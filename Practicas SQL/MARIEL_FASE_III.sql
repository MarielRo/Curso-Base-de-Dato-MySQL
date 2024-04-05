/* INSTITUTO NACIONAL DE APRENDIZAJE 
   MÓDULO GESTIÓN DE BASE DE DATOS
   ENTREGA FASE III
   MARIEL DANIELA ROJAS SÁNCHEZ 
   FECHA : 17 FEBRERO 2023
*/

USE MARIEL_PROYECTO_BD;
GO
----  

--VERIFICAR QUE TODO ESTE CORRECTO Y NO HAYA CHOQUES DE MODULOS, HORARIOS, PROFESORES. (POR EL MOMENTO)
SELECT MD.ID_PROFESOR,NOMBRE_PROFESOR,MA.NUM_RECIBO,MA.ID_ESTUDIANTE, NOMBRE_ESTUDIANTE, DIA,HORA_INICIO,HORA_FIN,NOMBRE_LAB, L.COD_HORARIO,COD_LABORATORIO, NOMBRE_MODULO
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

-- LISTAR PROGRAMAS CON MODULOS
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
-- EJECUCION PROCEDIMIENTO  SP_PROFESOR_HORARIOS
DECLARE @nombreCompleto varchar(45),@borrado bit, @msj varchar (35)
EXECUTE [SP_PROFESOR_HORARIOS]
	@nombreCompleto,@borrado,@msj 
GO


