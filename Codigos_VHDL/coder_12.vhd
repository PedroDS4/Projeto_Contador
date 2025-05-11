library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity decoder_12 is
    port (
        i0  : in  std_logic;
        i1  : in  std_logic;
	en  : in std_logic;
	
        d0  : out std_logic;
        d1  : out std_logic;
        d2  : out std_logic;
	d3  : out std_logic
    );
end decoder_12;


architecture CKT of decoder_12 is

   
	
begin
	d0 <= en and ( not(i0) and not(i1) );
	d1 <= en and( not(i0) and i1 ); 
	d2 <= en and ( i0 and not(i1) );
	d3 <= en and ( i0 and i1 );
   

end CKT;