/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 1 "parser.y"

	typedef struct tnode {
		const char * reg;
	} ExpNode;

	#include "Env.hpp"

#line 56 "parser.tab.h"

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TOKEN_INT = 258,
    TOKEN_CHAR = 259,
    TOKEN_CHAR_CONST = 260,
    TOKEN_IF = 261,
    TOKEN_ELSE = 262,
    TOKEN_ELSE_IF = 263,
    TOKEN_WHILE = 264,
    TOKEN_CONTINUE = 265,
    TOKEN_BREAK = 266,
    TOKEN_FOR = 267,
    TOKEN_RETURN = 268,
    TOKEN_VOID = 269,
    TOKEN_MAIN = 270,
    TOKEN_SWITCH = 271,
    TOKEN_CASE = 272,
    TOKEN_DEFAULT = 273,
    TOKEN_COLON = 274,
    TOKEN_IDENTIFIER = 275,
    TOKEN_INT_CONST = 276,
    TOKEN_SHARP = 277,
    TOKEN_LESS = 278,
    TOKEN_MORE = 279,
    TOKEN_LESS_EQU = 280,
    TOKEN_MORE_EQU = 281,
    TOKEN_EQUALS = 282,
    TOKEN_NOT_EQUALS = 283,
    TOKEN_BIT_OR = 284,
    TOKEN_BIT_AND = 285,
    TOKEN_OR = 286,
    TOKEN_AND = 287,
    TOKEN_XOR = 288,
    TOKEN_NOT = 289,
    TOKEN_PLUS = 290,
    TOKEN_MINUS = 291,
    TOKEN_MULTIPLY = 292,
    TOKEN_DIV = 293,
    TOKEN_ASSIGN = 294,
    TOKEN_LEFT_PAREN = 295,
    TOKEN_RIGHT_PAREN = 296,
    TOKEN_LEFT_BRAK = 297,
    TOKEN_RIGHT_BRAK = 298,
    TOKEN_COMMA = 299,
    TOKEN_DOT = 300,
    ERROR = 301
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 73 "parser.y"

	int intType;
	char charType;
	char* strType;
	ExpNode expNode;

#line 121 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
