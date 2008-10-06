Nonterminals E T F B I J K G.

Terminals  '<' '>' '==' '/=' '>=' '=<' '+' '-' '*' '%' '/' '(' ')' 'and' 'or' 'xor' 'not' '++' 'len' '[' ']'cadena entero float identificador boolean.

Rootsymbol B.
B -> 'not' '(' B ')': {'not', '$3'}.
B -> I '>' I: {'>', '$1', '$3'}.
B -> I '<' I: {'<','$1','$3'}.
B -> I '==' I: {'==','$1','$3'}.
B -> I '/=' I: {'/=','$1','$3'}.
B -> I '>=' I: {'>=','$1','$3'}.
B -> I '=<' I: {'=<','$1','$3'}.
B -> I: '$1'.
I -> 'len' '(' J ')': {'len', '$3'}.
I -> J: '$1'.
J -> J '++' G : {'++', '$1', '$3'}.
J -> K: '$1'.
K-> cadena: element(4,'$1').
K->E : '$1'.
%L -> identificador: element(4,'$1').
%L -> E: '$1'.
E -> E '+' T: {'+','$1','$3'}.
E -> E '-' T: {'-','$1','$3'}.
E -> E 'and' T: {'and','$1','$3'}.
E -> T: '$1'. 
T -> T '/' F: {'/','$1','$3'}.
T -> T '*' F: {'*','$1','$3'}.
T -> T '%' F: {'%','$1','$3'}.
T -> T 'or' F: {'or','$1','$3'}.
T -> T 'xor' F: {'xor','$1','$3'}.
T -> F: '$1'.
F -> '(' B ')': '$2'.
F -> G '[' E ']': {'[', '$3','$1'}.
F -> '-' F: {'-','$2'}.
%F -> 'not' '(' K ')': {'not', '$3'}.
F -> entero: element(4,'$1').
F -> float: element(4, '$1').
%F -> cadena: element(4, '$1').
F -> boolean: element(4, '$1').
F -> identificador: element(4, '$1').
G -> cadena: element(4, '$1').
