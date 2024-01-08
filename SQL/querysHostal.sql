use hostal;

/*Buscar hostales por ciudad*/
select h.ID_hostal, nombre, ciudad, telefono
from hostal h
         join direccion d on h.ID_hostal = d.ID_hostal
where ciudad like 'Madrid'; -- Indicamos la ciudad

/*Buscar habitaciones abiertas para un numero concreto de personas en una ciudad*/
select ID_habitacion, h.ID_hostal, ciudad, num_personas
from habitacion h
         join direccion d on h.ID_hostal = d.ID_hostal
where num_personas = 1
  and ciudad like 'Paris'
    and estado = 1;

/*Buscar habitaciones NO reservadas para una ciudad en concreto entre 2 fechas*/
select h.ID_habitacion, nombre, num_personas
from habitacion h
join hostal h2 on h2.ID_hostal = h.ID_hostal
join direccion d on h.ID_hostal = d.ID_hostal
where estado = 1
  and ciudad like 'Madrid'
  and h.ID_habitacion not in (select ID_habitacion
                              from habitaciones_reservadas
                              where fecha between '2021-03-02' and '2021-03-07'); -- Nos aseguramos de que no esten reservadas las habitaciones

-- Calcular el precio total de una reserva
select ID_reserva, (datediff(fin_reserva, inicio_reserva) * p.precio) as 'precio_total'
from reserva r
         join precio p on r.ID_habitacion = p.ID_habitacion
where ID_reserva = 4;

/* Buscar habitaciones disponibles
   en una ciudad en concreto
   entre un determinado precio
   entre 2 fechas
 */
select h.ID_habitacion, precio, num_personas, precio as precio_noche
from habitacion h
         join direccion d on h.ID_hostal = d.ID_hostal
         join precio p on h.ID_habitacion = p.ID_habitacion
where precio between 0 and 300
  and ciudad like 'Madrid'
and estado = 1
and h.ID_habitacion not in (select hr.ID_habitacion
                                from habitaciones_reservadas hr
                                where fecha between '2021-01-08' and '2021-03-06');
/* Buscar habitaciones disponibles
   en una ciudad en concreto
   entre un determinado precio
   entre 2 fechas
   mostrando el precio total de la estancia
 */
select h.ID_habitacion, num_personas, precio,datediff('2021-03-06', '2021-03-02') as noches, (datediff('2021-03-06', '2021-03-02') * precio) as precio_total
from habitacion h
         join direccion d on h.ID_hostal = d.ID_hostal
         join precio p on h.ID_habitacion = p.ID_habitacion
where precio between 0 and 300
  and ciudad like 'Madrid'
and estado = 1
and h.ID_habitacion not in (select hr.ID_habitacion
                                from habitaciones_reservadas hr
                                where fecha between '2021-03-02' and '2021-03-06');

-- Buscar habitaciones reservadas en temporada alta
select ID_habitacion
from habitaciones_reservadas hr
         join calendario c on c.fecha = hr.fecha
where temporada = 'Alta';

-- Buscar habitaciones NO reservadas en temporada Alta
select hab.ID_habitacion, nombre, ciudad, num_personas, precio
from habitacion hab
         join hostal h on h.ID_hostal = hab.ID_hostal
         join direccion d on hab.ID_hostal = d.ID_hostal
         join precio p on hab.ID_habitacion = p.ID_habitacion
where estado = 1
  and hab.ID_habitacion not in (select ID_habitacion
                                from habitaciones_reservadas hr
                                         join calendario c on c.fecha = hr.fecha
                                where temporada = 'Alta');

-- Mostrar las reservas de un usuario
select distinct ID_reserva
from reserva r
         join usuario_registrado ur on ur.ID_usuario = r.ID_usuario
where email = 'pepe@gmail.com';


/*Querys Negocio y gestion*/
-- Buscar cuantas reservas se han hecho con tarjeta
select count(ID_reserva) as total_reservas_pago_tarjeta
from reserva r
where pago like 'tarjeta';

-- Calcular cuantas reservas se han hecho entre varias fechas
select count(ID_reserva) as num_reservas
from reserva r
where inicio_reserva between '2021-01-01' and '2021-05-02';

-- Media de precios de cada hostal
select h.ID_hostal, nombre, round(avg(precio), 2) as precio_medio
from precio p
         join habitacion h on h.ID_habitacion = p.ID_habitacion
         join hostal h2 on h2.ID_hostal = h.ID_hostal
group by nombre, h.ID_hostal;

-- Total facturado en un hostal
select sum(precio_total) as facturacion_total
from reserva r
         join habitacion h on h.ID_habitacion = r.ID_habitacion
where ID_hostal = 1;

-- Mostrar el porcentaje de pagos con cryptomonedas
SELECT CONCAT((COUNT(pago) / (SELECT COUNT(*) FROM reserva)) * 100, '%') AS porcentaje_pagos_cryptomonedas
FROM reserva
WHERE pago = 'cryptomonedas';

-- Calcular los clientes disponibles en un hotel(3)
select sum(num_personas) as aforo_personas
from habitacion hab
         join hostal h on h.ID_hostal = hab.ID_hostal
where hab.ID_hostal = 3
group by hab.ID_hostal;

-- Mostrar numero de clientes hospedados en un hostal en concreto (1) en una fecha en concreto (Marzo)
select sum(num_personas) as num_clientes
from reserva r
         join habitacion h on h.ID_habitacion = r.ID_habitacion
where r.inicio_reserva >= '2021-03-01'
and r.fin_reserva <= '2021-04-01'
and ID_hostal = 1;




-- Actualiza el valor de la columna precio_total
UPDATE reserva r
    JOIN precio p ON r.ID_habitacion = p.ID_habitacion
SET r.precio_total = DATEDIFF(r.fin_reserva, r.inicio_reserva) * p.precio
WHERE r.fin_reserva IS NOT NULL AND r.inicio_reserva IS NOT NULL;

