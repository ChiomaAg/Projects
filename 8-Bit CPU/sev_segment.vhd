----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
--
-- Create Date: 10/29/2020 07:18:24 PM
-- Design Name: CONTROLLER FOR THE CPU
-- Module Name: 
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: CPU OF LAB 3 - ECE 410 (2021)
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Additional Comments:
--*********************************************************************************
-- This the seven segment that will display the current Program counter on any one of the two display(seven-segment)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity sev_segment is
    Port (
		 --output of PC from cpu
		 DispVal : in  STD_LOGIC_VECTOR (4 downto 0);
	     anode: out std_logic;
	     clk : in STD_LOGIC;
	     --controls which digit to display
         segOut : out  STD_LOGIC_VECTOR (6 downto 0)); 
end sev_segment;

architecture Behavioral of sev_segment is
    signal clk_slow: std_logic;
    signal highvalue, lowvalue: std_logic_vector (6 downto 0);
    signal val : std_logic_vector (7 downto 0);
    component clk_divider generic( divider: positive := 62500000);
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
    end component;
begin
    clk_div: clk_divider generic map (
        divider => 625000) -- 3 ms
        port map( clk_in => clk,
                  clk_out => clk_slow);
    
    anode <= clk_slow;
	
	with DispVal select
		val <= "00000000" when "00000", --0
			      "00000001" when "00001", --1
			      "00000010" when "00010", --2
			      "00000011" when "00011", --3
			      "00000100" when "00100", --4
			      "00000101" when "00101", --5
			      "00000110" when "00110", --6
			      "00000111" when "00111", --7
			      "00001000" when "01000", --8
			      "00001001" when "01001", --9
			      "00010000" when "01010", --A
                  "00010001" when "01011", --B
                  "00010010" when "01100", --C
                  "00010011" when "01101", --D
                  "00010100" when "01110", --E
                  "00010101" when "01111", --F
			      "10000000" when others;
			      	
	with val(3 downto 0) select
		lowvalue <= "0111111" when "0000", --0
			      "0000110" when "0001", --1
			      "1011011" when "0010", --2
			      "1001111" when "0011", --3
			      "1100110" when "0100", --4
			      "1101101" when "0101", --5
			      "1111101" when "0110", --6
			      "0000111" when "0111", --7
			      "1111111" when "1000", --8
			      "1101111" when "1001", --9
			      "1110111" when "1010", --A
                  "1111100" when "1011", --B
                  "0111001" when "1100", --C
                  "1011110" when "1101", --D
                  "1111001" when "1110", --E
                  "1110001" when "1111", --F
			      "1000000" when others;
			      
	with val(7 downto 4) select
		highvalue <= "0111111" when "0000", --0
			      "0000110" when "0001", --1
			      "1011011" when "0010", --2
			      "1001111" when "0011", --3
			      "1100110" when "0100", --4
			      "1101101" when "0101", --5
			      "1111101" when "0110", --6
			      "0000111" when "0111", --7
			      "1111111" when "1000", --8
			      "1101111" when "1001", --9
			      "1110111" when "1010", --A
                  "1111100" when "1011", --B
                  "0111001" when "1100", --C
                  "1011110" when "1101", --D
                  "1111001" when "1110", --E
                  "1110001" when "1111", --F
			      "1000000" when others;
		
        -- Switch between the two signals using clk_slow
    with clk_slow select
    segOut <= highvalue when '1',
                 lowvalue when '0',
                 "XXXXXXX" when others;
	
end Behavioral;

