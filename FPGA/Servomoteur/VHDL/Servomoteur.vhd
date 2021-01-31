library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity servomoteur is
  port (
	clk  : in std_logic;
	rst  : in std_logic;
	position : in std_logic_vector(3 downto 0);
	commande : out std_logic
  ) ;
end entity ; -- servomoteur

architecture behavioural of servomoteur is

signal cpt : integer;

begin

impulsion : process (clk, rst)
begin
	if rst = '0' then
        
        cpt      <= 0;
        commande <= '0';

	elsif rising_edge(clk) then

        commande <= '1';
		cpt      <= cpt + 1;
	
		--if (cpt > 32000 + (to_integer(unsigned(position))) * 666 * 5 * 24 / 15) then
		if (cpt >= 32000 + (to_integer(unsigned(position))) * 80000 / 15) then
			commande <= '0';
		end if;

		if (cpt >= 20 * 50000 ) then
			cpt <= 1;
		end if;
	
	end if;
end process ; -- impulsion

end architecture ; -- behavioural