 %{

 #include 
 #include 

 int regs [26];
 int base;

 %}

 %start list

 %token DIGIT LETTER

 %left '|'
 %left '&'
 %left '+' '-'
 %left '*' '/' '%'
 %left UMINUS /* устанавливает приоритет унарного минуса */

 %%     /* начало секции правил */

 list :  /* пусто */
      | list stat '\n'
      | list error '\n'
        {
          yyerrok;
        }
 ;

 stat : expr
        {
          (void) printf ("%d\n", $1);
        }
      | LETTER '=' expr
        {
          regs [$1] = $3;
        }
 ;

 expr : '(' expr ')'
        {
          $$ = $2;
        }
        expr '+' expr
        {
          $$ = $1 + $3;
        }
        expr '-' expr
        {
          $$ = $1 - $3;
        }
        expr '*' expr
        {
          $$ = $1 * $3;
        }
        expr '/' expr
        {
          $$ = $1 / $3;
        }
        expr '/' expr
        {
          $$ = $1 / $3;
        }
        expr '%' expr
        {
          $$ = $1 % $3;
        }
        expr '&' expr
        {
          $$ = $1 & $3;
        }
        expr '|' expr
        {
          $$ = $1 | $3;
        }
        '-' expr %prec UMINUS
        {
          $$ = - $2;
        }
        LETTER
        {
          $$ = regs[$1];
        }
        number
 ;

 number : DIGIT
          {
            $$ = $1; base = ($1==0) ? 8 : 10;
          }
          number DIGIT
          {
            $$ = base * $1 + $2;
          }
 ;

 %%      /* начало секции подпрограмм */

 int yylex () /* процедура лексического анализа */
 {            /* возвращает значение LETTER для */
              /* строчной буквы, yylval = от 0 до 25, */
              /* возвращает значение DIGIT для цифры, */
              /* yylval = от 0 до 9, для остальных */
              /* символов возвращается их значение */
  int c;

     /* пропуск пробелов */
  while ((c = getchar ()) == ' ')
    ;

  /* c - не пробел */
  if (islower (c)) {
    yylval = c - 'a';
    return (LETTER);
  }
  if (isdigit (c)) {
    yylval = c - '0';
    return (DIGIT);
  }
  return (c);
}