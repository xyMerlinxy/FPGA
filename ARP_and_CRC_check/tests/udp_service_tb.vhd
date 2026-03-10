library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.com_context;
context vunit_lib.data_types_context;
use vunit_lib.avalon_stream_pkg.all;
use vunit_lib.stream_master_pkg.all;
use vunit_lib.stream_slave_pkg.all;

ENTITY udp_service_tb IS
  generic(runner_cfg : string;
    asi_valid_high_probability : real range 0.0 to 1.0 := 1.0;
    aso_ready_high_probability : real range 0.0 to 1.0 := 1.0);
END ENTITY udp_service_tb;

ARCHITECTURE tb OF udp_service_tb IS
  -- avalon stream source
  constant avalon_source_stream : avalon_source_t :=
    new_avalon_source(data_length => 8, valid_high_probability => asi_valid_high_probability);
  constant master_stream : stream_master_t := as_stream(avalon_source_stream);

  component udp_service
    generic (
      IP_ADDRESS : std_logic_vector(31 downto 0);
      MAC_ADDRESS : std_logic_vector(47 downto 0)
    );
    port (
      clk : in std_logic;
      rst_n : in std_logic;
      asi_data : in std_logic_vector  (7 downto 0);
      asi_valid : in std_logic;
      asi_ready : out std_logic;
      asi_sop : in std_logic;
      asi_eop : in std_logic;
      dis_7seg_0 : out std_logic_vector  (6 downto 0);
      dis_7seg_1 : out std_logic_vector  (6 downto 0);
      dis_7seg_2 : out std_logic_vector  (6 downto 0);
      dis_7seg_3 : out std_logic_vector  (6 downto 0);
      dis_7seg_4 : out std_logic_vector  (6 downto 0);
      dis_7seg_5 : out std_logic_vector  (6 downto 0);
      dis_7seg_6 : out std_logic_vector  (6 downto 0);
      dis_7seg_7 : out std_logic_vector  (6 downto 0)
    );
  end component;
  
  constant IP_ADDR : std_logic_vector(31 downto 0) := x"A9FE93FA";
  constant MAC_ADDR : std_logic_vector(47 downto 0) := x"001A2B3C4D5E";
  -- INTERNAL SIGNALS DECLARATION --
  signal clk            : STD_LOGIC := '0';
  signal rst_n          : STD_LOGIC := '0';
  
  signal s_asi_data     : std_logic_vector(7 downto 0);
  signal s_asi_valid    : std_logic;
  signal s_asi_ready    : std_logic;
  signal s_asi_sop      : std_logic;
  signal s_asi_eop      : std_logic;

  signal s_dis_7seg_0 : std_logic_vector(6 downto 0);
  signal s_dis_7seg_1 : std_logic_vector(6 downto 0);
  signal s_dis_7seg_2 : std_logic_vector(6 downto 0);
  signal s_dis_7seg_3 : std_logic_vector(6 downto 0);
  signal s_dis_7seg_4 : std_logic_vector(6 downto 0);
  signal s_dis_7seg_5 : std_logic_vector(6 downto 0);
  signal s_dis_7seg_6 : std_logic_vector(6 downto 0);
  signal s_dis_7seg_7 : std_logic_vector(6 downto 0);

  signal start_stimuli, stimuli_done : boolean := false;

  signal s_asi_done : boolean := false;
  signal s_7seg_done : boolean := false;

procedure push_frame (signal nett : inout network_t;
  stream : avalon_source_t;
  src_ip_addr : std_logic_vector(31 downto 0);
  src_mac_addr : std_logic_vector(47 downto 0);
  trg_ip_addr : std_logic_vector(31 downto 0);
  trg_mac_addr : std_logic_vector(47 downto 0);
  data         : std_logic_vector(31 downto 0);
  lenght : natural range 0 to 100 := 60) is
variable index : natural range 0 to 2048;
variable is_sop : std_logic;
variable is_eop : std_logic;
variable push_data : std_logic_vector(7 downto 0);
begin
  index := 0;
  loop
    -- ending statment
    if index = lenght then
      is_eop := '1';
      index := 0;
      exit;
    end if;

    case index is
      when 00 => push_data := trg_mac_addr(47 downto 40); -- mac dest
      when 01 => push_data := trg_mac_addr(39 downto 32);
      when 02 => push_data := trg_mac_addr(31 downto 24);
      when 03 => push_data := trg_mac_addr(23 downto 16);
      when 04 => push_data := trg_mac_addr(15 downto 08);
      when 05 => push_data := trg_mac_addr(07 downto 00);
      when 06 => push_data := src_mac_addr(47 downto 40);-- mac src
      when 07 => push_data := src_mac_addr(39 downto 32);
      when 08 => push_data := src_mac_addr(31 downto 24);
      when 09 => push_data := src_mac_addr(23 downto 16);
      when 10 => push_data := src_mac_addr(15 downto 08);
      when 11 => push_data := src_mac_addr(07 downto 00);
      when 12 => push_data := x"08"; -- type ARP - 0x0806
      when 13 => push_data := x"00";
      when 14 => push_data := x"45"; -- hardwar type - 0x0001
      when 15 => push_data := x"01"; 
      when 16 => push_data := x"08"; -- version, ihl
      when 17 => push_data := x"22"; -- dscp

      when 18 => push_data := x"00"; -- total lenght
      when 19 => push_data := std_logic_vector(to_unsigned(lenght, 8));

      when 20 => push_data := x"00"; -- flag
      when 21 => push_data := x"00";

      when 22 => push_data := x"05"; -- ttl
      when 23 => push_data := x"11"; -- protocol
      when 24 => push_data := x"00"; -- header checksum
      when 25 => push_data := x"00"; -- 
      when 26 => push_data := src_ip_addr(31 downto 24); -- sender ip
      when 27 => push_data := src_ip_addr(23 downto 16);
      when 28 => push_data := src_ip_addr(15 downto 08);
      when 29 => push_data := src_ip_addr(07 downto 00);
      when 30 => push_data := trg_ip_addr(31 downto 24); -- target ip
      when 31 => push_data := trg_ip_addr(23 downto 16);
      when 32 => push_data := trg_ip_addr(15 downto 08);
      when 33 => push_data := trg_ip_addr(07 downto 00);
      when 34 => push_data := x"12"; -- src port
      when 35 => push_data := x"34";
      when 36 => push_data := x"08"; -- dst port
      when 37 => push_data := x"59";
      when 38 => push_data := x"12"; -- lenght
      when 39 => push_data := x"34";
      when 40 => push_data := x"08"; -- check_sum
      when 41 => push_data := x"59";
      when 42 => push_data := data(31 downto 24);
      when 43 => push_data := data(23 downto 16);
      when 44 => push_data := data(15 downto 08);
      when 45 => push_data := data(07 downto 00);

      when others => push_data := x"00";
    end case;

    -- set sop and eop
    if index = 0 then
      is_sop := '1';
      is_eop := '0';
    elsif index = lenght - 1 then
      is_sop := '0';
      is_eop := '1';
    else
      is_sop := '0';
      is_eop := '0';
    end if;

    push_avalon_stream(nett, stream, push_data, is_sop, is_eop);
    wait until rising_edge(clk);

    index := index + 1;
  end loop;
end procedure push_frame;

begin
  udp_service_inst : udp_service
  generic map (
    IP_ADDRESS => IP_ADDR,
    MAC_ADDRESS => MAC_ADDR
  )
  port map (
    clk => clk,
    rst_n => rst_n,
    asi_data => s_asi_data,
    asi_valid => s_asi_valid,
    asi_ready => s_asi_ready,
    asi_sop => s_asi_sop,
    asi_eop => s_asi_eop,
    dis_7seg_0 => s_dis_7seg_0,
    dis_7seg_1 => s_dis_7seg_1,
    dis_7seg_2 => s_dis_7seg_2,
    dis_7seg_3 => s_dis_7seg_3,
    dis_7seg_4 => s_dis_7seg_4,
    dis_7seg_5 => s_dis_7seg_5,
    dis_7seg_6 => s_dis_7seg_6,
    dis_7seg_7 => s_dis_7seg_7
  );

  avalon_source_vc : entity vunit_lib.avalon_source
    generic map (
      source => avalon_source_stream)
    port map (
      clk   => clk,
      valid => s_asi_valid,
      ready => s_asi_ready,
      sop   => s_asi_sop,
      eop   => s_asi_eop,
      data  => s_asi_data
    );

  process_clk: process
  begin
    wait for 5 ns;
    clk <= not clk;
  end process;

  process_rst : process
  begin
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    rst_n <= '1';
    wait;
  end process;

  test_runner : PROCESS
  BEGIN
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if   run("FRAME_01")
        or run("FRAME_02")
      then
        start_stimuli <= true;
        wait until(s_asi_done = true
               and s_7seg_done = true
               );
      end if;
    end loop;

    test_runner_cleanup(runner);
  END PROCESS test_runner;
  
  process_asi : process
  begin
    wait until (start_stimuli and rising_edge(clk) and rst_n = '1');

    if running_test_case = "FRAME_01" then
      info("PROCESS_ASI: FRAME_01");
      push_frame(net, avalon_source_stream, x"01020304", x"FFFEFDFCFBFA", IP_ADDR, MAC_ADDR, x"12345678");

    elsif running_test_case = "FRAME_02" then
      info("PROCESS_ASI: FRAME_02");
      push_frame(net, avalon_source_stream, x"FFAABBCC", x"FFFEFDFCFBFA", IP_ADDR, MAC_ADDR, x"FBCDA987");
      push_frame(net, avalon_source_stream, x"BAD12345", x"FFFEFDFCFBFA", IP_ADDR, MAC_ADDR, x"12345678");
    
    end if;
    info("PROCESS_ASI DONE");
    s_asi_done <= true;
    wait;
  end process;

  process_7seg : process
    variable check_data : std_logic_vector(6 downto 0);
  begin
    wait until (start_stimuli and rising_edge(clk) and rst_n = '1');

    if running_test_case = "FRAME_01" then
      info("PROCESS_7SEG: FRAME_01");
      wait until (s_asi_eop = '1' and s_asi_valid = '1' and rising_edge(clk));
      check_data := "0000000";
      info("Segment 0: Value: " & to_string(s_dis_7seg_0) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_0, check_data, ("Segment 0 Value: " & to_string(s_dis_7seg_0)));
      check_data := "1111000";
      info("Segment 1: Value: " & to_string(s_dis_7seg_1) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_1, check_data, ("Segment 1 Value: " & to_string(s_dis_7seg_1)));
      check_data := "0000010";
      info("Segment 2: Value: " & to_string(s_dis_7seg_2) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_2, check_data, ("Segment 2 Value: " & to_string(s_dis_7seg_2)));
      check_data := "0010010";
      info("Segment 3: Value: " & to_string(s_dis_7seg_3) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_3, check_data, ("Segment 3 Value: " & to_string(s_dis_7seg_3)));
      check_data := "0011001";
      info("Segment 4: Value: " & to_string(s_dis_7seg_4) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_4, check_data, ("Segment 4 Value: " & to_string(s_dis_7seg_4)));
      check_data := "0110000";
      info("Segment 5: Value: " & to_string(s_dis_7seg_5) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_5, check_data, ("Segment 5 Value: " & to_string(s_dis_7seg_5)));
      check_data := "0100100";
      info("Segment 6: Value: " & to_string(s_dis_7seg_6) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_6, check_data, ("Segment 6 Value: " & to_string(s_dis_7seg_6)));
      check_data := "1111001";
      info("Segment 7: Value: " & to_string(s_dis_7seg_7) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_7, check_data, ("Segment 7 Value: " & to_string(s_dis_7seg_7)));
      
    elsif running_test_case = "FRAME_02" then
      info("PROCESS_ASO: FRAME_02");
      wait until (s_asi_eop = '1' and s_asi_valid = '1' and rising_edge(clk));
      check_data := "1111000";
      info("Segment 0: Value: " & to_string(s_dis_7seg_0) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_0, check_data, ("Segment 0 Value: " & to_string(s_dis_7seg_0)));
      check_data := "0000000";
      info("Segment 1: Value: " & to_string(s_dis_7seg_1) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_1, check_data, ("Segment 1 Value: " & to_string(s_dis_7seg_1)));
      check_data := "0010000";
      info("Segment 2: Value: " & to_string(s_dis_7seg_2) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_2, check_data, ("Segment 2 Value: " & to_string(s_dis_7seg_2)));
      check_data := "0001000";
      info("Segment 3: Value: " & to_string(s_dis_7seg_3) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_3, check_data, ("Segment 3 Value: " & to_string(s_dis_7seg_3)));
      check_data := "0100001";
      info("Segment 4: Value: " & to_string(s_dis_7seg_4) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_4, check_data, ("Segment 4 Value: " & to_string(s_dis_7seg_4)));
      check_data := "1000110";
      info("Segment 5: Value: " & to_string(s_dis_7seg_5) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_5, check_data, ("Segment 5 Value: " & to_string(s_dis_7seg_5)));
      check_data := "0000011";
      info("Segment 6: Value: " & to_string(s_dis_7seg_6) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_6, check_data, ("Segment 6 Value: " & to_string(s_dis_7seg_6)));
      check_data := "0001110";
      info("Segment 7: Value: " & to_string(s_dis_7seg_7) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_7, check_data, ("Segment 7 Value: " & to_string(s_dis_7seg_7)));

      wait until (s_asi_eop = '1' and s_asi_valid = '1' and rising_edge(clk));
      check_data := "0000000";
      info("Segment 0: Value: " & to_string(s_dis_7seg_0) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_0, check_data, ("Segment 0 Value: " & to_string(s_dis_7seg_0)));
      check_data := "1111000";
      info("Segment 1: Value: " & to_string(s_dis_7seg_1) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_1, check_data, ("Segment 1 Value: " & to_string(s_dis_7seg_1)));
      check_data := "0000010";
      info("Segment 2: Value: " & to_string(s_dis_7seg_2) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_2, check_data, ("Segment 2 Value: " & to_string(s_dis_7seg_2)));
      check_data := "0010010";
      info("Segment 3: Value: " & to_string(s_dis_7seg_3) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_3, check_data, ("Segment 3 Value: " & to_string(s_dis_7seg_3)));
      check_data := "0011001";
      info("Segment 4: Value: " & to_string(s_dis_7seg_4) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_4, check_data, ("Segment 4 Value: " & to_string(s_dis_7seg_4)));
      check_data := "0110000";
      info("Segment 5: Value: " & to_string(s_dis_7seg_5) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_5, check_data, ("Segment 5 Value: " & to_string(s_dis_7seg_5)));
      check_data := "0100100";
      info("Segment 6: Value: " & to_string(s_dis_7seg_6) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_6, check_data, ("Segment 6 Value: " & to_string(s_dis_7seg_6)));
      check_data := "1111001";
      info("Segment 7: Value: " & to_string(s_dis_7seg_7) & " Should be: " & to_string(check_data));
      check_equal(s_dis_7seg_7, check_data, ("Segment 7 Value: " & to_string(s_dis_7seg_7)));
    end if;
    info("PROCESS_ASO DONE");
    s_7seg_done <= true;
    wait;
  end process;

END ARCHITECTURE tb;
