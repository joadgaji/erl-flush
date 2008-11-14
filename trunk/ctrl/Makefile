compilados: forma.beam prueba.beam formanum.beam prueba_if.beam

formanum.beam : formanum.erl
	erlc formanum.erl
	
forma.beam : forma.erl
	erlc forma.erl
	
prueba.beam : prueba.erl
	erlc prueba.erl
	
prueba_if.beam : prueba_if.erl
	erlc prueba_if.erl
	
clean : borra compilados

borra : 
	rm *.beam