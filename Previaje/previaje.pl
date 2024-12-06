%comercioAdherido(LugarQueEntraEnPrograma, Comercio).
comercioAdherido(iguazu, grandHotelIguazu).
comercioAdherido(iguazu, gargantaDelDiabloTour).
comercioAdherido(bariloche, aerolineas).
comercioAdherido(iguazu, aerolineas).

%factura(Persona, DetalleFactura).
%Detalles de facturas posibles:
% hotel(ComercioAdherido, ImportePagado)
% excursion(ComercioAdherido, ImportePagadoTotal, CantidadPersonas)
% vuelo(NroVuelo,NombreCompleto)
factura(estanislao, hotel(grandHotelIguazu, 2000)).
factura(antonieta, excursion(gargantaDelDiabloTour, 5000, 4)).
factura(antonieta, vuelo(1515, antonietaPerez)).
valorMaximoHotel(5000).

% vuelos que se hicieron:
%registroVuelo(NroVuelo,Destino,ComercioAdherido,Pasajeros,Precio)
registroVuelo(1515, iguazu, aerolineas, [estanislaoGarcia, antonietaPerez, danielIto], 10000).

% PUNTO 1
montoADevolver(Persona, Monto):-
    factura(Persona, _),
    facturasValidas(Persona, FacturasValidas),
    devolucionTotalFacValidas(FacturasValidas, DevolucionTotal),  
    adicionalTotal(FacturasValidas, AdicionalTotal),
    penalidad(Persona, Penalidad),
    Monto is DevolucionTotal + AdicionalTotal - Penalidad,
    Monto < 100000.  %El monto maximo es de 100 000
montoADevolver(Persona, 100000):-
    factura(Persona, _),
    facturasValidas(Persona, FacturasValidas),
    devolucionTotalFacValidas(FacturasValidas, DevolucionTotal),  
    adicionalTotal(FacturasValidas, AdicionalTotal),
    penalidad(Persona, Penalidad),
    Monto is DevolucionTotal + AdicionalTotal - Penalidad,
    Monto >= 100000.

penalidad(Persona, 15000):-
    factura(Persona, Factura),
    not(esValida(Factura)).
penalidad(Persona, 0):-
    forall(factura(Persona, Factura), esValida(Factura)).

adicionalTotal(FacturasValidas, AdicionalTotal):-
    findall(Ciudad, (member(Factura, FacturasValidas), ciudadFactura(Factura, Ciudad)), Ciudades),
    length(Ciudades, Cantidad),
    AdicionalTotal is Cantidad * 1000.

ciudadFactura(hotel(NombreHotel, _), Ciudad):-
    comercioAdherido(Ciudad, NombreHotel).
ciudadFactura(excursion(NombreExcursion, _, _), Ciudad):-
    comercioAdherido(Ciudad, NombreExcursion).
ciudadFactura(vuelo(NroVuelo, _), Ciudad):-
    registroVuelo(NroVuelo, Ciudad, _, _, _).

devolucionTotalFacValidas(FacturasValidas, DevolucionTotal):-
    findall(Devolucion, (member(Factura, FacturasValidas), devolucionParcial(Factura, Devolucion)), Devoluciones),
    sum_list(Devoluciones, DevolucionTotal).

devolucionParcial(hotel(_, ImportePagado), Devolucion):-
    Devolucion is ImportePagado / 2.
devolucionParcial(vuelo(NroVuelo, _), 0):-
    registroVuelo(NroVuelo, buenosAires, _, _, _).
devolucionParcial(vuelo(NroVuelo, _), Devolucion):-
    registroVuelo(NroVuelo, Destino, _, _, Monto),
    Destino \= buenosAires,
    Devolucion is Monto * (30/100).
devolucionParcial(excursion(_, ImportePagado, CantPersonas), Devolucion):-
    Devolucion is (80/100) * (ImportePagado / CantPersonas).

facturasValidas(Persona, FacturasValidas):-
    findall(Factura, (factura(Persona, Factura), esValida(Factura)), FacturasValidas).

esValida(excursion(NombreExcursion, _, _)):-
    comercioAdherido(_, NombreExcursion).
esValida(hotel(NombreHotel, ImportePagado)):-
    comercioAdherido(_, NombreHotel),
    valorMaximoHotel(ValorMaximo),
    ImportePagado > ValorMaximo.
esValida(vuelo(NroVuelo, NombreCompleto)):-
    registroVuelo(NroVuelo, _, Marca, Pasajeros, _),
    comercioAdherido(_, Marca),
    member(NombreCompleto, Pasajeros).  % Supongo que en los Pasajeros esta el nombre completo siempre


% PUNTO 2
destinosDeTrabajo(Destino):-
    registroVuelo(_, Destino, _, _, _),
    not(turistaAlojado(Destino)).
destinosDeTrabajo(Destino):-
    registroVuelo(_, Destino, _, _, _),
    not(tieneUnSoloHotel(Destino)).

tieneUnSoloHotel(Destino):-
    comercioAdherido(Destino, NombreHotel1),
    factura(_, hotel(NombreHotel1, _)),
    comercioAdherido(Destino, NombreHotel2),
    factura(_, hotel(NombreHotel2, _)),
    NombreHotel1 \= NombreHotel2.

turistaAlojado(Destino):-
    comercioAdherido(Destino, NombreHotel),
    factura(_, hotel(NombreHotel, _)).

% PUNTO 3
esEstafador(Persona):-
    forall(factura(Persona, Factura), not(esValida(Factura))).
esEstafador(Persona):-
    forall(factura(Persona, Factura), montoTrucho(Factura)).

montoTrucho(hotel(_, 0)).
montoTrucho(excursion(_, 0, _)).
montoTrucho(vuelo(NroVuelo, _)):- registroVuelo(NroVuelo, _, _, _, 0).

% PUNTO 4
/*
    Se podria agregar un comercio de transporte por ejemplo, tranporte(NombreEmpresa, MontoParaUnSoloViaje, MontoPack, MontoIlimitado).
    El codigo que tenemos no se cambiaria, ya que usariamos el polimorfismo para agregar los predicados que incluyan este nuevo comercio
    Agregariamos un predicado extra en ciudadFactura, devolucionParcial, esValida
*/