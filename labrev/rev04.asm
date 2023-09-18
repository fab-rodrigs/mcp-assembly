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
palavra:  .word 0        		# 0x10018000 Local de armazenamento para a palavra 0x10018000
paridade: .word 0        		# 0x10018004 Local de armazenamento para a paridade 0x10018004

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

.macro imprimirBin (%reg)
	li $v0, 35			# carrega o código do serviço de sistema para imprimir um binario em $v0
	add $a0, $zero, %reg		# carrega string ao registrador $a0
	syscall				# chama o serviço de sistema para imprimir a string
.end_macro

.text
    la $gp, 0x10010000 			# define global pointer como endereço inicial do .data
    lw $s0, 0($gp)			# $s0 <- palavra
    lw $s1, 4($gp)			# $s1 <- paridade
    
    li $t0, 0				# verificador mascara
    li $t1, 0				# quantidade de bits ligados = 0
    li $t2, 2				# $t2 = 2
	
    la $gp, 0x10018000 			# define global pointer como endereço inicial do .data
    lw $s0, 0($gp)			# $s0 <- palavra
    
    imprimirString("\n--------------------------------------\n")
    imprimirString("palavra = ")
    lerInt($s0)				# lê palavra
    
    imprimirString("\nbinario = ")
    imprimirBin($s0)
    imprimirString("\n--------------------------------------\n")
    
    while1_start:	
	beq  $s0, $0,  while1_end       # Verifica se $s0 é igual a 0, se for, vai para DONE
	andi $t0, $s0, 0x01        	# Armazena o bit menos significativo de $s1 em $t0
	if1:
	    beq  $t0, $0, if1_out     # Verifica se o bit em $t0 é zero, se for, vai para if1_out
	if1_them:
	    addi $t1, $t1, 1            # Se o bit em $t0 não for zero, incrementa $s0 em 1
	if1_out:
	srl $s0, $s0, 1       	        # Realiza um deslocamento lógico 
	j while1_start                  # Volta para o início do loop (etiqueta LOOP)
    while1_end:
    
    if2:
    	div $t1, $t2
    	mfhi $t1
    	bnez $t1, if2_else
    if2_them:
    	imprimirString("Paridade é par.\n")
    	j if2_out
    if2_else:
    	imprimirString("Paridade é ímpar.\n")
    if2_out:
    	
