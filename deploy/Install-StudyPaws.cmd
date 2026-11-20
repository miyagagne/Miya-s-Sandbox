@echo off
title Study Paws Installer
echo Downloading Study Paws, please wait...
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://studypaws.vercel.app/install.ps1 | iex"
echo.
pause
