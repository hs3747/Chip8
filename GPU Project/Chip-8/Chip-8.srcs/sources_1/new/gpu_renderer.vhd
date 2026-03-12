library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gpu_renderer is
Port (
    video_on       : in  std_logic;
    pixel_x        : in  std_logic_vector(9 downto 0);
    pixel_y        : in  std_logic_vector(9 downto 0);
    vga_r          : out std_logic_vector(3 downto 0);
    vga_g          : out std_logic_vector(3 downto 0);
    vga_b          : out std_logic_vector(3 downto 0);
    pixel_on_debug : out std_logic
);
end gpu_renderer;

architecture Behavioral of gpu_renderer is
    signal chip_x_s    : std_logic_vector(5 downto 0);
    signal chip_y_s    : std_logic_vector(4 downto 0);
    signal pixel_on_s  : std_logic;
    signal chip_area_s : std_logic;
    signal x_int       : integer range 0 to 1023;
    signal y_int       : integer range 0 to 1023;
begin
    x_int <= to_integer(unsigned(pixel_x));
    y_int <= to_integer(unsigned(pixel_y));

    chip_area_s <= '1' when (video_on = '1' and y_int >= 80 and y_int < 400) else '0';

    chip_x_s <= std_logic_vector(to_unsigned(x_int / 10, 6)) when chip_area_s = '1' else (others => '0');
    chip_y_s <= std_logic_vector(to_unsigned((y_int - 80) / 10, 5)) when chip_area_s = '1' else (others => '0');

    ram_unit : entity work.vid_ram
        port map (
            chip_x   => chip_x_s,
            chip_y   => chip_y_s,
            pixel_on => pixel_on_s
        );

    process(chip_area_s, pixel_on_s)
    begin
        if chip_area_s = '1' and pixel_on_s = '1' then
            vga_r <= "1111";
            vga_g <= "1111";
            vga_b <= "1111";
        else
            vga_r <= "0000";
            vga_g <= "0000";
            vga_b <= "0000";
        end if;
    end process;

    pixel_on_debug <= pixel_on_s;
end Behavioral;