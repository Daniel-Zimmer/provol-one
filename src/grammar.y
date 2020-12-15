%{
	#include "grammar.tab.h"
	#include "../src/list.h"

	#include <stdio.h>
	#include <string.h>

	int yylex();
	void yyerror(const char *s);
	void makeTabs(char *tabs, int depth);

	extern int indent_depth;

	List *varList;
	List *inVarList;
	List *finalVarList;
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
%token TK_SE
%token TK_ENTAO
%token <s> TK_INT
%token <s> TK_ID

%type <s> varlist cmd cmds cmds_opt

%%

program:
	TK_ENTRADA varlist nl TK_SAIDA TK_ID nl cmds_opt TK_FIM nl {

		finalVarList = LIST_create();

		int flag = 0;
		for (int i = 0; i < LIST_len(varList); i++) {
			for (int j = 0; j < LIST_len(inVarList); j++) {
				if (LIST_get(inVarList, i) != NULL) {
					if (!strcmp(LIST_get(varList, i), LIST_get(inVarList, i))) {
						free(LIST_get(inVarList, i));
						LIST_set(inVarList, i, NULL);
						flag = 1;
						break;
					}
				}
			}
			if (!flag) {
				finalVarList = LIST_push(finalVarList, LIST_get(varList, i));
			}
			flag = 0;
		}



		printf(
			"unsigned int provol_func(%s) {\n"
			"\tunsigned int "
			, $2
		);

		for (int i = 0; i < LIST_len(finalVarList) - 1; i++) {
			printf("%s, ", (char *) LIST_get(finalVarList, i) );
		}
		printf("%s;\n", (char *) LIST_get(finalVarList, LIST_len(finalVarList) - 1) );

		printf(
			"%s\n"
			"\treturn %s;\n"
			"}\n"
			, $7, $5
		);

		for (int i = 0; i < LIST_len(finalVarList); i++) {
			free(LIST_get(finalVarList, i));
		}
		free(finalVarList);

		free($2);
		free($5);
		free($7);
	}
;

varlist:
	varlist ',' TK_ID {
		char sep[] = ", unsigned int ";

		inVarList = LIST_push(inVarList, strdup($3));
		
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

		inVarList = LIST_push(inVarList, strdup($1));

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
cmd:
	TK_ID '=' TK_INT {
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

	| TK_SE TK_ID TK_ENTAO nl cmds_opt TK_FIM {
		char tabs[indent_depth + 1];
		makeTabs(tabs, indent_depth);
		char _if[] = "if (";
		char open_bracket[] = ") {\n";
		char close_bracket[] = "}\n";

		size_t len =
			indent_depth +
			sizeof(_if) +
			strlen($2) +
			sizeof(open_bracket) +
			strlen($5) +
			indent_depth - 1 +
			sizeof(close_bracket) +
			1;
		
		$$ = malloc(len);

		strcpy($$, tabs);
		strcat($$, _if);
		strcat($$, $2);
		strcat($$, open_bracket);
		strcat($$, $5);
		tabs[indent_depth] = '\0';
		strcat($$, tabs);
		strcat($$, close_bracket);

		free($2);
		free($5);
	}

	| TK_ENQUANTO TK_ID TK_FACA nl cmds_opt TK_FIM {
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
	varList = LIST_create();
	inVarList = LIST_create();

	yyparse();

	LIST_delete(varList);
	LIST_delete(inVarList);

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
