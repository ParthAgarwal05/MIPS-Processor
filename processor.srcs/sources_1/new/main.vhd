library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic
    );
end main;

architecture Structural of main is

    -- IF → ID
    signal instruction  : std_logic_vector(31 downto 0);
    signal PC_if_to_id  : std_logic_vector(29 downto 0);

    -- ID → EX
    signal opcode       : std_logic_vector(3 downto 0);
    signal rs, rt, rd   : std_logic_vector(4 downto 0);
    signal rs_data,
           rt_data      : std_logic_vector(31 downto 0);
    signal immediate    : std_logic_vector(15 downto 0);
    signal sign_ext_imm : std_logic_vector(31 downto 0);
    signal j_address    : std_logic_vector(25 downto 0);
    signal PC_id_out    : std_logic_vector(29 downto 0);

    -- EX output → for control
    signal alu_result    : std_logic_vector(31 downto 0);
    signal branch_taken  : std_logic;
    signal branch_target : std_logic_vector(29 downto 0);
    signal jump_target   : std_logic_vector(29 downto 0);
    signal jump_taken    : std_logic;

begin

    -- IF Stage
    IF_Inst : entity work.IF_Stage
        port map (
            clk           => clk,
            reset         => reset,
            jump_taken    => jump_taken,     -- from EX stage
            jump_target   => jump_target,    -- from EX stage
            branch_taken  => branch_taken,   -- NEW: from EX stage
            branch_target => branch_target,  -- NEW: from EX stage
            instruction   => instruction,
            PC_out        => PC_if_to_id
        );

    -- ID Stage
    ID_Inst : entity work.ID_Stage
        port map (
            clk           => clk,
            reset         => reset,
            instruction   => instruction,
            PC_in         => PC_if_to_id,
            opcode        => opcode,
            rs            => rs,
            rt            => rt,
            rd            => rd,
            rs_data       => rs_data,
            rt_data       => rt_data,
            immediate     => immediate,
            sign_ext_imm  => sign_ext_imm,
            j_address     => j_address,
            PC_out        => PC_id_out
        );

    -- EXE Stage
    EXE_Inst : entity work.EXE_Stage
        port map (
            opcode        => opcode,
            rs_data       => rs_data,
            rt_data       => rt_data,
            sign_ext_imm  => sign_ext_imm,
            j_address     => j_address,
            PC_in         => PC_id_out,
            alu_result    => alu_result,
            branch_taken  => branch_taken,
            branch_target => branch_target,
            jump_target   => jump_target,
            jump_taken    => jump_taken
        );

end Structural;
