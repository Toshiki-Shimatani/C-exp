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
	li     $v0, 3
	sw     $v0, 16($fp)
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
