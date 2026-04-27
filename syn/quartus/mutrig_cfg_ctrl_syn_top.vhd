library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mutrig_cfg_ctrl_syn_top is
    port(
        controller_clk : in  std_logic;
        spi_clk        : in  std_logic;
        activity_probe : out std_logic_vector(31 downto 0)
    );
end entity mutrig_cfg_ctrl_syn_top;

architecture rtl of mutrig_cfg_ctrl_syn_top is
    type schpad_mem_t is array (0 to 2047) of std_logic_vector(31 downto 0);

    function init_schpad return schpad_mem_t is
        variable mem : schpad_mem_t;
    begin
        for i in mem'range loop
            mem(i) := std_logic_vector(to_unsigned((i * 16#1021#) + 16#1357#, 32));
        end loop;
        return mem;
    end function;

    signal controller_rst_ctr      : unsigned(7 downto 0) := (others => '0');
    signal spi_rst_ctr             : unsigned(7 downto 0) := (others => '0');
    signal i_rst                   : std_logic;
    signal i_rst_spi               : std_logic;

    signal ctrl_ctr                : unsigned(31 downto 0) := (others => '0');
    signal spi_ctr                 : unsigned(31 downto 0) := (others => '0');
    signal probe_accum_ctrl        : std_logic_vector(31 downto 0) := (others => '0');
    signal probe_accum_spi         : std_logic_vector(31 downto 0) := (others => '0');

    signal avm_schpad_address      : std_logic_vector(10 downto 0);
    signal avm_schpad_read         : std_logic;
    signal avm_schpad_readdata     : std_logic_vector(31 downto 0) := (others => '0');
    signal avm_schpad_response     : std_logic_vector(1 downto 0) := (others => '0');
    signal avm_schpad_waitrequest  : std_logic := '0';
    signal avm_schpad_readdatavalid: std_logic := '0';
    signal avm_schpad_burstcount   : std_logic_vector(8 downto 0);

    signal avs_csr_address         : std_logic_vector(1 downto 0) := (others => '0');
    signal avs_csr_read            : std_logic := '0';
    signal avs_csr_readdata        : std_logic_vector(31 downto 0);
    signal avs_csr_write           : std_logic := '0';
    signal avs_csr_writedata       : std_logic_vector(31 downto 0) := (others => '0');
    signal avs_csr_waitrequest     : std_logic;
    signal avs_csr_response        : std_logic_vector(1 downto 0);

    signal avm_cnt_address         : std_logic_vector(15 downto 0);
    signal avm_cnt_read            : std_logic;
    signal avm_cnt_readdata        : std_logic_vector(31 downto 0) := (others => '0');
    signal avm_cnt_waitrequest     : std_logic := '0';
    signal avm_cnt_burstcount      : std_logic_vector(8 downto 0);
    signal avm_cnt_readdatavalid   : std_logic := '0';
    signal avm_cnt_response        : std_logic_vector(1 downto 0) := (others => '0');
    signal avm_cnt_flush           : std_logic;

    signal avs_scanresult_address  : std_logic_vector(13 downto 0) := (others => '0');
    signal avs_scanresult_read     : std_logic := '0';
    signal avs_scanresult_readdata : std_logic_vector(31 downto 0);
    signal avs_scanresult_waitrequest : std_logic;

    signal o_sclr_req              : std_logic;
    signal spi_miso                : std_logic := '0';
    signal spi_mosi                : std_logic;
    signal spi_sclk                : std_logic;
    signal spi_ssn                 : std_logic_vector(7 downto 0);

    signal schpad_mem              : schpad_mem_t := init_schpad;
begin
    i_rst     <= '1' when controller_rst_ctr < to_unsigned(32, controller_rst_ctr'length) else '0';
    i_rst_spi <= '1' when spi_rst_ctr < to_unsigned(32, spi_rst_ctr'length) else '0';
    activity_probe <= probe_accum_ctrl xor probe_accum_spi;

    u_dut : entity work.mutrig_ctrl
        generic map(
            N_MUTRIG      => 8,
            CLK_FREQUENCY => 156250000,
            DEBUG         => 1
        )
        port map(
            i_clk                    => controller_clk,
            i_rst                    => i_rst,
            i_clk_spi                => spi_clk,
            i_rst_spi                => i_rst_spi,
            avm_schpad_address       => avm_schpad_address,
            avm_schpad_read          => avm_schpad_read,
            avm_schpad_readdata      => avm_schpad_readdata,
            avm_schpad_response      => avm_schpad_response,
            avm_schpad_waitrequest   => avm_schpad_waitrequest,
            avm_schpad_readdatavalid => avm_schpad_readdatavalid,
            avm_schpad_burstcount    => avm_schpad_burstcount,
            avs_csr_address          => avs_csr_address,
            avs_csr_read             => avs_csr_read,
            avs_csr_readdata         => avs_csr_readdata,
            avs_csr_write            => avs_csr_write,
            avs_csr_writedata        => avs_csr_writedata,
            avs_csr_waitrequest      => avs_csr_waitrequest,
            avs_csr_response         => avs_csr_response,
            avm_cnt_address          => avm_cnt_address,
            avm_cnt_read             => avm_cnt_read,
            avm_cnt_readdata         => avm_cnt_readdata,
            avm_cnt_waitrequest      => avm_cnt_waitrequest,
            avm_cnt_burstcount       => avm_cnt_burstcount,
            avm_cnt_readdatavalid    => avm_cnt_readdatavalid,
            avm_cnt_response         => avm_cnt_response,
            avm_cnt_flush            => avm_cnt_flush,
            avs_scanresult_address   => avs_scanresult_address,
            avs_scanresult_read      => avs_scanresult_read,
            avs_scanresult_readdata  => avs_scanresult_readdata,
            avs_scanresult_waitrequest => avs_scanresult_waitrequest,
            o_sclr_req               => o_sclr_req,
            spi_miso                 => spi_miso,
            spi_mosi                 => spi_mosi,
            spi_sclk                 => spi_sclk,
            spi_ssn                  => spi_ssn
        );

    process(controller_clk)
        variable probe_next : std_logic_vector(31 downto 0);
        variable addr_mix   : unsigned(31 downto 0);
    begin
        if rising_edge(controller_clk) then
            if controller_rst_ctr /= to_unsigned(255, controller_rst_ctr'length) then
                controller_rst_ctr <= controller_rst_ctr + 1;
            end if;

            if i_rst = '1' then
                ctrl_ctr                 <= (others => '0');
                probe_accum_ctrl         <= (others => '0');
                avs_csr_address          <= (others => '0');
                avs_csr_read             <= '0';
                avs_csr_write            <= '0';
                avs_csr_writedata        <= (others => '0');
                avs_scanresult_address   <= (others => '0');
                avs_scanresult_read      <= '0';
                avm_schpad_readdata      <= (others => '0');
                avm_schpad_readdatavalid <= '0';
                avm_cnt_readdata         <= (others => '0');
                avm_cnt_readdatavalid    <= '0';
            else
                ctrl_ctr <= ctrl_ctr + 1;

                avm_schpad_readdatavalid <= avm_schpad_read;
                if avm_schpad_read = '1' then
                    avm_schpad_readdata <= schpad_mem(to_integer(unsigned(avm_schpad_address)));
                end if;

                avm_cnt_readdatavalid <= avm_cnt_read;
                if avm_cnt_read = '1' then
                    addr_mix := resize(unsigned(avm_cnt_address), 32) xor ctrl_ctr;
                    avm_cnt_readdata <= std_logic_vector(addr_mix);
                end if;

                avs_csr_read        <= '0';
                avs_csr_write       <= '0';
                avs_scanresult_read <= '0';
                case to_integer(ctrl_ctr(9 downto 0)) is
                    when 0 =>
                        avs_csr_address   <= "01";
                        avs_csr_writedata <= x"00000000";
                        avs_csr_write     <= '1';
                    when 1 =>
                        avs_csr_address   <= "10";
                        avs_csr_writedata <= x"00000002";
                        avs_csr_write     <= '1';
                    when 2 =>
                        avs_csr_address   <= "00";
                        avs_csr_writedata <= x"01100008";
                        avs_csr_write     <= '1';
                    when 128 =>
                        avs_csr_address   <= "00";
                        avs_csr_read      <= '1';
                    when 256 =>
                        avs_csr_address   <= "00";
                        avs_csr_writedata <= x"01200004";
                        avs_csr_write     <= '1';
                    when 384 =>
                        avs_scanresult_address <= std_logic_vector(ctrl_ctr(13 downto 0));
                        avs_scanresult_read    <= '1';
                    when 385 =>
                        avs_csr_address   <= "00";
                        avs_csr_read      <= '1';
                    when others =>
                        null;
                end case;

                probe_next := probe_accum_ctrl xor std_logic_vector(ctrl_ctr);
                probe_next := probe_next xor avs_csr_readdata xor avs_scanresult_readdata;
                probe_next := probe_next xor avm_schpad_readdata xor avm_cnt_readdata;
                probe_next(0) := probe_next(0) xor avs_csr_waitrequest;
                probe_next(2 downto 1) := probe_next(2 downto 1) xor avs_csr_response;
                probe_next(3) := probe_next(3) xor avs_scanresult_waitrequest;
                probe_next(4) := probe_next(4) xor o_sclr_req;
                probe_next(5) := probe_next(5) xor avm_cnt_flush;
                probe_accum_ctrl <= probe_next;
            end if;
        end if;
    end process;

    process(spi_clk)
        variable lfsr_feedback : std_logic;
        variable probe_next    : std_logic_vector(31 downto 0);
    begin
        if rising_edge(spi_clk) then
            if spi_rst_ctr /= to_unsigned(255, spi_rst_ctr'length) then
                spi_rst_ctr <= spi_rst_ctr + 1;
            end if;

            if i_rst_spi = '1' then
                spi_ctr         <= (others => '0');
                spi_miso        <= '0';
                probe_accum_spi <= (others => '0');
            else
                spi_ctr       <= spi_ctr + 1;
                lfsr_feedback := std_logic(spi_ctr(0) xor spi_ctr(3) xor spi_ctr(7) xor spi_ctr(12));
                spi_miso      <= lfsr_feedback;

                probe_next := probe_accum_spi xor std_logic_vector(spi_ctr);
                probe_next(0) := probe_next(0) xor spi_miso;
                probe_next(1) := probe_next(1) xor spi_mosi;
                probe_next(2) := probe_next(2) xor spi_sclk;
                probe_next(10 downto 3) := probe_next(10 downto 3) xor spi_ssn;
                probe_accum_spi <= probe_next;
            end if;
        end if;
    end process;
end architecture rtl;
