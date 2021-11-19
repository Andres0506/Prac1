CREATE PROCEDURE [dbo].[GetIvaPuntos]
	@id int

AS
	SELECT   iva,puntos  from Tipo_Producto where id_tipo = (select id_tipo from Producto where id_producto = @id )
RETURN 0
