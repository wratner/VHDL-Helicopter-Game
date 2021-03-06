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


entity Wall3 is
   Port ( Reset : in std_logic;
        crashSignal : in std_logic;
        frame_clk : in std_logic;
        goneOutofB : in std_logic;
        level :in std_logic_vector( 15 downto 0);
        Yoffsett : in std_logic_vector (11 downto 0);
		keyin: in std_logic_vector(2 downto 0);
        Wall3X : out std_logic_vector(9 downto 0);
        Wall3Y : out std_logic_vector(9 downto 0);
        Wall3S : out std_logic_vector(9 downto 0));
end Wall3;

architecture Behavioral of Wall3 is

signal Wall3_X_Pos, Wall3_X_motion, Wall3_Y_Pos, Wall3_Y_motion : std_logic_vector(9 downto 0);
signal Wall3_X_Size : std_logic_vector(9 downto 0);
signal Crash, Game_Start : std_logic;
--if ( conv_std_logic_vector((conv_integer(rand(11 downto 4)) mod 2),2) = "00") then

--signal frame_clk_div : std_logic_vector(5 downto 0);

constant Wall3_X_Cycle    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(800, 10); 
constant Wall3_X_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(350, 10);  --Leftmost point on the X axis
constant Wall3_X_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);  --Rightmost point on the X axis
--constant Wall3_Y_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR((conv_integer(Yoffsett)mod 20), 10);   --Topmost point on the Y axis
constant Wall3_Y_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(80, 10);   --Topmost point on the Y axis
constant Wall3_Y_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(479, 10);  --Bottommost point on the Y axis
                              
constant Wall3_X_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(2, 10);  --Step size on the X axis
constant Wall3_Y_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(3, 10);  --Step size on the Y axis
constant bWall5_X2_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(3, 10);  --Step size on the X axis
constant bWall5_X3_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(4, 10);  --Step size on the X axis

begin
 Wall3_X_Size <= CONV_STD_LOGIC_VECTOR(4, 10); -- assigns the value 4 as a 10-digit binary number, ie "0000000100"

-------------------------------------------------



  Move_Wall3: process(Reset, frame_clk, Wall3_X_Size, keyin,Wall3_X_motion,Wall3_Y_motion,Yoffsett)
  begin
    if(Reset = '1' or crashSignal = '1' or goneOutofB = '1') then   --Asynchronous Reset
      Wall3_Y_Motion <= CONV_STD_LOGIC_VECTOR(0, 10);
      Wall3_X_Motion <= CONV_STD_LOGIC_VECTOR(0, 10);
      Wall3_Y_Pos <= Wall3_Y_Min;
      Wall3_X_Pos <= Wall3_X_Min;
      --Crash <= '0';
      Game_Start <= '0';
    elsif( Wall3_X_Pos + Wall3_X_Size<=Wall3_X_Max)then
		Wall3_X_Pos <= Wall3_X_Cycle; --CONV_STD_LOGIC_VECTOR(100, 10);
		if(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "000")then
			Wall3_Y_Pos <= CONV_STD_LOGIC_VECTOR(110,10);
		elsif (CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "001") then
			Wall3_Y_Pos <= CONV_STD_LOGIC_VECTOR(60, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "010") then
			Wall3_Y_Pos <= CONV_STD_LOGIC_VECTOR(100, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "011") then
			Wall3_Y_Pos <= CONV_STD_LOGIC_VECTOR(115, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "110") then
			Wall3_Y_Pos <= CONV_STD_LOGIC_VECTOR(80, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "101") then
			Wall3_Y_Pos <= CONV_STD_LOGIC_VECTOR(105, 10);
		--Wall3_Y_Pos <= CONV_STD_LOGIC_VECTOR((CONV_INTEGER(Yoffsett)mod 100), 10); --CONV_STD_LOGIC_VECTOR( 200,10);
		end if;
    elsif(rising_edge(frame_clk)) then
         
      if(Game_Start = '1' and (Wall3_X_Pos + Wall3_X_Size < Wall3_X_Max)) then 
			Wall3_X_Pos <= Wall3_X_Min; --CONV_STD_LOGIC_VECTOR(100, 10);
			--Wall3_Y_Pos <= CONV_STD_LOGIC_VECTOR( 100,10);--CONV_STD_LOGIC_VECTOR((CONV_INTEGER(Yoffsett)mod 100), 10);
			--Wall3_X_motion <= CONV_STD_LOGIC_VECTOR(0,10);
	  elsif (keyin = "100") then --down
			Game_Start <= '1';
      elsif (Game_Start = '1') then
			--if(level = x"0100") then
			Wall3_X_Motion <= not(Wall3_X_Step) + '1';
			if(level >= x"0075" and level <=x"0149") then
			Wall3_X_Motion <= not(bWall5_X2_Step) + '1';
			elsif(level >= x"0150") then
			Wall3_X_Motion <= not(bWall5_X3_Step) + '1';
			end if;
	  else
		    Wall3_Y_Motion <= Wall3_Y_Motion;
            Wall3_X_Motion <= Wall3_X_Motion; -- Ball is somewhere in the middle, don't bounce, just keep moving
      end if;
                
                
      Wall3_Y_Pos <= Wall3_Y_Pos + Wall3_Y_Motion; -- Update ball position 
      Wall3_X_Pos <= Wall3_X_Pos + Wall3_X_Motion;
     
                
               
    end if;
  
  end process Move_Wall3;

  Wall3X <= Wall3_X_Pos;
  Wall3Y <= Wall3_Y_Pos;
  Wall3S <= Wall3_X_Size;
 
end Behavioral;      

