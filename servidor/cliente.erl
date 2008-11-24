-module(cliente).
-export([tests/2, test1/2]).

tests(Port,Request) ->
    spawn(fun() -> test1(Port,Request) end).

%% se inicia un cliente para realizar las prubeas necesarias en el framework
test1(Port,Request) ->
    case gen_tcp:connect("localhost", Port, [binary,{packet, 0}]) of
	{ok, Socket} ->
	    %%io:format("Socket=~p~n",[Socket]),
	    gen_tcp:send(Socket, Request),
	    {_, { _, _, Reply}} = wait_reply(Socket),
	    %io:format("~p~n", [Reply]),
	    gen_tcp:close(Socket),
	    binary_to_list(Reply);
	_ ->
	    error
    end.

%% Se espera a la respuesta del servidor en 100000 milisegundos.
wait_reply(_) ->
    receive
	Reply ->
	    {value, Reply}
    after 100000 ->
	    timeout
    end.

