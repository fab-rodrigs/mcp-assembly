#########################################################
# Laboratório 03 - MCP22105
# Estruturas de Controle
#
# Aluno: Fabrício Rodrigues de Santana
#########################################################

#########################################################
# Converta para assembly os trechos de código C a seguir
# 
# Faça a alocação das variáveis na memória (.data)
#########################################################

.data # 0x10010000 (padrão)
a: .word 0 				# 0x10010000
b: .word 0 				# 0x10010004
c: .word 0 				# 0x10010008
d: .word 0 				# 0x10010012
i: .word 0				# 0x10010016

#########################################################
# a = 0;
# b = 0;
# 
# do {
#   if ( b % 2 ){
#      a++;
#   }
#   b++;
# } while (a < 10)
#########################################################

.text 
    la $gp, 0x10010000 			# define global pointer como endereço inicial do .data
    lw $s0, 0($gp)			# $s0 <- a
    lw $s1, 4($gp)			# $s1 <- b
    
    DO0:
    	li $t2, 2		# $t2 = 2
    	div $s1, $t2 		# b / 2
	mfhi $t0 		# res = b % 2
	IF0:
	    beq $t0, 0, IF0_out # if(&t0 == 0) --> sai do if
	    addi $s0, $s0, 1	# a = a + 1
	IF0_out:
	addi $s1, $s1, 1	# b = b + 1
	blt $s0, 10, DO0	# if (a < 10) --> volta pro começo do DO
    
#########################################################
# if ( ( a < b ) &&  ( c == d ) ) {
#   a = a * (((c/b) * 2) + 10);
# } else {
#   a = a / ((c+4)/b);
# }
# a++;
#########################################################

.text
    la $gp, 0x10010000 			# define global pointer como endereço inicial do .data
    lw $s0, 0($gp)			# $s0 <- a
    lw $s1, 4($gp)			# $s1 <- b
    lw $s2, 4($gp)			# $s2 <- c
    lw $s3, 4($gp)			# $s3 <- d
    slt $t0, $s0, $s1 			# $t0 = (a < b)
    seq $s2, $s3, $t1 			# $t1 = (c == d)
    and $t2, $t0, $t1			# $t2 = ($t0 && $t1)
    IF1:
       beq $t2, 1, IF1_them		# if( ($t0 && $t1) == 1) )
    IF1_else:
        addi $t3, $s2, 4		# $t3 = c + 4
        div $t4, $t3, $s1		# $t4 = $t3 / b
        div $s0, $s0, $t4		# a = a / $t4
        j IF0_out
    IF1_them:  
    	div $t5, $s2, $s1		# &t5 = c / b
    	mul $t6, $t5, 2			# $t6 = $t5 * 2
    	addi $t6, $t6, 10		# $t6 = $t6 + 10
    	mul $s0, $s0, $t6		# a = a * $t6
    IF1_out:
    	addi $s0, $s0, 1 		# a = a + 1

#########################################################
# if ( a < 10 ) {
#   b = 20;
#   if ( a <= 5 ){
#     for(int i = 0; i < a; i++) {	while (i<a) i++
#       b += a * i;
#     }
#   } else {
#       while( a-- > 5) {
#         b -= b / a;
#       }
#   }
# }
#########################################################

.text
    la $gp, 0x10010000 			# define global pointer como endereço inicial do .data
    lw $s0, 0($gp)			# $s0 <- a
    lw $s1, 4($gp)			# $s1 <- b
    lw $s2, 16($gp)			# $s2 <- i

    IF2:
    	bgt $s0, 10, IF2_out   		# if(a>10) --> vai pro else
    IF2_them:
    	li $s1, 20			# b = 20
    	IF3:	
    	    bgt $s0,5, IF3_else		# if(a>5) --> vai pro else
    	IF3_them:
    	    FOR1:
    	    	bge $s2, $s0, FOR1_out	# i >= a  --> sai do for
    	    	mul $t0, $s0, $s1	# $t0 = a * i
    	    	add $s1, $s1, $t0	# b = b + $t0
    	    FOR1_out:
    	IF3_else:
    	    WHILE1:
		addi $s0, $s0, -1 	# a = a - 1
    		ble $s0, 5, IF3_out	# a <= 5  --> sai do while
    		div $t1, $s1, $s0	# $t1 = b / a
    		sub $s1, $s1, $t1	# b = b - $t1	    	
    	IF3_out:
    IF2_out:
