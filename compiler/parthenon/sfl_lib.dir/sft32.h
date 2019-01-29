/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare sft32 {
    input       a<32> ;
    input       b<5> ;
    output      out<32> ;
    instrin     sll ;
    instrin     srl;
    instrin     sra ;
    instr_arg sll(a,b) ;
    instr_arg srl(a,b) ;
    instr_arg sra(a,b) ;
}
