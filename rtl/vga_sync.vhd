library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_sync is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        pixel_tick : in  std_logic;
        hsync      : out std_logic;
        vsync      : out std_logic;
        video_on   : out std_logic;
        pixel_x    : out std_logic_vector(9 downto 0);
        pixel_y    : out std_logic_vector(9 downto 0)
    );
end vga_sync;

architecture Behavioral of vga_sync is
    signal h_cnt : integer range 0 to 799 := 0;
    signal v_cnt : integer range 0 to 524 := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            h_cnt <= 0;
            v_cnt <= 0;
        elsif rising_edge(clk) then
            if pixel_tick = '1' then
                if h_cnt = 799 then
                    h_cnt <= 0;
                    if v_cnt = 524 then
                        v_cnt <= 0;
                    else
                        v_cnt <= v_cnt + 1;
                    end if;
                else
                    h_cnt <= h_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    hsync <= '0' when h_cnt >= 656 and h_cnt < 752 else '1';
    vsync <= '0' when v_cnt >= 490 and v_cnt < 492 else '1';
    video_on <= '1' when h_cnt < 640 and v_cnt < 480 else '0';

    pixel_x <= std_logic_vector(to_unsigned(h_cnt, 10));
    pixel_y <= std_logic_vector(to_unsigned(v_cnt, 10));
end Behavioral;