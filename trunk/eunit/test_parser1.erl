-module(test_parser1).
-include_lib("eunit/include/eunit.hrl").
-import(parser1, [inicio/1]).

inicio_test_() ->
    [?_assert(inicio("eunit/test_parser1.html") =="<!-- hola \n\t     \n\t-->\n<html>\n\t<body bg color=\"bl{{ue}}\">\n\t\t                     \n\t\t{{'hola2'}}\n\t</body>\n</html>\n\n"),
    ?_assertException(throw, badcomment, inicio("{#hola")),
    ?_assertException(throw, badcomment, inicio("hola#}")),
    ?_assertException(throw, badcomment, inicio("{#hola{#"))].
