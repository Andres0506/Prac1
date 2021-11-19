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
:setvar DefaultDataPath "C:\Users\Andres\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"
:setvar DefaultLogPath "C:\Users\Andres\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"

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
/*
Se está quitando la columna [dbo].[Cliente].[fecha_nacimiento_cliente]; puede que se pierdan datos.

Debe agregarse la columna [dbo].[Cliente].[email_cliente] de la tabla [dbo].[Cliente], pero esta columna no tiene un valor predeterminado y no admite valores NULL. Si la tabla contiene datos, el script ALTER no funcionará. Para evitar esta incidencia, agregue un valor predeterminado a la columna, márquela de modo que permita valores NULL o habilite la generación de valores predeterminados inteligentes como opción de implementación.

Debe agregarse la columna [dbo].[Cliente].[fecha_nacimiento] de la tabla [dbo].[Cliente], pero esta columna no tiene un valor predeterminado y no admite valores NULL. Si la tabla contiene datos, el script ALTER no funcionará. Para evitar esta incidencia, agregue un valor predeterminado a la columna, márquela de modo que permita valores NULL o habilite la generación de valores predeterminados inteligentes como opción de implementación.
*/

IF EXISTS (select top 1 1 from [dbo].[Cliente])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
/*
Se está quitando la columna [dbo].[Facturacion].[id_venta]; puede que se pierdan datos.
*/

IF EXISTS (select top 1 1 from [dbo].[Facturacion])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
/*
Se está quitando la columna [dbo].[LugarStock].[id_lugar]; puede que se pierdan datos.
*/

IF EXISTS (select top 1 1 from [dbo].[LugarStock])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
/*
Debe agregarse la columna [dbo].[Tipo_Producto].[puntos] de la tabla [dbo].[Tipo_Producto], pero esta columna no tiene un valor predeterminado y no admite valores NULL. Si la tabla contiene datos, el script ALTER no funcionará. Para evitar esta incidencia, agregue un valor predeterminado a la columna, márquela de modo que permita valores NULL o habilite la generación de valores predeterminados inteligentes como opción de implementación.
*/

IF EXISTS (select top 1 1 from [dbo].[Tipo_Producto])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
/*
Se está quitando la columna [dbo].[Venta].[id_venta]; puede que se pierdan datos.
*/

IF EXISTS (select top 1 1 from [dbo].[Venta])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
PRINT N'La operación de refactorización Cambiar nombre con la clave fa9892f6-3d87-4e74-8b63-94666b70935a se ha omitido; no se cambiará el nombre del elemento [dbo].[LugarStock].[sección_bodega] (SqlSimpleColumn) a seccion_bodega';


GO
PRINT N'La operación de refactorización Cambiar nombre con la clave 138d8e79-b170-4dad-ad41-056b4862592b se ha omitido; no se cambiará el nombre del elemento [dbo].[LugarStock].[sección_gondola] (SqlSimpleColumn) a seccion_gondola';


GO
PRINT N'Quitando Clave externa [dbo].[FK_Facturacion_ToTable]...';


GO
ALTER TABLE [dbo].[Facturacion] DROP CONSTRAINT [FK_Facturacion_ToTable];


GO
PRINT N'Quitando Clave externa [dbo].[FK_Facturacion_ToTable_2]...';


GO
ALTER TABLE [dbo].[Facturacion] DROP CONSTRAINT [FK_Facturacion_ToTable_2];


GO
PRINT N'Quitando Clave principal restricción sin nombre en [dbo].[Venta]...';


GO
ALTER TABLE [dbo].[Venta] DROP CONSTRAINT [PK__Venta__459533BFCD80D66E];


GO
PRINT N'Iniciando recompilación de la tabla [dbo].[Cliente]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Cliente] (
    [cc_cliente]              INT            NOT NULL,
    [nombre_apellido_cliente] NVARCHAR (MAX) NOT NULL,
    [telefono_cliente]        NVARCHAR (MAX) NOT NULL,
    [email_cliente]           NVARCHAR (MAX) NOT NULL,
    [direccion_cliente]       NVARCHAR (MAX) NOT NULL,
    [fecha_nacimiento]        DATE           NOT NULL,
    [puntos_acumulados]       INT            NOT NULL,
    PRIMARY KEY CLUSTERED ([cc_cliente] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Cliente])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Cliente] ([cc_cliente], [nombre_apellido_cliente], [telefono_cliente], [direccion_cliente], [puntos_acumulados])
        SELECT   [cc_cliente],
                 [nombre_apellido_cliente],
                 [telefono_cliente],
                 [direccion_cliente],
                 [puntos_acumulados]
        FROM     [dbo].[Cliente]
        ORDER BY [cc_cliente] ASC;
    END

DROP TABLE [dbo].[Cliente];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Cliente]', N'Cliente';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Modificando Tabla [dbo].[Facturacion]...';


GO
ALTER TABLE [dbo].[Facturacion] DROP COLUMN [id_venta];


GO
PRINT N'Iniciando recompilación de la tabla [dbo].[LugarStock]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_LugarStock] (
    [barcode_producto] INT            NOT NULL,
    [cantidad_bodega]  INT            NOT NULL,
    [cantidad_gondola] INT            NOT NULL,
    [seccion_bodega]   NVARCHAR (MAX) NOT NULL,
    [seccion_gondola]  NVARCHAR (MAX) NOT NULL,
    UNIQUE NONCLUSTERED ([barcode_producto] ASC),
    PRIMARY KEY CLUSTERED ([barcode_producto] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[LugarStock])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_LugarStock] ([barcode_producto], [cantidad_bodega], [cantidad_gondola], [seccion_bodega], [seccion_gondola])
        SELECT   [barcode_producto],
                 [cantidad_bodega],
                 [cantidad_gondola],
                 [seccion_bodega],
                 [seccion_gondola]
        FROM     [dbo].[LugarStock]
        ORDER BY [barcode_producto] ASC;
    END

DROP TABLE [dbo].[LugarStock];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_LugarStock]', N'LugarStock';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Modificando Tabla [dbo].[Tipo_Producto]...';


GO
ALTER TABLE [dbo].[Tipo_Producto]
    ADD [puntos] INT NOT NULL;


GO
PRINT N'Modificando Tabla [dbo].[Venta]...';


GO
ALTER TABLE [dbo].[Venta] DROP COLUMN [id_venta];


GO
PRINT N'Creando Tabla [dbo].[Producto]...';


GO
CREATE TABLE [dbo].[Producto] (
    [id_producto]       INT             NOT NULL,
    [nombre_producto]   NVARCHAR (MAX)  NOT NULL,
    [fecha_llegada]     DATE            NOT NULL,
    [fecha_vencimiento] DATE            NOT NULL,
    [barcode]           INT             NOT NULL,
    [precio]            DECIMAL (18, 2) NOT NULL,
    [nit]               INT             NOT NULL,
    [id_tipo]           INT             NOT NULL,
    PRIMARY KEY CLUSTERED ([id_producto] ASC)
);


GO
PRINT N'Creando Clave externa [dbo].[FK_Facturacion_ToTable]...';


GO
ALTER TABLE [dbo].[Facturacion] WITH NOCHECK
    ADD CONSTRAINT [FK_Facturacion_ToTable] FOREIGN KEY ([cc_cliente]) REFERENCES [dbo].[Cliente] ([cc_cliente]);


GO
PRINT N'Creando Clave externa [dbo].[FK_Producto_ToTable]...';


GO
ALTER TABLE [dbo].[Producto] WITH NOCHECK
    ADD CONSTRAINT [FK_Producto_ToTable] FOREIGN KEY ([nit]) REFERENCES [dbo].[Proveedor] ([nit]);


GO
PRINT N'Creando Clave externa [dbo].[FK_Producto_ToTable_1]...';


GO
ALTER TABLE [dbo].[Producto] WITH NOCHECK
    ADD CONSTRAINT [FK_Producto_ToTable_1] FOREIGN KEY ([id_tipo]) REFERENCES [dbo].[Tipo_Producto] ([id_tipo]);


GO
PRINT N'Creando Vista [dbo].[GetCountFacturas]...';


GO
CREATE VIEW [dbo].[GetCountFacturas]
	AS
	SELECT id_factura from Facturacion;
GO
PRINT N'Creando Vista [dbo].[VerClientes]...';


GO
CREATE VIEW [dbo].[VerClientes]
	As
	select  cc_cliente ,nombre_apellido_cliente, puntos_acumulados from Cliente;
GO
PRINT N'Creando Vista [dbo].[VerPorductoPrecio]...';


GO
CREATE VIEW [dbo].[VerPorductoPrecio]
AS
SELECT 	id_producto,nombre_producto FROM Producto;
GO
PRINT N'Creando Vista [dbo].[VerProductos]...';


GO
CREATE VIEW [dbo].[VerProductos]
	AS
	SELECT nombre_producto, precio FROM Producto
GO
PRINT N'Creando Procedimiento [dbo].[ActualizarGondola]...';


GO
CREATE PROCEDURE [dbo].[ActualizarGondola]
	@id int,
	@n int
AS
	UPDATE LugarStock set cantidad_gondola= cantidad_gondola-@n where barcode_producto= (select barcode from Producto where id_producto=@id )
RETURN 0
GO
PRINT N'Creando Procedimiento [dbo].[ActualizarPuntos]...';


GO
CREATE PROCEDURE [dbo].[ActualizarPuntos]
	@n int,
	@id int
AS
	UPDATE Cliente set puntos_acumulados= puntos_acumulados-@n  where cc_cliente= @id
RETURN 0
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
	INSERT INTO Cliente (cc_cliente,  nombre_apellido_cliente, telefono_cliente, email_cliente,   direccion_cliente, fecha_nacimiento, puntos_acumulados )   VALUES ( @cc, @nombre,@telefono, @email, @direccion,@fecha, 0 )
RETURN 0
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
PRINT N'Creando Procedimiento [dbo].[VerProductoBodega]...';


GO
CREATE PROCEDURE [dbo].[VerProductoBodega]
	@codProd int 
	
AS
	SELECT cantidad_bodega, seccion_bodega fROM LugarStock WHERE barcode_producto=@codProd
RETURN 0
GO
PRINT N'Creando Procedimiento [dbo].[VerProductoGondola]...';


GO
CREATE PROCEDURE [dbo].[VerProductoGondola]
	@codProd int
	
AS
	SELECT cantidad_gondola, seccion_gondola FROM LugarStock WHERE barcode_producto=@codProd
RETURN 0
GO
PRINT N'Creando Procedimiento [dbo].[VerPuntos]...';


GO
CREATE PROCEDURE [dbo].[VerPuntos]
	@user int
	
AS
	SELECT puntos_acumulados FROM Cliente WHERE cc_cliente=@user
RETURN 0
GO
PRINT N'Actualizando Procedimiento [dbo].[LoginCliente]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[LoginCliente]';


GO
-- Paso de refactorización para actualizar el servidor de destino con los registros de transacciones implementadas
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'fa9892f6-3d87-4e74-8b63-94666b70935a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('fa9892f6-3d87-4e74-8b63-94666b70935a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '138d8e79-b170-4dad-ad41-056b4862592b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('138d8e79-b170-4dad-ad41-056b4862592b')

GO

GO
PRINT N'Comprobando los datos existentes con las restricciones recién creadas';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Facturacion] WITH CHECK CHECK CONSTRAINT [FK_Facturacion_ToTable];

ALTER TABLE [dbo].[Producto] WITH CHECK CHECK CONSTRAINT [FK_Producto_ToTable];

ALTER TABLE [dbo].[Producto] WITH CHECK CHECK CONSTRAINT [FK_Producto_ToTable_1];


GO
PRINT N'Actualización completada.';


GO
