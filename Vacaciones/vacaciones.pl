destino(dodain, pehuenia).
destino(dodain, sanMartin).
destino(dodain, esquel).
destino(dodain, sarmiento).
destino(dodain, camarones).
destino(dodain, playasDoradas).
destino(alf, bariloche).
destino(alf, sanMartin).
destino(alf, elBolson).
destino(nico, marDelPlata).
destino(vale, calafate).
destino(vale, elBolson).
destino(martu, Destino):- destinoMartu(Destino).
destino(juan, Destino):- destinoJuan(Destino).

persona(dodain).
persona(alf).
persona(nico).
persona(vale).
persona(martu).
persona(juan).

destinoJuan(Destino):-
    Destino = villaGesell.
destinoJuan(Destino):-
    Destino = federacion.

destinoMartu(Destino):-
    destino(nico, Destino).
destinoMartu(Destino):-
    destino(alf, Destino).

atracciones(esquel, parque(losAlerces)).
atracciones(esquel, excursion(trochita)).
atracciones(esquel, excursion(trevelin)).
atracciones(pehuenia, cerro(bateaMahuida, 2000)).
atracciones(pehuenia, cuerpoAgua(moquehue, puedePescar, 14)).
atracciones(pehuenia, cuerpoAgua(alumine, puedePescar, 19)).

vacacionesCopadas(Persona):-
    destino(Persona, Destino),
    forall(atracciones(Destino, Atraccion), atraccionCopada(Atraccion)).

atraccionCopada(cerro(_, Altura)):- Altura > 2000.
atraccionCopada(cuerpoAgua(_, puedePescar, _)).
atraccionCopada(cuerpoAgua(_, _, Temperatura)):- Temperatura > 20.
atraccionCopada(playa(Marea)):- Marea < 5.
atraccionCopada(parque(_)).
atraccionCopada(excursion(Nombre)):- atom_length(Nombre, Cant), Cant > 7.

noSeCruzaron(Persona1, Persona2):-
    persona(Persona1),
    persona(Persona2),
    forall(persona(_), not((destino(Persona1, Destino), destino(Persona2, Destino)))).

costoDeVida(sarmiento, 100).
costoDeVida(esquel, 150).
costoDeVida(pehuenia, 180).
costoDeVida(sanMartin, 150).
costoDeVida(camarones, 135).
costoDeVida(playasDoradas, 170).
costoDeVida(bariloche, 140).
costoDeVida(calafate, 240).
costoDeVida(elBolson, 145).
costoDeVida(marDelPlata, 140).

vacacionesGasoleras(Persona):-
    persona(Persona),
    forall(destino(Persona, Destino), (destino(Persona, Destino), costoDeVida(Destino, Costo), Costo < 160)).

itineracios(Persona, ListaDestinos):-
    cantidadViajes(Persona, Cantidad),
    length(ListaDestinos, Cantidad),
    forall(destino(Persona, Destino), member(Destino, ListaDestinos)).
    
    
cantidadViajes(Persona, Cantidad):-
    findall(Destino, destino(Persona, Destino), Destinos),
    length(Destinos, Cantidad).