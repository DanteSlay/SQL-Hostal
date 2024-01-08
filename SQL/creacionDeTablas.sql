create table calendario
(
    fecha     date         not null
        primary key,
    año       int          null,
    mes       int          null,
    dia       int          null,
    temporada varchar(255) null
);

create table hostal
(
    ID_hostal int          not null
        primary key,
    nombre    varchar(255) null,
    telefono  varchar(9)   null
);

create table direccion
(
    ID_hostal int          not null,
    direccion varchar(255) null,
    ciudad    varchar(255) null,
    pais      varchar(255) null,
    constraint direccion_hostal_null_fk
        foreign key (ID_hostal) references hostal (ID_hostal)
);

create table habitacion
(
    ID_habitacion  int        not null
        primary key,
    ID_hostal      int        not null,
    num_habitacion int        not null,
    num_personas   int        not null,
    estado         tinyint(1) not null,
    constraint habitacion_hostal_null_fk
        foreign key (ID_hostal) references hostal (ID_hostal)
);

create table habitaciones_reservadas
(
    fecha         date not null,
    ID_habitacion int  not null,
    primary key (fecha, ID_habitacion),
    constraint foreign_key_fecha
        foreign key (fecha) references calendario (fecha),
    constraint habitaciones_reservadas_habitacion_null_fk
        foreign key (ID_habitacion) references habitacion (ID_habitacion)
);

create table pago
(
    tipo_pago varchar(255) not null
        primary key
);

create table precio
(
    ID_precio     int auto_increment
        primary key,
    precio        double not null,
    ID_habitacion int    null,
    constraint foreign_key_name
        foreign key (ID_habitacion) references habitacion (ID_habitacion)
);

create table usuario_registrado
(
    ID_usuario int          not null
        primary key,
    email      varchar(255) null,
    password   varchar(16)  null
);

create table reserva
(
    ID_reserva     int auto_increment
        primary key,
    ID_usuario     int            not null,
    ID_habitacion  int            not null,
    inicio_reserva date           not null,
    fin_reserva    date           not null,
    pago           varchar(255)   not null,
    precio_total   decimal(10, 2) null,
    constraint fecha_fin_fk
        foreign key (fin_reserva) references habitaciones_reservadas (fecha),
    constraint fecha_inicio__fk
        foreign key (inicio_reserva) references habitaciones_reservadas (fecha),
    constraint habitacion_fk
        foreign key (ID_habitacion) references habitacion (ID_habitacion),
    constraint reserva_pago_null_fk
        foreign key (pago) references pago (tipo_pago),
    constraint usuario_fk
        foreign key (ID_usuario) references usuario_registrado (ID_usuario)
);
