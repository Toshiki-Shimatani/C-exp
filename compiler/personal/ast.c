#include "ast.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

Node *make_num_node(int n){
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

Node *make_ident_node(Stype type, int symno, Symbols *stable){
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
  if(type == SYM_FUNC){
    //obj->value2 = x;
  }
  return obj;
}

Node *make_new_ident_node(Symbols *stable, Stype type, char *name,
                          Node *num1, Node *num2){
  Symbols *stmp = NULL;
  Node *nid = NULL;
  Node *ndec = NULL;
  int size1 = 0, size2 = 0;

  if(sym_lookup(stable, name) == -1){
    if(num1 != NULL) size1 = num1->value;
    if(num2 != NULL) size2 = num2->value;
    stmp = sym_add(stable, name, type, size1, size2);
    nid = make_ident_node(type, stmp->symno, stable);
    ndec =  make_nchild_node(AST_DEC, nid, num1, num2);
    return make_nchild_node(AST_VAR_DECS, ndec, NULL);
    //return ndec;
  } else {
    return NULL;
  }
}

Node *make_nchild_node(Ntype type, ...){
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
  case AST_BREAK:
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

int sym_count = 0;
Symbols *sym_add(Symbols *stable, char *name, Stype type, unsigned int size1, unsigned int size2){
  Symbols *obj = (Symbols*)malloc(sizeof(Symbols));
  char *symbolname = (char*)malloc(strlen(name)+1);

  if(obj == NULL || symbolname == NULL){
    fprintf(stderr, "Error: faild to malloc\n");
    exit(EXIT_FAILURE);
  }

  strcpy(symbolname, name);
  obj->symbolname = symbolname;
  obj->type = type;
  obj->size1 = size1;
  obj->size2 = size2;
  obj->next = NULL;
  obj->branch = NULL;

  if(stable == NULL){
    obj->symno = sym_count;
    sym_count++;
    return obj;
  }

  while(stable->next != NULL) stable = stable->next;

  stable->next = obj;
  obj->symno = sym_count;
  sym_count++;
  return obj;
}

char *sym_lookup_name(Symbols *stable, int symno){
  if(stable == NULL){
    return NULL;
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
  return NULL;
}

Symbols *get_tail_of_stable(Symbols *stable){
  if(stable == NULL) return NULL;

  while(stable->next != NULL) stable = stable->next;

  return stable;
}

Symbols *sym_lookup_entry(Symbols *stable, int symno){
  while(stable != NULL){
    if(stable->symno == symno){
      return stable;
    }
    stable = stable->next;
  }
  return NULL;
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
  case AST_BREAK:
    return "AST_BREAK";
  default:
    return NULL;
  }
  return NULL;
}

char vline_flag[1024] = {0};
void print_ast_tree(Node *root, Symbols *gstable, Symbols *lstable, int space){
  int i, j;
  char *idname;
  Symbols *stmp;

  if(root == NULL){
    printf("NULL\n");
    return;
  }

  switch(root->type){
  case AST_NUM:
    printf("%s %d\n", get_ntype_name(root->type), root->value);
    return;
  case AST_IDENT:
    if((idname = sym_lookup_name(lstable, root->value)) == NULL){
      idname = sym_lookup_name(gstable, root->value);
    }
    printf("%s %s\n",
           get_ntype_name(root->type),
           idname);
    return;
  case AST_FUNC:
    stmp = sym_lookup_entry(gstable, root->child[0]->value);
    lstable = stmp->branch;
  default:
    printf("%s\n", get_ntype_name(root->type));
    space += 1;
    for(i = 0; i < root->n_child; i++){
      for(j = 0; j < space; j++){
        if(j == space-1) printf("|-");
        else {
          if(vline_flag[j]) printf("  ");
          else printf("| ");
        }
      }
      if(i == root->n_child-1){
        vline_flag[space-1] = 1;
      } else {
        vline_flag[space-1] = 0;
      }
      print_ast_tree(root->child[i], gstable, lstable, space);
    }
  }
}

void print_symbol_table(Symbols *stable, int depth){
  int i;

  if(stable == NULL){
    //printf("empty table\n");
    //return;
  }

  while(stable != NULL){
    for(i = 0; i < depth; i++) printf("  ");

    if(stable->type == SYM_VAR){
      printf("%d VAR %s\n", stable->symno, stable->symbolname);
    } else if(stable->type == SYM_FUNC){
      printf("%d FUNC %s\n", stable->symno, stable->symbolname);
    } else if(stable->type == SYM_KEYWORD){
      printf("%d KEYWORD %s\n", stable->symno, stable->symbolname);
    } else if(stable->type == SYM_ARG_VAR){
      printf("%d ARG_VAR %s\n", stable->symno, stable->symbolname);
    } else {
      printf("%d %s\n", stable->symno, stable->symbolname);
    }

    if(stable->branch != NULL){
      print_symbol_table(stable->branch, depth+1);
    }
    stable = stable->next;
  }
}

void generate_program_code(Node *root, Symbols *gstable){
  if(root == NULL || root->type != AST_PROGRAM){
    return;
  }

  generate_initial_code();

  if(root->child[1] != NULL){
    generate_function_list_code(root->child[1], gstable);
    generate_global_variables_definitions(gstable);
  } else {
    generate_function_list_code(root->child[0], gstable);
  }
}

void generate_initial_code(){
  printf("\tINITIAL_GP = 0x10008000		# initial value of global pointer\n");
  printf("\tINITIAL_SP = 0x7ffffffc		# initial value of stack pointer\n");
  printf("\t# system call service number\n");
  printf("\tstop_service = 99\n");
  printf("\n");
  printf("\t.text\n");
  printf("init:\n");
  printf("\t# initialize $gp (global pointer) and $sp (stack pointer)\n");
  printf("\tla	$gp, INITIAL_GP		# $sp <- 0x10008000 (INITIAL_GP)\n");
  printf("\tla	$sp, INITIAL_SP		# $sp <- 0x7ffffffc (INITIAL_SP)\n");
  printf("\tjal	main			# jump to `main'\n");
  printf("\tnop				# (delay slot)\n");
  printf("\tli	$v0, stop_service	# $v0 <- 99 (stop_service)\n");
  printf("\tsyscall				# stop\n");
  printf("\tnop\n");
  printf("\t# not reach here\n");
  printf("\tstop:					# if syscall return\n");
  printf("\tj stop				# infinite loop...\n");
  printf("\tnop				# (delay slot)\n");
  printf("\n");
  printf("\t.text 	0x00001000\n");
}

void generate_function_list_code(Node *node, Symbols *gstable){
  Node *func;
  Symbols *lstable;

  do {
    func = node->child[0];

    lstable = sym_lookup_entry(gstable, func->child[0]->value);
    generate_function_code(func, gstable, lstable->branch);

    node = node->child[1];
  } while(node != NULL);
}

/*
  stack
0x00000000

new
     local variables
     $ra
     $fp
     $a0
     $a1
     $a2
     $a3
     arg (option)
old

-------------------- 0xfffffff


  stack structuer
--------- 0x00000000
text area
---------
data area
--------- 0x???????? initial heap area 

---------------------  "func1"'s stack area size = YY
      $fp
func1:$ra              
---------------------  "main"'s  stack area size = XX  
                        ((変数の数/2)+1)*8+((( 呼び出す関数の引数の最大数-4)/2)+1)*8+24
                        変数に配列が含まれる場合,(配列以外の変数の数＋配列の大きさ)
     /$a0 =  YY($fp)
keep/ $a1 =  YY+4($fp)     このとき，func1の引数は6つであり，
16B \ $a2 =  YY+8($fp)     func1(0($fp),4($fp),8($fp),12($fp),16($fp),20($fp)
     \$a3 =  YY+12($fp)    である．
 

addtive argument area ====
      YY+16($fp)  == 16($sp){main's $sp}
      YY+20($fp)  == 20($sp){main's $sp}
==========================      
func "main" use area =====
      
      
==========================
      $fp
main: $ra             <- initial $sp 0xfffffffc
---------------------   0xfffffffff  
argv[0] = XX($fp)
argv[1] = XX+4($fp)
argv[2] = XX+8($fp)
argv[3] = XX+12($fp

 */
void generate_function_code(Node *func, Symbols *gstable, Symbols *lstable){
  char *func_name;
  int stack_size = 24;
  int local_size;
  int func_arg_size = 0;
  Node *stat_list;
 
  func_name = sym_lookup_name(gstable, func->child[0]->value);
  local_size = calc_local_variables_size(func);
  func_arg_size;
  stack_size += local_size;
  stack_size += stack_size % 8;

  // スタックの操作
  printf("%s:\n", func_name);
  //printf("%s_init:\n", func_name);
  printf("\tsubiu $sp, $sp, %d\n", stack_size);
  printf("\tsw    $ra, %d($sp)\n", stack_size - 4);
  printf("\tsw    $fp, %d($sp)\n", stack_size - 8);
  printf("\tadd   $fp, $sp, $zero\n"); // move相当の動作
  printf("\tsw    $a0, %d($sp)\n", stack_size);
  printf("\tsw    $a1, %d($sp)\n", stack_size + 4);
  printf("\tsw    $a2, %d($sp)\n", stack_size + 8);
  printf("\tsw    $a3, %d($sp)\n", stack_size + 12);
  

  // 関数の本体
  printf("%s_body:\n", func_name);
  stat_list = func->child[3];
  while(stat_list != NULL){
    generate_statement_code(stat_list->child[0], gstable, lstable);
    stat_list = stat_list->child[1];
  }

  // 関数から抜ける時の後処理
  printf("%s_end:\n", func_name);
  printf("\tadd   $sp, $fp, $zero\n");
  printf("\tlw    $ra, %d($sp)\n\tnop\n", stack_size - 4);
  printf("\tlw    $fp, %d($sp)\n\tnop\n", stack_size - 8);
  printf("\taddiu $sp, $sp, %d\n", stack_size);
  printf("\tjr $ra\n");
  printf("\t.align 2\n");
}

unsigned int calc_local_variables_size(Node *func){
  unsigned int val_area_size = 0;
  unsigned int size;
  Node *decs = func->child[2], *dec;

  do {
    dec = decs->child[0];

    if(dec->child[1] == NULL){  // 変数
      size = 4;
    } else if(dec->child[2] == NULL){ // 1次元
      size = dec->child[1]->value * 4;
    } else {                  // 2次元
      size = dec->child[1]->value * dec->child[2]->value * 4;
    }
    
    val_area_size += size;
    decs = decs->child[1];
  } while(decs != NULL);

  if((val_area_size%8) != 0){
    val_area_size += 4;
  }
  return val_area_size;
}

unsigned int calc_local_variables_size_by_table(Symbols *lstable){
  unsigned int total_size = 0;
  unsigned int size;
  
  // localまで移動
  while(lstable->type != SYM_VAR) lstable = lstable->next;
  
  do {
    if(lstable->size1 == 0){
      size = 1;
    } else if(lstable->size2 == 0){
      size = lstable->size1;
    } else {
      size = lstable->size1 * lstable->size2;
    }
    total_size += size * 4;

    lstable = lstable->next;
  } while(lstable != NULL);

  return total_size;
}

void generate_global_variables_definitions(Symbols *gstable){
  int i, j;

  if(gstable == NULL){
    return;
  }

  printf("\t# data segment (global variables)\n");
  printf("\t.data\n");
  
  do {
    if(gstable->type == SYM_VAR){
      printf("%s:\t.word  ", gstable->symbolname);
      if(gstable->size1 == 0){  // 変数
	printf("0\n");
      } else {                  // 配列
	if(gstable->size2 == 0){ // 1次元
	  for(i = 0; i < gstable->size1 - 1; i++){
	    printf("0, ");
	  }
	  printf("0\n");
	} else {                 // 2次元
	  for(i = 0; i < gstable->size2 - 1; i++){
	    printf("0, ");
	  }
	  printf("0\n");
	  for(j = 1; j < gstable->size1; j++){
	    printf("\t.word  ");
	    for(i = 0; i < gstable->size2 - 1; i++){
	      printf("0, ");
	    }
	    printf("0\n");
	  }
	}
      }
    }

    gstable = gstable->next;
  } while(gstable != NULL);
}

void generate_statement_code(Node *stat, Symbols *gstable, Symbols *lstable){
  if(stat == NULL){
    return;
  }

  if(stat->type == AST_ASSIGN){
    generate_arithmetic_code(stat->child[1], gstable, lstable, 0);
    printf("\tlw  $t0, -4($sp)\n\tnop\n");
    printf("\tsw  $t0, %s\n", get_variable_address(stat->child[0], gstable, lstable));
  }

  if(stat->type == AST_WHILE){
    generate_while_code(stat, gstable, lstable);
  }
}

int is_primitive_node(Node *node){
  if(node->type == AST_NUM || node->type == AST_IDENT){
    return 1;
  } else {
    return 0;
  }
}

int calc_local_variable_offset(Symbols *lstable, Symbols *sym){
  int offset = 0;

  // 最初のローカル変数を探す
  while(lstable->type != SYM_VAR) lstable = lstable->next;

  // symを探す
  while(lstable->symno != sym->symno){
    if(lstable->size1 == 0) offset++;
    else if(lstable->size2 == 0) offset += lstable->size1;
    else offset += lstable->size1 * lstable->size2;
    
    lstable = lstable->next;
  }
  return offset * 4;
}

int calc_argment_offset(Symbols *lstable, Symbols *sym){
  int offset = 0;

  // 最初の引数を探す
  while(lstable->type != SYM_ARG_VAR) lstable = lstable->next;

  // sym
  while(lstable->symno != sym->symno){
    offset++;
    lstable = lstable->next;
  }
  offset = offset * 4 + calc_local_variables_size_by_table(lstable) + 8;
  return offset;
}

// グローバル変数なら$t7にアドレスを格納
char variable_address_str[100] = {0};
char *get_variable_address(Node *var, Symbols *gstable, Symbols *lstable){
  Symbols *sym;

  if(var == NULL){
    return NULL;
  }

  if(var->type == AST_IDENT){
    sym = sym_lookup_entry(lstable, var->value);
    if(sym == NULL){ // global
      sym = sym_lookup_entry(gstable, var->value);
      printf("\tla $t7, %s\n", sym->symbolname);
      sprintf(variable_address_str, "0($t7)");
    } else { // local or arg
      if(sym->type == SYM_VAR){ // local
	sprintf(variable_address_str, "%d($sp)",
		calc_local_variable_offset(lstable, sym));
      } else if(sym->type == SYM_ARG_VAR){ // arg
	sprintf(variable_address_str, "%d($sp)",
		calc_argment_offset(lstable, sym));
      }
    }
  }
  return variable_address_str;
}

// $t2 <- $t0 op $t1
int generate_arithmetic_code(Node *exp, Symbols *gstable, Symbols *lstable, int stack_size){
  if(exp == NULL){
    return stack_size;
  }

  if(!is_primitive_node(exp)){
    if(!is_primitive_node(exp->child[0])){
      stack_size = generate_arithmetic_code(exp->child[0], gstable, lstable, stack_size);
    }
    if(!is_primitive_node(exp->child[1])){
      stack_size = generate_arithmetic_code(exp->child[1], gstable, lstable, stack_size);
    }
    // 右
    if(exp->child[1]->type == AST_NUM){
      printf("\taddi $t1, $zero, %d\n", exp->child[1]->value);
    } else if(exp->child[1]->type == AST_IDENT){
      printf("\tlw  $t1, %s\n\tnop\n",
	     get_variable_address(exp->child[1], gstable, lstable));
    } else {
      printf("\tlw  $t1, %d($sp)  /* pop */\n\tnop\n", -stack_size * 4);
      stack_size--;
    }
    // 左
    if(exp->child[0]->type == AST_NUM){
      printf("\taddi $t0, $zero, %d\n", exp->child[0]->value);
    } else if(exp->child[0]->type == AST_IDENT){
      printf("\tlw  $t0, %s\n\tnop\n",
	     get_variable_address(exp->child[0], gstable, lstable));
    } else {
      printf("\tlw  $t0, %d($sp)  /* pop */\n\tnop\n", -stack_size * 4);
      stack_size--;
    }

    if(exp->type == AST_ADD){
      printf("\tadd  $t2, $t0, $t1\n");
    } else if(exp->type == AST_SUB){
      printf("\tsub  $t2, $t0, $t1\n");
    } else if(exp->type == AST_MUL){
      printf("\tmult $t0, $t1\n");
      printf("\tmflo $t2\n");
    } else if(exp->type == AST_DIV){
      printf("\tdiv  $t0, $t1\n");
      printf("\tmflo $t2\n");
    } else if(exp->type == AST_MOD){
      printf("\tdiv  $t0, $t1\n");
      printf("\tmfhi $t2\n");
    }
    stack_size++;
    printf("\tsw   $t2, %d($sp)  /* push */\n", -stack_size * 4);
  } else {
    if(exp->type == AST_NUM){
      printf("\taddi $t0, $zero, %d\n", exp->value);
    } else if(exp->type == AST_IDENT){
      printf("\tlw  $t0, %s\n\tnop\n",
	     get_variable_address(exp, gstable, lstable));
    }
    stack_size++;
    printf("\tsw   $t0, %d($sp)  /* push */\n", -stack_size * 4);
  }

  return stack_size;
}

// 条件式がtrueになるとlabel_nameにジャンプするコードの生成
void generate_expression_code(Node *exp, Symbols *gstable, Symbols *lstable, char *label_name){
  if(exp == NULL) return;

  generate_arithmetic_code(exp->child[0], gstable, lstable, 0);  // left
  generate_arithmetic_code(exp->child[1], gstable, lstable, 1);  // right
  // pop
  printf("\tlw  $t0, -4($sp)  /* pop */\n");
  printf("\tlw  $t1, -8($sp)  /* pop */\n");
  printf("\tnop\n");

  if(exp->type == AST_EQ){
    printf("\tbeq  $t0, $t1, %s\n", label_name);
    printf("\tnop\n");
  } else if(exp->type == AST_LESS){
    printf("\tslt  $t0, $t0, $t1\n");
    printf("\tbne  $t0, $zero, %s\n", label_name);
    printf("\tnop\n");
  } else if(exp->type == AST_GR){
    printf("\tslt  $t0, $t1, $t0\n");
    printf("\tbne  $t0, $zero, %s\n", label_name);
    printf("\tnop\n");
  } else if(exp->type == AST_LSEQ){
    printf("\tslt  $t0, $t1, $t0\n");
    printf("\tbeq  $t0, $zero, %s\n", label_name);
    printf("\tnop\n");
  } else if(exp->type == AST_GREQ){
    printf("\tslt  $t0, $t0, $t1\n");
    printf("\tbeq  $t0, $zero, %s\n", label_name);
    printf("\tnop\n");
  }
}

int label_count = 0;
void generate_while_code(Node *while_node, Symbols *gstable, Symbols *lstable){
  Node *stat_list;
  char label_name[100] = {0};
  
  if(while_node == NULL) return;

  sprintf(label_name, "while_L1_%d", label_count);

  printf("\tj   while_L2_%d\n", label_count);
  printf("while_L1_%d:\n", label_count);
  // stat
  if(while_node->child[1]->type == AST_STAT_LIST){  // ブロック
    printf("/* stat list */\n");
    stat_list = while_node->child[1];
    while(stat_list != NULL){
      generate_statement_code(stat_list->child[0], gstable, lstable);
      stat_list = stat_list->child[1];
    }
  } else {  // 1行だけ
    printf("/* statement %s */\n", get_ntype_name(while_node->child[1]->type));
    generate_statement_code(while_node->child[1], gstable, lstable);
  }
  printf("while_L2_%d:\n", label_count);
  // exp
  generate_expression_code(while_node->child[0], gstable, lstable, label_name);

  label_count++;
}
