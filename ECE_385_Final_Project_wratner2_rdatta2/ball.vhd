---------------------------------------------------------------------------
---------------------------------------------------------------------------
--    Ball.vhd                                                           --
--    Viral Mehta                                                        --
--    Spring 2005                                                        --
--                                                                       --
--    Modified by Stephen Kempf 03-01-2006                               --
--                              03-12-2007                               --
--    Spring 2013 Distribution                                             --
--                                                                       --
--    For use with ECE 385 Lab 9                                         --
--    UIUC ECE Department                                                --
---------------------------------------------------------------------------
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ball is
   Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        crashSignal : in std_logic;
        goneOutofB : out std_logic;
        G_start : out std_logic;
		keyin: in std_logic_vector(2 downto 0);
        BallX : out std_logic_vector(9 downto 0);
        BallY : out std_logic_vector(9 downto 0);
        BallS : out std_logic_vector(9 downto 0));
end ball;

architecture Behavioral of ball is

signal Ball_X_pos, Ball_X_motion, Ball_Y_pos, Ball_Y_motion : std_logic_vector(9 downto 0);
signal Ball_Size : std_logic_vector(9 downto 0);
signal Crash, Game_Start : std_logic;

--signal frame_clk_div : std_logic_vector(5 downto 0);

constant Ball_X_Center : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(320, 10);  --Center position on the X axis
constant Ball_Y_Center : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(240, 10);  --Center position on the Y axis

constant Ball_X_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);  --Leftmost point on the X axis
constant Ball_X_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(639, 10);  --Rightmost point on the X axis
constant Ball_Y_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(128, 10);   --Topmost point on the Y axis
constant Ball_Y_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(352, 10);  --Bottommost point on the Y axis
                              
constant Ball_X_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(3, 10);  --Step size on the X axis
constant Ball_Y_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(2, 10);  --Step size on the Y axis

begin
  Ball_Size <= CONV_STD_LOGIC_VECTOR(4, 10); -- assigns the value 4 as a 10-digit binary number, ie "0000000100"

-------------------------------------------------

--  process(frame_clk, reset)
--  begin
--    if (reset = '1') then
--      frame_clk_div <= "000000";
--    elsif (rising_edge(frame_clk)) then
--      frame_clk_div <= frame_clk_div + '1';
--    end if;
--  end process;

  Move_Ball: process(Reset, frame_clk, Ball_Size, keyin,Ball_X_motion,Ball_Y_motion, crashSignal)
  begin
    if(Reset = '1' or Crash = '1') then   --Asynchronous Reset
      Ball_Y_Motion <= CONV_STD_LOGIC_VECTOR(0, 10);
      Ball_X_Motion <= CONV_STD_LOGIC_VECTOR(0, 10);
      Ball_Y_Pos <= Ball_Y_Center;
      Ball_X_pos <= Ball_X_Center;
      Crash <= '0';
      Game_Start <= '0';
 
    elsif(rising_edge(frame_clk)) then
         
      if   ((Ball_Y_Pos + Ball_Size >= Ball_Y_Max) or crashSignal = '1') then -- Ball is at the bottom edge, BOUNCE!
		Crash <= '1';
	
        --FOR LAB 8
        --Ball_Y_Motion <= not(Ball_Y_Step) + '1'; --2's complement.
        --Ball_X_Motion <= CONV_STD_LOGIC_VECTOR(0, 10);
      elsif(Ball_Y_Pos - Ball_Size <= Ball_Y_Min) then  -- Ball is at the top edge, BOUNCE!
		Crash <= '1';
				elsif (keyin = "001"  and Game_Start = '1') then --up
                    Ball_Y_motion <= not(Ball_Y_Step) + '1';
                    Ball_X_motion <=CONV_STD_LOGIC_VECTOR(0, 10);
                   --end if;
                elsif (keyin = "011" and Game_Start = '1') then --down
					Ball_Y_motion <= Ball_Y_Step;
					Ball_X_motion <=CONV_STD_LOGIC_VECTOR(0, 10);
				elsif (keyin = "100") then --down
					Game_Start <= '1';
			else
		 Ball_Y_Motion <= Ball_Y_Motion;
        Ball_X_Motion <= Ball_X_Motion; -- Ball is somewhere in the middle, don't bounce, just keep moving
      end if;
                

      Ball_Y_pos <= Ball_Y_pos + Ball_Y_Motion; -- Update ball position 
      Ball_X_pos <= Ball_X_pos + Ball_X_Motion;
     
                
       
    end if;
--if (Crash = '1') then
   -- Crash <= '1';
--else 
   -- Crash <= '0'; 
--end if;
  end process Move_Ball;

  goneOutofB <= Crash;
  BallX <= Ball_X_Pos;
  BallY <= Ball_Y_Pos;
  BallS <= Ball_Size;
  G_start <= Game_Start;
 
end Behavioral;      
