library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity SixteenBitAdder is
  port (
    a    : in std_logic_vector (15 downto 0);
    b    : in std_logic_vector (15 downto 0);
    sum  : out std_logic_vector (15 downto 0);
    cout : out std_logic
  );
end SixteenBitAdder;

architecture struct of SixteenBitAdder is

  signal carry : std_logic_vector(16 downto 0);

  component OneBitAdder is
    port (
      a, b, cin : in std_logic;
      sum, cout : out std_logic
    );
  end component OneBitAdder;

begin

  carry(0) <= '0'; -- cin is 0

  adder_loop : for i in 0 to 15 generate
    bit_i : OneBitAdder
    port map(
      a    => a(i),
      b    => b(i),
      cin  => carry(i),
      sum  => sum(i),
      cout => carry(i + 1)
    );
  end generate adder_loop;
  cout <= carry(16);

end struct;
