-module(parser1).
-export([inicio/1]).

inicio(Input) ->
	{ok, S} = file:read_file(Input),
	L = binary_to_list(S),
	stateA(lists:append(L, "$$"), []).

%% Los espacios estan representados con $_ donde _ es el espacio
stateA([H1, H2|T], Result)->
	if
		(H1 == ${) and (H2 == $#)	->stateB(T, [$ ,$ |Result]); 
		H1 == 10	->stateA([H2|T], [H1|Result]);
		(H1 == 13) and (H2 == 10)	->stateA(T, [H2,H1|Result]);
		(H1 == $$) and (H1 == $$)	->lists:reverse(Result);
		true -> stateA([H2|T], [H1|Result])
	end.
	
stateB([H1,H2|T], Result)->
	if
		(H1 == $#) and (H2 == $})	-> stateA(T, [$ ,$ |Result]);
		H1 == 10 ->  stateB([H2|T], [H1|Result]);
		(H1 == 13) and (H2 == 10)	->stateB(T, [H2,H1|Result]);
		true	-> stateB([H2|T],[$ |Result])
	end.