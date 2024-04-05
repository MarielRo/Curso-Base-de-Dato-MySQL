/*INSTITUTO NACIONAL DE APRENDIZAJE 
BASE DE DATOS
MARIEL ROJAS 
20/01/2023
*/


--CREA LA BASE DE DATOS
CREATE DATABASE BD_MATRICULA;
GO

--SE USA LA BASE DE DATOS
USE MI_PRIMERA_BD;
GO

------------CREACION DE TABLAS----------------
CREATE TABLE CARRERAS (
	COD_CARRERA int CONSTRAINT PK_CARRERAS PRIMARY KEY IDENTITY,
	NOMBRE_CARRERA varchar(100) NOT NULL,
	TOTAL_CREDITOS smallint CONSTRAINT CK_TOTAL_CREDITOS CHECK (TOTAL_CREDITOS >0 AND TOTAL_CREDITOS < 1000) NOT NULL,
	GRADO varchar(14) CONSTRAINT CK_GRADO 
	CHECK(GRADO IN ('LICENCIATURA', 'BACHILLERATO', 'DIPLOMADO', 'MAESTR�A') AND GRADO = upper(GRADO)) NOT NULL
);

ALTER TABLE CARRERAS 
 ADD CONSTRAINT 









