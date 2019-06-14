/*
 * vim:ft=c
 */

#include <stdio.h>

void main(){
	//int i=0;	// why segfault? and why comment this line out works fine
	char *a;
	sprintf(a, "%%0%dd\\n", 9);
}

