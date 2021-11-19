CREATE TABLE [dbo].[LugarStock]
(
 
    [barcode_producto] INT NOT NULL UNIQUE PRIMARY KEY, 
    [cantidad_bodega] INT NOT NULL, 
    [cantidad_gondola] INT NOT NULL, 
    [seccion_bodega] NVARCHAR(MAX) NOT NULL, 
    [seccion_gondola] NVARCHAR(MAX) NOT NULL
)
