/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare multi16 {
    input       in1<16> ;
    input       in2<16> ;
    output      out<32> ;
    instrin     do ;
    instr_arg do(in1,in2) ;
}
