library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc_register is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        tick_en    : in  std_logic;
        pc_next    : in  std_logic_vector(11 downto 0);
        pc_current : out std_logic_vector(11 downto 0)
    );
end pc_register;

architecture Behavioral of pc_register is
    signal pc_reg : std_logic_vector(11 downto 0) := x"200";
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= x"200";
        elsif rising_edge(clk) then
            if tick_en = '1' then
                pc_reg <= pc_next;
            end if;
        end if;
    end process;

    pc_current <= pc_reg;
end Behavioral;