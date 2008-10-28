-module(ascii).
-compile(export_all).
	
listParams([])	-> [];
listParams(Parametros)	->
	params(string:tokens(Parametros, [$&]), []).

params("", Result)	->  lists:reverse(Result);
params([A|B], Result)	->
	Index = string:rchr(A, $=),
	io:format("A; ~s, B: ,~p Index: ~p~n", [A, B, Index]),
	{Variable, Vigual} = lists:split(Index-1, A),
	{_, Valor} = lists:split(1, Vigual),
	io:format("Variable ~s, Valor ~s ~n", [Variable, Valor]),
	params(B,[{list_to_atom(Variable), convertASCII(Valor)}|Result]).

convertASCII(String)->
	B= " " ++ String,
	X= string:rchr(String,$%),
	if 
		(X /= 0) ->
			[H|T]=string:tokens(B,"%"),
			evaluar(T,H);
		true ->
			String
	end.
	
evaluar([], Result)-> 
	%G = string:substr(Result,2),
	X = string:rchr(Result,$+),
	if
		(X /= 0)->
			replaceSpaces(string:tokens(Result,[$+]), []);
		true ->
			string:substr(Result,2)
	end;
	
evaluar([H|T], Result)->
	Tail = string:substr(H,3),
	Ascii = string:substr(H,1,2),
	{_,A,_} = io_lib:fread("~16u",Ascii),
	evaluar(T, Result ++ A ++ Tail).
	
replaceSpaces([], Result)-> string:substr(Result,2);
replaceSpaces([H|T], Result)-> replaceSpaces(T, Result ++ H ++ " ").
	








