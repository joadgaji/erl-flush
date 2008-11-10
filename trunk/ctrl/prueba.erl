-module(prueba).
-export([fact/2, nada/2]).

fact(Params,Headers)-> 
	{[{A,factorial(list_to_integer(B))}||{A,B}<-Params],[{"Server", "Erl-flush"},{"Content-type", "text/plain"}]}.

factorial(0) ->	1;
factorial(N) -> N * factorial(N-1).



