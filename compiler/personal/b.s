	.file	1 "b.c"

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
_arg:
	subu	$sp,$sp,8
	sw	$fp,0($sp)
	move	$fp,$sp
	sw	$a0,8($fp)
	sw	$a1,12($fp)
	sw	$a2,16($fp)
	lw	$v0,8($fp)
	addu	$v0,$v0,8
	lw	$v0,0($v0)
	move	$sp,$fp
	lw	$fp,0($sp)
	addu	$sp,$sp,8
	j	$ra
	.align	2
	.set	nomips16
main:
	subu	$sp,$sp,440
	sw	$ra,436($sp)
	sw	$fp,432($sp)
	move	$fp,$sp
	li	$v0,5			# 0x5
	sw	$v0,424($fp)
	li	$v0,8			# 0x8
	sw	$v0,16($fp)
	li	$v0,2			# 0x2
	sw	$v0,416($fp)
	li	$v0,1			# 0x1
	sw	$v0,420($fp)
	addu	$v0,$fp,416
	addu	$a0,$fp,16
	move	$a1,$v0
	lw	$a2,424($fp)
	jal	_arg
	move	$sp,$fp
	lw	$ra,436($sp)
	lw	$fp,432($sp)
	addu	$sp,$sp,440
	j	$ra
