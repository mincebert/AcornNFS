; Almost builds
; NFS 3.40
; NFS 3.50
;
; Correctly builds:
; NFS 3.60
; NFS 3.65
;

; Target-specific equates
; -----------------------
IF   TARGET=0
  CPU 0			; 6502
  ADLC   =&FC28		; Network controller
  STNNUM =&FC2C		; Station number links
  STNNMI =&FC2C		; Used in NMI routines
  VIA    =&FC60		; 6522 VIA
  ROMSEL =&FE05		; ROM select register
  TUBEIO =&FCE5		; Tube data port
  FILEBLK=&02E2		; OSFILE control block
ELIF TARGET=1 OR TARGET=2
  CPU 0			; 6502
  ALDC   =&FE84		; Network controller
  STNNUM =&FE18		; Station number links
  STNNMI =&FE18		; Used in NMI routines
  VIA    =&FE60		; 6522 VIA
  ROMSEL =&FE30		; ROM select register
  TUBEIO =&FEE5		; Tube data port
  FILEBLK=&02EE         ; OSFILE control block
ELIF TARGET>2
  CPU 1			; 65c12
  ALDC   =&FE84		; Network controller
  STNNUM =0		; Read from Configuration
  STNNMI =&0Dxx		; Used in NMI routines
  VIA    =&FE60		; 6522 VIA
  ROMSEL =&FE30		; ROM select register
  TUBEIO =&FEE5		; Tube data port
  FILEBLK=&02EE         ; OSFILE control block
ENDIF

OS_CLI=&FFF7:OSBYTE=&FFF4:OSWORD=&FFF1:OSWRCH=&FFEE
OSWRCR=&FFEC:OSNEWL=&FFE7:OSASCI=&FFE3:OSRDCH=&FFE0
OSFILE=&FFDD:OSARGS=&FFDA:OSBGET=&FFD7:OSBPUT=&FFD4
OSGBPB=&FFD1:OSFIND=&FFCE
 
ORG &8000
include "NFS.asm"
include "TUBE.asm"
include "ECONET.asm"

.L9F9D
.DFS	RTS

IF VERSION<&0365
 .LBFF0
 PHA:LSR A:LSR A:LSR A
 LSR A:JSR LBFF8:PLA
 .LBFF8
 AND #15:CMP #10:BCC LBFFC:ADC #6
 .LBFFC
 ADC #48:JSR OSASCI
 SEC:RTS
ENDIF

IF TARGET>=3
 .MTYPE
 EQUB &05,&0A,&0C ; M128,MET,CMP
 .MSTATION
 LDA #0:LDX #1:JSR OSBYTE ; But BBCMOS will return X=1
 LDA MTYPE-3,X:STA &0D71  ; My MTYPE
 LDX #0
 .RDCMOS
 LDA #161:JSR OSBYTE      ; Get Station number
 TYA:RTS                  ; But if BBCMOS, no CMOS calls
ENDIF

.CODEEND

PRINT "Code ends at",~CODEEND,"(",(&A000-CODEEND),"bytes free)"

SAVE "", &8000, &A000
