library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_vid_ram is
end tb_vid_ram;

architecture sim of tb_vid_ram is
    signal chip_x   : std_logic_vector(5 downto 0) := (others => '0');
    signal chip_y   : std_logic_vector(4 downto 0) := (others => '0');
    signal pixel_on : std_logic;
begin
    uut : entity work.vid_ram
        port map (
            chip_x   => chip_x,
            chip_y   => chip_y,
            pixel_on => pixel_on
        );

    stim_proc : process
    begin
        chip_x <= std_logic_vector(to_unsigned(0, 6));
        chip_y <= std_logic_vector(to_unsigned(15, 5));
        wait for 1 ns;
        assert pixel_on = '1'
            report "Left border pixel should be ON"
            severity failure;

        chip_x <= std_logic_vector(to_unsigned(63, 6));
        chip_y <= std_logic_vector(to_unsigned(31, 5));
        wait for 1 ns;
        assert pixel_on = '1'
            report "Bottom-right border pixel should be ON"
            severity failure;

        chip_x <= std_logic_vector(to_unsigned(10, 6));
        chip_y <= std_logic_vector(to_unsigned(5, 5));
        wait for 1 ns;
        assert pixel_on = '1'
            report "Diagonal pixel (10,5) should be ON"
            severity failure;

        chip_x <= std_logic_vector(to_unsigned(52, 6));
        chip_y <= std_logic_vector(to_unsigned(5, 5));
        wait for 1 ns;
        assert pixel_on = '1'
            report "Opposite diagonal pixel (52,5) should be ON"
            severity failure;

        chip_x <= std_logic_vector(to_unsigned(30, 6));
        chip_y <= std_logic_vector(to_unsigned(10, 5));
        wait for 1 ns;
        assert pixel_on = '0'
            report "Pixel (30,10) should be OFF"
            severity failure;

        report "tb_vid_ram passed" severity note;
        wait;
    end process;
end sim;