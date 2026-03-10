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

ENTITY crc_checker_tb IS
  generic(runner_cfg : string;
    asi_valid_high_probability : real range 0.0 to 1.0 := 1.0;
    aso_ready_high_probability : real range 0.0 to 1.0 := 1.0);
END ENTITY crc_checker_tb;

ARCHITECTURE tb OF crc_checker_tb IS
  -- avalon stream source
  constant avalon_source_stream : avalon_source_t :=
    new_avalon_source(data_length => 8, valid_high_probability => asi_valid_high_probability);
  constant master_stream : stream_master_t := as_stream(avalon_source_stream);
  -- avalon stream sink 
  constant avalon_sink_stream : avalon_sink_t :=
    new_avalon_sink(data_length => 8, ready_high_probability => aso_ready_high_probability);
  constant slave_stream : stream_slave_t := as_stream(avalon_sink_stream);

  component crc_checker is
    port (
      clk : in std_logic;
      rst_n : in std_logic;
      asi_data : in std_logic_vector  (7 downto 0);
      asi_valid : in std_logic;
      asi_ready : out std_logic;
      asi_sop : in std_logic;
      asi_eop : in std_logic;
      asi_error : in std_logic;
      aso_data : out std_logic_vector  (7 downto 0);
      aso_valid : out std_logic;
      aso_ready : in std_logic;
      aso_sop : out std_logic;
      aso_eop : out std_logic;
      aso_error : out std_logic;
      out_error : out std_logic
    );
  end component crc_checker;

  -- test vector
  type t_array is array(natural range <>) of std_logic_vector;
  -- constant c_frame_t1 : t_array(0 to 23)(7 downto 0) :=  (x"AA", x"AA", x"AA", x"AA", x"AA", x"AA", x"74", x"78", x"27", x"DC", x"55", x"54", x"08", x"00", x"45", x"65",
  --                                                         x"14", x"15", x"16", x"17", x"99", x"D3", x"FE", x"3C");
  constant c_frame_t1 : t_array(0 to 71)(7 downto 0) :=  (x"AA",x"AA",x"AA",x"AA",x"AA",x"AA",x"74",x"78",x"27",x"DC",x"55",x"54",x"08",x"00",x"45",x"65",
                                                          x"00",x"36",x"6F",x"20",x"77",x"6F",x"72",x"6C",x"00",x"00",x"3A",x"28",x"00",x"01",x"02",x"03",
                                                          x"04",x"05",x"06",x"07",x"08",x"09",x"0A",x"0B",x"0C",x"0D",x"0E",x"0F",x"10",x"11",x"12",x"13",
                                                          x"14",x"15",x"16",x"17",x"18",x"19",x"1A",x"1B",x"1C",x"1D",x"1E",x"1F",x"20",x"21",x"22",x"23",
                                                          x"00",x"8F",x"64",x"31",x"DE",x"35",x"BA",x"C6");
  constant c_frame_t2 : t_array(0 to 160)(7 downto 0) :=  (x"33",x"33",x"00",x"01",x"00",x"02",x"e8",x"6a",x"64",x"52",x"c6",x"e5",x"86",x"dd",x"60",x"0c",
                                                          x"26",x"91",x"00",x"67",x"11",x"01",x"fe",x"80",x"00",x"00",x"00",x"00",x"00",x"00",x"ce",x"b9",
                                                          x"ac",x"dd",x"88",x"5f",x"97",x"fe",x"ff",x"02",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                                                          x"00",x"00",x"00",x"01",x"00",x"02",x"02",x"22",x"02",x"23",x"00",x"67",x"d1",x"f6",x"01",x"eb",
                                                          x"c8",x"fc",x"00",x"08",x"00",x"02",x"18",x"9c",x"00",x"01",x"00",x"0e",x"00",x"01",x"00",x"01",
                                                          x"2c",x"e1",x"ba",x"eb",x"e8",x"6a",x"64",x"52",x"c6",x"e5",x"00",x"03",x"00",x"0c",x"0d",x"e8",
                                                          x"6a",x"64",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"27",x"00",x"11",x"00",x"0f",
                                                          x"44",x"45",x"53",x"4b",x"54",x"4f",x"50",x"2d",x"42",x"32",x"4b",x"4e",x"41",x"45",x"4e",x"00",
                                                          x"10",x"00",x"0e",x"00",x"00",x"01",x"37",x"00",x"08",x"4d",x"53",x"46",x"54",x"20",x"35",x"2e",
                                                          x"30",x"00",x"06",x"00",x"08",x"00",x"11",x"00",x"17",x"00",x"18",x"00",x"27",x"C6",x"FC",x"75",x"B4");
  constant c_frame_t3 : t_array(0 to 160)(7 downto 0) :=  (x"33",x"33",x"00",x"01",x"00",x"02",x"e8",x"6a",x"64",x"52",x"c6",x"e5",x"86",x"dd",x"60",x"0c",
                                                          x"26",x"91",x"00",x"67",x"11",x"01",x"fe",x"80",x"00",x"00",x"00",x"00",x"00",x"00",x"ce",x"b9",
                                                          x"ac",x"dd",x"88",x"5f",x"97",x"fe",x"ff",x"02",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
                                                          x"00",x"00",x"00",x"01",x"00",x"02",x"02",x"22",x"02",x"23",x"00",x"67",x"d1",x"f6",x"01",x"eb",
                                                          x"c8",x"fc",x"00",x"08",x"00",x"02",x"18",x"9c",x"00",x"01",x"00",x"0e",x"00",x"01",x"00",x"01",
                                                          x"2c",x"e1",x"ba",x"eb",x"e8",x"6a",x"64",x"52",x"c6",x"e5",x"00",x"03",x"00",x"0c",x"0d",x"e8",
                                                          x"6a",x"64",x"00",x"00",x"00",x"00",x"00",x"01",x"00",x"00",x"00",x"27",x"00",x"11",x"00",x"0f",
                                                          x"44",x"45",x"53",x"4b",x"54",x"4f",x"50",x"2d",x"42",x"32",x"4b",x"4e",x"41",x"45",x"4e",x"00",
                                                          x"10",x"00",x"0e",x"00",x"00",x"01",x"37",x"00",x"08",x"4d",x"53",x"46",x"54",x"20",x"35",x"2e",
                                                          x"30",x"00",x"06",x"00",x"08",x"00",x"11",x"00",x"17",x"00",x"18",x"00",x"27",x"C6",x"FC",x"75",x"B4");                                                        

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
  signal s_aso_error      : std_logic;

  signal s_out_error    : std_logic;

  signal start_stimuli, stimuli_done : boolean := false;


  signal s_asi_done : boolean := false;
  signal s_aso_done : boolean := false;

  procedure push_frame(signal net : inout network_t;
                       stream : avalon_source_t;
                       data_array : t_array) is
    variable index : natural range 0 to 2048;
    variable is_sop : std_logic;
    variable is_eop : std_logic;
  begin
    index := 0;
    loop
      -- set sop and eop
      if index = 0 then
        is_sop := '1';
        is_eop := '0';
      elsif index = data_array'length - 1 then
        is_sop := '0';
        is_eop := '1';
      else
        is_sop := '0';
        is_eop := '0';
      end if;
      -- ending statment
      if index = data_array'length then
        index := 0;
        exit;
      end if;

      push_avalon_stream(net, stream, data_array(index), is_sop, is_eop);

      index := index + 1;
    end loop;
end procedure push_frame;

procedure check_frame (signal net : inout network_t;
                       stream : avalon_sink_t;
                       data_array : t_array;
                       error : std_logic := '0') is
    variable index : natural range 0 to 2048;
    variable read_data : std_logic_vector(7 downto 0);
    variable v_sop: std_logic;
    variable v_eop: std_logic;
  begin
    index := 0;
    loop
      pop_avalon_stream(net, stream, read_data, v_sop, v_eop);
      if(index = 0) then
        check_equal(v_sop, '1', "Sop signal is incorrect");
      end if;
      info("index: " & integer'image(index) & " Value " & to_hex_string(read_data) & " Should be " & to_hex_string(data_array(index)));
      check_equal(read_data, data_array(index), ("index: " & integer'image(index) & " Data " & to_hex_string(read_data)));

      if index = data_array'length - 5 then
        check_equal(v_eop, '1', "Eop signal is incorrect");
        check_equal(s_aso_error, error, "Error signal is incorrect");
        exit;
      end if;
      index := index + 1;
    end loop;
end procedure  check_frame;

begin
  crc_checker_inst : crc_checker
    port map (
      clk      => clk,
      rst_n    => rst_n,
      asi_data => s_asi_data,
      asi_valid => s_asi_valid,
      asi_ready => s_asi_ready,
      asi_sop   => s_asi_sop,
      asi_eop   => s_asi_eop,
      asi_error => '0',
      aso_data  => s_aso_data,
      aso_valid => s_aso_valid,
      aso_ready => s_aso_ready,
      aso_sop   => s_aso_sop,
      aso_eop   => s_aso_eop,
      aso_error => s_aso_error,
      out_error => s_out_error
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
      if   run("BASE_TEST_01")
        or run("BASE_TEST_02")
        or run("BASE_TEST_03")
        or run("WRONG_CRC_01")
        or run("WRONG_CRC_02")
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

    if running_test_case = "BASE_TEST_01" then
      info("PROCESS_ASI: BASE_TEST_01");
      push_frame(net, avalon_source_stream, c_frame_t1);
    elsif running_test_case = "BASE_TEST_02" then
      info("PROCESS_ASI: BASE_TEST_02");
      push_frame(net, avalon_source_stream, c_frame_t2);
    elsif running_test_case = "BASE_TEST_03" then
      info("PROCESS_ASI: BASE_TEST_03");
      push_frame(net, avalon_source_stream, c_frame_t1);
      push_frame(net, avalon_source_stream, c_frame_t2);
    elsif running_test_case = "WRONG_CRC_01" then
      info("PROCESS_ASI: WRONG_CRC_01");
      push_frame(net, avalon_source_stream, c_frame_t3);
    elsif running_test_case = "WRONG_CRC_02" then
      info("PROCESS_ASI: WRONG_CRC_02");
      push_frame(net, avalon_source_stream, c_frame_t3);
      push_frame(net, avalon_source_stream, c_frame_t2);
    end if;
    info("PROCESS_ASI DONE");
    s_asi_done <= true;
    wait;
  end process;

  process_aso : process
    variable error: std_logic := '1';
  begin
    wait until (start_stimuli and rising_edge(clk) and rst_n = '1');

    if running_test_case = "BASE_TEST_01" then
      info("PROCESS_ASO: BASE_TEST_01");
      check_frame(net, avalon_sink_stream, c_frame_t1);
    elsif running_test_case = "BASE_TEST_02" then
      info("PROCESS_ASO: BASE_TEST_02");
      check_frame(net, avalon_sink_stream, c_frame_t2);
    elsif running_test_case = "BASE_TEST_03" then
      info("PROCESS_ASO: BASE_TEST_03");
      check_frame(net, avalon_sink_stream, c_frame_t1);
      check_frame(net, avalon_sink_stream, c_frame_t2);
    elsif running_test_case = "WRONG_CRC_01" then
      info("PROCESS_ASO: WRONG_CRC_01");
      check_frame(net, avalon_sink_stream, c_frame_t3, '1');
    elsif running_test_case = "WRONG_CRC_02" then
      info("PROCESS_ASO: WRONG_CRC_02");
      check_frame(net, avalon_sink_stream, c_frame_t3, '1');
      check_frame(net, avalon_sink_stream, c_frame_t2);
    end if;
    info("PROCESS_ASO DONE");
    s_aso_done <= true;
    wait;
  end process;

END ARCHITECTURE tb;
