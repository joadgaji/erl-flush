-module(enunciados).
-compile(export_all).

secuencia(Params,_)-> 
	{[{secuencia,fibo(list_to_integer(B),2,[1,1])}||{_,B}<-Params],[{"Server", "Erl-flush"},{"Content-type", "text/html"}]}.

fibo (Num,Num,Result)->lists:reverse(Result);
fibo (Num,Contador,Result)-> [H1,H2|_]= Result,
	fibo (Num,Contador+1,[H1+H2|Result]).




