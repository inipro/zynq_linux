//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.4.2 (lin64) Build 1494164 Fri Feb 26 04:18:54 MST 2016
//Date        : Fri Nov 25 09:51:23 2016
//Host        : ThinkPad-E550 running 64-bit Ubuntu 16.04.1 LTS
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    iic_0_scl_io,
    iic_0_sda_io,
    spi_pl_io0_io,
    spi_pl_io1_io,
    spi_pl_sck_io,
    spi_pl_ss_io,
    spi_ps_io0_io,
    spi_ps_io1_io,
    spi_ps_sck_io,
    //spi_ps_ss1_o,
    //spi_ps_ss2_o,
    spi_ps_ss_io);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  inout iic_0_scl_io;
  inout iic_0_sda_io;
  inout spi_pl_io0_io;
  inout spi_pl_io1_io;
  inout spi_pl_sck_io;
  inout [0:0]spi_pl_ss_io;
  inout spi_ps_io0_io;
  inout spi_ps_io1_io;
  inout spi_ps_sck_io;
  //output spi_ps_ss1_o;
  //output spi_ps_ss2_o;
  inout spi_ps_ss_io;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire iic_0_scl_i;
  wire iic_0_scl_io;
  wire iic_0_scl_o;
  wire iic_0_scl_t;
  wire iic_0_sda_i;
  wire iic_0_sda_io;
  wire iic_0_sda_o;
  wire iic_0_sda_t;
  wire spi_pl_io0_i;
  wire spi_pl_io0_io;
  wire spi_pl_io0_o;
  wire spi_pl_io0_t;
  wire spi_pl_io1_i;
  wire spi_pl_io1_io;
  wire spi_pl_io1_o;
  wire spi_pl_io1_t;
  wire spi_pl_sck_i;
  wire spi_pl_sck_io;
  wire spi_pl_sck_o;
  wire spi_pl_sck_t;
  wire [0:0]spi_pl_ss_i_0;
  wire [0:0]spi_pl_ss_io_0;
  wire [0:0]spi_pl_ss_o_0;
  wire spi_pl_ss_t;
  wire spi_ps_io0_i;
  wire spi_ps_io0_io;
  wire spi_ps_io0_o;
  wire spi_ps_io0_t;
  wire spi_ps_io1_i;
  wire spi_ps_io1_io;
  wire spi_ps_io1_o;
  wire spi_ps_io1_t;
  wire spi_ps_sck_i;
  wire spi_ps_sck_io;
  wire spi_ps_sck_o;
  wire spi_ps_sck_t;
  //wire spi_ps_ss1_o;
  //wire spi_ps_ss2_o;
  wire spi_ps_ss_i;
  wire spi_ps_ss_io;
  wire spi_ps_ss_o;
  wire spi_ps_ss_t;

  IOBUF iic_0_scl_iobuf
       (.I(iic_0_scl_o),
        .IO(iic_0_scl_io),
        .O(iic_0_scl_i),
        .T(iic_0_scl_t));
  IOBUF iic_0_sda_iobuf
       (.I(iic_0_sda_o),
        .IO(iic_0_sda_io),
        .O(iic_0_sda_i),
        .T(iic_0_sda_t));
  IOBUF spi_pl_io0_iobuf
       (.I(spi_pl_io0_o),
        .IO(spi_pl_io0_io),
        .O(spi_pl_io0_i),
        .T(spi_pl_io0_t));
  IOBUF spi_pl_io1_iobuf
       (.I(spi_pl_io1_o),
        .IO(spi_pl_io1_io),
        .O(spi_pl_io1_i),
        .T(spi_pl_io1_t));
  IOBUF spi_pl_sck_iobuf
       (.I(spi_pl_sck_o),
        .IO(spi_pl_sck_io),
        .O(spi_pl_sck_i),
        .T(spi_pl_sck_t));
  IOBUF spi_pl_ss_iobuf_0
       (.I(spi_pl_ss_o_0),
        .IO(spi_pl_ss_io[0]),
        .O(spi_pl_ss_i_0),
        .T(spi_pl_ss_t));
  IOBUF spi_ps_io0_iobuf
       (.I(spi_ps_io0_o),
        .IO(spi_ps_io0_io),
        .O(spi_ps_io0_i),
        .T(spi_ps_io0_t));
  IOBUF spi_ps_io1_iobuf
       (.I(spi_ps_io1_o),
        .IO(spi_ps_io1_io),
        .O(spi_ps_io1_i),
        .T(spi_ps_io1_t));
  IOBUF spi_ps_sck_iobuf
       (.I(spi_ps_sck_o),
        .IO(spi_ps_sck_io),
        .O(spi_ps_sck_i),
        .T(spi_ps_sck_t));
  IOBUF spi_ps_ss_iobuf
       (.I(spi_ps_ss_o),
        .IO(spi_ps_ss_io),
        .O(spi_ps_ss_i),
        .T(spi_ps_ss_t));
  system system_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .IIC_0_scl_i(iic_0_scl_i),
        .IIC_0_scl_o(iic_0_scl_o),
        .IIC_0_scl_t(iic_0_scl_t),
        .IIC_0_sda_i(iic_0_sda_i),
        .IIC_0_sda_o(iic_0_sda_o),
        .IIC_0_sda_t(iic_0_sda_t),
        .spi_pl_io0_i(spi_pl_io0_i),
        .spi_pl_io0_o(spi_pl_io0_o),
        .spi_pl_io0_t(spi_pl_io0_t),
        .spi_pl_io1_i(spi_pl_io1_i),
        .spi_pl_io1_o(spi_pl_io1_o),
        .spi_pl_io1_t(spi_pl_io1_t),
        .spi_pl_sck_i(spi_pl_sck_i),
        .spi_pl_sck_o(spi_pl_sck_o),
        .spi_pl_sck_t(spi_pl_sck_t),
        .spi_pl_ss_i(spi_pl_ss_i_0),
        .spi_pl_ss_o(spi_pl_ss_o_0),
        .spi_pl_ss_t(spi_pl_ss_t),
        .spi_ps_io0_i(spi_ps_io0_i),
        .spi_ps_io0_o(spi_ps_io0_o),
        .spi_ps_io0_t(spi_ps_io0_t),
        .spi_ps_io1_i(spi_ps_io1_i),
        .spi_ps_io1_o(spi_ps_io1_o),
        .spi_ps_io1_t(spi_ps_io1_t),
        .spi_ps_sck_i(spi_ps_sck_i),
        .spi_ps_sck_o(spi_ps_sck_o),
        .spi_ps_sck_t(spi_ps_sck_t),
        //.spi_ps_ss1_o(spi_ps_ss1_o),
        //.spi_ps_ss2_o(spi_ps_ss2_o),
        .spi_ps_ss_i(spi_ps_ss_i),
        .spi_ps_ss_o(spi_ps_ss_o),
        .spi_ps_ss_t(spi_ps_ss_t));
endmodule
