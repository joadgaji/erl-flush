-module(lexer2N).
-export([inicio/1]).

-define(IN_RANGE(X, Start, End), (((Start) =< (X)) and ((X) =< (End)))). 
-define(IS_DIGIT(X), ?IN_RANGE(X, $0, $9)).
-define(IS_LOWER(X), ?IN_RANGE(X, $a, $z)).
-define(IS_UPPER(X), ?IN_RANGE(X, $A, $Z)).
-define(IS_LETTER(X), (?IS_LOWER(X) or ?IS_UPPER(X))).
-define(IS_SPACE(X), ((X) == $ )).
-define(IS_SYMBOL(X), ((X) == $+)or ((X) == $-) or ((X) == $*) or ((X) == $/) or ((X) == $=) or ((X) == $%) or ((X) == 40) or ((X) == 41)).

inicio({_,Ren,Col,[_,_|T]})-> stateA(T,Ren,Col+2,[]).

stateA([H|T],Ren,Col,Result)->
	if
		?IS_SPACE(H)	-> stateA(T, Ren, Col + 1, Result);
		(H == $') 		-> stateB(T, Ren, Col + 1, Result, [H], Ren, Col);
		(H == $")		-> stateC(T, Ren, Col + 1, Result, [H], Ren, Col);
		?IS_DIGIT(H)    -> stateD(T, Ren, Col + 1, Result, [H], Ren, Col);
		(H == $.)		-> stateE(T, Ren, Col + 1, Result, [H], Ren, Col);
		?IS_SYMBOL(H) 	-> stateF(T, Ren, Col + 1, Result, [H], Ren, Col);
		?IS_LOWER(H)    -> stateH(T, Ren, Col + 1, Result, [H], Ren, Col);
		(H == $})		-> stateK(T, Ren, Col + 1, Result, [H], Ren, Col);
		true 			-> stateJ(T, Ren, Col + 1, Result, [H], Ren, Col)
	end.

stateB([H|T],Ren,Col,Result,Partial,R,C)->
	if 
		(H == $') 	-> stateI([H|T], Ren, Col, Result, Partial, R, C, cadena);
		true		-> stateB(T, Ren, Col + 1, Result, [H|Partial], R, C)
	end.
	

stateC([H|T],Ren,Col,Result,Partial,R,C)->
	if 
		(H == $") 	-> stateI([H|T], Ren, Col, Result, Partial, R, C, cadena);
		true		-> stateC(T, Ren, Col + 1, Result, [H|Partial], R, C)
	end.
	
stateD([H|T],Ren,Col,Result,Partial,R,C)->
	if 
		?IS_DIGIT(H) 					-> stateD(T, Ren, Col+1, Result,[H|Partial], R, C);
		(H == $.)       				-> stateE(T, Ren, Col+1, Result,[H|Partial], R, C);
								
		?IS_SYMBOL(H) or ?IS_SPACE(H) or (H == $})	-> stateI([H|T], Ren, Col, Result, Partial, R, C, entero);
		true							-> stateJ(T, Ren, Col + 1, Result, [H|Partial], R, C)
	end.

stateE([H|T],Ren,Col,Result,Partial,R,C)->
	if 
		?IS_DIGIT(H) 					-> stateE(T, Ren, Col+1, Result,[H|Partial], R, C);
		(H == $})						-> stateK(T, Ren, Col + 1, Result, [H], Ren, Col);
		?IS_SYMBOL(H) or ?IS_SPACE(H) 	-> stateI([H|T], Ren, Col, Result, Partial, R, C, float);
		true							-> stateJ(T, Ren, Col + 1, Result, [H|Partial], R, C)
	end.

stateF([H|T],Ren,Col,Result,Partial,R,C)->
	if 
		?IS_DIGIT(H) or	?IS_SPACE(H) or 
		?IS_SYMBOL(H) or ?IS_LOWER(H) or (H == $.)	-> stateI([H|T], Ren, Col, Result, Partial, R, C, simbolo);      			
		(H == $})								-> stateK(T, Ren, Col + 1, Result, [H], Ren, Col);
		true									-> stateJ(T, Ren, Col + 1, Result, [H|Partial], R, C)
	end.

stateH([H|T],Ren,Col,Result,Partial,R,C)->
	if 
		?IS_DIGIT(H) or	?IS_LETTER(H) or (H ==$_) -> stateH(T, Ren, Col, Result,[H|Partial], R, C);      			
		?IS_SPACE(H) or ?IS_SYMBOL(H)			  -> stateI([H|T], Ren, Col, Result, Partial, R, C, identificador);    
		(H == $})								  -> stateK(T, Ren, Col + 1, Result, [H], Ren, Col);
		true									  -> stateJ(T, Ren, Col + 1, Result, [H|Partial], R, C)
	end.


stateI([H|T], Ren, Col, Result, Partial, R, C, Type)->
		if
		
		(H == $") or (H == $')  -> stateA(T, Ren, Col + 1, [{Type, R, C, lists:reverse([H|Partial])}|Result]);	
		(H == 41)  				-> stateA([H|T], Ren, Col, [{Type, R, C, lists:reverse(Partial)}|Result]);
		(H == $})				-> stateK(T, Ren, Col + 1, [{Type, R, C, lists:reverse(Partial)}|Result], [H], Ren, Col);
		true				   -> stateA([H|T], Ren, Col, [{Type, R, C, lists:reverse(Partial)}|Result])
		end.

%% Error en la expresion
stateJ(_,_,_,_,_,_,_)->0.

stateK([H|T],Ren,Col,Result,Partial,R,C)->
	if 
		
		(H == $}) 	->lists:reverse(Result);
		true 		-> stateJ(T, Ren, Col , Result, [H|Partial], R, C)
	end.

