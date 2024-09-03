% Base de Conocimientos
herramientasRequeridas(ordenarCuarto, [[aspiradora(100), escoba], trapeador, plumero]). 
                                        % la doble lista es un agregado del punto 6
herramientasRequeridas(ordenarCuarto, [escoba, trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

%tareaPedida(tarea, cliente, metrosCuadrados).
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

%precio(tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).

% --------- Punto 1
% tiene/2, tiene(Persona, Herramienta)
tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(peter, trapeador).
tiene(winston, varitaDeNeutrones).

% --------- Punto 2

tieneHerramientaRequerida(Persona, aspiradora(Potencia)):-
    tiene(Persona, aspiradora(PotenciaEnPosesion)),
    between(0, PotenciaEnPosesion, Potencia).

tieneHerramientaRequerida(Persona, Herramienta):-
    Herramienta \= aspiradora(_),
    tiene(Persona,Herramienta).

% Agregado del Punto 6
tieneHerramientaRequerida(Persona, ListaHerramientasReemplazables):-
    member(Herramienta, ListaHerramientasReemplazables),
    tieneHerramientaRequerida(Persona, Herramienta).

% --------- Punto 3

puedeRealizar(Persona, Tarea):-
    herramientasRequeridas(Tarea, _),
    tiene(Persona, varitaDeNeutrones).
puedeRealizar(Persona, Tarea):-
    tiene(Persona,_),
    herramientasRequeridas(Tarea, Herramientas),
    forall(member(Herramienta, Herramientas), tieneHerramientaRequerida(Persona, Herramienta)).

% -------- Punto 4 

cobroPorPedido(Cliente, Total):-
    tareaPedida(_, Cliente, _),
    findall(Precio,(tareaPedida(Tarea, Cliente, Metros), precioPorTarea(Tarea, Metros, Precio)), ListaPrecios),
    sumlist(ListaPrecios, Total).

precioPorTarea(Tarea, Metros, PrecioTotal):-
    precio(Tarea, Precio),
    PrecioTotal is Precio * Metros.

% -------- Punto 5

pidioTareasComplejas(Cliente):-
    tareaPedida(Tarea, Cliente, _),
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas, CantidadHerramientas),
    CantidadHerramientas > 2.
pidioTareasComplejas(Cliente):-
    tareaPedida(limpiarTecho, Cliente, _).

puedeRealizarTodasLasTareas(Persona, Cliente):-
    forall(tareaPedida(Tarea, Cliente,_), puedeRealizar(Persona, Tarea)).

estaDispuesto(ray, Cliente):-
    not(tareaPedida(limpiarTechos, Cliente, _)).

estaDispuesto(winston, Cliente):-
    cobroPorPedido(Cliente, Total),
    Total > 500.

estaDispuesto(egon, Cliente):-
    not(pidioTareasComplejas(Cliente)).

estaDispuesto(peter, _).

acepta(Persona, Cliente):-
    tiene(Persona, _),
    tareaPedida(_,Cliente,_),
    puedeRealizarTodasLasTareas(Persona, Cliente),
    estaDispuesto(Persona, Cliente).

% ------- Punto 6

% Realice los agregados marcados con comentarios para lograr implementar las herramientas reemplazables
% Lo hice agregando una lista que contiene las posibles herramientas y luego agregando una clausula
% al predicado tieneHerramientaRequerida para que pueda trabajar con la lista de herramientas posibles

