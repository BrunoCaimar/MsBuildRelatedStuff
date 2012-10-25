@@echo off
cls
IF (%1)==() GOTO NADA
IF (%2)==() GOTO NADA

ECHO *** %TIME%
ECHO *** Gerador de Setup's   
ECHO *** Passos executados 
ECHO ***     1o. Copia os arquivos de configuracao do ambiente informado
ECHO ***     2o. Atualiza o numero da versao (se requerido)
ECHO ***     3o. Compila o projeto em Release Mode
ECHO ***     4o. Executa o projeto de Setup 
ECHO ***     5o. Renomeia o setup gerado com o nome do ambiente
ECHO ***
ECHO *** Dados informados: Ambiente: %1 Atualizar Versao?: %2
ECHO *** 

@@ECHO OFF

ECHO . 
ECHO .

IF NOT EXIST CONFIG\%1\HIBERNATE.CFG.XML GOTO CONFIGNAOEXIST
ECHO ENCONTROU HIBERNATE.CFG.XML 

IF NOT EXIST CONFIG\%1\Company.AssemblyName.dll.config GOTO CONFIGNAOEXIST
ECHO ENCONTROU Company.AssemblyName.dll.config

ECHO .
ECHO ***** 1o. Copia os arquivos de configuracao do ambiente informado
ECHO .
ECHO COPIANDO HIBERNATE.CFG.XML
COPY ..\RepositoryDesigner\hibernate.cfg.xml ..\RepositoryDesigner\hibernate.cfg.xml.OLD
COPY CONFIG\%1\hibernate.cfg.xml ..\RepositoryDesigner\

ECHO .
ECHO COPIANDO Company.AssemblyName.dll.config
COPY ..\DesignerCommands\app.config ..\DesignerCommands\app.config.OLD
COPY CONFIG\%1\Company.AssemblyName.dll.config ..\DesignerCommands\app.config
ECHO .

ECHO . FAZENDO BACKUP DE VersionControl.txt
COPY VersionControl.txt VersionControl.BKP

ECHO ***     2o. Atualiza o numero da versao (se requerido) 
IF %2 == S %WINDIR%\Microsoft.NET\Framework\v2.0.50727\MSBUILD PLMVersionInfo.proj  
IF ERRORLEVEL 1 GOTO :ERRONOVAVERSAO

ECHO ***     3o. Compila o projeto em Release Mode

ECHO *** %TIME%
ECHO *** CLEAN RELEASE - SLN ***
%WINDIR%\Microsoft.NET\Framework\v2.0.50727\MSBUILD ..\ExtDesignerCore\ExtDesignerCore.sln /p:Configuration=Release /t:Clean 
IF ERRORLEVEL 1 GOTO :ERROCOMPILA 

ECHO *** %TIME%
ECHO *** BUILD RELEASE - SLN ***
%WINDIR%\Microsoft.NET\Framework\v2.0.50727\MSBUILD ..\ExtDesignerCore\ExtDesignerCore.sln /p:Configuration=Release >BuildLog\PLM_BUILD_%1.LOG 
IF ERRORLEVEL 1 GOTO :ERROCOMPILA 

ECHO *** %TIME%
ECHO ***     4o. Executa o projeto de Setup (Gerando o setup efetivamente) 

ECHO REMOVE VERSAO ATUAL
DEL Setup\SetupExtDesigner%1.msi

ECHO *** DEPLOY RELEASE ***
"%PROGRAMFILES%\Microsoft Visual Studio 8\Common7\IDE\devenv.exe" ..\ExtDesignerCore\ExtDesignerCore.sln /project SetupExtDesigner /projectconfig Release /build
IF ERRORLEVEL 1 GOTO :ERRODEPLOY

ECHO *** %TIME%
ECHO ***     5o. Renomeia o setup gerado com o nome do ambiente
copy ..\SetupExtDesigner\Release\SetupExtDesigner.msi Setup\SetupExtDesigner%1.msi

ECHO *** COMMITAR NOVA VERSAO *** NAO IMPLEMENTADO
ECHO *** TAG NOVA VERSAO ***      NAO IMPLEMENTADO

GOTO :END

:CONFIGNAOEXIST
ECHO .
ECHO .
ECHO ARQUIVO CONFIG\%1\Company.AssemblyName.dll.config OU CONFIG\%1\HIBERNATE.CFG.XML NAO ENCONTRADO
ECHO .
ECHO . 

GOTO :ENDVAZIO

:NADA
ECHO .
ECHO ***
ECHO *** PARAMETROS NAO INFORMADOS *** 
ECHO *** Executar como segue: PLM_GERARSETUP.BAT "AMBIENTE(PJH ou PLMH ou PLMT)" "VERSIONAR (S ou N)"   
ECHO *** 
ECHO *** Dados informados: Ambiente: %1 Versionar: %2
ECHO ***
ECHO .
GOTO :ENDVAZIO

:ERRONOVAVERSAO
ECHO ***************************************************************************
ECHO ***************************************************************************
ECHO ***************************************************************************
ECHO *** ATENCAO! *** Aconteceu um erro na geração da nova versão            ***
ECHO ***************************************************************************
ECHO ***************************************************************************
ECHO ***************************************************************************
ECHO . RETORNANDO BACKUP DE VersionControl.txt
COPY VersionControl.BKP VersionControl.txt
PAUSE
GOTO :END

:ERROCOMPILA
ECHO ***************************************************************************
ECHO ***************************************************************************
ECHO ***************************************************************************
ECHO *** ATENCAO! *** Aconteceu um erro na compilacao do projeto             ***
ECHO *** VEJA O LOG EM BuildLog\PLM_BUILD_%1.LOG                         ***
ECHO ***************************************************************************
ECHO ***************************************************************************
ECHO ***************************************************************************
ECHO . RETORNANDO BACKUP DE VersionControl.txt
COPY VersionControl.BKP VersionControl.txt
PAUSE  
GOTO :END

:ERRODEPLOY
ECHO ***************************************************************************
ECHO ***************************************************************************
ECHO ***************************************************************************
ECHO *** ATENCAO! *** Aconteceu um erro no build do projeto             ***
ECHO ***************************************************************************
ECHO ***************************************************************************
ECHO ***************************************************************************
ECHO . RETORNANDO BACKUP DE VersionControl.txt
COPY VersionControl.BKP VersionControl.txt
PAUSE  
GOTO :END

:END
ECHO .
ECHO Restaurando HIBERNATE.CFG.XML
COPY ..\RepositoryDesigner\hibernate.cfg.xml.old ..\RepositoryDesigner\hibernate.cfg.xml

ECHO .
ECHO Restaurando Company.AssemblyName.dll.config
COPY ..\DesignerCommands\app.config.OLD ..\DesignerCommands\app.config
ECHO .

:ENDVAZIO
ECHO FIM!
