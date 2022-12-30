----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
--
-- Create Date: 10/29/2020 07:18:24 PM
-- Updated Date: 01/11/2021
-- Design Name: CONTROLLER FOR THE CPU
-- Module Name: cpu - behavioral(controller)
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: CPU_LAB 3 - ECE 410 (2021)
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Additional Comments:
--*********************************************************************************
-- The controller implements the states for each instructions and asserts appropriate control signals for the datapath during every state.
-- For detailed information on the opcodes and instructions to be executed, refer the lab manual.
-----------------------------


LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- needed for CONV_INTEGER()

ENTITY controller IS PORT (
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
            PC_out          : out std_logic_vector(4 downto 0);
            OP_out          : out std_logic_vector(3 downto 0);
            ---------------------------------------------------
            bit_sel_ctrl    : OUT std_logic;
            bits_shift_ctrl : OUT std_logic_vector(1 downto 0); 
            ---------------------------------------------------
            done            : out std_logic);
END controller;

architecture Behavior of controller is

TYPE state_type IS (Fetch,Decode,LDA_execute,STA_execute,LDI_execute, ADD_execute, SUB_execute, SHFL_execute, SHFR_execute,
                    input_A, output_A, Halt_cpu, JZ_execute, flag_state, ADD_SUB_SL_SR_next);

SIGNAL state: state_type;
SIGNAL IR: std_logic_vector(7 downto 0);
SIGNAL PC: integer RANGE 0 to 31;


-- Instructions and their opcodes (pre-decided)
    CONSTANT LDA : std_logic_vector(3 DOWNTO 0) := "0001";  
    CONSTANT STA : std_logic_vector(3 DOWNTO 0) := "0010";  
    CONSTANT LDI : std_logic_vector(3 DOWNTO 0) := "0011";  
    
    CONSTANT ADD : std_logic_vector(3 DOWNTO 0) := "0100"; 
    CONSTANT SUB : std_logic_vector(3 DOWNTO 0) := "0101"; 
    
    CONSTANT SHFL : std_logic_vector(3 DOWNTO 0) := "0110";  
    CONSTANT SHFR : std_logic_vector(3 DOWNTO 0) := "0111";  
    
    CONSTANT INA  : std_logic_vector(3 DOWNTO 0) := "1000";   
    CONSTANT OUTA : std_logic_vector(3 DOWNTO 0) := "1001";   
    CONSTANT HALT : std_logic_vector(3 DOWNTO 0) := "1010";   
    
    CONSTANT JZ   : std_logic_vector(3 DOWNTO 0) := "1100";
    
    TYPE PM_BLOCK IS ARRAY(0 TO 31) OF std_logic_vector(7 DOWNTO 0); -- program memory that will store the instructions sequentially from part 1 and part 2 test program
    
BEGIN
    
    --opcode is kept up-to-date
    OP_out <= IR(7 downto 4);
    
    PROCESS(clk_ctrl ) -- complete the sensitivity list ********************************************
    
        -- "PM" is the program memory that holds the instructions to be executed by the CPU 
        VARIABLE PM                      : PM_BLOCK;     

        -- To decode the 4 MSBs from the PC content
        VARIABLE OPCODE                  : std_logic_vector( 3 DOWNTO 0);

        -- Zero flag and positive flag
        VARIABLE zero_flag, positive_flag: std_logic;
        
        BEGIN
            IF (rst_ctrl='1') THEN -- RESET initializes all the control signals to 0.
                PC <= 0;
                muxsel_ctrl <= "00";
                imm_ctrl <= (OTHERS => '0');
                accwr_ctrl <= '0';
                rfaddr_ctrl <= "000";
                rfwr_ctrl <= '0';
                alusel_ctrl <= "000";
                outen_ctrl <= '0';
                done       <= '0';
                bit_sel_ctrl <= '0';
                bits_shift_ctrl <= "00";
                state <= Fetch;    

-- *************** assembly code for PART1/PART2 goes here
                -- for example this is how the instructions will be stored in the program memory
--                PM(0) := "XXXXXXXX"; 
                   PM(0) := "10000000"; -- IN A
                   PM(1) := "10000000"; -- IN A
                   PM(2) := "11000000"; -- JMPZ 05
                   PM(3) := "00000101"; -- 05               
                   PM(4) := "01100010"; -- SHFL A
                   PM(5) := "10010000"; -- OUT A         
                   PM(6) := "00110000"; -- LDI A, 10
                   PM(7) := "00001010"; -- 10
                   PM(8) := "01110001"; -- SHFR A
                   PM(9) := "10010000"; -- OUT A
                   PM(10) := "10100000"; -- HALT
                   
--                   PM(0) := "10000000"; -- IN A
--                   PM(1) := "10000000"; -- IN A
--                   PM(2) := "00100000"; -- STA R[0], A
--                   PM(3) := "00110000"; -- LDI A, 15          
--                   PM(4) := "00001111"; -- 15
--                   PM(5) := "01000000"; -- ADD A, R[0]
--                   PM(6) := "10010000"; -- OUT A
--                   PM(7) := "10100000"; -- HALT   

                
-- **************

           ELSIF (clk_ctrl'event and clk_ctrl = '1') THEN
                CASE state IS
                    WHEN Fetch => -- fetch instruction
                                if(enter = '1')then
                                    PC_out <= conv_std_logic_vector(PC,5);
	      			    -- ****************************************
                                    -- write one line of code to get the 8-bit instruction into IR                      
	                                   IR <= PM(PC);
				    -------------------------------------------
			            
                                    PC <= PC + 1;
                                    muxsel_ctrl <= "00";
                                    imm_ctrl <= (OTHERS => '0');
                                    accwr_ctrl <= '0';
                                    rfaddr_ctrl <= "000";
                                    rfwr_ctrl <= '0';
                                    alusel_ctrl <= "000";
                                    outen_ctrl <= '0';
                                    done       <= '0';
                                    zero_flag := zero_ctrl;
                                    positive_flag := positive_ctrl;                                       
                                    state <= Decode;
                                elsif(enter = '0')then
                                    state <= Fetch;
                                end if;

                    WHEN Decode => -- decode instruction
                    
                            OPCODE := IR(7 downto 4);
                            
                            CASE OPCODE IS
                                WHEN LDA => state   <= LDA_execute;
                                WHEN STA => state   <= STA_execute;
                                WHEN LDI => state   <= LDI_execute;
                                WHEN ADD => state   <= ADD_execute;
                                WHEN SUB => state   <= SUB_execute;
                                WHEN SHFL => state  <= SHFL_execute;
                                WHEN SHFR => state  <= SHFR_execute;
                                WHEN INA  => state  <= input_A;
                                WHEN OUTA => state  <= output_A;
                                WHEN HALT => state  <= Halt_cpu;
                                WHEN JZ   => state  <= JZ_execute;
                                WHEN OTHERS => state <= Halt_cpu;
                                
                            END CASE;
                            
                            muxsel_ctrl <= "00";
                            imm_ctrl <= PM(PC);  --since the PC is incremented here, I am just doing the pre-fetching. Will relax the requirement for PM to be very fast for LDI to work properly.
                            accwr_ctrl <= '0';
                            rfaddr_ctrl <= IR(2 downto 0);  --Decode pre-emptively sets up the register file, just to reduce the delay for waiting one more cycle
                            rfwr_ctrl <= '0';
                            alusel_ctrl <= "000";
                            outen_ctrl <= '0';
                            done       <= '0';
                            bit_sel_ctrl <= IR(0);
                            bits_shift_ctrl <= IR(1 downto 0);
                            
                    WHEN flag_state => -- set zero and positive flags and then goto next instruction
                            muxsel_ctrl <= "00";
                            imm_ctrl <= (OTHERS => '0');
                            accwr_ctrl <= '0';
                            rfaddr_ctrl <= "000";
                            rfwr_ctrl <= '0';
                            alusel_ctrl <= "000";
                            outen_ctrl <= '0';
                            done       <= '0';
                            state <= Fetch;
                            zero_flag := zero_ctrl;
                            positive_flag := positive_ctrl;     
                            
                    WHEN ADD_SUB_SL_SR_next => -- next state TO add, sub,shfl, shfr
                            muxsel_ctrl <= "00";
                            imm_ctrl <= (OTHERS => '0');
                            accwr_ctrl <= '1';
                            rfaddr_ctrl <= "000";   
                            rfwr_ctrl <= '0';
                            alusel_ctrl <= "000";
                            outen_ctrl <= '0';
                            state <= flag_state;
                            
                    WHEN LDA_execute => -- LDA 
                            muxsel_ctrl <= "01";
                            imm_ctrl <= (OTHERS => '0');
                            accwr_ctrl <= '1';
                            rfwr_ctrl <= '0';
                            alusel_ctrl <= "000";
                            outen_ctrl <= '0';
                        
                            state <= Fetch;
      			    ------------------------------------
    
                    WHEN STA_execute => -- STA 
                            muxsel_ctrl <= "00";
                            imm_ctrl <= (OTHERS => '0');
                            accwr_ctrl <= '0';
                            rfaddr_ctrl <= IR(2 DOWNTO 0);
                            rfwr_ctrl <= '1';
                            alusel_ctrl <= "000";
                            outen_ctrl <= '0';
                            done       <= '0';
                            state <= Fetch;   
                            
                    WHEN LDI_execute => -- LDI 
                            muxsel_ctrl <= "11"; 
                            accwr_ctrl <= '1';
                            rfaddr_ctrl <= "000";
                            rfwr_ctrl <= '0';
                            alusel_ctrl <= "000";
                            outen_ctrl <= '0';
                            done       <= '0';
                             PC <= PC + 1;
                            state <= Fetch; 
			    ------------------------------------
                            
                    WHEN JZ_execute => -- JZ
                            muxsel_ctrl <= "00";
                            accwr_ctrl <= '0';
                            rfaddr_ctrl <= "000";
                            rfwr_ctrl <= '0';
                            alusel_ctrl <= "000";
                            outen_ctrl <= '0';
                            done       <= '0';
                            
                            if (zero_flag = '1') then 
                                PC <= conv_integer(unsigned(imm_ctrl(4 downto 0)));
                             else
                                 PC <= PC + 1;
                   end if;
                   state <= Fetch;                   

			    ------------------------------------

                    WHEN ADD_execute => -- ADD 
                            muxsel_ctrl <= "00";
                            imm_ctrl <= (OTHERS => '0');
                            accwr_ctrl <= '0';
                            rfaddr_ctrl <= "000";
                            rfwr_ctrl <= '0';
                            alusel_ctrl <= "100";
                            outen_ctrl <= '0';
                            done       <= '0';
                            state <= ADD_SUB_SL_SR_next; 

			    ------------------------------------
 
                    WHEN SUB_execute => -- SUB 
                            muxsel_ctrl <= "00";
                            imm_ctrl <= (OTHERS => '0');
                            accwr_ctrl <= '0';
                            rfaddr_ctrl <= "000";
                            rfwr_ctrl <= '0';
                            alusel_ctrl <= "101";
                            outen_ctrl <= '0';
                            done       <= '0';
                            state <= ADD_SUB_SL_SR_next; 

			    ------------------------------------

                    WHEN SHFL_execute => -- SHFL
                            muxsel_ctrl <= "00";
                            imm_ctrl <= (OTHERS => '0');
                            accwr_ctrl <= '0';
                            rfaddr_ctrl <= "000";
                            rfwr_ctrl <= '0';
                            alusel_ctrl <= "010";
                            outen_ctrl <= '0';
                            bits_shift_ctrl <= IR(1 downto 0);
                            done       <= '0';
                            state <= ADD_SUB_SL_SR_next; 

			    ------------------------------------
                            
                    WHEN SHFR_execute => -- SHFR 
                            muxsel_ctrl <= "00";
                            imm_ctrl <= (OTHERS => '0');
                            accwr_ctrl <= '0';
                            rfaddr_ctrl <= "000";
                            rfwr_ctrl <= '0';
                            alusel_ctrl <= "011";
                            outen_ctrl <= '0';
                            bits_shift_ctrl <= IR(1 downto 0);
                            done       <= '0';
                            state <= ADD_SUB_SL_SR_next; 

			    ------------------------------------
                    
                    WHEN input_A => -- INA
                            muxsel_ctrl <= "10";
                            imm_ctrl <= (OTHERS => '0');
                            accwr_ctrl <= '1';
                            rfaddr_ctrl <= "000";
                            rfwr_ctrl <= '0';
                            alusel_ctrl <= "000";
                            outen_ctrl <= '0';
                            done       <= '0';
                            state <= flag_state;
                            bit_sel_ctrl <= IR(0);
                            
                    WHEN output_A => -- OUTA
                            muxsel_ctrl <= "00";
                            imm_ctrl <= (OTHERS => '0');
                            accwr_ctrl <= '0';
                            rfaddr_ctrl <= "000";
                            rfwr_ctrl <= '0';
                            alusel_ctrl <= "000";
                            outen_ctrl <= '1';
                            done       <= '0';
                            state <= Fetch; 

			    ------------------------------------

                    WHEN Halt_cpu => -- HALT
                            muxsel_ctrl <= "00";
                            imm_ctrl <= (OTHERS => '0');
                            accwr_ctrl <= '0';
                            rfaddr_ctrl <= "000";
                            rfwr_ctrl <= '0';
                            alusel_ctrl <= "000";
                            outen_ctrl <= '1';
                            done       <= '1';
                            state <= Halt_cpu;
    
                    WHEN OTHERS =>
                            muxsel_ctrl <= "00";
                            imm_ctrl <= (OTHERS => '0');
                            accwr_ctrl <= '0';
                            rfaddr_ctrl <= "000";
                            rfwr_ctrl <= '0';
                            alusel_ctrl <= "000";
                            outen_ctrl <= '1';
                            done       <= '1';
                            state <= Halt_cpu;
                END CASE;
        END IF;

    END PROCESS;
end Behavior;    
