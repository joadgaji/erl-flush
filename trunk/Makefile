pruebas : lexer.beam  parser.beam test_lexer1.beam test_parser1.beam
	erl -noshell -s test_lexer1 test -s init stop
	
lexer.beam : lexer1.erl
	erlc lexer1.erl

parser.beam : parser1.erl
	erlc parser1.erl

subdirs :
	cd eunit; make
	
test_lexer1.beam : eunit/test_lexer1.erl
	erlc eunit/test_lexer1.erl

test_parser1.beam : eunit/test_parser1.erl
	erlc eunit/test_parser1.erl
	
clean : borra pruebas
	

borra : 
	rm *.beam
	
	
