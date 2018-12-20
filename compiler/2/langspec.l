%{
#include "langspec.tab.h"
%}
%%
"define"    { return DEFINE; }
"array"     { return ARRAY; }
"func"      { return FUNC; }
"funccall"  { return FUNCCALL; }
"while"     { return WHILE; }
"for"       { return FOR; }
"if"        { return IF; }
"else"      { return ELSE; }
"break"     { return BREAK; }
"("         { return PAREN_L; }
")"         { return PAREN_R; }
"["         { return BRACKET_L; }
"]"         { return BRACKET_R; }
"{"         { return BRACE_L; }
"}"         { return BRACE_R; }
"+"         { return ADDITION; }
"-"         { return SUBTRACTION; }
"*"         { return MULTIPLICATION; }
"/"         { return DIVISION; }
"%"         { return MODULUS; }
"++"        { return INCREMENT; }
"--"        { return DECREMENT; }
"=="        { return EQUAL; }
"<"         { return LESS; }
">"         { return GRATER; }
">="        { return GREQ; }
"<="        { return LSEQ; }
"="         { return ASSIGNMENT; }
";"         { return SEMIC; }
","         { return COMMA; }
[a-zA-Z][a-zA-Z0-9]*    { return IDENTIFIER; }
[0-9]+                  { return NUMBER; }
[ \t\n] ;
.           {}
%%

