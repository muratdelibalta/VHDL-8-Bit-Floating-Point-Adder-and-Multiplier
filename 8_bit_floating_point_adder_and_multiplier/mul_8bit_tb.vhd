-- Engineer: Murat Delibalta
-- Create Date: 26.05.2022 21:09:52
-- Module Name: multiplier_8bit - testbench
-- Project Name: 8 bit floating point multiplication - testbench

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity mul_8bit_tb is
end;

architecture bench of mul_8bit_tb is

  component mul_8bit
      Port ( a     : in  unsigned(7 downto 0);
             b     : in  unsigned(7 downto 0);
             mul_o : out  unsigned(7 downto 0);
             DONE  : out  std_logic);
  end component;

  signal a: unsigned(7 downto 0);
  signal b: unsigned(7 downto 0);
  signal mul_o: unsigned(7 downto 0);
  signal DONE: std_logic;

begin

  uut: mul_8bit port map ( a     => a,
                           b     => b,
                           mul_o => mul_o,
                           DONE  => DONE );

  stimulus: process
  begin
    a <= "10111000";    -- -1.5
    b <= "01000100";    --  2.5
    wait for 10ns;
    a <= "01000100";    --  2.5
    b <= "00010000";    --  0.25
    wait for 10ns;
    a <= "00110110";    --  1.375
    b <= "10101100";    -- -0.875
    wait for 10ns;
    a <= "00011000";    --  0.375
    b <= "10111100";    -- -1.75
    wait for 10ns;
    
    wait;
  end process;

end;
  