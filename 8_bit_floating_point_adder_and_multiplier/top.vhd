-- Engineer: Murat Delibalta
-- Create Date: 26.05.2022 23:47:32
-- Module Name: top 
-- Project Name: 8 bit floating point multiplication - adder

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity top is
	port(
		clk   		: in	std_logic;
		rst   		: in	std_logic;
		START		: in	std_logic;
		sel         : in    std_logic;
		a			: in	std_logic_vector(7 downto 0);
		b			: in	std_logic_vector(7 downto 0);
		fp_o		: out	std_logic_vector(7 downto 0);
		DONE		: out	std_logic
	);
end top;

architecture Behavioral of top is


signal add_temp : std_logic_vector( 7 downto 0);
signal mul_temp : unsigned( 7 downto 0);
signal DONE_temp1 : std_logic;
signal DONE_temp2 : std_logic;

component mul_8bit
    Port ( a     : in  std_logic_vector(7 downto 0);
           b     : in  std_logic_vector(7 downto 0);
           mul_o : out  unsigned(7 downto 0);
           DONE  : out  std_logic);
end component;

component add_8bit is
	port(
		clk   		: in	std_logic;
		rst   		: in	std_logic;
		START		: in	std_logic;
		a			: in	std_logic_vector(7 downto 0);
		b			: in	std_logic_vector(7 downto 0);
		add_o		: out	std_logic_vector(7 downto 0);
		DONE		: out	std_logic);
end component;

begin

mul : mul_8bit Port map(a, b, mul_temp, DONE_temp1);
add : add_8bit Port map(clk, rst, START, a, b, add_temp, DONE_temp2);

process (clk,rst)

begin
    if (rst = '1') then
        fp_o <= (others => '0');
    elsif(clk'event and clk = '1') then
        if (START = '1') then
    --  0 secildiði taktirde çarpma, 1 seçildiðinde toplama
            if ( sel = '0') then
                fp_o <= std_logic_vector(mul_temp);
                DONE <= DONE_temp1;
            elsif( sel = '1') then
                fp_o <= add_temp; 
                DONE <= DONE_temp2;
            end if;
        end if;
    end if;        
end process;


end Behavioral;
