

grammar Technology;
//https://stellaris.paradoxwikis.com/Technology_modding
@members {
    // Java 自定义方法，跳过空格字符来获取第k个字符
    public int lookAheadNonWhitespace(int k) {
        int index = 1;
        int seen = 0;
        while (true) {
            int c = _input.LA(index);
            if (c == IntStream.EOF) return c;
            if (!Character.isWhitespace(c)) {
                seen++;
                if (seen == k) return c;
            }
            index++;
        }
    }
}
root
    : (technology_item | variable_item)* EOF
    ;
technology_item
    : technology_name ASSIGN technology_body;

technology_name
    : IDENTIFIER
    ;
//部分关键字,防止与值冲突
technology_body_start
    : LBRACE
    ;
technology_body_end
    : RBRACE
    ;

technology_body
    : technology_body_start (
      area
    | tier
    | category
    | potential
    | ai_update_type
    | prerequisites
    | is_reverse_engineerable
    | start_tech
    | is_rare
    | is_dangerous
    | is_insight
    | weight_modifier
    | icon
    | modifier
    | cost
    | cost_by_script
    | cost_per_level
    | weight
    | levels
    | technology_swap
    | gateway
    | repeatable
    | weight_groups
    | mod_weight_if_group_picked
    | feature_flags
    | prereqfor_desc
    | ai_weight
    | starting_potential)+ technology_body_end
    ;

area: PROP_KEY_AREA ASSIGN area_val;
PROP_KEY_AREA:  'area' { lookAheadNonWhitespace(1) == '=' }?;
area_val: val;
tier: PROP_KEY_TIER ASSIGN tier_val;
PROP_KEY_TIER: 'tier' { lookAheadNonWhitespace(1) == '=' }?;
tier_val: val;
category: PROP_KEY_CATEGORY ASSIGN  category_val ;
PROP_KEY_CATEGORY : 'category' { lookAheadNonWhitespace(1) == '=' }?;
//# Physics
//field_manipulation, particles, computing
//
//# Society
//psionics, new_worlds, statecraft, biology, military_theory
//
//# Engineering
//materials, rocketry, voidcraft, industry
category_val: LBRACE val RBRACE;
icon: PROP_KEY_ICON ASSIGN icon_val;
PROP_KEY_ICON: 'icon' { lookAheadNonWhitespace(1) == '=' }?;
icon_val: val;
cost: PROP_KEY_COST ASSIGN cost_val;
PROP_KEY_COST: 'cost' { lookAheadNonWhitespace(1) == '=' }?;
cost_val: val;
cost_by_script: PROP_KEY_COST  ASSIGN  cost_by_script_val ;
cost_by_script_val: LBRACE (factor| inline_script)* RBRACE;
cost_per_level: PROP_KEY_COST_PER_LEVEL ASSIGN cost_per_level_val;
PROP_KEY_COST_PER_LEVEL: 'cost_per_level' { lookAheadNonWhitespace(1) == '=' }?;
cost_per_level_val: val;
is_rare: PROP_KEY_IS_RARE ASSIGN is_rare_val;
PROP_KEY_IS_RARE: 'is_rare' { lookAheadNonWhitespace(1) == '=' }?;
is_rare_val: BOOLEAN;
is_dangerous: PROP_KEY_IS_DANGEROUS ASSIGN is_dangerous_val;
PROP_KEY_IS_DANGEROUS: 'is_dangerous' { lookAheadNonWhitespace(1) == '=' }?;
is_dangerous_val: BOOLEAN;
weight: PROP_KEY_WEIGHT  ASSIGN (weight_val1|weight_val2);
PROP_KEY_WEIGHT: 'weight' { lookAheadNonWhitespace(1) == '=' }?;
weight_val1: LBRACE factor RBRACE;
weight_val2: val;
levels: PROP_KEY_LEVELS ASSIGN levels_val;
PROP_KEY_LEVELS: 'levels' { lookAheadNonWhitespace(1) == '=' }?;
levels_val: val;
potential: PROP_KEY_POTENTIAL  ASSIGN potential_val;
PROP_KEY_POTENTIAL: 'potential' { lookAheadNonWhitespace(1) == '=' }?;
potential_val: condition_statement;
gateway: PROP_KEY_GATEWAY ASSIGN gateway_val;
PROP_KEY_GATEWAY: 'gateway' { lookAheadNonWhitespace(1) == '=' }?;
gateway_val: IDENTIFIER;

repeatable: PROP_KEY_REPEATABLE ASSIGN repeatable_val;
PROP_KEY_REPEATABLE: 'repeatable' { lookAheadNonWhitespace(1) == '=' }?;
repeatable_val: val;
weight_groups: PROP_KEY_WEIGHT_GROUPS ASSIGN weight_groups_val;
PROP_KEY_WEIGHT_GROUPS: 'weight_groups' { lookAheadNonWhitespace(1) == '=' }?;
weight_groups_val: array_val;
mod_weight_if_group_picked: PROP_KEY_MOD_WEIGHT_IF_GROUP_PICKED  ASSIGN mod_weight_if_group_picked_val;
PROP_KEY_MOD_WEIGHT_IF_GROUP_PICKED: 'mod_weight_if_group_picked' { lookAheadNonWhitespace(1) == '=' }?;
mod_weight_if_group_picked_val: condition_statement;
start_tech: PROP_KEY_START_TECH ASSIGN start_tech_val;
PROP_KEY_START_TECH: 'start_tech' { lookAheadNonWhitespace(1) == '=' }?;
start_tech_val: BOOLEAN;
is_reverse_engineerable: PROP_KEY_IS_REVERSE_ENGINEERABLE  ASSIGN is_reverse_engineerable_val;
PROP_KEY_IS_REVERSE_ENGINEERABLE: 'is_reverse_engineerable' { lookAheadNonWhitespace(1) == '=' }?;
is_reverse_engineerable_val: BOOLEAN;
ai_update_type: PROP_KEY_AI_UPDATE_TYPE  ASSIGN ai_update_type_val;
PROP_KEY_AI_UPDATE_TYPE: 'ai_update_type' { lookAheadNonWhitespace(1) == '=' }?;
ai_update_type_val: val;
is_insight: PROP_KEY_IS_INSIGHT ASSIGN is_insight_val;
PROP_KEY_IS_INSIGHT: 'is_insight' { lookAheadNonWhitespace(1) == '=' }?;
is_insight_val: BOOLEAN;
feature_flags: PROP_KEY_FEATURE_FLAGS  ASSIGN feature_flags_val;
PROP_KEY_FEATURE_FLAGS: 'feature_flags' { lookAheadNonWhitespace(1) == '=' }?;
feature_flags_val: array_val;
starting_potential: PROP_KEY_STARTING_POTENTIAL  ASSIGN starting_potential_val;
PROP_KEY_STARTING_POTENTIAL: 'starting_potential' { lookAheadNonWhitespace(1) == '=' }?;
starting_potential_val: condition_statement;





prerequisites: PROP_KEY_PREREQUISITES  ASSIGN prerequisites_val;
PROP_KEY_PREREQUISITES: 'prerequisites' { lookAheadNonWhitespace(1) == '=' }?;
prerequisites_val: condition_statement;


technology_swap: PROP_KEY_TECHNOLOGY_SWAP ASSIGN technology_swap_val;
PROP_KEY_TECHNOLOGY_SWAP: 'technology_swap'  { lookAheadNonWhitespace(1) == '=' }?;
technology_swap_val
    : LBRACE
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
name: PROP_KEY_NAME ASSIGN name_val;
PROP_KEY_NAME: 'name'  { lookAheadNonWhitespace(1) == '=' }?;
name_val: val;
inherit_icon: PROP_KEY_INHERIT_ICON ASSIGN inherit_icon_val;
PROP_KEY_INHERIT_ICON: 'inherit_icon'  { lookAheadNonWhitespace(1) == '=' }?;
inherit_icon_val: val;
inherit_name: PROP_KEY_INHERIT_NAME ASSIGN inherit_name_val;
PROP_KEY_INHERIT_NAME: 'inherit_name'  { lookAheadNonWhitespace(1) == '=' }?;
inherit_name_val: val;
inherit_effects: PROP_KEY_INHERIT_EFFECTS  ASSIGN inherit_effects_val;
PROP_KEY_INHERIT_EFFECTS: 'inherit_effects'  { lookAheadNonWhitespace(1) == '=' }?;
inherit_effects_val: val;
trigger: PROP_KEY_TRIGGER ASSIGN trigger_val;
PROP_KEY_TRIGGER: 'trigger'  { lookAheadNonWhitespace(1) == '=' }?;
trigger_val: condition_statement;

factor: PROP_KEY_FACTOR ASSIGN factor_val;
PROP_KEY_FACTOR: 'factor'  { lookAheadNonWhitespace(1) == '=' }?;
factor_val: normal_val;
add: PROP_KEY_ADD  ASSIGN add_val;
PROP_KEY_ADD: 'add'  { lookAheadNonWhitespace(1) == '=' }?;
add_val: FLOAT|normal_val;
inline_script
    :  PROP_KEY_INLINE_SCRIPT ASSIGN (inline_script_val_1|inline_script_val_2);
PROP_KEY_INLINE_SCRIPT: 'inline_script'  { lookAheadNonWhitespace(1) == '=' }?;
inline_script_val_1: LBRACE (key ASSIGN val) + RBRACE;
inline_script_val_2: key;

modifier
    : PROP_KEY_MODIFIER ASSIGN modifier_val
    ;
PROP_KEY_MODIFIER: 'modifier'  { lookAheadNonWhitespace(1) == '=' }?;
modifier_val
    : LBRACE
        (factor
        | add
        | compare_condition_expr
        | op_condition_expr
        | inline_script
        )* RBRACE
    ;
weight_modifier: PROP_KEY_WEIGHT_MODIFIER ASSIGN weight_modifier_val;
PROP_KEY_WEIGHT_MODIFIER: 'weight_modifier'  { lookAheadNonWhitespace(1) == '=' }?;
weight_modifier_val: LBRACE(factor| add| modifier| inline_script)* RBRACE;
ai_weight: PROP_KEY_AI_WEIGHT ASSIGN ai_weight_val ;
PROP_KEY_AI_WEIGHT: 'ai_weight'  { lookAheadNonWhitespace(1) == '=' }?;
ai_weight_val: LBRACE( base|weight|factor| add| modifier| inline_script)* RBRACE;
base: PROP_KEY_BASE ASSIGN base_val;
PROP_KEY_BASE: 'base'  { lookAheadNonWhitespace(1) == '=' }?;
base_val: val;
hide_prereq_for_desc: PROP_KEY_HIDE_PREREQ_FOR_DESC ASSIGN hide_prereq_for_desc_val;
PROP_KEY_HIDE_PREREQ_FOR_DESC: 'hide_prereq_for_desc'  { lookAheadNonWhitespace(1) == '=' }?;
hide_prereq_for_desc_val : val;

prereqfor_desc : PROP_KEY_PREREQ_FOR_DESC ASSIGN prereqfor_desc_val;
PROP_KEY_PREREQ_FOR_DESC: 'prereqfor_desc'  { lookAheadNonWhitespace(1) == '=' }?;
prereqfor_desc_val: LBRACE(
    hide_prereq_for_desc
    | key ASSIGN i18_val
    )* RBRACE;
i18_val: LBRACE (i18_title| i18_desc)+ RBRACE;
i18_title : PROP_KEY_TITLE ASSIGN i18_title_val;
PROP_KEY_TITLE: 'title'  { lookAheadNonWhitespace(1) == '=' }?;
i18_title_val : val;
i18_desc : PROP_KEY_DESC ASSIGN i18_desc_val;
PROP_KEY_DESC: 'desc'  { lookAheadNonWhitespace(1) == '=' }?;
i18_desc_val : val;

variable_item
    : key_ref ASSIGN val
    ;

//逻辑门条件表达式
op_condition_expr: LOGICAL_OPERATORS ASSIGN condition_statement;

// 条件判断表达式
condition_expr
    : compare_condition_expr
    | op_condition_expr
    | in_condition_expr
    ;
// 条件判断块
// A=B
// OR { A=C }
condition_statement
    : LBRACE condition_expr* RBRACE
    ;

//数据比较条件表达式
compare_condition_expr: value_compare_condition_expr| object_compare_condition_expr;
//在列表中
in_condition_expr:  id_+;
//用于数据的比较
value_compare_condition_expr: condition_key value_compare val;
//条件块条件表达式
object_compare_condition_expr: condition_key ASSIGN condition_statement;
//是否在数组中
condition_key: key ;

array_val
    : LBRACE val* RBRACE
    ;

val
    : normal_val;

normal_val
    :
    STRING
    | INTEGER
    | BOOLEAN
    | FLOAT
    | key
    | key_ref
    ;
key
    : id_
    | attrib
    | tag
    ;

key_ref
    : '@' id_
    ;
//因为有些tag是以#开头的,所以需要全部枚举出来
tag : '#repeatable'| 'repeatable';
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

value_compare
    : ASSIGN
    |  GT
   |  LT
     | GE
     | LE
    |  NEQ
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
COLON    : ':';

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
