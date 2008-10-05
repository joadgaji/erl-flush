-module(lexer3).
-export([principal/1]).
-import(comment, [incio/1]).
-import(lexer1, [inicio/1]).
-import(lexer2, [iniciol2/1]).

% Activa el lexer1 que quita comentarios
principal(Input) ->
	R = lexer1:inicio(comment:inicio(Input)),
	S = stateA(R ++ [{final}], []),
	stateB(S ++ [{final}], []).
	
% Activa el lexer2 para las tuplas que son expresiones
stateA([H|T], Result) ->
	if
		final == element(1, H) -> lists:reverse(Result);
		expresion == element(1,H) -> stateA(T, [lexer2:iniciol2(H)|Result]);
		true -> stateA(T, [H|Result])
	end.
	
% Revisa la lista de tuplas de las expresiones para crear nuestra sintaxis para mandar a parser
stateB([H|T], Result)	->
	if 
		final == element(1, H) -> lists:reverse(Result);
		is_list(H)	-> stateB(T, [stateC(H ++ [{final, 0,0,0}], [])|Result]);
		true 	-> stateB(T, [H|Result])
	end.
	
% Este estado convierte las secuencia de string a su respectivo valor en entero, simbolo, float, cadena o identificador
stateC([{Type, R, C, A}|T], Partial)	->
	if
		Type == simbolo	-> stateE(T, Partial, R, C, A);
		Type == entero 	-> stateC(T, [{Type, R, C, list_to_integer(A)}|Partial]);
		Type == float 	-> stateC(T, [{Type, R, C, list_to_float(A)}|Partial]);
		Type == cadena 	-> stateC(T, [{Type, R, C, lists:concat([A])}|Partial]);
		Type == identificador 	-> stateD([{Type, R, C, A}|T], Partial);
		Type == final 	-> lists:reverse(Partial);
		true 	-> throw(invalidsyntax)
	end.

%Revisa los identificadores or, and, not y xor para convertirlos a atomos 
stateD([{Type, R, C, A}|T], Partial)	->
	if
		(A == "or") or (A == "and") or
		(A == "xor") or (A == "not")	-> stateC(T, [{list_to_atom(A), R, C, Type}|Partial]);
		true 	-> stateC(T, [{Type, R, C, A}|Partial])
	end.              
	
% Revisa la secuencia de simbolos ==, /=, =<, >= para convertirlo a simbolos
stateE([{Type, R2, C2, A2}|T], Partial, R1, C1, A1)	->
	if
		(Type /= simbolo ) 	-> stateC([{Type, R2,C2,A2}|T], [{list_to_atom(A1), R1, C1, simbolo}|Partial]);
		(C1 + 1 == C2) and (((A1 == "=") and (A2 == "=")) or 
		((A1 == "=") and (A2 == "<")) or
		((A1 == ">") and (A2 == "=")) or
		((A1 == "/") and (A2 == "="))) 	-> stateC(T, [{list_to_atom(A1++A2), R1, C1, simbolo}|Partial]);
		true	->  stateC([{Type, R2,C2,A2}|T], [{list_to_atom(A1), R1, C1, simbolo}|Partial])
	end.
