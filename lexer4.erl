-module(lexer4).
-export([iniciol4/1]).

-define(IN_RANGE(X, Start, End), (((Start) =< (X)) and ((X) =< (End)))). 
-define(IS_DIGIT(X), ?IN_RANGE(X, $0, $9)).
-define(IS_LOWER(X), ?IN_RANGE(X, $a, $z)).
-define(IS_UPPER(X), ?IN_RANGE(X, $A, $Z)).
-define(IS_LETTER(X), (?IS_LOWER(X) or ?IS_UPPER(X))).
-define(IS_SPACE(X), ((X) == $ )).


iniciol4({enunciado,_,_,Enunciado})-> stateA(Enunciado).

stateA([H1,H2|T])->
	if
		(H1 == ${) and (H2 == $%)	-> stateB(T);
		true 		-> stateC()
	end.

stateB([H1,H2,H3,H4|T])->
	if
		?IS_SPACE(H1)			->stateB([H2,H3,H4|T]);
		(H1 == $i) and (H2 == $f)	-> stateD([H3,H4|T]);
		(H1 == $f) and (H2 == $o) and (H3 == $r) and ?IS_SPACE(H4) -> stateG(T);
		(H1 == $e) -> validacion([H1,H2,H3,H4|T]);
		true 		-> stateC()
	end.
	
stateC()->throw(invalidsyntax).

stateD([H|T])->
	if
		?IS_SPACE(H)	-> stateD(T);
		true 		-> stateE(T,[H])
	end.
	
stateE([H1,H2|T],Result)->
	if
		(H1 == $%) and (H2 == $})	-> fin({'if',{'expresion',1,1,"{{"++ lists:reverse(Result) ++"}}"}});
		true 		-> stateE([H2|T],[H1|Result])
	end.
	
stateF([H1,H2|T], Tipo)->
	if
		?IS_SPACE(H1)	-> stateF([H2|T],Tipo);
		(H1 == $%) and (H2 == $})	-> fin({Tipo});
		true 		-> stateC()
	end.

stateG([H|T])->
	if
		?IS_SPACE(H)	-> stateG(T);
		?IS_LOWER(H)	-> stateH(T,[H]);
		true 		-> stateC()
	end.

stateH([H|T],Result)->
	if
		(H == $,)			->  stateJ(T,Result);
		?IS_SPACE(H) 			-> stateI(T, lists:reverse(Result));
		?IS_LETTER(H) or ?IS_DIGIT(H) 	-> stateH(T,[H|Result]);
		true 				-> stateC()
	end.

stateI([H1,H2|T],Var1)-> 
	if
		?IS_SPACE(H1) 			-> stateI([H2|T],Var1);
		(H1 == $,)			-> stateJ([H2|T],[Var1]);
		(H1 == $i) and (H2 == $n)  	-> stateK(T,[Var1]);
		true 				-> stateC()
	end.

stateJ([H|T],LVar1)-> 
	if
		?IS_SPACE(H) 	-> stateJ(T,LVar1);
		?IS_LOWER(H)  	-> stateM(T,LVar1,[H]);
		true 		-> stateC()
	end.

stateK([H|T],LVars)-> 
	if
		?IS_SPACE(H) 	-> stateL(T,LVars);
		true 		-> stateC()
	end.

stateL([H|T],LVars)->
	if
		(H == $%) 	-> stateC();
		?IS_SPACE(H) 	-> stateL(T,LVars);
		true 		-> stateO(T,LVars,[H])
	end.

stateM([H|T],LVar1,Var2)-> 
	if
		?IS_SPACE(H) 			-> stateN(T,LVar1,lists:reverse(Var2));
		?IS_LETTER(H) or ?IS_DIGIT(H)	-> stateM(T,LVar1,[H|Var2]);
		true 		-> stateC()
	end.

stateN([H1,H2|T],LVar1,Var2)-> 
	if
		?IS_SPACE(H1) 			-> stateN([H2|T],LVar1,Var2);
		(H1 == $i) and (H2 == $n)  	-> stateK(T,[LVar1]++[Var2]);
		true 		-> stateC()
	end.

stateO([H1,H2|T],LVars,Iterable)->
	if
		(H1 == $%) and (H2 == $})  	-> fin({'for',LVars,lists:reverse(Iterable)});
		true 		-> stateO([H2|T],LVars,[H1|Iterable])
	end.


	
fin(Tupla)-> Tupla.

validacion([_,H2,H3,H4,H5,H6|T])->
	if
		(H2 == $l) and (H3 == $s) and (H4 == $e) -> stateF([H5,H6|T],'else');
		(H2 == $n) and (H3 == $d) and (H4 == $i) and (H5 == $f) -> stateF([H6|T],'endif');
		(H2 == $n) and (H3 == $d) and (H4 == $f) and (H5 == $o) and (H6 == $r) -> stateF(T,'endfor');
		true -> stateC()
	end.