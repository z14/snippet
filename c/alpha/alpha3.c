/*
 * vim:ft=c
 */

#include <stdio.h>

void main(){
	int i,j,k;

	for(i=97;i<=122;i++){
		for(j=97;j<=122;j++){
			for(k=97;k<=122;k++){
				printf("%c%c%c\n", i,j,k);
			}
		}
	}
}

