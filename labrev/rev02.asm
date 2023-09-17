#########################################################
# Realize a conversão das expressões abaixo considerando
# que os valores das variáveis já estão carregados nos
# registradores, conforme o mapeamento indicado abaixo
#
# Mapeamento dos registradores:
# a: $s0, b: $s1, c: $s2, d: $s3
#########################################################

#########################################################
# if (a != b) {				  	// 1 != 2
#    a = b;					// a = 2
#    if( c < 3 ){				// 3 < 3 ?
#      a++;					
#    } else {					 
#      for(int i = 3; i < 15; i += 2) {		// 3+2=5+2=7+2=9+2=11+2=13+2=15
#         b += i;				// 2+2=4+5=8+7=15+9=24+11=35+13=48+13=61
#      }
#    }
# }
#########################################################

.data # 0x10010000 (padrão)		 (hexadecimal) ( decimal)
a: .word 1 				# 0x10010000  # 0x10010000
b: .word 2 				# 0x10010004  # 0x10010004
c: .word 3 				# 0x10010008  # 0x10010008
d: .word 4 				# 0x1001000C  # 0x10010012

.text
    la $gp, 0x10010000 			# define global pointer como endereço inicial do .data
    lw $s0, 0($gp)			# $s0 <- a
    lw $s1, 4($gp)			# $s1 <- b
    lw $s2, 8($gp)			# $s2 <- c
    lw $s3, 12($gp)			# $s3 <- d
    
    if1:
    	beq $s0, $s1, if1_else		# if(a==b) --> vai pro else
    if1_them:
    	addi $s0, $s1, 0		# a = b + 0
    	if2:
    	   bge $s2, 3, if2_else		# if (c >= 3) --> vai pro else
    	if2_them:
    	   addi $s0, $s0, 1		# a = a + 1
    	   j if2_out
    	if2_else:
    	   for1:
    	       li $t0, 3		# i = 3
    	   for1_start:
    	       bge $t0, 15, for1_end	# if ( i >= 15) --> encerra if
    	       add $s1, $s1, $t0	# b = b + i
    	       addi $t0, $t0, 2		# i = i + 2
    	       j for1_start
    	   for1_end: 
    	if2_out:
    	j if1_out
    if1_else: 	
if1_out:
