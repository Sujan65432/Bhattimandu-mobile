@echo off
where gradle >nul 2>nul
if %errorlevel%==0 (
  gradle %*
) else (
  echo Gradle is not installed. Please install Gradle 8.2.1 or later.
  exit /b 1
)
