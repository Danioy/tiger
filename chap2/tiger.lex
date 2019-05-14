%x COMMENT STRING

%{
#include <string.h>
#include "util.h"
#include "tokens.h"
#include "errormsg.h"

int charPos=1;

int yywrap(void)
{
 charPos=1;
 return 1;
}

void adjust(void)
{
 EM_tokPos=charPos;
 charPos+=yyleng;
}

%}

%%
/* Skip white spaces */
[ \r\n]           { adjust(); continue;               }
\n	               { adjust(); EM_newline(); continue; }

/* Reserved words */
while             { adjust(); return WHILE;           }
for               { adjust(); return FOR;             }
to                { adjust(); return TO;              }
break             { adjust(); return BREAK;           }
let               { adjust(); return LET;             }
in                { adjust(); return IN;              }
end               { adjust(); return END;             }

","	 {adjust(); return COMMA;}
for  	 {adjust(); return FOR;}
[0-9]+	 {adjust(); yylval.ival=atoi(yytext); return INT;}
.	 {adjust(); EM_error(EM_tokPos,"illegal token");}
