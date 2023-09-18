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

sll $t6, $t5, 2			# $t6 = i * 4
la $s0, A
la $s1, B
			
add $t7, $t6, $s0		# $t7 = $t6 + $s0
lw $t7, 0($t6)			# $t7 = A[$t6]
sll $t7, $t6, 1			# $t7 = 2 * A[1]

add $t6, $t6, $s1		# $t6 = $t6 + $s0
sw $s1, 0($t6)			# B[$t6] = 2 * A[$t6]

######################################
# B[f+g] = A[i] / (A[j] - B[j])

li $t5, 3		# i = 3
li $t6, 4		# j = 4
la $s0, A
la $s1, B

sll $t5, $t5, 2		# i = i * 4
sll $t6, $t6, 2		# j = j * 4

add $t6, $s0, $t6	# endereço(B[j]) = $s0 + $t6
lw $s0, 0($t6)		# A[j] = $t6
lw $s1, 0($t6)		# B[j] = $t6

sub $t7, $s0, $s1	# $t7 = A[j] - B[j]

add $t5, $s0, $t5	# endereço(A[i]) = $s0 + $t5
lw $s0, 0($t5)		# A[i] = $t5

div $t8, $s0, $t7	# $t8 = A[i] / $t7

add $t7, $t1, $t2	# $t7 = f + g
sll $t7, $t7, 2		# $t7 = $t7 * 4 
lw $s3, 0($t7)		# $s3 = $t7

add $s3, $t8, $0	# B[f+g] = $t8
