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
parse_operaciones_aritmeticas_test_() ->
[?_assert(parse([{entero,1,1,49},{'+',1,3,simbolo},{entero,1,4,10}]) == {ok,{'+',49,10}} ),
	?_assert(parse([{entero, 3,4, 4956}, {'-'},{float,4,6, 34.6}])=={ok,{'-',4956,34.6000}}),
	?_assert(parse([{entero,5,7,3},{'*'},{'('},{entero, 3,4, 4956}, {'-'},{float,4,6, 34.6},{')'}])=={ok,{'*',3,{'-',4956,34.6000}}})].
		

%%(8+9)*2
parse_parentesis_test_() ->
[?_assert(parse([{'(',1,1,simbolo},{entero,1,2,8},{'+',1,3,simbolo},{entero,1,4,9}, {')',1,5,simbolo},{'*',1,6,simbolo},{entero,5,5,7}]) == {ok,{'*',{'+',8,9},7}})].


%%5-4/2		
parse_precedencia_division_test_() ->
[?_assert(parse([{entero,1,2,5},{'-',1,3,simbolo},{entero,1,4,4}, {'/',1,6,simbolo},{entero,5,5,2}]) == {ok,{'-',5,{'/',4,2}}})].


parse_exp_logicas_test_()	->
[?_assert(parse([{'not', 4,5},{'('},{identificador, 4,6,'hola'},{')'}])=={ok, {'not', hola}}),
	?_assert(parse([{'not'},{'('},{identificador, 3,4,'bien'},{'/='},{cadena, 5,6,"bueno"},{')'}])==
	{ok,{'not',{'/=',bien,"bueno"}}}),
	?_assert(parse([{boolean,1,2,'false'},{'xor'},{boolean,1,3,'true'}])=={ok,{'xor', 'false','true'}}),
	?_assert(parse([{boolean,1,2,'false'},{'and'},{boolean,1,3,'true'},{'or'}, {boolean,2,4,'true'}])=={ok,{'and','false', {'or','true','true'}}})].
	
parse_exp_relacionales_test_() ->
[?_assert(parse([{identificador, 3,4,'bien'},{'<'},{cadena, 5,6,"bueno"}])== {ok,{'<',bien,"bueno"}}),
	?_assert(parse([{entero, 3,4,65},{'>='},{float, 5,6,12.9}])=={ok,{'>=', 65,12.9000}}),
	?_assert(parse([{entero, 3,4,65},{'=<'},{float, 5,6,12.9},{'/'},{float,5,7,34.9}])==
	{ok,{'=<',65,{'/',12.9000,34.9000}}}),
	?_assert(parse([{boolean, 3,4,'false'},{'=='},{boolean, 5,6,'true'},{'and'},{boolean,5,7,'false'}])==
	{ok,{'==','false',{'and','true','false'}}})].
	
parse_metodos_cadena_test_()	->
[?_assert(parse([{cadena, 3,4,"cad1"},{'++'},{cadena, 5,6,"cad2"}])=={ok,{'++',"cad1","cad2"}}),
	?_assert(parse([{cadena, 3,4,"cad1"},{'++'},{cadena, 5,6,"cad2"},{'++'},{cadena,5,7,"cad3"}])==
	{ok,{'++',{'++', "cad1", "cad2"},"cad3"}}),
	?_assert(parse([{'len'},{'('},{cadena, 5,6,"cad2"},{')'}])=={ok,{'len', "cad2"}}),
	?_assert(parse([{cadena, 5,6,"cad2"},{'['},{entero,5,6,3},{'+'},{entero,5,7,6},{']'}])=={ok,{'[',{'+',3,6},"cad2"}})].
