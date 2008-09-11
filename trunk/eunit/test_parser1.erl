-module(test_parser1).
-include_lib("eunit/include/eunit.hrl").
-import(lexer1, [inicio/1]).

inicio_test_() ->
    [?_assert(inicio("eunit/test_lexer1.html") == ["<!-- hola    
            
    	-->
<html>\
	   
		{%  \"hola1\" + 'hola2' / \"ho
		la3\" = \"ho\\nla4\"%} 
		               
	</body>
</html>
"])].
