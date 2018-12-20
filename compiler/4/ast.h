typedef enum{
  SYM_VAR,
  SYM_FUNC,
} Stype;

typedef enum{
  AST_PROGRAM,
  AST_VAR_DECS,
  AST_DEC,
  AST_FUNC_LIST,
  AST_FUNC,
  AST_ARG_LIST,
  AST_ARG,
  AST_STAT_LIST,
  AST_ASSIGN,
  AST_ADD,
  AST_SUB,
  AST_MUL,
  AST_DIV,
  AST_MOD,
  AST_INCRE,
  AST_DECRE,
  AST_WHILE,
  AST_FOR,
  AST_IF,
  AST_EQ,
  AST_LESS,
  AST_GR,
  AST_LSEQ,
  AST_GREQ,
  AST_FUNCCALL,
  AST_PARAM_LIST,
  AST_IDENT,
  AST_NUM,
  AST_ARRAY_REF,
} Ntype;

typedef struct node{
  Ntype type;
  int value;
  int n_child;
  struct node **child;
} Node;

typedef struct symbols{
  int symno;
  char *symbolname;
  Stype type;
  struct symbols *next;
  struct symbols *branch;
} Symbols;

Node *make_num_node(int n);
Node *make_ident_node(Stype type, int symno, Symbols *stable);
Node *make_nchild_node(Ntype type, ...);
int get_child_num(Ntype type);
Symbols *sym_add(Symbols *stable, char *name);
char *sym_lookup_name(Symbols *stable, int symno);
char *get_ntype_name(Ntype type);
void print_ast_tree(Node *root, int depth);
