horarios(dodain, lunes, 9, 15).
horarios(dodain, miercoles, 9, 15).
horarios(dodain, viernes, 9, 15).
horarios(lucas, martes, 10, 20).
horarios(juanC, sabado, 18, 22).
horarios(juanC, domingo, 18, 22).
horarios(juanFdS, jueves, 10, 20).
horarios(juanFdS, viernes, 12, 20).
horarios(leoC, lunes, 14, 18).
horarios(leoC, miercoles, 14, 18).
horarios(martu, miercoles, 23, 24).
horarios(vale, Dia, HoraInicio, HoraFinal):- horarios(dodain, Dia, HoraInicio, HoraFinal).
horarios(vale, Dia, HoraInicio, HoraFinal):- horarios(juanC, Dia, HoraInicio, HoraFinal).

% - nadie hace el mismo horario que leoC
% por principio de universo cerrado, no agregamos a la base de conocimiento aquello que no tiene sentido agregar
% - maiu está pensando si hace el horario de 0 a 8 los martes y miércoles
% por principio de universo cerrado, lo desconocido se presume falso

% Punto 2: quien atiende el kiosko en determinado horario
quienAtiende(Persona, Dia, Hora):-
    horarios(Persona, Dia, HoraInicio, HoraFinal),
    between(HoraInicio, HoraFinal, Hora).

% Punto 3: No existe persona que atienda en el mismo horario que esta persona
atiendeSola(Persona, Dia, HoraDeAtencion):-
    quienAtiende(Persona, Dia, HoraDeAtencion),
    not(((quienAtiende(Personas, _, _), Personas \= Persona), quienAtiende(Personas, Dia, HoraDeAtencion))).

% Punto 4: todas las posibilidades de quien podria estar atendiendo en algun momento del dia
posibilidadesAtencion(Dia, ListaPersonas):-
    findall(Persona, distinct(Persona, quienAtiende(Persona, Dia, _)), PosiblesPersonas),
    combinar(PosiblesPersonas, ListaPersonas).

combinar([], []).
combinar([Persona|PosiblesPersonas], [Persona|ListaPersonas]):-
    combinar(PosiblesPersonas, ListaPersonas).
combinar([_|PosiblesPersonas], ListaPersonas):-
    combinar(PosiblesPersonas, ListaPersonas).

% Qué conceptos en conjunto resuelven este requerimiento
% - findall como herramienta para poder generar un conjunto de soluciones que satisfacen un predicado
% - mecanismo de backtracking de Prolog permite encontrar todas las soluciones posibles

% Punto 5: VENTAS

/*golosinas(Valor).
cigarrillos([Marca]).
bebidas(Tipo, Cantidad).*/

ventas(dodain, lunes, 10, [golosinas(1200), cigarrillos([jockey]), golosinas(50)]).
ventas(dodain, miercoles, 12, [bebidas(alcoholica, 8), bebidas(noAlcoholica, 1), bebidas(alcoholica, 8)]).
ventas(martu, miercoles, 12, [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
ventas(lucas, martes, 11, [golosinas(600)]).
ventas(lucas, martes, 18, [bebidas(noAlcoholica, 2), cigarrillos([derby])]).

vendedorSuertudo(Persona):-
    ventas(Persona, _, _, Productos),
    forall(ventas(Persona, _, _, Productos), (nth1(1, Productos, ProductoImportante), ventaImportante(ProductoImportante))).
    
ventaImportante(golosinas(Valor)):- Valor > 100.
ventaImportante(cigarrillos(ListaMarcas)):- length(ListaMarcas, Longitud), Longitud > 2.
ventaImportante(bebidas(alcoholica, _)).
ventaImportante(bebidas(_, Cantidad)):- Cantidad > 5.


