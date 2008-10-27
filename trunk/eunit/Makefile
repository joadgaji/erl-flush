pruebas: test_comment.beam test_parser.beam test_lexer1.beam test_lexer2.beam test_lexer2.beam test_lexer3.beam\
	test_eval.beam test_peval.beam test_servidor.beam
	
test_lexer1.beam : test_lexer1.erl
	erlc test_lexer1.erl
	
test_lexer2.beam : test_lexer2.erl
	erlc test_lexer2.erl
	
test_lexer3.beam : test_lexer3.erl
	erlc test_lexer3.erl
	
test_parser.beam : test_parser.erl
	erlc test_parser.erl
	
test_comment.beam : test_comment.erl
	erlc test_comment.erl
	
test_eval.beam : test_eval.erl
	erlc test_eval.erl
	
test_peval.beam : test_peval.erl
	erlc test_peval.erl
	
test_servidor.beam : test_servidor.erl
	erlc test_servidor.erl
	
clean : borra pruebas

borra : 
	rm *.beam
