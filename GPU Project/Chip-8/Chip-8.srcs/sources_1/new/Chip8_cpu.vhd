library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Chip8_cpu is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        pc_out     : out std_logic_vector(11 downto 0)
    );
end Chip8_cpu;

architecture Structural of Chip8_cpu is
    signal tick_en_sig    : std_logic;
    signal pc_current_sig : std_logic_vector(11 downto 0);
    signal pc_next_sig    : std_logic_vector(11 downto 0);
begin
    clk_unit : entity work.clock_enable
        port map (
            clk     => clk,
            reset   => reset,
            tick_en => tick_en_sig
        );

    pc_next_unit : entity work.pc_next_logic
        port map (
            pc_current => pc_current_sig,
            pc_next    => pc_next_sig
        );

    pc_reg_unit : entity work.pc_register
        port map (
            clk        => clk,
            reset      => reset,
            tick_en    => tick_en_sig,
            pc_next    => pc_next_sig,
            pc_current => pc_current_sig
        );

    pc_out <= pc_current_sig;
end Structural;