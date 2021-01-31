library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity TELEM_MES_tb is
end entity ; -- TELEM_MES_tb

architecture testbench of TELEM_MES_tb is

signal clk : std_logic;
signal rst : std_logic;
signal echo : std_logic;
signal dist : std_logic_vector(7 downto 0);
constant clk_period : time := 20 ns;
shared variable simend : boolean := false;

begin

uut : entity work.TELEM_MES port map(clk,rst,echo,dist);

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
	echo <= '0';
	wait for clk_period;
	rst <= '1';
	wait for clk_period;
	echo <= '1';
	wait for 9420000 ns; --160cm
	echo <= '0';
	wait for 20*clk_period;
	simend := true;
	wait;

end process ; -- clkgen

end architecture ; -- testbench