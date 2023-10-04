##################################################################################
# Aluno: Fabrício Rodrigues de Santana
# 
# Elaborar uma programa para realizar as 4 operações básicas de soma, subtração, divisão e multiplicação, utilizando operações com ponto flutuantes.
#
# Interface simples, com acumulador
#
# Pergunta a operação através de um menu (exemplo abaixo)
#
# 1- Exibir Acumulador
# 2- Zerar Acumulador
# 3- Realizar Soma
# 4- Realizar Subtração
# 5- Realizar Divisão
# 6- Realizar Multiplicação
# 7- Sair do programa
# Se pertinente solicita entrada de valor (opções 3 a 6)
# 
# Exibe resultado
# 
##################################################################################


.data 0x10018000
acumulador:  .float 0.0   	# Inicialize o acumulador com zero
resultado:   .float 0.0   	# Variável que armazena o resultado temporário

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

.macro lerFloat		
	li $v0, 6
	syscall
.end_macro

.macro imprimirFloat (%f)
	li $v0, 2
	mov.s $f12, %f
	syscall
.end_macro

.text
    # Inicialize o acumulador com zero
    mtc1 $zero, $f0

menu:
	imprimirString("\n--> Calculadora <--\n")
	imprimirString("\n0 - Ver menu")
	imprimirString("\n1- Exibir Acumulador")
	imprimirString("\n2- Zerar Acumulador")
	imprimirString("\n3- Realizar Soma")
	imprimirString("\n4- Realizar Subtração")
	imprimirString("\n5- Realizar Divisão")
	imprimirString("\n6- Realizar Multiplicação")
	imprimirString("\n7- Sair do programa\n")

opcao:
    imprimirString("\nOpção: ")
    lerInt($t1)

    beq $t1, 0, menu
    beq $t1, 1, exibir_acumulador
    beq $t1, 2, zerar_acumulador
    beq $t1, 3, realizar_soma
    beq $t1, 4, realizar_subtracao
    beq $t1, 5, realizar_divisao
    beq $t1, 6, realizar_multiplicacao
    beq $t1, 7, sair_do_programa

exibir_acumulador:
    imprimirString("\nAcumulador = ")
    imprimirFloat($f0)
    j opcao

zerar_acumulador:
    # Zera o acumulador
    mtc1 $zero, $f0
    j exibir_acumulador

realizar_soma:
    imprimirString("\nn1 = ")		
    lerFloat			
    mov.s $f1, $f0		
    imprimirString("\nn2 = ")		
    lerFloat			
    mov.s $f2, $f0
    add.s $f0, $f1, $f2  # Acumula o resultado no acumulador
    j opcao

realizar_subtracao:
    imprimirString("\nn1 = ")		
    lerFloat			
    mov.s $f1, $f0		
    imprimirString("\nn2 = ")		
    lerFloat			
    mov.s $f2, $f0
    sub.s $f0, $f1, $f2  # Acumula o resultado no acumulador
    j opcao

realizar_divisao:
    imprimirString("\nn1 = ")		
    lerFloat			
    mov.s $f1, $f0		
    imprimirString("\nn2 = ")		
    lerFloat			
    mov.s $f2, $f0
    div.s $f0, $f1, $f2  # Acumula o resultado no acumulador
    j opcao

realizar_multiplicacao:
    imprimirString("\nn1 = ")		
    lerFloat			
    mov.s $f1, $f0		
    imprimirString("\nn2 = ")		
    lerFloat			
    mov.s $f2, $f0
    mul.s $f0, $f1, $f2  # Acumula o resultado no acumulador
    j opcao

sair_do_programa:
    exit
