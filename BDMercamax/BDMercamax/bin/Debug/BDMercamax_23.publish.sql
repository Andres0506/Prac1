/*
Script de implementación para BDMercamax

Una herramienta generó este código.
Los cambios realizados en este archivo podrían generar un comportamiento incorrecto y se perderán si
se vuelve a generar el código.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "BDMercamax"
:setvar DefaultFilePrefix "BDMercamax"
:setvar DefaultDataPath "C:\Users\Usuario\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"
:setvar DefaultLogPath "C:\Users\Usuario\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"

GO
:on error exit
GO
/*
Detectar el modo SQLCMD y deshabilitar la ejecución del script si no se admite el modo SQLCMD.
Para volver a habilitar el script después de habilitar el modo SQLCMD, ejecute lo siguiente:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'El modo SQLCMD debe estar habilitado para ejecutar correctamente este script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'La operación de refactorización Cambiar nombre con la clave fa9892f6-3d87-4e74-8b63-94666b70935a se ha omitido; no se cambiará el nombre del elemento [dbo].[LugarStock].[sección_bodega] (SqlSimpleColumn) a seccion_bodega';


GO
PRINT N'La operación de refactorización Cambiar nombre con la clave 138d8e79-b170-4dad-ad41-056b4862592b se ha omitido; no se cambiará el nombre del elemento [dbo].[LugarStock].[sección_gondola] (SqlSimpleColumn) a seccion_gondola';


GO
PRINT N'Creando Procedimiento [dbo].[CrearCliente]...';


GO
CREATE PROCEDURE [dbo].[CrearCliente]
	@cc int,
	@nombre nvarchar(max),
	@telefono nvarchar(max),
	@email nvarchar(max),
	@direccion nvarchar(max),
	@fecha date
	
AS
	INSERT INTO Cliente (cc_cliente,nombre_apellido_cliente,email_cliente,direccion_cliente,fecha_nacimiento,puntos_acumulados )   VALUES ( @cc, @nombre,@telefono, @email, @direccion,@fecha, 0 )
GO
PRINT N'Creando Procedimiento [dbo].[CrearFactura]...';


GO
CREATE PROCEDURE [dbo].[CrearFactura]
	@id int = 0,
	@monto decimal,
	@date date,
	@montoIva int,
	@cliente int,
	@personal int
AS
	insert into Facturacion (id_factura,monto_total,fecha,monto_iva,cc_cliente,cc_personal) values(@id,@monto, @date,@montoIva,@cliente,@personal  )
RETURN 0
GO
PRINT N'Creando Procedimiento [dbo].[GetIvaPuntos]...';


GO
CREATE PROCEDURE [dbo].[GetIvaPuntos]
	@id int

AS
	SELECT   iva,puntos  from Tipo_Producto where id_tipo = (select id_tipo from Producto where id_producto = @id )
RETURN 0
GO
-- Paso de refactorización para actualizar el servidor de destino con los registros de transacciones implementadas

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'fa9892f6-3d87-4e74-8b63-94666b70935a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('fa9892f6-3d87-4e74-8b63-94666b70935a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '138d8e79-b170-4dad-ad41-056b4862592b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('138d8e79-b170-4dad-ad41-056b4862592b')

GO

GO
PRINT N'Actualización completada.';


GO
