-- 4-7��������
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity seg is
port (
	data : in std_logic_vector(3 downto 0);
	hex : out std_logic_vector(6 downto 0)
     );
end seg;

architecture behav of seg is

	signal nhex: std_logic_vector(6 downto 0);
	signal a,b,c,d,e,f,g: std_logic;

begin
	process(data)
	begin
	case data is
		when B"0000" => nhex <= B"1111110";
		when B"0001" => nhex <= B"0110000";
		when B"0010" => nhex <= B"1101101";
		when B"0011" => nhex <= B"1111001";
		when B"0100" => nhex <= B"0110011";
		when B"0101" => nhex <= B"1011011";
		when B"0110" => nhex <= B"0011111";
		when B"0111" => nhex <= B"1110000";
		when B"1000" => nhex <= B"1111111";
		when B"1001" => nhex <= B"1110011";
		when B"1010" => nhex <= B"0001101";
		when B"1011" => nhex <= B"0011001";
		when B"1100" => nhex <= B"0100011";
		when B"1101" => nhex <= B"1001011";
		when B"1110" => nhex <= B"0001111";
		when B"1111" => nhex <= B"0000000";
		when others =>
	end case;	
	end process;

	hex(0) <= not nhex(6);
	hex(1) <= not nhex(5);
	hex(2) <= not nhex(4);
	hex(3) <= not nhex(3);
	hex(4) <= not nhex(2);
	hex(5) <= not nhex(1);
	hex(6) <= not nhex(0);
end behav;