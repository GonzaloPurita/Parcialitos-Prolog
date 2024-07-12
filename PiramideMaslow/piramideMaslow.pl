% necesidad(necesidad, categoria).
necesidad(respiracion, fisiologico).
necesidad(alimentacion, fisiologico).
necesidad(descanso, fisiologico).
necesidad(reproduccion, fisiologico).
necesidad(limpieza, fisiologico).
necesidad(fisica, seguridad).
necesidad(empleo, seguridad).
necesidad(salud, seguridad).
necesidad(amistad, social).
necesidad(afecto, social).
necesidad(intimidad, social).
necesidad(confianza, reconocimiento).
necesidad(respeto, reconocimiento).
necesidad(exito, reconocimiento).
necesidad(talento, autorealizacion).
necesidad(creatividad, autorealizacion).

% jerarquia(nivelSuperior, nivelInferior).
jerarquia(autorealizacion, reconocimiento).
jerarquia(reconocimiento, social).
jerarquia(social, seguridad).
jerarquia(seguridad, fisiologico).

% precedeNiveles(Posterior, Anterior).
precedeNiveles(Nivel, OtroNivel):-
    jerarquia(Nivel, OtroNivel).
precedeNiveles(Nivel, OtroNivel):-
    jerarquia(NivelIntermedio, OtroNivel),
    precedeNiveles(Nivel, NivelIntermedio).

%Punto 2: Saber la cantidad de niveles entre necesidades. Ej: entre respiracion y confianza hay 3 niveles.
separacionEntreNecesidades(Necesidad1, Necesidad2, Cantidad):-
    necesidad(Necesidad1, Nivel),
    necesidad(Necesidad2, OtroNivel),
    precedeNiveles(Nivel, OtroNivel),
    cantidadNivelesDif(Nivel, OtroNivel, Cantidad).
separacionEntreNecesidades(Necesidad1, Necesidad2, Cantidad):-
    necesidad(Necesidad2, Nivel),
    necesidad(Necesidad1, OtroNivel),
    precedeNiveles(Nivel, OtroNivel),
    cantidadNivelesDif(Nivel, OtroNivel, Cantidad).
separacionEntreNecesidades(Necesidad1, Necesidad2, 0):-
    necesidad(Necesidad1, Nivel),
    necesidad(Necesidad2, Nivel).

/* Posible solucion con listas:

cantidadNivelesDif(Nivel, OtroNivel, Cantidad):-
    findall(NivelIntermedio, (precedeNiveles(Nivel, NivelIntermedio), precedeNiveles(NivelIntermedio, OtroNivel)), Niveles),
    length(Niveles, Cant),
    Cantidad is Cant + 1.*/

% Solucion Con recursividad:
cantidadNivelesDif(Nivel, OtroNivel, 1):-
    jerarquia(Nivel, OtroNivel).
cantidadNivelesDif(Nivel, OtroNivel, Cantidad):-
    jerarquia(NivelIntermedio, OtroNivel),
    cantidadNivelesDif(Nivel, NivelIntermedio, Cant),
    Cantidad is Cant + 1.

% necesidades sin satisfacer:
/*necesidadPersona(carla, alimentacion).
necesidadPersona(carla, descanso).*/
necesidadPersona(carla, empleo).
necesidadPersona(carla, salud).
necesidadPersona(juan, afecto).
necesidadPersona(juan, exito).
necesidadPersona(roberto, amigos(1000000)).
% objeto(Cosa,Necesidad).
necesidadPersona(manuel, objeto(bandera,liberacion)).
necesidadPersona(charly, emparche).
necesidadPersona(charly, limpiezaCabeza).

% Para separar necesidades de necesidades consideradas en la piramide
queNecesita(Persona, Necesidad):-
    necesidadPersona(Persona, Necesidad),
    necesidad(Necesidad, _).
queNecesita(Persona, amistad):-
    necesidadPersona(Persona, amigos(_)).
queNecesita(Persona, Necesidad):-
    necesidadPersona(Persona, objeto(_, Necesidad)).

% Generador de personas
persona(Persona):-
    necesidadPersona(Persona,_).

% Generador de niveles
nivel(Nivel):-
    necesidad(_,Nivel).


% Punto 4: necesidad de mayor jerarquia
necesidadDeMayorJerarquia(Persona, Necesidad):-
    queNecesita(Persona, Necesidad),
    necesidad(Necesidad, JerarquiaMayor),
    forall(queNecesita(Persona, Necesidades), (necesidad(Necesidades, Jerarquia), mayorJerarquia(Jerarquia, JerarquiaMayor))).

mayorJerarquia(JerarquiaIgual, JerarquiaIgual).
mayorJerarquia(JerarquiaMenor, JerarquiaMayor):-
    precedeNiveles(JerarquiaMayor, JerarquiaMenor).

% Punto 5: nivel de jerarquia completo, para mi es cuando no tiene necesidades que satisfacer en ese nivel, y es un nivel inferior al de su necesidad de menor jerarquia
% Para todos los niveles existentes, no existe necesidad de una persona la cual este relacionada con un nivel
nivelJerarquicoCompleto(Persona, Nivel):-
    persona(Persona),
    nivel(Nivel),
    noTieneNecesidadesEnEseNivel(Persona, Nivel),
    nivelInferiorANivelesDeNecesidades(Persona, Nivel).

nivelInferiorANivelesDeNecesidades(Persona, Nivel):-
    nivelDeMenorJerarquia(Persona, NivelMenor),
    precedeNiveles(NivelMenor, Nivel).

nivelDeMenorJerarquia(Persona, JerarquiaMenor):-
    queNecesita(Persona, Necesidad), 
    necesidad(Necesidad, JerarquiaMenor),
    forall(queNecesita(Persona, Necesidades), (necesidad(Necesidades, Jerarquia), mayorJerarquia(JerarquiaMenor, Jerarquia))).

noTieneNecesidadesEnEseNivel(Persona, Nivel):-
    forall(necesidad(Necesidades, Nivel), not(queNecesita(Persona, Necesidades))).


% MOTIVACION: las personas sólo atienden necesidades superiores cuando han satisfecho las necesidades inferiores
% las necesidades tienen q estar en el mismo nivel jerargico

% a)
teoriaMaslowParticular(Persona):-
    necesidadDeMayorJerarquia(Persona, NecesidadMayor),
    condicionMaslow(Persona, NecesidadMayor). % si tiene solo una necesidad entonces no tiene necesidades en otro nivel
                                              % si no tiene una necesidad de menor jerarquia a la necesidad de mayor nivel

condicionMaslow(Persona, NecesidadMayor):-
    unicaNecesidad(Persona, NecesidadMayor).
condicionMaslow(Persona, NecesidadMayor):-
    not(tieneAlgunaNecesidadInferior(Persona, NecesidadMayor)).

tieneAlgunaNecesidadInferior(Persona, NecesidadMayor):-
    necesidad(NecesidadMayor, JerarquiaMayor),
    forall((queNecesita(Persona, Necesidades), necesidad(Necesidades, Jerarquia), Necesidades \= NecesidadMayor), (menorJerarquia(Jerarquia, JerarquiaMayor))).

unicaNecesidad(Persona, NecesidadMayor):-
    not((queNecesita(Persona, Necesidad), Necesidad \= NecesidadMayor)).

menorJerarquia(JerarquiaMenor, JerarquiaMayor):- precedeNiveles(JerarquiaMayor, JerarquiaMenor).

% b)
teoriaMaslowVarias(ListaPersonas):- %falta hacerla inversible
    %member(Persona, ListaPersonas),
    forall(member(Persona, ListaPersonas), teoriaMaslowParticular(Persona)).

% c) falta hacer

