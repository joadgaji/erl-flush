-module(eval_for).
-compile(export_all).

-import(exp_eval, [stateG/2]).
-import(lexer2, [iniciol2/1]).
-import(lexer3, [principal/1]).
-import(eval_enun, [principalEnun/3]).
-import(convert_term, [convert/1]).

stateA([H|T], T2, Result, Dic, DicT, Stkfor)	->
	
	IteratorExp = {expresion, 1,1, "{{" ++ element(3, H) ++ "}}"},
	IteratorVal = exp_eval:stateG(lexer3:principal(lexer2:iniciol2(IteratorExp)), Dic),
	Evaluacion = {element(2,H), convert(IteratorVal)},
	io:format("IteratorVal ~p~n Evaluacion ~p~n", [IteratorVal, Evaluacion]),
	io:format("H: ~p~n~n T: ~p~n~n DicT: ~p~n~n", [H, T, DicT]),
	stateB(T, T2, Result, Dic, DicT, [Evaluacion|Stkfor]).
	
stateB(T, T2, Result, Dic, DicT, [HStk|Stkfor])	->
	{Variables, Valores} = HStk,
	LenVariables = string:len(Variables),
	LenValores = string:len(Valores),
	%io:format("Rstl: ~p ~n", [T2]),
	if
		%%(LenVariables == 1) and 
		(LenValores /= 0) and (LenVariables =< 2) -> 
			[Variabls,Valors, DicTe] = addDict(Variables, Valores, DicT),
			%%{VarI, Valor} = {hd(Variables), hd(Valores)},
			stateC(T, T2, Result, Dic, DicTe, [{Variabls, Valors}|Stkfor]);
		(LenValores == 0)-> stateD(T, T2, Result, Dic, DicT, Stkfor, 1);
		true -> "ErrordeVariables"
	end.
	
stateC([H|T], T2, Result, Dic, DicT, Stkfor)	->
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

stateD([H|T], T2, Result, Dic, DicT, Stkfor, StkTemp)->
	if
		(element(1, H) == 'endfor') and (StkTemp == 0) -> {T, Result};
		element(1,H)== 'for' ->
			stateD(T, T2, Result, Dic, DicT, Stkfor, StkTemp+1);
		element(1,H) == 'endfor' -> 
			stateD(T, T2, Result, Dic, DicT, Stkfor, StkTemp-1);
		true -> stateD(T, T2, Result, Dic, DicT, Stkfor, StkTemp)
	end.
	
stateE([H|T], T2, Result, Dic, DicT, [HStk|Stkfor])	->
	{Variables, Valores} = HStk,
	LenVariables = string:len(Variables),
	%%io:format("LenVar~p",LenVariables),
	LenValores = string:len(Valores),
	if 
		(Stkfor == []) and (LenValores == 0) 	->	{[H|T], Result};
		LenValores == 1 -> stateB(T2, T2, Result, Dic, DicT, [HStk|Stkfor]);
		LenValores >= 0 -> stateB(T2, T2, Result, Dic, DicT, [HStk|Stkfor])
	end.

addDict([Var1], [H|T], DicT)-> [[Var1], T, remplazaTuplaEnDicT({list_to_atom(Var1),H},DicT,[])];
addDict([Var1, Var2], [{Val1, Val2}|T], DicT)->  
	DicTVar1 = remplazaTuplaEnDicT({list_to_atom(Var1), Val1},DicT,[]),
	[[Var1, Var2], T, remplazaTuplaEnDicT({list_to_atom(Var2), Val2},DicTVar1,[])].
	
remplazaTuplaEnDicT({Var,Val},[{Var,_}|T],Result) -> [{Var,Val}] ++ T ++Result;
remplazaTuplaEnDicT({Var, Val},[{VarOr,ValOr}|T],Result) -> remplazaTuplaEnDicT({Var,Val}, T, [{VarOr,ValOr}|Result]);
remplazaTuplaEnDicT({Var,Val},[],Result) -> [{Var, Val}|Result].
