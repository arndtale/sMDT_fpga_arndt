--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
--Date        : Mon Mar 31 13:52:09 2025
--Host        : DESKTOP-FCJ5MKD running 64-bit major release  (build 9200)
--Command     : generate_target system_wrapper.bd
--Design      : system_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity system_wrapper is
  port (
    CLK100MHZ : in STD_LOGIC;
    ck_a0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    ck_rst : in STD_LOGIC;
    ddr3_sdram_0_addr : out STD_LOGIC_VECTOR ( 13 downto 0 );
    ddr3_sdram_0_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
    ddr3_sdram_0_cas_n : out STD_LOGIC;
    ddr3_sdram_0_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_0_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_0_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_0_cs_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_0_dm : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr3_sdram_0_dq : inout STD_LOGIC_VECTOR ( 15 downto 0 );
    ddr3_sdram_0_dqs_n : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr3_sdram_0_dqs_p : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr3_sdram_0_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_0_ras_n : out STD_LOGIC;
    ddr3_sdram_0_reset_n : out STD_LOGIC;
    ddr3_sdram_0_we_n : out STD_LOGIC;
    reset : in STD_LOGIC;
    usb_uart_rxd : in STD_LOGIC;
    usb_uart_txd : out STD_LOGIC
  );
end system_wrapper;

architecture STRUCTURE of system_wrapper is
  component system is
  port (
    CLK100MHZ : in STD_LOGIC;
    ck_a0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    ck_rst : in STD_LOGIC;
    usb_uart_rxd : in STD_LOGIC;
    usb_uart_txd : out STD_LOGIC;
    ddr3_sdram_0_dq : inout STD_LOGIC_VECTOR ( 15 downto 0 );
    ddr3_sdram_0_dqs_p : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr3_sdram_0_dqs_n : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr3_sdram_0_addr : out STD_LOGIC_VECTOR ( 13 downto 0 );
    ddr3_sdram_0_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
    ddr3_sdram_0_ras_n : out STD_LOGIC;
    ddr3_sdram_0_cas_n : out STD_LOGIC;
    ddr3_sdram_0_we_n : out STD_LOGIC;
    ddr3_sdram_0_reset_n : out STD_LOGIC;
    ddr3_sdram_0_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_0_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_0_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_0_cs_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr3_sdram_0_dm : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr3_sdram_0_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    reset : in STD_LOGIC
  );
  end component system;
begin
system_i: component system
     port map (
      CLK100MHZ => CLK100MHZ,
      ck_a0(0) => ck_a0(0),
      ck_rst => ck_rst,
      ddr3_sdram_0_addr(13 downto 0) => ddr3_sdram_0_addr(13 downto 0),
      ddr3_sdram_0_ba(2 downto 0) => ddr3_sdram_0_ba(2 downto 0),
      ddr3_sdram_0_cas_n => ddr3_sdram_0_cas_n,
      ddr3_sdram_0_ck_n(0) => ddr3_sdram_0_ck_n(0),
      ddr3_sdram_0_ck_p(0) => ddr3_sdram_0_ck_p(0),
      ddr3_sdram_0_cke(0) => ddr3_sdram_0_cke(0),
      ddr3_sdram_0_cs_n(0) => ddr3_sdram_0_cs_n(0),
      ddr3_sdram_0_dm(1 downto 0) => ddr3_sdram_0_dm(1 downto 0),
      ddr3_sdram_0_dq(15 downto 0) => ddr3_sdram_0_dq(15 downto 0),
      ddr3_sdram_0_dqs_n(1 downto 0) => ddr3_sdram_0_dqs_n(1 downto 0),
      ddr3_sdram_0_dqs_p(1 downto 0) => ddr3_sdram_0_dqs_p(1 downto 0),
      ddr3_sdram_0_odt(0) => ddr3_sdram_0_odt(0),
      ddr3_sdram_0_ras_n => ddr3_sdram_0_ras_n,
      ddr3_sdram_0_reset_n => ddr3_sdram_0_reset_n,
      ddr3_sdram_0_we_n => ddr3_sdram_0_we_n,
      reset => reset,
      usb_uart_rxd => usb_uart_rxd,
      usb_uart_txd => usb_uart_txd
    );
end STRUCTURE;
