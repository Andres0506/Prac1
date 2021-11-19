CREATE VIEW [dbo].[VerClientes]
	As
	select  cc_cliente ,nombre_apellido_cliente, puntos_acumulados from Cliente;
