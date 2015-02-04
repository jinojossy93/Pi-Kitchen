@echo off
REM This script will generate the flavours.json file for NOOBS.
REM If performing an automated install, only a single flavour should be listed.
REM
REM The command line inputs determines the FLAVOUR selected for automated install and and DISTRO (or to use defaults given in this file).
REM i.e. gen_flavours ALL Raspbian

REM Read in the command line inputs:
REM FLAVOUR
if [%1] == [] (
  set FLAVOUR=ALL
) else (
  set FLAVOUR=%1
)
echo Flavour: %FLAVOUR%

REM DISTRO
if [%2] == [] (
  set DISTRO=Raspbian
) else (
  set DISTRO=%2
)
echo Distribution: %DISTRO%

set DISTRO_PATH=../../os/%DISTRO%
set FLAVOUR_FILE=flavours.json
set FLAVOUR_SOURCE=_flavours/*.json

REM Add start of flavours.json file:
echo {> %DISTRO_PATH%/%FLAVOUR_FILE%
echo   "flavours": [>> %DISTRO_PATH%/%FLAVOUR_FILE%
echo     {>> %DISTRO_PATH%/%FLAVOUR_FILE%
REM Add required flavour(s):
if "%FLAVOUR%" == "ALL" (
   for %%F in (%FLAVOUR_SOURCE%) do (
      set ADDFLAVOUR=%%~nF
      call :AddFlavour
      echo     },>> %DISTRO_PATH%/%FLAVOUR_FILE%
      echo     {>> %DISTRO_PATH%/%FLAVOUR_FILE%
   )
   REM Remove the last two lines so the json entry can be closed
   sed '$d' %DISTRO_PATH%/%FLAVOUR_FILE% > temp.txt
   sed '$d' temp.txt > %DISTRO_PATH%/%FLAVOUR_FILE%
   del temp.txt
) else (
   set ADDFLAVOUR=%FLAVOUR%
   call :AddFlavour
)
REM Add end of flavours.json file:
echo     }>> %DISTRO_PATH%/%FLAVOUR_FILE%
echo   ]>> %DISTRO_PATH%/%FLAVOUR_FILE%
echo }>> %DISTRO_PATH%/%FLAVOUR_FILE%

goto TheEnd



:AddFlavour
echo Add Flavour: %ADDFLAVOUR%
type "_flavours\%ADDFLAVOUR%.json" >> %DISTRO_PATH%/%FLAVOUR_FILE%
echo.>> %DISTRO_PATH%/%FLAVOUR_FILE%
goto :eof

:TheEnd