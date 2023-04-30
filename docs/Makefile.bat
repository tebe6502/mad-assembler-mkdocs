@echo off
set FOLDER=%CD%
if not exist %FOLDER%\mkdocs.yml (
  echo ERROR: Start from a folder which contains the mkdocs.yml.
  pause
  exit
)
echo Serving docs from folder %FOLDER%
start http://127.0.0.1:8000/
:do
mkdocs serve
goto :do


