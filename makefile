
build: bin/provol-comp

bin/provol-comp: bin/grammar.tab.h bin/grammar.tab.c bin/lex.yy.c
	gcc -Wall bin/lex.yy.c bin/grammar.tab.c -o bin/provol-comp

bin/grammar.tab.h: src/grammar.y
	bison src/grammar.y -b bin/grammar -d -v -g

bin/lex.yy.c: src/lex.l
	lex -o bin/lex.yy.c src/lex.l 

