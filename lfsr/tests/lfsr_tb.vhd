library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library vunit_lib;
context vunit_lib.vunit_context;

library lib_lfsr;

library lib_lfsr_tb;
use lib_lfsr_tb.test_utility_pkg.all;

entity lfsr_tb is
  generic (
    runner_cfg : string;
    g_size     : integer;
    g_seed     : string;
    g_steps    : integer;
    g_output   : string
  );
end entity lfsr_tb;

architecture tb of lfsr_tb is
  constant c_clk_period : time := 10 ns;

  constant c_zeros           : std_logic_vector(64 - 1 downto 0)     := (others => '0');
  constant c_in_seed         : std_logic_vector(64 - 1 downto 0)     := c_zeros(64 - 1 downto g_size) & bin_to_slv(g_seed);
  constant c_expected_output : std_logic_vector(g_size - 1 downto 0) := bin_to_slv(g_output);

  signal sim_start  : boolean := false;
  signal reset_done : boolean := false;
  signal basic_done : boolean := false;

  signal s_i_clk   : std_logic := '0';
  signal s_i_rst_n : std_logic := '0';
  signal s_o_state : std_logic_vector(g_size - 1 downto 0);
begin

  lfsr_inst : entity lib_lfsr.lfsr
    generic map(
      g_size => g_size,
      g_seed => c_in_seed
    )
    port map(
      i_clk   => s_i_clk,
      i_rst_n => s_i_rst_n,
      o_data  => open,
      o_state => s_o_state
    );

  s_i_clk <= not s_i_clk after c_clk_period / 2;

  MAIN : process is
  begin
    test_runner_setup(runner, runner_cfg);

    if run("test_basic") or
      run("test_reset") then

      sim_start <= true;
      report runner_cfg;
      report running_test_case;
      wait until reset_done and basic_done;
      test_runner_cleanup(runner);
      wait;
    end if;

  end process MAIN;

  RESET : process is
  begin
    wait until sim_start;
    wait until rising_edge(s_i_clk);
    wait until rising_edge(s_i_clk);

    s_i_rst_n <= '1';
    wait until rising_edge(s_i_clk);

    if running_test_case = "test_reset" then
      for i in 0 to g_steps - 1 loop
        wait until rising_edge(s_i_clk);
      end loop;
      s_i_rst_n <= '0';
      wait until rising_edge(s_i_clk);
      s_i_rst_n <= '1';
      wait until rising_edge(s_i_clk);
      check_equal(s_o_state, c_in_seed(g_size - 1 downto 0), "state after reset should equal seed");
    end if;

    reset_done <= true;
    wait;
  end process RESET;

  BASIC : process is
  begin
    wait until sim_start;
    wait until s_i_rst_n = '1' and rising_edge(s_i_clk);

    if running_test_case = "test_basic" then
      for i in 0 to g_steps - 1 loop
        wait until rising_edge(s_i_clk);
      end loop;
      check_equal(s_o_state, c_expected_output, "state after steps should equal expected output");
    elsif running_test_case = "test_reset" then
      for i in 0 to g_steps - 1 + 1 loop
        wait until rising_edge(s_i_clk);
      end loop;
      for i in 0 to g_steps - 1 + 1 loop
        wait until rising_edge(s_i_clk);
      end loop;
      check_equal(s_o_state, c_expected_output, "state after steps should equal expected output");
    end if;

    basic_done <= true;
    wait;
  end process BASIC;

end architecture tb;