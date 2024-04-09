; BUILD NFS ROM
; =============
; Build options:
; TARGET - OS to target
; DNFS   - shared service code arbitrated by KBD links, PRHEX in top ROM
; PATCH  - patch DNFS build to make 8K ROM

; Correctly builds:
; DNFS 3.60 - NFS for dual DNFS ROM
;  NFS 3.60 - 8K NFS from DNFS dual ROM with DFS patched out
;  NFS 3.65 - 8K NFS
;
; Almost builds
; DNFS 3.40 - NFS for dual DNFS ROM
; DNFS 3.50 - NFS for dual DNFS ROM
;
; Not yet checked
;  NFS 3.34 - 8K NFS
;  NFS 3.35 - 8K NFS
;

; Validate build options
; ----------------------
TUBE   =? &100
NOTUBE =? 0
PATCH  =? 0
IF PATCH
  DNFS =? 1
ENDIF

; Target-specific equates
; -----------------------
IF   TARGET=0
  CPU 0			; 6502
  ADLC   =&FC28		; Network controller
  STNNUM =&FC2C		; Station number links
  INTOFF =&FC2C   ; disable network NMIs
  INTON  =&FC2E   ; enable network NMIs
  SYSVIA =&FC60   ; 6522 System VIA
  ROMSEL =&FE05		; ROM select register
  TUBEIO =&FCE0		; Tube data port
ELIF TARGET=1 OR TARGET=2
  CPU 0			; 6502
  ADLC   =&FEA0		; Network controller
  STNNUM =&FE18		; Station number links
  INTOFF =&FE18   ; disable network NMIs
  INTON  =&FE20   ; enable network NMIs
  SYSVIA =&FE40   ; 6522 System VIA
  ROMSEL =&FE30		; ROM select register
  TUBEIO =&FEE0		; Tube data port
ELIF TARGET>2
  CPU 1			; 65c12
  ADLC   =&FE84		; Network controller
  STNNUM =0		; Read from Configuration
  INTOFF =&FE38   ; disable network NMIs
  INTON  =&FE3C   ; enable network NMIs
  SYSVIA =&FE40   ; 6522 System VIA
  ROMSEL =&FE30		; ROM select register
  TUBEIO =&FEE0		; Tube data port
ENDIF

OS_CLI=&FFF7:OSBYTE=&FFF4:OSWORD=&FFF1:OSWRCH=&FFEE
OSWRCR=&FFEC:OSNEWL=&FFE7:OSASCI=&FFE3:OSRDCH=&FFE0
OSFILE=&FFDD:OSARGS=&FFDA:OSBGET=&FFD7:OSBPUT=&FFD4
OSGBPB=&FFD1:OSFIND=&FFCE

; Helper macro for copying a block of code assembled in main RAM (at the
; address it will actually run at) into the ROM.
;
; stolen from IntegraB-OS recreation at:
; https://github.com/kgl2001/IntegraB-OS/blob/201e3e357a7b523181d2ddcaaebec7f653ce7d94/IBOS.asm#L5470

MACRO RELOCATE From, To
    ASSERT To >= &8000 ; sanity check
    COPYBLOCK From, P%, To
    CLEAR From, P%
    ORG To + (P% - From)
ENDMACRO

ORG &8000
include "NFS.asm"	; Filing system and high level routines
IF TUBE=&090
  include "TUBE090.asm"
ELSE
  include "TUBE.asm"	; Tube Host
ENDIF
include "ECONET.asm"	; Networking low level routines

IF PATCH
  .PRHEX
  PHA:LSR A:LSR A:LSR A
  LSR A:JSR PRHEX1:PLA
  .PRHEX1
  AND #15:CMP #10:BCC PRHEX2:ADC #6
  .PRHEX2
  ADC #48:JSR OSASCI:SEC:RTS
ENDIF

IF TARGET>=3
  .MTYPE
  EQUB &05,&0A,&0C	   ; M128,MET,COMP
  .MSTATION
  LDA #0:LDX #1:JSR OSBYTE ; But BBCMOS will return X=1
  LDA MTYPE-3,X:STA &0D71  ; My MTYPE
  LDX #0
  .RDCMOS
  LDA #161:JSR OSBYTE	   ; Get Station number
  TYA:RTS		   ; But if BBCMOS, no CMOS calls
ENDIF

.HIGHROM
.CODEEND
PRINT "Code ends at",~CODEEND,"(",(&A000-CODEEND),"bytes free)"
SAVE "", &8000, CODEEND
