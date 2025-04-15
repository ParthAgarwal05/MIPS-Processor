library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IF_Stage_tb is
end IF_Stage_tb;

architecture Behavioral of IF_Stage_tb is

    component IF_Stage is
        Port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            PC_out      : out std_logic_vector(29 downto 0);
            instruction : out std_logic_vector(31 downto 0)
        );
    end component;

    signal clk         : std_logic := '0';
    signal reset       : std_logic := '1';
    signal PC_out      : std_logic_vector(29 downto 0);
    signal instruction : std_logic_vector(31 downto 0);

begin

    uut: IF_Stage
        Port map (
            clk         => clk,
            reset       => reset,
            PC_out      => PC_out,
            instruction => instruction
        );

    clk_process :process
    begin
        while now < 100 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        wait for 10 ns;
        reset <= '0';  

        wait for 80 ns;

        wait;
    end process;

end Behavioral;
