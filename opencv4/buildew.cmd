REM @ECHO OFF

REM CHECK PYTHON 3
WHERE python
IF %ERRORLEVEL% NEQ 0 (echo "Python not available, please install it or add to the PATH variable") ^
ELSE echo "Python3 available" 
REM FOR /F %%i IN ("WHERE python | findstr /c:Python") DO set PYTHON3=%%i
set PYTHON3=python

REM CHECK PIP
WHERE pip
IF %ERRORLEVEL% NEQ 0 (echo "Pip not available, please install it or add to the PATH variable") ^
ELSE echo "Pip available" 
REM FOR /F %%i IN ("WHERE pip | findstr /c:Python") DO set PIP3=%%i
set PIP3=pip

REM CHECK VIRTUALENV COMMAND
REM %PYTHON3% -m .venv >nul
REM IF %ERRORLEVEL% NEQ 2 (
REM 	echo "Virtualenv not available, installing it [python3 -m pip install .venv]"
REM 	%PYTHON3% -m pip install .venv
REM ) ELSE echo "Venv module available" 

REM CHECK VENV NOT EXISTS
IF NOT EXIST "%CD%\.venv" ( 
    %PYTHON3% -m venv .venv 
    MKDIR input
    MKDIR output
)

set TMP_DEPENDENCIES_TXT=%TEMP%\dependencies-%DATE:/=-%-%TIME::=-%.txt
set TMP_DEPENDENCIES_TXT=%TMP_DEPENDENCIES_TXT: =-%
type requirements.txt | findstr /V picamera > %TMP_DEPENDENCIES_TXT%
.venv\Scripts\pip install -r %TMP_DEPENDENCIES_TXT%
echo %TMP_DEPENDENCIES_TXT%
del /Q /F %TMP_DEPENDENCIES_TXT%

IF NOT EXIST "%CD%\sensor.ini" COPY sensor.ini.example sensor.ini

REM if [ "x$1" == "xpip" ]; then
REM     echo 'Clear previous build'
REM     rm -fr dist
REM     rm -fr build
REM     rm -fr sensor_agent_farmsee.egg-info
REM     echo 'Build package for deploy'
REM     .venv/bin/python setup.py bdist_wheel
REM     echo 'Copy additional artifacts: sensor.ini'
REM     cp sensor.ini.example dist/sensor.ini
REM     echo 'Copy additional artifacts: deploy.sh'
REM     cp deploy.sh  dist/deploy.sh
REM     echo 'Copy additional artifacts: launcher.py'
REM     cp launcher.py  dist/launcher.py
REM     echo 'Copy additional artifacts: requirements.txt'
REM     cp requirements.txt  dist/requirements.txt
REM fi

REM if [ "x$1" == "xdeb" ]; then
REM     echo 'Clear previous build'
REM     rm -fr dist
REM     rm -fr build
REM     rm -fr sensor_agent_farmsee.egg-info
REM     echo 'Build package for raspberry'
REM     .venv/bin/python debian.py
REM fi

REM if [ "x$1" == "xclear" ]; then
REM     echo 'Clear previous build'
REM     rm -fr dist
REM     rm -fr build
REM     rm -fr sensor_agent_farmsee.egg-info
REM fi

IF "x%1"=="xunit-tests" (
	mkdir build\test-reports
	.venv\Scripts\pip install unittest-xml-reporting
	.venv\Scripts\python -m xmlrunner discover -t . -o build\test-reports
)

IF "x%1"=="xdeploy" (
    echo 'Clear folders'
 	rmdir /Q /S dist
    rmdir /Q /S build
    rmdir /Q /S sensor_agent_farmsee.egg-info
    echo 'Deploy to S3 and API'
    .venv\Scripts\python buildew_deploy.py --s3-bucket-name=farmsee-sensor-versions --api-version-url=https://dev-api.farmsee.com/api-1.0/sensor/UploadSensorAgentVersion --without-git-commit
)