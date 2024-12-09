#include <stdio.h>
#include <stdlib.h>

typedef struct {
	int power_plant;
	int HVB_station;
	int HVA_station;
	int LV_station;
	int company;
	int individual;
	int capacity;
	int load;
} Composant;

typedef struct _tree{
	Composant composant;
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

int* createComposant_member(int* member){
	if(member == NULL){
		exit(10);
	}
	char* donnee[50]; 
	int donnee_num;
	scanf("%s",donnee);
	if(donnee == "-"){
		// -1 is a value to say there is no value in this field of the composant
		*member = -1;
	}
	else{
		donnee_num = atoi(donnee);
		*member = donnee_num;
	}
	return member;
}

Composant createComposant(){
	Composant pNew;
	
	pNew.power_plant = createComposant_member(&(pNew.power_plant));
	pNew.HVB_station = createComposant_member(&(pNew.HVB_station));
	pNew.HVA_station = createComposant_member(&(pNew.HVA_station));
	pNew.LV_station = createComposant_member(&(pNew.LV_station));
	pNew.company = createComposant_member(&(pNew.company));
	pNew.individual = createComposant_member(&(pNew.individual));
	pNew.capacity = createComposant_member(&(pNew.capacity));
	pNew.load = createComposant_member(&(pNew.load));

	return pNew;
}


Tree* rotateLeft(Tree* pRoot){
	if(pRoot == NULL || pRoot->pRight == NULL){
		exit(200);
	}
	//update pointers 
	Tree* pPivot = pRoot->pRight;
	pRoot->pRight = pPivot->pLeft;
	pPivot->pLeft = pRoot;
	//update balance values
	int eqa = pRoot->balance;
	int eqb = pPivot->balance;
	pRoot->balance = eqa - max2(eqb,0) - 1;
	pPivot->balance = min3(eqa-2,eqa + eqb-2, eqb-1); 
	
	pRoot = pPivot;
	return pRoot;
	
}


Tree* rotateRight(Tree* pRoot){
	if(pRoot == NULL || pRoot->pLeft == NULL){
		exit(200);
	}
	//update pointers 
	Tree* pPivot = pRoot->pLeft;
	pRoot->pLeft = pPivot->pRight;
	pPivot->pRight = pRoot;
	//update values
	int eqa = pRoot->balance;
	int eqb = pPivot->balance;
	pRoot->balance = eqa - min2(eqb,0) + 1;
	pPivot->balance = max3(eqa+2,eqa + eqb+2, eqb+1); 
	
	pRoot = pPivot;
	return pRoot;
	
}


Tree* doubleRotateLeft(Tree* pRoot){
	if(pRoot==NULL || pRoot->pRight == NULL){
		exit(202);
	}
	pRoot->pRight = rotateRight(pRoot->pRight);
	return rotateLeft(pRoot);
} 


Tree* doubleRotateRight(Tree* pRoot){
	if(pRoot==NULL || pRoot->pLeft == NULL){
		exit(203);
	}
	pRoot->pLeft = rotateLeft(pRoot->pLeft);
	return rotateRight(pRoot);
}


Tree* balanceAVL(Tree* pRoot){
	if(pRoot == NULL){
		exit(205);
	}
	if(pRoot->balance >= 2){
		if(pRoot->pRight == NULL){
			exit(206);
		}
		if(pRoot->pRight->balance >= 0){
			//SIMPLE LEFT
			printf("Rotation simple gauche \n");
			pRoot = rotateLeft(pRoot);
		}
		else{
			//DOUBLE LEFT
			printf("Rotation double gauche \n");
			pRoot = doubleRotateLeft(pRoot);
		}
	}
	else if(pRoot-> balance <= -2){
		if(pRoot->pLeft == NULL){
			exit(207);
		}
		if(pRoot->pLeft->balance <= 0){
			//SIMPLE RIGHT
			printf("Rotation simple droite \n");
			pRoot = rotateRight(pRoot);
		}
		else{
			//DOUBLE RIGHT
			printf("Rotation double droite \n");
			pRoot = doubleRotateRight(pRoot);
		}
	}
	return pRoot;
}

Tree* createAVL(){
	Tree* pNew = malloc(sizeof(Tree));
	if(pNew == NULL){
		exit(10);
	}
	pNew->composant = createComposant();
	pNew->pLeft = NULL;
	pNew->pRight = NULL;
	pNew->balance = 0;
	return pNew;
}

Tree* insertAVL(Tree* pTree, int value, int* h){
	
	if(pTree == NULL){
		*h = 1;
		return createAVL(value);
	}
	else if(value < pTree->value){
		pTree->pLeft = insertAVL(pTree->pLeft, value, h);
		*h = -*h;
	}
	else if(value > pTree->value){
		pTree->pRight = insertAVL(pTree->pRight, value, h); 
	}
	else{
		*h = 0;
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


Tree* suppMinAVL(Tree* pTree, int* h, int* pValue){
	Tree* tmp;
	if(pTree->pLeft == NULL){
		*pValue = pTree->value;
		*h = -1;
		tmp = pTree;
		pTree = pTree->pRight;
		free(tmp);
		return pTree;
	}
	else{
		pTree->pLeft = suppMinAVL(pTree->pLeft,h,pValue);
		*h = -*h;
	}
	if( *h != 0){
		pTree->balance = pTree->balance + *h;
		pTree = balanceAVL(pTree);
		if(pTree->balance == 0){
			*h = -1;
		}
		else{
			*h = 0;
		}
	}
	return pTree;
}
		
		
Tree* suppAVL(Tree* pTree, int value, int* h){
	Tree* tmp;
	if(pTree == NULL){
		*h = 0;
		return pTree;
	}
	else if(value > pTree->value){
		pTree->pRight = suppAVL(pTree->pRight, value, h);
	}
	else if(value < pTree->value){
		pTree->pLeft = suppAVL(pTree->pLeft, value, h);
		*h = -*h;
	}
	else if(pTree->pRight != NULL){
		pTree->pRight = suppMinAVL(pTree->pRight, h, &(pTree->value));
	}
	else{
		tmp = pTree;
		pTree = pTree->pLeft;
		free(tmp);
		*h = -1;
		return pTree;
	}
	if(pTree == NULL){
		return pTree;
	}
	if(*h != 0){
		pTree->balance = pTree->balance + *h;
		pTree = balanceAVL(pTree);
		if(pTree->balance == 0){
			*h = -1;
		}
		else{
			*h = 0;
		}
	}
	return pTree;
}
	

void infix(Tree* p){
	if(p!=NULL){
		infix(p->pLeft);
		printf("[%02d / %2d]",p->value,p->balance);
		
		infix(p->pRight);
	}
}


void prefix(Tree* p){
	if(p!=NULL){
		printf("[%02d]",p->value);
		prefix(p->pLeft);
		prefix(p->pRight);
	}
}


int main(){
	
	
	return 0;
}


