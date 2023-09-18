#########################################################
# Laboratório 03 - MCP22105
# Estruturas de Controle
#
# Aluno: Fabrício Rodrigues de Santana
#########################################################

#########################################################
# Faça um programa para buscar um determinado valor em um 
# array de inteiros. O endereço inicial do vetor está 
# armazenado no endereço de memória 0x10010000, o tamanho 
# do vetor está no endereço 0x10010004 e valor que será 
# pesquisado está no endereço 0x10010008. Caso o valor 
# seja encontrado, escreva 0x01 no endereço 0x1001000C, 
# caso contrário, escreva 0x00.
#
#########################################################

.data
array: .word 1, 4, 2, 7, 9, 6, 8, 3, 5  # Exemplo de um array de inteiros
tamanho: .word 9                      # Tamanho do array
valor: .word 7                       # Valor a ser pesquisado
encontrado: .word 0x1001000C         # Endereço para armazenar o resultado

.text
# Carregar os endereços e valores em registradores
lw $a0, array           # Endereço inicial do array
lw $t0, tamanho         # Tamanho do array
lw $t1, valor           # Valor a ser pesquisado
la $t2, encontrado      # Endereço para armazenar o resultado

# Inicializar a variável de resultado com 0
li $t3, 0

loop:
   # Carregar o valor atual do array em $t4
   lw $t4, 0($a0)
   
   # Comparar o valor atual com o valor desejado
   beq $t4, $t1, encontrado
   
   # Avançar para o próximo elemento do array
   addi $a0, $a0, 4
   
   # Decrementar o contador de tamanho
   subi $t0, $t0, 1
   
   # Verificar se terminou a busca
   bnez $t0, loop

# Armazenar o resultado (0x01 ou 0x00) em 0x1001000C
sw $t3, 0($t2)

# O programa termina aqui


#########################################################
# Faça um programa para contar o número de elementos 
# encontrados em um array de inteiros. O endereço inicial 
# do vetor está armazenado no endereço de memória 0x10010000, 
# o tamanho do vetor está no endereço 0x10010004 e valor que 
# será contado está no endereço 0x10010008. Armazene no 
# endereço 0x1001000C o número de elementos encontrados 
# na procura.
#
#########################################################

.data
array: .word 1, 4, 2, 7, 9, 6, 8, 3, 5  # Exemplo de um array de inteiros
tamanho: .word 9                      # Tamanho do array
valor: .word 7                       # Valor a ser contado
contador: .word 0x1001000C            # Endereço para armazenar o resultado

.text
# Carregar os endereços e valores em registradores
lw $a0, array           # Endereço inicial do array
lw $t0, tamanho         # Tamanho do array
lw $t1, valor           # Valor a ser contado
la $t2, contador        # Endereço para armazenar o resultado

# Inicializar o contador com 0
li $t3, 0

loop:
   # Carregar o valor atual do array em $t4
   lw $t4, 0($a0)
   
   # Comparar o valor atual com o valor desejado
   beq $t4, $t1, encontrado
   
   # Avançar para o próximo elemento do array
   addi $a0, $a0, 4
   
   # Decrementar o contador de tamanho
   subi $t0, $t0, 1
   
   # Verificar se terminou a busca
   bnez $t0, loop

encontrado:
   # Incrementar o contador quando o valor for encontrado
   addi $t3, $t3, 1

# Armazenar o resultado (número de elementos) em 0x1001000C
sw $t3, 0($t2)

# O programa termina aqui
