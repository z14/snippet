/*
 * vim:ft=c
 * pinyin abbr
 *
 */

#include <stdio.h>

void main(){
	char p[] = {'a','b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','w','x','y','z'};
	int i,j,k,s;
	s=sizeof(p);

	FILE * fp=fopen("pinyin_abbr", "a+");
	for(i=0;i<s;i++){
		fprintf(fp,"%c\n",p[i]);
	}

	for(i=0;i<s;i++){
		for(j=0;j<s;j++){
			fprintf(fp,"%c%c\n",p[i],p[j]);
		}
	}

	for(i=0;i<s;i++){
		for(j=0;j<s;j++){
			for(k=0;k<s;k++){
				fprintf(fp,"%c%c%c\n",p[i],p[j],p[k]);
			}
		}
	}
	fclose(fp);
}

