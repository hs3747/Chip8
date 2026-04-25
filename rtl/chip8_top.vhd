library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity chip8_top is
    generic (
        CPU_TICK_DIVISOR : positive := 100000000;
        PIXEL_TICK_DIVISOR : positive := 4;
        INIT_TEST_PATTERN : boolean := true
    );
    Port (
        CLK100MHZ : in  std_logic;
        reset     : in  std_logic;
        LED       : out std_logic_vector(15 downto 0);
        VGA_HS    : out std_logic;
        VGA_VS    : out std_logic;
        VGA_R     : out std_logic_vector(3 downto 0);
        VGA_G     : out std_logic_vector(3 downto 0);
        VGA_B     : out std_logic_vector(3 downto 0)
    );
end chip8_top;

architecture Structural of chip8_top is
    signal cpu_tick : std_logic;
    signal pixel_tick : std_logic;
    signal pc_now : std_logic_vector(11 downto 0);
    signal opcode_now : std_logic_vector(15 downto 0);
    signal h_sig : std_logic;
    signal v_sig : std_logic;
    signal vid_on : std_logic;
    signal px : std_logic_vector(9 downto 0);
    signal py : std_logic_vector(9 downto 0);
    signal vx : std_logic_vector(5 downto 0);
    signal vy : std_logic_vector(4 downto 0);
    signal pix : std_logic;
begin
    t0 : entity work.tick_generator
        generic map (
            DIVISOR => CPU_TICK_DIVISOR
        )
        port map (
            clk     => CLK100MHZ,
            reset   => reset,
            tick_en => cpu_tick
        );

    c0 : entity work.chip8_cpu
        port map (
            clk        => CLK100MHZ,
            reset      => reset,
            step_en    => cpu_tick,
            pc_out     => pc_now,
            opcode_out => opcode_now
        );

    t1 : entity work.tick_generator
        generic map (
            DIVISOR => PIXEL_TICK_DIVISOR
        )
        port map (
            clk     => CLK100MHZ,
            reset   => reset,
            tick_en => pixel_tick
        );

    vga0 : entity work.vga_sync
        port map (
            clk        => CLK100MHZ,
            reset      => reset,
            pixel_tick => pixel_tick,
            hsync      => h_sig,
            vsync      => v_sig,
            video_on   => vid_on,
            pixel_x    => px,
            pixel_y    => py
        );

    vram0 : entity work.video_ram
        generic map (
            INIT_TEST_PATTERN => INIT_TEST_PATTERN
        )
        port map (
            clk         => CLK100MHZ,
            reset       => reset,
            clear       => '0',
            write_en    => '0',
            write_x     => "000000",
            write_y     => "00000",
            write_pixel => '0',
            read_x      => vx,
            read_y      => vy,
            read_pixel  => pix
        );

    ren0 : entity work.renderer
        port map (
            video_on       => vid_on,
            pixel_x        => px,
            pixel_y        => py,
            frame_pixel    => pix,
            frame_x        => vx,
            frame_y        => vy,
            vga_r          => VGA_R,
            vga_g          => VGA_G,
            vga_b          => VGA_B,
            pixel_on_debug => LED(12)
        );

    VGA_HS <= h_sig;
    VGA_VS <= v_sig;
    LED(11 downto 0) <= pc_now;
    LED(13) <= vid_on;
    LED(14) <= h_sig;
    LED(15) <= v_sig;
end Structural;
