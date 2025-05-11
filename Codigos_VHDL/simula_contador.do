# Inicia a simulação com a entidade de teste
vsim work.tb_contador

# Adiciona sinais à janela de waveform
add wave*

# Configurações iniciais
# clr = '0' => contador vai contar de 0 a 999 com passo 1
force clk 0, 1 50 -repeat 100
force clr 1

# Define valor mínimo = 002
force clr 1
force mx_mi 0
force A2 "0000"  # Centenas
force A1 "0000"  # Dezenas
force A0 "0010"  # Unidades
run 10
force load 1
run 100

# Define valor máximo = 009
force mx_mi 1
force A2 "0000"
force A1 "0000"
force A0 "1001"
run 10
force load 1
run 100

# Define passo = 3
force step 1
force A0 "0011"
force load 1
run 10
force step 0
run 100

# Faz contagem crescente
force up_dw 1
run 1000
