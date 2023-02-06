cd %0\..
H:\Apps\BeebAsm.exe -D TARGET=1 -D VERSION=0x350 -D ROM8K=0 -i build.asm -o NFS350.rom -v > NFS.lst
if ERRORLEVEL 1 pause
rem H:\Develop\FileTools\HexDiff.exe NFS350.rom ..\DNFS\DNFS200.rom diff.txt 8000
rem if ERRORLEVEL 1 pause
