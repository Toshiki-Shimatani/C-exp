%{
#include "arithv.tab.h"
#include <math.h>
extern int vbltable[26];
%}
%%
[0-9]+   {yylval.dval = atoi(yytext) ; return NUMBER; }
[\t ] ; /* ignore whitespace */
[a-z]  {yylval.vblno = yytext[0] - 'a'; return NAME; }
"$"   {return 0; /* end of input */}
\n       |
.  return yytext[0];
%%