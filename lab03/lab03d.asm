#########################################################
# Laboratório 03 - MCP22105
# Estruturas de Controle
#
# Aluno: Fabrício Rodrigues de Santana
#########################################################

#########################################################
# Uma cadeia de caracteres (string) é definida como um 
# conjunto de bytes, ordenados de forma consecutiva na 
# memória, terminada por um caractere nulo (byte 0). Faça 
# um programa que receba o endereço do início de uma string 
# e calcule o seu tamanho (número de caracteres). O 
# endereço da string é armazenado no endereço 0x10010000. 
# Armazene o resultado no endereço de memória 0x10010004.
#
#########################################################

.data
endereço: .word 0      # 0x10010000 (Endereço da string)
caracteres: .word 0    # 0x10010004 (Resultado)

.data 0x10010008
zero: .asciiz "\0"      # 0x10010008 (String nula)
hello: .asciiz "Hello World!" # 0x10010009 (Sua string)

.text
la $a0, hello           # Carrega o endereço da string 'Hello World!' em $a0
li $t0, 0               # Inicializa o contador de caracteres em 0
la $t1, zero            # Carrega o endereço da string nula em $t1

loop:
   lb $t2, 0($a0)       # Carrega o byte da string em $t2
   beqz $t2, end_loop   # Se for nulo (fim da string), saia do loop

   addi $t0, $t0, 1     # Incrementa o contador de caracteres
   addi $a0, $a0, 1     # Avança para o próximo caractere
   j loop

end_loop:
# Armazena o resultado (número de caracteres) em 0x10010004
sw $t0, caracteres

# O programa termina aqui
