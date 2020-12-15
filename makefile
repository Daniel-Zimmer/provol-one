build: bin bin/provol-comp provol-one

clean:
	rm -rf bin test/list.so provol-one example/ex1 example/ex1.c example/ex1.h

test:
	gcc -shared -o test/list.so -fPIC src/list.c
	cd test;\
	python3 list.py

.PHONY: build clean test

##################################################

# creates bin directory if it does not exist
bin:
	mkdir -p bin

bin/provol-comp: bin/grammar.tab.c bin/lex.yy.c bin/list.o
	gcc -Wall $^ -o $@

bin/grammar.tab.c: src/grammar.y
	bison $< -b bin/grammar -d -v -g

bin/lex.yy.c: src/lex.l
	lex -o $@ $<

bin/list.o: src/list.c
	gcc -Wall $< -c -o $@

provol-one: src/provol-one
	cp $< $@