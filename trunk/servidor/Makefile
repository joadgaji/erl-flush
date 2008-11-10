compilados: server.beam cliente.beam 

server.beam : server.erl
	erlc server.erl

cliente.beam : cliente.erl
	erlc cliente.erl

clean : borra compilados

borra : 
	rm *.beam