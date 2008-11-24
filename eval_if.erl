-module(eval_if).
-compile(export_all).

-import(exp_eval, [stateG/2]).
-import(lexer2, [iniciol2/1]).
-import(lexer3, [principal/1]).
-import(eval_enum, [principalEnum/5]).

%% Estado que checa la expresion del if y si esta true la manda al stateD de otra manera
%% la manda al stateB
stateA([H|T], Result, Dic, Stkif, Stkval)->
	CondicionEval = exp_eval:stateG(lexer3:principal(lexer2:iniciol2(element(2,H))),Dic),
	io:format("condicion~s~n", [CondicionEval]),
	if 
		CondicionEval == true-> stateD(T, Result, Dic, Stkif, [true| Stkval]);
		CondicionEval == false-> stateB(T, Result, Dic, Stkif, [false| Stkval])
	end.
	
%% stateB revisa todo lo que sigue y descrimina lo que sea hasta el endif o else que le corresponde
%% Tiene un contador para los ifs internos. Esto contador incrementa si encuentra un if interno
%% y decrementa si encuentra un endif
stateB([H|T], Result, Dic, Stkif, Stkval)->
	if 
		element(1,H) == 'if'-> stateB(T, Result, Dic, Stkif+1, Stkval);
		(element(1,H) == 'endif') and (Stkif == 1)-> stateF(T, Result, Dic, Stkif, tl(Stkval));
		element(1,H) == 'endif'-> stateB(T, Result, Dic, Stkif - 1, Stkval);
		(element(1,H) =='else') and (Stkif ==1)-> stateC(T,Result,Dic, Stkif, Stkval);
		true->stateB(T, Result, Dic, Stkif, Stkval)
	end.
	
%%  Retoma lo que esta el else y lo lee evaluando todo lo que este adentro, termina cuando encuentra
%% un endif, Tambien manda a llamar eval_enun si existe un for y manda a llamar al stateA si es un if
stateC([H|T], Result, Dic, Stkif, Stkval)->
	if
		element(1,H) == 'endif' -> stateF(T, Result, Dic, Stkif, tl(Stkval));
		element(1,H) == 'if' -> stateA([H|T], Result, Dic, Stkif, Stkval);
		element(1,H) == 'estatico' -> stateC(T, [H|Result],Dic, Stkif, Stkval);
		element(1,H) == 'for'	-> 
			{T2, Result2} = eval_enun:principalEnun([H|T], Result, Dic),
			stateC(T2, Result2, Dic, Stkif, Stkval);
		is_list(H) -> stateC(T, [exp_eval:stateG(lexer3:principal(H), Dic)|Result], Dic, Stkif, Stkval)
	end.
	
%%  En este estado toma todo lo que venga como valido y lo evalua hasta que encuentra un else
%% o un endif. Si llefa un for manda a llamar eval_enun y manda a llamar a statea si es un if
stateD([H|T], Result, Dic, Stkif, Stkval)->
	%io:format("H = ~p~n", [H]),
	%io:format("T = ~p~n", [T]),
	%io:format("Res = ~p~n", [Result]),
	if 
		element(1, H) == 'endif' -> stateF(T, Result, Dic, Stkif, tl(Stkval));
		element(1, H) == 'if' -> stateA([H|T], Result, Dic, Stkif, Stkval);
		element(1, H) == 'else' -> stateE(T, Result, Dic, Stkif, Stkval);
		element(1, H) == estatico ->
			%io:format("StkVal = ~p~n~n", [Stkval]),
		stateD(T, [H|Result] ,Dic, Stkif, Stkval);
		element(1,H) == 'for'	-> 
			{T2, Result2} = eval_enun:principalEnun([H|T], Result, Dic),
			stateD(T2, Result2, Dic, Stkif, Stkval);
		is_list(H) -> stateD(T, [(exp_eval:stateG(lexer3:principal(H), Dic))|Result], Dic, Stkif, Stkval)
	end.
	
%% En este estado se descrimina todo lo que este ahi, hasta que encuentra un endif
stateE([H|T], Result, Dic, Stkif, Stkval)->
	if 
		(element(1,H) == 'endif') and (Stkif == 1) -> stateF(T, Result, Dic, Stkif, tl(Stkval));
		element(1,H) == 'endif' -> stateE(T, Result, Dic, Stkif - 1, Stkval);
		element(1,H) == 'if' -> stateE(T, Result, Dic, Stkif+1, Stkval);
		true -> stateE(T, Result, Dic, Stkif, Stkval)
	end.
	
%% en este estado llegan todos los estado para revisar la condicion inicial del if y dependiento
%% contexto se manda a llamar diversos estados 
stateF([H|T], Result, Dic, Stkif, Stkval)->
	if 
		Stkval == [] -> {[H|T], Result};
		(element(1,H) == 'else') and (hd(Stkval) == true) -> stateE(T, Result, Dic, Stkif, Stkval);
		(element(1,H) == 'else') and (hd(Stkval) == false) -> stateC(T, Result, Dic, Stkif, Stkval);
		element(1,H) == 'endif' -> stateF(T, Result, Dic, Stkif, tl(Stkval));
		element(1,H) == 'if' -> stateA([H|T], Result, Dic, Stkif, Stkval);
		element(1,H)== 'estatico' -> stateF(T, [H|Result],Dic, Stkif, Stkval);
		is_list(H) -> stateF(T, [exp_eval:stateG(lexer3:principal(H), Dic)|Result], Dic, Stkif, Stkval)
	end.
