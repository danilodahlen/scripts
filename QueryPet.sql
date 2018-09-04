CREATE DATABASE DB_PET
GO
USE DB_PET

GO	

delete tb_categoria
select * from tb_categoria

CREATE TABLE TB_USUARIOS
(ID_USUARIO				CHAR(12) PRIMARY KEY NOT NULL,
 NOME_USUARIO			VARCHAR(250) NOT NULL,
 APELIDO_USUARIO		VARCHAR(50) NOT NULL,
 DATA_NASCIMENTO		DATETIME NOT NULL,
 TEL_FIXO_DDD			VARCHAR(2) NULL,
 TEL_FIXO				VARCHAR(30) NULL,
 TEL_CELULAR_DDD		VARCHAR(2) NULL,
 TEL_CELULAR			VARCHAR(30) NULL,
 SEXO					VARCHAR(1) NULL,
 USUARIO_CUIDADOR		BIT NOT NULL DEFAULT 0,
 ENDERECO_CEP			CHAR(8) NULL,
 ENDERECO_RUA			VARCHAR(250) NULL,
 ENDERECO_NUMERO		VARCHAR(6) NULL,
 ENDERECO_BAIRRO		VARCHAR(100) NULL,
 ENDERECO_CIDADE		VARCHAR(100) NULL,
 ENDERECO_ESTADO		VARCHAR(2) NULL,
 ENDERECO_PAIS			VARCHAR(4) NULL,
 EMAIL_USUARIO			CHAR(100) NOT NULL,
 EMAIL_USUARIO_2		CHAR(100) NULL,
 STATUS_USUARIO			INT NOT NULL,
 DATA_CADASTRO			DATETIME NOT NULL,
 DATA_ALTERACAO			DATETIME NULL)

GO

CREATE TABLE TB_CATEGORIA
(ID_CATEGORIA			CHAR(4) PRIMARY KEY NOT NULL,
 NOME_CATEGORIA			VARCHAR(100) NOT NULL,
 MARKETPLACE			BIT NOT NULL DEFAULT 0,
 DATA_ALTERACAO			DATETIME NOT NULL,
 STATUS_CATEGORIA 		INT NOT NULL)

GO

CREATE TABLE TB_TIPO
(ID_CATEGORIA			CHAR(4) FOREIGN KEY (ID_CATEGORIA) REFERENCES TB_CATEGORIA(ID_CATEGORIA),
 ID_TIPO				CHAR(5) PRIMARY KEY,
 NOME_TIPO				VARCHAR(100),
 DATA_ALTERACAO			DATETIME,
 STATUS_TIPO_PET 		INT)

GO
	
CREATE TABLE TB_USUARIOS_PET
(ID_USUARIO		     		CHAR(12) FOREIGN KEY (ID_USUARIO) REFERENCES TB_USUARIOS(ID_USUARIO), 
 ID_PET						CHAR(5) PRIMARY KEY,
 NOME_PET					VARCHAR(250) NOT NULL,
 ID_CATEGORIA				CHAR(4) FOREIGN KEY (ID_CATEGORIA) REFERENCES TB_CATEGORIA(ID_CATEGORIA),  
 ID_TIPO					CHAR(5) FOREIGN KEY (ID_TIPO) REFERENCES TB_TIPO(ID_TIPO),  
 DOACAO						BIT NOT NULL DEFAULT 0,
 DESAPARECIDO				BIT NOT NULL DEFAULT 0,
 OBSERVACOES				VARCHAR(MAX) NULL,
 STATUS_PET					INT NOT NULL,
 DATA_ALTERACAO				DATETIME NOT NULL,
 DATA_CADASTRO				DATETIME NOT NULL)

 CREATE TABLE TB_USUARIOS_OBJETOS
 (ID_USUARIO		     	CHAR(12) FOREIGN KEY (ID_USUARIO) REFERENCES TB_USUARIOS(ID_USUARIO),
  ID_OBJETO					CHAR(6),
  NOME_OBJETO			    VARCHAR(250) NOT NULL,
  ID_CATEGORIA				CHAR(4) FOREIGN KEY (ID_CATEGORIA) REFERENCES TB_CATEGORIA(ID_CATEGORIA),  
  ID_TIPO					CHAR(5) FOREIGN KEY (ID_TIPO) REFERENCES TB_TIPO(ID_TIPO),  
  TITULO_OBJETO				VARCHAR(MAX) NULL,
  OBSERVACAO_1				VARCHAR(MAX) NULL,
  OBSERVACAO_2				VARCHAR(MAX) NULL,
  STATUS_OBJETO				INT NOT NULL,
  DATA_CADASTRO				DATETIME NOT NULL,
  DATA_ATUALIZACAO			DATETIME NOT NULL)

GO

CREATE TABLE TB_USUARIOS_PET_DESAPARECIDOS_CHECKIN
 (ID_USUARIO					CHAR(12) FOREIGN KEY (ID_USUARIO) REFERENCES TB_USUARIOS(ID_USUARIO), 
  ID_PET						CHAR(5) FOREIGN KEY (ID_PET) REFERENCES TB_USUARIOS_PET(ID_PET),  
  ID_CHECKIN					CHAR(5) PRIMARY KEY,
  GEOLOCALIZACAO_ALL			VARCHAR(250) NULL,
  GEOLOCALIZACAO_ALTITUDE		VARCHAR(250) NULL,
  GEOLOCALIZACAO_LONGITUDE		VARCHAR(250) NULL,
  DATA_CHECKING					DATETIME NOT NULL,
  STATUS_CHECKIN				INT NOT NULL)

GO

CREATE TABLE TB_USUARIOS_CUIDADOR_AVALIACOES
(ID_USUARIO_AVALIADOR		CHAR(12) FOREIGN KEY (ID_USUARIO_AVALIADOR) REFERENCES TB_USUARIOS(ID_USUARIO), 
 ID_USUARIO_AVALIADO		CHAR(12) FOREIGN KEY (ID_USUARIO_AVALIADO) REFERENCES TB_USUARIOS(ID_USUARIO), 
 MENSAGEM_AVALIACAO			VARCHAR(MAX) NOT NULL,
 NIVEL_ESTRELAS				INT		 NOT NULL,
 DATA_AVALIACAO				DATETIME NOT NULL,
 STATUS_AVALIACAO			INT		 NOT NULL)

GO

CREATE TABLE TB_USUARIOS_SENHA
(ID_USUARIO			CHAR(12) FOREIGN KEY (ID_USUARIO) REFERENCES TB_USUARIOS(ID_USUARIO),
 SENHA_USUARIO		VARCHAR(50))

GO

CREATE TABLE TB_TIPO_ARQUIVOS
(TIPO_ARQUIVO		VARCHAR(2) PRIMARY KEY NOT NULL,
 NOME_TIPO_ARQUIVO	VARCHAR(250))

INSERT TB_TIPO_ARQUIVOS
VALUES('01','FOTO PERFIL'),
	  ('02','FOTO PET'),
	  ('03','FOTO DOACAO'),
	  ('04','FOTO PUBLICACAO')

GO

CREATE TABLE TB_USUARIOS_ARQUIVOS
(ID_USUARIO			CHAR(12) FOREIGN KEY (ID_USUARIO) REFERENCES TB_USUARIOS(ID_USUARIO),	
 ID_ARQUIVO			INT PRIMARY KEY,
 ID_OBJETO			CHAR(6) NULL FOREIGN KEY (ID_OBJETO) REFERENCES TB_USUARIOS_PET(ID_OBJETO),
 ID_PET				CHAR(5) NULL FOREIGN KEY (ID_PET) REFERENCES TB_USUARIOS_PET(ID_PET),	
 TIPO_ARQUIVO		VARCHAR(2) FOREIGN KEY (TIPO_ARQUIVO) REFERENCES TB_TIPO_ARQUIVOS(TIPO_ARQUIVO),	
 NOME_ARQUIVO		CHAR(250) NOT NULL,
 PASTA_ARQUIVO		VARCHAR(MAX) NOT NULL,
 ARQUIVO			VARCHAR(MAX) NOT NULL,
 FORMATO_ARQUIVO	VARCHAR(10) NOT NULL,
 DATA_INCLUSAO		DATETIME NOT NULL,
 DATA_ALTERACAO		DATETIME NULL,
 STATUS_ARQUIVO		INT NOT NULL)

GO

CREATE TABLE TB_PUBLICACAO
(ID_PUBLICACAO			INT PRIMARY KEY,	  
 ID_AUTOR_PUBLICACAO    CHAR(12) FOREIGN KEY (ID_AUTOR_PUBLICACAO) REFERENCES TB_USUARIOS(ID_USUARIO), 
 ID_ARQUIVO				INT FOREIGN KEY (ID_ARQUIVO) REFERENCES TB_USUARIOS_ARQUIVOS(ID_ARQUIVO),
 TITULO_PUBLICACAO		VARCHAR(250) NOT NULL,
 TEXTO_PUBLICACAO       VARCHAR(MAX) NULL,
 STATUS_PUBLICACAO		INT NOT NULL,
 DATA_PUBLICACAO		DATETIME NOT NULL,
 DATA_ALTERACAO			DATETIME NOT NULL)

 GO

 CREATE TABLE TB_PUBLICACAO_COMENTARIO
 (ID_PUBLICACAO			INT FOREIGN KEY (ID_PUBLICACAO) REFERENCES TB_PUBLICACAO(ID_PUBLICACAO),
  ID_AUTOR_PUBLICACAO   CHAR(12) FOREIGN KEY (ID_AUTOR_PUBLICACAO) REFERENCES TB_USUARIOS(ID_USUARIO),
  ID_AUTOR_COMENTARIO   CHAR(12) FOREIGN KEY (ID_AUTOR_COMENTARIO) REFERENCES TB_USUARIOS(ID_USUARIO),
  ID_SEQUENCIA			INT PRIMARY KEY,
  TEXTO_COMENTARIO		VARCHAR(MAX) NULL,
  STATUS_COMENTARIO		INT NOT NULL,
  DATA_COMENTARIO		DATETIME NOT NULL)

GO

CREATE TABLE TB_TIPO_CURTIDA
(TIPO_CURTIDA	INT PRIMARY KEY NOT NULL,
 NOME_CURTIDA	VARCHAR(250))

INSERT TB_TIPO_CURTIDA
VALUES(1,'FELIZ'),
	  (2,'TRISTE')

CREATE TABLE TB_PUBLICACAO_CURTIDA
(ID_PUBLICACAO			INT FOREIGN KEY (ID_PUBLICACAO) REFERENCES TB_PUBLICACAO(ID_PUBLICACAO), 
 ID_AUTOR_PUBLICACAO    CHAR(12) FOREIGN KEY (ID_AUTOR_PUBLICACAO) REFERENCES TB_USUARIOS(ID_USUARIO), --FOREIGN KEY/PRIMARY KEY,
 ID_AUTOR_CURTIDA       CHAR(12) FOREIGN KEY (ID_AUTOR_CURTIDA) REFERENCES TB_USUARIOS(ID_USUARIO), --FOREIGN KEY/PRIMARY KEY,
 TIPO_CURTIDA			INT NOT NULL,  
 DATA_CURTIDA			DATETIME NOT NULL,
 STATUS_CURTIDA			INT NOT NULL)

 GO
 
CREATE TABLE TB_SEGUIR_USUARIO
(ID_USUARIO_SOLICITANTE		CHAR(12) FOREIGN KEY (ID_USUARIO_SOLICITANTE) REFERENCES TB_USUARIOS(ID_USUARIO), --FOREIGN KEY/PRIMARY KEY
 ID_USUARIO_CONVIDADO		CHAR(12) FOREIGN KEY (ID_USUARIO_CONVIDADO) REFERENCES TB_USUARIOS(ID_USUARIO), --FOREIGN KEY/PRIMARY KEY
 SITUACAO_SEGUIR			INT NOT NULL,
 DATA_SOLICITACACAO			DATETIME NOT NULL,
 DATA_ACEITO				DATETIME NULL)	

 GO
 
 CREATE TABLE TB_TIPO_NOTIFICACAO
 (ID_TIPO_NOTIFICACAO	INT NOT NULL PRIMARY KEY ,
  NOME_NOTIFICACAO		VARCHAR(250) NOT NULL)

 GO

 CREATE TABLE TB_NOTIFICACOES
 (ID_USUARIO			CHAR(12) NOT NULL FOREIGN KEY (ID_USUARIO) REFERENCES TB_USUARIOS(ID_USUARIO),
  ID_SEQUENCIA			INT NOT NULL,
  ID_TIPO_NOTIFICACAO	INT NOT NULL FOREIGN KEY (ID_TIPO_NOTIFICACAO) REFERENCES TB_USUARIOS(ID_TIPO_NOTIFICACAO),
  LIDO					BIT NOT NULL DEFAULT 0,
  DATA_NOTIFICACAO      DATETIME NOT NULL,
  DATA_LIDO				DATETIME NOT NULL)






  


