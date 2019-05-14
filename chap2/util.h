#ifndef TIGER_UTIL_H
#define TIGER_UTIL_H

#include <assert.h>
#include <stdbool.h>


typedef char *string;


void *checked_malloc(int);


string String(char *);

typedef struct U_boolList_ *U_boolList;
struct U_boolList_ {bool head; U_boolList tail;};
U_boolList U_BoolList(bool head, U_boolList tail);

#endif      /* TIGER_UTIL_H */
