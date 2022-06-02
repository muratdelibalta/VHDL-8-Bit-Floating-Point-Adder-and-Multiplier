-- Engineer: Murat Delibalta
-- Create Date: 26.05.2022 23:17:55
-- Module Name: adder_8bit - tb
-- Project Name: 8 bit floating point adder - tb

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity add_8bit_tb is
end;

architecture bench of add_8bit_tb is

  component add_8bit
  	port(
  		clk   		: in	std_logic;
  		rst   		: in	std_logic;
  		START		: in	std_logic;
  		a			: in	std_logic_vector(7 downto 0);
  		b			: in	std_logic_vector(7 downto 0);
  		add_o		: out	std_logic_vector(7 downto 0);
  		DONE		: out	std_logic
  	);
  end component;

  signal clk: std_logic;
  signal rst: std_logic;
  signal START: std_logic;
  signal a: std_logic_vector(7 downto 0);
  signal b: std_logic_vector(7 downto 0);
  signal add_o: std_logic_vector(7 downto 0);
  signal DONE: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: add_8bit port map ( clk   => clk,
                           rst   => rst,
                           START => START,
                           a     => a,
                           b     => b,
                           add_o => add_o,
                           DONE  => DONE );

  stimulus: process
  begin
  
    rst <= '0';
    START <= '1';
    a <= "00111000";    --  1.5
    b <= "00100000";    --  0.5
    wait for 5ns;
    wait for 10ns;
    a <= "00111000";    --  1.5
    b <= "10100000";    -- -0.5
    wait for 10ns;
    a <= "00110110";    --  1.375
    b <= "10101100";    -- -0.875
    wait for 10ns;
    a <= "00110110";    --  1.375
    b <= "00101100";    --  0.875
    wait for 10ns;
    a <= "00011000";    --  0.375
    b <= "10111100";    -- -1.75
    wait for 10ns;
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
  