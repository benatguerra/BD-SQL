--Aqui inserto en las tablas los datos
INSERT INTO dbo.MEDICOS (Codigo_Identificacion,Nombre_del_Medico,Apellidos_del_Medico,Especialidad,Fecha_de_ingreso,Cargo,Numero_de_Colegiado,Observaciones)
VALUES ('AJH','Antonio','Jaén Hernández','Pediatria','12-08-82','Adjunto',2113,'Esta proxima su retirada'),('CEM','Carmen','Esteril Manrique','Psiquiatria','13-02-92','Jefe de seccion',1231,'')
,('RLQ','Rocio','Lopez Quijada','Medico de familia','23-09-94','Titular',1331,'');

INSERT INTO dbo.PACIENTES (N_Seguridad_Social,Nombre,Apellidos,Domicilio,Poblacion,Provincia,Codigo_Postal,Telefono,Numero_de_Historial,Sexo)
VALUES ('08/7888888','Jose Eduardo','Romerales Pito','C/ Azorin, 34 3o','Mostoles','Madrid',28935,'91-345-87-45','10203-F','H')
,('O8/7234823','Angel','Ruiz Picasso','C/ Salmeron, 212','Madrid','Madrid',28028,'91-565-34-33','11454-L','H')
,('08/7333333','Mercedes','Romero Carvajal','C/ Malaga, 13','Mostoles','Madrid',28935,'91-455-67-45','14546-E','M')
,('08/7555555','Martin','Fernandez Lopez','C/ Sastres, 21','Madrid','Madrid',28028,'91-333-33-33','15413-S','H')

INSERT INTO dbo.INGRESOS (Numero_de_Ingreso,Numero_de_Historial,Fecha_de_Ingreso,Codigo_de_Identificacion,Numero_de_planta,Numero_de_cama,Alergico,Observaciones)
VALUES(1,'10203-F','23/01/2009','AJH',5,121,'No','Epileptico')
,(2,'15413-S','13/03/2009','RLQ',2,5,'Si','Alergico a la penicilina')
,(3,'11454-L','25/05/2009','RLQ',3,31,'No','')
,(4,'15413-L','29/01/2010','CEM',2,13,'No','')
,(5,'14546-E','24/02/2010','AJH',1,5,'Si','Alergico al Paidoterin')

--Las consultas

SELECT Nombre_del_Medico,Fecha_de_ingreso FROM dbo.MEDICOS
WHERE Especialidad = 'Pediatria'

SELECT Nombre,Poblacion FROM dbo.PACIENTES
WHERE Poblacion = 'Madrid'

SELECT M.Nombre_del_Medico, I.Fecha_de_Ingreso FROM dbo.INGRESOS AS I
INNER JOIN dbo.MEDICOS AS M ON M.Codigo_Identificacion = I.Codigo_de_Identificacion
WHERE I.Fecha_de_Ingreso BETWEEN '01/01/2010' AND '28/02/2010'

SELECT P.Nombre,P.Apellidos FROM dbo.PACIENTES AS P
INNER JOIN dbo.INGRESOS AS I ON P.Numero_de_Historial = I.Numero_de_Historial
WHERE (I.Fecha_de_Ingreso BETWEEN '01/01/2009' AND '31/05/2009') AND (Observaciones like 'Alergico%')

SELECT P.Nombre,M.Nombre_del_Medico FROM dbo.PACIENTES AS P
INNER JOIN dbo.INGRESOS AS I ON P.Numero_de_Historial = I.Numero_de_Historial
INNER JOIN dbo.MEDICOS AS M ON M.Codigo_Identificacion = I.Codigo_de_Identificacion
WHERE M.Nombre_del_Medico = 'Antonio'

--Los procedimientos

CREATE PROCEDURE IntroducirMedicos
@Codigoidentificacion varchar(4),
@NombredeMedico varchar(15),
@ApellidosdeMedico varchar(30),
@Especialidad varchar(25),
@FechaIngreso date,
@Cargo varchar(25),
@NumerodeColegiado int,
@Observaciones varchar(max)

as

BEGIN
  if @NumerodeColegiado between 0 and 999
	return -1

	begin try
		insert into dbo.MEDICOS
		(Codigo_Identificacion,
		 Nombre_del_Medico,
         Apellidos_del_Medico ,    
         Especialidad,
         Fecha_de_ingreso,
		 Cargo,
		 Numero_de_Colegiado,
         Observaciones
		)
		values
		(@Codigoidentificacion,
			@NombredeMedico,
			@ApellidosdeMedico,
			@Especialidad,
			@FechaIngreso,
			@Cargo,
			@NumerodeColegiado,
			@Observaciones
		)
		return 0
		end try
		begin catch
			return @@ERROR
		END CATCH
END

EXECUTE IntroducirMedicos 'BGM','Beñat','Guerra Manterola','Pediatria','08-05-2020','Auxiliar',1001,''

CREATE PROCEDURE MostarDatos
@p_FechaInicio Date,
@p_FechaFinal Date

AS
BEGIN
	SELECT * FROM dbo.PACIENTES AS P
	INNER JOIN dbo.INGRESOS AS I ON I.Numero_de_Historial = P.Numero_de_Historial
	WHERE I.Fecha_de_Ingreso BETWEEN @p_FechaInicio AND @p_FechaFinal
END

EXECUTE MostarDatos '01/01/2009','01/02/2009'

--Las funciones

CREATE FUNCTION ContarPacientes(@pacientes tinyint)
returns int
as
BEGIN
	DECLARE @NumeroPacientes  tinyint
	SELECT @NumeroPacientes = COUNT(N_Seguridad_Social)
	FROM dbo.PACIENTES
	RETURN @NumeroPacientes 
END
