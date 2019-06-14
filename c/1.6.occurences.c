/*
 * vim:ft=c
 *
 * write a program to count the number of occurrences of each digit, of white space characters (blank, tab, newline), and of all other characters.
 *
 */

#include <stdio.h>

main(){
	int i,c,digit[10],blank=0,other=0;

	for(i=0;i<10;i++)
		digit[i]=0;

	for(;(c=getchar())!=EOF;){
		if(c>='0' && c<='9'){
			digit[c-'0']++;
		}
		else if(c=='\t' || c=='\n' || c==' ') blank++;
		else other++;
	}


	printf("digit =");
	for(i=0;i<10;i++)
		printf(" %d",digit[i]);

	printf(", blank = %d",blank);
	printf(", other = %d\n",other);

	return 0;
}

