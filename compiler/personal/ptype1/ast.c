//#define DEBUG 

#include "ast.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

int stack_count;

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

Node *make_ident_node(Stype type, int symno, Symbols *stable,char* name){
  Node *obj;
  obj = (Node *)malloc(sizeof(Node));
  char *identname = (char*)malloc(strlen(name)+1);
  strcpy(identname, name);

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
  obj->name = identname;
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
    nid = make_ident_node(type, stmp->symno, stable,name);
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
  if(size1 == 0){
    obj->array_flag = 0;
  }else{
    if(size2 == 0){
      obj->array_flag = 1;
    }else {
      obj->array_flag = 2;
    }
  }
  obj->value = 0;
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
    printf("%s", get_ntype_name(root->type));
    if(root->type == AST_FUNC){
      printf(" arg_num %d\n",root->value);
    }else printf("\n");
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

int calc_arg_node_depth(Node *arg_list,int depth){
  if(arg_list == NULL) {
    return 0;
  }else {
    if(arg_list->child[1] == NULL){
      return depth;
    }else {
      depth += calc_arg_node_depth(arg_list->child[1],depth);
      return depth;
    }
  }
}

/*#######################################################*/

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
  printf("\t.align  2\n");
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
  int local_size = 0;
  int func_arg_size = 0;
  Node *stat_list;
 
  func_name = sym_lookup_name(gstable, func->child[0]->value);
  local_size = calc_local_variables_size(func);
  local_size = ((local_size/2)+1)*8;
  #ifdef DEBUG
  printf("\x1b[31m");     /* 前景色を青に */
  printf("\x1b[1m"); // 太文字出力
  printf("local val area size:%d\n",local_size);
  printf("\x1b[0m");		
  printf("\x1b[39m");     /* 前景色をデフォルトに戻す */
  #endif
  func_arg_size = func->value;
  if(func_arg_size > 4){
    func_arg_size = ((((func_arg_size - 4)/2)+1)*8);
  }else func_arg_size = 0;
  stack_size += local_size;
  #ifdef DEBUG
  printf("\x1b[31m");     /* 前景色を青に */
  printf("\x1b[1m"); // 太文字出力
  printf("additive arg area size:%d\n",func_arg_size);
  printf("\x1b[0m");
  printf("\x1b[39m");     /* 前景色をデフォルトに戻す */
  stack_size += func_arg_size;
  printf("\x1b[31m");     /* 前景色を青に */
  printf("\x1b[1m"); // 太文字出力
  printf("stack area size:%d\n",stack_size);
  printf("\x1b[0m");
  printf("\x1b[39m");     /* 前景色をデフォルトに戻す */
  #endif
  // スタックの操作
  printf("%s:\n", func_name);
  //printf("%s_init:\n", func_name);
  printf("\taddiu $sp, $sp, -%d\n", stack_size);
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
  #ifdef DEBUG
  printf("%s < in generate_func\n",lstable->symbolname);
  #endif
  set_ident_address(lstable, func_arg_size, stack_size);
  while(stat_list != NULL){
    generate_statement_code(stat_list->child[0], gstable, lstable);
    stat_list = stat_list->child[1];
  }

  // 関数から抜ける時の後処理
  printf("\tadd   $t9, $v0, $zero\n");
  printf("%s_end:\n", func_name);
  printf("\tadd   $sp, $fp, $zero\n");
  printf("\tlw    $ra, %d($sp)\n\tnop\n", stack_size - 4);
  printf("\tlw    $fp, %d($sp)\n\tnop\n", stack_size - 8);
  printf("\taddiu $sp, $sp, %d\n", stack_size);
  printf("\tjr    $ra\n");
  printf("\t.align 2\n");
}

unsigned int calc_local_variables_size(Node *func){
  unsigned int val_area_size = 0;
  unsigned int size;
  Node *decs = func->child[2], *dec;

  do {
    dec = decs->child[0];
    if(dec->child[1] == NULL){  // 変数
      size = 1;
    } else if(dec->child[2] == NULL){ // 1次元
      size = dec->child[1]->value;
    } else {                  // 2次元
      size = dec->child[1]->value * dec->child[2]->value;
    }
    
    val_area_size += size;
    decs = decs->child[1];
  } while(decs != NULL);


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
  //int i, j;

  if(gstable == NULL){
    return;
  }

  printf("\t# data segment (global variables)\n");
  printf("\t.data\n");
  
  do {
    if(gstable->type == SYM_VAR){
      //printf("%s:\n\t.word\t0", gstable->symbolname);
      if(gstable->size1 == 0){  // 変数
	printf("%s:\n\t.word\t0\n", gstable->symbolname);
	//printf("0\n");
      } else {                  // 配列
	if(gstable->size2 == 0){ // 1次元
	  printf("%s:\n\t.space\t%lu\n", gstable->symbolname,gstable->size1*sizeof(int));
	  /*for(i = 0; i < gstable->size1 - 1; i++){
	    printf("0, ");
	  }
	  printf("0\n");*/
	} else {                 // 2次元
	  printf("%s:\n\t.space\t%lu\n", gstable->symbolname,gstable->size1*gstable->size2*sizeof(int));
	
	  /*
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
	  */
	}
      }
    }

    gstable = gstable->next;
  } while(gstable != NULL);
}

void generate_statement_code(Node *stat, Symbols *gstable, Symbols *lstable){
  if(stat == NULL){ //SEMIC
    return;
  }
  #ifdef DEBUG
  printf("stat\n");
  #endif
  if(stat->type == AST_ASSIGN){
    #ifdef DEBUG
    printf(" assign\n");
    #endif
    generate_assign_code(stat,gstable,lstable);
    //printf("\tlw  $t0, -4($sp)\n\tnop\n");
    //printf("\tsw  $t0, %s\n", get_variable_address(stat->child[0], gstable, lstable));
  }
  
  if(stat->type == AST_WHILE){
    //generate_while_code(stat, gstable, lstable);
  }
  if(stat->type == AST_IF){
  }
  if(stat->type == AST_BREAK){
  }
  if(stat->type == AST_INCRE){
  }
  if(stat->type == AST_DECRE){
  
  #ifdef DEBUG
  printf("\x1b[31m");     /* 後景色を赤に */
  //printf("\x1b[1m"); // 太文字出力
  printf("ERROR! in function get_indent_address\n");
  //printf("\x1b[0m");		
  printf("\x1b[39m");     /* 後景色をデフォルトに戻す */   
  #endif
  }
}

void generate_assign_code(Node *assign, Symbols *gstable, Symbols *lstable){
  int lval_address = 0;
  int assign_value = 0;

  if(assign == NULL){
    return;
  }

  lval_address = get_ident_address(assign->child[0],gstable,lstable);
  if(assign->child[0]->type == AST_ARRAY_REF){
    get_array_address(assign->child[0],gstable,lstable);
    printf("\tadd    $t9,$zero,$v0\n");
  }
  /*
  if(assign->child[1]->type == AST_NUM){ //右辺が定数
    assign_value = assign->child[1]->value;
    printf("\tli     $v0, %d\n",assign_value);
    set_ident_value(assign->child[0], assign_value,gstable,lstable);
    #ifdef DEBUG
    if(assign->child[0]-> type == AST_IDENT){
    printf("%s value <<<< %d\n",assign->child[0]->name,assign_value);
    }else
      printf("%s value <<<< %d\n",assign->child[0]->child[0]->name,assign_value); 
    #endif
    }else{*/ //右辺が算術式
      stack_count = 1;
    assign_value = generate_arithmetic_code(assign->child[1], gstable, lstable);
    //set_ident_value(assign->child[0], assign_value,gstable,lstable);
    //}
  if(assign->child[0]->type == AST_ARRAY_REF){
    printf("\tsw     $v0, 0($t9)\n");
    return;
  }else
    printf("\tsw     $v0, %d($fp)\n",lval_address);
  return;
}

int generate_arithmetic_code(Node *exp, Symbols *gstable, Symbols *lstable){
  int val_address = 0;
  Symbols *tmp_symbol;
  
  if(exp == NULL) {
    #ifdef DEBUG
    printf("\x1b[33m");     /* 後景色を黄に */
    printf("ERROR! in function generate_arithmetic_code\n");
    printf("\x1b[39m");     /* 後景色をデフォルトに戻す */ 
    #endif
  }

  if(exp->type == AST_IDENT){
    //printf("!!!%s!!!\n",exp->name);
    val_address = get_ident_address(exp,gstable,lstable);
    printf("\taddi   $t8, $fp, %d\n",val_address); 
    printf("\tlw     $v0, %d($fp)\n",val_address);
    printf("\tnop\n");
    return exp->value;
  }else if(exp->type == AST_NUM){
    printf("\tli     $v0, %d\n",exp->value);
    return exp->value;
  }else if(exp->type == AST_ARRAY_REF){
    get_array_address(exp,gstable,lstable);
    printf("\tadd   $t8, $zero, $v0\n");
    printf("\tlw     $v0, 0($v0)\n");
    printf("\tnop\n");
    return 0;
  }
  // 以下はexpが演算子だったときに動作
  /*if(exp->type == AST_INCRE && exp->type == AST_DECRE){
    tmp_symbol = lstable;
    while(tmp_symbol!=NULL){
      if(strcmp(exp->child[0]->name,tmp_symbol->symbolname)==0){
	break;
      }else
	tmp_symbol = tmp_symbol->next;
    }
    printf("\tlw     $v0, %d($fp)\n",tmp_symbol->address);
    printf("\tnop\n");
  */
  if(exp->child[0] != NULL){
    generate_arithmetic_code(exp->child[0],gstable,lstable);
    printf("\tsw     $v0, -%d($fp)\n",stack_count*4);
    stack_count++;
  }
  if(exp->child[1] != NULL){
    generate_arithmetic_code(exp->child[1],gstable,lstable);
    printf("\tsw     $v0, -%d($fp)\n",stack_count*4);
    stack_count++;
  }
  if(exp->type != AST_ADD &&
     exp->type != AST_SUB &&
     exp->type != AST_MUL &&
     exp->type != AST_DIV &&
     exp->type != AST_MOD &&
     exp->type != AST_INCRE &&
     exp->type != AST_DECRE ) return 0;

    if(exp->child[1] != NULL){
    printf("\tlw     $v1, -%d($fp)\n",(stack_count-1)*4);
    printf("\tnop\n");
    stack_count--;
    }
    printf("\tlw     $v0, -%d($fp)\n",(stack_count-1)*4);
    printf("\tnop\n");
    stack_count--;
    /*
    if(exp->child[1] != NULL){
    printf("\tlw     $v1, -%d($fp)\n",(stack_count-1)*4);
    printf("\tnop\n");
    }*/
  if(exp->type == AST_ADD){
    printf("\tadd    $v0, $v0, $v1\n");
    //stack_count = stack_count - 2;
  }else if(exp->type == AST_SUB){
    printf("\tsub    $v0, $v0, $v1\n");
    //stack_count = stack_count - 2;
  }else if(exp->type == AST_MUL){
    printf("\tmult   $v0, $v1\n");
    printf("\tmflo   $v0\n");
    //stack_count = stack_count - 2;
  }else if(exp->type == AST_DIV){
    printf("\tdiv    $v0, $v1\n");
    printf("\tmflo   $v0\n");
    //stack_count = stack_count - 2;
   }else if(exp->type == AST_MOD){
    printf("\tdiv    $v0, $v1\n");
    printf("\tmfhi   $v0\n");
    //stack_count = stack_count - 2;
  }else if(exp->type == AST_INCRE){
    printf("\taddi   $v0, $v0, 1\n");
    printf("\tsw     $v0, 0($t8)\n");
    if(exp->value == 0){
    }else if(exp->value == 1){
      printf("\taddi   $v0, $v0, -1\n");
    }
    //stack_count = stack_count - 1;
  }else if(exp->type == AST_DECRE){
    printf("\taddi   $v0, $v0, -1\n");
    printf("\tsw     $v0, 0($t8)\n");
    if(exp->value == 0){
    }else if(exp->value == 1){
      printf("\taddi   $v0, $v0, 1\n");
    }  
    //stack_count = stack_count - 1;
  }
  
  //printf("\tadd    $v0, $zero ,$v1\n");
  return 0;
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

void set_ident_address(Symbols *lstable, int func_arg_size, int stack_size){
  int arg_count = 0;
  int var_count = 0;
  Symbols *tmp_table = lstable;
  if(tmp_table == NULL) {
    return;
  }
  while(tmp_table != NULL){
    if(tmp_table->type == SYM_ARG_VAR){
      tmp_table->address = stack_size + arg_count * 4;
      arg_count += 1;
    }else if(tmp_table->type == SYM_VAR){
      if(tmp_table->array_flag == 0){
	tmp_table->address = 16 + func_arg_size + var_count * 4;
	var_count += 1;
	#ifdef DEBUG
	printf("\x1b[31m");     /* 前景色を青に */
	printf("\x1b[1m"); // 太文字出力
	printf("%s: address is %d($fp) < set_ident_address\n",tmp_table->symbolname,tmp_table->address);
	printf("\x1b[0m");
	printf("\x1b[39m");     /* 前景色をデフォルトに戻す */
	#endif
      }else if(tmp_table->array_flag == 1){
	tmp_table->address = 16 + func_arg_size + var_count * 4;
	var_count += tmp_table->size1;
	#ifdef DEBUG
	printf("\x1b[31m");     /* 前景色を青に */
	printf("\x1b[1m"); // 太文字出力
	printf("%s: address is %d($fp) < set_ident_address\n",tmp_table->symbolname,tmp_table->address);
	printf("\x1b[0m");
	printf("\x1b[39m");     /* 前景色をデフォルトに戻す */
	#endif
      }else if(tmp_table->array_flag == 2){
	tmp_table->address = 16 + func_arg_size + var_count * 4;
	var_count += tmp_table->size1 * tmp_table->size2;
      }else{
	#ifdef DEBUG
	printf("\x1b[31m");     /* 前景色を青に */
	printf("\x1b[1m"); // 太文字出力
	printf("ERROR: in set_ident_address\n");
	printf("\x1b[0m");
	printf("\x1b[39m");     /* 前景色をデフォルトに戻す */
	#endif
      }
    }
    tmp_table = tmp_table->next;
  }
}

int get_ident_address(Node *node, Symbols *gstable, Symbols *lstable){
  Symbols *tmp_symbol;
  char* ident_name;
  int array_flag;

  if(node == NULL) return -1;

  if(node->type == AST_ARRAY_REF){
    if((ident_name = sym_lookup_name(lstable, node->child[0]->value)) == NULL){
      ident_name = sym_lookup_name(gstable, node->child[0]->value);
      printf("\tglobal val: %s\n",ident_name);
      return -1;
    }
    tmp_symbol = lstable;
  while(tmp_symbol != NULL){
    if(strcmp(tmp_symbol->symbolname, ident_name) == 0){
      array_flag = tmp_symbol->array_flag;
      break;
    }else{
	tmp_symbol = tmp_symbol->next;
    }
  }
  
  if(array_flag == 1){
    if(node->child[1]->type == AST_NUM){
      return tmp_symbol->address + node->child[1]->value*4;
    }else if(node->child[1]->type == AST_IDENT){
    }else if(node->child[1]->type == AST_ARRAY_REF){
    }
  }else if(array_flag == 2){
    //printf("2 array\n");
  }
  return 100;

  }else if(node->type == AST_IDENT){
    if((ident_name = sym_lookup_name(lstable, node->value)) == NULL){
      ident_name = sym_lookup_name(gstable, node->value);
      printf("\tglobal val: %s\n",ident_name);
      return -1;
    }
  }else return -1;
  
  tmp_symbol = lstable;
  while(tmp_symbol != NULL){
    if(strcmp(tmp_symbol->symbolname, ident_name) == 0){
      return (int)tmp_symbol->address;
    }else{
	tmp_symbol = tmp_symbol->next;
    }
  }
  #ifdef DEBUG
  printf("\x1b[31m");     /* 後景色を赤に */
  //printf("\x1b[1m"); // 太文字出力
  printf("ERROR! in function get_ident_address\n");
  //printf("\x1b[0m");		
  printf("\x1b[39m");     /* 後景色をデフォルトに戻す */  
  #endif
  return -1;
  
}

void get_array_address(Node *array_ref, Symbols *gstable, Symbols *lstable){
  int address = 0;
  char* array_name;
  Symbols *tmp_symbol;

  array_name = array_ref->child[0]->name;
  #ifdef DEBUG
  printf("array_name :%s\n",array_name);
  #endif
  tmp_symbol = lstable;
  while(tmp_symbol != NULL){
    if(strcmp(tmp_symbol->symbolname, array_name) == 0){
      break;
    }else{
      tmp_symbol = tmp_symbol->next;
    }
  }
  address = tmp_symbol->address;
  printf("\tli     $v0, %d\n",address);
  printf("\tadd    $v1, $zero, $fp\n");
  printf("\tadd    $v0, $v0, $v1\n");
  printf("\tsw     $v0, -%d($fp)\n",stack_count*4);
  stack_count++;
  
  if(tmp_symbol->array_flag == 1){
    generate_arithmetic_code(array_ref->child[1],gstable,lstable);
    printf("\tli     $t0, 4\n");
    printf("\tmult   $v0, $t0\n");
    printf("\tlw     $v1, -%d($fp)\n",(stack_count-1)*4);
    printf("\tmflo   $v0\n");
    printf("\tadd    $v0, $v1,$v0\n");
    stack_count--;
  }else if(tmp_symbol->array_flag == 2){
    generate_arithmetic_code(array_ref->child[1],gstable,lstable);
    printf("\tli     $t0,%d\n",tmp_symbol->size2*4);
    printf("\tmult   $v0, $t0\n");   
    printf("\tlw     $v1, -%d($fp)\n",(stack_count-1)*4);
    printf("\tmflo     $v0\n");
    printf("\tadd    $v0, $v1,$v0\n");
    printf("\tsw     $v0, -%d($fp)\n",(stack_count-1)*4);
    generate_arithmetic_code(array_ref->child[2],gstable,lstable);    
    printf("\tli     $t0, 4\n");
    printf("\tmult   $v0, $t0\n");
    printf("\tlw     $v1, -%d($fp)\n",(stack_count-1)*4);
    printf("\tmflo   $v0\n");
    printf("\tadd    $v0, $v1,$v0\n");
    stack_count--;
  }
  
}

void set_ident_value(Node *node, int value, Symbols *gstable, Symbols *lstable){
  char *name;
  Symbols *tg_sym;

  if(node->type == AST_IDENT){
    name = node->name;
  }else{
    name = node->child[0]->name;
  }
  
  tg_sym = lstable;
  while(tg_sym != NULL){
    if(strcmp(name,tg_sym->symbolname) == 0){
      tg_sym->value = value;
      return;
    }else
      tg_sym = tg_sym->next;
  }
  tg_sym = gstable;
  while(tg_sym != NULL){
    if(strcmp(name,tg_sym->symbolname) == 0){
      tg_sym->value = value;
      return;
    }else
      tg_sym = tg_sym->next;
  }
  
}

void array_resolution(Node array_ref){
  
}
