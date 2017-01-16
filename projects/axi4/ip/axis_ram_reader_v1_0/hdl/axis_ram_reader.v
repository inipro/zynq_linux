
`timescale 1 ns / 1 ps

module axis_ram_reader #
(
  parameter integer ADDR_WIDTH = 20,
  //parameter integer AXI_ID_WIDTH = 6,
  parameter integer AXI_ADDR_WIDTH = 32,
  parameter integer AXI_DATA_WIDTH = 64,
  parameter integer AXIS_TDATA_WIDTH = 64
)
(
  // System signals
  input  wire							aclk,
  input  wire							aresetn,

  input  wire [AXI_ADDR_WIDTH-1:0]		cfg_data,
  output wire [ADDR_WIDTH-1:0]			sts_data,

  // Master side
  //output wire [AXI_ID_WIDTH-1:0]		m_axi_arid,		// AXI master: Read address ID
  output wire [AXI_ADDR_WIDTH-1:0]		m_axi_araddr,	// AXI master: Read address
  output wire [3:0]						m_axi_arlen,	// AXI master: Read burst length
  output wire [2:0]						m_axi_arsize,	// AXI master: Read burst size
  output wire [1:0]						m_axi_arburst,	// AXI master: Read burst type
  output wire [3:0]						m_axi_arcache,	// AXI master: Read cache type
  output wire							m_axi_arvalid,	// AXI master: Read address valid
  input  wire							m_axi_arready,	// AXI master: Read address ready

  input  wire [AXI_DATA_WIDTH-1:0]		m_axi_rdata,	// AXI master: Read data
  input  wire							m_axi_rlast,	// AXI master: Read last
  input  wire							m_axi_rvalid,	// AXI master: Read valid
  output wire							m_axi_rready,	// AXI master: Read ready

  input  wire							m_axis_tready,
  output wire [AXIS_TDATA_WIDTH-1:0]	m_axis_tdata,
  output wire							m_axis_tvalid
);

  function integer clogb2 (input integer value);
    for(clogb2 = 0; value > 0; clogb2 = clogb2 + 1) value = value >> 1;
  endfunction

  localparam integer ADDR_SIZE = clogb2((AXI_DATA_WIDTH/8)-1);

  reg int_arvalid_reg, int_arvalid_next;
  reg int_rready_reg, int_rready_next;
  reg [ADDR_WIDTH-1:0] int_addr_reg, int_addr_next;
  //reg [AXI_ID_WIDTH-1:0] int_arid_reg, int_arid_next;

  wire int_full_wire, int_empty_wire, int_rden_wire;
  wire int_tvalid_wire;
  wire [71:0] int_rdata_wire;

  assign int_rden_wire = m_axis_tready & ~int_empty_wire;

  FIFO36E1 #(
    .FIRST_WORD_FALL_THROUGH("TRUE"),
	.ALMOST_FULL_OFFSET(13'h1f1),
	.DATA_WIDTH(72),
	.FIFO_MODE("FIFO36_72")
  ) fifo_0 (
	.ALMOSTFULL(int_full_wire),
	.EMPTY(int_empty_wire),
	.RST(~aresetn),
	.WRCLK(aclk),
	.WREN(int_rready_reg & m_axi_rvalid), 
	.DI({{(72-AXI_DATA_WIDTH){1'b0}}, m_axi_rdata}),
	.RDCLK(aclk),
	.RDEN(int_rden_wire),
	.DO(int_rdata_wire)
  );

  always @(posedge aclk)
  begin
  	if (~aresetn)
	begin
	  int_arvalid_reg <= 1'b0;
      int_rready_reg <= 1'b0;
	  int_addr_reg <= {(ADDR_WIDTH){1'b0}};
      //int_arid_reg <= {(AXI_ID_WIDTH){1'b0}};
	end
	else
	begin
	  int_arvalid_reg <= int_arvalid_next;
	  int_rready_reg <= int_rready_next;
	  int_addr_reg <= int_addr_next;
	  //int_arid_reg <= int_arid_next;
	end
  end

  always @*
  begin
    int_arvalid_next = int_arvalid_reg;
	int_rready_next = int_rready_reg;
	int_addr_next = int_addr_reg;
	//int_arid_next = int_arid_reg;

	if (~int_full_wire & ~int_arvalid_reg & ~int_rready_reg)
	begin
	  int_arvalid_next = 1'b1;
	  int_rready_next = 1'b1;
	end

	if (m_axi_arready & int_arvalid_reg)
	begin
	  int_arvalid_next = 1'b0;
	end

	if (int_rready_reg & m_axi_rlast)
	begin
	  int_addr_next = int_addr_reg + 5'd16;
	  //int_arid_next = int_arid_reg + 1'b1;
	  if (int_full_wire)
		int_rready_next = 1'b0;
	  else	
	  begin
	    int_arvalid_next = 1'b1;
	  end
	end
  end

  assign sts_data = int_addr_reg;

  //assign m_axi_arid = int_arid_reg;
  assign m_axi_araddr = cfg_data + {int_addr_reg, {(ADDR_SIZE){1'b0}}};
  assign m_axi_arlen = 4'd15;
  assign m_axi_arsize = ADDR_SIZE;
  assign m_axi_arburst = 2'b01;
  assign m_axi_arcache = 4'b0011;
  assign m_axi_arvalid = int_arvalid_reg;
  assign m_axi_rready = int_rready_reg;
  assign m_axis_tvalid = int_rden_wire;
  assign m_axis_tdata = int_rdata_wire[AXI_DATA_WIDTH-1:0];

endmodule
