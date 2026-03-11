library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Entity is
    Port (
        CLK100MHZ : in  std_logic;
        reset     : in  std_logic;
        LED       : out std_logic_vector(15 downto 0)
    );
end Top_Entity;

architecture Structural of Top_Entity is
    signal pc_sig : std_logic_vector(11 downto 0);
begin
    cpu_unit : entity work.Chip8_cpu
        port map (
            clk    => CLK100MHZ,
            reset  => reset,
            pc_out => pc_sig
        );

    LED(7 downto 0)   <= pc_sig(9 downto 2);
    LED(15 downto 8)  <= (others => '0');
end Structural;