library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chip8_memory is
    Port (
        clk         : in  std_logic;
        write_en    : in  std_logic;
        addr        : in  std_logic_vector(11 downto 0);
        write_data  : in  std_logic_vector(7 downto 0);
        read_data   : out std_logic_vector(7 downto 0);
        opcode_addr : in  std_logic_vector(11 downto 0);
        opcode_out  : out std_logic_vector(15 downto 0)
    );
end chip8_memory;

architecture Behavioral of chip8_memory is
    type ram_type is array (0 to 4095) of std_logic_vector(7 downto 0);

    signal ram : ram_type := (
        80  => x"F0",
        81  => x"90",
        82  => x"90",
        83  => x"90",
        84  => x"F0",

        85  => x"20",
        86  => x"60",
        87  => x"20",
        88  => x"20",
        89  => x"70",

        90  => x"F0",
        91  => x"10",
        92  => x"F0",
        93  => x"80",
        94  => x"F0",

        95  => x"F0",
        96  => x"10",
        97  => x"F0",
        98  => x"10",
        99  => x"F0",

        100 => x"90",
        101 => x"90",
        102 => x"F0",
        103 => x"10",
        104 => x"10",

        105 => x"F0",
        106 => x"80",
        107 => x"F0",
        108 => x"10",
        109 => x"F0",

        110 => x"F0",
        111 => x"80",
        112 => x"F0",
        113 => x"90",
        114 => x"F0",

        115 => x"F0",
        116 => x"10",
        117 => x"20",
        118 => x"40",
        119 => x"40",

        120 => x"F0",
        121 => x"90",
        122 => x"F0",
        123 => x"90",
        124 => x"F0",

        125 => x"F0",
        126 => x"90",
        127 => x"F0",
        128 => x"10",
        129 => x"F0",

        130 => x"F0",
        131 => x"90",
        132 => x"F0",
        133 => x"90",
        134 => x"90",

        135 => x"E0",
        136 => x"90",
        137 => x"E0",
        138 => x"90",
        139 => x"E0",

        140 => x"F0",
        141 => x"80",
        142 => x"80",
        143 => x"80",
        144 => x"F0",

        145 => x"E0",
        146 => x"90",
        147 => x"90",
        148 => x"90",
        149 => x"E0",

        150 => x"F0",
        151 => x"80",
        152 => x"F0",
        153 => x"80",
        154 => x"F0",

        155 => x"F0",
        156 => x"80",
        157 => x"F0",
        158 => x"80",
        159 => x"80",

        others => x"00"
    );

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if write_en = '1' then
                ram(to_integer(unsigned(addr))) <= write_data;
            end if;
        end if;
    end process;

    process(ram, addr, opcode_addr)
        variable a  : integer range 0 to 4095;
        variable p  : integer range 0 to 4095;
        variable p2 : integer range 0 to 4095;
    begin
        a := to_integer(unsigned(addr));
        p := to_integer(unsigned(opcode_addr));

        if p = 4095 then
            p2 := 0;
        else
            p2 := p + 1;
        end if;

        read_data <= ram(a);
        opcode_out <= ram(p) & ram(p2);
    end process;
end Behavioral;