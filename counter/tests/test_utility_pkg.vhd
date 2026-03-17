library ieee;
use ieee.std_logic_1164.all;

package test_utility_pkg is
    function bin_to_slv(bin : string) return std_logic_vector;
end package test_utility_pkg;

package body test_utility_pkg is
    function bin_to_slv(bin : string) return std_logic_vector is
        variable result         : std_logic_vector(bin'length - 1 downto 0);
    begin
        for i in bin'range loop
            if bin(i) = '1' then
                result(bin'length - i) := '1';
            else
                result(bin'length - i) := '0';
            end if;
        end loop;
        return result;
    end function bin_to_slv;
end package body test_utility_pkg;