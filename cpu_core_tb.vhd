----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
--
-- Create Date: 10/29/2020 07:18:24 PM
-- Design Name:
-- Module Name: cpu _core test bench
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
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY cpu_core_tb IS
END cpu_core_tb;
 
ARCHITECTURE behavior OF cpu_core_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
  COMPONENT cpu_ctrl_dp PORT(
                    clk_cpu     : in std_logic;
                    rst_cpu     : IN std_logic;
                    entered_ip  : IN std_logic;
                    input_cpu   : IN std_logic_vector(7 DOWNTO 0);
                    output_cpu  : OUT std_logic_vector(7 DOWNTO 0);
                    PC_output   : OUT std_logic_vector(4 downto 0);
                    OPCODE_ouput: OUT std_logic_vector(3 downto 0);
                    done_cpu    : OUT std_logic);
  END COMPONENT;

  signal clk_tb : std_logic := '0';
  signal rst_tb : std_logic := '0';
  signal in_tb : std_logic_vector(7 downto 0);
  signal opcode_tb   : std_logic_vector(3 downto 0);
  signal pc_tb       : std_logic_vector(4 downto 0);
  signal output_tb   : std_logic_vector(7 downto 0);
  signal enter       : std_logic;
  signal done        : std_logic;
   
   -- Clock period definitions
   constant clk_period : time := 8 ns;
  
begin
    -- Instantiate the Unit Under Test (UUT)
   uut: cpu_ctrl_dp PORT MAP (
                              clk_cpu       => clk_tb,
                              rst_cpu       => rst_tb,
                              entered_ip    => enter,
                              input_cpu     => in_tb,
                              output_cpu    => output_tb,
                              PC_output     => pc_tb,
                              OPCODE_ouput  => opcode_tb,
                              done_cpu      => done);
   -- Clock process definitions
   clk_process :process
   begin
		clk_tb <= '0';
		wait for clk_period/2;
		clk_tb <= '1';
		wait for clk_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
     rst_tb <= '1';
     wait for clk_period;
     rst_tb <= '0';
     in_tb <= "00000000";
     enter <= '1';
     wait for clk_period;
     wait on done;
     
     rst_tb <= '1';
     wait for clk_period;
     rst_tb <= '0';
     in_tb <= "00000001";
     enter <= '1';
     wait for clk_period;
     wait on done;

     WAIT;
	-----------------------------------
   end process;

end behavior;