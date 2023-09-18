#########################################################
# Laboratório 02 - MCP22105
# Alocação de dados em memória e Chamada de Sistemas
#
# Aluno: Fabrício Rodrigues de Santana
#########################################################

#########################################################
# Faça um programa que imprime a cadeia de caracteres
# "Hello World!" em linguagem assembler para o MIPS
#######################	##################################

.data
hello: .asciiz "Hello World!"

.text

la $a0, hello  	# carrega o endereço da string 'Hello World!' em $a0
li $v0, 4 	# carrega o código do serviço de sistema para imprimir uma string em $v0
syscall		# chama o serviço de sistema para imprimir a string

li $v0, 10   	# código do serviço de sistema para sair
syscall
