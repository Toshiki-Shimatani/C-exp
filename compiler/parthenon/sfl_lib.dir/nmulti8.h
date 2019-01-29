/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare nmulti8 {
    input       in1<8> ;
    input       in2<8> ;
    output      out<16> ;
    instrin     do ;
    instr_arg do(in1,in2) ;
}
