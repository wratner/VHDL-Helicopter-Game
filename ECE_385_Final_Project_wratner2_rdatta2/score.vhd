library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity score is
   Port ( reseth, clkh, goneOutofBh,crashh, gs : in std_logic;
		  outData : out std_logic_vector( 15 downto 0));
end score;

architecture Behavioral of score is

--component score is
--	Port ( reset, clk, goneOutofB,crash : in std_logic;
	--	  outData : out std_logic_vector( 15 downto 0));
--end component;
signal gsSig : std_logic;
signal counter : std_logic_vector( 15 downto 0);
signal outCounter1, outCounter2, outCounter3, outCounter4 : std_logic_vector ( 3 downto 0);
begin 
--score_instance : score
--Port map (reset => reseth,
  --        clk => clkh,
    --      goneOutofB => goneOutofBh,
      --    crash => crashh,
        --  outData =>counter);
          
outputScore_process : process( reseth, clkh, goneOutofBh, crashh)
begin	
	if(gs = '1') then
		gsSig <= gs;
	else 
		gsSig <= gsSig;
	end if;
	if(reseth = '1' or goneOutofBh = '1' or crashh = '1') then
		outCounter1 <= "0000";
		outCounter2 <= "0000";
		counter <= CONV_STD_LOGIC_VECTOR(0, 16);
		--outCounter2 <= "0000";
		outCounter3 <= "0000";
		outCounter4 <= "0000";
		gsSig <= '0';
	elsif(rising_edge(clkh) and gsSig = '1')then
			counter <= counter +'1';
			if (counter = CONV_STD_LOGIC_VECTOR(20, 16)) then--if (outCounter1+ '1' = CONV_STD_LOGIC_VECTOR(10, 16)) then
				outCounter1 <= outCounter1 + '1';
				counter <= CONV_STD_LOGIC_VECTOR(0,16);
			elsif (outCounter2 + '1' = CONV_STD_LOGIC_VECTOR(10, 4) and outCounter1 + '1' = CONV_STD_LOGIC_VECTOR(10,4) and outCounter3 + '1'= CONV_STD_LOGIC_VECTOR(10,4)) then
				outCounter1 <= CONV_STD_LOGIC_VECTOR(0,4);
				outCounter2 <= CONV_STD_LOGIC_VECTOR(0,4);
				outCounter3 <= CONV_STD_LOGIC_VECTOR(0,4);
				outCounter4 <= outCounter4 + '1';
			elsif (outCounter2 + '1' = CONV_STD_LOGIC_VECTOR(10, 4) and outCounter1 + '1' = CONV_STD_LOGIC_VECTOR(10,4)) then
				outCounter1 <= CONV_STD_LOGIC_VECTOR(0, 4);
				outCounter2 <= CONV_STD_LOGIC_VECTOR(0, 4);
				outCounter3 <= outCounter3 +'1';
			elsif (outCounter1 + '1' = CONV_STD_LOGIC_VECTOR(10, 4)) then
				outCounter1 <= CONV_STD_LOGIC_VECTOR(0, 4);
				outCounter2 <= outCounter2 + '1';
	
		
			
		--elsif (outCounter2 + '1' = CONV_STD_LOGIC_VECTOR(10, 4)) then
			--outCounter2 <= CONV_STD_LOGIC_VECTOR(0, 4);
		--end if;
		--if(outCounter1 = CONV_STD_LOGIC_VECTOR(0, 4))then
			--if( outCounter2 = CONV_STD_LOGIC_VECTOR(9, 4)) then
			--	outCounter2 <= "0000";
			--else
		--		outCounter2 <= outCounter2 + '1';
		--	end if;
		--end if;
		--if(outCounter2 = CONV_STD_LOGIC_VECTOR(0, 4))then
			--if( outCounter3 = CONV_STD_LOGIC_VECTOR(9, 4)) then
				--outCounter3 <= "0000";
			--else
				--outCounter3 <= outCounter3 + '1';
			--end if;
		--end if;
		--if(outCounter3 = CONV_STD_LOGIC_VECTOR(0, 4))then
			--if( outCounter4 = CONV_STD_LOGIC_VECTOR(9, 4)) then
				--outCounter4 <= "0000";
			--else
				--outCounter4 <= outCounter4 + '1';
			--end if;
		--end if;
		end if;
	end if;
end process outputScore_process;

outData(3 downto 0) <= outCounter1;
outData(7 downto 4) <= outCounter2;
outData(11 downto 8) <= outCounter3;
outData(15 downto 12) <= outCounter4;

end Behavioral;