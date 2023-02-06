cd %0\..
H:\Apps\BeebAsm.exe -D TARGET=1 -D VERSION=0x360 -D PATCH=1 -i build.asm -o NFS360.rom -v > NFS.lst
if ERRORLEVEL 1 pause
H:\Develop\FileTools\HexDiff.exe NFS360.rom Originals\NFS360. diff.txt 8000
if ERRORLEVEL 1 pause
