/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare zero8 {
    input       data<8> ;
    output      zero ;
    instrin     do ;
    instr_arg do(data) ;
}

circuit zero8 {
    input       data<8> ;
    output      zero ;
    instrin     do ;
    instruct do zero = ^(/|data) ;
}
