/******************************************
* (C)Copyright by N.T.T 1993(unpublished) *
* All rights are reserved.                *
******************************************/
declare r256_8 {
    input       adrs<8> ;
    input       din<8> ;
    output      dout<8> ;
    instrin     read ;
    instrin     write ;
    instr_arg   read(adrs) ;
    instr_arg   write(adrs,din) ;
}
