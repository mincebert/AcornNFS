cd %0\..
H:\Apps\BeebAsm.exe -D TARGET=1 -D VERSION=0x350 -D DNFS=1 -i build.asm -o DNFS350.rom -v > NFS.lst
if ERRORLEVEL 1 pause
rem H:\Develop\FileTools\HexDiff.exe DNFS350.rom ..\DNFS\DNFS200.rom diff.txt 8000
rem if ERRORLEVEL 1 pause
