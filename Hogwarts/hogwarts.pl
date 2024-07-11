sangre(harry, mestiza).
caracteristica(harry, corajudo).
caracteristica(harry, amistoso).
caracteristica(harry, orgulloso).
caracteristica(harry, inteligente).
casaOdiada(harry, slytherin).

sangre(draco, pura).
caracteristica(draco, inteligente).
caracteristica(draco, orgulloso).
casaOdiada(draco, hufflepuff).

sangre(hermione, impura).
caracteristica(hermione, inteligente).
caracteristica(hermione, orgulloso).
caracteristica(hermione, responsable).

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).

preferenciaSombrero(gryffindor, corajudo).
preferenciaSombrero(slytherin, orgulloso).
preferenciaSombrero(slytherin, inteligente).
preferenciaSombrero(ravenclaw, inteligente).
preferenciaSombrero(ravenclaw, responsable).
preferenciaSombrero(hufflepuff, amistoso).

permiteEntrarACasa(Mago, Casa):-
    sangre(Mago, _),
    casa(Casa),
    not((sangre(Mago, impura), Casa = slytherin)).

preferenciaApropiada(Mago, Casa):-
    caracteristica(Mago, Caracteristica),
    preferenciaSombrero(Casa, Caracteristica).

% en que casa podria quedar seleccioando
casaSeleccionada(Mago, Casa):-
    caracterAdecuado(Mago, Casa),
    permiteEntrarACasa(Mago, Casa),
    not(casaOdiada(Mago, Casa)).

caracterAdecuado(hermione, gryffindor).
caracterAdecuado(Mago, Casa):- preferenciaApropiada(Mago, Casa).

cadenaDeAmistades(ListaMagos):-
    todosAmistosos(ListaMagos),
    mismaCasaQueElSiguiente(ListaMagos).

todosAmistosos(ListaMagos):-
    forall(member(Mago, ListaMagos), caracteristica(Mago, amistoso)).

mismaCasaQueElSiguiente([_]).
mismaCasaQueElSiguiente([Mago1, Mago2 | ListaMagos]):-
    casaSeleccionada(Mago1, Casa),
    casaSeleccionada(Mago2, Casa),
    mismaCasaQueElSiguiente([Mago2 | ListaMagos]).

% PARTE 2

accion(harry, andarDeNoche).
accion(hermione, irLugarALugarProhibido(tercerPiso)).
accion(hermione, irLugarALugarProhibido(biblioteca)).
accion(harry, irLugarALugarProhibido(tercerPiso)).
accion(harry, irLugarALugarProhibido(bosque)).
accion(draco, irLugarALugar(mazmorras)).
accion(ron, ganarAjedrez).
accion(hermione, usarIntelecto).
accion(harry, ganarAVoldemort).

puntaje(andarDeNoche, -50).
puntaje(irLugarALugarProhibido(tercerPiso), -75).
puntaje(irLugarALugarProhibido(biblioteca), -10).
puntaje(irLugarALugarProhibido(bosque), -50).
puntaje(irLugarALugar(_), 0).
puntaje(ganarAjedrez, 50).
puntaje(usarIntelecto, 50).
puntaje(ganarAVoldemort, 60).


% esDe(Mago, Casa).
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% Punto 1-a): buen alumno, hizo alguna accion y ninguna es mala
buenAlumno(Mago):-
    accion(Mago, _),
    forall(accion(Mago, Accion), (puntaje(Accion, Puntos), Puntos >= 0)).

% Punto 1-b): accion recurrente, mas de un mago hizo esa accion
accionRecurrente(Accion):-
    accion(Mago1, Accion),
    accion(Mago2, Accion),
    Mago1 \= Mago2.

% Punto 2: Puntaje total de los miembros de una casa
puntajeCasa(Casa, Puntaje):-
    findall(Punto, (esDe(Mago, Casa), puntajeMiembro(Mago, Punto)), Puntos),
    sum_list(Puntos, Puntaje).

puntajeMiembro(Mago, Puntaje):-
    findall(Punto, (accion(Mago, Accion), puntaje(Accion, Punto)), Puntos),
    sum_list(Puntos, Puntaje).

% Punto 4: Casa ganadora
casaGanadora(Casa):-
    casa(Casa),
    puntajeCasa(Casa, Puntaje),
    forall(casa(Casas), (puntajeCasa(Casas, Puntajes), Puntaje >= Puntajes)).

% Punto 5: Preguntas y Respuestas
accion(hermione, respuesta(ubicacionBezoar, 20, snape)).
accion(hermione, respuesta(levitarPluma, 25, flitwick)).

puntaje(respuesta(_, Dificultad, snape), Puntaje):- Puntaje is Dificultad / 2.
puntaje(respuesta(_, Dificultad, Profesor), Dificultad):- Profesor \= snape.