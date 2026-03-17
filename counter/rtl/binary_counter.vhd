library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_counter is
  generic (
    g_size    : integer                           := 8;
    g_counter : std_logic_vector(64 - 1 downto 0) := x"3535353535353535"
  );
  port (
    i_clk     : in std_logic;
    i_rst_n   : in std_logic;
    o_trigger : out std_logic
  );
end entity binary_counter;
architecture rtl of binary_counter is
  constant c_temp : std_logic_vector(64 - 1 downto 0) := std_logic_vector(unsigned(g_counter) - 2);

  signal r_state   : std_logic_vector(g_size - 1 downto 0) := (others => '0');
  signal r_trigger : std_logic;

  signal r_overload : std_logic;
begin
  -- check g_size
  assert g_size >= 2 and g_size <= 64
  report "g_size must be between 2 and 64"
    severity failure;
  MAIN : process (i_clk) is begin
    if rising_edge(i_clk) then
      if i_rst_n = '0' then
        r_state   <= (others => '0');
        r_trigger <= '0';
      elsif r_overload = '1' then
        r_state   <= (others => '0');
        r_trigger <= '1';
      else
        r_trigger <= '0';
        r_state   <= std_logic_vector(unsigned(r_state) + 1);
      end if;

      if i_rst_n = '0' then
        r_overload <= '0';
      elsif r_state = c_temp(g_size - 1 downto 0) then
        r_overload <= '1';
      else
        r_overload <= '0';

      end if;
    end if;
  end process MAIN;

  o_trigger <= r_trigger;

end architecture rtl;