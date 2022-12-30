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
-- This reg_file has 8 locations each of 8-bits. Address lines are used to select from 
-- R[0]:R[7]. A write enable port helps to write to respective location of register.
-- A given instruction will perform either read or write any given time and not both
-- at the same time.
-----------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity reg_file is PORT(
            clk_rf          : IN std_logic;
            wr_rf           : IN std_logic;
            addr_rf         : IN std_logic_vector(2 DOWNTO 0); -- addresses 8 locations in the register file
            input_rf        : IN std_logic_vector(7 DOWNTO 0);
            output_rf       : OUT std_logic_vector(7 DOWNTO 0));
end reg_file;

architecture Behavior of reg_file is 
    SUBTYPE reg IS STD_LOGIC_VECTOR(7 DOWNTO 0);
    TYPE regArray IS array(0 to 7) OF reg;
    SIGNAL RF: regArray; --register file contents
    
    BEGIN
        PROCESS(clk_rf,wr_rf)
        BEGIN
            IF(clk_rf'event AND clk_rf = '1')THEN
                IF(wr_rf = '1')THEN --writing to
                  RF(to_integer(unsigned(addr_rf))) <= input_rf;
		-----------------------------------------------------------
                ELSE--reading from
		          output_rf <= RF(to_integer(unsigned(addr_rf)));
		-----------------------------------------------------------
                END IF;         
            END IF;     
        END PROCESS;
        
        
end Behavior;            