-- lfsr based on
-- Table of Linear Feedback Shift Registers
-- Roy Ward, Timothy C.A. Molteno

library ieee;
use ieee.std_logic_1164.all;

entity lfsr_counter is
  generic (
    g_size  : integer                           := 8;
    g_state : std_logic_vector(64 - 1 downto 0) := x"3535353535353535"
  );
  port (
    i_clk     : in std_logic;
    i_rst_n   : in std_logic;
    o_trigger : out std_logic
  );
end entity lfsr_counter;
architecture rtl of lfsr_counter is

  function f_next_state(i_state : std_logic_vector) return std_logic_vector is
    variable v_state              : std_logic_vector(g_size - 1 downto 0);
    variable v_feedback           : std_logic;
  begin
    v_feedback := i_state(0);
    v_state    := i_state;
    case g_size is
      when 2 => v_state(1)   := v_state(1) xor v_feedback;
      when 3 => v_state(2)   := v_state(2) xor v_feedback;
      when 4 => v_state(3)   := v_state(3) xor v_feedback;
      when 5 => v_state(3)   := v_state(3) xor v_feedback;
      when 6 => v_state(5)   := v_state(5) xor v_feedback;
      when 7 => v_state(6)   := v_state(6) xor v_feedback;
      when 8 => v_state(6)   := v_state(6) xor v_feedback;
        v_state(5)             := v_state(5) xor v_feedback;
        v_state(4)             := v_state(4) xor v_feedback;
      when 9  => v_state(5)   := v_state(5) xor v_feedback;
      when 10 => v_state(7)  := v_state(7) xor v_feedback;
      when 11 => v_state(9)  := v_state(9) xor v_feedback;
      when 12 => v_state(11) := v_state(11) xor v_feedback;
        v_state(8)             := v_state(8) xor v_feedback;
        v_state(6)             := v_state(6) xor v_feedback;
      when 13 => v_state(12) := v_state(12) xor v_feedback;
        v_state(10)            := v_state(10) xor v_feedback;
        v_state(9)             := v_state(9) xor v_feedback;
      when 14 => v_state(13) := v_state(13) xor v_feedback;
        v_state(11)            := v_state(11) xor v_feedback;
        v_state(9)             := v_state(9) xor v_feedback;
      when 15 => v_state(14) := v_state(14) xor v_feedback;
      when 16 => v_state(14) := v_state(14) xor v_feedback;
        v_state(13)            := v_state(13) xor v_feedback;
        v_state(11)            := v_state(11) xor v_feedback;
      when 17 => v_state(14) := v_state(14) xor v_feedback;
      when 18 => v_state(11) := v_state(11) xor v_feedback;
      when 19 => v_state(18) := v_state(18) xor v_feedback;
        v_state(17)            := v_state(17) xor v_feedback;
        v_state(14)            := v_state(14) xor v_feedback;
      when 20 => v_state(17) := v_state(17) xor v_feedback;
      when 21 => v_state(19) := v_state(19) xor v_feedback;
      when 22 => v_state(21) := v_state(21) xor v_feedback;
      when 23 => v_state(18) := v_state(18) xor v_feedback;
      when 24 => v_state(23) := v_state(23) xor v_feedback;
        v_state(21)            := v_state(21) xor v_feedback;
        v_state(20)            := v_state(20) xor v_feedback;
      when 25 => v_state(22) := v_state(22) xor v_feedback;
      when 26 => v_state(25) := v_state(25) xor v_feedback;
        v_state(24)            := v_state(24) xor v_feedback;
        v_state(20)            := v_state(20) xor v_feedback;
      when 27 => v_state(26) := v_state(26) xor v_feedback;
        v_state(25)            := v_state(25) xor v_feedback;
        v_state(22)            := v_state(22) xor v_feedback;
      when 28 => v_state(25) := v_state(25) xor v_feedback;
      when 29 => v_state(27) := v_state(27) xor v_feedback;
      when 30 => v_state(29) := v_state(29) xor v_feedback;
        v_state(26)            := v_state(26) xor v_feedback;
        v_state(24)            := v_state(24) xor v_feedback;
      when 31 => v_state(28) := v_state(28) xor v_feedback;
      when 32 => v_state(30) := v_state(30) xor v_feedback;
        v_state(26)            := v_state(26) xor v_feedback;
        v_state(25)            := v_state(25) xor v_feedback;
      when 33 => v_state(20) := v_state(20) xor v_feedback;
      when 34 => v_state(31) := v_state(31) xor v_feedback;
        v_state(30)            := v_state(30) xor v_feedback;
        v_state(26)            := v_state(26) xor v_feedback;
      when 35 => v_state(33) := v_state(33) xor v_feedback;
      when 36 => v_state(25) := v_state(25) xor v_feedback;
      when 37 => v_state(36) := v_state(36) xor v_feedback;
        v_state(33)            := v_state(33) xor v_feedback;
        v_state(31)            := v_state(31) xor v_feedback;
      when 38 => v_state(37) := v_state(37) xor v_feedback;
        v_state(33)            := v_state(33) xor v_feedback;
        v_state(32)            := v_state(32) xor v_feedback;
      when 39 => v_state(35) := v_state(35) xor v_feedback;
      when 40 => v_state(37) := v_state(37) xor v_feedback;
        v_state(36)            := v_state(36) xor v_feedback;
        v_state(35)            := v_state(35) xor v_feedback;
      when 41 => v_state(38) := v_state(38) xor v_feedback;
      when 42 => v_state(40) := v_state(40) xor v_feedback;
        v_state(37)            := v_state(37) xor v_feedback;
        v_state(35)            := v_state(35) xor v_feedback;
      when 43 => v_state(42) := v_state(42) xor v_feedback;
        v_state(38)            := v_state(38) xor v_feedback;
        v_state(37)            := v_state(37) xor v_feedback;
      when 44 => v_state(42) := v_state(42) xor v_feedback;
        v_state(39)            := v_state(39) xor v_feedback;
        v_state(38)            := v_state(38) xor v_feedback;
      when 45 => v_state(44) := v_state(44) xor v_feedback;
        v_state(42)            := v_state(42) xor v_feedback;
        v_state(41)            := v_state(41) xor v_feedback;
      when 46 => v_state(40) := v_state(40) xor v_feedback;
        v_state(39)            := v_state(39) xor v_feedback;
        v_state(38)            := v_state(38) xor v_feedback;
      when 47 => v_state(42) := v_state(42) xor v_feedback;
      when 48 => v_state(44) := v_state(44) xor v_feedback;
        v_state(41)            := v_state(41) xor v_feedback;
        v_state(39)            := v_state(39) xor v_feedback;
      when 49 => v_state(40) := v_state(40) xor v_feedback;
      when 50 => v_state(48) := v_state(48) xor v_feedback;
        v_state(47)            := v_state(47) xor v_feedback;
        v_state(46)            := v_state(46) xor v_feedback;
      when 51 => v_state(50) := v_state(50) xor v_feedback;
        v_state(48)            := v_state(48) xor v_feedback;
        v_state(45)            := v_state(45) xor v_feedback;
      when 52 => v_state(49) := v_state(49) xor v_feedback;
      when 53 => v_state(52) := v_state(52) xor v_feedback;
        v_state(51)            := v_state(51) xor v_feedback;
        v_state(47)            := v_state(47) xor v_feedback;
      when 54 => v_state(51) := v_state(51) xor v_feedback;
        v_state(48)            := v_state(48) xor v_feedback;
        v_state(46)            := v_state(46) xor v_feedback;
      when 55 => v_state(31) := v_state(31) xor v_feedback;
      when 56 => v_state(54) := v_state(54) xor v_feedback;
        v_state(52)            := v_state(52) xor v_feedback;
        v_state(49)            := v_state(49) xor v_feedback;
      when 57 => v_state(50) := v_state(50) xor v_feedback;
      when 58 => v_state(39) := v_state(39) xor v_feedback;
      when 59 => v_state(57) := v_state(57) xor v_feedback;
        v_state(55)            := v_state(55) xor v_feedback;
        v_state(52)            := v_state(52) xor v_feedback;
      when 60 => v_state(59) := v_state(59) xor v_feedback;
      when 61 => v_state(60) := v_state(60) xor v_feedback;
        v_state(59)            := v_state(59) xor v_feedback;
        v_state(56)            := v_state(56) xor v_feedback;
      when 62 => v_state(59) := v_state(59) xor v_feedback;
        v_state(57)            := v_state(57) xor v_feedback;
        v_state(56)            := v_state(56) xor v_feedback;
      when 63 => v_state(62) := v_state(62) xor v_feedback;
      when 64 => v_state(63) := v_state(63) xor v_feedback;
        v_state(61)            := v_state(61) xor v_feedback;
        v_state(60)            := v_state(60) xor v_feedback;
      when others => null;
    end case;

    return v_feedback & v_state(g_size - 1 downto 1);
  end function f_next_state;

  signal r_state   : std_logic_vector(g_size - 1 downto 0) := (others => '1');
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
        r_state   <= (others => '1');
        r_trigger <= '0';
      elsif r_overload = '1' then
        r_state   <= (others => '1');
        r_trigger <= '1';
      else
        r_trigger <= '0';
        r_state   <= f_next_state(r_state);
      end if;

      if i_rst_n = '0' then
        r_overload <= '0';
      elsif r_state = g_state(g_size - 1 downto 0) then
        r_overload <= '1';
      else
        r_overload <= '0';

      end if;
    end if;
  end process MAIN;

  o_trigger <= r_trigger;

end architecture rtl;