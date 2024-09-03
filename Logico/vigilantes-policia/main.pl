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
    