library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

--Permet de communiquer avec le capteur.
	--envoie le signal trig au capteur
	--recoit le signal echo du capteur (reponse du capteur a trig)
	--envoie la distance en cm

entity TELEM is
  port (
	clk, rst : in std_logic;
	echo : in std_logic;
	trig : out std_logic;
	dist : out std_logic_vector(7 downto 0)
  ) ;
end entity ; -- TELEM

architecture struct of TELEM is

begin

trigGen : entity work.TELEM_TRIG port map (
                                clk  => clk,
								rst  => rst,
								trig => trig
);

distMes : entity work.TELEM_MES port map  (
                                clk  => clk,
								rst  => rst,
								echo => echo,
								dist => dist
);
end architecture ; -- struct