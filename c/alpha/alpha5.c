/*
 * vim:ft=c
 */

#include <stdio.h>

void main(){
	int i,j,k,l,m;

	for(i=97;i<=122;i++){
		for(j=97;j<=122;j++){
			for(k=97;k<=122;k++){
				for(l=97;l<=122;l++){
					for(m=97;m<=122;m++){
						printf("%c%c%c%c%c\n", i,j,k,l,m);
					}
				}
			}
		}
	}
}

