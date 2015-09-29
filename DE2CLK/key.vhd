-- 10ms 按键防抖动处理电路，适用于所有经用户手动输入的拨动开关或者按键
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity key is
port (
	clk   : in std_logic;
	clkms : in std_logic;
	pressin : in std_logic;
	pressout : out std_logic
     );
end key;

architecture behav of key is

	signal div : std_logic_vector(14 downto 0);
	signal sft: std_logic_vector(9 downto 0);

begin
	process(clk)
	begin
	if clk'event and clk = '1' then
		if clkms = '1' then
			sft(9) <= sft(8);
			sft(8) <= sft(7);
			sft(7) <= sft(6);
			sft(6) <= sft(5);
			sft(5) <= sft(4);
			sft(4) <= sft(3);
			sft(3) <= sft(2);
			sft(2) <= sft(1);
			sft(1) <= sft(0);
			sft(0) <= pressin;
		end if;
	end if;
	end process;

	process(clk)
	begin
	if clk'event and clk = '1' then
		if sft(9 downto 0) = B"1111111111" then
			pressout <= '1';
		elsif sft(9 downto 0) = B"0000000000" then
			pressout <= '0';
		end if;
	end if;
	end process;

end behav;