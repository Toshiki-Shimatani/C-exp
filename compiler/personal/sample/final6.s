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
	addi    $v0, $fp, 48
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	addi   $t8, $fp, 56
	lw     $v0, 56($fp)
	nop
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, 28($fp)
	addi   $t8, $fp, 52
	lw     $v0, 52($fp)
	nop
	sw     $v0, -4($fp)
	li     $v0, 1
	sw     $v0, -8($fp)
	lw     $v1, -8($fp)
	nop
	lw     $v0, -4($fp)
	nop
	sub    $v0, $v0, $v1
	sw     $v0, 24($fp)
	addi   $t8, $fp, 56
	lw     $v0, 56($fp)
	nop
	sw     $v0, 20($fp)
	j      L1_1
L2_1:
	j      L2_2
L1_2:
L2_2:
	addi   $t8, $fp, 28
	lw     $v0, 28($fp)
	nop
	add    $t7, $v0, $zero
	addi    $v0, $fp, 48
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	addi   $t8, $fp, 24
	lw     $v0, 24($fp)
	nop
	sw     $v0, -8($fp)
	lw     $v0, -8($fp)
	nop
	addi   $v0, $v0, 1
	sw     $v0, 0($t8)
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	add    $v1, $t7, $zero
	slt  $v0, $v0, $v1
	bne  $v0, $zero, L1_2
	nop
L3_2:
	j      L2_3
L1_3:
L2_3:
	addi   $t8, $fp, 28
	lw     $v0, 28($fp)
	nop
	add    $t7, $v0, $zero
	addi    $v0, $fp, 48
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	addi   $t8, $fp, 20
	lw     $v0, 20($fp)
	nop
	sw     $v0, -8($fp)
	lw     $v0, -8($fp)
	nop
	addi   $v0, $v0, -1
	sw     $v0, 0($t8)
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	add    $v1, $t7, $zero
	slt  $v0, $v1, $v0
	bne  $v0, $zero, L1_3
	nop
L3_3:
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
	j       L3_1
	nop
	j      if_end_L2
if_L1:
if_end_L2:
	addi    $v0, $fp, 48
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	addi   $t8, $fp, 24
	lw     $v0, 24($fp)
	nop
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, 16($fp)
	addi    $v0, $fp, 48
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	addi   $t8, $fp, 24
	lw     $v0, 24($fp)
	nop
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	addi    $v0, $fp, 48
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	addi   $t8, $fp, 20
	lw     $v0, 20($fp)
	nop
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, 0($t9)
	addi    $v0, $fp, 48
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	addi   $t8, $fp, 20
	lw     $v0, 20($fp)
	nop
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	addi   $t8, $fp, 16
	lw     $v0, 16($fp)
	nop
	sw     $v0, 0($t9)
L1_1:
	j       L2_1
	nop
L3_1:
	addi    $v0, $fp, 48
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	addi   $t8, $fp, 24
	lw     $v0, 24($fp)
	nop
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, 16($fp)
	addi    $v0, $fp, 48
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	addi   $t8, $fp, 24
	lw     $v0, 24($fp)
	nop
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	addi    $v0, $fp, 48
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	addi   $t8, $fp, 56
	lw     $v0, 56($fp)
	nop
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add   $t8, $zero, $v0
	lw     $v0, 0($v0)
	nop
	sw     $v0, 0($t9)
	addi    $v0, $fp, 48
	lw     $v0, 0($v0)
	sw     $v0, -4($fp)
	addi   $t8, $fp, 56
	lw     $v0, 56($fp)
	nop
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	addi   $t8, $fp, 16
	lw     $v0, 16($fp)
	nop
	sw     $v0, 0($t9)
	addi   $t8, $fp, 48
	lw     $v0, 48($fp)
	nop
	add     $a0, $zero, $v0
	add     $t9, $zero, $v0
	addi   $t8, $fp, 52
	lw     $v0, 52($fp)
	nop
	add      $a1, $zero, $v0
	addi   $t8, $fp, 24
	lw     $v0, 24($fp)
	nop
	sw     $v0, -4($fp)
	li     $v0, 1
	sw     $v0, -8($fp)
	lw     $v1, -8($fp)
	nop
	lw     $v0, -4($fp)
	nop
	sub    $v0, $v0, $v1
	add      $a2, $zero, $v0
	jal     quicksort
	nop
	addi   $t8, $fp, 48
	lw     $v0, 48($fp)
	nop
	add     $a0, $zero, $v0
	add     $t9, $zero, $v0
	addi   $t8, $fp, 24
	lw     $v0, 24($fp)
	nop
	sw     $v0, -4($fp)
	li     $v0, 1
	sw     $v0, -8($fp)
	lw     $v1, -8($fp)
	nop
	lw     $v0, -4($fp)
	nop
	add    $v0, $v0, $v1
	add      $a1, $zero, $v0
	addi   $t8, $fp, 56
	lw     $v0, 56($fp)
	nop
	add      $a2, $zero, $v0
	jal     quicksort
	nop
	j      if_end_L1
if_L0:
if_end_L1:
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
	sw     $v0, -4($fp)
	li     $v0, 0
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 10
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
	li     $v0, 4
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
	li     $v0, 2
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 3
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 7
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 4
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
	li     $v0, 5
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 5
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 6
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 9
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 7
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 10
	sw     $v0, 0($t9)
	li     $v0, 16
	add    $v1, $zero, $fp
	add    $v0, $v0, $v1
	sw     $v0, -4($fp)
	li     $v0, 8
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
	li     $v0, 9
	li     $t0, 4
	mult   $v0, $t0
	lw     $v1, -4($fp)
	mflo   $v0
	add    $v0, $v1,$v0
	add    $t9,$zero,$v0
	li     $v0, 8
	sw     $v0, 0($t9)
	addi   $t8, $fp, 16
	lw     $v0, 16($fp)
	nop
	add     $a0, $zero, $t8
	li     $v0, 0
	add      $a1, $zero, $v0
	li     $v0, 9
	add      $a2, $zero, $v0
	jal     quicksort
	nop
main_end:
	add   $sp, $fp, $zero
	lw    $ra, 60($sp)
	nop
	lw    $fp, 56($sp)
	nop
	addiu $sp, $sp, 64
	jr    $ra
	.align 2
