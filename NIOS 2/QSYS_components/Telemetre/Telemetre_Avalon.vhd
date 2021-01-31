library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity AVALON is
  port (
        avalon_clk          : in  std_logic;
        avalon_rst          : in  std_logic;
        avalon_echo         : in  std_logic;
        avalon_read         : in  std_logic;
        avalon_chipselect   : in  std_logic;
        avalon_trig         : out std_logic;
        avalon_readdata     : out std_logic_vector(7 downto 0);
        avalon_led          : out std_logic_vector(7 downto 0)
  ) ;
end entity ; -- AVALON

architecture behavioural of AVALON is
-- TELEM
signal dist : std_logic_vector(7 downto 0);
signal reset : std_logic;

-- TRIG
constant clk_period : integer := 20;                        -- Periode de la clock 50MHz en nanosecondes
signal   cpt_trig   : integer range 0 to 501;               -- Compteur de 500 periodes de 20ns => 10us (durée minimale du trigger)
signal   cpt_120ms  : integer range 0 to 6000001;           -- Compteur de 6 000 000 periodes => declenchement d'une mesures toutes les 0.12 secondes
signal   trig_sig   : std_logic;                            -- Trigger

-- MES
signal temp : unsigned (31 downto 0);
signal cpt : integer;

begin
reset <= not avalon_rst;
avalon_led <= dist;
avalon_trig <= trig_sig;


triggen : process( avalon_clk, reset )
begin

    -- Si reset = 0  <=> si on appuie sur le button KEY0
    if reset = '0' then
        trig_sig <= '0';                                -- Mise a zero des variables
        cpt_trig <= 0;                                  --
        cpt_120ms <= 0;                                 --
    elsif rising_edge(avalon_clk) then

        -- On laisse le compteur à 0 le temps de générer l'impulsion
        if cpt_120ms = 0 then
            if cpt_trig < 500 then                      -- 'trig_sig' vaut 1 pendant les premieres 10 us ( cpt_trig < 500 )
                trig_sig   <= '1';
                cpt_trig   <= cpt_trig + 1;
            else                                        -- Apres les 10 us, 'trig_sig' passe a zero et 'cpt_120ms' passe a 1
                cpt_trig   <= 0 ;
                trig_sig   <='0';
                cpt_120ms <= 1 ;
            end if ;
        
        -- Quand 'cpt_120ms' passe a 1, on l'incremente a chaque front montant
        else
            if cpt_120ms < 5999999 then
                cpt_120ms <= cpt_120ms + 1;
                trig_sig <= '0';
            else                                        -- Quand 'cpt_120ms' depasse 5999999, on le remet a zero pour envoyer un autre trigger
                cpt_120ms <= 0;
            end if ;
        end if ;
    end if ;
end process ; -- Process Trigger

count : process( avalon_clk,reset )
begin

    if reset = '0' then
        cpt <= 0;                 -- Mise a zero des variables
        temp <= (others => '0');  --


    -- Si on appuie sur le button KEY0
    elsif rising_edge(avalon_clk) then
			if avalon_chipselect = '1' and avalon_read = '1' then
				avalon_readdata <= dist;    
			end if;
        -- Tant que 'avalon_echo' vaut 1, on compte les fronts montants
        if avalon_echo = '1' then                                              
            cpt <= cpt + 1;
            -- Distance = nb_de_periodes x periode x vitesse_du_son / 2 
            temp <= to_unsigned(cpt * clk_period * 17 / 1000000,32);    
        else
            dist <= std_logic_vector(temp(7 downto 0));
            cpt <= 0;                                                   
        end if ;
    end if ;
end process ; -- Process Mesure



end architecture ; -- behavioural
