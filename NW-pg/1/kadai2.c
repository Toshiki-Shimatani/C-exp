/*
  課題２　ファイルから読み込んだ内容を，標準出力に出力するプログラムの作成
*/
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

#define CHAR_NUM 10
// TODO  コマンド引数のチェック
int main(int argc, char *argv[]){
  int fd,i,n=0;
  char buf[CHAR_NUM];

    
  fd=open(argv[1], O_RDWR,S_IRWXU);
  //file error check
  if(fd == -1){
    write(3, "Error: can't open file.\n", 24); 
  }
  else{
  read(fd, buf, CHAR_NUM);
  // characters check
  for(i=0;i<CHAR_NUM;i++){
    if(buf[i]=='\n' || buf[i] == '\0') break;
  }
  write(1, buf, i);
  }
  close(fd);
  printf("\n");
}
