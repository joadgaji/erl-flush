-module(test_peval).
-import(peval, [principal/2]).

-ifdef(windows) .
-include_lib("C:/tools/eunit/include/eunit.hrl").
-else.
-include_lib("eunit/include/eunit.hrl").
-endif.

principal_eval_test_()	->
[?_assert(principal("eunit/todo.html", [{x,5},{y,10}])== "<!-- hola \n\t-->\n<html>\n\t<body bg color=\"blue\">\n\t\t1.01000000000000000000e+001\n\t\t6.40000000000000040000e+000\n\t\t2.00000000000000000000e+000\n\t\t4.05000000000000000000e+001\n\t\tfalse\n\t\tfalse\n\t\tholahola\n\t\t4\n\t\to\n\t\tfalse\n\t</body>\n</html>\n")].
