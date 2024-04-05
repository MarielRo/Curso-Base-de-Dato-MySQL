USE DBMATRICULA_CLASE;
--******************************************************************************************
INSERT INTO ESTUDIANTES (CARNET, ID_ESTUDIANTE, NOMBRE_ESTUDIANTE, 	PRIMER_APELLIDO_E, 
						SEGUNDO_APELLIDO_E,TELEFONO_ESTUDIANTE,CORREO_ESTUDIANTE,FECHA_INGRESO)
		VALUES		('INA200','208170615','JOEL','ROJAS','JIMENEZ','88880101','208170615@ina.cr','20210603'),
					('INA202','702420185','MIGUEL','SUAREZ','GARCIA','88880102','702420185@ina.cr','20210603'),
					('INA203','207990019','CARLOS','RODRIGUEZ','AGUILAR','88880103','207990019@ina.cr','20210603'),
					('INA204','205790810','CARMEN','SOSA','GONZALES','88880104','205790810@ina.cr','20210603'),
					('INA205','206470303','MARIA','PEREZ','JIMENEZ','88880105','206470303@ina.cr','20210603'),
					('INA206','116870306','MARIANO','ARCE','ROJAS','88880106','116870306@ina.cr','20210603'),
					('INA207','901390706','DIANA','PREREIRA','SALAZAR','88880107','901390706@ina.cr','20210603'),
					('INA208','208110717','FERNANDO','ZELEDON','PACHECO','88880108','208110717@ina.cr','20210603'),
					('INA209','701890285','LUCIA','SANCHEZ','JIMENEZ','88880109','701890285@ina.cr','20210603');

SELECT * FROM ESTUDIANTES;

--******************************************************************************************
INSERT INTO CARRERAS(COD_CARRERA,NOMBRE_CARRERA,TOTAL_CREDITOS,GRADO)
	   VALUES   ('ASIS_01','ASISTENTE A PERSONAS USUARIAS DE TECNOLOG�AS DE INFORMACI�N Y COMUNICACI�N',390,'LICENCIATURA'),
				('COMU_02','COMUNICADOR(A) RADIOF�NICO',989,'BACHILLERATO'),
				('WEB1_03','PROGRAMADOR DE PAGINAS WEB',561,'DIPLOMADO'),
				('OPER_04','OPERADOR(A) DE TECNOLOG�AS DE INFORMACI�N Y COMUNICACI�N',260,'BACHILLERATO'),
				('PROG_05','PROGRAMADOR(A) DE APLICACIONES INFORM�TICAS',870,'DIPLOMADO'),
				('PROD_06','PRODUCTOR RADIOF�NICO',610,'LICENCIATURA'),
				('TECT_07','T�CNICAS B�SICAS DE PRODUCCI�N DE VIDEO',282,'DIPLOMADO');
				

SELECT * FROM CARRERAS

--******************************************************************************************
INSERT INTO MATERIAS(COD_MATERIA,NOMBRE_MATERIA,CREDITOS)
		VALUES	('ASIS_1000','Protecci�n de la salud laboral y ambiente',10),
				('ASIS_1001','Preparaci�n de equipos de c�mputo',8),
				('ASIS_1002','Atenci�n a personas usuarias de tecnolog�as de informaci�n y comunicaci�n',10),
				('ASIS_1003','Aplicaci�n de COBIT e ITIL en la asistencia a personas usuarias de tic',9),
				('ASIS_1004','Pr�ctica supervisada asistente a personas usuarias de tic',7),
				('ASIS_1005','Mercadeo para medios de comunicaci�n',6),

				('COMU_1000','Lenguaje radiof�nico',5),
				('COMU_1001','Bases de la comunicaci�n',12),
				('COMU_1002','Servicio al cliente',7),
				('COMU_1003','Locuci�n b�sica',8),
				('COMU_1004','Locuci�n de formatos radiof�nicos',8),
				('COMU_1005','Programaci�n musical',9),
				('COMU_1006','Bases de la producci�n radiof�nica',6),
				('COMU_1007','Manejo de hardware y software radiof�nico',7),
				('COMU_1008','Montaje y producci�n de material radiof�nico',7),
				('COMU_1009','Conducci�n y animaci�n de programas en medios de comunicaci�n',6),
				('COMU_1010','Organizaci�n y conducci�n de ceremonias',9),
				('COMU_1011','Pr�ctica supervisada para comunicador-A radiof�nico',10),

				('WEB1_1000','T�cnicas para dise�o de algoritmos',5),
				('WEB1_1001','Programaci�n en JavaScript',6),
				('WEB1_1002','Planificaci�n de pruebas de software',6),
				('WEB1_1003','Elaboraci�n de pruebas de software',7),
				('WEB1_1004','Implementaci�n de pruebas de software',5),

				('OPER_1000','Empleo de tecnolog�as de informaci�n y comunicaci�n',9),
				('OPER_1001','Desarrollo del trabajo colaborativo por medio de tics',8),
				('OPER_1002','Procesamiento de textos',7),
				('OPER_1003','Elaboraci�n de hojas de c�lculo',9),
				('OPER_1004','Realizaci�n de presentaciones multimedia',10),

				('PROG_1000','L�gica computacional',7),
				('PROG_1001','Implementaci�n de aplicaciones inform�ticas con programaci�n estructurada',7),
				('PROG_1002','Gesti�n de bases de datos',8),
				('PROG_1003','Creaci�n de p�ginas web',9),
				('PROG_1004','Programaci�n orientada a objetos',9),
				('PROG_1005','Programaci�n de aplicaciones empresariales en ambiente web',8),
				('PROG_1006','Pr�ctica supervisada para el programa programador-A de aplicaciones inform�ticas',8),

				('PROD_1000','Taller de producci�n radiof�nica',4),
				('PROD_1001','Foniatr�a y t�cnica vocal',5),
				('PROD_1002','Principios de la comunicaci�n',5),
				('PROD_1003','M�todos y t�cnicas de investigaci�n',5),
				('PROD_1004','Cultura general',6),
				('PROD_1005','Montaje de programas radiof�nicos',6),
				('PROD_1006','Cultura musical',6),

				('TECT_1000','Editor de audio DIGI 003',8),
				('TECT_1001','Manejo del idioma',6),
				('TECT_1002','Apreciaci�n audiovisual I',5),
				('TECT_1003','T�cnicas de c�mara para la producci�n de video',4),
				('TECT_1004','T�cnicas de iluminaci�n para la producci�n de video',4),
				('TECT_1005','T�cnicas de sonido para la producci�n de video',11),
				('TECT_1006','T�cnicas de edici�n para la producci�n de video',11),
				('TECT_1007','M�dulo pr�ctico para la producci�n audiovisual',11),
				('TECT_1008','T�cnicas b�sicas en edici�n digital',4),
				('TECT_1009','T�cnicas b�sicas en animaci�n digital',6),
				('TECT_1010','T�cnicas de guion 1',9),
				('TECT_1011','T�cnicas de realizaci�n',9),
				('TECT_1012','T�cnicas en direcci�n de c�mara',9),
				('TECT_1013','Apreciaci�n audiovisual 2',8),
				('TECT_1014','APLICACIONES INFORM�TICAS B�SICAS',8),
				('TECT_1015','BASES DE DATOS ACCESS',7),
				('TECT_1016','EDITOR DE AUDIO DIGI 003',7),
				('TECT_1017','EXCEL AVANZADO',7),
				('TECT_1018','HERRAMIENTAS COMPUTACIONALES',7),
				('TECT_1019','HOJA ELECTR�NICA EXCEL PARA PERSONAS CON DISCAPACIDAD VISUAL',7),
				('TECT_1020','INTERNET',6),
				('TECT_1021','INTRODUCCI�N A LA COMPUTACI�N -PARA PERSONAS CON DISCAPACIDAD VISUAL',6),
				('TECT_1022','PROCESADOR DE PALABRAS WORD -PARA PERSONAS CON DISCAPACIDAD VISUAL',7),
				('TECT_1023','PROJECT',6),
				('TECT_1024','T�CNICAS B�SICAS EN ANIMACI�N DIGITAL',5),
				('TECT_1025','T�CNICAS B�SICAS EN EDICI�N DIGITAL',5),
				('TECT_1026','T�CNICAS EN EDICI�N',6),
				('TECT_1027','T�CNICAS DE EDICI�N NO LINEAL',5),
				('TECT_1028','T�CNICAS EN ANIMACI�N DIGITAL',4);



--**************************************************************************
-- se insertan las materias de la carrera
-- ASISTENTE A PERSONAS USUARIAS DE TECNOLOG�AS DE INFORMACI�N Y COMUNICACI�N
INSERT INTO MATERIAS_CARRERAS(COD_CARRERA,COD_MATERIA)
	VALUES  ('ASIS_01','ASIS_1000');

INSERT INTO MATERIAS_CARRERAS(COD_CARRERA,COD_MATERIA, REQUISITO)
	VALUES  ('ASIS_01','ASIS_1001','ASIS_1000'),
			('ASIS_01','ASIS_1002','ASIS_1001'),
			('ASIS_01','ASIS_1003','ASIS_1002'),
			('ASIS_01','ASIS_1004','ASIS_1003'),
			('ASIS_01','ASIS_1005','ASIS_1004');

INSERT INTO MATERIAS_CARRERAS(COD_CARRERA,COD_MATERIA)
	VALUES	('COMU_02','COMU_1000'),
			('COMU_02','COMU_1001'),
			('COMU_02','COMU_1002'),
			('COMU_02','COMU_1003'),
			('COMU_02','COMU_1004'),
			('COMU_02','COMU_1005'),
			('COMU_02','COMU_1006'),
			('COMU_02','COMU_1007'),
			('COMU_02','COMU_1008'),
			('COMU_02','COMU_1009'),
			('COMU_02','COMU_1010'),
			('COMU_02','COMU_1011'),

			('WEB1_03','WEB1_1000'),
			('WEB1_03','WEB1_1001'),
			('WEB1_03','WEB1_1002'),
			('WEB1_03','WEB1_1003'),
			('WEB1_03','WEB1_1004'),

			('OPER_04','OPER_1000'),
			('OPER_04','OPER_1001'),
			('OPER_04','OPER_1002'),
			('OPER_04','OPER_1003'),
			('OPER_04','OPER_1004'),

			('PROG_05','PROG_1000'),
			('PROG_05','PROG_1001'),
			('PROG_05','PROG_1002'),
			('PROG_05','PROG_1003'),
			('PROG_05','PROG_1004'),
			('PROG_05','PROG_1005'),
			('PROG_05','PROG_1006'),

			('PROD_06','PROD_1000'),
			('PROD_06','PROD_1001'),
			('PROD_06','PROD_1002'),
			('PROD_06','PROD_1003'),
			('PROD_06','PROD_1004'),
			('PROD_06','PROD_1005'),
			('PROD_06','PROD_1006'),

			('TECT_07','TECT_1000'),
			('TECT_07','TECT_1001'),
			('TECT_07','TECT_1002'),
			('TECT_07','TECT_1003'),
			('TECT_07','TECT_1004'),
			('TECT_07','TECT_1005'),
			('TECT_07','TECT_1006'),
			('TECT_07','TECT_1007'),
			('TECT_07','TECT_1008'),
			('TECT_07','TECT_1009'),
			('TECT_07','TECT_1010'),
			('TECT_07','TECT_1011'),
			('TECT_07','TECT_1012'),
			('TECT_07','TECT_1013'),
			('TECT_07','TECT_1014'),
			('TECT_07','TECT_1015'),
			('TECT_07','TECT_1016'),
			('TECT_07','TECT_1017'),
			('TECT_07','TECT_1018'),
			('TECT_07','TECT_1019'),
			('TECT_07','TECT_1020'),
			('TECT_07','TECT_1021'),
			('TECT_07','TECT_1022'),
			('TECT_07','TECT_1023'),
			('TECT_07','TECT_1024'),
			('TECT_07','TECT_1025'),
			('TECT_07','TECT_1026'),
			('TECT_07','TECT_1027'),
			('TECT_07','TECT_1028');
select * from MATERIAS_CARRERAS 

--**************************************************************************
INSERT INTO PROFESORES(ID_PROFESOR,NOMBRE_PROFESOR,PRIMER_APELLIDO_P,SEGUNDO_APELLIDO_P,TELEFONO_PROFESOR,CORREO_PROFESOR)
VALUES  ('11111','Luis �ngel','Chacon','Zuniga','88881111','luis@ina.ac.cr'),
		('22222','Alonso','Bogantes','Rodriguez','88881112','alonso@ina.ac.cr'),
		('33333','Oscar','Pacheco','Vazquez','88881113','pacheco@ina.ac.cr'),
		('44444','Laura','Fonseca','Rojas','88881114','laura@ina.ac.cr'),
		('55555','Irene','Cruz','Fernandez','88881115','irene@ina.ac.cr'),
		('66666','Jimmy','Zuniga','Sanchez','88881116','jimmy@ina.ac.cr'),
		('77777','Nelson','Jimenez','Jimenez','88881117','Nelson@ina.ac.cr'),
		('88888','Rebeca','Aguilar','Navarez','88881118','Rebeca@ina.ac.cr'),
		('99999','Sady','Carrillo','Sanchez','88881119','Sady@ina.ac.cr'),
		('111110','Muricio','Cordero','Lizano','88881120','Mauricio@ina.ac.cr'),
		('122221','Graciela','Rojas','Chavarria','88881121','Graciela@ina.ac.cr'),
		('133332','Marco','Acosta','Paniagua','88881122','MAcosta Paniaguaina.ac.cr');

select * from PROFESORES

--**************************************************************************
SELECT * FROM MATRICULAS;

--RECORDAR QUE EL CARNET ES PK EN LA TABLA ESTUDIANTES AQUI FK
INSERT INTO MATRICULAS 
(CARNET,FECHA,MONTO,DESCUENTO,USUARIO_MATRICULA,OBSERVACIONES)
VALUES('INA201','20230124',1500,0.05,'ABC','TODO COMPLETO'),
('INA202','20230124',1550,0.01,'AB','CORRECTO'),
('INA203','20230124',1800,0.08,'AC','REPROBADO'),
('INA204','20230124',1500,0.05,'AD','INVALIDO'),
('INA205','20230124',1500,0.04,'AE','VALIDO'),
('INA206','20230124',1500,0.05,'AF','TODO COMPLETO');

DELETE FROM MATRICULAS;

/*
Falta
MATERIAS_ABIERTAS
HORARIOS
*/






/*
DETALLE
DETALLE_MATRICULAS
INSERT INTO MATRICULAS (CARNET,FECHA,MONTO,	DESCUENTO,USUARIO_MATRICULA,OBSERVACIONES_MATRICULAS)
			VALUES ('INA216', '20210603', 145000.00, 0, 'Sofia', 'Observaci�n'),
				   ('INA215', '20210607', 98000.00, 0, 'Sofia', 'Observaci�n');

SELECT * FROM MATRICULAS;
*/
