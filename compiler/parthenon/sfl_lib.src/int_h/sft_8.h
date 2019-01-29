/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare sft_8 {
    input       left_right ;
    input       sign ;
    input       amt<3> ;
    input       in<8> ;
    output      out<8> ;
    instrin     do ;
    instr_arg do(left_right,sign,amt,in) ;
}
