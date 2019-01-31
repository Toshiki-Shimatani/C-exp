TARGET=langspec
CC=gcc
CFLAGS=-g -O0 -Wall
LEX=flex
YACC=bison -d

HDR=langspec.tab.h ast.h
LDFLAGS=-lfl -ly
OBJ=langspec.tab.o lex.yy.o ast.o

.c.o:
	$(CC) $(CFLAGS) -c $<

$(TARGET): $(OBJ) $(HDR)
	$(CC) $(OBJ) $(LDFLAGS) -o $@

lex.yy.c: langspec.l
	$(LEX) $<

langspec.tab.c: langspec.y
	$(YACC) $< -r all --report-file=conflict.log

test_ast: test_ast.o ast.o
	$(CC) $^ -o $@

clean:
	rm -f *.o *.tab.c *.tab.h lex.yy.c *~
