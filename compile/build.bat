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
	set EMBO_DEX="C:\Program Files (x86)\Embarcadero\Studio\14.0\lib\android\debug\classes.dex)"
)
set VERBOSE=0

echo.
java -version
echo.

echo.
echo Compiling the Java service activity source files
echo.
mkdir output 2> nul
mkdir output\classes 2> nul
if x%VERBOSE% == x1 SET VERBOSE_FLAG=-verbose
javac %VERBOSE_FLAG% -Xlint:deprecation -d output\classes -cp %ANDROID_PLATFORM%\android.jar -source 1.6 -target 1.6 src\com\company\package\*.java

echo.
echo Creating jar containing the new classes
echo.
mkdir output\jar 2> nul
if x%VERBOSE% == x1 SET VERBOSE_FLAG=v
jar c%VERBOSE_FLAG%f output\jar\test_classes.jar -C output\classes com

echo.
echo Converting from jar to dex...
echo.
mkdir output\dex 2> nul
if x%VERBOSE% == x1 SET VERBOSE_FLAG=--verbose
call dx --dex %VERBOSE_FLAG% --output="%PROJ_DIR%\output\dex\test_classes.dex" --positions=lines "%PROJ_DIR%\output\jar\test_classes.jar"

echo.
echo Merging dex files
echo.
java -cp %DX_LIB%\dx.jar com.android.dx.merge.DexMerger "%PROJ_DIR%\output\dex\classes.dex" "%PROJ_DIR%\output\dex\test_classes.dex" %EMBO_DEX%

echo Tidying up
echo.
del output\classes\com\company\package\*.class
rmdir output\classes\com\company\package
rmdir output\classes\com\company
rmdir output\classes\com
rmdir output\classes
del output\dex\test_classes.dex
del output\jar\test_classes.jar
rmdir output\jar

echo.
echo Now we have the end result, which is output\dex\classes.dex

pause
:Exit

endlocal
