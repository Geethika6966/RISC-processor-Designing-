library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	port (
		a, b        : in std_logic_vector(15 downto 0);
		op          : in std_logic;
		c           : out std_logic_vector(15 downto 0);
		zero, carry : out std_logic
	);
end ALU;

architecture struct of ALU is

	signal cout : std_logic;
	signal addition_result, nand_result, temp : std_logic_vector(15 downto 0);

	component SixteenBitAdder is
		port (
			a    : in std_logic_vector (15 downto 0);
			b    : in std_logic_vector (15 downto 0);
			sum  : out std_logic_vector (15 downto 0);
			cout : out std_logic
		);
	end component SixteenBitAdder;

	component SixteenBitNand is
		port (
			a, b   : in std_logic_vector(15 downto 0);
			output : out std_logic_vector(15 downto 0)
		);
	end component SixteenBitNand;

	component MUX16_2x1 is
		port (
			a, b : in std_logic_vector(15 downto 0);
			s0   : in std_logic;
			y    : out std_logic_vector(15 downto 0)
		);
	end component MUX16_2x1;

begin

	op_add : SixteenBitAdder
	port map(
		a    => a,
		b    => b,
		sum  => addition_result,
		cout => cout
	);

	carry <= cout and (not op);

	op_nand : SixteenBitNand
	port map(
		-- in
		a => a, b => b,
		-- out
		output => nand_result
	);

	-- If op = 1, then return nand result, else return addition result
	selector : MUX16_2x1
	port map(
		-- in
		a => addition_result, b => nand_result,
		-- select
		s0 => op,
		-- out
		y => temp
	);

	-- zero is 1 iff all bits of the c are 0
	zero <= not(
		temp(0) or temp(1) or temp(2) or temp(3) or
		temp(4) or temp(5) or temp(6) or temp(7) or
		temp(8) or temp(9) or temp(10) or temp(11) or
		temp(12) or temp(13) or temp(14) or temp(15)
		);

	c <= temp;

end architecture;
