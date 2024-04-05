/* INSTITUTO NACIONAL DE APRENDIZAJE 
   MÓDULO GESTIÓN DE BASE DE DATOS
   ENTREGA FASE II
   MARIEL DANIELA ROJAS SÁNCHEZ 
   FECHA : 06 FEBRERO 2023
*/


--Se crea la base de datos con el nombre correspondiente
CREATE DATABASE MARIEL_PROYECTO_BD_FASE_III

GO

--DROP DATABASE MARIEL_PROYECTO_BD

--Se usa la base de datos
USE MARIEL_PROYECTO_BD_FASE_III

GO


--------------------------------------------------------------------------------------------------------
--********************************* CREACCION DE TABLAS *********************************--

-- CREA LA TABLA DE ESTUDIANTES
CREATE TABLE ESTUDIANTES_P(
	ID_ESTUDIANTE int CONSTRAINT PK_ESTUDIANTES_P PRIMARY KEY, -- PK
	NOMBRE_ESTUDIANTE  varchar(20) NOT NULL, 
	PRIMER_APE_E  varchar(20) NOT NULL,
	SEGUNDO_APE_E  varchar(20),
	TEL_ESTUDIANTE  varchar(8) NOT NULL,
	CORREO_E  varchar(25),
	PROVINCIA varchar(20) NOT NULL,
	FECHA_INGRESO date, 
	ESTADO_ESTUDIANTE varchar(3) NOT NULL DEFAULT 'ACT', -- Por defecto el estado es activo
	BORRADO_E bit NOT NULL DEFAULT 0
);

-- RESTRICCIONES DE LA TABLA ESTUDIANTES
ALTER TABLE ESTUDIANTES_P ADD CONSTRAINT CK_ESTADO_ESTUDIANTE 
CHECK(ESTADO_ESTUDIANTE IN ('ACT','INA') AND ESTADO_ESTUDIANTE = upper(ESTADO_ESTUDIANTE))

ALTER TABLE ESTUDIANTES_P
ADD CONSTRAINT CK_PROVINCIA CHECK(PROVINCIA IN ('ALAJUELA','SAN JOSE','PUNTARENAS','LIMON', 'GUANACASTE', 'CARTAGO', 'HEREDIA'))


-- TABLA DE MATRICULAS/ RESTRICIONES
CREATE TABLE MATRICULAS_P(
	NUM_RECIBO int IDENTITY CONSTRAINT PK_MATRICULAS_P PRIMARY KEY,
	ID_ESTUDIANTE int NOT NULL, -- FK
	FECHA_HORA datetime NOT NULL DEFAULT GETDATE(),-- Por defecto se pone la fecha actual de la matricula
	USUARIO_MATRICULA varchar(25) NOT NULL,
	MONTO decimal(10,2) NOT NULL CONSTRAINT CK_MONTO CHECK (MONTO >=0), -- El monto de la matricula no puede ser menor a cero
	ESTADO_M varchar(3) NOT NULL DEFAULT 'ACT' CONSTRAINT CK_ESTADO_M  -- Por defecto el estado es activo
	CHECK(ESTADO_M='ACT' OR ESTADO_M='INA') -- Realiza un check de estado matricula, para ver si es inactivo o activo
);


-- TABLA DE DETALLE MATRICULAS
CREATE TABLE DETALLE_MATRICULAS_P(
	NUM_RECIBO int NOT NULL, -- PK Y FK
	COD_MODULO_DISPONIBLE int NOT NULL,
	NOTA_FINAL decimal(5,2) DEFAULT 0, -- Por defecto 0, pero tiene restriccion de ser mayor o igual a cero
	ESTADO_D varchar(3) NOT NULL DEFAULT 'ACT' -- Por defecto el estado es activo,pero puede ser INA, REP o APR
	CONSTRAINT PK_DETALLE_MATRICULAS PRIMARY KEY(NUM_RECIBO,COD_MODULO_DISPONIBLE) -- Llaves primarias, como son dos mejor hacerlo aqui al final
);

--RESTRICCIONES TABLA DETALLE MATRICULAS

-- Crea una restriccion para que el estado, solo pueda ser activo, inactivo, aprobado, reprobado o retirado del modulo
ALTER TABLE DETALLE_MATRICULAS_P ADD CONSTRAINT CK_ESTADO_D
CHECK(ESTADO_D IN('ACT','RET','APR','REP')) 

ALTER TABLE DETALLE_MATRICULAS_P ADD CONSTRAINT CK_NOTA_FINAL -- La es nula o tiene que ser mayor o igual a 0 y menor a 100
CHECK (NOTA_FINAL is null or (NOTA_FINAL >= 0 AND NOTA_FINAL<=100))


-- CREACION TABLA DE MODULOS DISPONIBLES
CREATE TABLE MODULOS_DISPONIBLES(
	COD_MODULO_DISPONIBLE int IDENTITY(1,1) CONSTRAINT PK_MODULOS_DISPONIBLES PRIMARY KEY, --
	COD_PROGRAMA_MODULO int NOT NULL, --Llave foranea
	ID_PROFESOR int NOT NULL, -- Llave foranea
	COSTO_MODULO real NOT NULL,
	DURACION_MODULO int NOT NULL
);

-- RESTRICCIONES DE LA TABLA MODULOS DISPONIBLES
ALTER TABLE MODULOS_DISPONIBLES ADD CONSTRAINT CK_COSTO_MODULO CHECK(COSTO_MODULO>0)

-- CREAR TABLA PROGRAMAS_MODULOS
CREATE TABLE PROGRAMAS_MODULOS(
	COD_PROGRAMA_MODULO int IDENTITY(1,1) CONSTRAINT PK_PROGRAMAS_MODULOS PRIMARY KEY,
	COD_MODULO varchar(10) NOT NULL, -- Llave foranea
	COD_PROGRAMA varchar(20) NOT NULL,
	DETALLES varchar(200),
);


 -- CREACION DE LA TABLA PROFESORES
 CREATE TABLE PROFESORES_P(
	ID_PROFESOR int NOT NULL CONSTRAINT PK_PROFESORES_P PRIMARY KEY,
	NOMBRE_PROFESOR varchar(25) NOT NULL,
	PRIMER_APE_P varchar(20) NOT NULL,
	SEGUNDO_APE_P varchar(20),
	TELEFONO_PROFESOR varchar(8) NOT NULL,
	CORREO_PROFESOR varchar(25),
	CERTIFICACIONES varchar(120) DEFAULT 'INGIENERÍA SOFTWARE', -- puede ser nulo por ahora
	PROVINCIA varchar(20) NOT NULL,
	BORRADO_P bit NOT NULL DEFAULT 0 -- por defecto se pone que no esta borrado
);

-- RESTRICCIONES DE LA TABLA DE PROFESORES
ALTER TABLE PROFESORES_P
ADD CONSTRAINT CK_PROVINCIA_PR CHECK(PROVINCIA IN ('ALAJUELA','SAN JOSE','PUNTARENAS','LIMÓN', 'GUANACASTE', 'CARTAGO', 'HEREDIA'))



--CREAR LA TABLA MODULOS

CREATE TABLE MODULOS(
	COD_MODULO varchar(10) CONSTRAINT PK_MATERIAS PRIMARY KEY,
	NOMBRE_MODULO varchar(120) NOT NULL,
	REQUISITOS varchar(50)
);


--CREAR TABLA PROGRAMAS
CREATE TABLE PROGRAMAS(
	COD_PROGRAMA varchar(20) CONSTRAINT PK_PROGRAMAS PRIMARY KEY,
	NOMBRE_PROGRAMA VARCHAR(100) NOT NULL,
);


-- CREAR TABLA HORARIOS
CREATE TABLE HORARIOS_P(
	COD_HORARIO int IDENTITY CONSTRAINT PK_HORARIOS PRIMARY KEY,
	COD_MODULO_DISPONIBLE int,
	DIA CHAR(1) NOT NULL, -- lunes =1 , martes =2, miercoles =3, jueves=4, viernes=5
	HORA_INICIO time,
	HORA_FIN time
);

-- RESTRICCIONES DE LA TABLA HORARIOS
ALTER TABLE HORARIOS_P ADD CONSTRAINT CK_DIA
 CHECK(DIA IN('L','K','M','J','V','S') and DIA = upper(DIA))



-- CREAR TABLA LABORATORIOS 
CREATE TABLE LABORATORIOS(
	COD_LABORATORIO INT IDENTITY (1,1) CONSTRAINT PK_LABORATORIOS PRIMARY KEY,
	NOMBRE_LAB CHAR NOT NULL,
	COD_MODULO_DISPONIBLE int NOT NULL,
	COD_HORARIO int
);


-- CREAR TABLA PLANILLAS
CREATE TABLE PLANILLAS(
	COD_PLANILLAS int IDENTITY(1,1) CONSTRAINT PK_PLANILLAS PRIMARY KEY,
	ID_PROFESOR int NOT NULL,
	FECHA date NOT NULL,
	HORAS_TRABAJADAS float NOT NULL,
	HORAS_EXTRA float DEFAULT 0, -- puede ser nulo
	PRECIO_HORA real NOT NULL,
	SALARIO real, -- despues se puede realizar el calculo en consultas
	DEDUCCIONES real,
);

---------------------------------------------------------------------------------------------------------------

--********************************* CREACCION DE RELACIONES ENTRE LAS TABLAS ********************************* 

--Llave foranea ID_ESTUDIANTE en tabla matriculas, que es llave primaria en tabla estudiantes  
ALTER TABLE MATRICULAS_P ADD CONSTRAINT FK_MATRICULAS_P
FOREIGN KEY (ID_ESTUDIANTE) REFERENCES ESTUDIANTES_P(ID_ESTUDIANTE)
ON DELETE NO ACTION 

-- Llave foranea COD_MODULO_DISPONIBLE en tabla detalles_matriculas, que es PK en modulos_disponibles
ALTER TABLE DETALLE_MATRICULAS_P ADD CONSTRAINT FK_DETALLE_MATRICULAS_P
FOREIGN KEY (COD_MODULO_DISPONIBLE) REFERENCES MODULOS_DISPONIBLES(COD_MODULO_DISPONIBLE)
ON DELETE NO ACTION 


-- FK COD_PROGRAMA_MODULO en tabla modulos_disponibles, que es Pk en programa_modulo
ALTER TABLE MODULOS_DISPONIBLES ADD CONSTRAINT FK_MODULOS_DISPONIBLES_PM
FOREIGN KEY (COD_PROGRAMA_MODULO) REFERENCES PROGRAMAS_MODULOS(COD_PROGRAMA_MODULO)
ON DELETE NO ACTION 

-- FK ID_PROFESOR en tabla modulos_disponibles, que es Pk en la tabla profesores
ALTER TABLE MODULOS_DISPONIBLES ADD CONSTRAINT FK_MODULOS_DISPONIBLES_IP
FOREIGN KEY (ID_PROFESOR) REFERENCES PROFESORES_P(ID_PROFESOR)
ON DELETE NO ACTION 

-- FK COD_MODULO_DISPONIBLE en tabla HORARIOS_P , que es Pk en la tabla modulos_disponibles
ALTER TABLE HORARIOS_P ADD CONSTRAINT FK_HORARIOS_P
FOREIGN KEY (COD_MODULO_DISPONIBLE) REFERENCES MODULOS_DISPONIBLES(COD_MODULO_DISPONIBLE)

-- FK COD_HORARIO en tabla laboratorios, que es Pk en la HORARIOS_P
ALTER TABLE LABORATORIOS ADD CONSTRAINT FK_LABORATORIOS
FOREIGN KEY (COD_HORARIO) REFERENCES HORARIOS_P(COD_HORARIO)

-- FK COD_HORARIO en tabla laboratorios, que es Pk en la HORARIOS_P
ALTER TABLE LABORATORIOS ADD CONSTRAINT FK_LABORATORIOS_2
FOREIGN KEY (COD_MODULO_DISPONIBLE) REFERENCES MODULOS_DISPONIBLES(COD_MODULO_DISPONIBLE)

-- FK ID_PROFESOR en tabla planillas, que es pk en tabla profesores
ALTER TABLE PLANILLAS ADD CONSTRAINT FK_PLANILLAS
FOREIGN KEY (ID_PROFESOR) REFERENCES PROFESORES_P(ID_PROFESOR)

-- FK COD_MODULO en tabla PROGRAMAS_MODULO, que es PK en tabla MODULOS
ALTER TABLE PROGRAMAS_MODULOS ADD CONSTRAINT FK_PROGRAMAS_MODULOS
FOREIGN KEY (COD_MODULO) REFERENCES MODULOS(COD_MODULO)
ON DELETE NO ACTION 
	

---------------------------------------------------------------------------------------------------------------

--********************************* INSERCION DE DATOS EN LAS TABLAS  *********************************

--***************************************************************************************************************************
--TABLA ESTUDIANTES
SELECT * FROM ESTUDIANTES_P;

INSERT INTO ESTUDIANTES_P(ID_ESTUDIANTE, NOMBRE_ESTUDIANTE, PRIMER_APE_E,SEGUNDO_APE_E,TEL_ESTUDIANTE,CORREO_E,PROVINCIA,FECHA_INGRESO)
		VALUES		(208030487,'MARIEL','ROJAS','SANCHEZ','83912061','208030487@ina.cr','ALAJUELA','20210603'),
					(208000304,'VERONICA','BLANCO','ROJAS','60227090','208000304@ina.cr','SAN JOSE','20210604'),
					(203890954,'MAUREN','SANCHEZ','CAMPOS','88360383','203890954@ina.cr','ALAJUELA','20210605'),
					(207270446,'ESTEFANY','ROJAS','SANCHEZ','85689615','207270446@ina.cr','PUNTARENAS','20210606'),
					(204070904,'JORGE','ROJAS','VARGAS','60963155','204070904@ina.cr','ALAJUELA','20210607'),
					(208030488,'ERIKA','MOLINA','MORA','87873413','208030488@ina.cr','GUANACASTE','20210608'),
					(208030500,'ANDREA','SOTO','JIMENEZ','88888888','208030500@ina.cr','LIMON','20210609'),
					(208030501,'MELISSA','ARAYA','ABARCA','88776655','208030501@ina.cr','ALAJUELA','20210701'),
					(208030502,'NAZARETH','SOTO','JIMENEZ','55443322','208030502@ina.cr','HEREDIA','20210701'),
					(208030503,'LUNA','ROJAS','VARGAS','11223344','208030503@ina.cr','SAN JOSE','20210702'),
					(200000000,'LUCIA','VASQUEZ','SALAS','11223344','200000000@ina.cr','HEREDIA','20210703'); -- NO ESTA MATRICULADA
					

--***************************************************************************************************************************
--TABLA MATRICULAS
SELECT * FROM MATRICULAS_P;

-- NUM RECIBO ES IDENTITY
INSERT INTO MATRICULAS_P(ID_ESTUDIANTE,FECHA_HORA,USUARIO_MATRICULA,MONTO)
			VALUES (200000000,'20210703','LVS000',250000),
				   (203890954,'20210605','MSC954',240000),
				   (204070904,'20210607','JRV904',220000),
				   (207270446,'20210606','ERS446',195000),
				   (208000304,'20210604','VBR304',225000),
				   (208030487,'20210603','MRS487',335000),
				   (208030488,'20210608','EMM488',345000),
				   (208030500,'20210609','ASJ500',185000),
				   (208030501,'20210701','MAA501',175000),
				   (208030502,'20210701','NSJ502',180000),
				   (208030487,'20210603','MRS487',185000);

--***************************************************************************************************************************

--TABLA PROFESORES
SELECT * FROM PROFESORES_P;

INSERT INTO PROFESORES_P (ID_PROFESOR,NOMBRE_PROFESOR,PRIMER_APE_P,SEGUNDO_APE_P,TELEFONO_PROFESOR,CORREO_PROFESOR,PROVINCIA)
VALUES  (1111,'Luis','Chacon','Zuniga','88881111','luis@ina.ac.cr','ALAJUELA'),
		(2222,'Alonso','Bogantes','Rodriguez','88881112','alonso@ina.ac.cr','ALAJUELA'),
		(3333,'Oscar','Pacheco','Vazquez','88881113','pacheco@ina.ac.cr','SAN JOSE'),
		(4444,'Laura','Fonseca','Rojas','88881114','laura@ina.ac.cr','SAN JOSE'),
		(5555,'Irene','Cruz','Fernandez','88881115','irene@ina.ac.cr','CARTAGO'),
		(6666,'Jimmy','Zuniga','Sanchez','88881116','jimmy@ina.ac.cr','HEREDIA'),
		(7777,'Nelson','Jimenez','Jimenez','88881117','Nelson@ina.ac.cr','ALAJUELA'),
		(8888,'Rebeca','Aguilar','Navarez','88881118','Rebeca@ina.ac.cr','HEREDIA'),
		(9999,'Sady','Carrillo','Sanchez','88881119','Sady@ina.ac.cr','CARTAGO'),
		(1010,'Muricio','Cordero','Lizano','88881120','Mauricio@ina.ac.cr','GUANACASTE'),-- x
		(1011,'Graciela','Rojas','Chavarria','88881121','Graciela@ina.ac.cr','SAN JOSE'),
		(1110,'Marco','Acosta','Paniagua','88881122','MAcosta Paniaguaina.ac.cr','ALAJUELA'); -- x


--***************************************************************************************************************************
--TABLA PROGRAMAS
SELECT * FROM PROGRAMAS;

INSERT INTO PROGRAMAS(COD_PROGRAMA,NOMBRE_PROGRAMA)
VALUES  ('PDM_001','PROGRAMACIÓN DISPOSITIVOS MÓVILES'),
		('PSE_002','PROGRAMACIÓN SISTEMAS DE ESCRITORIO'),
		('PPW_003','PROGRAMACIÓN PAGINAS WEB'),
		('ASIS_004','ASISTENTE A PERSONAS USUARIAS DE TECNOLOGÍAS DE INFORMACIÓN Y COMUNICACIÓN'),
		('COMU_005','COMUNICADOR(A) RADIOFÓNICO'),
		('WEB1_006','INGIENERIA ELECTRONICA'),
		('OPER_007','OPERADOR(A) DE TECNOLOGÍAS DE INFORMACIÓN Y COMUNICACIÓN'),
		('PROG_008','PROGRAMADOR(A) DE APLICACIONES INFORMÁTICAS'),
		('PROD_009','PRODUCTOR RADIOFÓNICO'),
		('TECT_010','TÉCNICAS BÁSICAS DE PRODUCCIÓN DE VIDEO');

--***************************************************************************************************************************
--TABLA MODULOS
SELECT * FROM MODULOS;

INSERT INTO MODULOS(COD_MODULO,NOMBRE_MODULO,REQUISITOS)
 VALUES  ('PDM_1','ANDROID I',NULL),
		 ('PDM_2','ANDROID II','PDM_1'),
		 ('PDM_3','ANDROID III','PDM_2'),
		 ('PDM_4','APLICACIONES MIXTAS','PDM_3'),
		 ('PSE_01','LÓGICA COMPUTACIONAL',NULL),
		 ('PSE_02','INTRODUCCIÓN JAVA','PSE_01'),
		 ('PSE_03','ORIENDADA A OBJETOS','PSE_02'),
		 ('PPW_10','HTML',NULL),
		 ('PPW_20','CSS','PPW_10'),
		 ('PPW_30','JAVASCRIPT','PPW_20'),
		 ('PPW_40','BOOTSTRAP','PPW_30'),
		 ('PPW_50','NODE_JS','PPW_40');

--***************************************************************************************************************************

-- TABLA PROGRAMA_MODULOS
SELECT * FROM PROGRAMAS_MODULOS;

INSERT INTO PROGRAMAS_MODULOS(COD_MODULO,COD_PROGRAMA)
VALUES ('PDM_1','PDM_001'),
		 ('PDM_2','PDM_001'),
		 ('PDM_3','PDM_001'),
		 ('PDM_4','PDM_001'),
		 ('PSE_01','PSE_002'),
		 ('PSE_02','PSE_002'),
		 ('PSE_03','PSE_002'),
		 ('PPW_10','PPW_003'),
		 ('PPW_20','PPW_003'),
		 ('PPW_30','PPW_003'),
		 ('PPW_40','PPW_003'),
		 ('PPW_50','PPW_003');
--***************************************************************************************************************************
--TABLA MODULOS DISPONIBLES
SELECT * FROM MODULOS_DISPONIBLES;


INSERT INTO MODULOS_DISPONIBLES(COD_PROGRAMA_MODULO,ID_PROFESOR,COSTO_MODULO,DURACION_MODULO)
VALUES	 (1,1111,250000,120),
		 (2,2222,240000,110),
		 (3,3333,220000,100),
		 (4,4444,195000,100),
		 (5,5555,225000,140),
		 (6,6666,335000,150),
		 (7,7777,345000,160),
		 (8,8888,185000,90),
		 (9,9999,175000,60),
		 (11,1011,185000,90);


--***************************************************************************************************************************
--TABLA HORARIOS
SELECT * FROM HORARIOS_P;

INSERT INTO HORARIOS_P(COD_MODULO_DISPONIBLE,DIA,HORA_INICIO,HORA_FIN)
		VALUES	(1,'L','7:00','9:00'),	
				(1,'M','7:00','10:00'),	
				(2,'L','10:00','12:00'),	
				(2,'M','11:00','14:00'),
				(3,'K','7:00','9:00'),	
				(3,'J','7:00','10:00'),	
				(4,'L','10:00','12:00'),	
				(4,'M','11:00','14:00'),
				(5,'L','13:00','15:00'),	
				(5,'M','15:00','18:00'),	
				(6,'K','13:00','15:00'),	
				(6,'J','15:00','18:00'),
				(7,'V','7:00','12:00'),
				(8,'V','13:00','18:00'),
				(9,'L','7:00','9:00'),	
				(9,'M','7:00','10:00'),
				(10,'L','10:00','12:00'),	
				(10,'M','11:00','14:00');

--***************************************************************************************************************************
--TABLA DETALLE_MATRICULA

SELECT * FROM DETALLE_MATRICULAS_P;

SELECT * FROM MATRICULAS_P;

SELECT * FROM MODULOS_DISPONIBLES;
select * from PROGRAMAS_MODULOS
select * from MODULOS;
INSERT INTO DETALLE_MATRICULAS_P(NUM_RECIBO,COD_MODULO_DISPONIBLE)
VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10),(11,10);


--***************************************************************************************************************************
--TABLA LABORATORIOS

SELECT * FROM LABORATORIOS;
SELECT * FROM HORARIOS_P;
SELECT * FROM MODULOS_DISPONIBLES;

INSERT INTO LABORATORIOS(NOMBRE_LAB,COD_MODULO_DISPONIBLE,COD_HORARIO)
VALUES ('A',1,1),('A',2,2),('B',3,3),('B',4,4),('C',5,5),('C',6,6),('D',7,7),('D',8,8),('E',9,9),('E',10,10);

--***************************************************************************************************************************

--TABLA PLANILLAS
SELECT * FROM PLANILLAS;

INSERT INTO PLANILLAS(ID_PROFESOR,FECHA,HORAS_TRABAJADAS,PRECIO_HORA)
VALUES	(1111,'20210501',45,4500),
		(2222,'20210501',40,4000),
		(3333,'20210501',44,4500),
		(4444,'20210501',45,4500),
		(5555,'20210501',45,4500),
		(6666,'20210501',45,4500),
		(7777,'20210501',43,5000),
		(8888,'20210501',46,2000),
		(9999,'20210501',45,4500),
		(1010,'20210501',40,4500),
		(1011,'20210501',45,4500),
		(1110,'20210501',45,4500);

-----------------------------------------------------------------------------------------------------------------------------
--***************************************************************************************************************************

--********************************* CONSULTAS  *********************************

-- Muestre el nombre, primer apellido, segundo apellido de los estudiantes que tienen como primer apellido 'ROJAS'
SELECT NOMBRE_ESTUDIANTE,PRIMER_APE_E,SEGUNDO_APE_E
FROM ESTUDIANTES_P
WHERE PRIMER_APE_E = 'ROJAS'

--Misma consuta solo que ahora utilizando el like en luugar del igual
SELECT NOMBRE_ESTUDIANTE,PRIMER_APE_E,SEGUNDO_APE_E
FROM ESTUDIANTES_P
WHERE PRIMER_APE_E LIKE 'ROJAS' 

-- Mostrar Identificación, Nombre y Apellidos de los profesores que tienen una Materia Abierta Asignada.

-- esta consulta no necesariamente se tiene que hacer con inner join, se podia hacer asi tambien
SELECT MODULOS_DISPONIBLES.ID_PROFESOR, NOMBRE_PROFESOR,PRIMER_APE_P,SEGUNDO_APE_P 
FROM MODULOS_DISPONIBLES, PROFESORES_P
WHERE MODULOS_DISPONIBLES.ID_PROFESOR = PROFESORES_P.ID_PROFESOR
 -- utilizando inner join 
SELECT MD.ID_PROFESOR, NOMBRE_PROFESOR, PRIMER_APE_P,SEGUNDO_APE_P 
FROM MODULOS_DISPONIBLES MD INNER JOIN PROFESORES_P P 
ON MD.ID_PROFESOR = P.ID_PROFESOR 
-- full join
SELECT MD.ID_PROFESOR, NOMBRE_PROFESOR, PRIMER_APE_P,SEGUNDO_APE_P 
FROM MODULOS_DISPONIBLES MD FULL JOIN PROFESORES_P P 
ON MD.ID_PROFESOR = P.ID_PROFESOR 
WHERE MD.ID_PROFESOR IS NOT NULL

-- Mostrar los profesores que tienen modulos asignados y mostrar el nombre de dicho modulo
SELECT MD.ID_PROFESOR,NOMBRE_PROFESOR,PRIMER_APE_P, NOMBRE_MODULO,DIA,HORA_INICIO,HORA_FIN,NOMBRE_LAB, L.COD_HORARIO,COD_LABORATORIO
FROM MODULOS_DISPONIBLES MD INNER JOIN PROFESORES_P P
	ON MD.ID_PROFESOR = P.ID_PROFESOR
		INNER JOIN PROGRAMAS_MODULOS PM
			ON PM.COD_PROGRAMA_MODULO = MD.COD_PROGRAMA_MODULO
			  INNER JOIN MODULOS M
				ON M.COD_MODULO = PM.COD_MODULO
				INNER JOIN HORARIOS_P H
					ON H.COD_MODULO_DISPONIBLE = MD.COD_MODULO_DISPONIBLE
						INNER JOIN LABORATORIOS L 
							ON L.COD_MODULO_DISPONIBLE= MD.COD_MODULO_DISPONIBLE


SELECT MD.ID_PROFESOR,NOMBRE_PROFESOR,MA.NUM_RECIBO,MA.ID_ESTUDIANTE, NOMBRE_ESTUDIANTE, DIA,HORA_INICIO,HORA_FIN,NOMBRE_LAB, L.COD_HORARIO,COD_LABORATORIO, NOMBRE_MODULO
FROM MODULOS_DISPONIBLES MD FULL JOIN PROFESORES_P P
	ON MD.ID_PROFESOR = P.ID_PROFESOR
	FULL  JOIN PROGRAMAS_MODULOS PM
			ON PM.COD_PROGRAMA_MODULO = MD.COD_PROGRAMA_MODULO
			  FULL  JOIN MODULOS M
				ON M.COD_MODULO = PM.COD_MODULO
				FULL  JOIN HORARIOS_P H
					ON H.COD_MODULO_DISPONIBLE = MD.COD_MODULO_DISPONIBLE
						FULL  JOIN LABORATORIOS L 
							ON L.COD_MODULO_DISPONIBLE= MD.COD_MODULO_DISPONIBLE
							FULL  JOIN DETALLE_MATRICULAS_P DM
								ON DM.COD_MODULO_DISPONIBLE = MD.COD_MODULO_DISPONIBLE
								FULL  JOIN MATRICULAS_P MA
								 ON MA.NUM_RECIBO = DM.NUM_RECIBO
								 FULL JOIN ESTUDIANTES_P E
								 ON E.ID_ESTUDIANTE = MA.ID_ESTUDIANTE



SELECT DISTINCT MD.ID_PROFESOR,NOMBRE_PROFESOR, PRIMER_APE_P, SEGUNDO_APE_P, MD.COD_MODULO_DISPONIBLE,NOMBRE_MODULO
FROM MODULOS_DISPONIBLES MD RIGHT JOIN PROFESORES_P P
	ON MD.ID_PROFESOR = P.ID_PROFESOR
		INNER JOIN PROGRAMAS_MODULOS PM
			ON PM.COD_PROGRAMA_MODULO = MD.COD_PROGRAMA_MODULO
			  INNER JOIN MODULOS M
				ON M.COD_MODULO = PM.COD_MODULO
WHERE MD.ID_PROFESOR IS NOT NULL;


-- Mostrar todas los modulos que tienen un profesor asignado, además mostrar el nombre,apellidos del profesor y las horas trabajadas
SELECT NOMBRE_MODULO,NOMBRE_PROFESOR,PRIMER_APE_P,SEGUNDO_APE_P,HORAS_TRABAJADAS
FROM MODULOS_DISPONIBLES MD INNER JOIN PROFESORES_P P
ON MD.ID_PROFESOR = P.ID_PROFESOR
	INNER JOIN PROGRAMAS_MODULOS PM
		ON PM.COD_PROGRAMA_MODULO = MD.COD_PROGRAMA_MODULO
			 INNER JOIN MODULOS M
				ON M.COD_MODULO = PM.COD_MODULO
				INNER JOIN PLANILLAS
					ON PLANILLAS.ID_PROFESOR = P.ID_PROFESOR

-- Muestre nombre, codigo de modulo y el total de duracion de unicamente los modulo abiertos del programa "Programación de Páginas Web"
SELECT NOMBRE_MODULO,PM.COD_MODULO,DURACION_MODULO
FROM MODULOS M INNER JOIN PROGRAMAS_MODULOS PM
ON M.COD_MODULO = PM.COD_MODULO
 INNER JOIN MODULOS_DISPONIBLES MD
	ON MD.COD_PROGRAMA_MODULO = PM.COD_PROGRAMA_MODULO
WHERE COD_PROGRAMA = 'PPW_003'


--Seleccionar todos los estudiantes que no tienen una matricula
SELECT E.ID_ESTUDIANTE,NOMBRE_ESTUDIANTE,PRIMER_APE_E,SEGUNDO_APE_E, NUM_RECIBO
FROM ESTUDIANTES_P E LEFT JOIN MATRICULAS_P M
ON E.ID_ESTUDIANTE = M.ID_ESTUDIANTE
WHERE M.ID_ESTUDIANTE IS NULL
 
 --Seleccionar todas las matriculas que tienen estudiantes
 SELECT E.ID_ESTUDIANTE,NOMBRE_ESTUDIANTE,PRIMER_APE_E,SEGUNDO_APE_E, NUM_RECIBO
FROM ESTUDIANTES_P E RIGHT JOIN MATRICULAS_P M
ON E.ID_ESTUDIANTE = M.ID_ESTUDIANTE

--Muestre nombre, codigo, de los modulos que no estan abiertos 

SELECT NOMBRE_MODULO,PM.COD_MODULO
FROM MODULOS M RIGHT JOIN PROGRAMAS_MODULOS PM
ON M.COD_MODULO = PM.COD_MODULO
 LEFT JOIN MODULOS_DISPONIBLES MD
	ON MD.COD_PROGRAMA_MODULO = PM.COD_PROGRAMA_MODULO
 WHERE MD.COD_PROGRAMA_MODULO IS NULL

 -- Mostrar el nombre y apellidos de los profesores han sido borrados

UPDATE PROFESORES_P
  SET BORRADO_P = 1
  WHERE ID_PROFESOR = 1110

  SELECT * FROM PROFESORES_P

SELECT NOMBRE_PROFESOR,PRIMER_APE_P,SEGUNDO_APE_P
FROM PROFESORES_P P LEFT JOIN MODULOS_DISPONIBLES MD
	ON P.ID_PROFESOR =MD.ID_PROFESOR
		LEFT JOIN HORARIOS_P H
			ON MD.COD_MODULO_DISPONIBLE = H.COD_MODULO_DISPONIBLE
WHERE BORRADO_P = 1


--Mostrar el carnet, nombre, primer apellido, segundo apellido, el nombre de la materia y el monto a pagar de la matricula de los estudiantes matriculados, donde el monto sea mayor o igual a 30000
SELECT M.ID_ESTUDIANTE,NOMBRE_ESTUDIANTE,PRIMER_APE_E,SEGUNDO_APE_E, NOMBRE_MODULO, MONTO 
FROM ESTUDIANTES_P E INNER JOIN MATRICULAS_P M
ON E.ID_ESTUDIANTE = M.ID_ESTUDIANTE
	INNER JOIN DETALLE_MATRICULAS_P DM
		ON DM.NUM_RECIBO = M.NUM_RECIBO
			INNER JOIN MODULOS_DISPONIBLES MD
				ON MD.COD_MODULO_DISPONIBLE = DM.COD_MODULO_DISPONIBLE
					INNER JOIN PROGRAMAS_MODULOS PM
						ON PM.COD_PROGRAMA_MODULO = MD.COD_PROGRAMA_MODULO
							INNER JOIN MODULOS
								ON MODULOS.COD_MODULO = PM.COD_MODULO
WHERE MONTO >= 300000
ORDER BY MONTO

		
--Mostrar el carnet, nombre, primer apellido, segundo apellido y la suma total del monto a pagar de la matricula de los estudiantes matriculados
SELECT M.ID_ESTUDIANTE,NOMBRE_ESTUDIANTE,PRIMER_APE_E,SEGUNDO_APE_E,COSTO_MODULO, SUM(MONTO) AS TOTAL_MONTO
FROM ESTUDIANTES_P E INNER JOIN MATRICULAS_P M
ON E.ID_ESTUDIANTE = M.ID_ESTUDIANTE
	INNER JOIN DETALLE_MATRICULAS_P DM
		ON DM.NUM_RECIBO = M.NUM_RECIBO
			INNER JOIN MODULOS_DISPONIBLES MD
				ON MD.COD_MODULO_DISPONIBLE = DM.COD_MODULO_DISPONIBLE
GROUP BY M.ID_ESTUDIANTE,NOMBRE_ESTUDIANTE,PRIMER_APE_E,SEGUNDO_APE_E,COSTO_MODULO
ORDER BY NOMBRE_ESTUDIANTE

SELECT * FROM MATRICULAS_P; -- EL UNICO MONTO QUE CAMBIA ES EL DE MARIEL ROJAS

-- Unir la tabla profesores y la tabla estudiantes, agrupando por el nombre del profesor
SELECT upper(NOMBRE_PROFESOR) AS NOMBRES,upper(PRIMER_APE_P) AS PRIMER_APELLIDO,upper(SEGUNDO_APE_P) AS SEGUNDO_APELLIDO FROM PROFESORES_P
UNION 
SELECT NOMBRE_ESTUDIANTE,PRIMER_APE_E,SEGUNDO_APE_E FROM ESTUDIANTES_P
ORDER BY upper(NOMBRE_PROFESOR)



--Muestre las sumas de los montos de las matriculas durante el mes 6
SELECT FECHA_HORA, SUM(MONTO) AS TOTAL_FECHA FROM MATRICULAS_P
WHERE MONTH(FECHA_HORA) = 6 
GROUP BY FECHA_HORA
HAVING SUM(MONTO) > 2
ORDER BY TOTAL_FECHA

--Subconsulta que muestra el NUM_RECIBO, la FECHA de matrícula, el MONTO de matrícula, y el promedio de las notas obtenidas por matricula.

SELECT NUM_RECIBO,FECHA_HORA,MONTO,(SELECT AVG(NOTA_FINAL)
                               FROM DETALLE_MATRICULAS_P DM
                               WHERE M.NUM_RECIBO=DM.NUM_RECIBO)AS PROMEDIO_NOTAS
FROM MATRICULAS_P M


-- Monto total de todas las matriculas
SELECT SUM(MONTO) AS MONTO_TOTAL FROM MATRICULAS_P -- 2535000
-- promedio total de las matriculas
SELECT AVG(MONTO) AS PROMEDIO_MONTO FROM MATRICULAS_P --230454
--Cantidad recibos de matriculas
SELECT COUNT(NUM_RECIBO) AS CANTIDAD_RECIBOS FROM MATRICULAS_P 


--Seleccionar Id_estudiante, el nombre del estudiante concatenado, la fecha de matrícula, el MONTO de matrícula y la suma del costo de las materias matriculadas.

SELECT DISTINCT E.ID_ESTUDIANTE,E.NOMBRE_ESTUDIANTE + ' ' + E.PRIMER_APE_E + ' ' + E.SEGUNDO_APE_E AS NOMBRE_COMPLETO,
M.NUM_RECIBO,FECHA_HORA,MONTO, 
		(SELECT SUM(COSTO_MODULO)
			FROM MODULOS_DISPONIBLES MD INNER JOIN DETALLE_MATRICULAS_P DM
			ON MD.COD_MODULO_DISPONIBLE = DM.COD_MODULO_DISPONIBLE
			WHERE DM.NUM_RECIBO = M.NUM_RECIBO) AS MONTO_CURSOS 
FROM ESTUDIANTES_p E INNER JOIN MATRICULAS_P M
		ON E.ID_ESTUDIANTE = M.ID_ESTUDIANTE
ORDER BY NOMBRE_COMPLETO

--Contar cantidad estudiantes y profesores
SELECT COUNT(*) AS CANTIDAD_ESTUDIANTES,(SELECT COUNT(*) FROM PROFESORES_P) AS CANTIDAD_PROFESORES
FROM ESTUDIANTES_P

--Seleccionar fecha y monto de los montos superiores al promedio
SELECT ID_ESTUDIANTE, FECHA_HORA, MONTO  FROM MATRICULAS_P
WHERE MONTO > (SELECT AVG(MONTO) FROM MATRICULAS_P); -- promedio = 230454.

-- Extraer los primeros 3 y los ultimos 3 digitos del usuario de la matricula de cada uno de los estudiantes
SELECT SUBSTRING(USUARIO_MATRICULA,1,3) AS INICIALES_NOMBRE_COMPLETO,
	   SUBSTRING(USUARIO_MATRICULA,4,3) AS ULTIMOS_DIGITOS_CEDULA
FROM MATRICULAS_P

-- Mostrar el nombre, primer y segundo apellido de los profesores en mayuscula y ordenarlos por el nombre
SELECT UPPER (NOMBRE_PROFESOR) AS NOMBRE_PROFESOR ,UPPER (PRIMER_APE_P) AS  PRIMER_APELLIDO_P,UPPER (SEGUNDO_APE_P) AS SEGUNDO_APELLIDO_P FROM PROFESORES_P 
ORDER BY NOMBRE_PROFESOR ASC


--VERIFICAR QUE TODO ESTE CORRECTO Y NO HAYA CHOQUES DE MODULOS, HORARIOS, PROFESORES. (POR EL MOMENTO)
SELECT MD.ID_PROFESOR,NOMBRE_PROFESOR,MA.NUM_RECIBO,MA.ID_ESTUDIANTE, NOMBRE_ESTUDIANTE, DIA,HORA_INICIO,HORA_FIN,NOMBRE_LAB, L.COD_HORARIO,COD_LABORATORIO, NOMBRE_MODULO,md.COD_MODULO_DISPONIBLE,pm.COD_MODULO,PM.COD_PROGRAMA,pm.COD_PROGRAMA_MODULO
FROM MODULOS_DISPONIBLES MD 
	FULL JOIN PROFESORES_P P
	ON MD.ID_PROFESOR = P.ID_PROFESOR
			FULL  JOIN PROGRAMAS_MODULOS PM
			ON PM.COD_PROGRAMA_MODULO = MD.COD_PROGRAMA_MODULO
				FULL  JOIN MODULOS M
				ON M.COD_MODULO = PM.COD_MODULO
					FULL  JOIN HORARIOS_P H
					ON H.COD_MODULO_DISPONIBLE = MD.COD_MODULO_DISPONIBLE
						FULL  JOIN LABORATORIOS L 
						ON L.COD_MODULO_DISPONIBLE= MD.COD_MODULO_DISPONIBLE
							FULL  JOIN DETALLE_MATRICULAS_P DM
							ON DM.COD_MODULO_DISPONIBLE = MD.COD_MODULO_DISPONIBLE
								FULL  JOIN MATRICULAS_P MA
								ON MA.NUM_RECIBO = DM.NUM_RECIBO
									FULL JOIN ESTUDIANTES_P E
									ON E.ID_ESTUDIANTE = MA.ID_ESTUDIANTE
ORDER BY NOMBRE_ESTUDIANTE ASC
select * from MODULOS_DISPONIBLES
--========================================================================================================================
--***************************************PROCEDIMIENTOS ALMACENADOS*******************************************************
-- CUATRO PROCEDIMIENTOS PARA 4 TABLAS

-- TABLA PROGRAMAS--

--1) INSERTAR UNA NUEVO PROGRAMA
SELECT * FROM PROGRAMAS
GO
CREATE OR ALTER PROCEDURE SP_INSERTAR_CARRERA(@cod_programa varchar(20) OUT,
											  @nombre_programa varchar(100),
											  @msj varchar(55) OUT) 
AS 
	BEGIN TRY
		BEGIN TRAN
			INSERT INTO PROGRAMAS(COD_PROGRAMA,NOMBRE_PROGRAMA)
			VALUES (@cod_programa,@nombre_programa)
			SET @msj = 'PROGRAMA INSERRTADO CORRECTAMENTE'
		COMMIT TRAN

	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @msj = ERROR_MESSAGE()
	END CATCH
GO
-- EJECUTAR PROCEDIMIENTO SP_INSERTAR_CARRERA
DECLARE	@return_value int,
		@cod_programa varchar(20),
		@msj varchar(55)

SELECT	@cod_programa = N'''NEW_001'''

EXEC	@return_value = [dbo].[SP_INSERTAR_CARRERA]
		@cod_programa = @cod_programa OUTPUT,
		@nombre_programa = N'''BASE DATOS''',
		@msj = @msj OUTPUT

SELECT	@cod_programa as N'@cod_programa',
		@msj as N'@msj'

SELECT	'Return Value' = @return_value

GO
--------------------------------------------------------------------------------------------------------------
--2) INSERTAR O ACTUALIZAR UN PROGRAMA
GO
CREATE or ALTER PROCEDURE SP_INSERT_ACTUAIZAR_PROG(@cod_programa varchar(20) OUT,
										   @nombre_programa varchar(100),
										   @msj varchar(55) OUT) 					
AS 
	BEGIN TRY
		BEGIN TRANSACTION 
			IF (NOT EXISTS (SELECT 1 FROM PROGRAMAS WHERE COD_PROGRAMA = @cod_programa)) --SI NO EXISTE SE AGREGA
				BEGIN 
						INSERT INTO PROGRAMAS(COD_PROGRAMA,NOMBRE_PROGRAMA)
						VALUES (@cod_programa,@nombre_programa)
						SET @msj = 'CARRERA INGRESADA CORRECTAMENTE'
				END
			ELSE -- SI EXISTE SE ACTUALIZA
				BEGIN 
					UPDATE PROGRAMAS
						SET NOMBRE_PROGRAMA = @nombre_programa
					WHERE COD_PROGRAMA = @cod_programa
					SET @msj = 'CARRERA ACTUALIZADA CORRECTAMENTE'
			    END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH 
		ROLLBACK TRANSACTION
		SET @msj = ERROR_MESSAGE()
	END CATCH 
GO

-- EJECUTAR PROCEDIMIENTO SP_INSERT_ACTUAIZAR_PROG
GO
DECLARE	@return_value int,
		@cod_programa varchar(20),
		@msj varchar(55)

SELECT	@cod_programa = N'''NEW_002'''

EXEC	@return_value = [dbo].[SP_INSERT_ACTUAIZAR_PROG]
		@cod_programa = @cod_programa OUTPUT,
		@nombre_programa = N'''BASE DATOS II''',
		@msj = @msj OUTPUT

SELECT	@cod_programa as N'@cod_programa',
		@msj as N'@msj'

SELECT	'Return Value' = @return_value

GO

SELECT * FROM PROGRAMAS
------------------------------------------------------------------------------------------------------------------
--3) ELIMINAR PROGRAMA, SI EL PROGRAMA NO EXISTE SE LANZA UN MENSAJE 
GO
CREATE or ALTER PROCEDURE SP_ELIMINAR_PROGRAMA(@cod_programa varchar(20) OUT,
											   @nombre_programa varchar(100),
										       @msj varchar(55) OUT) 					
AS 
	BEGIN TRY
		BEGIN TRANSACTION 
			IF (NOT EXISTS (SELECT 1 FROM PROGRAMAS WHERE COD_PROGRAMA = @cod_programa)) --SI NO EXISTE SE MUESTRA UN MENSAJE
				BEGIN 
						SET @msj = ' EL PROGRAMA NO EXISTE '
				END
			ELSE -- SI EXISTE SE ELIMINA 
				BEGIN 
					DELETE FROM PROGRAMAS WHERE COD_PROGRAMA = @cod_programa
					SET @msj = 'PROGRAMA ELIMINADO CORRECTAMENTE'
			    END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH 
		ROLLBACK TRANSACTION
		SET @msj = ERROR_MESSAGE()
	END CATCH 
GO

-- EJECUTAR PROCEDIMIENTO SP_INSERT_ACTUAIZAR_PROG
GO
DECLARE	@RC int,
		@cod_programa varchar(20),
		@nombre_programa varchar(100),
		@msj varchar(55)
SET @cod_programa ='NEW_001'
SET @nombre_programa ='BASE DATOS'

EXEC	@RC = [dbo].[SP_ELIMINAR_PROGRAMA]
		@cod_programa OUTPUT,
		@cod_programa,
		@msj = @msj OUTPUT
PRINT @msj
go

select * from PROGRAMAS
-------------------------------------------------------------------------------------------------------------
--4) LISTAR PROGRAMAS CON MODULOS
GO
CREATE OR ALTER PROCEDURE SP_LISTAR_PROG(@cod_programa varchar(20),
										 @nombre_programa varchar(100))
AS
	BEGIN 
		SELECT P.COD_PROGRAMA,NOMBRE_PROGRAMA,M.COD_MODULO,NOMBRE_MODULO
		FROM   PROGRAMAS P  
			INNER JOIN PROGRAMAS_MODULOS PM
			    ON P.COD_PROGRAMA = PM.COD_PROGRAMA
					INNER JOIN MODULOS M
						ON M.COD_MODULO = PM.COD_MODULO
	    WHERE P.COD_PROGRAMA = @cod_programa
END
GO

DECLARE @cod_programa varchar(20),@nombre_programa varchar(100)
SET @cod_programa = 'WEB1_006'
SET @nombre_programa = 'INGIENERIA ELECTRONICA'

EXECUTE [SP_LISTAR_PROG]
@cod_programa,
@nombre_programa
GO

SELECT * FROM PROGRAMAS

------------------------------------------------------------------------------------------------------------------
--===================================================================================================================
-- TABLA MODULOS--
--5) INSERTAR/CREAR UNA NUEVO MODULO 
SELECT * FROM MODULOS
GO
CREATE OR ALTER PROCEDURE SP_INSERTAR_MODULO(@cod_modulo varchar(10) OUT,
											 @nombre_modulo varchar(120),
											 @requisito varchar(50),
											 @msj varchar(55) OUT) 
AS 
	BEGIN TRY
		BEGIN TRAN
			INSERT INTO MODULOS(COD_MODULO,NOMBRE_MODULO)
			VALUES (@cod_modulo,@nombre_modulo)
			SET @msj = 'MODULO INSERRTADO CORRECTAMENTE'
		COMMIT TRAN

	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @msj = ERROR_MESSAGE()
	END CATCH
GO
--- EJECUCION PROCEDIMIENTO SP_INSERTAR_MODULO

DECLARE	@return_value int,
		@cod_modulo varchar(20),
		@msj varchar(55)

SELECT	@cod_modulo = N'''PSE_004'''

EXEC	@return_value = [dbo].[SP_INSERTAR_MODULO]
		@cod_modulo = @cod_modulo OUTPUT,
		@nombre_modulo = N'''CREACION BASE DATOS''',
		@requisito = NULL,
		@msj = @msj OUTPUT

SELECT	@cod_modulo as N'@cod_modulo',
		@msj as N'@msj'

SELECT	'Return Value' = @return_value

GO
SELECT * FROM MODULOS
SELECT * FROM PROGRAMAS
-------------------------------------------------------------------------------------------------------------
--6) INSERTA/ ACTUALIZAR UN MODULO
GO
CREATE or ALTER PROCEDURE SP_INSERT_ACTUAIZAR_MODU(@cod_modulo varchar(10) OUT,
												   @nombre_modulo varchar(120),
										           @msj varchar(55) OUT) 					
AS 
	BEGIN TRY
		BEGIN TRANSACTION 
			IF (NOT EXISTS (SELECT 1 FROM  MODULOS WHERE COD_MODULO = @cod_modulo)) --SI NO EXISTE SE AGREGA
				BEGIN 
						INSERT INTO MODULOS(COD_MODULO,NOMBRE_MODULO)
						VALUES (@cod_modulo,@nombre_modulo)
						SET @msj = 'MODULO INGRESADO CORRECTAMENTE'
				END
			ELSE -- SI EXISTE SE ACTUALIZA
				BEGIN 
					UPDATE MODULOS
						SET NOMBRE_MODULO = @nombre_modulo
					WHERE COD_MODULO = @cod_modulo
					SET @msj = 'MODULO ACTUALIZADO CORRECTAMENTE'
			    END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH 
		ROLLBACK TRANSACTION
		SET @msj = ERROR_MESSAGE()
	END CATCH 
GO
SELECT * FROM MODULOS
-- EJECUTAR PROCEDIMIENTO SP_INSERT_ACTUAIZAR_MODU

DECLARE	@RC int,
		@cod_modulo varchar(10),
		@nombre_modulo varchar(120),
		@msj varchar(55)

SET	@cod_modulo = 'PSE_005'
SET @nombre_modulo = 'NUEVO MODULO'

EXEC	@RC = [dbo].[SP_INSERT_ACTUAIZAR_MODU]
		@cod_modulo OUTPUT,
		@nombre_modulo,
		@msj OUTPUT
 PRINT @msj 
GO
SELECT * FROM MODULOS
-------------------------------------------------------------------------------------------------------------
--7) ELIMINAR UN MODULO, SI EL MODULO NO EXISTE MOSTRAR MENSAJE

GO
CREATE OR ALTER PROCEDURE SP_ELIMINAR_MODULO(@cod_modulo varchar(10) OUT,
										     @msj varchar(55) OUT) 
AS
	BEGIN TRY
		BEGIN TRAN
			 IF (NOT EXISTS(SELECT COD_MODULO FROM MODULOS -- SI EXISTE SE ELIMINA 
					WHERE COD_MODULO = @cod_modulo))
				BEGIN 
					SET @msj = 'EL MODULO NO EXISTE'
				END
			 ELSE -- SI NO EXISTE SE INDICA CON MENSAJE
				BEGIN 
					 DELETE FROM MODULOS 
					 WHERE COD_MODULO = @cod_modulo
					 SET @msj = 'MODULO ELIMINADO CORRECTAMENTE'
				END
		COMMIT TRAN 
	END TRY
	BEGIN CATCH 
		ROLLBACK TRAN
		SET @msj  = ERROR_MESSAGE()
	END CATCH 

GO

-- EJECUTAR PROCEDIMIENTO SP_INSERT_ACTUAIZAR_PROG
GO
DECLARE	@RC int,
		@cod_modulo varchar(20),
		@msj varchar(55)

SET @cod_modulo ='PSE_005'

EXEC	@RC = [dbo].[SP_ELIMINAR_MODULO]
		@cod_modulo OUTPUT,
		@msj = @msj OUTPUT
PRINT @msj
GO
SELECT * FROM MODULOS
-------------------------------------------------------------------------------------------------------------
--8) ASIGNAR UN MODULO A UN PROGRAMA
GO
CREATE OR ALTER PROCEDURE SP_ASIGNAAR_MODULO_PROG(@cod_programa_modulo int OUT,
												  @cod_modulo varchar(10),
												  @cod_programa varchar(20),
												  @msj varchar(150) OUT)
                                             	  
AS
    BEGIN TRY
        BEGIN TRAN
            IF(not exists (select 1 from PROGRAMAS_MODULOS where COD_PROGRAMA_MODULO = @cod_programa_modulo))
                BEGIN
                    INSERT INTO PROGRAMAS_MODULOS(COD_PROGRAMA,COD_MODULO)
                            VALUES(@cod_programa, @cod_modulo)
                    SELECT @cod_programa_modulo = IDENT_CURRENT('PROGRAMA_MODULO')  
					SET @msj = 'LA MATERIA HA SIDO ASIGNADA CORRECTAMENTE'
                END
        COMMIT TRAN
    END TRY   
	BEGIN CATCH
        ROLLBACK TRAN
        SET @msj = 'HA OCURRIDO UN ERROR AL ASIGNAR LA MATERIA A LA CARRERA . ' + ERROR_MESSAGE()
    END CATCH
GO
SELECT * FROM PROGRAMAS_MODULOS

-- EJECUTAR PROCEDIMIENTO SP_ASIGNAAR_MODULO_PROG
DECLARE	@return_value int,
		@cod_programa_modulo int,
		@msj varchar(150)

SELECT	@cod_programa_modulo = 13

EXEC	@return_value = [dbo].[SP_ASIGNAAR_MODULO_PROG]
		@cod_programa_modulo = @cod_programa_modulo OUTPUT,
		@cod_modulo = N'''PSE_004''',
		@cod_programa = N'''NEW_001''',
		@msj = @msj OUTPUT

SELECT	@cod_programa_modulo as N'@cod_programa_modulo',
		@msj as N'@msj'

SELECT	'Return Value' = @return_value

GO

select * from PROGRAMAS
SELECT * FROM MODULOS
SELECT * FROM PROGRAMAS_MODULOS

--------------------------------------------------------------------------------------------------------------------
--===================================================================================================================
-- TABLA ESTUDIANTES --
--9) INSERTAR/CREAR UN ESTUDIANTE
SELECT * FROM ESTUDIANTES_P
GO
CREATE OR ALTER PROCEDURE SP_INSERTAR_ESTUDIANTE(@id_estudiante int OUT,
												 @nombre_estudiante varchar(20),
												 @primer_apellido varchar(20),
												 @segundo_apellido varchar(20),
												 @telefono varchar(8),
												 @correo varchar(25),
												 @provincia varchar(20),
												 @estado varchar(3),
												 @borrado bit,
												 @msj varchar(55) OUT) 
AS
	BEGIN TRY
		BEGIN TRAN
			INSERT INTO ESTUDIANTES_P(ID_ESTUDIANTE,NOMBRE_ESTUDIANTE,PRIMER_APE_E,SEGUNDO_APE_E,TEL_ESTUDIANTE,CORREO_E,PROVINCIA,
			ESTADO_ESTUDIANTE,BORRADO_E)
			VALUES (@id_estudiante,@nombre_estudiante,@primer_apellido,@segundo_apellido,@telefono,@correo,@provincia,@estado,@borrado)
			SET @msj = 'ESTUDIANTE INSERTADO CORRECTAMENTE'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @msj = ERROR_MESSAGE()
	END CATCH
GO

-- EJECUTAR PROCEDIMIENTO [SP_INSERTAR_ESTUDIANTE]
GO
DECLARE	@RC int,
		@id_estudiante int,
		@nombre_estudiante varchar(20),
		@primer_apellido varchar(20),
		@segundo_apellido varchar(20),
		@telefono varchar(8),
		@correo varchar(25),
		@provincia varchar(20),
		@estado varchar(3),
		@borrado bit,
		@msj varchar(55) 

SET @id_estudiante = 204530198
SET @nombre_estudiante = 'CARMEN'
SET @primer_apellido = 'FUENTES'
SET @segundo_apellido = 'CORDERO'
SET @telefono = '24473443'
SET	@correo = '204530198@ina.cr'
SET	@provincia = 'HEREDIA'
SET	@estado = N'ACT'
SET	@borrado = 0

EXEC @RC = [dbo].[SP_INSERTAR_ESTUDIANTE]
@id_estudiante out,@nombre_estudiante ,@primer_apellido,@segundo_apellido ,@telefono,
		@correo,@provincia ,@estado ,@borrado,@msj out

GO

SELECT * FROM ESTUDIANTES_P;
-------------------------------------------------------------------------------------------------------------
--10) ACTUALIZAR DATOS DE UN ESTUDIANTE
GO
CREATE or ALTER PROCEDURE SP_ACTUALIZAR_ESTUDIANTE(@id_estudiante int OUT,
												 @nombre_estudiante varchar(20),
												 @primer_apellido varchar(20),
												 @segundo_apellido varchar(20),
												 @telefono varchar(8),
												 @correo varchar(25),
												 @provincia varchar(20),
												 @fecha date,
												 @estado varchar(3),
												 @borrado bit,
												 @msj varchar(55) OUT)  					
AS 
	BEGIN TRY
		BEGIN TRANSACTION 
			IF (NOT EXISTS (SELECT 1 FROM ESTUDIANTES_P WHERE ID_ESTUDIANTE= @id_estudiante)) --SI NO EXISTE SE AGREGA
				BEGIN 
					INSERT INTO ESTUDIANTES_P(ID_ESTUDIANTE,NOMBRE_ESTUDIANTE,PRIMER_APE_E,SEGUNDO_APE_E,
					TEL_ESTUDIANTE,CORREO_E,PROVINCIA,FECHA_INGRESO,ESTADO_ESTUDIANTE,BORRADO_E)
					VALUES (@id_estudiante,@nombre_estudiante,@primer_apellido,@segundo_apellido,
							@telefono,@correo,@provincia,@fecha,@estado,@borrado)
			SET @msj = 'ESTUDIANTE INSERTADO CORRECTAMENTE'
				END
			ELSE -- SI EXISTE SE ACTUALIZA
				BEGIN 
					UPDATE ESTUDIANTES_P
					SET ID_ESTUDIANTE = @id_estudiante,NOMBRE_ESTUDIANTE = @nombre_estudiante,
					PRIMER_APE_E = @primer_apellido,SEGUNDO_APE_E = @segundo_apellido,
					TEL_ESTUDIANTE=@telefono,CORREO_E=@correo,PROVINCIA=@provincia,
					FECHA_INGRESO = @fecha,ESTADO_ESTUDIANTE= @estado,BORRADO_E= @borrado
					WHERE ID_ESTUDIANTE = @id_estudiante
					SET @msj = 'ESTUDIANTE ACTUALIZADO CORRECTAMENTE'
			    END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH 
		ROLLBACK TRANSACTION
		SET @msj = ERROR_MESSAGE()
	END CATCH 
GO
-- EJECUTAR PROCEDIMIENTO [SP_INSERTAR_ESTUDIANTE]
GO
DECLARE	@RC int,
		@id_estudiante int,
		@nombre_estudiante varchar(20),
		@primer_apellido varchar(20),
		@segundo_apellido varchar(20),
		@telefono varchar(8),
		@correo varchar(25),
		@provincia varchar(20),
		@fecha date,
		@estado varchar(3),
		@borrado bit,
		@msj varchar(55) 

SET @id_estudiante = 204530198
SET @nombre_estudiante = 'CARMEN'
SET @primer_apellido = 'FUENTES'
SET @segundo_apellido = 'CORDERO'
SET @telefono = '24473443'
SET	@correo = '204530198@ina.cr'
SET	@provincia = 'ALAJUELA'
SET @fecha = GETDATE()
SET	@estado = 'ACT'
SET	@borrado = 0

EXEC @RC = [dbo].[SP_ACTUALIZAR_ESTUDIANTE]
@id_estudiante out,@nombre_estudiante ,@primer_apellido,@segundo_apellido ,@telefono,
		@correo,@provincia,@fecha,@estado ,@borrado,@msj out

GO

SELECT * FROM ESTUDIANTES_P
-------------------------------------------------------------------------------------------------------------
--11) ELIMINAR UN ESTUDIANTE SI EXISTE, SI NO MOSTRAR MENSAJE

GO
CREATE or ALTER PROCEDURE SP_ELIMINAR_ESTUD(@id_estudiante int OUT,								
												 @msj varchar(55) OUT)  					
AS 
	BEGIN TRY
		BEGIN TRANSACTION 
			IF (NOT EXISTS (SELECT 1 FROM ESTUDIANTES_P WHERE ID_ESTUDIANTE= @id_estudiante)) --SI NO EXISTE SE AGREGA
				BEGIN 
					SET @msj = 'EL ESTUDIANTE NO EXISTE'
				END
			ELSE -- SI EXISTE SE ACTUALIZA
				BEGIN 
					DELETE FROM ESTUDIANTES_P WHERE ID_ESTUDIANTE= @id_estudiante
					SET @msj = 'ESTUDIANTE ELIMINADO CORRECTAMENTE'
			    END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH 
		ROLLBACK TRANSACTION
		SET @msj = ERROR_MESSAGE()
	END CATCH 


GO

-- EJECUTAR PROCEDIMIENTO [SP_ELIMINAR_ESTUD]
GO
DECLARE	@RC int,
		@id_estudiante int,
		@msj varchar(55) 

SET @id_estudiante = 204530198

EXEC @RC = [dbo].[SP_ELIMINAR_ESTUD]
@id_estudiante out,@msj out
PRINT @msj
GO
-------------------------------------------------------------------------------------------------------------
--12) VERIFICAR SI UN ESTUDIANTE ESTA MATRICULADO 
CREATE OR ALTER PROCEDURE SP_MATRICULADOS (@id_estudiante int OUT)
AS 
BEGIN 
	IF NOT EXISTS (SELECT 1 FROM MATRICULAS_P
			WHERE ID_ESTUDIANTE = @id_estudiante)
		RETURN 1
	ELSE 
		RETURN 0
END
GO
--EJECUTAR PROCEDIMIENTO [SP_MATRICULADOS]
DECLARE @matriculados int,
		@id_estudiante int
SET @id_estudiante = 208030503
EXECUTE @id_estudiante = [dbo].[SP_MATRICULADOS]
@id_estudiante 
IF @id_estudiante = 1
		PRINT 'ESTUDIANTE NO ESTA MATRICULADO'
ELSE 
	PRINT 'EL ESTUDIANTE SI ESTA MATRICULADO'
GO
SELECT * FROM ESTUDIANTES_P


-- ------------------------------------------------------------------------------------------------------------------
-- TABLA PROFESORES --
--13) INSERTAR/CREAR UN PROFESOR 
SELECT * FROM PROFESORES_P
GO
CREATE OR ALTER PROCEDURE SP_INSERTAR_PROFESOR(@id_profesor int OUT,
												 @nombre_profesor varchar(25),
												 @primer_ape varchar(20),
												 @segundo_ape varchar(20),
												 @telefono varchar(8),
												 @correo varchar(25),
												 @provincia varchar(20),
												 @borrado bit,
												 @msj varchar(55) OUT) 
AS
	BEGIN TRY
		BEGIN TRAN
			INSERT INTO PROFESORES_P(ID_PROFESOR,NOMBRE_PROFESOR,PRIMER_APE_P,SEGUNDO_APE_P,TELEFONO_PROFESOR,CORREO_PROFESOR,
			PROVINCIA,BORRADO_P)
			VALUES (@id_profesor,@nombre_profesor,@primer_ape,@segundo_ape,@telefono,@correo,@provincia,@borrado)
			SET @msj = 'PROFESOR INSERTADO CORRECTAMENTE'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @msj = ERROR_MESSAGE()
	END CATCH
GO

-- EJECUTAR PROCEDIMIENTO [SP_INSERTAR_ESTUDIANTE]
GO
DECLARE	@RC int,
		@id_profesor int,
		@nombre_profesor varchar(25),
		@primer_ape varchar(20),
		@segundo_ape varchar(20),
		@telefono varchar(8),
		@correo varchar(25),
		@provincia varchar(20),
		@borrado bit,
		@msj varchar(55) 

SET @id_profesor = 202453045
SET @nombre_profesor = 'RODOLFO'
SET @primer_ape = 'ZUNIGA'
SET @segundo_ape = 'MURILLO'
SET @telefono = '24531987'
SET	@correo = '202453045@ina.cr'
SET	@provincia = 'ALAJUELA'
SET	@borrado = 0

EXEC @RC = [dbo].[SP_INSERTAR_PROFESOR]
@id_profesor out,@nombre_profesor ,@primer_ape,@segundo_ape ,@telefono,
		@correo,@provincia,@borrado,@msj out

GO

SELECT * FROM PROFESORES_P;
-------------------------------------------------------------------------------------------------------------
--14) ACTUALIZAR DATOS DE UN PROFESOR
GO
CREATE or ALTER PROCEDURE SP_ACTUALIZAR_PROFESOR(@id_profesor int OUT,
												 @nombre_profesor varchar(25),
												 @primer_ape varchar(20),
												 @segundo_ape varchar(20),
												 @telefono varchar(8),
												 @correo varchar(25),
												 @provincia varchar(20),
												 @borrado bit,
												 @msj varchar(55) OUT)  					
AS 
	BEGIN TRY
		BEGIN TRANSACTION 
			IF (NOT EXISTS (SELECT 1 FROM PROFESORES_P WHERE ID_PROFESOR= @id_profesor)) --SI NO EXISTE SE AGREGA
				BEGIN 
					INSERT INTO PROFESORES_P(ID_PROFESOR,NOMBRE_PROFESOR,PRIMER_APE_P,
								SEGUNDO_APE_P,TELEFONO_PROFESOR,CORREO_PROFESOR,PROVINCIA,BORRADO_P)
			VALUES (@id_profesor,@nombre_profesor,@primer_ape,@segundo_ape,@telefono,@correo,@provincia,@borrado)
			SET @msj = 'PROFESOR INSERTADO CORRECTAMENTE'
				END
			ELSE -- SI EXISTE SE ACTUALIZA
				BEGIN 
					UPDATE PROFESORES_P
					SET ID_PROFESOR = @id_profesor,
					NOMBRE_PROFESOR = @nombre_profesor,
					PRIMER_APE_P = @primer_ape,
					SEGUNDO_APE_P = @segundo_ape,
					TELEFONO_PROFESOR = @telefono,
					CORREO_PROFESOR =@correo,
					PROVINCIA=@provincia,
					BORRADO_P= @borrado
					WHERE ID_PROFESOR = @id_profesor
					SET @msj = 'PROFESOR ACTUALIZADO CORRECTAMENTE'
			    END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH 
		ROLLBACK TRANSACTION
		SET @msj = ERROR_MESSAGE()
	END CATCH 
GO
-- EJECUTAR PROCEDIMIENTO [SP_INSERTAR_ESTUDIANTE]
GO
DECLARE	@RC int,
		@id_profesor int,
		@nombre_profesor varchar(25),
		@primer_ape varchar(20),
		@segundo_ape varchar(20),
		@telefono varchar(8),
		@correo varchar(25),
		@provincia varchar(20),
		@borrado bit,
		@msj varchar(55) 

SET @id_profesor = 202453045
SET @nombre_profesor = 'Rodolfo'
SET @primer_ape = 'Zuniga'
SET @segundo_ape = 'Murillo'
SET @telefono = '24531987'
SET	@correo = '202453045@ina.cr'
SET	@provincia = 'ALAJUELA'
SET	@borrado = 0

EXEC @RC = [dbo].[SP_ACTUALIZAR_PROFESOR]
@id_profesor out,@nombre_profesor ,@primer_ape,@segundo_ape ,@telefono,
		@correo,@provincia,@borrado,@msj out

GO
SELECT * FROM PROFESORES_P;

-------------------------------------------------------------------------------------------------------------
--15) ELIMINAR UN PROFESOR SI EXISTE, SI EXISTE NO MOSTRAR MENSAJE

GO
CREATE or ALTER PROCEDURE SP_ELIMINAR_PROFESOR(@id_profesor int OUT,								
												 @msj varchar(55) OUT)  					
AS 
	BEGIN TRY
		BEGIN TRANSACTION 
			IF (NOT EXISTS (SELECT 1 FROM  PROFESORES_P  WHERE ID_PROFESOR= @id_profesor)) --SI NO EXISTE SE AGREGA
				BEGIN 
					SET @msj = 'EL PROFESOR NO EXISTE'
				END
			ELSE -- SI EXISTE SE ACTUALIZA
				BEGIN 
					DELETE FROM PROFESORES_P WHERE ID_PROFESOR= @id_profesor
					SET @msj = 'PROFESOR ELIMINADO CORRECTAMENTE'
			    END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH 
		ROLLBACK TRANSACTION
		SET @msj = ERROR_MESSAGE()
	END CATCH 


GO

-- EJECUTAR PROCEDIMIENTO [SP_ELIMINAR_PROFESOR]
GO
DECLARE	@RC int,
		@id_profesor int,
		@msj varchar(55) 

SET @id_profesor = 202453045

EXEC @RC = [dbo].[SP_ELIMINAR_PROFESOR]
@id_profesor out,@msj out
PRINT @msj
GO
SELECT * FROM PROFESORES_P
-------------------------------------------------------------------------------------------------------------
--16) VERIFICAR SI UN PROFESOR TIENE CURSOS ASIGNADOS
GO
CREATE OR ALTER PROCEDURE SP_PROFESOR_LIBRE(@id_profesor int OUT)
AS 
BEGIN 
	IF NOT EXISTS (SELECT 1 FROM MODULOS_DISPONIBLES
			WHERE ID_PROFESOR= @id_profesor)
		RETURN 1
	ELSE 
		RETURN 0
END
GO
--EJECUTAR PROCEDIMIENTO [SP_MATRICULADOS]
DECLARE @condicion int,
		@id_profesor int
SET @id_profesor  = 1010 -- MAURICIO 

EXECUTE @id_profesor = [dbo].[SP_PROFESOR_LIBRE]
@id_profesor 
IF @id_profesor = 1
		PRINT 'PROFESOR NO TIENE MODULOS ASIGNADOS'
ELSE 
	PRINT 'PROFESOR SI TIENE MODULOS ASIGNADOS'
GO
SELECT * FROM PROFESORES_P
-------------------------------------------------------------------------------------------------------------
--17) MOSTRAR EL CODIGO Y NOMBRE DEL MODULO,Y EL HORARIO CONCATENADO DE
--	TODOS LOS CURSOS ABIERTOS ORDENADOS POR NOMBRE DE MATERIA 

SELECT * FROM MODULOS
SELECT * FROM MODULOS_DISPONIBLES
SELECT * FROM HORARIOS_P

GO
CREATE OR ALTER PROCEDURE SP_MOSTRAR_MODULOS
AS
	BEGIN 
		SELECT M.COD_MODULO,M.NOMBRE_MODULO, 'DIA : ' +CAST(DIA AS varchar) + ' de: ' + CONVERT(varchar, HORA_INICIO,108) + 
		' a: ' + CONVERT(varchar,HORA_FIN) AS HORARIO 
		FROM MODULOS_DISPONIBLES MD
			INNER JOIN PROGRAMAS_MODULOS PM
				ON MD.COD_PROGRAMA_MODULO = MD.COD_PROGRAMA_MODULO
					INNER JOIN MODULOS M
						ON PM.COD_MODULO = M.COD_MODULO
							INNER JOIN HORARIOS_P H
								ON MD.COD_MODULO_DISPONIBLE= H.COD_MODULO_DISPONIBLE
		  ORDER BY M.NOMBRE_MODULO
	END 
GO
-- EJECUCION PROCEDIMIENTO SP_MOSTRAR_MODULOS
DECLARE	@RC int
EXEC	@RC = [dbo].[SP_MOSTRAR_MODULOS]
GO
-------------------------------------------------------------------------------------------------------------
--18) MOSTRAR NOMBRE DE LOS MODULOS QUE NO HAN SIO MATRICULADOS

CREATE or ALTER PROCEDURE SP_MODULOS_NO_MATRIC(@cod_modulo varchar(10) OUT,
											   @nombre_modulo varchar(120),
										       @msj varchar(55) OUT) 
AS 
	BEGIN TRY
		SELECT DM.NUM_RECIBO,NOMBRE_MODULO
		FROM  PROGRAMAS_MODULOS PM LEFT JOIN MODULOS_DISPONIBLES MD
			ON  PM.COD_PROGRAMA_MODULO = MD.COD_PROGRAMA_MODULO
				LEFT JOIN MODULOS M 
					ON  PM.COD_MODULO = M.COD_MODULO 
					LEFT JOIN DETALLE_MATRICULAS_P DM
						ON DM.COD_MODULO_DISPONIBLE = MD.COD_MODULO_DISPONIBLE
		WHERE NUM_RECIBO IS NULL

	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @msj = ERROR_MESSAGE()
	END CATCH

GO
-- EJECUCION PROCEDIMIENTO SP_MODULOS_NO_MATRIC
DECLARE @cod_modulo varchar(10),@nombre_modulo varchar(120),  @msj varchar(55) 
EXECUTE [SP_MODULOS_NO_MATRIC]
		@cod_modulo,@nombre_modulo,@msj 

GO 
-------------------------------------------------------------------------------------------------------------
--19) MOSTRAR NOMBRE Y APELLIDOS DE LOS PROFESORES QUE TIENEN CURSOS DE LUNES A VIERNES Y NO HAN SIDO BORRADOS


SELECT * FROM MODULOS_DISPONIBLES
SELECT * FROM PROFESORES_P

GO
CREATE or ALTER PROCEDURE SP_PROFESOR_HORARIOS (@nombreCompleto varchar(65),
											   @borrado bit,
											   @msj varchar (35))
AS 
	BEGIN TRY
		SELECT NOMBRE_PROFESOR + ' ' + PRIMER_APE_P + ' ' + SEGUNDO_APE_P AS NOMBRE_COMPLETO,BORRADO_P,DIA
		FROM PROFESORES_P P INNER JOIN MODULOS_DISPONIBLES MD
			ON P.ID_PROFESOR = MD.ID_PROFESOR 
				INNER JOIN HORARIOS_P H
				 ON H.COD_MODULO_DISPONIBLE = MD.COD_MODULO_DISPONIBLE
		WHERE DIA IN ('L','M','K','J','V') and BORRADO_P = 0		
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @msj = ERROR_MESSAGE()
	END CATCH

GO
-- EJECUCION PROCEDIMIENTO SP_PROFESOR_HORARIOS
DECLARE @nombreCompleto varchar(45),@borrado bit, @msj varchar (35)
EXECUTE [SP_PROFESOR_HORARIOS]
	@nombreCompleto,@borrado,@msj 
GO
--------------------------------------------------------------------------------------------------------------------------
--========================================================================================================================
--************************************************** FUNCIONES ***********************************************************
--1) VERIFICAR SI UN ESTUDIANTE EXISTE O NO EXISTE (Funcion Escalar)
GO
CREATE OR ALTER FUNCTION FN_BUSCAR_ESTUDIANTE(@id_estudiante int)
RETURNS INT
AS 
	BEGIN 
		DECLARE @encontrado int
		IF (exists (Select 1 from ESTUDIANTES_P 
		WHERE ID_ESTUDIANTE = @id_estudiante))
			BEGIN 
				SET @encontrado = 1
			END 
		ELSE 
			SET @encontrado = 0
			RETURN @encontrado
	END
GO
--EJECUCION DE LA FUNCION FN_BUSCAR_ESTUDIANTE

GO
DECLARE @buscado int, @id_estudiante int
SET @id_estudiante = 208030487

SET @buscado = DBO.FN_BUSCAR_ESTUDIANTE(@id_estudiante)
IF @buscado = 1
	PRINT 'EL ESTUDIANTE CON EL ID ' + CAST(@id_estudiante AS varchar) + ' SI EXISTE'
ELSE
PRINT 'EL ESTUDIANTE CON EL ID ' + CAST(@id_estudiante AS varchar) + ' NO EXISTE'

GO
--------------------------------------------------------------------------------------------------------------------------
--2) CREAR FUNCION QUE MUESTRE LA LISTA DE MODULOS SU CODIGO Y SUS REQUISITOS
SELECT * FROM MODULOS

GO
CREATE OR ALTER FUNCTION FN_MOSTRAR_MODULOS() 
RETURNS TABLE AS
	RETURN 
	(SELECT DISTINCT M.COD_MODULO,NOMBRE_MODULO,REQUISITOS
	FROM MODULOS M LEFT JOIN PROGRAMAS_MODULOS PM
	ON M.COD_MODULO = PM.COD_MODULO)
GO
-- FUNCION PUEDE USARSE COMO UNA TABLA
SELECT * FROM FN_MOSTRAR_MODULOS() 

--------------------------------------------------------------------------------------------------------------------------
--3) FUNCION QUE MUESTRA EL CODIGO, NOMBRE DEL PROFESOR, EL CODIGO, NOMBRE DEL MODULO QUE IMPARTE Y SU HORARIO

GO
CREATE or ALTER FUNCTION FN_PROFESORES_MODULOS()
RETURNS TABLE AS 
	RETURN (
		SELECT MD.ID_PROFESOR,NOMBRE_PROFESOR,M.COD_MODULO,NOMBRE_MODULO, DIA,HORA_INICIO,HORA_FIN
		FROM PROFESORES_P E INNER JOIN MODULOS_DISPONIBLES MD
		ON E.ID_PROFESOR = MD.ID_PROFESOR
			INNER JOIN PROGRAMAS_MODULOS PM
			ON PM.COD_PROGRAMA_MODULO = MD.COD_PROGRAMA_MODULO
				INNER JOIN MODULOS M
				ON M.COD_MODULO = PM.COD_MODULO
					INNER JOIN HORARIOS_P H
					ON H.COD_MODULO_DISPONIBLE = MD.COD_MODULO_DISPONIBLE)
GO

SELECT * FROM FN_PROFESORES_MODULOS()
GO
--------------------------------------------------------------------------------------------------------------------------
--4) FUNCION QUE MUESTRA LA LISTA DE MODULOS, SU CODIGO NOMBRE,REQUISITOS 
--   Y EL NOMBRE DE LA CARRERA A LA QUE PERTENECE CADA MODULO
GO
CREATE or ALTER FUNCTION FN_MOSTRAR_MODULOS()
RETURNS TABLE AS 
	RETURN (
		SELECT M.COD_MODULO,NOMBRE_MODULO,REQUISITOS,PM.COD_PROGRAMA, NOMBRE_PROGRAMA
		FROM PROGRAMAS_MODULOS PM RIGHT JOIN MODULOS M
			ON PM.COD_MODULO = M.COD_MODULO
			  INNER JOIN PROGRAMAS P
			  ON PM.COD_PROGRAMA = P.COD_PROGRAMA)
GO

SELECT * FROM FN_MOSTRAR_MODULOS()
GO

--------------------------------------------------------------------------------------------------------------------------
--5) FUNCION PARA MOSTRAR EL NOMBRE DE LOS PROGRAMAS Y LA CANTIDAD DE MODULOS CORRESPONDIENTE DE CADA PROGRAMA 
SELECT * FROM MODULOS;
SELECT * FROM PROGRAMAS;
GO
CREATE OR ALTER FUNCTION FN_CANT_MODULOS_X_PROGRAMA()
RETURNS @TMP_PROGRAMAS TABLE (ID int IDENTITY PRIMARY KEY,
							NOMBRE_PROGRAMA varchar(100),
							CANTIDAD_MAT int)
AS
BEGIN
	INSERT INTO @TMP_PROGRAMAS
        SELECT NOMBRE_PROGRAMA,COUNT(PM.COD_MODULO) AS CANTIDAD_MODULOS
                FROM PROGRAMAS_MODULOS PM INNER JOIN PROGRAMAS P
                ON P.COD_PROGRAMA = PM.COD_PROGRAMA
             GROUP BY  NOMBRE_PROGRAMA
 RETURN
END
GO
-- EJECUCION DE LA FUNCION FN_CANT_MODULOS_X_PROGRAMA()
 SELECT * FROM FN_CANT_MODULOS_X_PROGRAMA()
SELECT * FROM MODULOS;
SELECT * FROM PROGRAMAS;

--------------------------------------------------------------------------------------------------------------------------
--6) VERIFICAR SI UN PROFESOR EXISTE O NO EXISTE
GO
CREATE OR ALTER FUNCTION FN_BUSCAR_PROFESOR(@id_profesor int)
RETURNS INT
AS 
	BEGIN 
		DECLARE @encontrado int
		IF (exists (Select 1 from PROFESORES_P
		WHERE ID_PROFESOR = @id_profesor))
			BEGIN 
				SET @encontrado = 1
			END 
		ELSE 
			SET @encontrado = 0
			RETURN @encontrado
	END
GO
--EJECUCION DE LA FUNCION FN_BUSCAR_PROFESOR
SELECT * FROM PROFESORES_P
GO
DECLARE @buscado int, @id_profesor int
SET @id_profesor =2222

SET @buscado = DBO.FN_BUSCAR_PROFESOR(@id_profesor)
IF @buscado = 1
	PRINT 'EL ESTUDIANTE CON EL ID ' + CAST(@id_profesor AS varchar) + ' SI EXISTE'
ELSE
PRINT 'EL ESTUDIANTE CON EL ID ' + CAST(@id_profesor AS varchar) + ' NO EXISTE'
GO

--------------------------------------------------------------------------------------------------------------------------
--7) MOSTRAR EL NOMBRE DE LOS ESTUDIANTES Y EL CODIGO, NOMBRE Y EL HORARIO QUE TIENEN
SELECT * FROM ESTUDIANTES_P
SELECT * FROM HORARIOS_P
SELECT * FROM MODULOS
GO
CREATE or ALTER FUNCTION FN_ESTUDIANTES_MODULOS()
RETURNS TABLE AS 
	RETURN (
		SELECT M.ID_ESTUDIANTE,NOMBRE_ESTUDIANTE,PM.COD_MODULO,NOMBRE_MODULO, DIA, HORA_INICIO,HORA_FIN
		FROM ESTUDIANTES_P E INNER JOIN MATRICULAS_P M
		 ON E.ID_ESTUDIANTE = M.ID_ESTUDIANTE
			INNER JOIN DETALLE_MATRICULAS_P DM
			ON DM.NUM_RECIBO = M.NUM_RECIBO
				INNER JOIN MODULOS_DISPONIBLES MD
				ON MD.COD_MODULO_DISPONIBLE = DM.COD_MODULO_DISPONIBLE
				 INNER JOIN PROGRAMAS_MODULOS PM
				 ON PM.COD_PROGRAMA_MODULO = MD.COD_PROGRAMA_MODULO
				  INNER JOIN MODULOS MO
				   ON MO.COD_MODULO = PM.COD_MODULO
				    INNER JOIN HORARIOS_P H
					 ON H.COD_MODULO_DISPONIBLE = MD.COD_MODULO_DISPONIBLE
		)
GO
-- EJECUCCION FN_ESTUDIANTES_MODULOS()
SELECT * FROM FN_ESTUDIANTES_MODULOS()
GO

--------------------------------------------------------------------------------------------------------------------------
--8) MOSTRAR EL NOMBRE Y ID DE LOS ESTUDIANTES Y EL DE LOS PROFESORES QUE IMPARTEN LOS MODULOS , Y EL HORARIO
SELECT * FROM ESTUDIANTES_P
SELECT * FROM HORARIOS_P
SELECT * FROM MODULOS
GO
CREATE or ALTER FUNCTION FN_EST_PROF_MODULOS()
RETURNS TABLE AS 
	RETURN (
		SELECT M.ID_ESTUDIANTE,NOMBRE_ESTUDIANTE,MD.ID_PROFESOR,NOMBRE_PROFESOR,PM.COD_MODULO,NOMBRE_MODULO, DIA, HORA_INICIO,HORA_FIN
		FROM ESTUDIANTES_P E INNER JOIN MATRICULAS_P M
		 ON E.ID_ESTUDIANTE = M.ID_ESTUDIANTE
			INNER JOIN DETALLE_MATRICULAS_P DM
			ON DM.NUM_RECIBO = M.NUM_RECIBO
				INNER JOIN MODULOS_DISPONIBLES MD
				ON MD.COD_MODULO_DISPONIBLE = DM.COD_MODULO_DISPONIBLE
				 INNER JOIN PROGRAMAS_MODULOS PM
				 ON PM.COD_PROGRAMA_MODULO = MD.COD_PROGRAMA_MODULO
				  INNER JOIN MODULOS MO
				   ON MO.COD_MODULO = PM.COD_MODULO
				    INNER JOIN HORARIOS_P H
					 ON H.COD_MODULO_DISPONIBLE = MD.COD_MODULO_DISPONIBLE
					 INNER JOIN PROFESORES_P PR
					 ON PR.ID_PROFESOR = MD.ID_PROFESOR)

GO
-- EJECUCION FUNCION FN_EST_PROF_MODULOS()
SELECT * FROM FN_EST_PROF_MODULOS()
GO

--------------------------------------------------------------------------------------------------------------------------
--9) MOSTRAR EL NOMBRE DE LOS MODULOS Y EL HORARIO EN EL QUE SE IMPARTEN 
GO
CREATE or ALTER FUNCTION FN_HORARIOS_MODULOS()
RETURNS TABLE AS 
	RETURN (
		SELECT PM.COD_MODULO,NOMBRE_MODULO, 'DIA : ' +CAST(DIA AS varchar) + ' de: ' + CONVERT(varchar, HORA_INICIO,108) + 
		' a: ' + CONVERT(varchar,HORA_FIN) AS HORARIO 
		FROM  MODULOS_DISPONIBLES MD INNER JOIN PROGRAMAS_MODULOS PM
				 ON PM.COD_PROGRAMA_MODULO = MD.COD_PROGRAMA_MODULO
				  INNER JOIN MODULOS MO
				   ON MO.COD_MODULO = PM.COD_MODULO
				    INNER JOIN HORARIOS_P H
					 ON H.COD_MODULO_DISPONIBLE = MD.COD_MODULO_DISPONIBLE)
					

GO
-- EJECUCION FUNCION FN_HORARIOS_MODULOS()
SELECT * FROM FN_HORARIOS_MODULOS()
GO

--------------------------------------------------------------------------------------------------------------------------
--10) MOSTRAR LA SUMA DE LOS COSTOS TOTALES DE LOS MODULOS DEPENDIENTO DE SU PROGRAMA 

GO 
CREATE or ALTER FUNCTION FN_COSTO_PROGRAMAS()
RETURNS TABLE AS 
	RETURN (
		SELECT  MD.COD_PROGRAMA_MODULO,NOMBRE_PROGRAMA,NOMBRE_MODULO,MO.COD_MODULO,COSTO_MODULO
		FROM  MODULOS_DISPONIBLES MD INNER JOIN PROGRAMAS_MODULOS PM
				 ON PM.COD_PROGRAMA_MODULO = MD.COD_PROGRAMA_MODULO
				  INNER JOIN MODULOS MO
				   ON MO.COD_MODULO = PM.COD_MODULO
				    INNER JOIN PROGRAMAS P
						ON P.COD_PROGRAMA = PM.COD_PROGRAMA)
GO

-- EJECUCION DE PROCEDIMIENTO FN_COSTO_PROGRAMAS()
SELECT * FROM FN_COSTO_PROGRAMAS()
GO


--------------------------------------------------------------------------------------------------------------------------
--11) MOSTRAR ESTUDIANTES QUE NO TIENEN UNA MATRICULA 
GO 
CREATE or ALTER FUNCTION FN_ESTUDIANTES_NO_MATRICULADOS()
RETURNS TABLE AS 
	RETURN (SELECT E.ID_ESTUDIANTE,NOMBRE_ESTUDIANTE,PRIMER_APE_E,SEGUNDO_APE_E, NUM_RECIBO
			FROM ESTUDIANTES_P E LEFT JOIN MATRICULAS_P M
			ON E.ID_ESTUDIANTE = M.ID_ESTUDIANTE
					WHERE M.ID_ESTUDIANTE IS NULL )
GO

-- EJECUCION DE PROCEDIMIENTO  FN_ESTUDIANTES_NO_MATRICULADOS()
SELECT * FROM  FN_ESTUDIANTES_NO_MATRICULADOS()
GO

--------------------------------------------------------------------------------------------------------------------
--==================================================================================================================
-- TRIGGERS 

--1) TRIGGER QUE CUANDO UN ESTUDIANTE REALICE UNA MATRICULA SU ESTADO SE ACTUALICE A ACT EN LA TABLA ESTUDIANTES 
GO 
CREATE TRIGGER TR_FI_ACTIVAR_ESTUDIANTE
ON MATRICULAS_P FOR INSERT 
AS 
	DECLARE @id_estudiante int
	SELECT @id_estudiante = ID_ESTUDIANTE FROM inserted 
	UPDATE MATRICULAS_P
	SET ESTADO_M = 'ACT' FROM inserted 
	WHERE MATRICULAS_P.ID_ESTUDIANTE = @id_estudiante
	UPDATE ESTUDIANTES_P
	SET ESTADO_ESTUDIANTE = 'ACT' 
	WHERE ID_ESTUDIANTE = @id_estudiante

--2)TRIGGER QUE SE EJECUTA CADA VEZZ QUE SE ELIMINA UN DETALLE MATRICULA SI NO QUEDAN MAS DETALLES DE DICHA MATRIUCLA 
-- TAMBIEN SE DEBE ELIMINAR LA MATRICULA (NO DEBEN EXISTIR MATRICULAS SIN MATERIAS MATRICULADAS)
SELECT * FROM DETALLE_MATRICULAS_P
GO
CREATE OR ALTER TRIGGER TR_AD_DETALLE_MATRICULA
ON DETALLE_MATRICULAS_P
AFTER DELETE 
AS
	 BEGIN 
		DECLARE @num_recibo int
		SELECT @num_recibo = NUM_RECIBO FROM deleted
		IF EXISTS (SELECT * FROM DETALLE_MATRICULAS_P WHERE NUM_RECIBO = @num_recibo)
		  PRINT 'SE ELIMINO SOLAMENTE EL DETALLE DE MATRICULA'
		ELSE 
			BEGIN
				DELETE FROM MATRICULAS_P  WHERE NUM_RECIBO = @num_recibo
				PRINT 'SE ELIMINO EL DETALLE DE MATRICULA Y LA MATRICULA VINCULADA'
			END
	 END
--  EJECUCION TRIGGER TR_AD_DETALLE_MATRICULA
DELETE FROM DETALLE_MATRICULAS_P WHERE COD_MODULO_DISPONIBLE = 10

SELECT * FROM DETALLE_MATRICULAS_P
SELECT * FROM MATRICULAS_P

--3)  TRIGGER QUE SE EJECUTA CADA VEZ QUE SE BORRA UNA MATRICULA Y SE BORRA LOS DETALLES DE MATRICULA CORRESPONDIENTES
SELECT * FROM MATRICULAS_P
SELECT * FROM DETALLE_MATRICULAS_P
GO
CREATE OR ALTER TRIGGER TR_ID_ELIMINAR_MATRICULA
ON MATRICULAS_P
INSTEAD OF DELETE 
AS 
	BEGIN 
		DECLARE @num_recibo int
		SELECT @num_recibo = NUM_RECIBO FROM deleted
		IF EXISTS (SELECT * FROM DETALLE_MATRICULAS_P WHERE NUM_RECIBO = @num_recibo)
			BEGIN
				DELETE FROM DETALLE_MATRICULAS_P WHERE NUM_RECIBO = @num_recibo
				DELETE FROM MATRICULAS_P  WHERE NUM_RECIBO = @num_recibo
			END 
		ELSE 
			BEGIN 
				PRINT 'NO HAY MATRICULAS POR ELIMINAR'
			END
	 END
-- EJECUCION DEL TRIGGER
DELETE FROM MATRICULAS_P WHERE NUM_RECIBO = 11


--4). Crear un TRIGGER que se ejecute cada vez que se elimine un MODULO_DISPONIBLE. Debe eliminar los horarios que tenga asociados.
--Asegúrese que la MATERIA_ABIERTA a eliminar, no puede estar relacionada con la tabla DETALLE_MATRICULAS. 
GO
	CREATE OR ALTER TRIGGER TR_ID_MODULOS_DISPONIBLES
	ON MODULOS_DISPONIBLES
	INSTEAD OF DELETE 
	AS 
		DECLARE @cod_modulo_disponible INT
		SELECT @cod_modulo_disponible = COD_MODULO_DISPONIBLE FROM inserted

		IF EXISTS(SELECT 1 FROM HORARIOS_P WHERE COD_MODULO_DISPONIBLE = @cod_modulo_disponible)
			BEGIN 
				DELETE FROM HORARIOS_P
				WHERE @cod_modulo_disponible = COD_MODULO_DISPONIBLE
			END
		ELSE 
			PRINT 'ESTE MODULO NO ES POSIBLE ELIMINARLO PORQUE HAY MATRICULAS ASOCIADAS'
			
DELETE FROM MODULOS_DISPONIBLES
WHERE COD_PROGRAMA_MODULO = 5;

--5) TRIGGER EN LA TABLA PROFESORES QUE SE ACTIVA CUANDO SE DESEA INSERTAR UN NUEVO PROFESOR,
--EN LUGAR DE INSERTAR SE MUESTRA UN MENSAJE
GO
CREATE OR ALTER TRIGGER TR_II_PROFESORES_P
ON PROFESORES_P --  SE DISPARA EN TABLA PRODUCTOS
INSTEAD OF INSERT 
AS
	PRINT 'SE INGRESO UN PROFESOR'
		
INSERT INTO PROFESORES_P(ID_PROFESOR,NOMBRE_PROFESOR,PRIMER_APE_P,
					SEGUNDO_APE_P,TELEFONO_PROFESOR,CORREO_PROFESOR,PROVINCIA,BORRADO_P)
			VALUES (2021,'Juan','Salas','Barrantes','83451945','2021@ina.cr','Heredia',0)

SELECT * FROM PROFESORES_P;
GO

--6) TRIGGER QUE SE DISPARA CUANDO HAY UNA ACTUALIZACION EN LA TABLA ESTUDIANTES
GO
CREATE OR ALTER TRIGGER TR_UD_ESTUDIANTES
ON ESTUDIANTES_P
FOR UPDATE
AS 
		PRINT 'SE ACTUALIZO UN ESTUDIANTE'


UPDATE ESTUDIANTES_P
SET PROVINCIA = 'GUANACASTE'
WHERE ID_ESTUDIANTE = '204070904'

	SELECT * FROM ESTUDIANTES_P

--7) TRIGGER QUE SE DISPARA CUANDO SE ACTUALIZA O ELIMINA UNA MATRICULA -- YA AQUI HAY UN TRIGGER INSTEAD OF, POR LO QUE PREDOMINA ESE TRIGGER ANTES QUE ESTE
-- RECORDAR QUE UNICAMNTE SE PUEDE HACER UN INSTEAD OF POR TABLA
GO
CREATE OR ALTER TRIGGER TR_FUD_MATRICULAS
ON MATRICULAS_P --  SE DISPARA EN TABLA PRODUCTOS
FOR UPDATE,DELETE
AS

	PRINT 'SE ACTUALIZO O SE BORRO UNA MATRICULA' -- SE EJECUTA EL TRIGGER TR_ID_ELIMINAR_MATRICULA PREDOMINA EL INSTEAD OF

DELETE FROM MATRICULAS_P
WHERE USUARIO_MATRICULA = 'MRS487'

SELECT * FROM MATRICULAS_P

--DESABILITAR TRIGGER
ALTER TABLE MATRICULAS_P
DISABLE TRIGGER TR_FUD_MATRICULAS


--8) TRIGGER DE SEGUIRIDAD DE TABLAS
--GO
--CREATE TRIGGER TR_SEGURIDAD ON DATABASE
--FOR DROP_TABLE, ALTER_TABLE
--AS 
--	BEGIN 
--		ROLLBACK TRAN
--		RAISERROR('NO ESTA PERMITIDO BORRAR O MODIFICAR TABLAS',16,1)
--	END 

--=============================================================================================================

--Crear un SP para abrir un módulo. Debe contemplar todas las validaciones correspondientes.
--Utilice los SP creados anteriormente.
SELECT * FROM MODULOS_DISPONIBLES
SELECT * FROM PROGRAMAS_MODULOS
SELECT * FROM PROGRAMAS
SELECT * FROM MODULOS
-- modulo para ser abierto necesita:
-- HORARIO (DIA,HORAINICIO,HORAFIN)
-- PROFESOR
-- LABORATORIO
--  Se asigna codigo y nombre al modulo, si ya existe se actualiza
GO
CREATE or ALTER PROCEDURE SP_ASIGNAR_ACTUAIZAR_MODULO(@cod_modulo varchar(10) OUT,
													  @nombre_modulo varchar(120),
													  @msj varchar(55) OUT) 					
AS 
	BEGIN TRY
		BEGIN TRANSACTION 
			IF (NOT EXISTS (SELECT 1 FROM  MODULOS WHERE COD_MODULO = @cod_modulo)) --SI NO EXISTE SE AGREGA
				BEGIN 
						INSERT INTO MODULOS(COD_MODULO,NOMBRE_MODULO)
						VALUES (@cod_modulo,@nombre_modulo)
						SET @msj = 'MODULO INGRESADO CORRECTAMENTE'
				END
			ELSE -- SI EXISTE SE ACTUALIZA
				BEGIN 
					UPDATE MODULOS
						SET NOMBRE_MODULO = @nombre_modulo
					WHERE COD_MODULO = @cod_modulo
					SET @msj = 'MODULO ACTUALIZADO CORRECTAMENTE'
			    END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH 
		ROLLBACK TRANSACTION
		SET @msj = ERROR_MESSAGE()
	END CATCH 
GO
SELECT * FROM MODULOS
-- EJECUTAR PROCEDIMIENTO SP_ASIGNAR_ACTUAIZAR_MODULO

DECLARE	@RC int,
		@cod_modulo varchar(10),
		@nombre_modulo varchar(120),
		@msj varchar(55)

SET	@cod_modulo = 'PDM_1'
SET @nombre_modulo = 'ANDROID I'

EXEC	@RC = [dbo].[SP_ASIGNAR_ACTUAIZAR_MODULO]
		@cod_modulo OUTPUT,
		@nombre_modulo,
		@msj OUTPUT
 PRINT @msj 
GO
 
 -- Se asigna el modulo a los programas

 --8) ASIGNAR UN MODULO A UN PROGRAMA
GO
CREATE OR ALTER PROCEDURE SP_ASIGNAAR_MODULO_PROGRAMA(@cod_programa_modulo int OUT,
												  @cod_modulo varchar(10),
												  @cod_programa varchar(20),
												  @msj varchar(150) OUT)
                                             	  
AS
    BEGIN TRY
        BEGIN TRAN
            IF(not exists (select 1 from PROGRAMAS_MODULOS where COD_PROGRAMA_MODULO = @cod_programa_modulo))
                BEGIN
                    INSERT INTO PROGRAMAS_MODULOS(COD_PROGRAMA,COD_MODULO)
                            VALUES(@cod_programa, @cod_modulo)
                    SELECT @cod_programa_modulo = IDENT_CURRENT('PROGRAMA_MODULO')  
					SET @msj = 'LA MATERIA HA SIDO ASIGNADA CORRECTAMENTE'
                END
        COMMIT TRAN
    END TRY   
	BEGIN CATCH
        ROLLBACK TRAN
        SET @msj = 'HA OCURRIDO UN ERROR AL ASIGNAR LA MATERIA A LA CARRERA . ' + ERROR_MESSAGE()
    END CATCH
GO
SELECT * FROM PROGRAMAS_MODULOS

-- EJECUTAR PROCEDIMIENTO SP_ASIGNAAR_MODULO_PROG
DECLARE	@RC int,
		@cod_programa_modulo int,
		@cod_modulo varchar(10),
		@cod_programa varchar(20),
		@msj varchar(150) 

SET @cod_programa_modulo = 1
SET	@cod_modulo = 1
SET	@cod_programa = 1

EXEC	@RC = [dbo].[SP_ASIGNAAR_MODULO_PROGRAMA]
		@cod_programa_modulo OUTPUT,
		@cod_modulo,
		@cod_programa,
		@msj = @msj OUTPUT
PRINT @msj
GO

--  Se le asigna los días en que se va a impartir el módulo


SELECT * FROM HORARIOS_P
GO
CREATE or ALTER PROCEDURE SP_ASIGNAR_HORARIO (@cod_horario int OUT,
											  @cod_modulo_disp int,
											  @dia char,
											  @hora_inicio time,
											  @hora_final time,
											  @msj varchar(55) OUT) 					
AS 
	BEGIN TRY
		BEGIN TRANSACTION 
			IF (NOT EXISTS (SELECT 1 FROM  HORARIOS_P WHERE COD_HORARIO = @cod_horario)) --SI NO EXISTE SE AGREGA
				BEGIN 
						INSERT INTO HORARIOS_P(COD_HORARIO,COD_MODULO_DISPONIBLE,DIA,HORA_INICIO,HORA_FIN)
						VALUES (@cod_horario, @cod_modulo_disp , @dia, @hora_inicio ,@hora_final )
				END
			ELSE -- SI EXISTE SE ACTUALIZA
				BEGIN 
					UPDATE HORARIOS_P
					SET COD_MODULO_DISPONIBLE = @cod_modulo_disp,DIA = @dia,HORA_INICIO = @hora_inicio, HORA_FIN = @hora_final
					WHERE COD_HORARIO = @cod_horario
					SET @msj = 'HORARIO ASIGNADO CORRECTAMENTE'
			    END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH 
		ROLLBACK TRANSACTION
		SET @msj = ERROR_MESSAGE()
	END CATCH 
GO
SELECT * FROM MODULOS
-- EJECUTAR PROCEDIMIENTO SP_ASIGNAR_HORARIO 

DECLARE	@RC int,
		@cod_horario int,
		@cod_modulo_disp int,
		@dia char,
		@hora_inicio time,
		@hora_final time,
		@msj varchar(55)

SET	@cod_horario = 1
SET @cod_modulo_disp = 1
SET	@dia = 'L'
SET	@hora_inicio = '7:00'
SET	@hora_final = '9:00'

EXEC	@RC = [dbo].[SP_ASIGNAR_HORARIO]
		@cod_horario OUT,
		@cod_modulo_disp,
		@dia,
		@hora_inicio,
		@hora_final, 
		@msj OUTPUT
 PRINT @msj 
GO
--  Se ingresa un profesor certificado

GO
CREATE OR ALTER PROCEDURE SP_AGREGAR_PROFESOR(@id_profesor int OUT,
												 @nombre_profesor varchar(25),
												 @primer_ape varchar(20),
												 @segundo_ape varchar(20),
												 @telefono varchar(8),
												 @correo varchar(25),
												 @provincia varchar(20),
												 @borrado bit,
												 @msj varchar(55) OUT) 
AS
	BEGIN TRY
		BEGIN TRAN
			INSERT INTO PROFESORES_P(ID_PROFESOR,NOMBRE_PROFESOR,PRIMER_APE_P,SEGUNDO_APE_P,TELEFONO_PROFESOR,CORREO_PROFESOR,
			PROVINCIA,BORRADO_P)
			VALUES (@id_profesor,@nombre_profesor,@primer_ape,@segundo_ape,@telefono,@correo,@provincia,@borrado)
			SET @msj = 'PROFESOR INSERTADO CORRECTAMENTE'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @msj = ERROR_MESSAGE()
	END CATCH
GO

-- EJECUTAR PROCEDIMIENTO SP_AGREGAR_PROFESOR
GO
DECLARE	@RC int,
		@id_profesor int,
		@nombre_profesor varchar(25),
		@primer_ape varchar(20),
		@segundo_ape varchar(20),
		@telefono varchar(8),
		@correo varchar(25),
		@provincia varchar(20),
		@borrado bit,
		@msj varchar(55) 

SET @id_profesor = 202453045
SET @nombre_profesor = 'Luis'
SET @primer_ape = 'Chacon'
SET @segundo_ape = 'Zuniga'
SET @telefono = '88881111'
SET	@correo = 'luis@ina.ac.cr'
SET	@provincia = 'ALAJUELA'
SET	@borrado = 0

EXEC @RC = [dbo].[SP_AGREGAR_PROFESOR]
@id_profesor out,@nombre_profesor ,@primer_ape,@segundo_ape ,@telefono,
		@correo,@provincia,@borrado,@msj out

-- SE ASIGNA EL PROFESOR A EL MODULO DIPONIBLE


SELECT * FROM PROFESORES_P
SELECT * FROM MODULOS_DISPONIBLES

GO
CREATE OR ALTER PROCEDURE SP_ASIGNAR_PROFESOR_MD( @cod_modulo_disp int OUT,
												  @cod_programa_modulo int,
												  @id_profesor int,
												  @costo_modulo real,
												  @duracion int,
												  @msj varchar(55) out) 
AS
	BEGIN TRY
		BEGIN TRAN
			IF (NOT EXISTS (select 1 from MODULOS_DISPONIBLES where ID_PROFESOR = @id_profesor))
				BEGIN
				  INSERT INTO MODULOS_DISPONIBLES(COD_MODULO_DISPONIBLE,COD_PROGRAMA_MODULO,ID_PROFESOR,COSTO_MODULO,DURACION_MODULO)
				  VALUES (@cod_modulo_disp,@cod_programa_modulo,@id_profesor,@costo_modulo,@duracion)
				END
			
			SET @msj = 'PROFESOR ASIGNADO A MODULOS DISPONIBLES CORRECTAMENTE'
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @msj = ERROR_MESSAGE()
	END CATCH
GO

-- EJECUTAR PROCEDIMIENTO SP_ASIGNAR_PROFESOR_MD
GO
DECLARE	@RC int,
		@cod_modulo_disp int,
		@cod_programa_modulo int,
		@id_profesor int,
		@costo_modulo real,
		@duracion int,
		@msj varchar(55) 

SET @cod_modulo_disp = 1
SET @cod_programa_modulo = 1
SET @id_profesor = 1111
SET @costo_modulo = 250000
SET @duracion = 120


EXEC @RC = [dbo].[SP_ASIGNAR_PROFESOR_MD]
	@cod_modulo_disp out ,
		@cod_programa_modulo,
		@id_profesor,
		@costo_modulo,
		@duracion,@msj out
GO

SELECT * FROM PROFESORES_P;

--  Se verifica que el profesor no tenga choque de horario
GO
CREATE OR ALTER PROCEDURE SP_CHOQUE_H_PROFE(@cod_modulo_disp int , @id_profesor int)
AS 
	BEGIN 
		DECLARE @HORARIO_INICIAL TIME, -- DECLARA VARIABLES
		@HORARIO_FINAL TIME,@DIA CHAR(1)
		DECLARE cPROFESORES_ASIGNAR CURSOR FOR -- CURSOR
		SELECT HORA_INICIO,HORA_FIN,DIA
		FROM HORARIOS_P
		WHERE COD_MODULO_DISPONIBLE = @cod_modulo_disp

		OPEN cPROFESORES_ASIGNAR -- ABRE CURSOR
		FETCH cPROFESORES_ASIGNAR INTO @HORARIO_INICIAL,@HORARIO_FINAL,@DIA
		WHILE (@@FETCH_STATUS = 0)
			BEGIN 
				IF EXISTS (SELECT 1 FROM MODULOS_DISPONIBLES MD INNER JOIN PROFESORES_P P 
					ON  MD.ID_PROFESOR = P.ID_PROFESOR
					INNER JOIN HORARIOS_P H
					ON MD.COD_MODULO_DISPONIBLE = H.COD_MODULO_DISPONIBLE
					WHERE MD.ID_PROFESOR =  @id_profesor
					AND H.DIA = @DIA 
					AND ((H.HORA_INICIO BETWEEN @HORARIO_INICIAL AND @HORARIO_FINAL) 
					OR (H.HORA_FIN BETWEEN @HORARIO_INICIAL AND @HORARIO_FINAL)) 
					AND ((@HORARIO_INICIAL BETWEEN H.HORA_INICIO AND H.HORA_FIN)))
			    BEGIN
						PRINT 'EXISTE UN CHOQUE DE HORARIO DEL EL PROFESOR CON EL MODULO POR ABIR'
					END
				ELSE 
					BEGIN 
						PRINT 'NO EXITE CHOQUE DE HORARIOS'
					END 
		FETCH cPROFESORES_ASIGNAR INTO @HORARIO_INICIAL,@HORARIO_FINAL,@DIA
	END

	CLOSE cPROFESORES_ASIGNAR
	DEALLOCATE cPROFESORES_ASIGNAR
END
	EXEC SP_CHOQUE_H_PROFE 1, 1111

--  Se le asigna un laboratorio
SELECT * FROM HORARIOS_P
GO

CREATE or ALTER PROCEDURE SP_ASIGNAR_LAB(@cod_lab int OUT,
										@nombre_lab char(1),
										@cod_modu_disp int,
										@cod_horario int,
										@msj varchar(55) OUT) 					
AS 
	BEGIN TRY
		BEGIN TRANSACTION 
			IF (NOT EXISTS (SELECT 1 FROM  LABORATORIOS WHERE COD_MODULO_DISPONIBLE = @cod_modu_disp)) --SI NO EXISTE SE AGREGA
				BEGIN 
						INSERT INTO LABORATORIOS(COD_LABORATORIO,NOMBRE_LAB,COD_MODULO_DISPONIBLE,COD_HORARIO)
						VALUES (@cod_lab,@nombre_lab,@cod_modu_disp,@cod_horario)
				END
			ELSE -- SI EXISTE SE ACTUALIZA
				BEGIN 
					UPDATE LABORATORIOS
					SET NOMBRE_LAB = @nombre_lab,COD_MODULO_DISPONIBLE = @cod_modu_disp,COD_HORARIO = @cod_horario
					WHERE COD_LABORATORIO = @cod_lab
					SET @msj = 'HORARIO ASIGNADO CORRECTAMENTE'
			    END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH 
		ROLLBACK TRANSACTION
		SET @msj = ERROR_MESSAGE()
	END CATCH 
GO
SELECT * FROM MODULOS
-- EJECUTAR PROCEDIMIENTO SP_INSERT_ACTUAIZAR_MODU

DECLARE	@RC int,
		@cod_lab int,
		@nombre_lab char(1),
		@cod_modu_disp int,
		@cod_horario int,
		@msj varchar(55)

SET	@cod_lab = 1
SET @nombre_lab = 'A'
SET	@cod_modu_disp = 1
SET	@cod_horario = 1

EXEC	@RC = [dbo].[SP_ASIGNAR_LAB]
		@cod_lab OUT,
		@nombre_lab,
		@cod_modu_disp,
		@cod_horario,
		@msj OUT
 PRINT @msj 
GO

--  Se verifica que el laboratorio no tenga choque de horario
GO
CREATE OR ALTER PROCEDURE SP_CHOQUE_H_LAB(@cod_modulo_disp int , @cod_horario int)
AS 
	BEGIN 
		DECLARE @HORARIO_INICIAL TIME, -- DECLARA VARIABLES
		@HORARIO_FINAL TIME,@DIA CHAR(1)
		DECLARE cLAB_ASIGNAR CURSOR FOR -- CURSOR
		SELECT HORA_INICIO,HORA_FIN,DIA
		FROM HORARIOS_P
		WHERE COD_MODULO_DISPONIBLE = @cod_modulo_disp

		OPEN cLAB_ASIGNAR -- ABRE CURSOR
		FETCH cLAB_ASIGNAR INTO @HORARIO_INICIAL,@HORARIO_FINAL,@DIA
		WHILE (@@FETCH_STATUS = 0)
			BEGIN 
				IF EXISTS (SELECT 1 FROM MODULOS_DISPONIBLES MD INNER JOIN LABORATORIOS L
					ON  MD.COD_MODULO_DISPONIBLE = L.COD_MODULO_DISPONIBLE
					INNER JOIN HORARIOS_P H
					ON MD.COD_MODULO_DISPONIBLE = H.COD_MODULO_DISPONIBLE
					WHERE H.DIA = @DIA 
					AND ((H.HORA_INICIO BETWEEN @HORARIO_INICIAL AND @HORARIO_FINAL) 
					OR (H.HORA_FIN BETWEEN @HORARIO_INICIAL AND @HORARIO_FINAL)) 
					AND ((@HORARIO_INICIAL BETWEEN H.HORA_INICIO AND H.HORA_FIN)))
			      BEGIN
						PRINT 'EXISTE UN CHOQUE DE HORARIO CON EL LABORATORIO'
					END
				ELSE 
					BEGIN 
						PRINT 'NO EXITE CHOQUE DE HORARIOS'
					END 
		FETCH cLAB_ASIGNAR INTO @HORARIO_INICIAL,@HORARIO_FINAL,@DIA
	END

	CLOSE cLAB_ASIGNAR
	DEALLOCATE cLAB_ASIGNAR
END
	EXEC SP_CHOQUE_H_LAB 1, 1
----------------------------------------------------------------
--ABIR MODULO
select * from MODULOS_DISPONIBLES

GO
CREATE OR ALTER PROCEDURE SP_OBSERVAR_MODULOS_ABIERTOS
AS
	BEGIN 
			SELECT PM.COD_MODULO,NOMBRE_MODULO,MD.COD_MODULO_DISPONIBLE,PM.COD_PROGRAMA_MODULO,MD.ID_PROFESOR,NOMBRE_PROFESOR,DIA,HORA_INICIO,HORA_FIN,COSTO_MODULO,DURACION_MODULO
			FROM MODULOS M INNER JOIN PROGRAMAS_MODULOS PM
			ON M.COD_MODULO = PM.COD_MODULO
			INNER JOIN MODULOS_DISPONIBLES MD
			ON MD.COD_PROGRAMA_MODULO =  PM.COD_PROGRAMA_MODULO
			INNER JOIN HORARIOS_P H
			ON H.COD_HORARIO = MD.COD_MODULO_DISPONIBLE
			INNER JOIN LABORATORIOS L
			ON L.COD_MODULO_DISPONIBLE = MD.COD_MODULO_DISPONIBLE
			INNER JOIN PROFESORES_P P
			ON P.ID_PROFESOR = MD.ID_PROFESOR
	END 
GO

EXECUTE SP_OBSERVAR_MODULOS_ABIERTOS

--========================================================================================================
-- 5.	Crear un SP para realizar la matrícula de un estudiante, contemplando todas las aristas necesarias.
--	Considera que el módulo esté abierto

GO
CREATE OR ALTER PROCEDURE SP_VERIFICAR_MODULOS_ABIERTOS
AS
	BEGIN 
			SELECT PM.COD_MODULO,NOMBRE_MODULO,MD.COD_MODULO_DISPONIBLE,PM.COD_PROGRAMA_MODULO,MD.ID_PROFESOR,NOMBRE_PROFESOR,DIA,HORA_INICIO,HORA_FIN,COSTO_MODULO,DURACION_MODULO
			FROM MODULOS M INNER JOIN PROGRAMAS_MODULOS PM
			ON M.COD_MODULO = PM.COD_MODULO
			INNER JOIN MODULOS_DISPONIBLES MD
			ON MD.COD_PROGRAMA_MODULO =  PM.COD_PROGRAMA_MODULO
			INNER JOIN HORARIOS_P H
			ON H.COD_HORARIO = MD.COD_MODULO_DISPONIBLE
			INNER JOIN LABORATORIOS L
			ON L.COD_MODULO_DISPONIBLE = MD.COD_MODULO_DISPONIBLE
			INNER JOIN PROFESORES_P P
			ON P.ID_PROFESOR = MD.ID_PROFESOR
	END 
GO

EXECUTE SP_VERIFICAR_MODULOS_ABIERTOS

--	Considera que no haya choque de horario con otros módulos matriculados por el estudiante
GO
CREATE OR ALTER PROCEDURE SP_CHOQUE_H_ESTUDIANTE( @id_estudiante int ,@cod_modulo_disp int)
AS 
	BEGIN 
		DECLARE @HORARIO_INICIAL TIME, -- DECLARA VARIABLES
		@HORARIO_FINAL TIME,@DIA CHAR(1)
		DECLARE cESTUDIANTES_CH CURSOR FOR -- CURSOR
		SELECT HORA_INICIO,HORA_FIN,DIA
		FROM HORARIOS_P
		WHERE COD_MODULO_DISPONIBLE = @cod_modulo_disp

		OPEN cESTUDIANTES_CH  -- ABRE CURSOR
		FETCH cESTUDIANTES_CH  INTO @HORARIO_INICIAL,@HORARIO_FINAL,@DIA
		WHILE (@@FETCH_STATUS = 0)
			BEGIN 
				IF EXISTS (SELECT 1 FROM MATRICULAS_P M INNER JOIN DETALLE_MATRICULAS_P DM
				ON M.NUM_RECIBO = DM.NUM_RECIBO
				INNER JOIN MODULOS_DISPONIBLES MD 
				ON DM.COD_MODULO_DISPONIBLE = MD.COD_MODULO_DISPONIBLE
					INNER JOIN HORARIOS_P H
					ON MD.COD_MODULO_DISPONIBLE = H.COD_MODULO_DISPONIBLE
					WHERE M.ID_ESTUDIANTE = @id_estudiante
					AND H.DIA = @DIA 
					AND ((H.HORA_INICIO BETWEEN @HORARIO_INICIAL AND @HORARIO_FINAL) 
					OR (H.HORA_FIN BETWEEN @HORARIO_INICIAL AND @HORARIO_FINAL)) 
					AND ((@HORARIO_INICIAL BETWEEN H.HORA_INICIO AND H.HORA_FIN)))
			    BEGIN
						PRINT 'EXISTE UN CHOQUE DE HORARIOEL ESTUDIANTE NO PUEDE MATRICULAR'
					END
				ELSE 
					BEGIN 
						PRINT 'NO EXITE CHOQUE DE HORARIOS DE MODULOS MATRICULADOS CON MODULOS POR MATRICULAR, EL ESTUDIANTE PUEDE REALIZAR LA MATRICULA'
					END 
		FETCH cESTUDIANTES_CH  INTO @HORARIO_INICIAL,@HORARIO_FINAL,@DIA
	END

	CLOSE cESTUDIANTES_CH 
	DEALLOCATE cESTUDIANTES_CH 
END

GO
	EXEC SP_CHOQUE_H_ESTUDIANTE 208000304,1
	GO


