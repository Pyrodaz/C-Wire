#ifndef CREATION_H
#define CREATION_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX 300 


typedef struct {
    long int id;
    long int capacity;
    long int load;
} Station;

typedef struct _tree{
    Station station;
    struct _tree* pLeft;
    struct _tree* pRight;
    int balance;
} Tree;
 
int min2(int a, int b);
int max2(int a, int b);
int min3(int a, int b, int c);
int max3(int a, int b, int c);
Tree* createAVL(Station station);
Tree* rotateLeft(Tree* pRoot);
Tree* rotateRight(Tree* pRoot);
Tree* doubleRotateLeft(Tree* pRoot);
Tree* doubleRotateRight(Tree* pRoot);
Tree* balanceAVL(Tree* pRoot);
Tree* insertAVL(Tree* pTree, Station station, int* h);
Tree* freeAVL(Tree* pTree);
void infix_write(Tree* pTree, FILE* file);


#endif 