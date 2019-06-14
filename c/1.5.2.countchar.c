/*
 * vim:ft=c
 *
 * counts characters
 *
 */

#include <stdio.h>
main(){
	int n;
	for(n=0;getchar()!=EOF;n++)
		; // !
	printf("%d\n",n);
	return 0;
}

