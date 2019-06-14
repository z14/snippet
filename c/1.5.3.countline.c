/*
 * vim:ft=c
 *
 * counts input lines
 *
 */

#include <stdio.h>
main(){
	int c,l=0;
	for(;(c=getchar())!=EOF;)
		if(c=='\n') l++;
	printf("%d\n",l);
	return 0;
}

