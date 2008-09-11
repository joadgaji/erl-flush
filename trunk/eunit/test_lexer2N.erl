-module(test_lexer2N).
-import(lexer2N, [separa_token/1]).
-include_lib("C:/tools/eunit/include/eunit.hrl").

separa_token_test_() ->
[?_assert(separa_token({expresion,4,10,"{{1+2}}"}) == [
        {entero,4,12,"1"}, 
        {simbolo,4,13,"+"}, 
		{entero,4,14,50,"2"}])].


