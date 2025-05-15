library ieee;
use ieee.std_logic_1164.all;

entity subtrator_bcd is
    port (
        A, B  : in  std_logic_vector(11 downto 0);
        C_i   : in  std_logic; -- normalmente '1' para o complemento de 10
        C_0   : out std_logic;
        S     : out std_logic_vector(11 downto 0)
    );
end subtrator_bcd;

architecture CKT of subtrator_bcd is

    signal A_C, A_D, A_U, B_C, B_D, B_U : std_logic_vector(3 downto 0);
    signal B_C_comp, B_D_comp, B_U_comp : std_logic_vector(3 downto 0);
    signal S_C, S_D, S_U, S_Cp, S_Dp, S_Up, S_C6, S_D6, S_U6, not_B_U, not_B_D, not_B_C : std_logic_vector(3 downto 0);
    signal maior_c, maior_d, maior_u : std_logic;
    signal corrige_u, corrige_d, corrige_c : std_logic;
    signal c_out : std_logic_vector(2 downto 0);

    component somador_4_bits
        port (
            A   : in  std_logic_vector(3 downto 0);
            B   : in  std_logic_vector(3 downto 0);
            C_i : in  std_logic;
            C_0 : out std_logic;
            S   : out std_logic_vector(3 downto 0)
        );
    end component;

    component comparador_4
        port (
            A     : in  std_logic_vector(3 downto 0);
            B     : in  std_logic_vector(3 downto 0);
            maior : out std_logic;
            igual : out std_logic;
            menor : out std_logic
        );
    end component;

    component mux_2x4
        port (
            A  : in std_logic_vector(3 downto 0);
            B  : in std_logic_vector(3 downto 0);
            Sl : in std_logic;
            Y  : out std_logic_vector(3 downto 0)
        );
    end component;

begin

    -- Separar dígitos
    A_C <= A(11 downto 8);  A_D <= A(7 downto 4);  A_U <= A(3 downto 0);
    B_C <= B(11 downto 8);  B_D <= B(7 downto 4);  B_U <= B(3 downto 0);

    not_B_U <= not(B_U); not_B_D <= not(B_D); not_B_C <= not(B_C);



    -- Complemento de 10 = 9 + not(B) + 1
    somador_comp_U: somador_4_bits port map(
        A => "1001",  -- 9
        B => not_B_U,
        C_i => '1',
        C_0 => open,
        S => B_U_comp
    );

    somador_comp_D: somador_4_bits port map(
        A => "1001",
        B => not_B_D,
        C_i => '1',
        C_0 => open,
        S => B_D_comp
    );

    somador_comp_C: somador_4_bits port map(
        A => "1001",
        B => not_B_C,
        C_i => '1',
        C_0 => open,
        S => B_C_comp
    );

    -- Unidade
    SU: somador_4_bits port map(
        A => A_U,
        B => B_U_comp,
        C_i => C_i,
        C_0 => c_out(0),
        S => S_Up
    );

    COMPARADOR_U: comparador_4 port map(
        A => S_Up,
        B => "1001",
        maior => maior_u,
        igual => open,
        menor => open
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

    -- Dezena
    SD: somador_4_bits port map(
        A => A_D,
        B => B_D_comp,
        C_i => corrige_u,
        C_0 => c_out(1),
        S => S_Dp
    );

    COMPARADOR_D: comparador_4 port map(
        A => S_Dp,
        B => "1001",
        maior => maior_d,
        igual => open,
        menor => open
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

    -- Centena
    SC: somador_4_bits port map(
        A => A_C,
        B => B_C_comp,
        C_i => corrige_d,
        C_0 => c_out(2),
        S => S_Cp
    );

    COMPARADOR_C: comparador_4 port map(
        A => S_Cp,
        B => "1001",
        maior => maior_c,
        igual => open,
        menor => open
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

