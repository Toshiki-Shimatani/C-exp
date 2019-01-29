/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare cmp8 {
    input       in1<8> ;
    input       in2<8> ;
    output      same ;
    instrin     do ;
    instr_arg do(in1,in2) ;
}

circuit cmp8 {
    input       in1<8> ;
    input       in2<8> ;
    output      same ;
    instrin     do ;
    instruct do same = ^(/|(in1 @ in2)) ;
}
