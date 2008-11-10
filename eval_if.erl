-module(eval_if).
-compile(export_all).

-import(exp_eval, [stateG/2]).
-import(lexer2, [iniciol2/1]).
-import(lexer3, [principal/1]).
-import(eval_enum, [principalEnum/5]).

stateA([H|T], Result, Dic, Stkif, Stkval)->
	CondicionEval = exp_eval:stateG(lexer3:principal(lexer2:iniciol2(element(2,H))),Dic),
	io:format("condicion~s~n", [CondicionEval]),
	if 
		CondicionEval == true-> stateD(T, Result, Dic, Stkif, [true| Stkval]);
		CondicionEval == false-> stateB(T, Result, Dic, Stkif, [false| Stkval])
	end.
stateB([H|T], Result, Dic, Stkif, Stkval)->
	if 
		element(1,H) == 'if'-> stateB(T, Result, Dic, Stkif+1, Stkval);
		(element(1,H) == 'endif') and (Stkif == 1)-> stateB(T, Result, Dic, Stkif, tl(Stkval));
		element(1,H) == 'endif'-> stateB(T, Result, Dic, Stkif - 1, Stkval);
		(element(1,H) =='else') and (Stkif ==1)-> stateC(T,Result,Dic, Stkif, Stkval);
		true->stateB(T, Result, Dic, Stkif, Stkval)
	end.
stateC([H|T], Result, Dic, Stkif, Stkval)->
	if
		element(1,H) == 'endif' -> stateF(T, Result, Dic, Stkif, tl(Stkval));
		element(1,H) == 'if' -> stateA([H|T], Result, Dic, Stkif, Stkval);
		element(1,H) == 'estatico' -> stateC(T, [H|Result],Dic, Stkif, Stkval);
		is_list(H) -> stateC(T, [exp_eval:stateG(lexer3:principal(H), Dic)|Result], Dic, Stkif, Stkval)
	end.
	
stateD([H|T], Result, Dic, Stkif, Stkval)->
	%io:format("H = ~p~n", [H]),
	%io:format("T = ~p~n", [T]),
	%io:format("Res = ~p~n", [Result]),
	if 
		
		element(1, H) == 'endif' -> stateF(T, Result, Dic, Stkif, tl(Stkval));
		element(1, H) == 'if' -> stateA([H|T], Result, Dic, Stkif, Stkval);
		element(1, H) == 'else' -> stateE(T, Result, Dic, Stkif, Stkval);
		element(1, H) == estatico ->
			io:format("StkVal = ~p~n~n", [Stkval]),
		stateD(T, [H|Result] ,Dic, Stkif, Stkval);
		is_list(H) -> stateD(T, [(exp_eval:stateG(lexer3:principal(H), Dic))|Result], Dic, Stkif, Stkval)
	end.
	
stateE([H|T], Result, Dic, Stkif, Stkval)->
io:format("H = ~p~n", [H]),
	io:format("T = ~p~n", [T]),
	io:format("Res = ~p~n~n", [Result]),
	io:format("RStkif = ~p~n~n", [Stkif]),
	if 
		(element(1,H) == 'endif') and (Stkif == 1) -> stateF(T, Result, Dic, Stkif, tl(Stkval));
		element(1,H) == 'endif' -> stateE(T, Result, Dic, Stkif - 1, Stkval);
		element(1,H) == 'if' -> stateE(T, Result, Dic, Stkif+1, Stkval);
		true -> stateE(T, Result, Dic, Stkif, Stkval)
	end.
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
