%{
/* Maverick lexer (Flex)
   Token categories: KEYWORD, IDENTIFIER, NUMBER, STRING, OPERATOR, DELIMITER
   Keywords: if, else, int (required) + while, print
   Comments (// to end of line) and whitespace are skipped.
   One simple rule per token so a parser (Bison) can be added later. */
#include <stdio.h>

int total = 0;

#define SHOW(category) { total++; printf("Line %-3d | %-10s | %s\n", yylineno, category, yytext); }
%}

%option noyywrap
%option yylineno

DIGIT   [0-9]
LETTER  [a-zA-Z_]

%%

"//".*                          { /* comment: skip */ }

"if"                            { SHOW("KEYWORD"); }
"else"                          { SHOW("KEYWORD"); }
"int"                           { SHOW("KEYWORD"); }
"while"                         { SHOW("KEYWORD"); }
"print"                         { SHOW("KEYWORD"); }

{DIGIT}+                        { SHOW("NUMBER"); }
{LETTER}({LETTER}|{DIGIT})*     { SHOW("IDENTIFIER"); }
\"[^\"\n]*\"                    { SHOW("STRING"); }

"=="|"!="|"<="|">="             { SHOW("OPERATOR"); }
"="|"+"|"-"|"*"|"/"|"<"|">"     { SHOW("OPERATOR"); }

"("|")"|"{"|"}"|";"|","         { SHOW("DELIMITER"); }

[ \t\r\n]+                      { /* skip whitespace */ }

.                               { printf("Line %-3d | %-10s | %s\n", yylineno, "ERROR", yytext); }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("Cannot open file %s\n", argv[1]);
            return 1;
        }
    }
    printf("=== Maverick Lexer ===\n");
    yylex();
    printf("=== Total tokens: %d ===\n", total);
    return 0;
}
