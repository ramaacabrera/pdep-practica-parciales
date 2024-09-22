% Base de Conocimientos

%tarea(agente, tarea, ubicacion)
%tareas:
% ingerir(descripcion, tamaño, cantidad)
% apresar(malviviente, recompensa)
% asuntosInternos(agenteInvestigado)
% vigilar(listaDeNegocios)

tarea(vigilanteDelBarrio, ingerir(pizza, 1.5, 2), laBoca).
tarea(vigilanteDelBarrio, vigilar([pizzeria, heladeria]), barracas).
tarea(canaBoton, asuntosInternos(vigilanteDelBarrio), barracas).
tarea(sargentoGarcia, vigilar([pulperia, haciendaDeLaVega, plaza]), puebloDeLosAngeles).
tarea(sargentoGarcia, ingerir(vino, 0.5, 5), puebloDeLosAngeles).
tarea(sargentoGarcia, apresar(elzorro, 100), puebloDeLosAngeles).
tarea(vega, apresar(neneCarrizo,50),avellaneda).
tarea(jefeSupremo, vigilar([congreso,casaRosada,tribunales]), laBoca).

ubicacion(puebloDeLosAngeles).
ubicacion(avellaneda).
ubicacion(barracas).
ubicacion(marDelPlata).
ubicacion(laBoca).
ubicacion(uqbar).

%jefe(jefe, subordinado)
jefe(jefeSupremo, vega).
jefe(vega, vigilanteDelBarrio).
jefe(vega, canaBoton).
jefe(jefeSupremo,sargentoGarcia).


% Punto 1

agente(Agente):-
    tarea(Agente, _, _).

frecuenta(Agente, buenosAires):-
    agente(Agente).
frecuenta(vega, quilmes).
frecuenta(Agente, marDelPlata):-
    tarea(Agente, vigilar(Ubicaciones), _),
    member(negocioAlfajores, Ubicaciones).
frecuenta(Agente, UbicacionFrecuente):-
    tarea(Agente, _, UbicacionFrecuente).

% Punto 2

inaccesible(Ubicacion):-
    ubicacion(Ubicacion),
    not(frecuenta(_, Ubicacion)).

% Punto 3

afincado(Agente):-
    tarea(Agente, _, Ubicacion),
    not((tarea(Agente, _, OtraUbicacion), OtraUbicacion \= Ubicacion)).

% Punto 4

cadenaDeMando([_]).
cadenaDeMando([PrimerAgente | [SegundoAgente | RestoAgentes]]):-
    agente(PrimerAgente),
    agente(SegundoAgente),
    jefe(PrimerAgente, SegundoAgente),
    cadenaDeMando([SegundoAgente | RestoAgentes]).

% Punto 5

puntuacionTarea(vigilar(Lugares), Puntos):-
    length(Lugares, CantidadLugares),
    Puntos is 5 * CantidadLugares.

puntuacionTarea(ingerir(_, Tamano, Cantidad), Puntos):-
    UnidadesIngeridas is Tamano * Cantidad,
    Puntos is -10 * UnidadesIngeridas.

puntuacionTarea(apresar(_, Recompensa), Puntos):-
    Puntos is Recompensa // 2.

puntuacionTarea(asuntosInternos(AgenteInvestigado), Puntos):-
    puntuacionTotal(AgenteInvestigado, PuntuacionAgenteInvestigado),
    Puntos is 2 * PuntuacionAgenteInvestigado.

puntuacionTotal(Agente, PuntuacionTotal):-
    findall(Puntuacion, (tarea(Agente, Tarea, _), puntuacionTarea(Tarea, Puntuacion)), Puntuaciones),
    sumlist(Puntuaciones, PuntuacionTotal).
    

tieneMasPuntos(UnAgente, OtroAgente):-
    puntuacionTotal(UnAgente, PuntuacionDeUno),
    puntuacionTotal(OtroAgente, PuntuacionDeOtro),
    PuntuacionDeUno > PuntuacionDeOtro.

agentePremiado(Agente):-
    agente(Agente),
    forall((agente(OtroAgente), OtroAgente \= Agente), tieneMasPuntos(Agente, OtroAgente)).