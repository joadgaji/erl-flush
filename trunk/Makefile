pruebas : lexer1.beam lexer2.beam comment.beam test_lexer1.beam test_comment.beam\
		test_lexer2.beam lexer3.beam parser.beam test_parser.beam test_lexer3.beam
	erl -noshell -s test_comment test -s init stop
	erl -noshell -s test_lexer1 test -s init stop
	erl -noshell -s test_lexer2 test -s init stop
	erl -noshell -s test_lexer3 test -s init stop 
	erl -noshell -s test_parser test -s init stop
	
	
WIN = 
	
lexer1.beam : lexer1.erl
	erlc $(WIN) lexer1.erl

lexer2.beam : lexer2.erl
	erlc $(WIN) lexer2.erl

comment.beam : comment.erl
	erlc $(WIN) comment.erl
	
lexer3.beam : lexer3.erl
	erlc $(WIN) lexer3.erl
	
parser.beam : parser.erl
	erlc $(WIN) parser.erl

subdirs :
	cd eunit; make
	
test_comment.beam : eunit/test_comment.erl
	erlc $(WIN) eunit/test_comment.erl
	
test_lexer1.beam : eunit/test_lexer1.erl
	erlc $(WIN) eunit/test_lexer1.erl

test_lexer2.beam : eunit/test_lexer2.erl
	erlc $(WIN) eunit/test_lexer2.erl
	
test_lexer3.beam : eunit/test_lexer3.erl
	erlc $(WIN) eunit/test_lexer3.erl

test_parser.beam : eunit/test_parser.erl
	erlc $(WIN) eunit/test_parser.erl
	
clean : borra pruebas
	
borra : 
	rm *.beam
	
	
