/*
 * vim:ft=c
 */

#include <stdio.h>
main(){
	int c,s=0;
	for(;(c=getchar())!=EOF;)
		if(c==' '||c=='\t'||c=='\n') s++;
	printf("%d\n",s);
	return 0;
}

