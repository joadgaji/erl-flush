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

%% Llega una expresion que es ecaluada, se espera una lista o un string que es una lista
%% Si es una lista solo se pasa el valor como tal
%% Si es un string este lo parseamos para convertirlo es una lista
convert(Exp)	-> 
	if 
		hd(Exp) == $[	-> 
			ExpEval = metodo1(Exp ++ [final], []),
			[H|T] = lexer3:principal(lexer2:iniciol2({expresion, 1,1, "{{" ++ ExpEval ++"}}"}));
		true	-> [H|T] = Exp
	end,
		io:format("H ~p~n T ~p~n", [H, T]),
	if
		element(1, H) == '['	-> stateA(T, []);
		true -> Exp
	end.
	
%% En este estado se espera algun identificador, un entero un float o un { que indica tupla
%% Otro signo manda un error de InvalidValue
stateA([H|T], Result) 	->
	Comp = element(1, H),
	if
		(Comp == entero) or (Comp == cadena) or (Comp == 'float')	->
			stateB(T, [element(4,H)|Result]);
		(Comp == '{')	->
			stateD(T, Result, []);
		true	-> throw(invalidValue)
	end.
	
%% Una vez que llego un valor valido, aqui solo se esperan comas (,) o (]) 
%% ] indica que la lista termina.
%% si llega un simbolo o valor distinto se arroja un invalidList
stateB([H|T], Result)	->
	Comp = element(1,H),
	if
		Comp == ','	-> stateC(T, Result);
		Comp == ']'	-> lists:reverse(Result);
		true	->throw(invalidList)
	end.
	
%% En este estado se espera un identificador, un entero o un float.
%% Cualquier otra cosa manda un invalidList
stateC([H|T], Result)	->
	Comp = element(1, H),
	if
		(Comp == entero) or (Comp == cadena) or (Comp == 'float')	->
			stateB(T, [element(4,H)|Result]);
		true	-> throw(invalidList)
	end.
	
%% Cuando sabemos que es un diccionario, en este estado esperamos un valor entero, float o identificador
%% seguido de una coma. Algún otro caso lanza un invalidTuple
stateD([H1, H2|T], Result, Partial)	->
	Comp = element(1, H1),
	if
		(Comp == entero) or (Comp == cadena) or (Comp == 'float')	and  (element(1, H2) == ',')->
			stateE(T, Result, [element(4,H1)|Partial]);
			true	-> throw(invalidTuple)
	end.
	
%% En este estao esperamos un identificador, un entero o un float seguido de un } para indicar fin de tupla
%% Cualquier otro caso arroja un invalidTuple
stateE([H1, H2|T], Result, Partial)	->
	Comp = element(1, H1),
	if
		(Comp == entero) or (Comp == cadena) or (Comp == 'float')
		and  (element(1, H2) == '}')->
			stateF(T, Result, [element(4,H1)|Partial]);
			true	-> throw(invalidTuple)
	end.
		
%% En este estado esperamos una coma (,) seguida de una llave ({)que significa que viene otra tupla, 
%% Tambien se espera un corchete (]) que significa que el diccionario se cierra.
%% Otra cosa que llegue manda un invalidSintax
stateF([H|T], Result, Partial)	->
	Comp = element(1, H),	
	Res2=  list_to_tuple(lists:reverse(Partial)),
	if
		Comp == ']'	-> lists:reverse([Res2|Result]);
		(Comp == ',')	or (hd(T) == '{')-> stateD(tl(T), [Res2|Result], []);
		true 	-> throw(invalidSintax)
	end.
	
%% Método1 busca caracteres para ponerlos entre comillas (")
metodo1([H|T], Result) ->
	if 
		H == final	-> lists:reverse(Result);
		?IS_LETTER(H) 	->	metodo2(T, [H, 34|Result]);
		true	-> metodo1(T, [H|Result])
	end.
	
%% Método que busca (, ] o }) para finalizar una linea de caracteres
metodo2([H|T], Result)	->
	if
		(H == $,) or (H == $]) or (H == $}) ->
			metodo1(T, [H, 34|Result]);
		true	-> metodo2(T, [H|Result])
	end.
