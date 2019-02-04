%{
#include <stdio.h>
#include "ast.h"
#include "langspec.tab.h"

extern int yylex();
extern int yyerror();
Node *top = NULL;
Symbols *global_stable = NULL;
Symbols *stable = NULL;

%}

%union{
  Node *np;
  char *name;
  Ntype op;
}

%token DEFINE ARRAY
%token<name> IDENTIFIER
%token<np> NUMBER
%token FUNC FUNCCALL
%token WHILE IF ELSE BREAK FOR
%token PAREN_L PAREN_R BRACKET_L BRACKET_R BRACE_L BRACE_R
%token ADDITION SUBTRACTION MULTIPLICATION DIVISION MODULUS
%token EQUAL LESS GRATER GREQ LSEQ
%token DECREMENT INCREMENT
%token ASSIGNMENT
%token SEMIC COMMA

%type<np> program function_list function pre_func argument_list argument
%type<np> variable_declarations declaration identifier_list
%type<np> statement_list statement assignment_statement
%type<np> arithmetic_expression multiplicative_expression primary_expression
%type<op> additive_operator multiplicative_operator unary_operator comparison_operator
%type<np> variable array_reference
%type<np> loop_statement for_initial for_expression for_update
%type<np> selection_statement if_statement else_statement break_statement
%type<np> expression
%type<np> function_call parameter_list
%%
program : variable_declarations function_list           {top=make_nchild_node(AST_PROGRAM, $1, $2);}
| function_list {top=make_nchild_node(AST_PROGRAM, $1, NULL);}
;
function_list : function function_list {$$=make_nchild_node(AST_FUNC_LIST, $1, $2);}
              | function {$$=make_nchild_node(AST_FUNC_LIST, $1, NULL);}
;
function : pre_func PAREN_L argument_list PAREN_R BRACE_L variable_declarations statement_list BRACE_R{
  Node *nfun;
  
  nfun = make_nchild_node(AST_FUNC, $1, $3, $6, $7);
  $$ = nfun;
}
|pre_func PAREN_L PAREN_R BRACE_L variable_declarations statement_list BRACE_R {
  Node *nfun;
  
  nfun = make_nchild_node(AST_FUNC, $1, NULL, $5, $6);
  $$ = nfun;
}
;
pre_func : FUNC IDENTIFIER{
  Node *nid;
  Symbols *stmp;
  char errmsg[1024];

  if(sym_lookup(global_stable, $2) == -1){
    stmp = sym_add(global_stable, $2, SYM_FUNC,0,0);
    stmp->branch = stable;
    nid = make_ident_node(SYM_FUNC, stmp->symno, NULL);
    $$ = nid;
  } else {
    sprintf(errmsg, "undefined id %s", $2);
    yyerror(errmsg);
  }
}
;
argument_list : argument COMMA argument_list {$$=make_nchild_node(AST_ARG_LIST, $1, $3);}
              | argument {$$=make_nchild_node(AST_ARG_LIST, $1, NULL);}
;
argument : DEFINE IDENTIFIER {
  Symbols *stmp;
  Node *nid;
  char errmsg[1024];

  if(sym_lookup(stable, $2) == -1){
    stmp = sym_add(stable, $2, SYM_ARG_VAR, 0, 0);
    nid = make_ident_node(SYM_ARG_VAR, stmp->symno, NULL);
    $$ = make_nchild_node(AST_ARG, nid, NULL);
    $$->value = 0;
  } else {
    sprintf(errmsg, "undefined id %s", $2);
    yyerror(errmsg);
  }
}
| ARRAY IDENTIFIER BRACKET_L BRACKET_R {
  Symbols *stmp;
  Node *nid;
  char errmsg[1024];

  if(sym_lookup(stable, $2) == -1){
    stmp = sym_add(stable, $2, SYM_ARG_VAR, 0, 0);
    nid = make_ident_node(SYM_ARG_VAR, stmp->symno, NULL);
    $$ = make_nchild_node(AST_ARG, nid, NULL);
    $$->value = 1;
  } else {
    sprintf(errmsg, "undefined id %s", $2);
    yyerror(errmsg);
  }
 }
| ARRAY IDENTIFIER BRACKET_L NUMBER BRACKET_R BRACKET_L BRACKET_R {
  Symbols *stmp;
  Node *nid;
  char errmsg[1024];
  
  if(sym_lookup(stable, $2) == -1){
    stmp = sym_add(stable, $2, SYM_ARG_VAR, 0, 0);
    nid = make_ident_node(SYM_ARG_VAR, stmp->symno, NULL);
    $$ = make_nchild_node(AST_ARG, nid, $4);
    $$->value = 2;
  } else {
    sprintf(errmsg, "undefined id %s", $2);
    yyerror(errmsg);
  }
}
;
variable_declarations : declaration variable_declarations    {
  Node *ntmp = $1;
  while(ntmp->child[1] != NULL) ntmp = ntmp->child[1];
  ntmp->child[1] = $2;
  $$ = $1;
}
                      | declaration                          {$$=$1;}
;
declaration : DEFINE identifier_list SEMIC             {$$ = $2;}
| ARRAY IDENTIFIER BRACKET_L NUMBER BRACKET_R SEMIC    {
  Node *ntmp = make_new_ident_node(stable, SYM_VAR, $2, $4, NULL);
  char errmsg[1024];

  if(ntmp != NULL){
    $$ = ntmp;
  } else {
    sprintf(errmsg, "used id %s", $2);
    yyerror(errmsg);
  }
}
| ARRAY IDENTIFIER BRACKET_L NUMBER BRACKET_R BRACKET_L NUMBER BRACKET_R SEMIC {
  Node *ntmp = make_new_ident_node(stable, SYM_VAR, $2, $4, $7);
  char errmsg[1024];

  if(ntmp != NULL){
    $$ = ntmp;
  } else {
    sprintf(errmsg, "used id %s", $2);
    yyerror(errmsg);
  }
}
;


identifier_list : IDENTIFIER COMMA identifier_list {
  Node *ntmp = make_new_ident_node(stable, SYM_VAR, $1, NULL, NULL);
  char errmsg[1024];

  if(ntmp != NULL){
    ntmp->child[1] = $3;
    $$ = ntmp;
  } else {
    sprintf(errmsg, "used id %s", $1);
    yyerror(errmsg);
    //print_symbol_table(global_stable, 0);
  }
}
| IDENTIFIER {
  Node *ntmp = make_new_ident_node(stable, SYM_VAR, $1, NULL, NULL);
  char errmsg[1024];

  if(ntmp != NULL){
    $$ = ntmp;
  } else {
    sprintf(errmsg, "used id %s", $1);
    yyerror(errmsg);
    //print_symbol_table(global_stable, 0);
  }
}
;


statement_list : statement statement_list    {$$=make_nchild_node(AST_STAT_LIST, $1, $2);}
               | statement                   {$$=make_nchild_node(AST_STAT_LIST, $1, NULL);}
;

statement : assignment_statement    {$$ = $1;}
          | loop_statement          {$$ = $1;}
          | selection_statement {$$ = $1;}
          | function_call {$$ = $1;}
          | break_statement {$$ = $1;}
          | IDENTIFIER unary_operator {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, $1)) == -1){
    if((symno = sym_lookup(global_stable, $1)) == -1){
      sprintf(errmsg, "undefined id %s", $1);
      yyerror(errmsg);
    }
  }
  nid = make_ident_node(SYM_VAR, symno, NULL);
  $$ = make_nchild_node($2, nid);
}
          | unary_operator IDENTIFIER {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, $2)) == -1){
    if((symno = sym_lookup(global_stable, $2)) == -1){
      sprintf(errmsg, "undefined id %s", $2);
      yyerror(errmsg);
    }
  }
  nid = make_ident_node(SYM_VAR, symno, NULL);
  $$ = make_nchild_node($1, nid);
}
          | SEMIC {$$ = NULL;}
;

assignment_statement : IDENTIFIER ASSIGNMENT arithmetic_expression SEMIC {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, $1)) == -1){
    if((symno = sym_lookup(global_stable, $1)) == -1){
      sprintf(errmsg, "undefined id %s", $1);
      yyerror(errmsg);
    }
  }

  nid = make_ident_node(SYM_VAR, symno, stable);
  $$ = make_nchild_node(AST_ASSIGN, nid, $3);
}
| array_reference ASSIGNMENT arithmetic_expression SEMIC {
  $$ = make_nchild_node(AST_ASSIGN, $1, $3);
}
;

arithmetic_expression : arithmetic_expression additive_operator multiplicative_expression 
{
  $$ = make_nchild_node($2, $1, $3);
}
| multiplicative_expression     {$$ = $1;}
;
multiplicative_expression : multiplicative_expression multiplicative_operator primary_expression 
{
  $$ = make_nchild_node($2, $1, $3);
}
| primary_expression        {$$ = $1;}
;
primary_expression : variable {$$ = $1;}
| PAREN_L arithmetic_expression PAREN_R {$$ = $2;}
;
additive_operator : ADDITION {$$ = AST_ADD;}
| SUBTRACTION {$$ = AST_SUB;}
;
multiplicative_operator : MULTIPLICATION {$$ = AST_MUL;}
| DIVISION {$$ = AST_DIV;}
| MODULUS {$$ = AST_MOD;}
;
unary_operator : INCREMENT {$$ = AST_INCRE;}
| DECREMENT {$$ = AST_DECRE;}
;
variable : IDENTIFIER {
  int symno;
  char errmsg[1024];

  if((symno = sym_lookup(stable, $1)) == -1){
    if((symno = sym_lookup(global_stable, $1)) == -1){
      sprintf(errmsg, "undefined id %s", $1);
      yyerror(errmsg);
    }
  }
  $$ = make_ident_node(SYM_VAR, symno, stable);
}
| NUMBER {$$ = $1;}
| array_reference {$$ = $1;}
| IDENTIFIER unary_operator {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, $1)) == -1){
    if((symno = sym_lookup(global_stable, $1)) == -1){
      sprintf(errmsg, "undefined id %s", $1);
      yyerror(errmsg);
    }
  }
  nid = make_ident_node(SYM_VAR, symno, stable);
  $$ = make_nchild_node($2, nid);
}
| unary_operator IDENTIFIER {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, $2)) == -1){
    if((symno = sym_lookup(global_stable, $2)) == -1){
      sprintf(errmsg, "undefined id %s", $2);
      yyerror(errmsg);
    }
  }
  nid = make_ident_node(SYM_VAR, symno, stable);
  $$ = make_nchild_node($1, nid);
}
;
array_reference : IDENTIFIER BRACKET_L variable BRACKET_R {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, $1)) == -1){
    if((symno = sym_lookup(global_stable, $1)) == -1){
      sprintf(errmsg, "undefined id %s", $1);
      yyerror(errmsg);
    }
  }
  nid = make_ident_node(SYM_VAR, symno, stable);
  $$ = make_nchild_node(AST_ARRAY_REF, nid, $3, NULL);
}
| IDENTIFIER BRACKET_L variable BRACKET_R BRACKET_L variable BRACKET_R {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, $1)) == -1){
    if((symno = sym_lookup(global_stable, $1)) == -1){
      sprintf(errmsg, "undefined id %s", $1);
      yyerror(errmsg);
    }
  }
  nid = make_ident_node(SYM_VAR, symno, stable);
  $$ = make_nchild_node(AST_ARRAY_REF, nid, $3, $6);
}
;
loop_statement : WHILE PAREN_L expression PAREN_R BRACE_L statement_list BRACE_R {
  $$ = make_nchild_node(AST_WHILE, $3, $6);
}
| WHILE PAREN_L expression PAREN_R statement {
  $$ = make_nchild_node(AST_WHILE, $3, $5);
}
| FOR PAREN_L for_initial for_expression for_update PAREN_R BRACE_L statement_list BRACE_R {
  $$ = make_nchild_node(AST_FOR, $3, $4, $5, $8);
}
| FOR PAREN_L for_initial for_expression for_update PAREN_R statement {
  $$ = make_nchild_node(AST_FOR, $3, $4, $5, $7);}
;
for_initial : assignment_statement { $$ = $1;}
| SEMIC { $$ = NULL;}
;/*******/
for_expression : expression SEMIC { $$ = $1;}
| SEMIC {$$ = NULL;}
;
for_update : IDENTIFIER ASSIGNMENT arithmetic_expression {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, $1)) == -1){
    if((symno = sym_lookup(global_stable, $1)) == -1){
      sprintf(errmsg, "undefined id %s", $1);
      yyerror(errmsg);
    }
  }
  nid = make_ident_node(SYM_VAR, symno, stable);
  $$ = make_nchild_node(AST_ASSIGN, nid, $3);
}
| array_reference ASSIGNMENT arithmetic_expression { $$ = make_nchild_node(AST_ASSIGN, $1, $3);}
| IDENTIFIER unary_operator {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, $1)) == -1){
    if((symno = sym_lookup(global_stable, $1)) == -1){
      sprintf(errmsg, "undefined id %s", $1);
      yyerror(errmsg);
    }
  }
  nid = make_ident_node(SYM_VAR, symno, stable);
  $$ = make_nchild_node($2, nid);
}
| unary_operator IDENTIFIER {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, $2)) == -1){
    if((symno = sym_lookup(global_stable, $2)) == -1){
      sprintf(errmsg, "undefined id %s", $2);
      yyerror(errmsg);
    }
  }
  nid = make_ident_node(SYM_VAR, symno, stable);
  $$ = make_nchild_node($1, nid);
}
| {$$ = NULL;}
;
selection_statement : if_statement { $$ = $1; }
| if_statement else_statement { $1->child[2] = $2; $$ = $1; }

;
if_statement : IF PAREN_L expression PAREN_R BRACE_L statement_list BRACE_R { $$ = make_nchild_node(AST_IF, $3, $6, NULL); }
             | IF PAREN_L expression PAREN_R statement { $$ = make_nchild_node(AST_IF, $3, $5, NULL); }
;
else_statement : ELSE BRACE_L statement_list BRACE_R { $$ = $3; }
| ELSE statement { $$ = $2; }
;
break_statement : BREAK SEMIC { $$ = make_nchild_node(AST_BREAK); }
;
expression : arithmetic_expression comparison_operator arithmetic_expression { $$ = make_nchild_node($2, $1, $3); }
;
comparison_operator : EQUAL { $$ = AST_EQ; }
| LESS { $$ = AST_LESS; }
| GRATER { $$ = AST_GR; }
| LSEQ { $$ = AST_LSEQ; }
| GREQ { $$ = AST_GREQ; }
;
function_call : FUNCCALL IDENTIFIER PAREN_L PAREN_R SEMIC {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(global_stable, $2)) == -1){
    sprintf(errmsg, "undefined id %s", $2);
    yyerror(errmsg);
  }
  nid = make_ident_node(SYM_FUNC, symno, NULL);
  $$ = make_nchild_node(AST_FUNCCALL, nid, NULL);
}
| FUNCCALL IDENTIFIER PAREN_L parameter_list PAREN_R SEMIC {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(global_stable, $2)) == -1){
    sprintf(errmsg, "undefined id %s", $2);
    yyerror(errmsg);
  }
  nid = make_ident_node(SYM_FUNC, symno, NULL);
  $$ = make_nchild_node(AST_FUNCCALL, nid, $4);}
;
parameter_list : arithmetic_expression COMMA parameter_list { $$ = make_nchild_node(AST_PARAM_LIST, $1, $3); }
               | arithmetic_expression { $$ = make_nchild_node(AST_PARAM_LIST, $1, NULL); }
;
%%
int main(){
  global_stable = sym_add(global_stable, "global", SYM_KEYWORD, 0, 0);
  stable = global_stable;
  if(yyparse()){
    fprintf(stderr, "Error\n");
    return 1;
  }
  // printf("tree\n");
  //print_ast_tree(top, global_stable, global_stable, 0);
  //printf("symbol table\n");
  // print_symbol_table(global_stable, 0);
  //printf("code\n");
  generate_program_code(top, global_stable);
  return 0;
}

