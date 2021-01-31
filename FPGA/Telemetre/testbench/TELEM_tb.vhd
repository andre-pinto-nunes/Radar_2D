library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity TELEM_tb is
end entity ; -- TELEM_tb

architecture testbench of TELEM_tb is

signal clk  : std_logic;
signal rst  : std_logic;
signal echo : std_logic;
signal trig : std_logic;
signal dist : std_logic_vector(7 downto 0);
constant clk_period : time := 20 ns;

begin

uut : entity work.TELEM port map(clk,rst,echo,trig,dist);

clkgen : process
begin
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
end process ; -- clkgen

siggen : process
begin

	rst <= '0';
	echo <= '0';
	wait for clk_period;
	rst <= '1';
	wait for 11000 ns; --au moins 10 us
	echo <= '1';
	wait for 9411800 ns; --161cm
	echo <= '0';
	wait for 20*clk_period;
	wait;

end process ; -- siggen


end architecture ; -- testbench