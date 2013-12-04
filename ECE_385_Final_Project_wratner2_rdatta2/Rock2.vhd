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


entity Rock2 is
   Port ( Reset : in std_logic;
        crashSignal : in std_logic;
        frame_clk : in std_logic;
        goneOutofB : in std_logic;
        Yoffsett : in std_logic_vector (11 downto 0);
		keyin: in std_logic_vector(2 downto 0);
		level: in std_logic_vector( 15 downto 0);
        Rock2X : out std_logic_vector(9 downto 0);
        Rock2Y : out std_logic_vector(9 downto 0);
        Rock2S : out std_logic_vector(9 downto 0));
end Rock2;

architecture Behavioral of Rock2 is

signal Rock2_X_Pos, Rock2_X_motion, Rock2_Y_Pos, Rock2_Y_motion : std_logic_vector(9 downto 0);
signal Rock2_X_Size : std_logic_vector(9 downto 0);
signal Crash, Game_Start : std_logic;
--if ( conv_std_logic_vector((conv_integer(rand(11 downto 4)) mod 2),2) = "00") then

--signal frame_clk_div : std_logic_vector(5 downto 0);

constant Rock2_X_Cycle    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(800, 10); 
constant Rock2_X_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(700, 10);  --Leftmost point on the X axis
constant Rock2_X_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);  --Rightmost point on the X axis
--constant Rock2_Y_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR((conv_integer(Yoffsett)mod 20), 10);   --Topmost point on the Y axis
constant Rock2_Y_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(240, 10);   --Topmost point on the Y axis
constant Rock2_Y_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(479, 10);  --Bottommost point on the Y axis
                              
constant Rock2_X_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(2, 10);  --Step size on the X axis
constant Rock2_Y_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(3, 10);  --Step size on the Y axis
constant bWall5_X2_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(3, 10);  --Step size on the X axis
constant bWall5_X3_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(4, 10);  --Step size on the X axis

begin
 Rock2_X_Size <= CONV_STD_LOGIC_VECTOR(4, 10); -- assigns the value 4 as a 10-digit binary number, ie "0000000100"

-------------------------------------------------

--  process(frame_clk, reset)
--  begin
--    if (reset = '1') then
--      frame_clk_div <= "000000";
--    elsif (rising_edge(frame_clk)) then
--      frame_clk_div <= frame_clk_div + '1';
--    end if;
--  end process;

  Move_Rock2: process(Reset, frame_clk, Rock2_X_Size, keyin,Rock2_X_motion,Rock2_Y_motion,Yoffsett)
  begin
    if(Reset = '1' or crashSignal = '1' or goneOutofB = '1') then   --Asynchronous Reset
      Rock2_Y_Motion <= CONV_STD_LOGIC_VECTOR(0, 10);
      Rock2_X_Motion <= CONV_STD_LOGIC_VECTOR(0, 10);
      Rock2_Y_Pos <= Rock2_Y_Min;
      Rock2_X_Pos <= Rock2_X_Min;
      --Crash <= '0';
      Game_Start <= '0';
    elsif( Rock2_X_Pos + Rock2_X_Size<=Rock2_X_Max)then
		Rock2_X_Pos <= Rock2_X_Cycle; --CONV_STD_LOGIC_VECTOR(100, 10);
	if(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "000")then
			Rock2_Y_Pos <= CONV_STD_LOGIC_VECTOR(220,10);
		elsif (CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "001") then
			Rock2_Y_Pos <= CONV_STD_LOGIC_VECTOR(260, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "010") then
			Rock2_Y_Pos <= CONV_STD_LOGIC_VECTOR(250, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "011") then
			Rock2_Y_Pos <= CONV_STD_LOGIC_VECTOR(210, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "110") then
			Rock2_Y_Pos <= CONV_STD_LOGIC_VECTOR(275, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "101") then
			Rock2_Y_Pos <= CONV_STD_LOGIC_VECTOR(215, 10);
		--Rock2_Y_Pos <= CONV_STD_LOGIC_VECTOR((CONV_INTEGER(Yoffsett)mod 100), 10); --CONV_STD_LOGIC_VECTOR( 200,10);
		end if;
    elsif(rising_edge(frame_clk)) then
         
      if(Game_Start = '1' and (Rock2_X_Pos + Rock2_X_Size < Rock2_X_Max)) then 
			Rock2_X_Pos <= Rock2_X_Min; --CONV_STD_LOGIC_VECTOR(100, 10);
			--Rock2_Y_Pos <= CONV_STD_LOGIC_VECTOR( 100,10);--CONV_STD_LOGIC_VECTOR((CONV_INTEGER(Yoffsett)mod 100), 10);
			--Rock2_X_motion <= CONV_STD_LOGIC_VECTOR(0,10);
	  elsif (keyin = "100") then --down
			Game_Start <= '1';
      elsif (Game_Start = '1') then
			--if(level = x"0100") then
			Rock2_X_Motion <= not(Rock2_X_Step) + '1';
			if(level >= x"0075" and level <=x"0149") then
			Rock2_X_Motion <= not(bWall5_X2_Step) + '1';
			elsif(level >= x"0150") then
			Rock2_X_Motion <= not(bWall5_X3_Step) + '1';
			end if;
	  else
		    Rock2_Y_Motion <= Rock2_Y_Motion;
            Rock2_X_Motion <= Rock2_X_Motion; -- Ball is somewhere in the middle, don't bounce, just keep moving
      end if;
                
                
      Rock2_Y_Pos <= Rock2_Y_Pos + Rock2_Y_Motion; -- Update ball position 
      Rock2_X_Pos <= Rock2_X_Pos + Rock2_X_Motion;
     
                
               
	--******************************************
	  --ATTENTION! Please answer the following quesiton in your lab report!
        -- Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
        --  that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
        --  or the old?  How will this impact behavior of the ball during a bounce, and how might that 
        --  interact with a response to a keypress?  Can you fix it?  Give an answer in your postlab.
      --******************************************
       
    end if;
  
  end process Move_Rock2;

  Rock2X <= Rock2_X_Pos;
  Rock2Y <= Rock2_Y_Pos;
  Rock2S <= Rock2_X_Size;
 
end Behavioral;      

