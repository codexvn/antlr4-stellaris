

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
    : (technology_item | scripted_variable_identity)* EOF
    ;
scripted_variable_identity
    : scripted_variable ASSIGN val
    ;
technology_item
    : technology_name ASSIGN technology_body;

technology_name
    : ID
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
    | prereqfor_desc
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
    | weight_groups
    | mod_weight_if_group_picked
    | feature_flags
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
potential_val: trigger_val;
gateway: PROP_KEY_GATEWAY ASSIGN gateway_val;
PROP_KEY_GATEWAY: 'gateway' { lookAheadNonWhitespace(1) == '=' }?;
gateway_val: ID;

weight_groups: PROP_KEY_WEIGHT_GROUPS ASSIGN weight_groups_val;
PROP_KEY_WEIGHT_GROUPS: 'weight_groups' { lookAheadNonWhitespace(1) == '=' }?;
weight_groups_val: id_array_val;
mod_weight_if_group_picked: PROP_KEY_MOD_WEIGHT_IF_GROUP_PICKED  ASSIGN mod_weight_if_group_picked_val;
PROP_KEY_MOD_WEIGHT_IF_GROUP_PICKED: 'mod_weight_if_group_picked' { lookAheadNonWhitespace(1) == '=' }?;
mod_weight_if_group_picked_val: definitions_val;
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
feature_flags_val: val;
starting_potential: PROP_KEY_STARTING_POTENTIAL  ASSIGN starting_potential_val;
PROP_KEY_STARTING_POTENTIAL: 'starting_potential' { lookAheadNonWhitespace(1) == '=' }?;
starting_potential_val: trigger_val;





prerequisites: PROP_KEY_PREREQUISITES  ASSIGN prerequisites_val;
PROP_KEY_PREREQUISITES: 'prerequisites' { lookAheadNonWhitespace(1) == '=' }?;
// 条件数组，每个元素都需要满足
//如 { a b c} 三个都要满足
//如 { a OR = { b c} } a 满足 且 (b 或 c) 满足
prerequisites_val:
block_start
 ( prerequisites_val_1 | prerequisites_val_2 )*
block_end;
prerequisites_val_1 : val;
prerequisites_val_2 : logical_operators ASSIGN prerequisites_val;


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

factor: PROP_KEY_FACTOR ASSIGN factor_val;
PROP_KEY_FACTOR: 'factor'  { lookAheadNonWhitespace(1) == '=' }?;
factor_val: val ;
add: PROP_KEY_ADD  ASSIGN add_val;
PROP_KEY_ADD: 'add'  { lookAheadNonWhitespace(1) == '=' }?;
add_val: val;
inline_script
    :  PROP_KEY_INLINE_SCRIPT ASSIGN (inline_script_val_1|inline_script_val_2);
PROP_KEY_INLINE_SCRIPT: 'inline_script'  { lookAheadNonWhitespace(1) == '=' }?;
inline_script_val_1: LBRACE (key ASSIGN val) + RBRACE;
inline_script_val_2: val;

modifier
    : PROP_KEY_MODIFIER ASSIGN modifier_val
    ;
PROP_KEY_MODIFIER: 'modifier'  { lookAheadNonWhitespace(1) == '=' }?;

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



//事件（event）
//用于定义游戏中发生的具体事件（如外交事件、科技突破、特殊项目等）。
//
//包含触发条件（trigger）、执行结果（effect）、描述文本（title、desc）等。
//event_val: ;






// 效果（effect）
//用于实际执行动作，如给予资源、改变政体、生成舰船、添加特性等。
//
//和 trigger 结构上相似，但用于行动而非判断。
//
//常用于事件选项、decision 执行体、start_effect、on_action 等。
//effect_val: ;





// 触发器（trigger）
//用于条件判断，返回 true/false。
//
//常用于事件触发、decision 是否可用、effect 是否执行等场景。
//
//可以嵌套使用逻辑判断（如 AND、OR、NOT）以及使用上下文敏感的判断。
trigger_val: trigger_body_start logical_block_expr* trigger_body_end;
//修饰符（modifier）
//改变某个国家、舰队、星球、领袖等对象的属性。
//
//常用于科技、传统、政策、特质等地方。
//
//与 effect 不同的是：modifier 是持续性的加成，而 effect 是一次性的动作。
modifier_val
    : LBRACE
        (factor
        | add
        | logical_block_expr
        | inline_script
        )* RBRACE
    ;

//定义项（definitions）
//如 country_types、technology、species_classes 等，提供模板式的数据结构定义。
//
definitions_val
    : LBRACE (key ASSIGN val )* RBRACE
    ;



trigger_body_start
    : LBRACE
    ;
trigger_body_end
    : RBRACE
    ;

logical_block_expr: value_compare_expr|object_compare_expr|logical_expr|if_else_expr|switch_expr|array_compare_expr_val;
block_start
    : LBRACE
    ;
block_end
    : RBRACE
    ;
//a=b
value_compare_expr: value_compare_expr_key relational_operators value_compare_expr_val;
value_compare_expr_key: key;
value_compare_expr_val: val;
//a={b=c}
//a={a b}
object_compare_expr: object_compare_expr_key ASSIGN object_compare_expr_val ;
object_compare_expr_key: key;
object_compare_expr_val: block_start logical_block_expr* block_end;
array_compare_expr_val: val;
//逻辑门运算
// OR { A=C }
logical_expr: logical_expr_key ASSIGN logical_expr_val  ;
logical_expr_key: logical_operators;
logical_expr_val: block_start logical_block_expr* block_end;
//条件运算
// if { A=C }
if_else_expr: if_else_expr_key ASSIGN if_else_expr_val;
if_else_expr_key: IF| ELSE_IF| ELSE;
if_else_expr_val: block_start logical_block_expr* block_end;
switch_expr: switch_expr_key ASSIGN switch_expr_val;
switch_expr_key: SWITCH;
switch_expr_val: block_start logical_block_expr* block_end;




//数值右值
val
    : INTEGER
    | BOOLEAN
    | FLOAT
    | STRING
    | ATTRIB
    | ID
    | id_array_val
    | scripted_variable
    | call_script_trigger
    ;
id_array_val
    : LBRACE ID* RBRACE
    ;
//参数
call_script_trigger: '"'key'"';
//全局变量
scripted_variable : '@' key;
logical_operators
    : AND
    | OR
    | NOT
    | NOR
    | NAND
    ;
relational_operators
    : ASSIGN
    | GT
    | LT
    | GE
    | LE
    | NEQ
    ;


key
    : ID
    | ATTRIB
    ;

ACCESSOR
    : '.'
    | ':'
    ;
VARIABLE_PREFIX
    : '@'
    ;
//以下是token定义
//常量放在最前面
// 运算符常量
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

IF : 'if';
ELSE_IF : 'else_if ';
ELSE : 'else';
SWITCH: 'switch';

OR       : 'OR';
AND      : 'AND';
NOT      : 'NOT';
NOR      : 'NOR';
NAND     : 'NAND';

BOOLEAN: YES | NO;
YES      : 'yes';
NO       : 'no';

// 分隔符
LPAREN    : '(';
RPAREN    : ')';
LBRACE    : '{';
RBRACE    : '}';
SEMI      : ';';
COMMA     : ',';

//宏相关
LBRACKET    : '[';
RBRACKET    : ']';
BANG      : '!';






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
    : [a-zA-Z$|/]
    ;

fragment IDENITIFIERBODY
    : IDENITIFIERHEAD
    | [0-9_]
    ;
ATTRIB
    : ID ACCESSOR (ATTRIB | ID)*
    ;
ID
    : IDENTIFIER
    | INTEGER
    ;

IDENTIFIER
    : IDENITIFIERHEAD IDENITIFIERBODY*
    ;


STRING
    : '"' ~["\r\n]+ '"'
    ;

COMMENT
    : '#' ~[\r\n]* -> channel(HIDDEN)
    ;
LOGGING
    : 'log' ~[\r\n]* -> channel(HIDDEN)
    ;

SPACE
    : [ \t\f] -> channel(HIDDEN)
    ;

NL
    : [\r\n] -> channel(HIDDEN)
    ;
WS : [ \t\r\n]+ -> skip;

BOM: '\uFEFF' -> skip;