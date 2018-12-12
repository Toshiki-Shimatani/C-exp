#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<stdio.h>
#include<netdb.h>
#include<string.h>
#include<stdlib.h>
#include <arpa/inet.h>

#define PORT_NO 2018
#define CHAR_NUM 300

int main(int argc, char* argv[]){
  int s, i, len, size;
  char c;
  char buf[CHAR_NUM]={0};
  struct sockaddr_in sa;
  struct hostent *hp;
  
  if((hp = gethostbyname(argv[1]))==0){
    fprintf(stderr,"Error: Unknwon host.\n");
    exit(1);
  }

  if((s = socket(AF_INET, SOCK_STREAM, 0))==-1){
    fprintf(stderr,"Error: Can't open socket.\n");
    exit(1);
  }

  sa.sin_family = AF_INET;
  sa.sin_port = htons(PORT_NO);
  
  bzero((char *)&sa.sin_addr, sizeof(sa.sin_addr));
  
  memcpy((char *)&sa.sin_addr,(char *)hp->h_addr,hp->h_length);
  if(connect(s, (struct sockaddr*)&sa, sizeof(struct sockaddr_in))==-1){
    fprintf(stderr,"Error: Can't connect socket with host.\n");
    exit(1);
  }
  char buf2[CHAR_NUM]={0};
  scanf("%[^\n]",&buf2);
  if(send(s, buf2, strlen(buf2)+1, 0)==-1){
    close(s);
    fprintf(stderr,"Error: Failed sending message.\n");
    exit(1);
  }
  send(s, "\r\n",2,0);

  recv(s, buf, strlen(buf2), 0);

  printf("%s\n",buf);

  close(s);
}
