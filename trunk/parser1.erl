-module(parser1).
-export([inicio/1]).

inicio(Input) ->
	case file:read_file(Input) of
		{ok, S} -> L = binary_to_list(S),
			stateA(lists:append(L, "$$"), []);
		{error,_} -> stateA(lists:append(Input, "$$"), [])
	end.

%% Los espacios estan representados con $_ donde _ es el espacio
stateA([H1, H2|T], Result)->
	if
		(H1 == ${) and (H2 == $#)	->stateB(T, [32, 32|Result]); 
		(H1 == $#) and (H2 == $})	->throw(badcomment); 
		H1 == 10	->stateA([H2|T], [H1|Result]);
		(H1 == 13) and (H2 == 10)	->stateA(T, [H2,H1|Result]);
		(H1 == $$) and (H2 == $$)	->lists:reverse(Result);
		true -> stateA([H2|T], [H1|Result])
	end.
	
stateB([H1,H2|T], Result)->
	if
		(H1 == $#) and (H2 == $})	-> stateA(T, [32,32|Result]);
		(H1 == ${) and (H2 == $#)	->throw(badcomment); 
		(H1 == $$) and (H2 == $$)	->throw(badcomment); 
		H1 == 10 ->  stateB([H2|T], [H1|Result]);
		(H1 == 13) and (H2 == 10)	->stateB(T, [H2,H1|Result]);
		true	-> stateB([H2|T],[32|Result])
	end.