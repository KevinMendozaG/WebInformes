USE [APORTES_IDENTIFICAR]
GO
/****** Object:  StoredProcedure [dbo].[SP_ADMINISTRA_CLIENTES]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ADMINISTRA_CLIENTES]
   	   
		--Variables generales
		@Opcion nvarchar(200) = null,
		@Referencia nvarchar(45) = null,
		@Pagador nvarchar(80) = null,
		@Responsable varchar(500)= null,
		@NombrePara nvarchar(200) = null,
		@Nit nvarchar(70) = null,
		@NombreNitPara NVARCHAR(300) = NULL,

		@Usuario nvarchar(10)= null,
		@Perfil int = null
AS
BEGIN

	BEGIN TRY

			SET NOCOUNT ON;
       
			DECLARE @Fecha int;
			DECLARE @Hora nvarchar(20);			
			DECLARE @Cuenta_Estado_Actual int;
									
			SET @Fecha = convert(int,FORMAT(GetDate(), 'yyyyMMdd'));
			SET @Hora = convert(nvarchar(20), getdate(), 108); -- 114: hh:mm:ss:mmm(24h), 108: hh:mm:ss(24h)
			IF (@Usuario IS NULL)
				BEGIN
					Set @Usuario = 'No_User';
				END
			
			--------------------------------
			--->INICIA PROCESO:
			--------------------------------
		
			-->1.0 Crear Cliente
			IF (@Opcion = 'InsertaCliente')
				BEGIN

					set @Cuenta_Estado_Actual = (
						select count(c.Referencia) 
						from ClientesValores as c
						where c.Referencia = @Referencia
					);
			
					IF @Cuenta_Estado_Actual > 0								
						select 
							'Existe' as Estado_Superior
							,C.Referencia
						from ClientesValores as C
						where C.Referencia = @Referencia
					ELSE								
						-->1.0. Crear Clientes						
						INSERT INTO ClientesValores(Referencia, Pagador, Responsable, NombrePara, Nit, NombreNitPara) VALUES (@Referencia, @Pagador, @Responsable, @NombrePara, @Nit, @NombreNitPara)

						-----------------------------------------------------------------------------	
						--> Se devuelve Id del pago actualizado.
						SELECT 'Id_Pago' = @Referencia
						-----------------------------------------------------------------------------
					END

			--> 1.2 Modificar Cliente
			IF (@Opcion = 'ModificaCliente')
				BEGIN
					
					UPDATE ClientesValores SET Pagador=@Pagador, Responsable=@Responsable, NombrePara=@NombrePara, Nit=@Nit, NombreNitPara=@NombreNitPara WHERE Referencia = @Referencia
					
					--> Se devuelve Id del pago actualizado.
					SELECT 'Id_Pago' = @Referencia;

				END

			--> 1.3 eliminar Cliente
			IF (@Opcion = 'EliminaCliente')
				BEGIN
					
					DELETE FROM ClientesValores where Referencia = @Referencia
					
					--> Se devuelve Id del pago actualizado.
					SELECT 'Id_Pago' = @Referencia;
				END

											   
	END TRY

		BEGIN CATCH
		
      SELECT
        'Error' AS Error
        ,ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage;  
		   	
		END CATCH
 END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADMINISTRA_CODIGOS_TRANSACCION]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ADMINISTRA_CODIGOS_TRANSACCION]
   	   
		--Variables generales
		@Opcion NVARCHAR(30) = null,
		@NombreBanco NVARCHAR(30) = NULL,
		@NombreTransaccion NVARCHAR(100) = NULL,
		@IdOperacion int = null
AS
BEGIN

	BEGIN TRY

			SET NOCOUNT ON;
       
			--DECLARE @FechaFormateada date;
			--DECLARE @HoraFormateada time(7);
			--DECLARE @Cuenta_Estado_Actual int;
									
			--SET @FechaFormateada = FORMAT(GetDate(), 'yyyyMMdd');
			--SET @HoraFormateada = convert(time(7), getdate(), 108); -- 114: hh:mm:ss:mmm(24h), 108: hh:mm:ss(24h)
			
			--------------------------------
			--->INICIA PROCESO:
			--------------------------------
		
			-->1.0 INSERTAR Codigo
			IF (@Opcion = 'InsertaCodigoTransaccion')
				BEGIN
				---COMPROBAR DUPLICIDAD---------------------------------------------------

					--IF hayCUENTA > 0								
					
					--ELSE								
						-->1.0. Crear Codigo							
						INSERT INTO CodigosTransacciones(NombreBanco, NombreTransaccion) VALUES (@NombreBanco, @NombreTransaccion)

						----SACAMOS EL ID DE LA OPERACION RECIEN INSERTADA
						set @IdOperacion = SCOPE_IDENTITY()
						-----------------------------------------------------------------------------	
						--> Se devuelve Id del pago actualizado.
						SELECT 'Id_Pago' = @IdOperacion
						-----------------------------------------------------------------------------
					END

			--> 1.2 Modificar Codigo
			IF (@Opcion = 'ModificaCodigoTransaccion')
				BEGIN
					UPDATE CodigosTransacciones SET NombreBanco = @NombreBanco, NombreTransaccion = @NombreTransaccion WHERE IdCodigo = @IdOperacion
					
					--> Se devuelve Id del pago actualizado.
					SELECT 'Id_Pago' = @IdOperacion;
				END

			--> 1.3 Eliminar Cuenta
			IF (@Opcion = 'EliminaCodigoTransaccion')
				BEGIN
					
					DELETE FROM CodigosTransacciones where IdCodigo = @IdOperacion
					
					--> Se devuelve Id del pago actualizado.
					SELECT 'Id_Pago' = @IdOperacion;
				END

											   
	END TRY

		BEGIN CATCH
		
			  SELECT
					'Error' AS Error
					,ERROR_NUMBER() AS ErrorNumber  
					,ERROR_SEVERITY() AS ErrorSeverity  
					,ERROR_STATE() AS ErrorState  
					,ERROR_PROCEDURE() AS ErrorProcedure  
					,ERROR_LINE() AS ErrorLine  
					,ERROR_MESSAGE() AS ErrorMessage;  
		   	
		END CATCH

 END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADMINISTRA_CUENTAS_BANCARIAS]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ADMINISTRA_CUENTAS_BANCARIAS]
		--Variables generales
		@Opcion NVARCHAR(30) = null,
		@NumCuenta bigint = NULL,
		@NombreCuenta NVARCHAR(30) = NULL,
		@CuentaContable bigint = NULL,
		@LineaNegocio NVARCHAR(30) = NULL,
		@Banco NVARCHAR(30) = null,
		@Fondo NVARCHAR(30) = NULL,
		@TipoCuenta nvarchar(30) = NULL,
		@CodigoFondo VARCHAR(5) = NULL,
		@CodBanco VARCHAR(4) = NULL,

		--las sieguientes 2 variables son de identidad de quien crea el usuario
		@Usuario varchar(20)= null,
		@Perfil int = null
AS
BEGIN
	BEGIN TRY
			SET NOCOUNT ON;
       
			DECLARE @FechaFormateada date;
			DECLARE @HoraFormateada time(7);
			DECLARE @Cuenta_Estado_Actual int;
									
			SET @FechaFormateada = FORMAT(GetDate(), 'yyyyMMdd');
			SET @HoraFormateada = convert(time(7), getdate(), 108); -- 114: hh:mm:ss:mmm(24h), 108: hh:mm:ss(24h)
			IF (@Usuario IS NULL)
				BEGIN
					Set @Usuario = 'No_User';
				END
			
			--------------------------------
			--->INICIA PROCESO:
			--------------------------------
			-->1.0 INSERTAR CUENTA
			IF (@Opcion = 'InsertaCuenta')
				BEGIN
				---COMPROBAR DUPLICIDAD---------------------------------------------------

					--IF hayCUENTA > 0								
					SET @Cuenta_Estado_Actual = (
						SELECT COUNT(C.NombreCuenta) 
						FROM CuentasFondos AS C
						WHERE C.CuentaFondo = @NumCuenta
					);
					IF @Cuenta_Estado_Actual > 0								
						SELECT 
							'Existe' AS Estado_Superior
							,C.CuentaFondo
						FROM CuentasFondos AS C
						WHERE C.CuentaFondo = @NumCuenta				
					ELSE	
					--ELSE								
						-->1.0. Crear Cuenta							
						INSERT INTO CuentasFondos(CuentaFondo, NombreCuenta, TipoCuenta, CuentaContable, LineaNegocio, Banco, NombreFondo, Codigo, CodBanco) VALUES (@NumCuenta, @NombreCuenta, @TipoCuenta, @CuentaContable, @LineaNegocio, @Banco, @Fondo, @CodigoFondo, @CodBanco)

						----SACAMOS EL ID DE LA OPERACION RECIEN INSERTADA
						--set @IdOperacion = SCOPE_IDENTITY()
						-----INSERTAMOS EL TOQUE
						--INSERT INTO Toques(IdOperacion, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado) VALUES(@IdOperacion, 'Nuevo Registro', CONVERT(date, @FechaPartida, 126), @HoraFormateada, @Usuario,1)
						-----------------------------------------------------------------------------	
						--> Se devuelve Id del pago actualizado.
						SELECT 'Id_Pago' = @NumCuenta
						-----------------------------------------------------------------------------
					END
			--> 1.2 Modificar Cuenta
			IF (@Opcion = 'ModificaCuenta')
				BEGIN
					UPDATE CuentasFondos SET NombreCuenta=@NombreCuenta, CuentaContable=@CuentaContable, LineaNegocio=@LineaNegocio, Banco=@Banco, NombreFondo=@Fondo, TipoCuenta=@TipoCuenta, Codigo = @CodigoFondo, CodBanco = @CodBanco WHERE CuentaFondo = @NumCuenta
					
					--> Se devuelve Id del pago actualizado.
					SELECT 'Id_Pago' = @NumCuenta;
				END
			--> 1.3 Eliminar Cuenta
			IF (@Opcion = 'EliminaCuenta')
				BEGIN
					
					DELETE FROM CuentasFondos WHERE CuentaFondo = @NumCuenta
					
					--> Se devuelve Id del pago actualizado.
					SELECT 'Id_Pago' = @NumCuenta;
				END	
				
			-->Consulta Nombres Fondos para llenar combobox
			IF(@Opcion = 'ConsultaNombresFondos')
				BEGIN
					IF(@LineaNegocio = 'Fiduciaria')
						BEGIN 
							SELECT A.Codigo, A.Fondo AS NombreFondo FROM (SELECT * FROM FONDOS_MK.gen.Fondos) AS A 
						END
					ELSE
						BEGIN
							SELECT '' AS Codigo, B.NombreFondo FROM (SELECT * FROM FONDOS_MK.gen.CuentasFiduciaria) AS B
						END
				END
	END TRY
		BEGIN CATCH
		
			  SELECT
					'Error' AS Error
					,ERROR_NUMBER() AS ErrorNumber  
					,ERROR_SEVERITY() AS ErrorSeverity  
					,ERROR_STATE() AS ErrorState  
					,ERROR_PROCEDURE() AS ErrorProcedure  
					,ERROR_LINE() AS ErrorLine  
					,ERROR_MESSAGE() AS ErrorMessage;  
		END CATCH
 END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADMINISTRA_PARTIDAS_AXI]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ADMINISTRA_PARTIDAS_AXI] 
   	   
		--Variables generales
		@Opcion NVARCHAR(20) = NULL,
		@IdOperacion INT = NULL,
		@Estado INT = NULL,
		@NitCliente BIGINT = NULL,
		@NombreCliente NVARCHAR(50) = NULL,
		@Monto MONEY = NULL,
		--@Fondo NVARCHAR(50) = NULL,
		@TipoOperacion INT = NULL,
		@FechaCumplimiento NVARCHAR(20)= NULL, --fecha de cumplimiento, cuando en el codigo salta el parametro de horario o se radica un dia no habil esta fecha cambia, cuando no, pues la fecha es la misma actual que se declara abajo	
		@FechaIngresoBancario NVARCHAR(20) = NULL,
		@EntidadBancaria NVARCHAR(70) = NULL,
		@CuentaFondo BIGINT = NULL, 
		--las siguientes 2 variables son de identidad de quien crea el usuario
		@Usuario NVARCHAR(20)= NULL,
		@Perfil INT = NULL
AS
BEGIN
	BEGIN TRY
			SET NOCOUNT ON;
			DECLARE @FechaFormateada DATE; --Fecha actual
			DECLARE @HoraFormateada TIME(7); -- Hora actual
			DECLARE @Partida_Estado_Actual INT;
									
			--FechaFormateada es donde sacamos la fecha actual
			SET @FechaFormateada = FORMAT(GetDate(), 'yyyyMMdd');
			SET @HoraFormateada = CONVERT(TIME(7), GETDATE(), 108); -- 114: hh:mm:ss:mmm(24h), 108: hh:mm:ss(24h)
			IF (@Usuario IS NULL)
				BEGIN
					Set @Usuario = 'No_User';
				END
			--------------------------------
			--->INICIA PROCESO:
			--------------------------------
					---->ModificaPartida, es la edicion que hace el coordinador o administrador a alguna aprtida que seleccione
			IF (@Opcion = 'ModificaPartidaAXI')
				BEGIN
					UPDATE PartidasIdentificar SET NitCliente = @NitCliente, NombreCliente = @NombreCliente, EstadoId = @Estado, Monto = @Monto, TipoOperacion = @TipoOperacion, FechaCumplimiento = CONVERT(DATE, @FechaCumplimiento, 126), FechaIngresoBancario = CONVERT(DATE, @FechaIngresoBancario, 126), EntidadBancaria = @EntidadBancaria, CuentaFondo = @CuentaFondo
					WHERE Id = @IdOperacion
					
					--Se modifica fecha cumplimiento en el modulo de aportes por legalizar, ya esta fecha de cumplimiento dependen varios informes
					IF (@FechaCumplimiento IS NOT NULL)
						BEGIN
							UPDATE PartidasLegalizar SET FechaCumplimiento = CONVERT(DATE, @FechaCumplimiento, 126), EstadoId = @Estado WHERE IdAxi = @IdOperacion
						END

					-----INSERTAMOS EL TOQUE
						INSERT INTO Toques(IdOperacion, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado) VALUES(@IdOperacion, 'Modificado por Coordinador', CONVERT(DATE, @FechaFormateada, 126), @HoraFormateada, @Usuario, @Estado)

					--> Se devuelve Id del pago actualizado.
						SELECT 'Id_Pago' = @IdOperacion;
				END
			IF (@Opcion = 'EliminaPartida')
				BEGIN
					DELETE FROM PartidasIdentificar WHERE Id = @IdOperacion
					--Tambien eliminar toque?
					INSERT INTO TOQUES(IdOperacion, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado) VALUES(@IdOperacion, 'Eliminado por Coordinador', CONVERT(DATE, @FechaFormateada, 126), @HoraFormateada, @Usuario, 9)
					--> Se devuelve Id del pago actualizado.
						SELECT 'Id_Pago' = @IdOperacion;
				END
	END TRY
		BEGIN CATCH
			  SELECT
					'Error' AS Error
					,ERROR_NUMBER() AS ErrorNumber  
					,ERROR_SEVERITY() AS ErrorSeverity  
					,ERROR_STATE() AS ErrorState  
					,ERROR_PROCEDURE() AS ErrorProcedure  
					,ERROR_LINE() AS ErrorLine  
					,ERROR_MESSAGE() AS ErrorMessage;  
		END CATCH
 END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADMINISTRA_PARTIDAS_AXL]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ADMINISTRA_PARTIDAS_AXL] 
  --Variables generales
  @Opcion NVARCHAR(20) = NULL,
  @IdOperacion INT = NULL,
  @NitCliente BIGINT = NULL,
  @NombreCliente NVARCHAR(50) = NULL,
  @Estado INT = NULL,
  @Monto MONEY = NULL,
  @Fondo NVARCHAR(50) = NULL,
  @TipoOperacion INT = NULL,
  @Observacion NVARCHAR(max)= NULL,
  @FechaPartida NVARCHAR(20)= NULL,
  @FechaIngresoBancario NVARCHAR(20) = NULL,			
  @EntidadBancaria NVARCHAR(30) = NULL,
  @CuentaInversion VARCHAR(30) = NULL,
  @ConfirmacionDuplicidad BIT = NULL,
  @NombreSoporte NVARCHAR(200) = NULL,
  @PlazoFondo INT = NULL,
  @LineaNegocio VARCHAR(50) = NULL,
  @NitFondo BIGINT = NULL,
  @NumeroFisico VARCHAR(50) = NULL,
  @CodTipoIdTitular Char(2) = NULL,
  @Usuario NVARCHAR(20)= NULL,
  @Perfil INT = NULL
AS
BEGIN
	BEGIN TRY
			SET NOCOUNT ON;
       
			DECLARE @FechaFormateada DATE; --Fecha actual
			DECLARE @HoraFormateada TIME(7); -- Hora actual
			DECLARE @Partida_Estado_Actual INT;
			DECLARE @IdAxL INT;
			DECLARE @Llave VARCHAR(50); --Llave para cruzar Los aportes ingresados por los comerciales con los aportes por identificar
			DECLARE @IdOperacionAxi INT;
			
			--Fecha y Hora actual
			SET @FechaFormateada = FORMAT(GetDate(), 'yyyyMMdd');
			SET @HoraFormateada = CONVERT(time(7), getdate(), 108); -- 114: hh:mm:ss:mmm(24h), 108: hh:mm:ss(24h)
			IF (@Usuario IS NULL)
				BEGIN
					Set @Usuario = 'No_User';
				END
			--------------------------------
			--->Inicia Proceso:
			--------------------------------
		
			-->1.0 Inserta partida a legalizar
			IF (@Opcion = 'InsertaLegalizar')
			BEGIN

				SET @Llave = CONCAT(CASE WHEN @LineaNegocio = 'Fiduciaria Bancolombia' THEN 
				(SELECT F.NIT_FONDO FROM FONDOS_MK.gen.Fondos F WHERE F.Codigo = @Fondo) ELSE @NitFondo END, @EntidadBancaria, @Monto, @FechaIngresoBancario);
				------Comprueba duplicidad---------						
				SET @Partida_Estado_Actual = (
					SELECT COUNT(P.NombreCliente) 
					FROM PartidasLegalizar AS P
					WHERE P.Llave = @Llave
				);
			
				--ConfirmarDuplicidad es un parametro que cuando el usuario confirma, se ingresa una partida duplicada
				IF @Partida_Estado_Actual > 0 AND @ConfirmacionDuplicidad = 0	
					BEGIN
						SELECT TOP(1)
							'ExisteSimilar' AS Estado_Superior, CONVERT(NVARCHAR(max),P.FechaIngresoBancario,103) AS FechaIngresoBancario, FORMAT(P.Monto, 'C') AS Monto, P.Fondo
						FROM PartidasLegalizar AS P
						WHERE P.Llave = @Llave
					END
				ELSE	
					BEGIN

						SET @Llave = CONCAT(CASE WHEN @LineaNegocio = 'Fiduciaria Bancolombia' THEN 
						(SELECT F.NIT_FONDO FROM FONDOS_MK.gen.Fondos F WHERE F.Codigo = @Fondo) ELSE @NitFondo END, @EntidadBancaria, @Monto, @FechaIngresoBancario);

						--Relaciona el Nit del fondo, Valor y fechaIngresoBancario con la tabla de partidas identificar para buscar su Id y asignarlo a la partida que el comercial acaba de ingresar para legalizar	
						--Solo se selecciona un Id en caso de que hayan partidas similares
						SET @IdOperacion = (SELECT TOP(1) Id FROM PartidasIdentificar WHERE Llave = @Llave AND (DuplicadoTomado IS NULL) AND EstadoId != 4); --Cuando DuplicadoTomado es null es que esta libre para relacionar con una partida en el modulo de los comerciales
						
						IF (@IdOperacion IS NULL) --Si no encuentra ningun registro que duplicadotomado sea null y que tenga la llave
							BEGIN
							-->CODIGO ANTIGUO<--
								--Se retorna tambien el DuplicadoTomado, en caso de que sea 1 es que ya hay una partida relacionada y no hay mas que no esten marcadas con las cuales relacionar
								--SELECT 'NoExiste' AS Estado_Superior, (SELECT TOP(1) DuplicadoTomado FROM PartidasIdentificar WHERE (NitCliente = @NitCliente) AND (Monto = @Monto) AND (FechaIngresoBancario = @FechaIngresoBancario)) AS DuplicadoTomado
							
							--Si no existe o hay que crearlo y dejarlo suelto, hasta que entre un registro en aportes por identificar
							-->Crear Partida							
								INSERT INTO PartidasLegalizar(IdAxi, UsuarioRadicador, NitCliente, NombreCliente, EstadoId, Monto, FechaRadicacion, HoraRadicacion, Fondo, TipoOperacion, FechaCumplimiento, FechaIngresoBancario, EntidadBancaria, CuentaInversion, LineaNegocio, PerfilUsuarioRadica, PlazoFondo, Llave, NitFondo, CodTipoIdTitular, NumeroFisico) 
								VALUES (0, @Usuario, @NitCliente, @NombreCliente ,1, @Monto, CONVERT(date, @FechaFormateada, 126),@HoraFormateada, @Fondo, @TipoOperacion, CONVERT(date, @FechaPartida, 126), CONVERT(date, @FechaIngresoBancario, 126), @EntidadBancaria, @CuentaInversion, @LineaNegocio, @Perfil, @PlazoFondo, @Llave, @NitFondo, @CodTipoIdTitular, @NumeroFisico)

								SET @IdOperacion = SCOPE_IDENTITY();

								--Inserta el soporte relacionando el Id de la partida que se acaba de ingresar
								INSERT INTO Soporte (IdPago,IdAxL, NombreSoporte, FechaSubido, HoraSubido) 
								VALUES (0,@IdOperacion, @NombreSoporte, @FechaFormateada, @HoraFormateada)

								-----Inserta Toque
								INSERT INTO Toques(IdOperacion, IdAxL, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado) 
								VALUES(0,@IdOperacion, 'Ingresada por comercial', CONVERT(date, @FechaFormateada, 126), @HoraFormateada, @Usuario,1)
								-----------------------------------------------------------------------------	
								--> Se devuelve Id del pago actualizado.
								SELECT 'Id_Pago' = @IdOperacion
							END
						ELSE --Encuentra partida para relacionar
							BEGIN
								SET @Llave = CONCAT(CASE WHEN @LineaNegocio = 'Fiduciaria Bancolombia' THEN 
								(SELECT F.NIT_FONDO FROM FONDOS_MK.gen.Fondos F WHERE F.Codigo = @Fondo) ELSE @NitFondo END, @EntidadBancaria, @Monto, @FechaIngresoBancario);

								SET @Estado = (SELECT EstadoId FROM PartidasIdentificar WHERE Id = @IdOperacion)
								-->Crear Partida	
								IF(@Estado = 1 OR @Estado = 2 OR @Estado = 7 OR @Estado = 12)	--Si la partida esta en estado pendiente, o pendiente soporte, se pone en revisar soporte
									BEGIN
										SET @Estado = 11
									END
									
								INSERT INTO PartidasLegalizar(IdAxi, UsuarioRadicador, NitCliente, NombreCliente, EstadoId, Monto, FechaRadicacion, HoraRadicacion, Fondo, TipoOperacion, FechaCumplimiento, FechaIngresoBancario, EntidadBancaria, CuentaInversion, LineaNegocio, PerfilUsuarioRadica, PlazoFondo, DuplicadoTomado, Llave, NitFondo, CodTipoIdTitular, NumeroFisico) 
								VALUES (@IdOperacion, @Usuario, @NitCliente, @NombreCliente ,@Estado, @Monto, CONVERT(date, @FechaFormateada, 126),@HoraFormateada, @Fondo, @TipoOperacion, CONVERT(date, @FechaPartida, 126), CONVERT(date, @FechaIngresoBancario, 126), @EntidadBancaria, @CuentaInversion, @LineaNegocio, @Perfil, @PlazoFondo, 1, @Llave, @NitFondo, @CodTipoIdTitular, @NumeroFisico)

								SET @IdAxL = SCOPE_IDENTITY();

								--Marca la partida de axi como tomada, tambien le pone fecha de cumplimiento, actualiza en estado(En caso que este en pendiente cambia a en gestion), pone el tipo de operacion
								UPDATE PartidasIdentificar SET DuplicadoTomado = 1, FechaCumplimiento = CONVERT(date, @FechaPartida, 126), IdPartidaLegalizar = SCOPE_IDENTITY(), EstadoId = @Estado, TipoOperacion = @TipoOperacion WHERE Id = @IdOperacion

								--Inserta el soporte relacionando el Id de la partida que se acaba de ingresar
								INSERT INTO Soporte (IdPago, IdAxL, NombreSoporte, FechaSubido, HoraSubido) VALUES (0, @IdAxL, @NombreSoporte, @FechaFormateada, @HoraFormateada)

								-----Inserta Toque
								INSERT INTO Toques(IdOperacion, IdAxL ,TipoToque, FechaToque, HoraToque, UsuarioToque, Estado) VALUES(@IdOperacion, @IdAxL, 'Ingresada por comercial', CONVERT(date, @FechaFormateada, 126), @HoraFormateada, @Usuario, @Estado)
								-----------------------------------------------------------------------------	
								--> Se devuelve Id del pago actualizado.
								SELECT 'Id_Pago' = @IdOperacion
							END
					END
			END
								-----------------------------------------------------------------------------
			---->ModificaPartidaAXL, cuando al comercial se le devuelve modifica la partida
			IF (@Opcion = 'ModificaPartidaAXL')
				BEGIN
					SET @Llave = CONCAT(CASE WHEN @LineaNegocio = 'Fiduciaria Bancolombia' THEN 
					(SELECT F.NIT_FONDO FROM FONDOS_MK.gen.Fondos F WHERE F.Codigo = @Fondo) ELSE @NitFondo END, @EntidadBancaria, @Monto, @FechaIngresoBancario);

					--Actualiza los campos y abajo se inserta de nuevo el soporte (Se pone en gestion, si es una partida independiente, se busca en axi, si esta se pone en estado revisar soporte)
					UPDATE PartidasLegalizar SET UsuarioRadicador = @Usuario, NitCliente = @NitCliente, NombreCliente = @NombreCliente, 
					EstadoId = 1, Monto = @Monto, FechaRadicacion = CONVERT(date, @FechaFormateada, 126),HoraRadicacion = @HoraFormateada, 
					Fondo = @Fondo, TipoOperacion = @TipoOperacion, FechaCumplimiento = CONVERT(date, @FechaPartida, 126), 
					FechaIngresoBancario = CONVERT(DATE, @FechaIngresoBancario, 126), EntidadBancaria = @EntidadBancaria, 
					CuentaInversion = @CuentaInversion, LineaNegocio = @LineaNegocio, PlazoFondo = @PlazoFondo, NitFondo = @NitFondo, 
					CodTipoIdTitular = @CodTipoIdTitular, FechaModificacion = @FechaFormateada, NumeroFisico = @NumeroFisico, Llave = @Llave
					WHERE Id = @IdOperacion

					IF(@NombreSoporte != '' OR @NombreSoporte IS NULL)
						BEGIN
							--Inserta el soporte 
							INSERT INTO Soporte ( IdPago,IdAxL, NombreSoporte, FechaSubido, HoraSubido) VALUES (0, @IdOperacion, @NombreSoporte, @FechaFormateada, @HoraFormateada)
						END
					
					--Si ya esta relacionada cambia el estado, si no esta relacionada busca con quien relacionarla
					SET @IdOperacionAxi = (SELECT TOP(1) Id FROM PartidasIdentificar WHERE IdPartidaLegalizar = @IdOperacion);
					IF (@IdOperacionAxi IS NOT NULL) --Si encuentra un registro relacionado
						BEGIN
							--Actualiza el estado y la fecha de cumplimiento de la partida en aportes por identificar(Modulo de gestion) para que quede otra vez en revisar soporte
							UPDATE PartidasIdentificar SET EstadoId = 11, FechaCumplimiento = CONVERT(DATE, @FechaPartida, 126) WHERE IdPartidaLegalizar = @IdOperacion
							UPDATE PartidasLegalizar SET EstadoId = 11 WHERE ID= @IdOperacion
							UPDATE Soporte SET IdPago = @IdOperacionAxi WHERE IdAxL = @IdOperacion
							-----Inserta Toque
							INSERT INTO Toques(IdOperacion, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado) VALUES(@IdOperacionAxi, 'Modificado por Comercial', CONVERT(date, @FechaFormateada, 126), @HoraFormateada, @Usuario, 11)
						END
					ELSE 
						BEGIN
							SET @IdOperacionAxi = (SELECT TOP(1) Id FROM PartidasIdentificar WHERE Llave = @Llave AND (DuplicadoTomado IS NULL)  AND EstadoId != 4);--Encuentra una partida para relacionar
							IF(@IdOperacionAxi IS NOT NULL)
								BEGIN
									--Marca la partida de axi como tomada, actualiza en estado a revisar soporte, pone el tipo de operacion
									UPDATE PartidasIdentificar SET DuplicadoTomado = 1, IdPartidaLegalizar = @IdOperacion, EstadoId = 11, TipoOperacion = @TipoOperacion WHERE Id = @IdOperacionAxi
									UPDATE PartidasLegalizar SET DuplicadoTomado = 1, IdAxi = @IdOperacionAxi, EstadoId = 11 WHERE Id = @IdOperacion
									-----Inserta Toque
									INSERT INTO Toques(IdOperacion, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado) VALUES(@IdOperacionAxi, 'Modificado por Comercial', CONVERT(date, @FechaFormateada, 126), @HoraFormateada, @Usuario, 11)
								END
							ELSE
								BEGIN--Comercial modifica y queda en pendiente
									-----Inserta Toque
							INSERT INTO Toques(IdOperacion, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado, IdAxL) VALUES(0, 'Modificado por Comercial', CONVERT(date, @FechaFormateada, 126), @HoraFormateada, @Usuario, 1, @IdOperacion)
								END
						END

					--> Se devuelve Id del pago actualizado.
					SELECT 'Id_Pago' = @IdOperacion;
				END
			IF(@Opcion = 'EliminaPartidaAXL')
				BEGIN
					DELETE FROM	PartidasLegalizar WHERE Id = @IdOperacion
					--Tambien eliminar toque?
					INSERT INTO TOQUES(IdOperacion, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado, IdAxL) VALUES(0, 'Eliminado por Administrador', CONVERT(DATE, @FechaFormateada, 126), @HoraFormateada, @Usuario, 9, @IdOperacion)
					--> Se devuelve Id del pago actualizado.
					SELECT 'Id_Pago' = @IdOperacion;
				END
			IF(@Opcion = 'GestionarAxl')
				BEGIN
					IF(@Estado = 7 OR @Estado = 6)--Si se devuelve o se rechaza
						BEGIN --Se deja individual, si se devuelve o se rechaza solo se hace el cambio a la tabla de las solicitudes de los comerciales
							UPDATE PartidasLegalizar SET EstadoId = @Estado, FechaModificacion = @FechaFormateada WHERE Id = @IdOperacion

							IF(@Estado = 6) -- Cuando se rechaza la partida se desliga
							BEGIN
								UPDATE PartidasLegalizar SET idAxi = null, DuplicadoTomado = NULL WHERE Id = @IdOperacion

								UPDATE PartidasIdentificar SET IdPartidaLegalizar = null, DuplicadoTomado = null WHERE IdPartidaLegalizar = @IdOperacion
							END

							-----Inserta Toque
							IF(@Estado = 6) --Rechazado
							BEGIN
								INSERT INTO Toques(IdOperacion, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado, IdAxL) VALUES(0, 'Partida Rechazada', CONVERT(date, @FechaFormateada, 126), @HoraFormateada, @Usuario, @Estado, @IdOperacion)
							END
							ELSE--eSTADO 7 SE DEVUELVE
							BEGIN
								INSERT INTO Toques(IdOperacion, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado, IdAxL) VALUES(0, 'Devolución de partida', CONVERT(date, @FechaFormateada, 126), @HoraFormateada, @Usuario, @Estado, @IdOperacion)

							END
							--Inserta la observacion(La observacion se hace con el Id Axi solamente)
							INSERT INTO Observaciones(IdOperacion, Observacion, FechaObservacion, HoraObservacion, UsuarioObservacion, IdAxl) VALUES(0, @Observacion, @FechaFormateada, @HoraFormateada, @Usuario, @IdOperacion)
						END
					ELSE--Se puso en pendiente aprobacion O liquidacion
						BEGIN
							UPDATE PartidasLegalizar SET EstadoId = @Estado, FechaModificacion = @FechaFormateada WHERE Id = @IdOperacion

							-----Inserta Toque
							INSERT INTO Toques(IdOperacion, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado, IdAxL) VALUES(0, 'Cambio de estado', CONVERT(date, @FechaFormateada, 126), @HoraFormateada, @Usuario, @Estado, @IdOperacion)
							IF (@Observacion != '')
								BEGIN
									INSERT INTO Observaciones(IdOperacion, Observacion, FechaObservacion, HoraObservacion, UsuarioObservacion, IdAxl) VALUES(0, @Observacion, @FechaFormateada, @HoraFormateada, @Usuario, @IdOperacion)
								END
						END
					--> Se devuelve Id del pago actualizado.
					SELECT 'Id_Pago' = @IdOperacion
							,Usuario = @Usuario
							,Observacion = @Observacion
							,UsuarioRadicador = (SELECT UsuarioRadicador FROM PartidasLegalizar WHERE Id = @IdOperacion);
				END
	END TRY
		BEGIN CATCH
      SELECT
        'Error' AS Error
        ,ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage;  
		END CATCH
 END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADMINISTRA_RENDIMIENTOS]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ADMINISTRA_RENDIMIENTOS] --Procedimiento que me devuelve las partidas pendientes de rendimeinto del dia anterior, tambien se usa para actualizar los rendimientos de cada partida en las tablas de partidaslegalizar y partidas identificar
	@Fecha NVARCHAR(20) = NULL, 
	@IdOperacion INT = NULL,
	@IdAxi INT = NULL,
	@Opcion VARCHAR(22) = NULL,
	@UnidadInicial VARCHAR(25) = NULL,
	@UnidadFinal VARCHAR(25) = NULL,
	@Rendimientos VARCHAR(25) = NULL
AS
BEGIN
	BEGIN TRY 

		IF(@Opcion = 'PendientesFidu')
			--Consulta partidas legalizadas ayer(Fiduciaria) Que hanian ingresado a la cuenta de aportes por lue se pagaron rendimientos
			BEGIN
				SELECT B.Id AS IdAxi, A.Fondo, FORMAT(A.FechaIngresoBancario, 'yyyyMMdd') AS FechaIngresoBancario, B.FechaRadicacion AS FechaSubidaAportes, B.CuentaFondo, A.Id AS IdAxl, B.NitCliente, B.NombreCliente, B.CuentaInversion, B.Monto AS ValorAporte, FORMAT(A.FechaModificacion, 'yyyyMMdd') AS FechaAprobacion, NitFondo
				FROM PartidasLegalizar A INNER JOIN PartidasIdentificar B ON A.IdAxi = B.Id
				WHERE A.FechaModificacion = CONVERT(DATE, @Fecha, 126) AND (A.EstadoId = 4 OR A.EstadoId = 8) AND A.LineaNegocio = 'Fiduciaria Bancolombia'
				UNION ALL--Partidas que solo se sacaron de aportes, sin la nota credito al cliente
				SELECT Axi.Id AS IdAxi, Cuentas.Codigo AS Fondo, FORMAT(Axi.FechaIngresoBancario, 'yyyyMMdd') AS FechaIngresoBancario, Axi.FechaRadicacion AS FechaSubidaAportes, Axi.CuentaFondo, null AS IdAxl, 0, '', '' , Axi.Monto AS ValorAporte, '' AS FechaAprobacion, ''
				FROM PartidasIdentificar Axi INNER JOIN CuentasFondos Cuentas ON Axi.CuentaFondo = Cuentas.CuentaFondo
				WHERE (Axi.EstadoId = 8) AND Axi.Linea = 'Fiduciaria Bancolombia' AND IdPartidaLegalizar IS NULL

				--Actualiza el estado a finalizado
				UPDATE PartidasLegalizar 
				SET EstadoId = 4
				FROM PartidasIdentificar T1
				INNER JOIN PartidasLegalizar T2 ON T1.Id=T2.IdAxi
				WHERE T2.FechaModificacion = CONVERT(DATE, @Fecha, 126) AND (T2.EstadoId = 8) AND T2.LineaNegocio = 'Fiduciaria Bancolombia'

				UPDATE PartidasIdentificar 
				SET EstadoId = 4
				FROM PartidasLegalizar T1
				INNER JOIN PartidasIdentificar T2 ON T1.IdAxi = T2.Id
				WHERE T1.FechaModificacion = CONVERT(DATE, @Fecha, 126) AND (T2.EstadoId = 8) AND T2.Linea = 'Fiduciaria Bancolombia'

				UPDATE PartidasIdentificar 
				SET EstadoId = 4
				WHERE (EstadoId = 8) AND Linea = 'Fiduciaria Bancolombia' AND IdPartidaLegalizar IS NULL
			END

		IF(@Opcion = 'ConsultaPendientes')
		--Consulta partidas legalizadas ayer(Valores) Y que hayan ingresado a la cuenta de aportes por lo cual son partidas pendientes de generar rendimientos
		BEGIN
			SELECT B.Id AS IdAxi, A.Fondo, A.FechaIngresoBancario, B.FechaRadicacion AS FechaSubidaAportes, B.CuentaFondo, A.Id AS IdAxl, A.NitCliente, A.NombreCliente, A.CuentaInversion, B.Monto AS ValorAporte, A.FechaModificacion AS FechaAprobacion, NitFondo
			FROM PartidasLegalizar A INNER JOIN PartidasIdentificar B ON A.IdAxi = B.Id
			WHERE A.FechaModificacion = CONVERT(DATE, @Fecha, 126) AND (A.EstadoId = 4 OR A.EstadoId = 8) AND A.LineaNegocio = 'Valores Bancolombia' AND IngresaCuentaAportes = 1 
			UNION ALL --Se agrega para partidas que solo se haga nd a la cuenta de aportes
			SELECT Axi.Id AS IdAxi, Cuentas.NombreFondo AS Fondo, Axi.FechaIngresoBancario, axi.FechaRadicacion AS FechaSubidaAportes, Axi.CuentaFondo, null AS IdAxl, 0, '', '', Axi.Monto AS ValorAporte, '' AS FechaAprobacion, ''
			FROM PartidasIdentificar Axi INNER JOIN CuentasFondos Cuentas ON Axi.CuentaFondo = Cuentas.CuentaFondo
			WHERE Axi.FechaModificacion = CONVERT(DATE, @Fecha, 126) AND (Axi.EstadoId = 4 OR Axi.EstadoId = 8)AND Linea = 'Valores Bancolombia' AND IngresaCuentaAportes = 1 AND IdPartidaLegalizar IS NULL
		END

		IF(@Opcion = 'ActualizaRendimientos')
		BEGIN
			IF(@IdOperacion IS NULL)
				BEGIN
				UPDATE PartidasIdentificar SET ValorUnidadInicial = @UnidadInicial, ValorUnidadFinal = @UnidadFinal, Rendimientos = @Rendimientos 
					WHERE Id = @IdAxi
				END
			ELSE
				BEGIN
					--Actualiza tabla de aportes por legalizar
					UPDATE PartidasLegalizar SET ValorUnidadInicial = @UnidadInicial, ValorUnidadFinal = @UnidadFinal, Rendimientos = @Rendimientos 
					WHERE Id = @IdOperacion
					--Actualiza la tabla de aportes por identificar
					UPDATE PartidasIdentificar SET ValorUnidadInicial = @UnidadInicial, ValorUnidadFinal = @UnidadFinal, Rendimientos = @Rendimientos 
					WHERE IdPartidaLegalizar = @IdOperacion

					SELECT @IdOperacion AS IdPago
				END
		END

		IF(@Opcion = 'PlanoPago')
		--Consulta con la estructura del plano para pago de rendimientos
			BEGIN 

				--Solo hacer ND  de aportes
				SELECT B.NumeroFisico, B.NitPlano, 
				CASE WHEN CAST(Axi.Rendimientos AS DECIMAL(25,2)) < 0 THEN 9 ELSE 10 END AS CodTransaccion, 
				CASE WHEN CAST(Axi.Rendimientos AS DECIMAL(25,2)) < 0 THEN 146 ELSE 170 END AS CodFormaPago, 
				CASE 
						WHEN CONVERT(DECIMAL(25,2), ROUND(ISNULL(Axi.Rendimientos, 0), 2)) < 0 
						THEN CAST(CONVERT(DECIMAL(25,2), ROUND(ISNULL(Axi.Rendimientos, 0), 2) * -1) AS VARCHAR(MAX)) 
						ELSE CAST(CONVERT(DECIMAL(25,2), ROUND(ISNULL(Axi.Rendimientos, 0), 2)) AS VARCHAR(MAX))
				END AS ValorFinal,
				CONVERT( varchar(10) , GETDATE(), 120) AS FechaLegalizacion
				FROM (PartidasIdentificar Axi INNER JOIN CuentasFondos Cuentas ON Axi.CuentaFondo = Cuentas.CuentaFondo) INNER JOIN FisicosFondo B ON Cuentas.NombreFondo = B.NombreFondo
				WHERE Axi.FechaModificacion = CONVERT(DATE, @Fecha, 126) AND (Axi.EstadoId = 4 OR Axi.EstadoId = 8) AND Axi.Linea = 'Valores Bancolombia' AND Axi.IngresaCuentaAportes = 1  AND Axi.IdPartidaLegalizar IS NULL
				AND B.NumeroFisico = 
				CASE 
					WHEN B.NombreFondo = 'Renta Liquidez' AND CONVERT(INT, CONVERT(VARCHAR(8), Axi.FechaIngresoBancario, 112)) >= 20211104 THEN '0021009108140288'
					WHEN B.NombreFondo = 'Renta Liquidez' AND CONVERT(INT, CONVERT(VARCHAR(8), Axi.FechaIngresoBancario, 112)) < 20211104 THEN '021009104911909'
					ELSE B.NumeroFisico
				END
				UNION ALL
				--NC o ND Para la cuenta del Fondo - Partidas que esten legalizadas del dia de ayer que hayan ingresado a la cuenta de aportes por identificar, por lo tanto estan pendientes de pagar rendimientos
				SELECT B.NumeroFisico, B.NitPlano, 
				CASE WHEN CAST(A.Rendimientos AS DECIMAL(25,2)) < 0 THEN 9 ELSE 10 END AS CodTransaccion, 
				CASE WHEN CAST(A.Rendimientos AS DECIMAL(25,2)) < 0 THEN 180 ELSE 181 END AS CodFormaPago, 
				CASE 
						WHEN CONVERT(DECIMAL(25,2), ROUND(ISNULL(A.Rendimientos, 0), 2)) < 0 
						THEN CAST(CONVERT(DECIMAL(25,2), ROUND(ISNULL(A.Rendimientos, 0), 2) * -1) AS VARCHAR(MAX)) 
						ELSE CAST(CONVERT(DECIMAL(25,2), ROUND(ISNULL(A.Rendimientos, 0), 2)) AS VARCHAR(MAX))
				END AS ValorFinal,
				CONVERT( varchar(10) , GETDATE(), 120) AS FechaLegalizacion
				FROM PartidasLegalizar A INNER JOIN FisicosFondo B ON A.NitFondo = B.NitPlano
				INNER JOIN PartidasIdentificar Axi ON A.IdAxi = Axi.Id
				WHERE A.FechaModificacion = CONVERT(DATE, @Fecha, 126) AND (A.EstadoId = 4 OR A.EstadoId = 8) AND A.LineaNegocio = 'Valores Bancolombia' AND Axi.IngresaCuentaAportes = 1 
				AND B.NumeroFisico = 
				CASE 
					WHEN B.NombreFondo = 'Renta Liquidez' AND CONVERT(INT, CONVERT(VARCHAR(8), A.FechaIngresoBancario, 112)) >= 20211104 THEN '0021009108140288'
					WHEN B.NombreFondo = 'Renta Liquidez' AND CONVERT(INT, CONVERT(VARCHAR(8), A.FechaIngresoBancario, 112)) < 20211104 THEN '021009104911909'
					ELSE B.NumeroFisico
				END
				UNION ALL
				--NC O ND Para el cliente segun los rendimientos
				SELECT A.NumeroFisico, A.NitFondo, 
				CASE WHEN CAST(A.Rendimientos AS DECIMAL(25,2)) < 0 THEN 10 ELSE 9 END AS CodTransaccion, 
				CASE WHEN CAST(A.Rendimientos AS DECIMAL(25,2)) < 0 THEN 181 ELSE 180 END AS CodFormaPago, 
				CASE 
						WHEN CONVERT(DECIMAL(25,2), ROUND(ISNULL(Axi.Rendimientos, 0), 2)) < 0 
						THEN CAST(CONVERT(DECIMAL(25,2), ROUND(ISNULL(Axi.Rendimientos, 0), 2) * -1) AS VARCHAR(MAX)) 
						ELSE CAST(CONVERT(DECIMAL(25,2), ROUND(ISNULL(Axi.Rendimientos, 0), 2)) AS VARCHAR(MAX))
				END AS ValorFinal,
				CONVERT( varchar(10) , GETDATE(), 120) AS FechaLegalizacion
				FROM PartidasLegalizar A INNER JOIN PartidasIdentificar Axi ON A.IdAxi = Axi.Id
				WHERE A.FechaModificacion = CONVERT(DATE, @Fecha, 126) AND (A.EstadoId = 4 OR A.EstadoId = 8) AND A.LineaNegocio = 'Valores Bancolombia' AND Axi.IngresaCuentaAportes = 1
				
				--Actualiza el estado a finalizado
				UPDATE PartidasLegalizar 
				SET EstadoId = 4
				FROM PartidasIdentificar T1
				INNER JOIN PartidasLegalizar T2 ON T1.Id=T2.IdAxi
				WHERE T2.FechaModificacion = CONVERT(DATE, @Fecha, 126) AND (T2.EstadoId = 4 OR T2.EstadoId = 8) AND T2.LineaNegocio = 'Valores Bancolombia' AND T1.IngresaCuentaAportes = 1

				UPDATE PartidasIdentificar 
				SET EstadoId = 4
				FROM PartidasLegalizar T1
				INNER JOIN PartidasIdentificar T2 ON T1.IdAxi = T2.Id
				WHERE T1.FechaModificacion = CONVERT(DATE, @Fecha, 126) AND (T1.EstadoId = 4 OR T1.EstadoId = 8) AND T1.LineaNegocio = 'Valores Bancolombia' AND T2.IngresaCuentaAportes = 1

				UPDATE PartidasIdentificar 
				SET EstadoId = 4
				WHERE EstadoId = 8 AND Linea = 'Valores Bancolombia' AND IngresaCuentaAportes = 1 AND IdPartidaLegalizar IS NULL
			END
	END TRY
	BEGIN CATCH
    SELECT
      'Error' AS Error
      ,ERROR_NUMBER() AS ErrorNumber  
      ,ERROR_SEVERITY() AS ErrorSeverity  
      ,ERROR_STATE() AS ErrorState  
      ,ERROR_PROCEDURE() AS ErrorProcedure  
      ,ERROR_LINE() AS ErrorLine  
      ,ERROR_MESSAGE() AS ErrorMessage;  
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADMINISTRA_USUARIOS]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ADMINISTRA_USUARIOS] 
   	   
		--Variables generales
		@Opcion nvarchar(200) = null,
		@IdOperacion int = null,
		@Usuario_Red_Form nvarchar(10)= null,
		@Nombre_Usuario_Form nvarchar(100)= null,
		@Perfil_Form int = null,

		--las sieguientes 2 variables son de identidad de quien crea el usuario
		@Usuario nvarchar(10)= null,
		@Perfil int = null
AS
BEGIN

	BEGIN TRY

			SET NOCOUNT ON;
       
			DECLARE @Fecha int;
			DECLARE @Hora nvarchar(20);			
			DECLARE @Cuenta_Estado_Actual int;
									
			SET @Fecha = convert(int,FORMAT(GetDate(), 'yyyyMMdd'));
			SET @Hora = convert(nvarchar(20), getdate(), 108); -- 114: hh:mm:ss:mmm(24h), 108: hh:mm:ss(24h)
			IF (@Usuario IS NULL)
				BEGIN
					Set @Usuario = 'No_User';
				END
			
			--------------------------------
			--->INICIA PROCESO:
			--------------------------------
		
			-->1.0 Crear usuario
			IF (@Opcion = 'InsertaUsuario')
				BEGIN

					set @Cuenta_Estado_Actual = (
						select count(a.Usuario) 
						from USUARIOS as a
						where a.Usuario = @Usuario_Red_Form
					);
			
					IF @Cuenta_Estado_Actual > 0								
						select 
							'Existe' as Estado_Superior
							,a.USUARIO as Usuario_Red
							,a.FECHA_CREACION as Fecha_Creacion
							,a.USUARIO_CREA as Usuario_Creacion
						from USUARIOS as a
						where a.Usuario = @Usuario_Red_Form					
					ELSE								
						-->1.0. Crear Usuario						
						INSERT INTO USUARIOS (USUARIO, NOMBRE, PERFIL, USUARIO_CREA, FECHA_CREACION, HORA_CREACION, USUARIO_MODIFICA, FECHA_MODIFICA,HORA_MODIFICA,ESTADO) VALUES (UPPER(@Usuario_Red_Form),@Nombre_Usuario_Form, @Perfil_Form, @Usuario, @Fecha, @Hora, @Usuario, @Fecha, @Hora,1)

						-----------------------------------------------------------------------------	
						--> Se devuelve Id del pago actualizado.
						SELECT 'Id_Pago' = @Usuario_Red_Form
						-----------------------------------------------------------------------------
					END

			--> 1.2 Modificar Usuario
			IF (@Opcion = 'ModificaUsuario')
				BEGIN
					
					UPDATE USUARIOS SET USUARIO=@Usuario_Red_Form, NOMBRE=@Nombre_Usuario_Form, PERFIL=@Perfil_Form, FECHA_MODIFICA=@Fecha, HORA_MODIFICA=@Hora, USUARIO_MODIFICA=@Usuario WHERE Id = @IdOperacion
					
					--> Se devuelve Id del pago actualizado.
					SELECT 'Id_Pago' = @Usuario_Red_Form;

				END

			--> 1.3 eliminar Usuario
			IF (@Opcion = 'EliminaUsuario')
				BEGIN
					
					DELETE FROM USUARIOS where ID = @IdOperacion
					
					--> Se devuelve Id del pago actualizado.
					SELECT 'Id_Pago' = @Usuario_Red_Form;
				END

											   
	END TRY

		BEGIN CATCH
		
			  SELECT
					'Error' AS Error
					,ERROR_NUMBER() AS ErrorNumber  
					,ERROR_SEVERITY() AS ErrorSeverity  
					,ERROR_STATE() AS ErrorState  
					,ERROR_PROCEDURE() AS ErrorProcedure  
					,ERROR_LINE() AS ErrorLine  
					,ERROR_MESSAGE() AS ErrorMessage;  
		   	
		END CATCH

 END
GO
/****** Object:  StoredProcedure [dbo].[SP_CAMBIAR_ESTADOS]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CAMBIAR_ESTADOS] -- Cambia los estados de las partidas a las cuales acaban de ser cargadas y se les acaba de enviar correo a los comerciales
		--Variables generales
		@Estado INT = NULL, --El estado que se les pondra
		@Fecha NVARCHAR(20) = NULL,
		--las sieguientes 2 variables son de identidad de quien crea el usuario
		@Usuario NVARCHAR(20)= null,
		@Perfil INT = null
AS
BEGIN
	BEGIN TRY
			SET NOCOUNT ON;
			
			DECLARE @FechaFormateada date; --Fecha actual
			DECLARE @HoraFormateada time(7); -- Hora actual
			DECLARE @Partida_Estado_Actual int;
			DECLARE @UsuarioRadicador NVARCHAR(20);
			DECLARE @IdToqueconjunto bigint;
									
			--FechaFormateada es la fecha actual en el formato que necesitamos
			SET @FechaFormateada = FORMAT(GetDate(), 'yyyyMMdd');
			SET @HoraFormateada = convert(time(7), getdate(), 108); -- 114: hh:mm:ss:mmm(24h), 108: hh:mm:ss(24h)
			IF (@Usuario IS NULL)
				BEGIN
					Set @Usuario = 'No_User';
				END

			--------------------------------
			--->INICIA PROCESO:
			--------------------------------
				-------Inserta el toque
				INSERT INTO Toques(IdOperacion, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado) VALUES('', 'Correo enviado', @FechaFormateada, @HoraFormateada, @Usuario,@Estado)
				--Busca el Id del Toque insertado
				SET @IdToqueconjunto = SCOPE_IDENTITY()

				--Actualiza los estados de la partida
				UPDATE PartidasIdentificar SET EstadoId= @Estado, IdToqueConjunto = @IdToqueconjunto  WHERE EstadoId = 1 AND FechaRadicacion = @Fecha

				SELECT 'Estado' = 'True'
	END TRY
		BEGIN CATCH
			  SELECT
					'Error' AS Error
					,ERROR_NUMBER() AS ErrorNumber  
					,ERROR_SEVERITY() AS ErrorSeverity  
					,ERROR_STATE() AS ErrorState  
					,ERROR_PROCEDURE() AS ErrorProcedure  
					,ERROR_LINE() AS ErrorLine  
					,ERROR_MESSAGE() AS ErrorMessage;  
		END CATCH
 END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_CODIGOS_TRANSACCIONES]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTA_CODIGOS_TRANSACCIONES]
AS
BEGIN
	select *
	from CodigosTransacciones
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_DETALLES_OPERACION_AXI]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTA_DETALLES_OPERACION_AXI]
	@IdOperacion bigint,
	@Opcion VARCHAR(20) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Detalle para correo a los comerciales
	IF(@Opcion = 'Correo')
		BEGIN
			select Description as Campo, value As Valor From
	(
			select Cast('--------------------------------' as nvarchar(max)) as [Datos Básicos Operación],
			Cast(Legalizacion.Id As nvarchar(max)) As [Id Operación],
			Cast(Legalizacion.NitCliente as nvarchar(max)) As [Nit Cliente],
			Cast(Legalizacion.NombreCliente as nvarchar(max)) as [Nombre Cliente],
			Cast(Legalizacion.CuentaInversion as nvarchar(max)) as [Cuenta Inversión],
			Cast(FORMAT(P.Monto, 'C', 'en-US' ) as nvarchar(max)) as [Valor Operación],
			CONVERT(nvarchar(max),P.FechaIngresoBancario,103) As [Fecha Ingreso Bancario],
			Cast(Format(cast(P.EntidadBancaria as int),'0000') + ' - ' + B.NombreBanco AS nvarchar(max)) As [Entidad Bancaria],
			Cast(P.CuentaFondo As nvarchar(max)) As [Cuenta Fondo],
			Cast(C.NombreFondo As nvarchar(max)) As [Nombre Fondo],
			Cast(E.Estado As nvarchar(max)) As [Estado Actual],
			CONVERT(nvarchar(max),P.FechaCumplimiento,103) As [Fecha Cumplimiento],
			Cast(P.Linea As nvarchar(max)) As [Linea],
			Cast(P.Detalle As nvarchar(max)) As [Detalle],
			Cast(P.Sucursal As nvarchar(max)) As [Sucursal],
			Cast(P.Referencia As nvarchar(max)) As [Referencia]
			FROM PartidasIdentificar P LEFT JOIN PartidasLegalizar Legalizacion ON P.Id = Legalizacion.IdAxi
			LEFT JOIN Estados E on P.EstadoId = E.Id
			LEFT JOIN CuentasFondos C ON P.CuentaFondo = C.CuentaFondo
			LEFT JOIN Bancos B on P.EntidadBancaria = B.Codigo
			where P.Id = @IdOperacion
	) up
	unpivot (value For Description IN(
			[Datos Básicos Operación],
			[Id Operación],
			[Nit Cliente],
			[Nombre Cliente],
			[Cuenta Inversión],
			[Valor Operación],
			[Fecha Ingreso Bancario],
			[Entidad Bancaria],
			[Cuenta Fondo],
			[Nombre Fondo],
			[Estado Actual],		
			[Fecha Cumplimiento],
			[Linea],
			[Detalle],
			[Sucursal],
			[Referencia]
		)
	)as unpvt
		END
	ELSE--Detalle que se muestra en el modulo gestion
		BEGIN
			select Description as Campo, value As Valor From
	(
			select Cast('--------------------------------' as nvarchar(max)) as [Datos Básicos Operación],
			Cast(P.Id As nvarchar(max)) As [Id Operación],
			(CASE WHEN P.NitCliente = 0 THEN null ELSE Cast(P.NitCliente as nvarchar(max))END) As [Nit Cliente],
			Cast(P.NombreCliente as nvarchar(max)) as [Nombre Cliente],
			Cast(FORMAT(P.Monto, 'C', 'en-US' ) as nvarchar(max)) as Monto,
			CONVERT(nvarchar(max),P.FechaIngresoBancario,103) As [Fecha Ingreso Bancario],
			Cast(Format(cast(P.EntidadBancaria as int),'0000') + ' - ' + B.NombreBanco AS nvarchar(max)) As [Entidad Bancaria],
			Cast(P.CuentaFondo As nvarchar(max)) As [Cuenta Fondo],
			Cast(C.NombreFondo As nvarchar(max)) As [Nombre Fondo],
			Cast(T.NombreTipo As nvarchar(max)) As [Tipo Operación],
			Cast(E.Estado As nvarchar(max)) As [Estado Actual],
			Cast(P.UsuarioRadicador As nvarchar(max)) As [Usuario Cargue],
			CONVERT(nvarchar(max),P.FechaRadicacion,103) As [Fecha Cargue],
			CONVERT(nvarchar(max), P.HoraRadicacion, 22) as [Hora Cargue],
			CONVERT(nvarchar(max),P.FechaCumplimiento,103) As [Fecha Cumplimiento],
			Cast(P.Linea As nvarchar(max)) As [Linea],
			Cast(P.Detalle As nvarchar(max)) As [Detalle],
			Cast(P.Sucursal As nvarchar(max)) As [Sucursal],
			Cast(P.Observaciones As nvarchar(max)) As [Observaciones],
			Cast(P.Referencia As nvarchar(max)) As [Referencia],
			Cast(P.ValorUnidadInicial As nvarchar(max)) As [Valor Unidad Inicial],
			Cast(P.ValorUnidadFinal As nvarchar(max)) As [Valor Unidad Final],
			Cast(FORMAT(CAST(P.Rendimientos AS DECIMAL(18, 2)), '##,###.00') As nvarchar(max)) As [Rendimientos Pagados]
			FROM PartidasIdentificar P
			LEFT JOIN Estados E on P.EstadoId = E.Id
			LEFT JOIN CuentasFondos C ON P.CuentaFondo = C.CuentaFondo
			LEFT JOIN TipoOperacion T on P.TipoOperacion = T.Id
			LEFT JOIN Bancos B on P.EntidadBancaria = B.Codigo
			where P.Id = @IdOperacion
	) up
	unpivot (value For Description IN(
			[Datos Básicos Operación],
			[Id Operación],
			[Nit Cliente],
			[Nombre Cliente],
			[Monto],
			[Fecha Ingreso Bancario],
			[Entidad Bancaria],
			[Cuenta Fondo],
			[Nombre Fondo],
			[Tipo Operación],
			[Estado Actual],
			[Usuario Cargue],
			[Fecha Cargue],
			[Hora Cargue],			
			[Fecha Cumplimiento],
			[Linea],
			[Detalle],
			[Sucursal],
			[Observaciones],
			[Referencia],
			[Valor Unidad Inicial],
			[Valor Unidad Final],
			[Rendimientos Pagados]
		)
	)as unpvt
		END
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_DETALLES_OPERACION_AXL]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTA_DETALLES_OPERACION_AXL]
	@IdOperacion bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Description AS Campo, Value AS Valor
FROM (
    SELECT
        Cast('--------------------------------' AS nvarchar(max)) AS [Datos Básicos Operación],
        Cast(P.Id AS nvarchar(max)) AS [Id Operación],
        Cast(P.NitCliente AS nvarchar(max)) AS [Nit Cliente],
        Cast(P.NombreCliente AS nvarchar(max)) AS [Nombre Cliente],
        Cast(FORMAT(P.Monto, 'C', 'en-US') AS nvarchar(max)) AS Monto,
        CONVERT(nvarchar(max), P.FechaIngresoBancario, 103) AS [Fecha Ingreso Bancario],
        Cast(Format(cast(P.EntidadBancaria as int), '0000') + ' - ' + B.NombreBanco AS nvarchar(max)) AS [Entidad Bancaria],
        Cast(P.CuentaInversion AS nvarchar(max)) AS [Cuenta Inversión],
        Cast(P.LineaNegocio AS nvarchar(max)) AS [Linea Negocio],
        CASE
            WHEN P.LineaNegocio = 'Fiduciaria Bancolombia' THEN
                CAST(CONCAT(P.Fondo, '-', CAST(F.Fondo COLLATE SQL_Latin1_General_CP1_CI_AS AS nvarchar(MAX))) AS nvarchar(MAX))
            ELSE --Cuando es Fiduciaria se tiene el codigo del fondo
                Cast(P.Fondo AS nvarchar(max))
        END AS [Nombre Fondo], --Cuando es valores se tiene el Nombre sin el codigo
        Cast(T.NombreTipo AS nvarchar(max)) AS [Tipo Operación],
        Cast(E.Estado AS nvarchar(max)) AS [Estado Actual],
        Cast(P.UsuarioRadicador AS nvarchar(max)) AS [Usuario Radicador],
        CONVERT(nvarchar(max), P.FechaRadicacion, 103) AS [Fecha Radicación],
        CONVERT(nvarchar(max), P.HoraRadicacion, 22) AS [Hora Radicación],
        CONVERT(nvarchar(max), P.FechaModificacion, 103) AS [Fecha Ultima Modificación],
        CONVERT(nvarchar(max), P.FechaCumplimiento, 103) AS [Fecha Cumplimiento]
    FROM PartidasLegalizar P
    LEFT JOIN Estados E ON P.EstadoId = E.Id
    LEFT JOIN (SELECT Fondo, Codigo FROM FONDOS_MK.gen.Fondos) F
        ON P.Fondo COLLATE SQL_Latin1_General_CP1_CI_AS = F.Codigo COLLATE SQL_Latin1_General_CP1_CI_AS
    LEFT JOIN TipoOperacion T ON P.TipoOperacion = T.Id
    LEFT JOIN Bancos B ON P.EntidadBancaria = B.Codigo
    WHERE P.Id = @IdOperacion
) up
UNPIVOT (
    Value FOR Description IN (
        [Datos Básicos Operación],
        [Id Operación],
        [Nit Cliente],
        [Nombre Cliente],
        [Monto],
        [Fecha Ingreso Bancario],
        [Entidad Bancaria],
        [Cuenta Inversión],
        [Linea Negocio],
        [Nombre Fondo],
        [Tipo Operación],
        [Estado Actual],
        [Usuario Radicador],
        [Fecha Radicación],
        [Hora Radicación],
        [Fecha Ultima Modificación],
        [Fecha Cumplimiento]
    )
) AS unpvt;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_ENTIDAD_BANCARIA]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTA_ENTIDAD_BANCARIA]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT Codigo, NombreBanco FROM Bancos
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_FECHA_MAXIMA]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CONSULTA_FECHA_MAXIMA]
	@Opcion AS VARCHAR(20) = NULL,
	@Fecha AS VARCHAR(10) = NULL
AS
BEGIN
	IF(@Opcion = 'InformeConciliacion')
		BEGIN
			SELECT FORMAT(MAX(FechaRadicacion), 'yyyyMMdd') As Fecha FROM PartidasIdentificar WHERE FORMAT(FechaRadicacion, 'yyyyMMdd') < @Fecha
		END
	ELSE
		BEGIN
			SELECT FORMAT(MAX(FechaRadicacion), 'yyyyMMdd') As Fecha FROM PartidasIdentificar WHERE FORMAT(FechaRadicacion, 'yyyyMMdd') < FORMAT(GETDATE(),'yyyyMMdd')
		END
	--IF (@Opcion = 'ReclasificacionFidu')
	--	BEGIN
	--		--Informe de reclasificacion se saca comenzando el dia, se necesita lo radicado de ayer
	--		SELECT MAX(FechaRadicacion) As Fecha FROM PartidasIdentificar WHERE FORMAT(FechaRadicacion, 'yyyyMMdd') < FORMAT(GETDATE(),'yyyyMMdd')
	--	END
	--ELSE
	--	BEGIN
	--		--Para el informe de conciliacion diario
	--		SELECT FORMAT(MAX(FechaRadicacion), 'yyyyMMdd') AS Fecha FROM PartidasIdentificar WHERE FechaRadicacion < (SELECT MAX(FechaRadicacion) FROM PartidasIdentificar)
	--	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_FLUJO_TRABAJO_OPERACION]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTA_FLUJO_TRABAJO_OPERACION] 
	@IdOperacion int,
	@Modulo VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- Insert statements for procedure here
	IF (@Modulo = 'Gestion')
		BEGIN
			(SELECT T.UsuarioToque, FORMAT(CAST(T.FechaToque AS date), N'dd/MM/yyyy') AS FechaToque, FORMAT(CAST(T.HoraToque AS datetime2), N'hh:mm:ss tt') AS HoraToque, 
			T.TipoToque, E.Estado AS EstadoOperacion
			FROM Toques T
			INNER JOIN Estados E ON T.Estado = E.Id
			WHERE T.IdOperacion = @IdOperacion OR T.IdAxL = (SELECT IdPartidaLegalizar FROM PartidasIdentificar WHERE Id = @IdOperacion))
			UNION
			(SELECT T.UsuarioToque, FORMAT(CAST(T.FechaToque AS date), N'dd/MM/yyyy') AS FechaToque, FORMAT(CAST(T.HoraToque AS datetime2), N'hh:mm:ss tt') AS HoraToque, 
			T.TipoToque, E.Estado AS EstadoOperacion
			FROM PartidasIdentificar P
			INNER JOIN Toques T ON T.IdToqueConjunto = P.IdToqueConjunto 
			INNER JOIN Estados E ON T.Estado = E.Id
			WHERE P.IdToqueConjunto = T.IdToqueConjunto AND P.Id = @IdOperacion)
			ORDER BY FechaToque ASC, HoraToque DESC
		END
	ELSE
		BEGIN
			SELECT T.UsuarioToque, FORMAT(CAST(T.FechaToque AS date), N'dd/MM/yyyy') AS FechaToque, FORMAT(CAST(T.HoraToque AS datetime2), N'hh:mm:ss tt') AS HoraToque, 
			T.TipoToque, E.Estado AS EstadoOperacion
			FROM Toques T
			INNER JOIN Estados E ON T.Estado = E.Id
			WHERE T.IdOperacion = (SELECT Id FROM PartidasIdentificar WHERE IdPartidaLegalizar = @IdOperacion) OR T.IdAxL = @IdOperacion
			ORDER BY FechaToque ASC, HoraToque DESC
		END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_INFORMES]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTA_INFORMES] 
	@Opcion int = NULL,
	@FechaConsulta AS VARCHAR(10) = NULL, --Para el detalle informe conciliacion diario
	@FechaMaxima AS VARCHAR(10) = NULL, -- Detalle informe conciliacion
	@Year INT = NULL, --Para informe mensual
	@Mes VARCHAR(2) = NULL, --Para informe mensual
	@Dia INT = NULL --Para calcular una diferencia de dias, saca error si el mes actual no tiene 31 dias, o 30, etc.
AS
BEGIN
	BEGIN TRY

		IF (@Opcion = 1)-- Opcion 1 = Detalle_AxI
		BEGIN
		--Se da formato a los campos desde la consulta sql para que cuando se exporte con alasql mantenga los formatos
			SELECT DISTINCT Axi.Id,
			UPPER(Axi.Linea) AS [Línea Negocio],
			UPPER(Bancos.NombreBanco) AS [Banco], 
			UPPER(Cuentas.NombreFondo) AS [Nombre Fondo], 
			CAST(Axi.CuentaFondo AS VARCHAR(MAX)) AS [Cuenta Bancaria],
			FORMAT (Axi.FechaIngresoBancario, 'dd MMMM yyyy', 'es-ES') AS [Fecha Efectiva], 
			FORMAT(Axi.Monto, 'C') AS [Valor Aporte], 
			REPLACE(Axi.Detalle, 'null', '') AS [Descripción Transacción],
			CASE WHEN Axi.EstadoId = 4 OR Axi.EstadoId = 8 OR Axi.EstadoId = 3 THEN 'Partida Legalizada' 
			ELSE 'Partida Sin Identificar'
			END AS Estado, 
			CASE WHEN Axi.EstadoId = 4 OR Axi.EstadoId = 8 OR Axi.EstadoId = 3 THEN CASE WHEN Legalizacion.FechaModificacion IS NOT NULL THEN FORMAT(Legalizacion.FechaModificacion, 'dd MMM yyyy') ELSE FORMAT(Axi.FechaModificacion, 'dd MMM yyyy') END ELSE '' END AS [Fecha Aprobacion], --Partidas que radican los comerciales se muestra la fecha en que se aprobo, cuando se cierra el mismo dia desde el modulo de gestion la fecha de aprobacion es igual a la fecha de radicacion
			CASE WHEN Legalizacion.NombreCliente IS NOT NULL THEN Legalizacion.NombreCliente ELSE Axi.NombreCliente END AS [Nombre Cliente], 
			Cast(Legalizacion.CuentaInversion AS NVARCHAR(max)) AS [Cuenta Inversión],
			CASE WHEN Legalizacion.Monto IS NOT NULL THEN FORMAT(Legalizacion.Monto, 'C') ELSE FORMAT(Axi.Monto, 'C') END  AS [Valor Legalizado], 
			FORMAT (Axi.FechaRadicacion, 'dd MMM yyyy') AS [Fecha], --Fecha en que se cargo a axi 
			CAST(Axi.NitCliente AS NVARCHAR(MAX)) AS [Id Pagador],
			Axi.NombreCliente AS [Nombre Pagador], 
			Axi.Referencia AS [Referencia],
			CASE WHEN Axi.Linea = 'Valores Bancolombia' THEN CAST(Legalizacion.NumeroFisico AS NVARCHAR(MAX)) ELSE CAST(Legalizacion.CuentaInversion AS NVARCHAR(MAX)) END AS [Cuenta Origen],
			(SELECT STRING_AGG(Concatenado, ';')
			FROM (
				SELECT STRING_AGG(CONCAT(FechaObservacion, ' ' , HoraObservacion , ' ' , UsuarioObservacion, ' ', Observacion), ';') AS Concatenado
				FROM Observaciones WHERE IdOperacion = Axi.Id
				UNION ALL
				SELECT STRING_AGG(CONCAT(T.UsuarioToque, ' ', FORMAT(CAST(T.FechaToque AS date), N'dd/MM/yyyy') , ' ', FORMAT(CAST(T.HoraToque AS datetime2), N'hh:mm:ss tt') , ' ', 
				T.TipoToque , ' ' , E.Estado), ';') AS Concatenado
				FROM Toques T
				INNER JOIN Estados E ON T.Estado = E.Id
				WHERE T.IdOperacion = Axi.Id OR T.IdAxL = (SELECT IdPartidaLegalizar FROM PartidasIdentificar WHERE Id = Axi.Id)
				UNION
				SELECT STRING_AGG(CONCAT(T.UsuarioToque, ' ', FORMAT(CAST(T.FechaToque AS date), N'dd/MM/yyyy'), ' ', FORMAT(CAST(T.HoraToque AS datetime2), N'hh:mm:ss tt'), ' ', 
				T.TipoToque , ' ', E.Estado), ';') AS Concatenado
				FROM PartidasIdentificar P
				INNER JOIN Toques T ON T.IdToqueConjunto = P.IdToqueConjunto
				INNER JOIN Estados E ON T.Estado = E.Id
				WHERE P.IdToqueConjunto = T.IdToqueConjunto AND P.Id = 54105 ) AS Concatenado) AS [Observaciones],
			(SELECT COUNT(IdOperacion) FROM Toques WHERE IdOperacion = Axi.Id) AS [Cantidad Gestiones Realizadas],
			CASE WHEN Axi.Autogestion = 1 THEN 'SI' ELSE CASE WHEN Axi.UsuarioRadicador = Legalizacion.UsuarioRadicador THEN 'SI' ELSE 'NO' END END AS [Autogestionado], -- Autogestionadas el mismo dia si, para el caso de que el ejecutor radique la solicitud por el modulo comercial tambien es una autogestion
			Legalizacion.UsuarioRadicador AS [Usuario Radicador],
			Axi.ValorUnidadInicial AS [Valor Unidad Inicial],
			Axi.ValorUnidadFinal AS [Valor Unidad Final],
			Axi.Rendimientos AS [Rendimientos Pagados]
			FROM PartidasIdentificar Axi LEFT JOIN PartidasLegalizar Legalizacion ON Axi.Id = Legalizacion.IdAxi
			INNER JOIN Estados ON Axi.EstadoId = Estados.Id
			LEFT JOIN CuentasFondos Cuentas ON Axi.CuentaFondo = Cuentas.CuentaFondo
			LEFT JOIN Bancos ON Axi.EntidadBancaria = Bancos.Codigo
		END
		IF (@Opcion = 2)-- Opcion 2 = Plano para la Acreditacion Cuenta Axi Y Cuenta cliente (Valores)
		BEGIN

			--NC a la cuenta de Aporte por identificar con las partidas de Valores Bancolombia que no tuvieron gestion el dia de hoy
			SELECT CAST(F.NumeroFisico AS VARCHAR(MAX)) AS Fondo, F.NitPlano AS [NitPlano], 9 AS [CodTrn], B.CodigoFormaPagoNC AS [FormaPago], CAST(CONVERT(DECIMAL(25,2), ROUND(ISNULL(Axi.Monto, 0), 2)) AS VARCHAR(MAX)) AS [ValorAporte], 
			CONVERT( varchar(10) ,GetDate(), 120) AS Fecha, '' As CodOyD, '' As NitNegDestino, '' AS CtaDestino, '' As AnombreDe, '' As TipoCtaOrigen,'' As CtaBcoOrigen,'' As CodEntidadOrigen, '' As CodEntidadCliente,'' As CtaBancariaCliente, 
			SUBSTRING(CASE WHEN B.CodigoFormaPagoNC = 890 THEN ISNULL(REPLACE(AXI.Detalle,' - ', ''), '') + ' DEL ' + CONVERT(varchar, Axi.FechaIngresoBancario, 103) + ' DE LA SUCURSAL: ' + ISNULL(AXI.Sucursal, '') + ' ' + ISNULL(S.NombreActual, '') + '-REFERENCIA: ' + ISNULL(AXI.Referencia, '') 
			ELSE ISNULL(REPLACE(AXI.Detalle,' - ', ''), '') + ' DEL ' + CONVERT(varchar, Axi.FechaIngresoBancario, 103) + ' DEL BANCO: ' + ISNULL(B.NombreBanco, '') END,1,50) AS MjsTransaccion
			FROM PartidasIdentificar Axi LEFT JOIN Bancos B ON Axi.EntidadBancaria = B.Codigo
			INNER JOIN CuentasFondos Cuentas ON Axi.CuentaFondo = Cuentas.CuentaFondo
			LEFT JOIN FisicosFondo F ON Cuentas.NombreFondo = UPPER(F.NombreFondo)
			LEFT JOIN Sucursales S ON AXI.Sucursal = S.CodigoSucursal
			WHERE (F.LineaNegocio = 'Valores Bancolombia') AND (Axi.EstadoId = 2 OR Axi.EstadoId = 1 OR Axi.EstadoId = 11 OR Axi.EstadoId = 7 OR Axi.EstadoId = 12) --Agreso el estado suspendido aunque de hoy no deberia haber, suspendido es cuando pasa un tiempo y no se identifica 
			AND FORMAT(Axi.FechaRadicacion, 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd') AND F.NumeroFisico = 
			CASE 
				WHEN F.NombreFondo = 'Renta Liquidez' AND CONVERT(INT, CONVERT(VARCHAR(8), Axi.FechaIngresoBancario, 112)) >= 20211104 THEN '0021009108140288'
				WHEN F.NombreFondo = 'Renta Liquidez' AND CONVERT(INT, CONVERT(VARCHAR(8), Axi.FechaIngresoBancario, 112)) < 20211104 THEN '021009104911909'
				ELSE F.NumeroFisico
			END
			UNION ALL										--Y partidas que tengan se hayan legalizado hoy
			--Partidas que habian ingresado a la cuenta de aportes y se legalizaron, por lo que hay que hacer la ND de la cuenta de Aportes y la NC a la cuenta del cliente
			--ND A LA CUENTA DE APORTES POR IDENTIFICAR
			SELECT CAST(F.NumeroFisico AS VARCHAR(MAX)) AS Fondo, F.NitPlano AS [NitPlano], 10 AS [CodTrn], B.CodigoFormaPagoND AS [FormaPago], CAST(CONVERT(DECIMAL(25,2), ROUND(ISNULL(Axi.Monto, 0), 2)) AS VARCHAR(MAX)) AS [ValorAporte], 
			CONVERT( varchar(10) ,GetDate(), 120) AS Fecha, '' As CodOyD, '' As NitNegDestino, '' AS CtaDestino, '' As AnombreDe, '' As TipoCtaOrigen,'' As CtaBcoOrigen,'' As CodEntidadOrigen, '' As CodEntidadCliente,'' As CtaBancariaCliente, 
			SUBSTRING(CASE WHEN B.CodigoFormaPagoND = 179 THEN ISNULL(AXI.Detalle, '') + ' DEL ' + CONVERT(varchar, Axi.FechaIngresoBancario, 103) + ' DE LA SUCURSAL: ' + ISNULL(AXI.Sucursal, '') + ' ' + ISNULL(S.NombreActual, '') + '-REFERENCIA: ' + ISNULL(AXI.Referencia, '') 
			ELSE ISNULL(REPLACE(AXI.Detalle,' - ', ''), '') + ' DEL ' + CONVERT(varchar, Axi.FechaIngresoBancario, 103) + ' DEL BANCO: ' + ISNULL(B.NombreBanco, '') END,1,50) AS MjsTransaccion
			FROM PartidasLegalizar A 
			INNER JOIN PartidasIdentificar Axi ON A.IdAxi = Axi.Id 
			LEFT JOIN Bancos B ON A.EntidadBancaria = B.Codigo
			INNER JOIN CuentasFondos Cuentas ON Axi.CuentaFondo = Cuentas.CuentaFondo
			LEFT JOIN FisicosFondo F ON Cuentas.NombreFondo = UPPER(F.NombreFondo)
			LEFT JOIN Sucursales S ON AXI.Sucursal = S.CodigoSucursal
			WHERE (F.LineaNegocio = 'Valores Bancolombia') AND (Axi.EstadoId = 3 OR Axi.EstadoId = 8 OR Axi.EstadoId = 4) 
			AND FORMAT(A.FechaModificacion, 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd') AND Axi.IngresaCuentaAportes = 1 AND F.NumeroFisico = 
			CASE 
				WHEN F.NombreFondo = 'Renta Liquidez' AND CONVERT(INT, CONVERT(VARCHAR(8), Axi.FechaIngresoBancario, 112)) >= 20211104 THEN '0021009108140288'
				WHEN F.NombreFondo = 'Renta Liquidez' AND CONVERT(INT, CONVERT(VARCHAR(8), Axi.FechaIngresoBancario, 112)) < 20211104 THEN '021009104911909'
				ELSE F.NumeroFisico
			END
			UNION ALL
			--NC A LA CUENTA DEL CLIENTE
			SELECT CAST(A.NumeroFisico AS VARCHAR(MAX)) AS Fondo, A.NitFondo AS [NitPlano], 9 AS [CodTrn], CASE WHEN B.CodigoFormaPagoNC = 890 THEN 178 ELSE B.CodigoFormaPagoNC END AS [FormaPago], CAST(CONVERT(DECIMAL(25,2), ROUND(ISNULL(A.Monto, 0), 2)) AS VARCHAR(MAX)) AS [ValorAporte], 
			CONVERT( varchar(10) ,GetDate(), 120) AS Fecha, '' As CodOyD, '' As NitNegDestino, '' AS CtaDestino, '' As AnombreDe, '' As TipoCtaOrigen,'' As CtaBcoOrigen,'' As CodEntidadOrigen, '' As CodEntidadCliente,'' As CtaBancariaCliente, 
			SUBSTRING(CASE WHEN B.CodigoFormaPagoNC = 890 THEN ISNULL(REPLACE(AXI.Detalle,' - ', ''), '') + ' DEL ' + CONVERT(varchar, A.FechaIngresoBancario, 103) + ' DE LA SUCURSAL: ' + ISNULL(Axi.Sucursal, '') + ' ' + ISNULL(S.NombreActual, '') + '-REFERENCIA: ' + ISNULL(Axi.Referencia, '') 
			ELSE ISNULL(REPLACE(AXI.Detalle,' - ', ''), '') + ' DEL ' + CONVERT(varchar, A.FechaIngresoBancario, 103) + ' DEL BANCO: ' + ISNULL(B.NombreBanco, '') END,1,50) AS MjsTransaccion
			FROM PartidasLegalizar A 
			INNER JOIN PartidasIdentificar Axi ON A.IdAxi = Axi.Id 
			INNER JOIN Bancos B ON A.EntidadBancaria = B.Codigo
			LEFT JOIN Sucursales S ON Axi.Sucursal = S.CodigoSucursal
			WHERE FORMAT(A.FechaModificacion, 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd') AND (A.EstadoId = 3 OR A.EstadoId = 8 OR A.EstadoId = 4) 
			AND Axi.IngresaCuentaAportes = 1 AND A.LineaNegocio = 'Valores Bancolombia'
			UNION ALL										--Y partidas que tengan se hayan legalizado hoy
			--PArtidas que ingresaron a Aportes por identificar y se necesitan sacar sin hacerle la adicion al cliente
			--ND A LA CUENTA DE APORTES POR IDENTIFICAR
			SELECT CAST(F.NumeroFisico AS VARCHAR(MAX)) AS Fondo, F.NitPlano AS [NitPlano], 10 AS [CodTrn], CASE WHEN B.CodigoFormaPagoND = 179 THEN 169 ELSE B.CodigoFormaPagoND END AS [FormaPago], CAST(CONVERT(DECIMAL(25,2), ROUND(ISNULL(Axi.Monto, 0), 2)) AS VARCHAR(MAX)) AS [ValorAporte], 
			CONVERT( varchar(10) ,GetDate(), 120) AS Fecha, '' As CodOyD, '' As NitNegDestino, '' AS CtaDestino, '' As AnombreDe, '' As TipoCtaOrigen,'' As CtaBcoOrigen,'' As CodEntidadOrigen, '' As CodEntidadCliente,'' As CtaBancariaCliente, 
			SUBSTRING(CASE WHEN B.CodigoFormaPagoND = 179 THEN ISNULL(AXI.Detalle, '') + ' DEL ' + CONVERT(varchar, Axi.FechaIngresoBancario, 103) + ' DE LA SUCURSAL: ' + ISNULL(AXI.Sucursal, '') + ' ' + ISNULL(S.NombreActual, '') + '-REFERENCIA: ' + ISNULL(AXI.Referencia, '') 
			ELSE ISNULL(REPLACE(AXI.Detalle,' - ', ''), '') + ' DEL ' + CONVERT(varchar, Axi.FechaIngresoBancario, 103) + ' DEL BANCO: ' + ISNULL(B.NombreBanco, '') END,1,50) AS MjsTransaccion
			FROM PartidasIdentificar Axi 
			LEFT JOIN Bancos B ON Axi.EntidadBancaria = B.Codigo
			INNER JOIN CuentasFondos Cuentas ON Axi.CuentaFondo = Cuentas.CuentaFondo
			LEFT JOIN FisicosFondo F ON Cuentas.NombreFondo = UPPER(F.NombreFondo)
			LEFT JOIN Sucursales S ON AXI.Sucursal = S.CodigoSucursal
			WHERE (F.LineaNegocio = 'Valores Bancolombia') AND FORMAT(Axi.FechaModificacion, 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd') AND (Axi.EstadoId = 3 OR Axi.EstadoId = 8) 
			AND Axi.IngresaCuentaAportes = 1 AND Axi.IdPartidaLegalizar is null AND F.NumeroFisico = 
			CASE 
				WHEN F.NombreFondo = 'Renta Liquidez' AND CONVERT(INT, CONVERT(VARCHAR(8), Axi.FechaIngresoBancario, 112)) >= 20211104 THEN '0021009108140288'
				WHEN F.NombreFondo = 'Renta Liquidez' AND CONVERT(INT, CONVERT(VARCHAR(8), Axi.FechaIngresoBancario, 112)) < 20211104 THEN '021009104911909'
				ELSE F.NumeroFisico
			END
			UNION ALL --Partidas pendientes de aprobacion o liquidacion en el modulo de los comerciales, estan sueltas en este modulo, no estan en el modulo de gestion, estas partidas hay que hacerle NC al cliente 
			SELECT CAST(A.NumeroFisico AS VARCHAR(MAX)) AS Fondo, A.NitFondo AS [NitPlano], 9 AS [CodTrn], CASE WHEN B.CodigoFormaPagoNC = 890 THEN 178 ELSE B.CodigoFormaPagoNC END AS [FormaPago], CAST(CONVERT(DECIMAL(25,2), ROUND(ISNULL(A.Monto, 0), 2)) AS VARCHAR(MAX)) AS [ValorAporte], 
			CONVERT( varchar(10) ,GetDate(), 120) AS Fecha, '' As CodOyD, '' As NitNegDestino, '' AS CtaDestino, '' As AnombreDe, '' As TipoCtaOrigen,'' As CtaBcoOrigen,'' As CodEntidadOrigen, '' As CodEntidadCliente,'' As CtaBancariaCliente, 
			SUBSTRING(CASE WHEN B.CodigoFormaPagoNC = 890 THEN ISNULL(REPLACE(A.NombreCliente,' - ', ''), '') + ' DEL ' + CONVERT(varchar, A.FechaIngresoBancario, 103) + '-REFERENCIA: ' + ISNULL(CONVERT(VARCHAR(20),A.NitCliente), '') 
			ELSE ISNULL(REPLACE(A.NombreCliente,' - ', ''), '') + ' DEL ' + CONVERT(varchar, A.FechaIngresoBancario, 103) + ' DEL BANCO: ' + ISNULL(B.NombreBanco, '') END,1,50) AS MjsTransaccion
			FROM PartidasLegalizar A 
			INNER JOIN Bancos B ON A.EntidadBancaria = B.Codigo
			WHERE FORMAT(A.FechaModificacion, 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd') AND (A.EstadoId = 3 OR A.EstadoId = 8) 
			AND A.IdAxi = 0 AND A.LineaNegocio = 'Valores Bancolombia'

			--Actualizacion de registros, se actualiza variable de control
			--Se marcan las partidas que no tuvieron gestion el dia de hoy por lo tanto ingresaron a la cuenta de aportes por identificar
			UPDATE PartidasIdentificar 
			SET  IngresaCuentaAportes = 1 
			WHERE Linea = 'Valores Bancolombia' AND FORMAT(FechaRadicacion, 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd') 
			AND (EstadoId = 2 OR EstadoId = 1 OR EstadoId = 11 OR EstadoId = 7 OR EstadoId = 12) AND IngresaCuentaAportes IS NULL
		END

		IF (@Opcion = 3)-- Opcion 3 = Ajustes - Fiduciaria
		--Se exportan los aportes por identificar que estan pendientes de realizar ajuste(Retiro o constitucion) Y solo de F01, los datos de este query se pegan en la macro de ajustes
		--Solo se exporta lo de hoy, lo radicado de hoy que tubo gestion y lo que se subio al modulo de aportes que no tubo gestion
		BEGIN
			--Incrementos
			(SELECT SUBSTRING(P.CuentaInversion,1,4) AS Oficina, SUBSTRING(P.CuentaInversion,5,LEN(P.CuentaInversion)-3) AS Cuenta, P.Monto, FORMAT(P.FechaIngresoBancario, 'yyyyMMdd') AS Fecha, 
			'ANR' AS Concepto, 1 AS [Tipo Ajuste], 'C' AS [Tipo Cta], '' AS [Cuenta Banco], CONCAT(P.EntidadBancaria,'|',B.NombreBanco) AS Banco, P.NitCliente AS Nit
			FROM PartidasLegalizar P
			LEFT JOIN Bancos B ON RIGHT('0000'+CAST(B.Codigo AS VARCHAR(4)),4)= P.EntidadBancaria
			INNER JOIN PartidasIdentificar ON P.Id = PartidasIdentificar.IdPartidaLegalizar
			WHERE P.LineaNegocio = 'Fiduciaria Bancolombia' AND P.Fondo = 'F01' AND P.TipoOperacion = 1 
			AND FORMAT(P.FechaModificacion, 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd') AND (P.EstadoId = 3 OR P.EstadoId = 8 OR P.EstadoId = 4) AND PartidasIdentificar.IngresaCuentaAportes IS NULL --Partidas de hoy que esten pendientes de aprobacion o liquidacion
			UNION ALL																																								--Y partidas que tengan fecha de cumplimiento hoy que no hayan ingresado a aportes por identificar
			--Constituciones - En la constitucion se exporta el tipo de documento y no se tiene cta de inversion
			SELECT '' AS Oficina, '' AS Cuenta, P.Monto, FORMAT(P.FechaIngresoBancario, 'yyyyMMdd') AS Fecha, 'CNR' AS Concepto, 4 AS [Tipo Ajuste], P.CodTipoIdTitular AS [Tipo Cta], '' AS [Cuenta Banco], 
			CONCAT(P.EntidadBancaria,'|',B.NombreBanco) AS Banco, P.NitCliente AS Nit
			FROM PartidasLegalizar P
			LEFT JOIN Bancos B ON RIGHT('0000'+CAST(B.Codigo AS VARCHAR(4)),4)= P.EntidadBancaria
			INNER JOIN PartidasIdentificar ON P.Id = PartidasIdentificar.IdPartidaLegalizar
			WHERE P.LineaNegocio = 'Fiduciaria Bancolombia' AND P.Fondo = 'F01' AND P.TipoOperacion = 2 
			AND FORMAT(P.FechaModificacion, 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd') AND (P.EstadoId = 3 OR P.EstadoId = 8 OR P.EstadoId = 4) AND PartidasIdentificar.IngresaCuentaAportes IS NULL--Partidas de hoy que ya esten pendientes de aprobacion o liquidacion
			--Los registros que quedaron sin gestion en aportes por identificar, el dinero debe ir el dinero a la cuenta de aportes por identificar, estas partidas son marcadas,
			--Ya que en un futuro cuando se ingrese el soporte, este query debe exportar un retiro desde la cuenta de aportes por identificar y tambien debe exportar una adicion a la cuenta del cliente
			UNION ALL
			SELECT '8888' AS Oficina, '1200' AS Cuenta, P.Monto, FORMAT(P.FechaIngresoBancario, 'yyyyMMdd') AS Fecha, 'ANR' AS Concepto, 1 AS [Tipo Ajuste], 
			'C' AS [Tipo Cta], '' AS [Cuenta Banco], CONCAT(P.EntidadBancaria,'|',B.NombreBanco) AS Banco, '' AS Nit --No se trae nit en este caso
			FROM PartidasIdentificar P 
			LEFT JOIN CuentasFondos C ON P.CuentaFondo = C.CuentaFondo
			INNER JOIN Bancos B ON RIGHT('0000'+CAST(b.Codigo AS VARCHAR(4)),4)= P.EntidadBancaria
			WHERE P.Linea = 'Fiduciaria Bancolombia' AND C.NombreFondo = 'FIDUCUENTA' 
			AND FORMAT(P.FechaRadicacion, 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd') AND (P.EstadoId = 2 OR P.EstadoId = 1 OR P.EstadoId = 11 OR P.EstadoId = 7 OR P.EstadoId = 12 )--Partidas de hoy que no tengan gestion (Pendientes soporte, pendientes revisar soporte, devueltas o pendientes)
			UNION ALL --AGREGADO 20230613, PARTIDAS QUE SOLO SE DEBEN SACAR DE LA CUENTA DE APORTES POR IDENTIFICAR, SIN HACER EL CREDITO AL CLIENTE
			SELECT '8888' AS Oficina, '1200' AS Cuenta, P.Monto, FORMAT(P.FechaIngresoBancario, 'yyyyMMdd') AS Fecha, 'AAD' AS Concepto, 2 AS [Tipo Ajuste], 'C' AS [Tipo Cta], '' AS [Cuenta Banco], 
			CONCAT(P.EntidadBancaria,'|',B.NombreBanco) AS Banco, '' AS Nit
			FROM PartidasIdentificar P
			LEFT JOIN Bancos B ON RIGHT('0000'+CAST(B.Codigo AS VARCHAR(4)),4)= P.EntidadBancaria
			INNER JOIN CuentasFondos Cuentas ON P.CuentaFondo = Cuentas.CuentaFondo
			WHERE P.Linea = 'Fiduciaria Bancolombia' AND Cuentas.NombreFondo = 'Fiducuenta' AND FORMAT(P.FechaModificacion, 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd')  AND (P.EstadoId = 3 OR P.EstadoId = 8) AND P.IngresaCuentaAportes = 1 AND P.IdPartidaLegalizar is null --Indica que no ha cruzado con una partida de comercial pero se paso a pendiente de aprobacion
			UNION ALL
			--Partidas que habia entrado en la cuenta de aportes por identificar, por lo que hay que hacer los 2 registros mensionados anteriormente, retiro de la cuenta de aportes y adicion a la cuenta del cliente
			--QUERY RETIRO CUENTA APORTES
			SELECT '8888' AS Oficina, '1200' AS Cuenta, P.Monto, FORMAT(P.FechaIngresoBancario, 'yyyyMMdd') AS Fecha, 'AAD' AS Concepto, 2 AS [Tipo Ajuste], 'C' AS [Tipo Cta], '' AS [Cuenta Banco], 
			CONCAT(P.EntidadBancaria,'|',B.NombreBanco) AS Banco, '' AS Nit
			FROM PartidasLegalizar P
			LEFT JOIN Bancos B ON RIGHT('0000'+CAST(B.Codigo AS VARCHAR(4)),4)= P.EntidadBancaria
			INNER JOIN PartidasIdentificar ON P.Id = PartidasIdentificar.IdPartidaLegalizar
			WHERE P.LineaNegocio = 'Fiduciaria Bancolombia' AND P.Fondo = 'F01'
			AND FORMAT(P.FechaModificacion, 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd') AND (P.EstadoId = 3 OR P.EstadoId = 8) AND PartidasIdentificar.IngresaCuentaAportes = 1
			UNION ALL
			--QUERY ADICION O CONSTITUCION AL CLIENTE
			SELECT 
			CASE WHEN P.TipoOperacion = 2 THEN '' ELSE SUBSTRING(P.CuentaInversion,1,4) END AS Oficina, 
			CASE WHEN P.TipoOperacion = 2 THEN '' ELSE SUBSTRING(P.CuentaInversion,5,LEN(P.CuentaInversion)-3) END AS Cuenta, P.Monto, FORMAT(P.FechaIngresoBancario, 'yyyyMMdd') AS Fecha, 
			CASE WHEN P.TipoOperacion = 2 THEN 'CNR' ELSE 'ANR' END AS Concepto, 
			CASE WHEN P.TipoOperacion = 2 THEN 4 ELSE 1 END AS [Tipo Ajuste], 
			CASE WHEN P.TipoOperacion = 2 THEN P.CodTipoIdTitular ELSE 'C' END AS [Tipo Cta], '' AS [Cuenta Banco], CONCAT(P.EntidadBancaria,'|',B.NombreBanco) AS Banco, P.NitCliente AS Nit
			FROM PartidasLegalizar P
			LEFT JOIN Bancos B ON RIGHT('0000'+CAST(B.Codigo AS VARCHAR(4)),4)= P.EntidadBancaria
			INNER JOIN PartidasIdentificar ON P.Id = PartidasIdentificar.IdPartidaLegalizar
			WHERE P.LineaNegocio = 'Fiduciaria Bancolombia' AND P.Fondo = 'F01'
			AND FORMAT(P.FechaModificacion, 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd') AND (P.EstadoId = 3 OR P.EstadoId = 8) AND PartidasIdentificar.IngresaCuentaAportes = 1
			UNION ALL --ADICION O CONSTITUCION PARA PARTIDAS QUE SE PUSIERON EN PTE APROBACION O LIQUIDACION EN EL MODULO COMERCIAL Y NO ESTAN RELACIONADAS CON AXI
			SELECT 
			CASE WHEN P.TipoOperacion = 2 THEN '' ELSE SUBSTRING(P.CuentaInversion,1,4) END AS Oficina, 
			CASE WHEN P.TipoOperacion = 2 THEN '' ELSE SUBSTRING(P.CuentaInversion,5,LEN(P.CuentaInversion)-3) END AS Cuenta, P.Monto, FORMAT(P.FechaIngresoBancario, 'yyyyMMdd') AS Fecha, 
			CASE WHEN P.TipoOperacion = 2 THEN 'CNR' ELSE 'ANR' END AS Concepto, 
			CASE WHEN P.TipoOperacion = 2 THEN 4 ELSE 1 END AS [Tipo Ajuste], 
			CASE WHEN P.TipoOperacion = 2 THEN P.CodTipoIdTitular ELSE 'C' END AS [Tipo Cta], '' AS [Cuenta Banco], CONCAT(P.EntidadBancaria,'|',B.NombreBanco) AS Banco, P.NitCliente AS Nit
			FROM PartidasLegalizar P
			LEFT JOIN Bancos B ON RIGHT('0000'+CAST(B.Codigo AS VARCHAR(4)),4)= P.EntidadBancaria
			WHERE P.LineaNegocio = 'Fiduciaria Bancolombia' AND P.Fondo = 'F01'
			AND FORMAT(P.FechaModificacion, 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd') AND (P.EstadoId = 3 OR P.EstadoId = 8) AND P.IdAxi = 0)
			ORDER BY [Tipo Ajuste] ASC

			--Actualizacion de registros, se actualiza variable de control
			--Se marcan las partidas que no tuvieron gestion el dia de hoy por lo tanto ingresaron a la cuenta de aportes por identificar
			UPDATE PartidasIdentificar 
			SET  IngresaCuentaAportes = 1 
			FROM PartidasIdentificar P 
			WHERE P.Linea = 'Fiduciaria Bancolombia' AND FORMAT(P.FechaRadicacion, 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd') 
			AND (P.EstadoId = 2 OR P.EstadoId = 1 OR P.EstadoId = 11 OR P.EstadoId = 7 OR P.EstadoId = 12) AND IngresaCuentaAportes IS NULL

		END

		IF (@Opcion = 4)-- Opcion 4 = Informe Mensual
		BEGIN
			SELECT DISTINCT ResultadoFinal.Id, ResultadoFinal.LineaNegocio, ResultadoFinal.Nombre_Fondo, 
				ResultadoFinal.Banco, ResultadoFinal.CuentaFondo, ResultadoFinal.Fecha_Efectiva, ResultadoFinal.Valor_Aporte, ResultadoFinal.Detalle, ResultadoFinal.Fecha_Aprobacion, ResultadoFinal.Dias_Dif,
				CASE
					WHEN Dias_Dif <= 30 THEN '1. Hasta 30 días'
					WHEN Dias_Dif > 30 AND Dias_Dif < 60 THEN '2. De 31 y 59 días'
					WHEN Dias_Dif >= 60 AND Dias_Dif < 90 THEN '3. De 60 a 89 días'
					WHEN Dias_Dif >= 90 AND Dias_Dif < 180 THEN '4. De 90 a 179 días'
					WHEN Dias_Dif >= 180 AND Dias_Dif < 360 THEN '5. De 180 a 359 días'
					WHEN Dias_Dif >= 360 THEN '6. Más de 360 días'
				END AS Rango, ResultadoFinal.Estado_Final, ResultadoFinal.año_mes 
				 FROM (
					SELECT DISTINCT Id, LineaNegocio, Nombre_Fondo, Banco, CuentaFondo, Fecha_Efectiva, Valor_Aporte, Detalle, Fecha_Aprobacion,
					CASE
						WHEN Estado_Final = 'Sin Identificar'
							THEN DATEDIFF(DAY, CONVERT(DATE, Resultado.FechaIngresoBancario, 112), DATEFROMPARTS(@Year, @Mes, @Dia))
						WHEN Fecha_Aprobacion != ''
							THEN DATEDIFF(DAY, CONVERT(DATE, Resultado.FechaIngresoBancario, 112), DATEFROMPARTS(SUBSTRING(Resultado.FechaModificacion, 1, 4), SUBSTRING(Resultado.FechaModificacion, 5, 2), SUBSTRING(Resultado.FechaModificacion, 7, 2)))
						ELSE 1
					END AS Dias_Dif, Estado_Final, año_mes 
					FROM ( 
						SELECT DISTINCT AxI.Id, CuentasFondos.LineaNegocio, CuentasFondos.NombreFondo AS Nombre_Fondo, Axi.FechaIngresoBancario, FORMAT(Legalizacion.FechaModificacion, 'yyyyMMdd') AS FechaModificacion,
						CuentasFondos.Banco, AxI.CuentaFondo, FORMAT(AxI.FechaIngresoBancario, 'yyyyMMdd') AS Fecha_Efectiva, AxI.Monto AS Valor_Aporte, AxI.Detalle, 
						CASE
							WHEN (Legalizacion.EstadoId = 3 OR Legalizacion.EstadoId = 8 OR Legalizacion.EstadoId = 4)
								THEN FORMAT(Legalizacion.FechaModificacion, 'yyyyMMdd')
							ELSE ''
						END AS Fecha_Aprobacion,
						Iif(Axi.EstadoId = 3 OR Axi.EstadoId = 8 OR Axi.EstadoId = 4, 
						 Iif(Legalizacion.FechaModificacion != '', 
						 Iif(SUBSTRING(FORMAT(Legalizacion.FechaModificacion, 'yyyyMMdd'), 5, 2) = @Mes, 
						 Iif(SUBSTRING(FORMAT(AxI.FechaIngresoBancario, 'yyyyMMdd'), 5, 2) = @Mes AND SUBSTRING(FORMAT(AxI.FechaIngresoBancario, 'yyyyMMdd'), 1, 4) = @Year,'Legalizado el Mismo Mes','Legalizado de Meses Anteriores'),'Legalizadas otros meses'), 
						 Iif(SUBSTRING(FORMAT(AxI.FechaIngresoBancario, 'yyyyMMdd'), 5, 2) = @Mes AND SUBSTRING(FORMAT(AxI.FechaIngresoBancario, 'yyyyMMdd'), 1, 4) = @Year,'Legalizado el Mismo Mes','Legalizadas otros meses')) ,'Sin Identificar') AS Estado_Final, 
						 Iif(SUBSTRING(FORMAT(AxI.FechaIngresoBancario, 'yyyyMMdd'),1,6) < CONCAT(@Year,@Mes),'Otros Meses','Mes Vigente') as año_mes FROM CuentasFondos 
						 INNER JOIN (PartidasIdentificar Axi LEFT JOIN PartidasLegalizar Legalizacion ON Axi.Id = Legalizacion.IdAxi) ON CuentasFondos.CuentaFondo = Axi.CuentaFondo
						 WHERE Axi.EstadoId != 5 AND Axi.EstadoId != 6) AS Resultado) AS ResultadoFinal
		END

		IF(@Opcion = 5)--Detalle para el infrome diario de conciliacion
		BEGIN

			 SELECT LineaNegocio,
				   NombreFondo,
				   CodigoFondo,
				   SUM(SALDO_INICIAL) AS SaldoAxi,
				   SUM(No_Partidas_INICIAL) AS PendientesAxi,
				   SUM(REND_ACUMULADOS) AS RendimientosAcumulados,
				   SUM(ABONO_AxI) AS Abonos,
				   SUM(No_Partidas_ABONO_AxI) AS CantAbono,
				   SUM(DEVOLUCION_AxI) AS Devoluciones,
				   SUM(No_Partidas_DEVOLUCION_AxI) AS CantDevoluciones
			FROM (
				SELECT TablaResultado.LineaNegocio,
					   TablaResultado.NombreFondo,
					   TablaResultado.CodigoFondo,
					   IIF(Tipo2 = 'SALDO INICIAL CUENTA AxI', SUM(Monto), 0) AS SALDO_INICIAL,
					   IIF(Tipo2 = 'SALDO INICIAL CUENTA AxI', COUNT(Monto), 0) AS No_Partidas_INICIAL,
					   0 AS REND_ACUMULADOS,
					   IIF(Tipo2 = 'INGRESO AxI', SUM(Monto), 0) AS ABONO_AxI,
					   IIF(Tipo2 = 'INGRESO AxI', COUNT(Monto), 0) AS No_Partidas_ABONO_AxI,
					   IIF(Tipo2 = 'EGRESO AxI', SUM(Monto), 0) AS DEVOLUCION_AxI,
					   IIF(Tipo2 = 'EGRESO AxI', COUNT(Monto), 0) AS No_Partidas_DEVOLUCION_AxI
				FROM (
					--Axi Pendientes
					SELECT AxI.Id as Id,@FechaMaxima as fecha2, @FechaConsulta as fecha1, Axi.Linea AS LineaNegocio, 
					CASE 
						WHEN CuentasFondos.NombreFondo = 'Renta Liquidez' THEN 
							CASE 
								WHEN CAST(FORMAT(Axi.FechaIngresoBancario, 'yyyyMMdd') AS INT) > 20211104 THEN 'Renta Liquidez 2' 
								ELSE 'Renta Liquidez' 
							END  
						ELSE CuentasFondos.NombreFondo 
					END AS NombreFondo, CuentasFondos.Codigo AS CodigoFondo,
					AxI.Monto, 'PENDIENTES AxI' as Tipo, 'SALDO INICIAL CUENTA AxI' as Tipo2 FROM CuentasFondos INNER JOIN PartidasIdentificar Axi
					ON CuentasFondos.CuentaFondo = AxI.CuentaFondo WHERE (Axi.EstadoId = 1 OR Axi.EstadoId = 10 OR Axi.EstadoId = 3 OR Axi.EstadoId = 7 OR Axi.EstadoId = 2 OR Axi.EstadoId = 11 OR Axi.EstadoId = 8 OR Axi.EstadoId = 12) AND FORMAT(Axi.FechaRadicacion, 'yyyyMMdd') < @FechaConsulta and Axi.IngresaCuentaAportes = 1
					GROUP BY AxI.Id, AxI.FechaIngresoBancario, Axi.Linea, CuentasFondos.NombreFondo, CuentasFondos.Codigo, AxI.Monto 
					--
					UNION ALL
					--AxI que Ingresan
					SELECT AxI.Id, IIF(CuentasFondos.LineaNegocio = 'Fiduciaria Bancolombia', FORMAT(Axi.FechaIngresoBancario, 'yyyyMMdd'),
					FORMAT(Axi.FechaRadicacion, 'yyyyMMdd')) as fecha2, @FechaConsulta as fecha1, CuentasFondos.LineaNegocio, 
					CASE 
						WHEN CuentasFondos.NombreFondo = 'Renta Liquidez' THEN 
							CASE 
								WHEN CAST(FORMAT(Axi.FechaIngresoBancario, 'yyyyMMdd') AS INT) > 20211104 THEN 'Renta Liquidez 2' 
								ELSE 'Renta Liquidez' 
							END  
						ELSE CuentasFondos.NombreFondo 
					END AS NombreFondo, CuentasFondos.Codigo AS CodigoFondo,
					AxI.Monto, 'APORTE POR IDENTIFICAR' as Tipo, 
					'INGRESO AxI' as Tipo2 FROM (CuentasFondos LEFT JOIN FisicosFondo ON CuentasFondos.NombreFondo = FisicosFondo.NombreFondo) 
					INNER JOIN PartidasIdentificar Axi ON CuentasFondos.CuentaFondo = AxI.CuentaFondo  
					WHERE (Axi.EstadoId != 4 AND Axi.EstadoId != 5 AND Axi.EstadoId != 8 AND Axi.EstadoId != 3 ) AND  FORMAT(Axi.FechaRadicacion, 'yyyyMMdd') = @FechaConsulta  AND Axi.IngresaCuentaAportes = 1         
					GROUP BY AxI.Id,AxI.FechaIngresoBancario,Axi.FechaRadicacion,CuentasFondos.LineaNegocio, CuentasFondos.NombreFondo, CuentasFondos.Codigo, AxI.Monto 
					UNION ALL
					--'AxI Legalizados
					SELECT AxI.Id, IIF(CuentasFondos.LineaNegocio = 'Fiduciaria Bancolombia', FORMAT(Axi.FechaIngresoBancario, 'yyyyMMdd'), FORMAT(Axi.FechaRadicacion, 'yyyyMMdd'))  as fecha2, @FechaConsulta as fecha1, CuentasFondos.LineaNegocio, 
					CASE 
						WHEN CuentasFondos.NombreFondo = 'Renta Liquidez' THEN 
							CASE 
								WHEN CAST(FORMAT(Axi.FechaIngresoBancario, 'yyyyMMdd') AS INT) > 20211104 THEN 'Renta Liquidez 2' 
								ELSE 'Renta Liquidez' 
							END  
						ELSE CuentasFondos.NombreFondo
					END AS NombreFondo, CuentasFondos.Codigo AS CodigoFondo, Axi.Monto, 'LEGALIZACION DE APORTE' as Tipo, 'EGRESO AxI' as Tipo2 
					FROM (CuentasFondos LEFT JOIN FisicosFondo ON CuentasFondos.NombreFondo = FisicosFondo.NombreFondo) INNER JOIN (PartidasIdentificar Axi INNER JOIN PartidasLegalizar Legalizacion 
					ON Axi.Id = Legalizacion.IdAxi) ON CuentasFondos.CuentaFondo = AxI.CuentaFondo  
					WHERE ((Legalizacion.EstadoId = 3 OR Legalizacion.EstadoId = 8 OR Legalizacion.EstadoId = 4) AND FORMAT(Axi.FechaRadicacion, 'yyyyMMdd') <= @FechaMaxima AND 
					FORMAT(Legalizacion.FechaModificacion, 'yyyyMMdd') = @FechaConsulta)
					GROUP BY AxI.Id,CuentasFondos.LineaNegocio, CuentasFondos.NombreFondo, CuentasFondos.Codigo, AxI.Monto, AxI.FechaIngresoBancario, Axi.FechaRadicacion
					UNION ALL
					--'AxI Legalizados (Poniendolos pendientes de aprobaccion desde el modulo de gestion)
					SELECT AxI.Id, IIF(CuentasFondos.LineaNegocio = 'Fiduciaria Bancolombia', FORMAT(Axi.FechaIngresoBancario, 'yyyyMMdd'), FORMAT(Axi.FechaRadicacion, 'yyyyMMdd'))  as fecha2, @FechaConsulta as fecha1, CuentasFondos.LineaNegocio, 
					CASE 
						WHEN CuentasFondos.NombreFondo = 'Renta Liquidez' THEN 
							CASE 
								WHEN CAST(FORMAT(Axi.FechaIngresoBancario, 'yyyyMMdd') AS INT) > 20211104 THEN 'Renta Liquidez 2' 
								ELSE 'Renta Liquidez' 
							END  
						ELSE CuentasFondos.NombreFondo
					END AS NombreFondo, CuentasFondos.Codigo AS CodigoFondo, Axi.Monto, 'LEGALIZACION DE APORTE' as Tipo, 'EGRESO AxI' as Tipo2 
					FROM PartidasIdentificar Axi INNER JOIN CuentasFondos ON CuentasFondos.CuentaFondo = Axi.CuentaFondo LEFT JOIN FisicosFondo ON CuentasFondos.NombreFondo = FisicosFondo.NombreFondo  
					WHERE FORMAT(Axi.FechaRadicacion, 'yyyyMMdd') <= @FechaMaxima AND FORMAT(Axi.FechaModificacion, 'yyyyMMdd') = @FechaConsulta AND (Axi.EstadoId = 3 OR Axi.EstadoId = 8 OR Axi.EstadoId = 4) AND Axi.IngresaCuentaAportes = 1 AND Axi.IdPartidaLegalizar IS NULL
					GROUP BY AxI.Id,CuentasFondos.LineaNegocio, CuentasFondos.NombreFondo, CuentasFondos.Codigo, AxI.Monto, AxI.FechaIngresoBancario, Axi.FechaRadicacion
				) AS TablaResultado
				GROUP BY TablaResultado.LineaNegocio, TablaResultado.NombreFondo, TablaResultado.CodigoFondo, Tipo2
			) AS TablaResultado2
			GROUP BY CodigoFondo, LineaNegocio, NombreFondo
		END

		IF(@Opcion = 6) --Movimientos a los clientes(Para el cuadre)
		BEGIN
			--Movimientos a clientes
			SELECT TablaResultado.LineaNegocio,
				TablaResultado.NombreFondo,
				SUM(Monto) AS Movimientos,
				COUNT(Monto) AS CantMovimientos
			FROM (
				SELECT A.Id, FORMAT(A.FechaRadicacion, 'yyyyMMdd')  as fecha2, A.LineaNegocio, 
				CASE 
					WHEN A.Fondo = 'Renta Liquidez' THEN 
						CASE 
							WHEN CAST(FORMAT(A.FechaIngresoBancario, 'yyyyMMdd') AS INT) > 20211104 THEN 'Renta Liquidez 2' 
							ELSE 'Renta Liquidez' 
						END  
					ELSE A.Fondo
				END AS NombreFondo, A.Monto
				FROM PartidasLegalizar A LEFT JOIN PartidasIdentificar Axi ON A.IdAxi = Axi.Id
				INNER JOIN Bancos B ON A.EntidadBancaria = B.Codigo
				WHERE FORMAT(A.FechaModificacion, 'yyyyMMdd') = @FechaConsulta AND (A.EstadoId = 3 OR A.EstadoId = 8 OR A.EstadoId = 4) 
				AND A.LineaNegocio = 'Valores Bancolombia' AND Axi.IngresaCuentaAportes = 1 --Para valores tiene que estar relacionada con una partida en Axi
				GROUP BY A.Id,A.FechaIngresoBancario, A.FechaRadicacion, A.LineaNegocio, A.Fondo, A.Monto
				UNION
				SELECT A.Id, FORMAT(A.FechaIngresoBancario, 'yyyyMMdd')  as fecha2, A.LineaNegocio, 
				A.Fondo AS NombreFondo, A.Monto
				FROM PartidasLegalizar A LEFT JOIN PartidasIdentificar Axi ON A.IdAxi = Axi.Id
				INNER JOIN Bancos B ON A.EntidadBancaria = B.Codigo
				WHERE FORMAT(A.FechaModificacion, 'yyyyMMdd') = @FechaConsulta AND (A.EstadoId = 3 OR A.EstadoId = 8 OR A.EstadoId = 4) 
				AND A.LineaNegocio = 'Fiduciaria Bancolombia'
				GROUP BY A.Id,A.FechaIngresoBancario, A.FechaRadicacion, A.LineaNegocio, A.Fondo, A.Monto
			) AS TablaResultado
			GROUP BY TablaResultado.LineaNegocio, TablaResultado.NombreFondo
		END
	END TRY
		BEGIN CATCH
			  SELECT
					'Error' AS Error
					,ERROR_NUMBER() AS ErrorNumber  
					,ERROR_SEVERITY() AS ErrorSeverity  
					,ERROR_STATE() AS ErrorState  
					,ERROR_PROCEDURE() AS ErrorProcedure  
					,ERROR_LINE() AS ErrorLine  
					,ERROR_MESSAGE() AS ErrorMessage;  
		END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_OBSERVACIONES_OPERACION]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTA_OBSERVACIONES_OPERACION]
	@IdOperacion int,
	@Modulo VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@Modulo = 'Gestion')
		BEGIN

			DECLARE @IdAxl INT;
			SET @IdAxl = (SELECT IdPartidaLegalizar FROM PartidasIdentificar WHERE Id= @IdOperacion);

			SELECT *
			FROM
			(
				SELECT O.UsuarioObservacion, FORMAT(CAST(O.FechaObservacion AS DATE), N'dd/MM/yyyy') AS FechaObservacion,
					   FORMAT(CAST(O.HoraObservacion AS DATETIME2), N'hh:mm:ss tt') AS HoraObservacion, O.Observacion
				FROM Observaciones O
				WHERE O.IdAxl = @IdAxl
				UNION ALL
				SELECT O.UsuarioObservacion, FORMAT(CAST(O.FechaObservacion AS DATE), N'dd/MM/yyyy') AS FechaObservacion,
				FORMAT(CAST(O.HoraObservacion AS DATETIME2), N'hh:mm:ss tt') AS HoraObservacion, O.Observacion
				FROM Observaciones O
				WHERE O.IdOperacion = @IdOperacion
			) AS Observaciones
			ORDER BY FechaObservacion DESC, HoraObservacion DESC
		END
	ELSE
		BEGIN
			
			DECLARE @IdAxi INT;
			SET @IdAxi = (SELECT Id FROM PartidasIdentificar WHERE IdPartidaLegalizar = @IdOperacion);

			SELECT *
			FROM
			(
				SELECT O.UsuarioObservacion, FORMAT(CAST(O.FechaObservacion AS DATE), N'dd/MM/yyyy') AS FechaObservacion,
				FORMAT(CAST(O.HoraObservacion AS DATETIME2), N'hh:mm:ss tt') AS HoraObservacion, O.Observacion
				FROM Observaciones O
				WHERE O.IdAxl = @IdOperacion
				UNION ALL
				SELECT O.UsuarioObservacion, FORMAT(CAST(O.FechaObservacion AS DATE), N'dd/MM/yyyy') AS FechaObservacion,
				FORMAT(CAST(O.HoraObservacion AS DATETIME2), N'hh:mm:ss tt') AS HoraObservacion, O.Observacion
				FROM Observaciones O
				WHERE O.IdOperacion = @IdAxi
			) AS Observaciones
			ORDER BY FechaObservacion DESC, HoraObservacion DESC
		END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_PERFILES_USUARIO]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTA_PERFILES_USUARIO]
AS
BEGIN
	SELECT Id, Nombre AS Perfil From Roles 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_TIPO_DOCUMENTO]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTA_TIPO_DOCUMENTO]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM TiposDocumento
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTA_TIPO_OPERACION]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTA_TIPO_OPERACION]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT * FROM TipoOperacion
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_CLIENTES]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTAR_CLIENTES]
AS
BEGIN
	SELECT 
		*
	FROM ClientesValores
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_CUENTAS_BANCARIAS]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTAR_CUENTAS_BANCARIAS]
AS
BEGIN
	SELECT
		CuentaFondo As NumCuenta,
		NombreCuenta,
		CuentaContable,
		LineaNegocio,
		Banco,
		NombreFondo as Fondo,
		TipoCuenta, 
		CodBanco
	FROM CuentasFondos
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_DETALLE_PARA_CORREO]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTAR_DETALLE_PARA_CORREO]
	@Opcion NVARCHAR(20) = NULL,
	@Fecha NVARCHAR(20) = NULL,
	@IdOperacion bigint = NULL,
	@Referencia NVARCHAR(45) = NULL
AS
BEGIN

	BEGIN TRY

	IF (@Opcion = 'EnviarCorreos')
	BEGIN
	--Consulta todas las partidas en estado pendiente
		SELECT P.Id, P.Linea, C.NombreFondo, P.CuentaFondo, P.NitCliente, P.FechaIngresoBancario AS FechaIngreso, 
		P.Monto, P.Sucursal, P.Referencia, P.NombreCliente, p.Detalle, p.EntidadBancaria FROM PartidasIdentificar P LEFT JOIN CuentasFondos C ON P.CuentaFondo = C.CuentaFondo WHERE EstadoId = 1 AND FechaRadicacion = @Fecha --Que hayan sido radicadas el dia de hoy
	END
	IF (@Opcion = 'CorreoRechazo')
	BEGIN
		SELECT Linea, Fondo, CuentaInversion AS CtaCliente, FechaIngresoBancario AS FechaIngreso, Monto FROM PartidasIdentificar WHERE Id = @IdOperacion
	END
	IF (@Opcion = 'ConsultaDestinatario')
	BEGIN
		SELECT Responsable, NombreNitPara FROM ClientesValores WHERE Referencia = @Referencia
	END

	END TRY

	BEGIN CATCH

		SELECT
			'Error' AS Error
			,ERROR_NUMBER() AS ErrorNumber  
			,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState  
			,ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage;  
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_ESTADOS]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTAR_ESTADOS] 
	@Perfil int
AS 
BEGIN
SELECT 
E.Id,
E.Estado
FROM Estados E
	WHERE 
	--E.Id = CASE WHEN @Perfil= 2 OR @Perfil= 5 OR @Perfil = 7 THEN 1
	--END
	--OR 
	E.Id = CASE WHEN  @Perfil = 5 OR @Perfil = 7 THEN 2 
	END
	OR 
	E.Id = CASE WHEN @Perfil= 1 OR @Perfil= 5 OR @Perfil= 2 THEN 3
	END
	OR 
	E.Id = CASE WHEN @Perfil=1 OR @Perfil= 2 OR @Perfil= 5 OR @Perfil = 7 THEN 4
	END
	OR 
	E.Id = CASE WHEN  @Perfil= 5 OR @Perfil = 7 THEN 5
	-- estado rechazado (6) ya no se necesita, se reemplaza por el boton de eliminar el registro directamente
	END
	OR 
	/*E.Id = CASE WHEN @Perfil= 1 OR @Perfil= 2 OR @Perfil= 5 OR @Perfil = 7 THEN 6
	END
	OR */
	--E.Id = CASE WHEN @Perfil= 1 OR @Perfil= 2 OR @Perfil= 5 OR @Perfil = 7 THEN 7 
	--END
	--OR 
	E.Id = CASE WHEN @Perfil= 5 THEN 8 
	END
	OR 
	E.Id = CASE WHEN  @Perfil= 5 OR @Perfil = 7 THEN 11
	END
	OR 
	E.Id = CASE WHEN @Perfil= 1 OR @Perfil= 5 OR @Perfil= 2 THEN 12
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_PARTIDAS_AXI]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_CONSULTAR_PARTIDAS_AXI] --Partidas por identificar
	@Perfil int = null 
AS
BEGIN
	SELECT
		P.Id,
		P.UsuarioRadicador,
		Cast(P.NitCliente AS NVARCHAR(max)) AS NitCliente,
		P.NombreCliente,
		E.Estado,
		E.Id AS EstadoId,
		P.Monto AS Monto,
		CONVERT(NVARCHAR(max),P.FechaRadicacion,103) AS FechaRadicacion,
		C.NombreFondo, 
		P.TipoOperacion,
		O.NombreTipo,
		CONVERT(NVARCHAR(max),P.FechaCumplimiento,103) AS FechaCumplimiento,
		CONVERT(NVARCHAR(max),P.FechaIngresoBancario,103) AS FechaIngresoBancario,
		CONCAT(P.EntidadBancaria, ' - ', B.NombreBanco) AS EntidadBancaria,
		Cast(P.CuentaFondo AS NVARCHAR(max)) AS CuentaFondo
	from PartidasIdentificar P LEFT JOIN PartidasLegalizar Legalizar ON P.Id = Legalizar.IdAxi
	LEFT JOIN Estados E ON P.EstadoId = E.Id
	LEFT JOIN CuentasFondos C ON P.CuentaFondo = C.CuentaFondo
	LEFT JOIN TipoOperacion O ON P.TipoOperacion = O.Id
	LEFT JOIN Bancos B on RIGHT('0000'+CAST(b.Codigo AS VARCHAR(4)),4)= p.EntidadBancaria
	--WHERE (@Perfil != 5 AND P.EstadoId != 4	) OR (@Perfil = 5)
	ORDER BY CASE WHEN P.EstadoId = 11 THEN 0 ELSE 1 END, CASE WHEN P.EstadoId = 1 THEN 0 ELSE 1 END, CASE WHEN P.EstadoId = 3 THEN 0 ELSE 1 END,CASE WHEN P.EstadoId = 8 THEN 0 ELSE 1 END,CASE WHEN P.EstadoId = 2 THEN 0 ELSE 1 END, P.FechaIngresoBancario DESC, P.FechaModificacion DESC
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_PARTIDAS_AXL]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTAR_PARTIDAS_AXL]
	@Perfil INT = null,
	@Usuario NVARCHAR(20)= null
AS
BEGIN
	SELECT
		P.Id,
		P.UsuarioRadicador AS Usuario,
		Cast(P.NitCliente AS NVARCHAR(max)) AS NitCliente,
		P.NombreCliente,
		TRIM(P.CodTipoIdTitular) AS CodTipoIdTitular,
		E.Id AS EstadoId,
		E.Estado,
		FORMAT(P.Monto, 'C') AS Monto,
		CONVERT(NVARCHAR(max),P.FechaRadicacion,103) AS FechaRadicacion,
		P.Fondo, 
		P.TipoOperacion,
		O.NombreTipo,
		CASE WHEN P.LineaNegocio = 'Fiduciaria Bancolombia' THEN CONCAT(P.Fondo, '-', CAST(F.Fondo COLLATE SQL_Latin1_General_CP1_CI_AS AS nvarchar(100))) ELSE P.Fondo END AS NombreFondo,
		CONVERT(NVARCHAR(max),P.FechaCumplimiento,103) AS FechaCumplimiento,
		CONVERT(NVARCHAR(max),P.FechaIngresoBancario,103) AS FechaIngresoBancario,
		CONCAT(P.EntidadBancaria, ' - ', B.NombreBanco) AS EntidadBancaria,
		Cast(P.CuentaInversion as NVARCHAR(max)) AS CuentaInversion,
		P.LineaNegocio,
		P.NitFondo,
		P.NumeroFisico
	from PartidasLegalizar P
	LEFT JOIN Estados E ON P.EstadoId = E.Id
	LEFT JOIN (SELECT * FROM FONDOS_MK.gen.Fondos) F ON P.Fondo COLLATE SQL_Latin1_General_CP1_CI_AS = F.Codigo COLLATE SQL_Latin1_General_CP1_CI_AS
	LEFT JOIN TipoOperacion O ON P.TipoOperacion = O.Id
	LEFT JOIN Bancos B ON RIGHT('0000'+CAST(b.Codigo AS VARCHAR(4)),4)= p.EntidadBancaria
	WHERE
		--Que a los comerciales solo les muestre las mismas partidas que ellos radican 
		((@Perfil = 4 AND P.UsuarioRadicador = @Usuario)
		OR
		--Perfil diferente a comercial se muestran todas las partidas radicadas
		(@Perfil != 4))
		--AND ((@Perfil != 5 AND @Perfil != 4 AND P.EstadoId != 4	) OR (@Perfil = 5 OR @Perfil = 4)) --Perfil administrador muestra todas las partidas, otros perfiles no muestra las finalizadas
	ORDER BY CASE WHEN P.EstadoId = 11 THEN 0 ELSE 1 END, CASE WHEN P.EstadoId = 1 THEN 0 ELSE 1 END, CASE WHEN P.EstadoId = 3 THEN 0 ELSE 1 END,CASE WHEN P.EstadoId = 8 THEN 0 ELSE 1 END,CASE WHEN P.EstadoId = 2 THEN 0 ELSE 1 END, P.FechaCumplimiento DESC, P.FechaModificacion DESC
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_SOPORTES]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTAR_SOPORTES]
	@IdOperacion int,
	@Modulo VARCHAR(20)
AS
BEGIN
     
       SET NOCOUNT ON;
	   IF (@Modulo = 'Gestion')
		BEGIN
			SELECT IdSoporte, NombreSoporte
			FROM (
				SELECT IdSoporte, NombreSoporte, FechaSubido, HoraSubido
				FROM Soporte
				WHERE IdAxL = (SELECT IdPartidaLegalizar FROM PartidasIdentificar WHERE Id = @IdOperacion)
				UNION 
				SELECT IdSoporte, NombreSoporte, FechaSubido, HoraSubido
				FROM Soporte
				WHERE IdPago = @IdOperacion
			) AS S
			ORDER BY FechaSubido DESC, HoraSubido DESC
			
		END	
	   ELSE
		BEGIN
		 SELECT 
					--S.IdPago		
				S.IdSoporte
				,S.NombreSoporte
			FROM Soporte as S		
			WHERE S.IdAxL = @IdOperacion
			order by S.FechaSubido desc, S.HoraSubido desc
		END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_USUARIO]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTAR_USUARIO]
	@Usuario varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		U.USUARIO,
		U.NOMBRE,
		U.PERFIL AS Perfil,
		R.Nombre as Nombre_Perfil
	from USUARIOS U 
	LEFT JOIN Roles R ON U.PERFIL= R.Id
	where U.USUARIO = @Usuario and U.ESTADO = 1

END
GO
/****** Object:  StoredProcedure [dbo].[SP_CONSULTAR_USUARIOS]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CONSULTAR_USUARIOS]
AS
BEGIN
SELECT 
	U.Id as Id_Usuario	
	,U.USUARIO as Usuario_Red
	,U.NOMBRE as Nombre_Usuario
	,U.PERFIL as Perfil
	,R.NOMBRE as Nombre_Perfil
	,U.FECHA_CREACION as Fecha_Creacion
	,U.HORA_CREACION as Hora_Creacion
	,U.USUARIO_CREA as Usuario_Creacion
	,U.FECHA_MODIFICA as Fecha_Modificacion
	,U.HORA_MODIFICA as Hora_Modificacion
	,U.USUARIO_MODIFICA as Usuario_Modificacion
	,U.ESTADO
FROM USUARIOS U
LEFT JOIN Roles R ON U.PERFIL= R.Id
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GESTIONAR_PARTIDAS]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GESTIONAR_PARTIDAS] --Gestiona partidas axi
		--Variables generales
		@IdOperacion INT = NULL,
		@Estado INT = NULL,
		@Observacion NVARCHAR(max)= NULL,
		@EstadoActual INT = NULL,
		--las sieguientes 2 variables son de identidad de quien crea el usuario
		@Usuario NVARCHAR(20) = NULL,
		@Perfil INT = NULL,
		@NombreSoporte NVARCHAR(200) = NULL
AS
BEGIN
	BEGIN TRY
			SET NOCOUNT ON;

			DECLARE @FechaFormateada date; --Fecha actual
			DECLARE @HoraFormateada time(7); -- Hora actual
			DECLARE @Partida_Estado_Actual int;
			DECLARE @UsuarioRadicador NVARCHAR(20);
			DECLARE @Autogestionado bit;
			--El usuario que radico la partida en caso de que haya que enviar correo
			SET @UsuarioRadicador = (SELECT UsuarioRadicador FROM PartidasLegalizar WHERE IdAxi = @IdOperacion);
									
			SET @Autogestionado = CASE WHEN @Estado = 4 THEN 1 ELSE 0 END;
			--FechaFormateada es la fecha actual en el formato que necesitamos
			SET @FechaFormateada = FORMAT(GetDate(), 'yyyyMMdd');
			SET @HoraFormateada = convert(time(7), getdate(), 108); -- 114: hh:mm:ss:mmm(24h), 108: hh:mm:ss(24h)
			IF (@Usuario IS NULL)
				BEGIN
					Set @Usuario = 'No_User';
				END

			--------------------------------
			--->INICIA PROCESO:
			--------------------------------
			--> Gestionar Partida (Cambiar estado, agregar observacion o las 2)

				--Comprueba cuendo se ingresa tanto observacion y tambien se cambia el estado
				IF (@Observacion != '' AND @Estado != 0)
					BEGIN

						---Actualiza el estado de la partida del lado de los comerciales
						UPDATE PartidasLegalizar SET EstadoId = @Estado, FechaModificacion = @FechaFormateada WHERE IdAxi = @IdOperacion

						--Actualiza el estado de la partida del lado de la gestion (Axi)
						UPDATE PartidasIdentificar SET EstadoId= @Estado, Autogestion = @Autogestionado, FechaModificacion= @FechaFormateada  WHERE Id = @IdOperacion

						--Inserta la observacion(La observacion se hace con el Id Axi solamente)
						INSERT INTO Observaciones(IdOperacion, Observacion, FechaObservacion, HoraObservacion, UsuarioObservacion) VALUES(@IdOperacion, @Observacion, @FechaFormateada, @HoraFormateada, @Usuario)

						-------Inserta el toque
						INSERT INTO Toques(IdOperacion, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado) VALUES(@IdOperacion, 'Modificación y Observación', @FechaFormateada, @HoraFormateada, @Usuario,@Estado)
					
						--En caso de ser una autogestion
						IF(@NombreSoporte IS NOT NULL OR @NombreSoporte != '')
							BEGIN
								--Para el caso de las partidas que solo deban salir de la cuenta axi, identificador de fecha para el query
								UPDATE PartidasIdentificar SET FechaModificacion= @FechaFormateada  WHERE Id = @IdOperacion

								INSERT INTO Soporte (IdPago,IdAxL, NombreSoporte, FechaSubido, HoraSubido) 
								VALUES (@IdOperacion,0, @NombreSoporte, @FechaFormateada, @HoraFormateada)
							END
						--> Se devuelve Id del pago actualizado. Devuelvo el usuario radicador en los casos que hay que enviar correo se nencesita
						SELECT 'Id_Pago' = @IdOperacion
								,IdLegalicacion = (SELECT Id FROM PartidasLegalizar WHERE IdAxi = @IdOperacion)
								,UsuarioRadicador = @UsuarioRadicador
								,Linea = (SELECT Linea FROM PartidasIdentificar WHERE Id = @IdOperacion)
								,Fondo = (SELECT Fondo FROM PartidasIdentificar WHERE Id = @IdOperacion)
								,CtaCliente = (SELECT CuentaInversion FROM PartidasIdentificar WHERE Id = @IdOperacion)
								,FechaIngreso = (SELECT FechaIngresoBancario FROM PartidasIdentificar WHERE Id = @IdOperacion);
					END
				ELSE
					BEGIN	
					--Comprueba si solo se ingresa cambio de esatado o observacion
						IF(@Estado != 0)
							BEGIN
								--Actualiza el estado de la partida del lado de los comerciales
								UPDATE PartidasLegalizar SET EstadoId = @Estado, FechaModificacion = @FechaFormateada WHERE IdAxi = @IdOperacion

								--Actualiza el estado de la partida del lado de la gestion (Axi)
								UPDATE PartidasIdentificar SET EstadoId= @Estado, Autogestion = @Autogestionado, FechaModificacion= @FechaFormateada  WHERE Id = @IdOperacion

								--En caso de ser una autogestion
								IF(@NombreSoporte IS NOT NULL OR @NombreSoporte != '')
								BEGIN
									UPDATE PartidasIdentificar SET FechaModificacion= @FechaFormateada  WHERE Id = @IdOperacion

									INSERT INTO Soporte (IdPago,IdAxL, NombreSoporte, FechaSubido, HoraSubido) 
									VALUES (@IdOperacion,0, @NombreSoporte, @FechaFormateada, @HoraFormateada)
								END
								-------Inserta el Toque
								INSERT INTO Toques(IdOperacion, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado) VALUES(@IdOperacion, 'Modificación', @FechaFormateada, @HoraFormateada, @Usuario,@Estado)
							END
						ELSE --Si no ingreso estado entonces ingreso observacion
							BEGIN
								--Aqui no actualizamos estado ya que no se cambio
								--Consultamos el estado actual, lo necesitamos para el toque
								SET @Estado = (SELECT EstadoId FROM PartidasIdentificar WHERE Id = @IdOperacion);

								--Inserta Observacion
								INSERT INTO Observaciones(IdOperacion, Observacion, FechaObservacion, HoraObservacion, UsuarioObservacion) VALUES(@IdOperacion, @Observacion, @FechaFormateada, @HoraFormateada, @Usuario)
					
								-------Inserta el toque
								INSERT INTO Toques(IdOperacion, TipoToque, FechaToque, HoraToque, UsuarioToque, Estado) VALUES(@IdOperacion, 'Observación', @FechaFormateada, @HoraFormateada, @Usuario,@Estado)
							
								--En caso de ser una autogestion
								IF(@NombreSoporte IS NOT NULL OR @NombreSoporte != '')
								BEGIN
									UPDATE PartidasIdentificar SET FechaModificacion= @FechaFormateada  WHERE Id = @IdOperacion

									INSERT INTO Soporte (IdPago,IdAxL, NombreSoporte, FechaSubido, HoraSubido) 
									VALUES (@IdOperacion,0, @NombreSoporte, @FechaFormateada, @HoraFormateada)
								END
							END

						--> Se devuelve Id del pago actualizado. 
						SELECT 'Id_Pago' = @IdOperacion
								,UsuarioRadicador = @UsuarioRadicador
								,IdLegalicacion = (SELECT Id FROM PartidasLegalizar WHERE IdAxi = @IdOperacion)
								,Linea = (SELECT Linea FROM PartidasIdentificar WHERE Id = @IdOperacion)
								,FechaIngreso = (SELECT FechaIngresoBancario FROM PartidasIdentificar WHERE Id = @IdOperacion);

					END	
	END TRY
		BEGIN CATCH
			  SELECT
					'Error' AS Error
					,ERROR_NUMBER() AS ErrorNumber  
					,ERROR_SEVERITY() AS ErrorSeverity  
					,ERROR_STATE() AS ErrorState  
					,ERROR_PROCEDURE() AS ErrorProcedure  
					,ERROR_LINE() AS ErrorLine  
					,ERROR_MESSAGE() AS ErrorMessage;  
		END CATCH
 END
GO
/****** Object:  StoredProcedure [dbo].[SP_RELACIONAR_CON_APORTES_LEGALIZAR]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_RELACIONAR_CON_APORTES_LEGALIZAR]--Procedimiento que relaciona los registros recien cargados en axi con algun registro en el modulo de los comerciales, si no encuentra registros igual crea las llaves para posteriormente relacionar cuando el comercial ingrese la instruccion de legalizacion
@Fecha NVARCHAR(20)= NULL
AS
BEGIN
	BEGIN TRY
		 --Crea llave a los registros recien cargados masivamente
		 ---Linea Fiduciaria
		UPDATE PartidasIdentificar 
		 SET Llave = CONCAT(A.Nit_Fondo, F.CodBanco, P.Monto, P.FechaIngresoBancario) 
		 FROM PartidasIdentificar P LEFT JOIN CuentasFondos F ON P.CuentaFondo = F.CuentaFondo 
		 LEFT JOIN (SELECT * FROM FONDOS_MK.gen.Fondos ) as A ON F.NombreFondo COLLATE SQL_Latin1_General_CP1_CI_AS = UPPER(A.Fondo) COLLATE SQL_Latin1_General_CP1_CI_AS
		 WHERE P.EstadoId = 1 AND P.FechaRadicacion = @Fecha AND P.Linea = 'Fiduciaria Bancolombia'

		 --Linea Valores
		 UPDATE PartidasIdentificar 
		 SET Llave = CONCAT(A.NitFondo, f.CodBanco, P.Monto, P.FechaIngresoBancario) 
		 FROM PartidasIdentificar P LEFT JOIN CuentasFondos F ON P.CuentaFondo = F.CuentaFondo 
		 LEFT JOIN  (SELECT * FROM FONDOS_MK.gen.CuentasFiduciaria ) as A ON F.NombreFondo COLLATE SQL_Latin1_General_CP1_CI_AS = UPPER(A.NombreFondo) COLLATE SQL_Latin1_General_CP1_CI_AS
		 WHERE P.EstadoId = 1 AND P.FechaRadicacion = @Fecha AND P.Linea = 'Valores Bancolombia'

		 --Se crean subconsultas contando las llaves que hay en cada tabla, se concatena la llave + el numero de veces que se repite
		;WITH CTE_PartidasIdentificar AS (
			SELECT *,
					CONCAT(Llave,ROW_NUMBER() OVER (PARTITION BY Llave ORDER BY FechaIngresoBancario)) AS RowNum
			FROM PartidasIdentificar
			WHERE EstadoId = 1 AND FechaRadicacion <= @Fecha AND DuplicadoTomado IS NULL 
		), CTE_PartidasLegalizar AS (
			SELECT *,
					CONCAT(Llave,ROW_NUMBER() OVER (PARTITION BY Llave ORDER BY FechaIngresoBancario)) AS RowNum
			FROM PartidasLegalizar
			WHERE EstadoId = 1 AND FechaRadicacion <= @Fecha AND DuplicadoTomado IS NULL
		)

		 UPDATE T2
		 SET T2.IdPartidaLegalizar = T1.Id, T2.DuplicadoTomado = 1, T2.EstadoId = 11
		 FROM CTE_PartidasLegalizar T1
		 LEFT JOIN CTE_PartidasIdentificar T2 ON T1.RowNum = T2.RowNum

		 ;WITH CTE_PartidasIdentificar AS (
			SELECT *,
					ROW_NUMBER() OVER (PARTITION BY Llave ORDER BY FechaIngresoBancario) AS RowNum
			FROM PartidasIdentificar
			WHERE EstadoId = 11 AND FechaRadicacion <= @Fecha AND DuplicadoTomado = 1
		), CTE_PartidasLegalizar AS (
			SELECT *,
					ROW_NUMBER() OVER (PARTITION BY Llave ORDER BY FechaIngresoBancario) AS RowNum
			FROM PartidasLegalizar
			WHERE EstadoId = 1 AND FechaRadicacion <= @Fecha AND DuplicadoTomado IS NULL
		)

		 UPDATE T2
		 SET T2.IdAxi = T1.Id, T2.DuplicadoTomado = 1, T2.EstadoId = 11
		 FROM CTE_PartidasIdentificar T1
		 INNER JOIN CTE_PartidasLegalizar T2 ON T1.Llave=T2.Llave AND T1.RowNum = T2.RowNum

		 --SELECT 'true'
		 IF @@ROWCOUNT>0
		 BEGIN
			SELECT 'Relacionadas' = @@ROWCOUNT--Se supone que retorna las filas afectadas en el ultimo query ejecutado, pero no funciona en el mismo procedimiento
		 END
	 END TRY
		BEGIN CATCH
			SELECT
				'Error' AS Error
				,ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  
		END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_VALIDA_CUENTA]    Script Date: 20/05/2024 5:24:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_VALIDA_CUENTA]
 @CuentaFondo BIGINT 
AS
BEGIN
	BEGIN TRY
		DECLARE @EntidadBancaria VARCHAR(4)
		DECLARE @LineNegocio VARCHAR(25)

		SET @EntidadBancaria = (SELECT CodBanco FROM CuentasFondos WHERE CuentaFondo = @CuentaFondo)
		SET @LineNegocio = (SELECT LineaNegocio FROM CuentasFondos WHERE CuentaFondo = @CuentaFondo)

		IF (@EntidadBancaria IS NULL)
			BEGIN
				SELECT CONCAT('La cuenta: ', @CuentaFondo , ' no se encuentra parametrizada, debe ingresarla por el modulo Administración Cuentas FIC ') AS Respuesta
			END
		ELSE
			BEGIN
				SELECT @EntidadBancaria AS EntidadBancaria, @LineNegocio AS LineaNegocio
			END
	END TRY
		BEGIN CATCH
			SELECT
				'Error' AS Error
				,ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  
		END CATCH
END
GO
