-module(eval_enun).
-compile(export_all).

-import(exp_eval, [stateG/2]).
-import(lexer2, [iniciol2/1]).
-import(lexer3, [principal/1]).

principalEnun([H|T], Result, Dic)	->
	Enunciado = element(1,H),
	if
		Enunciado == 'if' -> 
			eval_if:stateA([H|T],Result, Dic, 1, []);
		Enunciado == 'for'	->
			eval_for:stateA([H|T], T, Result, Dic, Dic, []);
		true -> throw(invalidenun)
	end.
