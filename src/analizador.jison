/* Definición Léxica */
%lex

%options case-insensitive

%%

"Evaluar"           return 'EVALUAR'
";"					return ';'
"+"					return '+'
"-"					return '-'
"*"					return '*'
"/"					return '/'
"("					return '('
")"					return ')'
"["					return '['
"]"					return ']'

/* Espacios en blanco */
\s+                 /* ignorar */

[0-9]+("."[0-9]+)?\b    return 'NUMERO'

<<EOF>>                 return 'EOF'

.                       { alert('Error léxico:  ' + yytext + '.\nEn la linea: ' + yylloc.first_line + ' y columna: ' + yylloc.first_column); }
/lex

/* Asociación de operadores y precedencia */

%left '+' '-'
%left '*' '/'
%left UMENOS

%start ini

%% /* Definición de la gramática */

ini
	: instrucciones EOF { return $1; }
;

instrucciones
	: instrucciones instruccion		{ $$ = $1.concat('\n', $2); }
	| instruccion					{ $$ = $1; }
	| error { alert('Error sintáctico:  ' + yytext + '.\nEn la linea: ' + this._$.first_line + ' y columna: ' + this._$.first_column); }
;

instruccion
	: 'EVALUAR' '[' exp ']' ';' {
		var msg = 'El valor de la expresión es: ';
		$$ = msg.concat($3);
	}
;

exp
	: '-' exp %prec UMENOS	{ $$ = $2 * -1; }
	| exp '+' exp       	{ $$ = $1 + $3; }
	| exp '-' exp     		{ $$ = $1 - $3; }
	| exp '*' exp       	{ $$ = $1 * $3; }
	| exp '/' exp  			{ $$ = $1 / $3; }
	| '(' exp ')'      		{ $$ = $2; }
	| NUMERO                { $$ = Number($1); }
;