/*
 * vim:ft=c
 */

#include <stdio.h>

void main(){
	int i,j;

	for(i=97;i<=122;i++){
		for(j=97;j<=122;j++){
			printf("%c%c\n", i,j);
		}
	}
}

