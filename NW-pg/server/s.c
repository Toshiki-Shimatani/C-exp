#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<stdio.h>
#include<netdb.h>
#include<string.h>
#include<stdlib.h>
#include<arpa/inet.h>
#include<sys/time.h>
#include<netinet/in.h>
#include<unistd.h>

#define PORT_NO 2018
#define BUFSIZE 1024+1
#define MAX_STR_LEN 70 /*構造体メンバnameとhomeの最大文字数*/
#define MAX_SPLIT 5 /*split関数での最大分割数*/
#define PDS profile_data_store
#define PDN profile_data_nitems

struct date {
  int y;
  int m;
  int d;
};

struct profile {
  int id;
  char name[MAX_STR_LEN];
  struct date birthday;
  char home[MAX_STR_LEN];
  char *comment;
};

typedef enum {
  QUITE,
  CHECK,
  PRINT,
  SERVER_WRITE,
  SERVER_READ,
  WRITE,
  READ,
  LINUX_ls,
  LINUX_fd,
  UNKNOWN
} Command;

struct profile profile_data_store[10000]; /*10000件のデータまで登録可能*/
int profile_data_nitems = 0; /*登録したデータ数*/
int save = 0; /* データを保存したかどうかの判定に使用 */
/*************************************************************************/
void parse_line(char* cmd1, char* cmd2, int socket);
void exec_command(char* cmd1, char* cmd2, int socket);  /* 基本関数 */
void new_profile(char* profile, int socket);
int split(char *str, char *ret[], char sep, int max);
void cmd_quit();                 /************************************/ 
void cmd_check(int socket);
void cmd_print(int n, int socket);
void cmd_read(int socket);
void cmd_write(int socket);
void cmd_serv_read(char *file, int socket);
void cmd_serv_write(char *file, int socket);/*          コマンド関数           */
void cmd_find(char *word);
void cmd_bsort(int n);
void cmd_qsort(int n);
void cmd_modify(int n);
void cmd_delete(int n);
void cmd_find2(char *word);
void cmd_Bwrite(char *line);
void cmd_Bread(char *line);     /************************************/
void cmd_ls(int socket);
void print_profile(struct profile *p, int socket);
void fprint_profile_csv(FILE *fp, struct profile *p);
int execute(char *command, char *buf, int bufmax);
int decide_cmd(char *cmd);
int get_line(FILE *fp,char *line);
int subst(char *str, char c1, char c2);
/*************************************************************************/

int recv_msg_exe(char* recv_buf, int socket);

int main(void){
  int s,new_s; /* socket */
  int i; /* loop counter */
  int len,len_c;
  int sn,cn,rn;
  int n;
  int pid; /* fork */
  struct sockaddr_in sa,sa_c;
  char c;
  //char cmd1[BUFSIZE];
  //char cmd2[BUFSIZE];  
  char send_buf[BUFSIZE];
  char recv_buf[BUFSIZE];
  
  if((s = socket(AF_INET, SOCK_STREAM, 0)) < 0){
    fprintf(stderr,"Error: Can't open socket.\n");
    exit(1);
  }
  
  memset((char*)&sa,0,sizeof(sa));
  sa.sin_family = AF_INET;
  sa.sin_port = htons(PORT_NO);
  sa.sin_addr.s_addr=htonl(INADDR_ANY);

  if(bind(s,(struct sockaddr*)&sa,sizeof(sa)) < 0){
    fprintf(stderr,"Error: Failed Binding stream socket server\n");
    close(s);
    exit(2);
  }
  
  printf("Socket Port %d\n", ntohs(sa.sin_port));

  if(listen(s,5)==-1){
    fprintf(stderr,"Error: Listen Failed.\n");
    exit(3);
  }
  while(1){ 
    len_c = sizeof(sa_c);
    new_s = accept(s,(struct sockaddr*)&sa_c,&len_c);
    if(new_s==-1){
      fprintf(stderr,"Error: Accept Failed.\n");
      exit(4);
    }
    pid = fork();
    if(pid==0){
      close(s);
	/* サーバ処理メインルーチン */
	while(1){
	  i = 0; /* 受信文字のカウント */
	  //bzero(send_buf,strlen(send_buf));
	  
	  sn = sprintf(send_buf, "< ");
	  send(new_s, send_buf, sn, 0);
	  
	receive: /* ストリーム型のデータの受信処理 */  
	  if(rn = recv(new_s,&recv_buf[i],1,0) < 0) break;
	  /* 改行単位で受信処理をする */
	  if (recv_buf[i] != '\n') {
	    i++;
	    if (i < BUFSIZE - 1)
	      goto receive;
	  }
	  recv_buf[i] = '\0';
	  //printf("receive '%s'\n", recv_buf);
	  rn = i;
	  //bzero(cmd1,BUFSIZE);
	  //bzero(cmd2,BUFSIZE);
	  if((recv_msg_exe(recv_buf, new_s))<=0) break;
	  bzero(recv_buf,BUFSIZE);
	  /* 受信コマンドの処理 */
	}
      printf("connection closed.\n");
      //bzero(send_buf,BUFSIZE);
      //bzero(recv_buf,BUFSIZE);
      close(new_s);
      _exit(0);
    }else {
      close(new_s);
    }
  }
  close(s);
  return EXIT_SUCCESS;
}
  
int recv_msg_exe(char* recv_buf, int socket){ 
  int cn;
  char send_buf[BUFSIZE];
  char cmd1[BUFSIZE];
  char cmd2[BUFSIZE];

  bzero(cmd1,BUFSIZE);
  bzero(cmd2,BUFSIZE);
  bzero(send_buf,BUFSIZE);

  //if ((cn = sscanf(recv_buf, "%s%s", cmd1, cmd2)) <= 0){
  if (*recv_buf == '%'){
    if ((cn = sscanf(recv_buf, "%s%s", cmd1, cmd2)) <= 0){
      fprintf(stderr,"Input Error\n");
      send(socket, "> Input Error\n",14,0);
      return 2;
    }else if(cn == 1){
      if(strcmp(cmd1, "%Q") == 0) {
	printf("exec %Q command.\n");
	return 0;
	//return 0; /* 0 以下の値を返すと呼び出し側で break文が実行される */
      }else{
	*cmd2 = 0;
	parse_line(cmd1, cmd2, socket);
	return 1;
      }
    }else if(cn == 2){
      parse_line(cmd1, cmd2, socket);
      return 1;
    }
  } else {
    parse_line(recv_buf, NULL, socket);
    return 1;
  }
}

void parse_line(char* cmd1, char* cmd2, int socket){
    if(*cmd1 == '%'){
      exec_command(cmd1, cmd2, socket);
    }else {
      if (profile_data_nitems < 10000 ) {
	new_profile(cmd1, socket);
      }
    }
}


void exec_command(char* cmd1, char* cmd2, int socket){
 Command cmd = decide_cmd(cmd1);
    switch(cmd) {
    case CHECK :  cmd_check(socket); break;
    case PRINT : 
      if(cmd2 == NULL) {
	cmd_print(0,socket);
      }else{
	cmd_print(atoi(cmd2),socket); 
      } break;
    case READ  : cmd_read(socket); break;
    case WRITE : cmd_write(socket); break;
    case SERVER_READ : cmd_serv_read(cmd2,socket); break;
    case SERVER_WRITE :  cmd_serv_write(cmd2, socket); break;
    case LINUX_ls : cmd_ls(socket); break;
    default:
      fprintf(stderr, "%s command is undefined \n", cmd1);
      break;
    }
}

void new_profile(char* profile, int socket){
  char send_buf[BUFSIZE] = {};
  char *ret[5];
  char *ret2[3];
  int cnt1, cnt2;
  int err_flag = 0;
  
  cnt1 = split(profile, ret, ',', MAX_SPLIT);
  if (cnt1 == 5){
    //printf("%s\n",ret[0]);
    //printf("%s\n",ret[1]);
    //printf("%s\n",ret[2]);
    //printf("%s\n",ret[3]);
    //printf("%s\n",ret[4]);
    if (strlen(ret[0]) > 8) {
      err_flag = 1;
      strcat(send_buf, "> ID max digits are 8.\n");
      //send(socket, send_buf, strlen(send_buf) , 0);
      //fprintf(stderr,"ID max digits are 8\n");
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
	if(err_flag == 1) strcat(send_buf, "  ");
	else strcat(send_buf,"> ");
	err_flag = 1;
	strcat(send_buf, "inputed birthday data is inappropriate.\n");
	//send(socket, "inputed birthday data is inappropriate.\n", 40,0);
	//fprintf(stderr,"inputed birthday data is inappropriate\n");
	cnt2 = 0;
      }
    } else if (cnt2 == 2 || cnt2 == 1) {
      if(err_flag == 1) strcat(send_buf, "  ");
      else strcat(send_buf,"> ");
      err_flag = 1;
      strcat(send_buf, "inputed birthday data is inappropriate.\n");
      //send(socket, "inputed birthday data is inappropriate.\n", 40, 0);
      //fprintf(stderr,"inputed birthday data is inappropriate\n");
    } 
    strncpy(PDS[PDN].home, ret[3], MAX_STR_LEN);
    PDS[PDN].home[MAX_STR_LEN] ='\0';
    PDS[PDN].comment = (char*)malloc(sizeof(char*)*(strlen(ret[4])+1));
    ret[4][strlen(ret[4])-1]='\n';
    strcpy(PDS[PDN].comment, ret[4]);
    profile_data_nitems++;
    if (cnt2 != 3 || strlen(ret[0]) > 8) {
      profile_data_nitems--;
      if (cnt2 == 2 || cnt2 == 1 ) {
	if(err_flag == 1) strcat(send_buf, "  ");
	else strcat(send_buf,"> ");
	err_flag = 1;
	strcat(send_buf, "correct birtday form example: 2018-01-01\n");
      }
    }
    send(socket, send_buf,strlen(send_buf),0);
  } else {
    strcat(send_buf,"> ");
    strcat(send_buf,"error: this input is wrong form.\n  ");
    strcat(send_buf,"correct form : (ID),(name),(birthday),(home),(comment)\n  ");
    strcat(send_buf,"             : %(command) (argument)\n  ");
    strcat(send_buf,"example: 09428500,Okayama Taro,1998-01-01,okayama,good student\n  ");
    strcat(send_buf,"       : %C\n");
   
    send(socket, send_buf, strlen(send_buf), 0);
      }
}

int split(char *str, char *ret[], char sep, int max){
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

void cmd_check(int socket) {
  char send_buf[BUFSIZE]={0};
  
  sprintf(send_buf,"> %d profile(s)\n",profile_data_nitems);
  send(socket, send_buf, strlen(send_buf),0);
  printf("%d profile(s)\n",profile_data_nitems);
}


void cmd_print(int n, int socket) {
  int i;
  if (n > 0) {
    if ( n > profile_data_nitems ) {
      n = profile_data_nitems;
    }
    for( i = 0 ; i < n ; i++) { 
      print_profile(PDS + i, socket);
    }
  } else if (n == 0) {
    for( i = 0 ; i < profile_data_nitems ; i++) { 
      print_profile(PDS + i, socket);
    }
  } else if (n < 0 ) {
    if ( (-1) * n > profile_data_nitems) {
      n = (-1) * profile_data_nitems;
    } 
    for( i = profile_data_nitems + n ; i < profile_data_nitems ; i++) { 
      print_profile(PDS + i, socket);
    }
  }
}

void print_profile(struct profile *p, int socket) {
  char send_buf[BUFSIZE] = {};
  char tmp_buf[BUFSIZE] = {};
  sprintf(tmp_buf,"Id    : %d\n",p->id);
  strcat(send_buf,tmp_buf);
  bzero(tmp_buf, BUFSIZE);
  sprintf(tmp_buf,"Name  : %s\n",p->name);
  strcat(send_buf,tmp_buf);
  bzero(tmp_buf, BUFSIZE);
  sprintf(tmp_buf,"Birth : %04d-%02d-%02d\n",p->birthday.y,p->birthday.m,p->birthday.d);
  strcat(send_buf,tmp_buf);
  bzero(tmp_buf, BUFSIZE);
  sprintf(tmp_buf,"Addr  : %s\n",p->home);
  strcat(send_buf,tmp_buf);
  bzero(tmp_buf, BUFSIZE);
  sprintf(tmp_buf,"Com.  : %s\n",p->comment);
  strcat(send_buf, tmp_buf);
  send(socket, send_buf, strlen(send_buf), 0);
}

void cmd_read(int socket){
  char recv_buf[BUFSIZE+1]={0};
  struct timeval tv;
  fd_set readfd;
  tv.tv_sec = 1;
  tv.tv_usec = 0;
  
  FD_ZERO(&readfd);
  FD_SET(socket,&readfd);

  send(socket," ",1,0);
  
  while(1){
    if((select(socket+1, &readfd, NULL, NULL, &tv))<=0){
      save = 1;
      break;
    }
    recv(socket,recv_buf,BUFSIZE+1,0);
    //if(strcmp(recv_buf,"%Q")==0) break;
    if (profile_data_nitems < 10000 ) {
      new_profile(recv_buf, socket);
    }
    send(socket," ",1,0);
  }
}

void cmd_write(int socket){
  int i;
  char ack[2]={0};
  FILE *fp,*tmp_fp;
  char tmp_file[22]={"server_file/.tmp.csv"};
  char send_buf[BUFSIZE+1]={0};

  tmp_fp = fopen(tmp_file,"w");
  for (i = 0; i < profile_data_nitems; i++) {
   fprint_profile_csv(tmp_fp, PDS+i);
  }
  fclose(tmp_fp);
  fp = fopen(tmp_file,"r");
  
  send(socket," ",1,0);
  while(1){
    while(1){
      if(recv(socket,ack,1,0)>0) break;
    }
    if(fgets(send_buf,BUFSIZE+1,fp)==NULL) {
      send(socket,"\0",1,0);
      break;
    }
    send(socket,send_buf,strlen(send_buf),0);
    bzero(send_buf,BUFSIZE);
  }
}

void cmd_serv_read(char *file, int socket){
  FILE *fp;
  char line[BUFSIZE];
  char filename[BUFSIZE+12]={"server_file/"};
  char send_buf[BUFSIZE]={0};

  if(strchr(file,'/')!=NULL){
    sprintf(send_buf,"This file-name is including invalid character '/' : %s\n", file);
    send(socket,send_buf,strlen(send_buf),0);
    return;
  }
  strcat(filename,file);
  fp = fopen(filename, "r");

  if (fp == NULL) {
   sprintf(send_buf,"Could not open file: %s\n", file);
    send(socket,send_buf,strlen(send_buf),0);
    fclose(fp);
    return;
  }

  
  while (get_line(fp, line)) {
    parse_line(line,NULL,socket);
  }

  fclose(fp);
}  

void cmd_serv_write(char *file, int socket) {
  int i,pms;
  FILE *fp;
  char send_buf[BUFSIZE]={0};
  char filename[BUFSIZE+12]={"server_file/"};
  
  if(strchr(file,'/')!=NULL){
    sprintf(send_buf,"This file-name is including invalid character '/' : %s\n", file);
    send(socket,send_buf,strlen(send_buf),0);
    return;
  }
  strcat(filename,file);
  if(access(filename,F_OK)==0){
    if(access(filename,W_OK)==-1){
      sprintf(send_buf,"Could not write file: %s\n", file);
      send(socket,send_buf,strlen(send_buf),0);
      return;
    }
  }
    fp = fopen(filename, "w");

  if (fp == NULL) {
    sprintf(send_buf,"Could not open file: %s\n", file);
    send(socket,send_buf,strlen(send_buf),0);
    fclose(fp);
    return;
  }
  for (i = 0; i < profile_data_nitems; i++) {
   fprint_profile_csv(fp, PDS+i);
  }
  fclose(fp);

} 

void fprint_profile_csv(FILE *fp, struct profile *p) {
  fprintf(fp,"%d,",p->id);
  fprintf(fp,"%s,",p->name);
  fprintf(fp,"%d-%d-%d,",p->birthday.y,p->birthday.m,p->birthday.d);
  fprintf(fp,"%s,",p->home);
  fprintf(fp,"%s",p->comment);
    
}

void cmd_ls(int socket){
  char send_buf[BUFSIZE]={0};
  int sn;
  
  sn = execute("/bin/ls ./server_file", send_buf, BUFSIZE);
  send(socket, send_buf, sn , 0);
  
}

int execute(char *cmd, char *buf, int bufmax)
{
  FILE *fp; // ファイルポインタ         
  int i;    // 入力したデータのバイト数 

  if ((fp = popen(cmd, "r")) == NULL) {
    perror(cmd);
    i = sprintf(buf, "server error: '%s' cannot execute.\n", cmd);
  } else {
    i = 0;
    while ((buf[i] = fgetc(fp)) != EOF && i < bufmax - 1)
      i++;

    pclose(fp);
  }
  return i;
}

int decide_cmd(char *cmd){
  if((strcmp(cmd,"%C") == 0) || (strcmp(cmd,"%c") == 0)) return CHECK;
  else if((strcmp(cmd,"%W") == 0) || (strcmp(cmd,"%w") == 0)) return WRITE;
  else if((strcmp(cmd,"%R") == 0) || (strcmp(cmd,"%r") == 0)) return READ;
  else if((strcmp(cmd,"%P") == 0) || (strcmp(cmd,"%p") == 0)) return PRINT;
  else if((strcmp(cmd,"%LS")== 0) || (strcmp(cmd,"%ls")== 0)) return LINUX_ls;
  else if((strcmp(cmd,"%SW")== 0) || (strcmp(cmd,"%sw")== 0)) return SERVER_WRITE;
  else if((strcmp(cmd,"%SR")== 0) || (strcmp(cmd,"%sr")== 0)) return SERVER_READ;
  else return UNKNOWN;
  
}
int get_line(FILE *fp, char *line)
{
  if (fgets(line, BUFSIZE, fp) == '\0')
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
