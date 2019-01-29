/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare dec16 {
    input       in<16> ;
    output      out<16> ;
    instrin     do ;
    instr_arg do(in) ;
}

circuit dec16 {
    input       in<16> ;
    output      out<16> ;
    instrin     do ;
    instruct do out = in + 0xffff ;
}
