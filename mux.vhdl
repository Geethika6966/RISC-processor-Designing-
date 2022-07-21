-- Component: Package of different MUXes
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

package MUXes is

	-- (a) MUX1_2x1: 2 inputs, 1 output, 1 selector, each input is a single bit
	component MUX1_2x1 is
		port (
			a, b, s0 : in std_logic;
			y        : out std_logic
		);
	end component MUX1_2x1;

	-- (b) MUX1_4x1: 4 inputs, 1 output, 2 selectors, each input is a single bit
	component MUX1_4x1 is
		port (
			a, b, c, d, s1, s0 : in std_logic;
			y                  : out std_logic
		);
	end component MUX1_4x1;

	-- (c) MUX3_2x1: 2 inputs, 1 output, 1 selector, each input is a 3-bit vector
	component MUX3_2x1 is
		port (
			a, b : in std_logic_vector(2 downto 0);
			s0   : in std_logic;
			y    : out std_logic_vector(2 downto 0)
		);
	end component MUX3_2x1;

	-- (d) MUX3_4x1: 4 inputs, 1 output, 2 selectors, each input is a 3-bit vector
	component MUX3_4x1 is
		port (
			a, b, c, d : in std_logic_vector(2 downto 0);
			s1, s0     : in std_logic;
			y          : out std_logic_vector(2 downto 0)
		);
	end component MUX3_4x1;

	-- (e) MUX16_2x1: 2 inputs, 1 output, 1 selector, each input is a 16-bit vector
	component MUX16_2x1 is
		port (
			a, b : in std_logic_vector(15 downto 0);
			s0   : in std_logic;
			y    : out std_logic_vector(15 downto 0)
		);
	end component MUX16_2x1;

	-- (f) MUX16_4x1: 4 inputs, 1 output, 2 selectors, each input is a 16-bit vector
	component MUX16_4x1 is
		port (
			a, b, c, d : in std_logic_vector(15 downto 0);
			s1, s0     : in std_logic;
			y          : out std_logic_vector(15 downto 0)
		);
	end component MUX16_4x1;

end package MUXes;
-- (a) MUX1_2x1: 2 inputs, 1 output, 1 selector, each input is a single bit
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity MUX1_2x1 is
	port (
		a, b, s0 : in std_logic;
		y        : out std_logic
	);
end MUX1_2x1;

architecture arch of MUX1_2x1 is
begin
	y <= (a and not s0) or (b and s0);
end architecture;
-- (b) MUX1_4x1: 4 inputs, 1 output, 2 selectors, each input is a single bit
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity MUX1_4x1 is
	port (
		a, b, c, d, s1, s0 : in std_logic;
		y                  : out std_logic
	);
end MUX1_4x1;

architecture arch of MUX1_4x1 is
begin
	y <= (a and (not s1) and (not s0))
		or (b and (not s1) and (s0))
		or (c and (s1) and (not s0))
		or (d and (s1) and (s0));
end architecture;
-- (c) MUX3_2x1: 2 inputs, 1 output, 1 selector, each input is a 3-bit vector
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity MUX3_2x1 is
	port (
		a, b : in std_logic_vector(2 downto 0);
		s0   : in std_logic;
		y    : out std_logic_vector(2 downto 0)
	);
end MUX3_2x1;

architecture arch of MUX3_2x1 is
	component MUX1_2x1 is
		port (
			a, b, s0 : in std_logic;
			y        : out std_logic
		);
	end component;
begin
	MUXg : for i in 2 downto 0 generate
		mx : MUX1_2x1 port map(a => a(i), b => b(i), s0 => s0, y => y(i));
	end generate MUXg;
end architecture;
-- (d) MUX3_4x1: 4 inputs, 1 output, 2 selectors, each input is a 3-bit vector
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity MUX3_4x1 is
	port (
		a, b, c, d : in std_logic_vector(2 downto 0);
		s1, s0     : in std_logic;
		y          : out std_logic_vector(2 downto 0)
	);
end MUX3_4x1;

architecture arch of MUX3_4x1 is
	component MUX1_4x1 is
		port (
			a, b, c, d, s1, s0 : in std_logic;
			y                  : out std_logic
		);
	end component;
begin
	MUXg : for i in 2 downto 0 generate
		mx : MUX1_4x1 port map(a => a(i), b => b(i), c => c(i), d => d(i), s0 => s0, s1 => s1, y => y(i));
	end generate MUXg;
end architecture;
-- (e) MUX16_2x1: 2 inputs, 1 output, 1 selector, each input is a 16-bit vector
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity MUX16_2x1 is
	port (
		a, b : in std_logic_vector(15 downto 0);
		s0   : in std_logic;
		y    : out std_logic_vector(15 downto 0)
	);
end MUX16_2x1;

architecture arch of MUX16_2x1 is
	component MUX1_2x1 is
		port (
			a, b, s0 : in std_logic;
			y        : out std_logic
		);
	end component;
begin
	MUXg : for i in 15 downto 0 generate
		mx : MUX1_2x1 port map(a => a(i), b => b(i), s0 => s0, y => y(i));
	end generate MUXg;
end architecture;
-- (f) MUX16_4x1: 4 inputs, 1 output, 2 selectors, each input is a 16-bit vector
library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity MUX16_4x1 is
	port (
		a, b, c, d : in std_logic_vector(15 downto 0);
		s1, s0     : in std_logic;
		y          : out std_logic_vector(15 downto 0)
	);
end MUX16_4x1;

architecture arch of MUX16_4x1 is
	component MUX1_4x1 is
		port (
			a, b, c, d, s1, s0 : in std_logic;
			y                  : out std_logic
		);
	end component;
begin
	MUXg4 : for i in 15 downto 0 generate
		mx : MUX1_4x1 port map(a => a(i), b => b(i), c => c(i), d => d(i), s0 => s0, s1 => s1, y => y(i));
	end generate MUXg4;
end architecture;
