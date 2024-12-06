%persona(nombre, altura, peso).
persona(valdivieso, 155, 52).
persona(leguisamo, 161, 49).
persona(lezcano, 149, 50).
persona(baratucci, 153, 55).
persona(falero, 157, 52).

caballo(botafogo).
caballo(oldMan).
caballo(energica).
caballo(matBoy).
caballo(yatasto).

preferenciaCaballo(botafogo, Persona):- persona(Persona, _, Peso), Peso < 52.
preferenciaCaballo(botafogo, baratucci).
preferenciaCaballo(oldMan, Persona):- persona(Persona, _, _), atom_length(Persona, Cant), Cant > 7.
preferenciaCaballo(energica, Persona):- persona(Persona, _, _), not(preferenciaCaballo(botafogo, Persona)).
preferenciaCaballo(matBoy, Persona):- persona(Persona, Altura, _), Altura > 170.

%caballeria(Persona, Caballeria).
caballeria(valdivieso, elTute).
caballeria(falero, elTute).
caballeria(lezcano, lasHormigas).
caballeria(baratucci, elCharabon).
caballeria(leguisamo, elCharabon).

%gano(Caballo, Premio).
gano(botafogo, nacional).
gano(botafogo, republica).
gano(oldMan, republica).
gano(oldMan, palermoDeOro).
gano(matBoy, criadores).

%PUNTO 2
prefierenAMasDeUno(Caballo):-
    preferenciaCaballo(Caballo, Persona1),
    preferenciaCaballo(Caballo, Persona2),
    Persona1 \= Persona2.

%PUNTO 3
aborrece(Caballo, Caballeria):-
    caballo(Caballo),
    caballeria(_, Caballeria),
    not((caballeria(Personas, Caballeria), preferenciaCaballo(Caballo, Personas))).

%PUNTO 4
premioImportante(nacional).
premioImportante(republica).

esPiolin(Persona):-
    persona(Persona, _, _),
    forall((premioImportante(Premio), gano(Caballo, Premio)), preferenciaCaballo(Caballo, Persona)).

%PUNTO 5
% apuesta(ganadorXcaballo(Caballo)).
% apuesta(segundoXcaballo(Caballo)).
% apuesta(exacta(Caballo1, Caballo2)).
% apuesta(imperfecta(Caballo1, Caballo2)).

buenaApuesta(ganadorXcaballo(Caballo), ResultadoCarrera):-
    nth0(0, ResultadoCarrera, Caballo).
buenaApuesta(segundoXcaballo(Caballo), ResultadoCarrera):-
    nth0(0, ResultadoCarrera, Caballo).
buenaApuesta(segundoXcaballo(Caballo), ResultadoCarrera):-
    nth0(1, ResultadoCarrera, Caballo).
buenaApuesta(exacta(Caballo1, Caballo2), ResultadoCarrera):-
    nth0(0, ResultadoCarrera, Caballo1),
    nth0(1, ResultadoCarrera, Caballo2).
buenaApuesta(imperfecta(Caballo1, Caballo2), ResultadoCarrera):-
    nth0(0, ResultadoCarrera, Caballo1),
    nth0(1, ResultadoCarrera, Caballo2).
buenaApuesta(imperfecta(Caballo1, Caballo2), ResultadoCarrera):-
    nth0(1, ResultadoCarrera, Caballo1),
    nth0(0, ResultadoCarrera, Caballo2).

/*
Otra forma:

apuestaGanadora(ganador(Caballo), Resultado):-salioPrimero(Caballo, Resultado).
apuestaGanadora(segundo(Caballo), Resultado):-salioPrimero(Caballo, Resultado).
apuestaGanadora(segundo(Caballo), Resultado):-salioSegundo(Caballo, Resultado).
apuestaGanadora(exacta(Caballo1, Caballo2),Resultado):-salioPrimero(Caballo1, Resultado), salioSegundo(Caballo2, Resultado).
apuestaGanadora(imperfecta(Caballo1, Caballo2),Resultado):-salioPrimero(Caballo1, Resultado), salioSegundo(Caballo2, Resultado).
apuestaGanadora(imperfecta(Caballo1, Caballo2),Resultado):-salioPrimero(Caballo2, Resultado), salioSegundo(Caballo1, Resultado).

salioPrimero(Caballo, [Caballo|_]).
salioSegundo(Caballo, [_|[Caballo|_]]).    o    salioSegundo(Caballo, [_, Caballo | _]).
*/

%PUNTO 6
% color(botafogo, negro).
% color(oldMan, marron).
% color(energica, gris).
% color(energica, negro).
% color(matBoy, marron).
% color(matBoy, blanco).
% color(yatasto, blanco).
% color(yatasto, marron).

color(tordo, negro).
color(alazan, marron).
color(ratonero, gris).
color(ratonero, negro).
color(palomino, marron).
color(palomino, blanco).
color(pinto, blanco).
color(pinto, marron).

crin(botafogo, tordo).
crin(oldMan, alazan).
crin(energica, ratonero).
crin(matBoy, palomino).
crin(yatasto, pinto).

comprar(Color, Caballos):-
    findall(Caballo, (crin(Caballo, Crin), color(Crin, Color)), CaballosPosibles),
    combinar(CaballosPosibles, Caballos),
    Caballos \= [].

combinar([], []).
combinar([Caballo|Caballos], [Caballo|ListaCaballos]):-
    combinar(Caballo, ListaCaballos). 
combinar([_|Caballos], ListaCaballos):-
    combinar(Caballos, ListaCaballos).