% Base de Conocimientos

personaje(pumkin, ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent, mafioso(maton)).
personaje(jules, mafioso(maton)).
personaje(marsellus, mafioso(capo)).
personaje(winston, mafioso(resuelveProblemas)).
personaje(mia, actriz([foxForceFive])).
personaje(butch, boxeador).
pareja(marsellus, mia).
pareja(pumkin, honeyBunny).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

% Punto 1

actividadPeligrosa(Personaje):-
    personaje(Personaje, mafioso(maton)).
actividadPeligrosa(Personaje):-
    personaje(Personaje, ladron(QueRoba)),
    member(licorerias, QueRoba).

esPeligroso(Personaje):-
    actividadPeligrosa(Personaje).
esPeligroso(Personaje):-
    trabajaPara(Personaje, Empleado),
    esPeligroso(Empleado).

% Punto 2

% Conocimiento del Punto 2
amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

% Resolucion

% Considero que la relacion de amistad y pareja debe ser simetrica, es decir,
% que si marsellus es pareja de mia entonces mia es pareja de marsellus
sonAmigos(UnPersonaje, OtroPersonaje):-
    amigo(UnPersonaje, OtroPersonaje).
sonAmigos(UnPersonaje, OtroPersonaje):-
    amigo(OtroPersonaje, UnPersonaje).
sonPareja(UnPersonaje, OtroPersonaje):-
    pareja(UnPersonaje, OtroPersonaje).
sonPareja(UnPersonaje, OtroPersonaje):-
    pareja(OtroPersonaje, UnPersonaje).

sonDuo(UnPersonaje, OtroPersonaje):-
    sonPareja(OtroPersonaje, UnPersonaje).
sonDuo(UnPersonaje, OtroPersonaje):-
    sonAmigos(OtroPersonaje, UnPersonaje).

duoTemible(UnPersonaje, OtroPersonaje):-
    esPeligroso(UnPersonaje),
    esPeligroso(OtroPersonaje),
    sonDuo(UnPersonaje, OtroPersonaje). 

% Punto 3

% Conocimiento del Punto 3

%encargo(Solicitante, Encargado, Tarea).
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent, cuidar(mia)).
encargo(vincent, elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

% Resolucion

estaEnProblemas(Personaje):-
    trabajaPara(Jefe, Personaje),
    esPeligroso(Jefe),
    encargo(Jefe, Personaje, cuidar(Persona)),
    sonPareja(Jefe, Persona).

estaEnProblemas(Personaje):-
    encargo(_, Personaje, buscar(Persona, _)),
    personaje(Persona, boxeador).

% Punto 4 

tieneCerca(UnPersonaje, OtroPersonaje):-
    sonAmigos(UnPersonaje, OtroPersonaje).
tieneCerca(UnPersonaje, OtroPersonaje):-
    trabajaPara(UnPersonaje, OtroPersonaje).

sanCayetano(Personaje):-
    personaje(Personaje, _),
    forall(tieneCerca(Personaje, QuienTieneCerca), encargo(Personaje, QuienTieneCerca, _)).

% Punto 5

cantidadEncargos(Personaje, Cantidad):-
    findall(Encargo, encargo(_, Personaje, Encargo), Encargos),
    length(Encargos, Cantidad).

tieneMasEncargos(UnPersonaje, OtroPersonaje):-
    cantidadEncargos(UnPersonaje, CantidadDeUno),
    cantidadEncargos(OtroPersonaje, CantidadDeOtro),
    CantidadDeUno > CantidadDeOtro.

masAtareado(Personaje):-
    personaje(Personaje, _),
    forall((personaje(OtroPersonaje, _), OtroPersonaje \= Personaje), tieneMasEncargos(Personaje, OtroPersonaje)).

% Punto 6 

respetoActividad(actriz(Peliculas), Respeto):-
    length(Peliculas, CantidadPeliculas),
    Respeto is CantidadPeliculas // 10.

respetoActividad(mafioso(resuelveProblemas), 10).
respetoActividad(mafioso(maton), 1).
respetoActividad(mafioso(capo), 20).

personajesRespetables(PersonajesRespetables):-
    findall(Personaje, (personaje(Personaje, Actividad), respetoActividad(Actividad, Respeto), Respeto > 9), PersonajesRespetables).

% Punto 7

requiereInteractuar(cuidar(Personaje), Personaje).
requiereInteractuar(cuidar(Personaje), OtroPersonaje):-
    sonAmigos(Personaje, OtroPersonaje).

requiereInteractuar(buscar(Personaje, _), Personaje).
requiereInteractuar(buscar(Personaje, _), OtroPersonaje):-
    sonAmigos(Personaje, OtroPersonaje).

requiereInteractuar(ayudar(Personaje), Personaje).
requiereInteractuar(ayudar(Personaje), OtroPersonaje):-
    sonAmigos(Personaje, OtroPersonaje).

hartoDe(UnPersonaje, OtroPersonaje):-
    encargo(_, UnPersonaje, _),
    personaje(OtroPersonaje, _),
    forall(encargo(_, UnPersonaje, Encargo), requiereInteractuar(Encargo, OtroPersonaje)).

% Punto 8

% Conocimiento del punto 8
caracteristicas(vincent, [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules, [tieneCabeza, muchoPelo]).
caracteristicas(marvin, [negro]).

% Resolucion

almenosUnaDiferencia(CaracteristicasDeUno, CaracteristicasDeOtro):-
    member(Caracteristica, CaracteristicasDeUno),
    not(member(Caracteristica, CaracteristicasDeOtro)).
almenosUnaDiferencia(CaracteristicasDeUno, CaracteristicasDeOtro):-
    member(Caracteristica, CaracteristicasDeOtro),
    not(member(Caracteristica, CaracteristicasDeUno)).

duoDiferenciable(UnPersonaje, OtroPersonaje):-
    sonDuo(UnPersonaje, OtroPersonaje),
    caracteristicas(UnPersonaje, CaracteristicasDeUno),
    caracteristicas(OtroPersonaje, CaracteristicasDeOtro),
    almenosUnaDiferencia(CaracteristicasDeUno, CaracteristicasDeOtro).


