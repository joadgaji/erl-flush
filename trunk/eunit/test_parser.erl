-module(test_parser).
-import(parser, [parse/1]).

-ifdef(windows) .
-include_lib("C:/tools/eunit/include/eunit.hrl").
-else.
-include_lib("eunit/include/eunit.hrl").
-endif.

parse_num_test_() ->
[?_assert(parse([{entero,1,1,49}]) == {ok,49})].

%%49+10
parse_sum_test_() ->
[?_assert(parse([{entero,1,1,49},{'+',1,3,simbolo},{entero,1,4,10}]) == {ok,{'+',49,10}} )].
		

%%(8+9)*2
parse_parentesis_test_() ->
[?_assert(parse([{'(',1,1,simbolo},{entero,1,2,8},{'+',1,3,simbolo},{entero,1,4,9}, {')',1,5,simbolo},{'*',1,6,simbolo},{entero,5,5,7}]) == {ok,{'*',{'+',8,9},7}})].


%%5-4/2		
parse_precedencia_division_test_() ->
[?_assert(parse([{entero,1,2,5},{'-',1,3,simbolo},{entero,1,4,4}, {'/',1,6,simbolo},{entero,5,5,2}]) == {ok,{'-',5,{'/',4,2}}})].

parse_exp_logicas_test_()	->
[?_assert(parse([{entero,1,2,5},{'or'},{entero,1,3,10}])=={ok,{'or', 5,10}}),
	?_assert(parse([{'not', 4,5},{'('},{identificador, 4,6,'hola'},{')'}])=={ok, {'not', hola}}),
	?_assert(parse([{'not'},{'('},{identificador, 3,4,'bien'},{'/='},{cadena, 5,6,"tu papa"},{')'}])==
	{ok,{'not',{'/=',bien,"tu papa"}}})].
