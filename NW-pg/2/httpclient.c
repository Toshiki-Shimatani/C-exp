#include <unistd.h>
#include <netdb.h>
#include <sys/types.h>      
#include <sys/socket.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>

/*
  第一引数にホスト名，第二引数にファイル名を指定すると，そのファイルを受信し，表示するプログラム
  $ httpclient [host name] [filename]
 */
/** 
 *TODO：引数チェック
 */
#define PORT_NO 80
#define CHAR_NUM 65535

int main(int argc, char *argv[]){
  struct sockaddr_in sa;
  struct hostent *hp;

  char buf[CHAR_NUM] ={0};
  char c;
  int s,i;

  if(argc != 2){
    fprintf(stderr,"Error: Wrong number of arguments.\nPlese run in this format. => $ ./httpclient [host name/IP] [file name]\n");
    exit(1);
  }
//１．通信相手のIPアドレスの取得
  if((hp = gethostbyname(argv[1]))==0){
    fprintf(stderr,"Error: Unknwon host.\n");
    exit(1);
  }
//２．ソケットの作成
  if((s = socket(AF_INET, SOCK_STREAM, 0))==-1){
    fprintf(stderr,"Error: Can't open socket.\n");
    exit(1);
  }
//３．接続の確立
  sa.sin_family = hp->h_addrtype;
  sa.sin_port = htons(PORT_NO);
  bzero((char *)&sa.sin_addr, sizeof(sa.sin_addr));
  memcpy((char *)&sa.sin_addr,(char *)hp->h_addr,hp->h_length);
  if(connect(s, (struct sockaddr*)&sa, sizeof(struct sockaddr_in))==-1){
    fprintf(stderr,"Error: Can't connect socket with host.\n");
    exit(1);
  }
//４．要求メッセージを送信
  send(s, "GET ", 4,0);
  if(send(s, argv[2], strlen(argv[2])+1, 0)==-1){
    close(s);
    fprintf(stderr,"Error: Failed sending message.\n");
    exit(1);
  }
  send(s, "\r\n",2,0);
//５．応答メッセージを受信
//６．応答メッセージを処理
  recv(s, buf, CHAR_NUM, 0);
  /*for(;;){
    if(recv(s,&c,1,0)==-1){
      close(s);
      fprintf(stderr,"Error: Failed receaving message. \n");
      exit(1);
    }
    if(c=='\0') break;
    else putchar(c);
    }*/
//６．応答メッセージを処理
  printf("%s\n",buf);
//７．ソケットの削除
 close(s);
}

// ./a.out www.edu.cs.okayama-u.ac.jp /index.html

