grammar technology;

technology
    : technology_item+ EOF
    ;

technology_item
    : technology_name ASSIGN technology_body;

technology_name
    : IDENTIFIER
    ;
technology_body
    : LBRACE technology_body_item+ RBRACE
    ;

// 科技属性 key = value
// 属性可能为条件表达式或者属性赋值表达式
    technology_body_item
    : assign_expr
   | assign_statement
    | condition_expr
   | condition_statement
    ;


// 普通的属性赋值表达式
assign_expr
    : assign_key ASSIGN val
    | assign_key ASSIGN assign_statement
    ;
assign_statement
    : LBRACE assign_expr+ RBRACE
    ;

assign_key
    :
    key;
// 条件判断表达式
condition_expr
    : condition_key (ASSIGN|GT|LT|GE|LE|NEQ) val
    | condition_key ASSIGN condition_statement
    ;

// 条件判断块
// A=B
// OR { A=C }
condition_statement
    : LBRACE (condition_expr | LOGICAL_OPERATORS ASSIGN condition_statement)* RBRACE
    ;
condition_key
    :
    key
    | 'weight_modifier'
    | 'modifier'
    ;
key
    : id_
    | attrib
    ;

val
    :
    STRING
    | INTEGER
    | BOOLEAN
    | FLOAT
    | id_
    | key_ref
     |  array_val

    ;
array_val
    : LBRACE key+ RBRACE
    ;

key_ref
    : '@' id_
    ;

attrib
    : id_ accessor (attrib | id_)
    ;

accessor
    : '.'
    | '@'
    | ':'
    ;
id_
    : IDENTIFIER
    | STRING
    | INTEGER
    ;

BOOLEAN
	: YES
	| NO
	;

LOGICAL_OPERATORS
    : AND
    | OR
    | NOT
    ;
IDENTIFIER
    : IDENITIFIERHEAD IDENITIFIERBODY*
    ;

INTEGER
    : [+-]? INTEGERFRAG
    ;
FLOAT
    : [+-]? INTEGERFRAG'.'INTEGERFRAG
    ;


fragment INTEGERFRAG
    : [0-9]+
    ;

fragment IDENITIFIERHEAD
    : [a-zA-Z/]
    ;

fragment IDENITIFIERBODY
    : IDENITIFIERHEAD
    | [0-9_]
    ;


// 运算符
EQUALS    : '==';
ASSIGN    : '=';
GT        : '>';
LT        : '<';
GE        : '>=';
LE        : '<=';
NEQ       : '!=';
PLUS      : '+';
MINUS     : '-';
MULT      : '*';
DIV       : '/';

OR       : 'OR';
AND      : 'AND';
NOT      : 'NOT';
YES      : 'yes';
NO       : 'no';

// 分隔符
LPAREN    : '(';
RPAREN    : ')';
LBRACE    : '{';
RBRACE    : '}';
SEMI      : ';';
COMMA     : ',';

STRING
    : '"' ~["\r\n]* '"'
    ;

COMMENT
    : '#' ~[\r\n]* -> channel(HIDDEN)
    ;

SPACE
    : [ \t\f] -> channel(HIDDEN)
    ;

NL
    : [\r\n] -> channel(HIDDEN)
    ;
WS : [ \t\r\n]+ -> skip;