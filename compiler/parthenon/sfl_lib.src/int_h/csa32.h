/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare csa32 {
    input       in1<32> ;
    input       in2<32> ;
    input       in3<32> ;
    output      out1<32> ;
    output      out2<32> ;
    instrin     do ;
    instr_arg do(in1,in2,in3) ;
}
