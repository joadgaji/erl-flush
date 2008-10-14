-module(servidor2).
-export([inicio/0]).

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
			[Request|_] = string:tokens(Input, "\r\n"),
			[Metodo,Recurso|_] = string:tokens(Request, " "),
			[Name|Extension] = string:tokens(Recurso, "."),
			New_input = set_content_type(Extension,Input),
			if
				(Metodo == "GET") -> 
					Response = darrespuesta(Recurso);
					gen_tcp:send(Socket, [io_lib:format(Response, [New_input])]);
				(Metodo /= "GET") or (Metodo /= "POST") -> 
					{ok, ArchivoPagina} = leerarchivo(pagina405),
					{ok, Pagina} = file:read_file(ArchivoPagina),
					gen_tcp:send(Socket, [io_lib:format(binary_to_list(Pagina), [""])])
				%(New_input == ["404"]) -> 
				%	{ok, ArchivoPagina} = leerarchivo(pagina404),
				%	{ok, Pagina} = file:read_file(ArchivoPagina),
				%	gen_tcp:send(Socket, [io_lib:format(binary_to_list(Pagina), [""])]);
				
			end
    end.
    
print_time() ->
    {{Year, Month, Day}, {Hour, Min, Sec}} = erlang:localtime(),
    io:format("~w/~2.2.0w/~2.2.0w ~2.2.0w:~2.2.0w:~2.2.0w ", [Year, Month, Day, Hour, Min, Sec]).
    
print_request(Input) ->
    [H|_] = string:tokens(Input, "\r\n"),
    io:format("\"~s\"~n", [H]).
    
set_content_type(Extension, Input)->
	[_,_|T] = lists:reverse(Input),
	NInput = lists:reverse(T),
	if 
		(Extension == ["html"])-> lists:append(NInput,"Content-type : text/html");
		(Extension == ["txt"])-> lists:append(NInput,"Content-type : text/plain");
		(Extension == ["css"])-> lists:append(NInput,"Content-type : text/css");
		(Extension == ["js"])-> lists:append(NInput,"Content-type : text/javascript");
		(Extension == ["jpeg"])-> lists:append(NInput,"Content-type : image/jpeg");
		(Extension == ["png"])-> lists:append(NInput,"Content-type : image/x-png");
		(Extension == ["gif"])-> lists:append(NInput,"Content-type : image/gif");
		true -> ["404"]
	end.
	
darrecurso(Recurso)	->
	[Name|Extension] = string:tokens(Recurso, "."),
	New_input = set_content_type(Extension,Input),
	{ok, Root} = leerarchivo(root),
	{ok, ArchivoPagina} = leerarchivo(Root ++ Recurso),
	{ok, Pagina} = file:read_file(ArchivoPagina),

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