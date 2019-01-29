/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare sft16 {
    input       a<16> ;
    input       b<4> ;
    output      out<16> ;
    instrin     sll ;
    instrin     srl;
    instrin     sra ;
    instr_arg sll(a,b) ;
    instr_arg srl(a,b) ;
    instr_arg sra(a,b) ;
}

circuit sft16 {
    input       a<16> ;
    input       b<4> ;
    output      out<16> ;
    sel_v       work<32> ;
    instrin     sll ;
    instrin     srl;
    instrin     sra ;
    instruct sll out = a << b ;
    instruct srl out = a >> b ;
    instruct sra par {
        work = 32#a >> b ;
        out = work<15:0> ;
    }
}
