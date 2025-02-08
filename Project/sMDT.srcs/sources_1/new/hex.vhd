----------------------------------------------------------------------------------
-- Company: Michigan State University
-- Engineer: 
--
-- Create Date: 2024/11/26
-- Design Name: Top - Behavioral
-- Module Name: Top
-- Project Name: Ethernet-Based Muon Detector System
-- Target Devices: Arty-A7-100T FPGA (xc7a100ticsg324-1L)
-- Tool Versions: Vivado 2024.1
-- Description:
--     Top-level module for Ethernet-based muon detector system.
--     Handles interfacing with scintillators and processes signals for UDP transmission.
--
-- Dependencies:
--     - counter.vhd: Signal event generation.
--     - rate_generator.vhd: Controls readout rate.
--     - Ethernet_UDP_TX_CTRL.vhd: UDP transmission over Ethernet.
--
-- Revision:
-- Revision 1.03 - Removed RX functionality.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top is
    generic(
        DVSR : integer := 4;
        DVSR_BIT : integer := 10
    );
    Port (
        clk       : in std_logic;
        reset     : in std_logic;
        JA        : inout std_logic_vector(1 downto 0);
        eth_tx_en : out std_logic;
        eth_txd   : out std_logic_vector(3 downto 0)
    );
end Top;

architecture Behavioral of Top is
    -- Internal Signals
    signal udpData       : std_logic_vector(7 downto 0) := "00000000"; -- Data to be transmitted
    signal UDP_SEND      : std_logic := '0'; -- Signal to trigger UDP transmission
    signal udpReady      : std_logic := '0'; -- Ready signal from Ethernet module
    signal counter_out   : std_logic_vector(7 downto 0) := "00000000"; -- Counter output

    -- Component Declarations
    component Ethernet_UDP_TX_CTRL 
    Port(
        UDP_SEND  : in std_logic;
        DATA      : in std_logic_vector(7 downto 0);
        CLK       : in std_logic;
        READY     : out std_logic;
        ETH_TX_EN : out std_logic;
        ETH_TXD   : out std_logic_vector(3 downto 0)
    );
    end component;

    component counter is
        Port (
            clk         : in std_logic;
            reset       : in std_logic;
            reach_cycle : out std_logic;
            JA          : inout std_logic_vector(1 downto 0);
            counter_out : out std_logic_vector(7 downto 0)
        );
    end component;

    component rate_generator is
        Port (
            clk        : in std_logic;
            reset      : in std_logic;
            input_reg  : in std_logic_vector(7 downto 0);
            m_tick     : out std_logic;
            output_reg : out std_logic_vector(7 downto 0)
        );
    end component;

begin
    -- Simulated toggling of JA signals
    process(clk, reset)
    begin
        if reset = '1' then
            JA <= "00"; -- Reset state
        elsif rising_edge(clk) then
            case JA is
                when "00" => JA <= "01"; -- Simulate Event 1
                when "01" => JA <= "10"; -- Simulate Event 2
                when "10" => JA <= "11"; -- Simulate Coincidence
                when "11" => JA <= "00"; -- Reset to no event
                when others => JA <= "00"; -- Default to reset state
            end case;
        end if;
    end process;

    -- Signal generation unit (Counter for JA toggles)
    signal_generate_unit: entity work.counter
    port map(
        clk => clk, 
        reset => reset, 
        reach_cycle => UDP_SEND, -- Trigger for UDP_SEND
        JA => JA, 
        counter_out => counter_out
    ); 

    -- Rate control unit for readout timing
    rate_generator_unit: entity work.rate_generator
    port map(
        clk => clk, 
        reset => reset, 
        input_reg => counter_out,
        m_tick => UDP_SEND, -- Sole source of UDP_SEND
        output_reg => udpData
    );

    -- Ethernet UDP Transmission Unit
    Inst_Ethernet_UDP_TX_CTRL: Ethernet_UDP_TX_CTRL
    port map(
        UDP_SEND => UDP_SEND, 
        DATA => udpData, 
        CLK => clk, 
        READY => udpReady, 
        ETH_TX_EN => eth_tx_en, 
        ETH_TXD => eth_txd
    );

end Behavioral;
