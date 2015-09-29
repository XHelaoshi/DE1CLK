library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clktop is
port (
	KEY   : in std_logic_vector(7 downto 0);  ---rst input
	CLOCK_50   : in std_logic;  ---50MHz clock
	HEX0 : out std_logic_vector(6 downto 0);   --secl
	HEX1 : out std_logic_vector(6 downto 0);   --sech
	HEX2 : out std_logic_vector(6 downto 0);   --minl
	HEX3 : out std_logic_vector(6 downto 0);   --minh
--	HEX4 : out std_logic_vector(6 downto 0);   --houl
--	HEX5 : out std_logic_vector(6 downto 0);   --houh
	LEDG: out std_logic_vector(7 downto 0)     --press state
     );
end clktop;

architecture behav of clktop is
signal rst,clks,clkms,ledg7n ,pressout,press_sw,press_dm:std_logic;
signal seccnthh,seccntll,mincnthh,mincntll,houcnthh,houcntll,daycntll,daycnthh,moncntll,moncnthh,templ,temph,templl,temphh :std_logic_vector(3 downto 0);
signal ss,ssdm : std_logic;
signal ledgg: std_logic ;  
component clkdiv is
port (
	clk   : in std_logic;
	clkms: out std_logic;
	clks: out std_logic
     );
end component;
component gbrst IS
	PORT
	(
		inclk		: IN STD_LOGIC ;
		outclk		: OUT STD_LOGIC 
	);
END component;
component dclk is
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
end component;
component keyb is
port (
	clk   : in std_logic;
	clkms : in std_logic;
	pressin : in std_logic;
	pressout : out std_logic
     );
end component;
component seg is
port (
	data : in std_logic_vector(3 downto 0);
	hex : out std_logic_vector(6 downto 0)
     );
end component;
--component syreset is
--port (
--	clk   : in std_logic;
--	rstin : in std_logic;
--	rstout : out std_logic
--     );
--end component;

begin
u1: clkdiv port map(clock_50,clkms,clks);
u2:keyb port map(clock_50,clkms,key(0),pressout);
u3: dclk port map(rst,clks,seccnthh,seccntll,mincnthh,mincntll,houcnthh,houcntll,daycnthh,daycntll,moncnthh,moncntll,ledgg);
u4: seg port map(templl,hex0);
u5: seg port map(temphh,hex1);
u6: seg port map(templ,hex2);
u7: seg port map(temph,hex3);
--u6: seg port map(mincntll,hex2);
--u7: seg port map(mincnthh,hex3);
--u8: seg port map(houcntll,hex4);
--u9: seg port map(houcnthh,hex5);
u10: gbrst port map (pressout,rst);
u11:keyb port map(clock_50,clkms,key(1),press_sw);
u12:keyb port map(clock_50,clkms,key(2),press_dm);

process(press_sw)
begin
if press_sw'event and press_sw = '0'then
	ss <=not ss;
end if;
end process;

process(press_dm)
begin
if press_dm'event and press_dm = '0'then
	ssdm <=not ssdm;
end if;
end process;

process(clkms)
begin
if rst = '0'then
	templ <= mincntll;
	temph <= mincnthh ;
	templl <= seccntll;
	temphh <= seccnthh;
elsif clkms'event and clkms = '1' then
	if ssdm = '0' then
		case ss is
			when '1' =>
				templ <= houcntll;
				temph <= houcnthh ;	
				templl <= mincntll;
				temphh <= mincnthh;	
			when '0' =>
				templ <= mincntll;
				temph <= mincnthh ;
				templl <= seccntll;
				temphh <= seccnthh;
			when others =>
				templ <= mincntll;
				temph <= mincnthh ;
				templl <= seccntll;
				temphh <= seccnthh;
		end case;	
	else
		templ <= moncntll;
		temph <= moncnthh ;
		templl <= daycntll;
		temphh <= daycnthh;
	end if;
end if;
end process;

--process(clock_50)--press down key(1) is hour,or is minute
--begin
--if press_sw = '1' then
--templ <= mincntll;
--temph <= mincnthh ;
--else 
--templ <= houcntll;
--temph <= houcnthh ;
--end if;
--end process;

process(clks)
begin
	if clks'event and clks = '1' then
	ledg7n <= not ledg7n;
	end if;
end process;
LEDG(0) <= LEDG7N;
LEDG(7) <= ledgg;
LEDG(6 downto 1) <= key(6 downto 1);
end behav;