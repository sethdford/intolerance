@echo off

for %%S in (%*) do "%~dp0bin\mxmlc.exe" -load-config font-config.xml -use-network=false %%S

pause