pruebas: test_parser1.beam test_lexer1.beam
	
test_lexer1.beam : test_lexer1.erl
	erlc test_lexer1.erl
	
test_parser1.beam : test_parser1.erl
	erlc test_parser1.erl
	
clean : borra pruebas

borra : 
	rm *.beam
