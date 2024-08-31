% Punto 1

% atiende(Nombre, Día, HoraInicio, HoraFin).

atiende(dodain, lunes, 9, 15).
atiende(dodain, miércoles, 9, 15).
atiende(dodain, viernes, 9, 15).

atiende(lucas, martes, 10, 20).

atiende(juanC, sábados, 18, 22).
atiende(juanC, domingos, 18, 22).

atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).

atiende(leoC, lunes, 14, 18).
atiende(leoC, miércoles, 14, 18).

atiende(martu, miércoles, 23, 24).

atiende(vale, Dia, HorarioEntrada, HorarioSalida):-
    atiende(dodain, Dia, HorarioEntrada, HorarioSalida).
atiende(vale, Dia, HorarioEntrada, HorarioSalida):-
    atiende(juanC, Dia, HorarioEntrada, HorarioSalida).


% Punto 2

quienAtiende(Persona, Dia, Hora):-
    atiende(Persona, Dia, HorarioEntrada, HorarioSalida),
    between(HorarioEntrada, HorarioSalida, Hora).
    