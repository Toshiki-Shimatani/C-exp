/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare cla32 {
    input       cin ;
    input       in1<32> ;
    input       in2<32> ;
    output      out<32> ;
    output      gout ;
    output      pout ;
    instrin     do ;
    instr_arg do(cin,in1,in2) ;
}
