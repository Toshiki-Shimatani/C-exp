#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<stdio.h>
#include<netdb.h>
#include<string.h>
#include<stdlib.h>

#define PORT_NO 2018
#define BUFSIZE 1024

int main(void){
  int s,new_s,i,len,len_c,sn,cn,rn;
  struct sockaddr_in sa,sa_c;
  char c;
  char cmd1[BUFSIZE];
  char cmd2[BUFSIZE];  
  char send_buf[BUFSIZE];
  char recv_buf[BUFSIZE];
  
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
      bzero(send_buf,strlen(send_buf));
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
      /* 受信コマンドの処理 */
      if ((cn = sscanf(recv_buf, "%s%s", cmd1, cmd2)) <= 0){
	fprintf(stderr,"Input Error\n");
	send(new_s, ">\n",2,0);
        continue;
      }
      else if(cn == 1) {
	if(strcmp(cmd1, "quit") == 0) 
	  break;	
	//send_buf[0] = '\0';
	if(strcmp(cmd1,"quit") != 0)  {
	  for(i=0;i<BUFSIZE+2;i++){
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
	send(new_s, "\n", 1,0);
        break;
      }
      send(new_s,"\n",1,0);
      printf("send '%s'\n", send_buf);
    }
     
    printf("connection closed.\n");
    bzero(send_buf,1024);
    bzero(recv_buf,1024);
    close(new_s);
  }
  close(s);

  return EXIT_SUCCESS;
}

    /*
    send(new_s,&buf,strlen(buf),0);
    bzero(buf, sizeof(buf));
    }
 
  }
  }*/
  
