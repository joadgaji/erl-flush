-module(lexer2N).
-export([inicio/1]).

-define(IN_RANGE(X, Start, End), (((Start) =< (X)) and ((X) =< (End)))). 
-define(IS_DIGIT(X), ?IN_RANGE(X, $0, $9)).
-define(IS_LOWER(X), ?IN_RANGE(X, $a, $z)).
-define(IS_UPPER(X), ?IN_RANGE(X, $A, $Z)).
-define(IS_LETTER(X), (?IS_LOWER(X) or ?IS_UPPER(X))).
-define(IS_SPACE(X), ((X) == $ )).
-define(IS_SYMBOL(X), ((X) == $+)or ((X) == $-) or ((X) == $*) or ((X) == $/) or ((X) == $=) or ((X) == $%) or ((X) == 40) or ((X) == 41)or ((X) == $<)or ((X) == $>)or  ((X) == $!)).

inicio({_,Ren,Col,[_,_|T]})-> stateA(T,Ren,Col+2,[]).

%% Escoge entre los diferentes caractéres posibles
stateA([H|T],Ren,Col,Result)->
	if
		?IS_SPACE(H)	-> stateA(T, Ren, Col + 1, Result);
		(H == $') 		-> stateB(T, Ren, Col + 1, Result, [H], Ren, Col);
		(H == $")		-> stateC(T, Ren, Col + 1, Result, [H], Ren, Col);
		?IS_DIGIT(H)    -> stateD(T, Ren, Col + 1, Result, [H], Ren, Col);
		(H == $.)		-> stateE(T, Ren, Col + 1, Result, [H], Ren, Col);
		?IS_SYMBOL(H) 	-> stateF([H|T], Ren, Col, Result, Ren, Col);
		?IS_LOWER(H)    -> stateH(T, Ren, Col + 1, Result, [H], Ren, Col);
		(H == $}) 		-> stateK( [H|T],Result);
		true 			-> throw(invalidsyntax)
	end.
	
%% Revisa una cadena de string con comilla sencilla
stateB([H|T],Ren,Col,Result, Partial,R,C)->
	if 
		(H == $') 	-> stateI(T, Ren, Col + 1, Result, [H|Partial], R, C, cadena);
		true		-> stateB(T, Ren, Col + 1, Result, [H|Partial], R, C)
	end.
	
%% Revisa una cadena de string con comilla dolbe
stateC([H|T],Ren,Col,Result, Partial,R,C)->
	if 
		(H == $") 	-> stateI([H|T], Ren, Col, Result, Partial, R, C, cadena);
		true		-> stateC(T, Ren, Col + 1, Result, [H|Partial], R, C)
	end.
	
%% Reivsa un número entero y un foltante
stateD([H|T],Ren,Col,Result, Partial,R,C)->
	if 
		?IS_DIGIT(H) 					-> stateD(T, Ren, Col+1, Result,  [H|Partial], R, C);
		(H == $.)       				-> stateE(T, Ren, Col+1, Result, [H|Partial], R, C);					
		?IS_SYMBOL(H) or ?IS_SPACE(H) 
		or (H == $})					-> stateI([H|T], Ren, Col, Result, Partial, R, C, entero);
		true							-> throw(invalidsyntax)
	end.

%% Concatena un número flotante
stateE([H|T],Ren,Col,Result, Partial,R,C)->
	if 
		?IS_DIGIT(H) 					-> stateE(T, Ren, Col+1, Result, [H|Partial], R, C);
		(H == $}) or					%%	-> stateK([H|T], Result);
		?IS_SYMBOL(H) or ?IS_SPACE(H) 	-> stateI([H|T], Ren, Col, Result, Partial, R, C, float);
		true							-> throw(invalidsyntax)
	end.

%% Revisa caractéres, Incrementa y decrementa el stack de paréntesis
stateF([H|T],Ren,Col,Result,R,C)->
	if 
		%(H == 40)	-> stateI(T, Ren, Col+ 1, Result, [H], R, C, simbolo); 
		%(H == 41)	-> stateI(T, Ren, Col+ 1, Result, [H], R, C, simbolo); 
		true			-> stateI(T, Ren, Col+ 1, Result, [H], R, C, simbolo)
	end.

%% Concatena identificadores
stateH([H|T],Ren,Col,Result, Partial,R,C)->
	if 
		?IS_DIGIT(H) or	?IS_LETTER(H) or (H ==$_) -> stateH(T, Ren, Col + 1, Result, [H|Partial], R, C);      			
		?IS_SPACE(H) or ?IS_SYMBOL(H) or
		(H == $})								  -> stateI([H|T], Ren, Col, Result, Partial, R, C, identificador);    
		true									  -> throw(invalidsyntax)
	end.

%% Tolo de que esté es partial lo concatena a el resultado final
stateI([H|T], Ren, Col, Result, Partial, R, C, Type)->
		 stateA([H|T], Ren, Col, [{Type, R, C, lists:reverse(Partial)}|Result]).

%% Estado que revida el stack antes de terminar
stateK([H|_],Result)->
	if 
		(H == $}) 	->lists:reverse(Result);
		true 		-> throw(invalidsyntax)
	end.

