library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity crashDetection is 
Port (  clk : in std_logic;
		BallX : in std_logic_vector (9 downto 0);
		BallY : in std_logic_vector ( 9 downto 0);
		Wall1X : in std_logic_vector (9 downto 0);
		Wall1Y, Wall2X, Wall2Y, Wall3X, Wall4X, Wall5X, Wall6X, Wall7X, Wall8X, Wall9X, Wall10X, Wall11X, Wall3Y, Wall4Y, Wall5Y, Wall6Y, Wall7Y, Wall8Y, Wall9Y, Wall10Y, Wall11Y, Wall12X, Wall12Y, Wall13X, Wall13Y, Wall14X, Wall14Y, BallS : in std_logic_vector (9 downto 0);
		Crash : out std_logic);
end crashDetection;

architecture Behavioral of crashDetection is
	signal tempCrash : std_logic;
	constant Wall_X_Size : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(60, 10);  --Center position on the X axis
	constant Wall_Y_Size : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(75, 10);  --Center position on the Y axis
	
	constant Wall2_X_Size : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(35, 10);  --Center position on the X axis
	constant Wall2_Y_Size : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(75, 10);
	
	constant Wall3_X_Size : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(15, 10);  --Center position on the X axis
	constant Wall3_Y_Size : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(15, 10);
	
	constant Ball_X_Size : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(15, 10);  --Center position on the X axis
	constant Ball_Y_Size : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(12, 10);
begin
	crashProcess : process ( clk, BallX, BallY, Wall1X, Wall1Y, Wall2X, Wall2Y)
begin
	if(rising_edge (clk))then
		if(((BallY - Ball_Y_Size) <= Wall1Y + Wall_Y_Size and (BallY + Ball_Y_Size) >= Wall1Y - Wall_Y_Size and BallX + Ball_X_Size >= Wall1X - Wall_X_Size and BallX - Ball_X_Size <= Wall1X + Wall_X_Size) or 
			((BallY - Ball_Y_Size) <= Wall2Y + Wall_Y_Size and (BallY + Ball_Y_Size) >= Wall2Y - Wall_Y_Size and BallX + Ball_X_Size >= Wall2X - Wall_X_Size and BallX - Ball_X_Size <= Wall2X + Wall_X_Size) or
			((BallY - Ball_Y_Size) <= Wall3Y + Wall_Y_Size and (BallY + Ball_Y_Size) >= Wall3Y - Wall_Y_Size and BallX + Ball_X_Size >= Wall3X - Wall_X_Size and BallX - Ball_X_Size <= Wall3X + Wall_X_Size) or
			((BallY - Ball_Y_Size) <= Wall4Y + Wall_Y_Size and (BallY + Ball_Y_Size) >= Wall4Y - Wall_Y_Size and BallX + Ball_X_Size >= Wall4X - Wall_X_Size and BallX - Ball_X_Size <= Wall4X + Wall_X_Size) or
			((BallY - Ball_Y_Size) <= Wall5Y + Wall_Y_Size and (BallY + Ball_Y_Size) >= Wall5Y - Wall_Y_Size and BallX + Ball_X_Size >= Wall5X - Wall_X_Size and BallX - Ball_X_Size <= Wall5X + Wall_X_Size) or 
			((BallY - Ball_Y_Size) <= Wall6Y + Wall_Y_Size and (BallY + Ball_Y_Size) >= Wall6Y - Wall_Y_Size and BallX + Ball_X_Size >= Wall6X - Wall_X_Size and BallX - Ball_X_Size <= Wall6X + Wall_X_Size) or
			((BallY - Ball_Y_Size) <= Wall7Y + Wall_Y_Size and (BallY + Ball_Y_Size) >= Wall7Y - Wall_Y_Size and BallX + Ball_X_Size >= Wall7X - Wall_X_Size and BallX - Ball_X_Size <= Wall7X + Wall_X_Size) or
			((BallY - Ball_Y_Size) <= Wall8Y + Wall_Y_Size and (BallY + Ball_Y_Size) >= Wall8Y - Wall_Y_Size and BallX + Ball_X_Size >= Wall8X - Wall_X_Size and BallX - Ball_X_Size <= Wall8X + Wall_X_Size) or
			((BallY - Ball_Y_Size) <= Wall9Y + Wall_Y_Size and (BallY + Ball_Y_Size) >= Wall9Y - Wall_Y_Size and BallX + Ball_X_Size >= Wall9X - Wall_X_Size and BallX - Ball_X_Size <= Wall9X + Wall_X_Size) or
			((BallY - Ball_Y_Size) <= Wall10Y + Wall_Y_Size and (BallY + Ball_Y_Size) >= Wall10Y - Wall_Y_Size and BallX + Ball_X_Size >= Wall10X - Wall_X_Size and BallX - Ball_X_Size <= Wall10X + Wall_X_Size) or
			((BallY - Ball_Y_Size) <= Wall11Y + Wall_Y_Size and (BallY + Ball_Y_Size) >= Wall11Y - Wall_Y_Size and BallX + Ball_X_Size >= Wall11X - Wall_X_Size and BallX - Ball_X_Size <= Wall11X + Wall_X_Size) or
			((BallY - Ball_Y_Size) <= Wall12Y + Wall2_Y_Size and (BallY + Ball_Y_Size) >= Wall12Y - Wall2_Y_Size and BallX + Ball_X_Size >= Wall12X - Wall2_X_Size and BallX - Ball_X_Size <= Wall12X + Wall2_X_Size) or
			((BallY - Ball_Y_Size) <= Wall14Y + Wall3_Y_Size and (BallY + Ball_Y_Size) >= Wall14Y - Wall3_Y_Size and BallX + Ball_X_Size >= Wall14X - Wall3_X_Size and BallX - Ball_X_Size <= Wall14X + Wall3_X_Size) or
			((BallY - Ball_Y_Size) <= Wall13Y + Wall3_Y_Size and (BallY + Ball_Y_Size) >= Wall13Y - Wall3_Y_Size and BallX + Ball_X_Size >= Wall13X - Wall3_X_Size and BallX - Ball_X_Size <= Wall13X + Wall3_X_Size)) then	
			tempCrash <= '1';
		else
			tempCrash <= '0';
		end if;
	end if;
end process;
Crash <= tempCrash;
end Behavioral;
