library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity servomoteur is
  port (
	clk        : in std_logic;
	rst        : in std_logic;
	address    : in std_logic;
	chipselect : in std_logic;
	write_n    : in std_logic;
	WriteData  : in std_logic_vector(31 downto 0);
	commande   : out std_logic
  ) ;
end entity ; -- servomoteur

architecture behavioural of servomoteur is
signal position : std_logic_vector(31 downto 0);
signal cpt : integer;
signal reset : std_logic;

begin
reset <= not rst;

Avalon : process( clk, reset )
begin
	if reset = '0' then 
		position <= (others => '0');
	elsif rising_edge(clk) then 	
		if (chipselect = '1') and (write_n = '0') then
			position <= WriteData;
		end if; 
	end if; 
end process ; -- Avalon

impulsion : process (clk, reset)
begin
	if reset = '0' then
        
        cpt      <= 0;
        commande <= '0';

	elsif rising_edge(clk) then

        commande <= '1';
		cpt      <= cpt + 1;
	
		if (cpt >= 32000 + (to_integer(unsigned(position)))) then
			commande <= '0';
		end if;

		if (cpt >= 20 * 50000 ) then
			cpt <= 1;
		end if;
	
	end if;
end process ; -- impulsion

end architecture ; -- behavioural