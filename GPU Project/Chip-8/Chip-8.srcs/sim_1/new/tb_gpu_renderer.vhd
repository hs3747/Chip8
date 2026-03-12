library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_gpu_renderer is
end tb_gpu_renderer;

architecture sim of tb_gpu_renderer is
    signal video_on       : std_logic := '0';
    signal pixel_x        : std_logic_vector(9 downto 0) := (others => '0');
    signal pixel_y        : std_logic_vector(9 downto 0) := (others => '0');
    signal vga_r          : std_logic_vector(3 downto 0);
    signal vga_g          : std_logic_vector(3 downto 0);
    signal vga_b          : std_logic_vector(3 downto 0);
    signal pixel_on_debug : std_logic;
begin
    uut : entity work.gpu_renderer
        port map (
            video_on       => video_on,
            pixel_x        => pixel_x,
            pixel_y        => pixel_y,
            vga_r          => vga_r,
            vga_g          => vga_g,
            vga_b          => vga_b,
            pixel_on_debug => pixel_on_debug
        );

    stim_proc : process
    begin
        video_on <= '0';
        pixel_x  <= std_logic_vector(to_unsigned(100, 10));
        pixel_y  <= std_logic_vector(to_unsigned(130, 10));
        wait for 1 ns;
        assert vga_r = "0000" and vga_g = "0000" and vga_b = "0000"
            report "Output should be black when video_on = 0"
            severity failure;

        video_on <= '1';
        pixel_x  <= std_logic_vector(to_unsigned(100, 10));
        pixel_y  <= std_logic_vector(to_unsigned(50, 10));
        wait for 1 ns;
        assert vga_r = "0000" and vga_g = "0000" and vga_b = "0000"
            report "Output should be black above the Chip-8 display area"
            severity failure;

        video_on <= '1';
        pixel_x  <= std_logic_vector(to_unsigned(100, 10));
        pixel_y  <= std_logic_vector(to_unsigned(130, 10));
        wait for 1 ns;
        assert vga_r = "1111" and vga_g = "1111" and vga_b = "1111"
            report "Mapped ON pixel should be white"
            severity failure;
        assert pixel_on_debug = '1'
            report "pixel_on_debug should be 1 for ON pixel"
            severity failure;

        video_on <= '1';
        pixel_x  <= std_logic_vector(to_unsigned(300, 10));
        pixel_y  <= std_logic_vector(to_unsigned(180, 10));
        wait for 1 ns;
        assert vga_r = "0000" and vga_g = "0000" and vga_b = "0000"
            report "Mapped OFF pixel should be black"
            severity failure;
        assert pixel_on_debug = '0'
            report "pixel_on_debug should be 0 for OFF pixel"
            severity failure;

        report "tb_gpu_renderer passed" severity note;
        wait;
    end process;
end sim;