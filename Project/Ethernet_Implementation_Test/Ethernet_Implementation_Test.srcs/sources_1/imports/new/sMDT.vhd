----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2023/07/26 20:20:51
-- Design Name: 
-- Module Name: sMDT - Coincidence
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sMDT is
Port (
    clk     : in  std_logic;
    reset   : in  std_logic;
    sw      : in  std_logic;
    an      : out std_logic_vector (3 downto 0);
    sseg    : out std_logic_vector (7 downto 0)
);
end sMDT;

architecture Behavioral of sMDT is
    type t_digital is array (3 downto 0) of integer range 0 to 9;
    signal digit : t_digital := (others => 0);
    signal value : integer range 0 to 9999 := 0;
    signal counter : integer range 0 to 100000 := 0;
    signal counter_clk : std_logic := '0';
    signal an_number : integer range 0 to 3 := 0;
begin
    -- Process for generating counter clock and resetting value
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            value <= 0;
            counter_clk <= '0';
        elsif rising_edge(clk) then
            counter <= counter + 1;
            if counter >= 10000 then
                counter <= 0;
                counter_clk <= not counter_clk;
            end if;

            if sw = '1' then
                value <= 0;
            end if;
        end if;
    end process;

    -- Process for updating value and managing digit display
    process(counter_clk)
    begin
        if rising_edge(counter_clk) then
            value <= value + 1;
            digit(0) <= value / 1000;
            digit(1) <= (value mod 1000) / 100;
            digit(2) <= (value mod 100) / 10;
            digit(3) <= value mod 10;
            an_number <= an_number + 1;

            if an_number >= 4 then
                an_number <= 0;
            end if;
        end if;
    end process;

    -- Process for encoding digit to seven-segment display
    ENCODER_PROC : process(digit, an_number)
    begin
        case digit(an_number) is
            when 0 => sseg <= "0111111";
            when 1 => sseg <= "0000110";
            when 2 => sseg <= "1011011";
            when 3 => sseg <= "1001111";
            when 4 => sseg <= "1100110";
            when 5 => sseg <= "1101101";
            when 6 => sseg <= "1111101";
            when 7 => sseg <= "0000111";
            when 8 => sseg <= "1111111";
            when 9 => sseg <= "1101111";
            when others => sseg <= "0000000";
        end case;
    end process;

    -- Process for activating the correct anode
    process(an_number)
    begin
        case an_number is
            when 0 => an <= "1110";
            when 1 => an <= "1101";
            when 2 => an <= "1011";
            when 3 => an <= "0111";
            when others => an <= "1111";
        end case;
    end process;
end Behavioral;
