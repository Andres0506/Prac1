CREATE TABLE [dbo].[Venta]
(
	 
    [barcode_producto] INT NOT NULL UNIQUE, 
    [cantidad] INT NOT NULL, 
    [id_factura] INT NOT NULL, 
    CONSTRAINT [FK_Venta_ToTable] FOREIGN KEY ([id_factura]) REFERENCES [Facturacion]([id_factura])
)
