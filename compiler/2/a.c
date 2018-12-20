#include<stdio.h>
int a=1;
for(;;){
  if(a==4) break;
  a++;
 }
 
int main(){
  int i;
  for(i=0;i<5;3){
    if(i==4) printf("a");
    else if(i==3){printf("E");
    }
    else printf("d");
  }
  return 0;
}
