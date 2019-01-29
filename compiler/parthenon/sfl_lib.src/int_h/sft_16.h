/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare sft_16 {
    input       left_right ;
    input       sign ;
    input       amt<4> ;
    input       in<16> ;
    output      out<16> ;
    instrin     do ;
    instr_arg do(left_right,sign,amt,in) ;
}
