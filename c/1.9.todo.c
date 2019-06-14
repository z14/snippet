/*
 * vim:ft=c
 *
 * write a program that reads a set of text lines and prints the longest.
 *
 * TODO functionise this program
 */

#include <stdio.h>

main(){
	int i, j, c, len=0, max=0;
	int a[50], aa[50];

	for(i=0;(c=getchar())!=EOF;){
		a[i]=c;
		if(c=='\n'){
			if(len>max){
				max=len;
				for(j=0;j<max;j++) aa[j]=a[j];
				len=0;
			}
			i=0;
		}
		else{
			len++;
			i++;
		}
	}
	for(j=0;j<max;j++) printf("%c",aa[j]);
	putchar('\n');


	return 0;
}

