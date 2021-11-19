CREATE PROCEDURE [dbo].[CrearCliente]
	@cc int,
	@nombre nvarchar(max),
	@telefono nvarchar(max),
	@email nvarchar(max),
	@direccion nvarchar(max),
	@fecha date
	
AS
	INSERT INTO Cliente (cc_cliente,  nombre_apellido_cliente, telefono_cliente, email_cliente,   direccion_cliente, fecha_nacimiento, puntos_acumulados )   VALUES ( @cc, @nombre,@telefono, @email, @direccion,@fecha, 0 )
RETURN 0
