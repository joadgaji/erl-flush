-module(lexer3).
-export([principal/1]).
-import(comment, [incio/1]).
-import(lexer1, [inicio/1]).
-import(lexer2, [iniciol2/1]).

principal(Input) ->
	stateA(Input ++ [{final, 0,0,0}], []).
	
% Este estado convierte las secuencia de string a su respectivo valor en entero, simbolo, float, cadena o identificador
stateA([{Type, R, C, A}|T], Partial)	->
	if
		Type == simbolo	-> stateC(T, Partial, R, C, A);
		Type == entero 	-> stateA(T, [{Type, R, C, list_to_integer(A)}|Partial]);
		Type == float 	-> stateA(T, [{Type, R, C, list_to_float("0"++A)}|Partial]);
		% El string cuando es leido de un archivo viene con commillas dobles 
		Type == cadena	-> stateA(T, [{Type, R, C, string:sub_string(lists:concat([A]),2,string:len(A)-1)}|Partial]);
		Type == identificador	-> stateB([{Type, R, C, A}|T], Partial);
		Type == final 	-> lists:reverse(Partial);
		true 	-> throw(invalidsyntax)
	end.

%Revisa los identificadores or, and, not y xor para convertirlos en atomos 
stateB([{Type, R, C, A}|T], Partial)	->
	if
		(A == "or") or (A == "and") or (A == "xor")
		or (A == "not") or (A == "len") -> stateA(T, [{list_to_atom(A), R, C, Type}|Partial]);
		(A == "true")	or (A == "false") -> stateA(T, [{boolean, R, C, list_to_atom(A)}|Partial]);
		true 	-> stateA(T, [{Type, R, C, list_to_atom(A)}|Partial])
	end.              
	
% Revisa la secuencia de simbolos ==, /=, =<, >= ++ para convertirlo a simbolos
stateC([{Type, R2, C2, A2}|T], Partial, R1, C1, A1)	->
	if
		(Type /= simbolo ) 	-> stateA([{Type, R2,C2,A2}|T], [{list_to_atom(A1), R1, C1, simbolo}|Partial]);
		(C1 + 1 == C2) and (((A1 == "=") and (A2 == "=")) or 
		((A1 == "=") and (A2 == "<")) or
		((A1 == ">") and (A2 == "=")) or
		((A1 == "/") and (A2 == "=")) or
		((A1 == "+") and (A2 == "+"))) 	-> stateA(T, [{list_to_atom(A1++A2), R1, C1, simbolo}|Partial]);
		true	->  stateA([{Type, R2,C2,A2}|T], [{list_to_atom(A1), R1, C1, simbolo}|Partial])
	end.
