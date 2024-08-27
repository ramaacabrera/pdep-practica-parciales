% Base de conocimientos

% Integrantes de las grupos y el instrumento que tocan en esa grupo
integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

% Nivel de habilidad de los músicos para improvisar con sus instrumentos
nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

% Tipo de instrumentos y su rol que cumple al tocarse en su grupo
instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

persona(Persona):-
    nivelQueTiene(Persona, _, _).

% Punto 1
/* 
    Entiendo que los integrantes que toquen cada instrumento deben ser distintos debido a que si es la
    misma persona no podria tocar a la vez ambos instrumentos, con lo cual, no tendrian buena base. 
*/
tieneBuenaBase(Grupo):-
    integrante(Grupo, UnIntegrante, UnInstrumento),
    integrante(Grupo, OtroIntegrante, OtroInstrumento),
    UnIntegrante \= OtroIntegrante,
    instrumento(UnInstrumento, ritmico),
    instrumento(OtroInstrumento, armonico).

% Punto 2
nivelInstrumentoQueUsaEnGrupo(Integrante, Grupo, Nivel):-
    integrante(Grupo, Integrante, Instrumento),
    nivelQueTiene(Integrante, Instrumento, Nivel).

diferencia(UnNumero, OtroNumero, Diferencia):-
    Diferencia is UnNumero - OtroNumero.

seDestaca(Integrante, Grupo):-
    nivelInstrumentoQueUsaEnGrupo(Integrante, Grupo, Nivel),
    forall((nivelInstrumentoQueUsaEnGrupo(OtroIntegrante, Grupo, OtroNivel), OtroIntegrante \= Integrante), (diferencia(Nivel, OtroNivel, Diferencia), Diferencia >= 2)).

% Punto 3

grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacionParticular([contrabajo, guitarra, violin])).
grupo(jazzmin, formacionParticular([bateria, bajo, trompeta, piano, guitarra])).
grupo(estudio1, ensamble(3)).

% Punto 4

hayInstrumentoEnElGrupo(Instrumento, Grupo):-
    integrante(Grupo, _, Instrumento).

sirveParaTipoDeGrupo(Instrumento, formacionParticular(Formacion)):-
    member(Instrumento, Formacion).

sirveParaTipoDeGrupo(bateria, bigBand).
sirveParaTipoDeGrupo(bajo, bigBand).
sirveParaTipoDeGrupo(piano, bigBand).

% Agregado del 'ensamble' del punto 8 
% ---
sirveParaTipoDeGrupo(_, ensamble(_)).
% ---

hayCupo(Instrumento, Grupo):-
    grupo(Grupo, bigBand),
    instrumento(Instrumento, melodico(viento)).

hayCupo(Instrumento, Grupo):-
    grupo(Grupo, TipoDeGrupo),
    instrumento(Instrumento, _),
    not(hayInstrumentoEnElGrupo(Instrumento, Grupo)),
    sirveParaTipoDeGrupo(Instrumento, TipoDeGrupo).


% Punto 5

nivelEsperado(bigBand, 1).
nivelEsperado(formacionParticular(Formacion), NivelEsperado):-
    length(Formacion, CantidadInstrumentos),
    NivelEsperado is 7 - CantidadInstrumentos.

% Agregado del 'ensamble' del punto 8 
% ---
nivelEsperado(ensamble(NivelEsperado), NivelEsperado).
% ---

puedeIncorporarse(Persona, Instrumento, Grupo):-
    persona(Persona),
    hayCupo(Instrumento, Grupo),
    not(integrante(Grupo, Persona, _)),
    nivelQueTiene(Persona, Instrumento, NivelQueTiene),
    grupo(Grupo, TipoDeGrupo),
    nivelEsperado(TipoDeGrupo, NivelEsperado),
    NivelQueTiene >= NivelEsperado.

% Punto 6

seQuedoEnBanda(Persona):-
    persona(Persona),
    not(integrante(_, Persona, _)),
    not(puedeIncorporarse(Persona, _, _)).

% Punto 7

cubrenNecesidadesMinimas(Grupo, bigBand):-
    tieneBuenaBase(Grupo),
    findall(Integrante, (integrante(Grupo, Integrante, Instrumento), instrumento(Instrumento, melodico(viento))), Integrantes),
    length(Integrantes, CantidadIntegrantes),
    CantidadIntegrantes >= 5.

cubrenNecesidadesMinimas(Grupo, formacionParticular(Formacion)):-
    forall(member(Instrumento, Formacion), hayInstrumentoEnElGrupo(Instrumento, Grupo)).

% Agregado del 'ensamble' del punto 8 
% ---
cubrenNecesidadesMinimas(Grupo, ensamble(_)):-
    tieneBuenaBase(Grupo),
    integrante(Grupo, _, Instrumento),
    instrumento(Instrumento, melodico(_)).
% ---

puedeTocar(Grupo):-
    grupo(Grupo, TipoDeGrupo),
    cubrenNecesidadesMinimas(Grupo, TipoDeGrupo).


