vocaloid(megurineLuka, nightFever, 4).
vocaloid(megurineLuka, foreverYoung, 5).
vocaloid(hatsuneMiku, tellYourWorld, 4).
vocaloid(gumi, foreverYoung, 4).
vocaloid(gumi, tellYourWorld, 5).
vocaloid(seeU, novemberRain, 6).
vocaloid(seeU, nightFever, 5).

cantante(megurineLuka).
cantante(hatsuneMiku).
cantante(gumi).
cantante(seeU).
cantante(kaito).

% Punto 1: cantante novedoso, saben al menos 2 canciones y el tiempo total de las canciones debe ser menor a 15
vocaloidNovedoso(Vocaloid):-
    masDeUnaCancion(Vocaloid),
    tiempoTotal(Vocaloid, TiempoTotal),
    TiempoTotal < 15.

tiempoTotal(Vocaloid, TiempoTotal):-
    findall(Tiempo, (vocaloid(Vocaloid, _, Tiempo)), Tiempos),
    sum_list(Tiempos, TiempoTotal).

masDeUnaCancion(Vocaloid):-
    vocaloid(Vocaloid, Cancion1, _),
    vocaloid(Vocaloid, Cancion2, _),
    Cancion1 \= Cancion2.

% Punto 2: todas sus canciones duran 4 min o menos
% no existe cancion del cantante que dure mas de 4 min
vocaloidAcelerado(Vocaloid):-
    cantante(Vocaloid),
    not((vocaloid(Vocaloid, _, Tiempo), Tiempo > 4)).

% CONCIERTOS
% gigante(cantCanciones, tiempo minimo de duracion de canciones)
% mediano(tiempo maximo de duracion de canciones)
% peque(tiempo minimo de una cancion por lo menos)

%concierto(nombre, pais, fama, tipo).
concierto(mikuExpo, usa, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, usa, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, peque(4)).
concierto(miku, argentina, 100, peque(1000)).

nombreConcierto(mikuExpo).
nombreConcierto(magicalMirai).
nombreConcierto(vocalektVisions).
nombreConcierto(mikuFest).
nombreConcierto(miku).

% Punto 2: Puede participar en un concierto si cumple con el requisito del tipo de concierto
%puedeParticipar(hatsuneMiku, _).
puedeParticipar(hatsuneMiku, Concierto):-
    nombreConcierto(Concierto).
puedeParticipar(Vocaloid, Concierto):-
    cantante(Vocaloid),
    Vocaloid \= hatsuneMiku,
    concierto(Concierto, _, _, Tipo),
    cumpleTipo(Vocaloid, Tipo).

cumpleTipo(Vocaloid, gigante(Cant, TiempoMinimo)):-
    cantidadCancionesMinimas(Cant, Vocaloid),
    tiempoMinimosCanciones(Vocaloid, TiempoMinimo).
cumpleTipo(Vocaloid, mediano(TiempoMaximo)):-
    tiempoTotal(Vocaloid, TiempoTotal),
    TiempoTotal < TiempoMaximo.
cumpleTipo(Vocaloid, peque(TiempoMinimo)):-
    vocaloid(Vocaloid, _, Tiempo),
    Tiempo > TiempoMinimo.

tiempoMinimosCanciones(Vocaloid, TiempoMinimo):-
    forall(vocaloid(Vocaloid, _, Tiempo), Tiempo >= TiempoMinimo).

cantidadCancionesMinimas(Cant, Vocaloid):-
    cantidadDeCanciones(Vocaloid, Cantidad),
    Cantidad >= Cant.

% Punto 3: vocaloid famosa, es la que tenga el mayor nivel de fama
% nivel de fama: suma de los puntos que le dan los conciertos en donde puede participar * la cantidad de canciones que tiene
vocaloidFamosa(Vocaloid):-
    nivelFama(Vocaloid, Nivel),
    forall(cantante(Cantantes), (nivelFama(Cantantes, Niveles), Nivel >= Niveles)).

nivelFama(Vocaloid, Nivel):-
    cantante(Vocaloid),
    puntosConciertos(Vocaloid, Puntos),
    cantidadDeCanciones(Vocaloid, Cant),
    Nivel is Puntos * Cant.

puntosConciertos(Vocaloid, Puntos):-
    findall(Punto, (puedeParticipar(Vocaloid, Concierto), concierto(Concierto, _, Punto, _)), Puntajes),
    sum_list(Puntajes, Puntos).

cantidadDeCanciones(Vocaloid, Cantidad):-
    findall(Cancion, vocaloid(Vocaloid, Cancion, _), Canciones),
    length(Canciones, Cantidad).

% Punto 4
conoceA(megurineLuka, hatsuneMiku).
conoceA(hatsuneMiku, gumi).
conoceA(megurineLuka, gumi).
conoceA(gumi, seeU).
conoceA(seeU, kaito).

contactoDirectoIndirecto(Persona, Conocido):-
    conoceA(Persona, Conocido).
contactoDirectoIndirecto(Persona, Conocido):-
    conoceA(ConocidoIntermedio, Conocido),
    contactoDirectoIndirecto(Persona, ConocidoIntermedio).

% un vocaloid es el unico q participa en un concierto si ninguno de sus conocidos participa en el concierto
% no existe conocido que pueda participar en este concierto
vocaloidSolo(Vocaloid, Concierto):-
    puedeParticipar(Vocaloid, Concierto),
    not((contactoDirectoIndirecto(Vocaloid, Conocido), puedeParticipar(Conocido, Concierto))).

% Punto 5: si queremos agregar un nuevo tipo de conciero, que tendriamos que agregar al codigo? que conceptos explicarian esta modificacion?

% Tendriamos que agregar otra condicion mas en el prdicado cumpleTipo/2. Y usariamos el concepto de polimorfismo.