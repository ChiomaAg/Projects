----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
--
-- Create Date: 10/29/2020 07:18:24 PM
-- Design Name: DATAPATH FOR THE CPU
-- Module Name: cpu - structural(datapath)
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: CPU_PART 1 OF LAB 3 - ECE 410 (2021)
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Additional Comments:
--*********************************************************************************
-- datapath module that maps all the components used... 
-----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY datapath IS PORT (
                clk_dp          : IN std_logic;
                rst_dp          : IN std_logic;
                muxsel_dp       : IN std_logic_vector(1 DOWNTO 0);  -- mux select for selecting between the four different inputs
                imm_dp          : IN std_logic_vector(7 DOWNTO 0);  -- getting the immediate value as an operand
                input_dp        : IN std_logic_vector(7 DOWNTO 0);  -- getting user input value
                accwr_dp        : IN std_logic;                     -- write signal asserted to write into the accumulator
                rfaddr_dp       : IN std_logic_vector(2 DOWNTO 0);  -- select signal for choosing between the eight register locations
                rfwr_dp         : IN std_logic;                     -- write control signal asserted to write to register file
                alusel_dp       : IN std_logic_vector(2 DOWNTO 0);  -- select signal for the eight ALU operations
                outen_dp        : IN std_logic;                     -- outer buffer enable signal for the output buffer 
                
                bits_sel_dp     : IN std_logic;                     -- select signal to load the bits either in upper or lower nibble of the input
                bits_shift_dp   : IN std_logic_vector(1 downto 0);  -- signal for shifting operation of the number by these many bits
                
                zero_dp         : OUT std_logic;                    -- output zero flag signal
                positive_dp     : OUT std_logic;                    -- output positive flag signal
                output_dp       : OUT std_logic_vector(7 DOWNTO 0));
END datapath;

ARCHITECTURE struct OF datapath is

COMPONENT mux4 PORT (
            sel_mux                         : IN std_logic_vector(1 DOWNTO 0);
            in3_mux,in2_mux,in1_mux,in0_mux : IN std_logic_vector(7 DOWNTO 0);
            out_mux                         : OUT std_logic_vector(7 DOWNTO 0));
END COMPONENT;

COMPONENT accum PORT (
            clk_acc         : IN std_logic;
            rst_acc         : IN std_logic;
            wr_acc          : IN std_logic;
            input_acc       : IN std_logic_vector (7 DOWNTO 0);
            output_acc      : OUT std_logic_vector (7 DOWNTO 0));
END COMPONENT;

COMPONENT reg_file PORT (
            clk_rf          : IN std_logic;
            wr_rf           : IN std_logic;
            addr_rf         : IN std_logic_vector(2 DOWNTO 0);
            input_rf        : IN std_logic_vector(7 DOWNTO 0);
            output_rf       : OUT std_logic_vector(7 DOWNTO 0));
END COMPONENT;

COMPONENT alu PORT (
            clk_alu: IN std_logic;
            sel_alu: IN std_logic_vector(2 DOWNTO 0);
            inA_alu: IN std_logic_vector(7 DOWNTO 0);
            inB_alu: IN std_logic_vector(7 DOWNTO 0);
            bits_shift : IN std_logic_vector(1 downto 0);
            OUT_alu: OUT std_logic_vector (7 DOWNTO 0));
END COMPONENT;


COMPONENT tristatebuffer PORT (
            E   : IN std_logic;
            D   : IN std_logic_vector(7 DOWNTO 0);
            Y   : OUT std_logic_vector(7 DOWNTO 0));
END COMPONENT;

-----------------------------------------------------------------------------------
SIGNAL C_aluout,C_accout,C_rfout,C_muxout, usr_input: std_logic_vector(7 DOWNTO 0);
SIGNAL C_outen: std_logic;
-----------------------------------------------------------------------------------

BEGIN
    
    U0: mux4 PORT MAP(sel_mux => muxsel_dp,
                      in3_mux => imm_dp,
                      in2_mux => usr_input,
                      in1_mux => C_rfout,
                      in0_mux => C_aluout,
                      out_mux => C_muxout);
    
    U1: accum PORT MAP(clk_acc => clk_dp, 
                       rst_acc => rst_dp, 
                       wr_acc => accwr_dp,
                       input_acc => C_muxout, 
                       output_acc => C_accout);
    
    U2: reg_file PORT MAP(clk_rf => clk_dp,
                          wr_rf => rfwr_dp,
                          addr_rf => rfaddr_dp,
                          input_rf => C_accout,
                          output_rf => C_rfout);
    
    U3: alu PORT MAP(clk_alu => clk_dp, 
                     sel_alu => alusel_dp, 
                     inA_alu => C_accout, 
                     inB_alu => C_rfout, 
		             bits_shift => bits_shift_dp,
                     OUT_alu => C_aluout);
    
                     C_outen <= outen_dp OR rst_dp;
    
    U5: tristatebuffer PORT MAP(E => C_outen,
                                D => C_accout, 
                                Y => output_dp);
    
    -- ***********************************************************
    -- Write lines of code here for "usr_input" based on the "bits_sel_dp" signal
    process(bits_sel_dp,clk_dp)
    begin
	if bits_sel_dp='1' then --upper
	-- write two lines of logic code here
	   usr_input <= input_dp(3 downto 0) & "0000";
	else
	-- write two lines of logic code here 
	   usr_input <= input_dp;
	end if;
    end process;

    --------------------------------------------------------------
    
    -- ***********************************************************
    -- Write two lines for zero flag and positive flag here (hint: these flags are being detected at the output of 4:1 mux)
    zero_dp <= not (C_muxout(0) or C_muxout(1) or C_muxout(2) or C_muxout(3) or C_muxout(4) or C_muxout(5) or C_muxout(6)or C_muxout(7));
    positive_dp <= not C_muxout(7);
    --------------------------------------------------------------
    
END struct;