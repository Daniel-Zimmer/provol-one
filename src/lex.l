%{
	#include "grammar.tab.h"

	int indent_depth = 1;

%}

%option noyywrap
%option noinput
%option nounput

%%

[\t ] {

}

"ENTRADA"  { return TK_ENTRADA ; }
"SAIDA"    { return TK_SAIDA   ; }
"FIM"      { indent_depth--; return TK_FIM      ; }
"ENQUANTO" { indent_depth++; return TK_ENQUANTO ; }
"FACA"     { return TK_FACA    ; }
"INC"      { return TK_INC     ; }
"ZERA"     { return TK_ZERA    ; }

[a-zA-Z_][a-zA-Z_0-9]* {
	yylval.s = strdup(yytext);
	return TK_ID;
}

. {
	return *yytext;
}

\n {
	return '\n';
}

<<EOF>> {
	static int once = 0; return once++ ? 0 : '\n';
}

%%
