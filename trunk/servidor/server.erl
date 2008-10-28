-module(server).
%-export([inicio/0, listParams/1, listaHead/2, stringHeaders/2]).
-compile(export_all).
-import(ascii, [listParams/1]).
inicio() -> 
    Port = leerConfig(port),
    Rootctrl = leerConfig(controller_root),
    code:add_path(Rootctrl),
    code:add_path("."),
    code:add_path(".."),
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
				(Metodo == "GET")	and (Recurso == "/")->
					ArchivoPagina = leerConfig(index),
					{ok, Pagina} = file:read_file(ArchivoPagina),
					gen_tcp:send(Socket, [io_lib:format(binary_to_list(Pagina), ["\n"])]);
				(Metodo == "GET") -> 
					{Response, New_header, BodyPage} = readResource(Recurso, Input),
					io:format(Response, [New_header, BodyPage]),
					gen_tcp:send(Socket, [io_lib:format(Response, [New_header, BodyPage])]);
				(Metodo == "POST") -> 
					{Response, New_header, BodyPage} = readPostResource(Recurso, Input),
					io:format("Response ~s~n ", [Input]),
					%io:format(Response, [New_header, BodyPage]),
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
	
readResource(Recurso, Input)	->
	[Name, Extension|Parametros] = evalResource(Recurso),
	if 
		Extension == controlador	->
			[Param] = Parametros,
			recursoDinamico(Name, Param, Input);
		true	-> recursoEstatico(Name, Extension) 
	end.

	
readPostResource(Recurso, Input)	->
	[Name, Extension|_] = evalResource(Recurso),
	Parametros = [get_params_post(Input)],
	io:format("PARA; ~s",[Parametros]),
	if 
		Extension == controlador	->
			[Param] = Parametros,
			recursoDinamico(Name, Param, Input);
		true	-> recursoEstatico(Name, Extension) 
	end.
	
recursoDinamico(Name, Parametros, Input)	->
	[Modulo, Funtion |_] = string:tokens(Name, [$/]),
	io:format("Modulo; ~s, Function: ~s, Parametros: ~s~n",[Modulo, Funtion, Parametros]),
	%io:format("Input; ~s",[Input]),
	Listaparametros = ascii:listParams(Parametros),
	Response = "HTTP/1.0 200 OK\n~s\n~s",
	Index = string:str(Input, "\r\n"),
	Index2 = string:str(Input, "\r\n\r\n"),
	if 
		Index == Index2	-> Headlist= [];
		true	-> Headlist = string:sub_string(Input, Index+2, Index2-1)
	end,
	%io:format("Hlist ~s~n~n", [Headlist]),
	Hlist = listaHead(string:tokens(Headlist, "\r\n"), []),
	%io:format("Hlist ~p~n~n", [Hlist]),
	{ValPlantilla, HeaderPlantilla} = apply(list_to_atom(Modulo), list_to_atom(Funtion), [Listaparametros, Hlist]),
	io:format("valplantilla ~p~n headerplantilla~p~n", [ValPlantilla, HeaderPlantilla]),
	Rootviews = leerConfig(view_root),
	PaginaHtml = peval:principal(Rootviews  ++ Funtion ++ ".html", ValPlantilla),
	%io:format("PAgina; ~p~n", [PaginaHtml]),
	io:format("Header a plantilla; ~p~n", [HeaderPlantilla]),
	%Headlist =  stringHeaders(HeaderPlantilla, ""),
	%io:format("Headers ~s ~n", [Headlist]),
	io:format("HTTP/1.0 200 OK\n~p\n~p", ["Content-type: text/html\n", PaginaHtml]),
	{Response,"Content-type: text/html\n", PaginaHtml}.
	
stringHeaders([], Result)	-> Result;
stringHeaders([{A, B}|C], Result)	->
	%io:format("A, ~p  B, ~p ~n", [A, B]),
	P1 = string:concat(A, ":"),
	P2 = string:concat(B, "\r\n"),
	P3 = string:concat(P1, P2),
	stringHeaders(C, string:concat(Result, P3)).
	
listaHead("",Result)	-> lists:reverse(Result);
listaHead([A|B], Result)	->
	Index = string:str(A, ":"),
	{Hname, Hvalue}= lists:split(Index, A),
	Len = string:len(Hname),
	listaHead(B, [{string:sub_string(Hname, 1, Len -1 ), Hvalue}|Result]).
	
%listParams([])	-> [];
%listParams(Parametros)	->
%	params(string:tokens(Parametros, [$&]), []).

params("", Result)	->  lists:reverse(Result);
params([A|B], Result)	->
	Index = string:rchr(A, $=),
	io:format("A; ~s, B: ,~p Index: ~p~n", [A, B, Index]),
	{Variable, Vigual} = lists:split(Index-1, A),
	{_, Valor} = lists:split(1, Vigual),
	io:format("Variable ~s, Valor ~s ~n", [Variable, Valor]),
	params(B,[{list_to_atom(Variable), Valor}|Result]).
	

get_params_post(Input) ->
	Index2 = string:str(Input, "\r\n\r\n"),
	Parametros = string:sub_string(Input, Index2+4, string:len(Input)),
	Parametros.
	
%tamaArchivo(Header, Archivo)	->
%no se como cachar lo del archivo
%	case file:read_file_info(Archivo) of
%		{ok, {_, sizefile, _, _, _, _, _, _, _, _, _, _, _, _}}	->
%			head = "Content-size = " ++ sizefile ++ "\n",
%			string:concat(Header, head);
%		_ 	->
%			Header
%	end.

recursoEstatico(Name, Extension)	->
	New_header = set_content_type(Extension),
	Root = leerConfig(root),
	Archivo = Root ++ Name ++ "." ++ Extension,
	BodyPage = buscarArchivo(Archivo),
	TemplatePagina = formarPagina(BodyPage, Archivo),
	%New_header2 = tamaArchivo(New_header, Archivo),
	io:format("Root; ~s, Name: ~s, Extension: ~s",[Root, Name, Extension]),
	{TemplatePagina, New_header, BodyPage}.
	
evalResource(Recurso)	->
	[Fuente|_] = string:tokens(Recurso, [$?]),
	A = string:rchr(Fuente, $.),
	if
		(A == 0)	->
			[Name|Parametros]	= string:tokens(Recurso, [$?]),
			[Name, controlador|Parametros];
		true	->
			string:tokens(Recurso, [$. , $?])
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
	{error, _}	->
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