-- PRACTICA 13 --

USE DBMATRICULA_CLASE_2023N;

--Seleccionar el CARNET, el nombre del estudiante concatenado, la FECHA de matrícula,
--el MONTO de matrícula y la suma del costo de las materias matriculadas.
-- COSTO --> MATERIAS ABIERTAS

SELECT DISTINCT E.CARNET,E.NOMBRE_ESTUDIANTE + ' ' + E.PRIMER_APELLIDO_E 
				+ ' ' + E.SEGUNDO_APELLIDO_E AS NOMBRE_COMPLETO,
M.NUM_RECIBO,FECHA,MONTO, 
		(SELECT SUM(COSTO)
			FROM MATERIAS_ABIERTAS MA INNER JOIN DETALLE_MATRICULAS DM
			ON MA.COD_MATERIA_ABIERTA = DM.COD_MATERIA_ABIERTA
			WHERE DM.NUM_RECIBO = M.NUM_RECIBO) AS MONTO_CURSOS 
FROM ESTUDIANTES E INNER JOIN MATRICULAS M
		ON E.CARNET = M.CARNET



SELECT * FROM ESTUDIANTES;
SELECT * FROM MATERIAS_ABIERTAS;
SELECT * FROM DETALLE_MATRICULAS;
SELECT * FROM MATRICULAS;

------------------------------------------------------------------------------------------------------------------------
---CASES

--MODO 1
SELECT MONTO, USUARIO_MATRICULA, 
DESC_APERTURA =  CASE(USUARIO_MATRICULA)
					WHEN 'KARINA' THEN MONTO * 0.1
					WHEN 'KARLA' THEN MONTO * 0.2
					WHEN 'JOSE' THEN MONTO * 0.5
		            ELSE 0
	END
FROM MATRICULAS

--MODO 2
SELECT MONTO, USUARIO_MATRICULA, 
	 CASE USUARIO_MATRICULA
					WHEN 'KARINA' THEN MONTO * 0.1
					WHEN 'KARLA' THEN MONTO * 0.2
					WHEN 'JOSE' THEN MONTO * 0.5
		            ELSE 0
	END AS DESC_APERTURA
FROM MATRICULAS

UPDATE MATRICULAS
SET USUARIO_MATRICULA = 'JOSE' 
WHERE NUM_RECIBO = 2


--EJEMPLO C
SELECT NOMBRE_ESTUDIANTE,PRIMER_APELLIDO_E,SEGUNDO_APELLIDO_E,CORREO_ESTUDIANTE,
	FECHA = CASE
	WHEN FECHA IS NULL THEN 'NO REGISTRA'
	ELSE CONVERT(VARCHAR, FECHA, 103)
	END
FROM ESTUDIANTES E INNER JOIN MATRICULAS M
ON E.CARNET = M.CARNET


--EJEMPLO D
SELECT MONTO AS TOTAL_MATRICULA,FECHA,
	CASE 
		WHEN FECHA > '20210501' THEN MONTO * 0.2

	ELSE 0
	END AS RECARGO
FROM MATRICULAS

---------------------------------------------------------------------------------------------
--WHILE

--EJEMPLO 01
DECLARE @N int
SET @N = 1
WHILE @N <= 10
	BEGIN 
		IF (@N % 2) = 0
			--SELECT @N AS NUMERO
			PRINT @N
		SET @N = @N + 1
	END

--EJEMPLO 02
DECLARE @contador int
SET @contador = 0
WHILE (@contador < 100)
	BEGIN 
		SET @contador = @contador + 1
	PRINT 'Iteracion del bucle ' + CAST(@contador AS varchar)
END

SELECT * FROM MATERIAS_ABIERTAS;



---EJMPLO 03
UPDATE MATERIAS_ABIERTAS 
SET COSTO = 10000
WHERE COD_MATERIA_ABIERTA BETWEEN 1 AND 3

WHILE (SELECT avg(COSTO) FROM MATERIAS_ABIERTAS) <= 80000
	BEGIN 
		SELECT COD_MATERIA_ABIERTA, COSTO FROM MATERIAS_ABIERTAS

		SELECT avg(COSTO) AS PROMEDIO_ACTUAL FROM MATERIAS_ABIERTAS

		UPDATE MATERIAS_ABIERTAS 
		SET COSTO = COSTO + 5000 
		WHERE COSTO < 80000
	END

SELECT * FROM MATERIAS_ABIERTAS;



----PRACTICA EN CLASE 01

-- MUESTRE LOS MULRIPLOS DE 5 DEL 1 AL 50
DECLARE @number int
SET @number = 1

WHILE @number <= 50 
BEGIN 
	IF (@number % 5= 0)
	PRINT @number
	SET @number = @number + 1
END

--MUESTRE LOS NUMEROS DEL 1 AL 20 E INDIQUE LA SUMA DE TODOS
DECLARE @number1 int , @sum int
SET @number1 = 0
SET @sum = 0

WHILE (@number1 < 20)
BEGIN 
	SET @number1 += 1
	PRINT @number1
	SET @sum += @number1
END
PRINT 'La suma de los numeros del 1 al 200 es : ' + cast(@sum AS varchar)

-- CALCULE EL FACTORIAL DE 6
DECLARE @number2 int , @fac int
SET @number2 = 1
SET @fac= 1

WHILE (@number2 <= 6)
BEGIN 
	SET @fac = @fac * @number2
	SET @number2 = @number2 +1
END
PRINT 'El factorial de 6 es : ' + cast(@fac AS varchar)

--MUESTRE LOS NUMEROS DEL 1 AL 50, E INDIQUE LA SUMA DE TODOS LOS NUMEROS PARES DE ESE MISMO RANGO

DECLARE @number3 int , @sum1 int
SET @number3 = 1
SET @sum1 = 0

WHILE (@number3 <= 50)
BEGIN 
	PRINT @number3
	IF (@number3 % 2 = 0)
		SET @sum1 = @sum1 + @number3

	SET @number3 = @number3 + 1		
END
PRINT 'La suma de los numeros pares del 1 al 50 es : ' + cast(@sum1 AS varchar)

-- MUESTRE EL PROMEDIO Y LA SUMA DEL MONTO DE TODAS LAS MATRICULAS
-- AGREGUE UN CAMPO EDAD A LA TABLA PROFESOR 
-- MUESTRE LOS DATOS DEL PROFESOR Y ASIGNE A UNNA VARIABLE @COD_PROF EL PRIMER CODIGO DEL PROFESOR Y A UNA VARIABLE @EDAD 20
--LUEGO MODIFIQUE LA EDAD DEL PROFESOR INICIANDO EN 20 Y AUMENTANDO LA EDAD EN 2
-- ESCRIBA EL NOMBRE EN MAYUSCULA DE TODOS LOS PROFESORES QUE TIENEN UNA EDAD MAYOR AL PROMEDIO

--Practica 2 
--Sume tres notas y calcule el promedio, si una de ellas es mayor a 100 o menos a 1 lance un error.





















-- IMPRIME NUMEROS IMPARES YA QUE LOS PARES SE LOS SALTA
DECLARE @contador1 int
SET @contador1 = 0
WHILE (@contador1 < 100)
	BEGIN 
		SET @contador1 = @contador1 + 1
		CONTINUE
	PRINT 'Iteracion del bucle ' + CAST(@contador1 AS varchar)
END


DECLARE @contador2 int
SET @contador2 = 0
WHILE (1=1)
	BEGIN 
		SET @contador2 = @contador2 + 1
		IF (@contador2 % 50 =0)
		CONTINUE
	PRINT 'Iteracion del bucle ' + CAST(@contador2 AS varchar)
END

BEGIN TRY 
	 DECLARE @divisor int,@dividiendo int,@resultado int
	 SET @dividiendo = 100
	 SET @divisor = 0
	 SET @resultado = @dividiendo/@divisor
	 PRINT 'NO HAY ERROR'
END TRY
BEGIN CATCH
	PRINT ' SI HAY ERROR' + cast(@@error as varchar)
	PRINT error_message()
END CATCH

BEGIN TRY 
	SELECT * FROM ESTUDIANTES
	UPDATE ESTUDIANTES SET ESTADO_ESTUDIANTE ='ACTIVO' WHERE CARNET = 'INA201'
END TRY
BEGIN CATCH
	PRINT 'ERROR AL ACTUALIZAR'
END CATCH
--MUESTRE LOS NUMEROS IMPARES DEL 10 AL 30
DECLARE @impares int
SET @impares = 10
WHILE @impares <= 30
	BEGIN 
		IF (@impares % 2) = 0
			--SELECT @N AS NUMERO
			PRINT @impares
		SET @impares = @impares + 1
	END


