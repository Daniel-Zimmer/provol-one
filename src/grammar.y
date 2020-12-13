%{
	#include "grammar.tab.h"

	#include <stdio.h>
	#include <string.h>

	int yylex();
	void yyerror(const char *s);
	void makeTabs(char *tabs, int depth);

	extern int indent_depth;
%}

%union {
	char *s;
}

%token TK_ENTRADA
%token TK_SAIDA
%token TK_FIM
%token TK_ENQUANTO
%token TK_FACA
%token TK_INC
%token TK_ZERA
%token <s> TK_ID

%type <s> varlist cmd cmds cmds_opt

%%

program:
	TK_ENTRADA varlist nl TK_SAIDA TK_ID nl cmds_opt TK_FIM nl {
		printf(
			"unsigned int func(%s) {\n"
			"%s\n"
			"\treturn %s;\n"
			"}\n"
			, $2, $7, $5
		);

		free($2);
	}
;

varlist:
	varlist ',' TK_ID {
		char sep[] = ", unsigned int ";
		
		size_t len =
			strlen($1) +
			sizeof(sep) +
			strlen($3) +
			1;

		char *str = malloc(len);
		
		strcpy(str, $1);
		strcat(str, sep);
		strcat(str, $3);

		free($1);
		free($3);
		$$ = str;
	}
	| TK_ID {
		char type[] = "unsigned int ";

		size_t len =
			sizeof(type) +
			strlen($1) +
			1;

		$$ = malloc(len);

		strcpy($$, type);
		strcat($$, $1);

		free($1);
	}
	| { $$ = malloc(1); $$[0] = '\0'; }
;

cmds:
	cmds nl cmd {
		char nl[] = "\n";

		size_t len =
			strlen($1) +
			sizeof(nl) +
			strlen($3) +
			1;

		$$ = malloc(len);

		strcpy($$, $1);
		strcat($$, nl);
		strcat($$, $3);

		free($1);
		free($3);
	}
	| cmd {
		$$ = $1;
	}
;

cmds_opt:
	cmds nl {
		char nl[] = "\n";

		size_t size =
			strlen($1) +
			sizeof(nl) +
			1;

		$$ = malloc(size);

		strcpy($$, $1);
		strcat($$, nl);

		free($1);
	}
	| { $$ = malloc(1); $$[0] = '\0'; }
;

cmd:
	TK_ENQUANTO TK_ID TK_FACA nl cmds_opt TK_FIM {
		char tabs[indent_depth + 1];
		makeTabs(tabs, indent_depth);
		char _while[] = "while (";
		char dec[] = "--";
		char open_bracket[] = ") {\n";
		char close_bracket[] = "}\n";

		size_t len =
			indent_depth +
			sizeof(_while) +
			strlen($2) +
			sizeof(dec) +
			sizeof(open_bracket) +
			strlen($5) +
			indent_depth - 1 +
			sizeof(close_bracket) +
			1;
		
		$$ = malloc(len);

		strcpy($$, tabs);
		strcat($$, _while);
		strcat($$, $2);
		strcat($$, dec);
		strcat($$, open_bracket);
		strcat($$, $5);
		tabs[indent_depth] = '\0';
		strcat($$, tabs);
		strcat($$, close_bracket);

		free($2);
		free($5);
	}

	| TK_ID '=' TK_ID {
		char tabs[indent_depth + 1];
		makeTabs(tabs, indent_depth);
		char sep[] = " = ";
		char end[] = ";";

		size_t len =
			indent_depth +
			strlen($1) +
			sizeof(sep) +
			sizeof($3) +
			sizeof(end) +
			1;

		$$ = malloc(len);

		strcpy($$, tabs);
		strcat($$, $1);
		strcat($$, sep);
		strcat($$, $3);
		strcat($$, end);

		free($1);
		free($3);
	}

	| TK_INC '(' TK_ID ')' {
		char tabs[indent_depth + 1];
		makeTabs(tabs, indent_depth);
		char inc[] = "++;";

		size_t len =
			indent_depth +
			strlen($3) +
			sizeof(inc) +
			1;

		$$ = malloc(len);

		strcpy($$, tabs);
		strcat($$, $3);
		strcat($$, inc);

		free($3);
	}

	| TK_ZERA '(' TK_ID ')' {
		char tabs[indent_depth + 1];
		makeTabs(tabs, indent_depth);
		char zera[] = " = 0;";

		size_t len =
			indent_depth +
			strlen($3) +
			sizeof(zera) +
			1;

		$$ = malloc(len);

		strcpy($$, tabs);
		strcat($$, $3);
		strcat($$, zera);

		free($3);
	}
;

nl:
	  nl '\n'
	| '\n'
;

%%

#include <stdio.h>

int main() {
	yyparse();
	
	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "%s\n", s);
}

void makeTabs(char *tabs, int depth) {
	for (int i = 0; i < depth + 1; i++) {
		tabs[i] = '\t';
	}
	tabs[depth] = '\0';
}
