#########################################################
# Qual é o valor do registrador $s0 após a execução das 
# instruções abaixo? O registrador $s1 possui o valor 
# 0x0000FEFE. Apresente a sua resposta em hexadecimal.
#########################################################

li $s1, 0x0000FEFE 		   # 0b0000 0000 0000 0000 1111 1110 1111 1110

#########################################################
	add  $s0, $0, $0           # Inicializa $s0 com 0
LOOP:	
	beq  $s1, $0,  DONE        # Verifica se $s1 é igual a 0, se for, vai para DONE
	andi $t0, $s1, 0x01        # Armazena o bit menos significativo de $s1 em $t0
#       0b0000 0000 0000 0000 1111 1110 1111 1110
# and:  0b0000 0000 0000 0000 0000 0000 0000 0001
# $t0 = 0b0000 0000 0000 0000 0000 0000 0000 0000
	beq  $t0, $0, SKIP         # Verifica se o bit em $t0 é zero, se for, vai para SKIP
	addi $s0, $s0, 1           # Se o bit em $t0 não for zero, incrementa $s0 em 1
SKIP:
	srl $s1, $s1, 1       	   # Realiza um deslocamento lógico para a direita em $s1 (divisão por 2)
# $s1 = 0b0000 0000 0000 0000 1111 1110 1111 1110
#$s1/2= 0b0000 0000 0000 0000 0111 1111 0111 1111
	j LOOP                     # Volta para o início do loop (etiqueta LOOP)
DONE:

#########################################################

# Após a execução do loop, $s0 conterá o número de bits 1 em 0x0000FEFE.
# Contando os bits 1 na representação binária de 0x0000FEFE, obtemos o 
# valor 14 em decimal, que é 0xE em hexadecimal.

#########################################################
addi $t0, $0, 12    # Inicializa $t0 com 12.
sll  $t0, $t0, 4    # Multiplica $t0 por 2^4, resultando em $t0 = 192.
xori $t0, $t0, 10   # Realiza uma operação XOR com 10, resultando em $t0 = 202.
sll  $t0, $t0, 8    # Multiplica $t0 por 2^8, resultando em $t0 = 51712.
xori $t0, $t0, 255  # Realiza uma operação XOR com 255, invertendo todos os bits em $t0, resultando em $t0 = 65423 (0xFFDF em hexadecimal).

# Agora, vamos calcular o valor final de $s0 considerando que ele começa com 14.
# Suponha que $s1 tenha o valor 0x0000FEFE (em binário: 0000 0000 1111 1110 1111 1110 1111 1110).

and  $s0, $s1, $t0   # Realiza uma operação AND bit a bit entre $s1 e $t0, armazenando o resultado em $s0.

# O resultado da operação AND manterá apenas os bits que são 1 em ambos os registros.
# Portanto, o valor final de $s0 será:
# 0000 0000 1101 1110 1111 1110 1111 1110
# 0x0000DEFE 

#########################################################


