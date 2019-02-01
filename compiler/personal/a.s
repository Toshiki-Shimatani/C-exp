	.file	1 "a.c"

 # -G value = 0, Cpu = r2000, ISA = 1
 # GNU C version 2.96-mips3264-000710 (mipsel-linux) compiled by GNU C version 2.96 20000731 (Red Hat Linux 7.2 2.96-112.7.2).
 # [AL 1.1, MM 40] BSD Mips
 # options passed:  -mno-abicalls -mrnames -mmips-as
 # -mno-check-zero-division -mcpu=r2000 -O0 -fleading-underscore
 # -finhibit-size-directive -fverbose-asm
 # options enabled:  -fpeephole -fkeep-static-consts -fpcc-struct-return
 # -fsched-interblock -fsched-spec -fnew-exceptions -fcommon
 # -finhibit-size-directive -fverbose-asm -fgnu-linker -flive-range-gdb
 # -fargument-alias -fleading-underscore -fdelay-postincrement -fident
 # -fmath-errno -msplit-addresses -mrnames -mno-check-zero-division
 # -mdebugf -mdebugi -mno-div-checks -mcpu=r2000


	.text
	.align	2
	.set	nomips16
main:
	subu	$sp,$sp,128
	sw	$ra,124($sp)
	sw	$fp,120($sp)
	move	$fp,$sp
	sw	$a0,128($fp)
	sw	$a1,132($fp)
	lw	$v0,128($fp)
	sw	$v0,40($fp)
	li	$v0,2			# 0x2
	sw	$v0,44($fp)
	li	$v0,3			# 0x3
	sw	$v0,48($fp)
	li	$v0,4			# 0x4
	sw	$v0,52($fp)
	li	$v0,5			# 0x5
	sw	$v0,56($fp)
	li	$v0,6			# 0x6
	sw	$v0,60($fp)
	sw	$zero,80($fp)
	li	$v0,5			# 0x5
	sw	$v0,84($fp)
	li	$v0,10			# 0xa
	sw	$v0,88($fp)
	li	$v0,100			# 0x64
	sw	$v0,96($fp)
	sw	$zero,104($fp)
	lw	$v0,40($fp)
	sw	$v0,16($sp)
	lw	$v0,40($fp)
	sw	$v0,20($sp)
	lw	$a0,40($fp)
	lw	$a1,40($fp)
	lw	$a2,40($fp)
	lw	$a3,40($fp)
	jal	_func
	lw	$v0,60($fp)
	sw	$v0,16($sp)
	lw	$v0,56($fp)
	sw	$v0,20($sp)
	lw	$a0,40($fp)
	lw	$a1,44($fp)
	lw	$a2,48($fp)
	lw	$a3,52($fp)
	jal	_func
	sw	$v0,64($fp)
	lw	$v0,40($fp)
	sw	$v0,16($sp)
	lw	$v0,40($fp)
	sw	$v0,20($sp)
	lw	$v0,40($fp)
	sw	$v0,24($sp)
	lw	$v0,40($fp)
	sw	$v0,28($sp)
	lw	$v0,40($fp)
	sw	$v0,32($sp)
	lw	$a0,40($fp)
	lw	$a1,40($fp)
	lw	$a2,40($fp)
	lw	$a3,40($fp)
	jal	_func2
	move	$v0,$zero
	move	$sp,$fp
	lw	$ra,124($sp)
	lw	$fp,120($sp)
	addu	$sp,$sp,128
	j	$ra
	.align	2
	.set	nomips16
_func:
	subu	$sp,$sp,16
	sw	$fp,8($sp)
	move	$fp,$sp
	sw	$a0,16($fp)
	sw	$a1,20($fp)
	sw	$a2,24($fp)
	sw	$a3,28($fp)
	lw	$v1,16($fp)
	lw	$v0,20($fp)
	addu	$v1,$v1,$v0
	lw	$v0,24($fp)
	addu	$v1,$v1,$v0
	lw	$v0,28($fp)
	addu	$v1,$v1,$v0
	lw	$v0,32($fp)
	addu	$v1,$v1,$v0
	lw	$v0,36($fp)
	addu	$v0,$v1,$v0
	sw	$v0,0($fp)
	lw	$v0,0($fp)
	move	$sp,$fp
	lw	$fp,8($sp)
	addu	$sp,$sp,16
	j	$ra
	.align	2
	.set	nomips16
_func2:
	subu	$sp,$sp,8
	sw	$fp,0($sp)
	move	$fp,$sp
	sw	$a0,8($fp)
	sw	$a1,12($fp)
	sw	$a2,16($fp)
	sw	$a3,20($fp)
	move	$v0,$zero
	move	$sp,$fp
	lw	$fp,0($sp)
	addu	$sp,$sp,8
	j	$ra

