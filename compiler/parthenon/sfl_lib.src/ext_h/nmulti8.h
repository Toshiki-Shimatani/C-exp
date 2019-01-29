/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare nmulti8 {
    input       in1<8> ;
    input       in2<8> ;
    output      out<16> ;
    instrin     do ;
    instr_arg do(in1,in2) ;
}

circuit nmulti8 {
/*
in1            -+++++++
in2            -+++++++
-----------------------
tmp0  |         +++++++
tmp1  |        +++++++
tmp2  |       +++++++
tmp3  |      +++++++
tmp4  |     +++++++
tmp5  |    +++++++
tmp6  |   +++++++
tmp7  |  -------
tmp8  |  -------
tmp9  | +
*/
    input       in1<8> ;
    input       in2<8> ;
    output      out<16> ;
    sel_v       tmp0<16>, tmp1<16>, tmp2<16>, tmp3<16>, tmp4<16> ;
    sel_v       tmp5<16>, tmp6<16>, tmp7<16>, tmp8<16>, tmp9<16> ;
    instrin     do ;
    instruct do par {
        tmp0 = 0b000000000||(  in1<6:0> & 7 # in2<0> )     ;
        tmp1 = 0b00000000||(  in1<6:0> & 7 # in2<1> )||0b0 ;
        tmp2 = 0b0000000||(  in1<6:0> & 7 # in2<2> )||0b00 ;
        tmp3 = 0b000000||(  in1<6:0> & 7 # in2<3> )||0b000 ;
        tmp4 = 0b00000||(  in1<6:0> & 7 # in2<4> )||0b0000 ;
        tmp5 = 0b0000||(  in1<6:0> & 7 # in2<5> )||0b00000 ;
        tmp6 = 0b000||(  in1<6:0> & 7 # in2<6> )||0b000000 ;
        tmp7 = 0b00||(^(in1<6:0> & 7 # in2<7>))||0b0000000 ;
        tmp8 = 0b00||(^(in2<6:0> & 7 # in1<7>))||0b0000000 ;
        tmp9 = 0b1||(  in1<7> & in2<7> )||0b00000100000000 ;
        out = tmp0 + tmp1 + tmp2 + tmp3 + tmp4 + tmp5 + tmp6 + tmp7 + tmp8 + tmp9;
    }
}
