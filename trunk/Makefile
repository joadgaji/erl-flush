pruebas : lexer1.beam lexer2.beam parser1.beam test_lexer1.beam test_parser1.beam\
		test_lexer2.beam main.beam
	erl -noshell -s test_parser1 test -s init stop
	erl -noshell -s test_lexer1 test -s init stop
	erl -noshell -s test_lexer2 test -s init stop
	erl -noshell -s main principal "todo.html" -s init stop
	
WIN = 
	
lexer1.beam : lexer1.erl
	erlc $(WIN) lexer1.erl

lexer2.beam : lexer2.erl
	erlc $(WIN) lexer2.erl

parser1.beam : parser1.erl
	erlc $(WIN) parser1.erl
	
main.beam : main.erl
	erlc $(WIN) main.erl

subdirs :
	cd eunit; make
	
test_parser1.beam : eunit/test_parser1.erl
	erlc $(WIN) eunit/test_parser1.erl
	
test_lexer1.beam : eunit/test_lexer1.erl
	erlc $(WIN) eunit/test_lexer1.erl

test_lexer2.beam : eunit/test_lexer2.erl
	erlc $(WIN) eunit/test_lexer2.erl
	
clean : borra pruebas
	
borra : 
	rm *.beam
	
	
