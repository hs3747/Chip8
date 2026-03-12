library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_vga_sync is
end tb_vga_sync;

architecture sim of tb_vga_sync is
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal pixel_tick : std_logic := '1';
    signal hsync      : std_logic;
    signal vsync      : std_logic;
    signal video_on   : std_logic;
    signal pixel_x    : std_logic_vector(9 downto 0);
    signal pixel_y    : std_logic_vector(9 downto 0);
begin
    clk <= not clk after 5 ns;

    uut : entity work.vga_sync
        port map (
            clk        => clk,
            reset      => reset,
            pixel_tick => pixel_tick,
            hsync      => hsync,
            vsync      => vsync,
            video_on   => video_on,
            pixel_x    => pixel_x,
            pixel_y    => pixel_y
        );

    stim_proc : process
        procedure tick_n(n : natural) is
        begin
            for i in 1 to n loop
                wait until rising_edge(clk);
            end loop;
            wait for 1 ns;
        end procedure;
    begin
        reset <= '1';
        wait for 20 ns;
        assert unsigned(pixel_x) = to_unsigned(0, 10)
            report "pixel_x should be 0 during reset"
            severity failure;
        assert unsigned(pixel_y) = to_unsigned(0, 10)
            report "pixel_y should be 0 during reset"
            severity failure;

        reset <= '0';
        wait for 1 ns;
        assert video_on = '1'
            report "video_on should start high at (0,0)"
            severity failure;

        tick_n(640);
        assert unsigned(pixel_x) = to_unsigned(640, 10)
            report "pixel_x should be 640 after 640 ticks"
            severity failure;
        assert unsigned(pixel_y) = to_unsigned(0, 10)
            report "pixel_y should still be 0"
            severity failure;
        assert video_on = '0'
            report "video_on should be low outside visible horizontal area"
            severity failure;

        tick_n(16);
        assert unsigned(pixel_x) = to_unsigned(656, 10)
            report "pixel_x should be 656 at hsync start"
            severity failure;
        assert hsync = '0'
            report "hsync should be low from x=656"
            severity failure;

        tick_n(96);
        assert unsigned(pixel_x) = to_unsigned(752, 10)
            report "pixel_x should be 752 at hsync end"
            severity failure;
        assert hsync = '1'
            report "hsync should return high at x=752"
            severity failure;

        tick_n(48);
        assert unsigned(pixel_x) = to_unsigned(0, 10)
            report "pixel_x should wrap to 0 at end of line"
            severity failure;
        assert unsigned(pixel_y) = to_unsigned(1, 10)
            report "pixel_y should increment to 1 after one full line"
            severity failure;

        tick_n(489 * 800);
        assert unsigned(pixel_x) = to_unsigned(0, 10)
            report "pixel_x should be 0 at start of line 490"
            severity failure;
        assert unsigned(pixel_y) = to_unsigned(490, 10)
            report "pixel_y should be 490 at vsync start"
            severity failure;
        assert vsync = '0'
            report "vsync should be low at y=490"
            severity failure;

        tick_n(2 * 800);
        assert unsigned(pixel_y) = to_unsigned(492, 10)
            report "pixel_y should be 492 after vsync pulse"
            severity failure;
        assert vsync = '1'
            report "vsync should return high at y=492"
            severity failure;

        report "tb_vga_sync passed" severity note;
        wait;
    end process;
end sim;