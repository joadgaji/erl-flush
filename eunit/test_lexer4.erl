-module(test_lexer4).
-import(lexer4, [iniciol4/2]).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

if_test_() ->
	[?_assert(lexer4:iniciol4({enunciado, 1,2,"{% if x > 6%}"})== {'if',{expresion,1,1,"{{x > 6}}"}}),
	?_assert(lexer4:iniciol4({enunciado, 4,5, "{% if (y > 100) and (x < 25) %}"}) == {'if',{expresion,1,1,"{{(y > 100) and (x < 25) }}"}})].
	
for_test()	->
	[?_assert(lexer4:iniciol4({enunciado, 4,5, "{%for i in x %}"}) == {for,["i"],"x "}),
	?_assert(lexer4:iniciol4({enunciado, 7,8, "{%for k,v in dic%}"}) == {for,["k","v"],"dic"})].
	
else_test() ->
	[?_assert(lexer4:iniciol4({enunciado, 3,4, "{% else%}"}) ==  {else})].
	
endif_test() ->
	[?_assert(lexer4:iniciol4({enunciado, 3,4, "{% endif%}"}) ==  {endif})].
	
endfor_test() ->
	[?_assert(lexer4:iniciol4({enunciado, 3,4, "{% endfor%}"}) ==  {endfor})].
