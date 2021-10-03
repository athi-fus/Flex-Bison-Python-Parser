%option case-sensitive
%option yylineno
%option noyywrap
%option reject

%{

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include "parserino3.tab.h"

%}

number		([0-9])+

float		{number}\.{number}
alpha		[a-zA-Z]
alphanum    {alpha}|{number}							

ID          \_*{alpha}{alphanum}*(_{alphanum}+)*_?
STRING      \"{ID}(" "{ID})*\"
ASCII       [ !"$%&'()*+,-./:;<=>?@\[\\\]^_`{|}~]
TEXT 		({ID}*" "+{ASCII}*)*
%%

"import"												{printf("import \t"); return T_IMPORT;}

{number}                                          		{printf("integer\t"); yylval.intval =atoi( yytext);return T_INT;} 

"class"                                                 {printf("class\t"); return T_CLASS;}
" "                 									{ printf("whitespace\t");}

"list"                                                  {return T_LIST;}
"continue"                                              {return T_CONTINUE;}
"break"                                                 {return T_BREAK;}
"if"                                                    {printf("if\t"); return T_IF;}
"else"                                                  {return T_ELSE;}
"for"                                                   {printf("for\t"); return T_FOR;}
"default"                                               {return T_DEFAULT;}

"len"                                                	{return T_LEN;}
"new"                                                   {return T_NEW;}
"main"                                                  {return T_MAIN;}
"sizeof"                                                {return T_SIZEOP;}  

"from"													{printf("from \t");return T_FROM;}
"as"													{printf("as\t");return T_AS;}
\n                  									{printf("\n"); return T_LINE;}
\t                  									{return T_TAB;}
"def"               									{printf("def\t"); return T_DEF;}

"or"                									{printf("or\t");	return T_OR;    }
"and"               									{printf("and\t");	return T_AND;   }
"not"|"=="          									{printf("not|==\t"); return T_EQ;    }
"True"|"False"											{printf("boolean variable \t");	return T_BOOL;}
"return"												{printf("return \t"); return T_RETURN;}
"print"													{printf("print\t"); return T_PRINT;}
"__init__"         									    {printf("INIT\t");					return T_INIT;}
"self"													{printf("SELF\t"); return T_SELF;}
"lambda"												{return T_LAMBDA;}
"elif"													{return T_ELIF;}
"dict"													{return T_DICT;}
"range"													{printf("range\t");return T_RANGE;} 
"in"													{printf("in\t"); return T_IN;}
{float}                        							{printf("float\t"); yylval.flval =atof( yytext); return T_FLOAT;} 

{STRING}												{printf("string\t");return T_STRING;}
  
{ID}                                                    {printf("identifier \t"); yylval.strval=strdup(yytext); return T_ID;}   

"||"                                                    {return T_OROP;}  
"&&"                                                    {return T_ANDOP;}  
"=="|"!="                                               {return T_EQUOP;}  
">="|"<="|">"|"<"                                       {return T_RELOP;}                                      
"+"		                                                {return T_ADD;}  
"-"														{return T_SUB;}
"*"		                                                {return T_MUL;}
"/"														{return T_DIV;}  
"!"                                                     {return T_NOTOP;}  


"("                                                     {printf("left paren\t");return T_LPAREN;} 
")"                                                     {printf("right paren\t");return T_RPAREN;} 
";"                                                     {return T_SEMI;} 
"."                                                     {printf("DOT \t");return T_DOT;} 
","                                                     {printf("COMMA \t");return T_COMMA;} 
"="                                                     {printf("ASSIGN \t");return T_ASSIGN;}
"::"                                                    {return T_METH;}                                                             
":"                                                     {printf("COLON\t"); return T_COLON;} 
"["                                                     {return T_LBRACK;} 
"]"                                                     {return T_RBRACK;} 
"&"                                                     {return T_REFER;} 
"{"                                                     {return T_LBRACE;} 
"}"                                                     {return T_RBRACE;} 
"#".*  													{printf("COMMENT HEEERE\n");}


  
.                   { printf("\nUnrecognised character at line \n");return T_ERROR;}

