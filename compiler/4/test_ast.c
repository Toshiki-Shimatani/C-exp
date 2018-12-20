#include "ast.h"

int main(){
  Node *root;
  Node *tmp1, *tmp2;
  Node *mul1;
  Node *ifnode;
  Node *exp;
  Node *le;

  tmp1 = make_num_node(1);
  tmp2 = make_num_node(3);
  mul1 = make_nchild_node(AST_MUL, tmp1, tmp2);

  le = make_nchild_node(AST_LESS, tmp2, tmp1);
  ifnode = make_nchild_node(AST_IF, le, mul1, tmp1);

  root = make_nchild_node(AST_ADD, mul1, tmp2);
  print_ast_tree(ifnode, 0);
}
