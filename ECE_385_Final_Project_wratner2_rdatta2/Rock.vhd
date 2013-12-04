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


entity Rock is
   Port ( Reset : in std_logic;
        crashSignal : in std_logic;
        frame_clk : in std_logic;
        level: in std_logic_vector( 15 downto 0);
        goneOutofB : in std_logic;
        Yoffsett : in std_logic_vector (11 downto 0);
		keyin: in std_logic_vector(2 downto 0);
        RockX : out std_logic_vector(9 downto 0);
        RockY : out std_logic_vector(9 downto 0);
        RockS : out std_logic_vector(9 downto 0));
end Rock;

architecture Behavioral of Rock is

signal Rock_X_Pos, Rock_X_motion, Rock_Y_Pos, Rock_Y_motion : std_logic_vector(9 downto 0);
signal Rock_X_Size : std_logic_vector(9 downto 0);
signal Crash, Game_Start : std_logic;
--if ( conv_std_logic_vector((conv_integer(rand(11 downto 4)) mod 2),2) = "00") then

--signal frame_clk_div : std_logic_vector(5 downto 0);

constant Rock_X_Cycle    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(1000, 10); 
constant Rock_X_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(2000, 10);  --Leftmost point on the X axis
constant Rock_X_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);  --Rightmost point on the X axis
--constant Rock_Y_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR((conv_integer(Yoffsett)mod 20), 10);   --Topmost point on the Y axis
constant Rock_Y_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(240, 10);   --Topmost point on the Y axis
constant Rock_Y_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(479, 10);  --Bottommost point on the Y axis
                              
constant Rock_X_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(2, 10);  --Step size on the X axis
constant Rock_Y_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(3, 10);  --Step size on the Y axis
constant bWall5_X2_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(3, 10);  --Step size on the X axis
constant bWall5_X3_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(4, 10);  --Step size on the X axis

begin
 Rock_X_Size <= CONV_STD_LOGIC_VECTOR(4, 10); -- assigns the value 4 as a 10-digit binary number, ie "0000000100"

-------------------------------------------------

--  process(frame_clk, reset)
--  begin
--    if (reset = '1') then
--      frame_clk_div <= "000000";
--    elsif (rising_edge(frame_clk)) then
--      frame_clk_div <= frame_clk_div + '1';
--    end if;
--  end process;

  Move_Rock: process(Reset, frame_clk, Rock_X_Size, keyin,Rock_X_motion,Rock_Y_motion,Yoffsett)
  begin
    if(Reset = '1' or crashSignal = '1' or goneOutofB = '1') then   --Asynchronous Reset
      Rock_Y_Motion <= CONV_STD_LOGIC_VECTOR(0, 10);
      Rock_X_Motion <= CONV_STD_LOGIC_VECTOR(0, 10);
      Rock_Y_Pos <= Rock_Y_Min;
      Rock_X_Pos <= Rock_X_Min;
      --Crash <= '0';
      Game_Start <= '0';
    elsif( Rock_X_Pos + Rock_X_Size<=Rock_X_Max)then
		Rock_X_Pos <= Rock_X_Cycle; --CONV_STD_LOGIC_VECTOR(100, 10);
	if(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "000")then
			Rock_Y_Pos <= CONV_STD_LOGIC_VECTOR(220,10);
		elsif (CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "001") then
			Rock_Y_Pos <= CONV_STD_LOGIC_VECTOR(260, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6,3) = "010") then
			Rock_Y_Pos <= CONV_STD_LOGIC_VECTOR(250, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "011") then
			Rock_Y_Pos <= CONV_STD_LOGIC_VECTOR(210, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "110") then
			Rock_Y_Pos <= CONV_STD_LOGIC_VECTOR(275, 10);
		elsif(CONV_STD_LOGIC_VECTOR(CONV_INTEGER(Yoffsett)mod 6, 3) = "101") then
			Rock_Y_Pos <= CONV_STD_LOGIC_VECTOR(215, 10);
		--Rock_Y_Pos <= CONV_STD_LOGIC_VECTOR((CONV_INTEGER(Yoffsett)mod 100), 10); --CONV_STD_LOGIC_VECTOR( 200,10);
		end if;
    elsif(rising_edge(frame_clk)) then
         
      if(Game_Start = '1' and (Rock_X_Pos + Rock_X_Size < Rock_X_Max)) then 
			Rock_X_Pos <= Rock_X_Min; --CONV_STD_LOGIC_VECTOR(100, 10);
			--Rock_Y_Pos <= CONV_STD_LOGIC_VECTOR( 100,10);--CONV_STD_LOGIC_VECTOR((CONV_INTEGER(Yoffsett)mod 100), 10);
			--Rock_X_motion <= CONV_STD_LOGIC_VECTOR(0,10);
	  elsif (keyin = "100") then --down
			Game_Start <= '1';
      elsif (Game_Start = '1') then
			--if(level = x"0100") then
			Rock_X_Motion <= not(Rock_X_Step) + '1';
			if(level >= x"0075" and level <=x"0149") then
			Rock_X_Motion <= not(bWall5_X2_Step) + '1';
			elsif(level >= x"0150") then
			Rock_X_Motion <= not(bWall5_X3_Step) + '1';
			end if;
	  else
		    Rock_Y_Motion <= Rock_Y_Motion;
            Rock_X_Motion <= Rock_X_Motion; -- Ball is somewhere in the middle, don't bounce, just keep moving
      end if;
                
                
      Rock_Y_Pos <= Rock_Y_Pos + Rock_Y_Motion; -- Update ball position 
      Rock_X_Pos <= Rock_X_Pos + Rock_X_Motion;
     
                
               
	--******************************************
	  --ATTENTION! Please answer the following quesiton in your lab report!
        -- Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
        --  that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
        --  or the old?  How will this impact behavior of the ball during a bounce, and how might that 
        --  interact with a response to a keypress?  Can you fix it?  Give an answer in your postlab.
      --******************************************
       
    end if;
  
  end process Move_Rock;

  RockX <= Rock_X_Pos;
  RockY <= Rock_Y_Pos;
  RockS <= Rock_X_Size;
 
end Behavioral;      

