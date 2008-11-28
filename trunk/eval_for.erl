-module(eval_for).
-compile(export_all).

-import(exp_eval, [stateG/2]).
-import(lexer2, [iniciol2/1]).
-import(lexer3, [principal/1]).
-import(eval_enun, [principalEnun/3]).
-import(convert_term, [convert/1]).

%% Agrega al Stackdel For las variables y los valores que se utilizaran durante el ciclo
%% y se manda a llamar al stateB
stateA([H|T], T2, Result, Dic, DicT, Stkfor)	->

	IteratorExp = {expresion, 1,1, "{{" ++ element(3, H) ++ "}}"},
	IteratorVal = exp_eval:stateG(lexer3:principal(lexer2:iniciol2(IteratorExp)), Dic),
	io:format("elemtn : ~p~n~n", [IteratorVal]),
	Evaluacion = {element(2,H), convert(IteratorVal)},
	io:format("IteratorVal ~p~n Evaluacion ~p~n", [IteratorVal, Evaluacion]),
	io:format("H: ~p~n~n T: ~p~n~n dic: ~p~n~n DicT: ~p~n~n StkFor~p~n~n", [H, T, Dic, DicT, Stkfor]),
	stateB(T, T2, Result, Dic, DicT, [Evaluacion|Stkfor]).

%% Se decide cual es el siguiente paso en el ciclo, si aun hay valores que tomar
%% se agregan en el Diccionario Temporal para despues mandar llamar al stateC
%% si ya no hay mas valores se manda al stateD
stateB(T, T2, Result, Dic, DicT, [HStk|Stkfor])	->
	{Variables, Valores} = HStk,
	LenVariables = string:len(Variables),
	LenValores = string:len(Valores),
	%io:format("Rstl: ~p ~n", [T2]),
	if
		(LenValores /= 0) and (LenVariables =< 2) -> 
			[Variabls,Valors, DicTe] = addDict(Variables, Valores, DicT),
			%%{VarI, Valor} = {hd(Variables), hd(Valores)},
			io:format("State B Dic: ~p~n~n Dicte: ~p~n~n Stkfor: ~p~n~n", [Dic, DicTe, Stkfor]),
			stateC(T, T2, Result, Dic, DicTe, [{Variabls, Valors}|Stkfor]);
		(LenValores == 0)-> stateD(T, T2, Result, Dic, DicT, Stkfor, 1);
		true -> "ErrordeVariables"
	end.

%% Se evalua el contenido del for dependiendo del valor que se este leyendo
%% si es algun dato se agrega a lista, si es algo dinamico se evalua 
%% si es un if se manda a llamar el eval_if mediante el eval_enun
%% si es un for se vuelve a llamar eval_for mediante el eval_enun
%% cuando hay un endfor se llama el stateE
stateC([H|T], T2, Result, Dic, DicT, Stkfor)	->
	io:format("State C T: ~p~n~n Dict: ~p~n~n Stkfor: ~p~n~n Result: ~p~n~n", [T, DicT, Stkfor, Result]),
	if
		element(1,H) == 'endfor' 	->stateE(T, T2, Result, Dic, DicT, Stkfor);
		element(1,H) == 'for' 	-> 
			%%{Input2, Result2} = eval_enun:principalEnun([H|T], Result, DicT);
			{Input2, Result2}=stateA([H|T], T, Result, Dic, DicT, Stkfor),
			stateC(Input2, T2, Result2, Dic, DicT, Stkfor);
		element(1, H) == 'if'	->
			{Input2 , Result2} = eval_enun:principalEnun([H|T], Result, DicT),
			stateC(Input2, T2, Result2, Dic, DicT, Stkfor);
		element(1,H) == 'estatico' 	-> stateC(T, T2, [H|Result], Dic, DicT, Stkfor);
		is_list(H)	->
			%io:format("DicT: ~p ~n", [DicT]),
			stateC(T, T2, [exp_eval:stateG(lexer3:principal(H),DicT)|Result],Dic,DicT, Stkfor)
	end.

%% Recorre el contenido del for por ultima vez sin concatenar nada
%%
stateD([H|T], T2, Result, Dic, DicT, Stkfor, StkTemp)->
	if
		(element(1, H) == 'endfor') and (StkTemp == 0) -> {T, Result};
		element(1,H)== 'for' ->
			stateD(T, T2, Result, Dic, DicT, Stkfor, StkTemp+1);
		element(1,H) == 'endfor' -> 
			stateD(T, T2, Result, Dic, DicT, Stkfor, StkTemp-1);
		true -> stateD(T, T2, Result, Dic, DicT, Stkfor, StkTemp)
	end.

%% Se retira un valor del Stack para volver a llamar al stateB
%% Si no hay mas valores para evaluar regresa el Resultado
stateE([H|T], T2, Result, Dic, DicT, [HStk|Stkfor])	->
	{_, Valores} = HStk,
	%LenVariables = string:len(Variables),
	%%io:format("LenVar~p",LenVariables),
	LenValores = string:len(Valores),
	if 
		(Stkfor == []) and (LenValores == 0) 	->	{[H|T], Result};
		LenValores == 0 -> {[H|T], Result};
		LenValores > 0 -> stateB(T2, T2, Result, Dic, DicT, [HStk|Stkfor])
	end.

%% Agrega la variable correspondiente en el diccionario temporal mandando llamar remplazaTupaEnDicT
addDict([Var1], [H|T], DicT)-> [[Var1], T, remplazaTuplaEnDicT({list_to_atom(Var1),H},DicT,[])];
addDict([Var1, Var2], [{Val1, Val2}|T], DicT)->  
	DicTVar1 = remplazaTuplaEnDicT({list_to_atom(Var1), Val1},DicT,[]),
	[[Var1, Var2], T, remplazaTuplaEnDicT({list_to_atom(Var2), Val2},DicTVar1,[])].
	
%% Reemplaza en una lista el valor de una variable si es que existe
%% si no existe el valor lo agrega.
remplazaTuplaEnDicT({Var,Val},[{Var,_}|T],Result) -> [{Var,Val}] ++ T ++Result;
remplazaTuplaEnDicT({Var, Val},[{VarOr,ValOr}|T],Result) -> remplazaTuplaEnDicT({Var,Val}, T, [{VarOr,ValOr}|Result]);
remplazaTuplaEnDicT({Var,Val},[],Result) -> [{Var, Val}|Result].
