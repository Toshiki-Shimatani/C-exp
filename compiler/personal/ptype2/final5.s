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
	addiu $sp, $sp, -88
	sw    $ra, 84($sp)
	sw    $fp, 80($sp)
	add   $fp, $sp, $zero
	sw    $a0, 88($sp)
	sw    $a1, 92($sp)
	sw    $a2, 96($sp)
	sw    $a3, 100($sp)
main_body:
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 0
	li     $t0,8
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo     $v0
	add    $v0, $v1,$v0
	sw     $v0, -4($fp)
	li     $v0, 0
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 1
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 0
	li     $t0,8
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo     $v0
	add    $v0, $v1,$v0
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
	li     $v0, 1
	li     $t0,8
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo     $v0
	add    $v0, $v1,$v0
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
	li     $t0,8
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo     $v0
	add    $v0, $v1,$v0
	sw     $v0, -4($fp)
	li     $v0, 1
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 4
	sw     $v0, 0($t9)
	li     $v0, 32
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 0
	li     $t0,8
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo     $v0
	add    $v0, $v1,$v0
	sw     $v0, -4($fp)
	li     $v0, 0
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 5
	sw     $v0, 0($t9)
	li     $v0, 32
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 0
	li     $t0,8
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo     $v0
	add    $v0, $v1,$v0
	sw     $v0, -4($fp)
	li     $v0, 1
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 6
	sw     $v0, 0($t9)
	li     $v0, 32
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 1
	li     $t0,8
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo     $v0
	add    $v0, $v1,$v0
	sw     $v0, -4($fp)
	li     $v0, 0
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 7
	sw     $v0, 0($t9)
	li     $v0, 32
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 1
	li     $t0,8
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo     $v0
	add    $v0, $v1,$v0
	sw     $v0, -4($fp)
	li     $v0, 1
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 8
	sw     $v0, 0($t9)
	li     $v0, 0
	sw     $v0, 64($fp)
	j      for_L1
for_L0:
	li     $v0, 0
	sw     $v0, 68($fp)
	j      for_L3
for_L2:
	li     $v0, 48
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	addi   $t8, $fp, 64
	lw     $v0, 64($fp)
	nop
	li     $t0,8
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo     $v0
	add    $v0, $v1,$v0
	sw     $v0, -4($fp)
	addi   $t8, $fp, 68
	lw     $v0, 68($fp)
	nop
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 0
	sw     $v0, 0($t9)
	addi   $t8, $fp, 68
	lw     $v0, 68($fp)
	nop
	sw     $v0, -4($fp)
	lw     $v0, -4($fp)
	nop
	addi   $v0, $v0, 1
	sw     $v0, 0($t8)
	addi   $v0, $v0, -1
for_L3:
	li     $v0, 2
	add    $t7, $v0, $zero
	addi   $t8, $fp, 68
	lw     $v0, 68($fp)
	nop
	add    $v1, $t7, $zero
	slt  $v0, $v0, $v1
	bne  $v0, $zero, for_L2
	nop
	addi   $t8, $fp, 64
	lw     $v0, 64($fp)
	nop
	sw     $v0, -4($fp)
	lw     $v0, -4($fp)
	nop
	addi   $v0, $v0, 1
	sw     $v0, 0($t8)
	addi   $v0, $v0, -1
for_L1:
	li     $v0, 2
	add    $t7, $v0, $zero
	addi   $t8, $fp, 64
	lw     $v0, 64($fp)
	nop
	add    $v1, $t7, $zero
	slt  $v0, $v0, $v1
	bne  $v0, $zero, for_L0
	nop
	li     $v0, 0
	sw     $v0, 64($fp)
	j      for_L5
for_L4:
	li     $v0, 0
	sw     $v0, 68($fp)
	j      for_L7
for_L6:
	li     $v0, 0
	sw     $v0, 72($fp)
	j      for_L9
for_L8:
	li     $v0, 48
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	addi   $t8, $fp, 64
	lw     $v0, 64($fp)
	nop
	li     $t0,8
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo     $v0
	add    $v0, $v1,$v0
	sw     $v0, -4($fp)
	addi   $t8, $fp, 68
	lw     $v0, 68($fp)
	nop
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 48
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	addi   $t8, $fp, 64
	lw     $v0, 64($fp)
	nop
	li     $t0,8
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo     $v0
	add    $v0, $v1,$v0
	sw     $v0, -4($fp)
	addi   $t8, $fp, 68
	lw     $v0, 68($fp)
	nop
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, -4($fp)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -8($fp)
	addi   $t8, $fp, 64
	lw     $v0, 64($fp)
	nop
	li     $t0,8
	mult   $v0, $t0
	lw     $v1, -8($fp)
	mflo     $v0
	add    $v0, $v1,$v0
	sw     $v0, -8($fp)
	addi   $t8, $fp, 72
	lw     $v0, 72($fp)
	nop
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -8($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, -8($fp)
	li     $v0, 32
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -12($fp)
	addi   $t8, $fp, 72
	lw     $v0, 72($fp)
	nop
	li     $t0,8
	mult   $v0, $t0
	lw     $v1, -12($fp)
	mflo     $v0
	add    $v0, $v1,$v0
	sw     $v0, -12($fp)
	addi   $t8, $fp, 68
	lw     $v0, 68($fp)
	nop
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -12($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, -12($fp)
	lw     $v1, -12($fp)
	nop
	lw     $v0, -8($fp)
	nop
	mult   $v0, $v1
	mflo   $v0
	sw     $v0, -8($fp)
	lw     $v1, -8($fp)
	nop
	lw     $v0, -4($fp)
	nop
	add    $v0, $v0, $v1
	sw     $v0, 0($t9)
	addi   $t8, $fp, 72
	lw     $v0, 72($fp)
	nop
	sw     $v0, -4($fp)
	lw     $v0, -4($fp)
	nop
	addi   $v0, $v0, 1
	sw     $v0, 0($t8)
	addi   $v0, $v0, -1
for_L9:
	li     $v0, 2
	add    $t7, $v0, $zero
	addi   $t8, $fp, 72
	lw     $v0, 72($fp)
	nop
	add    $v1, $t7, $zero
	slt  $v0, $v0, $v1
	bne  $v0, $zero, for_L8
	nop
	addi   $t8, $fp, 68
	lw     $v0, 68($fp)
	nop
	sw     $v0, -4($fp)
	lw     $v0, -4($fp)
	nop
	addi   $v0, $v0, 1
	sw     $v0, 0($t8)
	addi   $v0, $v0, -1
for_L7:
	li     $v0, 2
	add    $t7, $v0, $zero
	addi   $t8, $fp, 68
	lw     $v0, 68($fp)
	nop
	add    $v1, $t7, $zero
	slt  $v0, $v0, $v1
	bne  $v0, $zero, for_L6
	nop
	addi   $t8, $fp, 64
	lw     $v0, 64($fp)
	nop
	sw     $v0, -4($fp)
	lw     $v0, -4($fp)
	nop
	addi   $v0, $v0, 1
	sw     $v0, 0($t8)
	addi   $v0, $v0, -1
for_L5:
	li     $v0, 2
	add    $t7, $v0, $zero
	addi   $t8, $fp, 64
	lw     $v0, 64($fp)
	nop
	add    $v1, $t7, $zero
	slt  $v0, $v0, $v1
	bne  $v0, $zero, for_L4
	nop
	add   $t9, $v0, $zero
main_end:
	add   $sp, $fp, $zero
	lw    $ra, 84($sp)
	nop
	lw    $fp, 80($sp)
	nop
	addiu $sp, $sp, 88
	jr    $ra
	.align 2
