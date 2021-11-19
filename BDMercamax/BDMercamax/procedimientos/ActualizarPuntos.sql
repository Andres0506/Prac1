CREATE PROCEDURE [dbo].[ActualizarPuntos]
	@n int,
	@id int
AS
	UPDATE Cliente set puntos_acumulados= puntos_acumulados-@n  where cc_cliente= @id
RETURN 0
