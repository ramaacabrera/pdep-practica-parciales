%%%%%%%%%%%%%%%%%%%%%%%%
%% Base de Conocimientos
%%%%%%%%%%%%%%%%%%%%%%%%

% festival(NombreDelFestival, Bandas, Lugar).
% Relaciona el nombre de un festival con la lista de los nombres de bandas que tocan en él y el lugar dónde se realiza.
festival(lollapalooza, [gunsAndRoses, theStrokes, ...., littoNebbia], hipodromoSanIsidro).


% lugar(nombre, capacidad, precioBase).
% Relaciona un lugar con su capacidad y el precio base que se cobran las entradas ahí.
lugar(hipodromoSanIsidro, 85000, 3000).


% banda(nombre, nacionalidad, popularidad).
% Relaciona una banda con su nacionalidad y su popularidad.
banda(gunsAndRoses, eeuu, 69420).


% entradaVendida(NombreDelFestival, TipoDeEntrada).
% Indica la venta de una entrada de cierto tipo para el festival
% indicado.
% Los tipos de entrada pueden ser alguno de los siguientes:
% - campo
% - plateaNumerada(Fila)
% - plateaGeneral(Zona).
entradaVendida(lollapalooza, campo).
entradaVendida(lollapalooza, plateaNumerada(1)).
entradaVendida(lollapalooza, plateaGeneral(zona2)).


% plusZona(Lugar, Zona, Recargo)
% Relacion una zona de un lugar con el recargo que le aplica al precio de las plateas generales.
plusZona(hipodromoSanIsidro, zona1, 1500).

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Resolucion de los Puntos
%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Punto 1

itinerante(Festival):-
    festival(Festival, Bandas, Lugar),
    festival(Festival, Bandas, OtroLugar),
    Lugar \= OtroLugar.

%% Punto 2

tieneCampo(Festival):-
    entradaVendida(Festival,campo).

careta(personalFest).
careta(Festival):-
    festival(Festival,_,_),
    not(tieneCampo(Festival)).


%% Punto 3

bandaArgentinaPopular(Banda):-
    banda(Banda, argentina, Popularidad),
    Popularidad > 1000.

nacAndPop(Festival):-
    festival(Festival, ListaBandas, _),
    not(careta(Festival)),
    forall(member(Banda,ListaBandas), bandaArgentinaPopular(Banda)).

%% Punto 4

sobrevendido(Festival):-
    festival(Festival,_,Lugar),
    lugar(Lugar,Capacidad,_),
    findall(Entrada, entradaVendida(Festival,Entrada), ListaEntradas),
    length(ListaEntradas, CantidadEntradasVendidas),
    CantidadEntradasVendidas > Capacidad.

%% Punto 5

precioEntrada(campo,Lugar,PrecioEntrada):-
    lugar(Lugar,_,PrecioEntrada).

precioEntrada(plateaGeneral(Zona),Lugar, PrecioEntrada):-
    lugar(Lugar, _, PrecioBase),
    plusZona(Lugar, Zona, Recargo),
    PrecioEntrada is PrecioBase + Recargo.

aumentoPorFila(Fila, 3):-
    Fila > 10.
aumentoPorFila(Fila, 6):-
    Fila =< 10.

precioEntrada(plateaNumerada(Fila), Lugar, PrecioEntrada) :-
    lugar(Lugar, _, PrecioBase),
    aumentoPorFila(Fila, Aumento),
    PrecioEntrada is Aumento * PrecioBase.

recaudacionTotal(Festival, TotalRecaudado):-
    festival(Festival, _, Lugar),
    findall(PrecioEntrada, (entradaVendida(Festival, Entrada), precioEntrada(Entrada,Lugar,PrecioEntrada)), ListaPrecios),
    sumlist(ListaPrecios, TotalRecaudado).

%% Punto 6

tocoCon(UnaBanda, OtraBanda):-
    festival(_, Bandas, _),
    member(UnaBanda, Bandas),
    member(OtraBanda, Bandas),
    UnaBanda \= OtraBanda.

delMismoPalo(UnaBanda, OtraBanda):-
    tocoCon(UnaBanda, OtraBanda).

delMismoPalo(UnaBanda, OtraBanda):-
    tocoCon(UnaBanda,UnaTerceraBanda),
    banda(UnaTerceraBanda, _, PopularidadTerceraBanda),
    banda(OtraBanda, _, PopularidadOtraBanda),
    PopularidadTerceraBanda > PopularidadOtraBanda,
    delMismoPalo(OtraBanda, UnaTerceraBanda).
