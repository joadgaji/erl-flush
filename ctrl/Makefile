compilados: forma.beam prueba.beam formanum.beam

formanum.beam : formanum.erl
	erlc formanum.erl
	
forma.beam : forma.erl
	erlc forma.erl
	
prueba.beam : prueba.erl
	erlc prueba.erl
	
clean : borra compilados

borra : 
	rm *.beam