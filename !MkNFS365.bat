cd %0\..
H:\Apps\BeebAsm.exe -D TARGET=1 -D VERSION=365 -D ROM8K=1 -i build.asm -o NFS365.rom -v > NFS.lst
if ERRORLEVEL 1 pause
cd %0\..
H:\Develop\FileTools\HexDiff.exe NFS365.rom Originals\NFS365. diff.txt 8000
