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


entity bWall3 is
   Port ( Reset : in std_logic;
        crashSignal : in std_logic;
        frame_clk : in std_logic;
        level: in std_logic_vector( 15 downto 0);
        goneOutofB : in std_logic;
        Yoffsett : in std_logic_vector (11 downto 0);
		keyin: in std_logic_vector(2 downto 0);
        bWall3X : out std_logic_vector(9 downto 0);
        bWall3Y : out std_logic_vector(9 downto 0);
        bWall3S : out std_logic_vector(9 downto 0));
end bWall3;

architecture Behavioral of bWall3 is

signal bWall3_X_Pos, bWall3_X_motion, bWall3_Y_Pos, bWall3_Y_motion : std_logic_vector(9 downto 0);
signal bWall3_X_Size : std_logic_vector(9 downto 0);
signal Crash, Game_Start : std_logic;
--if ( conv_std_logic_vector((conv_integer(rand(11 downto 4)) mod 2),2) = "00") then

--signal frame_clk_div : std_logic_vector(5 downto 0);

constant bWall3_X_Cycle    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(800, 10); 
constant bWall3_X_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(360, 10);  --Leftmost point on the X axis
constant bWall3_X_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);  --Rightmost point on the X axis
--constant bWall3_Y_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR((conv_integer(Yoffsett)mod 20), 10);   --Topmost point on the Y axis
constant bWall3_Y_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(400, 10);   --Topmost point on the Y axis
constant bWall3_Y_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(479, 10);  --Bottommost point on the Y axis
                              
constant bWall3_X_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(2, 10);  --Step size on the X axis
constant bWall3_Y_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(3, 10);  --Step size on the Y axis
constant bWall5_X2_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(3, 10);  --Step size on the X axis
constant bWall5_X3_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(4, 10);  --Step size on the X axis

begin
 bWall3_X_Size <= CONV_STD_LOGIC_VECTOR(4, 10); -- assigns the value 4 as a 10-digit binary number, ie "0000000100"

-------------------------------------------------



  Move_bWall3: process(Reset, frame_clk, bWall3_X_Size, keyin,bWall3_X_motion,bWall3_Y_motion,Yoffsett)
  begin
    if(Reset = '1' or crashSignal = '1' or goneOutofB = '1') then   --Asynchronous Reset
      bWall3_Y_Motion <= CONV_STD_LOGIC_VECTOR(0, 10);
      bWall3_X_Motion <= CONV_STD_LOGIC_VECTOR(0, 10);
      bWall3_Y_Pos <= bWall3_Y_Min;
      bWall3_X_Pos <= bWall3_X_Min;
      --Crash <= '0';
      Game_Start <= '0';
    elsif( bWall3_X_Pos + bWall3_X_Size<=bWall3_X_Max)then
		bWall3_X_Pos <= bWall3_X_Cycle; --CONV_STD_LOGIC_VECTOR(100, 10);
		if(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "000")then
			bWall3_Y_Pos <= CONV_STD_LOGIC_VECTOR(420,10);
		elsif (CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "001") then
			bWall3_Y_Pos <= CONV_STD_LOGIC_VECTOR(390, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "010") then
			bWall3_Y_Pos <= CONV_STD_LOGIC_VECTOR(405, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "011") then
			bWall3_Y_Pos <= CONV_STD_LOGIC_VECTOR(400, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "110") then
			bWall3_Y_Pos <= CONV_STD_LOGIC_VECTOR(380, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "101") then
			bWall3_Y_Pos <= CONV_STD_LOGIC_VECTOR(410, 10);
		--bWall3_Y_Pos <= CONV_STD_LOGIC_VECTOR((CONV_INTEGER(Yoffsett)mod 100), 10); --CONV_STD_LOGIC_VECTOR( 200,10);
		end if;
    elsif(rising_edge(frame_clk)) then
         
      if(Game_Start = '1' and (bWall3_X_Pos + bWall3_X_Size < bWall3_X_Max)) then 
			bWall3_X_Pos <= bWall3_X_Min; --CONV_STD_LOGIC_VECTOR(100, 10);
			--bWall3_Y_Pos <= CONV_STD_LOGIC_VECTOR( 100,10);--CONV_STD_LOGIC_VECTOR((CONV_INTEGER(Yoffsett)mod 100), 10);
			--bWall3_X_motion <= CONV_STD_LOGIC_VECTOR(0,10);
	  elsif (keyin = "100") then --down
			Game_Start <= '1';
      elsif (Game_Start = '1') then
			--if(level = x"0100") then
			bWall3_X_Motion <= not(bWall3_X_Step) + '1';
			if(level >= x"0075" and level <=x"0149") then
			bWall3_X_Motion <= not(bWall5_X2_Step) + '1';
			elsif(level >= x"0150") then
			bWall3_X_Motion <= not(bWall5_X3_Step) + '1';
			end if;
	  else
		    bWall3_Y_Motion <= bWall3_Y_Motion;
            bWall3_X_Motion <= bWall3_X_Motion; -- Ball is somewhere in the middle, don't bounce, just keep moving
      end if;
                
                
      bWall3_Y_Pos <= bWall3_Y_Pos + bWall3_Y_Motion; -- Update ball position 
      bWall3_X_Pos <= bWall3_X_Pos + bWall3_X_Motion;
     
                
               
    end if;
  
  end process Move_bWall3;

  bWall3X <= bWall3_X_Pos;
  bWall3Y <= bWall3_Y_Pos;
  bWall3S <= bWall3_X_Size;
 
end Behavioral;      


