creencia(gabriel, campanita).
creencia(gabriel, magoDeOz).
creencia(gabriel, cavenaghi).
creencia(juan, conejoPascua).
creencia(macarena, reyes).
creencia(macarena, magoCapria).
creencia(macarena, campanita).

suenios(gabriel, ganarLoteria([5,9])).
suenios(gabriel, futbolista(arsenal)).
suenios(juan, cantante(100000)).
suenios(macarena, cantante(10000)).

persona(Persona):- suenios(Persona, _).

personaje(Personaje):- creencia(_, Personaje).

/*
    Para la base de conocimiento utilice functores, y el concepto de universo cerrado, ya que en el caso de diego dice que no tiene suenios
    Entonces no lo coloque, lo mismo con el estilo de macarena.
*/

% Punto 2: la suma de sus puntos de dificultad tiene q ser mayor a 20
dificultadSuenio(cantante(Discos), Dificultad):- cantidadDiscos(Discos, Dificultad).
cantidadDiscos(Discos, Dificultad):-
    Discos > 500000,
    Dificultad is 6.
cantidadDiscos(_, Dificultad):-
    Dificultad is 4.

dificultadSuenio(ganarLoteria(ListaNumeros), Dificultad):- length(ListaNumeros, Longitud), Dificultad is 10 * Longitud.

dificultadSuenio(futbolista(arsenal), 3).
dificultadSuenio(futbolista(aldosivi), 3).
dificultadSuenio(futbolista(_), 16).

personaAmbiciosa(Persona):-
    suenios(Persona, _),
    findall(Dificultad, (suenios(Persona, Suenio), dificultadSuenio(Suenio, Dificultad)), Dificultades),
    sum_list(Dificultades, Suma),
    Suma > 20.

% Punto 3: quimica entre personaje y persona
% - si la persona cree en el personaje
% - para Campanita, la persona debe tener al menos un sueño de dificultad menor a 5.
% - para el resto: todos los sueños deben ser puros (ser futbolista o cantante de menos de 200.000 discos) y la persona no debe ser ambiciosa

quimica(Personaje, Persona):-
    creencia(Persona, Personaje),
    condicionQuimica(Personaje, Persona).

condicionQuimica(campanita, Persona):-
    suenios(Persona, Suenio),
    dificultadSuenio(Suenio, Dificultad),
    Dificultad < 5.
condicionQuimica(Personaje, Persona):-
    not(esCampanita(Personaje)),
    sueniosPuros(Persona),
    not(personaAmbiciosa(Persona)).

esCampanita(campanita).

sueniosPuros(Persona):-
    suenios(Persona, _),
    forall(suenios(Persona, Suenio), condicionSuenioPuro(Suenio)).

condicionSuenioPuro(futbolista(_)).
condicionSuenioPuro(cantante(Discos)):- Discos < 200000.

% Punto 4: un personaje puede alegrar a una persona
amistad(campanita, reyes).
amistad(campanita, conejoPascua).
amistad(conejoPascua, cavenaghi).

amigoDirectoIndirecto(Personaje, Amigo):-
    amistad(Personaje, Amigo).
amigoDirectoIndirecto(Personaje, Amigo):-
    amistad(AmigoIntermedio, Amigo),
    amigoDirectoIndirecto(Personaje, AmigoIntermedio).

personajePuedeAlegrarA(Personaje, Persona):-
    suenios(Persona, _),
    quimica(Personaje, Persona),
    algunoNoEstaEnfermo(Personaje).

algunoNoEstaEnfermo(Personaje):- not(estaEnfermo(Personaje)).
algunoNoEstaEnfermo(Personaje):- amigoDirectoIndirecto(Personaje, Amigo), not(estaEnfermo(Amigo)).

estaEnfermo(campanita).
estaEnfermo(reyes).
estaEnfermo(conejoPascua).
