library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity renderer is
    Port (
        video_on       : in  std_logic;
        pixel_x        : in  std_logic_vector(9 downto 0);
        pixel_y        : in  std_logic_vector(9 downto 0);
        frame_pixel    : in  std_logic;
        frame_x        : out std_logic_vector(5 downto 0);
        frame_y        : out std_logic_vector(4 downto 0);
        vga_r          : out std_logic_vector(3 downto 0);
        vga_g          : out std_logic_vector(3 downto 0);
        vga_b          : out std_logic_vector(3 downto 0);
        pixel_on_debug : out std_logic
    );
end renderer;

architecture Behavioral of renderer is
begin
    process(video_on, pixel_x, pixel_y, frame_pixel)
        variable x : integer range 0 to 1023;
        variable y : integer range 0 to 1023;
        variable sx : integer range 0 to 63;
        variable sy : integer range 0 to 31;
    begin
        x := to_integer(unsigned(pixel_x));
        y := to_integer(unsigned(pixel_y));

        frame_x <= (others => '0');
        frame_y <= (others => '0');
        vga_r <= "0000";
        vga_g <= "0000";
        vga_b <= "0000";
        pixel_on_debug <= '0';

        if video_on = '1' then
            if x >= 0 and x < 640 and y >= 80 and y < 400 then
                sx := x / 10;
                sy := (y - 80) / 10;
                frame_x <= std_logic_vector(to_unsigned(sx, 6));
                frame_y <= std_logic_vector(to_unsigned(sy, 5));
                pixel_on_debug <= frame_pixel;

                if frame_pixel = '1' then
                    vga_r <= "1111";
                    vga_g <= "1111";
                    vga_b <= "1111";
                end if;
            end if;
        end if;
    end process;
end Behavioral;
