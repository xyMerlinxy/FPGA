library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.data_types_context;

library ecdsa;

entity fp_mul_tb is
  generic (runner_cfg : string);
end entity fp_mul_tb;

architecture tb of fp_mul_tb is

  constant WIDTH : integer range 0 to 200     := 192;
  constant MOD_P : integer range 0 to 1048576 := 211;

  -- INTERNAL SIGNALS DECLARATION --
  signal clk   : std_logic := '0';
  signal rst_n : std_logic := '0';

  signal s_o_i_ready : std_logic;
  signal s_i_i_valid : std_logic := '0';
  signal s_i_i_a     : std_logic_vector (WIDTH - 1 downto 0);
  signal s_i_i_b     : std_logic_vector (WIDTH - 1 downto 0);

  signal s_i_o_ready : std_logic := '0';
  signal s_o_o_valid : std_logic;
  signal s_o_o_data  : std_logic_vector (WIDTH - 1 downto 0);

  -- SIMULATION SIGNALS DECLARATION --
  signal start_stimuli, stimuli_done : boolean := false;
  signal push_done, check_done       : boolean := false;

  procedure push_data(
    signal s_ready : in std_logic;
    signal s_valid : out std_logic;
    signal s_a     : out std_logic_vector(WIDTH - 1 downto 0);
    signal s_b     : out std_logic_vector(WIDTH - 1 downto 0);
    data_a         : std_logic_vector(WIDTH - 1 downto 0);
    data_b         : std_logic_vector(WIDTH - 1 downto 0)
  ) is
  begin
    s_valid <= '1';
    s_a     <= data_a;
    s_b     <= data_b;
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
  fp_mul_inst : entity ecdsa.fp_mul
    generic map(
      MOD_P => MOD_P
    )
    port map(
      clk   => clk,
      rst_n => rst_n,

      o_i_ready => s_o_i_ready,
      i_i_valid => s_i_i_valid,
      i_i_a     => s_i_i_a,
      i_i_b     => s_i_i_b,

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
      if run("TEST_1")
        or run("TEST_2")
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

    if running_test_case = "TEST_1" then
      push_data(s_o_i_ready, s_i_i_valid, s_i_i_a, s_i_i_b, x"000000000000000000000000000000000000000000000096", x"0000000000000000000000000000000000000000000000c8");
    elsif running_test_case = "TEST_2" then
      push_data(s_o_i_ready, s_i_i_valid, s_i_i_a, s_i_i_b, x"000000000000000000000000000000000000000000000096", x"0000000000000000000000000000000000000000000000bf");
      push_data(s_o_i_ready, s_i_i_valid, s_i_i_a, s_i_i_b, x"0000000000000000000000000000000000000000000000c8", x"000000000000000000000000000000000000000000000037");
      push_data(s_o_i_ready, s_i_i_valid, s_i_i_a, s_i_i_b, x"000000000000000000000000000000000000000000000000", x"000000000000000000000000000000000000000000000037");
      push_data(s_o_i_ready, s_i_i_valid, s_i_i_a, s_i_i_b, x"0000000000000000000000000000000000000000000000c8", x"000000000000000000000000000000000000000000000000");
      push_data(s_o_i_ready, s_i_i_valid, s_i_i_a, s_i_i_b, x"0000000000000000000000000000000000000000000000c8", x"000000000000000000000000000000000000000000000001");
      push_data(s_o_i_ready, s_i_i_valid, s_i_i_a, s_i_i_b, x"0000000000000000000000000000000000000000000000d2", x"000000000000000000000000000000000000000000000001");
      push_data(s_o_i_ready, s_i_i_valid, s_i_i_a, s_i_i_b, x"0000000000000000000000000000000000000000000000d2", x"0000000000000000000000000000000000000000000000d2");
    end if;

    info("PROCESS_PUSH: " & running_test_case & " DONE");
    push_done <= true;
    wait;
  end process process_push;

  process_check : process
  begin
    wait until (start_stimuli and rising_edge(clk) and rst_n = '1');
    info("PROCESS_CHECK: " & running_test_case);

    if running_test_case = "TEST_1" then
      check_result(s_i_o_ready, s_o_o_valid, s_o_o_data, x"000000000000000000000000000000000000000000000026");
    elsif running_test_case = "TEST_2" then
      check_result(s_i_o_ready, s_o_o_valid, s_o_o_data, x"0000000000000000000000000000000000000000000000a5");
      check_result(s_i_o_ready, s_o_o_valid, s_o_o_data, x"00000000000000000000000000000000000000000000001c");
      check_result(s_i_o_ready, s_o_o_valid, s_o_o_data, x"000000000000000000000000000000000000000000000000");
      check_result(s_i_o_ready, s_o_o_valid, s_o_o_data, x"000000000000000000000000000000000000000000000000");
      check_result(s_i_o_ready, s_o_o_valid, s_o_o_data, x"0000000000000000000000000000000000000000000000c8");
      check_result(s_i_o_ready, s_o_o_valid, s_o_o_data, x"0000000000000000000000000000000000000000000000d2");
      check_result(s_i_o_ready, s_o_o_valid, s_o_o_data, x"000000000000000000000000000000000000000000000001");
    end if;

    info("PROCESS_CHECK: " & running_test_case & " DONE");
    check_done <= true;
    wait;
  end process process_check;

end architecture tb;