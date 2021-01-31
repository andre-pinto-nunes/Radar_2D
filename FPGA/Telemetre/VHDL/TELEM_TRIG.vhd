library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

--Génère des impulsions régulières de 10us espacées de 1.2s

entity TELEM_TRIG is
  port (
	clk  : in std_logic;
	rst  : in std_logic;
	trig : out std_logic
  ) ;
end entity ; -- TELEM_TRIG

architecture behavioural of TELEM_TRIG is

constant clk_period : integer := 20; 					-- Periode de la clock 50MHz en nanosecondes
signal cpt_trig : integer range 0 to 501; 				-- Compteur de 500 periodes de 20ns => 10us (durée minimale du trigger)
signal cpt_120ms : integer range 0 to 6000001;        -- Compteur de 6 000 000 periodes => declenchement d'une mesures toutes les 0.12 secondes
signal trig_sig : std_logic;							-- Trigger

begin

trig <= trig_sig;

triggen : process( clk, rst )
begin

	-- Si reset = 0  <=> si on appuie sur le button KEY0
	if rst = '0' then
		trig_sig <= '0';								-- Mise a zero des variables
		cpt_trig <= 0;									--
		cpt_120ms <= 0;									--
	elsif rising_edge(clk) then

		-- On laisse le compteur à 0 le temps de générer l'impulsion
		if cpt_120ms = 0 then
			if cpt_trig < 500 then						-- 'trig_sig' vaut 1 pendant les premieres 10 us ( cpt_trig < 500 )
				trig_sig   <= '1';
				cpt_trig   <= cpt_trig + 1;
			else    									-- Apres les 10 us, 'trig_sig' passe a zero et 'cpt_120ms' passe a 1
				cpt_trig   <= 0 ;
				trig_sig   <='0';
				cpt_120ms <= 1 ;
			end if ;
		
		-- Quand 'cpt_120ms' passe a 1, on l'incremente a chaque front montant
		else
			if cpt_120ms < 5999999 then
				cpt_120ms <= cpt_120ms + 1;
				trig_sig <= '0';
			else 										-- Quand 'cpt_120ms' depasse 5999999, on le remet a zero pour envoyer un autre trigger
				cpt_120ms <= 0;
			end if ;
		end if ;
	end if ;
end process ; -- triggen

end architecture ; -- behavioural