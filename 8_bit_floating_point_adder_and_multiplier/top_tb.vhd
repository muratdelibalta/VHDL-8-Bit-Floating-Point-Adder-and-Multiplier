-- Engineer: Murat Delibalta
-- Create Date: 27.05.2022 00:27:02
-- Module Name: top -tb
-- Project Name: 8 bit floating point multiplication - adder -tb

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity top_tb is
end;

architecture bench of top_tb is

  component top
  	port(
  		clk   		: in	std_logic;
  		rst   		: in	std_logic;
  		START		: in	std_logic;
  		sel         : in    std_logic;
  		a			: inout	std_logic_vector(7 downto 0);
  		b			: inout	std_logic_vector(7 downto 0);
  		fp_o		: out	std_logic_vector(7 downto 0);
  		DONE		: out	std_logic
  	);
  end component;

  signal clk: std_logic;
  signal rst: std_logic;
  signal START: std_logic;
  signal sel: std_logic;
  signal a: std_logic_vector(7 downto 0);
  signal b: std_logic_vector(7 downto 0);
  signal fp_o: std_logic_vector(7 downto 0);
  signal DONE: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: top port map ( clk   => clk,
                      rst   => rst,
                      START => START,
                      sel   => sel,
                      a     => a,
                      b     => b,
                      fp_o  => fp_o,
                      DONE  => DONE );

  stimulus: process
  begin
  
  rst <= '0';
  START <= '1';
  wait for 5ns;
  sel <= '0';
  a <= "00111000";    --  1.5
  b <= "00100000";    --  0.5
  wait for 10ns;
  sel <= '1';
  a <= "00111000";    --  1.5
  b <= "00100000";    --  0.5
  wait for 10ns;
  sel <= '0';
  a <= "00110110";    --  1.375
  b <= "10101100";    -- -0.875
  wait for 10ns;
  sel <= '1';
  a <= "00110110";    --  1.375
  b <= "10101100";    -- -0.875
  wait for 10ns;
  sel <= '0';
  a <= "00011000";    --  0.375
  b <= "00111100";    --  1.75
  wait for 10ns;
  sel <= '1';
  a <= "00011000";    --  0.375
  b <= "00111100";    --  1.75
  wait for 10ns;  

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
  