#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<stdio.h>
#include<netdb.h>
#include<string.h>
#include<stdlib.h>

#define PORT_NO 2018
#define CHAR_NUM 300

int main(void){
  int s,new_s,i,len,len_c;
  uint32_t v;
  struct sockaddr_in sa,sa_c;
  char c;
  
  if((s = socket(AF_INET, SOCK_STREAM, 0))==-1){
    fprintf(stderr,"Error: Can't open socket.\n");
    exit(1);
  }
  
  memset((char*)&sa,0,sizeof(sa));
  sa.sin_family = AF_INET;
  sa.sin_port = htons(PORT_NO);
  sa.sin_addr.s_addr=htonl(INADDR_ANY);

  if(bind(s,(struct sockaddr*)&sa,sizeof(sa))==-1){
    fprintf(stderr,"Error: Failed Binding stream socket server\n");
    close(s);
    exit(2);
  }
  
  printf("Socket Port %d\n", ntohs(sa.sin_port));

   for(;;){
  if(listen(s,5)==-1){
    fprintf(stderr,"Error: Listen Failed.\n");
    exit(3);
  }
  
  len_c = sizeof(sa_c);
  new_s = accept(s,(struct sockaddr*)&sa_c,&len_c);
  if(new_s==-1){
    fprintf(stderr,"Error: Accept Failed.\n");
    exit(4);
  }
  
  /*for(i=0;i<3;i++){
      if(recv(new_s,&c,1,0)==-1){
	close(new_s);
	fprintf(stderr,"Error: Receave Failed.\n");
	exit(5);
      }
      if(c=='\0') break;
      else {*/
  char buf[CHAR_NUM]={0};
  i=0;
  for(;;){

  recv(new_s,&c,1,0);
  if(c=='\n') break;
  if(c=='$') {
    printf("bye\n");
    close(new_s);
    close(s);
    goto end;
  }
  else i++;
  }    
  send(new_s,&i,sizeof(i),0);/*
    if(send(new_s,&c,1,0)==-1){
      close(new_s);
      fprintf(stderr,"Error: Send Failed.\n");
      exit(6);
      
      }*/
  /*close(new_s);
    close(s);*/
    //  }
   }
 end: ;
}

