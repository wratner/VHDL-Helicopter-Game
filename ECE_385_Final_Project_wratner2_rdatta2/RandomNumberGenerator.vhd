library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RandomNumberGenerator is 
Port (  Clk, Reset: in std_logic;
		--DataIn : in std_logic_vector( 79 downto 0);
		DataOut : out std_logic_vector (11 downto 0));
end RandomNumberGenerator;
		
architecture Behavioral of RandomNumberGenerator is 
	signal regValue : std_logic_vector ( 11 downto 0);
begin
	operateReg : process(Clk,Reset)
begin
	if ( Reset = '1' ) then -- Asynchronous Reset
		regValue <= x"7E3"; -- all the data is reset to a random number
	else if  (rising_edge(Clk)) then
		regValue <= (regValue(9) xor regValue(0) xor regValue(1) xor regValue(5)) & regValue(11 downto 1);
	else
		regValue <= regValue;
	end if;
	end if;
end process;
DataOut <= regValue;
end Behavioral;