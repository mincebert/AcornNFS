\ TUBE HOST VERSION 0.90
\ ======================

\ Tube I/O locations
\ ------------------
IF TARGET=0
  TUBE%=&FCE0	:\ Electon
ELSE
  TUBE%=&FEE0	:\ BBC/Master
ENDIF
:
TUBES1=TUBE%+0:TUBES2=TUBE%+2:TUBES3=TUBE%+4:TUBES4=TUBE%+6
TUBER1=TUBE%+1:TUBER2=TUBE%+3:TUBER3=TUBE%+5:TUBER4=TUBE%+7

\ Tube host workspace
\ -------------------
\ &0000   - Control block
\ &0012/3 - Control block pointer
\ &0014   - b7=Tube free
\ &0015   - Claimant ID

\ Tube idle loop code copied to &0016-&0057
\ =========================================
.TubeZero
TUBE0=TubeZero-&0016

\ BRK handler
\ -----------
.L0016
LDA #&FF:JSR L069E-TUBE5	:\ Send &FF to R4 to interupt CoPro
LDA TUBER2			:\ Get ACK byte from CoPro via R2
LDA #&00:JSR L0695-TUBE5	:\ Send &00 to R2 to specify ERROR
TAY:LDA (&FD),Y:JSR L0695-TUBE5	:\ Send error number via R2
.L0029
INY:LDA (&FD),Y:JSR L0695-TUBE5	:\ Send error character via R2
TAX:BNE L0029			:\ Loop until terminating &00 sent
:
\ Idle startup
\ ------------
.L0032
LDX #&FF:TXS:CLI	:\ Clear stack, enable IRQs
:
\ Tube idle loop
\ --------------
.L0036
BIT TUBES1:BPL L0041	:\ No character in R1, check for command in R2
.L003B
LDA TUBER1:JSR OSWRCH	:\ Get character from R1 and send to OSWRCH
.L0041
BIT TUBES2:BPL L0036	:\ No command in R2, loop back
BIT TUBES1:BMI L003B	:\ Deal with pending character first
LDX TUBER2
.L004E
STX L004E-TUBE0+3	:\ Get command from R2 and index into &0500
JMP (&0500)		:\ Jump to command routine

.L0053
EQUD &00008000		:\ Tube transfer address

\ Main Tube code copied to &0400-&06FF
\ ====================================
.TubeCode
TUBE4=TubeCode-&0400

.L0400:JMP L0484-TUBE4	:\ Copy language across the Tube
.L0403:JMP L06A7-TUBE5	:\ Copy Escape state across the Tube
.L0406			:\ Tube Transfer/Claim/Release
CMP #&80:BCC L0435	:\ If <&80, data transfer action
CMP #&C0:BCS L0428	:\ &C0-&FF - jump to claim Tube
:
\ Release Tube
\ ------------
ORA #&40		:\ Ensure release ID same as claim ID
CMP &15:BNE L0434	:\ Not same as the claim ID, exit
.L0414
\PHP:\SEI		:\ Disable IRQs
LDA #05:JSR L069E-TUBE5	:\ Send &05 via R4 to CoPro
LDA &15:JSR L069E-TUBE5	:\ Send Tube ID to notify a Tube release
\PLP			:\ Restore IRQs
:
\ Clear Tube status and owner
\ ---------------------------
.L0421
LDA #&80
\STA &15		:\ Store Tube ID
STA &14			:\ Set Tube status to 'free' and ID to 'unclaimed'
.L0427
RTS

\ Claim Tube
\ ----------
.L0428
ASL &14:BCS L0432	:\ If Tube free, jump to claim it, exit with CS
CMP &15:BEQ L0434	:\ Tube ID same as claimer, we already own it, exit with CS
CLC:RTS			:\ Exit with CC='can't claim Tube'

.L0432
STA &15			:\ Store Tube ID
.L0434
RTS

\ Tube data transfer
\ ==================
\ On entry, XY=>data transfer address
\            A=data transfer action
.L0435
PHP:SEI		:\ Disable IRQs
STY &13:STX &12	:\ Store pointer to control block
JSR L069E-TUBE5	:\ Send action code via R4 to interrupt CoPro
TAX		:\ Save action code in X
LDY #&03	:\ Prepare to send 4 byte control block
LDA &15
JSR L069E-TUBE5	:\ Send Tube ID via R4
.L0446
LDA (&12),Y:JSR L069E-TUBE5	:\ Send control block across Tube via R4
DEY:BPL L0446
LDY #&18:STY TUBES1		:\ Disable FIFO on R3, and NMI on R3 by default
LDA L0518-TUBE5,X:STA TUBES1	:\ Set Tube I/O setting according to action code
LSR A:LSR A		:\ Move b1 to Carry (b1 set = Copro->I/O)
\BCC L0463		:\ I/O->CoPro, no pre-delay needed
\BIT TUBER3:\BIT TUBER3	:\ Read R3 twice to delay & empty FIFO
.L0463
\JSR L069E-TUBE5	:\ Send flag via R4 to synchronise
.L0466
BIT TUBES4:BVC L0466	:\ Loop until data has left R4
\BCS L047A		:\ Carry still indicates direction, jump with CoPro->I/O
BCS L93CA
CPX #&04:BNE L0482	:\ If not 'execute code' jump to finish
.L0471
JSR L0414-TUBE4		:\ Release Tube
JSR L0695-TUBE5		:\ Send &80 via R2
JMP L0032-TUBE0		:\ Jump to Tube Idle loop

.L93CA
BIT TUBER3:BIT TUBER3	:\ Read R3 twice to delay & empty FIFO
.L047A
LSR A:BCC L0482        :\ If Tube I/O flag in b2 was clear, no NMI required, jump to exit
LDY #&88:STY TUBES1    :\ Set Tube I/O to NMI on R3
.L0482
PLP:RTS                :\ Restore IRQs and exit

\ Copy language across Tube
\ =========================
\ On entry, A=1 - enter language, CLC=Break, SEC=OSBYTE 142
\           A=0 - no language found at Break
\
.L0484
CLI			:\ Enable IRQs
BCS L0498		:\ Branch if selected with *fx142
BNE L048C		:\ A<>0, jump to enter language
JMP L059C-TUBE5		:\ A=0, send &7F ack, enter Tube Idle loop

\ Language entered at BREAK
\ -------------------------
.L048C
LDX #&00:LDY #&FF:LDA #&FD
JSR OSBYTE		:\ Get last Break type
TXA:BEQ L0471		:\ If Soft Break, just release Tube, send &80 and jump to idle

\ The current language is not copied across the Tube on Soft Break, only on
\ Power-On Break and Hard Break, or when entered explicitly with OSBYTE 142.

\ Language entered with OSBYTE 142, or on Hard Break
\ --------------------------------------------------
.L0498
LDA #&FF:JSR L0406-TUBE4	:\ Claim Tube with ID=&3F
BCC L0498			:\ Loop until Tube available
JSR L04D2-TUBE4			:\ Find address to copy language to

\ Send language ROM via Tube 256 bytes at a time
\ ----------------------------------------------
.L049B
LDA #&07:JSR L04CB-TUBE4	:\ Start I/O->CoPro 256-byte transfer from (&53-&56)
:
LDY #&00:STY &00		:\ Start copying from &8000
.L04A6
LDA (&00),Y:STA TUBER3		:\ Get byte from ROM, send to CoPro via R3
\NOP:\NOP:\NOP			:\ Delay
LDA &8000			:\ Delay
INY:BNE L04A6			:\ Loop for 256 bytes
:
INC L0053-TUBE0+1:BNE L04BC	:\ Update transfer address
INC L0053-TUBE0+2:BNE L04BC
INC L0053-TUBE0+3
.L04BC
INC &01			:\ Update source address
BIT &01:BVC L049B	:\ Check b6 of source high byte, loop until source=&C000
:
JSR L04D2-TUBE4		:\ Find start address language copied to
LDA #&04		:\ Drop through to execute code in CoPro
:			:\ Finished by sending &80 to Copro via R2
:
\ Start a Tube transfer with address block at &0053
\ -------------------------------------------------
.L04CB
LDY #&00:LDX #L0053-TUBE0 :\ Point to Tube control block
JMP L0406-TUBE4		  :\ Jump to do a data transfer

\ Set Tube address to destination to copy language to
\ ---------------------------------------------------
\ Also sets source address at &00/&01 to &80xx
\
.L04D2
LDA #&80
STA L0053+1-TUBE0	:\ Set transfer address to &xxxx80xx
STA &01			:\ Set source address to &80xx
LDA #&20:AND &8006	:\ Check relocation bit in ROM type byte
TAY:STY L0053-TUBE0	:\ If no relocation, A=0, Y=0, set address to &xxxx8000
BEQ L04F7		:\ Jump forward with no relocation
:
LDX &8007		:\ Get offset to ROM copyright
.L04E5
INX:LDA &8000,X		:\ Skip past copyright message
BNE L04E5		:\ Loop until terminating zero byte
LDA &8001,X:STA L0053-TUBE0+0	:\ Get relocation address from after copyright message
LDA &8002,X:STA L0053-TUBE0+1
LDY &8003,X		:\ Get two high bytes to Y and A
LDA &8004,X

\ Set Tube address high bytes
\ ---------------------------
.L04F7
STA L0053-TUBE0+3
STY L0053-TUBE0+2	:\ Set Tube address high bytes
RTS

\ Tube R2 command entry block
\ ===========================
\ Has to be fixed at &0500 for jump dispatch
.L0500
TUBE5=L0500-&0500
EQUW L0537-TUBE5	:\ &00 OSRDCH
EQUW L0596-TUBE5	:\ &02 OSCLI
EQUW L05F2-TUBE5	:\ &04 OSBYTELO
EQUW L0607-TUBE5	:\ &06 OSBYTEHI
EQUW L0627-TUBE5	:\ &08 OSWORD
EQUW L0668-TUBE5	:\ &0A RDLINE
EQUW L055E-TUBE5	:\ &0C OSARGS
EQUW L052D-TUBE5	:\ &0E OSBGET
EQUW L0520-TUBE5	:\ &10 OSBPUT
EQUW L0542-TUBE5	:\ &12 OSFIND
EQUW L05A9-TUBE5	:\ &14 OSFILE
EQUW L05D1-TUBE5	:\ &16 OSGBPB

\ Tube data transfer flags
\ ------------------------
.L0518
EQUB &86	:\  CoPro->I/O bytes
EQUB &88	:\  I/O->CoPro bytes
EQUB &96	:\  CoPro->I/O words
EQUB &98	:\  I/O->CoPro words
EQUB &18	:\  Execute in CoPro
EQUB &18	:\  Release
EQUB &82	:\  CoPro->I/O 256 bytes
EQUB &18	:\  I/O->CoPro 256 bytes

\ OSBPUT
\ ======
.L0520
JSR L06C5-TUBE5:TAY	:\ Wait for a handle via R2
JSR L06C5-TUBE5		:\ Wait for a byte via R2
JSR OSBPUT		:\ Write byte to file
JMP L059C-TUBE5		:\ Send &7F ack byte via R2 and return to idle loop

\ OSBGET
\ ======
.L052D
JSR L06C5-TUBE5:TAY	:\ Wait for a handle via R2
JSR OSBGET		:\ Fetch a byte from file
JMP L053A-TUBE5		:\ Jump to send Carry and A

\ OSRDCH
\ ======
.L0537
JSR OSRDCH		:\ Wait for a character
.L053A
ROR A:JSR L0695-TUBE5	:\ Move carry to b7 and send via R2
ROL A:JMP L059E-TUBE5	:\ Move A back, send via R2 and return to idle loop

\ OSFIND
\ ======
.L0542
JSR L06C5-TUBE5:BEQ L0552	:\ Wait for a byte in R2, if zero jump to do CLOSE
PHA:JSR L0582-TUBE5:PLA		:\ Get a string via R2
JSR OSFIND			:\ Do the OPEN
JMP L059E-TUBE5			:\ Send handle via R2 and go to idle loop

\ CLOSE
\ -----
.L0552
JSR L06C5-TUBE5:TAY	:\ Wait for a handle via R2
LDA #&00:JSR OSFIND	:\ Do the CLOSE
JMP L059C-TUBE5		:\ Send &7F ack and jump to idle loop

\ OSARGS
\ ======
.L055E
JSR L06C5-TUBE5:TAY	:\ Wait for a handle via R2
LDX #&04
.L0566
JSR L06C5-TUBE5		:\ Fetch four bytes for control block, returns X=&00
STA &FF,X:DEX:BNE L0566
JSR L06C5-TUBE5		:\ Wait for ARGS function via R2
JSR OSARGS		:\ Do the OSARGS action
JSR L0695-TUBE5		:\ Send A back via R2
LDX #&03
.L0575
LDA &00,X:JSR L0695-TUBE5 :\ Send four bytes from control block
DEX:BPL L0575
JMP L0036-TUBE0		  :\ Jump to Tube idle loop

\ Read a string via R2 into string buffer at &0700
\ ================================================
.L0582
LDX #&00:LDY #&00		:\ Y=index into string
.L0586
JSR L06C5-TUBE5:STA &0700,Y	:\ Wait for a byte via R2, store in string buffer
INY:BEQ L0593			:\ Buffer full, end loop
CMP #&0D:BNE L0586		:\ Loop until <cr> received
.L0593
LDY #&07			:\ Return XY pointing to string at &0700
RTS

\ OSCLI
\ =====
.L0596
JSR L0582-TUBE5		:\ Read string to &0700
JSR OS_CLI		:\ Execute the command

\ If the command returns here, the CoPro will get &7F as an acknowledgement.
\ The CoPro also gets sent a &7F byte if there is no language available on
\ Break. If calling OSCLI results in code being run in the CoPro or a language
\ being copied over and entered, the CoPro will get an &80 acknowledgement
\ elsewhere.

\ Send &7F acknowledgement byte via R2 and return to idle loop
\ ------------------------------------------------------------
.L059C
LDA #&7F		:\ Send &7F to CoPro

\ Send byte in A via R2 and return to Tube idle loop
\ --------------------------------------------------
.L059E
BIT TUBES2:BVC L059E	:\ Loop until port free
STA TUBER2		:\ Send byte in A
.L05A6
JMP L0036-TUBE0		:\ Jump to Tube idle loop

\ OSFILE
\ ======
.L05A9
LDX #&10		:\ Loop for 16-byte control block
.L05AB
JSR L06C5-TUBE5:STA &01,X :\ Get byte via R2, store in control block
DEX:BNE L05AB
JSR L0582-TUBE5		 :\ Read string to &0700, returns YX=&0700
STX &00:STY &01		 :\ Point control block to string
LDY #&00:JSR L06C5-TUBE5 :\ Wait for action byte via R2, returns Y=&00
JSR OSFILE		 :\ Do the OSFILE call

\ During the OSFILE call the Tube system may be called to do a data transfer

JSR L0695-TUBE5		:\ Send result back via R2
LDX #&10		:\ Send 16-byte control block back
.L05C7
LDA &01,X:JSR L0695-TUBE5 :\ Get byte from control block, send via R2
DEX:BNE L05C7
BEQ L05A6		:\ Jump to Tube idle loop

\ OSGBPB
\ ======
.L05D1
LDX #&0D
.L05D3
JSR L06C5-TUBE5		:\ Fetch 13-byte control block
STA &FF,X:DEX:BNE L05D3
JSR L06C5-TUBE5		:\ Wait for action byte via R2, returns Y=&00
LDY #&00:JSR OSGBPB	:\ Do the OSGBPB call

\ During the OSGBPB call the Tube system may be called to do a data transfer

PHA			:\ Save result
LDX #&0C
.L05F6
LDA &00,X:JSR L0695-TUBE5 :\ Send 13-byte control block
DEX:BPL L05F6
PLA:JMP L053A-TUBE5	:\ Get result byte, jump to send Carry and A,
			:\ then return to Tube idle loop

\ OSBYTELO - OSBYTEs &00-&7F
\ ==========================
.L05F2
JSR L06C5-TUBE5:TAX	:\ Wait for X parameter via R2
JSR L06C5-TUBE5		:\ Wait for A parameter via R2
JSR OSBYTE		:\ Do the OSBYTE call

\ Send byte in X via R2 and jump to Tube idle loop
\ ------------------------------------------------
.L05FC
BIT TUBES2:BVC L05FC	:\ Loop until port free
STX TUBER2		:\ Send X via R2
.L0604
JMP L0036-TUBE0		:\ Return to Tube idle loop

\ OSBYTEHI - OSBYTE &80-&FF
\ =========================
.L0607
JSR L06C5-TUBE5:TAX	:\ Wait for X parameter via R2
JSR L06C5-TUBE5:TAY	:\ Wait for Y parameter via R2
JSR L06C5-TUBE5		:\ Wait for A parameter via R2
JSR OSBYTE		:\ Do the OSBYTE call

\ If the OSBYTE results in code being executed - ie, OSBYTE 142, then the
\ call will not be returned here, and the CoPro will be sent an &80 ack
\ byte.

EOR #&9D:BEQ L0604	:\ If OSBYTE &9D, Fast BPUT, jump stright back to idle loop
ROR A:JSR L0695-TUBE5	:\ Move Carry into b7 of A, send via R2

\ Send bytes in Y, X via R2, then jump to Tube idle loop
\ ------------------------------------------------------
.L061D
BIT TUBES2:BVC L061D	:\ Loop until port free
STY TUBER2		:\ Send byte in Y
BVS L05FC		:\ Jump to send X and jump to idle loop

\ OSWORD
\ ======
.L0627
JSR L06C5-TUBE5:TAY	:\ Wait for action byte in R2, save in Y
.L062B
BIT TUBES2:BPL L062B	:\ Loop until data present in R2
LDX TUBER2		:\ Get X from R2 - number of bytes inward
DEX:BMI L0645		:\ Jump if no bytes to read
			:\ Note, it is the Client that declares how
			:\ many bytes to transfer, and the protocol
			:\ treats &81-&FF as zero as well
.L0636
BIT TUBES2:BPL L0636	:\ Loop until data present in R2
LDA TUBER2:STA &128,X	:\ Get byte via R2, store in control block
DEX:BPL L0636
TYA			:\ Get function back to A

\ This builds the OSWORD control block in &0128 up towards &01FF, allowing a
\ maximum control block of almost 216 bytes before it crashes into the stack.
\ However, the protocol treats a control block length of &81-&FF as zero, so
\ the maximum size control block will be &0128-&01A7.

.L0645
LDX #&28:LDY #&01	:\ Point XY to control block at &0128
JSR OSWORD		:\ Do the OSWORD call
.L064C
BIT TUBES2:BPL L064C	:\ Loop until data present in R2
LDX TUBER2		:\ Get output control block size to X
DEX:BMI L0665		:\ Jump if no bytes to return, again the Client
			:\ declares how many bytes to transfer, and the
			:\ protocol treats &81-&FF as zero.
.L0657
LDY &128,X		:\ Get byte from control block
.L065A
BIT TUBES2:BVC L065A	:\ Loop until R2 free
STY TUBER2		:\ Send byte via R2
DEX:BPL L0657
.L0665
JMP L0036-TUBE0		:\ Return to Tube idle loop

\ RDLINE - Read a line
\ ====================
.L0668
LDX #&04
.L066A
JSR L06C5-TUBE5		:\ Fetch five bytes into control block
STA &00,X
DEX:BPL L066A
INX:LDY #&00:TXA	:\ Point XY to control block at &0000
JSR OSWORD		:\ Call OSWORD A=0 to read the line
BCC L0680		:\ Jump if no Escape
LDA #&FF:JMP L059E-TUBE5 :\ Send &FF via R2 for Escape, return to Tube idle loop

.L0680
LDX #&00		 :\ Point to start of string buffer
LDA #&7F:JSR L0695-TUBE5 :\ Send &7F via R2 to indicate no Escape
.L0687
LDA &0700,X:JSR L0695-TUBE5 :\ Get byte from string buffer, send via R2
INX			:\ Move to next byte
CMP #&0D:BNE L0687	:\ Loop until <cr> sent
JMP L0036-TUBE0		:\ Return to Tube idle loop

\ Send byte in A via R2
\ =====================
.L0695
BIT TUBES2:BVC L0695	:\ Loop until R2 free
STA TUBER2:RTS		:\ Send byte

\ Send byte in A via R4
\ =====================
.L069E
BIT TUBES4:BVC L069E	:\ Loop until R4 free
STA TUBER4:RTS		:\ Send byte

\ Copy Escape state across Tube
\ =============================
.L06A7
LDA &FF			:\ Get Escape state
SEC:ROR A		:\ Rotate escape to b6 and set b7
BMI L06BC		:\ Interupt client with byte send via R1

\ Send event across Tube
\ ======================
.L06AD
PHA			 :\ Save A
LDA #&00:JSR L06BC-TUBE5 :\ Send &00 via R1, generating client IRQ

\ After being interupted with the first byte, above, the client usually
\ disables IRQs and reads the following bytes directly from the Tube registers.

TYA:JSR L06BC-TUBE5	:\ Send Y via R1
TXA:JSR L06BC-TUBE5	:\ Send X via R1
PLA			:\ Get A back and send via R1
:
\ Send byte in A via R1
\ =====================
.L06BC
BIT TUBES1:BVC L06BC	:\ Loop until R1 free
STA TUBER1:RTS		:\ Send byte

\ Wait for data via R2
\ ====================
.L06C5
BIT TUBES2:BPL L06C5	:\ Loop until data present
LDA TUBER2:RTS		:\ Get byte

