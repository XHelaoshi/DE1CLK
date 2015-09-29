library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dclk is
port (
	rst   : in std_logic;
	clk   : in std_logic;
--	set   : in std_logic;-- enter set mode
--	mode  : in std_logic;-- set date,hours,min,sec etc.
	seccnthh : out std_logic_vector(3 downto 0);
	seccntll : out std_logic_vector(3 downto 0);
	mincnthh : out std_logic_vector(3 downto 0);
	mincntll : out std_logic_vector(3 downto 0);
	houcnthh : out std_logic_vector(3 downto 0);
	houcntll : out std_logic_vector(3 downto 0)
     );
end dclk;

architecture behav of dclk is

    constant s0 :std_logic_vector(2 downto 0):= "000";
    constant s1 :std_logic_vector(2 downto 0):= "001";
    constant s2 :std_logic_vector(2 downto 0):= "011";
    constant s3 :std_logic_vector(2 downto 0):= "010";
    constant s4 :std_logic_vector(2 downto 0):= "110";
    constant s5 :std_logic_vector(2 downto 0):= "111";
    constant s6 :std_logic_vector(2 downto 0):= "101";
    constant s7 :std_logic_vector(2 downto 0):= "100";

	signal ss: std_logic_vector(2 downto 0);
	signal seccnth,seccntl,mincnth,mincntl,houcnth,houcntl,daycnth,daycntl,monthcnth,monthcntl :std_logic_vector(3 downto 0);
	signal secoc,minoc,houoc :std_logic;

begin

	seccnthh <= seccnth;
	seccntll <= seccntl;
	mincnthh <= mincnth;
	mincntll <= mincntl;
	houcnthh <= houcnth;
	houcntll <= houcntl;
	process(rst,clk)
	begin
		if rst = '1' then
			ss <= s0;
		elsif clk'event and clk = '1' then
			case ss is 
				when s0 => -- for 31days' month
					if monthcnth = 0 then
						if monthcntl = 1 or monthcntl = 3 or monthcntl = 5 or monthcntl = 7 or monthcntl = 8 then
							ss <= s1;
						end if;
					else 
						if monthcntl = 0 or monthcntl = 2 then
							ss <= s1;
						end if;
					end if;
				when s1 => --for 30days' month
					if monthcnth = 0 then
						if monthcntl = 2 or monthcntl = 4 or monthcntl = 6 or monthcntl = 9 then
							ss <= s0;
						end if;
					else 
						if monthcntl = 1 then
							ss <= s0;
						end if;
					end if;
				when others =>
					ss <= s0;
			end case;
		end if;
	end process;
	
	process(rst,clk)
	begin
	if rst = '1' then
		monthcntl <= "1";
		monthcnth <= "0";
		daycntl <= "1";
		daycnth <= "0";
	elsif clk'event and clk = '1' then
		if ss = s0 then --31days
			if daycnth = 3 and daycntl = 1 then
				daycntl <= 1;
				daycnth <= 0;
				monthcntl <= monthl + 1;
			elsif daycntl = 9 then
				daycnth <= daycnth + 1;
				daycntl <= 0;
			else
				daycntl <= daycntl + 1;
			end if;
			if monthcnth = 1 and monthcntl = 2 then
				monthcnth <= 0;
				monthcntl <= 1;
			end if;
		elsif ss = s1 then--30days
			if daycnth = 3 and daycntl = 0 then
				daycntl <= 1;
				daycnth <= 0;
				monthl <= monthl + 1;
			elsif daycntl = 9 then
				daycnth <= daycnth + 1;
				daycntl <= 0;
			else
				daycntl <= daycntl + 1;
			end if;
		end if;
	end if;
	end process;
	
	
	process(rst,clk)
	begin
		if rst = '0' then
			seccnth <= (others =>'0');
		elsif clk'event and clk = '1' then
			if seccntl = 9 then
				if seccnth = 5 then
					seccnth <= (others =>'0');
				else
					seccnth <= seccnth +1;
				end if;
			end if;
		end if;
	end process;

	process(rst,clk)
	begin
		if rst = '0' then
			seccntl <= (others =>'0');
		elsif clk'event and clk = '1' then
			if seccntl = 9 then
				seccntl <= (others =>'0');
			else
				seccntl <= seccntl +1;
			end if;
		end if;
	end process;


	process(rst,clk)
	begin
		if rst = '0' then
			secoc <= '0';
		elsif clk'event and clk = '1' then
			if seccnth = 5 and seccntl = 8 then
				secoc <= '1';
			else
				secoc <= '0';
			end if;
		end if;
	end process;

	process(rst,clk)
	begin
		if rst = '0' then
			mincnth <= (others =>'0');
		elsif clk'event and clk = '1' then
			if secoc = '1' and mincntl = 9 then
				if mincnth = 5 then
					mincnth <= (others =>'0');
				else
					mincnth <= mincnth +1;
				end if;
			end if;
		end if;
	end process;

	process(rst,clk)
	begin
		if rst = '0' then
			mincntl <= (others =>'0');
		elsif clk'event and clk = '1' then
			if secoc = '1' then
				if mincntl = 9 then
					mincntl <= (others =>'0');
				else
					mincntl <= mincntl +1;
				end if;
			end if;
		end if;
	end process;

	process(rst,clk)
	begin
		if rst = '0' then
			minoc <= '0';
		elsif clk'event and clk = '1' then
			if mincnth = 5 and seccnth = 5 and mincntl = 9 and seccntl = 8 then
				minoc <= '1';
			else
				minoc <= '0';
			end if;
		end if;
	end process;

	process(rst,clk)
	begin
		if rst = '0' then
			houcnth <= (others =>'0');
		elsif clk'event and clk = '1' then
			if minoc = '1' and secoc = '1' then
				if houcnth = 2 and houcntl = 3 then
					houcnth <= (others =>'0');
				elsif houcntl = 9 then
					houcnth <= houcnth +1;
				end if;
			end if;
		end if;
	end process;

	process(rst,clk)
	begin
		if rst = '0' then
			houcntl <= (others =>'0');
		elsif clk'event and clk = '1' then
			if minoc = '1' and secoc = '1' then
				if (( houcnth = 2 and houcntl = 3) or houcntl = 9) then
					houcntl <= (others =>'0');
				else
					houcntl <= houcntl +1;
				end if;
			end if;
		end if;
	end process;

	process(rst,clk)
	begin
		if rst = '0' then
			houoc <= '0';
		elsif clk'event and clk = '1' then
			if houcnth = 2 and mincnth = 5 and seccnth = 5 and houcntl = 3 and mincntl = 9 and seccntl = 8 then
				houoc <= '1';
			else
				houoc <= '0';
			end if;
		end if;
	end process;

end behav;