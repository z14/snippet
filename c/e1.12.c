/*
 * vim:ft=c
 *
 * Write a program that prints its input one word per line.
 */

#include <stdio.h>

main(){
	int c,s=0;
	for(;(c=getchar())!=EOF;){
		if(c==' ' || c=='\t' || c=='\n'){
			if(s==1) putchar('\n');
			s=0;
		}
		else{
			s=1;
			putchar(c);
		}
	}

	return 0;
}

