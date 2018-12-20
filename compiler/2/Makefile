FILE = langspec
IN = input.txt

f:
	flex ${FILE}.l
b:  
	bison -d ${FILE}.y
gcc:
	flex ${FILE}.l
	bison -d ${FILE}.y
	gcc ${FILE}.tab.c lex.yy.c -o ${FILE} -lfl -ly
clean:
	rm *~
run:
	./${FILE}  
run_a:
	./${FILE} < ${IN}