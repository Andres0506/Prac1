CREATE TABLE [dbo].[CURSO]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [Nombre] NVARCHAR(50) NULL, 
    [Fecha_Inicio] NVARCHAR(50) NOT NULL, 
    [Duracion] INT NOT NULL, 
    [Valor] INT NOT NULL
)
