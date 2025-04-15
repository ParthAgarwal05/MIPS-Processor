library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ID_Stage is
    Port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        instruction : in  std_logic_vector(31 downto 0);
        PC_in       : in  std_logic_vector(29 downto 0);

        opcode       : out std_logic_vector(3 downto 0);
        rs           : out std_logic_vector(4 downto 0);
        rt           : out std_logic_vector(4 downto 0);
        rd           : out std_logic_vector(4 downto 0);
        rs_data      : out std_logic_vector(31 downto 0);
        rt_data      : out std_logic_vector(31 downto 0);
        immediate    : out std_logic_vector(15 downto 0);
        sign_ext_imm : out std_logic_vector(31 downto 0);
        PC_out       : out std_logic_vector(29 downto 0)
    );
end ID_Stage;

architecture Behavioral of ID_Stage is

    type reg_file_type is array (0 to 31) of std_logic_vector(31 downto 0);
    signal reg_file : reg_file_type := (
        0 => x"00000000", 1 => x"00000001", 2 => x"00000002", 3 => x"00000003",
        4 => x"00000004", 5 => x"00000005", 6 => x"00000006", 7 => x"00000007",
        others => (others => '0')
    );

    signal opcode_s    : std_logic_vector(3 downto 0);
    signal rs_s, rt_s, rd_s : std_logic_vector(4 downto 0);
    signal imm_s       : std_logic_vector(15 downto 0);

begin

    opcode_s <= instruction(29 downto 26);
    rs_s     <= instruction(25 downto 21);
    rt_s     <= instruction(20 downto 16);
    rd_s     <= instruction(15 downto 11);
    imm_s    <= instruction(15 downto 0);

    opcode    <= opcode_s;
    rs        <= rs_s;
    rt        <= rt_s;
    rd        <= rd_s;
    immediate <= imm_s;

    rs_data <= reg_file(to_integer(unsigned(rs_s)));
    rt_data <= reg_file(to_integer(unsigned(rt_s)));

    sign_ext_imm <= (15 downto 0 => imm_s(15)) & imm_s;

    PC_out <= PC_in;

end Behavioral;
