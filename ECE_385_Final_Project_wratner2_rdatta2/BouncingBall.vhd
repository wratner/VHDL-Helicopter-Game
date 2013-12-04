---------------------------------------------------------------------------
--      BouncingBall.vhd                                                 --
--      Viral Mehta                                                      --
--      Spring 2005                                                      --
--                                                                       --
--      Modified by Stephen Kempf 03-01-2006                             --
--                                03-12-2007                             --
--      Fall 2012 Distribution                                           --
--                                                                       --
--      For use with ECE 385 Lab 9                                       --
--      UIUC ECE Department                                              --
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BouncingBall is
    Port ( Clk : in std_logic;
           Reset : in std_logic;
           key : in std_logic_vector(2 downto 0);
           Red   : out std_logic_vector(9 downto 0);
           Green : out std_logic_vector(9 downto 0);
           Blue  : out std_logic_vector(9 downto 0);
           VGA_clk : out std_logic; 
           sync : out std_logic;
           blank : out std_logic;
           vs : out std_logic;
           hs : out std_logic);
end BouncingBall;

architecture Behavioral of BouncingBall is

component ball is
    Port ( Reset : in std_logic;
           frame_clk : in std_logic;
           crashSignal : in std_logic;
           goneOutofB : out std_logic;
           keyin: in std_logic_vector(2 downto 0);
           BallX : out std_logic_vector(9 downto 0);
           BallY : out std_logic_vector(9 downto 0);
           G_start : out std_logic;
           BallS : out std_logic_vector(9 downto 0));
end component;

component crashDetection is
Port (  clk : in std_logic;
		BallX : in std_logic_vector (9 downto 0);
		BallY : in std_logic_vector ( 9 downto 0);
		Wall1X : in std_logic_vector (9 downto 0);
		Wall1Y, Wall2X, Wall2Y, Wall3X, Wall4X, Wall5X, Wall6X, Wall7X, Wall8X, Wall9X, Wall10X, Wall11X, Wall3Y, Wall4Y, Wall5Y, Wall6Y, Wall7Y, Wall8Y, Wall9Y, Wall10Y, Wall11Y,Wall12X, Wall12Y, Wall13X, Wall13Y, Wall14X, Wall14Y, BallS : in std_logic_vector (9 downto 0);
		Crash : out std_logic);
end component;

component wall is
	Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        crashSignal : in std_logic;
        level :in std_logic_vector( 15 downto 0);
        goneOutofB : in std_logic;
		keyin: in std_logic_vector(2 downto 0);
		Yoffsett : in std_logic_vector (11 downto 0);
        WallX : out std_logic_vector(9 downto 0);
        WallY : out std_logic_vector(9 downto 0);
        WallS : out std_logic_vector(9 downto 0));
end component;

component RandomNumberGenerator is
	Port (  Clk, Reset: in std_logic;
		--DataIn : in std_logic_vector( 79 downto 0);
		DataOut : out std_logic_vector (11 downto 0));
end component;

component wall2 is
	Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        crashSignal : in std_logic;
        level: in std_logic_vector( 15 downto 0);
        goneOutofB : in std_logic;
		keyin: in std_logic_vector(2 downto 0);
		Yoffsett : in std_logic_vector (11 downto 0);
        Wall2X : out std_logic_vector(9 downto 0);
        Wall2Y : out std_logic_vector(9 downto 0);
        Wall2S : out std_logic_vector(9 downto 0));
 end component;
 
component wall3 is
	Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        crashSignal : in std_logic;
        level :in std_logic_vector( 15 downto 0);
        goneOutofB : in std_logic;
		keyin: in std_logic_vector(2 downto 0);
		Yoffsett : in std_logic_vector (11 downto 0);
        Wall3X : out std_logic_vector(9 downto 0);
        Wall3Y : out std_logic_vector(9 downto 0);
        Wall3S : out std_logic_vector(9 downto 0));
end component;

component wall4 is
	Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        crashSignal : in std_logic;
        level :in std_logic_vector( 15 downto 0);
        goneOutofB : in std_logic;
		keyin: in std_logic_vector(2 downto 0);
		Yoffsett : in std_logic_vector (11 downto 0);
        Wall4X : out std_logic_vector(9 downto 0);
        Wall4Y : out std_logic_vector(9 downto 0);
        Wall4S : out std_logic_vector(9 downto 0));
end component;

component wall5 is
	Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        crashSignal : in std_logic;
        level: in std_logic_vector( 15 downto 0);
        goneOutofB : in std_logic;
		keyin: in std_logic_vector(2 downto 0);
		Yoffsett : in std_logic_vector (11 downto 0);
        Wall5X : out std_logic_vector(9 downto 0);
        Wall5Y : out std_logic_vector(9 downto 0);
        Wall5S : out std_logic_vector(9 downto 0));
end component;

component wall6 is
	Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        level: in std_logic_vector( 15 downto 0);
        crashSignal : in std_logic;
        goneOutofB : in std_logic;
		keyin: in std_logic_vector(2 downto 0);
		Yoffsett : in std_logic_vector (11 downto 0);
        Wall6X : out std_logic_vector(9 downto 0);
        Wall6Y : out std_logic_vector(9 downto 0);
        Wall6S : out std_logic_vector(9 downto 0));
end component;

component wall7 is
	Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        crashSignal : in std_logic;
        level :in std_logic_vector( 15 downto 0);
        goneOutofB : in std_logic;
		keyin: in std_logic_vector(2 downto 0);
		Yoffsett : in std_logic_vector (11 downto 0);
        Wall7X : out std_logic_vector(9 downto 0);
        Wall7Y : out std_logic_vector(9 downto 0);
        Wall7S : out std_logic_vector(9 downto 0));
end component;

component bwall is
	Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        level :in std_logic_vector( 15 downto 0);
        crashSignal : in std_logic;
        goneOutofB : in std_logic;
		keyin: in std_logic_vector(2 downto 0);
		Yoffsett : in std_logic_vector (11 downto 0);
        bWallX : out std_logic_vector(9 downto 0);
        bWallY : out std_logic_vector(9 downto 0);
        bWallS : out std_logic_vector(9 downto 0));
end component;

component bwall2 is
	Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        level: in std_logic_vector( 15 downto 0);
        crashSignal : in std_logic;
        goneOutofB : in std_logic;
		keyin: in std_logic_vector(2 downto 0);
		Yoffsett : in std_logic_vector (11 downto 0);
        bWall2X : out std_logic_vector(9 downto 0);
        bWall2Y : out std_logic_vector(9 downto 0);
        bWall2S : out std_logic_vector(9 downto 0));
end component;

component bwall3 is
	Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        crashSignal : in std_logic;
        level: in std_logic_vector( 15 downto 0);
        goneOutofB : in std_logic;
		keyin: in std_logic_vector(2 downto 0);
		Yoffsett : in std_logic_vector (11 downto 0);
        bWall3X : out std_logic_vector(9 downto 0);
        bWall3Y : out std_logic_vector(9 downto 0);
        bWall3S : out std_logic_vector(9 downto 0));
end component;

component bwall4 is
	Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        level :in std_logic_vector( 15 downto 0);
        crashSignal : in std_logic;
        goneOutofB : in std_logic;
		keyin: in std_logic_vector(2 downto 0);
		Yoffsett : in std_logic_vector (11 downto 0);
        bWall4X : out std_logic_vector(9 downto 0);
        bWall4Y : out std_logic_vector(9 downto 0);
        bWall4S : out std_logic_vector(9 downto 0));
end component;

component bwall5 is
	Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        level: in std_logic_vector( 15 downto 0);
        crashSignal : in std_logic;
        goneOutofB : in std_logic;
		keyin: in std_logic_vector(2 downto 0);
		Yoffsett : in std_logic_vector (11 downto 0);
        bWall5X : out std_logic_vector(9 downto 0);
        bWall5Y : out std_logic_vector(9 downto 0);
        bWall5S : out std_logic_vector(9 downto 0));
end component;

component Rock is
	Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        crashSignal : in std_logic;
        level :in std_logic_vector( 15 downto 0);
        goneOutofB : in std_logic;
		keyin: in std_logic_vector(2 downto 0);
		Yoffsett : in std_logic_vector (11 downto 0);
        RockX : out std_logic_vector(9 downto 0);
        RockY : out std_logic_vector(9 downto 0);
        RockS : out std_logic_vector(9 downto 0));
end component;

component Rock2 is
	Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        crashSignal : in std_logic;
        level :in std_logic_vector( 15 downto 0);
        goneOutofB : in std_logic;
		keyin: in std_logic_vector(2 downto 0);
		Yoffsett : in std_logic_vector (11 downto 0);
        Rock2X : out std_logic_vector(9 downto 0);
        Rock2Y : out std_logic_vector(9 downto 0);
        Rock2S : out std_logic_vector(9 downto 0));
end component;


component vga_controller is
    Port ( clk : in std_logic;
           reset : in std_logic;
           hs : out std_logic;
           vs : out std_logic;
           pixel_clk : out std_logic;
           blank : out std_logic;
           sync : out std_logic;
           DrawX : out std_logic_vector(9 downto 0);
           DrawY : out std_logic_vector(9 downto 0));
end component;

component score is
   Port ( reseth, clkh, goneOutofBh,crashh, gs : in std_logic;
		  outData : out std_logic_vector( 15 downto 0));
end component;

component Color_Mapper is
    Port (BallX : in std_logic_vector(9 downto 0);
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
end component;

signal Reset_h, vsSig, CrashSig, goneOutofBSig, gStartSig : std_logic; ---------
signal DrawXSig, DrawYSig, BallXSig, BallYSig, BallSSig, WallXSig, WallYSig, WallSSig, Wall2XSig, Wall2YSig, Wall2SSig,  Wall3XSig, Wall3YSig, Wall3SSig, Wall4XSig, Wall4YSig, Wall4SSig, 
		Wall5XSig, Wall5YSig, Wall5SSig, Wall6XSig, Wall6YSig, Wall6SSig, Wall7XSig, Wall7YSig, Wall7SSig, bWallXSig, bWallYSig, bWallSSig, bWall2XSig, bWall2YSig, bWall2SSig, bWall3XSig, bWall3YSig, bWall3SSig, 
		bWall4XSig, bWall4YSig, bWall4SSig, bWall5XSig, bWall5YSig, bWall5SSig, RockXSig, RockYSig, RockSSig, Rock2XSig, Rock2YSig, Rock2SSig : std_logic_vector(9 downto 0);
signal yOffsetSig : std_logic_vector (11 downto 0);
signal textAdrSig : std_logic_vector (10 downto 0);
signal textdataSig : std_logic_vector ( 7 downto 0);
signal scoreDataSig : std_logic_vector ( 15 downto 0);
begin

Reset_h <= not Reset; -- The push buttons are active low

vgaSync_instance : vga_controller
   Port map(clk => clk,
            reset => Reset_h,
            hs => hs,
            vs => vsSig,
            pixel_clk => VGA_clk,
            blank => blank,
            sync => sync,
            DrawX => DrawXSig,
            DrawY => DrawYSig);

ball_instance : ball
   Port map(Reset => Reset_h,
            keyin => key,
            goneOutofB => goneOutofBSig,
            crashSignal => CrashSig,
            frame_clk => vsSig, -- Vertical Sync used as an "ad hoc" 60 Hz clock signal
            BallX => BallXSig,  --   (This is why we registered it in the vga controller!)
            BallY => BallYSig,
            G_start =>GStartSig,
            BallS => BallSSig);

wall_instance : wall
	Port map(Reset => Reset_h,
			 frame_clk => vsSig,
			 keyin => key,
			 level => scoreDataSig,
			 goneOutofB => goneOutofBSig,
			 WallX => WallXSig,
			 crashSignal => CrashSig,
			 Yoffsett => yOffsetSig,
			 WallY => WallYSig,
			 WallS => WallSSig);
wall2_instance : wall2
	Port map (Reset => Reset_h,
			  frame_clk =>vsSig,
			  level => scoreDataSig,
			  keyin =>key,
			  goneOutofB => goneOutofBSig,
			  crashSignal => CrashSig,
			  Yoffsett => yOffsetSig,
			  Wall2X => Wall2XSig,
			  Wall2Y => Wall2YSig,
			  Wall2S => Wall2SSig);

wall3_instance : wall3
	Port map (Reset => Reset_h,
			  frame_clk =>vsSig,
			  keyin =>key,
			  level => scoreDataSig,
			  goneOutofB => goneOutofBSig,
			  crashSignal => CrashSig,
			  Yoffsett => yOffsetSig,
			  Wall3X => Wall3XSig,
			  Wall3Y => Wall3YSig,
			  Wall3S => Wall3SSig);

wall4_instance : wall4
	Port map (Reset => Reset_h,
			  frame_clk =>vsSig,
			  keyin =>key,
			  level => scoreDataSig,
			  goneOutofB => goneOutofBSig,
			  crashSignal => CrashSig,
			  Yoffsett => yOffsetSig,
			  Wall4X => Wall4XSig,
			  Wall4Y => Wall4YSig,
			  Wall4S => Wall4SSig);
			  
wall5_instance : wall5
	Port map (Reset => Reset_h,
			  frame_clk =>vsSig,
			  keyin =>key,
			  level => scoreDataSig,
			  goneOutofB => goneOutofBSig,
			  crashSignal => CrashSig,
			  Yoffsett => yOffsetSig,
			  Wall5X => Wall5XSig,
			  Wall5Y => Wall5YSig,
			  Wall5S => Wall5SSig);
			  
wall6_instance : wall6
	Port map (Reset => Reset_h,
			  frame_clk =>vsSig,
			  keyin =>key,
			  level => scoreDataSig,
			  goneOutofB => goneOutofBSig,
			  crashSignal => CrashSig,
			  Yoffsett => yOffsetSig,
			  Wall6X => Wall6XSig,
			  Wall6Y => Wall6YSig,
			  Wall6S => Wall6SSig);
			  
wall7_instance : wall7
	Port map (Reset => Reset_h,
			  frame_clk =>vsSig,
			  keyin =>key,
			  level => scoreDataSig,
			  goneOutofB => goneOutofBSig,
			  crashSignal => CrashSig,
			  Yoffsett => yOffsetSig,
			  Wall7X => Wall7XSig,
			  Wall7Y => Wall7YSig,
			  Wall7S => Wall7SSig);
			  
bwall_instance : bwall
	Port map (Reset => Reset_h,
			  frame_clk =>vsSig,
			  keyin =>key,
			  level => scoreDataSig,
			  goneOutofB => goneOutofBSig,
			  crashSignal => CrashSig,
			  Yoffsett => yOffsetSig,
			  bWallX => bWallXSig,
			  bWallY => bWallYSig,
			  bWallS => bWallSSig);
			  
bwall2_instance : bwall2
	Port map (Reset => Reset_h,
			  frame_clk =>vsSig,
			  keyin =>key,
			  level => scoreDataSig,
			  goneOutofB => goneOutofBSig,
			  crashSignal => CrashSig,
			  Yoffsett => yOffsetSig,
			  bWall2X => bWall2XSig,
			  bWall2Y => bWall2YSig,
			  bWall2S => bWall2SSig);
			  
bwall3_instance : bwall3
	Port map (Reset => Reset_h,
			  frame_clk =>vsSig,
			  keyin =>key,
			  level => scoreDataSig,
			  goneOutofB => goneOutofBSig,
			  crashSignal => CrashSig,
			  Yoffsett => yOffsetSig,
			  bWall3X => bWall3XSig,
			  bWall3Y => bWall3YSig,
			  bWall3S => bWall3SSig);
			  
bwall4_instance : bwall4
	Port map (Reset => Reset_h,
			  frame_clk =>vsSig,
			  keyin =>key,
			  level => scoreDataSig,
			  goneOutofB => goneOutofBSig,
			  crashSignal => CrashSig,
			  Yoffsett => yOffsetSig,
			  bWall4X => bWall4XSig,
			  bWall4Y => bWall4YSig,
			  bWall4S => bWall4SSig);

bwall5_instance : bwall5
	Port map (Reset => Reset_h,
			  frame_clk =>vsSig,
			  keyin =>key,
			  level => scoreDataSig,
			  goneOutofB => goneOutofBSig,
			  crashSignal => CrashSig,
			  Yoffsett => yOffsetSig,
			  bWall5X => bWall5XSig,
			  bWall5Y => bWall5YSig,
			  bWall5S => bWall5SSig);
			  
Rock_instance : Rock
	Port map (Reset => Reset_h,
			  frame_clk =>vsSig,
			  keyin =>key,
			  level => scoreDataSig,
			  goneOutofB => goneOutofBSig,
			  crashSignal => CrashSig,
			  Yoffsett => yOffsetSig,
			  RockX => RockXSig,
			  RockY => RockYSig,
			  RockS => RockSSig);
			  
Rock2_instance : Rock2
	Port map (Reset => Reset_h,
			  frame_clk =>vsSig,
			  keyin =>key,
			  level => scoreDataSig,
			  goneOutofB => goneOutofBSig,
			  crashSignal => CrashSig,
			  Yoffsett => yOffsetSig,
			  Rock2X => Rock2XSig,
			  Rock2Y => Rock2YSig,
			  Rock2S => Rock2SSig);
			  
random_num_gen_instance : RandomNumberGenerator
	Port map (Reset => Reset_h,
			  Clk => vsSig,
			  DataOut => yOffsetSig);
			  
crash_detect_instance : crashDetection
	Port map (clk => vsSig,
			  BallX => BallXSig,
			  BallY => BallYSig,
			  Wall1X => WallXSig,
			  Wall1Y => WallYSig,
			  Wall2X => Wall2XSig,
			  Wall2Y => Wall2YSig,
			  Wall3X => Wall3XSig,
			  Wall3Y => Wall3YSig,
			  Wall4X => Wall4XSig,
			  Wall4Y => Wall4YSig,
			  Wall5X => Wall5XSig,
			  Wall5Y => Wall5YSig,
			  Wall6X => Wall6XSig,
			  Wall6Y => Wall6YSig,
			  Wall7X => bWallXSig,
			  Wall7Y => bWallYSig,
			  Wall8X => bWall2XSig,
			  Wall8Y => bWall2YSig,
			  Wall9X => bWall3XSig,
			  Wall9Y => bWall3YSig,
			  Wall10X => bWall4XSig,
			  Wall10Y => bWall4YSig,
			  Wall11X => bWall5XSig,
			  Wall11Y => bWall5YSig,
			  Wall12X => Wall7XSig,
			  Wall12Y => Wall7YSig,
			  Wall13X => RockXSig,
			  Wall13Y => RockYSig,
			  Wall14X => Rock2XSig,
			  Wall14Y => Rock2YSig,
			  BallS => BallSSig,
			  Crash => CrashSig);
			  
Color_instance : Color_Mapper
   Port Map(BallX => BallXSig,
            BallY => BallYSig,
            BlockX => WallXSig,
            BlockY => WallYSig,
            DrawX => DrawXSig,
            DrawY => DrawYSig,
            Ball_size => BallSSig,
            BlockSize => WallSSig,
            Wall2X => Wall2XSig,
            Wall2Y => Wall2YSig,
            Wall2Size => WallSSig,
            Wall3X => Wall3XSig,
            Wall3Y => Wall3YSig,
            Wall3Size => WallSSig,
            Wall4X => Wall4XSig,
            Wall4Y => Wall4YSig,
            Wall4Size => WallSSig,
            Wall5X => Wall5XSig,
            Wall5Y => Wall5YSig,
            Wall5Size => WallSSig,
            Wall6X => Wall6XSig,
            Wall6Y => Wall6YSig,
            Wall6Size => WallSSig,
            Wall7X => Wall7XSig,
            Wall7Y => Wall7YSig,
            Wall7Size => WallSSig,
            bWallX => bWallXSig,
            bWallY => bWallYSig,
            bWallSize => WallSSig,
            bWall2X => bWall2XSig,
            bWall2Y => bWall2YSig,
            bWall2Size => WallSSig,
            bWall3X => bWall3XSig,
            bWall3Y => bWall3YSig,
            bWall3Size => WallSSig,
            bWall4X => bWall4XSig,
            bWall4Y => bWall4YSig,
            bWall4Size => WallSSig,
            bWall5X => bWall5XSig,
            bWall5Y => bWall5YSig,
            bWall5Size => WallSSig,
            RockX => RockXSig,
            RockY => RockYSig,
            RockSize => RockSSig,
            Rock2X => Rock2XSig,
            Rock2Y => Rock2YSig,
            Rock2Size => RockSSig,
            keyboard_input => key,
            Red => Red,
            Green => Green,
            scoreData =>scoreDataSig,
            Blue => Blue);
score_instance : score
   Port map ( reseth =>Reset_h,
		   clkh=> vsSig,
		   gs => gStartSig,
		   goneOutofBh => goneOutofBSig,
		   crashh =>  CrashSig,
		  outData => scoreDataSig);
         
            


vs <= vsSig;

end Behavioral;      
