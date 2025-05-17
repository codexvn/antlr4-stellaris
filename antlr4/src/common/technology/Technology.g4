grammar Technology;

technology
    : (technology_item | variable_item)* EOF
    ;
technology_item
    : technology_name ASSIGN technology_body;

technology_name
    : IDENTIFIER
    ;
//部分关键字,防止与值冲突
keywork
    : 'technology'
    | 'component'
    | 'ship'
    | 'gateway'
    | 'component_technology'
    | 'ship_technology'
    ;
technology_body
    : LBRACE (
    area
    | tier
    | category
    | icon
    | modifier
    | cost
    | cost_by_script
    | cost_per_level
    | is_rare
    | is_dangerous
    | weight
    | levels
    | prerequisites
    | technology_swap
    | potential
    | gateway
    | repeatable
    | weight_groups
    | mod_weight_if_group_picked
    | start_tech
    | is_reverse_engineerable
    | ai_update_type
    | is_insight
    | feature_flags
    | prereqfor_desc
    | weight_modifier
    | ai_weight
    | starting_potential)+ RBRACE
    ;


area: 'area' ASSIGN val;
tier: 'tier' ASSIGN val;
category: 'category' ASSIGN LBRACE val RBRACE;
icon: 'icon' ASSIGN val;
cost: 'cost' ASSIGN val;
cost_by_script: 'cost' ASSIGN LBRACE(factor| inline_script)*RBRACE;
cost_per_level: 'cost_per_level' ASSIGN val;
is_rare: 'is_rare' ASSIGN val;
is_dangerous: 'is_dangerous' ASSIGN val;
weight: 'weight' ASSIGN (LBRACE factor RBRACE | val);
levels: 'levels' ASSIGN val;
potential: 'potential' ASSIGN condition_statement;
gateway: 'gateway' ASSIGN gateway_enum;
repeatable: 'repeatable' ASSIGN val;
weight_groups: 'weight_groups' ASSIGN val;
mod_weight_if_group_picked: 'mod_weight_if_group_picked' ASSIGN condition_statement;
start_tech: 'start_tech' ASSIGN val;
is_reverse_engineerable: 'is_reverse_engineerable' ASSIGN val;
ai_update_type: 'ai_update_type' ASSIGN val;
is_insight: 'is_insight' ASSIGN val;
feature_flags: 'feature_flags' ASSIGN val;
starting_potential: 'starting_potential' ASSIGN condition_statement;
ai_weight: 'ai_weight' ASSIGN LBRACE
    (weight
     |factor
     | condition_expr
     | modifier
     | inline_script)*
    RBRACE;





prerequisites
    : 'prerequisites' ASSIGN LBRACE
        id_*
        condition_expr*
    RBRACE
    ;

name: 'name' ASSIGN val;
inherit_icon: 'inherit_icon' ASSIGN val;
inherit_name: 'inherit_name' ASSIGN val;
inherit_effects: 'inherit_effects' ASSIGN val;
trigger: 'trigger' ASSIGN condition_statement;
technology_swap
    : 'technology_swap' ASSIGN LBRACE
        (name
         |inherit_icon
         |inherit_name
         |inherit_effects
         |trigger
         |modifier
         |prereqfor_desc
         |area
         |category
         |weight)+
         RBRACE
        ;
factor: 'factor' ASSIGN val;
inline_script
    : 'inline_script' ASSIGN LBRACE
        keyval +
        RBRACE
    |'inline_script' ASSIGN  key;

modifier
    : 'modifier' ASSIGN LBRACE(
        factor
        | condition_expr
        | inline_script
    )* RBRACE
    ;
weight_modifier
    : 'weight_modifier' ASSIGN LBRACE(
    factor
    | condition_expr
    | modifier
    | inline_script
    )* RBRACE
    ;

hide_prereq_for_desc: 'hide_prereq_for_desc' ASSIGN val;
i18: LBRACE (i18_title| i18_desc)+ RBRACE;
i18_title : 'title' ASSIGN val;
i18_desc : 'desc' ASSIGN val;

custom: 'custom' ASSIGN i18;
prereq_for_category: 'prereq_for_category' ASSIGN i18;
component: 'component' ASSIGN i18;
ship: 'ship' ASSIGN i18;
diplo_action: 'diplo_action' ASSIGN i18;
prereqfor_desc
    : 'prereqfor_desc' ASSIGN LBRACE
    (hide_prereq_for_desc
    | custom
    | ship
    | prereq_for_category
    | diplo_action
    | component)*
        RBRACE
    ;
variable_item
    : key_ref ASSIGN val
    ;

// 条件判断表达式
condition_expr
    : condition_key (ASSIGN|GT|LT|GE|LE|NEQ) val
    | condition_key ASSIGN condition_statement
    | LOGICAL_OPERATORS ASSIGN condition_statement
    | has_trait_in_council
    | has_modifier
    | num_buildings
    | has_ancrel
    | has_seen_any_bypass

    ;

has_modifier: 'has_modifier' ASSIGN val;
has_trait_in_council: 'has_trait_in_council' ASSIGN LBRACE keyval + RBRACE;
num_buildings: 'num_buildings' ASSIGN condition_statement;
has_ancrel: 'has_ancrel' ASSIGN val;
has_seen_any_bypass: 'has_seen_any_bypass' ASSIGN val;

// 条件判断块
// A=B
// OR { A=C }
condition_statement
    : LBRACE ( condition_expr | key)* RBRACE
    | array_val
    ;

keyval
    : key ASSIGN val
    ;
key
    : id_
    | attrib
    | tag
    ;
//用于判断的token,如以has或者is开头的
condition_key
    :'has_' IDENTIFIER
    | 'is_' IDENTIFIER
    | key
    ;
val
    :
    normal_val | array_val | keywork
    ;
normal_val
    :
    STRING
    | INTEGER
    | BOOLEAN
    | FLOAT
    | id_
    | attrib
    | key_ref
    | tag
    ;
array_val
    : LBRACE key* RBRACE
    ;

key_ref
    : '@' id_
    ;
//因为有些tag是以#开头的,所以需要全部枚举出来
tag : '#repeatable'| 'repeatable';
gateway_enum
    : 'ship'
    | IDENTIFIER

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
    | NOR
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
NOR      : 'NOR';
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