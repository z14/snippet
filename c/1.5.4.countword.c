/*
 * vim:ft=c
 *
 * counts lines, words, and characters, with the loose definition that a word is any sequence of characters that does not contain a blank, tab or newline. This is a bare-bones version of the UNIX program wc.
 */

#include <stdio.h>

main(){
	int i,c,l,w,b,state=0;
	l=w=b=0;

	for(;(c=getchar())!=EOF;b++){
		if(c=='\n') l++;
		if(c==' ' || c=='\t' || c=='\n'){
			state=0;
		}
		else if(state==0){
			state=1;
			w++;
		}
	}

	printf("%d %d %d\n",l,w,b);

	return 0;
}

