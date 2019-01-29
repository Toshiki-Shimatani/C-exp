/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare csa_16 {
    input       in1<16> ;
    input       in2<16> ;
    input       in3<16> ;
    output      out1<16> ;
    output      out2<16> ;
    instrin     do ;
    instr_arg do(in1,in2,in3) ;
}
