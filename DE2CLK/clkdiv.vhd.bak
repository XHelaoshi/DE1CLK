-- 时钟分频到秒脉冲和毫秒脉冲，成为单脉冲使能
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clkdiv is
port (
	clk   : in std_logic;
	clkms: out std_logic;
	clks: out std_logic
     );
end clkdiv;

architecture behav of clkdiv is

	signal divms : std_logic_vector(14 downto 0);
	signal divs: std_logic_vector(8 downto 0);
	signal clkms_s: std_logic;

begin
	process(clk)
	begin
	if clk'event and clk = '1' then
		if divms(11 downto 0) = B"110101" then--14,3,110000110101
			divms <= (others => '0');
		else
			divms <= divms +1;
		end if;
	end if;
	end process;

	process(clk)
	begin
	if clk'event and clk = '1' then
		if divms(11 downto 0) = B"110101" then--14,3,110000110101
			clkms_s <= '1';
		else
			clkms_s <= '0';
		end if;
	end if;
	end process;

	process(clk)
	begin
	if clk'event and clk = '1' then
		clkms <= clkms_s;	
	end if;
	end process;

	process(clk)
	begin
	if clk'event and clk = '1' then
		if clkms_s = '1' then
			if divs(8 downto 2) = B"1111101" then
				divs <= (others => '0');
			else
				divs <= divs +1;
			end if;
		end if;
	end if;
	end process;

	process(clk)
	begin
	if clk'event and clk = '1' then
		if clkms_s = '1' then
			if divs(8 downto 2) = B"1111101" then
				clks <= '1';
			else
				clks <= '0';
			end if;
		end if;
	end if;
	end process;

end behav;