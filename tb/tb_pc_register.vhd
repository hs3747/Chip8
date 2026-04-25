library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_pc_register is
end tb_pc_register;

architecture sim of tb_pc_register is
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal step_en : std_logic := '0';
    signal load_en : std_logic := '0';
    signal load_addr : std_logic_vector(11 downto 0) := x"000";
    signal pc_out : std_logic_vector(11 downto 0);
begin
    clk <= not clk after 5 ns;

    uut : entity work.pc_register
        port map (
            clk       => clk,
            reset     => reset,
            step_en   => step_en,
            load_en   => load_en,
            load_addr => load_addr,
            pc_out    => pc_out
        );

    process
    begin
        reset <= '1';
        wait for 20 ns;
        assert pc_out = x"200"
            report "PC reset failed"
            severity failure;

        reset <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;
        assert pc_out = x"200"
            report "PC moved when it should have stayed"
            severity failure;

        step_en <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        assert pc_out = x"202"
            report "PC did not step to 202"
            severity failure;

        wait until rising_edge(clk);
        wait for 1 ns;
        assert pc_out = x"204"
            report "PC did not step to 204"
            severity failure;

        step_en <= '0';
        load_addr <= x"300";
        load_en <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        assert pc_out = x"300"
            report "PC load failed"
            severity failure;

        load_en <= '0';
        step_en <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        assert pc_out = x"302"
            report "PC step after load failed"
            severity failure;

        reset <= '1';
        wait for 1 ns;
        assert pc_out = x"200"
            report "PC async reset failed"
            severity failure;

        report "tb passed" severity note;
        wait;
    end process;
end sim;