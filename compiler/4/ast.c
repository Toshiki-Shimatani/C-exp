
#include "ast.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

Node *
make_num_node(int n){
  Node *obj;
  obj = (Node *)malloc(sizeof(Node));

  if(obj == NULL){
    fprintf(stderr, "Error: faild to malloc\n");
    exit(EXIT_FAILURE);
  }

  obj->type = AST_NUM;
  obj->value = n;
  obj->n_child = 0;
  obj->child = NULL;
  return obj;
}

Node *
make_ident_node(Stype type, int symno, Symbols *stable){
  Node *obj;
  obj = (Node *)malloc(sizeof(Node));
  if(obj == NULL){
    fprintf(stderr, "Error: faild to malloc\n");
    exit(EXIT_FAILURE);
  }
  obj->type = AST_IDENT;
  obj->value = symno;
  obj->n_child = 0;
  obj->child = NULL;
  return obj;
}

Node *
make_nchild_node(Ntype type, ...){
  int n_child = get_child_num(type);
  va_list ap;
  Node *obj = (Node*)malloc(sizeof(Node));
  int i;
  if(obj == NULL){
    fprintf(stderr, "Error: faild to malloc\n");
    exit(EXIT_FAILURE);
  }

  obj->type = type;
  obj->n_child = n_child;
  obj->child = (Node**)malloc(sizeof(Node) * n_child);

  va_start(ap, type);
  for(i = 0; i < n_child; i++){
    obj->child[i] = va_arg(ap, Node*);
  }
  va_end(ap);

  return obj;
}

int get_child_num(Ntype type){
  switch(type){
  case AST_IDENT:
  case AST_NUM:
    return 0;
  case AST_INCRE:
  case AST_DECRE:
    return 1;
  case AST_PROGRAM:
  case AST_VAR_DECS:
  case AST_FUNC_LIST:
  case AST_ARG_LIST:
  case AST_ARG:
  case AST_STAT_LIST:
  case AST_ASSIGN:
  case AST_ADD:
  case AST_SUB:
  case AST_MUL:
  case AST_DIV:
  case AST_MOD:
  case AST_WHILE:
  case AST_EQ:
  case AST_LESS:
  case AST_GR:
  case AST_LSEQ:
  case AST_GREQ:
  case AST_FUNCCALL:
  case AST_PARAM_LIST:
    return 2;
  case AST_DEC:
  case AST_IF:
  case AST_ARRAY_REF:
    return 3;
  case AST_FUNC:
  case AST_FOR:
    return 4;
  default:
    return 0;
  }
}

int sym_lookup(Symbols *stable, char *name){
  if(stable == NULL){
    return -1;
  }
  
  if(strcmp(stable->symbolname, name) == 0){
    return stable->symno;
  }
  while(stable->next != NULL){
    stable = stable->next;
     if(strcmp(stable->symbolname, name) == 0){
       return stable->symno;
     }
  }
  return -1;
}

Symbols *sym_add(Symbols *stable, char *name){
  Symbols *obj = (Symbols*)malloc(sizeof(Symbols));
  char *symbolname = (char*)malloc(strlen(name));

  if(obj == NULL || symbolname == NULL){
    fprintf(stderr, "Error: faild to malloc\n");
    exit(EXIT_FAILURE);
  }

  strcpy(symbolname, name);
  obj->symbolname = symbolname;
  obj->next = NULL;
  obj->branch = NULL;

  if(stable == NULL){
    obj->symno = 0;
    return obj;
  }

  while(stable->next == NULL) stable = stable->next;

  stable->next = obj;
  obj->symno = stable->symno + 1;
  return obj;
}

char *sym_lookup_name(Symbols *stable, int symno){
  if(stable == NULL){
    return "";
  }
  
  while(1){
    if(stable->symno == symno){
      return stable->symbolname;
    }
    if(stable->next != NULL){
      stable = stable->next;
    } else {
      break;
    }
  }
  return "";
}

char *get_ntype_name(Ntype type){
  switch(type){
  case AST_PROGRAM:
    return "PROGRAM";
  case AST_VAR_DECS:
    return "VAR_DECS";
  case AST_DEC:
    return "AST_DEC";
  case AST_FUNC_LIST:
    return "AST_FUNC_LIST";
  case AST_FUNC:
    return "AST_FUNC";
  case AST_ARG_LIST:
    return "AST_ARG_LIST"; 
  case AST_ARG:
    return "AST_ARG";
  case AST_STAT_LIST:
    return "AST_STAT_LIST";
  case AST_ASSIGN:
    return "AST_ASSIGN";
  case AST_ADD:
    return "AST_ADD";
  case AST_SUB:
    return "AST_SUB";
  case AST_MUL:
    return "AST_MUL";
  case AST_DIV:
    return "AST_DIV";
  case AST_MOD:
    return "AST_MOD";
  case AST_INCRE:
    return "AST_INCRE";
  case AST_DECRE:
    return "AST_DECRE";
  case AST_WHILE:
    return "AST_WHILE";
  case AST_FOR:
    return "AST_FOR";
  case AST_IF:
    return "AST_IF";
  case AST_EQ:
    return "AST_EQ";
  case AST_LESS:
    return "AST_LESS";
  case AST_GR:
    return "AST_GR";  
  case AST_LSEQ:
    return "AST_LSEQ";
  case AST_GREQ:
    return "AST_GREQ";
  case AST_FUNCCALL:
    return "AST_FUNCCALL";
  case AST_PARAM_LIST:
    return "AST_PARAM_LIST";
  case AST_IDENT:
    return "AST_IDENT";
  case AST_NUM:
    return "AST_NUM";
  case AST_ARRAY_REF:
    return "AST_ARRAY_REF";
  defaule:
    return NULL;
    
    }
}

void print_ast_tree(Node *root, int space){
  int i, j;

  if(root == NULL){
    return;
  }

  switch(root->type){
  case AST_NUM:
    printf("%s %d\n", get_ntype_name(root->type), root->value);
    return;
  case AST_IDENT:
    printf("%s \?\?\?\n", get_ntype_name(root->type));
    return;
  default:
    space += printf("%s    ", get_ntype_name(root->type));
    for(i = 0; i < root->n_child; i++){
      if(i != 0){
	for(j = 0; j < space; j++) printf(" ");
      }
      print_ast_tree(root->child[i], space);
    }
    printf("\n");
  }
}
