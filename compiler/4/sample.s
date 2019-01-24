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
main_init:
	addiu $sp, $sp, -32
	sw    $ra, 8($sp)
	sw    $fp, 12($sp)
	sw    $a0, 16($sp)
	sw    $a1, 20($sp)
	sw    $a2, 24($sp)
	sw    $a3, 28($sp)
	add $fp, $sp, $zero
main_body:
	addi $t0, $zero, 1
	sw   $t0, -4($sp)  /* push */
	lw  $t0, -4($sp)
	nop
	la $t7, ans
	sw  $t0, 0($t7)
	la $t7, ans
	lw  $t1, 0($t7)
	nop
	la $t7, ans
	lw  $t0, 0($t7)
	nop
	add  $t2, $t0, $t1
	sw   $t2, -4($sp)  /* push */
	lw  $t0, -4($sp)
	nop
	la $t7, ans
	sw  $t0, 0($t7)
main_end:
	lw    $ra, 8($sp)
	nop
	lw    $fp, 12($sp)
	nop
	addiu $sp, $sp, 32
	jr $ra
	# data segment (global variables)
	.data
ans:	.word  0
