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

entity fp_as_tb is
  generic (runner_cfg : string);
end entity fp_as_tb;
architecture tb of fp_as_tb is

  constant WIDTH : integer range 0 to 200               := 192;
  constant MOD_P : std_logic_vector(WIDTH - 1 downto 0) := x"fffffffffffffffffffffffffffffffeffffffffffffffff";

  component fp_as
    generic (
      MOD_P : std_logic_vector(WIDTH - 1 downto 0)
    );
    port (
      clk         : in std_logic;
      rst_n       : in std_logic;
      i_data_a    : in std_logic_vector (WIDTH - 1 downto 0);
      i_data_b    : in std_logic_vector (WIDTH - 1 downto 0);
      i_data_wr   : in std_logic;
      i_operation : in std_logic;
      o_data      : out std_logic_vector (WIDTH - 1 downto 0);
      o_valid     : out std_logic
    );
  end component;

  -- INTERNAL SIGNALS DECLARATION --
  signal clk   : std_logic := '0';
  signal rst_n : std_logic := '0';

  signal s_i_data_a    : std_logic_vector (WIDTH - 1 downto 0);
  signal s_i_data_b    : std_logic_vector (WIDTH - 1 downto 0);
  signal s_i_data_wr   : std_logic := '0';
  signal s_o_data      : std_logic_vector (WIDTH - 1 downto 0);
  signal s_o_valid     : std_logic;
  signal s_i_operation : std_logic := '0';

  signal start_stimuli, stimuli_done : boolean := false;
  signal main_done                   : boolean := false;

  procedure check_result(
    signal s_data_a  : out std_logic_vector(WIDTH - 1 downto 0);
    signal s_data_b  : out std_logic_vector(WIDTH - 1 downto 0);
    signal s_data_wr : out std_logic;
    data_a           : std_logic_vector(WIDTH - 1 downto 0);
    data_b           : std_logic_vector(WIDTH - 1 downto 0);
    result           : std_logic_vector(WIDTH - 1 downto 0)
  ) is
  begin
    s_data_a  <= data_a;
    s_data_b  <= data_b;
    s_data_wr <= '1';
    wait until (rising_edge(clk));
    s_data_wr <= '0';
    wait until (rising_edge(clk) and s_o_valid = '1');
    check_equal(s_o_data, result, "MAIN: Result are incorrect");
  end procedure check_result;

begin
  fp_as_inst : fp_as
  generic map(
    MOD_P => MOD_P
  )
  port map(
    clk         => clk,
    rst_n       => rst_n,
    i_data_a    => s_i_data_a,
    i_data_b    => s_i_data_b,
    i_operation => s_i_operation,
    i_data_wr   => s_i_data_wr,
    o_data      => s_o_data,
    o_valid     => s_o_valid
  );

  process_clk : process
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

  test_runner : process
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("TEST_ADD")
        or run("TEST_SUB")
        -- or run("BASE_TEST_03")
        -- or run("WRONG_CRC_01")
        -- or run("WRONG_CRC_02")
        then
        start_stimuli <= true;
        wait until(main_done = true);
      end if;
    end loop;

    stimuli_done <= true;
    test_runner_cleanup(runner);
  end process test_runner;

  process_main : process
    variable result : std_logic_vector (WIDTH - 1 downto 0);
  begin
    wait until (start_stimuli and rising_edge(clk) and rst_n = '1');

    if running_test_case = "TEST_ADD" then
      info("PROCESS_MAIN: TEST_ADD");
      check_result(s_i_data_a, s_i_data_b, s_i_data_wr, x"000000000000000000000000000000000000000000000001", x"000000000000000000000000000000000000000000000002", x"000000000000000000000000000000000000000000000003");
      check_result(s_i_data_a, s_i_data_b, s_i_data_wr, x"fffffffffffffffffffffffffffffffefffffffffffffffe", x"000000000000000000000000000000000000000000000002", x"000000000000000000000000000000000000000000000001");
      info("PROCESS_MAIN: TEST_ADD DONE");

    elsif running_test_case = "TEST_SUB" then
      info("PROCESS_MAIN: TEST_SUB");
      s_i_operation <= '1';
      check_result(s_i_data_a, s_i_data_b, s_i_data_wr, x"000000000000000000000000000000000000000000000002", x"000000000000000000000000000000000000000000000005", x"fffffffffffffffffffffffffffffffefffffffffffffffc");
      check_result(s_i_data_a, s_i_data_b, s_i_data_wr, x"0dbedd0b90fc2a70d39776af6269fcb71677c02a902cd306", x"2cafdbf2d310fee112143fd367f429619c14d08f215466ff", x"e10f0118bdeb2b8fc18336dbfa75d3547a62ef9b6ed86c06");
      info("PROCESS_MAIN: TEST_SUB DONE");
    end if;
    main_done <= true;
    wait;
  end process;

end architecture tb;