cd %0\..
H:\Apps\BeebAsm.exe -D TARGET=1 -D VERSION=0x340 -D ROM8K=0 -i build.asm -o NFS340.rom -v > NFS.lst
if ERRORLEVEL 1 pause
H:\Develop\FileTools\HexDiff.exe NFS340.rom ..\DNFS\DNFS200.rom diff.txt 8000
if ERRORLEVEL 1 pause
