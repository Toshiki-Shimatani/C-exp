/*
  課題１　標準入力から読み込んだ文字列を，ファイルに書き出すプログラムの作成
*/
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

#define CHAR_NUM 10
//TODO コマンド引数のチェック
int main(int argc, char *argv[]){
  int fd,i,n=0;
  char buf[CHAR_NUM];

  read(0, buf, CHAR_NUM);
  // characters check
  for(i=0;i<CHAR_NUM;i++){
    n++;
    if(buf[i] == '\n'|| buf[i] == '\0') break;
  }
  fd = open(argv[1], O_RDWR|O_CREAT|O_TRUNC, S_IRWXU);
  //file error check
  if(fd == -1){
    write(3, "Error: can't open file.\n", 24); 
  }
  else{
  write(fd, buf, n);
  if(n==10) write(fd, "\0", 1);
  }
  close(fd);
  
  
}
