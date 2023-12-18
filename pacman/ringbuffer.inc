#define MAX_SIZE 16
.eqv RB_MAX_SIZE 16

#typedef struct ringbuffer {
#	int size;
#	int rd;
#	int wr;
#	char buf[MAX_SIZE];
#} t_ringbuffer;
.macro t_ringbuffer(%name)
.data
%name:
.align 2
	.space 12
	.space RB_MAX_SIZE
.end_macro

.text
# void rb_init(t_ringbuffer * rbuf){
# 	rbuf->size = 0;
# 	rbuf->rd = 0;
# 	rbuf->wr = 0;
# }
rb_init:
	sw $zero, 0($a0)
	sw $zero, 4($a0)
	sw $zero, 8($a0)
	jr $ra

# bool rb_empty(t_ringbuffer * rbuf){
#	if (rbuf->size == 0) {
#		return 1;
#	} else {
#		return 0;
#	}
# }
rb_empty: #IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP# 
	lw $t0,0($a0)	# rbuf->size
	if1:
		bne $t0, 0, if1_else	# if (rbuf->size != 0) --> vai pro else
	if1_them:
		li $v0, 1
		j if1_out
	if1_else:
		li $v0, 0
	if1_out:
	jr   $ra

# bool rb_full(t_ringbuffer * rbuf){
#	if (rbuf->size == MAX_SIZE)
#		return 1;
#	else
#		return 0;
# } 
rb_full: #IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP# 
	lw $t0,0($a0)	# rbuf->size
	if2:
		bne $t0, RB_MAX_SIZE, if2_else	# if (rbuf->size == MAX_SIZE) --> vai pro else
	if2_them:
		li $v0, 1
		j if2_out
	if2_else:
		li $v0, 0
	if2_out:
	jr   $ra

# main
# --- old stack  8 ($sp)
#============= 
#  $ra        	  4 ($sp)
#-------------
#  $a0            0 ($sp)
#=============

#char rb_read(t_ringbuffer * rbuf){
#	char tmp = 0;
#	if(!rbuf_empty(rbuf)){
#		rbuf->size--;
#		tmp = rbuf->buf[rbuf->rd];
#		rbuf->rd = (rbuf->rd + 1) % MAX_SIZE;
#	}
#	return tmp;
#}
rb_read: #IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP# 
	addiu $sp, $sp, -8
	sw $ra, 4($sp)
	
	li $t5, 0		# char tmp = 0
	
	jal rb_empty
	if3:
		bne $v0, $0, if3_out	# if ( rbuf_empty(rbuf) == 0 ) --> sai do if
	if3_them:
		sw   $t0, 0($a0)   # rbuf->size
		addi $t0, $t0, -1  # rbuf->size--

		lw   $t1, 4($a0)   # rbuf->rd
		add  $t2, $t1, $a0
		lb   $t5, 12($t2)  # tmp = rbuf->buf[rbuf->rd];

		addi $t1, $t1, 1   # rbuf->rd++
		li   $t3, RB_MAX_SIZE
		div  $t1, $t3
		mfhi $t1
		sw   $t1, 4($a0)   # rbuf->rd = (rbuf->rd + 1) % RB_MAX_SIZE

	if3_out:
	#move $v0, $t5
	addi $v0, $t5, 0
	lw   $ra, 4($sp)
	addiu $sp, $sp, 8
	jr   $ra

# bool rb_write(t_ringbuffer * rbuf, char byte){
#	if(!rbuf_full(rbuf)){
#		rbuf->size++;
#		rbuf->buf[rbuf->wr] = byte;
#		rbuf->wr = (rbuf->wr + 1) % MAX_SIZE;
#		return 1;
#	}
#	return 0;
# }

# main
# --- old stack  8 ($sp)
#============= 
#  $ra        	  4 ($sp)
#-------------
#  $a0            0 ($sp)
#=============

rb_write: #IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP#IMP# 
	addiu $sp, $sp, -8
	sw $ra, 4($sp)
	
	jal rb_full
	
	if4:
		bne $v0, $0, if4_out # if (rb_full != 0) --> sai do if
	if4_them:
		lw $t0, 0($a0)      # Carrega rbuf->size
		addi $t0, $t0, 1	# rbuf->size++
		sw $t0, 0($a0)      # Armazena rbuf->size
		
		lw $t0, 8($a0)      # Carrega rbuf->wr
		add $t1, $t0, $a0   # Calcula o endereço de rbuf->buf[rbuf->wr]
		
		addi $t0, $t0, 1	# rbuf->wr + 1
		lw $t3, RB_MAX_SIZE
		div $t0, $t3
		mfhi $t2	# (rbuf->wr + 1) % MAX_SIZE
		
		li $v0, 1	# retorna 1
	
	if4_out:
	
	li $v0, 0	# retorna 0
	lw   $ra, 4($sp)
	addiu $sp, $sp, 8
	jr $ra
