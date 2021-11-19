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
