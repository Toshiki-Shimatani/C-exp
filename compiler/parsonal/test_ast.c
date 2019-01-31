#include "ast.h"
#include <stdio.h>

int main(){
  Node *root;
  Node *tmp1, *tmp2;
  Node *mul1;
  Node *ifnode;
  Node *exp;
  Node *le;
  Node *var1, *var2;
  Symbols *stable = NULL, *stmp;

  stable = stmp = sym_add(stable, "abc");
  var1 = make_ident_node(SYM_VAR, stmp->symno, NULL);

  stmp = sym_add(stable, "xyz");
  var2 = make_ident_node(SYM_VAR, stmp->symno, NULL);

  tmp1 = make_num_node(1);
  tmp2 = make_num_node(3);

  mul1 = make_nchild_node(AST_MUL, var1, var2);

  le = make_nchild_node(AST_LESS, tmp2, tmp1);
  ifnode = make_nchild_node(AST_IF, le, mul1, NULL);

  root = make_nchild_node(AST_ADD, mul1, tmp2);
  print_ast_tree(ifnode, stable, 0);

  //printf("%d %s\n", stable->symno, stable->symbolname);
  print_symbol_table(stable, 0);

  return 0;
}
