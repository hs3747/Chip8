library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_pc_path is
end tb_pc_path;

architecture sim of tb_pc_path is
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal tick_en    : std_logic := '0';
    signal pc_current : std_logic_vector(11 downto 0);
    signal pc_next    : std_logic_vector(11 downto 0);
begin
    clk <= not clk after 5 ns;

    uut_next : entity work.pc_next_logic
        port map (
            pc_current => pc_current,
            pc_next    => pc_next
        );

    uut_reg : entity work.pc_register
        port map (
            clk        => clk,
            reset      => reset,
            tick_en    => tick_en,
            pc_next    => pc_next,
            pc_current => pc_current
        );

    stim_proc : process
    begin
        reset <= '1';
        tick_en <= '0';
        wait for 20 ns;
        assert pc_current = x"200"
            report "PC did not reset to 0x200"
            severity failure;

        reset <= '0';
        wait for 10 ns;
        assert pc_current = x"200"
            report "PC changed unexpectedly after reset release"
            severity failure;

        tick_en <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        assert pc_current = x"202"
            report "PC did not increment to 0x202"
            severity failure;

        wait until rising_edge(clk);
        wait for 1 ns;
        assert pc_current = x"204"
            report "PC did not increment to 0x204"
            severity failure;

        tick_en <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;
        assert pc_current = x"204"
            report "PC changed even though tick_en was 0"
            severity failure;

        reset <= '1';
        wait for 1 ns;
        assert pc_current = x"200"
            report "PC did not return to 0x200 on reset"
            severity failure;

        report "tb_pc_path passed" severity note;
        wait;
    end process;
end sim;