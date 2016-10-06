@echo off

setlocal

if x%ANDROID% == x set ANDROID="Путь к sdk (...\Embarcadero\Studio\14.0\PlatformSDKs\adt-bundle-windows-x86-20131030\sdk)"
set ANDROID_PLATFORM=%ANDROID%\platforms\android-19
set DX_LIB=%ANDROID%\build-tools\android-4.4\lib
set PROJ_DIR=%CD%
if exist "%PROJ_DIR%\lib\classes.dex" (
	echo Local .\lib\classes.dex will be used in merging.
	set EMBO_DEX="%PROJ_DIR%\lib\classes.dex"
) else (
	echo Emarcadero's debug classes.dex will be used in merging.
	set EMBO_DEX="C:\Program Files (x86)\Embarcadero\Studio\14.0\lib\android\debug\classes.dex"
)
set VERBOSE=0

echo.
java -version
echo.

echo.
echo Converting from jar to dex...
echo.
mkdir output\dex 2> nul
if x%VERBOSE% == x1 SET VERBOSE_FLAG=--verbose
call dx --dex %VERBOSE_FLAG% --output="%PROJ_DIR%\output\dex\lib_classes.dex" --positions=lines "%PROJ_DIR%\lib\sdk.jar"

echo.
echo Merging dex files
echo.
java -cp %DX_LIB%\dx.jar com.android.dx.merge.DexMerger "%PROJ_DIR%\output\dex\classes.dex" "%PROJ_DIR%\output\dex\lib_classes.dex" %EMBO_DEX%

echo Tidying up
echo.
del output\dex\lib_classes.dex

echo.
echo Now we have the end result, which is output\dex\classes.dex

pause
:Exit

endlocal
