-module(test_lexer2N).
-import(lexer2N, [inicio/1]).
-include_lib("eunit/include/eunit.hrl").

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

%%El cero es tomado como error, será reemplazado por un exception
inicio_entero_invalido_test_() ->
[?_assert(inicio({expresion,100,100,"{{ 567z88}}"}) == 0)].

inicio_float_simbolo_test_() ->
[?_assert(inicio({expresion,11,6,"{{.09 - 0.25 }}"}) == [
        {float,11,8,".09"},
		{simbolo,11,12,"-"},
		{float,11,14,"0.25"}])].

%%El cero es tomado como error, será reemplazado por un exception
inicio_float_invalido_test_() ->
[?_assert(inicio({expresion,0,0,"{{ 0.34r3}}"}) == 0)].


%%El cero es tomado como error, será reemplazado por un exception
inicio_float_invalido_dos_puntos_test_() ->
[?_assert(inicio({expresion,11,6,"{{ 0.090.25 }}"}) == 0)].

inicio_identificador_test_() ->
[?_assert(inicio({expresion,3,9,"{{ hola }}"}) == [
        {identificador,3,12,"hola"}])].

%%El cero es tomado como error, será reemplazado por un exception
inicio_identificador_invalido_mayus_test_() ->
[?_assert(inicio({expresion,1,1,"{{ Hola }}"}) == 0)].

%%El cero es tomado como error, será reemplazado por un exception
inicio_identificador_invalido_num_test_() ->
[?_assert(inicio({expresion,2,2,"{{ 6hola }}"}) == 0)].

%%El cero es tomado como error, será reemplazado por un exception
inicio_identificador_invalido_simbolo_test_() ->
[?_assert(inicio({expresion,1,1,"{{ ?hola }}"}) == 0)].


 