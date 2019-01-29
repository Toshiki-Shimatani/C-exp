/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare alu32 {
    input       a<32> ;
    input       b<32> ;
    output      out<32> ;
    output      ov ;
    output      z ;
    instrin     add ;
    instrin     sub ;
    instrin     and ;
    instrin     or ;
    instrin     xor ;
    instr_arg add(a,b) ;
    instr_arg sub(a,b) ;
    instr_arg and(a,b) ;
    instr_arg or(a,b) ;
    instr_arg xor(a,b) ;
}
