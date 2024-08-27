%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parte 1 - Sombrero Seleccionador
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
caracteristicaMago(harry, coraje).
caracteristicaMago(harry, amistad).
caracteristicaMago(harry, orgullo).
caracteristicaMago(harry, inteligencia).
caracteristicaMago(draco, inteligencia).
caracteristicaMago(draco, orgullo).
caracteristicaMago(draco, amistad).
caracteristicaMago(hermione, inteligencia).
caracteristicaMago(hermione, orgullo).
caracteristicaMago(hermione, responsabilidad).

sangre(harry, mestiza).
sangre(draco, pura).
sangre(hermione, impura).

mago(Mago):-
    sangre(Mago,_).

casaQueOdia(harry, slytherin).
casaQueOdia(draco, hufflepuff).

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).

sombreroCaracteristicaPrincipal(gryffindor, coraje).
sombreroCaracteristicaPrincipal(slytherin, orgullo).
sombreroCaracteristicaPrincipal(slytherin, inteligencia).
sombreroCaracteristicaPrincipal(ravenclaw, inteligencia).
sombreroCaracteristicaPrincipal(ravenclaw, responsabilidad).
sombreroCaracteristicaPrincipal(hufflepuff, amistad).

%% Punto 1

permiteEntrar(Casa,Mago):-
    casa(Casa),
    mago(Mago),
    Casa \= slytherin.
permiteEntrar(slytherin,Mago):-
    sangre(Mago,Sangre),
    Sangre \= impura.

%% Punto 2

caracterApropiado(Mago,Casa):-
    casa(Casa),
    mago(Mago),
    forall(sombreroCaracteristicaPrincipal(Casa,Caracteristica),caracteristicaMago(Mago,Caracteristica)).

%% Punto 3

puedeQuedarSeleccionado(Mago, Casa):-
    caracterApropiado(Mago,Casa),
    permiteEntrar(Casa, Mago),
    not(casaQueOdia(Mago, Casa)).

puedeQuedarSeleccionado(hermione, gryffindor).

%% Punto 4

esAmistoso(Mago):-
    caracteristicaMago(Mago, amistad).

todosAmistosos(Magos):-
    forall(member(Mago, Magos), esAmistoso(Mago)).

cadenaDeCasas([_]).
cadenaDeCasas([]).
cadenaDeCasas([Mago1,Mago2|Magos]):-
    puedeQuedarSeleccionado(Mago1,Casa),
    puedeQuedarSeleccionado(Mago2,Casa),
    cadenaDeCasas([Mago2|Magos]).

cadenaDeAmistades(Magos):-
    todosAmistosos(Magos),
    cadenaDeCasas(Magos).
