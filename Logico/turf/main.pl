% Punto 1

jockey(valdivieso, 155, 52).
jockey(leguisamo, 161, 49).
jockey(lezcano, 149, 50).
jockey(baratucci, 153, 55).
jockey(falero, 157, 52).

leGusta(botafogo, Jockey):-
    jockey(Jockey, _, Peso),
    Peso < 52.
leGusta(botafogo, baratucci).

leGusta(oldMan, Jockey):-
    jockey(Jockey, _, _),
    atom_length(Jockey, CantidadLetras),
    CantidadLetras > 7.

leGusta(energica, Jockey):-
    jockey(Jockey, _, _),
    not(leGusta(botafogo, Jockey)).

leGusta(matBoy, Jockey):-
    jockey(Jockey, Altura, _),
    Altura > 170.

caballeriza(valdivieso, elTute).
caballeriza(falero, elTute).
caballeriza(lezcano, lasHormigas).
caballeriza(baratucci, elCharabon).
caballeriza(leguisamo, elCharabon).

caballo(botafogo).
caballo(oldMan).
caballo(energica).
caballo(matBoy).
caballo(yatasto).

gano(botafogo, granPremioNacional).
gano(botafogo, granPremioRepublica).
gano(oldMan, granPremioNacional).
gano(oldMan, campeonatoPalermoOro).
gano(matBoy, granPremioCriadores).

% Punto 2

prefiereMasDeUno(Caballo):-
    leGusta(Caballo, Jockey),
    leGusta(Caballo, OtroJockey),
    Jockey \= OtroJockey.

% Punto 3

ningunJockey(Caballo, Caballeriza):-
    caballo(Caballo),
    caballeriza(_, Caballeriza),
    forall(caballeriza(Jockey, Caballeriza), not(leGusta(Caballo, Jockey))).