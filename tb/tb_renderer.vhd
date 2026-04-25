library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_renderer is
end tb_renderer;

architecture sim of tb_renderer is
    signal video_on : std_logic := '0';
    signal pixel_x : std_logic_vector(9 downto 0) := (others => '0');
    signal pixel_y : std_logic_vector(9 downto 0) := (others => '0');
    signal frame_pixel : std_logic := '0';
    signal frame_x : std_logic_vector(5 downto 0);
    signal frame_y : std_logic_vector(4 downto 0);
    signal vga_r : std_logic_vector(3 downto 0);
    signal vga_g : std_logic_vector(3 downto 0);
    signal vga_b : std_logic_vector(3 downto 0);
    signal pixel_on_debug : std_logic;
begin
    uut : entity work.renderer
        port map (
            video_on       => video_on,
            pixel_x        => pixel_x,
            pixel_y        => pixel_y,
            frame_pixel    => frame_pixel,
            frame_x        => frame_x,
            frame_y        => frame_y,
            vga_r          => vga_r,
            vga_g          => vga_g,
            vga_b          => vga_b,
            pixel_on_debug => pixel_on_debug
        );

    process
    begin
        video_on <= '0';
        frame_pixel <= '1';
        pixel_x <= std_logic_vector(to_unsigned(100, 10));
        pixel_y <= std_logic_vector(to_unsigned(130, 10));
        wait for 1 ns;
        assert vga_r = "0000" and vga_g = "0000" and vga_b = "0000"
            report "color should be black when video_on is low"
            severity failure;

        video_on <= '1';
        pixel_x <= std_logic_vector(to_unsigned(100, 10));
        pixel_y <= std_logic_vector(to_unsigned(50, 10));
        wait for 1 ns;
        assert vga_r = "0000" and vga_g = "0000" and vga_b = "0000"
            report "color should be black above display"
            severity failure;
        assert pixel_on_debug = '0'
            report "debug should be low outside display"
            severity failure;

        video_on <= '1';
        frame_pixel <= '1';
        pixel_x <= std_logic_vector(to_unsigned(100, 10));
        pixel_y <= std_logic_vector(to_unsigned(130, 10));
        wait for 1 ns;
        assert frame_x = std_logic_vector(to_unsigned(10, 6))
            report "x map failed"
            severity failure;
        assert frame_y = std_logic_vector(to_unsigned(5, 5))
            report "y map failed"
            severity failure;
        assert vga_r = "1111" and vga_g = "1111" and vga_b = "1111"
            report "on pixel should be white"
            severity failure;
        assert pixel_on_debug = '1'
            report "debug should be high"
            severity failure;

        frame_pixel <= '0';
        pixel_x <= std_logic_vector(to_unsigned(300, 10));
        pixel_y <= std_logic_vector(to_unsigned(180, 10));
        wait for 1 ns;
        assert frame_x = std_logic_vector(to_unsigned(30, 6))
            report "x map 2 failed"
            severity failure;
        assert frame_y = std_logic_vector(to_unsigned(10, 5))
            report "y map 2 failed"
            severity failure;
        assert vga_r = "0000" and vga_g = "0000" and vga_b = "0000"
            report "off pixel should be black"
            severity failure;
        assert pixel_on_debug = '0'
            report "debug should be low for off pixel"
            severity failure;

        frame_pixel <= '1';
        pixel_x <= std_logic_vector(to_unsigned(639, 10));
        pixel_y <= std_logic_vector(to_unsigned(399, 10));
        wait for 1 ns;
        assert frame_x = std_logic_vector(to_unsigned(63, 6))
            report "right edge x failed"
            severity failure;
        assert frame_y = std_logic_vector(to_unsigned(31, 5))
            report "bottom edge y failed"
            severity failure;

        report "tb_renderer passed" severity note;
        wait;
    end process;
end sim;