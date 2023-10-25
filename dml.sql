
/*
Insert 
    -encabezados
    -sin encabezado
    -select 

Update 
    -select
    -where

Delete
    Para borar indformación 
    - where
<- Deben de ir en una transacción : se ejecuta bien todo o no se ejecuta nada, se usan para cuidar integridad de los datos
    --empiezan:
    begin tran

    --terminan:
    rollback o commit

*/


--------------------------------------------------------------------------------------------------------
------------------------     EJERCICIOS DML  -----------------------------------------------------------
--1.	Inserte 5 registros en las tablas: puesto, días festivos y tarifas con encabezado (profesora)

--1. Inserte 5 registros en las tablas: puesto, carreras y concepto con encabezado 



--puesto
EXECUTE sp_help [catalogo.puesto]
-- No tiene un identity, por lo que la pk no se calclará sola


-- Obteniendo la llave primaria (secuencia numerica)

select max(id_puesto)+1 from catalogo.PUESTO-- REGRESA EL MAXIMO VALOR QUE SE ENCUENTRA EN LA COLUMNA 

SELECT MAX(id_puesto)+1 FROM CATALOGO.puesto-- No le puede sumar nada en algo dónde no hay nada si es que no hay nada en la tabla

SELECT 	ISNULL(MAX(id_puesto)+1, 10) FROM catalogo.puesto-- si no es nulo sumale 1, si es nulo sumale 10
-- para calcular de manera automática el consecutivo



BEGIN TRAN
	
	select * from catalogo.PUESTO
	insert into catalogo.puesto (id_puesto, descripcion, vigente, nivel, sueldo)
	values (1,'DBA',1,'A',45000),  --marca error por qué?
	(2, 'JEFE DE UNIDAD',1,'J',79000) -- marca error por el check poner C,S, D

	select * from catalogo.puesto

ROLLBACK TRAN

EXECUTE sp_help [catalogo.puesto]


select * from catalogo.puesto

BEGIN TRAN
    /*
    Ingresar estos registros 
    */
	insert into catalogo.puesto (id_puesto, descripcion, vigente, nivel, sueldo)
	values (1, 'DBA',1,'S',45000),  --correjido
	(2, 'JEFE DE UNIDAD',1,'D',69000), -- correjido
	(3, 'TESTER',1,'C',28000),
	(4, 'PROJECT MANAGER',1,'S',50000),
	(5, 'DESARROLLADOR SENIOR',1,'C',35000),
	(6, 'ANALISTA DE BD',1,'C',30000)
	select * from catalogo.puesto

COMMIT TRAN

--VERIFICAMOS
select * from catalogo.puesto


-- Obteniendo la llave primaria (secuencia numerica)

--(esto no lo ejecute)

select max(id_puesto)+1 from catalogo.PUESTO

SELECT MAX(id_puesto)+1 FROM CATALOGO.puesto

SELECT 	ISNULL(MAX(id_puesto)+1, 10) FROM catalogo.puesto



begin tran
    -- con isnull se manda la pk 
	insert into catalogo.puesto -- crea el 7
	 SELECT ISNULL(MAX(id_puesto)+1,1), 'JEFE DE AREA', 16000, 1, 'S' 
	 FROM catalogo.puesto
     -- se utiliza el ISNULL pq no se sabría si tiene ya algún registro, se supone que es nuevo no debería tener registros, es recomendable ponerlo


	insert into catalogo.puesto -- crea el 8
	 SELECT max(id_puesto)+1, 'GERENTE',60000, 1, 'D' 
	 FROM catalogo.puesto 

	insert into catalogo.puesto 
	 SELECT ISNULL(MAX(id_puesto)+1,1), 'DESARROLLADOR WEB',15000, 1, 'C' 
	 FROM catalogo.puesto 

	 	 select * from catalogo.puesto

--rollback tran
commit tran


--------------------------------------

-- insertar 8  dias festivos sin encabezados

/*
Este si tiene un identity por lo que la pk se ingresará automaticamente 
*/


execute sp_help[catalogo.diafestivo]

insert into catalogo.diaFestivo(fecha)
values ('2023/02/05'), 
		('2023/05/01'), 
		('2023/05/05'), 
		('2023/05/10'), 
		('2023/05/15'), 
		('2023/09/15'),
		('2023/09/16'),
		('2023/10/02')

select * from catalogo.diaFestivo


------------------------------------
-- INSERTANDO LAS TARIFAS 
-------------------------------


exec sp_help 'catalogo.tarifa'

select * from catalogo.TARIFA


insert into catalogo.tarifa(tipo_tarifa, costo)
values ('L', 2), ('F',5)


--2.	Insertar 6 registros en la tabla empleado (profesora)


/*




*/

EXECUTE sp_help [trabajador.empleado]

--ALTER TABLE trabajador.empleado alter column horario varchar(50) NULL -- cambiar que horario sea null 
ALTER TABLE TRABAJADOR.EMPLEADO
ALTER COLUMN HORARIO VARCHAR(50) NULL

--- INSERTANDO LOS EMPLEADOS DEFINITIVOS
    -- curp no pueden ser iguales 
    -- ingresar el primer registro
	insert into trabajador.empleado (nombre, paterno, materno, curp, correo, tipo_empleado, fechaNacimiento, horario, telefono, fecha_ingreso, edad, genero, apodo)
	values 	('MIGUEL','ESTRELLA', 'RICO', 'LANH920113D3NER78I', 'ricorico@yahoo.com','D', '05-12-1992', 'LUNES A VIERNES', NULL, NULL, NULL, 'H',  NULL)
    -- hacer un primer select 

	insert into trabajador.empleado   (nombre, paterno, materno, curp, correo, tipo_empleado, fechaNacimiento, horario, telefono, fecha_ingreso, edad, genero, apodo)
	values ('DANIEL','AVALOS', 'RUIZ', 'AARD920113D3NER78I', 'danyf@gmail.com', 'D', '11-21-1995', 'LUNES A VIERNES', '5', null, 33, 'H', null)  --error en el curp Y TELEFONO

    -- al hacer un insert con error, y después hacer uno correcto, habrá un hueco en el consecutivo (1, 3) el 2 es el del error
select * from trabajador.empleado

-- se cambia el constraint

-- borrar el constraint y después la columna 
alter table trabajador.empleado
drop constraint ck_telefono, column telefono

-- agregar el telefono con el constraint 
alter table trabajador.empleado
add  telefono char(10) constraint ck_telefono check (telefono like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');-- con expresion regular que valide 10 digitos, cada digito del 0 al 9 

--validando el constraint
--se corrige el error
	insert into trabajador.empleado   (nombre, paterno, materno, curp, correo, tipo_empleado, fechaNacimiento, horario, telefono, fecha_ingreso, edad, genero, apodo)
	values ('ROBERTO','ANAYA', 'RUIZ', 'AARR920113D3NER7PA', 'danyf@gmail.com', 'D', '11-21-1995', 'LUNES A VIERNES', '5523456764', null, 33, 'H', null)  

-- REVISANDO LOS IDENTITY

DBCC CHECKIDENT ('trabajador.EMPLEADO', NORESEED);-- para los huecos 
GO 


select * from trabajador.EMPLEADO


DBCC CHECKIDENT ('trabajador.EMPLEADO', RESEED,2);
go


--- INSERTANDO LOS 6
--REVISANDO PUESTOS
--REVISANDO EMPLEADOS

select * from catalogo.PUESTO
select * from trabajador.EMPLEADO


begin tran

  -- analizar posibles errores anotarlos y corregir

	insert into trabajador.empleado (nombre, paterno, materno, curp, correo, tipo_empleado, fechaNacimiento, horario, telefono, fecha_ingreso, edad, genero, apodo)
	values
	( 'ISAAC','FLORES', 'JUAREZ', 'ISDF850423NHRQSD34', 'isaacdf@gmail.com', 'D', NULL, 'LUNES A DOMINGO', '5536889152', NULL, NULL, 'H', NULL),
	('MIGUEL ANGEL','ESQUI', 'RICON', 'EURM920113D3N23DFR', 'ricorico@yahoo.com','D', '05-12-1992', 'VESPERTINO',  NULL,NULL, NULL, 'H', 'CHOKIS'),
	('FLOR','AVALOS', 'RUIZ', 'AARF920113D3MSD45Y', 'danyf@gmail.com', 'D', '05-12-1988', NULL, NULL,  NULL, NULL, 'H',NULL),
	('CESAR','AGRUILAR', 'COLIN', 'AUCC891123JUY78UJN', 'cesar23@gmail.com',  'B', '04-23-1989', NULL, NULL, '05-01-2020',  NULL,'H','GUERO'),
	('XIMENA','ALCANTARA', 'MARROQUIN', 'AAMX800512KIUASD76', 'xime445@gmail.com', 'B', '02-26-1986', NULL, NULL, NULL,NULL, 'M',NULL),
	('ALEJANDRA','BAENA', 'AGUIRRE', 'BAAA880727K87DFR45', 'alba34@gmail.com', 'B', '09-14-1990', 'MATUTINO', '5512829871', '05-01-2020',  NULL,'M','la Chapis'),
	( 'DIEGO','HERNANDEZ', 'BARRON', 'HEBD851128Y7UASW12', 'difg45@gmail.com', 'B', '07-27-1994', NULL, null, NULL,   NULL, 'H','EL REY')
 
   select * from trabajador.empleado

-- rollback tran primero ejecutar con roll back 
 COMMIT TRAN

----------------------------------------


--3.	Registre a los empleados definitivos, los cuales tienen el siguiente curp (ISDF850423NHRQSD34, EURM920113D3N23DFR, AARF920113D3MSD45Y).  (alumnos)
--Aguilar García Paola.
select id_empleado, id_empledoJefe, id_puesto
                                                                                                                                                                                                                                                                                                                                                  
from empleado.definitivo
where id_empleado, id_puesto IS NOT NULL

insert into trabajador.definitivo (CURP, id_empleadoJefe, antiguedad_años, id_empleado, id_puesto)
values ('ISDF850423NHRQSD34', NULL, 3, 34567, 'JEFE DE UNIDAD'),
	( 'EURM920113D3N23DFR', 1, 2, 78162, 'PROJECT MANAGER'),
	( 'AARF92011303MSD45Y', 1, 3, 33091, 'DESARROLLADOR SENIOR');

--4.	Registre a los empleados becarios, los perfiles son A-analista, D-desarrollador, B-bases de datos. (CESAR AGRUILAR COLIN, XIMENA ALCANTARA MARROQUIN, ALEJANDRA BAENA AGUIRRE)
--Alcantara Paleo Daniel Esteabn


select id_empleado from trabajador.EMPLEADO 
where nombre = 'DANIEL' AND paterno = 'AVALOS' AND materno = 'RUIZ';

insert into trabajador.becarios(paterno, materno, nombre, perfil, fecha_termino )
values ('AGUILAR', 'COLIN', 'CESAR', 'A', NULL),
	('ALCANTARA', 'MARROQUIN', 'XIMENA', 'D', NULL),
	('BAENA', 'AGUIRRE', 'ALEJANDRA', 'B', NULL);
select * from trabajador.becarios;


--5.	Inserte para los primeros 5 empleados su domicilio
--Beltrán Hernández Nathan
insert into trabajador.domicilio (calle, numero, colonia, tipo)
values (NULL, 67, 'CARRILLO', 'P'),
		('CALLE 10', 345, 'JUAREZ', 'R'),
		('MIGUEL DOMINGUEZ', 876, 'EL ROSEDAL', 'P'),
		('JUAN ESCUTIA', 546, 'MORA', 'R'),
		('TECNICOS', 1009, 'EL ROSEDAL', 'R');

select * from trabajador.domicilio

--6.	Los empleados con id menor o igual a tres son de COYOACAN, el resto son de la IZTAPALAPA, refleje los cambios en la base de datos (alumnos) (UPDATE)
-- Brothers Radilla José Francisco
update trabajador.domicilio
set alcaldia = 'COYOACAN'
where idempleado <= 3

update trabajador.domicilio
set alcaldia = 'IZTAPALAPA'
where idempleado > 3

--7.	Registre 6 empleados con encabezados, 4 con el apodo que inicie con la letra 'E' y 2 con el apodo 'EL PUAS', tester, desarrolladores y analistas. (alumnos). Los valores a insertar son:
--Cortez Rios Enrique Yoab
ALTER table trabajador.empleado
add fechaNacimiento date not null;
ALTER table trabajador.empleado
add edad smallint null;

BEGIN TRAN
INSERT INTO trabajador.empleado (nombre, paterno, materno, curp, correo, tipo_empleado, genero, apodo, fechaNacimiento, edad, horario)
values ('SONIA','ESTRELLA', 'RICOS', 'SOER920113D3NKIJ34', 'soñaer@yahoo.com', 'D', 'M','ESTRELLA', '1992-06-12',45,'matutino'),
	   ('LUIS','AVALOS', 'COLIN', 'LUAC920113D3NQÑP90', 'luisac@gmail.com', 'D', 'H','EL BUENO','1988-07-12',39,'vepertino'),
	   ('MARCOS','AGRUILAR', 'COLIN', 'MAAC891123JUYQ78IO', 'marcosac@gmail.com', 'D', 'H','EL PUAS', '1989-03-23',NULL,'nocturno'),
	   ('SOFIA','ALCANTARA', 'AGUIRRE', 'SOAA800512KIUSJ897', 'alsofy45@gmail.com', 'B','M','MANIS', '1986-06-26',46,'Medio Tiempo'),
	   ('AURORA','BAENA', 'AGUIRRE', 'AUBA880727K8790LOK', 'aurora74@gmail.com', 'B', 'M','LA CHAPIS', '1990-05-14', 29,'Medio Tiempo'),
	   ('PEDRO','HERNANDEZ', 'JUAREZ', 'PEHJ851128Y7UAS89W', 'juarezph5@gmail.com', 'D', 'H','EL PUAS', '1994-02-27', 52,'Tiempo Completo');

select * from trabajador.empleado
--rollback tran
commit tran

--Insertamos los puestos que tendran los trabajadores
BEGIN TRAN

INSERT INTO catalogo.puesto(id_puesto,descripcion,sueldo)
values(1,'tester', 20000),
	  (2,'desarrollador', 22000),
	  (3,'analista',30000);

--ROLLBACK TRAN
COMMIT TRAN

select*from trabajador.empleado
--Se le inserta el puesto a los trabajadores definitivos
BEGIN TRAN
INSERT INTO trabajador.definitivo(id_empleado,id_puesto,numEmpleado, antiguedad_años)
VALUES (35,1,'23564',1),
	   (36,2,'58946',2),
	   (37,3,'15896',1),
	   (38,2,'45687',1),
	   (39,2,'78956',2),
	   (40,1,'31730',1);
select*from trabajador.definitivo
ROLLBACK TRAN

--8.	SONIA, LUIS Y MARCOS son empleados definitivos y el resto becarios, registre la información con los datos que usted quiera (en definitivos y becarios respectivamente) (alumnos)
--Cruz Cruz Lizbeth 
insert into trabajador.definitivo(id_empleado,id_empleadoJefe,antiguedad_años,id_puesto)
VALUES(1,1,25,'D'),
(2,NULL,15,'D'),
(3,NULL,5,'S');

insert into trabajador.becarios (id_empleado,id_Empleado_supervisor,perfil,fecha _termino)
VALUES(5,NULL,'A','2024-06-26'),
(6,NULL,'D','2025-05-14'),
(7,7,'B','2024-02-27');


/*insert into trabajador.definitivo(id_empleado,id_empleadoJefe,antiguedad_años,id_puesto,paterno, materno, nombre,edad, fechanacimiento, curp,correo)
VALUES(1,1,25,'D','ESTRELLA','RICOS','SONIA',45,'1992-06-12','SOER920113D3NKIJ34','soñaer@yahoo.com'),
(2,NULL,10,'D','AVALOS','COLIN','LUIS',39,'1992-06-12','LUAC920113D3NQÑP90','luisac@gmail.com'),
(3,NULL,5,'S','AGRUILAR','COLIN','MARCOS',NULL,'1989-03-23',MAAC891123JUYQ78IO','marcosac@gmail.com');

insert into trabajador.becarios(id_empleado,id_Empleado_supervisor,perfil,fecha _termino,paterno, materno, nombre,edad, fechanacimiento, curp,correo)
VALUES(5,NULL,'A','2024-06-26','ALCANTARA','AGUIRRE','SOFIA',46,'1986-06-26','SOAA800512KIUSJ897', 'alsofy45@gmail.com'),
(6,NULL,'D','2025-05-14','BAENA','AGUIRRE','AURORA',29,'1990-05-14','AUBA880727K8790LOK', 'aurora74@gmail.com'),
(7,7,'B','2024-02-27','HERNANDEZ','JUAREZ','PEDRO',52,'1994-02-27','PEHJ851128Y7UAS89W', 'juarezph5@gmail.com');
*/

--9.	Registre en una transacción un empleado definitivo (KARLA MORALES LÓPEZ curPMOLK851128Y7UAS89W) con domicilio en la colonia Juárez de la delegación Benito Juárez y es PROJECT MANAGER (alumnos)
-- Díaz Real Ricardo
INSERT INTO empleado.definitivo (Nombre,paterno, materno,CURP,colonia,delegacion, id_puesto)
VALUES ('KARLA', 'MORALES', 'LÓPEZ', 'MOLK851128Y7UAS89W', 'Juárez', 'Benito Juárez', 'PROJECT MANAGER');

--10.	Registre en una transacción un empleado definitivo con puesto tester y antigüedad de 4 años (alumnos)
ESCUDERO BOHORQUEZ JULIO


--11.	Su jefe le pide almacenar la fecha de término (estimada) de cada proyecto, implemente en la base de datos (alumnos)
--Guillen Luna Adair Isai

alter table proyecto
ADD fechaTermino date, not null 

--12.	Registre los siguientes 5 proyectos en una transacción (alumnos)
-------------------------------------------------------------
--Guzmán Mondragón Jesús Rodolfo
-- Iniciar una transacción
BEGIN TRANSACTION;
-- Insertar los proyectos
INSERT INTO proyecto.proyecto (nombre, costo, duracion, acronimo, fecha_inicio, fecha_fin, total_pagado, id_empleado)
VALUES ('CONTROL DE INVENTARIOS', 150000.00, 7, 'CINV', '2020-01-21', '2020-08-30', 0.00, 1);

INSERT INTO proyecto.proyecto (nombre, costo, duracion, acronimo, fecha_inicio, fecha_fin, total_pagado, id_empleado)
VALUES ('CONTROL DE GESTION', 400000.00, 9, 'CG', '2020-01-15', '2020-10-30', 0.00, 2);

INSERT INTO proyecto.proyecto (nombre, costo, duracion, acronimo, fecha_inicio, fecha_fin, total_pagado, id_empleado)
VALUES ('PAGOS Y NOMINA', 550000.00, 13, 'PYN', '2020-03-20', '2021-04-30', 0.00, 3);

INSERT INTO proyecto.proyecto (nombre, costo, duracion, acronimo, fecha_inicio, fecha_fin, total_pagado, id_empleado)
VALUES ('REGISTRO DE ASISTENCIAS', 380000.00, 11, 'REA', '2020-02-16', '2020-12-15', 0.00, 4);

INSERT INTO proyecto.proyecto (nombre, costo, duracion, acronimo, fecha_inicio, fecha_fin, total_pagado, id_empleado)
VALUES ('LICENCIAS MEDICAS', 600000.00, 18, 'LM', '2020-04-18', '2021-10-18', 0.00, 5);
--se calculo fecha_fin a partir de la fecha_inicio y duracion ya que no puede ser null el dato
-- Confirmar la transacción
COMMIT;
--------------------------------------------------------------------------------------------------------------------------------------------------------
--13.	Inserte 3, 4 y 5 recibos de pago para los proyectos con id 1,2,3, respectivamente, deben sumar más de la mitad del costo de los proyectos (alumnos)
-- Lara Aguilar Christian Abraham

-- Proyecto 1 (3 pagos)
INSERT INTO proyecto.PAGOS (id_proyecto, id_pago, fecha, cantidad)
VALUES 
      (1, 1, '2020-01-21', 30000),
      (1, 2, '2020-02-21', 30000),
      (1, 3, '2020-03-21', 30000);

-- Proyecto 2 (4 pagos)
INSERT INTO proyecto.PAGOS (id_proyecto, id_pago, fecha, cantidad)
VALUES 
      (2, 4, '2020-01-15', 55000),
      (2, 5, '2020-02-15', 55000),
      (2, 6, '2020-03-15', 55000),
      (2, 7, '2020-04-15', 55000);

-- Proyecto 3 (5 pagos)
INSERT INTO proyecto.PAGOS (id_proyecto, id_pago, fecha, cantidad)
VALUES 
      (3, 8, '2020-03-20', 60000),
      (3, 9, '2020-04-20', 60000),
      (3, 10, '2020-05-20', 60000),
      (3, 11, '2020-06-20', 60000),
      (3, 12, '2020-07-20', 60000);

---------------------------------------------------------------------------------------------------------------------------------------------------------

--14.	Registre para cada proyecto al menos 2 empleados y 1 becario, deje 2 empleados sin proyecto asignado y 2 becarios (alumnos)
-- Machorro Villa Marco Antonio
--Duda con los nombres
-- Insertar empleados y asignarlos a proyectos
INSERT INTO empleados (nombre, proyecto_id) VALUES ('SONIA', CONTROL DE
INVENTARIOS);
INSERT INTO empleados (nombre, proyecto_id) VALUES ('LUIS', CONTROL DE
INVENTARIOS);


-- Insertar becarios y asignarlos a proyectos
INSERT INTO becarios (nombre, proyecto_id) VALUES ('Sofia', CONTROL DE
INVENTARIOS);


-- Insertar empleados sin asignar a proyectos
INSERT INTO empleados (nombre) VALUES ('MARCOS');
INSERT INTO empleados (nombre) VALUES ('Miguel');


-- Insertar becarios (alumnos) sin asignar a proyectos
INSERT INTO becarios (nombre) VALUES ('Aurora');
INSERT INTO becarios (nombre) VALUES ('Pedro');

--15.	Inserte para cada empleado al menos 2 puestos utilice fechas posteriores al 01/01/2010 (alumnos)
---Maldonado Martínez MiguelW
INSERT INTO trabajador.historico_puesto (id_historico, id_puesto, fechas_desde,id_empleado)
VALUES(1, 1, '01-01-2010', 1*),
			(2, 3, '01-21-2010', 1*),
			(3, 5, '02-11-2011', 2*),
			(4, 3, '07-15-2011', 2*),
			(5, 4, '06-03-2013', 3*),
			(6, 2, '08-25-2014', 3*),
			(7, 1, '03-16-2010', 4*),
			(8, 3, '01-18-2012', 4*),
			(9, 2, '01-17-2011', 5*),
			(10, 5, '11-21-2013', 5*),
			(11, 1, '05-01-2014', 6*),
			(12, 3, '09-21-2016', 6*);

--16.	Muestre los datos que contiene la tabla empleado ordene por el apodo en orden descendiente (alumnos)
-- Martínez Pérez Jaime Miguel
SELECT * FROM trabajador.empleado
ORDER BY trabajador.empleado.apodo DESC

--17.	Borre el empleado con CURP=’MOLK851128Y7UAS89W’ y verifique el borrado en cascada (alumnos)
--Maya Navarro Ángel Iván
DELETE FROM trabajador.empleado
where id_empleado= (select id_empleadod from trabajador.empleado
                   where curp='MOLK851128Y7UAS89W');
SELECT * FROM trabajador.empleado
--18.	Actualizar el apellido materno a nulo y apodo a 'NUEVO CHAPIS' a los empleados con apodo 'LA CHAPIS' O EMPLEADOS BECARIOS (alumnos)
--- Medrano Miranda Daniel Ulises ---
update trabajador.empleado
set materno = null
where apodo = 'LA CHAPIS' or tipo_empleado = 'B'

update trabajador.empleado
set apodo = 'NUEVO CHAPIS'


--19.	Elimine el domicilio del empleado con CURP ='LANH920113D3NER78A' en una transacción (alumnos)
--- Melchor Flores Daniel---
begin TRANSATCION;
delete from trabajador.domicilio
where idempleado=(select curp from trabajador.empleado
			where curp ='LANH920113D3NER78A');
COMMIT;

--20.	Genere 6 facturas debe tener 4 llamadas en días laborales y 4 en días festivos (alumnos)
--MENDEZ COSTALES LUIS ENRTIQUE 
-- TUVE LA VERDAD MUCHA DUDA SI SI ERA CON SELECT PORQUE NO ME IMAGINABA LA CONSULTA COMO LA ESTA PIDIENDO EL EJERCICIO :(
begin TRANSACTION;
 SELECT ALL facturacion.FACTURACION 
FROM LEMC_EMPRESA24_1 facturacion.FACTURACION
WHERE 
COMMIT;

begin TRANSACTION;
SELECT ALL id_facturacion
FROM facturacion.LLAMADA
WHERE id_dia IN catalogo.diaFestivo.fecha
COMMIT;

INSERT INTO facturacion.FACTURACION 
VALUES 
      (1, 67, 60, 7,'2020-10-25',10,2),
      (2, 27, 20, 7,'2020-09-20',09,2),
      (3, 87, 80, 7,'2020-03-09',03,1);
	  (4, 57, 50, 7,'2020-02-25',02,3),
      (5, 47, 40, 7,'2020-11-20',11,1),
      (6, 107, 100, 7,'2020-03-16',03,3);
	  (7, 24, 17, 7,'2020-11-2',11,1),
      (8, 35, 28, 7,'2020-05-10',03,3);

INSERT INTO catalogo.diaFestivo
VALUES
	(1,'2020-03-09')
	(2,'2020-11-20')	
	(3,'2020-11-2')
	(4,'2020-05-10')


INSERT INTO facturacion.LLAMADA
VALUES
	(1,,2,'2020-10-25 17:05:21.436', '2020-10-25 17:26:07.462', 21, 60, 453872648, NULL,1),
    (2, 2,'2020-09-20 23:45:02.127', '2020-09-20 23:50:02.127', 05, 20, 672398237, NULL,2),
    (3, 3,'2020-03-09 11:36:07.163', '2020-03-09 11:46:07.163', 10, 80, 653287392, 1,1);
	(4, 4,'2020-02-25 15:27:25.723', '2020-02-25 15:37:25.723', 10, 50, 675126393, NULL,3),
    (5, 2,'2020-11-20 18:25:15.231', '2020-11-20 18:50:15.231', 25, 40, 368764762, 2,1),
    (6, 1,'2020-03-16 12:39:07.342', '2020-03-16 12:52:07.342', 13,100, 675383643, NULL,3);
	(7, 2,'2020-11-2 08:33:02.521',  '2020-11-2 08:40:02.521', 07, 17,  865327834, 3,1),
    (8, 3,'2020-05-10 07:36:19.623', '2020-05-10 07:40:19.623', 04,28,  873263789, 4,3);


 
--21.	Registre 10 llamadas, las cuales aún no están facturadas (alumnos)
-- Mendoza González Mario

-- Revisamos la estructura de la tablas
exec sp_help 'facturacion.llamada'
exec sp_help 'catalogo.tarifa'
exec sp_help 'catalogo.diafestivo'

-- Insertamos dos registros en la tabla tarifa
insert into catalogo.tarifa values('L', 5.00)
insert into catalogo.tarifa values('F', 15.00)

-- Insertamos cinco registros en la tabla diafestivo
insert into catalogo.diaFestivo values('2023/10/24')
insert into catalogo.diaFestivo values('2023/11/28')
insert into catalogo.diaFestivo values('2023/11/02')
insert into catalogo.diaFestivo values('2023/11/20')
insert into catalogo.diaFestivo values('2023/12/25')

-- Consultamos las tablas
select * from catalogo.TARIFA
select * from catalogo.diaFestivo

-- Insertamos diez registros en la tabla llamada
insert into facturacion.llamada(ID_TARIFA, fecha_horainicio, fecha_horafin, 
duracion, costo, numeroTelefonico, id_dia, id_Facturacion)
values (1, '2023/10/24 14:30:00', '2023/10/24 14:35:00', 5, 25, 5512345678, 1, null)
insert into facturacion.llamada(ID_TARIFA, fecha_horainicio, fecha_horafin, 
duracion, costo, numeroTelefonico, id_dia, id_Facturacion)
values (1, '2023/10/24 15:30:00', '2023/10/24 15:33:00', 3, 15, 5587654321, 1, null)
insert into facturacion.llamada(ID_TARIFA, fecha_horainicio, fecha_horafin, 
duracion, costo, numeroTelefonico, id_dia, id_Facturacion)
values (1, '2023/11/28 16:30:00', '2023/11/28 16:35:00', 5, 25, 5534567812, 2, null)
insert into facturacion.llamada(ID_TARIFA, fecha_horainicio, fecha_horafin, 
duracion, costo, numeroTelefonico, id_dia, id_Facturacion)
values (1, '2023/11/28 17:30:00', '2023/11/28 17:33:00', 3, 15, 5556347812, 2, null)
insert into facturacion.llamada(ID_TARIFA, fecha_horainicio, fecha_horafin, 
duracion, costo, numeroTelefonico, id_dia, id_Facturacion)
values (2, '2023/11/02 18:30:00', '2023/11/02 18:35:00', 5, 25, 5512783456, 3, null)
insert into facturacion.llamada(ID_TARIFA, fecha_horainicio, fecha_horafin, 
duracion, costo, numeroTelefonico, id_dia, id_Facturacion)
values (2, '2023/11/02 19:30:00', '2023/11/02 19:33:00', 3, 15, 5512783456, 3, null)
insert into facturacion.llamada(ID_TARIFA, fecha_horainicio, fecha_horafin, 
duracion, costo, numeroTelefonico, id_dia, id_Facturacion)
values (2, '2023/11/20 20:30:00', '2023/11/20 20:35:00', 5, 25, 5518273645, 4, null)
insert into facturacion.llamada(ID_TARIFA, fecha_horainicio, fecha_horafin, 
duracion, costo, numeroTelefonico, id_dia, id_Facturacion)
values (2, '2023/11/20 21:30:00', '2023/11/20 21:33:00', 3, 15, 5518273645, 4, null)
insert into facturacion.llamada(ID_TARIFA, fecha_horainicio, fecha_horafin, 
duracion, costo, numeroTelefonico, id_dia, id_Facturacion)
values (2, '2023/12/25 22:30:00', '2023/12/25 22:35:00', 5, 25, 5517283645, 5, null)
insert into facturacion.llamada(ID_TARIFA, fecha_horainicio, fecha_horafin, 
duracion, costo, numeroTelefonico, id_dia, id_Facturacion)
values (2, '2023/12/25 23:30:00', '2023/12/25 23:33:00', 3, 15, 5517283645, 5, null)

-- Consultamos la tabla
select * from facturacion.llamada

--22.	Crea una transacción utilizando puntos de salvado (PROFESORA)

--23.	Inserte 2 llamadas para los primeros 3 empleados (ALUMNOS)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--24.	Registre los parentescos; PADRE, MADRE, ESPOSA (O), HIJO(A), ABUELO(A) (alumnos)
--Autor: Monter González Luis Enrique
begin tran 
	select * from catalogo.parentesco
	
	insert into catalogo.parentesco 
	values ('Padre'),
			('Madre'),
			('Esposa (O)'),
			('Hijo (A)'),
			('Abuelo (A)');

	select * from catalogo.parentesco

rollback tran
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--25.	Registre 2 familiares para los empleados primero 3 empleados definitivos con curp: AUCC891123JUY78UJN, EURM920113D3N23DFR, HEBD851128Y7UASW12  (alumnos)
 --Munguia Lopez Georgina
INSERT INTO trabajador.definitivo(familiar)
values('padre')
WHERE curp = 'AUCC891123JUY78UJN' and  curp = 'EURM920113D3N23DFR' and  curp = 'HEBD851128Y7UASW12';

--25.	Registre 2 familiares para los empleados primero 3 empleados definitivos con curp: AUCC891123JUY78UJN, EURM920113D3N23DFR, HEBD851128Y7UASW12  (alumnos)
 --Moreno Ramos Eduardo Jair
INSERT INTO trabajador.definitivo
values('padre','madre')
WHERE curp = 'AUCC891123JUY78UJN' and  curp = 'EURM920113D3N23DFR' and  curp = 'HEBD851128Y7UASW12';

--26.	Registre 2 puestos para los empleados con curp: ISDF850423NHRQSD34, AARR920113D3NER7PA, BAAA880727K87DFR45 (alumnos)
--Perez Uribe Jose Alberto
UPDATE trabajador.definitivo
SET id_puesto = (SELECT id_empleado FROM empleado WHERE curp IN ('ISDF850423NHRQSD34', 'AARR920113D3NER7PA', 'BAAA880727K87DFR45'))
LIMIT 2;

--27.	Borre los familiares del empleado con curp: AUCC891123JUY78UJN  (alumnos)
------Ponce Diez Marina Raymundo----------
DELETE FROM Dependiente WHERE id_empleado=(SELECT id_empleado FROM trabajador.empleado WHERE curp='AUCC891123JUY78UJN');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--28.	Los empleados con CURP:  ISDF850423NHRQSD34, EURM920113D3N23DFR y AARF920113D3MSD45Y ingresaron el 15 de mayo de 2021, registre la información (alumnos)
--Rosales Vigil Karla Sofia
UPDATE trabajador.empleado
SET fecha_ingreso = '2021-05-15'
WHERE curp = 'ISDF850423NHRQSD34' and  curp = 'EURM920113D3N23DFR' and  curp = 'AARF920113D3MSD45Y';
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--29.	Los empleados con curp: AUCC891123JUY78UJN, AAMX800512KIUASD768 y BAAA880727K87DFR45 ingresaron el 01 de enero de 2023, actualice la información (alumnos)
--Sanchez Diaz Daniel
UPDATE trabajador.empleado
SET fecha_ingreso = '2023-01-01'
WHERE curp = 'AUCC891123JUY78UJN' and  curp = 'AAMX800512KIUASD768' and  curp = 'BAAA880727K87DFR45';

--30.	Registre el horario para el becario DIEGO HERNANDEZ BARRON el cual es de lunes a viernes de 10 a 2 de la tarde y ellos terminan su estancia el 30 de noviembre de 2023, utilice transacciones (alumnos)
--Trigueros Lopez Hector Adrian
INSERT INTO alumnos (nombre, horario_inicio, horario_fin, fecha_terminacion)
VALUES ('DIEGO HERNANDEZ BARRON', '10:00', '14:00', '2023-11-30');

----------------------------------------------------------------------------------------
/*
Miranda González José Francisco
30. Registre el horario para el becario DIEGO HERNANDEZ BARRON el cual es de lunes a viernes de
10 a 2 de la tarde y ellos terminan su estancia el 30 de noviembre de 2023, utilice
transacciones (alumnos)
*/

--Registramos el horario 
BEGIN TRAN
 
	select * from trabajador.becarios
		
		-- si no esta Diego en la tabla
		INSERT INTO trabajador.becarios (nombre, appaterno, apmaterno, diatrabajo, horario, finestancia)
		VALUES ('DIEGO' , 'HERNANDEZ' , 'BARRON' , 'LUNES - VIERNES' , '10:00 - 14:00' , '2023-11-30');

		-- si ya esta Diego en la tabla:
		--UPDATE trabajador.becarios
	    --SET diatrabajo='LUNES - VIERNES', horario = '10:00 - 14:00', finestancia = '2023-11-30'
	    --WHERE nombre='DIEGO' and appaterno='HERNANDEZ' and apmaterno='BARRON';

	select * from trabajador.becarios
		
COMMIT  TRAN -- Confirmamos la transaccion
-----------------------------------------------------------------------------------------
 
--31.	Elimine los puestos que no se han utilizado, utilice transacciones (alumnos)
--Vazquez Apolonio Armando:
BEGIN TRAN;
DELETE FROM catalogo.puesto
WHERE id_puesto NOT IN (
    SELECT id_puesto
    FROM trabajador.definitivo
);
COMMIT TRAN;


--31. Elimine los puestos que no se han utilizado, utilice transacciones (alumnos)
--Vazquez Muñoz Laura Nayeli
BEGIN TRANSACTION;
DELETE FROM catalogo.puesto
WHERE NOT EXISTS(
	SELECT 1
	FROM trabajador.definitivo
  WHERE trabajador.definitivo.id_puesto = catalogo.puesto.id_puesto
	);













