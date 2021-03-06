#include<stdio.h>

int quicksort(int a[], int l, int r){
  int v,i,j,t;
  int ii;
  
  if (r > l){
    v = a[r]; i = l - 1; j = r;
    for(;;){
      while(a[++i] < v) ;
      while(a[--j] > v);
      if (i >= j) break;
      t = a[i]; a[i] = a[j]; a[j] = t;
    }	
    t = a[i]; a[i] = a[r]; a[r] = t;
    
    quicksort(a, l, i-1);
    quicksort(a, i+1, r);
    }
}

int main(){
    int data[10];
    int i;
    data[0] = 10;
    data[1] = 4;
    data[2] = 2;
    data[3] = 7;
    data[4] = 3;
    data[5] = 5;
    data[6] = 9;
    data[7] = 10;
    data[8] = 1;
    data[9] = 8;

    quicksort(data, 0, 9);

    for(i=0;i<10;i++){
      printf("data[%d]: %d\n", i, data[i]);
    }
}
