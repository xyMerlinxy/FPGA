library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.data_types_context;

library ecdsa;

entity fp_as_tb is
  generic (runner_cfg : string);
end entity fp_as_tb;
architecture tb of fp_as_tb is

  constant WIDTH : integer range 0 to 200               := 192;
  constant MOD_P : std_logic_vector(WIDTH - 1 downto 0) := x"fffffffffffffffffffffffffffffffeffffffffffffffff";

  -- INTERNAL SIGNALS DECLARATION --
  signal clk   : std_logic := '0';
  signal rst_n : std_logic := '0';

  signal s_o_i_ready     : std_logic;
  signal s_i_i_valid     : std_logic := '0';
  signal s_i_i_operation : std_logic := '0';
  signal s_i_i_a         : std_logic_vector (WIDTH - 1 downto 0);
  signal s_i_i_b         : std_logic_vector (WIDTH - 1 downto 0);

  signal s_i_o_ready : std_logic := '0';
  signal s_o_o_valid : std_logic;
  signal s_o_o_data  : std_logic_vector (WIDTH - 1 downto 0);

  -- SIMULATION SIGNALS DECLARATION --
  signal start_stimuli, stimuli_done : boolean := false;
  signal push_done, check_done       : boolean := false;

  procedure push_data(
    signal s_ready     : in std_logic;
    signal s_valid     : out std_logic;
    signal s_operation : out std_logic;
    signal s_a         : out std_logic_vector(WIDTH - 1 downto 0);
    signal s_b         : out std_logic_vector(WIDTH - 1 downto 0);
    operation          : std_logic;
    data_a             : std_logic_vector(WIDTH - 1 downto 0);
    data_b             : std_logic_vector(WIDTH - 1 downto 0)
  ) is
  begin
    s_valid     <= '1';
    s_operation <= operation;
    s_a         <= data_a;
    s_b         <= data_b;
    wait until (rising_edge(clk) and s_ready = '1');
    s_valid <= '0';
  end procedure push_data;

  procedure check_result(
    signal s_ready : out std_logic;
    signal s_valid : in std_logic;
    signal s_data  : in std_logic_vector(WIDTH - 1 downto 0);
    result         : std_logic_vector(WIDTH - 1 downto 0)
  ) is
  begin
    s_ready <= '1';
    wait until (rising_edge(clk) and s_valid = '1');
    s_ready <= '0';
    check_equal(s_data, result, "MAIN: Result are incorrect");
  end procedure check_result;

begin
  fp_as_inst : entity ecdsa.fp_as
    generic map(
      MOD_P => MOD_P
    )
    port map(
      clk   => clk,
      rst_n => rst_n,

      o_i_ready     => s_o_i_ready,
      i_i_valid     => s_i_i_valid,
      i_i_operation => s_i_i_operation,
      i_i_a         => s_i_i_a,
      i_i_b         => s_i_i_b,

      i_o_ready => s_i_o_ready,
      o_o_valid => s_o_o_valid,
      o_o_data  => s_o_o_data
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
        then
        start_stimuli <= true;
        wait until(push_done = true and check_done = true);
      end if;
    end loop;

    stimuli_done <= true;
    test_runner_cleanup(runner);
  end process test_runner;

  process_push : process
  begin
    wait until (start_stimuli and rising_edge(clk) and rst_n = '1');
    info("PROCESS_PUSH: " & running_test_case);

    if running_test_case = "TEST_ADD" then
      push_data(s_o_i_ready, s_i_i_valid, s_i_i_operation, s_i_i_a, s_i_i_b, '0', x"000000000000000000000000000000000000000000000001", x"000000000000000000000000000000000000000000000002");
      push_data(s_o_i_ready, s_i_i_valid, s_i_i_operation, s_i_i_a, s_i_i_b, '0', x"fffffffffffffffffffffffffffffffefffffffffffffffe", x"000000000000000000000000000000000000000000000002");
      push_data(s_o_i_ready, s_i_i_valid, s_i_i_operation, s_i_i_a, s_i_i_b, '0', x"fffffffffffffffffffffffffffffffefffffffffffffffe", x"fffffffffffffffffffffffffffffffefffffffffffffffe");
    elsif running_test_case = "TEST_SUB" then
      push_data(s_o_i_ready, s_i_i_valid, s_i_i_operation, s_i_i_a, s_i_i_b, '1', x"000000000000000000000000000000000000000000000005", x"000000000000000000000000000000000000000000000002");
      push_data(s_o_i_ready, s_i_i_valid, s_i_i_operation, s_i_i_a, s_i_i_b, '1', x"000000000000000000000000000000000000000000000002", x"000000000000000000000000000000000000000000000005");
      push_data(s_o_i_ready, s_i_i_valid, s_i_i_operation, s_i_i_a, s_i_i_b, '1', x"0dbedd0b90fc2a70d39776af6269fcb71677c02a902cd306", x"2cafdbf2d310fee112143fd367f429619c14d08f215466ff");
    end if;

    info("PROCESS_PUSH: " & running_test_case & " DONE");
    push_done <= true;
    wait;
  end process process_push;

  process_check : process
  begin
    wait until (start_stimuli and rising_edge(clk) and rst_n = '1');
    info("PROCESS_CHECK: " & running_test_case);

    if running_test_case = "TEST_ADD" then
      check_result(s_i_o_ready, s_o_o_valid, s_o_o_data, x"000000000000000000000000000000000000000000000003");
      check_result(s_i_o_ready, s_o_o_valid, s_o_o_data, x"000000000000000000000000000000000000000000000001");
      check_result(s_i_o_ready, s_o_o_valid, s_o_o_data, x"fffffffffffffffffffffffffffffffefffffffffffffffd");
    elsif running_test_case = "TEST_SUB" then
      check_result(s_i_o_ready, s_o_o_valid, s_o_o_data, x"000000000000000000000000000000000000000000000003");
      check_result(s_i_o_ready, s_o_o_valid, s_o_o_data, x"fffffffffffffffffffffffffffffffefffffffffffffffc");
      check_result(s_i_o_ready, s_o_o_valid, s_o_o_data, x"e10f0118bdeb2b8fc18336dbfa75d3547a62ef9b6ed86c06");
    end if;

    info("PROCESS_CHECK: " & running_test_case & " DONE");
    check_done <= true;
    wait;
  end process process_check;

end architecture tb;