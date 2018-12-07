%{
#include<stdio.h>
#include<stdlib.h>
#include"basis.tab.h"
  extern int yylex();
  extern int yyerror();
  %}
%union {
  double dval;
  int vblno;
}
%token <vblno> NAME
%token <dval> NUMBER
%type <dval> expression mulexp primary
%%
program : val_dec sentence_set '\n'
;

val_dec : dec val_dec
| dec
;
    
dec : {define ident;}
;

sentence_set : sentence sentence_set 
| sentence
;

sentence : assign
| loop
| branch
;

assign : ident '=' arith;

arith : arith add_sub item 
| item
;

item : item mul_dev fact
| fact
;

fact : val
| '(' arith ')'
;

add_sub : '+' 
| '-'
;

mul_dev : '*' 
| '/'
;

val : ident 
|  number
;

loop : while '(' branch ')' '{' sentence_set '}'
;

branch





%%
int main(void)
{
  if(yyparse()){
    fprintf(stderr,"Error\n");
    return 1;
  }
  return 0;
}
