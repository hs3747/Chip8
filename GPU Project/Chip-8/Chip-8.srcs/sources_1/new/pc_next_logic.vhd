library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc_next_logic is
    Port (
        pc_current : in  std_logic_vector(11 downto 0);
        pc_next    : out std_logic_vector(11 downto 0)
    );
end pc_next_logic;

architecture Behavioral of pc_next_logic is
begin
    pc_next <= std_logic_vector(unsigned(pc_current) + 2);
end Behavioral;