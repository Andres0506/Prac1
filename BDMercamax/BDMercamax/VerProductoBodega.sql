CREATE PROCEDURE [dbo].[VerProductoBodega]
	@codProd int 
	
AS
	SELECT cantidad_bodega, seccion_bodega fROM LugarStock WHERE barcode_producto=@codProd
RETURN 0
 