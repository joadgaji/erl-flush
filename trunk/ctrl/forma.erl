-module(forma).
-export([eval/2]).

eval(Params,_)-> 
	{Params,[{"Content-Type","text/html"},{"Allow","GET,POST"},{"Server","Erl-flush/1.0"}]}.
