-module(peval).
-export([principal/2]).
-import(exp_eval, [principal_eval/2]) .

%% Ejecuta todo el exp_eval y revise una lista con lo estatico y lo evaluado
principal(Input, Dic)	->
	L = exp_eval:principal_eval(Input, Dic),
	stateA(L ++ [{final}], []).
	
%% Por cada elemento de la lista revisa si es elemento estatico, float, integer, o atomo
%% para despues convertirlo en lo que corresponda
stateA([H|T], Result)->
	if
		(is_tuple(H)) and (element(1, H) == final)	-> Result;
		is_float(H)	->stateA(T, string:concat(Result, float_to_list(H)));
		is_integer(H)	->stateA(T, string:concat(Result, integer_to_list(H)));
		is_atom(H)	->stateA(T, string:concat(Result, atom_to_list(H)));
		is_tuple(H)	-> stateB([H|T], Result);
		true 	->stateA(T, string:concat(Result, H))
	end.
		
%%si es elemento estatico se agrega solo el contenido de la tupla
stateB([{_,_,_,A}|T], Result)	->
	stateA(T, string:concat(Result, A)).

