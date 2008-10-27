pruebas :  comment.beam lexer1.beam lexer2.beam lexer3.beam parser.beam exp_eval.beam peval.beam\
		server.beam cliente.beam\
		tests_subdirs
	erl -noshell -s eunit/test_comment test -s init stop
	erl -noshell -s eunit/test_lexer1 test -s init stop
	erl -noshell -s eunit/test_lexer2 test -s init stop
	erl -noshell -s eunit/test_lexer3 test -s init stop
	erl -noshell -s eunit/test_parser test -s init stop
	erl -noshell -s eunit/test_eval test -s init stop
	erl -noshell -s eunit/test_peval test -s init stop 
	erl -noshell -s eunit/test_servidor test -s init stop
	
lexer1.beam : lexer1.erl
	erlc lexer1.erl

lexer2.beam : lexer2.erl
	erlc lexer2.erl

comment.beam : comment.erl
	erlc comment.erl
	
lexer3.beam : lexer3.erl
	erlc lexer3.erl
	
parser.beam : parser.erl
	erlc parser.erl

exp_eval.beam : exp_eval.erl
	erlc exp_eval.erl

peval.beam : peval.erl
	erlc peval.erl

server.beam : servidor/server.erl
	erlc servidor/server.erl

cliente.beam : servidor/cliente.erl
	erlc servidor/cliente.erl



tests_subdirs :
	cd eunit : pruebas

test_comment.beam : eunit/test_comment.erl
	erlc eunit/test_comment.erl

test_lexer1.beam : eunit/test_lexer1.erl
	erlc eunit/test_lexer1.erl

test_lexer2.beam : eunit/test_lexer2.erl
	erlc eunit/test_lexer2.erl

test_lexer3.beam : eunit/test_lexer3.erl
	erlc eunit/test_lexer3.erl

test_parser.beam : eunit/test_parser.erl
	erlc eunit/test_parser.erl

test_eval.beam : eunit/test_eval.erl
	erlc eunit/test_eval.erl
	
test_peval.beam : eunit/test_peval.erl
	erlc eunit/test_peval.erl

test_servidor.beam : eunit/test_servidor.erl
	erlc eunit/test_servidor.erl

clean : 
	borra pruebas
	cd eunit : make clean
	
borra : 
	rm *.beam
	cd eunit : make borra