-module(prueba_if).
-export([fact_if/2]).

fact_if(Params,_)-> 
	{[{A,factorial(list_to_integer(B))}||{A,B}<-Params],[{"Server", "Erl-flush"},{"Content-type", "text/html"}]}.

factorial(0) ->	1;
factorial(N) -> N * factorial(N-1).
