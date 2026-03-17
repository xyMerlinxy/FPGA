library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
use vunit_lib.run_pkg.all;
use vunit_lib.check_pkg.all;

library lib_counter;
library lib_counter_tb;
use lib_counter_tb.test_utility_pkg.all;

entity binary_counter_tb is
  generic (
    runner_cfg : string;
    g_steps    : integer;
    g_size     : integer;
    g_counter  : string
  );
end entity binary_counter_tb;

architecture tb of binary_counter_tb is
  constant c_clk_period : time := 10 ns;

  constant c_counter : std_logic_vector(64 - 1 downto 0) := bin_to_slv(g_counter);

  signal sim_start  : boolean := false;
  signal reset_done : boolean := false;
  signal basic_done : boolean := false;

  signal s_i_clk     : std_logic := '0';
  signal s_i_rst_n   : std_logic := '0';
  signal s_o_trigger : std_logic;
begin

  binary_counter_inst : entity lib_counter.binary_counter
    generic map(
      g_size    => g_size,
      g_counter => c_counter
    )
    port map(
      i_clk     => s_i_clk,
      i_rst_n   => s_i_rst_n,
      o_trigger => s_o_trigger
    );

  s_i_clk <= not s_i_clk after c_clk_period / 2;

  MAIN : process is
  begin
    test_runner_setup(runner, runner_cfg);

    if run("test_basic") or
      run("test_reset") then

      sim_start <= true;
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
      for i in 0 to 5 - 1 loop
        wait until rising_edge(s_i_clk);
      end loop;
      s_i_rst_n <= '0';
      wait until rising_edge(s_i_clk);
      s_i_rst_n <= '1';
    end if;

    reset_done <= true;
    wait;
  end process RESET;

  BASIC : process is
  begin
    wait until sim_start;
    wait until s_i_rst_n = '1' and rising_edge(s_i_clk);
    wait until rising_edge(s_i_clk);

    if running_test_case = "test_basic" then
      for j in 0 to 10 - 1 loop
        -- wait for trigger
        for i in 0 to g_steps - 2 loop
          check_equal(s_o_trigger, '0', "trigger should be down");
          wait until rising_edge(s_i_clk);
        end loop;
        -- check trigger
        check_equal(s_o_trigger, '1', "trigger should be up");
        wait until rising_edge(s_i_clk);
      end loop;

    elsif running_test_case = "test_reset" then
      -- wait for reset
      while not reset_done loop
        check_equal(s_o_trigger, '0', "trigger should be down");
        wait until rising_edge(s_i_clk);
      end loop;
      wait until rising_edge(s_i_clk);

      for j in 0 to 10 - 1 loop
        -- wait for trigger
        for i in 0 to g_steps - 2 loop
          check_equal(s_o_trigger, '0', "trigger should be down");
          wait until rising_edge(s_i_clk);
        end loop;
        -- check trigger
        check_equal(s_o_trigger, '1', "trigger should be up");
        wait until rising_edge(s_i_clk);
      end loop;
    end if;

    basic_done <= true;
    wait;
  end process BASIC;

end architecture tb;