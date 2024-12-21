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
 
int min2(int a, int b); //Calculate the minimum between 2 numbers
int max2(int a, int b); //Calculate the maximum between 2 numbers
int min3(int a, int b, int c); //Calculate the minimum between 3 numbers
int max3(int a, int b, int c); //Calculate the minimum between 3 numbers
Tree* createAVL(Station station); //Create an AVL Tree
Tree* rotateLeft(Tree* pRoot); //Rotate the tree to the left to balance the AVL tree with pRoot's right son as pivot
Tree* rotateRight(Tree* pRoot);//Rotate the tree to the right to balance the AVL tree with pRoot's left son as pivot
Tree* doubleRotateLeft(Tree* pRoot); //Rotate the tree to the right than the left to balance the AVL tree
Tree* doubleRotateRight(Tree* pRoot); //Rotate the tree to the left than the right to balance the AVL tree
Tree* balanceAVL(Tree* pRoot); //Use the rotation to balance the AVL tree
Tree* insertAVL(Tree* pTree, Station station, int* h); //Insert a station into a AVL tree with a pointer on its root pTree
Tree* freeAVL(Tree* pTree); //Free the memory which is taken by an AVL tree recursively
void infix_write(Tree* pTree, FILE* file); //Write the data in the station of the AVL tree in a csv file


#endif 