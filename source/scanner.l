%option noyywrap
%{
    #include <stdio.h>
    #include <stdlib.h>
	#include <string.h>
	#include <string>
	#include <cstring>

	#include "parser.tab.h"

	using std::string;
	

	int lineNumber = 0;
	int preCharNumber = 0;
	int currentCharNumber = 0;

%}
%%
"int"                  {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_INT);}
"char"                 {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_CHAR);}
"if"                   {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_IF);}
"else"                 {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_ELSE);}
"elseif"               {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_ELSE_IF);}
"while"                {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_WHILE);}
"continue"             {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_CONTINUE);}
"break"                {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_BREAK);}
"for"                  {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_FOR);}
"return"               {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_RETURN);}
"void"                 {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_VOID);}
"main"                 {preCharNumber = currentCharNumber; currentCharNumber += yyleng; yylval.strType = strdup(yytext); return(TOKEN_MAIN); }
"switch"                 {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_SWITCH);}
"case"                 {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_CASE);}
"default"                 {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_DEFAULT);}
":"                 {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_COLON);}
[a-zA-Z_][a-zA-Z_0-9]* {
							preCharNumber = currentCharNumber; currentCharNumber += yyleng;
							yylval.strType = strdup(yytext);
							return(TOKEN_IDENTIFIER);
						}
[0-9]+                 {
							long a = atol(yytext);
							if(yyleng > 10 || a > 2147483648 || a < -2147483649)
							{
								printf("error in line %d : integer constant is out of range\n",lineNumber+1);
								exit(1);
							}
							preCharNumber = currentCharNumber; currentCharNumber += yyleng;
							yylval.intType = atoi(yytext);
							return(TOKEN_INT_CONST);
						}
'.'                    {
							preCharNumber = currentCharNumber; currentCharNumber += yyleng;
							yylval.intType = yytext[1];
							return(TOKEN_CHAR_CONST);
						}


"$*"([^*]|"*"+[^$*])*"*"+"$"    {preCharNumber = currentCharNumber; currentCharNumber += yyleng;}
"$$".*                          {preCharNumber = currentCharNumber; currentCharNumber += yyleng;}

"#"                   {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_SHARP);}
"<"                   {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_LESS);}
">"                   {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_MORE);}
"<="                  {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_LESS_EQU);}
">="                  {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_MORE_EQU);}
"=="                  {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_EQUALS);}
"!="                  {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_NOT_EQUALS);}
"|"                   {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_BIT_OR);}
"&"                   {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_BIT_AND);}
"||"                  {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_OR);}
"&&"                  {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_AND);}
"^"                   {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_XOR);}
"!"                   {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_NOT);}
"+"                   {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_PLUS);}
"-"                   {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_MINUS);}
"*"                   {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_MULTIPLY);}
"/"                   {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_DIV);}
"="                   {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_ASSIGN);}


"("                 {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_LEFT_PAREN);}
")"                 {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_RIGHT_PAREN);}
"["                 {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_LEFT_BRAK);}
"]"                 {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_RIGHT_BRAK);}
","                 {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_COMMA);}
[.]                 {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(TOKEN_DOT);}

[ \t]+              {preCharNumber = currentCharNumber; currentCharNumber += yyleng;}
[\n]				{preCharNumber=0; currentCharNumber = 0; lineNumber++;}
.                   {preCharNumber = currentCharNumber; currentCharNumber += yyleng; return(ERROR);}
%%
