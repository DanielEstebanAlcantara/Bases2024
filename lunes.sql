----------------------------------------------------------
-------------------- ESPACIO PARA COMPARTI CODIGO
------------------------ BD SEM 2024-1 --------------------



/*

LENGUAJE DE CONTROL DE DATOS
BASE DE DATOS GRUPO: 02
SEMESTRE 2024-1

*/




--1 El primer paso es crear un inicio de sesión, crear el inicio de sesión admonSQL:
--a.	Crear el login

USE master --use para abrir una base de datos
GO



-- crear el login login_numcta con password 123456*
CREATE LOGIN login_89000546 WITH PASSWORD='123456*', DEFAULT_DATABASE=master, CHECK_EXPIRATION=OFF, 
CHECK_POLICY=OFF
GO



--2)	Crear una base de datos llamada empresa_numcta y la tabla alumno

create database empresa_89000546
go


-- abrir la base de datos

use empresa_89000546
go

create table alumno
( numCuenta numeric(10) primary key,
   paterno varchar(30),
   materno varchar(30) null,
   nombre varchar(30)
)

select * from alumno

insert into alumno
values(9134567870, 'RUIZ2', null, 'JULIAN2')

select * from alumno


--3)	Conectarse con el login login_numcta, intentar hacer un select a la tabla alumno

use empresa_89000546
go

select * from alumno


----	Crear el ususario en la base de datos

use empresa_89000546
go

create user login_89000546 for login login_89000546
go



--4) otorgar permisos de consulta al usuario login_numcta, nuevamente hacer select


grant select on alumno to login_89000546;
go


--nuevamente dar select a la tabla alumno


-- 5) conceder el permiso de crear tablas a login_numcta


USE empresa_89000546
GO
GRANT ALTER ON Schema :: DBO TO login_89000546
GRANT CREATE TABLE TO login_89000546
GO


-- 6) crear la tabla color con el usuario login_numcta, verificar


create table color
( numCuenta tinyint primary key,
   color varchar(30))


-- 7) quitar el privilegio de hacer consultas, verifique

--revoke select on alumno to login_89000546;

use [empresa_89000546]
GO
DENY CONTROL ON [dbo].[alumno] TO [login_89000546]
GO


--8)	Agregar al login login_numcta el privilegio de crear usuarios


ALTER SERVER ROLE securityadmin ADD MEMBER login_89000546
GO


--9)	Conectarse con el inicio de sesión admonSql y crear el login usu<INICIALES> indicando que su contraseña debe cambiar en su primera sesión


CREATE LOGIN usuMLP WITH PASSWORD = '123456*'
    MUST_CHANGE, CHECK_EXPIRATION = ON;
GO

-- 10) Conectarse con el usuario usu<INICIALES> ¿qué sucede?


-- 11) Cambie la contraseña del usuario usu<INICIALES> (conectado con SQLADMON )

USE master
GO
ALTER LOGIN usuMLP WITH PASSWORD='12345abc$'
GO

-- 12) Conéctate a SQL con el login [usu<INICIALES>] y revisa desde el explorador de objetos lo que tiene la base de datos creada en la sesión anterior



-- l3) Agrega el login [usu<INICIALES>] a la base de datos empresa (con el usuario administrador)

USE empresa_89000546
GO
CREATE USER usuMLP FOR LOGIN usuMLP WITH DEFAULT_SCHEMA=dbo

-- 14) conéctate con el usuario [usu<INICIALES>], revise los objetos de la base de datos mediante el explorador de objetos


--15)	Eliminar el usuario usuMLP


USE master
GO
DROP LOGIN usuMLP
GO


--16. Conéctate con el usuario admonSql y crear la base de datos <iniciales>bd02, analizar qué sucede

CREATE DATABASE mlpbd02 /*comentario */
go

/*17. Conéctarse con el usuario de Windows y darle privilegios de crear bases de datos  al usuario admonSql */


ALTER SERVER ROLE dbcreator ADD MEMBER adminSql
GO


--18. Conéctate con el usuario admonSql y crear la base de datos <iniciales>db02, ¿qué sucede?

CREATE DATABASE mlpbd02


/*19. Revoque el privilegio de crear usuarios al usuario admonSQL con el usuario administrador 
(Windows o el SA) */

ALTER SERVER ROLE securityadmin DROP MEMBER admonSql
GO

--19.1 comprobar


--------------------------------
--------Roles. 
----------------------------------


-- 20. Conéctate con el usuario de Windows o el sa y cree las tablas catalogo y persona en la base de datos mlpbd02


USE mlpbd02
GO

CREATE TABLE catalogoColor(
	idConsecutivo int IDENTITY(1,1) NOT NULL primary key,
	descripcion varchar(50) NULL
) 

GO


CREATE TABLE persona(
	idConsecutivo int IDENTITY(1,1) NOT NULL primary key,
	paterno varchar(50) NULL,
	materno varchar(50) NULL,
	nombre varchar(50) NULL
) 
GO


--21. Crear el rol catalogo en la base de datos y agregar los privilegios de insertar,
-- borrar y actualizar las tablas de catálogos

USE mlpbd02
GO


CREATE ROLE registra
GO

GRANT ALTER ON dbo.catalogoColor TO registra
GO
GRANT DELETE ON dbo.catalogoColor TO registra
GO
GRANT INSERT ON dbo.catalogoColor TO registra
GO

GRANT ALTER ON dbo.persona TO registra
GO
GRANT SELECT ON dbo.persona TO registra
GO
GRANT INSERT ON dbo.persona TO registra
GO

--22. Crea la sesion <iniciales>usu03 con el usuario de Windows

USE master
GO
CREATE LOGIN mlpusu03 WITH PASSWORD='123456', DEFAULT_DATABASE=master, CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

--23. Agrega el login <iniciales>usu03 al rol registra con el usuario de windows

USE mlpbd02
GO
CREATE USER mlpusu03 FOR LOGIN mlpusu03
GO

USE mlpbd02
GO
ALTER ROLE registra ADD MEMBER mlpusu03
GO

--24. Conéctate con el mlpusu03 e Inserta 2 registros en las tablas

USE mlpbd02
GO

insert into catalogoColor
values('ROJO'),
(' AMARILLO')

 
INSERT INTO PERSONA
VALUES('RUIZ', 'JIMENEZ', 'PAOLA'),
('MARTINEZ','JUAREZ','ROGELIO')

--25. Visualiza los registros insertados

select * from catalogoColor
select * from persona


--26. Analizar que sucede



--27. Conéctate con el usuario admonSql, revisa la base de datos mlpbd02, que sucede y por qué?


----------------------------------------------------------------------------------------------
-------------------------------------- DDL ---------------------------------------------------
--------------------------- FECHA 13 DE OCTUBRE DE 2023 -------------------------------------
---------------------------------------------------------------------------------------------

/*

AUTOR: MARTHA LÓPEZ PECLASTRE
DESCRIPCION: CREACIÓN DE  UNA BASE DE DATOS. SEM 2024-1
FECHA: 13 DE OCTUBRE DE 2023
 */


/* 
 * TABLE: BECARIOS 
 */


 --Actividad 1. Cree la base de datos en el manejador
 -- Crear la base de datos INICIALES_EMPRSA24_1

 create database [MLP_EMPRESA24_1]
 go

 USE MLP_EMPRESA24_1
 GO


 -- CREACION DE ESQUEMAS

 -- Se crean los esquemas
CREATE SCHEMA proyecto
go

CREATE SCHEMA trabajador
go

CREATE SCHEMA facturacion
go

create schema catalogo
go

 --CREACIÓN DE TABLAS


 
/* 
 * TABLE: EMPLEADO 
 */

CREATE TABLE trabajador.empleado(
    id_empleado      smallint       NOT NULL identity (1,1),
    paterno          varchar(40)    NOT NULL,
    materno          varchar(40)    NULL,
    nombre           varchar(40)    NOT NULL,
    curp             char(18)       NOT NULL,
    correo           varchar(70)    NULL,
    fecha_ingreso    date           NULL,
    tipo_empleado    char(1)        NOT NULL constraint ck_tipoEmpleado check (tipo_Empleado in ('D','B')),
    CONSTRAINT pk_empleado PRIMARY KEY CLUSTERED (id_empleado)
)
go

--- Actividad 2. Ver la estructura de las tablas

	EXEC sp_help [trabajador.empleado] -- Se usan corchetes por los esquemas

/* 
 * TABLE: PUESTO 
 */

CREATE TABLE catalogo.puesto(
    id_puesto      tinyint        NOT NULL CONSTRAINT PK2 PRIMARY KEY CLUSTERED (id_puesto),
    descripcion    varchar(60)    NOT NULL,
    sueldo         money          NOT NULL,
)
go

/* 
 * TABLE: DEFINITIVO 
 */

 -- constraints de tabla

CREATE TABLE trabajador.definitivo(
    id_empleado        smallint    NOT NULL,
    id_empleadoJefe    smallint    NULL,
    antiguedad_años    tinyint     NOT NULL,
    id_puesto          tinyint     NOT NULL,
    CONSTRAINT pk_definitivo PRIMARY KEY CLUSTERED (id_empleado), 
    CONSTRAINT fk_con_empleado FOREIGN KEY (id_empleado) REFERENCES trabajador.EMPLEADO(id_empleado),
    CONSTRAINT fk_recursiva FOREIGN KEY (id_empleadoJefe) REFERENCES trabajador.DEFINITIVO(id_empleado),													
    CONSTRAINT fk_con_puesto FOREIGN KEY (id_puesto) REFERENCES catalogo.PUESTO(id_puesto)
)



/* 
 * TABLE: BECARIOS 
 */

-- constraint de columna
CREATE TABLE trabajador.becarios(
    id_empleado               smallint    NOT NULL CONSTRAINT pk_becarios PRIMARY KEY CLUSTERED (id_empleado),
    id_Empleado_supervisor    smallint    NOT NULL CONSTRAINT fk_supervisor FOREIGN KEY (id_empleado) REFERENCES trabajador.EMPLEADO(id_empleado),
	                                               CONSTRAINT fk_con_empleado FOREIGN KEY (id_Empleado_supervisor) REFERENCES trabajador.DEFINITIVO(id_empleado), --error por el nombre
    perfil                    char(1)     NOT NULL ,
    fecha_termino             date         NULL,
    
)
go


/* 
 * TABLE: DIA_Festivo 
 */

CREATE TABLE catalogo.diaFestivo(
    id_dia    smallint    identity (1,1) primary key,
    fecha     date        NOT NULL
)
go


/* 
 * TABLE: PROYECTO 
 */

CREATE TABLE proyecto.proyecto(
    i_proyecto        smallint         CONSTRAINT pk_proyecto PRIMARY KEY CLUSTERED (i_proyecto),
    nombre            varchar(90)       NOT NULL,
    costo             money             NOT NULL,
    duracion          tinyint           NOT NULL,
    acronimo          varchar(10)       NOT NULL constraint ak_acronimo unique,
    fecha_inicio      date              NOT NULL,
    feha_fin          date              NOT NULL,
    total_pagado  decimal(12, 3)    NOT NULL,
    id_empleado       smallint          NOT NULL,
    CONSTRAINT fk_empleado_dirige FOREIGN KEY (id_empleado) REFERENCES trabajador.EMPLEADO(id_empleado)
)
go



/* 
 * TABLE: EMPLEADO_PROYECTO 
 */

CREATE TABLE proyecto.empleado_proyecto(
    id_empleado    smallint       NOT NULL,
    i_proyecto     smallint    NOT NULL,
    CONSTRAINT pk_empleado_proyecto PRIMARY KEY CLUSTERED (id_empleado, i_proyecto), 
    CONSTRAINT fk_con_empleado_p FOREIGN KEY (id_empleado) REFERENCES trabajador.EMPLEADO(id_empleado)
																ON DELETE CASCADE
		                                                      ON UPDATE CASCADE,
    CONSTRAINT fk_con_proyecto FOREIGN KEY (i_proyecto) REFERENCES proyecto.PROYECTO(i_proyecto)
														ON DELETE CASCADE
		                                                      ON UPDATE CASCADE
)
go

/* 
 * TABLE: PAGOS 
 */

CREATE TABLE proyecto.PAGOS(
    i_proyecto    smallint    NOT NULL,
	id_pago       tinyint    NOT NULL,
    fecha         date           NOT NULL,
    cantidad      money          NOT NULL,
    CONSTRAINT pk_pagos PRIMARY KEY CLUSTERED (id_pago, i_proyecto), 
    CONSTRAINT fk_de_proyecto FOREIGN KEY (i_proyecto) REFERENCES proyecto.PROYECTO(i_proyecto)
									                          ON DELETE CASCADE
		                                                      ON UPDATE CASCADE
)
go


/* 
 * TABLE: FACTURACION 
 */

CREATE TABLE facturacion.FACTURACION(
    id_Facturacion    smallint      NOT NULL,
    total             money            ,
    subtotal          money            ,
    iva               money            ,
    fecha             date             NOT NULL,
    mes               numeric(2, 0)    NOT NULL,
    id_empleado       smallint         NOT NULL,
    CONSTRAINT pk_facturacion PRIMARY KEY CLUSTERED (id_Facturacion), 
    CONSTRAINT fk_con_definitivo FOREIGN KEY (id_empleado) REFERENCES trabajador.DEFINITIVO(id_empleado)
)
go

/* 
 * TABLE: TARIFA 
 */

CREATE TABLE catalogo.TARIFA(
    id_tarifa       tinyint    NOT NULL identity(1,1),
    tipo_tarifa  char(1)        NOT NULL constraint ck_tipotarifa check (tipo_tarifa in ('F','L')),
    costo            money          NOT NULL,
    CONSTRAINT pk_tarifa PRIMARY KEY CLUSTERED (ID_TARIFA)
)
go


/* 
 * TABLE: LLAMADA 
 */

CREATE TABLE facturacion.LLAMADA(
    id_llamada          int               NOT NULL identity (1,1),
    ID_TARIFA           tinyint           NOT NULL,
    fecha_horainicio    datetime          NOT NULL,
    fecha_horafin       datetime          NOT NULL,
    duracion       numeric(2, 0)          NULL,
    costo               money             NULL,
    numeroTelefonico    numeric(10, 0)    NOT NULL,
    id_dia              smallint          NULL,
    id_Facturacion      smallint          NULL,
    CONSTRAINT pk_llamada PRIMARY KEY CLUSTERED (id_llamada), 
    CONSTRAINT fk_con_tarifa FOREIGN KEY (ID_TARIFA) REFERENCES catalogo.TARIFA(ID_TARIFA),
    CONSTRAINT fk_con_diafestivo FOREIGN KEY (id_dia) REFERENCES catalogo.DIAFestivo(id_dia),
    CONSTRAINT fk_con_facturacion FOREIGN KEY (id_Facturacion) REFERENCES facturacion.FACTURACION(id_Facturacion)
)
go




--cambiar el nombre a una tabla
EXEC sp_rename 'proyecto.empleado_proyecto', 'proyecto.empleadoProyecto';

-- BORRAR UNA TABLA

DROP TABLE proyecto.proyecto


-- CONSULTAR EL DICCIONARIO DE DATOS


select * from sys.key_constraints
where type='pk'

select distinct type from sys.key_constraints

select * from sys.key_constraints
where type='uq'


select * from sys.foreign_keys

select * from sys.check_constraints
where parent_object_id=OBJECT_ID('catalogo.tarifa');

select * from sys.default_constraints


-----------------------------------------------------------------
------------------ ejercicios DDL ---------------------------------
--------------------------------------------------------------------

----Ejercicio 3. Agrega a la tabla empleado las siguientes columnas:
---a) genero CARACTER DE 1 y solo acepta H-hombre, M-mujer (CK_GENERO)
---b) TELEFONO carácter de 10 y que solo acepte 10 dígitos del 0 al 9 (CK_TELEFONO)
---c) coloque el campo CURP como clave candidata (UK_CURP)
---d) horario varchar(50) NOT NULL
--Maya Navarro Ángel Iván
--Maldonado Martínez Miguel
ALTER TABLE trabajador.empleado
ADD genero    char(1)        NULL constraint ck_genero check (genero in ('H','M')),
	 telefono  char(10)        NULL constraint ck_telefono check (telefono in (0,1,2,3,4,5,6,7,8,9)),
	 horario varchar(50)	NOT NULL

ALTER TABLE trabajador.empleado
ADD CONSTRAINT UK_CURP UNIQUE (curp)


--4.Para el campo sueldo de la tabla puesto cree el constraint necesario para que el monto sea
--   mayor que 15000 y menor que 80000 (ck_PagoPermitido)
-- Brothers Radilla José Francisco
ALTER TABLE catalogo.puesto ADD CONSTRAINT ck_PagoPermitido check (sueldo BETWEEN 15000 AND 80000)

--5. Cree la columna apodo varchar(20) a la tabla empleado
ALTER TABLE trabajador.empleado 
ADD apodo varchar(20)  NULL

--5. Cree la columna apodo varchar(20) a la tabla empleado
--TRIGUEROS LOPEZ HECTOR ADRIAN
ALTER TABLE trabajador.empleado
ADD apodo varchar(20);

--6. Cree el índice no cluster para el campo apodo de la tabla empleado
--Guzmán Mondragón Jesús Rodolfo
CREATE NONCLUSTERED INDEX idx_apodo
ON trabajador.empleado(apodo);


--ACTIVIDAD 7 Y 8---
--Méndez Costales Luis Enrique--
--Machorro Villa Marco Antonio--
--7.Crear el campo numempleado char(5) a la tabla definitivo NOT NULL
--8. Crear un índice al campo numempleado del subtipo definitivo para validar la unicidad
--(idx_ak_numempleado)

ALTER TABLE trabajador.definitivo 
ADD numEmpleado char(5) NOT NULL 

--ALTER TABLE trabajador.definitivo
CREATE UNIQUE NONCLUSTERED INDEX idx_ak_numempleado 
ON trabajador.definitivo(numEmpleado);

--9. Cambie el tamaño de la columa apodo de la tabla trabajador a 50.
-- Martinez Perez Jaime Miguel

ALTER TABLE trabajador.empleado
ALTER COLUMN apodo varchar(50)

--10 Agregue a la tabla puesto los campos vigente bit, nivel char(1)
--Pérez Uribe José Alberto
ALTER TABLE puesto

ADD vigente bit,

    nivel char(1);
    
---------------------------------------------------------------------------------------------------

--11 Agregue a la tabla puesto el constraint ck_nivelpuesto, que valide los posibles valores permitidos D-directivo, S-supervisores, C-comunes
--Rosas Hernandez Nahim 
--Miranda González José Francisco 
ALTER TABLE catalogo.puesto ADD constraint ck_nivelPuesto check (nivel in ('D','S','C')) -- constrain de tabla


-- A partir de aquí sig con la maestra xD

---- 12 
insert into catalogo.diaFestivo 
values('2023-01-01')


-- Verificar el valor actual
DBCC CHECKIDENT('catalogo.puesto', NORESEED)
go

-- Modificar el valor a 10 (se reinicia en 10)
DBCC CHECKIDENT('catalogo.puesto', RESEED, 10)
go

insert into catalogo.diaFestivo 
values('2023-15-01')-- falla pq el mes 15 no es correcto 
DBCC CHECKIDENT('catalogo.puesto', NORESEED)
go-- el valor del identity sería 2 pq es la segunda vez que se trata de ingresar 
-- si se inserta una tercera vez entonces sera 3

-- Modificar el valor a 10 (se reinicia en 10)
DBCC CHECKIDENT('catalogo.diaFestivo', RESEED, 10)
go-- debe reiniciar en 10 

insert into catalogo.diaFestivo 
values('2023-03-01')-- deberia haber tres registros al ingresar este contando el resset 


-----------------------------------------------------------------------------------------------------
-- Ejercicio 13
-- MENDOZA GONZALEZ MARIO
create table trabajador.domicilio(
    idempleado SMALLINT CONSTRAINT pk_domicilio PRIMARY key CLUSTERED (idempleado),
                         CONSTRAINT fk_empleadoDomicilio FOREIGN key (idempleado) REFERENCES trabajador.empleado(id_empleado) on DELETE CASCADE,
    calle VARCHAR(40) constraint df_calle default 'DOMICILIO CONOCIDO',
    colonia varchar(50) null,
    numero varchar(35) null,
    alcaldia VARCHAR(40) null,
    tipo char(1) CONSTRAINT ck_tipo_domicilio CHECK (tipo in ('P', 'R'))
);
    
------------------------------------------------------------------------------------------------------
--14 En la tabla puesto agregue el valor por default (DF_parentescoVigente) vigente en 1
--León Ruiz Eduardo
ALTER TABLE catalo.PUESTO 
ADD CONSTRAINT DF_parentescoVigente DEFAULT '1' FOR vigente;

------------------------------------------------------------------------------------------------------

--15. Borrar el constraint DF_parentescoVigente de la tabla puesto
ALTER TABLE catalo.puesto DROP CONSTRAINT DF_parentescoVigente;


------------------------------------------------------------------------------------------------------
--Actividad 16. Modifique la columna correo de la tabla empleado a obligatoria
-- Monter González Luis Enrique
-- indica qué tabla se va a modificar
alter table trabajador.empleado

--indica que columna de esa tabla se va a modificar
alter column correo varchar(70)  not null;  
-- error sería alter column correo  not null; -- se necesita el tipo de dato al cambairlo 
------------------------------------------------------------------------------------------------------
/*
    17) Agregue la columna fecha de nacimiento y edad a  la tabla empleado con tipo 
    de dato date y char de 2 respectivamente ambos opcionales los valores de dominio 
    de edad son del 0 al 9}
     -- enunciado que puede estar en el examen 
    
    Beltrán Hernández Nathan
*/
------------------------------------------------------------------------------------------------------

alter table trabajador.empleado
add fechaNacimiento date null

alter table trabajador.empleado
add edad char (2)  null CHECK (edad IS NULL OR edad BETWEEN '0' AND '9');

------------------------------------------------------------------------------------------------------
--Actividad 18. Borrar la columna genero de la tabla empleado
-- Melchor Flores Daniel
alter table trabajador.empleado DROP CONSTRAINT ck_genero; -- primero borrar check en el hijo

alter table trabajador.empleado
drop column genero;
/*
19.- Agregue la columna genero char(1) con el constraint ck_genero ('M','H')
Vazquez Apolonio Armando
*/
ALTER TABLE trabajador.empleado ADD genero char(1) CONSTRAINT ck_genero check(genero in ('M','H'))--Vazquez Apolonio Armando.

--------------------------------------------------------------------------

--ACTIVIDAD 20. Crea índice a la tabla empleado para los apellidos (idx_apellidos)
--Sanchez Diaz Daniel
CREATE INDEX idx_apellidos
ON trabajador.empleado(paterno,materno);-- En el índice se debe tener en cuenta la estructura del indice 

--EJERCICIO 21
--------------------------------------------------------------------------
--Crea índice (idx_puesto) a la tabla definitivo del puesto
--RICARDO DIAZ

CREATE INDEX idx_puesto ON 
catalogo.puesto(descripcion);-- hacerlo con la descripción
-- No cluster 

--------------------------------------------------------------------------
--EJERCICIO 22 
--Crear Tabla Dependiente como entidad débil
--por existencia de empleado definitivo
--con constraints de tabla
--Vazquez Muñoz 
--Munguia Lopez 
CREATE TABLE Dependiente (
  id_dependiente tinyint, nombre varchar (30),
  paterno varchar (30),
  materno varchar (39), 
  id _empleado smallint not null, 
  CONSTRAINT fk_id_empleado foreign key (id_empleado)
  REFERENCES trabajador empleado (id _empleado),
  CONSTRAINT pk_id _dependiente primary key (id_empleado, id_dependiente)
  );
  
-----------------------------------------------  
 ---- Ejercicio 23 
 -- crear la columna adeudoC persistente que obtenga la diferencia (costo-total_pagado)
 -- Ponce Diez Marina Raymundo
ALTER TABLE proyecto.proyecto ADD
adeudoC  as (costo - total_pagado) PERSISTED; 

-----------------------------------------------  
--EJERCICIO 24.
/*
Implementa histórico de puestos que han tenido los empleados definitivos, bajo el
esquema:
trabajador.historio_puesto={id_hostorico smalllint, id_puesto tinyint(fk), fecha_de date,
fecha_hasta date null}
nota: el indice de la pk como NONCLUSTERED
*/
--PAOLA AGUILAR GARCÍA.
--KARLA SOFÍA ROSALES VIGIL.
CREATE TABLE historico_puesto
(
    id_historico       smallint   NULL,
    fecha_de  date   NOT NULL,
	fecha_hasta date NULL,
	id_puesto tinyint NOT NULL, 
	CONSTRAINT fk_ca FOREIGN KEY (id_puesto) REFERENCES catalogo.puesto(id_puesto)
	                                                
)
go

---Actividad 24: implementar historico
/*
Implementa histórico de puestos que han tenido los empleados definitivos, bajo el
esquema:
trabajador.historio_puesto={id_hostorico smalllint, id_puesto tinyint(fk), fecha_de date,
fecha_hasta date null}
nota: el indice de la pk como NONCLUSTERED
*/
---Gullén Luna Adair isaí
---Medrano Miranda Daniel Ulises

begin tran
	CREATE TABLE trabajador.historico_puesto(
		id_historico	smallint	not null,
		id_puesto		tinyint		not null,
		fecha_desde		date		not null,
		fecha_hasta		date		null,
		id_empleado		smallint    not null,
		CONSTRAINT pk_historico PRIMARY KEY NONCLUSTERED (id_historico), 
		CONSTRAINT fk_puesto    FOREIGN KEY (id_puesto) REFERENCES catalogo.puesto(id_puesto),
		constraint fk_definitvo foreign key (id_Empleado) references trabajador.definitivo (id_empleado),
	)

commit tran	

-- DROP TABLE trabajador.historico_puesto --pq se hizo mal al principio


/* 	
		25. Crear la tabla parentesco en el esquema catalogo bajo el siguiente esquema
		PARENTESCO={idParentesco tintyint (pk), descripcion varchar(45)}
		Lara Aguilar Christian Abraham
*/
CREATE TABLE catalogo.parentesco(
	idParentesco	tinyint	NOT NULL identity(1,1),-- no más de 250 parentescos 
	descripcion	varchar(45)	NOT NULL
	CONSTRAINT pk_parentesco PRIMARY KEY CLUSTERED (idParentesco)
)
go

/* 26. Implemente la relación entre parentesco y la tabla dependiente (on delete cascade)
	
*/
--- CREAR EN DEPENDIENTE EL ATRIBUTO QUE RECIBE LA KF
ALTER TABLE dependiente
add column idParentesco tinyint NOT NULL 



/*27 Borrar la tabla parentesco
Moreno Ramos Eduardo Jair*/

--borrar el constraint
alter table dependiente drop constraint fk_parentesco;
  
DROP TABLE catalogo.parentesco-- pero spriemro se tiene que quitar el constraint con el que hace eferencia 


-- volver a crear el constraint (crear tabla y despues agregar constraint )
ALTER TABLE dependiente ADD CONSTRAINT fk_parentesco FOREIGN KEY (idParentesco)REFERENCES catalogo.parentesco(id_parentesco) ON DELETE CASCADE;


--- Para el diagrama solo tomar captura



