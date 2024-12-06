recorrido(17, gba(sur), mitre).
recorrido(24, gba(sur), belgrano).
recorrido(247, gba(sur), onsari).
recorrido(60, gba(norte), maipu).
%recorrido(60, gba(este), maipu).
recorrido(152, gba(norte), olivos).
recorrido(17, caba, santaFe).
recorrido(152, caba, santaFe).
recorrido(10, caba, santaFe).
recorrido(160, caba, medrano).
recorrido(24, caba, corrientes).


%PUNTO 1
puedenCombinarse(Linea1, Linea2):-
    recorrido(Linea1, Zona, Calle),
    recorrido(Linea2, Zona, Calle),
    Linea1 \= Linea2.

%PUNTO 2
jurisdiccion(Linea, nacional):-
    %recorrido(Linea, _, _)    no hace falta porq cruzaGeneralPaz ya lo hace inversible
    cruzaGeneralPaz(Linea).
jurisdiccion(Linea, provincial(Provincia)):-
    recorrido(Linea, Zona, _),
    perteneceA(Zona, Provincia),
    not(cruzaGeneralPaz(Linea)).

cruzaGeneralPaz(Linea):-
    recorrido(Linea, caba, _),
    recorrido(Linea, gba(_), _).

perteneceA(caba, caba).
perteneceA(gba(_), buenosAires).

%PUNTO 3
calleMasTransitada(Calle, Zona):-
    recorrido(_, Zona, Calle),
    cantidadDeLineas(Calle, Zona, CantLineas),
    forall(recorrido(_, Zona, Calles), (cantidadDeLineas(Calles, Zona, CantidadLineas), CantLineas >= CantidadLineas)).

cantidadDeLineas(Calle, Zona, CantLineas):-
    findall(Linea, distinct(Linea, recorrido(Linea, Zona, Calle)), Lineas),   
    length(Lineas, CantLineas).

%PUNTO 4
calleTransbordo(Calle, Zona):-
    recorrido(_, Zona, Calle),
    cantidadDeLineas(Calle, Zona, CantLineas),
    CantLineas >= 3,
    forall(recorrido(Lineas, Calle, Zona), jurisdiccion(Lineas, nacional)).

%PUNTO 5

%beneficio(Persona, estudiantil).  costo fijo de $50
%beneficio(Persona, personal(Zona)).  Si la línea que se toma la persona con este beneficio pasa por dicha zona, se subsidia el valor total del boleto
%beneficio(Persona, jubilado).   el boleto cuesta la mitad

beneficio(pepito, personal(gba(oeste))).
beneficio(juanita, estudiantil).
beneficio(marta, jubilado).
beneficio(marta, personal(caba)).
beneficio(marta, personal(gba(sur))).

cuantoCuesta(Persona, Linea, Costo):-
    jurisdiccion(Linea, Jurisdiccion),
    valorBoleto(Linea, Jurisdiccion, Valor),
    mejorBeneficio(Persona, Beneficio, Valor, Linea),
    descuento(Linea, Beneficio, Valor, Costo).

mejorBeneficio(Persona, Beneficio, Valor, Linea):-
    beneficio(Persona, Beneficio),
    descuento(Linea, Beneficio, Valor, Costo),
    forall(beneficio(Persona, Beneficios), (descuento(Linea, Beneficios, Valor, Costos), Costos >= Costo)).

descuento(_, estudiantil, Valor, 50).
descuento(_, jubilado, Valor, Valor/2).
descuento(Linea, personal(Zona), Valor, Costo):-
    recorrido(Linea, Zona, _),
    Costo is 0.
descuento(Linea, personal(Zona), Valor, Costo):-
    not(recorrido(Linea, Zona, _)),
    Costo is Valor.

valorBoleto(_, nacional, 500).
valorBoleto(_, provincial(caba), 350).
valorBoleto(Linea, provincial(buenosAires), Valor):-
    pasaPorDifZonas(Linea),
    cantidadDeCalles(Linea, CantCalles),
    Valor is 25 * CantCalles + 50.
valorBoleto(Linea, provincial(buenosAires), Valor):-
    not(pasaPorDifZonas(Linea)),
    cantidadDeCalles(Linea, CantCalles),
    Valor is 25 * CantCalles.

pasaPorDifZonas(Linea):-
    recorrido(Linea, Zona1, _),
    recorrido(Linea, Zona2, _),
    Zona1 \= Zona2.

cantidadDeCalles(Linea, CantCalles):-
    findall(Calle, distinct(Calle, recorrido(Linea, _, Calle)), Calles),
    length(Calles, CantCalles).


% SI AGREGO OTRO DESCUENTO
% no me cambiaria la implementacion, porque esta pensada para poder agregar cualquier descuento que se ocurra