#include "myHeader.h"

void quicksort(int[], int, int);
int data[MAXNUM];


int main(int argc, char** argv){
    int i;

    for(i = 0; i < MAXNUM; i++){
      printf("Please input data for sorting\n");
      scanf("%d", &data[i]);
    }

    quicksort(data, 0, MAXNUM-1);
    for(i = 0; i < MAXNUM; i++){
        printf("%d ", data[i]);
    }

    return 0;
}
