
#########################################################
# Laboratório 03 - MCP22105
# Procedimentos
#
# Aluno: Fabrício Rodrigues de Santana
#########################################################

#########################################################
# O fatorial de um número pode ser calculado através de 
# um procedimento recursivo, conforme definido abaixo:
#
# unsigned int fatorial(unsigned int n){ 
#     if(n == 0) {
#         return 1; 
#     } else {
#         return n * fatorial(n-1); 
#     }
# }
#
# Implemente a função fatorial apresentada acima, 
# e faça um programa que irá apresentar o fatorial dos 
# primeiros 10 números naturais. Utilize as chamadas de 
# sistema para a entrada e saída de dados. O código deve 
# ser implementado seguindo a convenção de chamada de 
# procedimento estudada em sala de aula.
#########################################################
.include "macros.inc"
.text 0x00400000
init:
	la $sp, 0x7FFFEFFC
	jal main
	exit
.include "string.inc"

#-----------
# ($a0) old_stk -> 16($sp)
#-----------
#   $ra         -> 12($sp)
#-----------
#   $s1         -> 8($sp)
#-----------
#   $s0         -> 4($sp)
#-----------
#   $a0         -> 0($sp)
#############################################
main:
	addiu $sp, $sp, -16
	sw 	  $s0, 4($sp)
	sw    $s1, 8($sp)
	sw    $ra, 12($sp)

	li $s0, 11
main_L0:
	beqz $s0, main_L0_end
	addi $s0, $s0, -1
	
	print_str("fatorial(")
	print_intReg($s0)
	print_str(") = ")
	
	move $a0, $s0
	jal  fatorial
	move $s1, $v0
	
	print_intReg($s1)
	print_str("\n")
	
	j main_L0
main_L0_end:
  lw	  $ra, 12($sp)
  lw    $s1, 8($sp)
  lw    $s0, 4($sp)
	addiu $sp, $sp, 16
	jr $ra
############################################

fatorial:
	addi $sp, $sp, -16   # Aloca espaço na pilha
    	sw   $ra, 8($sp)    # Salva o endereço de retorno na pilha
	
	


######################
# unsigned int fatorial(unsigned int n){ 
#     unsigned int ret;
#     if(n == 0) {
#         ret = 1; 
#     } else {
#         ret = n * fatorial(n-1); 
#     }
#		  return ret;
# }
#
#############################################
