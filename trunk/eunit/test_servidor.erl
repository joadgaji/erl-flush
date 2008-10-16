-module(test_lexer1).
-import(serverl, [inicio/0]).
-import(cliente, [test1/1])

-include_lib("eunit/include/eunit.hrl").

inicio_test_() ->
    [?_assert(test1(800, "GET /deportes.css HTTP/1.0") == [
    		{estatico,1,1,"<!-- hola \n\t"},
    		{expresion,2,2,"{{}}"},
		{estatico,2,6,"\n\t"},
		{enunciado,3,2,"{%%}"},
		{estatico,3,6,"\n\t-->\n<html>\n\t<body bg color=\"bl"},
		{expresion,6,20,"{{ue}}"},
		{estatico,6,26,"\">\n\t\t"},
		{enunciado,7,3,"{%  \"hola1\" + 'hola2' / \"ho\n\t\tla3\" = \"ho\\nla4\"%}"},
		{estatico,8,21," \n\t\t"},
		{expresion,9,3,"{{\"ho'la'5\" % 'ho\n\t\tla6' - 'ho\"la\"7'}}"},
		{estatico,10,21,"\n\t</body>\n</html>\n\n"}])].
		
inicio_especiales_test_() ->
	[?_assert(iniciol1("{{ '{{' }}") == [{expresion,1,1,"{{ '{{' }}"}]),
	?_assert(iniciol1("{% '%}' %}") == [{enunciado,1,1,"{% '%}' %}"}])].
	
inicio_excepciones_test_() ->
	[?_assertThrow(invalidsyntax, iniciol1("{% {{ }} %}")),
	?_assertThrow(invalidsyntax, iniciol1("{{ {% %} }}"))].
	
inicio_nueva_linea_test_() ->
	[?_assert(iniciol1("{{ \"\n\" }}") /= [{expresion,1,1,"{{ \"
	\" }}"}])].
