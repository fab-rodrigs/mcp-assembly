#########################################################
# Realize a conversão das expressões abaixo considerando
# que os valores das variáveis já estão carregados nos
# registradores, conforme o mapeamento indicado abaixo
#
# Mapeamento dos registradores:
# f: $t0, g: $t1, h: $t2, i: $t3, j: $t4
# Endereço base A: $s0, Endereço base B: $s1
#########################################################

.data
A: .word 1,2,3,4,5
B: .word 6,7,8,9,10

.text
li $t0, 0		# x = 0
li $t1, 1 		# f = 1
li $t2, 2 		# g = 2
li $t3, 3 		# h = 3
li $t4, 0		# y = 0

######################################
# f = ((g+1) * h) - 3

addi $t0, $t1, 1	# x = g + 1
mul $t0, $t0, $t2	# x = x * h
addi $t1, $t0, -3	# f = x - 3

######################################
# f = (h*h + 2) / f - g

mul $t0, $t3, $t3	# x = h * h
addi $t0, $t0, 2	# x = x + 2
sub $t4, $t1, $t2	# y = f - g
div $t1, $t0, $t4	# f = x / y

######################################
# B[i] = 2 * A[i] 

li $t5, 3		# i = 3
lw $t6, A($t5)		# Carrega A[i] em $t6
sll $t6, $t6, 1		# Multiplica A[i] por 2
sw $t6, B($t5)		# Armazena o resultado em B[i]

######################################
# B[f+g] = A[i] / (A[j] - B[j])

add $t7, $t1, $t2	# x = f + g
lw $t8, A($t5)		# Carrega A[i] em $t8
lw $t9, B($t7)		# Carrega B[f+g] em $t9
sub $t0, $t8, $t9	# x = A[i] - B[f+g]
div $t0, $t0		# x = x / (A[j] - B[j])
mflo $t0		# x = resultado da divisão
sw $t0, B($t7)		# Armazena o resultado em B[f+g]








