/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare alu8 {
    input       a<8> ;
    input       b<8> ;
    output      out<8> ;
    output      ov ;
    output      z ;
    instrin     add ;
    instrin     sub ;
    instrin     and ;
    instrin     or ;
    instrin     xor ;
    instr_arg add(a,b) ;
    instr_arg sub(a,b) ;
    instr_arg and(a,b) ;
    instr_arg or(a,b) ;
    instr_arg xor(a,b) ;
}

circuit alu8 {
    input       a<8> ;
    input       b<8> ;
    output      out<8> ;
    output      ov ;
    output      z ;
    instrin     add ;
    instrin     sub ;
    instrin     and ;
    instrin     or ;
    instrin     xor ;
    instruct add par {
        out  = a + b ;
        ov   = ( (^a<7>) & (^b<7>) & ( out<7>) )
             | ( ( a<7>) & ( b<7>) & (^out<7>) ) ;
    }
    instruct sub par {
        out  = a + (^b) + 0b1 ;
        ov   = ( (^a<7>) & ( b<7>) & ( out<7>) )
             | ( ( a<7>) & (^b<7>) & (^out<7>) ) ;
        z    = ^(/| out<7:0>) ;
    }
    instruct and out = a & b ;
    instruct or out = a | b ;
    instruct xor out = a @ b ;
}
