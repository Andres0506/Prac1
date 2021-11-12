CREATE PROCEDURE [dbo].[VerProductoGondola]
	@codProd int
	
AS
	SELECT cantidad_gondola,sección_gondola FROM LugarStock WHERE barcode_producto=@codProd
RETURN 0
