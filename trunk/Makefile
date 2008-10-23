pruebas :  comment.beam lexer1.beam lexer2.beam lexer3.beam parser.beam exp_eval.beam peval.beam\
		server.beam cliente.beam\
		test_comment.beam test_lexer1.beam test_lexer2.beam test_lexer3.beam test_parser.beam test_eval.beam test_peval.beam test_servidor.beam
	erl -noshell -s test_comment test -s init stop
	erl -noshell -s test_lexer1 test -s init stop
	erl -noshell -s test_lexer2 test -s init stop
	erl -noshell -s test_lexer3 test -s init stop
	erl -noshell -s test_parser test -s init stop
	erl -noshell -s test_eval test -s init stop
	erl -noshell -s test_peval test -s init stop 
	erl -noshell -s test_servidor test -s init stop
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

subdirs :
	cd eunit; make

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

clean : borra pruebas
	
borra : 
	rm *.beam