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
