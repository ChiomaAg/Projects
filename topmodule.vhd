----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
--
-- Create Date: 10/29/2020 07:18:24 PM
-- Design Name: CONTROLLER FOR THE CPU
-- Module Name: cpu
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
-- This is the top module file for the cpu, clk_divider and the seven segment
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

entity topmodule is
  Port ( clk        : in std_logic;
         rst_button : in std_logic;
         entered_input     : in std_logic;
         input_sw          : in std_logic_vector(2 downto 0);
         OPcode_LED      : out std_logic_vector(3 downto 0);
         PC_on_7_seg     : out std_logic_vector(6 downto 0);
         select_segment  : out std_logic;
         done_signal     : out std_logic  );
end topmodule;

architecture Behavioral of topmodule is

component cpu_ctrl_dp port (
        clk_cpu     : in std_logic;
        rst_cpu     : IN std_logic;
        entered_ip  : IN std_logic;
        input_cpu   : IN std_logic_vector(7 DOWNTO 0);
        output_cpu  : OUT std_logic_vector(7 DOWNTO 0);
        PC_output   : OUT std_logic_vector(4 downto 0);
        OPCODE_ouput: OUT std_logic_vector(3 downto 0);
        done_cpu    : OUT std_logic);
end component;

component sev_segment Port ( 
        --output of PC from cpu
        DispVal : in  STD_LOGIC_VECTOR (4 downto 0);
        anode: out std_logic;
        clk : in std_logic;
        --controls which digit to display
        segOut : out  STD_LOGIC_VECTOR (6 downto 0));
end component;
 
component clk_divider   generic( divider: positive := 62500000);
                        Port ( clk_in : in STD_LOGIC;
                             clk_out : out STD_LOGIC);
end component;


signal clk_1Hz         : std_logic;
signal in_modified     : std_logic_vector(7 downto 0);
signal output_from_cpu : std_logic_vector(7 downto 0);
signal PC              : std_logic_vector(4 downto 0);

begin
    
    in_modified  <= "00000" & input_sw; 
    
    clk_div : clk_divider 
                          port map(clk_in   =>  clk,
                                   clk_out  =>  clk_1Hz);
                                   
                                   
    cpu_core: cpu_ctrl_dp port map( clk_cpu    => clk_1Hz,
                                    rst_cpu    => rst_button,
                                    entered_ip => entered_input,
                                    input_cpu  => in_modified,		-- port map this signal
                                    output_cpu => output_from_cpu, 		-- port map this signal
                                    PC_output  => PC,
                                    OPCODE_ouput =>  OPcode_LED,		-- port map this signal
                                    done_cpu => done_signal );		-- port map this signal

    seven_seg: component sev_segment port map(DispVal => PC,
                                              clk     => clk,
                                              anode   => select_segment,
                                              segOut  => PC_on_7_seg);

end Behavioral;
