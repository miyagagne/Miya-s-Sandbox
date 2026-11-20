@echo off
title Study Paws Installer
echo Downloading Study Paws, please wait...
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://miyagagne.github.io/Miya-s-Sandbox/site/install.ps1 | iex"
echo.
pause
