#########################################################
# Laboratório 03 - MCP22105
# Estruturas de Controle
#
# Aluno: Fabrício Rodrigues de Santana
#########################################################

.data # 0x10010000 (padrão)		 (hexadecimal) ( decimal)
a: .word 5 				# 0x10010000  # 0x10010000
b: .word 3 				# 0x10010004  # 0x10010004
c: .word 2 				# 0x10010008  # 0x10010008
aprovado: .word 0 			# 0x1001000C  # 0x10010012
reprovado: .word 0 			# 0x10010010  # 0x10010016
yes: .word 1 				# 0x10010014  # 0x10010020


#########################################################
# Faça um programa que leia o conteúdo da posição de 
# memória 0x10010000 e armazene-a na posição 0x10010004 
# se ela for positiva, ou 0x10010008 se for negativa.
#
#########################################################

.text 
    la $gp, 0x10010000 			# define global pointer como endereço inicial do .data
    lw $s0, 0($gp)			# $s0 <- a
    lw $s1, 4($gp)			# $s1 <- positivo
    lw $s2, 8($gp)			# $s2 <- negativo

    IF0:
    	blt $s0, 0, IF0_else		# if(a<0) --> vai pro else    
    IF0_them:
    	lw $s1, 0($gp)			# $s1(positivo) = a
    	j IF0_out
    IF0_else:
	lw $s2, 0($gp)			# $s2(negativo) = a
    IF0_out:

#########################################################
# Faça um programa que teste se o conteúdo da posição de 
# memória 0x10010000 e 0x10010004 são iguais e, em caso 
# positivo, armazene o valor na posição 0x10010008.
#
#########################################################

.text 
    la $gp, 0x10010000 			# define global pointer como endereço inicial do .data
    lw $s0, 0($gp)			# $s0 <- a
    lw $s1, 4($gp)			# $s1 <- b
    lw $s2, 8($gp)			# $s2 <- são iguais?

    IF1:
    	bne $s0, $s1, IF1_out		# if(a!=b) --> sai do if  
    	lw $s2, 0($gp)			# $s2(iguais) = a = b
    IF1_out:

#########################################################
# Faça um programa que leia o conteúdo da posição de 
# memória 0x10010000 e 0x10010004 e, armazene o maior 
# deles na posição 0x10010008.
#
#########################################################

.text 
    la $gp, 0x10010000 			# define global pointer como endereço inicial do .data
    lw $s0, 0($gp)			# $s0 <- a
    lw $s1, 4($gp)			# $s1 <- b
    lw $s2, 8($gp)			# $s2 <- maior

    IF2:
    	bgt $s0, $s1, IF2_else		# if(a>b) --> sai do if  
    	lw $s2, 4($gp)			# $s2(maior) = b
    	j IF2_out			# sai do if
    IF2_else:
	lw $s2, 0($gp)			# $s2(maior) = a
    IF2_out:
	
#########################################################
# Faça um programa que leia 3 notas dos endereços 
# 0x10010000, 0x10010004 e 0x10010008 e, sabendo que a 
# média é 7, armazene 1 no endereço 0x1001000C caso ele 
# esteja aprovado ou no endereço 0x10010010 caso ele 
# esteja reprovado.
#
# n1 = 2 <-- a
# n2 = 4 <-- b
# n3 = 6 <-- c
# medialimite = 7
# media = (n1 + n2 + n3) / 3
# if (media < medialimite) --> vai pro else
# else --> reprovado
#
#########################################################

.text 
    la $gp, 0x10010000 			# define global pointer como endereço inicial do .data
    lw $s0, 0($gp)			# $s0 <- n1
    lw $s1, 4($gp)			# $s1 <- n2
    lw $s2, 8($gp)			# $s2 <- n3
    lw $s3, 12($gp)			# $s3 <- aprovado
    lw $s4, 16($gp)			# $s4 <- reprovado
    lw $s5, 20($gp)			# $s5 = 1 = aprovado
    
    li $t0, 7				# &t0 = medialimite = 7
    
    add $t1, $s0, $s1			# $t1 = n1 + n2
    add $t2, $t1, $s2			# $t2 = $t1 + n3
    
    div $t3, $t2, 3			# $t3 = media = $t2 / 3
    
    IF3:
    	blt $t3, $t0, IF3_else		# if(media < medialimite) --> vai pro else
    IF3_them:
    	lw $s3, 20($gp)			# armazena 1 no registrador de aprovado
    	j IF3_out
    IF3_else:
    	lw $s4, 20($gp)			# armazena 1 no registrador de reprovado
    IF3_out:
