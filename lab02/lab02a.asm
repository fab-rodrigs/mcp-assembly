#########################################################
# Laboratório 02 - MCP22105
# Alocação de dados em memória e Chamada de Sistemas
#
# Aluno: Fabrício Rodrigues de Santana
#########################################################

#########################################################
# Considere o seguinte programa em linguagem 
# Assembly do MIPS
#
#    .data 0x10010400 # segmento de dados
#      palavra1: .word 13
#      palavra2: .word 0x15
#
# Indique, em hexadecimal, os endereços de memória dos 
# símbolos palavra1 e palavra2
##########################################################
# palavra1: 0x10010400
# palavra2: 0x10010404

#########################################################
# Considere o seguinte programa em linguagem 
# Assembly do MIPS
#
#    .data 0x10010800 # segmento de dados
#
#      variavel_a: .word 13
#      nums:       .word 2, 6, 8, 5, 98, 74, 28
#
# Indique, em hexadecimal, o endereço do elemento com o
# valor 74 do vetor nums
##########################################################

# nums 74: 0x10010818

#########################################################
# Realize a conversão das expressões abaixo considerando
# que os valores das variáveis já estão carregados nos
# registradores, conforme o mapeamento indicado abaixo
#
# Mapeamento dos registradores:
# i: $s3, j: $s4
# Endereço base dos vetores: A: $s6 e B: $s7
#########################################################

#########################################################
# B[8] = A [i-j]
#########################################################
.data # Variáveis

i: .word 3					# i = 3
j: .word 1					# j = 1
A: .word 0, 1, 2, 3, 4				# A = {0, 1, 2, 3, 4}
B: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10	# B = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

.text

lw $s3, i # define registrador $s3 como i
lw $s4, j # define registrador $s4 como j

sub $t0, $s3, $s4 # indice para vetor A: i - j

la $s6, A # carrega endereço A no registrador $s6

# calcula o endereço de memória para acessar A[i-j]
sll $t0, $t0, 2    # multiplica o índice por 4 (tamanho de uma palavra) 
		   # sll = shift left --> 2x = multilpicar por 4 (2^2)
add $t1, $s6, $t0  # soma o índice ao endereço base de A
lw $t2, ($t1)     # carrega o valor de A[i-j] para o registrador $t2

la $s7, B # carrega endereço B em $s7

# calcula o endereço de memória para acessar B[8]
li $t0, 8          # carrega o índice 8
sll $t0, $t0, 2    # multiplica o índice por 4 (tamanho de uma palavra)

add $t1, $s7, $t0  # soma o índice ao endereço base de B

sw $t2, ($t1) # armazena A[i-j] em B[8]

#########################################################
# B[32] = A[i] + A[j]
#########################################################

lw $t0, i # carrega i em $t0
lw $t1, j # carrega j em $t1

sll $t0, $t0, 2 # multiplica i por 4
sll $t1, $t1, 2 # multiplica j por 4

la $s6, A # carrega endereço A em $s6

add $t0, $s6, $t0  # soma o índice ao endereço base de A
add $t1, $s6, $t1  # soma o índice ao endereço base de A

add $t3, $t0, $t1 # armazena em $t3 A[i} + A[j}

# calcula o endereço de memória para acessar B[32]
li $t0, 32          # carrega o índice 32
sll $t0, $t0, 2    # multiplica o índice por 4 (tamanho de uma palavra)

add $t3, $s7, $t0  # soma o índice ao endereço base de B

sw $t3, 0($t0) # armazena A[i} + A[j} em B[32
