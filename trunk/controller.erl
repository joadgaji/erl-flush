-module(controller).
-import(peval, [principal/2]).
-export([inicio_controller/4]).

inicio_controller(Modulo,Funcion,Params,Headers)->
	{ValoresPlantilla,HeadersResponse} = apply(Modulo,Funcion,[Params,Headers]),
	peval:principal("views/forma.html",ValoresPlantilla).