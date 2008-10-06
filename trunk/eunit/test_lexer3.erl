-module(test_lexer3).
-import(lexer3, [principal/1]).

-ifdef(windows) .
-include_lib("C:/tools/eunit/include/eunit.hrl").
-else.
-include_lib("eunit/include/eunit.hrl").
-endif.

principal_entero_test_()	->
[?_assert(principal([{entero, 1,2, "12"}])==[{entero, 1,2,12}])].

principal_float_test_()	->
[?_assert(principal([{float, 1,2, "34.69"}])==[{float, 1,2, 34.69000}])].

principal_cadena_test_()	->
[?_assert(principal([{cadena, 3,4, "micadena"}])==[{cadena,3,4,"micadena"}])].

principal_identificador_test_()	->
[?_assert(principal([{identificador, 4,5,"or"}])==[{'or', 4,5,identificador}]),
	?_assert(principal([{identificador, 6,7, "len"}])==[{'len', 6,7, identificador}]),
	?_assert(principal([{identificador, 23,56, "not"}])==[{'not', 23,56, identificador}])].
	
principal_sinbolos_test_()	->
[?_assert(principal([{simbolo, 34,56,"("}])==[{'(', 34,56, simbolo}]),
	?_assert(principal([{simbolo, 34,56,"="}])==[{'=', 34,56, simbolo}]),
	?_assert(principal([{simbolo, 34,35,"="}, {simbolo, 34,36, "<"}])==[{'=<', 34,35, simbolo}]),
	?_assert(principal([{simbolo, 34,35,"="}, {simbolo, 34,37, "("}])==[{'=', 34,35, simbolo},{'(', 34,37,simbolo}]),
	?_assert(principal([{simbolo, 34,35,"="}, {entero, 34,36, "10"}])==[{'=', 34,35, simbolo},{entero, 34,36,10}])
	].
