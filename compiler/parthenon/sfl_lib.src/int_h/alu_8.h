/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare alu_8 {
    input       enb_cry ;
    input       inv_in2 ;
    input       and ;
    input       or ;
    input       eor ;
    input       cin ;
    input       in1<8> ;
    input       in2<8> ;
    output      out<8> ;
    output      gout ;
    output      pout ;
    output      ovf ;
    output      eq ;
    instrin     do ;
    instr_arg do(enb_cry,inv_in2,and,or,eor,cin,in1,in2) ;
}
