/*
 * vim:ft=c
 */

#include <stdio.h>

void main(){
	FILE * fp=fopen("t","a+");

	for(int i=0;i<=99999999;i++)
		fprintf(fp,"%08d\n",i);

	fclose(fp);
}

