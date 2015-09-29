--Í¬²½¸´Î» 
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity syreset is
port (
	clk   : in std_logic;
	rstin : in std_logic;
	rstout : out std_logic
     );
end syreset;

architecture behav of syreset is

	signal sft: std_logic_vector(2 downto 0);

begin
	process(clk)
	begin
		if clk'event and clk = '1' then
			rstout <= sft(2);
			sft(2) <= sft(1);
			sft(1) <= sft(0);
			sft(0) <= rstin;
		end if;
	end process;

end behav;