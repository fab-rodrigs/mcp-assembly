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
str1:       .asciiz "MCP22105 is cool"

.text
	print_str("Str1: ")
	print_str_ptr(str1)
	print_str("\n")
	
	## Chamar strlen
	la $a0, str1
	jal strlen
	move $s0, $v0
	
	print_str("A str1 tem ")
	print_int_reg($s0)
	print_str(" caracteres\n")
	
	## Search ' '
	la $a0, str1
	li $a1, ' '
	jal strSearch
	move $s0, $v0
	
	print_str("O espaço está no índice: ")
	print_int_reg($s0)
	print_str("\n")
	
	print_str("Final do programa\n")
	exit

#############################################	
# int strSearch(char * str, char value);
#
#  O procedimento deve procurar o caracter passado
# como parâmetro na string, retornando o inteiro
# equivalente a sua posição na string (índice).
#  Caso o caracter não seja encontrado, o procedimento
# deve retornar -1.
# 
# int strSearch(char * str, char value){
# 	int index = 0;	
# 	
# 	while(str[index] != '\0'){
# 		
# 		if(str[index] == value)
# 			return index;
# 
# 		index++;
# 	}
# 	
# 	return -1;	 // Caso não seja encontrado o carácter
# }

strSearch:
# $a0: ponteiro para a string
# $a1: caractere a ser procurado
# $v0: resultado (índice ou -1)
	li $v0, -1				# $v0 = -1 caso não encontre carácter
	li $t1, 0				# index = 0
 	
 	while1:
 		lb $t0, 0($a0)    		# carrega o caractere atual da string em $t0
 		beq $t0, $zero, while1_out	# caso o caracter seja igual a 0, sai do while
 		
 		if1:
 			beq $t0, $a1, if1_them
 		if1_else:
 			addi $a0, $a0, 1	# soma 1 no endereço da string 
 			addi $t1, $t1, 1  	# incrementa o índice
 			j while1		# volta pro início do loop
 		if1_them:
 			move $v0, $t1   	# armazena o índice em $v0			
 	while1_out:
	
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
