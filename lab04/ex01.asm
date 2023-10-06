.macro print_str_ptr (%ptr)
  li $v0, 4
  la $a0, %ptr
  syscall
.end_macro

.macro print_str (%str)
.data
mStr: .asciiz %str
.text
   li $v0, 4
   la $a0, mStr
   syscall
.end_macro

.macro print_int_reg (%reg)
  move $a0, %reg
  li $v0, 1
  syscall
.end_macro

.macro get_str (%ptr, %max_size)
  li $v0, 8
  la $a0, %ptr
  li $a1, %max_size
  syscall
.end_macro

.macro get_int(%reg)
	li $v0, 5
	syscall
	move %reg, $v0
.end_macro

.macro exit
   li $v0, 10
   syscall
.end_macro

.data
str_len:    .word 0
str_buffer: .space 1024
str1:       .asciiz "MCP22105 is cool"

.text

	print_str("Digite uma frase: ")
	get_str(str_buffer, 1024)
	
	print_str("Você digitou: ")
	print_str_ptr(str_buffer)
	
	## Chamar strlen
	la $a0, str_buffer
	jal strlen
	sw $v0, str_len
	
	print_str("A string digitada tem ")
	lw  $t0, str_len
	print_int_reg($t0)
	print_str(" caracteres\n")
	
	# Fazer a conversão da string para caracteres minúsculos
	la	$a0, str_buffer
	li	$a1, 0
	jal	changeCase
	print_str("Minúsculo: ")
	print_str_ptr(str_buffer)
	print_str("\n")
	
	# Fazer a conversão da string para caracteres maiúsculos
	la	$a0, str_buffer
	li	$a1, 1
	jal	changeCase
	print_str("Maiúsculo: ")
	print_str_ptr(str_buffer)
	print_str("\n")
	
	print_str("Final do programa\n")
	exit

#############################################	
# void changeCase(char * str, bool type);
#
#  A função deve converter as letras da string
# para maiúsculo ou minúsculo, conforme o segundo
# parâmetro type (0 - minúsculo, 1-maiúsculo). 
#
#  As letras minúsculas estão entre os valores 97(a) e
# 122(z), e as letras maiúsculas entre os valores
# 65(A) e 90(Z). A conversão pode ser feita somando
# ou subtraindo a diferença entre esses valores.
#
changeCase:

	
	jr $ra
#############################################

#############################################	
# int strlen(char * str) {
#   int len = 0;
#   while ( *str != 0 ){
#     str = str + 1;
#     len = len + 1;
#   }
#   return len;
#}
strlen:
	li $v0, 0 # len = 0
	strlen_L0:
		lb   $t0, 0($a0)
		beq  $t0, $zero, strlen_L0_exit
		addi $a0, $a0, 1
		addi $v0, $v0, 1
		j strlen_L0
	strlen_L0_exit:
	jr $ra
#############################################
	
