%integrante(Grupo, Persona, Instrumento).
integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

%nivelQueTiene(Persona, Instrumento, nivel).
nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

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

% PUNTO 1
tieneBuenaBase(Grupo):-
    integrante(Grupo, _, Instrumento1),
    instrumento(Instrumento1, ritmico),
    integrante(Grupo, _, Instrumento2),
    instrumento(Instrumento2, armonico).

% PUNTO 2
seDestaca(Persona, Grupo):-
    integrante(Grupo, Persona, Instrumento),
    nivelQueTiene(Persona, Instrumento, Nivel),
    forall((integrante(Grupo, Integrantes, Instrumentos), Integrantes \= Persona), (nivelQueTiene(Integrantes, Instrumentos, Niveles), (Nivel - Niveles) >= 2)).

% PUNTO 3
grupo(vientosDelEste, bigBand).
grupo(sophieTrio, particular([contrabajo, guitarra, violin])).
grupo(jazzmin, particular([bateria, bajo, trompeta, piano, guitarra])).
grupo(estudio1, ensamble(3)).  % punto 8)

% PUNTO 4
hayCupo(Instrumento, Grupo):-
    grupo(Grupo, bigBand),
    instrumento(Instrumento, melodico(viento)).
hayCupo(Instrumento, Grupo):-
    instrumento(Instrumento, _),
    grupo(Grupo, TipoGrupo),
    not(integrante(Grupo, _, Instrumento)),
    sirve(Instrumento, TipoGrupo).

sirve(Instrumento, particular(InstrumentosReq)):-
    member(InstrumentosReq, Instrumento).
sirve(Instrumento, bigBand):-
    member([bateria, bajo, piano], Instrumento).
sirve(Instrumento, ensamble(_)).

% PUNTO 5
puedeIncorporarse(Grupo, Persona, Instrumento):-
    not(integrante(Grupo, Persona, _)),
    hayCupo(Instrumento, Grupo),
    grupo(Grupo, TipoGrupo),
    nivelQueTiene(Persona, Instrumento, Nivel),
    nivelEsperado(Nivel, TipoGrupo).

nivelEsperado(Nivel, bigBand):-
    Nivel >= 1.
nivelEsperado(Nivel, particular(InstrumentosReq)):-
    length(InstrumentosReq, Cant),
    Nivel >= 7 - Cant.
nivelEsperado(Nivel, ensamble(NivelEnsamble)):-
    Nivel >= NivelEnsamble.

% PUNTO 6
seQuedoEnBanda(Persona):-
    nivelQueTiene(Persona, Instrumento, _),
    not(integrante(_, Persona, _)),
    not(puedeIncorporarse(_, Persona, Instrumento)).

% PUNTO 7
puedeTocar(Grupo):-
    grupo(Grupo, TipoGrupo),
    cubrirNecesidades(Grupo, TipoGrupo).

cubrirNecesidades(Grupo, bigBand):-
    tieneBuenaBase(Grupo),
    findall(Integrante, (integrante(Grupo, Integrante, Instrumento), instrumento(Instrumento, melodico(viento))), Integrantes),
    length(Integrantes, Cantidad),
    Cantidad >= 5.
cubrirNecesidades(Grupo, particular(InstrumentosReq)):-
    forall(member(InstrumentosReq, Instrumento), integrante(Grupo, _, Instrumento)).
cubrirNecesidades(Grupo, ensamble(_)):-
    tieneBuenaBase(Grupo),
    integrante(Grupo, _, Instrumento),
    instrumento(Instrumento, melodico(_)).

% PUNTO 8
% ENSAMBLES (sirve, nivelEsperado, cubrirNecesidades)

