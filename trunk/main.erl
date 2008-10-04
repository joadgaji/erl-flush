-module(main).
-export([principal/1]).
-import(parser1, [incio/1]).
-import(lexer1, [inicio/1]).
-import(lexer2, [iniciol2/1]).

principal(Input) ->
	R = lexer1:inicio(parser1:inicio(Input)),
	S = stateA(R ++ [{final}], []),
	stateB(S ++ [{final}], []).
	
stateA([H|T], Result) ->
	if
		final == element(1, H) -> lists:reverse(Result);
		expresion == element(1,H) -> stateA(T, [lexer2:iniciol2(H)|Result]);
		true -> stateA(T, [H|Result])
	end.
	
stateB([H|T], Result)	->
	if 
		final == element(1, H) -> lists:reverse(Result);
		is_list(H)	-> stateB(T, [stateC(H ++ [{final, 0,0,0}], [])|Result]);
		true 	-> stateB(T, [H|Result])
	end.
	
stateC([{Type, R, C, A}|T], Partial)	->
	if
		Type == simbolo 	-> stateC(T, [{list_to_atom(A), R, C, Type}|Partial]);
		Type == entero 	-> stateC(T, [{Type, R, C, list_to_integer(lists:concat([X- 48||X <- A]))}|Partial]);
		Type == float 	-> stateC(T, [{Type, R, C, list_to_float(A)}|Partial]);
		Type == cadena 	-> stateC(T, [{Type, R, C, lists:concat([A])}|Partial]);
		Type == final 	-> lists:reverse(Partial);
		true 	-> stateC(T, [{Type, R, C, A}|Partial])
	end.
	
%convert_to_float([H|T], Partial)	->
%	if
%		H == $.	-> covert_to_float(T, [H|Partial]);
%		H == $$	-> list
%		true	->covert_to_float(T, [H-48|Partial]);
