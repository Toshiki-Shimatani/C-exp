/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare cla16 {
    input       cin ;
    input       in1<16> ;
    input       in2<16> ;
    output      out<16> ;
    output      gout ;
    output      pout ;
    instrin     do ;
    instr_arg do(cin,in1,in2) ;
}
