/*
 * vim:ft=c
 */

#define UPPER 200
#define LOWER 0
#define STEP 10

#include <stdio.h>

main(){
	int i,fahr;
	float cels;
	printf("fahr\t  cels\n");

	for(fahr=UPPER;fahr>=LOWER;fahr-=STEP){
		cels=(fahr-32)*5.0/9.0;
		printf("%4d\t%6.1f\n",fahr,cels);
	}
	return 0;
}

