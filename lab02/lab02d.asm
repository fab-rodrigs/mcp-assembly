#########################################################
# Laboratório 02 - MCP22105
# Alocação de dados em memória e Chamada de Sistemas
#
# Aluno: Fabrício Rodrigues de Santana
#########################################################

#########################################################
# Faça um programa no MARS, utilizando as chamadas de 
# sistema que implementa um papagaio :)
#
# O programa simplesmente imprime no terminal a mesma 
# frase que foi digitada.
#
#  # Diga alguma coisa que eu irei dizer também!
#  # Entre com o seu texto: ...
#  # O seu texto é: ...
#
#########################################################

.data
resp: .space 100

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

.macro lerString (%str, %n)
	.text
	li $v0, 8		# carrega o código do serviço de sistema para ler uma string em $v0
	la $a0, %str
	li $a1, %n		# carrega string ao registrador $a0
	syscall			# chama o serviço de sistema para imprimir a string
.end_macro

.macro imprimirResp(%ptr) # realiza a impressao da resposta
	li $v0, 4
	la $a0, %ptr
	syscall
.end_macro

.text 

imprimirString("Diga alguma coisa que eu irei dizer também!\n")

imprimirString("Entre com o seu texto: ")
lerString(resp, 100)
imprimirString("O seu texto é: ")
imprimirResp(resp)

exit
