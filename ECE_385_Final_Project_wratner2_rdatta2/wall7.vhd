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
use IEEE.numeric_bit.all;
use IEEE.numeric_std.all;


entity Wall7 is
   Port ( Reset : in std_logic;
        crashSignal : in std_logic;
        frame_clk : in std_logic;
        goneOutofB : in std_logic;
        level: in std_logic_vector( 15 downto 0);
        Yoffsett : in std_logic_vector (11 downto 0);
		keyin: in std_logic_vector(2 downto 0);
        Wall7X : out std_logic_vector(9 downto 0);
        Wall7Y : out std_logic_vector(9 downto 0);
        Wall7S : out std_logic_vector(9 downto 0));
end Wall7;

architecture Behavioral of Wall7 is

signal Wall7_X_Pos, Wall7_X_motion, Wall7_Y_Pos, Wall7_Y_motion : std_logic_vector(9 downto 0);
signal Wall7_X_Size : std_logic_vector(9 downto 0);
signal Crash, Game_Start : std_logic;
--if ( conv_std_logic_vector((conv_integer(rand(11 downto 4)) mod 2),2) = "00") then

--signal frame_clk_div : std_logic_vector(5 downto 0);

constant Wall7_X_Cycle    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(800, 10); 
constant Wall7_X_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(35, 10);  --Leftmost point on the X axis
constant Wall7_X_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);  --Rightmost point on the X axis
--constant Wall7_Y_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR((conv_integer(Yoffsett)mod 20), 10);   --Topmost point on the Y axis
constant Wall7_Y_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(80, 10);   --Topmost point on the Y axis
constant Wall7_Y_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(479, 10);  --Bottommost point on the Y axis
                              
constant Wall7_X_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(2, 10);  --Step size on the X axis
constant Wall7_Y_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(3, 10);  --Step size on the Y axis
constant bWall5_X2_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(3, 10);  --Step size on the X axis
constant bWall5_X3_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(4, 10);  --Step size on the X axis

begin
 Wall7_X_Size <= CONV_STD_LOGIC_VECTOR(4, 10); -- assigns the value 4 as a 10-digit binary number, ie "0000000100"

-------------------------------------------------

--  process(frame_clk, reset)
--  begin
--    if (reset = '1') then
--      frame_clk_div <= "000000";
--    elsif (rising_edge(frame_clk)) then
--      frame_clk_div <= frame_clk_div + '1';
--    end if;
--  end process;

  Move_Wall7: process(Reset, frame_clk, Wall7_X_Size, keyin,Wall7_X_motion,Wall7_Y_motion,Yoffsett)
  begin
    if(Reset = '1' or crashSignal = '1' or goneOutofB = '1') then   --Asynchronous Reset
      Wall7_Y_Motion <= CONV_STD_LOGIC_VECTOR(0, 10);
      Wall7_X_Motion <= CONV_STD_LOGIC_VECTOR(0, 10);
      Wall7_Y_Pos <= Wall7_Y_Min;
      Wall7_X_Pos <= Wall7_X_Min;
      --Crash <= '0';
      Game_Start <= '0';
    elsif( Wall7_X_Pos + Wall7_X_Size<=Wall7_X_Max)then
		Wall7_X_Pos <= Wall7_X_Cycle; --CONV_STD_LOGIC_VECTOR(100, 10);
		if(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "000")then
			Wall7_Y_Pos <= CONV_STD_LOGIC_VECTOR(100,10);
		elsif (CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "001") then
			Wall7_Y_Pos <= CONV_STD_LOGIC_VECTOR(105, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "010") then
			Wall7_Y_Pos <= CONV_STD_LOGIC_VECTOR(110, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "011") then
			Wall7_Y_Pos <= CONV_STD_LOGIC_VECTOR(115, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "110") then
			Wall7_Y_Pos <= CONV_STD_LOGIC_VECTOR(60, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "101") then
			Wall7_Y_Pos <= CONV_STD_LOGIC_VECTOR(80, 10);
		--Wall7_Y_Pos <= CONV_STD_LOGIC_VECTOR((CONV_INTEGER(Yoffsett)mod 100), 10); --CONV_STD_LOGIC_VECTOR( 200,10);
		end if;
    elsif(rising_edge(frame_clk)) then
         
      if(Game_Start = '1' and (Wall7_X_Pos + Wall7_X_Size < Wall7_X_Max)) then 
			Wall7_X_Pos <= Wall7_X_Min; --CONV_STD_LOGIC_VECTOR(100, 10);
			--Wall7_Y_Pos <= CONV_STD_LOGIC_VECTOR( 100,10);--CONV_STD_LOGIC_VECTOR((CONV_INTEGER(Yoffsett)mod 100), 10);
			--Wall7_X_motion <= CONV_STD_LOGIC_VECTOR(0,10);
	  elsif (keyin = "100") then --down
			Game_Start <= '1';
      elsif (Game_Start = '1') then
			--if(level = x"0100") then
			Wall7_X_Motion <= not(Wall7_X_Step) + '1';
			if(level >= x"0075" and level <=x"0149") then
			Wall7_X_Motion <= not(bWall5_X2_Step) + '1';
			elsif(level >= x"0150") then
			Wall7_X_Motion <= not(bWall5_X3_Step) + '1';
			end if;
	  else
		    Wall7_Y_Motion <= Wall7_Y_Motion;
            Wall7_X_Motion <= Wall7_X_Motion; -- Ball is somewhere in the middle, don't bounce, just keep moving
      end if;
                
                
      Wall7_Y_Pos <= Wall7_Y_Pos + Wall7_Y_Motion; -- Update ball position 
      Wall7_X_Pos <= Wall7_X_Pos + Wall7_X_Motion;
     
                
               
	--******************************************
	  --ATTENTION! Please answer the following quesiton in your lab report!
        -- Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
        --  that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
        --  or the old?  How will this impact behavior of the ball during a bounce, and how might that 
        --  interact with a response to a keypress?  Can you fix it?  Give an answer in your postlab.
      --******************************************
       
    end if;
  
  end process Move_Wall7;

  Wall7X <= Wall7_X_Pos;
  Wall7Y <= Wall7_Y_Pos;
  Wall7S <= Wall7_X_Size;
 
end Behavioral;      

