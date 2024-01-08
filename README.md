# Practica BBDD de una cadena de Hostales
---
En esta practica he generado un modelo Entidad Relacion para guardar datos sobre una cadena de Hostales.
Estan creadas las tablas y existe un sql para insertat los datos iniciales:

Puede que de error por las foreign key

Se soluciona poniendo al principio:

set foreign_key_checks = 0;

De esta manera desactivamos la comprobacion de las foreign keys

cargamos los datos y activamos otra vez la verificacion:

set foreign_key_checks = 1;

--- 
Tambien hay otro sql con querys de posibles consultas que se podrian ejecutar contra esta BBDD.
