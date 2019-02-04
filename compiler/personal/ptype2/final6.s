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
quicksort:
	addiu $sp, $sp, -48
	sw    $ra, 44($sp)
	sw    $fp, 40($sp)
	add   $fp, $sp, $zero
	sw    $a0, 48($sp)
	sw    $a1, 52($sp)
	sw    $a2, 56($sp)
	sw    $a3, 60($sp)
quicksort_body:
	addi   $t8, $fp, 52
	lw     $v0, 52($fp)
	nop
	add    $t7, $v0, $zero
	addi   $t8, $fp, 56
	lw     $v0, 56($fp)
	nop
	add    $v1, $t7, $zero
	slt  $v0, $v1, $v0
	beq  $v0, $zero, if_L0
	nop
	li     $v0, 48
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, 28($fp)
	addi   $t8, $fp, 52
	lw     $v0, 52($fp)
	nop
	sw     $v0, -8($fp)
	li     $v0, 1
	sw     $v0, -12($fp)
	lw     $v1, -12($fp)
	nop
	lw     $v0, -8($fp)
	nop
	sub    $v0, $v0, $v1
	sw     $v0, 24($fp)
	addi   $t8, $fp, 56
	lw     $v0, 56($fp)
	nop
	sw     $v0, 20($fp)
	j      for_L1
for_L0:
	j      while_L2_0
while_L1_0:
while_L2_0:
	addi   $t8, $fp, 28
	lw     $v0, 28($fp)
	nop
	add    $t7, $v0, $zero
	li     $v0, 48
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -8($fp)
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	add    $v1, $t7, $zero
	slt  $v0, $v0, $v1
	bne  $v0, $zero, while_L1_0
	nop
	j      while_L2_1
while_L1_1:
while_L2_1:
	addi   $t8, $fp, 28
	lw     $v0, 28($fp)
	nop
	add    $t7, $v0, $zero
	li     $v0, 48
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -12($fp)
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	add    $v1, $t7, $zero
	slt  $v0, $v1, $v0
	bne  $v0, $zero, while_L1_1
	nop
	addi   $t8, $fp, 20
	lw     $v0, 20($fp)
	nop
	add    $t7, $v0, $zero
	addi   $t8, $fp, 24
	lw     $v0, 24($fp)
	nop
	add    $v1, $t7, $zero
	slt  $v0, $v0, $v1
	bne  $v0, $zero, if_L1
	nop
	j      if_end_L2
if_L1:
if_end_L2:
	li     $v0, 48
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -16($fp)
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, 16($fp)
	li     $v0, 48
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -20($fp)
	add    $t9,$zero,$v0
	li     $v0, 48
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -24($fp)
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, 0($t9)
	li     $v0, 48
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -28($fp)
	add    $t9,$zero,$v0
	addi   $t8, $fp, 16
	lw     $v0, 16($fp)
	nop
	sw     $v0, 0($t9)
for_L1:
	li     $v0, 48
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -32($fp)
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, 16($fp)
	li     $v0, 48
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -36($fp)
	add    $t9,$zero,$v0
	li     $v0, 48
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -40($fp)
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, 0($t9)
	li     $v0, 48
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -44($fp)
	add    $t9,$zero,$v0
	addi   $t8, $fp, 16
	lw     $v0, 16($fp)
	nop
	sw     $v0, 0($t9)
	j      if_end_L1
if_L0:
if_end_L2:
	add   $t9, $v0, $zero
quicksort_end:
	add   $sp, $fp, $zero
	lw    $ra, 44($sp)
	nop
	lw    $fp, 40($sp)
	nop
	addiu $sp, $sp, 48
	jr    $ra
	.align 2
main:
	addiu $sp, $sp, -64
	sw    $ra, 60($sp)
	sw    $fp, 56($sp)
	add   $fp, $sp, $zero
	sw    $a0, 64($sp)
	sw    $a1, 68($sp)
	sw    $a2, 72($sp)
	sw    $a3, 76($sp)
main_body:
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -48($fp)
	li     $v0, 0
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -48($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 10
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -48($fp)
	li     $v0, 1
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -48($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 4
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -48($fp)
	li     $v0, 2
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -48($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 2
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -48($fp)
	li     $v0, 3
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -48($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 7
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -48($fp)
	li     $v0, 4
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -48($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 3
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -48($fp)
	li     $v0, 5
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -48($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 5
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -48($fp)
	li     $v0, 6
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -48($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 9
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -48($fp)
	li     $v0, 7
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -48($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 10
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -48($fp)
	li     $v0, 8
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -48($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 1
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -48($fp)
	li     $v0, 9
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -48($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 8
	sw     $v0, 0($t9)
	add   $t9, $v0, $zero
main_end:
	add   $sp, $fp, $zero
	lw    $ra, 60($sp)
	nop
	lw    $fp, 56($sp)
	nop
	addiu $sp, $sp, 64
	jr    $ra
	.align 2
