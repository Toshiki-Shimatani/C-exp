#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LEN 1024 /*1行に読み込める最大文字数*/
#define MAX_STR_LEN 70 /*構造体メンバnameとhomeの最大文字数*/
#define MAX 5 /*split関数での最大分割数*/
#define PDS profile_data_store
#define PDN profile_data_nitems

struct date {
  int y;
  int m;
  int d;
};

struct profile {
  int id;
  char name[70];
  struct date birthday;
  char home[70];
  char *comment;
};

struct profile profile_data_store[10000]; /*10000件のデータまで登録可能*/
int profile_data_nitems = 0; /*登録したデータ数*/
int save = 0; /* データを保存したかどうかの判定に使用 */
/*************************************************************************/
int get_line(FILE *fp,char *line);
int subst(char *str, char c1, char c2);
void parse_line(char *line);     
void exec_command(char cmd1,char cmd2, char *param);
void new_profile(char *line);
int split(char *str, char *ret[], char sep, int max);
void cmd_quit();                 /************************************/ 
void cmd_check();
void cmd_print(int n);
void cmd_read(char *file);
void cmd_write(char *file);      /*             コマンド関数           */
void cmd_find(char *word);
void cmd_bsort(int n);
void cmd_qsort(int n);
void cmd_modify(int n);
void cmd_delete(int n);
void cmd_find2(char *word);
void cmd_Bwrite(char *line);
void cmd_Bread(char *line);     /************************************/
void print_profile(struct profile *p);
void fprint_profile_csv(FILE *fp, struct profile *p);
char *date_to_string(char buf[], struct date *date);
int comparsion (char *word, int i);/*        コマンド関数に用いる関数     */
void b_sort(struct profile *p, int left, int right, int column);
int compare_profile(struct profile *p1, struct profile *p2, int column);
void swap (struct profile *a, struct profile *b);
void q_sort(struct profile *p, int left, int right, int column);
/*************************************************************************/
int main() {
  char line[MAX_LINE_LEN + 1];
  while (get_line(stdin, line)) {
    parse_line(line);
   }
  cmd_quit();
  return 0;
}

int get_line(FILE *fp, char *line)
{
  if (fgets(line, MAX_LINE_LEN + 1, fp) == '\0')
    {
      return 0;
    }

  subst(line, '\n', '\0');

  return 1;
}

int subst(char *str, char c1, char c2) {
  char *s;
  int i, x, n;

  s = str;
  while (*s != '\0') {
    s++;
  }
  x = s - str; /* strの文字数 */
  s = str;
  n=0; /*入れ替えを行った回数 */
  for(i=0;i<x+1;i++) {
    if (*(s+i)== c1) {
      *(s+i) = c2;
      n++;
    }
  }
  return n;
}

void parse_line(char *line) {
  if (*line == '%') {
    exec_command(line[1], line[2], &line[3]);
  } else {
    if (profile_data_nitems < 10000 ) {
      new_profile(line) ;
    }
  }
}

void exec_command(char cmd1, char cmd2, char *param) {

  if(cmd2 == ' ' || cmd2 == '\0') {
    /*************************** 1文字コマンド ****************************/
    switch (cmd1) {
    case 'Q' :
    case 'q' : cmd_quit();  break;
    case 'C' : 
    case 'c' : cmd_check(); break;
    case 'P' : 
    case 'p' : cmd_print(atoi(param)); break;
    case 'R' : 
    case 'r' : cmd_read(param);  break;
    case 'W' : 
    case 'w' : cmd_write(param); break;
    case 'F' : cmd_find(param); break;
    case 'f' : cmd_find2(param);  break;
    case 'S' : cmd_bsort(atoi(param));  break;
    case 's' : cmd_qsort(atoi(param));  break;
    case 'M' : 
    case 'm' : cmd_modify(atoi(param)); break;
    case 'D' : 
    case 'd' : cmd_delete(atoi(param)); break;
    default:
      fprintf(stderr, "%%%c command is undefined \n", cmd1);
      break;
    }
    /*******************************************************************/
  } else
    /************************** 2文字コマンド ****************************/
    switch (cmd1) {
    case 'T' :
    case 't' :
      switch (cmd2) {
      case 'R' : 
      case 'r' : cmd_read(param+1); break;
      default:
	fprintf(stderr, "%%%c%c command is undefined \n", cmd1, cmd2);
      break;
      } break;      
    case 'B' :
    case 'b' :
      switch (cmd2) {
      case 'R' : 
      case 'r' : cmd_Bread(param+1); break;
      case 'W' : 
      case 'w' : cmd_Bwrite(param+1); break;
      case 'S' : 
      case 's' : cmd_bsort(atoi(param+1));  break;  
      default:
	fprintf(stderr, "%%%c%c command is undefined \n", cmd1, cmd2);
	break;	
      } break;
    case 'Q' :
    case 'q' :
      switch (cmd2) {
      case 'S' : 
      case 's' : cmd_qsort(atoi(param+1)); break;
      default:
	fprintf(stderr, "%%%c%c command is undefined \n", cmd1, cmd2);
      break; 
      } break;
    default:
      fprintf(stderr, "%%%c%c command is undefined \n", cmd1, cmd2);
      break;
    }   
    /*******************************************************************/
}
  
void new_profile(char *line) {
    
  char *ret[5];
  char *ret2[3];
  int cnt1, cnt2;
  
  cnt1 = split(line, ret, ',', MAX);
  if (cnt1 == 5){
    if (strlen(ret[0]) > 8) {
      fprintf(stderr,"ID max digits are 8\n");
    }
    PDS[PDN].id = atoi(ret[0]);
    strncpy(PDS[PDN].name, ret[1], MAX_STR_LEN);
    PDS[PDN].name[MAX_STR_LEN] = '\0';
    cnt2 = split(ret[2], ret2, '-', 3);
    if (cnt2 == 3) { 
      PDS[PDN].birthday.y = atoi(ret2[0]);
      PDS[PDN].birthday.m = atoi(ret2[1]);
      PDS[PDN].birthday.d = atoi(ret2[2]);
      if (PDS[PDN].birthday.y > 9999 ||
	  PDS[PDN].birthday.y < 0    ||
	  PDS[PDN].birthday.m > 12   ||
	  PDS[PDN].birthday.m < 1    ||
	  PDS[PDN].birthday.d < 1    ||
	  PDS[PDN].birthday.d > 31) {
	fprintf(stderr,"inputed birthday data is inappropriate\n");
	cnt2 = 0;
      }
    } else if (cnt2 == 2 || cnt2 == 1) {
      fprintf(stderr,"inputed birthday data is inappropriate\n");
    } 
    strncpy(PDS[PDN].home, ret[3], MAX_STR_LEN);
    PDS[PDN].home[MAX_STR_LEN] ='\0';
    PDS[PDN].comment = (char*)malloc(sizeof(char*)*(strlen(ret[4])+1));
    strcpy(PDS[PDN].comment, ret[4]);
    profile_data_nitems++;
    if (cnt2 != 3 || strlen(ret[0]) > 8) {
      profile_data_nitems--;
      if (cnt2 == 2 || cnt2 == 1 ) { 
      fprintf(stderr,"correct birthday form example: 1000-10-10\n");
      }
    }
  } else {
    fprintf(stderr,"error: this input is wrong form\n");
    fprintf(stderr,"correct form : (ID),(name),(birthday),(home),(comment)\n");
  }
}

int split(char *str, char *ret[], char sep, int max)
{
  int cnt = 0;

  *(ret + (cnt++)) = str;

  while (*str && cnt < max) {
    if (*str == sep){
      *str = '\0';
      *(ret + (cnt++)) = str + 1;
    }
    str++;
  }
  
  return cnt; 
}

void cmd_quit() {
  int c;
  if (save == 0) {
    printf("you don't save date\n");
    printf("May I end this program? y or n\n");
    while((c = getchar()) == 'y' ||(c = getchar()) == 'n'){
      if (c = 'y') {
      exit(0);
      } else if (c = 'n') {
    } else
      printf("inputed character is wrong\n");
    }
  } else 
    exit(0);

    
}

void cmd_check() {
  printf("%d profile(s)\n",profile_data_nitems);
}

void cmd_print(int n) {
  int i;
  if (n > 0) {
    if ( n > profile_data_nitems ) {
      n = profile_data_nitems;
    }
    for( i = 0 ; i < n ; i++) { 
      print_profile(PDS + i);
    }
  } else if (n == 0) {
    for( i = 0 ; i < profile_data_nitems ; i++) { 
      print_profile(PDS + i);
    }
  } else if (n < 0 ) {
    if ( (-1) * n > profile_data_nitems) {
      n = (-1) * profile_data_nitems;
    } 
    for( i = profile_data_nitems + n ; i < profile_data_nitems ; i++) { 
      print_profile(PDS + i);
    }
  }
}

void cmd_read(char *file) {
  FILE *fp;
  char line[MAX_LINE_LEN + 1];

  fp = fopen(file, "r");

  if (fp == NULL) {
    fprintf(stderr,"Could not open file: $s\n", file);
  }
  while (get_line(fp, line)) {
    parse_line(line);
  }

  fclose(fp);
}  

void cmd_write(char *file) {
  int i;
  FILE *fp;

  fp = fopen(file, "w");

  if (fp == NULL) {
    fprintf(stderr,"Could not open file: $s\n", file);
  }
  for (i = 0; i < profile_data_nitems; i++) {
    fprint_profile_csv(fp, PDS+i);
  }
  fclose(fp);

  if (save == 0) {
    save = 1;
  }
} 

void cmd_find(char *word) {
  int i;
  for (i = 0; i < profile_data_nitems; i++) {
    if (comparsion(word, i) == 1) {
      print_profile(&profile_data_store[i]);
    }
  }
} 

void cmd_bsort(int n) {
  if(1 <= n && n <= 5) {
  b_sort(PDS, 0, profile_data_nitems - 1, n);
  } else 
    fprintf(stderr,"this argument is wrong. plese input 1,2,3,4,5\n");
} 

void cmd_qsort(int n) {
  if(1 <= n && n <= 5) {
  q_sort(PDS, 0, profile_data_nitems - 1, n);
  } else 
    fprintf(stderr,"this argument is wrong. plese input 1,2,3,4,5\n");
} 

void cmd_modify(int n) {
  if (n-1 < PDN && n > 0) {    
  char line[MAX_LINE_LEN + 1];
  get_line(stdin, line);
  
  char *ret[5];
  char *ret2[3];
  int cnt1, cnt2;
  
  cnt1 = split(line, ret, ',', MAX);
  if (cnt1 == 5){
    if (strlen(ret[0]) > 8) {
      fprintf(stderr,"ID max digits are 8\n");
    }
    PDS[n-1].id = atoi(ret[0]);
    strncpy(PDS[n-1].name, ret[1], MAX_STR_LEN);
    PDS[n-1].name[MAX_STR_LEN] = '\0';
    cnt2 = split(ret[2], ret2, '-', 3);
    if (cnt2 == 3) { 
      PDS[n-1].birthday.y = atoi(ret2[0]);
      PDS[n-1].birthday.m = atoi(ret2[1]);
      PDS[n-1].birthday.d = atoi(ret2[2]);
      if (PDS[n-1].birthday.y > 9999 ||
	  PDS[n-1].birthday.y < 0    ||
	  PDS[n-1].birthday.m > 12   ||
	  PDS[n-1].birthday.m < 1    ||
	  PDS[n-1].birthday.d < 1    ||
	  PDS[n-1].birthday.d > 31) {
	fprintf(stderr,"inputed birthday data is inappropriate\n");
	cnt2 = 0;
      }
    } else if (cnt2 == 2 || cnt2 == 1) {
      fprintf(stderr,"inputed birthday data is inappropriate\n");
    } 
    strncpy(PDS[n-1].home, ret[3], MAX_STR_LEN);
    PDS[n-1].home[MAX_STR_LEN] ='\0';
    PDS[n-1].comment = (char*)malloc(sizeof(char)*strlen(ret[4])+1);
    strcpy(PDS[n-1].comment, ret[4]);
      if (cnt2 == 2 || cnt2 == 1 ) { 
      fprintf(stderr,"correct birthday form example: 1000-10-10\n");
      }
  } else {
    fprintf(stderr,"error: this input is wrong form\n");
    fprintf(stderr,"correct form : (ID),(name),(birthday),(home),(comment)\n");
  }
  } else
    fprintf(stderr,"error: your inputed argument is not correct\n");
}

void cmd_delete(int n) {
  int i;
  if (n-1 < PDN && n > 0) {    
  printf("Number %d date deleted\n", n);
  
  for(i = 0;i < PDN - (n-1);i++) {
    swap(&PDS[n-1], &PDS[n]);
    n++;
  }
  PDN--;
  } else
    fprintf(stderr,"error: your inputed argument is not correct\n");
}

void cmd_find2(char *word) {
  int i;

  for (i = 0; i < profile_data_nitems; i++) {
    if (comparsion(word, i) == 1) {
      print_profile(&profile_data_store[i]);
      printf("this data is number %d from start\n",i+1);
    }
  }
} 

void cmd_Bwrite(char *line) {
  int length; /*profile_date_storeのcommentの文字数を保存する変数*/
  int i;
  int p; /*commentを格納する配列を初期化することに使用する変数*/
  char a[100+1]; /*commentを格納する配列　100文字まで格納可能*/
  FILE *fpw = fopen(line, "wb");

  fwrite(&PDN, sizeof(int), 1, fpw);
  for(i=0;i<PDN;i++){
  length = strlen(PDS[i].comment);
  fwrite(&length, sizeof(int), 1, fpw);
  fwrite(&PDS[i], sizeof(PDS[i]), 1, fpw);
  for(p=0;p<101;p++) { /*配列を初期化*/
    a[p] = '\0';
  }
  if(length > 100) {
    length = 100;
  }
  strncpy(a, PDS[i].comment, length);
  a[100] = '\0';
  fwrite(&a, sizeof(char), 100+1, fpw);
  }
  
  fclose(fpw);
 
} 

void cmd_Bread(char *line) {
  int length; /*profile_date_storeのcommentの文字数を保存する変数*/
  int i;
  int bdn; /*読み込んだバイナリファイル中のデータ数*/
  FILE *fpr = fopen(line, "rb");
  char a[100+1]; /*commentを格納する配列　100文字を想定*/
  
  fread(&bdn, sizeof(int), 1, fpr);
  bdn = bdn + PDN;
  for(i=PDN;i<bdn;i++) {
  fread(&length, sizeof(int), 1, fpr);
  fread(&PDS[i], sizeof(PDS[i]), 1, fpr);
  PDS[i].comment = NULL; 
  fread(&a, sizeof(char), 100+1, fpr);
  PDS[i].comment = (char*)malloc(sizeof(char*)*length+1);
  strcpy(PDS[i].comment, a);
  PDN++;
  }
  fclose(fpr);
  
  if (save == 0) { /*Quitコマンドで使用*/
    save = 1;
  }
}


void print_profile(struct profile *p) {
  printf("Id    : %d\n",p->id);
  printf("Name  : %s\n",p->name);
  printf("Birth : %04d-%02d-%02d\n",p->birthday.y,p->birthday.m,p->birthday.d);
  printf("Addr  : %s\n",p->home);
  printf("Com.  : %s\n",p->comment);
  printf("\n");
}

void fprint_profile_csv(FILE *fp, struct profile *p) {
  fprintf(fp,"%d,",p->id);
  fprintf(fp,"%s,",p->name);
  fprintf(fp,"%d-%d-%d,",p->birthday.y,p->birthday.m,p->birthday.d);
  fprintf(fp,"%s,",p->home);
  fprintf(fp,"%s\n",p->comment);
    
}

char *date_to_string(char buf[], struct date *date)
{
  sprintf(buf, "%04d-%02d-%02d", date->y, date->m, date->d);
  return buf;
}

int comparsion (char *word, int i) {
  char buf[8 + 1]; /* IDは8桁と制限しているため8+1としている*/
  char birthday_str[10 + 1]; /*birthdayは"-"を含めて10桁になるよう制限しているため*/
  
  sprintf(buf, "%d", PDS[i].id);
  if (strcmp(PDS[i].name, word)    == 0  ||
      strcmp(PDS[i].home, word)    == 0  ||
      strcmp(PDS[i].comment, word) == 0  ||
      strcmp(buf, word)         == 0  ||
      strcmp(date_to_string(birthday_str, &PDS[i].birthday), word) ==0) {
    return 1;
  } else 
    return 0;
}

int compare_profile(struct profile *p1, struct profile *p2, int column) {
  switch (column) {
  case 1:
    return p1->id - p2->id;
  case 2:
    return strcmp(p1->name, p2->name);
  case 3:
    if (p1->birthday.y != p2->birthday.y) return p1->birthday.y - p2->birthday.y;
    if (p1->birthday.m != p2->birthday.m) return p1->birthday.m - p2->birthday.m;
    return p1->birthday.d - p2->birthday.d;
  case 4:
    return strcmp(p1->home, p2->home);
  case 5:
    return strcmp(p1->comment, p2->comment);
  
    
  }
}

void b_sort(struct profile *p, int left, int right, int column) {
  int i, j;

  for (i = left; i <= right; i++) {
    for (j = left; j <= right - 1; j++) {
      if ((compare_profile(p+j, p+j+1, column)) > 0) {
	  swap(&p[j], &p[j + 1]);
      }
    }
  }
}

void swap(struct profile *a, struct profile *b) {
  struct profile temp;

  temp = *a;
  *a = *b;
  *b = temp;
}



void q_sort(struct profile *p, int left, int right, int column) {
  int i,j;
  int pivot;
  pivot = (left + right) / 2;
  
  i = left;
  j = right;

  while(1) {
    while ((compare_profile(p+pivot, p+i, column)) > 0) {
      i++;
    }
    while ((compare_profile(p+j, p+pivot, column)) > 0) {
      j--;
    }
      if (i <= j) {
        break;
      }
    swap(&p[i], &p[j]);
    i++;
    j--;
  }
    q_sort(p,left, j, column);
    q_sort(p, i, right, column);
}
 
