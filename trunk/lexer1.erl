-module(lexer1).
-export([inicio/1]).

inicio(Input) ->
	{ok, S} = file:read_file(Input),
	L = binary_to_list(S),
	stateA(lists:append(L, "$$"), 1, 1, []).

stateA([H1, H2|T], Ren, Col, Result)->
	if
		(H1 == ${) and (H2 == $%)	->stateB(T, Ren, Col + 2, Result, [H2, H1], Ren, Col, enunciado);
		(H1 == ${) and (H2 == ${)	->stateB(T, Ren, Col + 2, Result, [H2, H1], Ren, Col, expresion);
		(H1 == ${) and (H2 == $#)	->stateN(T, Ren, Col + 2, Result, [H2, H1], Ren, Col, comment);
		H1 == 10	->stateJ([H2|T], Ren + 1, 1, Result, [H1], Ren, Col, estatico);
		(H1 == $$) and (H1 == $$)	->lists:reverse(Result);
		(H1 == $<) and (H2 == $!)	->stateK(T, Ren, Col + 2 , Result, [H2, H1], Ren, Col, estatico);
		true -> stateJ([H2|T], Ren, Col + 1, Result, [H1], Ren, Col, estatico)
	end.
	
stateB([H1,H2|T], Ren, Col, Result, Partial, R, C, Type)->
	if
		(H1 == $}) and (H2 == $})	-> stateI([H1, H2|T], Ren, Col, Result, Partial, R, C, Type);
		(H1 == $%) and (H2 == $})	-> stateI([H1, H2|T], Ren, Col, Result, Partial, R, C, Type);
		H1 == $"	-> stateE([H2|T], Ren, Col + 1, Result, [H1|Partial], R, C, Type);
		H1 == $'	-> stateD([H2|T], Ren, Col + 1, Result, [H1|Partial], R, C, Type);
		H1 == 10 ->  stateB([H2|T], Ren + 1, 1, Result, [H1|Partial], R, C, Type);
		true	-> stateB([H2|T], Ren, Col + 1, Result, [H1|Partial], R, C, Type)
	end.
		
stateC([H|T], Ren, Col, Result, Partial, R, C, Type)->
	if
		H == $"	->stateD(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		true 	->stateC(T, Ren, Col + 1, Result, [H|Partial], R, C, Type)
	end.
	
stateD([H|T], Ren, Col, Result, Partial, R, C, Type)	->
	if
		(H == $') and  (Type == comment)	-> stateN(T, Ren, Col, Result, [H|Partial], R, C, Type);
		H == $"	-> stateC(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		H == $'	-> stateB(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		H == $\\	-> stateF(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);            
		H == 10	-> stateD(T, Ren+ 1, 1, Result, [H|Partial], R, C, Type);
		true	-> stateD(T, Ren, Col + 1, Result, [H|Partial], R, C, Type)
	end.
	
stateE([H|T], Ren, Col, Result, Partial, R, C, Type)	->
	if
		(H == $") and  (Type == comment)	-> stateN(T, Ren, Col, Result, [H|Partial], R, C, Type);
		H == $"	-> stateB(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		H == $'	-> stateG(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		H == $\\	-> stateH(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		H == 10	-> stateE(T, Ren + 1, 1, Result, [H|Partial], R, C, Type);
		true	-> stateE(T, Ren, Col + 1, Result, [H|Partial], R, C, Type)
	end.
	
stateF([H|T], Ren, Col, Result, Partial, R, C, Type)->
	if
		true 	->stateD(T, Ren, Col + 1, Result, [H|Partial], R, C, Type)
	end.
	
stateG([H|T], Ren, Col, Result, Partial, R, C, Type)->
	if
		H == $'	->stateE(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		true 	->stateG(T, Ren, Col + 1, Result, [H|Partial], R, C, Type)
	end.
	
stateH([H|T], Ren, Col, Result, Partial, R, C, Type)->
	if
		true 	->stateE(T, Ren, Col + 1, Result, [H|Partial], R, C, Type)
	end.
			
stateI([H1,H2|T], Ren, Col, Result, Partial, R, C, Type)->
	if
		(Type == expresion) and (H1 == $}) -> stateA(T, Ren, Col + 2, [{Type, R, C, lists:reverse([H2,H1|Partial])}|Result]);
		(Type == enunciado) and (H1 == $%) -> stateA(T, Ren, Col + 2, [{Type, R, C,lists:reverse([H2,H1|Partial])}|Result]);
		(Type == comment) and (H1 == $#) -> stateA(T, Ren, Col + 2, [{Type, R, C, lists:reverse([H2,H1|Partial])}|Result]);
		(H1 == $$) and (H2 == $$) -> stateA([H1, H2|T], Ren, Col + 2, [{Type, R, C, lists:reverse(Partial)}|Result]);
		(H1 == ${) and (H2 == ${) -> stateA([H1,H2|T], Ren, Col, [{Type, R, C, lists:reverse(Partial)}|Result]);
		(H1 == ${) and (H2 == $%) -> stateA([H1,H2|T], Ren, Col, [{Type, R, C, lists:reverse(Partial)}|Result]);
		(H1 == ${) and (H2 == $#) -> stateA([H1,H2|T], Ren, Col, [{Type, R, C, lists:reverse(Partial)}|Result])
	end.

stateJ([H1,H2|T], Ren, Col, Result, Partial, R, C, Type)->
	if
		(H1 == ${) and (H2 == $%)	->stateI([H1, H2|T], Ren, Col , Result, Partial, R, C, Type);
		(H1 == ${) and (H2 == ${)	->stateI([H1, H2|T], Ren, Col , Result, Partial, R, C, Type);
		(H1 == ${) and (H2 == $#)	->stateI([H1,H2|T], Ren, Col, Result, Partial, R, C, Type);
		(H1 == $$) and (H2 == $$)	->stateI([H1, H2|T], Ren, Col , Result, Partial, R, C, Type);
		(H1 == $<) and (H2 == $!) -> stateK(T, Ren, Col + 2, Result, [H2, H1|Partial], Ren, Col, Type);
		H1 == 10	->stateJ([H2|T], Ren + 1, 1, Result, [H1|Partial], R, C, Type);
		true	->stateJ([H2|T], Ren, Col + 1, Result, [H1|Partial], R, C, Type)
	end.

stateK([H1,H2|T], Ren, Col, Result, Partial, R , C, Type)->
	if 
		(H1 ==$-) and (H2==$-) ->  stateL(T, Ren, Col + 2, Result, [H2, H1|Partial], R, C, Type);
		H1 == 10	->stateJ([H2|T], Ren + 1, 1, Result, [H1|Partial], R, C, Type);
		true	-> stateJ([H2|T], Ren, Col + 1, Result, [H1|Partial], R, C, Type)
		end.

stateL([H1, H2|T], Ren, Col, Result, Partial, R, C, Type)->
	if 
		(H1 == $-) and (H2 == $-)->	stateM(T, Ren, Col + 2, Result, [H2, H1|Partial], R, C, Type);
		H1 == 10	->stateL([H2|T], Ren + 1, 1, Result, [H1|Partial], R, C, Type);
		true	-> stateL([H2|T], Ren, Col + 1, Result, [H1|Partial], R, C, Type)
	end.
	
stateM([H|T], Ren, Col, Result, Partial, R, C, Type)->
	if 
		(H == $>)->	stateJ(T, Ren, Col + 1, Result, [H|Partial], R, C, Type);
		H == 10	->stateL(T, Ren + 1, 1, Result, [H|Partial], R, C, Type);
		true	-> stateL(T, Ren, Col + 1, Result, [H|Partial], R, C, Type)
	end.
	
stateN([H1,H2|T], Ren, Col, Result, Partial, R, C, Type)->
	if 
		(H1 == $#) and (H2 == $}) -> stateI([H1,H2|T], Ren, Col, Result, Partial, R, C, Type);
		H1 == $"	-> stateE([H2|T], Ren, Col + 1, Result, [H1|Partial], R, C, Type);
		H1 == $'	-> stateD([H2|T], Ren, Col + 1, Result, [H1|Partial], R, C, Type);
		H1 == 10 ->  stateN([H2|T], Ren + 1, 1, Result, [H1|Partial], R, C, Type);
		true	-> stateN([H2|T], Ren, Col + 1, Result, [H1|Partial], R, C, Type)
	end.
