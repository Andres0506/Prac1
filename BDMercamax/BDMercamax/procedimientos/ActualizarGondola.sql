CREATE PROCEDURE [dbo].[ActualizarGondola]
	@id int,
	@n int
AS
	UPDATE LugarStock set cantidad_gondola= cantidad_gondola-@n where barcode_producto= (select barcode from Producto where id_producto=@id )
RETURN 0
