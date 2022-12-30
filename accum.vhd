----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
--
-- Create Date: 10/29/2020 07:18:24 PM
-- Design Name:
-- Module Name: cpu - structural(datapath)
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: CPU LAB 3 - ECE 410 (2021)
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Additional Comments:
--*********************************************************************************
-- 8-bit accumulator register as shown in the datapath of lab manual
-----------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity accum is PORT (
            clk_acc         : IN std_logic;
            rst_acc         : IN std_logic; -- clear signal to reset the accumulator
            wr_acc          : IN std_logic; -- this signal goes high whenever you want to write into the accumulator register
            input_acc       : IN std_logic_vector (7 DOWNTO 0);
            output_acc      : OUT std_logic_vector (7 DOWNTO 0));

end accum;

architecture Behavioral of accum is

BEGIN
    PROCESS(clk_acc, rst_acc)

	begin
		if rst_acc = '1' then
			output_acc <= (others => '0');
		elsif (clk_acc'event) and (clk_acc = '1') and (wr_acc = '1') then
              output_acc <= input_acc;
		-----------------------------------------------------------------
		end if;
	end process;

end Behavioral;
