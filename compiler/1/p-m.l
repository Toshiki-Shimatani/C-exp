%{
#include "p-m.tab.h"
extern int yylval;
%}
%%
[0-9]+ {yylval = atoi(yytext); return NUMBER;}
[\t ]; /* ignore whitespace */
\n return 0;
.  return yytext[0];
%%

/*
flex p-m.l
bison -d p-m.y
gcc p-m.tab.c lex.yy.c -o p-m -lfl -ly
*/