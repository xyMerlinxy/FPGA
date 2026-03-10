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

ENTITY arp_service_tb IS
  generic(runner_cfg : string;
    asi_valid_high_probability : real range 0.0 to 1.0 := 1.0;
    aso_ready_high_probability : real range 0.0 to 1.0 := 1.0);
END ENTITY arp_service_tb;

ARCHITECTURE tb OF arp_service_tb IS
  -- avalon stream source
  constant avalon_source_stream : avalon_source_t :=
    new_avalon_source(data_length => 8, valid_high_probability => asi_valid_high_probability);
  constant master_stream : stream_master_t := as_stream(avalon_source_stream);
  -- avalon stream sink 
  constant avalon_sink_stream : avalon_sink_t :=
    new_avalon_sink(data_length => 8, ready_high_probability => aso_ready_high_probability);
  constant slave_stream : stream_slave_t := as_stream(avalon_sink_stream);

  component arp_service
    port (
      clk : in std_logic;
      rst_n : in std_logic;
      asi_data : in std_logic_vector  (7 downto 0);
      asi_valid : in std_logic;
      asi_ready : out std_logic;
      asi_sop : in std_logic;
      asi_eop : in std_logic;
      aso_data : out std_logic_vector  (7 downto 0);
      aso_valid : out std_logic;
      aso_ready : in std_logic;
      aso_sop : out std_logic;
      aso_eop : out std_logic
    );
  end component;

  -- test vector
  type t_array is array(natural range <>) of std_logic_vector;
  -- constant c_frame_t3 : t_array(0 to 160)(7 downto 0) :=  ((x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e8",x"6a",x"64",x"52",x"c6",x"e5",x"08",x"06",x"00",x"01",
  
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

  signal s_aso_data     : std_logic_vector(7 downto 0);
  signal s_aso_valid    : std_logic;
  signal s_aso_ready    : std_logic;
  signal s_aso_sop      : std_logic;
  signal s_aso_eop      : std_logic;


  signal start_stimuli, stimuli_done : boolean := false;


  signal s_asi_done : boolean := false;
  signal s_aso_done : boolean := false;
  -- valid frame length 60
procedure push_frame (signal nett : inout network_t;
                        stream : avalon_source_t;
                        src_ip_addr : std_logic_vector(31 downto 0);
                        src_mac_addr : std_logic_vector(47 downto 0);
                        trg_ip_addr : std_logic_vector(31 downto 0);
                        trg_mac_addr : std_logic_vector(47 downto 0);
                        lenght : natural range 0 to 100 := 60;
                        error_addr: natural range 0 to 100 := 0;
                        error_value: std_logic_vector(7 downto 0) := x"00") is
    variable index : natural range 0 to 2048;
    variable is_sop : std_logic;
    variable is_eop : std_logic;
    variable push_data : std_logic_vector(7 downto 0);
    variable push_data_with_error : std_logic_vector(7 downto 0);

begin
  index := 0;
  loop
    -- ending statment
    if index = 60 then
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
      when 13 => push_data := x"06";
      when 14 => push_data := x"00"; -- hardwar type - 0x0001
      when 15 => push_data := x"01"; 
      when 16 => push_data := x"08"; -- protocol type - 0x0800
      when 17 => push_data := x"00"; 

      when 18 => push_data := x"06"; -- hardware size - 0x06
      when 19 => push_data := x"04"; -- protocol size - 0x04

      when 20 => push_data := x"00"; -- opcode - 0x0001
      when 21 => push_data := x"01";
      
      when 22 => push_data := src_mac_addr(47 downto 40); -- sender mac
      when 23 => push_data := src_mac_addr(39 downto 32);
      when 24 => push_data := src_mac_addr(31 downto 24);
      when 25 => push_data := src_mac_addr(23 downto 16);
      when 26 => push_data := src_mac_addr(15 downto 08);
      when 27 => push_data := src_mac_addr(07 downto 00);
      when 28 => push_data := src_ip_addr(31 downto 24); -- sender ip
      when 29 => push_data := src_ip_addr(23 downto 16);
      when 30 => push_data := src_ip_addr(15 downto 08);
      when 31 => push_data := src_ip_addr(07 downto 00);
      when 32 => push_data := x"00"; -- target mac
      when 33 => push_data := x"00";
      when 34 => push_data := x"00";
      when 35 => push_data := x"00";
      when 36 => push_data := x"00";
      when 37 => push_data := x"00";
      when 38 => push_data := trg_ip_addr(31 downto 24); -- target ip
      when 39 => push_data := trg_ip_addr(23 downto 16);
      when 40 => push_data := trg_ip_addr(15 downto 08);
      when 41 => push_data := trg_ip_addr(07 downto 00);
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

    if(index = error_addr) then
      push_data_with_error := push_data xor error_value;
    else
      push_data_with_error := push_data;
    end if;
    push_avalon_stream(nett, stream, push_data_with_error, is_sop, is_eop);
    wait until rising_edge(clk);

    index := index + 1;
  end loop;
end procedure push_frame;

procedure check_frame (signal net : inout network_t;
                        stream : avalon_sink_t;
                        src_ip_addr : std_logic_vector(31 downto 0);
                        src_mac_addr : std_logic_vector(47 downto 0);
                        trg_ip_addr : std_logic_vector(31 downto 0);
                        trg_mac_addr : std_logic_vector(47 downto 0)) is
  variable index : natural range 0 to 2048;
  variable read_data : std_logic_vector(7 downto 0);
  variable v_sop : std_logic;
  variable v_eop : std_logic;
  variable check_data : std_logic_vector(7 downto 0);
begin
  index := 0;
  loop
    pop_avalon_stream(net, stream, read_data, v_sop, v_eop);
    if (index = 0) then
      check_equal(v_sop, '1', "ASO: Sop signal is incorrect");
    end if;
    case index is
      when 00 => check_data := trg_mac_addr(47 downto 40); -- mac dest
      when 01 => check_data := trg_mac_addr(39 downto 32);
      when 02 => check_data := trg_mac_addr(31 downto 24);
      when 03 => check_data := trg_mac_addr(23 downto 16);
      when 04 => check_data := trg_mac_addr(15 downto 08);
      when 05 => check_data := trg_mac_addr(07 downto 00);
      when 06 => check_data := src_mac_addr(47 downto 40);-- mac src
      when 07 => check_data := src_mac_addr(39 downto 32);
      when 08 => check_data := src_mac_addr(31 downto 24);
      when 09 => check_data := src_mac_addr(23 downto 16);
      when 10 => check_data := src_mac_addr(15 downto 08);
      when 11 => check_data := src_mac_addr(07 downto 00);
      when 12 => check_data := x"08"; -- type ARP - 0x0806
      when 13 => check_data := x"06";
      when 14 => check_data := x"00"; -- hardwar type - 0x0001
      when 15 => check_data := x"01"; 
      when 16 => check_data := x"08"; -- protocol type - 0x0800
      when 17 => check_data := x"00"; 

      when 18 => check_data := x"06"; -- hardware size - 0x06
      when 19 => check_data := x"04"; -- protocol size - 0x04

      when 20 => check_data := x"00"; -- opcode - 0x0002 reply
      when 21 => check_data := x"02";
      
      when 22 => check_data := src_mac_addr(47 downto 40); -- sender mac
      when 23 => check_data := src_mac_addr(39 downto 32);
      when 24 => check_data := src_mac_addr(31 downto 24);
      when 25 => check_data := src_mac_addr(23 downto 16);
      when 26 => check_data := src_mac_addr(15 downto 08);
      when 27 => check_data := src_mac_addr(07 downto 00);
      when 28 => check_data := src_ip_addr(31 downto 24); -- sender ip
      when 29 => check_data := src_ip_addr(23 downto 16);
      when 30 => check_data := src_ip_addr(15 downto 08);
      when 31 => check_data := src_ip_addr(07 downto 00);
      when 32 => check_data := trg_mac_addr(47 downto 40); -- target mac
      when 33 => check_data := trg_mac_addr(39 downto 32);
      when 34 => check_data := trg_mac_addr(31 downto 24);
      when 35 => check_data := trg_mac_addr(23 downto 16);
      when 36 => check_data := trg_mac_addr(15 downto 08);
      when 37 => check_data := trg_mac_addr(07 downto 00);
      when 38 => check_data := trg_ip_addr(31 downto 24); -- target ip
      when 39 => check_data := trg_ip_addr(23 downto 16);
      when 40 => check_data := trg_ip_addr(15 downto 08);
      when 41 => check_data := trg_ip_addr(07 downto 00);
      when others => check_data := x"00";
    end case;

    info("ASO: index: " & integer'image(index) & " Value: " & to_hex_string(read_data) & " Should be: " & to_hex_string(check_data));
    check_equal(read_data, check_data, ("ASO: index: " & integer'image(index) & " Value: " & to_hex_string(read_data)));

    if index = 59 then
      check_equal(v_eop, '1', "ASO: Eop signal is incorrect");
      exit;
    end if;
    index := index + 1;
  end loop;
end procedure check_frame;

begin

  arp_service_inst : arp_service
  port map (
    clk => clk,
    rst_n => rst_n,
    asi_data => s_asi_data,
    asi_valid => s_asi_valid,
    asi_ready => s_asi_ready,
    asi_sop => s_asi_sop,
    asi_eop => s_asi_eop,

    aso_data => s_aso_data,
    aso_valid => s_aso_valid,
    aso_ready => s_aso_ready,
    aso_sop => s_aso_sop,
    aso_eop => s_aso_eop
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

  avalon_sink_vc : entity vunit_lib.avalon_sink
    generic map (
      sink => avalon_sink_stream)
    port map (
      clk   => clk,
      valid => s_aso_valid,
      ready => s_aso_ready,
      sop   => s_aso_sop,
      eop   => s_aso_eop,
      data  => s_aso_data
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
      if   run("CORRECT_FRAME_01")
        or run("CORRECT_FRAME_02")
        -- or run("BASE_TEST_03")
        -- or run("WRONG_CRC_01")
        -- or run("WRONG_CRC_02")
      then
        start_stimuli <= true;
        wait until(s_asi_done = true
               and s_aso_done = true
               );
      end if;
    end loop;

    test_runner_cleanup(runner);
  END PROCESS test_runner;
  


  process_asi : process
  begin
    wait until (start_stimuli and rising_edge(clk) and rst_n = '1');

    if running_test_case = "CORRECT_FRAME_01" then
      info("PROCESS_ASI: CORRECT_FRAME_01");
      push_frame(net, avalon_source_stream, x"01020304", x"FFFEFDFCFBFA", IP_ADDR, x"FFFFFFFFFFFF");

    elsif running_test_case = "CORRECT_FRAME_02" then
      info("PROCESS_ASI: CORRECT_FRAME_02");
      push_frame(net, avalon_source_stream, x"01020304", x"FFFEFDFCFBFA", IP_ADDR, x"FFFFFFFFFFFF");
      push_frame(net, avalon_source_stream, x"01020304", x"FFFEFDFCFBFA", IP_ADDR, x"FFFFFFFFFFFF");
    -- elsif running_test_case = "BASE_TEST_03" then
    --   info("PROCESS_ASI: BASE_TEST_03");
    --   push_frame(net, avalon_source_stream, c_frame_t1);
    --   push_frame(net, avalon_source_stream, c_frame_t2);
    -- elsif running_test_case = "WRONG_CRC_01" then
    --   info("PROCESS_ASI: WRONG_CRC_01");
    --   push_frame(net, avalon_source_stream, c_frame_t3);
    -- elsif running_test_case = "WRONG_CRC_02" then
    --   info("PROCESS_ASI: WRONG_CRC_02");
    --   push_frame(net, avalon_source_stream, c_frame_t3);
    --   push_frame(net, avalon_source_stream, c_frame_t2);
    end if;
    info("PROCESS_ASI DONE");
    s_asi_done <= true;
    wait;
  end process;

  process_aso : process
    variable error: std_logic := '1';
  begin
    wait until (start_stimuli and rising_edge(clk) and rst_n = '1');

    if running_test_case = "CORRECT_FRAME_01" then
      info("PROCESS_ASO: CORRECT_FRAME_01");
      check_frame(net, avalon_sink_stream, IP_ADDR, MAC_ADDR, x"01020304", x"FFFEFDFCFBFA");
    elsif running_test_case = "CORRECT_FRAME_02" then
      info("PROCESS_ASO: CORRECT_FRAME_02");
      check_frame(net, avalon_sink_stream, IP_ADDR, MAC_ADDR, x"01020304", x"FFFEFDFCFBFA");
      check_frame(net, avalon_sink_stream, IP_ADDR, MAC_ADDR, x"01020304", x"FFFEFDFCFBFA");
    -- elsif running_test_case = "BASE_TEST_03" then
    --   info("PROCESS_ASO: BASE_TEST_03");
    --   check_frame(net, avalon_sink_stream, c_frame_t1);
    --   check_frame(net, avalon_sink_stream, c_frame_t2);
    -- elsif running_test_case = "WRONG_CRC_01" then
    --   info("PROCESS_ASO: WRONG_CRC_01");
    --   check_frame(net, avalon_sink_stream, c_frame_t3, '1');
    -- elsif running_test_case = "WRONG_CRC_02" then
    --   info("PROCESS_ASO: WRONG_CRC_02");
    --   check_frame(net, avalon_sink_stream, c_frame_t3, '1');
    --   check_frame(net, avalon_sink_stream, c_frame_t2);
    end if;
    info("PROCESS_ASO DONE");
    s_aso_done <= true;
    wait;
  end process;

END ARCHITECTURE tb;
