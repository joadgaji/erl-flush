-module(test_eval).
-import(exp_eval, [eval_/1,eval_/2]).

-ifdef(windows) .
-include_lib("C:/tools/eunit/include/eunit.hrl").
-else.
-include_lib("eunit/include/eunit.hrl").
-endif.

eval_num_test_() ->
[?_assert( exp_eval:eval_(49,[]) == 49)].

eval_suma_test_() ->
[?_assert(eval_({'+',1,a},[{a,2}]) == 3)].

%%((8-9)/7)+6
eval_operaciones_anidadas_test_() ->
[?_assert( exp_eval:eval_({'+',{'/',{'-',8,9},7},6},[]) == 5.857142857142857)].

eval_mayor_que_test_() ->
[?_assert(eval_({'<',3.2,3.5},[]) == true)].

eval_menor_que_test_() ->
[?_assert(eval_({'>',3.2,3.5},[]) == false)].

eval_menor_que_con_suma_anidada_test_() ->
[?_assert(eval_({'<',{'+',1,3},10},[]) == true)].

eval_menor_igual__test_() ->
[?_assert(eval_({'=<',7,11},[]) == true)].

eval_mayor_igual_test_() ->
[?_assert(eval_({'>=',7,11},[]) == false)].

eval_igual_igual_test_() ->
[?_assert(eval_({'==',3,3},[]) == true)].

eval_diferente_test_() ->
[?_assert(eval_({'/=',{'+',1,2},3},[]) == false)].

eval_and_test_() ->
[?_assert(eval_({'and',false,true},[]) == false)].

eval_or_test_() ->
[?_assert(eval_({'or',false,true},[]) == true)].

eval_xor_test_() ->
[?_assert(eval_({'xor',true,true},[]) == false)].

eval_not_test_() ->
[?_assert(eval_({'and',{'not',false},true},[]) == true)].

eval_len_test_() ->
[?_assert(eval_({'len',"hola"},[]) == 4)].

eval_concatenacion_test_() ->
[?_assert(eval_({'++',{'++',"ho","l"},"a"},[]) == "hola")].

eval_indice_test_() ->
[?_assert(eval_({'[',2,"hola"},[]) == "o")].

eval_indice_error_no_numerico_test_() ->
[?_assert(eval_({'[',"brrr","hola"},[]) == "error")].

