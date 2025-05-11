library ieee;
use ieee.std_logic_1164.all;

entity display7 is
    port (
        A, B, C, D : in std_logic;
        l: out std_logic_vector(6 downto 0)
    );
end display7;

architecture CKT of display7 is
    signal x : std_logic_vector(0 to 17);
begin
    x(0) <= A;
    x(1) <= B;
    x(2) <= C;
    x(3) <= not A and C;
    x(4) <= not B and not D;
    x(5) <= B and D;
    x(6) <= not C and not D;
    x(7) <= C and D;
    x(8) <= not A and not B;
    x(9) <= B and not D;
    x(10) <= not C;
    x(11) <= not B and not C and not D;
    x(12) <= C and not D;
    x(13) <= not A and not B and C;
    x(14) <= B and not C and D;
    x(15) <= A and C;
    x(16) <= A and B;
    x(17) <= B and not C;

    l(0) <= not( x(0) or x(3) or x(4) or x(5));
    l(1) <= not(x(0) or x(6) or x(7) or x(8));
    l(2) <= not(x(0) or x(9) or x(7) or x(10));
    l(3) <= not(x(0) or x(11) or x(12) or x(13) or x(14));
    l(4) <= not(x(11) or x(15) or x(16) or x(12));
    l(5) <= not(x(0) or x(6) or x(9) or x(17));
    l(6) <= not(x(0) or x(1) or x(2));
end CKT;