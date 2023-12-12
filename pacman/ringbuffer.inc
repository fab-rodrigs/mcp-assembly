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
rb_empty:
    lw $t0, 0($a0)      # Carrega rbuf->size em $t0
    beq $t0, $zero, if1 # Se rbuf->size == 0, vá para if1_them (return 1)
    j   if1_else             # Caso contrário, vá para if1_else (return 0)
if1_them:
    li $v0, 1           # Se rbuf->size == 0, configura $v0 para 1 (true)
    jr $ra
if1_else:
    li $v0, 0           # Se rbuf->size != 0, configura $v0 para 0 (false)
    jr $ra

# bool rb_full(t_ringbuffer * rbuf){
#	if (rbuf->size == MAX_SIZE)
#		return 1;
#	else
#		return 0;
# } 
rb_full:
    lw $t0, 0($a0)           # Carrega rbuf->size em $t0
    li $t1, MAX_SIZE         # Carrega MAX_SIZE em $t1
    beq $t0, $t1, if2_them   # Se rbuf->size == MAX_SIZE, vá para if2_them (return 1)
    j   if2_else             # Caso contrário, vá para if2_else (return 0)
if2_them:
    li $v0, 1                # Se rbuf->size == MAX_SIZE, configura $v0 para 1 (true)
    jr $ra
if2_else:
    li $v0, 0                # Se rbuf->size != MAX_SIZE, configura $v0 para 0 (false)
    jr $ra
	
#char rb_read(t_ringbuffer * rbuf){
#	char tmp = 0;
#	if(!rbuf_empty(rbuf)){
#		rbuf->size--;
#		tmp = rbuf->buf[rbuf->rd];
#		rbuf->rd = (rbuf->rd + 1) % MAX_SIZE;
#	}
#	return tmp;
#}
rb_read:
    lb $v0, 12($a0)           # Carrega rbuf->buf[rbuf->rd] em $v0
    lw $t0, 0($a0)            # Carrega rbuf->size em $t0
    beqz $t0, rb_read_end     # Se rbuf->size == 0, encerra a função
    subu $t0, $t0, 1          # Decrementa rbuf->size
    sw $t0, 0($a0)            # Armazena o novo valor de rbuf->size
    lw $t1, 4($a0)            # Carrega rbuf->rd em $t1
    addiu $t1, $t1, 1         # Incrementa rbuf->rd
    li $t2, MAX_SIZE          # Carrega MAX_SIZE em $t2
    rem $t1, $t1, $t2         # Calcula (rbuf->rd + 1) % MAX_SIZE
    sw $t1, 4($a0)            # Armazena o novo valor de rbuf->rd
rb_read_end:
    jr $ra


# bool rb_write(t_ringbuffer * rbuf, char byte){
#	if(!rbuf_full(rbuf)){
#		rbuf->size++;
#		rbuf->buf[rbuf->wr] = byte;
#		rbuf->wr = (rbuf->wr + 1) % MAX_SIZE;
#		return 1;
#	}
#	return 0;
# }

rb_write:
    lb $t0, 12($a0)          # Carrega rbuf->buf[rbuf->wr] em $t0
    lw $t1, 0($a0)           # Carrega rbuf->size em $t1
    li $t2, MAX_SIZE         # Carrega MAX_SIZE em $t2
    beq $t1, $t2, rb_write_end  # Se rbuf->size == MAX_SIZE, encerra a função
    sb $a1, 12($a0)          # Armazena byte em rbuf->buf[rbuf->wr]
    addiu $t1, $t1, 1        # Incrementa rbuf->size
    sw $t1, 0($a0)           # Armazena o novo valor de rbuf->size
    lw $t3, 8($a0)           # Carrega rbuf->wr em $t3
    addiu $t3, $t3, 1        # Incrementa rbuf->wr
    rem $t3, $t3, $t2        # Calcula (rbuf->wr + 1) % MAX_SIZE
    sw $t3, 8($a0)           # Armazena o novo valor de rbuf->wr
    li $v0, 1                # Configura $v0 para 1 (true)
    j rb_write_end
rb_write_end:
    jr $ra