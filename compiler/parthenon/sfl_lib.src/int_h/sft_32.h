/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare sft_32 {
    input       left_right ;
    input       sign ;
    input       amt<5> ;
    input       in<32> ;
    output      out<32> ;
    instrin     do ;
    instr_arg do(left_right,sign,amt,in) ;
}
