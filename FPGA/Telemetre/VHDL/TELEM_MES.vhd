library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

--Calcule la distance en cm grace au signal d'entree echo

entity TELEM_MES is
  port (
	clk  : in std_logic;
	rst  : in std_logic;
	echo : in std_logic;
	dist : out std_logic_vector(7 downto 0) --distance cm
  ) ;
end entity ; -- TELEM_MES

architecture behavioural of TELEM_MES is

signal temp : unsigned (31 downto 0);
signal cpt : integer;
constant clk_period : integer := 20; --ns

begin


count : process( clk,rst )
begin

    if rst = '0' then
        cpt <= 0;                 -- Mise a zero des variables
        temp <= (others => '0');  --


    -- Si on appuie sur le button KEY0
    elsif rising_edge(clk) then
        -- Tant que 'echo' vaut 1, on compte les fronts montants
        if echo = '1' then												
            cpt <= cpt + 1;
            -- Distance = nb_de_periodes x periode x vitesse_du_son / 2 
            temp <= to_unsigned(cpt * clk_period * 17 / 1000000,32);	
        else
            dist <= std_logic_vector(temp(7 downto 0));
            cpt <= 0;													
        end if ;
    end if ;
end process ; -- count

end architecture ; -- behavioural