%{
#include <stdio.h>
#include <math.h>
#include <string.h>   
#include <stdlib.h>


void yyerror(char *);
extern FILE *yyin;
extern FILE *yyout;
int yylex();
extern int yylineno;
int yylex(void);
char *var;
char *var1;
char *var2;
int y=0;

%}
%union
{
	char *strval;
	int intval;
	float flval;
};

%token <strval> T_ELSE T_WHILE T_RETURN T_IF T_ANY T_SELF
%token <strval> T_DEF T_INIT T_CLASS T_COLON T_FOR T_RANGE T_IN T_BOOL T_PRINT
%token <strval> T_FROM
%token <strval> T_CONTINUE
%token <strval> T_BREAK
%token <strval> T_DEFAULT
%token <strval> T_LEN
%token <strval> T_NEW
%token <strval> T_MAIN
%token <strval> T_SIZEOP
%token <strval> T_AS
%token <strval> T_LAMBDA
%token <strval> T_ELIF
%token <strval> T_DICT
%token <intval> T_INT
%token <strval> T_OROP
%token <strval> T_ANDOP
%token <strval> T_EQUOP
%token <strval> T_RELOP
%token <strval> T_NOTOP
%token <strval> T_DOT
%token <strval> T_METH T_ID
%token <strval> T_IMPORT  T_LINE T_TAB T_EQ T_OR T_AND T_NOT  T_START T_LIST T_COMMNT
%token <strval> T_LPAREN T_RPAREN T_SEMI T_COMMA T_LBRACK T_RBRACK T_REFER T_LBRACE T_RBRACE
%token <flval> T_FLOAT
%token <strval> T_ERROR
%token <strval> T_STRING

%left <strval> T_ADD T_SUB
%left <strval> T_MUL T_DIV
%right <strval> T_ASSIGN

%%

//-----R U L E S --------

prog
	:stmt
	|prog stmt
	;

stmt
	:imp_stmt
	|assgn_stmt
	|def_func
	|print_stmt
	|if_stmt
	|for_loop
	|class_def
	|obj_create
	|function_call
	|T_LINE
	;

imp_stmt
	:T_IMPORT T_ID T_LINE								{var = $2; printf("IMPORTING MODULE: %s \n", var);}												
	|T_IMPORT T_ID T_AS T_ID T_LINE						{var = $2; var1 = $4; printf("IMPORTING MODULE: %s AS: %s \n", var, var1);}
	|T_IMPORT T_ID T_FROM T_ID T_LINE					{var = $2; var1 = $4; printf("IMPORTING MODULE: %s FROM: %s\n", var, var1);}
	|T_IMPORT T_ID T_FROM T_ID T_AS T_ID T_LINE			{var = $2; var1 = $4; var2 = $6; printf("IMPORTING MODULE: %s FROM: %s AS: %s\n", var, var1, var2);}
		  ;

class_def:
			T_CLASS T_ID T_COLON T_LINE class_body         {var = $2; printf("CREATED CLASS: %s\n", var);}
			;

class_body:
			T_TAB class_constr class_body
			|T_TAB def_func class_body
			|/*empty */
			;
			
class_constr:
			T_DEF T_INIT T_LPAREN T_SELF T_COMMA parameters T_RPAREN T_COLON T_LINE self_assign			{printf("THIS IS A CLASS CONSTRUCTOR \n");}
			;
self_assign:
			T_TAB T_TAB T_SELF T_DOT T_ID T_ASSIGN T_ID T_LINE self_assign
			| /* empty */
			;

obj_create:
			T_ID T_ASSIGN T_ID T_LPAREN parameters T_RPAREN T_LINE 					{printf("OBJECT CREATION\n");}
			;


assgn_stmt
			:T_ID T_ASSIGN T_ID T_LINE								{printf("ASSIGNING A VARIABLE TO A VARIABLE\n");}
			|T_ID T_ASSIGN T_INT T_LINE 							{printf("ASSIGNING AN INTEGER TO A VARIABLE\n");}
			|T_ID T_ASSIGN T_FLOAT T_LINE							{printf("ASSIGNING A FLOAT TO A VARIABLE\n");}
			|T_ID T_ASSIGN operation T_LINE							{printf("THIS IS AN ASSING STATEMENT WITH AN OPERATION\n");}
			;
operation :
			T_INT T_ADD T_INT 								{printf("This is an ADDITION: %d + %d = %d \n",$1, $3,($1 + $3));}
			|T_INT T_SUB T_INT 								{printf("This is an SUBTRACTION: %d \n", ($1 - $3));}
			|T_INT T_MUL T_INT 								{printf("This is an MULTIPLICATION: %d \n",($1 * $3));}
			|T_INT T_DIV T_INT 								{printf("This is an DIVISION: %d \n", ($1 / $3));}
			|T_FLOAT T_ADD T_FLOAT 							{printf("This is an ADDITION: %.3f + %.3f = %.3f \n",$1, $3, ($1 + $3));}
			|T_FLOAT T_SUB T_FLOAT 							{printf("This is an SUBTRACTION: %.3f \n", ($1 - $3));}
			|T_FLOAT T_MUL T_FLOAT 							{printf("This is an MULTIPLICATION: %.3f \n",($1 * $3));}
			|T_FLOAT T_DIV T_FLOAT 							{printf("This is an DIVISION: %.3f \n",($1 / $3));}
			|T_FLOAT T_ADD T_INT 							{printf("This is an ADDITION: %.3f + %d = %.3f \n",$1, $3, ($1 + $3));}
			|T_FLOAT T_SUB T_INT 							{printf("This is an SUBTRACTION: %.3f \n", ($1 - $3));}
			|T_FLOAT T_MUL T_INT							{printf("This is an MULTIPLICATION: %.3f \n",($1 * $3));}
			|T_FLOAT T_DIV T_INT 							{printf("This is an DIVISION: %.3f \n",($1 / $3));}
			|T_INT  T_ADD T_FLOAT 							{printf("This is an ADDITION: %.d + %.3f = %.3f \n",$1, $3, ($1 + $3));}
			|T_INT  T_SUB T_FLOAT 							{printf("This is an SUBTRACTION: %.3f \n", ($1 - $3));}
			|T_INT  T_MUL T_FLOAT 							{printf("This is an MULTIPLICATION: %.3f \n",($1 * $3));}
			|T_INT  T_DIV T_FLOAT 							{printf("This is an DIVISION: %.3f \n",($1 / $3));}
			
			;
			
			



def_func:
			T_DEF T_ID T_LPAREN parameters T_RPAREN T_COLON T_LINE tail {printf("FUNCTION DEFINITION HERE\n");}
			;

parameters: pars T_ID
			| /* empty */
			;

pars:		pars T_ID T_COMMA
			| /* empty */
			;

function_call:
				T_ID T_LPAREN parameters T_RPAREN 				{printf("FUNCTION CALL HERE\n");}


print_stmt: 
			T_PRINT T_LPAREN T_STRING T_RPAREN T_LINE   { printf("THIS IS A PRINT LOL\n");}
			;

if_stmt:
			T_IF expression T_COLON T_LINE 	tail		{printf("THIS IS AN IF STATEMENT\n");}
			;
						
			
tail: tail tb commands_in 
	  |tb commands_in
		;	
		
		
tb: T_TAB
	|tb T_TAB
	;			
		
commands_in: print_stmt
			|assgn_stmt
			|def_func
			|if_stmt
			|for_loop
			;	
			
expression:
			bool_st
			|cmprsn
			;
			
bool_st:
			T_ID T_EQ T_BOOL
			;
cmprsn:
			T_ID compare T_ID
			|T_ID compare T_INT
			|T_ID compare T_FLOAT
			;
compare:
			T_EQUOP
			|T_RELOP
			;
			
for_loop:
			T_FOR T_ID T_IN T_ID T_COLON T_LINE	tail				{printf("THIS IS A PYTHONIAN FOR LOOP\n");}
			|T_FOR T_ID T_IN range_tool T_COLON T_LINE 	tail		{printf("THIS IS A FOR LOOP\n");}
			;
			
range_tool:
			T_RANGE T_LPAREN T_INT T_COMMA T_INT T_RPAREN
			;		


%%

void yyerror(char *s) {
        fprintf(stderr,"AT LINE %d : %s\n",yylineno,s);
       
}
int main ( int argc, char **argv )
{
  ++argv; --argc;
  if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
  else
        yyin = stdin;
  yyout = fopen ( "output", "w" );
  yyparse ();




  return 0;
}
