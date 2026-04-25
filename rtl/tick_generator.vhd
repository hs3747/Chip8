library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tick_generator is
    generic (
        DIVISOR : positive := 100000000
    );
    Port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        tick_en : out std_logic
    );
end tick_generator;

architecture Behavioral of tick_generator is
    signal cnt : natural range 0 to DIVISOR - 1 := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            cnt <= 0;
            tick_en <= '0';
        elsif rising_edge(clk) then
            if cnt = DIVISOR - 1 then
                cnt <= 0;
                tick_en <= '1';
            else
                cnt <= cnt + 1;
                tick_en <= '0';
            end if;
        end if;
    end process;
end Behavioral;