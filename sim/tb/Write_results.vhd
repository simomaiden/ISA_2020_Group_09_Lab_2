library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity Write_results is

  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    RESULT_AVAILABLE   : in std_logic;
    OUT_MPY   : in std_logic_vector(31 downto 0));

end Write_results;

architecture Behavior of Write_results is

begin

  process (CLK, RST_n)
    file results_fp : text open WRITE_MODE is "data_files/results_vhdl.txt";
    variable line_buf : line;
  begin
    if RST_n = '0' then
      null;
    elsif CLK'event and CLK = '1' then  -- each output sample is stored in file
      if (RESULT_AVAILABLE = '1') then -- wait for the correct latency before writing
        hwrite(line_buf, OUT_MPY);  -- hwrite to write hex values
        writeline(results_fp, line_buf);
      end if;
    end if;
  end process;

end Behavior;
