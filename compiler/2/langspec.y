%{
#include <stdio.h>
#include "langspec.tab.h"
extern int yylex();
extern int yyerror();

%}
%token DEFINE ARRAY IDENTIFIER NUMBER
%token FUNC FUNCCALL
%token WHILE IF ELSE BREAK FOR
%token PAREN_L PAREN_R BRACKET_L BRACKET_R BRACE_L BRACE_R
%token ADDITION SUBTRACTION MULTIPLICATION DIVISION MODULUS
%token EQUAL LESS GRATER GREQ LSEQ
%token DECREMENT INCREMENT
%token ASSIGNMENT
%token SEMIC COMMA
%%
program : variable_declarations function_list           {}
        | function_list {}
;
function_list : function function_list {}
              | function {}
;
function : FUNC IDENTIFIER PAREN_L argument_list PAREN_R BRACE_L variable_declarations statement_list BRACE_R {}
         |  FUNC IDENTIFIER PAREN_L PAREN_R BRACE_L variable_declarations statement_list BRACE_R {}
;
argument_list : argument COMMA argument_list {}
              | argument {}
;
argument : DEFINE IDENTIFIER {}
         | ARRAY IDENTIFIER BRACKET_L BRACKET_R {}
         | ARRAY IDENTIFIER BRACKET_L NUMBER BRACKET_R BRACKET_L BRACKET_R {}
;
variable_declarations : declaration variable_declarations    {}
                      | declaration                          {}
;
declaration : DEFINE identifier_list SEMIC                            {}
            | ARRAY IDENTIFIER BRACKET_L NUMBER BRACKET_R SEMIC    {}
| ARRAY IDENTIFIER BRACKET_L NUMBER BRACKET_R BRACKET_L NUMBER BRACKET_R SEMIC {}
;
identifier_list : IDENTIFIER COMMA identifier_list {}
                | IDENTIFIER {}
;
statement_list : statement statement_list    {}
               | statement                   {}
;
statement : assignment_statement    {}
          | loop_statement          {}
          | selection_statement {}
          | function_call {}
          | break_statement {}
          | SEMIC {}
;
assignment_statement : IDENTIFIER ASSIGNMENT arithmetic_expression SEMIC {}
                     | array_reference ASSIGNMENT arithmetic_expression SEMIC    {}
;
arithmetic_expression : arithmetic_expression additive_operator multiplicative_expression {}
                      | multiplicative_expression                                         {}
;
multiplicative_expression : multiplicative_expression multiplicative_operator primary_expression {}
                          | primary_expression                                                   {}
;
primary_expression : variable {}
                   | PAREN_L arithmetic_expression PAREN_R {}
;
additive_operator : ADDITION {}
                  | SUBTRACTION {}
;
multiplicative_operator : MULTIPLICATION {}
                        | DIVISION {}
                        | MODULUS {}
;
unary_operator : INCREMENT {}
               | DECREMENT {}
;
variable : IDENTIFIER {}
         | NUMBER {}
         | array_reference {}
         | IDENTIFIER unary_operator {}
         | unary_operator IDENTIFIER {}
;
array_reference : IDENTIFIER BRACKET_L variable BRACKET_R {}
                | IDENTIFIER BRACKET_L variable BRACKET_R BRACKET_L variable BRACKET_R {}
;
loop_statement : WHILE PAREN_L expression PAREN_R BRACE_L statement_list BRACE_R {}
               | WHILE PAREN_L expression PAREN_R statement {}
               | FOR PAREN_L for_initial for_expression for_update PAREN_R BRACE_L statement_list BRACE_R {}
               | FOR PAREN_L for_initial for_expression for_update PAREN_R statement {}
;
for_initial : assignment_statement{}
            | SEMIC {}
;
for_expression : expression SEMIC {}
               | SEMIC {}
;
for_update : IDENTIFIER ASSIGNMENT arithmetic_expression {}
           | array_reference ASSIGNMENT arithmetic_expression {}
           | IDENTIFIER unary_operator {}
           | unary_operator IDENTIFIER {}
           | {}
;
selection_statement : if_statement {}
                    | if_statement else_statement {}

;
if_statement : IF PAREN_L expression PAREN_R BRACE_L statement_list BRACE_R {}
             | IF PAREN_L expression PAREN_R statement {}
;
else_statement : ELSE BRACE_L statement_list BRACE_R {}
| ELSE statement {}
;
break_statement : BREAK SEMIC {}
;
expression : arithmetic_expression comparison_operator arithmetic_expression {}
;
comparison_operator : EQUAL {}
                    | LESS {}
                    | GRATER {}
                    | LSEQ {}
                    | GREQ {}
;
function_call : FUNCCALL IDENTIFIER PAREN_L PAREN_R SEMIC {}
              | FUNCCALL IDENTIFIER PAREN_L parameter_list PAREN_R SEMIC {}
;
parameter_list : arithmetic_expression COMMA parameter_list {}
               | arithmetic_expression {}
;
%%
int main(){
	if(yyparse()){
		fprintf(stderr, "Error\n");
		return 1;
	}
	return 0;
}
