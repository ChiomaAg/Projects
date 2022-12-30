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
-- Description: CPU_LAB 3 - ECE 410 (2021)
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Additional Comments:
--*********************************************************************************
-- When the enable line is asserted, the output from the accumulator will be stored in the buffer.
-- The value stored in the output buffer will the output of this CPU. 
-----------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tristatebuffer is PORT(
            E   : IN std_logic;
            D   : IN std_logic_vector(7 DOWNTO 0);
            Y   : OUT std_logic_vector(7 DOWNTO 0));
end tristatebuffer;

ARCHITECTURE Behavioral OF TriStateBuffer IS
BEGIN
    PROCESS (E, D) -- complete the sensitivity list ***********************************************
        BEGIN
        IF (E = '1') THEN
         Y <= D;
        ELSE
            Y <= (OTHERS => 'Z'); -- gets 8 Z values in the simulation waveform...
        END IF;
    END PROCESS;
END Behavioral;           