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
	addiu $sp, $sp, -32
	sw    $ra, 28($sp)
	sw    $fp, 24($sp)
	add   $fp, $sp, $zero
	sw    $a0, 32($sp)
	sw    $a1, 36($sp)
	sw    $a2, 40($sp)
	sw    $a3, 44($sp)
main_body:
	li     $v0, 1
	sw     $v0, 20($fp)
	li     $v0, 1
	sw     $v0, 16($fp)
	j      while_L2_0
while_L1_0:
	addi   $t8, $fp, 20
	lw     $v0, 20($fp)
	nop
	sw     $v0, -4($fp)
	addi   $t8, $fp, 16
	lw     $v0, 16($fp)
	nop
	sw     $v0, -8($fp)
	lw     $v1, -8($fp)
	nop
	lw     $v0, -4($fp)
	nop
	mult   $v0, $v1
	mflo   $v0
	sw     $v0, 20($fp)
	addi   $t8, $fp, 16
	lw     $v0, 16($fp)
	nop
	sw     $v0, -4($fp)
	li     $v0, 1
	sw     $v0, -8($fp)
	lw     $v1, -8($fp)
	nop
	lw     $v0, -4($fp)
	nop
	add    $v0, $v0, $v1
	sw     $v0, 16($fp)
while_L2_0:
	li     $v0, 6
	add    $v1, $v0, $zero
	addi   $t8, $fp, 16
	lw     $v0, 16($fp)
	nop
	slt  $v0, $v0, $v1
	bne  $v0, $zero, while_L1_0
	nop
	add   $t9, $v0, $zero
main_end:
	add   $sp, $fp, $zero
	lw    $ra, 28($sp)
	nop
	lw    $fp, 24($sp)
	nop
	addiu $sp, $sp, 32
	jr    $ra
	.align 2
