library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity Read_data is

  port (
    CLK, RST_N  : in  std_logic;
    DATA : out std_logic_vector(31 downto 0);
	END_SIM, RESULT_AVAILABLE : out std_logic);

end Read_data;

architecture Behavior of Read_data is

	constant Ts : time := 10 ns; -- clock period
	constant tco: time := 1 ns; -- propagation delay

begin

  process (CLK, RST_N)

    file fp : text open read_mode is "data_files/fp_samples.hex";
    variable read_buf : line;
    variable sample : std_logic_vector(31 downto 0);

  begin

  if RST_N = '0' then
	END_SIM <= '0';
	RESULT_AVAILABLE <= '0';
  elsif CLK'event and CLK = '1' then
      if (not(endfile(fp))) then
        readline(fp, read_buf);
        hread(read_buf, sample); -- hread to read hex values
		  DATA <= sample after tco;
		  RESULT_AVAILABLE <= '1' after tco+6*Ts; -- latency
		  END_SIM <= '0';
	  else
		END_SIM <= '1' after tco+6*Ts; -- latency
		RESULT_AVAILABLE <= '0' after tco+6*Ts; -- latency

      end if;

    end if;

  end process;

end Behavior;
