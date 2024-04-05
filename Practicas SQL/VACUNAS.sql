/*
INSTITUTO NACIONAL DE APRENDIZAJE
GESTION DE BASE DE DATOS
MARIEL ROJAS SANCHEZ
30/01/2023
*/

-- 1)Cree una Base de Datos llamada VACUNAS, 
CREATE DATABASE VACUNAS;
GO

USE VACUNAS;
GO


-- Cree 3 tablas: Pacientes, Tipos de Vacuna y Registros de Vacunas


--2) La tabla Pacientes debe tener los siguientes campos: Cedula, Nombre, Apellido
CREATE TABLE PACIENTES (
CEDULA int CONSTRAINT PK_PACIENTES PRIMARY KEY,
NOMBRE varchar(20) NOT NULL,
APELLIDO varchar(20) NOT NULL
);

--3)La tabla TiposVacuna debe tener: Codigo_V y Nombre_V
CREATE TABLE TIPOS_VACUNAS (
CODIGO_V varchar(10) CONSTRAINT PK_TIPOS_VACUNAS PRIMARY KEY,
NOMBRE_V varchar(20) NOT NULL
);



-- 4)La tabla Registros_Vacunas debe tener los campos: Cedula, Codigo_V, F_Dosis1, F_Dosis2
CREATE TABLE REGISTRO_VACUNAS (
CEDULA int, --FK
CODIGO_V varchar(10), --FK
F_DOSIS1 int,
F_DOSIS2 int
);


-- 5)Cree las relaciones correspondientes.

ALTER TABLE REGISTRO_VACUNAS ADD CONSTRAINT FK_REGISTRO_VACUNAS_CEDULA -- FK CEDULA, DONDE ES PK EN LA TABLA PACIENTES
	FOREIGN KEY (CEDULA) REFERENCES PACIENTES(CEDULA)

 ALTER TABLE REGISTRO_VACUNAS ADD CONSTRAINT FK_REGISTRO_VACUNAS_TV
	FOREIGN KEY (CODIGO_V) REFERENCES TIPOS_VACUNAS(CODIGO_V) -- FK CODIGO_V, DONDE ES PK EN LA TIPO VACUNAS


 --6) Agregar registros en las tabla PACIENTES

 INSERT INTO PACIENTES(CEDULA, NOMBRE, APELLIDO)
 VALUES  (123,'ALEJANDRO','QUINTERO'),
		 (234,'NILS','CARRILLO'),
		 (345,'STIVEN','SOSA'),
		 (456,'GABRIEL','GARCIA'),
		 (567,'ALEXANDER','DURAN'),
		 (678,'FRANCISCO','PANIAGUA'),
		 (789,'MANFRED','ARAYA'),
		 (890,'DANNY','SOTO'),
		 (901,'ALLAN','MADRIZ');

-- 7)Para la tabla Tipos_Vacuna ingrese los siguientes registros:

INSERT INTO TIPOS_VACUNAS(CODIGO_V, NOMBRE_V)
VALUES  ('V-01','PFIZER'),
		('V-02','ASTRAZENECA'),
		('V-03','JANSSEN'),
		('V-04','MODERNA');


--8)Para la tabla Registros_Vacunas, ingrese los siguientes registros
INSERT INTO REGISTRO_VACUNAS ( CEDULA,CODIGO_V,F_DOSIS1,F_DOSIS2)
VALUES  (123,'V-01',20210401,20210422),
		(234,'V-01',20210415,20210507),
		(345,NULL,NULL,NULL),
		(456,NULL,NULL,NULL),
		(567,'V-02',20210517,NULL),
		(678,'V-02',20210718,NULL),
		(789,'V-03',20210722,NULL),
		(890,NULL,NULL,NULL),
		(901,NULL,NULL,NULL);
	
		 
		 -- SE VERIFICA QUE TODO ESTE CORRECTO 
		 SELECT * FROM PACIENTES;
		 SELECT * FROM TIPOS_VACUNAS;
		 SELECT * FROM REGISTRO_VACUNAS;



--9)Cree las siguientes consultas (debe utilizar INNER JOIN, LEFT JOIN Y RIGHT JOIN). 
--En cada ejercicio se le muestra los resultados esperados.


--1) Lista de todos los pacientes (Cedula, Nombre, Apellido (NO USAR SELECT * ))

SELECT CEDULA,NOMBRE,APELLIDO FROM PACIENTES;

-- 2) Lista de los tipos de vacunas (código de la vacuna y su nombre)

SELECT CODIGO_V,NOMBRE_V FROM TIPOS_VACUNAS

--3) Lista de los pacientes que no han recibido ninguna dosis
--(Cedula, Nombre, Apellido, Fecha de Dosis 1, Fecha de Dosis 2)

SELECT P.CEDULA,NOMBRE, APELLIDO, F_DOSIS1, F_DOSIS2
FROM PACIENTES P INNER JOIN REGISTRO_VACUNAS RV
ON P.CEDULA = RV.CEDULA
WHERE F_DOSIS1 IS NULL AND F_DOSIS2 IS NULL



--4)	Lista de los pacientes que han recibido al menos una dosis
--(cédula, nombre, apellido, código de la vacuna, nombre de la vacuna,
--fechas de la primera y segunda dosis)

SELECT P.CEDULA,NOMBRE, APELLIDO,RV.CODIGO_V,NOMBRE_V, F_DOSIS1, F_DOSIS2
FROM PACIENTES P INNER JOIN REGISTRO_VACUNAS RV
ON P.CEDULA = RV.CEDULA
INNER JOIN TIPOS_VACUNAS TV
ON RV.CODIGO_V = TV.CODIGO_V
WHERE F_DOSIS1 IS NOT NULL 

--5)Lista de los pacientes que han recibido sólo una dosis (cédula, nombre,
-- apellido, código de la vacuna, nombre de la vacuna, fechas de la primera y segunda dosis). 
--Realice este ejercicio 2 veces, (5.a) utilizando INNER JOIN y (5.b) utilizando LEFT JOIN. 
-- El resultado debe ser el mismo.

SELECT P.CEDULA,NOMBRE, APELLIDO,RV.CODIGO_V,NOMBRE_V, F_DOSIS1, F_DOSIS2
FROM PACIENTES P INNER JOIN REGISTRO_VACUNAS RV
ON P.CEDULA = RV.CEDULA
INNER JOIN TIPOS_VACUNAS TV
ON RV.CODIGO_V = TV.CODIGO_V
WHERE F_DOSIS1 IS NOT NULL AND F_DOSIS2 IS NULL


SELECT P.CEDULA,NOMBRE, APELLIDO,RV.CODIGO_V,NOMBRE_V, F_DOSIS1, F_DOSIS2
FROM PACIENTES P LEFT JOIN REGISTRO_VACUNAS RV
ON P.CEDULA = RV.CEDULA
LEFT JOIN TIPOS_VACUNAS TV
ON RV.CODIGO_V = TV.CODIGO_V
WHERE F_DOSIS1 IS NOT NULL AND F_DOSIS2 IS NULL



--6)Lista de los pacientes que han recibido las 2 dosis (cédula, nombre, apellido,
--código de la vacuna, nombre de la vacuna, fecha de la primera y segunda dosis). 
--Realice este ejercicio 3 veces, (6.a) utilizando INNER JOIN, (6.b) utilizando LEFT JOIN y
--(6.c) utilizando RIGHT JOIN El resultado debe ser el mismo.

-------------INNER JOIN--------------------------------
SELECT P.CEDULA,NOMBRE, APELLIDO,RV.CODIGO_V,NOMBRE_V, F_DOSIS1, F_DOSIS2
FROM PACIENTES P INNER JOIN REGISTRO_VACUNAS RV
ON P.CEDULA = RV.CEDULA
INNER JOIN TIPOS_VACUNAS TV
ON RV.CODIGO_V = TV.CODIGO_V
WHERE F_DOSIS1 IS NOT NULL AND F_DOSIS2 IS NOT NULL

--------------LEFT JOIN------------------------------------
SELECT P.CEDULA,NOMBRE, APELLIDO,RV.CODIGO_V,NOMBRE_V, F_DOSIS1, F_DOSIS2
FROM PACIENTES P LEFT JOIN REGISTRO_VACUNAS RV
ON P.CEDULA = RV.CEDULA
LEFT JOIN TIPOS_VACUNAS TV
ON RV.CODIGO_V = TV.CODIGO_V
WHERE F_DOSIS1 IS NOT NULL AND F_DOSIS2 IS NOT NULL

--------------RIGHT JOIN------------------------------------
SELECT P.CEDULA,NOMBRE, APELLIDO,RV.CODIGO_V,NOMBRE_V, F_DOSIS1, F_DOSIS2
FROM PACIENTES P RIGHT JOIN REGISTRO_VACUNAS RV
ON P.CEDULA = RV.CEDULA
RIGHT JOIN TIPOS_VACUNAS TV
ON RV.CODIGO_V = TV.CODIGO_V
WHERE F_DOSIS1 IS NOT NULL AND F_DOSIS2 IS NOT NULL


--7)Vacunas que no han sido utilizadas

SELECT TV.CODIGO_V,NOMBRE_V
FROM REGISTRO_VACUNAS RV RIGHT JOIN TIPOS_VACUNAS TV
ON RV.CODIGO_V = TV.CODIGO_V
WHERE RV.CODIGO_V IS NULL

SELECT TV.CODIGO_V,NOMBRE_V
FROM TIPOS_VACUNAS TV LEFT JOIN  REGISTRO_VACUNAS RV
ON RV.CODIGO_V = TV.CODIGO_V
WHERE RV.CODIGO_V IS NULL
