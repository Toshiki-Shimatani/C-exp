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
  
  recv(new_s,&buf,CHAR_NUM,0);
  //printf("%c\n",c-32);
	//}
      //}
  if(buf[0]=='e'||buf[0]=='E')if(buf[1]=='x'||buf[1]=='X')if(buf[2]=='i'||buf[2]=='I')if(buf[3]=='t'||buf[3]=='T'){
	    printf("bye\n");
	    close(new_s);
	    close(s); 
	    break;
	  }
	  
  for(i=0;i<CHAR_NUM+2;i++){
    if(97<=buf[i] && buf[i]<=122){
      buf[i] = buf[i] - 32;
    }
    if(buf[i]=='\r'){
      if(buf[i+1]=='\n'){
	break;
      }
    }
    else ;
  }
    

      
      send(new_s,&buf,strlen(buf),0);/*
    if(send(new_s,&c,1,0)==-1){
      close(new_s);
      fprintf(stderr,"Error: Send Failed.\n");
      exit(6);
      
      }*/
  /*close(new_s);
    close(s);*/
    //  }
   }
}

