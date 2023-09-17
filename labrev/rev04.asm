#########################################################
# Paridade de uma palavra pode ser definida como par ou 
# ímpar, de acordo com a quantidade de bits “1” presentes 
# na palavra. Por exemplo, a palavra 0b0110 possui 
# paridade par, pois possui 2 bits ativados, enquanto que 
# a palavra 0b1110 possui paridade ímpar uma vez que possui 
# 3 bits ativados. Projete um programa em linguagem assembly 
# do MIPS para calcular a paridade da palavra presente no 
# endereço de memória 0x10018000. Armazene o valor 0x01 
# caso a paridade seja par, ou 0x02 caso seja ímpar no 
# endereço de memória 0x10018004.
#
# Utilize chamadas de sistemas para inicializar o valor 
# inicial da palavra armazenada no endereço 0x10018000.
#
#########################################################

.data 0x10018000
palavra:  .word 0        		# Local de armazenamento para a palavra 0x10018000
paridade: .word 0        		# Local de armazenamento para a paridade 0x10018004

.macro exit
	li $v0, 10
	syscall
.end_macro

.macro imprimirString (%str)
	.data
	string: .asciiz %str
	.text
	li $v0, 4			# carrega o código do serviço de sistema para imprimir uma string em $v0
	la $a0, string			# carrega string ao registrador $a0
	syscall				# chama o serviço de sistema para imprimir a string
.end_macro

.macro lerInt (%reg)
	li $v0, 5 
	move $a0, %reg
	syscall
	move %reg, $v0 
.end_macro

.macro imprimirInt (%reg)
	li $v0, 1			# carrega o código do serviço de sistema para imprimir uma string em $v0
	add $a0, $zero, %reg		# carrega string ao registrador $a0
	syscall				# chama o serviço de sistema para imprimir a string
.end_macro

.
    li $t0, 0				# quantidade de bits ligados = 0
	
    la $gp, 0x10018000 			# define global pointer como endereço inicial do .data
    lw $s0, 0($gp)			# $s0 <- palavra
    
    imprimirString("palavra = ")
    lerInt($s0)				# lê palavra
    
    while1_start:	
	beq  $s0, $0,  while1_end       # Verifica se $s0 é igual a 0, se for, vai para DONE
	andi $t0, $s1, 0x01        	# Armazena o bit menos significativo de $s1 em $t0

	if1:
	    beq  $t0, $0, if1_else      # Verifica se o bit em $t0 é zero, se for, vai para if1_out
	if1_them:
	    addi $s0, $s0, 1            # Se o bit em $t0 não for zero, incrementa $s0 em 1
	if1_out:
	srl $s1, $s1, 1       	        # Realiza um deslocamento lógico 
 a direita em $s1 (divisão por 2)
# $s1 = 0b0000 0000 0000 0000 1111 1110 1111 1110
#$s1/2= 0b0000 0000 0000 0000 0111 1111 0111 1111
	j while1_start:                 # Volta para o início do loop (etiqueta LOOP)
while1_end:
    
