-- Engineer: Murat Delibalta
-- Create Date: 26.05.2022 21:09:52
-- Module Name: multiplier_8bit - Behavioral
-- Project Name: 8 bit floating point multiplication

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mul_8bit is
    Port ( a     : in   std_logic_vector(7 downto 0);
           b     : in   std_logic_vector(7 downto 0);
           mul_o : out  unsigned(7 downto 0);
           DONE  : out  std_logic);
end mul_8bit;

architecture Behavioral of mul_8bit is

begin

process(a,b)
	
	variable DONE_TEMP             : std_logic;
	variable sign_a,sign_b,sign_o  : std_logic;								
	variable exp_a,exp_b,exp_o     : unsigned(3 downto 0);
	variable man_a,man_b           : unsigned(4 downto 0);
	variable man_o                 : unsigned(9 downto 0);
begin
	-- sonsuz deðer kontrolü
	if (a(6 downto 4)="111" or b(6 downto 4)="111") then
	    DONE  <= '0';
	    mul_o <="00000000";
	else	
    --  iþaret bitlerinin giriþlere atanmasý
        sign_a  := a(7);
        sign_b  := b(7);
        
    --  exponent bitlerinin giriþlere atanmasý    
        exp_a(2 downto 0):= unsigned(a(6 downto 4));	
        exp_a(3):= '0';    
        exp_b(2 downto 0):= unsigned(b(6 downto 4));
        exp_b(3):= '0';
        
    --  mantissa bitlerinin giriþlere atanmasý    
        man_a(3 downto 0):= unsigned(a(3 downto 0));
        man_b(3 downto 0):= unsigned(b(3 downto 0));
        man_a(4):= '1';
        man_b(4):= '1'; 
        
		DONE_TEMP:='1'; 
	
	--  exponent bitlerinin toplanmasý	
		exp_o :=exp_a+exp_b;
		
	--  bias'ýn çýkarýlmasý
		exp_o:=exp_o-"0011";
			
    --  taþma kontrolü
		if exp_o(3)='1' then
			DONE_TEMP:='0';
		end if;
			
    --  mantissa bitlerinin çarpýmý		
		man_o:=resize(man_a*man_b,10);
         
    --  taþma durumunda kaydýrma
		if (man_o(9)='1') then
			man_o:=man_o srl 1;
			exp_o:=exp_o+"0001";
			end if;
			
    --  exponent taþma durumunda DONE bayraðýný sýfýrlama
		if (exp_o(3)='1') then
			DONE_TEMP:='0';
		end if;
			
    --  Çýkýþýn iþaretini belirleme
		sign_o:=sign_a xor sign_b;
			
    --  Çýkýþa mantissa, exponent, ve bayrak bitlerini atama 
		mul_o(3 downto 0) <= man_o(7 downto 4);
		mul_o(6 downto 4) <= exp_o(2 downto 0);
		mul_o(7)<=sign_o;
		DONE <= DONE_TEMP;
	end if;
end process;
end Behavioral;