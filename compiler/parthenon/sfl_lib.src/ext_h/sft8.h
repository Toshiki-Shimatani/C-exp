/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare sft8 {
    input       a<8> ;
    input       b<3> ;
    output      out<8> ;
    instrin     sll ;
    instrin     srl;
    instrin     sra ;
    instr_arg sll(a,b) ;
    instr_arg srl(a,b) ;
    instr_arg sra(a,b) ;
}

circuit sft8 {
    input       a<8> ;
    input       b<3> ;
    output      out<8> ;
    sel_v       work<16> ;
    instrin     sll ;
    instrin     srl;
    instrin     sra ;
    instruct sll out = a << b ;
    instruct srl out = a >> b ;
    instruct sra par {
        work = 16#a >> b ;
        out = work<7:0> ;
    }
}
