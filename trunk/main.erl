-module(main).
-export([principal/1]).
-import(parser1, [incio/1]).
-import(lexer1, [inicio/1]).
-import(lexer2, [iniciol2/1]).

principal(Input) ->
	S = lexer1:inicio(parser1:inicio(Input)),
	stateA(S ++ [{final}], []).
	
stateA([H|T], Result) ->
	if
		final == element(1, H) -> lists:reverse(Result);
		expresion == element(1,H) -> stateA(T, [lexer2:iniciol2(H)|Result]);
		true -> stateA(T, [H|Result])
	end.
	
