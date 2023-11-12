.macro exit
   li $v0, 10
   syscall
.end_macro

.data

.text
# init
init:
	la $sp, 0x7FFFEFFC
	jal main
	exit

# main
# --- old stack   8 ($sp)
#============= 
#  <empty>        4 ($sp)
#-------------
#  $ra            0 ($sp)
#=============
main:
	addi $sp, $sp, -8
	sw   $ra, 0($sp)
	
main_L0:
	jal getchar
	move $a0, $v0
	jal printchar
	j   main_L0
	
	lw   $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra
#==============
	
#=============================================================
#char getchar();
getchar:
	la $t0, 0xffff0000

getchar_pooling:
	lw   $t1, 0($t0) # Carregando o registrador de controle do teclado	
	andi $t1, $t1, 1 # isolo o bit Ready
	beq  $t1, $zero, getchar_pooling
	
	lb  $v0, 4($t0) # leio o registrador de dados
	
	jr $ra
#=============================================================

#=============================================================
# void printchar(char a)
printchar:
	la $t0, 0xffff0008
	
print_char_pooling:
	lw   $t1, 0($t0) # Carregando o registrador de controle do Display	
	andi $t1, $t1, 1 # isolo o bit Ready
	beq  $t1, $zero, print_char_pooling
	
	sb  $a0, 4($t0) # escrevo o char no registrador de dados do Display

	jr $ra
#=============================================================

#=============================================================
# int getline(char * string, int buf_size);
getline:

    jr $ra
#=============================================================

#=============================================================
# void printstring(char * string);
print_string:

    jr $ra
#=============================================================
