pruebas :  comment.beam lexer1.beam lexer2.beam lexer3.beam lexer4.beam parser.beam exp_eval.beam peval.beam \
		ascii.beam cliente.beam server.beam eval_enun.beam eval_if.beam libs
	erl -noshell -pa eunit -s test_comment test -s init stop
	erl -noshell -pa eunit -s test_lexer1 test -s init stop
	erl -noshell -pa eunit -s test_lexer2 test -s init stop
	erl -noshell -pa eunit -s test_lexer3 test -s init stop
	erl -noshell -pa eunit -s test_lexer4 test -s init stop
	erl -noshell -pa eunit -s test_parser test -s init stop
	erl -noshell -pa eunit -s test_eval test -s init stop
	erl -noshell -pa eunit -s test_peval test -s init stop 
	erl -noshell -pa eunit -s test_servidor test -s init stop
	erl -noshell -pa eunit -s test_if test -s init stop

lexer1.beam : lexer1.erl
	erlc lexer1.erl

lexer2.beam : lexer2.erl
	erlc lexer2.erl

comment.beam : comment.erl
	erlc comment.erl
	
lexer3.beam : lexer3.erl
	erlc lexer3.erl
	
lexer4.beam : lexer4.erl
	erlc lexer4.erl
	
parser.beam : parser.erl
	erlc parser.erl

exp_eval.beam : exp_eval.erl
	erlc exp_eval.erl

peval.beam : peval.erl
	erlc peval.erl

ascii.beam : ascii.erl
	erlc ascii.erl
	
eval_enun.beam : eval_enun.erl
	erlc eval_enun.erl
	
eval_if.beam : eval_if.erl
	erlc eval_if.erl

server.beam : servidor/server.erl
	erlc servidor/server.erl
	
cliente.beam : servidor/cliente.erl
	erlc servidor/cliente.erl

libs :
	cd eunit; make pruebas
	cd ctrl; make compilados
	
clean : borra pruebas

borra : 
	rm *.beam
	cd eunit; make borra
	cd ctrl; make borra

