-module(test_peval).
-import(peval, [principal/2]).

-ifdef(windows) .
-include_lib("C:/tools/eunit/include/eunit.hrl").
-else.
-include_lib("eunit/include/eunit.hrl").
-endif.

principal_eval_test_()	->
[?_assert(principal("eunit/todo.html", [{x,5},{y,10}])=="<!-- hola \n\t-->\n<html>\n\t<body bg color=\"blue\">\n\t\t1.00999999999999996447e+01\n\t\t6.40000000000000035527e+00\n\t\t2.00000000000000000000e+00\n\t\t4.05000000000000000000e+01\n\t\tfalse\n\t\tfalse\n\t\tholahola\n\t\t4\n\t\to\n\t\tfalse\n\t</body>\n</html>\n")].

