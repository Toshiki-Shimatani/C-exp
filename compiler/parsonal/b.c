int arg(int a[10],int b[],int c){
  return a[2];
}

int main(){
  int a[100];
  int b[2];
  int c=5;
  a[0]=8;
  b[0]=2;
  b[1]=1;
  arg(a,b,c);
  return;
}


