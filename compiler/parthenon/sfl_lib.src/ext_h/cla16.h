/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare cla16 {
    input       cin ;
    input       in1<16> ;
    input       in2<16> ;
    output      out<16> ;
    instrin     do ;
    instr_arg do(cin,in1,in2) ;
}

circuit cla16 {
    input       cin ;
    input       in1<16> ;
    input       in2<16> ;
    output      out<16> ;
    instrin     do ;
    instruct do out = cin + in1 + in2 ;
}
