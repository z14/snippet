/*
 * vim:ft=c
 */

#include <stdio.h>

// why is this code seg fault? all three of them

//void main(char argv[]){
//void main(char *argv){
void main(char *argv[]){
	printf("%s\n", argv[0]);
}

