library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IF_Stage is
    Port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        PC_out      : out std_logic_vector(29 downto 0);
        instruction : out std_logic_vector(31 downto 0)  
    );
end IF_Stage;

architecture Behavioral of IF_Stage is
    signal PC_in : std_logic_vector(29 downto 0) := (others => '0');

    type mem_type is array (0 to 255) of std_logic_vector(31 downto 0);
    signal instruction_mem : mem_type := (
        0 => x"12345678",
        1 => x"ABCDEF01",
        others => (others => '0')
    );
begin

    process(clk, reset)
    begin
        if reset = '1' then
            PC_in <= (others => '0');
        elsif rising_edge(clk) then
            PC_in <= std_logic_vector(unsigned(PC_in) + 4);  
        end if;
    end process;

    instruction <= instruction_mem(to_integer(unsigned(PC_in(29 downto 2))));
    PC_out <= PC_in;
    
end Behavioral;
