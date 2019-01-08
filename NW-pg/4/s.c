#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<stdio.h>
#include<netdb.h>
#include<string.h>
#include<stdlib.h>

#define PORT_NO 2018
#define BUFSIZE 1024
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
void print_profile(struct profile *p, int socket);
/*************************************************************************/

int recv_msg_exe(char* recv_buf, int socket, int i);

int main(void){
  int s,new_s; /* socket */
  int i; /* loop counter */
  int len,len_c;
  int sn,cn,rn;
  int n;
  struct sockaddr_in sa,sa_c;
  char c;
  char cmd1[BUFSIZE];
  char cmd2[BUFSIZE];  
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
    
    /* サーバ処理メインルーチン */
    while(1){
      i = 0; /* 受信文字のカウント */
      //bzero(send_buf,strlen(send_buf));
      sn = sprintf(send_buf, "< ");
      send(new_s, send_buf, sn, 0);
      
    receive:  /* ストリーム型のデータの受信処理 */  
      if(rn = recv(new_s,&recv_buf[i],1,0) < 0) break;
      /* 改行単位で受信処理をする */
      if (recv_buf[i] != '\n') {
	i++;
        if (i < BUFSIZE - 1)
          goto receive;
      }
      recv_buf[i] = '\0';
      printf("receive '%s'\n", recv_buf);
      rn = i;
      bzero(cmd1,BUFSIZE);
      bzero(cmd2,BUFSIZE);
      if((recv_msg_exe(recv_buf, new_s, i))<=0) break;
      /* 受信コマンドの処理 */
      /*if ((cn = sscanf(recv_buf, "%s%s", cmd1, cmd2)) <= 0){
	fprintf(stderr,"Input Error\n");
	send(new_s, ">\n",2,0);
        continue;
	}
      else if(cn == 1) {
      if(strcmp(cmd1, "quit") == 0) {
	break;	
	//send_buf[0] = '\0';
	} else if(strcmp(cmd1,"quit") != 0)  {
	  for(i=0;i<BUFSIZE;i++){
	    if(97<=cmd1[i] && cmd1[i]<=122){
	      send_buf[i] = cmd1[i] - 32;
	    }
	    else if(cmd1[i]=='\n'){
		break;
	    }
	    else{
	      send_buf[i] = cmd1[i];
	    }
	  }
	}
      }
      
      send(new_s, "> ",2, 0); 
      if (send(new_s, send_buf, rn, 0) < 0){
	//send(new_s, "\n", 1,0);
        break;
      }
      send(new_s,"\n",1,0);
      printf("send '%s'\n", send_buf);
      }*/
    }
    printf("connection closed.\n");
    //bzero(send_buf,BUFSIZE);
    //bzero(recv_buf,BUFSIZE);
    close(new_s);
  }
  close(s);

  return EXIT_SUCCESS;
}

int recv_msg_exe(char* recv_buf, int socket, int i){ 
  int cn, rn;
  char send_buf[BUFSIZE];
  char cmd1[BUFSIZE];
  char cmd2[BUFSIZE];

  rn = i;
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
	parse_line(cmd1, NULL, socket);
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
  if(strlen(cmd1)-1 == 1){
    printf("1 char command\n");
    switch(*(cmd1+1)) {
    case 'C' : 
    case 'c' : cmd_check(socket); break;
    case 'P' :
    case 'p' : 
      if(cmd2 == NULL) {
	cmd_print(0,socket);
      }else{
	cmd_print(atoi(cmd2),socket); 
      }break;
    case 'R' :
    case 'r' : printf("cmd_read\n"); break;
    case 'W' : 
    case 'w' : printf("cmd_write\n"); break;
    default:
      fprintf(stderr, "%s command is undefined \n", cmd1);
      break;
    }
  }else if(strlen(cmd1)-1 == 2){
    printf("2 char command\n");
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
    printf("%s\n",ret[0]);
    printf("%s\n",ret[1]);
    printf("%s\n",ret[2]);
    printf("%s\n",ret[3]);
    printf("%s\n",ret[4]);
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
    strcpy(PDS[PDN].comment, ret[4]);
    profile_data_nitems++;
    if (cnt2 != 3 || strlen(ret[0]) > 8) {
      profile_data_nitems--;
      if (cnt2 == 2 || cnt2 == 1 ) {
	if(err_flag == 1) strcat(send_buf, "  ");
	else strcat(send_buf,"> ");
	err_flag = 1;
	strcat(send_buf, "correct birtday form example: 2018-01-01\n");
	//send(socket, "correct birtday form example: 2018-01-01\n",41,0); 
	//fprintf(stderr,"correct birthday form example: 2018-01-01\n");
      }
    }
    send(socket, send_buf,strlen(send_buf),0);
  } else {
    strcat(send_buf,"> ");
    strcat(send_buf,"error: this input is wrong form.\n  ");
    strcat(send_buf,"correct form : (ID),(name),(birthday),(home),(comment)\n  ");
    strcat(send_buf,"example: 09428500,Okayama Taro,1998-01-01,okayama,good student\n");
    send(socket, send_buf, strlen(send_buf), 0);
    /*    send(socket,"error: this input is wrong form.\n",33,0);
    send(socket,"correct form : (ID),(name),(birthday),(home),(comment)\n",55,0);
    send(socket,"example: 09428500,Okayama Taro,1998-01-01,okayama,good student\n",63,0);*/
    //fprintf(stderr,"error: this input is wrong form\n");
    //fprintf(stderr,"correct form : (ID),(name),(birthday),(home),(comment)\n");
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
  strcat(send_buf, "\n");
  send(socket, send_buf, strlen(send_buf), 0);
}




