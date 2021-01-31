library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity TELEM_TRIG_tb is
end entity ; -- TELEM_TRIG_tb

architecture testbench of TELEM_TRIG_tb is

signal clk : std_logic;
signal rst : std_logic;
signal trig : std_logic;
constant clk_period : time := 20 ns;
shared variable simend : boolean := false;

begin

uut : entity work.TELEM_TRIG port map(clk,rst,trig);

clkgen : process
begin
	-- Generation de la clock
	if (simend = false) then
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	else
		wait;
	end if;

end process ; -- clkgen

siggen : process
begin

	rst <= '0';
	wait for clk_period;
	rst <= '1';
	wait for 250000000 ns;
	simend := true;
	wait;

end process ; -- clkgen

end architecture ; -- testbench