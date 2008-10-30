-module(formanum).
-export([start/2]).

start(Params,Headers)-> 
	[{_, Num1}, {_, Num2}] = Params,
	Fact = factorial(list_to_integer(Num1)),
	Sumat = sumatoria(list_to_integer(Num2)),
	MCD = mcd(list_to_integer(Num1), list_to_integer(Num2)),
	HeadB = stringHeaders1(Headers),
	{[{factorial, Fact}, {sumatoria, Sumat},{mcd, MCD},{headers, HeadB}],[{"Content-Type","text/plain"}]}.
	
factorial(0) ->	1;
factorial(N) -> N * factorial(N-1).

sumatoria(N)	-> suma(N, 0).
suma(0, Result)	-> Result;
suma(N, Result)	-> suma(N-1, Result + N).

mcd(X, 0) 	-> X;
mcd(0, Y)		-> Y;
mcd(X, Y) ->
    if
        X > Y ->
            mcd(Y, X rem Y);
        true ->
            mcd(X, Y rem X)
    end.

stringHeaders1(Header)	->
	NewHeader = Header ++ [{final, fin}],
	stringHeaders(NewHeader, []).
	
stringHeaders([{A, B}|C], Result)	->
	if
		A == final	-> Result;
		true	-> Lista = lists:append([A, [$:], B, "\r\n"]),
		stringHeaders(C, Result ++ Lista)
	end.
