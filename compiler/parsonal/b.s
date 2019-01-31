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
main:
	subu	$sp,$sp,32
	sw	$fp,24($sp)
	move	$fp,$sp
	li	$v0,1			# 0x1
	sw	$v0,0($fp)
	li	$v0,2			# 0x2
	sw	$v0,4($fp)
	li	$v0,3			# 0x3
	sw	$v0,8($fp)
	li	$v0,4			# 0x4
	sw	$v0,12($fp)
	li	$v0,5			# 0x5
	sw	$v0,16($fp)
	li	$v0,6			# 0x6
	sw	$v0,20($fp)
	move	$sp,$fp
	lw	$fp,24($sp)
	addu	$sp,$sp,32
	j	$ra
