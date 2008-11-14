-module(test_if).
-import(serverl, [inicio/0]).
-import(cliente, [test1/2]).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

if_prueba1_test_() ->
	[?_assert(cliente:test1(8800,"GET /prueba_if/fact_if?x=3&y=3 HTTP/1.0") == "HTTP/1.0 200 OK\nServer:Erl-flush\r\nContent-type:text/html\r\n\n<html>\n\t<body>\n\t\n\tx = 6, &nbsp; \n\t\t\n\t\ty es menor a 20\n\t\t\n\t\t<br>\n\t\t\n\ty = 6, &nbsp;\n\t\t\n\t\ty es menor a 10, &nbsp;\n\t\t\t\n\t\t\tpero es mayor a 0\n\t\t\t<br>\n\t\t\t\n\t\t\n\t\t\n\t</body>\n</html>\n")].
	
if_prueba2_test_() 	->
	[?_assert(cliente:test1(8800,"GET /prueba_if/fact_if?x=4&y=4 HTTP/1.0") == "HTTP/1.0 200 OK\nServer:Erl-flush\r\nContent-type:text/html\r\n\n<html>\n\t<body>\n\t\n\tx = 24, &nbsp; \n\t\t\n\t\ty es mayor a 20\n\t\t\n\t\t<br>\n\t\t\n\ty = 24, &nbsp;\n\t\t\n\t\ty es mayor a 10, &nbsp;\n\t\t\t\n\t\t\tpero es menor a 100\n\t\t\t<br>\n\t\t\t\n\t\t\n\t\t\n\t</body>\n</html>\n")].
