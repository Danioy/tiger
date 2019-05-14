#ifndef TIGER_UTIL_H
#define TIGER_UTIL_H

#include <assert.h>
#include <stdbool.h>

#define STR_BUF_CONST 4096

typedef char *string;


void *checked_malloc( size_t);


string String(char *);
string new_str_buf( void );

typedef struct U_boolList_ *U_boolList;
struct U_boolList_ {bool head; U_boolList tail;};
U_boolList U_BoolList(bool head, U_boolList tail);

#endif      /* TIGER_UTIL_H */
