-module(prueba).
-export([fact/2]).

fact(Params,Headers)-> 
	{[{A,factorial(list_to_integer(B))}||{A,B}<-Params],Headers}.

factorial(0) ->	1;
factorial(N) -> N * factorial(N-1).

			