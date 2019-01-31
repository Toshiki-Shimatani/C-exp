tree
PROGRAM
|-VAR_DECS
| |-AST_DEC
| | |-AST_IDENT a
| | |-NULL
| | |-NULL
| |-NULL
|-AST_FUNC_LIST
  |-AST_FUNC
  | |-AST_IDENT main
  | |-NULL
  | |-VAR_DECS
  | | |-AST_DEC
  | | | |-AST_IDENT i
  | | | |-NULL
  | | | |-NULL
  | | |-VAR_DECS
  | |   |-AST_DEC
  | |   | |-AST_IDENT sum
  | |   | |-NULL
  | |   | |-NULL
  | |   |-NULL
  | |-AST_STAT_LIST
  |   |-AST_ASSIGN
  |   | |-AST_IDENT sum
  |   | |-AST_NUM 0
  |   |-AST_STAT_LIST
  |     |-AST_ASSIGN
  |     | |-AST_IDENT i
  |     | |-AST_NUM 1
  |     |-AST_STAT_LIST
  |       |-AST_WHILE
  |       | |-AST_LESS
  |       | | |-AST_IDENT i
  |       | | |-AST_NUM 11
  |       | |-AST_STAT_LIST
  |       |   |-AST_ASSIGN
  |       |   | |-AST_IDENT sum
  |       |   | |-AST_ADD
  |       |   |   |-AST_IDENT sum
  |       |   |   |-AST_IDENT i
  |       |   |-AST_STAT_LIST
  |       |     |-AST_ASSIGN
  |       |     | |-AST_IDENT i
  |       |     | |-AST_ADD
  |       |     |   |-AST_IDENT i
  |       |     |   |-AST_NUM 1
  |       |     |-NULL
  |       |-AST_STAT_LIST
  |         |-AST_ASSIGN
  |         | |-AST_IDENT a
  |         | |-AST_IDENT sum
  |         |-NULL
  |-NULL
symbol table
0 KEYWORD global
1 VAR a
3 FUNC main
  2 KEYWORD local
  4 VAR i
  5 VAR sum
code
	INITIAL_GP = 0x10008000		# initial value of global pointer
	INITIAL_SP = 0x7ffffffc		# initial value of stack pointer
	# system call service number
	stop_service = 99

	.text
init:
	# initialize $gp (global pointer) and $sp (stack pointer)
	la	$gp, INITIAL_GP		# $sp <- 0x10008000 (INITIAL_GP)
	la	$sp, INITIAL_SP		# $sp <- 0x7ffffffc (INITIAL_SP)
	jal	main			# jump to `main'
	nop				# (delay slot)
	li	$v0, stop_service	# $v0 <- 99 (stop_service)
	syscall				# stop
	nop
	# not reach here
	stop:					# if syscall return
	j stop				# infinite loop...
	nop				# (delay slot)

	.text 	0x00001000
main:
	subiu $sp, $sp, 32
	sw    $ra, 28($sp)
	sw    $fp, 24($sp)
	add   $fp, $sp, $zero
	sw    $a0, 32($sp)
	sw    $a1, 36($sp)
	sw    $a2, 40($sp)
	sw    $a3, 44($sp)
main_body:
	addi $t0, $zero, 0
	sw   $t0, -4($sp)  /* push */
	lw  $t0, -4($sp)
	nop
	sw  $t0, 4($sp)
	addi $t0, $zero, 1
	sw   $t0, -4($sp)  /* push */
	lw  $t0, -4($sp)
	nop
	sw  $t0, 0($sp)
	j   while_L2_0
while_L1_0:
/* stat list */
	lw  $t1, 0($sp)
	nop
	lw  $t0, 4($sp)
	nop
	add  $t2, $t0, $t1
	sw   $t2, -4($sp)  /* push */
	lw  $t0, -4($sp)
	nop
	sw  $t0, 4($sp)
	addi $t1, $zero, 1
	lw  $t0, 0($sp)
	nop
	add  $t2, $t0, $t1
	sw   $t2, -4($sp)  /* push */
	lw  $t0, -4($sp)
	nop
	sw  $t0, 0($sp)
while_L2_0:
	lw  $t0, 0($sp)
	nop
	sw   $t0, -4($sp)  /* push */
	addi $t0, $zero, 11
	sw   $t0, -8($sp)  /* push */
	lw  $t0, -4($sp)  /* pop */
	lw  $t1, -8($sp)  /* pop */
	nop
	slt  $t0, $t0, $t1
	bne  $t0, $zero, while_L1_0
	nop
	lw  $t0, 4($sp)
	nop
	sw   $t0, -4($sp)  /* push */
	lw  $t0, -4($sp)
	nop
	la $t7, a
	sw  $t0, 0($t7)
main_end:
	add   $sp, $fp, $zero
	lw    $ra, 28($sp)
	nop
	lw    $fp, 24($sp)
	nop
	addiu $sp, $sp, 32
	jr $ra
	.align 2
	# data segment (global variables)
	.data
a:	.word  0
