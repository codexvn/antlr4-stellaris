grammar Technology;

technology
    : (technology_item | variable)* EOF
    ;
variable
    : key_ref ASSIGN val
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
    : assign_expr_key ASSIGN val
    |  ASSIGN assign_statement
    ;

assign_expr_key
    : assign_key
    | key
    ;
assign_statement
    : LBRACE assign_expr+ RBRACE
    ;

assign_key
    :
    ;


// 条件判断表达式
condition_expr
    : condition_expr_key (ASSIGN|GT|LT|GE|LE|NEQ) val
    | condition_expr_key ASSIGN condition_statement
    ;
condition_expr_key
    : condition_key
    | key
    ;

// 条件判断块
// A=B
// OR { A=C }
condition_statement
    : LBRACE (  condition_expr | LOGICAL_OPERATORS ASSIGN condition_statement | key)* RBRACE
    | array_val
    ;
condition_key
    : 'weight_modifier'
    | 'modifier'
    |
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
    | attrib
    | key_ref

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
    : '"' ~["\r\n]+ '"'
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

BOM: '\uFEFF' -> skip;