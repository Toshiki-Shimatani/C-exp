%{
 int num_lines = 0, num_chars = 0, wordCount = 0, num_numbers = 0;
%}
%%
[a-zA-Z] wordCount++; ++num_chars;
[0-9]+ num_numbers++; num_chars += yyleng;
\n   ++num_lines; ++num_chars;
.   ++num_chars;
%%
int main(void){
   yylex();
   printf("#of lines = %d, #of chars = %d, # of words = %d, # of digits = %d\n",
  num_lines,num_chars,wordCount, num_numbers);
   return 0;
}
