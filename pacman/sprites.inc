.text 0x00430000

#  int colors[8];
#  sprite sprites[20];
#  char sprite[49];
#=============================================================
# void draw_sprite(X, Y, sprite_id){
#       char * ptr_sprite =  sprites[sprite_id];
#       for(int i = 0; i < 49; i++){ 
#			color = colors[*ptr_sprite];
#           sX = i % 7 ;
#			sY = i / 7 ;
#           sX = X + sX;
#           sY = Y + sY;
#        	set_pixel(sX, sY, color)
#           ptr_sprite++;
#       }
# }
## IMP

# main
# --- old stack   40 ($sp)
#============= 
#  <empty>        36 ($sp)
#-------------
#  $ra            32 ($sp)
#-------------
#  $s4            28 ($sp)
#-------------
#  $s3            24 ($sp)
#-------------
#  $s2            20 ($sp)
#-------------
#  $s1            16 ($sp)
#-------------
#  $s0            12 ($sp)
#-------------
#  $a2            8 ($sp)
#-------------
#  $a1            4 ($sp)
#-------------
#  $a0            0 ($sp)
#=============

draw_sprite: #IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP# 
	addiu $sp, $sp, -40
	sw   $ra, 32($sp)
	sw   $s4, 28($sp)
	sw   $s3, 24($sp)
	sw   $s2, 20($sp)
	sw   $s1, 16($sp)
	sw   $s0, 12($sp)
#	sw   $a2, 8($sp)
#	sw   $a1, 4($sp)
#	sw   $a0, 0($sp)

	move $s0,$a0	# s0 = X
	move $s1,$a1	# s1 = Y
#	move $s2,$a2	# s2 = sprite_id
	
	la $s2, colors		# Endereço base do array de cores
	
	la $s3, sprites 	# s3 = *ptr_sprite
	mul $t2, $a2, 49  	# Offset do sprite_id
	add $s3, $s3, $t2   # char * ptr_sprite = sprites[sprite_id];
	
	li $s4, 0			# i = 0
	
	for1:
		bge $s4, 49, for1_out		# if (i >= 49) , sai do for1
		
		lb $t2, 0($s3) 			# Carrega o valor apontado por ptr_sprite
		sll $t2, $t2, 2			# Multiplica o índice de cor por 4 (tamanho de um inteiro)
		add $t2, $t2, $s2		# Soma o offset ao endereço base para obter o endereço final da cor
		lw $a2, 0($t2)			# Carrega a cor na variável $s30
		
		li $t7, 7			# t7 = 7
		div $s4, $t7			# i / 7
		mfhi $t2        		# sX = i % 7
		mflo $t3        	 	# sY = i / 7
		
		add $a0, $s0, $t2		# sX = X + sX
		add $a1, $s1, $t3		# sY = Y + sY
		
		jal set_pixel
		
		addi $s3, $s3, 1		# ptr_sprite++
		addi $s4, $s4, 1		# i++
		
		j for1					# Volta para for1
	for1_out:

#	lw   $a0, 0($sp)
#	lw   $a1, 4($sp)
#	lw   $a2, 8($sp)
	lw   $s0, 12($sp)
	lw   $s1, 16($sp)
	lw   $s2, 20($sp)
	lw   $s3, 24($sp)
	lw   $s4, 28($sp)
	lw   $ra, 32($sp)
	addiu $sp, $sp, 40
    jr   $ra
#=============================================================

#=============================================================
# main
# --- old stack   8 ($sp)
#============= 
#  $ra        	  4 ($sp)
#-------------
#  $s0            0 ($sp)
#=============

# void draw_animated_sprite(animated_sprite*)
## IMP
draw_animated_sprite: #IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP# 
	# Chama draw_sprite com a posição contida na estrutura
	# animated_sprite
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)
	
	move $t0, $a0   # Move o ponteiro da estrutura animated_sprite para $t0
	
	lw $a0, 4($t0)  # X
	lw $a1, 8($t0)  # Y
	lw $a2, 0($t0)  # sprite_id
	jal draw_sprite

	lw   $a0, 0($sp)
	lw   $ra, 4($sp)
	addi $sp, $sp, 8
	jr    $ra
#=============================================================

#=============================================================
# void apply_movement(animated_sprite*)
apply_movement:
	lw 	 $t0, 4($a0)
	lw   $t1, 12($a0)
	add  $t0, $t0, $t1
	sw   $t0, 4($a0)
	
	lw   $t0, 8($a0)
	lw   $t1, 16($a0)
	add  $t0, $t0, $t1
	sw   $t0, 8($a0)
	
	jr    $ra
#=============================================================

#=============================================================
# void set_move_animated_sprite(animated_sprite* sp, int vx, int vy)
set_move_animated_sprite:
	# Aplica o vetor de movimento da posicao do sprite
	sw   $a1, 12($a0)
	sw   $a2, 16($a0)
	jr   $ra
#=============================================================

#=============================================================   
# void stop_animated_sprite(animated_sprite* sp)
stop_animated_sprite:
	# zera o vetor de movimento do animated sprite
	sw   $zero, 12($a0)
	sw   $zero, 16($a0)
	jr   $ra
#=============================================================

#=============================================================
# char get_grid_element(row-y, column-x, grid_table* )
get_grid_element:
	## Le o elemento na grid table e retorna
	mul $t0, $a0, GRID_COLS
	add $t0, $t0, $a1
	add $t0, $t0, $a2
	lb  $v0, 0($t0)	
	jr  $ra
#=============================================================

#=============================================================
# draw_grid(width, height, grid_table* )
draw_grid:
	#Percorre a matriz da grid, para cada elemento
	
	## Pegar o id_do_sprite (get_grid_element)
	## converter de ASCII para ID (-64)
	## Chamar draw_sprite(grid pos -> pixel pos - multiplica {X|Y}_SCALE)
	addiu $sp, $sp, -40
	
	sw    $s4, 28($sp)
	sw    $s3, 24($sp)
	sw    $s2, 20($sp)
	sw    $s1, 16($sp)
	sw    $s0, 12($sp)
	sw    $ra, 32($sp)

	move $s0, $a2
	move $s1, $a0
	move $s2, $a1

	li $s3, 0 # ROW
draw_grid_L0:
	beq $s3, $s2, draw_grid_L0_end
	li $s4, 0 # COL
	draw_grid_L1:
		beq  $s4, $s1, draw_grid_L1_end
		
		move $a0, $s3
		move $a1, $s4
		move $a2, $s0
		jal get_grid_element
		move $a2, $v0
		addi $a2, $a2, -64 ## Adjust to idx
		## Convert ROW COL to X, Y
		mul $a0, $s4, X_SCALE
		mul $a1, $s3, Y_SCALE
		jal draw_sprite
		
		addi $s4, $s4, 1
		j draw_grid_L1
	draw_grid_L1_end:
		addi $s3, $s3, 1
		j draw_grid_L0
draw_grid_L0_end:

	lw    $s4, 28($sp)
	lw    $s3, 24($sp)
	lw    $s2, 20($sp)
	lw    $s1, 16($sp)
	lw    $s0, 12($sp)
	lw    $ra, 32($sp)
	addiu $sp, $sp, 40
	
	jr   $ra
#=============================================================

# struct mov_vector {
#    int valid;
#    int mov_x;
#    int mov_y;
# }
#=============================================================
#IMP
# process_input(mov_vector *)
process_input: #IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP# 
    ## Verificar se key_rb está vazio
    ## Se estiver, retornar
	
	## Senao
	## Le valor do ringbuffer
	
	## Processa valor com teclas associadas ao
	## movimento. Setar mov_vector e tornar
	## válido	
	
			
	jr   $ra
#=============================================================

#=============================================================   
# void try_change_movement(animated_sprite* sp, mov_vector* mv)
try_change_movement: #IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP# 
	## Verifica se mov_vector é válido
	## Se não, retorna.

	## Converte posição pixel para posicao grid
	## Lembrete - se resto divisao == 0, está alinhado
	
	## Se não está alinhado, não muda o movimento.
	## Retorna função.
	
	## Se alinhado, verifica se pode se mover para nova
	## direção
	
	## Calculo nova posicao somando vetor movimento
	## com posição do grid e pego elemento do grid
	## para ver se não é parede.
	
	## Se não for parede, aplica vetor de movimento
	## no sprite, caso contrário não faz nada
	## Não esquecer de tornar o mov_vector inválido
	## (valid = 0)
	addi $sp, $sp, -24
	sw   $s0, 12($sp)
	sw   $s1, 16($sp)
	sw   $ra, 20($sp)

	move $s0, $a0
	move $s1, $a1

	lw   $t0, 0($s1)
	beqz $t0, try_change_movement_end

	lw 	 $a1, 4($s0)        # Pixel X
	div  $a1, $a1, X_SCALE  # Column
	mfhi $t0                # If == 0 - root pos
	
	lw 	 $a0, 8($s0)
	div  $a0, $a0, Y_SCALE  # Row
	mfhi $t1				 # If == 0 - root pos
	
	add  $t0, $t0, $t1
	bnez $t0, try_change_movement_end
	
	#Can change direction?
	lw 	 $t0, 4($s1)
	add  $a1, $a1, $t0		# +mov_x
	lw 	 $t0, 8($s1)
	add  $a0, $a0, $t0		# +mov_y
	la   $a2, grid
	jal  get_grid_element
	
	bge  $v0, 69, try_change_movement_end
	
	# change direction
	lw 	 $t0,    4($s1)
	sw   $t0,   12($s0)
	lw 	 $t0,    8($s1)
	sw   $t0,   16($s0)
	sw   $zero,  0($s1)
	
try_change_movement_end:	
	lw   $s0, 12($sp)
	lw   $s1, 16($sp)
	lw   $ra, 20($sp)
	addi $sp, $sp, 24	
			
	jr   $ra
#=============================================================

#=============================================================
# bool check_movement(animated_sprite*)
check_movement: #IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP# 
	## Converte posição pixel para posicao grid
	## Lembrete - se resto divisao == 0, está alinhado
	
	## Se não está alinhado, pode se mover.
	## Retorna verdadeiro
	
	## Calculo nova posicao somando vetor movimento
	## com posição do grid e pego elemento do grid
	## para ver se não é parede.
	
	## Se não é parede retorna verdadeiro
	
	## Se for parede, para o sprite (stop_animated_sprite)
	## e retorna falso.
	addi $sp, $sp, -24
	sw   $s0, 12($sp)
	sw   $ra, 16($sp)

	move $s0, $a0

	lw 	 $a1, 4($s0)        # Pixel X
	div  $a1, $a1, X_SCALE  # Column
	mfhi $t0                # If == 0 - root pos
	
	lw 	 $a0, 8($s0)
	div  $a0, $a0, Y_SCALE  # Row
	mfhi $t1				 # If == 0 - root pos
	
	add  $t0, $t0, $t1
	bnez $t0, check_movement_can_move
	
	lw 	 $t0, 12($s0)
	add  $a1, $a1, $t0		# +mov_x
	lw 	 $t0, 16($s0)
	add  $a0, $a0, $t0		# +mov_y
	la   $a2, grid
	jal  get_grid_element
	
	blt  $v0, 69, check_movement_can_move
	
	move $a0, $s0
	jal  stop_animated_sprite
	li   $v0, 0
	
	j    check_movement_end
		
check_movement_can_move:
	li   $v0, 1

check_movement_end:	
	lw   $s0, 12($sp)
	lw   $ra, 16($sp)
	addi $sp, $sp, 24
	
	jr   $ra
#=============================================================

