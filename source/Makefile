all: clean clear compile run view
clear:	
	clear
compile:
	bison -dv parser.y
	flex scanner.l
	g++ -std=c++17 -g \
		lex.yy.c \
		parser.tab.c \
		mips.cpp\
		registerManager.cpp \
		Env.cpp\
		utils.cpp \
		stackManager.cpp \
		-o compiler \
		-lm

run:
	./compiler test.txt out.txt

view:
	cat out.txt

clean: 
	rm -rf parser.tab.c parser.tab.h lex.yy.c compiler

