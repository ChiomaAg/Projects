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
-- Total eights operations can be performed using 3 select lines of this ALU.
-- The select line codes have been given to you in the lab manual.
-- In future, this alu is scalable to say, 16 operations using 4 select lines.
-----------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- The following package is needed so that the STD_LOGIC_VECTOR signals
-- A and B can be used in unsigned arithmetic operations.
use IEEE.STD_LOGIC_ARITH.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity alu is PORT (
            clk_alu     : IN std_logic;
            sel_alu     : IN std_logic_vector(2 DOWNTO 0);
            inA_alu     : IN std_logic_vector(7 DOWNTO 0);
            inB_alu     : IN std_logic_vector(7 DOWNTO 0);
            bits_shift  : IN std_logic_vector(1 downto 0);       -- decides how much to shift during shift left and shift right operation (decide from last 2 bits in the SHFL/SHFR operation)
            OUT_alu     : OUT std_logic_vector (7 DOWNTO 0) := "00000000");
end alu;

ARCHITECTURE Behavior OF alu IS
    BEGIN
        PROCESS(clk_alu,inA_alu,inB_alu,sel_alu)  -- complete the sensitivity list here! *********************************
      
        BEGIN
   
        IF clk_alu'event and clk_alu = '1' THEN
            CASE sel_alu IS
                WHEN "000" =>   
                                OUT_alu <= inA_alu;
                WHEN "001" =>
                                OUT_alu <= inA_alu AND inB_alu;
                WHEN "010" =>
                               if (bits_shift = "00") then 
                                    OUT_alu <= inA_alu;
                               elsif (bits_shift = "01") then                
                                    OUT_alu <= inA_alu(6 downto 0) & '0';
                               elsif (bits_shift = "10") then                
                                    OUT_alu <= inA_alu(5 downto 0) & "00";
                               else               
                                    OUT_alu <= inA_alu(4 downto 0) & "000";
                               end if;      
                WHEN "011" =>
                                if (bits_shift = "00") then 
                                    OUT_alu <= inA_alu;
                                elsif (bits_shift = "01") then                
                                    OUT_alu <= '0' & inA_alu(7 downto 1);
                                elsif (bits_shift = "10") then                
                                    OUT_alu <= "00" & inA_alu(7 downto 2);
                                else               
                                    OUT_alu <= "000" & inA_alu(7 downto 3);
                                end if;				
                WHEN "100" =>
                                OUT_alu <= inA_alu + inB_alu;
                WHEN "101" =>
                                OUT_alu <= inA_alu - inB_alu;
                WHEN "110" =>
                                OUT_alu <= inA_alu + 1;
                WHEN OTHERS =>
                                OUT_alu <= inA_alu - 1;               
            END CASE;
        END IF;
        END PROCESS;
END Behavior;