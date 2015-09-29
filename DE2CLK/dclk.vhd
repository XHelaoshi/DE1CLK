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
	houcntll : out std_logic_vector(3 downto 0);
	daycnthh : out std_logic_vector(3 downto 0);
	daycntll : out std_logic_vector(3 downto 0);
	moncnthh : out std_logic_vector(3 downto 0);
	moncntll : out std_logic_vector(3 downto 0);
	LEDG: out std_logic    --press state
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
	signal ssr:std_logic;
	signal seccnth,seccntl,mincnth,mincntl,houcnth,houcntl,daycnth,daycntl,moncnth,moncntl,yearcnt0,yearcnt1,yearcnt2,yearcnt3 :std_logic_vector(3 downto 0);
	signal secoc,minoc,houoc,dayoc,monoc :std_logic;

begin

	seccnthh <= seccnth;
	seccntll <= seccntl;
	mincnthh <= mincnth;
	mincntll <= mincntl;
	houcnthh <= houcnth;
	houcntll <= houcntl;
	daycnthh <= daycnth;
	daycntll <= daycntl;
	moncnthh <= moncnth;
	moncntll <= moncntl;
	process(rst,clk)
	begin
		if rst = '0' then
			ss <= s0;
		elsif clk'event and clk = '1' then
			case ss is 
				when s0 => -- for 30days' month
					if moncnth = 0 then
						if moncntl = 1 or moncntl = 3 or moncntl = 5 or moncntl = 7 or moncntl = 8 then
							ss <= s1;
						else ss<=s0;
						end if;
					else 
						if moncntl = 0 or moncntl = 2 then
							ss <= s1;
						else ss<=s0;
						end if;
					end if;
				when s1 => --for 31days' month
					if moncnth = 0 then
						if moncntl = 2 or moncntl = 4 or moncntl = 6 or moncntl = 9 then
							ss <= s0;
						else ss<=s1;
						end if;
					else 
						if moncntl = 1 then
							ss <= s0;
						else ss<=s1;
						end if;
					end if;
					
				when others =>
					ss <= s0;
			end case;
		end if;
	end process;
	
	process(rst,clk)-- run year
	begin
		if rst = '0' then
			ssr <= '0';
		elsif clk'event and clk = '1' then
			if yearcnt0(1 downto 0) = "00" then--can be div by 4
				if not(yearcnt0 = 0 and yearcnt1 = 0) then--can not be div by 100
					ssr <= '1';	
				else-- can be div by 100;
					if yearcnt2 (1 downto 0) = "00" then--can be div by 400
						ssr <= '1';	
					else
						ssr <= '0';
					end if;
				end if;
			else
				ssr <= '0';
			end if;
		end if;
	end process;
	
	process(rst,clk)
	begin
	if rst = '0' then
		moncntl <= B"0001";
		moncnth <= B"0000";
		daycntl <= B"0001";
		daycnth <= B"0000";
	elsif clk'event and clk = '1' then
		if houoc = '1' then
			if ss = s1 then --31days
				if daycnth = 3 and daycntl = 1  then
					daycntl <= B"0001";
					daycnth <= B"0000";
					moncntl <= moncntl + 1;
					if moncnth = 1 and moncntl = 2 then
						moncnth <= B"0000";
						moncntl <= B"0001";
						monoc <= '1';
					end if;
					
				elsif daycntl = 9 then
					daycnth <= daycnth + 1;
					daycntl <= B"0000";
				else
					daycntl <= daycntl + 1;
				end if;
				
			elsif ss = s0 then--30days
				if daycnth = 3 and daycntl = 0 then
					daycntl <= B"0001";
					daycnth <= B"0000";
					moncntl <= moncntl + 1;
					if moncntl = 9 then
						moncnth <= B"0001";
						moncntl <= B"0000";
					end if;
				elsif moncnth = 0 and moncntl = 2 and daycnth = 2 and ssr = '0' and daycntl = 8 then
						moncntl <= moncntl + 1;
						daycntl <= B"0001";
						daycnth <= B"0000";
--				elsif moncnth = 0 and moncntl = 2 and daycnth = 2 and ssr = '1' and daycntl = 9 then
--						moncntl <= moncntl + 1;
--						daycntl <= B"0001";
--						daycnth <= B"0000";
				elsif daycntl = 9 then
					if moncnth = 0 and moncntl = 2 and daycnth = 2 and ssr = '1'then
						moncntl <= moncntl + 1;
						daycntl <= B"0001";
						daycnth <= B"0000";
					else
						daycnth <= daycnth + 1;
						daycntl <= B"0000";
					end if;
				else
					daycntl <= daycntl + 1;
				end if;
				
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
LEDG<='1' when ssr = '1' else '0';
end behav;