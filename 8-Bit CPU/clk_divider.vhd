----------------------------------------------------------------------------------
-- Company: University of Alberta, Edmonton
-- Engineer: Shyama Gandhi
-- 
-- Create Date: 02/10/2022 
-- Design Name: 
-- Module Name: clk_divider - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_divider is
    generic( divider: positive := 62500000);
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end clk_divider;

architecture Behavioral of clk_divider is
signal clock_out : std_logic := '0';
signal count : integer := 1;
begin
    process(clk_in)
    begin
        if clk_in='1' and clk_in'event then
            count <= count + 1;
            if(count >= divider) then
                clock_out <= NOT clock_out;
                count <= 1;
            end if;
        end if;            
    clk_out <= clock_out;
    end process;
end Behavioral;
