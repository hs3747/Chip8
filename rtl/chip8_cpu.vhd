library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity chip8_cpu is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        step_en    : in  std_logic;
        pc_out     : out std_logic_vector(11 downto 0);
        opcode_out : out std_logic_vector(15 downto 0)
    );
end chip8_cpu;

architecture Structural of chip8_cpu is
    signal pc_sig : std_logic_vector(11 downto 0);
begin
    pc0 : entity work.pc_register
        port map (
            clk       => clk,
            reset     => reset,
            step_en   => step_en,
            load_en   => '0',
            load_addr => x"000",
            pc_out    => pc_sig
        );

    mem0 : entity work.chip8_memory
        port map (
            clk         => clk,
            write_en    => '0',
            addr        => pc_sig,
            write_data  => x"00",
            read_data   => open,
            opcode_addr => pc_sig,
            opcode_out  => opcode_out
        );

    pc_out <= pc_sig;
end Structural;