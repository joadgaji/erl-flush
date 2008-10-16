-module(serverl).
-export([inicio/0]).

inicio() -> 
	Port = leerarchivo(port),
    {ok, Listen} = gen_tcp:listen(Port, [binary, {packet, 0}, {reuseaddr, true}, {active, false}]),    
    io:format("Erl-FlushServer Ver. 0.1~n(C) by Erl-Flush Team, 2008.~n"),
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
			if
				(Metodo == "GET") -> 
					{Response, New_header, BodyPage} = arecurso(Recurso),
					io:format(Response, [New_header, BodyPage]),
					gen_tcp:send(Socket, [io_lib:format(Response, [New_header, BodyPage])]);
				(Metodo /= "GET") or (Metodo /= "POST") -> 
					ArchivoPagina = leerarchivo(pagina405),
					{ok, Pagina} = file:read_file(ArchivoPagina),
					gen_tcp:send(Socket, [io_lib:format(binary_to_list(Pagina), [""])])
				%(New_input == ["404"]) -> 
				%	{ok, ArchivoPagina} = leerarchivo(pagina404),
				%	{ok, Pagina} = file:read_file(ArchivoPagina),
				%	gen_tcp:send(Socket, [io_lib:format(binary_to_list(Pagina), [""])]);
				
			end
		%[Name|Extension] = string:tokens(Recurso, "."),
		%	New_input = set_content_type(Extension,Input),
    end.
    
print_time() ->
    {{Year, Month, Day}, {Hour, Min, Sec}} = erlang:localtime(),
    io:format("~w/~2.2.0w/~2.2.0w ~2.2.0w:~2.2.0w:~2.2.0w ", [Year, Month, Day, Hour, Min, Sec]).
    
print_request(Input) ->
    [H|_] = string:tokens(Input, "\r\n"),
    io:format("\"~s\"~n", [H]).
    
set_content_type(Extension)->
	%[_,_|T] = lists:reverse(Input),
	%NInput = lists:reverse(T),
	if 
		(Extension == "html")-> "Content-type : text/html\n";
		(Extension == "txt")-> "Content-type : text/plain\n";
		(Extension == "css")-> "Content-type : text/css\n";
		(Extension == "js")-> "Content-type : text/javascript\n";
		(Extension == "jpeg") or (Extension == "jpg")-> "Content-type : image/jpeg\n";
		(Extension == "png")-> "Content-type : image/x-png\n";
		(Extension == "gif")-> "Content-type : image/gif\n";
		true -> ["\n"]
	end.
	
arecurso(Recurso)	->
	[Name,Extension|Parametros] = string:tokens(Recurso, [$., $?]),
	New_header = set_content_type(Extension),
	Root = leerarchivo(root),
	io:format("Root; ~s, Name: ~s, Extension: ~s",[Root, Name, Extension]),
	BodyPagina = buscararchivo(Root ++ Name ++ "." ++ Extension),
	%ResponseRoot = leerarchivo(pagina200),
	%TemplatePagina = buscararchivo(ResponseRoot),
	TemplatePagina = formarPagina(BodyPagina, New_header),
	%io:format("Root; ~s, Name: ~s, Extension: ~s",[TemplatePagina, Name, Extension]),
	{TemplatePagina, New_header, BodyPagina}.

formarPagina(BodyPagina, New_Header)	->
	if
		New_Header == "\n"	->
			ResponseRoot = leerarchivo(pagina404),
			buscararchivo(ResponseRoot);
		BodyPagina  /= error	-> 
			ResponseRoot = leerarchivo(pagina200),
			buscararchivo(ResponseRoot);
		true -> 
			ResponseRoot = leerarchivo(pagina404),
			buscararchivo(ResponseRoot)
	end.
	
	
leerarchivo(Atom)	->
	case file:open("server_config.dat", read) of
	{ok, S}	->
		Val = leerarch(S, Atom),
		file:close(S),
		Val;
	{error, Why}	->
		Why
	end.
	
leerarch(S, Atom)	->
	case io:read(S, ' ') of
		{ok, Term} -> evalTerm(S, Atom, Term);
		eof	-> [];
		true 	-> leerarch(S, Atom)
	end.

evalTerm(S, Atom, {Atom2, Result})	->
	if 
		Atom == Atom2	-> Result;
		true	-> leerarch(S, Atom)
	end.
	
buscararchivo(Archivo)	->
	case file:read_file(Archivo) of
	{ok, Bin}	-> binary_to_list(Bin);
	{error, _}		-> error
	end.