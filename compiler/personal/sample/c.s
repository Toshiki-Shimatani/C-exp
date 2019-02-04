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
tmp:
	addiu $sp, $sp, -32
	sw    $ra, 28($sp)
	sw    $fp, 24($sp)
	add   $fp, $sp, $zero
	sw    $a0, 32($sp)
	sw    $a1, 36($sp)
	sw    $a2, 40($sp)
	sw    $a3, 44($sp)
tmp_body:
	addi    $v0, $fp, 36
	lw     $v0, 0($v0)
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	li     $v0, 0
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	addi    $v0, $fp, 32
	lw     $v0, 0($v0)
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	li     $v0, 0
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, 0($t9)
	addi    $v0, $fp, 36
	lw     $v0, 0($v0)
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	li     $v0, 1
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	addi    $v0, $fp, 32
	lw     $v0, 0($v0)
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	li     $v0, 1
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, 0($t9)
	addi    $v0, $fp, 36
	lw     $v0, 0($v0)
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	li     $v0, 0
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, -4($fp)
	addi    $v0, $fp, 36
	lw     $v0, 0($v0)
	lw     $v0, 0($v0)
	sw     $v0, -8($fp)
	li     $v0, 1
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -8($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, -8($fp)
	lw     $v1, -8($fp)
	nop
	lw     $v0, -4($fp)
	nop
	add    $v0, $v0, $v1
	sw     $v0, 16($fp)
	add   $t9, $v0, $zero
tmp_end:
	add   $sp, $fp, $zero
	lw    $ra, 28($sp)
	nop
	lw    $fp, 24($sp)
	nop
	addiu $sp, $sp, 32
	jr    $ra
	.align 2
main:
	addiu $sp, $sp, -48
	sw    $ra, 44($sp)
	sw    $fp, 40($sp)
	add   $fp, $sp, $zero
	sw    $a0, 48($sp)
	sw    $a1, 52($sp)
	sw    $a2, 56($sp)
	sw    $a3, 60($sp)
main_body:
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 0
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 3
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 1
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 2
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 2
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 1
	sw     $v0, 0($t9)
	li     $v0, 28
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 0
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 0
	sw     $v0, 0($t9)
	li     $v0, 28
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 1
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 0
	sw     $v0, 0($t9)
	addi   $t8, $fp, 16
	lw     $v0, 16($fp)
	nop
	add     $a0, $zero, $t8
	addi   $t8, $fp, 28
	lw     $v0, 28($fp)
	nop
	add     $a1, $zero, $t8
	jal     tmp
	add   $t9, $v0, $zero
main_end:
	add   $sp, $fp, $zero
	lw    $ra, 44($sp)
	nop
	lw    $fp, 40($sp)
	nop
	addiu $sp, $sp, 48
	jr    $ra
	.align 2
