-module(lexer1).
-export([inicio/1]).

inicio(Input) ->
	case file:read_file(Input) of
		{ok, S} -> L = binary_to_list(S),
			stateA(lists:append(L, "$$"), 1, 1, []);
		{error, _} -> stateA(lists:append(Input, "$$"), 1, 1, [])
	end.

%% Estado que identifica entre contenido dinámico (enunciado y expresión) y contenido
%% estático.
%% Lo comentado es una pequeña implementación de busqueda de comentarios que puede
%% ser de utilidad para una posterior iteración
stateA([H1, H2|T], Ren, Col, Result)->
	if
		(H1 == ${) and (H2 == $%)	->stateB(T, Ren, Col + 2, Result, [H2, H1], Ren, Col, enunciado);
		(H1 == ${) and (H2 == ${)	->stateB(T, Ren, Col + 2, Result, [H2, H1], Ren, Col, expresion);
		%(H1 == ${) and (H2 == $#)	->stateN(T, Ren, Col + 2, Result, [H2, H1], Ren, Col, comment);
		H1 == 10	->stateJ([H2|T], Ren + 1, 1, Result, [H1], Ren, Col, estatico);
		(H1 == $$) and (H1 == $$)	->lists:reverse(Result);
		true -> stateJ([H2|T], Ren, Col + 1, Result, [H1], Ren, Col, estatico)
	end.
	
%% Estado que busca el cierre de contenido dinámico y el inicio de un string
stateB([H1,H2|T], Ren, Col, Result, Partial, R, C, Type)->
	if
		(H1 == $}) and (H2 == $})	-> stateI([H1, H2|T], Ren, Col, Result, Partial, R, C, Type);
		(H1 == $%) and (H2 == $})	-> stateI([H1, H2|T], Ren, Col, Result, Partial, R, C, Type);
		H1 == $"	-> stateE([H2|T], Ren, Col + 1, Result, [H1|Partial], R, C, Type);
		H1 == $'	-> stateD([H2|T], Ren, Col + 1, Result, [H1|Partial], R, C, Type);
		H1 == 10 ->  stateB([H2|T], Ren + 1, 1, Result, [H1|Partial], R, C, Type);
		true	-> stateB([H2|T], Ren, Col + 1, Result, [H1|Partial], R, C, Type)
	end.
		
%% Estado que busca el cierre de un string de comiilla sencilla dentro de una de doble comilla
stateC([H|T], Ren, Col, Result, Partial, R, C, Type)->
	if
		H == $"	->stateD(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		true 	->stateC(T, Ren, Col + 1, Result, [H|Partial], R, C, Type)
	end.
	
%% Estado que busca el cierre de un string de comilla sencilla o el inicio de un string de 
%% de comilla doble
stateD([H|T], Ren, Col, Result, Partial, R, C, Type)	->
	if
		%(H == $') and  (Type == comment)	-> stateN(T, Ren, Col, Result, [H|Partial], R, C, Type);
		H == $"	-> stateC(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		H == $'	-> stateB(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		H == $\\	-> stateF(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);            
		H == 10	-> stateD(T, Ren+ 1, 1, Result, [H|Partial], R, C, Type);
		true	-> stateD(T, Ren, Col + 1, Result, [H|Partial], R, C, Type)
	end.
	
%% Tiene la misma funcionalidad que el estado D pero con el inicio de comilla doble
stateE([H|T], Ren, Col, Result, Partial, R, C, Type)	->
	if
		%(H == $") and  (Type == comment)	-> stateN(T, Ren, Col, Result, [H|Partial], R, C, Type);
		H == $"	-> stateB(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		H == $'	-> stateG(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		H == $\\	-> stateH(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		H == 10	-> stateE(T, Ren + 1, 1, Result, [H|Partial], R, C, Type);
		true	-> stateE(T, Ren, Col + 1, Result, [H|Partial], R, C, Type)
	end.
	
%% Estado que escapa caractéres dentro de un string
stateF([H|T], Ren, Col, Result, Partial, R, C, Type)->
	if
		true 	->stateD(T, Ren, Col + 1, Result, [H|Partial], R, C, Type)
	end.
	
%% Tiene la misma funcionalidad que el estado C
stateG([H|T], Ren, Col, Result, Partial, R, C, Type)->
	if
		H == $'	->stateE(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		true 	->stateG(T, Ren, Col + 1, Result, [H|Partial], R, C, Type)
	end.
	
%% Tiene la misma funcionalidad que el estado F
stateH([H|T], Ren, Col, Result, Partial, R, C, Type)->
	if
		true 	->stateE(T, Ren, Col + 1, Result, [H|Partial], R, C, Type)
	end.
		
%% Estado final que guarda los resultados parciales en el resultado final.	
stateI([H1,H2|T], Ren, Col, Result, Partial, R, C, Type)->
	if
		((Type == expresion) and (H1 == $})) or 
		((Type == enunciado) and (H1 == $%)) -> stateA(T, Ren, Col + 2, [{Type, R, C,lists:reverse([H2,H1|Partial])}|Result]);
		%(Type == comment) and (H1 == $#) -> stateA(T, Ren, Col + 2, [{Type, R, C, lists:reverse([H2,H1|Partial])}|Result]);
		(H1 == $$) and (H2 == $$) -> stateA([H1, H2|T], Ren, Col + 2, [{Type, R, C, lists:reverse(Partial)}|Result]);
		((H1 == ${) and (H2 == ${)) or
		((H1 == ${) and (H2 == $%)) -> stateA([H1,H2|T], Ren, Col, [{Type, R, C, lists:reverse(Partial)}|Result]);
		%(H1 == ${) and (H2 == $#) -> stateA([H1,H2|T], Ren, Col, [{Type, R, C, lists:reverse(Partial)}|Result])
		true -> throw(invalidsyntax)
	end.

%%  Estado que identifica todo el contenido estático
stateJ([H1,H2|T], Ren, Col, Result, Partial, R, C, Type)->
	if
		(H1 == ${) and (H2 == $%)	->stateI([H1, H2|T], Ren, Col , Result, Partial, R, C, Type);
		(H1 == ${) and (H2 == ${)	->stateI([H1, H2|T], Ren, Col , Result, Partial, R, C, Type);
		%(H1 == ${) and (H2 == $#)	->stateI([H1,H2|T], Ren, Col, Result, Partial, R, C, Type);
		(H1 == $$) and (H2 == $$)	->stateI([H1, H2|T], Ren, Col , Result, Partial, R, C, Type);
		H1 == 10	->stateJ([H2|T], Ren + 1, 1, Result, [H1|Partial], R, C, Type);
		true	->stateJ([H2|T], Ren, Col + 1, Result, [H1|Partial], R, C, Type)
	end.
