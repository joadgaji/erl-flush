-module(forma).
-export([eval/2]).

eval(Params,_)-> 
	{Params,[{"Content-Type","text/plain"},{"Allow","GET,POST"},{"Server","Erl-flush/1.0"}]}.
