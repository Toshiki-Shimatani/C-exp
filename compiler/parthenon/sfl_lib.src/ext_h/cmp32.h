/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare cmp32 {
    input       in1<32> ;
    input       in2<32> ;
    output      same ;
    instrin     do ;
    instr_arg do(in1,in2) ;
}

circuit cmp32 {
    input       in1<32> ;
    input       in2<32> ;
    output      same ;
    instrin     do ;
    instruct do same = ^(/|(in1 @ in2)) ;
}
