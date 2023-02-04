cd %0\..
H:\Apps\BeebAsm.exe -D TARGET=1 -D VERSION=0x360 -D ROM8K=0 -i build.asm -o NFS360.rom -v > NFS.lst
if ERRORLEVEL 1 pause
H:\Develop\FileTools\HexDiff.exe NFS360.rom ..\DNFS\DNFS300.rom diff.txt 8000
if ERRORLEVEL 1 pause
