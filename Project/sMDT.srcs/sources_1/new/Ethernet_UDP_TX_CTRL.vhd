library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Ethernet_RX_CTRL is
    Port (
        CLK        : in  STD_LOGIC;                          -- Clock signal
        RESET      : in  STD_LOGIC;                          -- Reset signal
        ETH_RX_DV  : in  STD_LOGIC;                          -- Data valid signal from Ethernet PHY
        ETH_RXD    : in  STD_LOGIC_VECTOR(3 downto 0);       -- 4-bit Ethernet RX data lines
        DATA_READY : out STD_LOGIC;                          -- Indicates data is available
        DATA_OUT   : out STD_LOGIC_VECTOR(7 downto 0)        -- Received 8-bit data
    );
end Ethernet_RX_CTRL;

architecture Behavioral of Ethernet_RX_CTRL is

    type RX_STATE_TYPE is (IDLE, HEADER, CHECK_IP, RECEIVE, DONE);
    signal rxState       : RX_STATE_TYPE := IDLE;
    signal rxPacket      : STD_LOGIC_VECTOR(95 downto 0) := (others => '0'); -- Received packet buffer
    signal bitCounter    : integer range 0 to 95 := 0; -- Counter for bit assembly
    signal dataValid     : STD_LOGIC := '0';
    
    -- Constant for FPGA's static IP (192.168.1.50 -> C0A80132)
    constant FPGA_IP     : STD_LOGIC_VECTOR(31 downto 0) := x"C0A80132"; -- 192.168.1.50

begin

    process(CLK, RESET)
    begin
        if RESET = '1' then
            -- Reset all internal signals
            rxState <= IDLE;
            rxPacket <= (others => '0');
            bitCounter <= 0;
            dataValid <= '0';
        elsif rising_edge(CLK) then
            case rxState is
                when IDLE =>
                    dataValid <= '0'; -- Clear data ready signal
                    if ETH_RX_DV = '1' then
                        rxState <= HEADER; -- Move to reading header
                        bitCounter <= 0;
                        rxPacket <= (others => '0');
                    end if;

                when HEADER =>
                    -- Assemble first 96 bits (Ethernet + IP Header)
                    rxPacket(bitCounter + 3 downto bitCounter) <= ETH_RXD;
                    bitCounter <= bitCounter + 4;
                    
                    if bitCounter = 95 then
                        rxState <= CHECK_IP; -- Move to IP filtering step
                    end if;

                when CHECK_IP =>
                    -- Extract destination IP (bits 63-32)
                    if rxPacket(63 downto 32) = FPGA_IP then
                        rxState <= RECEIVE; -- Accept packet
                    else
                        rxState <= IDLE; -- Discard packet if IP doesn't match
                    end if;

                when RECEIVE =>
                    -- Assemble 8-bit data from 4-bit chunks
                    if bitCounter mod 8 = 0 then
                        rxPacket(7 downto 4) <= ETH_RXD; -- Load high nibble
                    else
                        rxPacket(3 downto 0) <= ETH_RXD; -- Load low nibble
                        rxState <= DONE; -- Full byte received
                    end if;
                    bitCounter <= bitCounter + 4;

                when DONE =>
                    dataValid <= '1'; -- Indicate data is ready
                    DATA_OUT <= rxPacket(7 downto 0); -- Output only relevant data
                    rxState <= IDLE; -- Return to IDLE state

                when others =>
                    rxState <= IDLE; -- Fallback in case of unexpected state
            end case;
        end if;
    end process;

    -- Output assignments
    DATA_READY <= dataValid;

end Behavioral;
