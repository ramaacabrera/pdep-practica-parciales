%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parte 2 - La copa de las casas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

esDe(hermione, gryffindor). 
esDe(ron, gryffindor). 
esDe(harry, gryffindor). 
esDe(draco, slytherin). 
esDe(luna, ravenclaw).

mago(Mago):-
    esDe(Mago,_).

%% Punto 1

esAccion(Accion):-
    accion(_,Accion).

accion(harry, andarFueraDeCama).
accion(harry, estuvoEn(tercerPiso)).
accion(harry, estuvoEn(elBosque)).
accion(harry, buenaAccion(leGanoAVoldemort, 60)).
accion(hermione, estuvoEn(tercerPiso)).
accion(hermione, estuvoEn(seccionRestringida)).
accion(hermione, buenaAccion(salvoASusAmigos, 50)).
accion(ron, buenaAccion(ganoPartidaAjedrez, 50)).
accion(draco, estuvoEn(lasMazmorras)).
accion(hermione, respondioPregunta(dondeSeEncuentrBezoar, 20, snape)).
accion(hermione, respondioPregunta(comoHacerLevitarPluma, 25 , flitwick)).

hizoMalasAcciones(Mago):-
    accion(Mago, AccionQueCometio),
    puntajeQueDa(AccionQueCometio,Puntaje),
    Puntaje < 0.

puntajeQueDa(estuvoEn(tercerPiso), -75).
puntajeQueDa(estuvoEn(elBosque), -50).
puntajeQueDa(estuvoEn(seccionRestringida), -10).
puntajeQueDa(andarFueraDeCama, -50).
puntajeQueDa(buenaAccion(_,Puntaje),Puntaje).
puntajeQueDa(respondioPregunta(_,Dificultad, snape), Puntaje) :-
    Puntaje is Dificultad // 2.
puntajeQueDa(respondioPregunta(_,Puntaje, Profesor), Puntaje) :-
    Profesor \= snape.

esBuenAlumno(Mago):-
    accion(Mago, _),
    not(hizoMalasAcciones(Mago)).

%% 1b)

accionRecurrente(Accion):-
    esAccion(Accion),
    accion(Mago,Accion),
    accion(OtroMago,Accion),
    Mago \= OtroMago.

%% Punto 2

puntajeCasaTotal(Casa, PuntajeTotal) :-
    esDe(_,Casa),
    findall(Puntaje, (esDe(Mago, Casa), puntosQueObtuvo(Mago,Puntaje)), ListaPuntajes),
    sumlist(ListaPuntajes, PuntajeTotal).

puntosQueObtuvo(Mago, Puntaje) :-
    accion(Mago,Accion), 
    puntajeQueDa(Accion, Puntaje).

%% Punto 3

casaGanadora(CasaGanadora) :-
    esDe(_,CasaGanadora),
    forall((esDe(_,OtraCasa), OtraCasa \= CasaGanadora), tieneMasPuntos(CasaGanadora,OtraCasa)).

tieneMasPuntos(UnaCasa, OtraCasa) :-
    puntajeCasaTotal(UnaCasa, PuntajeUnaCasa),
    puntajeCasaTotal(OtraCasa, PuntajeOtraCasa),
    PuntajeUnaCasa > PuntajeOtraCasa.
    
%% Punto 4



