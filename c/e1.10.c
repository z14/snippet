/*
 * vim:ft=c
 *
 * Write a program to copy its input to its output, replacing each tab by \t, each backspace by \b, and each backslash by \\. This makes tabs and backspaces visible in an unambiguous way.
 */

#include <stdio.h>

main(){
	int c;
	for(;(c=getchar())!=EOF;){
		switch(c){
			//case '\n': c='n'; break;
			case '\b': c='b'; break;
			case '\t': c='t'; break;
			case '\\': c='\\'; break;
			//default: ;
		}
		printf("%c",c);
	}


	return 0;
}

