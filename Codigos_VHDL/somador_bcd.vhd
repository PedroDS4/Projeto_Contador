library ieee;
use ieee.std_logic_1164.all;


entity somador_bcd is
	port(

	A,B : in std_logic_vector(11 downto 0);
        C_i : in std_logic;
	C_0 : out std_logic;
	S :   out std_logic_vector(11 downto 0)
	);
end somador_bcd;



architecture CKT of somador_bcd is 
	



	signal A_C, A_D, A_U, B_C, B_D, B_U, S_C, S_D, S_U, S_Cp, S_Dp, S_Up, S_C6, S_D6, S_U6 : std_logic_vector(3 downto 0);
	signal maior_c, maior_d, maior_u, menor_c, menor_d, menor_u, igual_c, igual_d, igual_u, corrige_u, corrige_d, corrige_c : std_logic;
	signal c_out: std_logic_vector(2 downto 0);
 	signal c_out_aux: std_logic_vector(2 downto 0);


	component somador_4_bits
		port(
			A: in std_logic_vector(3 downto 0);
			B: in std_logic_vector(3 downto 0);
			C_i: in std_logic;
			C_0: out std_logic;
			S: out std_logic_vector(3 downto 0)
			);

	end component;
	
	component comparador_N
     	port (
     	   A      : in  std_logic_vector(11 downto 0);
     	   B      : in  std_logic_vector(11 downto 0);
     	   maior  : out std_logic;
     	   igual  : out std_logic;
     	   menor  : out std_logic
    	);
    	 end component;

	component comparador_4
     	port (
     	   A      : in  std_logic_vector(3 downto 0);
     	   B      : in  std_logic_vector(3 downto 0);
     	   maior  : out std_logic;
     	   igual  : out std_logic;
     	   menor  : out std_logic
    	);
    	 end component;


	component mux_2x4
	port(
          A  : in std_logic_vector(3 downto 0);
          B  : in std_logic_vector(3 downto 0);
          Sl : in std_logic;
          Y  : out std_logic_vector(3 downto 0)
    	 );
	end component;

	component mux_1x1
	port(
          A  : in std_logic;
          B  : in std_logic;
          Sl : in std_logic;
          Y  : out std_logic
    	 );
	end component;
begin 
	A_C <= A(11 downto 8);
	A_D <= A(7 downto 4);
	A_U <= A(3 downto 0);

	B_C <= B(11 downto 8);
	B_D <= B(7 downto 4);
	B_U <= B(3 downto 0);

	SU: somador_4_bits port map(
		A => A_U,
		B => B_U,
		C_i => C_i,
		C_0 => c_out(0),
		S => S_Up
	);

	COMPARADOR_U: comparador_4 port map(
		A => S_Up,
		B => "1001",
		maior => maior_u,
		igual => igual_u,
		menor => menor_u
	);

	SOMADOR_4_U: somador_4_bits port map(
		A => S_Up,
		B => "0110",
		C_i => '0',
		C_0 => open,
		S => S_U6
	);

	corrige_u <= maior_u or c_out(0);

	MUX_U: mux_2x4 port map(
		A => S_Up,
		B => S_U6,
		Sl => corrige_u,
		Y => S_U
	);

	SD: somador_4_bits port map(
		A => A_D,
		B => B_D,
		C_i => corrige_u,
		C_0 => c_out(1),
		S => S_Dp
	);

	COMPARADOR_D: comparador_4 port map(
		A => S_Dp,
		B => "1001",
		maior => maior_d,
		igual => igual_d,
		menor => menor_d
	);

	SOMADOR_4_D: somador_4_bits port map(
		A => S_Dp,
		B => "0110",
		C_i => '0',
		C_0 => open,
		S => S_D6
	);

	corrige_d <= maior_d or c_out(1);

	MUX_D: mux_2x4 port map(
		A => S_Dp,
		B => S_D6,
		Sl => corrige_d,
		Y => S_D
	);

	SC: somador_4_bits port map(
		A => A_C,
		B => B_C,
		C_i => corrige_d,
		C_0 => c_out(2),
		S => S_Cp
	);

	COMPARADOR_C: comparador_4 port map(
		A => S_Cp,
		B => "1001",
		maior => maior_c,
		igual => igual_c,
		menor => menor_c
	);

	SOMADOR_4_C: somador_4_bits port map(
		A => S_Cp,
		B => "0110",
		C_i => '0',
		C_0 => open,
		S => S_C6
	);

	corrige_c <= maior_c or c_out(2);

	MUX_C: mux_2x4 port map(
		A => S_Cp,
		B => S_C6,
		Sl => corrige_c,
		Y => S_C
	);

	C_0 <= corrige_c;
	S <= S_C & S_D & S_U;


end CKT;