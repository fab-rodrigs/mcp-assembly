#########################################################
# Laboratório 01 - MCP22105
# Expressões Aritméticas e Lógicas
#
# Aluno: Fabrício Rodrigues de Santana
#########################################################
# Realize a conversão das expressões abaixo considerando
# que os valores das variáveis já estão carregados nos
# registradores, conforme o mapeamento indicado abaixo
#
# Mapeamento dos registradores:
# a: $t0, b: $t1, c: $t2, d: $t3, res: $t4
#########################################################

li $t0, 1 		# a = 1
li $t1, 2 		# b = 2
li $t2, 3 		# c = 3
li $t3, 4 		# d = 4
li $t4, 0 		# res = 0

li $t5, 0 		# tmp5 = 0

######################################
# res = a + b + c

add $t4, $t0, $t1 	# res = a + b
add $t4, $t2, $t4 	# res = c + res

######################################
# res = a - b - c

sub $t4, $t0, $t1 	# res = a - b
sub $t4, $t4, $t2 	# res = res - c

######################################
# res = a * b - c

mul $t4, $t0, $t1 	# res = a * b
sub $t4, $t4, $t2 	# res = res - c

######################################
# res = a * (b + c)

add $t4, $t1, $t2 	# res = b + c
mul $t4, $t0, $t4 	# res = a * res

######################################
# res = a + (b - 5)

addi $t4, $t1, -5 	# res = b - 5
add $t4, $t0, $t4 	# res = a + res

######################################
# res = ((b % 2) == 0)
div $t1, $t1 		# b / 2  (b=2)
mfhi $t4 		# res = b % 2
#div $t4, $t1, 2 	# res = b / 2
#rem $t4, $t1, 2 	# res = b % 2
seq $t4, $t4, 0 	# res = (res == 0)

######################################
# res = (a < b) && (((a+b) % 3) == 10)

add $t4, $t0, $t1 	# res = a + b
#rem $t4, $t4, 3 	# res = res % 3
div $t4, $t2 		# res = res / c   (c=3)
mfhi $t4 		# res = res % 3
seq $t4, $t4, 10 	# res = (res == 10)
slt $t5, $t0, $t1 	# tmp5 = a < b
and $t4, $t3, $t4 	# res = tmp5 && res

######################################
# res = (a >= b) && (c != d)

sge $t4, $t0, $t1 	# res = a >= b
sne $t5, $t2, $t3 	# tmp5 = c != d
and $t4, $t4, $t5 	# res = res && tmp5

######################################
# res = (((a/2)+1) > b) || (d == (b-a))

sra $t5, $t0, 1 	# tmp5 = a / 2
add $t5, $t5, 1   	# tmp5 = tmp5 + 1
sgt $t4, $t5, $t1 	# res = (tmp5 > b)
sub $t5, $t1, $t0 	# tmp5 = b - a
seq $t5, $t3, $t5 	# tmp5 = (d == tmp5)

or $t4, $t4, $t5  	# res = res || tmp5









