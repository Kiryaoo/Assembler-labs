@echo off
ml /c /coff "7-10-IM-33-Kozarezov-PUBLIC.asm"
ml /c /coff "7-10-IM-33-Kozarezov.asm"
polink /subsystem:windows "7-10-IM-33-Kozarezov.obj" "7-10-IM-33-Kozarezov-PUBLIC.obj"
7-10-IM-33-Kozarezov.exe