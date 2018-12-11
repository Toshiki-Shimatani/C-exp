#include <unistd.h>
#include <netdb.h>
#include <sys/types.h>      
#include <sys/socket.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <arpa/inet.h>

/*
  第一引数にホスト名，第二引数にファイル名を指定すると，そのファイルを受信し，表示するプログラム
  $ httpclient [host name] [filename]
 */
/** 
 *TODO：引数チェック
 *TODO：プログラム作成
 */
#define PORT_NO 80
#define CHAR_NUM 65535

int main(int argc, char *argv[]){
  struct sockaddr_in sa;
  struct hostent *hp;

  char buf[CHAR_NUM];
  char buf2[256];
  int s,i;

//１．通信相手のIPアドレスの取得
  hp = gethostbyname(argv[1]);
//２．ソケットの作成
  s = socket(AF_INET, SOCK_STREAM, 0);
//３．接続の確立
  sa.sin_family = hp->h_addrtype;
  sa.sin_port = htons(PORT_NO);
  bzero((char *)&sa.sin_addr, sizeof(sa.sin_addr));
  memcpy((char *)&sa.sin_addr,(char *)hp->h_addr,hp->h_length);
  connect(s, (struct sockaddr*)&sa, sizeof(struct sockaddr_in));
//４．要求メッセージを送信
  printf("%s\n",argv[2]);
  printf("%d\n",strlen(argv[2]));
  //send(s, "GET ", 4,0);
  //send(s, argv[2], strlen(argv[2])+1, 0);
  char buf3[] = "GET /index.html\r\n";
  i = send(s, buf3, strlen(buf3), 0);
  //recv(s, buf, CHAR_NUM, 0);
  
  printf("%d",i);
  send(s, "\n", 1, 0);
//５．応答メッセージを受信
  recv(s, buf, CHAR_NUM, 0);
//６．応答メッセージを処理
  printf("%s\n",buf);
//７．ソケットの削除
 close(s);
}

// ./a.out www.edu.cs.okayama-u.ac.jp /index.html
