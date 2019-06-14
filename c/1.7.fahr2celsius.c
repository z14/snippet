/*
 * vim:ft=c
 */

#define UPPER 100
#define LOWER 0
#define STEP 1

#include <stdio.h>

float fahr2cels(int fahr);

main(){
	int i,fahr;
	printf("fahr\t  cels\n");

	for(fahr=UPPER;fahr>=LOWER;fahr-=STEP){
		printf("%4d\t%6.1f\n",fahr,fahr2cels(fahr));
	}
	return 0;
}

float fahr2cels(int fahr){
	return (fahr-32)*5.0/9.0;
}
