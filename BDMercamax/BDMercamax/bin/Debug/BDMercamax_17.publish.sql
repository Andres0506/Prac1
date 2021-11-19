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
Se está quitando la columna [dbo].[Venta].[id_venta]; puede que se pierdan datos.
*/

IF EXISTS (select top 1 1 from [dbo].[Venta])
    RAISERROR (N'Se detectaron filas. La actualización del esquema va a terminar debido a una posible pérdida de datos.', 16, 127) WITH NOWAIT

GO
PRINT N'Quitando Clave externa [dbo].[FK_Facturacion_ToTable_2]...';


GO
ALTER TABLE [dbo].[Facturacion] DROP CONSTRAINT [FK_Facturacion_ToTable_2];


GO
PRINT N'Quitando Clave externa [dbo].[FK_Venta_ToTable]...';


GO
ALTER TABLE [dbo].[Venta] DROP CONSTRAINT [FK_Venta_ToTable];


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
    [sección_bodega]   NVARCHAR (MAX) NOT NULL,
    [sección_gondola]  NVARCHAR (MAX) NOT NULL,
    UNIQUE NONCLUSTERED ([barcode_producto] ASC),
    PRIMARY KEY CLUSTERED ([barcode_producto] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[LugarStock])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_LugarStock] ([barcode_producto], [cantidad_bodega], [cantidad_gondola], [sección_bodega], [sección_gondola])
        SELECT   [barcode_producto],
                 [cantidad_bodega],
                 [cantidad_gondola],
                 [sección_bodega],
                 [sección_gondola]
        FROM     [dbo].[LugarStock]
        ORDER BY [barcode_producto] ASC;
    END

DROP TABLE [dbo].[LugarStock];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_LugarStock]', N'LugarStock';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Iniciando recompilación de la tabla [dbo].[Venta]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Venta] (
    [barcode_producto] INT NOT NULL,
    [cantidad]         INT NOT NULL,
    [id_factura]       INT NOT NULL,
    UNIQUE NONCLUSTERED ([barcode_producto] ASC),
    PRIMARY KEY CLUSTERED ([barcode_producto] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Venta])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Venta] ([barcode_producto], [cantidad], [id_factura])
        SELECT   [barcode_producto],
                 [cantidad],
                 [id_factura]
        FROM     [dbo].[Venta]
        ORDER BY [barcode_producto] ASC;
    END

DROP TABLE [dbo].[Venta];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Venta]', N'Venta';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creando Clave externa [dbo].[FK_Venta_ToTable]...';


GO
ALTER TABLE [dbo].[Venta] WITH NOCHECK
    ADD CONSTRAINT [FK_Venta_ToTable] FOREIGN KEY ([id_factura]) REFERENCES [dbo].[Facturacion] ([id_factura]);


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
PRINT N'Actualizando Procedimiento [dbo].[VerProductoBodega]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VerProductoBodega]';


GO
PRINT N'Actualizando Procedimiento [dbo].[VerProductoGondola]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VerProductoGondola]';


GO
PRINT N'Comprobando los datos existentes con las restricciones recién creadas';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Venta] WITH CHECK CHECK CONSTRAINT [FK_Venta_ToTable];


GO
PRINT N'Actualización completada.';


GO
