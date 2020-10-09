%{	
	#include <stdio.h> 
	#include <string.h> 
	#include "DDLFunctionsDefine.h"	
%}

%union
{
    char *str;
}

%type <str> dest attr

%token <str> NOME 
%token <str> DIM 
%token <str> NUM 
%token <str> TYPE
%token KEY COMMA
%token C R A D S DA W L DB TAB EXIT
%token EOL
%token VAR
%error-verbose

%%

PROGRAM: PROGRAM LINGUAGGIO
|LINGUAGGIO 
|NUM {printf("Yuppie ka ye");}
|VAR {printf("Yuppws");}
|error EOL{yyerrok; yyclearin;printf("Comando non riconosciuto, usare help per vedere la lista di comandi \n");}
;

LINGUAGGIO: C DB NOME EOL   { creaDB($3); }
		  | C TAB NOME EOL  { creaTable($3); }
		  | C error EOL 	{ yyerrok; yyclearin; printf("Per la sintassi completa usare HELP C: \n"); }
		  | R DB NOME EOL	{ rimuoviDB($3); }
		  | R TAB NOME EOL  {}
		  | R error EOL		{ yyerrok; yyclearin; printf("Per la sintassi completa usare HELP R: \n");}
		  | A dest attr EOL { /*DEBUG*/ printf("%s%s",$3,$2); appendAttr($2, $3); }
		  | A error EOL	    { yyerrok;
							  printf("Il token [%s] e errato o non esistente\n",yylval);
							  yyclearin;
							  printf("Per la sintassi completa usare help A:\n"); }
;

/* Attributo della tabella */
/*
attr: NOME TYPE					{ myToUpper($2); sprintf($$, "%s|%s", $1, $2);}
	| NOME TYPE KEY				{ myToUpper($2); sprintf($$, "%s|%s|KEY", $1, $2); }
	| NOME TYPE COMMA			{ myToUpper($2); sprintf($$, "%s|%s|,", $1, $2); }
	| NOME TYPE KEY COMMA		{ sprintf($$, "%s|%s|KEY|,", $1, myToUpper($2)); }
	| attr NOME TYPE			{ sprintf($$, "%s|%s|%s", $1, $2, myToUpper($3)); }
	| attr NOME TYPE KEY		{ sprintf($$, "%s|%s|%s|KEY",$1,$2,$3); }
	| attr NOME TYPE COMMA		{ sprintf($$, "%s%s|%s,",$1,$2,$3); }
	| attr NOME TYPE KEY COMMA	{ sprintf($$, "%s%s|%s|KEY,",$1,$2,$3); }
;
*/

attr: NOME TYPE		  { myToUpper($2); sprintf($$, "%s|%s", $1, $2); }
	| NOME TYPE KEY	  { myToUpper($2); sprintf($$, "%s|%s|KEY", $1, $2); }
	| attr COMMA attr { sprintf($$, "$s|,|$s", $1, $3); }

/* Destinazione di un comando */
dest: DB NOME TAB NOME { setLoadedDB($2); $$ = $4;}
	| TAB NOME		   { $$ = $2; }
;

%%

main (int argc, char **argv)	{
	yyparse();	
}

yyerror( char *s){
	fprintf(stderr, "Error:%s\n", s);
}	
