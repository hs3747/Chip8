library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_chip8_cpu is
end tb_chip8_cpu;

architecture sim of tb_chip8_cpu is
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal step_en : std_logic := '0';
    signal pc_out : std_logic_vector(11 downto 0);
    signal opcode_out : std_logic_vector(15 downto 0);
begin
    clk <= not clk after 5 ns;

    uut : entity work.chip8_cpu
        port map (
            clk        => clk,
            reset      => reset,
            step_en    => step_en,
            pc_out     => pc_out,
            opcode_out => opcode_out
        );

    process
    begin
        reset <= '1';
        wait for 20 ns;
        assert pc_out = x"200"
            report "CPU PC reset failed"
            severity failure;

        reset <= '0';
        step_en <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        assert pc_out = x"202"
            report "CPU PC step 1 failed"
            severity failure;

        wait until rising_edge(clk);
        wait for 1 ns;
        assert pc_out = x"204"
            report "CPU PC step 2 failed"
            severity failure;

        step_en <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;
        assert pc_out = x"204"
            report "CPU PC should have stayed"
            severity failure;

        assert opcode_out = x"0000"
            report "opcode should be 0000 in empty program memory"
            severity failure;

        report "tb_chip8_cpu passed" severity note;
        wait;
    end process;
end sim;
