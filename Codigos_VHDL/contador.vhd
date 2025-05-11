
library ieee;
use ieee.std_logic_1164.all;

entity contador is
   port (
	up_dw : in std_logic;
        mx_mi : in std_logic;
        A2 : in std_logic_vector(3 downto 0);
        A1 : in std_logic_vector(3 downto 0);
	A0 : in std_logic_vector(3 downto 0);
        step : in std_logic;
        load : in std_logic;
        clr : in std_logic;
        clk : in std_logic;
  
        clock : out std_logic;	
	LED : out std_logic;
	
	HEX0:  out std_logic_vector(6 downto 0);
	HEX1: out std_logic_vector(6 downto 0);
	HEX2: out std_logic_vector(6 downto 0)
);
end contador;





architecture CKT of contador is




    signal Q2,Q1,Q0     : std_logic_vector(3 downto 0);
    signal Q : std_logic_vector(11 downto 0);
    signal Q_future     : std_logic_vector(11 downto 0);
    signal CNT ,I_temp, I_step, in_comp  : std_logic_vector(11 downto 0);
    signal MAX : std_logic_vector(11 downto 0);
    signal MIN : std_logic_vector(11 downto 0);
    signal step_value : std_logic_vector(11 downto 0); 
    signal MAX_OR_999, STEP_OR_1 : std_logic_vector(11 downto 0);
    signal d0,d1,d2,d3,d  : std_logic;
    signal maior,menor,igual,c_0 : std_logic;
    signal comp_out, load_cnt, ck  : std_logic; 
    signal Sl_mux4: std_logic_vector(1 downto 0);
    signal not_clr, not_up_dw, not_load, load_max, load_step: std_logic;
    signal SUM, SUB: std_logic_vector(11 downto 0);
    


     component mux_1
     port(
        A  : in std_logic_vector(11 downto 0);
        B  : in std_logic_vector(11 downto 0);
        Sl : in std_logic;
        Y  : out std_logic_vector(11 downto 0)
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
   

     component mux_4
     port(
        A  : in std_logic_vector(11 downto 0);
        B  : in std_logic_vector(11 downto 0);
	C  : in std_logic_vector(11 downto 0);
        D  : in std_logic_vector(11 downto 0);
        S : in std_logic_vector(1 downto 0);
        Y_4  : out std_logic_vector(11 downto 0)
    );
     end component;


     component decoder_12 
     port (
        i0  : in  std_logic;
        i1  : in  std_logic;
	en  : in std_logic;
	
        d0  : out std_logic;
        d1  : out std_logic;
        d2  : out std_logic;
	d3  : out std_logic
    );
     end component;


     component comparador_12
     port (
        A      : in  std_logic_vector(11 downto 0);
        B      : in  std_logic_vector(11 downto 0);
        maior  : out std_logic;
        igual  : out std_logic;
        menor  : out std_logic
    );
     end component;



     component reg_12
      port (ck, load, clr, set: in  std_logic;
   	I : in std_logic_vector(11 downto 0);
   	q : out std_logic_vector(11 downto 0) 
     );
     end component;


     component somador_bcd 
	port(

	A,B : in std_logic_vector(11 downto 0);
        C_i : in std_logic;
	C_0 : out std_logic;
	S :   out std_logic_vector(11 downto 0)
	);
	end component;


     component subtrator_bcd 
	port(

	A,B : in std_logic_vector(11 downto 0);
        C_i : in std_logic;
	C_0 : out std_logic;
	S :   out std_logic_vector(11 downto 0)
	);
	end component;


      component somador_4_bits
	port(

	A,B : in std_logic_vector(3 downto 0);
	C_i: in std_logic;
	C_0 : out std_logic;
	S :   out std_logic_vector(3 downto 0)
	);
	end component;


    component display7
    port (
        A, B, C, D : in std_logic;
        l: out std_logic_vector(6 downto 0)
    );
    end component;


    component ck_div
    port(
      ck_in  : in  std_logic;
      ck_out : out  std_logic
	);
    end component;


    component ffjk
    port(
       ck : in std_logic;
       clr : in std_logic;
       set : in std_logic;
       j : in std_logic;
       k : in std_logic;
       q : out std_logic
	);
     end component;



begin
    
    not_up_dw <= not(up_dw);
    not_load <= not(load);


    --FREQ_DIV: ck_div port map(
         -- ck_in => clk,
	 -- ck_out => ck
	 --);
 
     ck <= clk;

          
    DECODER: decoder_12 port map(
          i0 => step,
	  i1 => mx_mi,
	  en => not_load,
	  d0 => d0,
	  d1 => d1,
	  d2 => d2,
	  d3 => d3
	);


    I_temp <= A2 & A1 & A0;
    
    not_clr <= not(clr);
   
    --Registradores para armazenar os valores
    MIN_REG: reg_12 port map(
         ck => ck,
         load => d0,
         clr => not_clr,
         set => '0',
         I => I_temp,
	 q => MIN
        );

     MUX_MAX_PADRAO: mux_1 port map(
	 A => "100110011001",
	 B => I_temp,
	 Sl => clr,
	 Y => MAX_OR_999
      );


     load_max <= d1 or not_clr;


     MAX_REG: reg_12 port map(
         ck => ck,
         load => load_max,
         clr => '0',
         set => '0',
         I => MAX_OR_999,
	 q => MAX
        );
         
     
     I_step <= "00000000" & A0;
     

     MUX_STEP_PADRAO: mux_1 port map(
	 A => "000000000001",
	 B => I_step,
	 Sl => clr,
	 Y => STEP_OR_1
      );

     d <= (d2 or d3);
     

     load_step <= d or not_clr;


     STEP_REG: reg_12 port map(
         ck => ck,
         load => load_step,
         clr => '0',
         set => '0',
         I => STEP_OR_1,
	 q => step_value
        );

    
      SUM_BCD: somador_bcd 
	port map(
	 A => Q,
	 B => step_value,
	 C_i => '0',
	 C_0 => c_0,
	 S => SUM 
	);
	
     SUB_BCD: subtrator_bcd 
	port map(
	 A => Q,
	 B => step_value,
	 C_i => '1',
	 C_0 => c_0,
	 S => SUB 
	);

      MUX_STEP: mux_1 
	port map(
	 A => SUB,
	 B => SUM,
	 Sl => up_dw ,
	 Y => Q_future
	);


      MUX_COMP: mux_1 
        port map(
	 A => MIN,
	 B => MAX,
	 Sl => up_dw ,
	 Y => in_comp
	);



    COMPARADOR_SAIDA: comparador_12 port map(
	 A => Q_future,
	 B => in_comp,
	 maior => maior,
	 menor => menor,
	 igual => igual
	 );
    

     LED <= igual;
     clock <= ck;


     MUX_LOAD_CNT: mux_1x1 port map(
	 A => menor,
	 B => maior,
	 Sl => up_dw,
	 Y => comp_out
	);

     load_cnt <= not(comp_out);


     Sl_mux4 <=  not_load & up_dw;


     MUX_CNT: mux_4 port map(
	 A => Q_future,
	 B => Q_future,
	 C => MAX,
	 D => MIN,
	 S => Sl_mux4,
	 Y_4 => CNT
	);

     
   
     REG_CNT: reg_12 port map(
	ck => ck,
        load => load_cnt,
        clr => not_clr,
        set => '0',
        I => CNT,
	q => Q
        );
     

     Q0 <= Q(3 downto 0);
     Q1 <= Q(7 downto 4);
     Q2 <= Q(11 downto 8);

	
     LED1: display7 port map(
 	A => Q0(3),
	B => Q0(2),
        C => Q0(1),
	D => Q0(0),
	l => HEX0
	);
	   
	   
      LED2: display7 port map(
	 A => Q1(3),
	 B => Q1(2),
	 C => Q1(1),
	 D => Q1(0),
	 l => HEX1
	 );
	   
      LED3: display7 port map(
	 A => Q2(3),
	 B => Q2(2),
	 C => Q2(1),
	 D => Q2(0),
	 l => HEX2
	 );
	   
	   

end CKT;