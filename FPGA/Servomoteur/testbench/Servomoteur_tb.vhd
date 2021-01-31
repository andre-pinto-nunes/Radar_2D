library IEEE;
use IEEE.Std_logic_1164.all;

entity Servomoteur_TEST is
end entity Servomoteur_TEST;

architecture test_bench of Servomoteur_TEST is

signal clk : std_logic;
signal rst : std_logic;
signal position : std_logic_vector(3 downto 0);
signal commande : std_logic;

shared variable simend : boolean := false;
begin

Servomoteur : entity work.Servomoteur port map(clk,rst,position,commande);

clkgen : process
begin
	-- Generation de la clock
	if (simend = false) then
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
	else
		wait;
	end if;

end process ; -- clkgen

test : process
begin
	rst      <= '0';
	position <= "0000";
	wait for 50 ns;


	rst      <= '1';
	wait for 20 ms;

	position <= "0001";
	wait for 30 ms;

	position <= "0101";
	wait for 30 ms;

	position <= "1111";
	wait for 30 ms;

	simend := true;
	wait;
end process ; -- test


end architecture test_bench;