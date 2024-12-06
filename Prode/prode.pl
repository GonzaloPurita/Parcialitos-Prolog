%resultado(UnPais, GolesDeUnPais, OtroPais, GolesDeOtroPais)
resultado(paises_bajos, 3, estados_unidos, 1). % Paises bajos 3 - 1 Estados unidos
resultado(australia, 1, argentina, 2). % Australia 1 - 2 Argentina
resultado(polonia, 3, francia, 1).
resultado(inglaterra, 3, senegal, 0).

pronostico(juan, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(juan, gano(argentina, australia, 3, 0)).
pronostico(juan, empataron(inglaterra, senegal, 0)).
pronostico(gus, gano(estados_unidos, paises_bajos, 1, 0)).
pronostico(gus, gano(japon, croacia, 2, 0)).
pronostico(lucas, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(lucas, gano(argentina, australia, 2, 0)).
pronostico(lucas, gano(croacia, japon, 1, 0)).

jugador(juan).
jugador(gus).
jugador(lucas).

% PUNTO 1
jugaron(Pais1, Pais2, Diferencia):-
    resultado(Pais1, Goles1, Pais2, Goles2),
    Diferencia is Goles1 - Goles2.
jugaron(Pais1, Pais2, Diferencia):-
    resultado(Pais2, Goles2, Pais1, Goles1),
    Diferencia is Goles2 - Goles1.

/*jugaron(Pais1, Pais2, Diferencia):-
    golesDelPartido(Pais1, Pais2, Goles1, Goles2),


golesDelPartido(Pais1, Pais2, Goles1, Goles2):- resultado(Pais1, Goles1, Pais2, Goles2).
golesDelPartido(Pais1, Pais2, Goles1, Goles2):- resultado(Pais2, Goles2, Pais1, Goles1).*/

gano(Ganador, Perdedor):-
    jugaron(Ganador, Perdedor, Diferencia),
    Diferencia > 0.

% PUNTO 2
puntosPronostico(gano(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor), 200):-
    gano(PaisGanador, PaisPerdedor),
    coincideGoles(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor).

coincideGoles(Pais1, Pais2, Goles1, Goles2):- resultado(Pais1, Goles1, Pais2, Goles2).
coincideGoles(Pais1, Pais2, Goles1, Goles2):- resultado(Pais2, Goles2, Pais1, Goles1).

puntosPronostico(empataron(UnPais, OtroPais, GolesDeCualquieraDeLosDos), 200):-
    jugaron(UnPais, OtroPais, 0),
    coincideGoles(UnPais, OtroPais, GolesDeCualquieraDeLosDos, GolesDeCualquieraDeLosDos).

puntosPronostico(gano(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor), 100):-
    gano(PaisGanador, PaisPerdedor),
    not(coincideGoles(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor)).

puntosPronostico(empataron(UnPais, OtroPais, GolesDeCualquieraDeLosDos), 100):-
    jugaron(UnPais, OtroPais, 0),
    not(coincideGoles(UnPais, OtroPais, GolesDeCualquieraDeLosDos, GolesDeCualquieraDeLosDos)).

puntosPronostico(gano(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor), 0):-
    not(gano(PaisGanador, PaisPerdedor)).

puntosPronostico(empataron(UnPais, OtroPais, GolesDeCualquieraDeLosDos), 0):-
    not(jugaron(UnPais, OtroPais, 0)).

% PUNTO 3
invicto(Jugador):-
    jugador(Jugador),
    forall((pronostico(Jugador, Pronostico), seJugo(Pronostico)), (puntosPronostico(Pronostico, Puntos), Puntos >= 100)).

seJugo(gano(PaisGanador, PaisPerdedor, GolesGanador, GolesPerdedor)):- jugaron(PaisGanador, PaisPerdedor, _).
seJugo(empataron(UnPais, OtroPais, GolesDeCualquieraDeLosDos)):- jugaron(UnPais, OtroPais, _).

% PUNTO 4
puntaje(Jugador, Puntaje):-
    jugador(Jugador),
    findall(Punto, (pronostico(Jugador, Pronostico), puntosPronostico(Pronostico, Punto)), Puntos),
    sum_list(Puntos, Puntaje).

% PUNTO 5   
esFavorito(Pais):-
    favoritoDeLosPronosticos(Pais).
esFavorito(Pais):-
    todoGanoPorGoleada(Pais).

todoGanoPorGoleada(Pais):-
    jugaron(Pais, OtroPais, Diferencia),
    Pais \= OtroPais,
    Diferencia >= 3.

favoritoDeLosPronosticos(Pais):-
    not((pronostico(_, empataron(Pais, OtroPais, _)))),
    OtroPais \= Pais.
favoritoDeLosPronosticos(Pais):-
    not((pronostico(_, empataron(OtroPais, Pais, _)))),
    OtroPais \= Pais.
favoritoDeLosPronosticos(Pais):-
    not((pronostico(_, gano(OtroPais, Pais, _, _)))),
    OtroPais \= Pais.

