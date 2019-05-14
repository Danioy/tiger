

%{
#include <string.h>
#include "util.h"
#include "tokens.h"
#include "errormsg.h"

int charPos=1;
char str_buf[STR_BUF_CONST];
char *str_buf_ptr;

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
%x COMMENT_STATE STRING_STATE
%%



[ \t]             { adjust(); continue;               }
(\n|\r\n)         { adjust(); EM_newline(); continue; }

while             { adjust(); return WHILE;           }
for               { adjust(); return FOR;             }
to                { adjust(); return TO;              }
break             { adjust(); return BREAK;           }
let               { adjust(); return LET;             }
in                { adjust(); return IN;              }
end               { adjust(); return END;             }
function          { adjust(); return FUNCTION;        }
var               { adjust(); return VAR;             }
type              { adjust(); return TYPE;            }
array             { adjust(); return ARRAY;           }
if                { adjust(); return IF;              }
then              { adjust(); return THEN;            }
else              { adjust(); return ELSE;            }
do                { adjust(); return DO;              }
of                { adjust(); return OF;              }
nil               { adjust(); return NIL;             }

","               { adjust(); return COMMA;           }
":"               { adjust(); return COLON;           }
";"               { adjust(); return SEMICOLON;       }
"("               { adjust(); return LPAREN;          }
")"               { adjust(); return RPAREN;          }
"["               { adjust(); return LBRACK;          }
"]"               { adjust(); return RBRACK;          }
"{"               { adjust(); return LBRACE;          }
"}"               { adjust(); return RBRACE;          }
"\."              { adjust(); return DOT;             }
"+"               { adjust(); return PLUS;            }
"-"               { adjust(); return MINUS;           }
"*"               { adjust(); return TIMES;           }
"/"               { adjust(); return DIVIDE;          }
"="               { adjust(); return EQ;              }
"<>"              { adjust(); return NEQ;             }
"<"               { adjust(); return LT;              }
"<="              { adjust(); return LE;              }
">"               { adjust(); return GT;              }
">="              { adjust(); return GE;              }
"&"               { adjust(); return AND;             }
"|"               { adjust(); return OR;              }
":="              { adjust(); return ASSIGN;          }

[a-zA-Z]+[a-zA-Z_0-9]*    {     /* identifiers */
                     adjust();
                     yylval.sval = yytext;
                     return ID;
                  }

[+-]?[0-9]+                {     /* integers    */
                     adjust();
                     yylval.ival = atoi(yytext);
                     return INT;
                  }

\"                         {     /* begin string literals */
                     adjust();
                     str_buf_ptr = str_buf;
                     BEGIN( STRING_STATE);
                  }

<STRING_STATE>\"           {     /* end string literals */
                     *str_buf_ptr = '\0';
                     charPos += strlen(str_buf);
                     yylval.sval = String(str_buf);
                     BEGIN(INITIAL);
                     return STRING;
                  }

<STRING_STATE>\n           {     /* string more than one line */
                     EM_error(EM_tokPos, "Unterminated string const");
                     yyterminate();
                  }

<STRING_STATE>\\n    { str_buf_ptr++; *str_buf_ptr = '\n';  }
<STRING_STATE>\\t    { str_buf_ptr++; *str_buf_ptr = '\t';  }
<STRING_STATE>\\r    { str_buf_ptr++; *str_buf_ptr = '\r';  }
<STRING_STATE>\\b    { str_buf_ptr++; *str_buf_ptr = '\b';  }
<STRING_STATE>\\f    { str_buf_ptr++; *str_buf_ptr = '\f';  }

<STRING_STATE>\\(.|\n)  { str_buf_ptr++; *str_buf_ptr = yytext[1];  }
<STRING_STATE>[^\\\n\"]+   {
                     char *yptr = yytext;
                     while( *yptr ) {
                        str_buf_ptr++;
                        *str_buf_ptr = *yptr++;
                     }
                  }

"/*"                         {     /* start comments */
                     adjust();
                     BEGIN(COMMENT_STATE);
                  }

"*/"                         {
                     adjust();
                     EM_error(EM_tokPos, "Comments without open");
                     yyterminate();
                  }

.                 {adjust(); EM_error(EM_tokPos,"illegal token");}

<COMMENT_STATE>{
    "/*" {
           adjust();
           continue;
         }

    "*/" {
           adjust();
            BEGIN(INITIAL);
         }

    <<EOF>> {
              EM_error(EM_tokPos, "Encounter EOF.");
              yyterminate();
            }

    \n  {
      adjust();
      EM_newline();
      continue;
    }

    . {
      adjust();
      }

}
