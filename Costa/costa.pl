comida(hamburguesa, 2000).
comida(panchoConPapas, 1500).
comida(lomito, 2500).
comida(caramelo, 0).

%atraccion(Nombre, Tipo).
% Tipo = tranquila(Destinada).
atraccion(autitosChocadores, tranquila(adulto)).
atraccion(autitosChocadores, tranquila(chico)).
atraccion(casaEmbrujada, tranquila(adulto)).
atraccion(casaEmbrujada, tranquila(chico)).
atraccion(laberinto, tranquila(adulto)).
atraccion(laberinto, tranquila(chico)).
atraccion(tobogan, tranquila(chico)).
atraccion(calesita, tranquila(chico)).
% Tipo = intensa(coeficiente).
atraccion(barcoPirata, intensa(14)).
atraccion(tazasChinas, intensa(6)).
atraccion(simulador2D, intensa(2)).
% Tipo = montaniaRusa(Giros, Tiempo).
atraccion(abismoMortal, montaniaRusa(3, 134)).
atraccion(paseoXBosque, montaniaRusa(0, 45)).
% Tipo = acuatica
atraccion(torpedoSalpicon, acuatica).
atraccion(mudaRopaNueva, acuatica).

grupo(viejitos).
grupo(lopez).
grupo(promo23).

%persona(Nombre, Dinero, Edad, GrupoFam).
persona(eusebio, 3000, 80, viejitos).
persona(carmela, 0, 80, viejitos).
persona(gonza, 100, 22, solo).
persona(nico, 10, 10, lopez).

%sentimiento(Nombre, Hambre, Aburrimiento).
sentimiento(eusebio, 50, 0).
sentimiento(caramela, 0, 25).
sentimiento(gonza, 0, 0).

generacion(eusebio, adulto).
generacion(caramela, adulto).
generacion(gonza, adulto).
generacion(nico, chico).

%PUNTO 2
bienestar(Visitante, Estado):-
    persona(Visitante, _, _, Grupo),
    verificarSentimientos(Visitante, Grupo, Estado).

verificarSentimientos(Visitante, solo, podriaEstarMejor):-
    sumaSentimientos(Visitante, 0, 0).
verificarSentimientos(Visitante, _, puraFelicidad):-
    sumaSentimientos(Visitante, 0, 0).
verificarSentimientos(Visitante, _, podriaEstarMejor):-
    sumaSentimientos(Visitante, 1, 50).
verificarSentimientos(Visitante, _, necesitaEntretenerse):-
    sumaSentimientos(Visitante, 51, 99).
verificarSentimientos(Visitante, _, seQuiereIr):-
    sentimiento(Visitante, Hambre, Aburrimiento),
    Hambre + Aburrimiento >= 100.

sumaSentimientos(Visitante, Desde, Hasta):-
    sentimiento(Visitante, Hambre, Aburrimiento),
    Total is Hambre + Aburrimiento,
    between(Desde, Hasta, Total).

% PUNTO 3
grupoPuedeSerSatisfecho(Grupo, Comida):-
    grupo(Grupo),
    comida(Comida, _),
    forall(persona(Persona, Dinero, _, Grupo), puedeComprarlo(Persona, Comida)),
    forall(persona(Persona, _, _, Grupo), quitaHambre(Persona, Comida)).

quitaHambre(Persona, hamburguesa):-
    sentimiento(Persona, Hambre, _),
    Hambre < 50.
quitaHambre(Persona, panchoConPapas):-
    generacion(Persona, chico).
quitaHambre(_, lomito).
quitaHambre(Persona, caramelo):-
    persona(Persona, Dinero, _, _),
    forall((comida(Comidas, Cuestan), Comidas \= caramelo), Dinero < Cuestan).

puedeComprarlo(Visitante, Comida):-
    persona(Visitante, Dinero, _, _),
    comida(Comida, Costo),
    Dinero >= Costo.

% PUNTO 4
lluviaHamburguesas(Visitante, Atraccion):-
    puedeComprarlo(Visitante, hamburguesa),
    atraccion(Atraccion, _),
    esUnaAtraccionPicante(Atraccion, Visitante).

esUnaAtraccionPicante(Atraccion, Visitante):-
    atraccion(Atraccion, intensa(Coeficiente)),
    Coeficiente >= 10.
esUnaAtraccionPicante(Atraccion, Visitante):-
    atraccion(Atraccion, montaniaRusa(_, _)),
    generacion(Visitante, Edad),
    esPeligrosa(Atraccion, Visitante, Edad).
esUnaAtraccionPicante(Atraccion, Visitante):-
    atraccion(tobogan, _).

esPeligrosa(Atraccion, Visitante, adulto):-
    not(bienestar(Visitante, necesitaEntretenerse)),
    montaniaRusaConMasGiros(Atraccion).
esPeligrosa(Atraccion, Visitante, chico):-
    atraccion(Atraccion, montaniaRusa(_, Tiempo)),
    Tiempo > 60.

montaniaRusaConMasGiros(Atraccion):-
    atraccion(Atraccion, montaniaRusa(Giro, _)),
    forall(atraccion(Atracciones, montaniaRusa(Giros, _)), Giro >= Giros).

% PUNTO 5
entretenimiento(Visitante, Entretenimiento, Mes):-
    persona(Visitante, _, _, _),
    cumpleSerEntretenimientoAdecuado(Visitante, Entretenimiento, Mes).

cumpleSerEntretenimientoAdecuado(Visitante, Comida, _):-
    puedeComprarlo(Visitante, Comida).
cumpleSerEntretenimientoAdecuado(Visitante, Atraccion, _):-
    atraccion(Atraccion, intensa(_)).
cumpleSerEntretenimientoAdecuado(Visitante, Atraccion, _):-
    atraccion(Atraccion, tranquila(Edad)),
    generacion(Visitante, Edad).
cumpleSerEntretenimientoAdecuado(Visitante, Atraccion, _):-
    atraccion(Atraccion, tranquila(chico)),
    persona(Visitante, _, _, Grupo),
    persona(Persona, _, _, Grupo), 
    Persona \= Visitante,
    generacion(Persona, chico).
cumpleSerEntretenimientoAdecuado(Visitante, Atraccion, _):-
    atraccion(Atraccion, montaniaRusa(_, _)),
    generacion(Visitante, Edad),
    not(esPeligrosa(Atraccion, Visitante, Edad)).
cumpleSerEntretenimientoAdecuado(Visitante, Atraccion, Mes):-   %Supongamos que los meses de apertura son [Noviembre - Abril]
    atraccion(Atraccion, acuatica),
    member(Mes, [noviembre, diciembre, enero, febrero, marzo, abril]).
    