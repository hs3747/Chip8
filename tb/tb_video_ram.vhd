library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_video_ram is
end tb_video_ram;

architecture sim of tb_video_ram is
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal clear : std_logic := '0';
    signal write_en : std_logic := '0';
    signal write_x : std_logic_vector(5 downto 0) := "000000";
    signal write_y : std_logic_vector(4 downto 0) := "00000";
    signal write_pixel : std_logic := '0';
    signal read_x : std_logic_vector(5 downto 0) := "000000";
    signal read_y : std_logic_vector(4 downto 0) := "00000";
    signal read_pixel : std_logic;
begin
    clk <= not clk after 5 ns;

    uut : entity work.video_ram
        generic map (
            INIT_TEST_PATTERN => true
        )
        port map (
            clk         => clk,
            reset       => reset,
            clear       => clear,
            write_en    => write_en,
            write_x     => write_x,
            write_y     => write_y,
            write_pixel => write_pixel,
            read_x      => read_x,
            read_y      => read_y,
            read_pixel  => read_pixel
        );

    process
    begin
        reset <= '1';
        wait for 20 ns;

        read_x <= std_logic_vector(to_unsigned(0, 6));
        read_y <= std_logic_vector(to_unsigned(15, 5));
        wait for 1 ns;
        assert read_pixel = '1'
            report "left border failed"
            severity failure;

        read_x <= std_logic_vector(to_unsigned(63, 6));
        read_y <= std_logic_vector(to_unsigned(31, 5));
        wait for 1 ns;
        assert read_pixel = '1'
            report "corner failed"
            severity failure;

        read_x <= std_logic_vector(to_unsigned(10, 6));
        read_y <= std_logic_vector(to_unsigned(5, 5));
        wait for 1 ns;
        assert read_pixel = '1'
            report "first diagonal failed"
            severity failure;

        read_x <= std_logic_vector(to_unsigned(52, 6));
        read_y <= std_logic_vector(to_unsigned(5, 5));
        wait for 1 ns;
        assert read_pixel = '1'
            report "second diagonal failed"
            severity failure;

        reset <= '0';
        read_x <= std_logic_vector(to_unsigned(30, 6));
        read_y <= std_logic_vector(to_unsigned(10, 5));
        wait for 1 ns;
        assert read_pixel = '0'
            report "test pixel should be off"
            severity failure;

        write_x <= std_logic_vector(to_unsigned(30, 6));
        write_y <= std_logic_vector(to_unsigned(10, 5));
        write_pixel <= '1';
        write_en <= '1';
        wait until rising_edge(clk);
        write_en <= '0';
        wait for 1 ns;
        assert read_pixel = '1'
            report "write failed"
            severity failure;

        clear <= '1';
        wait until rising_edge(clk);
        clear <= '0';
        wait for 1 ns;
        assert read_pixel = '0'
            report "clear failed"
            severity failure;

        report "tb_video_ram passed" severity note;
        wait;
    end process;
end sim;