library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_enable is
    Port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        tick_en : out std_logic
    );
end clock_enable;

architecture Behavioral of clock_enable is
    constant DIV_COUNT : unsigned(25 downto 0) := to_unsigned(49999999, 26);
    signal counter     : unsigned(25 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter  <= (others => '0');
            tick_en  <= '0';
        elsif rising_edge(clk) then
            if counter = DIV_COUNT then
                counter <= (others => '0');
                tick_en <= '1';
            else
                counter <= counter + 1;
                tick_en <= '0';
            end if;
        end if;
    end process;
end Behavioral;