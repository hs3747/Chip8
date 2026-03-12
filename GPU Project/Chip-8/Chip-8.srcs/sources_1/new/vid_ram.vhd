library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vid_ram is
Port (
    chip_x   : in  std_logic_vector(5 downto 0);
    chip_y   : in  std_logic_vector(4 downto 0);
    pixel_on : out std_logic
);
end vid_ram;

architecture Behavioral of vid_ram is
begin
    process(chip_x, chip_y)
        variable x : integer range 0 to 63;
        variable y : integer range 0 to 31;
    begin
        x := to_integer(unsigned(chip_x));
        y := to_integer(unsigned(chip_y));

        if (x = 0) or (x = 63) or (y = 0) or (y = 31) or
           (x = (2 * y)) or (x = (2 * y) + 1) or
           (x = 63 - (2 * y)) or (x = 62 - (2 * y)) then
            pixel_on <= '1';
        else
            pixel_on <= '0';
        end if;
    end process;
end Behavioral;