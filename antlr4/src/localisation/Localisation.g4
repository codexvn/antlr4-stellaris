grammar Localisation;

localisation:
    language_type COLON
    localisation_item* EOF
    ;

localisation_item :
    title COLON title_val
    | title_desc COLON title_desc_val
    ;
//待补全
language_type
    : 'l_simp_chinese'
    | 'l_english'
    ;

title: TITLE_KEY;
title_val: STRING;
title_desc: TITLE_DESC_KEY;
title_desc_val: STRING;
//desc需要排在前面,保证优先级
TITLE_DESC_KEY
    : [a-zA-Z0-9_]+'_desc'
    ;
TITLE_KEY
    : [a-zA-Z0-9_]+
    ;

STRING
    : '"' ~["\r\n]+ '"'
    ;

// 分隔符
COLON    : ':';

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