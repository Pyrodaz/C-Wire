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



int min2(int a, int b){
    return a < b ? a:b;
}
int max2(int a, int b){
    return a > b ? a:b;
}

int min3(int a, int b, int c){
    return min2(a, min2(b,c));
}
int max3(int a, int b, int c){
    return max2(a,max2(b,c));
}


Tree* createAVL(Station station){
    Tree* pNew = malloc(sizeof(Tree));
    if(pNew == NULL){
        exit(10);
    }
    pNew->station = station;
    pNew->pLeft = NULL;
    pNew->pRight = NULL;
    pNew->balance = 0;

    return pNew;
}


Tree* rotateLeft(Tree* pRoot){
    if(pRoot == NULL || pRoot->pRight == NULL){
        exit(20);
    }
    //update pointers 
    Tree* pPivot = pRoot->pRight;
    pRoot->pRight = pPivot->pLeft;
    pPivot->pLeft = pRoot;
    //update balance values
    int eqa = pRoot->balance;
    int eqp = pPivot->balance;
    pRoot->balance = eqa - max2(eqp,0) - 1;
    pPivot->balance = min3(eqa-2,eqa + eqp-2, eqp-1); 
    
    return pPivot;
}


Tree* rotateRight(Tree* pRoot){
    if(pRoot == NULL || pRoot->pLeft == NULL){
        exit(30);
    }
    //update pointers 
    Tree* pPivot = pRoot->pLeft;
    pRoot->pLeft = pPivot->pRight;
    pPivot->pRight = pRoot;
    //update values
    int eqa = pRoot->balance;
    int eqp = pPivot->balance;
    pRoot->balance = eqa - min2(eqp,0) + 1;
    pPivot->balance = max3(eqa+2,eqa + eqp+2, eqp+1); 

    return pPivot;
    
}


Tree* doubleRotateLeft(Tree* pRoot){
    if(pRoot==NULL || pRoot->pRight == NULL){
        exit(40);
    }
    pRoot->pRight = rotateRight(pRoot->pRight);
    return rotateLeft(pRoot);
} 


Tree* doubleRotateRight(Tree* pRoot){
    if(pRoot==NULL || pRoot->pLeft == NULL){
        exit(50);
    }
    pRoot->pLeft = rotateLeft(pRoot->pLeft);
    return rotateRight(pRoot);
}


Tree* balanceAVL(Tree* pRoot){
    if(pRoot == NULL){
        exit(60);
    }
    if(pRoot->balance >= 2){
        if(pRoot->pRight == NULL){
            exit(70);
        }
        if(pRoot->pRight->balance >= 0){
            //SIMPLE LEFT
            pRoot = rotateLeft(pRoot);
        }
        else{
            //DOUBLE LEFT
            pRoot = doubleRotateLeft(pRoot);
        }
    }
    else if(pRoot-> balance <= -2){
        if(pRoot->pLeft == NULL){
            exit(80);
        }
        if(pRoot->pLeft->balance <= 0){
            //SIMPLE RIGHT
            pRoot = rotateRight(pRoot);
        }
        else{
            //DOUBLE RIGHT
            pRoot = doubleRotateRight(pRoot);
        }
    }
    return pRoot;
}


Tree* insertAVL(Tree* pTree, Station station, int* h){
    
    if(pTree == NULL){
        *h = 1;
        return createAVL(station);
    }
    else if(station.id < pTree->station.id){
        pTree->pLeft = insertAVL(pTree->pLeft, station, h);
        *h = -*h;
    }
    else if(station.id > pTree->station.id){
        pTree->pRight = insertAVL(pTree->pRight, station, h); 
    }
    else{
        *h = 0;
        pTree->station.load += station.load; // calcul noeud existe 
        return pTree;
    }
    if(*h != 0){
        pTree->balance = pTree->balance + *h;

        pTree = balanceAVL(pTree); 
        if(pTree->balance == 0){
            *h = 0;
        }
        else{
            *h = 1;
        }
    }
    return pTree;
}

/*void add_conso(Tree* pTree, Station station){

    if(pTree != NULL){
        
        if(pTree->station.id == station.id){
            pTree->station.load += station.load;
        }
        else if(pTree->station.id > station.id){
            add_conso(pTree->pLeft, station);
        }
        else{
            add_conso(pTree->pRight, station);
        }
    }
}*/

void freeAVL(Tree* pTree){
    if (pTree != NULL)
    {
        freeAVL(pTree->pLeft);
        freeAVL(pTree->pRight);
        free(pTree);
    }
}

void infix_write(Tree* pTree, FILE * file){
	if (pTree !=NULL ){
		infix_write(pTree->pLeft, file);
        fprintf(file, "%ld:%ld:%ld\n" ,pTree->station.id, pTree->station.capacity, pTree->station.load);
		infix_write(pTree->pRight, file);
	}
}

int main(int argc, char** argv){ 
    // ./exe nomFichier.csv nomFichierRetour.csv
    

    if (argc != 3 || argv == NULL || argv[1] == NULL || argv[2] == NULL)
    {
        exit(100);
    }
    
    FILE * file = fopen(argv[1],"r");

    if (file==NULL){
        exit(110);
    }
 
    Tree* tree = NULL;
    Station station;
    
    int h, ret_var;
    long int id, load, capacity;
    char string[MAX];

 

    while (fgets(string, MAX, file))
    {
        ret_var = sscanf(string, "%ld;%ld;%ld", &id,&capacity,&load);
    
        if (ret_var != 3)
        {
            exit(120);
        }

        station.id = id;
        station.capacity = capacity;
        station.load = load;

        tree = insertAVL(tree, station, &h);
    }
     
    fclose(file);
    
    FILE * file2 = fopen(argv[2],"w");
    infix_write(tree, file2);
    
    freeAVL(tree);

    return 0;
} 

    
