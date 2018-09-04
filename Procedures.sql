CREATE DATABASE DB_PET
GO
USE DB_PET

GO

CREATE PROCEDURE [dbo].[Proc_GravarUsuario]
(	
	@id_usuario			CHAR(12),
	@nome_usuario		VARCHAR(250),	
	@apelido_usuario	VARCHAR(30),
	@data_nascimento	DATETIME,
	@email_usuario		VARCHAR(100),
	@email_usuario_2	VARCHAR(100),
	@tel_fixo_ddd		VARCHAR(5),	
	@tel_fixo			VARCHAR(12),
	@tel_celular_ddd	VARCHAR(5),
	@tel_celular		VARCHAR(12),
	@usuario_cuidador	BIT,
	@endereco_cep		CHAR(8),	
	@endereco_rua		VARCHAR(250),
	@endereco_numero	VARCHAR(6),
	@endereco_bairro	VARCHAR(100),
	@endereco_cidade	VARCHAR(100),
	@endereco_estado	VARCHAR(2),
	@endereco_pais		VARCHAR(4),
	@operacao			INT
)
AS
BEGIN

	BEGIN TRY
		IF @operacao = 1 AND @id_usuario IS NULL BEGIN
	
			IF EXISTS(SELECT 1
					    FROM TB_USUARIOS 
					   WHERE TB_USUARIOS.EMAIL_USUARIO = @email_usuario) BEGIN

				SELECT '0Email já cadastrado'
				GOTO FIM

			END

			SELECT @id_usuario = [dbo].[nfn__kernel_CriarIDs](MAX(TB_USUARIOS.ID_USUARIO),12)
			 FROM  TB_USUARIOS

			INSERT TB_USUARIOS	
			(ID_USUARIO,			
			 NOME_USUARIO,		
			 APELIDO_USUARIO,	
			 DATA_NASCIMENTO,	
			 EMAIL_USUARIO,		
			 EMAIL_USUARIO_2,	
			 TEL_FIXO_DDD,		
			 TEL_FIXO,			
			 TEL_CELULAR_DDD,	
			 TEL_CELULAR,		
			 USUARIO_CUIDADOR,	
			 ENDERECO_CEP,		
			 ENDERECO_RUA,		
			 ENDERECO_NUMERO,	
			 ENDERECO_BAIRRO,	
			 ENDERECO_CIDADE,	
			 ENDERECO_ESTADO,	
			 ENDERECO_PAIS,
			 STATUS_USUARIO,
			 DATA_CADASTRO,
			 DATA_ALTERACAO)
			 VALUES(
			 @id_usuario,
			 @nome_usuario,		
			 @apelido_usuario,
			 @data_nascimento,	
			 @email_usuario,
			 @email_usuario_2,
			 @tel_fixo_ddd,
			 @tel_fixo,			
			 @tel_celular_ddd,
			 @tel_celular,		
			 @usuario_cuidador,	
			 @endereco_cep,		
			 @endereco_rua,		
			 @endereco_numero,	
			 @endereco_bairro,	
			 @endereco_cidade,	
			 @endereco_estado,	
			 @endereco_pais,		
			 1,
			 GETDATE(),
			 GETDATE())

		END
		ELSE IF @operacao = 2 AND @id_usuario IS NOT NULL BEGIN

			UPDATE TB_USUARIOS
			SET    NOME_USUARIO		= @nome_usuario		,
				   APELIDO_USUARIO  = @apelido_usuario	,
				   DATA_NASCIMENTO	= @data_nascimento	,
				   TEL_FIXO			= @tel_fixo			,
				   TEL_CELULAR		= @tel_celular		,
				   USUARIO_CUIDADOR	= @usuario_cuidador	,
				   ENDERECO_CEP		= @endereco_cep		,
				   ENDERECO_RUA		= @endereco_rua		,
				   ENDERECO_NUMERO	= @endereco_numero	,
				   ENDERECO_BAIRRO	= @endereco_bairro	,
				   ENDERECO_CIDADE	= @endereco_cidade	,
				   ENDERECO_ESTADO	= @endereco_estado	,
				   ENDERECO_PAIS	= @endereco_pais	,
				   EMAIL_USUARIO	= @email_usuario	,
				   EMAIL_USUARIO_2	= @email_usuario_2	,
				   STATUS_USUARIO	= 1					,
				   DATA_ALTERACAO	= GETDATE()	 
			 WHERE ID_USUARIO		=  @id_usuario

		END
		ELSE IF @operacao = 3 AND @id_usuario IS NOT NULL BEGIN

			UPDATE TB_USUARIOS
			 SET   STATUS_USUARIO	= 0,
				   DATA_ALTERACAO	= GETDATE()	 
			 WHERE ID_USUARIO		=  @id_usuario

		END
	END TRY
	BEGIN CATCH
		SELECT '0Erro ao salvar na operacao ' + @operacao + ' - ' + ERROR_MESSAGE()
		GOTO FIM
	END CATCH

	SELECT '1' + @id_usuario

	FIM:
END

GO


ALTER PROCEDURE [dbo].[Proc_GravarCategoria]
(	
	@id_categoria		CHAR(4),
	@nome_categoria		VARCHAR(100),
	@operacao			INT			
)
AS
BEGIN

	BEGIN TRY
		
		IF @operacao = 1 AND @id_categoria IS NULL BEGIN
				
			SELECT @id_categoria = [dbo].[nfn__kernel_CriarIDs](MAX(ID_CATEGORIA),4)
			 FROM  TB_CATEGORIA

			INSERT TB_CATEGORIA
			(ID_CATEGORIA,		
			 NOME_CATEGORIA,		
			 DATA_ALTERACAO,		
			 STATUS_CATEGORIA)
			VALUES(
			 @id_categoria,	
			 @nome_categoria,
			 GETDATE(),
			 1)
				
		END
		IF @operacao = 2 AND @id_categoria IS  NOT NULL BEGIN
			
			 UPDATE TB_CATEGORIA
				SET DATA_ALTERACAO		= GETDATE(),
					STATUS_CATEGORIA	= 1,
					NOME_CATEGORIA		= @nome_categoria
			  WHERE ID_CATEGORIA		= @id_categoria

		END
		IF @operacao = 3 AND @id_categoria IS NOT NULL BEGIN

			UPDATE TB_CATEGORIA
			   SET DATA_ALTERACAO	= GETDATE(),
				   STATUS_CATEGORIA	= 0,
				   NOME_CATEGORIA	= @nome_categoria
			 WHERE ID_CATEGORIA		= @id_categoria

		END
	END TRY
	BEGIN CATCH
		SELECT '0Erro ao salvar na operacao ' + @operacao + ' - ' + ERROR_MESSAGE()
		GOTO FIM
	END CATCH

	SELECT '1' + @id_categoria
	FIM:
END

GO

CREATE PROCEDURE [dbo].[Proc_GravarTipoCategoria]
(
	@id_categoria		CHAR(4),
	@id_tipo_pet		CHAR(5),
	@nome_tipo_pet		VARCHAR(100),
	@operacao			INT				
)
AS
BEGIN

	BEGIN TRY
		IF @operacao = 1 AND @id_tipo_pet IS NULL BEGIN
		
			SELECT @id_tipo_pet = [dbo].[nfn__kernel_CriarIDs](MAX(ID_TIPO_PET),5)
			 FROM  TB_TIPO_PET
			 WHERE ID_CATEGORIA = @id_categoria

			INSERT TB_TIPO_PET
			(ID_CATEGORIA,		
			 ID_TIPO_PET,		
			 NOME_TIPO_PET,		
			 DATA_ALTERACAO,		
			 STATUS_CATEGORIA)
			 VALUES(
			 @id_categoria,		
			 @id_tipo_pet,		
			 @nome_tipo_pet,
			 GETDATE(),
			 1)
		END
		IF @operacao = 2 AND @id_tipo_pet IS NOT NULL BEGIN
			
			UPDATE TB_TIPO_PET 
			   SET NOME_TIPO_PET	= @nome_tipo_pet,
				   DATA_ALTERACAO	= GETDATE(),
				   STATUS_CATEGORIA	= 1   	      
			WHERE ID_CATEGORIA = @id_categoria
			 AND  ID_TIPO_PET  = @id_tipo_pet

		END
		IF @operacao = 3 AND @id_tipo_pet IS NOT NULL BEGIN
			
			UPDATE TB_TIPO_PET 
			   SET DATA_ALTERACAO	= GETDATE(),
				   STATUS_CATEGORIA	= 0   	      
			WHERE ID_CATEGORIA = @id_categoria
			 AND  ID_TIPO_PET  = @id_tipo_pet

		END
	END TRY
	BEGIN CATCH
		SELECT '0Erro ao salvar na operacao ' + @operacao + ' - ' + ERROR_MESSAGE()
		GOTO FIM
	END CATCH

	SELECT '1' + @id_tipo_pet
	FIM:
END

GO

CREATE PROCEDURE [dbo].[Proc_GravarPetsUsuarios]
(
	@id_usuario				CHAR(12), 	
	@id_pet					CHAR(5),		
	@nome_pet				VARCHAR(250),	
	@id_categoria			CHAR(4),	
	@id_tipo_pet			CHAR(5),
	@doacao					BIT,
	@desaparecido			BIT,
	@observacoes			VARCHAR(MAX),
	@operacao				INT
)
AS
BEGIN

	BEGIN TRY
		IF @operacao = 1 AND @id_pet IS NULL BEGIN

			SELECT @id_pet = [dbo].[nfn__kernel_CriarIDs](MAX(ID_PET),5)
			 FROM  TB_USUARIOS_PET
			 WHERE ID_USUARIO_AVALIADO = @id_usuario_avaliado
			
			INSERT TB_USUARIOS_PET
			(ID_USUARIO_AVALIADO,
			 ID_PET,				
			 NOME_PET,			
			 ID_CATEGORIA,		
			 ID_TIPO_PET,		
			 DOACAO,					
			 DESAPARECIDO,			
			 OBSERVACOES,			
			 STATUS_PET,			
			 DATA_ALTERACAO)
			VALUES(
			 @id_usuario_avaliado,
			 @id_pet,				
			 @nome_pet,			
			 @id_categoria,		
			 @id_tipo_pet,		
			 @doacao,					
			 @desaparecido,			
			 @observacoes,			
			 1,
			 GETDATE())
						
		END
		ELSE IF @operacao = 2 AND @id_pet IS NOT NULL BEGIN
		
			UPDATE TB_USUARIOS_PET
			   SET NOME_PET			= @nome_pet		,	
			       ID_CATEGORIA		= @id_categoria	,	
			       ID_TIPO_PET		= @id_tipo_pet	,	
			       DOACAO			= @doacao		,							
				   DESAPARECIDO		= @desaparecido ,			
				   OBSERVACOES		= @observacoes	,			
			       STATUS_PET		= 1				,	
			       DATA_ALTERACAO	= GETDATE()	
			 WHERE ID_USUARIO_AVALIADO = @id_usuario_avaliado
			   AND ID_PET			   = @id_pet

		END 
		ELSE IF @operacao = 3 BEGIN
			
			UPDATE TB_USUARIOS_PET
				   STATUS_PET			= 0,	
			       DATA_ALTERACAO		= GETDATE()
			 WHERE ID_USUARIO_AVALIADO  = @id_usuario_avaliado
			   AND ID_PET			    = @id_pet

		END
	END TRY
	BEGIN CATCH
		SELECT '0Erro ao salvar na operacao ' + @operacao + ' - ' + ERROR_MESSAGE()
		GOTO FIM
	END CATCH 
	
	SELECT '1' + @id_pet
	FIM:
END

GO

CREATE PROCEDURE [dbo].[Proc_GravarCuidadorAvaliacoes]
(
	@id_usuario_avaliador	CHAR(12),
	@id_usuario_avaliado	CHAR(12),
	@mensagem_avaliacao		VARCHAR(MAX),
	@nivel_estrelas			INT,
	@operacao				INT		
)
AS
BEGIN

	BEGIN TRY 
		IF @operacao = 1 BEGIN

			INSERT TB_USUARIOS_CUIDADOR_AVALIACOES
			(ID_USUARIO_AVALIADOR,
			 ID_USUARIO_AVALIADO,
			 MENSAGEM_AVALIACAO,
			 NIVEL_ESTRELAS,		
			 DATA_AVALIACAO,	
			 STATUS_AVALIACAO)
			VALUES(
			 @id_usuario_avaliador,
			 @id_usuario_avaliado,
			 @mensagem_avaliacao,	
			 @nivel_estrelas,		
			 GETDATE(),
			 1)

		END
		IF @operacao = 3 BEGIN

			UPDATE TB_USUARIOS_CUIDADOR_AVALIACOES
			   SET STATUS_AVALIACAO = 0
			 WHERE ID_USUARIO_AVALIADOR = @id_usuario_avaliador
			  AND  ID_USUARIO_AVALIADO  = @id_usuario_avaliado
		  
		END
	END TRY
	BEGIN CATCH
		SELECT '0Erro ao salvar na operacao ' + @operacao + ' - ' + ERROR_MESSAGE()
	END CATCH

	SELECT '1'
	FIM:
END

GO

CREATE PROCEDURE [dbo].[Proc_GravarSenha]
(	
	@id_usuario			CHAR(12),
	@senha_usuario		VARCHAR(50),
	@operacao			INT		
)
AS
BEGIN

	BEGIN TRY

		IF @operacao = 1 OR NOT EXISTS(SELECT 1
											 FROM TB_USUARIOS_SENHA
											WHERE ID_USUARIO    = @id_usuario) BEGIN

			INSERT TB_USUARIOS_SENHA
			(ID_USUARIO,		
			 SENHA_USUARIO)
			 VALUES(
			 @id_usuario,			
			 @senha_usuario)

		END 
		IF @operacao = 2 BEGIN

			UPDATE TB_USUARIOS_SENHA
			   SET SENHA_USUARIO = @senha_usuario 
			 WHERE ID_USUARIO    = @id_usuario

		END
	END TRY
	BEGIN CATCH
		SELECT '0Erro ao salvar na operacao ' + @operacao + ' - ' + ERROR_MESSAGE()
	END CATCH

	SELECT '1'

	FIM:
END

GO

CREATE PROCEDURE [dbo].[Proc_GravarArquivos]
(
	@id_usuario			CHAR(12),
	@id_arquivo			INT,	
	@tipo_arquivo		VARCHAR(1),	
	@nome_arquivo		VARCHAR(250),
	@formato_arquivo	VARCHAR(10),
	@operacao			INT
)
AS
BEGIN
	
	BEGIN TRY

		IF @operacao = 1 AND @id_arquivo IS NULL BEGIN 
			
			INSERT TB_USUARIOS_ARQUIVOS
			(ID_USUARIO,		
			 ID_ARQUIVO,		
			 TIPO_ARQUIVO,	
			 NOME_ARQUIVO,	
			 FORMATO_ARQUIVO,
			 DATA_ALTERACAO,	
			 STATUS_ARQUIVO	)	
			 VALUES(
			 @id_usuario,		
			 @id_arquivo,		
			 @tipo_arquivo,	
			 @nome_arquivo,	
			 @formato_arquivo,
			 GETDATE(),
			 1)
			
		END
		IF @operacao = 3 AND @id_arquivo IS NOT NULL BEGIN 
			
			UPDATE TB_USUARIOS_ARQUIVOS
			   SET DATA_ALTERACAO  = GETDATE()
			 WHERE ID_USUARIO	   = @id_usuario  
			   AND ID_ARQUIVO	   = @id_arquivo

		END

	END TRY
	BEGIN CATCH
		SELECT '0Erro ao salvar na operacao ' + @operacao + ' - ' + ERROR_MESSAGE()
	END CATCH

	SELECT '1' + @id_arquivo
	FIM:

END

GO

CREATE PROCEDURE [dbo].[Proc_GravarSolicitacaoAmizade]
(
	@id_usuario_solicitante		CHAR(12),
	@id_usuario_convidado		CHAR(12),	
	@aceito						BIT,
	@operacao					INT
)
AS
BEGIN

	BEGIN TRY

		IF @operacao = 1 BEGIN
			
			INSERT TB_SOLICITACAO_AMIZADE	
			(ID_USUARIO_SOLICITANTE,		
			 ID_USUARIO_CONVIDADO,		
			 ACEITO,						
			 DATA_SOLICITACACAO,			
			 DATA_ACEITO)
			 VALUES(
			 @id_usuario_solicitante,		
			 @id_usuario_convidado,		
			 NULL,
			 GETDATE(),
			 NULL)

		END
		IF @operacao = 2 BEGIN

			UPDATE TB_SOLICITACAO_AMIZADE
			   SET ACEITO		= 1,
				   DATA_ACEITO  = GETDATE()
			 WHERE ID_USUARIO_SOLICITANTE = @id_usuario_solicitante
			  AND  ID_USUARIO_CONVIDADO	  = @id_usuario_convidado
		END

	END TRY
	BEGIN CATCH
		SELECT '0Erro ao salvar na operacao ' + @operacao + ' - ' + ERROR_MESSAGE()
	END CATCH
	SELECT '1'
	FIM:		

END	

GO

CREATE PROCEDURE [dbo].[Proc_GravarPublicacaoCurtida]
(
 @id_publicacao			INT,
 @id_autor_publicacao	CHAR(12),
 @id_autor_curtida		CHAR(12),
 @tipo_curtida			INT,
 @operacao				INT
)
AS
BEGIN

	BEGIN TRY

	IF @operacao = 1 BEGIN

		INSERT TB_PUBLICACAO_CURTIDA
		(ID_PUBLICACAO		,
		 ID_AUTOR_PUBLICACAO,
		 ID_AUTOR_CURTIDA   ,
		 TIPO_CURTIDA		,
		 DATA_CURTIDA		,
		 STATUS_CURTIDA		)
		 VALUES(
		 @id_publicacao,			
		 @id_autor_publicacao,	
		 @id_autor_curtida,		
		 @tipo_curtida,			
		 GETDATE(),			
		 1)

	END
	IF @operacao = 2 BEGIN

		UPDATE TB_PUBLICACAO_CURTIDA
		   SET TIPO_CURTIDA			= @tipo_curtida,		
		       DATA_CURTIDA			= GETDATE(),
		       STATUS_CURTIDA		= 1	
	     WHERE ID_PUBLICACAO		= @id_publicacao			
		  AND  ID_AUTOR_PUBLICACAO	= @id_autor_publicacao	
		  AND  ID_AUTOR_CURTIDA		= @id_autor_curtida

	END
	IF @operacao = 3 BEGIN
		
		UPDATE TB_PUBLICACAO_CURTIDA
		   SET STATUS_CURTIDA		= 0	
	     WHERE ID_PUBLICACAO		= @id_publicacao			
		  AND  ID_AUTOR_PUBLICACAO	= @id_autor_publicacao	
		  AND  ID_AUTOR_CURTIDA		= @id_autor_curtida

	END	
	END TRY
	BEGIN CATCH
		
		SELECT '0Problemas ao gravar a curtida' + ERROR_MESSAGE()
		GOTO FIM
	END CATCH

	SELECT '1'
	FIM:

END

GO

CREATE PROCEDURE [dbo].[Proc_GravarPublicacaoComentario]
(
	@id_publicacao			INT,
	@id_autor_publicacao	CHAR(12),
	@id_autor_comentario	CHAR(12),
	@id_sequencia			INT,
	@texto_comentario		VARCHAR(MAX),
	@operacao				INT 	
)
AS
BEGIN

	BEGIN TRY

		IF @operacao = 1 AND @id_sequencia IS NULL BEGIN

			 SELECT @id_sequencia = [dbo].[nfn__kernel_CriarIDs](MAX(ID_SEQUENCIA))
			 FROM  TB_PUBLICACAO_COMENTARIO
			 WHERE ID_PUBLICACAO		= @id_publicacao		   
			  AND  ID_AUTOR_PUBLICACAO  = @id_autor_publicacao
			  AND  ID_AUTOR_COMENTARIO  = @id_autor_comentario


			INSERT TB_PUBLICACAO_COMENTARIO
			(ID_PUBLICACAO		   ,
			 ID_AUTOR_PUBLICACAO   ,
			 ID_AUTOR_COMENTARIO   ,
			 ID_SEQUENCIA		   ,
			 TEXTO_COMENTARIO	   ,
			 STATUS_COMENTARIO	   ,
			 DATA_COMENTARIO)
			 VALUES(
			 @id_publicacao,			
			 @id_autor_publicacao,	
			 @id_autor_comentario,	
			 @id_sequencia,			
			 @texto_comentario,
			 1,
			 GETDATE())

		END
		IF @operacao = 3 AND @id_sequencia IS NOT NULL BEGIN

			UPDATE TB_PUBLICACAO_COMENTARIO
			   SET STATUS_COMENTARIO   = 0	
			 WHERE ID_PUBLICACAO	   = @id_publicacao
			   AND ID_AUTOR_PUBLICACAO = @id_autor_publicacao
			   AND ID_AUTOR_COMENTARIO = @id_autor_comentario
			   AND ID_SEQUENCIA		   = @id_sequencia
			 
		END	

	END TRY
	BEGIN CATCH
		
		SELECT '0Problemas ao gravar o comentario' + ERROR_MESSAGE()
		GOTO FIM
	END CATCH

END

GO

CREATE PROCEDURE [dbo].[Proc_GravarPublicacao]	
(
	@id_publicacao			INT,
	@id_autor_publicacao	CHAR(12),
	@id_arquivo				INT,
	@titulo_publicacao		VARCHAR(250),
	@texto_publicacao		VARCHAR(MAX),
	@operacao				INT
)
AS
BEGIN
	
	BEGIN TRY

		IF @operacao = 1 AND @id_publicacao IS NULL BEGIN

			INSERT TB_PUBLICACAO
			(ID_PUBLICACAO,		
			 ID_AUTOR_PUBLICACAO,
			 ID_ARQUIVO,			
			 TITULO_PUBLICACAO,	
			 TEXTO_PUBLICACAO,   
			 STATUS_PUBLICACAO,	
			 DATA_PUBLICACAO,
			 DATA_ALTERACAO)
			VALUES(
			 @id_publicacao,		
			 @id_autor_publicacao,
			 @id_arquivo,			
			 @titulo_publicacao,	
			 @texto_publicacao,
			 1,
			 GETDATE(),
			 GETDATE())
			 	
		END
		IF @operacao = 2 AND @id_publicacao IS NOT NULL BEGIN
		
			UPDATE TB_PUBLICACAO
			   SET ID_ARQUIVO			= @id_arquivo,
				   TITULO_PUBLICACAO	= @titulo_publicacao,
				   TEXTO_PUBLICACAO		= @texto_publicacao,
				   DATA_ALTERACAO		= GETDATE()
			 WHERE ID_PUBLICACAO		= @id_publicacao			
			  AND  ID_AUTOR_PUBLICACAO	= @id_autor_publicacao
			
		END
		IF @operacao = 3 AND @id_publicacao IS NOT NULL BEGIN
			
			UPDATE TB_PUBLICACAO
			   SET STATUS_PUBLICACAO    = 0,
				   DATA_ALTERACAO		= GETDATE()
			 WHERE ID_PUBLICACAO		= @id_publicacao			
			  AND  ID_AUTOR_PUBLICACAO	= @id_autor_publicacao

		END
	END TRY
	BEGIN CATCH
		
		SELECT '0Problemas ao gravar a curtida' + ERROR_MESSAGE()
		GOTO FIM

	END CATCH
	
	SELECT '1'
	FIM:
END

GO
------------------------------ Retorno ws -------------------------------------
CREATE PROCEDURE [dbo].[Proc_ws_retornaDoacoes]
(
	@atual_estado	VARCHAR(2),
	@atual_cidade	VARCHAR(100)
)
AS
BEGIN
	
	SELECT TB_USUARIOS_PET.ID_USUARIO,		
		   TB_USUARIOS_PET.ID_PET,			
		   TB_USUARIOS_PET.NOME_PET,		
		   TB_USUARIOS_PET.ID_CATEGORIA,	
		   TB_USUARIOS_PET.ID_TIPO_PET,	
		   TB_USUARIOS_PET.DOACAO,			
		   TB_USUARIOS_PET.OBSERVACOES,
		   TB_CATEGORIA.NOME_CATEGORIA,
		   TB_TIPO_PET.NOME_TIPO_PET
	  FROM TB_USUARIOS_PET
INNER JOIN TB_CATEGORIA
		ON TB_CATEGORIA.ID_CATEGORIA = TB_USUARIOS_PET.ID_CATEGORIA
INNER JOIN TB_TIPO_PET
		ON TB_TIPO_PET.ID_CATEGORIA	 = TB_USUARIOS_PET.ID_CATEGORIA
	   AND TB_TIPO_PET.ID_TIPO_PET	 = TB_USUARIOS_PET.ID_TIPO_PET
	 WHERE DOACAO = 1				

END

GO

CREATE PROCEDURE [dbo].[Proc_ws_retornaDesaparecido]
(
	@atual_estado	VARCHAR(2),
	@atual_cidade	VARCHAR(100)
)
AS
BEGIN
	
	SELECT TB_USUARIOS_PET.ID_USUARIO,		
		   TB_USUARIOS_PET.ID_PET,			
		   TB_USUARIOS_PET.NOME_PET,		
		   TB_USUARIOS_PET.ID_CATEGORIA,	
		   TB_USUARIOS_PET.ID_TIPO_PET,	
		   TB_USUARIOS_PET.DESAPARECIDO,			
		   TB_USUARIOS_PET.OBSERVACOES,
		   TB_CATEGORIA.NOME_CATEGORIA,
		   TB_TIPO_PET.NOME_TIPO_PET
	  FROM TB_USUARIOS_PET
INNER JOIN TB_CATEGORIA
		ON TB_CATEGORIA.ID_CATEGORIA = TB_USUARIOS_PET.ID_CATEGORIA
INNER JOIN TB_TIPO_PET
		ON TB_TIPO_PET.ID_CATEGORIA	 = TB_USUARIOS_PET.ID_CATEGORIA
	   AND TB_TIPO_PET.ID_TIPO_PET	 = TB_USUARIOS_PET.ID_TIPO_PET
	 WHERE DESAPARECIDO = 1				

END

GO

CREATE PROCEDURE [dbo].[Proc_ws_retornaPublicacao]
(
	@id_publicacao			INT,
	@id_autor_publicacao	CHAR(12),
	@perfil					BIT 
)
AS
BEGIN

	SELECT ID_PUBLICACAO,		
		   ID_AUTOR_PUBLICACAO,
		   ID_ARQUIVO,			
		   TITULO_PUBLICACAO,	
		   TEXTO_PUBLICACAO,
		   DATA_PUBLICACAO
	  FROM TB_PUBLICACAO	
	 WHERE ((@id_publicacao IS NULL) OR (ID_PUBLICACAO			= @id_publicacao))
	  AND  ((@perfil			= 0) OR (ID_AUTOR_PUBLICACAO	= @id_autor_publicacao))
				    
END

GO

CREATE PROCEDURE [dbo].[Proc_ws_retornaComentario]
(
	@id_publicacao			INT
)
AS
BEGIN

	SELECT ID_PUBLICACAO,			
		   ID_AUTOR_PUBLICACAO,   
		   ID_AUTOR_COMENTARIO,   
		   ID_SEQUENCIA,			
		   TEXTO_COMENTARIO,
		   TB_AUTOR_PUBLICACAO.APELIDO_USUARIO AS APELIDO_USUARIO_PUB,
		   TB_AUTOR_PUBLICACAO.NOME_USUARIO AS NOME_USUARIO_PUB,
		   TB_AUTOR_COMENTARIO.APELIDO_USUARIO AS APELIDO_USUARIO_COMENTARIO,
		   TB_AUTOR_COMENTARIO.NOME_USUARIO AS NOME_USUARIO_COMENTARIO
	  FROM TB_PUBLICACAO_COMENTARIO
INNER JOIN TB_USUARIOS AS TB_AUTOR_PUBLICACAO
		ON TB_AUTOR_PUBLICACAO.ID_USUARIO	= TB_PUBLICACAO_COMENTARIO.ID_AUTOR_PUBLICACAO
INNER JOIN TB_USUARIOS AS TB_AUTOR_COMENTARIO
		ON TB_AUTOR_COMENTARIO.ID_USUARIO	= TB_PUBLICACAO_COMENTARIO.ID_AUTOR_PUBLICACAO

	 WHERE ((@id_publicacao IS NULL) OR (ID_PUBLICACAO			= @id_publicacao))
  ORDER BY ID_SEQUENCIA 
				    
END

GO

CREATE PROCEDURE [dbo].[Proc_ws_retornaCurtida]
(
	@id_publicacao			INT
)
AS
BEGIN

	SELECT TB_PUBLICACAO_CURTIDA.ID_PUBLICACAO,			
		   TB_PUBLICACAO_CURTIDA.ID_AUTOR_PUBLICACAO,    
		   TB_PUBLICACAO_CURTIDA.ID_AUTOR_CURTIDA,      
		   TB_PUBLICACAO_CURTIDA.TIPO_CURTIDA,
		   TB_AUTOR_PUBLICACAO.APELIDO_USUARIO AS APELIDO_USUARIO_PUB,
		   TB_AUTOR_PUBLICACAO.NOME_USUARIO AS NOME_USUARIO_PUB,
		   TB_AUTOR_CURTIDA.APELIDO_USUARIO AS APELIDO_USUARIO_CURTIDA,
		   TB_AUTOR_CURTIDA.NOME_USUARIO AS NOME_USUARIO_CURTIDA
	  FROM TB_PUBLICACAO_CURTIDA
INNER JOIN TB_USUARIOS AS TB_AUTOR_PUBLICACAO
		ON TB_AUTOR_PUBLICACAO.ID_USUARIO	= TB_PUBLICACAO_CURTIDA.ID_AUTOR_PUBLICACAO
INNER JOIN TB_USUARIOS AS TB_AUTOR_CURTIDA
		ON TB_AUTOR_CURTIDA.ID_USUARIO		= TB_PUBLICACAO_CURTIDA.ID_AUTOR_PUBLICACAO
	 WHERE ((@id_publicacao IS NULL) OR (ID_PUBLICACAO			= @id_publicacao))
  ORDER BY APELIDO_USUARIO_CURTIDA
				    
END

GO




