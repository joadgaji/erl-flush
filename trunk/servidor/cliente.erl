-module(cliente).

-export([tests/1, test1/1]).

tests(Port) ->
  
    spawn(fun() -> test1(Port) end).



test1(Port) ->
    case gen_tcp:connect("localhost", Port, [binary,{packet, 0}]) of
	{ok, Socket} ->
	    io:format("Socket=~p~n",[Socket]),
	    gen_tcp:send(Socket, "GET /deportes.css HTTP/1.0"),
	    Reply = wait_reply(Socket),
	    io:format("Reply 1 = ~p~n", [Reply]),
	    gen_tcp:close(Socket);
	_ ->
	    error
    end.


wait_reply(X) ->
    receive
	Reply ->
	    {value, Reply}
    after 100000 ->
	    timeout
    end.

