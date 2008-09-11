-module(test_lexer2N).
-import(lexer2N, [inicio/1]).
-export([inicio_test_vacio_/0,inicio_test_cadena_comilla_simple_/0,inicio_test_entero_simbolo_/0,
inicio_test_entero_invalido_/0,inicio_test_float_simbolo_/0,inicio_test_float_invalido_/0,inicio_test_float_invalido_dos_puntos_/0,
inicio_test_identificador_/0, inicio_test_identificador_invalido_mayus_/0,inicio_test_identificador_invalido_num_/0,inicio_test_identificador_invalido_simbolo_/0]).
-include_lib("C:/tools/eunit/include/eunit.hrl").

inicio_test_vacio_() ->
[?_assert(inicio({expresion,11,6,"{{ }}"}) == [])].
		
inicio_test_cadena_comilla_simple_() ->
[?_assert(inicio({expresion,6,20,"{{'flush'}}"}) == [
        {cadena,6,22,"'flush'"}])].

inicio_test_entero_simbolo_() ->
[?_assert(inicio({expresion,4,10,"{{1+2}}"}) == [
        {entero,4,12,"1"}, 
        {simbolo,4,13,"+"}, 
		{entero,4,14,50,"2"}])].

%%El cero es tomado como error, será reemplazado por un exception
inicio_test_entero_invalido_() ->
[?_assert(inicio({expresion,100,100,"{{ 567z88}}"}) == 0)].

inicio_test_float_simbolo_() ->
[?_assert(inicio({expresion,11,6,"{{.09 - 0.25 }}"}) == [
        {float,11,8,".09"},
		{simbolo,11,12,"-"},
		{float,11,14,"0.25"}])].

%%El cero es tomado como error, será reemplazado por un exception
inicio_test_float_invalido_() ->
[?_assert(inicio({expresion,0,0,"{{ 0.34r3}}"}) == 0)].


%%El cero es tomado como error, será reemplazado por un exception
inicio_test_float_invalido_dos_puntos_() ->
[?_assert(inicio({expresion,11,6,"{{ 0.090.25 }}"}) == 0)].

inicio_test_identificador_() ->
[?_assert(inicio({expresion,3,9,"{{ hola }}"}) == [
        {identificador,3,12,"hola"}])].

%%El cero es tomado como error, será reemplazado por un exception
inicio_test_identificador_invalido_mayus_() ->
[?_assert(inicio({expresion,1,1,"{{ Hola }}"}) == 0)].

%%El cero es tomado como error, será reemplazado por un exception
inicio_test_identificador_invalido_num_() ->
[?_assert(inicio({expresion,2,2,"{{ 6hola }}"}) == 0)].

%%El cero es tomado como error, será reemplazado por un exception
inicio_test_identificador_invalido_simbolo_() ->
[?_assert(inicio({expresion,1,1,"{{ ?hola }}"}) == 0)].


 