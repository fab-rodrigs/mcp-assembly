#########################################################
# Laboratório 02 - MCP22105
# Alocação de dados em memória e Chamada de Sistemas
#
# Aluno: Fabrício Rodrigues de Santana
#########################################################

#########################################################
# Faça um programa que solicite dois números para o
# usuário e exiba a soma destes dois números
#########################################################

.macro exit
	li $v0, 10
	syscall
.end_macro

.macro imprimirString (%str)
	.data
	string: .asciiz %str
	.text
	li $v0, 4		# carrega o código do serviço de sistema para imprimir uma string em $v0
	la $a0, string		# carrega string ao registrador $a0
	syscall			# chama o serviço de sistema para imprimir a string
.end_macro

.macro lerInt (%reg)
	li $v0, 5 
	move $a0, %reg
	syscall
	move %reg, $v0 
.end_macro

.macro imprimirInt (%reg)
	li $v0, 1		# carrega o código do serviço de sistema para imprimir uma string em $v0
	add $a0, $zero, %reg	# carrega string ao registrador $a0
	syscall			# chama o serviço de sistema para imprimir a string
.end_macro

.text 

imprimirString("n1 = ")

lerInt($t1)

imprimirString("n2 = ")

lerInt($t2)

imprimirString("Soma = ")

add $t0, $t1, $t2	# $t0 = n1 + n2

imprimirInt($t0)

exit
