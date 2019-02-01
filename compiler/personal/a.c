int func(int,int,int,int,int,int);
int func2(int,int,int,int,int,int,int,int,int);

int main(int argc, char argv[]){
  int a = argc;
  int b = 2;
  int c = 3;
  int d = 4;
  int e = 5;
  int f = 6;
  int g;
  int h;
  int i;
  int j;
  int ary[3];
  int aa;
  int ary2[4];
  ary[0]=0;
  ary[1]=5;
  ary[2]=10;
  aa = 100;
  ary2[0]=0;
  func(a,a,a,a,a,a);
  
  g = func(a,b,c,d,f,e);
  func2(a,a,a,a,a,a,a,a,a);
  return 0;

}

int func(int a,int b,int c,int d,int e,int f){
  int sum;
  sum = a + b + c + d + e + f;
  return sum;
}

int func2(int a,int b,int c,int d,int e,int f,int g,int h,int i){
  return 0;
}
