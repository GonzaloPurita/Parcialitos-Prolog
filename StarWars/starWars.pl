apareceEn( luke, elImperioContrataca, luminoso).
apareceEn( luke, unaNuevaEsperanza, luminoso).
apareceEn( vader, unaNuevaEsperanza, oscuro).
apareceEn( vader, laVenganzaDeLosSith, luminoso).
apareceEn( vader, laAmenazaFantasma, luminoso).
apareceEn( c3po, laAmenazaFantasma, luminoso).
apareceEn( c3po, unaNuevaEsperanza, luminoso).
apareceEn( c3po, elImperioContrataca, luminoso).
apareceEn( chewbacca, elImperioContrataca, luminoso).
apareceEn( yoda, elAtaqueDeLosClones, luminoso).
apareceEn( yoda, laAmenazaFantasma, luminoso).

%Maestro(Personaje)
maestro(luke).
maestro(leia).
maestro(vader).
maestro(yoda).
maestro(rey).
maestro(duku).

%caracterizacion(Personaje,Aspecto).
%aspectos:
% ser(Especie,Tamaño)
% humano
% robot(Forma)
caracterizacion(chewbacca,ser(wookiee,10)).
caracterizacion(luke,humano).
caracterizacion(vader,humano).
caracterizacion(yoda,ser(desconocido,5)).
caracterizacion(jabba,ser(hutt,20)).
caracterizacion(c3po,robot(humanoide)).
caracterizacion(bb8,robot(esfera)).
caracterizacion(r2d2,robot(secarropas)).

%elementosPresentes(Episodio, Dispositivos)
elementosPresentes(laAmenazaFantasma, [sableLaser]).
elementosPresentes(elAtaqueDeLosClones, [sableLaser, clon]).
elementosPresentes(laVenganzaDeLosSith, [sableLaser, mascara, estrellaMuerte]).
elementosPresentes(unaNuevaEsperanza, [estrellaMuerte, sableLaser, halconMilenario]).
elementosPresentes(elImperioContrataca, [mapaEstelar, estrellaMuerte] ).

%precede(EpisodioAnterior,EpisodioSiguiente)
precedeA(laAmenazaFantasma,elAtaqueDeLosClones).
precedeA(elAtaqueDeLosClones,laVenganzaDeLosSith).
precedeA(laVenganzaDeLosSith,unaNuevaEsperanza).
precedeA(unaNuevaEsperanza,elImperioContrataca).


nuevoEpisodio(Heroe, Villano, Extra, Dispositivo):-
    apareceEn(Heroe, _, _),
    apareceEn(Villano, _, _),
    apareceEn(Extra, _, _),
    distintosPersonajes(Heroe, Villano, Extra),
    esHeroe(Heroe),
    esVillano(Villano),
    esExtra(Extra),
    dispositivoConocido(Dispositivo).

dispositivoConocido(Dispositivo):-
    elementosPresentes(_, Lista),
    member(Dispositivo, Lista),
    findall(Pelicula, (elementosPresentes(Pelicula, ListaDispositivos), member(Dispositivo, ListaDispositivos)), Peliculas),
    length(Peliculas, Cantidad),
    Cantidad >= 3.
    
    

esExtra(Extra):-
    apareceProtagonista(Extra),
    exotico(Extra).

exotico(Extra):-
    caracterizacion(Extra, robot(Tipo)),
    Tipo \= esfera.
exotico(Extra):-
    caracterizacion(Extra, ser(_, Altura)),
    Altura > 15.
exotico(Extra):-
    caracterizacion(Extra, ser(desconocido, _)).

apareceProtagonista(Extra):-
    apareceEn(Personaje, _, _),
    esHeroe(Personaje),
    forall(apareceEn(Extra, Episodio, _), apareceEn(Personaje, Episodio, _)).
apareceProtagonista(Extra):-
    apareceEn(Personaje, _, _),
    esVillano(Personaje),
    forall(apareceEn(Extra, Episodio, _), apareceEn(Personaje, Episodio, _)).

esVillano(Villano):-
    masDeUnEp(Villano),
    cambioDeLado(Villano).

cambioDeLado(Villano):-
    apareceEn(Villano, Episodio, luminoso),
    apareceEn(Villano, Episodio, oscuro).
cambioDeLado(Villano):-
    apareceEn(Villano, Episodio1, luminoso),
    apareceEn(Villano, Episodio2, oscuro),
    epPrecedente(Episodio1, Episodio2).

epPrecedente(Episodio1, Episodio2):-
    precedeA(Episodio1, Episodio2).
epPrecedente(Episodio1, Episodio2):-
    precedeA(EpIntermedio, Episodio2),
    epPrecedente(Episodio1, EpIntermedio).

masDeUnEp(Villano):-
    apareceEn(Villano, Episodio1, _),
    apareceEn(Villano, Episodio2, _),
    Episodio1 \= Episodio2.

esHeroe(Heroe):-
    maestro(Heroe),
    forall(apareceEn(Heroe, Episodio, _), apareceEn(Heroe, Episodio, luminoso)).
    

distintosPersonajes(Heroe, Villano, Extra):-
    Heroe \= Villano,
    Villano \= Extra,
    Heroe \= Extra.
