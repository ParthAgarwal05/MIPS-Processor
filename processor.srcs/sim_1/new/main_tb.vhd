library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity main_tb is
end main_tb;

architecture Behavioral of main_tb is

    component main
        Port (
            clk   : in  std_logic;
            reset : in  std_logic
        );
    end component;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';

begin

    DUT: main
        port map (
            clk   => clk,
            reset => reset
        );

    -- Clock generation
    clk_process: process
    begin
        while now < 200 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Reset logic
    stim_proc: process
    begin
        wait for 10 ns;
        reset <= '0';
        wait;
    end process;

end Behavioral;
