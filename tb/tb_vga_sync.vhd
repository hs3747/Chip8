library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_vga_sync is
end tb_vga_sync;

architecture sim of tb_vga_sync is
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal pixel_tick : std_logic := '1';
    signal hsync : std_logic;
    signal vsync : std_logic;
    signal video_on : std_logic;
    signal pixel_x : std_logic_vector(9 downto 0);
    signal pixel_y : std_logic_vector(9 downto 0);
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

    process
        procedure ticks(n : natural) is
        begin
            for i in 1 to n loop
                wait until rising_edge(clk);
            end loop;
            wait for 1 ns;
        end procedure;
    begin
        reset <= '1';
        wait for 20 ns;
        assert unsigned(pixel_x) = 0
            report "x reset failed"
            severity failure;
        assert unsigned(pixel_y) = 0
            report "y reset failed"
            severity failure;

        reset <= '0';
        wait for 1 ns;
        assert video_on = '1'
            report "video_on should start high"
            severity failure;

        ticks(640);
        assert unsigned(pixel_x) = 640
            report "x should be 640"
            severity failure;
        assert unsigned(pixel_y) = 0
            report "y should still be 0"
            severity failure;
        assert video_on = '0'
            report "video_on should be low after visible x"
            severity failure;

        ticks(16);
        assert unsigned(pixel_x) = 656
            report "x should be 656"
            severity failure;
        assert hsync = '0'
            report "hsync should be low"
            severity failure;

        ticks(96);
        assert unsigned(pixel_x) = 752
            report "x should be 752"
            severity failure;
        assert hsync = '1'
            report "hsync should be high again"
            severity failure;

        ticks(48);
        assert unsigned(pixel_x) = 0
            report "x did not wrap"
            severity failure;
        assert unsigned(pixel_y) = 1
            report "y did not move to next line"
            severity failure;

        ticks(489 * 800);
        assert unsigned(pixel_x) = 0
            report "x should be 0 at line 490"
            severity failure;
        assert unsigned(pixel_y) = 490
            report "y should be 490"
            severity failure;
        assert vsync = '0'
            report "vsync should be low"
            severity failure;

        ticks(2 * 800);
        assert unsigned(pixel_y) = 492
            report "y should be 492"
            severity failure;
        assert vsync = '1'
            report "vsync should be high again"
            severity failure;

        report "tb_vga_sync passed" severity note;
        wait;
    end process;
end sim;