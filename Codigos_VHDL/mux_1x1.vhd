library ieee;
use ieee.std_logic_1164.all;

entity mux_1x1 is
    port(
        A  : in std_logic;
        B  : in std_logic;
        Sl : in std_logic;
        Y  : out std_logic
    );
end mux_1x1;

architecture CKT of mux_1x1 is

    signal sl0 : std_logic;
    signal sl1 : std_logic;

begin
    sl0 <= not Sl;
    sl1 <= Sl;

    Y <= (A and sl0) or (B and sl1);
end CKT;