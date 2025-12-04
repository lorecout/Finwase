@echo off
cd /d "c:\Users\Lorena\StudioProjects\Finwase\gastos_manager"
echo Diretorio atual: %CD%
echo.
echo Gerando App Bundle de release...
flutter build appbundle --release
echo.
if %ERRORLEVEL% EQU 0 (
  echo BUILD CONCLUIDO COM SUCESSO!
) else (
  echo BUILD FALHOU!
)
