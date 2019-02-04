	INITIAL_GP = 0x10008000		# initial value of global pointer
	INITIAL_SP = 0x80000000		# initial value of stack pointer
	# system call service number
	stop_service = 99

	.text
init:
	# initialize $gp (global pointer) and $sp (stack pointer)
	la	$gp, INITIAL_GP		# $sp <- 0x10008000 (INITIAL_GP)
	la	$sp, INITIAL_SP		# $sp <- 0x7fffffff (INITIAL_SP)
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
	.align  2
main:
	addiu $sp, $sp, -40
	sw    $ra, 36($sp)
	sw    $fp, 32($sp)
	add   $fp, $sp, $zero
	sw    $a0, 40($sp)
	sw    $a1, 44($sp)
	sw    $a2, 48($sp)
	sw    $a3, 52($sp)
main_body:
	li     $v0, 1
	sw     $v0, 16($fp)
	li     $v0, 1
	sw     $v0, 28($fp)
	li     $v0, 16
	sw     $v0, 24($fp)
	j      L1_1
L2_1:
	li     $v0, 10
	add    $t7, $v0, $zero
	addi   $t8, $fp, 28
	lw     $v0, 28($fp)
	nop
	add    $v1, $t7, $zero
	slt  $v0, $v1, $v0
	beq  $v0, $zero, if_L0
	nop
	j       L3_1
	nop
	j      if_end_L1
if_L0:
if_end_L1:
	addi   $t8, $fp, 16
	lw     $v0, 16($fp)
	nop
	sw     $v0, -4($fp)
	lw     $v0, -4($fp)
	nop
	addi   $v0, $v0, 1
	sw     $v0, 0($t8)
	addi   $v0, $v0, -1
	addi   $t8, $fp, 28
	lw     $v0, 28($fp)
	nop
	sw     $v0, -4($fp)
	lw     $v0, -4($fp)
	nop
	addi   $v0, $v0, 1
	sw     $v0, 0($t8)
	addi   $v0, $v0, -1
L1_1:
	j       L2_1
	nop
L3_1:
	addi   $t8, $fp, 16
	lw     $v0, 16($fp)
	nop
	sw     $v0, 20($fp)
	add   $t9, $v0, $zero
main_end:
	add   $sp, $fp, $zero
	lw    $ra, 36($sp)
	nop
	lw    $fp, 32($sp)
	nop
	addiu $sp, $sp, 40
	jr    $ra
	.align 2
