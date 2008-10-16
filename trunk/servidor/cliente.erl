-module(cliente).
-export([tests/2, test1/2]).

tests(Port,Request) ->
    spawn(fun() -> test1(Port,Request) end).

test1(Port,Request) ->
    case gen_tcp:connect("localhost", Port, [binary,{packet, 0}]) of
	{ok, Socket} ->
	    io:format("Socket=~p~n",[Socket]),
	    gen_tcp:send(Socket, Request),
	    Reply = wait_reply(Socket),
	    io:format("Reply 1 = ~p~n", [Reply]),
	    gen_tcp:close(Socket);
	_ ->
	    error
    end.

%%"GET /deportes.css HTTP/1.0"
wait_reply(X) ->
    receive
	Reply ->
	    {value, Reply}
    after 100000 ->
	    timeout
    end.

