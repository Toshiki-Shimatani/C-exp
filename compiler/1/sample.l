%{
#include "sample.tab.h"
/* lex for sample.y */
%}
%%
I {return SUBJECT;}
am {return PRED;}
[ \t]+ {return SPACE;}
\n  return 0;
.  return yytext[0];
%%
/*
flex sample.l
bison -d sample.y
gcc sample.tab.c lex.yy.c -o sample -lfl -ly
*/