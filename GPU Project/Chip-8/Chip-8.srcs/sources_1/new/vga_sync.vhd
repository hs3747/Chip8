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
    signal h_count : unsigned(9 downto 0) := (others => '0');
    signal v_count : unsigned(9 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            h_count <= (others => '0');
            v_count <= (others => '0');
        elsif rising_edge(clk) then
            if pixel_tick = '1' then
                if h_count = to_unsigned(799, 10) then
                    h_count <= (others => '0');
                    if v_count = to_unsigned(524, 10) then
                        v_count <= (others => '0');
                    else
                        v_count <= v_count + 1;
                    end if;
                else
                    h_count <= h_count + 1;
                end if;
            end if;
        end if;
    end process;

    hsync    <= '0' when (to_integer(h_count) >= 656 and to_integer(h_count) < 752) else '1';
    vsync    <= '0' when (to_integer(v_count) >= 490 and to_integer(v_count) < 492) else '1';
    video_on <= '1' when (to_integer(h_count) < 640 and to_integer(v_count) < 480) else '0';

    pixel_x <= std_logic_vector(h_count);
    pixel_y <= std_logic_vector(v_count);
end Behavioral;