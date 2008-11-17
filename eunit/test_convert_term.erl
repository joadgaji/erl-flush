-module(test_convert_term).
-import(convert_term, [convert/1]).

-include_lib("eunit/include/eunit.hrl").

listas_test_()	->
	[?_assert(convert("[1,2,3]")==[1,2,3]),
	?_assert(convert("[1.1,2.2,3.3]") == [1.10000,2.20000,3.30000]),
	?_assert(convert("[a,b,c]")==["a","b","c"]),
	?_assert(convert("[hola,adios]")==["hola", "adios"])].
	
dictionarios_test_()	->
	[?_assert(convert("[{a,1}]")==[{"a", 1}]),
	?_assert(convert("[{a,10},{b,prueba}]")==[{"a", 10},{"b", "prueba"}])].
