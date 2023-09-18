#########################################################
# Laboratório 03 - MCP22105
# Estruturas de Controle
#
# Aluno: Fabrício Rodrigues de Santana
#########################################################

#########################################################
# Faça um programa que receba dois endereços de memória 
# (fonte e destino) (0x10010000, 0x10010004), além da 
# quantidade de posições de memória (bytes) que devem 
# ser copiados (0x10010008), e faça a transferência dos 
# dados presentes no endereço de fonte, para o endereço 
# de destino.
#
#########################################################

.data
fonte: .word 0x10010000  # Endereço de origem (0x10010000)
destino: .word 0x10010004  # Endereço de destino (0x10010004)
tamanho: .word 0x10010008  # Tamanho em bytes a ser copiado (0x10010008)

.text
# Carregar os endereços de origem, destino e tamanho em registradores
lw $a0, fonte
lw $a1, destino
lw $t0, tamanho

loop:
   # Carregar um byte da memória de origem em $t1
   lb $t1, 0($a0)
   
   # Armazenar o byte na memória de destino
   sb $t1, 0($a1)
   
   # Incrementar os ponteiros de origem e destino
   addi $a0, $a0, 1
   addi $a1, $a1, 1
   
   # Decrementar o contador de tamanho
   subi $t0, $t0, 1
   
   # Verificar se terminou a cópia
   beqz $t0, end_loop
   
   # Caso contrário, continue o loop
   j loop

end_loop:
# O programa termina aqui
