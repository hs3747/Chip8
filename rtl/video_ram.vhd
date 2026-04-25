library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity video_ram is
    generic (
        INIT_TEST_PATTERN : boolean := true
    );
    Port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        clear       : in  std_logic;
        write_en    : in  std_logic;
        write_x     : in  std_logic_vector(5 downto 0);
        write_y     : in  std_logic_vector(4 downto 0);
        write_pixel : in  std_logic;
        read_x      : in  std_logic_vector(5 downto 0);
        read_y      : in  std_logic_vector(4 downto 0);
        read_pixel  : out std_logic
    );
end video_ram;

architecture Behavioral of video_ram is
    type screen_type is array (0 to 2047) of std_logic;
    signal screen : screen_type := (others => '0');
begin
    process(clk, reset)
        variable x_pos : integer range 0 to 63;
        variable y_pos : integer range 0 to 31;
        variable write_addr : integer range 0 to 2047;
    begin
        if reset = '1' then
            for i in 0 to 2047 loop
                x_pos := i mod 64;
                y_pos := i / 64;

                if INIT_TEST_PATTERN then
                    if x_pos = 0 or x_pos = 63 or y_pos = 0 or y_pos = 31 then
                        screen(i) <= '1';
                    elsif x_pos = 2 * y_pos or x_pos = (2 * y_pos) + 1 then
                        screen(i) <= '1';
                    elsif x_pos = 63 - (2 * y_pos) or x_pos = 62 - (2 * y_pos) then
                        screen(i) <= '1';
                    else
                        screen(i) <= '0';
                    end if;
                else
                    screen(i) <= '0';
                end if;
            end loop;
        elsif rising_edge(clk) then
            if clear = '1' then
                for i in 0 to 2047 loop
                    screen(i) <= '0';
                end loop;
            elsif write_en = '1' then
                write_addr := to_integer(unsigned(write_y)) * 64 + to_integer(unsigned(write_x));
                screen(write_addr) <= write_pixel;
            end if;
        end if;
    end process;

    process(screen, read_x, read_y)
        variable read_addr : integer range 0 to 2047;
    begin
        read_addr := to_integer(unsigned(read_y)) * 64 + to_integer(unsigned(read_x));
        read_pixel <= screen(read_addr);
    end process;
end Behavioral;