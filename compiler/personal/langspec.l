%{
#include "ast.h"
#include "langspec.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern Symbols *global_stable;
extern Symbols *stable;
%}
%%
"define"    { return DEFINE; }
"array"     { return ARRAY; }
"func"      {
    stable = sym_add(NULL, "local", SYM_KEYWORD, 0, 0);
    return FUNC;
}
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
[a-zA-Z][a-zA-Z0-9]*    {
    char *name = (char*)malloc(strlen(yytext)+1);
    strcpy(name, yytext);
    yylval.name = name;
    return IDENTIFIER;
}
[0-9]+                  {
                          yylval.np = make_num_node(atoi(yytext));
                          return NUMBER;
                        }
[ \t\n] ;
.           {}
%%

