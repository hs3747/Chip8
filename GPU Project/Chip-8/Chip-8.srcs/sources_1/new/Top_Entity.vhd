library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Entity is
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
end Top_Entity;

architecture Structural of Top_Entity is
    signal pc_sig         : std_logic_vector(11 downto 0);
    signal pixel_tick_sig : std_logic;
    signal hsync_sig      : std_logic;
    signal vsync_sig      : std_logic;
    signal video_on_sig   : std_logic;
    signal pixel_x_sig    : std_logic_vector(9 downto 0);
    signal pixel_y_sig    : std_logic_vector(9 downto 0);
    signal pixel_on_sig   : std_logic;
begin
    cpu_unit : entity work.Chip8_cpu
        port map (
            clk    => CLK100MHZ,
            reset  => reset,
            pc_out => pc_sig
        );

    pixel_tick_unit : entity work.clock_enable
        generic map (
            DIVISOR => 4
        )
        port map (
            clk     => CLK100MHZ,
            reset   => reset,
            tick_en => pixel_tick_sig
        );

    sync_unit : entity work.vga_sync
        port map (
            clk        => CLK100MHZ,
            reset      => reset,
            pixel_tick => pixel_tick_sig,
            hsync      => hsync_sig,
            vsync      => vsync_sig,
            video_on   => video_on_sig,
            pixel_x    => pixel_x_sig,
            pixel_y    => pixel_y_sig
        );

    render_unit : entity work.gpu_renderer
        port map (
            video_on       => video_on_sig,
            pixel_x        => pixel_x_sig,
            pixel_y        => pixel_y_sig,
            vga_r          => VGA_R,
            vga_g          => VGA_G,
            vga_b          => VGA_B,
            pixel_on_debug => pixel_on_sig
        );

    VGA_HS <= hsync_sig;
    VGA_VS <= vsync_sig;

    LED(11 downto 0) <= pc_sig;
    LED(12) <= pixel_on_sig;
    LED(13) <= video_on_sig;
    LED(14) <= hsync_sig;
    LED(15) <= vsync_sig;
end Structural;