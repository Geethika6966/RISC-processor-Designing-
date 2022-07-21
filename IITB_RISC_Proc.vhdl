-- Top Level Entity
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity IITB_RISC_Proc is
	port (
		clk, reset : in std_logic;
		PC, IR     : out std_logic_vector(15 downto 0);
		done       : out std_logic;
		C, Z       : out std_logic;
		reg0, reg1, reg2, reg3,
		reg4, reg5, reg6, reg7 : out std_logic_vector(15 downto 0)

		
	);
end entity;

architecture struct of IITB_RISC_Proc is

	component RegisterFile is
		port (
			clk, write_flag        : in std_logic;
			addr1, addr2, addr3    : in std_logic_vector(2 downto 0);
			data_write3, PC_in          : in std_logic_vector(15 downto 0);
			data_read1, data_read2, PC_out : out std_logic_vector(15 downto 0); 
			reg0, reg1, reg2, reg3,
		reg4, reg5, reg6, reg7 : out std_logic_vector(15 downto 0)

			
		);
	end component;

	component OneBitRegister is
		port (
			clk, write_flag, data_write : in std_logic;
			data_read                   : out std_logic
		);
	end component;

	component SixteenBitRegister is
		port (
			data_write      : in std_logic_vector(15 downto 0);
			clk, write_flag : in std_logic;
			data_read       : out std_logic_vector(15 downto 0));
	end component;

	component MUX1_2x1 is
		port (
			a, b, s0 : in std_logic;
			y        : out std_logic);
	end component;

	component MUX3_2x1 is
		port (
			a, b : in std_logic_vector(2 downto 0);
			s0   : in std_logic;
			y    : out std_logic_vector(2 downto 0));
	end component;

	component MUX3_4x1 is
		port (
			a, b, c, d : in std_logic_vector(2 downto 0);
			s1, s0     : in std_logic;
			y          : out std_logic_vector(2 downto 0));
	end component;

	component MUX16_2x1 is
		port (
			a, b : in std_logic_vector(15 downto 0);
			s0   : in std_logic;
			y    : out std_logic_vector(15 downto 0));
	end component;

	component MUX16_4x1 is
		port (
			a, b, c, d : in std_logic_vector(15 downto 0);
			s1, s0     : in std_logic;
			y          : out std_logic_vector(15 downto 0));
	end component;

	component ALU is
		port (
			a, b        : in std_logic_vector(15 downto 0);
			op          : in std_logic;
			c           : out std_logic_vector(15 downto 0);
			zero, carry : out std_logic
		);
	end component;
	
	component priority_encoder is
-- Generic (CLK_BITS : INTEGER := 11)
   port (
    ip : in std_logic_vector (7 downto 0);
    op_addr : out std_logic_vector (2 downto 0);
    update : out std_logic_vector (7 downto 0));
    end component;

	component Memory is
		port (
			addr, data_write : in std_logic_vector(15 downto 0);
			clk, write_flag  : in std_logic;
			data_read        : out std_logic_vector(15 downto 0));
	end component;

	component FSM is
		port (
			instruction, T1, T2, mem    : in std_logic_vector(15 downto 0);
		rst, clk, init_carry, init_zero, PE : in std_logic;
		W_PC, W_MEM, W_IR, W_RF, W_T3, W_T2, W_T1,
		M1, M20, M21, M30, M31, M4,
		M5, M60, M61, M7, M80, M81,
		M90, M91, M10, M110, M111,
		carry_write, zero_write, done, alu_control : out std_logic);
	end component;

	signal reg0_out, reg1_out, reg2_out, reg3_out, reg4_out, reg5_out, reg6_out, reg7_out : std_logic_vector(15 downto 0);
  
	signal PC_out1, PC_out2, IR_out, ALU_a, ALU_b, ALU_c, T1_out, T2_out, T3_out, MEM_out, D1_out, D2_out,
	M3_out, M4_out, M5_out, M6_out, M7_out, M8_out,M9_out, M10_out, M11_out, LS1, Imm9e16, SEImm9, SEImm6 : std_logic_vector(15 downto 0);

	signal M1_out, M2_out, PE_out : std_logic_vector(2 downto 0);
   signal ip : std_logic_vector(7 downto 0);
	signal W_PC, W_MEM, W_IR, W_RF, W_T3, W_T1, W_T2,
   M1, M20, M21, M30, M31, M4,M5, M60, M61, M7, M80, M81,M90, M91, M10, M110, M111, PE,
	Z_out, C_out, WC, WZ, Cr_out, Zr_out, T3_zero, alu_control : std_logic;

	signal temp1 : std_logic_vector(9 downto 0);
	signal temp2 : std_logic_vector(6 downto 0);

	constant O16 : std_logic_vector(15 downto 0) := (0 => '1', others => '0');

begin
   --Priority encoder
	PE_R : priority_encoder
   port map(
     --in
	  ip => IR_out(7 downto 0),
	 --out
	 op_addr => PE_out, update => ip
   );
	
	PE <= not( ip(7) or ip(6) or ip(5) or ip(4) or ip(3) or ip(2) or ip(1) or ip(0));
	-- Finite State Machine

	FSM_R : FSM
	port map(
		-- in
		instruction => IR_out, T1 => M6_out, T2 => M7_out, mem => MEM_out,
		rst => reset, clk => clk, init_carry => Cr_out, init_zero => Zr_out, PE => PE,
		-- out
		W_PC => W_PC, W_MEM => W_MEM, W_IR => W_IR, W_RF => W_RF, W_T3 => W_T3, W_T2 => W_T2, W_T1 => W_T1,
		M1 => M1, M20 => M20, M21=>M21, M30 =>M30, M31 =>M31, M4 => M4, M5 => M5, M60 => M60, M61 => M61, M7 =>M7, 
		M80 => M80, M81 => M81, M90 => M90, M91 => M91, M10 => M10, M110 => M110, M111 => M111,
		carry_write => WC, zero_write => WZ, done => done, alu_control => alu_control
	);

	-- Registers

	PC_R : SixteenBitRegister
	port map(
		-- in
		data_write => M4_out, clk => clk,
		-- control pin
		write_flag => W_PC,
		-- out
		data_read => PC_out1
	);

	MEM_R : Memory
	port map(
		-- in
		addr => M11_out, data_write => M10_out, clk => clk,
		-- control pin
		write_flag => W_MEM,
		-- out
		data_read => MEM_out
	);

	IR_R : SixteenBitRegister
	port map(
		-- in
		data_write => MEM_out, clk => clk,
		-- control pin
		write_flag => W_IR,
		--out
		data_read => IR_out
	);
   LS1 <= D2_out(14 downto 0) & "0";
	
	Imm9e16 <= IR_out(8 downto 0) & "0000000";

	temp1 <= (others => IR_out(5));

	SEImm6 <= temp1 & IR_out(5 downto 0);

	temp2 <= (others => IR_out(8));

	SEImm9 <= temp2 & IR_out(8 downto 0);

	RF_R : RegisterFile
	port map(
		-- in
		addr1 => M1_out, addr2 => IR_out(8 downto 6), addr3 => M2_out,
		data_write3 => M3_out, clk => clk, PC_in =>PC_out1,
		-- control pin
		write_flag => W_RF,
		-- out
		data_read1 => D1_out, data_read2 => D2_out,PC_out =>PC_out2,
		reg0 => reg0_out, reg1 => reg1_out, reg2 => reg2_out, reg3 => reg3_out,
		reg4 => reg4_out, reg5 => reg5_out, reg6 => reg6_out, reg7 => reg7_out
	);

	T1_R : SixteenBitRegister
	port map(
		-- in
		data_write => M5_out, clk => clk,
		-- control pin
		write_flag => W_T1,
		--out
		data_read => T1_out
	);

	T2_R : SixteenBitRegister
	port map(
		-- in
		data_write => M6_out, clk => clk,
		-- control pin
		write_flag => W_T2,
		--out
		data_read => T2_out
	);

	T3_R : SixteenBitRegister
	port map(
		-- in
		data_write => M7_out, clk => clk,
		-- control pin
		write_flag => W_T3,
		-- out
		data_read => T3_out
	);

	C_R : OneBitRegister
	port map(
		-- in
		data_write => C_out,
		clk        => clk,
		-- control pin
		write_flag => WC,
		-- out
		data_read => Cr_out
	);

	Z_R : OneBitRegister
	port map(
		-- in
		data_write => Z_out,
		clk        => clk,
		-- control pin
		write_flag => WZ,
		--out
		data_read => Zr_out
	);

	-- ALU

	ALU_en : ALU
	port map(
		-- in
		a => ALU_a, b => ALU_b,
		-- control pin
		op => alu_control,
		-- out
		c => ALU_c,
		--out flags
		zero => Z_out, carry => C_out
	);

	-- MUXes

	MUX1 : MUX3_2x1
	port map(
		-- in
		a => IR_out(11 downto 9), b => PE_out,
		-- select
		s0 => M1,
		-- out
		y => M1_out
	);

	MUX2 : MUX3_4x1
	port map(
		-- in
		a => IR_out(5 downto 3), b =>IR_out(8 downto 6), c => IR_out(11 downto 9), d => PE_out,
		-- select
		s1 => M21, s0 => M20,
		-- out
		y => M2_out
	);

	MUX3 : MUX16_4x1
	port map(
		-- in
		a => T3_out, b => Imm9e16, c=> T2_out, d => PC_out1,
		-- select
		s1 => M31, s0 =>M30,
		-- out
		y => M3_out);

	MUX4 : MUX16_2x1
	port map(
		-- in
		a => Alu_c, b => T2_out,
		-- select
		s0 => M4,
		-- out
		y => M4_out
	);

	MUX5 : MUX16_2x1
	port map(
		-- in
		a => D1_out, b => ALU_c,
		-- select
		s0 => M5,
		-- out
		y => M5_out
	);

	MUX6 : MUX16_4x1
	port map(
		-- in
		a => D2_out, b => LS1, c => D1_out, d => Mem_out,
		-- select
		s0 => M60, s1 => M61,
		-- out
		y => M6_out
	);

	MUX7 : MUX16_2x1
	port map(
		-- in
		  a => MEM_out, b => ALU_c,
		-- select
		s0 => M7,
		--out
		y => M7_out
	);

	MUX8 : MUX16_4x1
	port map(
		-- in
		a => T1_out, b => PC_out1, c => T2_out, d => D1_out,
		-- select
		s1 => M81, s0 => M80,
		--out
		y => M8_out
	);

	MUX9 : MUX16_4x1
	port map(
		-- in
		a => T2_out, b => O16, c => SEImm6, d => SEImm9,
		-- select
		s1 => M91, s0 => M90,
		-- out
		y => ALU_b
	);

	MUX10 : MUX16_2x1
	port map(
		-- in
		a => T1_out, b => T2_out,
		-- select
		s0 => M10,
		-- out
		y => ALU_a
	);

	MUX11 : MUX16_4x1
	port map(
		-- in
		a => PC_out1, b => T3_out, c => ALU_c, d => T1_out,
		-- select
		s0 => M110, s1 => M111,
		--out
		y => M11_out
	);

	-- Output to Testbench

	PC <= PC_out2;
	IR <= IR_out;
	C <= Cr_out;
	Z <= Zr_out;
	reg0 <= reg0_out;
	reg1 <= reg1_out;
	reg2 <= reg2_out;
	reg3 <= reg3_out;
	reg4 <= reg4_out;
	reg5 <= reg5_out;
	reg6 <= reg6_out;
	reg7 <= reg7_out;
	
end struct;
