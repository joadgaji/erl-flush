-module(servidor).
-export([inicio/0]).

-define(RESPONSE_PAGE,
"HTTP/1.0 200 OK
Server: StupidErlangServer/0.1
Content-Type: text/html; charset=ISO-8859-1

<html>
  <head>
    <title>It Works!</title>
    <style type='text/css'>
      body {
        background-color: white;       
        font-family: sans-serif;
        font-size: medium;
        padding: 20px;
      }
      pre {
        margin: 0px 20px;
        padding: 20px;
        border: 1px solid #000000;
        background-color: #eeeeee;
      }
    </style>
  </head>
  <body>
    <h1>Erlang Server: It works!</h1>
    <p>Request message is:</p>
    <pre>~s</pre>
  </body>
</html>
").

inicio() -> 
	{ok, Port} = leerarchivo(port),
	
    {ok, Listen} = gen_tcp:listen(Port, [binary, {packet, 0}, {reuseaddr, true}, {active, false}]),    
    io:format("StupidErlangServer Ver. 0.1~n(C) by Ariel Ortiz, 2008.~n"),
    accept(Listen).
    
accept(Listen) ->        
    {ok, Socket} = gen_tcp:accept(Listen),
    loop(Socket),
    gen_tcp:close(Socket),
    accept(Listen).
    
loop(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, B} ->
            Input = binary_to_list(B),
            print_time(),
            print_request(Input),
            gen_tcp:send(Socket, 
                         [io_lib:format(?RESPONSE_PAGE, [Input])])
    end.
    
print_time() ->
    {{Year, Month, Day}, {Hour, Min, Sec}} = erlang:localtime(),
    io:format("~w/~2.2.0w/~2.2.0w ~2.2.0w:~2.2.0w:~2.2.0w ", [Year, Month, Day, Hour, Min, Sec]).
    
print_request(Input) ->
    [H|_] = string:tokens(Input, "\r\n"),
    io:format("\"~s\"~n", [H]).
    
  leerarchivo(Atom)	->
	case file:open("server_config.dat", read) of
	{ok, S}	->
		Val = leerarch(S, Atom),
		file:close(S),
		{ok,Val};
	{error, Why}	->
		{error, Why}
	end.
	
leerarch(S, Atom)	->
	case io:read(S, '') of
		{ok, {Atom, Result}} -> Result;
		eof	-> [];
		true 	-> leerarch(S, Atom)
	end.
