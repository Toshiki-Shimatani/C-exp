/*
  標準入力から読み込んだ文字列を標準出力に出力するプログラムの作成
*/
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

#define CHAR_NUM 10

int main(int argc, char *argv[]){
  
  int fd,i,n=0;
  char buf[CHAR_NUM];
  
  read(0, buf, CHAR_NUM);
  // characters check
  for(i=0;i<CHAR_NUM;i++){
    n++;
    if(buf[i] == '\n'|| buf[i] == '\0') break;
  }

  write(1, buf, i);
  printf("\n");
  
}

