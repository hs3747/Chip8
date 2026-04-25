library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc_register is
    Port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        step_en   : in  std_logic;
        load_en   : in  std_logic;
        load_addr : in  std_logic_vector(11 downto 0);
        pc_out    : out std_logic_vector(11 downto 0)
    );
end pc_register;

architecture Behavioral of pc_register is
    signal pc : unsigned(11 downto 0) := to_unsigned(512, 12);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pc <= to_unsigned(512, 12);
        elsif rising_edge(clk) then
            if load_en = '1' then
                pc <= unsigned(load_addr);
            elsif step_en = '1' then
                pc <= pc + 2;
            end if;
        end if;
    end process;

    pc_out <= std_logic_vector(pc);
end Behavioral;
