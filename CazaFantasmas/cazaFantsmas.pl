herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

herramientas(egon, aspiradora(200)).
herramientas(egon, trapeador).
herramientas(peter, trapeador).
herramientas(winston, varitaDeNeutrones).

persona(egon).
persona(peter).
persona(winston).
persona(ray).

% Tiene herramienta requerida
tieneHerramienta(Integrante, aspiradora(PotenciaRequerida)):-
    herramientas(Integrante, aspiradora(Potencia)),
    Potencia >= PotenciaRequerida.
tieneHerramienta(Integrante, Herramienta):-
    herramientas(Integrante, Herramienta).

puedeHacerTarea(Persona, _):-
    herramientas(Persona, varitaDeNeutrones).
puedeHacerTarea(Persona, Tarea):-
    persona(Persona),
    herramientasRequeridas(Tarea, ListaDeHerramientas),
    tieneLoNecesario(Persona, ListaDeHerramientas).
    %not((herramientas(Persona, Herramienta), not(member(Herramienta, ListaDeHerramientas)))).

tieneLoNecesario(Persona, ListaDeHerramientas):-
    forall(member(Herramienta, ListaDeHerramientas), tieneHerramienta(Persona, Herramienta)).

% Punto 4

% tareaPedida(tarea, cliente, metros)
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

% precio(tarea, precio)
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).

cobroCliente(Cliente, PrecioCobrar):-
    tareaPedida(_, Cliente, _),
    findall(Precio, precioMultitplicado(Cliente, Precio), ListaPrecios),
    sum_list(ListaPrecios, PrecioCobrar).

precioMultitplicado(Cliente, Precio):-
    tareaPedida(Tarea, Cliente, Metros),
    precio(Tarea, PrecioUnitario),
    Precio is PrecioUnitario * Metros.

% Punto 5: Aceptar pedido, puede realizar todas las tareas y esta dispuesto a aceptarlo
% - ray solo acepta pedidos que no incluyan limpiar techos
% - winston solo acepta los q pagan mas de $500
% - Peter acepta lo q sea
% - egor no acepta pedidos con tareas complejas, osea que requiera mas de dos herramientas (limpiar techos siempre es compleja)

% el pedido es una lista de tareas
aceptaPedido(Integrante, Cliente):-
    puedeHacerPedido(Integrante, Cliente),
    estaDispuestoAHacerlo(Integrante, Cliente).

puedeHacerPedido(Integrante, Cliente):-
    forall(tareaPedida(Tarea, Cliente, _), puedeHacerTarea(Integrante, Tarea)).

estaDispuestoAHacerlo(ray, Cliente):-
    not(tareaPedida(limpiarTecho, Cliente, _)).

estaDispuestoAHacerlo(winston, Cliente):-
    cobroCliente(Cliente, PrecioACobrar),
    PrecioACobrar > 500.

estaDispuestoAHacerlo(peter, Cliente):-
    tareaPedida(_, Cliente, _).

estaDispuestoAHacerlo(egor, Cliente):-
    forall(tareaPedida(Tarea, Cliente, _), not(tareaCompleja(Tarea))).

tareaCompleja(limpiarTecho).
tareaCompleja(Tarea):-
    herramientasRequeridas(Tarea, ListaDeHerramientas),
    length(ListaDeHerramientas, Longitud),
    Longitud > 2.

% Punto 6:
herramientasRequeridas(ordenarCuarto, [escoba, trapeador, plumero]).
