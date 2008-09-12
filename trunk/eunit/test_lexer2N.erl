-module(test_lexer2N).
-import(lexer2N, [inicio/1]).

-ifdef(windows) .
-include_lib("eunt/include/eunit.hrl").
-else.
-include_lib("eunit/include/eunit.hrl").
-endif.

inicio_vacio_test_() ->
[?_assert(inicio({expresion,11,6,"{{ }}"}) == [])].
		
inicio_cadena_comilla_simple_test_() ->
[?_assert(inicio({expresion,6,20,"{{'flush'}}"}) == [
        {cadena,6,22,"'flush'"}])].

inicio_entero_simbolo_test_() ->
[?_assert(inicio({expresion,4,10,"{{1+2}}"}) == [
        {entero,4,12,"1"}, 
        {simbolo,4,13,"+"}, 
		{entero,4,14,"2"}])].

inicio_entero_invalido_test_() ->
[?_assertThrow(invalidsyntax,inicio({expresion,100,100,"{{ 567z88}}"})].

inicio_float_simbolo_test_() ->
[?_assert(inicio({expresion,11,6,"{{.09 - 0.25 }}"}) == [
        {float,11,8,".09"},
		{simbolo,11,12,"-"},
		{float,11,14,"0.25"}])].


inicio_float_invalido_test_() ->
	[?_assertThrow(invalidsyntax,inicio({expresion,0,0,"{{ 0.34r3}}"})].



inicio_float_invalido_dos_puntos_test_() ->
	[?_assertThrow(invalidsyntax,inicio({expresion,11,6,"{{ 0.090.25 }}"})].

inicio_identificador_test_() ->
[?_assert(inicio({expresion,3,9,"{{ hola }}"}) == [
        {identificador,3,12,"hola"}])].


inicio_identificador_invalido_mayus_test_() ->
	[?_assertThrow(invalidsyntax,inicio({expresion,1,1,"{{ Hola }}"})].


inicio_identificador_invalido_num_test_() ->
	[?_assertThrow(invalidsyntax,inicio({expresion,2,2,"{{ 6hola }}"})].


inicio_identificador_invalido_simbolo_test_() ->
	[?_assertThrow(invalidsyntax,inicio({expresion,1,1,"{{ ?hola }}"})].


inicio_simbolo_parentesistest_() ->
[?_assert(inicio({expresion,32,15,"{{(1+2)*(4-3) }}"}) == [
        {simbolo,32,17,"("},
		{entero,32,18,"1"},
		{simbolo,32,19,"+"},
		{entero,32,20,"2"},
		{simbolo,32,21,")"},
		{simbolo,32,22,"*"},
		{simbolo,32,23,"("},
		{entero,32,24,"8"},
		{simbolo,32,25,"-"},
		{entero,32,26,"3"},
		{simbolo,32,27,")"}].


