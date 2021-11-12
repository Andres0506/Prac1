CREATE TABLE [dbo].[LugarStock]
(
	[id_lugar] INT NOT NULL PRIMARY KEY, 
    [barcode_producto] INT NOT NULL UNIQUE, 
    [cantidad_bodega] INT NOT NULL, 
    [cantidad_gondola] INT NOT NULL, 
    [sección_bodega] NVARCHAR(MAX) NOT NULL, 
    [sección_gondola] NVARCHAR(MAX) NOT NULL
)
