%{
#include "arith.tab.h"
extern int yylval;
%}
%%
[0-9]+ {yylval = atoi(yytext); return NUMBER;}
[\t ]; /* ignore whitespace */
\n return 0;
.  return yytext[0];
%%

/*
flex arith.l
bison -d arith.y
gcc arith.tab.c lex.yy.c -o arith -lfl -ly
*/