----------------------------------------------------------------------------------
-- Company: 
-- Engineer:Nitheesh Manjunath 
-- 
-- Create Date: 01/05/2022 10:34:16 AM
-- Design Name: cdc
-- Module Name: cdc - Behavioral
-- Project Name: NA
-- Target Devices: 
-- Tool Versions: 
-- Description: Single bit toggle Clock Domain Crossing
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Works
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

entity cdc is
 generic(
    DW : integer
 );
  Port (
    clk_src     : in std_logic;
    valid_src   : in std_logic;
    data_src    : in std_logic_vector(DW-1 downto 0);
    
    clk_dest    : in std_logic;
    valid_dest  : out std_logic;
    data_dest   : out std_logic_vector(DW-1 downto 0)
  );
end cdc;

architecture Behavioral of cdc is
    
signal data_src_r, data_dest_r : std_logic_vector(DW-1 downto 0) := (others => '0');
signal xor_src, xor_dest  : std_logic := '0';
signal sync_src     : std_logic := '0';
signal sync_dest    : std_logic_vector(2 downto 0) := (others => '0');
signal valid_dest_r : std_logic := '0';

begin

--Control path
xor_src <= valid_src xor sync_src;

process(clk_src) begin
    if rising_edge(clk_src) then
        sync_src    <= xor_src;
    end if; 
end process;

process(clk_dest) begin
    if rising_edge(clk_dest) then
        sync_dest     <= sync_dest(1) & sync_dest(0) & sync_src;
        valid_dest_r  <= xor_dest;
    end if; 
end process;

xor_dest <= sync_dest(2) xor sync_dest(1);

--Data path
process(clk_src) begin
    if rising_edge(clk_src) then
        if (valid_src = '1') then
            data_src_r  <= data_src;
        end if;
    end if; 
end process;

process(clk_dest) begin
    if rising_edge(clk_dest) then
        if(xor_dest = '1') then 
           data_dest_r    <= data_src_r; 
        end if; 
    end if; 
end process;

data_dest   <= data_dest_r;
valid_dest  <= valid_dest_r;

end Behavioral;
