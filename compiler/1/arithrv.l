%{
#include "arithrv.tab.h"
#include <math.h>
extern int vbltable[26];
%}
%%
([0-9]+)|([0-9]*\.[0-9]+) {yylval.dval = atof(yytext); return NUMBER;}
[\t ]+ ; /* ignore whitespace */
[a-z] {yylval.vblno = yytext[0] - 'a'; return NAME;}
"$"   {return 0; /* end of input */}
\n  |
.  return yytext[0];
%%

/*
flex arithrv.l
bison -d arithrv.y
gcc arithrv.tab.c lex.yy.c -o arithrv -lfl -ly

#define YYSTYPE double
*/