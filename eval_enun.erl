-module(eval_enun).
-compile(export_all).

-import(exp_eval, [stateG/2]).
-import(lexer2, [iniciol2/1]).
-import(lexer3, [principal/1]).

%% Modulo que es llamado cuando se tiene que analizar un if o un for

%% Si lo que llega es un if, se manda al stateA de eval_if
%% De otrsa manera si es un for se manda al stateA de eval_for
%% Si llega aldo distinto manda un invalidenun
principalEnun([H|T], Result, Dic)	->
	Enunciado = element(1,H),
	if
		Enunciado == 'if' -> 
			eval_if:stateA([H|T],Result, Dic, 1, []);
		Enunciado == 'for' ->
			eval_for:stateA([H|T], T, Result, Dic, [], []);
		true -> throw(invalidenun)
	end.
