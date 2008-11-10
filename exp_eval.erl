-module(exp_eval).
-export([principal_eval/2,stateG/2,eval_/2]).

-import(parser, [parse/1]).
-import(lexer1, [iniciol1/1]).
-import(lexer2, [iniciol2/1]).
-import(lexer3, [principal/1]).
-import(comment, [inicio/1]).
-import(lexer4, [iniciol4/1]).


% Activa el lexer1 que quita comentarios
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%Aqui estoy agregando un Dic, que va a ser el Diccionario de las variables.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
principal_eval(Input, Dic) ->
	R = lexer1:iniciol1(comment:inicio(Input)),
	S = stateA(R ++ [{final}], []),
	stateB(S ++ [{final}], [], Dic).
	
%% Activa el lexer2 para las tuplas que son expresiones
stateA([H|T], Result) ->
	if
		final == element(1, H) ->lists:reverse(Result);
		expresion == element(1,H) -> stateA(T, [lexer2:iniciol2(H)|Result]);
		enunciado== element(1,H)-> stateA(T, [lexer4:iniciol4(H)|Result]);
		true -> stateA(T, [H|Result])
	end.

% Revisa la lista de tuplas de las expresiones para crear nuestra sintaxis para mandar a parser
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Aqui me queda duda todavia de como se va a concatenar stateG con el Result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stateB([H|T], Result, Dic)	->
	io:format("~p~n~n", [T]),
	io:format("Result: ~p~n~n", [Result]),
	if 
		final == element(1, H) -> lists:reverse(Result);
		('if' == element(1,H)) -> 
		{T2, Result2}=eval_enun:principalEnun([H|T], Result, Dic),
		stateB(T2, Result2, Dic);
		%('for'== element(1,H))	-> {T2, Result2}=eval_enun:principalEnun([H|T], Result, Dic, 0, 1),
		%stateB(T2, Result2);
		is_list(H)	-> stateB(T, [stateG(lexer3:principal(H), Dic)|Result], Dic);
		true 	-> stateB(T, [H|Result],Dic)
	end.

%Se toma el valor regresado por lexer 3 y se evalua, regresa el resultado de la evaluacion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% aqui entra en stateG -> [{entero, 1, 2, 5}, {'+', 1,2}, {entero,1,4, 6}]   y sale un 11.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stateG(List, Dic)->
	case parse(List) of
        {ok, Result} -> 
            eval_(Result,Dic);
			  
        {error, {Line, _, List}} ->
            case Line of  
                999999 -> throw("Syntax error at end of input");
                Line -> throw("Line " ++ integer_to_list(Line)
                        ++ ", " ++ lists:flatten(List))  
            end                    
    end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Esto es lo que ya esta corriendo ahorita
%% para agregar lo de arriba se debe agregar una variaba Dic a eval_ 
%% Hay errores en el or and xor y esos.. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

eval_({X,A,B}, Dic)-> 
	if
		is_tuple (A) and is_tuple(B) -> eval_({X,eval_(A,Dic),eval_(B,Dic)});
		is_tuple (A) -> eval_({X,eval_(A,Dic),B});
		is_tuple(B) -> eval_({X,A,eval_(B,Dic)});
		is_boolean(A) or is_boolean(B) -> eval_({X,A,B});
		is_atom(A) and is_atom(B) -> eval_({X,eval_atom(A,Dic),eval_atom(B,Dic)});
		is_atom(A) -> eval_({X,eval_atom(A,Dic),B});
		is_atom(B) -> eval_({X,A,eval_atom(B,Dic)});
		true -> eval_({X,A,B})
	end;

eval_({X,A}, _) when is_boolean(A)-> eval_({X,A});
eval_({X,A}, Dic) when is_atom(A)-> eval_({X,eval_atom(A,Dic)});
eval_({X,A}, _) -> eval_({X,A});

eval_(A, _) when is_boolean(A)-> eval_(A);
eval_(A, Dic) when is_atom(A)-> eval_(eval_atom(A,Dic));
eval_(A, _) -> eval_(A).
	

eval_(N) when is_number(N) -> N;
eval_(N) when is_boolean(N) ->N;
eval_(N) when is_list(N) -> 
	Comilla = string:substr(N,1,1),
	Sin_comillas = string:len(N)-1,
	if 	
		(("\"") == Comilla) -> string:sub_string(N,2,Sin_comillas);
		true-> N
	end;


eval_({'+', A, B}) -> eval_(A) + eval_(B);
eval_({'-', A, B}) -> eval_(A) - eval_(B);
eval_({'*', A, B}) -> eval_(A) * eval_(B);
eval_({'/', A, B}) -> eval_(A) / eval_(B);
eval_({'%', A, B}) -> eval_(A) rem eval_(B);

eval_({'<', A, B}) -> eval_(A) < eval_(B);
eval_({'>', A, B}) -> eval_(A) > eval_(B);
eval_({'>=', A, B}) -> eval_(A) >= eval_(B);
eval_({'=<', A, B}) -> eval_(A) =< eval_(B);
eval_({'==', A, B}) -> eval_(A) == eval_(B);
eval_({'/=', A, B}) -> eval_(A) =/= eval_(B);

eval_({'or', A, B}) -> ((eval_(A)) or (eval_(B)));
eval_({'and', A, B}) -> eval_(A) and eval_(B);
eval_({'xor', A, B}) -> eval_(A) xor eval_(B);
eval_({'not', A}) -> not A;

eval_({'[', A, B}) -> 
	if
		is_number(A) and is_list(B) -> string:substr(B, A, 1);
		true-> "error"
	end;
		
eval_({'len',A}) ->
	if
		is_tuple(A) -> string:len(eval_(A));
		is_list(A) -> string:len(A);
		true-> "error"
	end;
	

eval_({'++', A, B})->
	if
		is_tuple(A) and is_tuple(B) -> eval_(A)++eval_(B);
		is_tuple(A) -> eval_(A)++B;
		is_tuple(B)	-> A++eval_(B);
		is_list(A) and is_list(B) -> 
			ComillaA = string:substr(A,1,1),
			Sin_comillasA = string:len(A)-1,
			ComillaB = string:substr(B,1,1),
			Sin_comillasB = string:len(B)-1,	
			if
				(("\"") == ComillaA) and (("\"") == ComillaB)-> string:sub_string(A,2,Sin_comillasA) ++ string:sub_string(B,2,Sin_comillasB);
				(("\"") == ComillaA) -> string:sub_string(A,2,Sin_comillasA) ++ B;
				(("\"") == ComillaB) -> A ++ string:sub_string(B,2,Sin_comillasB);
				true-> A++B
			end;
		true -> "error"
	end.

eval_atom( _, []) 	-> false;
eval_atom( N, [{X,Value}|T])->
	if
		X == N -> Value;
		X /= N -> eval_atom(N,T)
	end.