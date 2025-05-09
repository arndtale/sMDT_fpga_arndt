----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2023 14:57:42
-- Design Name: 
-- Module Name: Counter - Behavioral
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

entity rate_generator is
    Port 
    ( clk, reset : in std_logic;
      input_reg : in std_logic_vector(7 downto 0);
      m_tick : out std_logic;
      output_reg : out std_logic_vector(7 downto 0)
    );
end rate_generator;

architecture arch of rate_generator is
    signal counter_idle: integer := 0;
    signal counter_data: integer := 0;

    constant DATA_LEN : natural := 10; -- the data bus will always be 10 bits (8 data bits and a start and stop bit)
    type readout_states is (DATA, IDLE);
    signal readout_state : readout_states := IDLE;
begin
    next_readout_state_process : process(clk, reset)
    begin
        if reset = '1' then -- is reset is logic high, all signals are set to logic low
            counter_idle <= 0;
            counter_data <= 0;
            m_tick <= '0';
            output_reg <= (others => '0');
        elsif rising_edge(clk) then
            counter_idle <= counter_idle + 1;

            if readout_state = IDLE then
                if counter_idle = 100000000 then
                    readout_state <= DATA; -- Transition to DATA state
                    output_reg <= input_reg; -- Load input_reg into output_reg
                    m_tick <= '1'; -- Set m_tick high
                    counter_idle <= 0;
                end if;
            elsif readout_state = DATA then
                counter_data <= counter_data + 1;
                if counter_data = DATA_LEN then
                    m_tick <= '0'; -- Reset m_tick
                    counter_data <= 0;
                    readout_state <= IDLE; -- Transition back to IDLE state
                end if;
            end if;
        end if;
    end process;
end arch;
