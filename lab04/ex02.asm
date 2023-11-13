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
	
	## Resize str1
	la $a0, str1			# primeiro parâmetro
	li $a1, 8			# segundo parâmetro
	jal strResize
	
	print_str("Str1 ajustada: ")
	print_str_ptr(str1)
	print_str("\n")
	
	## Chamar strlen
	la $a0, str1
	jal strlen
	move $s0, $v0
	print_str("A str1 ajustada tem ")
	print_int_reg($s0)
	print_str(" caracteres\n")
	
	
	print_str("Final do programa\n")
	exit

#############################################	
# int strResize(char * str, int size);
#
#  O procedimento deve modificar o tamanho da string
# de acordo com o tamanho especificado pelo parâmetro
# size. O size deve ser sempre menor que o tamanho
# atual da string.
#
#  O procedimento retorna o valor -1, caso o size seja
# maior que o tamanho da string, ou o novo tamanho da
# string, caso contrário, ou seja, o próprio valor de
# size.
#
# int strResize(char *str, int size) {
#     // Verifica se size é maior que o tamanho atual da string
#     if (size >= strlen(str)) {
#         return -1;
#     }
# 
#     // Redimensiona a string para o novo tamanho
#     str[size] = '\0';
# 
#     return size;
# }


strResize:
    	# $a0: ponteiro para a string
    	# $a1: novo tamanho
    	# $v0: resultado (novo tamanho ou -1)
    
    	li $v0, -1  # Inicializa $v0 com -1
    	
    	# Chama strlen para obter o tamanho atual da string
    	move $a0, $a0
    	jal strlen
    	move $s0, $v0  # $s0 contém o tamanho atual
    	
    	if1:
    		bge $a1, $s0, if1_else		# caso o tamanho solicitado >= tamanho atual, vai pro else
    	if1_them:
    		# Ajusta o tamanho da string para $a1
    		li $v0, 0
    		move $t0, $a0  # $t0 contém o ponteiro original para a string
    		move $a0, $a1  # $a0 contém o novo tamanho
    		jal strlen     # Calcula o novo tamanho da string após o ajuste
    		move $s1, $v0  # $s1 contém o novo tamanho

    		# Ajusta o ponteiro para a string
    		add $a0, $t0, $s1
    		sb  $zero, 0($a0)  # Adiciona o caractere nulo ao final da string
    	if1_else:
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
