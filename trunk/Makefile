pruebas : lexer1.beam lexer2N.beam parser1.beam test_lexer1.beam test_parser1.beam\
		test_lexer2N.beam
	erl -noshell -s test_parser1 test -s init stop
	erl -noshell -s test_lexer1 test -s init stop
	erl -noshell -s test_lexer2N test -s init stop
	
WIN = 
	
lexer1.beam : lexer1.erl
	erlc $(WIN) lexer1.erl

lexer2N.beam : lexer2N.erl
	erlc $(WIN) lexer2N.erl

parser1.beam : parser1.erl
	erlc $(WIN) parser1.erl

subdirs :
	cd eunit; make
	
test_parser1.beam : eunit/test_parser1.erl
	erlc $(WIN) eunit/test_parser1.erl
	
test_lexer1.beam : eunit/test_lexer1.erl
	erlc $(WIN) eunit/test_lexer1.erl

test_lexer2N.beam : eunit/test_lexer2N.erl
	erlc $(WIN) eunit/test_lexer2N.erl
	
clean : borra pruebas
	
borra : 
	rm *.beam
	
	
