-- Engineer: Murat Delibalta
-- Create Date: 26.05.2022 23:17:55
-- Module Name: adder_8bit - Behavioral
-- Project Name: 8 bit floating point adder
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add_8bit is
	port(
		clk   		: in	std_logic;
		rst   		: in	std_logic;
		START		: in	std_logic;
		a			: in	std_logic_vector(7 downto 0);
		b			: in	std_logic_vector(7 downto 0);
		add_o		: out	std_logic_vector(7 downto 0);
		DONE		: out	std_logic
	);
end add_8bit;

architecture Behavioral of add_8bit is

type state_t is (S_IDLE,S_0,S_10,S_11,S_2,S_3,S_4,S_5);
signal state : state_t;
constant mantissa               : integer := 4;
signal sign_a, sign_b, sign_o	: std_logic;
signal man_a, man_b, man_o      : unsigned(5 downto 0);
signal exp_a, exp_b, exp_o      : unsigned(2 downto 0);
signal dif                      : unsigned(2 downto 0);
signal i                        : integer range 0 to 7;
begin

	process(clk, rst)
	begin
	    -- reset gelince her þeyi sýfýrla
		if (rst = '1') then
			DONE <= '0';
			add_o <= (others=>'0');
			man_o <= (others=>'0');
			exp_o <= (others=>'0');
			sign_o <= '0';
		elsif (clk'event and clk = '1') then
			if (state = S_IDLE) then
				DONE <= '0';
				add_o <= (others=>'0');
				man_o <= (others=>'0');
				exp_o <= (others=>'0');
				sign_o <= '0';
				if (START='1') then
				-- mantissa, exponent ve iþaret bitlerinin atanmasý
					state <= S_0;
					man_a(3 downto 0) <= unsigned(a(3 downto 0));
					man_a(5 downto 4) <= "01";
					man_b(3 downto 0) <= unsigned(b(3 downto 0));
					man_b(5 downto 4) <= "01";
					exp_a <= unsigned(a(6 downto 4));
					exp_b <= unsigned(b(6 downto 4));
					sign_a <= a(7);
					sign_b <= b(7);
				end if;
			elsif ( state = S_0 ) then
			--  exponent'i büyük giriþi belirleme
				if (exp_a > exp_b) then
					dif <= exp_a - exp_b;
					state <= S_10;
				else
					dif <= exp_b - exp_a;
					state <= S_11;
				end if;
			elsif (state = S_10 ) then -- shift
				exp_o <= exp_a;
				-- eðer exponentler arasýndaki fark mantissadan
				-- büyük deðilse kaydýr, büyükse sýfýrla
				if (dif < mantissa) then
					man_b <= shift_right(man_b,to_integer(dif));
				else 
					man_b <= (others=>'0');
				end if;				
				state <= S_2;
			elsif (state = S_11 ) then 
				exp_o <= exp_b;
				if (dif < mantissa) then
					man_a <= shift_right(man_a,to_integer(dif));
				else 
					man_a <= (others=>'0');
				end if;
				state <= S_2;
			elsif (state = S_2) then 
			-- iþaret bitinin kontrolü ve mantissalarin eklenmesi
				if (sign_a = sign_b) then 
					man_o <= man_a + man_b;
					sign_o <= sign_a;
                        -- +- durumu
				elsif (sign_a = '0') then 
					if (man_a > man_b) then
						man_o <= man_a - man_b;
						sign_o <= '0';
					else
						man_o <= man_b - man_a;
						sign_o <= '1';
					end if;
				else	-- -+ durumu
					if (man_b > man_a ) then
						man_o <= man_b - man_a;
						sign_o <= '0';
					else
						man_o <= man_a - man_b;
						sign_o <= '1';
					end if;
				end if;
				state <= S_3;
			-- mantissa taþma durumunda kaydýrma ve exponenti arttýrma 
			elsif (state = S_3) then 
				if (man_o(5) = '1') then 
					man_o <= shift_right(man_o,1);
					exp_o <= exp_o + 1;
					state <= S_4;
				else 
					state <= S_5;
					i <= 0;
				end if;
			elsif (state = S_5) then
				if (man_o(4) = '1') then
					state <= S_4;
				elsif (i = mantissa) then 
					exp_o <= (others=>'0');
					sign_o <= '0';
					state <= S_4;
				else
					man_o <= shift_left(man_o,1);
					exp_o <= exp_o - 1;
					state <= S_5;
					i <= i+1;
				end if;
				-- iþaret, exponent, mantissa ve bayrak bitlerinin atanmasý
			elsif (state = S_4) then
				add_o <= sign_o & std_logic_vector(exp_o) & std_logic_vector(man_o(3 downto 0));
				DONE <= '1';
				state <= S_IDLE;
			end if;
			
		end if;
	end process;

end Behavioral;
