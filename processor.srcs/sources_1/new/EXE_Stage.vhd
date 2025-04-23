library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EXE_Stage is
    Port (
        opcode        : in std_logic_vector(3 downto 0);
        rs_data       : in std_logic_vector(31 downto 0);
        rt_data       : in std_logic_vector(31 downto 0);
        sign_ext_imm  : in std_logic_vector(31 downto 0);
        j_address     : in std_logic_vector(25 downto 0);
        PC_in         : in std_logic_vector(29 downto 0);

        alu_result    : out std_logic_vector(31 downto 0);
        branch_taken  : out std_logic;
        branch_target : out std_logic_vector(29 downto 0);
        jump_target   : out std_logic_vector(29 downto 0);
        jump_taken    : out std_logic  -- Added jump_taken signal
    );
end EXE_Stage;

architecture Behavioral of EXE_Stage is
    signal alu_out      : std_logic_vector(31 downto 0);
    signal branch_addr  : std_logic_vector(29 downto 0);
    signal jump_addr    : std_logic_vector(29 downto 0);
    signal branch_cond  : std_logic := '0';
begin

    process(opcode, rs_data, rt_data, sign_ext_imm, j_address, PC_in)
        variable offset : signed(29 downto 0);
        variable jump_shifted : std_logic_vector(25 downto 0);
    begin
        branch_taken <= '0';
        alu_out <= (others => '0');
        branch_target <= (others => '0');
        jump_target <= (others => '0');
        jump_taken <= '0';  -- Default is no jump

        case opcode is
            -- R-type ALU operations
            when "0000" => alu_out <= std_logic_vector(signed(rs_data) + signed(rt_data)); -- add
            when "0001" => alu_out <= std_logic_vector(signed(rs_data) - signed(rt_data)); -- sub
            when "0010" => alu_out <= rs_data and rt_data; -- and
            when "0011" => alu_out <= rs_data or rt_data;  -- or
            when "0100" => alu_out <= rs_data xor rt_data; -- xor
            when "0101" => -- slt
                if signed(rs_data) < signed(rt_data) then
                    alu_out <= (others => '0'); alu_out(0) <= '1';
                else
                    alu_out <= (others => '0');
                end if;

            -- I-type ALU operations
            when "0110" => alu_out <= std_logic_vector(signed(rs_data) + signed(sign_ext_imm)); -- addi
            when "0111" => -- slti
                if signed(rs_data) < signed(sign_ext_imm) then
                    alu_out <= (others => '0'); alu_out(0) <= '1';
                else
                    alu_out <= (others => '0');
                end if;
            when "1000" => alu_out <= rs_data and sign_ext_imm; -- andi
            when "1001" => alu_out <= rs_data or sign_ext_imm;  -- ori
            when "1010" => alu_out <= rs_data xor sign_ext_imm; -- xori

            -- lw/sw: calculate memory address
            when "1011" | "1100" => -- lw/sw
                alu_out <= std_logic_vector(signed(rs_data) + signed(sign_ext_imm));

            -- beq
            when "1101" =>
                if rs_data = rt_data then
                    branch_taken <= '1';
                    offset := resize(signed(sign_ext_imm), 30) sll 2;
                    branch_target <= std_logic_vector(signed(PC_in) + offset + 4);
                end if;

            -- bne
            when "1110" =>
                if rs_data /= rt_data then
                    branch_taken <= '1';
                    offset := resize(signed(sign_ext_imm), 30) sll 2;
                    branch_target <= std_logic_vector(signed(PC_in) + offset + 4);
                end if;

            -- j (Jump)
            when "1111" =>
                jump_shifted := j_address;  -- Left shift the address
                jump_target <= PC_in(29 downto 26) & jump_shifted;  -- Concatenate upper 4 bits of PC
                jump_taken <= '1';  -- Set jump_taken to 1 when a jump is encountered

            when others =>
                alu_out <= (others => '0');
        end case;
    end process;

    alu_result <= alu_out;

end Behavioral;
