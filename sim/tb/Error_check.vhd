library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity Error_check is

  port (MPY_OUT : in std_logic_vector(31 downto 0);
        CLK, RST_n, RESULT_AVAILABLE : in std_logic);

end Error_check;

architecture Behavior of Error_check is

begin

  process (CLK, RST_n)

    file errors_fp : text open WRITE_MODE is "data_files/error_check.txt";
    file results_prod_fp : text open READ_MODE is "data_files/fp_prod.hex";
    variable error_buf : line; -- to write the error file
    variable results_prod_buf : line;
    variable y_prod: std_logic_vector(31 downto 0); -- to store read result

  begin

    if RST_n = '0' then
      null;
    elsif CLK'event and CLK = '1' then  -- each mpy output sample is read and compared
      if (RESULT_AVAILABLE = '1') then   -- wait for the correct latency before starting the comparison
        if not endfile(results_prod_fp) then
            readline(results_prod_fp, results_prod_buf);
            hread(results_prod_buf, y_prod);

            if MPY_OUT = y_prod then
              write(error_buf, String'("Correct result"));
            else
              write(error_buf, String'("Wrong result:   expected "));
              hwrite(error_buf, y_prod);
              write(error_buf, String'("   obtained "));
              hwrite(error_buf, MPY_OUT);

            end if;
            writeline(errors_fp, error_buf);
        end if;
      end if;
    end if;
  end process;

end Behavior;
