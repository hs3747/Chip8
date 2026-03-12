library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_enable is
    generic (
        DIVISOR : integer := 100000000
    );
    Port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        tick_en : out std_logic
    );
end clock_enable;

architecture Behavioral of clock_enable is
    signal count : integer range 0 to DIVISOR - 1 := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            count   <= 0;
            tick_en <= '0';
        elsif rising_edge(clk) then
            if count = DIVISOR - 1 then
                count   <= 0;
                tick_en <= '1';
            else
                count   <= count + 1;
                tick_en <= '0';
            end if;
        end if;
    end process;
end Behavioral;