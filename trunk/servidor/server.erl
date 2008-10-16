-module(server).
-export([inicio/0]).

inicio() -> 
    Port = leerConfig(port),
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
					{Response, New_header, BodyPage} = readResource(Recurso),
					io:format(Response, [New_header, BodyPage]),
					gen_tcp:send(Socket, [io_lib:format(Response, [New_header, BodyPage])]);
				(Metodo == "POST") -> 
					{Response, New_header, BodyPage} = readResource(Recurso),
					io:format(Response, [New_header, BodyPage]),
					gen_tcp:send(Socket, [io_lib:format(Response, [New_header, BodyPage])]);
				(Metodo /= "GET") or (Metodo /= "POST") -> 
					ArchivoPagina = leerConfig(pagina405),
					{ok, Pagina} = file:read_file(ArchivoPagina),
					gen_tcp:send(Socket, [io_lib:format(binary_to_list(Pagina), [""])])
			end
    end.
    
print_time() ->
    {{Year, Month, Day}, {Hour, Min, Sec}} = erlang:localtime(),
    io:format("~w/~2.2.0w/~2.2.0w ~2.2.0w:~2.2.0w:~2.2.0w ", [Year, Month, Day, Hour, Min, Sec]).
    
print_request(Input) ->
    [H|_] = string:tokens(Input, "\r\n"),
    io:format("\"~s\"~n", [H]).
    
set_content_type(Extension)->
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
	
readResource(Recurso)	->
	% en _  van los parametros
	[Name, Extension|_] = evalResource(Recurso),
	New_header = set_content_type(Extension),
	Root = leerConfig(root),
	Archivo = Root ++ Name ++ "." ++ Extension,
	BodyPage = buscarArchivo(Archivo),
	TemplatePagina = formarPagina(BodyPage, Archivo),
	%New_header2 = tamaArchivo(New_header, Archivo),
	io:format("Root; ~s, Name: ~s, Extension: ~s",[Root, Name, Extension]),
	{TemplatePagina, New_header, BodyPage}.

%tamaArchivo(Header, Archivo)	->
%no se como cachar lo del archivo
%	case file:read_file_info(Archivo) of
%		{ok, {_, sizefile, _, _, _, _, _, _, _, _, _, _, _, _}}	->
%			head = "Content-size = " ++ sizefile ++ "\n",
%			string:concat(Header, head);
%		_ 	->
%			Header
%	end.
	
evalResource(Recurso)	->
	A = string:rchr(Recurso, $.),
	if
		(A == 0)	->
			[Name|Parametros]	= string:tokens(Recurso, [$?]),
			[Name, "html"|Parametros];
		true	->
			string:tokens(Recurso, [$., $?])
	end.
	
formarPagina(BodyPagina, Archivo)	->
	if
		BodyPagina == Archivo -> 
			ResponseRoot = leerConfig(pagina404),
			buscarArchivo(ResponseRoot);
%		New_Header == "\n"	->
%			ResponseRoot = leerConfig(pagina404),
%			buscarArchivo(ResponseRoot);
		BodyPagina  /= error	-> 
			ResponseRoot = leerConfig(pagina200),
			buscarArchivo(ResponseRoot)
	end.
	
	
leerConfig(Atom)	->
	case file:open("servidor/server_config.dat", read) of
	{ok, S}	->
		Val = leerArch(S, Atom),
		file:close(S),
		Val;
	{error, Why}	->
		"Archivo de configuracion no encontrado"
	end.
	
leerArch(S, Atom)	->
	case io:read(S, ' ') of
		{ok, Term} -> evalTerm(S, Atom, Term);
		eof	-> [];
		true 	-> leerArch(S, Atom)
	end.

evalTerm(S, Atom, {Atom2, Result})	->
	if 
		Atom == Atom2	-> Result;
		true	-> leerArch(S, Atom)
	end.
	
buscarArchivo(Archivo)	->
	case file:read_file(Archivo) of
	{ok, Bin}	-> binary_to_list(Bin);
	{error, _}		-> Archivo
	end.