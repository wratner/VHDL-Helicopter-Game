---------------------------------------------------------------------------
--    Color_Mapper.vhd                                                   --
--    Stephen Kempf                                                      --
--    3-1-06                                                             --
--												 --
--    Modified by David Kesler - 7-16-08						 --
--                                                                       --
--    Spring 2013 Distribution                                             --
--                                                                       --
--    For use with ECE 385 Lab 9                                         --
--    University of Illinois ECE Department                              --
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Color_Mapper is
   Port ( BallX : in std_logic_vector(9 downto 0);
          keyboard_input : in std_logic_vector(2 downto 0);
          BallY : in std_logic_vector(9 downto 0);
          DrawX : in std_logic_vector(9 downto 0);
          DrawY : in std_logic_vector(9 downto 0);
          Ball_size : in std_logic_vector(9 downto 0);
          BlockX : in std_logic_vector (9 downto 0);
          BlockY : in std_logic_vector(9 downto 0);
          BlockSize : in std_logic_vector (9 downto 0);
          Wall2X : in std_logic_vector (9 downto 0);
          Wall2Y : in std_logic_vector (9 downto 0);
          Wall2Size : in std_logic_vector (9 downto 0);
          Wall3X : in std_logic_vector (9 downto 0);
          Wall3Y : in std_logic_vector (9 downto 0);
          Wall3Size : in std_logic_vector (9 downto 0);
          Wall4X : in std_logic_vector (9 downto 0);
          Wall4Y : in std_logic_vector (9 downto 0);
          Wall4Size : in std_logic_vector (9 downto 0);
          Wall5X : in std_logic_vector (9 downto 0);
          Wall5Y : in std_logic_vector (9 downto 0);
          Wall5Size : in std_logic_vector (9 downto 0);
          Wall6X : in std_logic_vector (9 downto 0);
          Wall6Y : in std_logic_vector (9 downto 0);
          Wall6Size : in std_logic_vector (9 downto 0);
          Wall7X : in std_logic_vector (9 downto 0);
          Wall7Y : in std_logic_vector (9 downto 0);
          Wall7Size : in std_logic_vector (9 downto 0);
          bWallX : in std_logic_vector (9 downto 0);
          bWallY : in std_logic_vector (9 downto 0);
          bWallSize : in std_logic_vector (9 downto 0);
          bWall2X : in std_logic_vector (9 downto 0);
          bWall2Y : in std_logic_vector (9 downto 0);
          bWall2Size : in std_logic_vector (9 downto 0);
          bWall3X : in std_logic_vector (9 downto 0);
          bWall3Y : in std_logic_vector (9 downto 0);
          bWall3Size : in std_logic_vector (9 downto 0);
          bWall4X : in std_logic_vector (9 downto 0);
          bWall4Y : in std_logic_vector (9 downto 0);
          bWall4Size : in std_logic_vector (9 downto 0);
          bWall5X : in std_logic_vector (9 downto 0);
          bWall5Y : in std_logic_vector (9 downto 0);
          bWall5Size : in std_logic_vector (9 downto 0);
          RockX : in std_logic_vector (9 downto 0);
          RockY : in std_logic_vector (9 downto 0);
          RockSize : in std_logic_vector (9 downto 0);
          Rock2X : in std_logic_vector (9 downto 0);
          Rock2Y : in std_logic_vector (9 downto 0);
          Rock2Size : in std_logic_vector (9 downto 0);
          Red   : out std_logic_vector(9 downto 0);
          Green : out std_logic_vector(9 downto 0);
          scoreData : in std_logic_vector ( 15 downto 0);
          Blue  : out std_logic_vector(9 downto 0));
end Color_Mapper;



architecture Behavioral of Color_Mapper is

signal Ball_on : std_logic;
signal Ball2_on : std_logic;
signal Ball3_on, score1Out,score2Out, score3Out, score4Out, score5Out, score6Out, score7Out, score8Out, score9Out, score10Out  : std_logic;
signal Ball4_on : std_logic;
signal Ball5_on : std_logic;
signal Ball6_on : std_logic;
signal Ball7_on : std_logic;
signal Ball8_on : std_logic;
signal bBall_on : std_logic;
signal bBall2_on : std_logic;
signal bBall3_on : std_logic;
signal bBall4_on : std_logic;
signal bBall5_on : std_logic;
signal Rock_on : std_logic;
signal Rock2_on : std_logic;
signal lettAddress, lettAddress2, lettAddress3, lettAddress4, lettAddress5, lettAddress6, lettAddress7, lettAddress8, lettAddress9, lettAddress10 : std_logic_vector (6 downto 0);
signal colPos : std_logic_vector  (2 downto 0);
signal colPosTen, colPosTen2, colPosTen3, colPosTen4, colPosTen5, colPosTen6, colPosTen7, colPosTen8, colPosTen9, colPosTen10 : std_logic_vector ( 9 downto 0);
signal addrSig,addrSig2, addrSig3, addrSig4, addrSig5, addrSig6, addrSig7, addrSig8, addrSig9, addrSig10 : std_logic_vector ( 10 downto 0);
signal rowPosTen, rowPosTen2, rowPosTen3, rowPosTen4, rowPosTen5, rowPosTen6, rowPosTen7, rowPosTen8, rowPosTen9, rowPosTen10 : std_logic_vector (9 downto 0);
signal rowPos, rowPos2, rowPos3, rowPos4, rowPos5, rowPos6, rowPos7, rowPos8, rowPos9, rowPos10 : std_logic_vector ( 3 downto 0);
--signal conRowPos, : std_logic_vector( 3 downto 0);
signal dataSig, dataSig2, dataSig3, dataSig4, dataSig5, dataSig6, dataSig7, dataSig8, dataSig9, dataSig10 : std_logic_vector ( 7 downto 0);


constant Ball_X_Size_Const : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(9, 10);  
constant Ball_Y_Size_Const : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(7, 10);  

constant Wall_X_Size_Const : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(60, 10);  
constant Wall_Y_Size_Const : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(75, 10);  

constant Wall2_X_Size_Const : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(35, 10);  
constant Wall2_Y_Size_Const : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(75, 10);  

constant Rock_X_Size_Const : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(15, 10);  
constant Rock_Y_Size_Const : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(15, 10);  

constant score1X : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(30, 10);
constant score1Y : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(400, 10);

constant score2X : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(45, 10);
constant score2Y : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(400, 10);

constant score3X : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(60, 10);
constant score3Y : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(400, 10);

constant score4X : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(75, 10);
constant score4Y : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(400, 10);

constant score5X : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(90, 10);
constant score5Y : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(400, 10);

constant score6X : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(105, 10);
constant score6Y : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(400, 10);

constant score7X : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(120, 10);
constant score7Y : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(400, 10);

constant score8X : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(135, 10);
constant score8Y : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(400, 10);

constant score9X : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(150, 10);
constant score9Y : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(400, 10);

constant score10X : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(165, 10);
constant score10Y : std_logic_vector (9 downto 0) := CONV_STD_LOGIC_VECTOR(400, 10);

component font_rom is
Port( --clk: in std_logic;
      addr: in std_logic_vector(10 downto 0);
      data: out std_logic_vector(7 downto 0));
end component;

begin

font_rom_instance : font_rom
	Port map (addr => addrSig,
			  data => dataSig);
font_rom_instance2 : font_rom
	Port map (addr => addrSig2,
			  data => dataSig2);
font_rom_instance3 : font_rom
	Port map (addr => addrSig3,
			  data => dataSig3);
font_rom_instance4 : font_rom
	Port map (addr => addrSig4,
			  data => dataSig4);
font_rom_instance5 : font_rom
	Port map (addr => addrSig5,
			  data => dataSig5);
font_rom_instance6 : font_rom
	Port map (addr => addrSig6,
			  data => dataSig6);
font_rom_instance7 : font_rom
	Port map (addr => addrSig7,
			  data => dataSig7);
font_rom_instance8 : font_rom
	Port map (addr => addrSig8,
			  data => dataSig8);
font_rom_instance9 : font_rom
	Port map (addr => addrSig9,
			  data => dataSig9);
font_rom_instance10 : font_rom
	Port map (addr => addrSig10,
			  data => dataSig10);
			  
			   Score1_on_proc : process(DrawX, DrawY)

begin
	if(DrawX >= score1X and DrawX <= (score1X + CONV_STD_LOGIC_VECTOR(8, 10))
	   and DrawY >= score1Y and DrawY <= (score1Y + CONV_STD_LOGIC_VECTOR(16, 10))) then
		--score1Out <= '1';
		colPosTen <= DrawX - score1X;
		rowPosTen <= DrawY - score1Y;
		rowPos <= rowPosTen(3 downto 0);
		lettAddress <= CONV_STD_LOGIC_VECTOR(5,3) & CONV_STD_LOGIC_VECTOR(3,4);
		addrSig <= lettAddress &rowPos;
		score1Out <= dataSig(CONV_INTEGER(colPosTen));
	else
		score1Out <= '0';
	end if;
end process Score1_on_proc;

 Score2_on_proc : process(DrawX, DrawY)

begin
	if(DrawX >= score2X and DrawX <= (score2X + CONV_STD_LOGIC_VECTOR(8, 10))
	   and DrawY >= score2Y and DrawY <= (score2Y + CONV_STD_LOGIC_VECTOR(16, 10))) then
		--score1Out <= '1';
		colPosTen2 <= DrawX - score2X;
		rowPosTen2 <= DrawY - score2Y;
		rowPos2 <= rowPosTen2(3 downto 0);
		lettAddress2 <= CONV_STD_LOGIC_VECTOR(6,3) & CONV_STD_LOGIC_VECTOR(3,4);
		addrSig2 <= lettAddress2 &rowPos2;
		score2Out <= dataSig2(CONV_INTEGER(colPosTen2));
	else
		score2Out <= '0';
	end if;
end process Score2_on_proc;

 Score3_on_proc : process(DrawX, DrawY)

begin
	if(DrawX >= score3X and DrawX <= (score3X + CONV_STD_LOGIC_VECTOR(8, 10))
	   and DrawY >= score3Y and DrawY <= (score3Y + CONV_STD_LOGIC_VECTOR(16, 10))) then
		--score1Out <= '1';
		colPosTen3 <= DrawX - score3X;
		rowPosTen3 <= DrawY - score3Y;
		rowPos3 <= rowPosTen3(3 downto 0);
		lettAddress3 <= CONV_STD_LOGIC_VECTOR(6,3) & CONV_STD_LOGIC_VECTOR(15,4);
		addrSig3 <= lettAddress3 &rowPos3;
		score3Out <= dataSig3(CONV_INTEGER(colPosTen3));
	else
		score3Out <= '0';
	end if;
end process Score3_on_proc;

 Score4_on_proc : process(DrawX, DrawY)

begin
	if(DrawX >= score4X and DrawX <= (score4X + CONV_STD_LOGIC_VECTOR(8, 10))
	   and DrawY >= score4Y and DrawY <= (score4Y + CONV_STD_LOGIC_VECTOR(16, 10))) then
		--score1Out <= '1';
		colPosTen4 <= DrawX - score4X;
		rowPosTen4 <= DrawY - score4Y;
		rowPos4 <= rowPosTen4(3 downto 0);
		lettAddress4 <= CONV_STD_LOGIC_VECTOR(7,3) & CONV_STD_LOGIC_VECTOR(2,4);
		addrSig4 <= lettAddress4 &rowPos4;
		score4Out <= dataSig4(CONV_INTEGER(colPosTen4));
	else
		score4Out <= '0';
	end if;
end process Score4_on_proc;

 Score5_on_proc : process(DrawX, DrawY)

begin
	if(DrawX >= score5X and DrawX <= (score5X + CONV_STD_LOGIC_VECTOR(8, 10))
	   and DrawY >= score5Y and DrawY <= (score5Y + CONV_STD_LOGIC_VECTOR(16, 10))) then
		--score1Out <= '1';
		colPosTen5 <= DrawX - score5X;
		rowPosTen5 <= DrawY - score5Y;
		rowPos5 <= rowPosTen5(3 downto 0);
		lettAddress5 <= CONV_STD_LOGIC_VECTOR(6,3) & CONV_STD_LOGIC_VECTOR(5,4);
		addrSig5 <= lettAddress5 &rowPos5;
		score5Out <= dataSig5(CONV_INTEGER(colPosTen5));
	else
		score5Out <= '0';
	end if;
end process Score5_on_proc;

 Score6_on_proc : process(DrawX, DrawY)

begin
	if(DrawX >= score6X and DrawX <= (score6X + CONV_STD_LOGIC_VECTOR(8, 10))
	   and DrawY >= score6Y and DrawY <= (score6Y + CONV_STD_LOGIC_VECTOR(16, 10))) then
		--score1Out <= '1';
		colPosTen6 <= DrawX - score6X;
		rowPosTen6 <= DrawY - score6Y;
		rowPos6 <= rowPosTen6(3 downto 0);
		lettAddress6 <= CONV_STD_LOGIC_VECTOR(3,3) & CONV_STD_LOGIC_VECTOR(10,4);
		addrSig6 <= lettAddress6 &rowPos6;
		score6Out <= dataSig6(CONV_INTEGER(colPosTen6));
	else
		score6Out <= '0';
	end if;
end process Score6_on_proc;

Score7_on_proc : process(DrawX, DrawY)

begin
	if(DrawX >= score7X and DrawX <= (score7X + CONV_STD_LOGIC_VECTOR(8, 10))
	   and DrawY >= score7Y and DrawY <= (score7Y + CONV_STD_LOGIC_VECTOR(16, 10))) then
		--score1Out <= '1';
		colPosTen7 <= DrawX - score7X;
		rowPosTen7 <= DrawY - score7Y;
		rowPos7 <= rowPosTen7(3 downto 0);
		lettAddress7 <= CONV_STD_LOGIC_VECTOR(3,3) & scoreData(15 downto 12);
		addrSig7 <= lettAddress7 &rowPos7;
		score7Out <= dataSig7(CONV_INTEGER(colPosTen7));
	else
		score7Out <= '0';
	end if;
end process Score7_on_proc;

Score8_on_proc : process(DrawX, DrawY)

begin
	if(DrawX >= score8X and DrawX <= (score8X + CONV_STD_LOGIC_VECTOR(8, 10))
	   and DrawY >= score8Y and DrawY <= (score8Y + CONV_STD_LOGIC_VECTOR(16, 10))) then
		--score1Out <= '1';
		colPosTen8 <= DrawX - score8X;
		rowPosTen8 <= DrawY - score8Y;
		rowPos8 <= rowPosTen8(3 downto 0);
		lettAddress8 <= CONV_STD_LOGIC_VECTOR(3,3) & scoreData(11 downto 8);
		addrSig8 <= lettAddress8 &rowPos8;
		score8Out <= dataSig8(CONV_INTEGER(colPosTen8));
	else
		score8Out <= '0';
	end if;
end process Score8_on_proc;

Score9_on_proc : process(DrawX, DrawY)

begin
	if(DrawX >= score9X and DrawX <= (score9X + CONV_STD_LOGIC_VECTOR(8, 10))
	   and DrawY >= score9Y and DrawY <= (score9Y + CONV_STD_LOGIC_VECTOR(16, 10))) then
		--score1Out <= '1';
		colPosTen9 <= DrawX - score9X;
		rowPosTen9 <= DrawY - score9Y;
		rowPos9 <= rowPosTen9(3 downto 0);
		lettAddress9 <= CONV_STD_LOGIC_VECTOR(3,3) & scoreData(7 downto 4);
		addrSig9 <= lettAddress9 &rowPos9;
		score9Out <= dataSig9(CONV_INTEGER(colPosTen9));
	else
		score9Out <= '0';
	end if;
end process Score9_on_proc;

Score10_on_proc : process(DrawX, DrawY)

begin
	if(DrawX >= score10X and DrawX <= (score10X + CONV_STD_LOGIC_VECTOR(8, 10))
	   and DrawY >= score10Y and DrawY <= (score10Y + CONV_STD_LOGIC_VECTOR(16, 10))) then
		--score1Out <= '1';
		colPosTen10 <= DrawX - score10X;
		rowPosTen10 <= DrawY - score10Y;
		rowPos10 <= rowPosTen10(3 downto 0);
		lettAddress10 <= CONV_STD_LOGIC_VECTOR(3,3) & scoreData(3 downto 0);
		addrSig10 <= lettAddress10 &rowPos10;
		score10Out <= dataSig10(CONV_INTEGER(colPosTen10));
	else
		score10Out <= '0';
	end if;
end process Score10_on_proc;

  Ball_on_proc : process (BallX, BallY, DrawX, DrawY, Ball_size)
  begin
  -- Old Ball: Generated square box by checking if the current pixel is within a square of length
  -- 2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons, by using
  -- IEEE.STD_LOGIC_UNSIGNED.ALL at the top.
	--if ((DrawX >= BallX - Ball_size) AND     (DrawX <= BallX + Ball_size) AND
   --(DrawY >= BallY - Ball_size) AND
    --(DrawY <= BallY + Ball_size)) then
	--if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 --( DrawX> (BallX - Ball_X_Size_Const) and
	  -- DrawX< (BallX + Ball_X_Size_Const) and
	   --DrawY> (BallY - Ball_Y_Size_Const) and
	   --DrawY< (BallY + Ball_Y_Size_Const))) then
    if (DrawX >= (BallX - CONV_STD_LOGIC_VECTOR(12, 10)) and
        DrawX <= (BallX + CONV_STD_LOGIC_VECTOR(16, 10)) and
        DrawY = (BallY - CONV_STD_LOGIC_VECTOR(10, 10))) then
			 Ball_on <= '1';
    elsif (DrawX = (BallX + CONV_STD_LOGIC_VECTOR(2, 10)) and
       (DrawY = (BallY - CONV_STD_LOGIC_VECTOR(8, 10)) or
		DrawY = (BallY - CONV_STD_LOGIC_VECTOR(5, 10)) or
		DrawY = (BallY - CONV_STD_LOGIC_VECTOR(9, 10)) or
		DrawY = (BallY - CONV_STD_LOGIC_VECTOR(7, 10)) or
        DrawY = (BallY - CONV_STD_LOGIC_VECTOR(6, 10)))) then
			Ball_on <= '1';
	elsif (DrawX >= (BallX - CONV_STD_LOGIC_VECTOR(2, 10)) and
        DrawX <= (BallX + CONV_STD_LOGIC_VECTOR(8, 10)) and
        DrawY >= (BallY - CONV_STD_LOGIC_VECTOR(4, 10)) and 
        DrawY <= (BallY + CONV_STD_LOGIC_VECTOR(6, 10))) then
			Ball_on <= '1';
	elsif ((DrawX = (BallX + CONV_STD_LOGIC_VECTOR(10, 10)) or
        DrawX = (BallX + CONV_STD_LOGIC_VECTOR(12, 10)) or
        DrawX = (BallX + CONV_STD_LOGIC_VECTOR(11, 10)) or
        DrawX = (BallX + CONV_STD_LOGIC_VECTOR(9, 10))) and
        DrawY >= (BallY - CONV_STD_LOGIC_VECTOR(2, 10)) and
        DrawY <= (BallY + CONV_STD_LOGIC_VECTOR(4, 10))) then
			Ball_on <= '1';
	elsif ((DrawX = (BallX + CONV_STD_LOGIC_VECTOR(14, 10)) or
        DrawX = (BallX + CONV_STD_LOGIC_VECTOR(16, 10)) or
        DrawX = (BallX + CONV_STD_LOGIC_VECTOR(13, 10)) or
        DrawX = (BallX + CONV_STD_LOGIC_VECTOR(15, 10))) and
       (DrawY = (BallY + CONV_STD_LOGIC_VECTOR(0, 10)) or
		DrawY = (BallY + CONV_STD_LOGIC_VECTOR(1, 10)) or
        DrawY = (BallY + CONV_STD_LOGIC_VECTOR(2, 10)))) then
			Ball_on <= '1';
	elsif (DrawX = (BallX - CONV_STD_LOGIC_VECTOR(4, 10)) or
		   DrawX = (BallX - CONV_STD_LOGIC_VECTOR(3, 10)) or
		   DrawX = (BallX - CONV_STD_LOGIC_VECTOR(5, 10))) and
        (DrawY >= (BallY - CONV_STD_LOGIC_VECTOR(2, 10)) and
        DrawY <= (BallY + CONV_STD_LOGIC_VECTOR(4, 10))) then
			Ball_on <= '1';
	elsif (DrawX > (BallX - CONV_STD_LOGIC_VECTOR(12, 10)) and
        DrawX <= (BallX - CONV_STD_LOGIC_VECTOR(6, 10)) and
       (DrawY = (BallY - CONV_STD_LOGIC_VECTOR(0, 10)) or
		DrawY = (BallY - CONV_STD_LOGIC_VECTOR(1, 10)) or
		DrawY = (BallY + CONV_STD_LOGIC_VECTOR(1, 10)) or
        DrawY = (BallY + CONV_STD_LOGIC_VECTOR(2, 10)))) then
			Ball_on <= '1';
	elsif (DrawX >= (BallX - CONV_STD_LOGIC_VECTOR(12, 10)) and
        DrawX <= (BallX - CONV_STD_LOGIC_VECTOR(8, 10)) and
       (DrawY = (BallY - CONV_STD_LOGIC_VECTOR(0, 10)) or
		DrawY = (BallY - CONV_STD_LOGIC_VECTOR(1, 10)) or
        DrawY = (BallY - CONV_STD_LOGIC_VECTOR(2, 10)))) then
			Ball_on <= '1';
	elsif (DrawX >= (BallX - CONV_STD_LOGIC_VECTOR(4, 10)) and
        DrawX <= (BallX + CONV_STD_LOGIC_VECTOR(10, 10)) and
        DrawY = (BallY + CONV_STD_LOGIC_VECTOR(12, 10))) then
			Ball_on <= '1';
    elsif (DrawX = (BallX - CONV_STD_LOGIC_VECTOR(0, 10)) and
       (DrawY = (BallY + CONV_STD_LOGIC_VECTOR(8, 10)) or
		DrawY = (BallY + CONV_STD_LOGIC_VECTOR(7, 10)) or
		DrawY = (BallY + CONV_STD_LOGIC_VECTOR(9, 10)) or
		DrawY = (BallY + CONV_STD_LOGIC_VECTOR(11, 10)) or
        DrawY = (BallY + CONV_STD_LOGIC_VECTOR(10, 10)))) then
			Ball_on <= '1';
	elsif (DrawX = (BallX + CONV_STD_LOGIC_VECTOR(8, 10)) and
	   (DrawY = (BallY + CONV_STD_LOGIC_VECTOR(8, 10)) or
		DrawY = (BallY + CONV_STD_LOGIC_VECTOR(9, 10)) or
		DrawY = (BallY + CONV_STD_LOGIC_VECTOR(7, 10)) or
		DrawY = (BallY + CONV_STD_LOGIC_VECTOR(11, 10)) or
        DrawY = (BallY + CONV_STD_LOGIC_VECTOR(10, 10)))) then
			Ball_on <= '1';
       
      
  -- New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
  -- this single line is quite powerful descriptively, it causes the synthesis tool to use up three
  -- of the 12 available multipliers on the chip!  It also requires IEEE.STD_LOGIC_SIGNED.ALL for
  -- the signed multiplication to operate correctly.
   --if ((((DrawX - BallX) * (DrawX - BallX)) + ((DrawY - BallY) * (DrawY - BallY))) <= (Ball_Size*Ball_Size)) then
      --Ball_on <= '1';
    else
      Ball_on <= '0';
    end if;
  end process Ball_on_proc;
  
  Ball2_on_proc : process (BlockX, BlockY, DrawX, DrawY, Ball_size)
 begin
  if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 ( DrawX> (BlockX - Wall_X_Size_Const) and
	   DrawX< (BlockX + Wall_X_Size_Const) and
	   DrawY> (BlockY - Wall_Y_Size_Const) and
	   DrawY< (BlockY + Wall_Y_Size_Const))) then
	Ball2_on <= '1';
  else
	Ball2_on <= '0';
  end if;
 end process Ball2_on_proc;
 
   Ball3_on_proc : process (Wall2X, Wall2Y, DrawX, DrawY, Ball_size)
 begin
  if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 ( DrawX> (Wall2X - Wall_X_Size_Const) and
	   DrawX< (Wall2X + Wall_X_Size_Const) and
	   DrawY> (Wall2Y - Wall_Y_Size_Const) and
	   DrawY< (Wall2Y + Wall_Y_Size_Const))) then
	Ball3_on <= '1';
  else
	Ball3_on <= '0';
  end if;
 end process Ball3_on_proc;
 
    Ball4_on_proc : process (Wall3X, Wall3Y, DrawX, DrawY, Ball_size)
 begin
  if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 ( DrawX> (Wall3X - Wall_X_Size_Const) and
	   DrawX< (Wall3X + Wall_X_Size_Const) and
	   DrawY> (Wall3Y - Wall_Y_Size_Const) and
	   DrawY< (Wall3Y + Wall_Y_Size_Const))) then
	Ball4_on <= '1';
  else
	Ball4_on <= '0';
  end if;
 end process Ball4_on_proc;

 Ball5_on_proc : process (Wall4X, Wall4Y, DrawX, DrawY, Ball_size)
 begin
  if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 ( DrawX> (Wall4X - Wall_X_Size_Const) and
	   DrawX< (Wall4X + Wall_X_Size_Const) and
	   DrawY> (Wall4Y - Wall_Y_Size_Const) and
	   DrawY< (Wall4Y + Wall_Y_Size_Const))) then
	Ball5_on <= '1';
  else
	Ball5_on <= '0';
  end if;
 end process Ball5_on_proc;
 
  Ball6_on_proc : process (Wall5X, Wall5Y, DrawX, DrawY, Ball_size)
 begin
  if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 ( DrawX> (Wall5X - Wall_X_Size_Const) and
	   DrawX< (Wall5X + Wall_X_Size_Const) and
	   DrawY> (Wall5Y - Wall_Y_Size_Const) and
	   DrawY< (Wall5Y + Wall_Y_Size_Const))) then
	Ball6_on <= '1';
  else
	Ball6_on <= '0';
  end if;
 end process Ball6_on_proc;
 
  Ball7_on_proc : process (Wall6X, Wall6Y, DrawX, DrawY, Ball_size)
 begin
  if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 ( DrawX> (Wall6X - Wall_X_Size_Const) and
	   DrawX< (Wall6X + Wall_X_Size_Const) and
	   DrawY> (Wall6Y - Wall_Y_Size_Const) and
	   DrawY< (Wall6Y + Wall_Y_Size_Const))) then
	Ball7_on <= '1';
  else
	Ball7_on <= '0';
  end if;
 end process Ball7_on_proc;
 
   Ball8_on_proc : process (Wall7X, Wall7Y, DrawX, DrawY, Ball_size)
 begin
  if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 ( DrawX> (Wall7X - Wall2_X_Size_Const) and
	   DrawX< (Wall7X + Wall2_X_Size_Const) and
	   DrawY> (Wall7Y - Wall2_Y_Size_Const) and
	   DrawY< (Wall7Y + Wall2_Y_Size_Const))) then
	Ball8_on <= '1';
  else
	Ball8_on <= '0';
  end if;
 end process Ball8_on_proc;
 
   bBall_on_proc : process (bWallX, bWallY, DrawX, DrawY, Ball_size)
 begin
  if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 ( DrawX> (bWallX - Wall_X_Size_Const) and
	   DrawX< (bWallX + Wall_X_Size_Const) and
	   DrawY> (bWallY - Wall_Y_Size_Const) and
	   DrawY< (bWallY + Wall_Y_Size_Const))) then
	bBall_on <= '1';
  else
	bBall_on <= '0';
  end if;
 end process bBall_on_proc;
 
 bBall2_on_proc : process (bWall2X, bWall2Y, DrawX, DrawY, Ball_size)
 begin
  if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 ( DrawX> (bWall2X - Wall_X_Size_Const) and
	   DrawX< (bWall2X + Wall_X_Size_Const) and
	   DrawY> (bWall2Y - Wall_Y_Size_Const) and
	   DrawY< (bWall2Y + Wall_Y_Size_Const))) then
	bBall2_on <= '1';
  else
	bBall2_on <= '0';
  end if;
 end process bBall2_on_proc;

 bBall3_on_proc : process (bWall3X, bWall3Y, DrawX, DrawY, Ball_size)
 begin
  if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 ( DrawX> (bWall3X - Wall_X_Size_Const) and
	   DrawX< (bWall3X + Wall_X_Size_Const) and
	   DrawY> (bWall3Y - Wall_Y_Size_Const) and
	   DrawY< (bWall3Y + Wall_Y_Size_Const))) then
	bBall3_on <= '1';
  else
	bBall3_on <= '0';
  end if;
 end process bBall3_on_proc;
 
  bBall4_on_proc : process (bWall4X, bWall4Y, DrawX, DrawY, Ball_size)
 begin
  if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 ( DrawX> (bWall4X - Wall_X_Size_Const) and
	   DrawX< (bWall4X + Wall_X_Size_Const) and
	   DrawY> (bWall4Y - Wall_Y_Size_Const) and
	   DrawY< (bWall4Y + Wall_Y_Size_Const))) then
	bBall4_on <= '1';
  else
	bBall4_on <= '0';
  end if;
 end process bBall4_on_proc;
 
 bBall5_on_proc : process (bWall5X, bWall5Y, DrawX, DrawY, Ball_size)
 begin
  if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 ( DrawX> (bWall5X - Wall_X_Size_Const) and
	   DrawX< (bWall5X + Wall_X_Size_Const) and
	   DrawY> (bWall5Y - Wall_Y_Size_Const) and
	   DrawY< (bWall5Y + Wall_Y_Size_Const))) then
	bBall5_on <= '1';
  else
	bBall5_on <= '0';
  end if;
 end process bBall5_on_proc;
 
  Rock_on_proc : process (RockX, RockY, DrawX, DrawY, Ball_size)
 begin
  if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 ( DrawX> (RockX - Rock_X_Size_Const) and
	   DrawX< (RockX + Rock_X_Size_Const) and
	   DrawY> (RockY - Rock_Y_Size_Const) and
	   DrawY< (RockY + Rock_Y_Size_Const))) then
	Rock_on <= '1';
  else
	Rock_on <= '0';
  end if;
 end process Rock_on_proc;
 
   Rock2_on_proc : process (Rock2X, Rock2Y, DrawX, DrawY, Ball_size)
 begin
  if (--(((DrawX - BlockX) * (DrawX - BlockX)) + ((DrawY - BlockY) * (DrawY - BlockY))) <= (Ball_Size*Ball_Size)) then
	 ( DrawX> (Rock2X - Rock_X_Size_Const) and
	   DrawX< (Rock2X + Rock_X_Size_Const) and
	   DrawY> (Rock2Y - Rock_Y_Size_Const) and
	   DrawY< (Rock2Y + Rock_Y_Size_Const))) then
	Rock2_on <= '1';
  else
	Rock2_on <= '0';
  end if;
 end process Rock2_on_proc;



  RGB_Display : process (Ball_on, DrawX, DrawY)
    variable GreenVar, BlueVar : std_logic_vector(22 downto 0);
  begin
    if (Ball_on = '1') then -- blue ball
      Red <= "0000000000";
      Green <= "1010101010";
      Blue <= "0101010101";
    else if (score1Out = '1') then
      Red <= "1100100111";
	  Green <= "0000111010";
	  Blue <= "0000001000";
	else if (score2Out = '1') then
      Red <= "1100100111";
	  Green <= "0000111010";
	  Blue <= "0000001000";
	else if (score3Out = '1') then
      Red <= "1100100111";
	  Green <= "0000111010";
	  Blue <= "0000001000";
    else if (score4Out = '1') then
      Red <= "1100100111";
	  Green <= "0000111010";
	  Blue <= "0000001000";
	else if (score5Out = '1') then
      Red <= "1100100111";
	  Green <= "0000111010";
	  Blue <= "0000001000";
	else if (score6Out = '1') then
      Red <= "1100100111";
	  Green <= "0000111010";
	  Blue <= "0000001000";
	else if (score7Out = '1') then
      Red <= "1100100111";
	  Green <= "0000111010";
	  Blue <= "0000001000";
	else if (score8Out = '1') then
      Red <= "1100100111";
	  Green <= "0000111010";
	  Blue <= "0000001000";
	else if (score9Out = '1') then
      Red <= "1100100111";
	  Green <= "0000111010";
	  Blue <= "0000001000";
	else if (score10Out = '1') then
      Red <= "1100100111";
	  Green <= "0000111010";
	  Blue <= "0000001000";
    else if (Ball2_on = '1') then --***
	  Red <= "0000000000";
	  Green <= "1111111111";
	  Blue <= "0000000000";
	else if (Ball3_on = '1') then
	  Red <= "0000000000";
	  Green <= "1111111111";
	  Blue <= "0000000000";
	else if (Ball4_on = '1') then
	  Red <= "0000000000";
	  Green <= "1111111111";
	  Blue <= "0000000000";
	else if (Ball5_on = '1') then --
	  Red <= "0000000000";
	  Green <= "1111111111";
	  Blue <= "0000000000";
	else if (Ball6_on = '1') then
	  Red <= "0000000000";
	  Green <= "1111111111";
	  Blue <= "0000000000";
	else if (Ball7_on = '1') then
	  Red <= "0000000000";
	  Green <= "1111111111";
	  Blue <= "0000000000";
	else if (Ball8_on = '1') then --
	  Red <= "0000000000";
	  Green <= "1111111111";
	  Blue <= "0000000000";
	else if (bBall_on = '1') then
	  Red <= "0000000000";
	  Green <= "1111111111";
	  Blue <= "0000000000";
	else if (bBall2_on = '1') then
	  Red <= "0000000000";
	  Green <= "1111111111";
	  Blue <= "0000000000";
	else if (bBall3_on = '1') then --
	  Red <= "0000000000";
	  Green <= "1111111111";
	  Blue <= "0000000000";
	else if (bBall4_on = '1') then
	  Red <= "0000000000";
	  Green <= "1111111111";
	  Blue <= "0000000000";
	else if (bBall5_on = '1') then
	  Red <= "0000000000";
	  Green <= "1111111111";
	  Blue <= "0000000000";
	else if (Rock_on = '1') then 
	  Red <= "0000000000";
	  Green <= "1111111111";
	  Blue <= "0000000000";
	else if (Rock2_on = '1') then 
	  Red <= "0000000000";
	  Green <= "1111111111";
	  Blue <= "0000000000";
    else          -- gradient background
      if(drawY < "0010000000") then
      Red   <= "0000000000"; --DrawX(9 downto 0);
      Green <= "1111111111"; --DrawX(9 downto 0);
      Blue  <= "0000000000"; --DrawX(9 downto 0);
      elsif (drawY > "0101100000") then
	  Red   <= "0000000000"; --DrawX(9 downto 0);
      Green <= "1111111111"; --DrawX(9 downto 0);
      Blue  <= "0000000000"; --DrawX(9 downto 0);
      else
      Red   <= "0000000000"; --DrawX(9 downto 0);
      Green <= "0000000000"; --DrawX(9 downto 0);
      Blue  <= "0000000000"; --DrawX(9 downto 0);
      end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
    end if;
  end process RGB_Display;
end Behavioral;
