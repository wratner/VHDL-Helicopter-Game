library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity keyboard_reader is
	Port ( Keyboard_Output: in STD_LOGIC_VECTOR (7 downto 0);
			Control_Out:	out STD_LOGIC_VECTOR (2 downto 0));
end keyboard_reader;

architecture behavorial of keyboard_reader is

begin 
	process( Keyboard_Output)
	begin
		if (Keyboard_Output = x"1D") then		-- Keyboard outputting (up)
		Control_Out<= "001";
		elsif (Keyboard_Output = x"00") then	-- Keyboard outputting (down)
		Control_Out<= "011";
		elsif (Keyboard_Output = x"29") then 	-- Keyboard outputting (right)
		Control_Out<= "100";
		else
		Control_Out<= "000";
		end if;
	end process;
end Behavorial; 