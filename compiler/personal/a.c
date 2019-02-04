#include<stdio.h>
int func(int a[]){
  a[0]=10;
  a[1]=20;
}

int main(){
  int a[2];
  a[0]=1;
  a[1]=2;
  printf("%d,%d\n",a[0],a[1]);
  func(a);
  printf("%d,%d\n",a[0],a[1]);
}
