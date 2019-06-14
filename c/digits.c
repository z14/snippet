/*
 * vim:ft=c
 */

#include <stdio.h>
#include <math.h>
#include <stdlib.h>

void main(int argc, char *argv[]){
	int digits=0, max=0, min=0;
	char f[9];	// Format of print
	char file[]="di";
	char prefix[]="";
	char suffix[]="";

	if (argc != 2) return;

	//char a[] = argv[1];
	char *a = argv[1];

	digits = strtol(a, NULL, 10);

	//sprintf(f, "%%0%dd\n", digits);	// if have more than 3 char before %%, mess code, why?
	sprintf(f, "%%0%dd", digits);
	//printf("%s\n", f);

	max = pow(10,digits)-1;

	FILE * fp=fopen(file,"a+");

	for(int i=min;i<=max;i++){
		//printf(prefix);
		//printf(f,i);
		//printf(suffix);
		fprintf(fp,prefix);
		fprintf(fp,f,i);
		fprintf(fp,suffix);
		fprintf(fp,"\n");
	}

	fclose(fp);
}

