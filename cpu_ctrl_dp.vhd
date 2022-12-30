----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
--
-- Create Date: 10/29/2020 07:18:24 PM
-- Design Name: CONTROLLER AND DATAPATH FOR THE CPU
-- Module Name: cpu - structural
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
-- *******************************************************************************
-- Additional Comments:
-- This is the module that integrates the datapath and the controller
----------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;

ENTITY cpu_ctrl_dp IS PORT (
                    clk_cpu     : in std_logic;
                    rst_cpu     : IN std_logic;
                    entered_ip  : IN std_logic;
                    input_cpu   : IN std_logic_vector(7 DOWNTO 0);
                    output_cpu  : OUT std_logic_vector(7 DOWNTO 0);
                    PC_output   : OUT std_logic_vector(4 downto 0);
                    OPCODE_ouput: OUT std_logic_vector(3 downto 0);
                    done_cpu    : OUT std_logic);
END cpu_ctrl_dp;

ARCHITECTURE structure OF cpu_ctrl_dp IS

COMPONENT controller PORT (
                clk_ctrl        : IN std_logic;
                rst_ctrl        : IN std_logic;
                enter           : IN std_logic;
                muxsel_ctrl     : OUT std_logic_vector(1 DOWNTO 0);
                imm_ctrl        : buffer std_logic_vector(7 DOWNTO 0);
                accwr_ctrl      : OUT std_logic;
                rfaddr_ctrl     : OUT std_logic_vector(2 DOWNTO 0);
                rfwr_ctrl       : OUT std_logic;
                alusel_ctrl     : OUT std_logic_vector(2 DOWNTO 0);
                outen_ctrl      : OUT std_logic;
                zero_ctrl       : IN std_logic;
                positive_ctrl   : IN std_logic;
                PC_out          : OUT std_logic_vector(4 downto 0);
                OP_out          : OUT std_logic_vector(3 downto 0);
               
                bit_sel_ctrl    : OUT std_logic;
                bits_shift_ctrl : OUT std_logic_vector(1 downto 0);
                
                done            : OUT std_logic);
END COMPONENT;

COMPONENT datapath PORT (
                clk_dp      : IN std_logic;
                rst_dp      : IN std_logic;
                muxsel_dp   : IN std_logic_vector(1 DOWNTO 0);
                imm_dp      : IN std_logic_vector(7 DOWNTO 0);
                input_dp    : IN std_logic_vector(7 DOWNTO 0);
                accwr_dp    : IN std_logic;
                rfaddr_dp   : IN std_logic_vector(2 DOWNTO 0);
                rfwr_dp     : IN std_logic;
                alusel_dp   : IN std_logic_vector(2 DOWNTO 0);
                outen_dp    : IN std_logic;
                
                bits_sel_dp  	: IN std_logic;
                bits_shift_dp   : IN std_logic_vector(1 downto 0);
                        
                zero_dp     : OUT std_logic;
                positive_dp : OUT std_logic;
                output_dp   : OUT std_logic_vector(7 DOWNTO 0));
END COMPONENT;

    SIGNAL C_immediate: std_logic_vector(7 DOWNTO 0);
    SIGNAL C_accwr,C_rfwr,C_outen,C_zero,C_positive, bit_sel: std_logic;
    SIGNAL C_muxsel: std_logic_vector(1 DOWNTO 0);
    SIGNAL bits_shift : std_logic_vector(1 DOWNTO 0);
    SIGNAL C_rfaddr,C_alusel: std_logic_vector(2 DOWNTO 0);

BEGIN
        U0: controller PORT MAP(  clk_ctrl => clk_cpu,
                                  rst_ctrl => rst_cpu,
                                  enter => entered_ip,
                                  muxsel_ctrl => C_muxsel,
                                  imm_ctrl => C_immediate,
                                  accwr_ctrl => C_accwr,
                                  rfaddr_ctrl => C_rfaddr,
                                  rfwr_ctrl => C_rfwr,
                                  alusel_ctrl => C_alusel,
                                  outen_ctrl => C_outen,
                                  zero_ctrl => C_zero,
                                  positive_ctrl => C_positive,
                                  PC_out => PC_output,
                                  OP_out => OPCODE_ouput,
                                  bit_sel_ctrl => bit_sel,
                                  bits_shift_ctrl => bits_shift,
                                  done => done_cpu );
       
        U1: datapath PORT MAP(  clk_dp => clk_cpu,
                                rst_dp => rst_cpu,
                                muxsel_dp => C_muxsel,
                                imm_dp => C_immediate,
                                input_dp => input_cpu, 
                                accwr_dp => C_accwr,
                                rfaddr_dp => C_rfaddr,
                                rfwr_dp => C_rfwr,
                                alusel_dp => C_alusel,
                                outen_dp => C_outen,
                                
                                bits_sel_dp => bit_sel,
                                bits_shift_dp => bits_shift,
                                
                                zero_dp => C_zero,
                                positive_dp => C_positive,

                                output_dp => output_cpu);
END structure;