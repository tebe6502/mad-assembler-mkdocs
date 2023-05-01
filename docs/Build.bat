@echo off
cd "%~dp0"
setlocal
set SITE_DIR=C:\jac\system\WWW\Sites\www.wudsn.com\
set SITE_MADS_DIR=%SITE_DIR%\tmp\projects\mads\%LANGUAGE%
set UPLOAD=%SITE_DIR%\productions\www\site\export\upload.bat 

call :make_docs en
call :make_docs pl
call %UPLOAD% tmp
start https://www.wudsn.com/tmp/projects/mads/en/
start https://www.wudsn.com/tmp/projects/mads/pl/
goto :eof

:make_docs
set LANGUAGE=%1
set CONFIG_FILE=%LANGUAGE%\mkdocs.yml
set SITE_LANGUAGE_DIR=%SITE_MADS_DIR%\%LANGUAGE%
if not exist %SITE_LANGUAGE_DIR% mkdir %SITE_LANGUAGE_DIR%
mkdocs build --config-file %CONFIG_FILE% --site-dir %SITE_LANGUAGE_DIR% --clean 
goto :eof
