#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<stdio.h>
#include<netdb.h>
#include<string.h>
#include<stdlib.h>
#include <arpa/inet.h>
#include <sys/time.h>
#include <netinet/in.h>

#define PORT_NO 2018
#define BUFSIZE 1024

int main(int argc, char* argv[]){
  int s, i=0, len, size, n;
  char recv_buf[BUFSIZE]={0};  /* 受信バッファ                  */
  char send_buf[BUFSIZE+3]={0};  /* 送信バッファ                  */
  struct sockaddr_in sa;
  struct hostent *hp;   
  struct timeval tv;    /* selectのタイムアウト時間       */
  fd_set readfd;        /* selectで検出するディスクリプタ  */

  if((hp = gethostbyname(argv[1]))==0){
    fprintf(stderr,"Error: Unknwon host.\n");
    exit(1);
  }

  sa.sin_family = AF_INET;
  sa.sin_port = htons(PORT_NO);
  
  bzero((char *)&sa.sin_addr, sizeof(sa.sin_addr));
  
  memcpy((char *)&sa.sin_addr,(char *)hp->h_addr,hp->h_length);

  if((s = socket(AF_INET, SOCK_STREAM, 0))==-1){
    fprintf(stderr,"Error: Can't open socket.\n");
    exit(1);
  }
  if(connect(s, (struct sockaddr*)&sa, sizeof(struct sockaddr_in))==-1){
    fprintf(stderr,"Error: Can't connect socket with host.\n");
    exit(1);
  }

  printf("connected to '%s'\n", inet_ntoa(sa.sin_addr));

  /* client processing routine */
  while(1){
    //bzero(send_buf,strlen(send_buf));
    //bzero(recv_buf,strlen(recv_buf));
    tv.tv_sec = 600;
    tv.tv_usec = 0;

    FD_ZERO(&readfd);
    FD_SET(0,&readfd);
    FD_SET(s,&readfd);
    if((select(s+1, &readfd, NULL, NULL, &tv))<=0){
      fprintf(stderr, "\nTimeout\n");
      break;
    }

    /* standard input */
    if(FD_ISSET(0, &readfd)){
      if((n = read(0, recv_buf, BUFSIZE-1))<= 0) break;
      recv_buf[n]='\0';
      sscanf(recv_buf, "%s", send_buf);
      if(strcmp(send_buf, "%Q") == 0 ||
	 strcmp(send_buf, "%q") == 0) {
	printf("Bye.\n");
	break;
      }
      if(send(s, recv_buf, n, 0) <= 0) break;
    }

    /* server */
    if (FD_ISSET(s, &readfd)){
      //recv(s,recv_buf,2,0);
      //printf("%s",recv_buf);
      //bzero(recv_buf,BUFSIZE);
      if ((n = recv(s, recv_buf, (BUFSIZE+3)-1, 0)) < 0){
	fprintf(stderr, "Error: connection closed. \n");
	exit(EXIT_FAILURE);
      }
      recv_buf[n]='\0';
      printf("%s",recv_buf);
      fflush(stdout);
    }
  }
  bzero(send_buf, BUFSIZE);
  strncpy(send_buf, "%Q", 2);
  send(s, send_buf, n, 0);
  close(s);

  return EXIT_SUCCESS;
}


/*
  while(1){
    bzero(buf2, sizeof(buf2));
    recv(s,buf2,5,0);
    printf("%s",buf2);
    bzero(buf2, sizeof(buf2));
    scanf("%[^\n]",&buf2);
    i=send(s, buf2, strlen(buf2)+1, 0);
    if(i==-1){
      close(s);
      fprintf(stderr,"Error: Failed sending message.\n");
      exit(1);
    }
    send(s, "\r\n",2,0);
       
    recv(s, buf, strlen(buf2), 0);
    
    printf("%s\n",buf);
  }
}*/
  
