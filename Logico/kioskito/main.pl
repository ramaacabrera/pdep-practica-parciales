% Punto 1

% atiende(Nombre, Día, HoraInicio, HoraFin).

atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).

atiende(lucas, martes, 10, 20).

atiende(juanC, sebados, 18, 22).
atiende(juanC, domingos, 18, 22).

atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).

atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).

atiende(martu, miercoles, 23, 24).

atiende(vale, Dia, HorarioEntrada, HorarioSalida):-
    atiende(dodain, Dia, HorarioEntrada, HorarioSalida).
atiende(vale, Dia, HorarioEntrada, HorarioSalida):-
    atiende(juanC, Dia, HorarioEntrada, HorarioSalida).


% Punto 2

quienAtiende(Persona, Dia, Hora):-
    atiende(Persona, Dia, HorarioEntrada, HorarioSalida),
    between(HorarioEntrada, HorarioSalida, Hora).

% Punto 3

atiendeSolo(Persona, Dia, Hora):-
    quienAtiende(Persona, Dia, Hora),
    not((quienAtiende(OtraPersona, Dia, Hora), Persona \= OtraPersona)).

% Punto 4

% no tengo idea de como hacer este

% Punto 5 
vendio(dodain, fecha(10, 8), [golosinas(1200), cigarrillos([jockey]), golosinas(50)]).
vendio(dodain, fecha(12, 8), [bebidas(alcoholicas, 8), bebidas(noAlcoholicas, 1), golosinas(10)]).
vendio(martu, fecha(12, 8), [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
vendio(lucas, fecha(11, 8), [golosinas(600)]).
vendio(lucas, fecha(18,8), [bebidas(noAlcoholicas, 2), cigarrillos([derby])]).

esImportante(golosinas(Total)):-
    Total>100.
esImportante(cigarrillos(Marcas)):-
    length(Marcas, CantidadMarcas),
    CantidadMarcas > 2.
esImportante(bebidas(alcoholicas, _)).
esImportante(bebidas(_, Cantidad)):-
    Cantidad > 5.

primeraVentaImportante(Persona, Dia):-
    vendio(Persona, Dia, [PrimerVenta | _]),
    esImportante(PrimerVenta).

suertuda(Persona):-
    vendio(Persona, _, _),
    forall(vendio(Persona, Dia, _), primeraVentaImportante(Persona, Dia)).
