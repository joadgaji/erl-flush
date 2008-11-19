-module(convert_term).
-compile(export_all).

-import(exp_eval, [stateG/2]).
-import(lexer2, [iniciol2/1]).
-import(lexer3, [principal/1]).
-import(eval_enun, [principalEnun/3]).

-define(IN_RANGE(X, Start, End), (((Start) =< (X)) and ((X) =< (End)))). 
-define(IS_LOWER(X), ?IN_RANGE(X, $a, $z)).
-define(IS_UPPER(X), ?IN_RANGE(X, $A, $Z)).
-define(IS_LETTER(X), (?IS_LOWER(X) or ?IS_UPPER(X))).

convert(Exp)	-> 
	if 
		hd(Exp) == $[	-> 
			[H|T] = lexer3:principal(lexer2:iniciol2({expresion, 1,1, "{{" ++ string:concat(metodo1(Exp ++ [final], []),"}}")}));
		true	-> [H|T] = Exp
	end,
		io:format("H ~p~n T ~p~n", [H, T]),
	if
		element(1, H) == '['	-> stateA(T, []);
		true -> Exp
	end.
	
stateA([H|T], Result) 	->
	Comp = element(1, H),
	if
		(Comp == entero) or (Comp == cadena) or (Comp == 'float')	->
			stateB(T, [element(4,H)|Result]);
		(Comp == '{')	->
			stateD(T, Result, []);
		true	-> throw(invalidValue)
	end.
	
stateB([H|T], Result)	->
	Comp = element(1,H),
	if
		Comp == ','	-> stateC(T, Result);
		Comp == ']'	-> lists:reverse(Result);
		true	->throw(invalidList)
	end.
	
stateC([H|T], Result)	->
	Comp = element(1, H),
	if
		(Comp == entero) or (Comp == cadena) or (Comp == 'float')	->
			stateB(T, [element(4,H)|Result]);
		true	-> throw(invalidList)
	end.
	
stateD([H1, H2|T], Result, Partial)	->
	Comp = element(1, H1),
	if
		(Comp == entero) or (Comp == cadena) or (Comp == 'float')	and  (element(1, H2) == ',')->
			stateE(T, Result, [element(4,H1)|Partial]);
			true	-> throw(invalidTuple)
	end.
	
stateE([H1, H2|T], Result, Partial)	->
	Comp = element(1, H1),
	if
		(Comp == entero) or (Comp == cadena) or (Comp == 'float')
		and  (element(1, H2) == '}')->
			stateF(T, Result, [element(4,H1)|Partial]);
			true	-> throw(invalidTuple)
	end.
		
stateF([H|T], Result, Partial)	->
	Comp = element(1, H),	
	Res2=  list_to_tuple(lists:reverse(Partial)),
	if
		Comp == ']'	-> lists:reverse([Res2|Result]);
		(Comp == ',')	or (hd(T) == '{')-> stateD(tl(T), [Res2|Result], []);
		true 	-> throw(invalidSintax)
	end.
	
metodo1([H|T], Result) ->
	if 
		H == final	-> lists:reverse(Result);
		?IS_LETTER(H) 	->	metodo2(T, [H, 34|Result]);
		true	-> metodo1(T, [H|Result])
	end.
	
metodo2([H|T], Result)	->
	if
		(H == $,) or (H == $]) or (H == $}) ->
			metodo1(T, [H, 34|Result]);
		true	-> metodo2(T, [H|Result])
	end.
	
metodomagico([], Result)	-> lists:reverse(tl(Result));
metodomagico([H|T], Result)	-> metodomagico(T, [$, ,H|Result]).
