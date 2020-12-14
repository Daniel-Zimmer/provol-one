build: bin/provol-comp

clean:
	rm -f bin/*

.PHONY: build clean

##################################################

bin/provol-comp: bin/grammar.tab.c bin/lex.yy.c
	gcc -Wall $^ -o $@

bin/grammar.tab.c: src/grammar.y
	bison $< -b bin/grammar -d -v -g

bin/lex.yy.c: src/lex.l
	lex -o $@ $<

