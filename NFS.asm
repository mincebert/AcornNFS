.L8000   :JMP L80E1           :\ Language entry, used for Remote Procedure Call dispatch
.L8003   :JMP L80F7           :\ Service entry
.L8006   :EQUB &82            :\ ROM type
.L8007   :EQUB ROMCopy-L8000  :\ Copyright offset
IF ROM8K=0
 .L8008  :EQUB &83            :\ ROM Version, 3.xx with b7 set
          EQUS "DFS,"         :\ ROM Title
ELSE
 .L8008  :EQUB &03            :\ ROM Version, 3.xx
ENDIF
.L800D   :EQUS "NET"          :\ Rest of title, also "NET" command string
.ROMCopy :EQUB 0:EQUS "(C)"
.L8014   :EQUS "ROFF"         :\ "ROFF" command string

\ Indexes into error messages
\ ---------------------------
.L8018
EQUB L8580-L8580 :\ Line jammed
EQUB L858D-L8580 :\ Net error
EQUB L8598-L8580 :\ Not listening
EQUB L85A7-L8580 :\ No clock
EQUB L85B1-L8580 :\ Escape
EQUB L85B1-L8580 :\ Escape
EQUB L85B1-L8580 :\ Escape
EQUB L85B9-L8580 :\ Bad option
EQUB L85C5-L8580 :\ No reply

\ Machine type
\ ------------
.L8021
IF TARGET=0
 EQUW &0006			:\ Machine type=Electron
ELIF TARGET=1 OR TARGET=2
 EQUW &0001			:\ Machine type=BBC
ELIF TARGET>2
 EQUW &0005			:\ Machine type=Master 128
ENDIF
EQUW VERSION			:\ NFS Version

\ Dispatch table address low bytes
\ ================================
\
.L8025
\ Service routines
\ ----------------
\ On entry, X=?&BB, Y=Y parameter, Cy=Clear (Cy=Set if Serv18)
\           ?&A8=Y parameter, ?&A9=service number
\           Flags set from X
\
\ On exit,  ?&A9=A result, Y=Y result
\
EQUB (L80F6-1) AND 255:\  0 - Null
EQUB (L82BC-1) AND 255:\  1 - AbsoluteWS
EQUB (L82C5-1) AND 255:\  2 - PrivateWS
EQUB (L821D-1) AND 255:\  3 - BootFS
EQUB (L81B5-1) AND 255:\  4 - UKCommand
EQUB (L963C-1) AND 255:\  5 - Serv5
EQUB (L80F6-1) AND 255:\  6 - Serv6
EQUB (L806F-1) AND 255:\  7 - UKByte
EQUB (L8E87-1) AND 255:\  8 - UKWord
EQUB (L8208-1) AND 255:\  9 - Help
EQUB (L80F6-1) AND 255:\ 10 - ServA
EQUB (L9639-1) AND 255:\ 11 - ServB
EQUB (L9636-1) AND 255:\ 12 - ServC
EQUB (L81F1-1) AND 255:\ 18 - FSSelect

\ Remote Procedure Calls
\ ----------------------
\ On entry, ???
\
EQUB (L84FD-1) AND 255 :\ RPC 0 - Character arrived from Notify
EQUB (L84AF-1) AND 255 :\ RPC 1 - Initialise Remote
EQUB (L92AB-1) AND 255 :\ RPC 2 - Read VIEW parameters
EQUB (L84DD-1) AND 255 :\ RPC 3 - Generate fatal error (start Remote)
EQUB (L84ED-1) AND 255 :\ RPC 4 - Character arrived from Remote

\ FSCV routines
\ -------------
\ On entry, &F2/3, &BB/C, &BE/F=>command line
\           &BD=function
\           X=X parameter (from &BB)
\           Y=Y parameter
\           Flags set from X
\
EQUB (L8A2C-1) AND 255 :\ FSC 0 - *Opt
EQUB (L88AD-1) AND 255 :\ FSC 1 - =EOF
EQUB (L8DDC-1) AND 255 :\ FSC 2 - *RUN
EQUB (L8C1B-1) AND 255 :\ FSC 3 - *command
EQUB (L8DDC-1) AND 255 :\ FSC 4 - */
EQUB (L8C67-1) AND 255 :\ FSC 5 - *CAT
EQUB (L8351-1) AND 255 :\ FSC 6 - New FS taking over
EQUB (L86CB-1) AND 255 :\ FSC 7 - Request handle range

\ Return values from Net_FSOp 0 - Decode command line
\ ---------------------------------------------------
\ On entry, X=?&BB, Y=A from caller, Cy from caller
\
EQUB (L8D96-1) AND 255 :\ FSOp 1 -
EQUB (L8E38-1) AND 255 :\ FSOp 2 - Load
EQUB (L8E39-1) AND 255 :\ FSOp 3 - Save
EQUB (L8E32-1) AND 255 :\ FSOp 4 -
EQUB (L8DE2-1) AND 255 :\ FSOp 5 -
EQUB (L8E2D-1) AND 255 :\ FSOp 6 - I AM

\ OSBYTE calls
\ ------------
\ On entry, X=?&BB, Y=Y parameter, Carry=Clear
\           ?&A9=0
\ On exit,
\
EQUB (L8E67-1) AND 255 :\ OSBYTE &32 (50) - Poll network transmit
EQUB (L8E6D-1) AND 255 :\ OSBYTE &33 (51) - Poll network receive
EQUB (L8E7D-1) AND 255 :\ OSBYTE &34 (52) - Delete receive control block
EQUB (L81BC-1) AND 255 :\ OSBYTE &35 (53) - Disconnect remote connection

\ Dispatch table address high bytes
\ ================================
.L804A
\ Service routines
\ ----------------
EQUB (L80F6-1) DIV 256:\  0 - Null
EQUB (L82BC-1) DIV 256:\  1 - AbsoluteWS
EQUB (L82C5-1) DIV 256:\  2 - PrivateWS
EQUB (L821D-1) DIV 256:\  3 - BootFS
EQUB (L81B5-1) DIV 256:\  4 - UKCommand
EQUB (L963C-1) DIV 256:\  5 - Serv5
EQUB (L80F6-1) DIV 256:\  6 - Serv6
EQUB (L806F-1) DIV 256:\  7 - UKByte
EQUB (L8E87-1) DIV 256:\  8 - UKWord
EQUB (L8208-1) DIV 256:\  9 - Help
EQUB (L80F6-1) DIV 256:\ 10 - ServA
EQUB (L9639-1) DIV 256:\ 11 - ServB
EQUB (L9636-1) DIV 256:\ 12 - ServC
EQUB (L81F1-1) DIV 256:\ 18 - FSSelect

\ Remote Procedure Calls
\ ----------------------
EQUB (L84FD-1) DIV 256 :\ RPC 0 - Character arrived from Notify
EQUB (L84AF-1) DIV 256 :\ RPC 1 - Initialise Remote
EQUB (L92AB-1) DIV 256 :\ RPC 2 - Read VIEW parameters
EQUB (L84DD-1) DIV 256 :\ RPC 3 - Generate fatal error (start Remote)
EQUB (L84ED-1) DIV 256 :\ RPC 4 - Character arrived from Remote

\ FSCV routines
\ -------------
\ On entry, 
EQUB (L8A2C-1) DIV 256 :\ FSC 0 - *Opt
EQUB (L88AD-1) DIV 256 :\ FSC 1 - =EOF
EQUB (L8DDC-1) DIV 256 :\ FSC 2 - *RUN
EQUB (L8C1B-1) DIV 256 :\ FSC 3 - *command
EQUB (L8DDC-1) DIV 256 :\ FSC 4 - */
EQUB (L8C67-1) DIV 256 :\ FSC 5 - *CAT
EQUB (L8351-1) DIV 256 :\ FSC 6 - New FS taking over
EQUB (L86CB-1) DIV 256 :\ FSC 7 - Request handle range

\ Return values from Net_FSOp 0 - Decode command line
\ ---------------------------------------------------
EQUB (L8D96-1) DIV 256 :\ FSOp 1 -
EQUB (L8E38-1) DIV 256 :\ FSOp 2 - Load
EQUB (L8E39-1) DIV 256 :\ FSOp 3 - Save
EQUB (L8E32-1) DIV 256 :\ FSOp 4 -
EQUB (L8DE2-1) DIV 256 :\ FSOp 5 -
EQUB (L8E2D-1) DIV 256 :\ FSOp 6 - I AM

\ OSBYTE calls
\ ------------
EQUB (L8E67-1) DIV 256 :\ OSBYTE &32 (50) - Poll network transmit
EQUB (L8E6D-1) DIV 256 :\ OSBYTE &33 (51) - Poll network receive
EQUB (L8E7D-1) DIV 256 :\ OSBYTE &34 (52) - Delete receive control block
EQUB (L81BC-1) DIV 256 :\ OSBYTE &35 (53) - Disconnect remote connection


\ SERVICE 7 - OSBYTE HANDLER
\ ==========================
\ Entered with Carry Clear
.L806F
LDA &EF:SBC #&31              :\ Get OSBYTE number and reduce range 50-53 to 0-3
CMP #&04:BCS L80E3            :\ OSBYTE call<50 or >53, jump to exit
TAX:LDA #&00:STA &A9:TYA
LDY #&21:BNE L80E7            :\ Jump to dispatch

\ *I AM [[net.]stn] user [<colon>|password]
\ =========================================
.L8081
INY

\ Enters here
\ -----------
.L8082
LDA (&BB),Y:CMP #&20:BEQ L8081:\ Skip spaces
CMP #&3A:BCS L809D            :\ Jump if colon or not digit
JSR L8677:BCC L8098           :\ Read number, jump past if not a number or not net number
STA &0E01:INY                 :\ Set file server net number
JSR L8677                     :\ Read another number for station
.L8098
BEQ L809D:STA &0E00           :\ Jump past if not a number, set file server station number

\ File server set to any [[net.]stn]
\ ----------------------------------
.L809D
JSR L8D82                     :\ Copy whole of command line to &0F05 to send to server
.L80A0
DEY:BEQ L80C5                 :\ Null string, jump forward, just "I AM" or "I AM [net.]stn"
LDA &0F05,Y                   :\ Get last character copied
CMP #&3A:BNE L80A0            :\ Not a colon, skip concealed password
JSR OSWRCH                    :\ print colon prompt
.L80AD
JSR L84A1                     :\ Check for Escape
JSR OSRDCH:STA &0F05,Y        :\ Get character and append to string in NetFS_Op buffer
INY:INX:CMP #&0D:BNE L80AD    :\ Step to next, loop until <cr> entered
JSR OSNEWL:BNE L80A0          :\ Print newline and branch to check for another colon


\ *I. and unmatched *command - pass to file server via FSOp_CommandLine
\ =====================================================================
.L80C1
JSR L8D82:TAY                 :\ Copy command line to NetFS_Op buffer
.L80C5
JSR L83C7                     :\ Transmit NetFS_Op 0 to server and get reply (checks for errors)
LDX &0F03:BEQ L80F6           :\ Ok, all done, return
LDA &0F05:LDY #&17            :\ Get CommandLine command
BNE L80E7                     :\ Jump to dispatch to handler routine


\ FSC
\ ===
.L80D4
JSR L8649                     :\ Store XY in &F2/3, &BB/C and &BE/F, store A in &BD
CMP #&08:BCS L80F6            :\ If call>7, jump to exit
TAX:TYA:LDY #&13:BNE L80E7    :\ Index into table and jump to dispatch to handler


\ Remote Procedure Call handler
\ =============================
.L80E1
CPX #&05        :\ Check RPC call number
.L80E3
BCS L80F6       :\ Out of range, ignore and return
LDY #&0E        :\ Offset 14 into dispatch table

\ Index into dispatch table and dispatch call
\ -------------------------------------------
.L80E7
INX:DEY:BPL L80E7:TAY         :\ Index into dispatch table
LDA L804A-1,X:PHA             :\ Get address high byte
LDA L8025-1,X:PHA             :\ Get address low byte
LDX &BB                       :\ Get X from &BB
.L80F6
RTS                           :\ Jump to routine


\ SERVICE HANDLER
\ ===============
.L80F7
IF ROM8K=0
 BIT &028F:PHP:BPL L8100      :\ If NFS priority, jump to NFS service handler
 JSR L9F9D                    :\ Call DFS service handler
ENDIF

\ NFS Service Handler
\ -------------------
.L8100
PHA:CMP #&01:BNE L811A        :\ Not Service 1, skip hardware check
LDA &FEA0:AND #&ED:BNE L8113  :\ Econet hardware absent, jump to disable
LDA &FEA1:AND #&DB:BEQ L811A  :\ Econet hardware present, jump to continue
.L8113
ROL &0DF0,X:SEC:ROR &0DF0,X   :\ Disable NFS in ROM workspace byte
.L811A
LDA &0DF0,X:ASL A             :\ Get NFS enable/disable flag
PLA:BMI L8123                 :\ Jump ahead with high numbered service calls, A>&7F
BCS L8191                     :\ Exit if NFS disabled
.L8123
CMP #&FE:BCC L8183            :\ Not Tube service call, jump ahead to NFS service handler

\ Tube Host service handler
\ =========================
BNE L8144                     :\ Not &FE, jump to Service &FF routine
CPY #&00:BEQ L8183            :\ No Tube, exit
LDX #&06:LDA #&14:JSR OSBYTE  :\ Explode font
.L8134
BIT &FEE0:BPL L8134           :\ Wait for character
LDA &FEE1:BEQ L8181           :\ End on CHR$0
JSR OSWRCH:JMP L8134          :\ Print it and loop back

.L8144
LDA #(L06AD-TUBE4) AND 255:STA &0220 :\ Claim EVENTV
LDA #(L06AD-TUBE4) DIV 256:STA &0221
LDA #(L0016-TUBE0) AND 255:STA &0202 :\ Claim BRKV
LDA #(L0016-TUBE0) DIV 256:STA &0203
LDA #&8E:STA &FEE0
LDY #&00
.L815F
LDA TubeCode+&000,Y:STA &0400,Y :\ Copy Tube host code
LDA TubeCode+&100,Y:STA &0500,Y
LDA TubeCode+&200,Y:STA &0600,Y
DEY:BNE L815F
JSR L0421-TUBE4              :\ Initialise Tube host
LDX #&60
.L8179
LDA TubeZero,X:STA &16,X	:\ Copy Tube idle code
DEX:BPL L8179
.L8181
LDA #&00

\ NFS Service Handler
\ ===================
.L8183
CMP #&12:BNE L818F       :\ Not FSSelect, jump past
CPY #&05:BNE L818F       :\ Not Select NFS, jump past
LDA #&0D:BNE L8193       :\ Jump forward to dispatch as service routine 13
.L818F
CMP #&0D                 :\ Check for service call 13
.L8191
BCS L81AF                :\ Exit if service 13 or greater
.L8193
TAX                      :\ Pass service number to X
LDA &A9:PHA:LDA &A8:PHA  :\ Save some workspace
STX &A9:STY &A8          :\ &A8=Y parameters, &A9=service number
TYA:LDY #&00             :\
JSR L80E7                :\ Call subroutine dispatcher with Carry Clear (CS if Serv18)
LDX &A9                  :\ Get any result from &A9
PLA:STA &A8:PLA:STA &A9  :\ Restore workspace
TXA:LDX &F4              :\ Pass result to A, restore X
.L81AF
IF ROM8K=0
 PLP:BMI L81E9           :\ DFS already called earlier, jump to exit
 JMP L9F9D               :\ Continue into DFS service handler
ELSE
 RTS
ENDIF

\ SERVICE 4 - *COMMAND
\ ====================
.L81B5
LDX #L8014-L8008         :\ Point to 'ROFF' command
JSR L8362:BNE L81EA      :\ Not *ROFF, jump to check for *NET

\ OSBYTE &35 (53) - Disconnect REMOTE connection
\ ----------------------------------------------
.L81BC
LDY #&04                 :\ get 'remoted' flag
LDA (&9C),Y:BEQ L81E3    :\ Not Remoted, exit
LDA #&00:TAX:STA (&9C),Y :\ Set 'not remoted'
TAY:LDA #&C9:JSR OSBYTE  :\ *FX201,0,0 - enable keyboard
LDA #&0A:JSR L90C4
.L81D2
STX &9E                  :\ Use &9E/F pointer to hold flag
LDA #&CE                 :\ Do OSBYTE &CE, &CF, &D0
.L81D6
LDX &9E:LDY #&7F:JSR OSBYTE  :\ Set/Clear b7 of intercept OSBYTEs
ADC #&01:CMP #&D0:BEQ L81D6  :\ Step to next OSBYTE
.L81E3
LDA #&00:STA &A9         :\ Claim service call
STA &9E                  :\ Restore &9E/F pointer
.L81E9
RTS

.L81EA
LDX #L800D-L8008         :\ Point to 'NET' command
JSR L8362:BNE L8215      :\ Not *NET, jump to exit
                         :\ Fall through to select NFS


\ SERVICE 12,5 - Select filing system
\ ===================================
.L81F1
JSR L8218       :\ 81F1= 20 18 82     ..
SEC             :\ 81F4= 38          8
ROR &A8         :\ 81F5= 66 A8       f(
JSR L827B       :\ 81F7= 20 7B 82     {.
LDY #&1D        :\ 81FA= A0 1D        .
.L81FC
LDA (&9C),Y     :\ 81FC= B1 9C       1.
STA &0DEB,Y     :\ 81FE= 99 EB 0D    .k.
DEY             :\ 8201= 88          .
CPY #&14        :\ 8202= C0 14       @.
BNE L81FC       :\ 8204= D0 F6       Pv
BEQ L8264       :\ 8206= F0 5C       p\


\ SERVICE 9 - HELP
\ ================
.L8208
JSR L865C			:\ Print inline text
EQUB 13:EQUS "NFS "
EQUB (VERSION DIV 256)+48	:\ Version string
EQUB "."
EQUB ((VERSION AND &F0)DIV 16)+48
EQUB (VERSION AND &0F)+48
IF TARGET=0
 EQUS "E"			:\ Electron
ELIF TARGET>=3
 EQUS "M"			:\ Master
ENDIF
EQUB 13
.L8215
LDY &A8:RTS              :\ Restore Y and return

\ Warn current filing system
\ -------------------------- 
.L8218
LDA #&06:JMP (&021E)     :\ Filing system taking over

\ SERVICE 3 - Boot filing system
\ ==============================
.L821D
JSR L8218                :\ Warn current filing system (bug? too early)
LDA #&7A:JSR OSBYTE      :\ Check for keys pressed
TXA:BMI L8232            :\ No key pressed, select NFS
EOR #&55:BNE L8215       :\ 'N' pressed not pressed, exit
TAY:LDA #&78:JSR OSBYTE  :\ Write keys to cancel 'N' pressed
.L8232
JSR L865C                :\ Print inline text
EQUS "Econet Station "
LDY #&14:LDA (&9C),Y     :\ Get station number
JSR L8DBD                :\ Print it in decimal
LDA #&20:BIT &FEA1       :\ Test ALDC clock
BEQ L825F                :\ Skip past if clock present
JSR L865C                :\ Print inline text
EQUS " No Clock"
NOP
.L825F
JSR L865C                :\ Print inline text
EQUB 13:EQUB 13          :\ Two newlines
\                        :\ Drop through to select filing system

\ Select filing system
\ --------------------
.L8264
LDY #&0D
.L8266
LDA L829A,Y:STA &0212,Y  :\ Set up filing system vectors
DEY:BPL L8266
.L826F
JSR L8325       :\ 826F= 20 25 83     %.
LDY #&1B        :\ 8272= A0 1B        .
LDX #&07        :\ 8274= A2 07       ".
JSR L8339       :\ 8276= 20 39 83     9.
STX &A9         :\ 8279= 86 A9       .)
.L827B
LDA #&8F        :\ 827B= A9 8F       ).
.L827D
LDX #&0F        :\ 827D= A2 0F       ".
JSR OSBYTE      :\ 827F= 20 F4 FF     t.
LDX #&0A        :\ 8282= A2 0A       ".
JSR OSBYTE      :\ 8284= 20 F4 FF     t.
LDX &A8:BNE L82C2       :\ No boot, jump to return
LDX #L8292 AND 255      :\ Point to 'I .BOOT' command
.L828D
LDY #L8292 DIV 256
JMP L8C1B               :\ Jump to do FSOp_Command

.L8292
EQUS "I .BOOT":EQUB 13

.L829A
EQUW &FF1B      :\ 829A= 1B FF       .. - FILEV
EQUW &FF1E      :\ 829C= 1E FF       .. - ARGSV
EQUW &FF21      :\ 829E= 21 FF       !. - BGETV
EQUW &FF24      :\ 82A0= 24 FF       $. - BPUTV
EQUW &FF27      :\ 82A2= 27 FF       '. - GBPBV
EQUW &FF2A      :\ 82A4= 2A FF       *. - FINDV
EQUW &FF2D      :\ 82A6= 2D FF       -. - FSCV

EQUW L870C:EQUB "J" :\ FILE
EQUW L8968:EQUB "D" :\ ARGS
EQUW L8563:EQUB "W" :\ BGET
EQUW L8413:EQUB "B" :\ BPUT
EQUW L8A72:EQUB "A" :\ GBPB
EQUW L89D8:EQUB "R" :\ FIND
EQUW L80D4          :\ FSC

.L82BC
CPY #&10        :\ 82BC= C0 10       @.
BCS L82C2       :\ 82BE= B0 02       0.
LDY #&10        :\ 82C0= A0 10        .
.L82C2
RTS             :\ 82C2= 60          `
 
EQUW L9080      :\ 82C3= 80 90       ..   9080 - NETV
 
\ SERVICE CALL 2 - PRIVATE WORKSPACE
\ ==================================
.L82C5
STY &9D         :\ 82C5= 84 9D       ..
INY             :\ 82C7= C8          H
STY &9F         :\ 82C8= 84 9F       ..
LDA #&00        :\ 82CA= A9 00       ).
LDY #&04        :\ 82CC= A0 04        .
STA (&9C),Y     :\ 82CE= 91 9C       ..
LDY #&FF        :\ 82D0= A0 FF        .
STA &9C         :\ 82D2= 85 9C       ..
STA &9E         :\ 82D4= 85 9E       ..
STA &A8         :\ 82D6= 85 A8       .(
STA &0D62       :\ 82D8= 8D 62 0D    .b.
TAX             :\ 82DB= AA          *
LDA #&FD        :\ 82DC= A9 FD       )}
JSR OSBYTE      :\ 82DE= 20 F4 FF     t.
TXA             :\ 82E1= 8A          .
BEQ L8316       :\ 82E2= F0 32       p2
LDY #&15        :\ 82E4= A0 15        .
LDA #&FE        :\ Default fileserver station number
STA &0E00       :\ 82E8= 8D 00 0E    ...
STA (&9C),Y     :\ 82EB= 91 9C       ..
LDA #&00        :\ Default fileserver and printserver network number
STA &0E01       :\ 82EF= 8D 01 0E    ...
STA &0D63       :\ 82F2= 8D 63 0D    .c.
STA &0E06       :\ Set *OPT 1,0
STA &0E05       :\ 82F8= 8D 05 0E    ...
INY             :\ 82FB= C8          H
STA (&9C),Y     :\ 82FC= 91 9C       ..
LDY #&03        :\ 82FE= A0 03        .
STA (&9E),Y     :\ 8300= 91 9E       ..
DEY             :\ 8302= 88          .
LDA #&EB        :\ Default printserver station number
STA (&9E),Y     :\ 8305= 91 9E       ..
.L8307
LDA &A8         :\ 8307= A5 A8       %(
JSR L8E55       :\ Y=A*12, index into receive buffer
BCS L8316       :\ All done
LDA #&3F:STA (&9E),Y     :\ Clear receive buffer
INC &A8:BNE L8307        :\ Step to next buffer
.L8316
LDA &FE18              :\ Read hardware links
LDY #&14:STA (&9C),Y   :\ Store my station number
JSR L9633
LDA #&40:STA &0D64
.L8325
LDA #&A8        :\ 8325= A9 A8       )(
LDX #&00        :\ 8327= A2 00       ".
LDY #&FF        :\ 8329= A0 FF        .
JSR OSBYTE      :\ 832B= 20 F4 FF     t.
STX &F6         :\ 832E= 86 F6       .v
STY &F7         :\ 8330= 84 F7       .w
LDY #&36        :\ 8332= A0 36        6
STY &0224       :\ 8334= 8C 24 02    .$.
LDX #&01        :\ 8337= A2 01       ".
.L8339
LDA L828D,Y     :\ 8339= B9 8D 82    9..
STA (&F6),Y     :\ 833C= 91 F6       .v
INY             :\ 833E= C8          H
LDA L828D,Y     :\ 833F= B9 8D 82    9..
STA (&F6),Y     :\ 8342= 91 F6       .v
INY             :\ 8344= C8          H
LDA &F4         :\ 8345= A5 F4       %t
STA (&F6),Y     :\ 8347= 91 F6       .v
INY             :\ 8349= C8          H
DEX             :\ 834A= CA          J
BNE L8339       :\ 834B= D0 EC       Pl
LDY &9F         :\ 834D= A4 9F       $.
INY             :\ 834F= C8          H
RTS             :\ 8350= 60          `


\ FSC 6 - New filing system about to be selected
\ ==============================================
.L8351 
LDY #&1D
.L8353
LDA &0DEB,Y:STA (&9C),Y     :\ Copy to private workspace
DEY:CPY #&14:BNE L8353
LDA #&77:JMP OSBYTE         :\ Close Spool/Exec files


\ Compare string at &F2 command table at &8008
\ --------------------------------------------
\ On entry, X=>string to match offset from &8008
.L8362
LDY &A8                  :\ Get string pointer
.L8364
LDA (&F2),Y              :\ Get character
CMP #&2E:BEQ L837D       :\ dot - jump to match
AND #&DF:BEQ L8377       :\ Ensure upper case
CMP L8008,X:BNE L8377    :\ No match, check for end of string
INY:INX:BNE L8364        :\ Loop for next character
.L8377
LDA L8008,X:BEQ L837E    :\ End of entry, check for end of command string
RTS                      :\ Return NE - no match
.L837D
INY                      :\ Step past dot
.L837E
LDA (&F2),Y              :\ Get next character
CMP #&20:BEQ L837D       :\ Space - exit matched
EOR #&0D:RTS             :\ CR - exit matched

\ Make a private Rx block receiving on port &90
\ ---------------------------------------------
.L8387
LDA #&90
.L8389
JSR L8395       :\ Copy Tx block to &C0-&CC
STA &C1         :\ Change port to &90
LDA #&03:STA &C4:\ RxAddr=&FFFF0F03
DEC &C0:RTS     :\ Change Ctrl to &7F
 
.L8395
PHA             :\ 8395= 48          H
LDY #&0B        :\ 8396= A0 0B        .
.L8398
LDA L83AD,Y     :\ 8398= B9 AD 83    9-.
STA &00C0,Y     :\ 839B= 99 C0 00    .@.
CPY #&02        :\ 839E= C0 02       @.
BPL L83A8       :\ 83A0= 10 06       ..
LDA &0E00,Y     :\ 83A2= B9 00 0E    9..
STA &00C2,Y     :\ 83A5= 99 C2 00    .B.
.L83A8
DEY             :\ 83A8= 88          .
BPL L8398       :\ 83A9= 10 ED       .m
PLA             :\ 83AB= 68          h
RTS             :\ 83AC= 60          `
 
.L83AD
EQUW &9980      :\ 83AD= 80 99       ..
 
BRK             :\ 83AF= 00          .
BRK             :\ 83B0= 00          .
BRK             :\ 83B1= 00          .
EQUB &0F        :\ 83B2= 0F          .
.L83B3
EQUB &FF        :\ 83B3= FF          .
EQUB &FF        :\ 83B4= FF          .
EQUB &FF        :\ 83B5= FF          .
EQUB &0F        :\ 83B6= 0F          .
EQUB &FF        :\ 83B7= FF          .
EQUB &FF        :\ 83B8= FF          .
.L83B9
PHA             :\ 83B9= 48          H
SEC             :\ 83BA= 38          8
BCS L83CF       :\ 83BB= B0 12       0.
.L83BD
CLV:BVC L83CE


\ *BYE - close files and log off server
\ =====================================
.L83C0
LDA #&77:JSR OSBYTE      :\ Close SPOOL and EXEC files
LDY #&17                 :\ Continue to do FSOp &17 - Logoff


\ Send FSOp and check for returned error
\ ======================================
\ On entry, Y=FSOp, FSOp buffer at &0F05 holds data
\ On entry to L83C8, if V set return errors
\ On exit, A=0 Ok, A<>0 error+42 (if VS on entry), Cy=error 214, File not found
\          X=0 Ok, X<>0 error (if VS on entry)
\          Y=0
\
.L83C7
CLV
.L83C8
LDA &0E02:STA &0F02      :\ Store URD handle in FSOp block
.L83CE
CLC
.L83CF
STY &0F01:LDY #&01       :\ Store FSOp function code
.L83D4
LDA &0E03,Y:STA &0F03,Y  :\ Store CSD and LIB handles
DEY:BPL L83D4
.L83DD
PHP:LDA #&90:STA &0F00   :\ Set reply port to &90
JSR L8395                :\ Set up NetTx control block on port &99
TXA:ADC #&05:STA &C8     :\ X+5 to get end of transmitted data
PLP:BCS L8408
PHP:JSR L85F7:PLP
.L83F3
PHP:JSR L8387            :\ Set up NetRx control block on port &90, rx to &FFFF0F03
JSR L8530:PLP            :\ Wait for reply to &00C0
.L83FB
INY:LDA (&C4),Y          :\ Get return result
TAX:BEQ L8407:BVC L8405  :\ If zero, return ok
ADC #&2A                 :\ If V was set on entry, add 42 so Cy=File not Found
.L8405
BNE L847A                :\ If result<>0, generate an error
.L8407
RTS
 
.L8408
PLA             :\ 8408= 68          h
LDX #&C0        :\ 8409= A2 C0       "@
INY             :\ 840B= C8          H
JSR L9266       :\ 840C= 20 66 92     f.
STA &B3         :\ 840F= 85 B3       .3
BCC L83FB       :\ 8411= 90 E8       .h

\ BPUT
.L8413
CLC             :\ 8413= 18          .
.L8414
JSR L8657       :\ Set a flag
PHA             :\ 8417= 48          H
STA &0FDF       :\ 8418= 8D DF 0F    ._.
TXA             :\ 841B= 8A          .
PHA             :\ 841C= 48          H
TYA             :\ 841D= 98          .
PHA             :\ 841E= 48          H
PHP             :\ 841F= 08          .
STY &BA         :\ 8420= 84 BA       .:
JSR L869B       :\ 8422= 20 9B 86     ..
STY &0FDE       :\ 8425= 8C DE 0F    .^.
STY &CF         :\ 8428= 84 CF       .O
LDY #&90        :\ 842A= A0 90        .
STY &0FDC       :\ 842C= 8C DC 0F    .\.
JSR L8395       :\ 842F= 20 95 83     ..
LDA #&DC        :\ 8432= A9 DC       )\
STA &C4         :\ 8434= 85 C4       .D
LDA #&E0        :\ 8436= A9 E0       )`
STA &C8         :\ 8438= 85 C8       .H
INY             :\ 843A= C8          H
LDX #&09        :\ 843B= A2 09       ".
PLP             :\ 843D= 28          (
BCC L8441       :\ 843E= 90 01       ..
DEX             :\ 8440= CA          J
.L8441
STX &0FDD       :\ 8441= 8E DD 0F    .].
LDA &CF         :\ 8444= A5 CF       %O
LDX #&C0        :\ 8446= A2 C0       "@
JSR L9266       :\ 8448= 20 66 92     f.
LDX &0FDD       :\ 844B= AE DD 0F    .].
BEQ L8498       :\ 844E= F0 48       pH
LDY #&1F        :\ 8450= A0 1F        .
.L8452
LDA &0FDC,Y     :\ 8452= B9 DC 0F    9\.
STA &0FE0,Y     :\ 8455= 99 E0 0F    .`.
DEY             :\ 8458= 88          .
BPL L8452       :\ 8459= 10 F7       .w
TAX             :\ 845B= AA          *
LDA #&C6:JSR OSBYTE      :\ Get Spool & Exec handles to X and Y
LDA #L8529 AND 255       :\ Point to 'SP.'
CPY &BA:BEQ L846D        :\ If &BA=Spool handle, jump to close it with *SPOOL
LDA #L852D AND 255       :\ Point to 'E.'
CPX &BA:BNE L8473        :\ If ?&BA=Exec handle, jump to close it with *EXEC
.L846D
TAX:LDY #L8529 DIV 256   :\ XY=>'SP.' or 'E.' string
JSR OS_CLI               :\ Execute command to close Spool or Exec
.L8473
LDA #&E0        :\ 8473= A9 E0       )`
STA &C4         :\ 8475= 85 C4       .D
LDX &0FDD       :\ 8477= AE DD 0F    .].
:
.L847A
STX &0E09       :\ 847A= 8E 09 0E    ...
LDY #&01        :\ 847D= A0 01        .
CPX #&A8        :\ 847F= E0 A8       `(
BCS L8487       :\ 8481= B0 04       0.
LDA #&A8        :\ 8483= A9 A8       )(
STA (&C4),Y     :\ 8485= 91 C4       .D
.L8487
LDY #&FF        :\ 8487= A0 FF        .
.L8489
INY             :\ 8489= C8          H
LDA (&C4),Y     :\ 848A= B1 C4       1D
STA &0100,Y     :\ 848C= 99 00 01    ...
EOR #&0D        :\ 848F= 49 0D       I.
BNE L8489       :\ 8491= D0 F6       Pv
STA &0100,Y     :\ 8493= 99 00 01    ...
BEQ L84EA       :\ 8496= F0 52       pR
.L8498
STA &0E08       :\ 8498= 8D 08 0E    ...
PLA             :\ 849B= 68          h
TAY             :\ 849C= A8          (
PLA             :\ 849D= 68          h
TAX             :\ 849E= AA          *
PLA             :\ 849F= 68          h
.L84A0
RTS             :\ 84A0= 60          `
 
.L84A1
LDA &FF         :\ 84A1= A5 FF       %.
AND &97         :\ 84A3= 25 97       %.
BPL L84A0       :\ 84A5= 10 F9       .y
LDA #&7E        :\ 84A7= A9 7E       )~
JSR OSBYTE      :\ 84A9= 20 F4 FF     t.
JMP L8512       :\ 84AC= 4C 12 85    L..


\ Remote OS Call 1 - Initialise for Remote
\ ========================================
.L84AF
LDY #&04:LDA (&9C),Y:BEQ L84B8    :\ Not remoted, jump to set up
.L84B5
JMP L92F0                :\ Already remoted, restore PROT and exit

.L84B8
ORA #&09:STA (&9C),Y     :\ Set b0,b3
LDX #&80
LDY #&80:LDA (&9C),Y     :\ Get station number
PHA:INY:LDA (&9C),Y      :\ Get network number
LDY #&0F:STA (&9E),Y     :\ Set NetRx 1 to listen to Remoter's network
DEY:PLA:STA (&9E),Y      :\ Set NetRx 1 to listen to Remoter's station
JSR L81D2                :\ Call OSBYTEs to turn intercept on
JSR L9188                :\ Copy stuff around workspace
LDX #&01:LDY #&00
LDA #&C9:JSR OSBYTE      :\ *FX201,1 - disable keyboard


\ Remote OS Call 3 - Generate fatal error
\ =======================================
.L84DD
JSR L92F0:LDX #&02:LDA #&00
.L84E4
STA &0100,X:DEX:BPL L84E4 :\ Copy null error to &100
.L84EA
JMP &0100                 :\ Jump to error


\ Remote OS Call 4 - Character arrived from Remote
\ ================================================
.L84ED 
LDY #&04:LDA (&9C),Y     :\ Is machine remoted?
BEQ L84B8                :\ No, jump to initialise Remote
LDY #&80:LDA (&9C),Y     :\ Get incoming station number
LDY #&0E:CMP (&9E),Y     :\ Is it the one we're listening to?
BNE L84B5                :\ No, exit

\ Remote OS Call 0 - Character arrived from Notify
\ ================================================
.L84FD
LDY #&82:LDA (&9C),Y     :\ Get character
TAY:LDX #&00:JSR L92F0   :\ Restore protection mask
LDA #&99:JMP OSBYTE      :\ Enter character in keyboard buffer
 
.L850C
LDA #&08:BNE L8514

.L8510
LDA (&9A,X)     :\ 8510= A1 9A       !.
.L8512
AND #&07        :\ 8512= 29 07       ).

\ Copy error to &0100
\ -------------------
.L8514
TAX             :\ 8514= AA          *
LDY L8018,X     :\ 8515= BC 18 80    <..
LDX #&00        :\ 8518= A2 00       ".
STX &0100       :\ 851A= 8E 00 01    ...
.L851D
LDA L8580,Y     :\ 851D= B9 80 85    9..
STA &0101,X     :\ 8520= 9D 01 01    ...
BEQ L84EA       :\ 8523= F0 C5       pE
INY             :\ 8525= C8          H
INX             :\ 8526= E8          h
BNE L851D       :\ 8527= D0 F4       Pt

.L8529:EQUS "SP.":EQUB 13 :\ *SPOOL
.L852D:EQUS "E.":EQUB 13  :\ *EXEC

.L8530
LDA #&2A:PHA               :\ Push timeout=42
LDA &0D64:PHA              :\ Save current Rx flag
LDX &9B:BNE L8540          :\ &9A/B<>&00xx, skip past
ORA #&80:STA &0D64         :\ Flag that Rx is at &00C0
.L8540
LDA #&00:PHA:PHA:TAY:TSX   :\ Push counter=&0000
.L8546
LDA (&9A),Y:BMI L8559      :\ Get RxResult, b7=received
DEC &0101,X:BNE L8546      :\ Decrement timeout counter
DEC &0102,X:BNE L8546
DEC &0104,X:BNE L8546      :\ Decrement timeout
.L8559
PLA:PLA:PLA:STA &0D64      :\ Drop timer, restore Rx flag
PLA:BEQ L850C:RTS          :\ If timeout=0, jump to 'No reply' error

.L8563 
SEC             :\ 8563= 38          8
JSR L8414       :\ 8564= 20 14 84     ..
SEC             :\ 8567= 38          8
LDA #&FE        :\ 8568= A9 FE       )~
BIT &0FDF       :\ 856A= 2C DF 0F    ,_.
BVS L857F       :\ 856D= 70 10       p.
CLC             :\ 856F= 18          .
PHP             :\ 8570= 08          .
LDA &CF         :\ 8571= A5 CF       %O
PLP             :\ 8573= 28          (
BMI L8579       :\ 8574= 30 03       0.
JSR L86D5       :\ 8576= 20 D5 86     U.
.L8579
JSR L86D0       :\ 8579= 20 D0 86     P.
LDA &0FDE       :\ 857C= AD DE 0F    -^.
.L857F
RTS             :\ 857F= 60          `

\ Error messages
\ --------------
.L8580:EQUB &A0:EQUS "Line Jammed":EQUB 0
.L858D:EQUB &A1:EQUS "Net Error":EQUB 0
.L8598:EQUB &A2:EQUS "Not listening":EQUB 0
.L85A7:EQUB &A3:EQUS "No Clock":EQUB 0
.L85B1:EQUB &11:EQUS "Escape":EQUB 0
.L85B9:EQUB &CB:EQUS "Bad Option":EQUB 0
.L85C5:EQUB &A5:EQUS "No reply":EQUB 0

.L85CF
EQUW &0EA0      :\ 85CD= A0 0E
EQUW &BBB1      :\ 85CF= B1 BB       1;
AND #&3F        :\ 85D3= 29 3F       )?
LDX #&04        :\ 85D5= A2 04       ".
BNE L85DD       :\ 85D7= D0 04       P.
.L85D9
AND #&1F        :\ 85D9= 29 1F       ).
LDX #&FF        :\ 85DB= A2 FF       ".
.L85DD
STA &B8         :\ 85DD= 85 B8       .8
LDA #&00        :\ 85DF= A9 00       ).
.L85E1
INX             :\ 85E1= E8          h
LSR &B8         :\ 85E2= 46 B8       F8
BCC L85E9       :\ 85E4= 90 03       ..
ORA L85EC,X     :\ 85E6= 1D EC 85    .l.
.L85E9
BNE L85E1       :\ 85E9= D0 F6       Pv
RTS             :\ 85EB= 60          `
 
.L85EC
EQUW &2050      :\ 85EC= 50 20       P 
ORA &02         :\ 85EE= 05 02       ..
DEY             :\ 85F0= 88          .
EQUW &0804      :\ 85F1= 04 08       ..
EQUW &1080      :\ 85F3= 80 10       ..
 
ORA (&02,X)     :\ 85F5= 01 02       ..
.L85F7
LDX #&C0        :\ 85F7= A2 C0       "@
STX &9A         :\ 85F9= 86 9A       ..
LDX #&00        :\ 85FB= A2 00       ".
STX &9B         :\ 85FD= 86 9B       ..
.L85FF
LDA #&FF        :\ 85FF= A9 FF       ).
LDY #&60        :\ 8601= A0 60        `
PHA             :\ 8603= 48          H
TYA             :\ 8604= 98          .
.L8605
PHA             :\ 8605= 48          H
LDX #&00        :\ 8606= A2 00       ".
LDA (&9A,X)     :\ 8608= A1 9A       !.
.L860A
STA (&9A,X)     :\ 860A= 81 9A       ..
PHA             :\ 860C= 48          H
.L860D
ASL &0D62:BCC L860D  :\ Loop until no transmission
LDA &9A:STA &A0      :\ &A0/1=> ?
LDA &9B:STA &A1
JSR L9630            :\ Call low-level transmit driver
.L861D
LDA (&9A,X)     :\ 861D= A1 9A       !.
BMI L861D       :\ 861F= 30 FC       0|
ASL A           :\ 8621= 0A          .
BPL L8643       :\ 8622= 10 1F       ..
ASL A           :\ 8624= 0A          .
BEQ L863F       :\ 8625= F0 18       p.
JSR L84A1       :\ 8627= 20 A1 84     !.
PLA             :\ 862A= 68          h
TAX             :\ 862B= AA          *
PLA             :\ 862C= 68          h
TAY             :\ 862D= A8          (
PLA             :\ 862E= 68          h
BEQ L863F       :\ 862F= F0 0E       p.
SBC #&01        :\ 8631= E9 01       i.
PHA             :\ 8633= 48          H
TYA             :\ 8634= 98          .
PHA             :\ 8635= 48          H
TXA             :\ 8636= 8A          .
.L8637
DEX             :\ 8637= CA          J
BNE L8637       :\ 8638= D0 FD       P}
DEY             :\ 863A= 88          .
BNE L8637       :\ 863B= D0 FA       Pz
BEQ L860A       :\ 863D= F0 CB       pK
.L863F
TAX             :\ 863F= AA          *
JMP L8510       :\ 8640= 4C 10 85    L..
 
.L8643
PLA             :\ 8643= 68          h
PLA             :\ 8644= 68          h
PLA             :\ 8645= 68          h
JMP L8657       :\ 8646= 4C 57 86    LW.
 
.L8649
STX &F2         :\ 8649= 86 F2       .r
STY &F3         :\ 864B= 84 F3       .s
.L864D
STA &BD         :\ 864D= 85 BD       .=
STX &BB         :\ 864F= 86 BB       .;
STY &BC         :\ 8651= 84 BC       .<
STX &BE         :\ 8653= 86 BE       .>
STY &BF         :\ 8655= 84 BF       .?
.L8657
PHP             :\ 8657= 08          .
LSR &97         :\ 8658= 46 97       F.
PLP             :\ 865A= 28          (
RTS             :\ 865B= 60          `
 
\ Print inline text - could combine with DFS PrText code
.L865C
PLA             :\ 865C= 68          h
STA &B0         :\ 865D= 85 B0       .0
PLA             :\ 865F= 68          h
STA &B1         :\ 8660= 85 B1       .1
LDY #&00        :\ 8662= A0 00        .
.L8664
INC &B0         :\ 8664= E6 B0       f0
BNE L866A       :\ 8666= D0 02       P.
INC &B1         :\ 8668= E6 B1       f1
.L866A
LDA (&B0),Y     :\ 866A= B1 B0       10
BMI L8674       :\ 866C= 30 06       0.
JSR OSASCI      :\ 866E= 20 E3 FF     c.
JMP L8664       :\ 8671= 4C 64 86    Ld.
 
.L8674
JMP (&00B0)     :\ 8674= 6C B0 00    l0.
 
.L8677
LDA #&00        :\ 8677= A9 00       ).
STA &B2         :\ 8679= 85 B2       .2
.L867B
LDA (&BB),Y     :\ 867B= B1 BB       1;
CMP #&2E        :\ 867D= C9 2E       I.
BEQ L8697       :\ 867F= F0 16       p.
BCC L8696       :\ 8681= 90 13       ..
AND #&0F        :\ 8683= 29 0F       ).
STA &B3         :\ 8685= 85 B3       .3
ASL &B2         :\ 8687= 06 B2       .2
LDA &B2         :\ 8689= A5 B2       %2
ASL A           :\ 868B= 0A          .
ASL A           :\ 868C= 0A          .
ADC &B2         :\ 868D= 65 B2       e2
ADC &B3         :\ 868F= 65 B3       e3
STA &B2         :\ 8691= 85 B2       .2
INY             :\ 8693= C8          H
BNE L867B       :\ 8694= D0 E5       Pe
.L8696
CLC             :\ 8696= 18          .
.L8697
LDA &B2         :\ 8697= A5 B2       %2
RTS             :\ 8699= 60          `

\ Convert handle to bitmap 
.L869A
TAY             :\ 869A= A8          (
.L869B
CLC             :\ 869B= 18          .
.L869C
PHA             :\ 869C= 48          H
TXA             :\ 869D= 8A          .
PHA             :\ 869E= 48          H
TYA             :\ 869F= 98          .
BCC L86A4       :\ 86A0= 90 02       ..
BEQ L86B3       :\ 86A2= F0 0F       p.
.L86A4
SEC             :\ 86A4= 38          8
SBC #&1F        :\ 86A5= E9 1F       i.
TAX             :\ 86A7= AA          *
LDA #&01        :\ 86A8= A9 01       ).
.L86AA
ASL A           :\ 86AA= 0A          .
DEX             :\ 86AB= CA          J
BNE L86AA       :\ 86AC= D0 FC       P|
ROR A           :\ 86AE= 6A          j
TAY             :\ 86AF= A8          (
BNE L86B3       :\ 86B0= D0 01       P.
DEY             :\ 86B2= 88          .
.L86B3
PLA             :\ 86B3= 68          h
TAX             :\ 86B4= AA          *
PLA             :\ 86B5= 68          h
RTS             :\ 86B6= 60          `
 
.L86B7
LDX #&1F        :\ 86B7= A2 1F       ".
.L86B9
INX             :\ 86B9= E8          h
LSR A           :\ 86BA= 4A          J
BNE L86B9       :\ 86BB= D0 FC       P|
TXA             :\ 86BD= 8A          .
RTS             :\ 86BE= 60          `
 
.L86BF
LDX #&04        :\ 86BF= A2 04       ".
.L86C1
LDA &AF,X       :\ 86C1= B5 AF       5/
EOR &B3,X       :\ 86C3= 55 B3       U3
BNE L86CA       :\ 86C5= D0 03       P.
DEX             :\ 86C7= CA          J
BNE L86C1       :\ 86C8= D0 F7       Pw
.L86CA
RTS             :\ 86CA= 60          `


\ FSC 7 - Request file handles
\ ============================
.L86CB 
LDX #&20:LDY #&27:RTS  :\ Lowest handle=&20, highest handle=&27

.L86D0
ORA &0E07       :\ 86D0= 0D 07 0E    ...
BNE L86DA       :\ 86D3= D0 05       P.
.L86D5
EOR #&FF        :\ 86D5= 49 FF       I.
AND &0E07       :\ 86D7= 2D 07 0E    -..
.L86DA
STA &0E07       :\ 86DA= 8D 07 0E    ...
RTS             :\ 86DD= 60          `
 
.L86DE
LDY #&01        :\ 86DE= A0 01        .
.L86E0
LDA (&BB),Y     :\ 86E0= B1 BB       1;
STA &00F2,Y     :\ 86E2= 99 F2 00    .r.
DEY             :\ 86E5= 88          .
BPL L86E0       :\ 86E6= 10 F8       .x
.L86E8
LDY #&00        :\ 86E8= A0 00        .
.L86EA
LDX #&FF        :\ 86EA= A2 FF       ".
CLC             :\ 86EC= 18          .
JSR &FFC2       :\ 86ED= 20 C2 FF     B.
BEQ L86FD       :\ 86F0= F0 0B       p.
.L86F2
JSR &FFC5       :\ 86F2= 20 C5 FF     E.
BCS L86FD       :\ 86F5= B0 06       0.
INX             :\ 86F7= E8          h
STA &0E30,X     :\ 86F8= 9D 30 0E    .0.
BCC L86F2       :\ 86FB= 90 F5       .u
.L86FD
INX             :\ 86FD= E8          h
LDA #&0D        :\ 86FE= A9 0D       ).
STA &0E30,X     :\ 8700= 9D 30 0E    .0.
LDA #&30        :\ 8703= A9 30       )0
STA &BE         :\ 8705= 85 BE       .>
LDA #&0E        :\ 8707= A9 0E       ).
STA &BF         :\ 8709= 85 BF       .?
RTS             :\ 870B= 60          `


\ OSFILE - Perform whole file operation
\ =====================================
.L870C
JSR L864D       :\ 870C= 20 4D 86     M.
JSR L86DE       :\ 870F= 20 DE 86     ^.
LDA &BD         :\ 8712= A5 BD       %=
BPL L8790       :\ 8714= 10 7A       .z
CMP #&FF        :\ 8716= C9 FF       I.
BEQ L871D       :\ 8718= F0 03       p.
JMP L89B3       :\ 871A= 4C B3 89    L3.
 
.L871D
JSR L8D82       :\ 871D= 20 82 8D     ..
LDY #&02        :\ 8720= A0 02        .
.L8722
LDA #&92        :\ 8722= A9 92       ).
STA &97         :\ 8724= 85 97       ..
STA &0F02       :\ 8726= 8D 02 0F    ...
JSR L83BD       :\ 8729= 20 BD 83     =.
LDY #&06        :\ 872C= A0 06        .
LDA (&BB),Y     :\ 872E= B1 BB       1;
BNE L873A       :\ 8730= D0 08       P.
JSR L882F       :\ 8732= 20 2F 88     /.
JSR L8841       :\ 8735= 20 41 88     A.
BCC L8740       :\ 8738= 90 06       ..
.L873A
JSR L8841       :\ 873A= 20 41 88     A.
JSR L882F       :\ 873D= 20 2F 88     /.
.L8740
LDY #&04        :\ 8740= A0 04        .
.L8742
LDA &B0,X       :\ 8742= B5 B0       50
STA &C8,X       :\ 8744= 95 C8       .H
ADC &0F0D,X     :\ 8746= 7D 0D 0F    }..
STA &B4,X       :\ 8749= 95 B4       .4
INX             :\ 874B= E8          h
DEY             :\ 874C= 88          .
BNE L8742       :\ 874D= D0 F3       Ps
SEC             :\ 874F= 38          8
SBC &0F10       :\ 8750= ED 10 0F    m..
STA &B7         :\ 8753= 85 B7       .7
JSR L8765       :\ 8755= 20 65 87     e.
LDX #&02        :\ 8758= A2 02       ".
.L875A
LDA &0F10,X     :\ 875A= BD 10 0F    =..
STA &0F05,X     :\ 875D= 9D 05 0F    ...
DEX             :\ 8760= CA          J
BPL L875A       :\ 8761= 10 F7       .w
BMI L87D8       :\ 8763= 30 73       0s
.L8765
JSR L86BF       :\ 8765= 20 BF 86     ?.
BEQ L878F       :\ 8768= F0 25       p%
LDA #&92        :\ 876A= A9 92       ).
STA &C1         :\ 876C= 85 C1       .A
.L876E
LDX #&03        :\ 876E= A2 03       ".
.L8770
LDA &C8,X       :\ 8770= B5 C8       5H
STA &C4,X       :\ 8772= 95 C4       .D
LDA &B4,X       :\ 8774= B5 B4       54
STA &C8,X       :\ 8776= 95 C8       .H
DEX             :\ 8778= CA          J
BPL L8770       :\ 8779= 10 F5       .u
LDA #&7F        :\ 877B= A9 7F       ).
STA &C0         :\ 877D= 85 C0       .@
JSR L8530       :\ 877F= 20 30 85     0.
LDY #&03        :\ 8782= A0 03        .
.L8784
LDA &00C8,Y     :\ 8784= B9 C8 00    9H.
EOR &00B4,Y     :\ 8787= 59 B4 00    Y4.
BNE L876E       :\ 878A= D0 E2       Pb
DEY             :\ 878C= 88          .
BPL L8784       :\ 878D= 10 F5       .u
.L878F
RTS             :\ 878F= 60          `
 
.L8790
BEQ L8795       :\ 8790= F0 03       p.
JMP L88D1       :\ 8792= 4C D1 88    LQ.
 

\ Display file information if *OPT1 set
\ -------------------------------------
.L8795
LDX #&04        :\ 8795= A2 04       ".
LDY #&0E        :\ 8797= A0 0E        .
.L8799
LDA (&BB),Y     :\ 8799= B1 BB       1;
STA &00A6,Y     :\ 879B= 99 A6 00    .&.
JSR L884E       :\ 879E= 20 4E 88     N.
SBC (&BB),Y     :\ 87A1= F1 BB       q;
STA &0F03,Y     :\ 87A3= 99 03 0F    ...
PHA             :\ 87A6= 48          H
LDA (&BB),Y     :\ 87A7= B1 BB       1;
STA &00A6,Y     :\ 87A9= 99 A6 00    .&.
PLA             :\ 87AC= 68          h
STA (&BB),Y     :\ 87AD= 91 BB       .;
JSR L883B       :\ 87AF= 20 3B 88     ;.
DEX             :\ 87B2= CA          J
BNE L8799       :\ 87B3= D0 E4       Pd
LDY #&09        :\ 87B5= A0 09        .
.L87B7
LDA (&BB),Y     :\ 87B7= B1 BB       1;
STA &0F03,Y     :\ 87B9= 99 03 0F    ...
DEY             :\ 87BC= 88          .
BNE L87B7       :\ 87BD= D0 F8       Px
LDA #&91        :\ 87BF= A9 91       ).
STA &97         :\ 87C1= 85 97       ..
STA &0F02       :\ 87C3= 8D 02 0F    ...
STA &B8         :\ 87C6= 85 B8       .8
LDX #&0B        :\ 87C8= A2 0B       ".
JSR L8D84       :\ 87CA= 20 84 8D     ..
LDY #&01        :\ 87CD= A0 01        .
JSR L83BD       :\ 87CF= 20 BD 83     =.
LDA &0F05       :\ 87D2= AD 05 0F    -..
JSR L8853       :\ 87D5= 20 53 88     S.
.L87D8
LDA &0F03       :\ 87D8= AD 03 0F    -..
PHA             :\ 87DB= 48          H
JSR L83F3       :\ 87DC= 20 F3 83     s.
PLA             :\ 87DF= 68          h
LDY &0E06:BEQ L8817       :\ Get *OPT 1 value, if *OPT 1,0 skip display
LDY #&00
TAX:BEQ L87EF             :\ 87E8= F0 05       p.
JSR L8D98       :\ 87EA= 20 98 8D     ..
BMI L8803       :\ 87ED= 30 14       0.
.L87EF
LDA (&BE),Y     :\ 87EF= B1 BE       1>
CMP #&21        :\ 87F1= C9 21       I!
BCC L87FB       :\ 87F3= 90 06       ..
JSR OSASCI      :\ 87F5= 20 E3 FF     c.
INY             :\ 87F8= C8          H
BNE L87EF       :\ 87F9= D0 F4       Pt
.L87FB
JSR L8D7B                :\ Print space
INY:CPY #&0C:BCC L87FB   :\ Loop to pad to 12 characters
.L8803
LDY #&05:JSR L8D70       :\ Print load address at offset &05
LDY #&09:JSR L8D70       :\ Print exec address at offset &09
LDY #&0C                 :\ Point to length offset &0C
LDX #&03:JSR L8D72       :\ Print 3-byte hex
JSR OSNEWL
.L8817
STX &0F08       :\ 8817= 8E 08 0F    ...
LDY #&0E        :\ 881A= A0 0E        .
LDA &0F05       :\ 881C= AD 05 0F    -..
JSR L85D9       :\ 881F= 20 D9 85     Y.
.L8822
STA (&BB),Y     :\ 8822= 91 BB       .;
INY             :\ 8824= C8          H
LDA &0EF7,Y     :\ 8825= B9 F7 0E    9w.
CPY #&12        :\ 8828= C0 12       @.
BNE L8822       :\ 882A= D0 F6       Pv
JMP L89B3       :\ 882C= 4C B3 89    L3.
 
.L882F
LDY #&05        :\ 882F= A0 05        .
.L8831
LDA (&BB),Y     :\ 8831= B1 BB       1;
STA &00AE,Y     :\ 8833= 99 AE 00    ...
DEY             :\ 8836= 88          .
CPY #&02        :\ 8837= C0 02       @.
BCS L8831       :\ 8839= B0 F6       0v
.L883B
INY             :\ 883B= C8          H
.L883C
INY             :\ 883C= C8          H
INY             :\ 883D= C8          H
INY             :\ 883E= C8          H
INY             :\ 883F= C8          H
RTS             :\ 8840= 60          `
 
.L8841
LDY #&0D        :\ 8841= A0 0D        .
TXA             :\ 8843= 8A          .
.L8844
STA (&BB),Y     :\ 8844= 91 BB       .;
LDA &0F02,Y     :\ 8846= B9 02 0F    9..
DEY             :\ 8849= 88          .
CPY #&02        :\ 884A= C0 02       @.
BCS L8844       :\ 884C= B0 F6       0v
.L884E
DEY             :\ 884E= 88          .
.L884F
DEY             :\ 884F= 88          .
DEY             :\ 8850= 88          .
DEY             :\ 8851= 88          .
RTS             :\ 8852= 60          `
 
.L8853
PHA             :\ 8853= 48          H
JSR L86BF       :\ 8854= 20 BF 86     ?.
BEQ L88CD       :\ 8857= F0 74       pt
.L8859
LDA #&00        :\ 8859= A9 00       ).
PHA             :\ 885B= 48          H
PHA             :\ 885C= 48          H
TAX             :\ 885D= AA          *
LDA &0F07       :\ 885E= AD 07 0F    -..
PHA             :\ 8861= 48          H
LDA &0F06       :\ 8862= AD 06 0F    -..
PHA             :\ 8865= 48          H
LDY #&04        :\ 8866= A0 04        .
CLC             :\ 8868= 18          .
.L8869
LDA &B0,X       :\ 8869= B5 B0       50
STA &C4,X       :\ 886B= 95 C4       .D
PLA             :\ 886D= 68          h
ADC &B0,X       :\ 886E= 75 B0       u0
STA &C8,X       :\ 8870= 95 C8       .H
STA &B0,X       :\ 8872= 95 B0       .0
INX             :\ 8874= E8          h
DEY             :\ 8875= 88          .
BNE L8869       :\ 8876= D0 F1       Pq
SEC             :\ 8878= 38          8
.L8879
LDA &00B0,Y     :\ 8879= B9 B0 00    90.
SBC &00B4,Y     :\ 887C= F9 B4 00    y4.
INY             :\ 887F= C8          H
DEX             :\ 8880= CA          J
BNE L8879       :\ 8881= D0 F6       Pv
BCC L888E       :\ 8883= 90 09       ..
LDX #&03        :\ 8885= A2 03       ".
.L8887
LDA &B4,X       :\ 8887= B5 B4       54
STA &C8,X       :\ 8889= 95 C8       .H
DEX             :\ 888B= CA          J
BPL L8887       :\ 888C= 10 F9       .y
.L888E
PLA             :\ 888E= 68          h
PHA             :\ 888F= 48          H
PHP             :\ 8890= 08          .
STA &C1         :\ 8891= 85 C1       .A
LDA #&80        :\ 8893= A9 80       ).
STA &C0         :\ 8895= 85 C0       .@
JSR L85F7       :\ 8897= 20 F7 85     w.
LDA &B8         :\ 889A= A5 B8       %8
JSR L8389       :\ Receive
PLP             :\ 889F= 28          (
BCS L88CD       :\ 88A0= B0 2B       0+
LDA #&91        :\ 88A2= A9 91       ).
STA &C1         :\ 88A4= 85 C1       .A
INC &C4         :\ 88A6= E6 C4       fD
JSR L8530       :\ 88A8= 20 30 85     0.
BNE L8859       :\ 88AB= D0 AC       P,

.L88AD
PHA             :\ 88AD= 48          H
TXA             :\ 88AE= 8A          .
JSR L869A       :\ 88AF= 20 9A 86     ..
TYA             :\ 88B2= 98          .
AND &0E07       :\ 88B3= 2D 07 0E    -..
TAX             :\ 88B6= AA          *
BEQ L88CD       :\ 88B7= F0 14       p.
PHA             :\ 88B9= 48          H
STY &0F05       :\ 88BA= 8C 05 0F    ...
LDY #&11        :\ 88BD= A0 11        .
LDX #&01        :\ 88BF= A2 01       ".
JSR L83C7       :\ 88C1= 20 C7 83     G.
PLA             :\ 88C4= 68          h
LDX &0F05       :\ 88C5= AE 05 0F    ...
BNE L88CD       :\ 88C8= D0 03       P.
JSR L86D5       :\ 88CA= 20 D5 86     U.
.L88CD
PLA             :\ 88CD= 68          h
LDY &BC         :\ 88CE= A4 BC       $<
RTS             :\ 88D0= 60          `
 
.L88D1
STA &0F05       :\ 88D1= 8D 05 0F    ...
CMP #&06        :\ 88D4= C9 06       I.
BEQ L8917       :\ 88D6= F0 3F       p?
BCS L8922       :\ 88D8= B0 48       0H
CMP #&05        :\ 88DA= C9 05       I.
BEQ L8930       :\ 88DC= F0 52       pR
CMP #&04        :\ 88DE= C9 04       I.
BEQ L8926       :\ 88E0= F0 44       pD
CMP #&01        :\ 88E2= C9 01       I.
BEQ L88FB       :\ 88E4= F0 15       p.
ASL A           :\ 88E6= 0A          .
ASL A           :\ 88E7= 0A          .
TAY             :\ 88E8= A8          (
JSR L884F       :\ 88E9= 20 4F 88     O.
LDX #&03        :\ 88EC= A2 03       ".
.L88EE
LDA (&BB),Y     :\ 88EE= B1 BB       1;
STA &0F06,X     :\ 88F0= 9D 06 0F    ...
DEY             :\ 88F3= 88          .
DEX             :\ 88F4= CA          J
BPL L88EE       :\ 88F5= 10 F7       .w
LDX #&05        :\ 88F7= A2 05       ".
BNE L8910       :\ 88F9= D0 15       P.
.L88FB
JSR L85CF       :\ 88FB= 20 CF 85     O.
STA &0F0E       :\ 88FE= 8D 0E 0F    ...
LDY #&09        :\ 8901= A0 09        .
LDX #&08        :\ 8903= A2 08       ".
.L8905
LDA (&BB),Y     :\ 8905= B1 BB       1;
STA &0F05,X     :\ 8907= 9D 05 0F    ...
DEY             :\ 890A= 88          .
DEX             :\ 890B= CA          J
BNE L8905       :\ 890C= D0 F7       Pw
LDX #&0A        :\ 890E= A2 0A       ".
.L8910
JSR L8D84       :\ 8910= 20 84 8D     ..
LDY #&13:BNE L891C :\ NetFSOp 19 - Write attributes

.L8917
JSR L8D82       :\ 8917= 20 82 8D     ..
LDY #&14        :\ NetFSOp 20 - Delete
.L891C
BIT L83B3       :\ 891C= 2C B3 83    ,3.
JSR L83C8       :\ 891F= 20 C8 83     H.
.L8922
BCS L8966       :\ Not found, return A=&00
BCC L8997       :\ Any other error, return A preserved

.L8926
JSR L85CF       :\ 8926= 20 CF 85     O.
STA &0F06       :\ 8929= 8D 06 0F    ...
LDX #&02        :\ 892C= A2 02       ".
BNE L8910       :\ 892E= D0 E0       P`
.L8930
LDX #&01        :\ 8930= A2 01       ".
JSR L8D84       :\ 8932= 20 84 8D     ..
LDY #&12        :\ 8935= A0 12        .
JSR L83C7       :\ 8937= 20 C7 83     G.
LDA &0F11       :\ 893A= AD 11 0F    -..
STX &0F11       :\ 893D= 8E 11 0F    ...
STX &0F14       :\ 8940= 8E 14 0F    ...
JSR L85D9       :\ 8943= 20 D9 85     Y.
LDY #&0E        :\ 8946= A0 0E        .
STA (&BB),Y     :\ 8948= 91 BB       .;
DEY             :\ 894A= 88          .
LDX #&0C        :\ 894B= A2 0C       ".
.L894D
LDA &0F05,X     :\ 894D= BD 05 0F    =..
STA (&BB),Y     :\ 8950= 91 BB       .;
DEY             :\ 8952= 88          .
DEX             :\ 8953= CA          J
BNE L894D       :\ 8954= D0 F7       Pw
INX             :\ 8956= E8          h
INX             :\ 8957= E8          h
LDY #&11        :\ 8958= A0 11        .
.L895A
LDA &0F12,X     :\ 895A= BD 12 0F    =..
STA (&BB),Y     :\ 895D= 91 BB       .;
DEY             :\ 895F= 88          .
DEX             :\ 8960= CA          J
BPL L895A       :\ 8961= 10 F7       .w
LDA &0F05       :\ 8963= AD 05 0F    -..
.L8966
BPL L89B5       :\ 8966= 10 4D       .M

\ OSARGS handler
\ ==============
.L8968
JSR L864D          :\ Store XY in &BB/C and &BE/F, store A in &BD
CMP #&03:BCS L89B3 :\ Out of range, exit with all preserved
CPY #&00:BEQ L89BA :\ Jump with handle=0

\ A=0  - Read PTR,    returns A=&00, return code from FSOp
\ A=1  - Write PTR,   returns A=&00, return code from FSOp
\ A=2  - Read EXT,    returns A=&00, return code from FSOp
\ A=3  - Write EXT,   returns A=&03
\ A=4+ - Unsupported, returns A preserved
JSR L869B       :\ 8973= 20 9B 86     ..
STY &0F05       :\ 8976= 8C 05 0F    ...
LSR A           :\ 8979= 4A          J
STA &0F06       :\ 897A= 8D 06 0F    ...
BCS L8999       :\ Jump with A=odd, write file information
LDY #&0C        :\ 897F= A0 0C        .
LDX #&02        :\ 8981= A2 02       ".
JSR L83C7       :\ Do FSOp 12 - read open file info
STA &BD         :\ Set returned A to &00
LDX &BB         :\ 8988= A6 BB       &;
LDY #&02        :\ 898A= A0 02        .
STA &03,X       :\ 898C= 95 03       ..
.L898E
LDA &0F05,Y     :\ 898E= B9 05 0F    9..
STA &02,X       :\ 8991= 95 02       ..
DEX             :\ 8993= CA          J
DEY             :\ 8994= 88          .
BPL L898E       :\ 8995= 10 F7       .w
.L8997
BCC L89B3       :\ 8997= 90 1A       ..

.L8999
TYA             :\ 8999= 98          .
PHA             :\ 899A= 48          H
LDY #&03        :\ 899B= A0 03        .
.L899D
LDA &03,X       :\ 899D= B5 03       5.
STA &0F07,Y     :\ 899F= 99 07 0F    ...
DEX             :\ 89A2= CA          J
DEY             :\ 89A3= 88          .
BPL L899D       :\ 89A4= 10 F7       .w
LDY #&0D        :\ 89A6= A0 0D        .
LDX #&05        :\ 89A8= A2 05       ".
JSR L83C7       :\ Do FSOp 13 - write open file information
STX &BD         :\ Set returned A to &00
PLA             :\ 89AF= 68          h
JSR L86D0       :\ 89B0= 20 D0 86     P.
.L89B3
LDA &BD         :\ 89B3= A5 BD       %=
.L89B5
LDX &BB         :\ 89B5= A6 BB       &;
LDY &BC         :\ 89B7= A4 BC       $<
RTS             :\ 89B9= 60          `

\ OSARGS Y=0
\ ----------
\ A=0  - Filing system number,  returns A=5
\ A=1  - Command line address,  returns A=0
\ A=2  - Filing system version, returns A=1
\ A=3  - LIBFS number,          returns A=3
\ A=4+ - Returns A preserved
.L89BA
CMP #&02:BEQ L89C5 :\ OSARGS 2,0 - VERSION
BCS L89D4          :\ OSARGS 3,0 - Already filtered out, will return A=3
TAY:BNE L89C8      :\ OSARGS 1,0 - Read command line address
LDA #&0A           :\ OSARGS 0,0 - A=5*2
.L89C5
LSR A:BNE L89B5    :\ Return A=5 for 0,0; return A=1 for 2,0
:
.L89C8
LDA &0E0A,Y:STA (&BB),Y  :\ Copy command line address
DEY:BPL L89C8            :\ Loop for two bytes
STY &02,X:STY &03,X      :\ Set to &FFFFxxxx
.L89D4
LDA #&00:BPL L89B5       :\ Jump to return A=0, XY preserved

.L89D8
JSR L8649       :\ 89D8= 20 49 86     I.
SEC             :\ 89DB= 38          8
JSR L869C       :\ 89DC= 20 9C 86     ..
TAX             :\ 89DF= AA          *
BEQ L8A10       :\ 89E0= F0 2E       p.
AND #&3F        :\ 89E2= 29 3F       )?
BNE L89D4       :\ 89E4= D0 EE       Pn
TXA             :\ 89E6= 8A          .
EOR #&80        :\ 89E7= 49 80       I.
ASL A           :\ 89E9= 0A          .
STA &0F05       :\ 89EA= 8D 05 0F    ...
ROL A           :\ 89ED= 2A          *
STA &0F06       :\ 89EE= 8D 06 0F    ...
JSR L86E8       :\ 89F1= 20 E8 86     h.
LDX #&02        :\ 89F4= A2 02       ".
JSR L8D84       :\ 89F6= 20 84 8D     ..
LDY #&06        :\ NetFSOp 6 - Open
BIT L83B3       :\ 89FB= 2C B3 83    ,3.
JSR L83C8       :\ 89FE= 20 C8 83     H.
BCS L89B5       :\ If Not found, ....
LDA &0F05       :\ 8A03= AD 05 0F    -..
TAX             :\ 8A06= AA          *
JSR L86D0       :\ 8A07= 20 D0 86     P.
TXA             :\ 8A0A= 8A          .
JSR L86B7       :\ 8A0B= 20 B7 86     7.
BNE L89B5       :\ 8A0E= D0 A5       P%
.L8A10
TYA             :\ 8A10= 98          .
BNE L8A1A       :\ 8A11= D0 07       P.
LDA #&77        :\ 8A13= A9 77       )w
JSR OSBYTE      :\ 8A15= 20 F4 FF     t.
LDY #&00        :\ 8A18= A0 00        .
.L8A1A
STY &0F05       :\ 8A1A= 8C 05 0F    ...
LDX #&01        :\ 8A1D= A2 01       ".
LDY #&07        :\ 8A1F= A0 07        .
JSR L83C7       :\ 8A21= 20 C7 83     G.
LDA &0F05       :\ 8A24= AD 05 0F    -..
JSR L86D0       :\ 8A27= 20 D0 86     P.
.L8A2A
BCC L89B3       :\ 8A2A= 90 87       ..

\ FSC 0 - *Opt
\ ============
\ On entry, X=X parameter, Y=Y parameter, Flags set from X
\
.L8A2C
BEQ L8A39                :\ Jump with *Opt 0
CPX #&04:BNE L8A36       :\ Jump if not *Opt 4
CPY #&04:BCC L8A43       :\ Jump if valid *Opt 4 option
.L8A36
DEX:BNE L8A3E            :\ Jump to generate 'Bad option' error
.L8A39
STY &0E06:BCC L8A50      :\ Store *Opt 1 option, branch to return
.L8A3E
LDA #&07:JMP L8512       :\ A=7 for 'Bad option' error

\ *Opt 4,n
\ -------- 
.L8A43
STY &0F05                :\ Store boot option in FSOp buffer
LDY #&16:JSR L83C7       :\ Send FSOp &16 - Set Boot Option
LDY &BC         :\ 8A4B= A4 BC       $<
STY &0E05       :\ 8A4D= 8C 05 0E    ...
.L8A50
BCC L8A2A       :\ 8A50= 90 D8       .X
.L8A52
LDY #&09        :\ 8A52= A0 09        .
JSR L8A59       :\ 8A54= 20 59 8A     Y.
.L8A57
LDY #&01        :\ 8A57= A0 01        .
.L8A59
CLC             :\ 8A59= 18          .
.L8A5A
LDX #&FC        :\ 8A5A= A2 FC       "|
.L8A5C
LDA (&BB),Y     :\ 8A5C= B1 BB       1;
BIT &B2         :\ 8A5E= 24 B2       $2
BMI L8A68       :\ 8A60= 30 06       0.
ADC &0E0A,X     :\ 8A62= 7D 0A 0E    }..
JMP L8A6B       :\ 8A65= 4C 6B 8A    Lk.
 
.L8A68
SBC &0E0A,X     :\ 8A68= FD 0A 0E    }..
.L8A6B
STA (&BB),Y     :\ 8A6B= 91 BB       .;
INY             :\ 8A6D= C8          H
INX             :\ 8A6E= E8          h
BNE L8A5C       :\ 8A6F= D0 EB       Pk
RTS             :\ 8A71= 60          `

.L8A72
JSR L864D       :\ 8A72= 20 4D 86     M.
TAX             :\ 8A75= AA          *
BEQ L8A7D       :\ 8A76= F0 05       p.
DEX             :\ 8A78= CA          J
CPX #&08        :\ 8A79= E0 08       `.
BCC L8A80       :\ 8A7B= 90 03       ..
.L8A7D
JMP L89B3       :\ 8A7D= 4C B3 89    L3.
 
.L8A80
TXA             :\ 8A80= 8A          .
LDY #&00        :\ 8A81= A0 00        .
PHA             :\ 8A83= 48          H
CMP #&04        :\ 8A84= C9 04       I.
BCC L8A8B       :\ 8A86= 90 03       ..
JMP L8B31       :\ 8A88= 4C 31 8B    L1.
 
.L8A8B
LDA (&BB),Y     :\ 8A8B= B1 BB       1;
JSR L869A       :\ 8A8D= 20 9A 86     ..
STY &0F05       :\ 8A90= 8C 05 0F    ...
LDY #&0B        :\ 8A93= A0 0B        .
LDX #&06        :\ 8A95= A2 06       ".
.L8A97
LDA (&BB),Y     :\ 8A97= B1 BB       1;
STA &0F06,X     :\ 8A99= 9D 06 0F    ...
DEY             :\ 8A9C= 88          .
CPY #&08        :\ 8A9D= C0 08       @.
BNE L8AA2       :\ 8A9F= D0 01       P.
DEY             :\ 8AA1= 88          .
.L8AA2
DEX             :\ 8AA2= CA          J
BNE L8A97       :\ 8AA3= D0 F2       Pr
PLA             :\ 8AA5= 68          h
LSR A           :\ 8AA6= 4A          J
PHA             :\ 8AA7= 48          H
BCC L8AAB       :\ 8AA8= 90 01       ..
INX             :\ 8AAA= E8          h
.L8AAB
STX &0F06       :\ 8AAB= 8E 06 0F    ...
LDY #&0B        :\ 8AAE= A0 0B        .
LDX #&91        :\ 8AB0= A2 91       ".
PLA             :\ 8AB2= 68          h
PHA             :\ 8AB3= 48          H
BEQ L8AB9       :\ 8AB4= F0 03       p.
LDX #&92        :\ 8AB6= A2 92       ".
DEY             :\ 8AB8= 88          .
.L8AB9
STX &0F02       :\ 8AB9= 8E 02 0F    ...
STX &B8         :\ 8ABC= 86 B8       .8
LDX #&08        :\ 8ABE= A2 08       ".
LDA &0F05       :\ 8AC0= AD 05 0F    -..
JSR L83B9       :\ 8AC3= 20 B9 83     9.
LDA &B3         :\ 8AC6= A5 B3       %3
STA &0E08       :\ 8AC8= 8D 08 0E    ...
LDX #&04        :\ 8ACB= A2 04       ".
.L8ACD
LDA (&BB),Y     :\ 8ACD= B1 BB       1;
STA &00AF,Y     :\ 8ACF= 99 AF 00    ./.
STA &00C7,Y     :\ 8AD2= 99 C7 00    .G.
JSR L883C       :\ 8AD5= 20 3C 88     <.
ADC (&BB),Y     :\ 8AD8= 71 BB       q;
STA &00AF,Y     :\ 8ADA= 99 AF 00    ./.
JSR L884F       :\ 8ADD= 20 4F 88     O.
DEX             :\ 8AE0= CA          J
BNE L8ACD       :\ 8AE1= D0 EA       Pj
INX             :\ 8AE3= E8          h
.L8AE4
LDA &0F03,X     :\ 8AE4= BD 03 0F    =..
STA &0F06,X     :\ 8AE7= 9D 06 0F    ...
DEX             :\ 8AEA= CA          J
BPL L8AE4       :\ 8AEB= 10 F7       .w
PLA             :\ 8AED= 68          h
BNE L8AF8       :\ 8AEE= D0 08       P.
LDA &0F02       :\ 8AF0= AD 02 0F    -..
JSR L8853       :\ 8AF3= 20 53 88     S.
BCS L8AFB       :\ 8AF6= B0 03       0.
.L8AF8
JSR L8765       :\ 8AF8= 20 65 87     e.
.L8AFB
JSR L83F3       :\ 8AFB= 20 F3 83     s.
LDA (&BB,X)     :\ 8AFE= A1 BB       !;
BIT &0F05       :\ 8B00= 2C 05 0F    ,..
BMI L8B08       :\ 8B03= 30 03       0.
JSR L86D5       :\ 8B05= 20 D5 86     U.
.L8B08
JSR L86D0       :\ 8B08= 20 D0 86     P.
STX &B2         :\ 8B0B= 86 B2       .2
JSR L8A52       :\ 8B0D= 20 52 8A     R.
DEC &B2         :\ 8B10= C6 B2       F2
SEC             :\ 8B12= 38          8
JSR L8A5A       :\ 8B13= 20 5A 8A     Z.
ASL &0F05       :\ 8B16= 0E 05 0F    ...
JMP L89D4       :\ 8B19= 4C D4 89    LT.
 
.L8B1C
LDY #&15        :\ 8B1C= A0 15        .
JSR L83C7       :\ 8B1E= 20 C7 83     G.
LDA &0E05       :\ 8B21= AD 05 0E    -..
STA &0F16       :\ 8B24= 8D 16 0F    ...
STX &B0         :\ 8B27= 86 B0       .0
STX &B1         :\ 8B29= 86 B1       .1
LDA #&12        :\ 8B2B= A9 12       ).
STA &B2         :\ 8B2D= 85 B2       .2
BNE L8B7F       :\ 8B2F= D0 4E       PN
.L8B31
LDY #&04        :\ 8B31= A0 04        .
LDA &0D67       :\ 8B33= AD 67 0D    -g.
BEQ L8B3F       :\ 8B36= F0 07       p.
CMP (&BB),Y     :\ 8B38= D1 BB       Q;
BNE L8B3F       :\ 8B3A= D0 03       P.
DEY             :\ 8B3C= 88          .
SBC (&BB),Y     :\ 8B3D= F1 BB       q;
.L8B3F
STA &A9         :\ 8B3F= 85 A9       .)
.L8B41
LDA (&BB),Y     :\ 8B41= B1 BB       1;
STA &00BD,Y     :\ 8B43= 99 BD 00    .=.
DEY             :\ 8B46= 88          .
BNE L8B41       :\ 8B47= D0 F8       Px
PLA             :\ 8B49= 68          h
AND #&03        :\ 8B4A= 29 03       ).
BEQ L8B1C       :\ 8B4C= F0 CE       pN
LSR A           :\ 8B4E= 4A          J
BEQ L8B53       :\ 8B4F= F0 02       p.
BCS L8BBE       :\ 8B51= B0 6B       0k
.L8B53
TAY             :\ 8B53= A8          (
LDA &0E03,Y     :\ 8B54= B9 03 0E    9..
STA &0F03       :\ 8B57= 8D 03 0F    ...
LDA &0E04       :\ 8B5A= AD 04 0E    -..
STA &0F04       :\ 8B5D= 8D 04 0F    ...
LDA &0E02       :\ 8B60= AD 02 0E    -..
STA &0F02       :\ 8B63= 8D 02 0F    ...
LDX #&12        :\ 8B66= A2 12       ".
STX &0F01       :\ 8B68= 8E 01 0F    ...
LDA #&0D        :\ 8B6B= A9 0D       ).
STA &0F06       :\ 8B6D= 8D 06 0F    ...
STA &B2         :\ 8B70= 85 B2       .2
LSR A           :\ 8B72= 4A          J
STA &0F05       :\ 8B73= 8D 05 0F    ...
CLC             :\ 8B76= 18          .
JSR L83DD       :\ 8B77= 20 DD 83     ].
STX &B1         :\ 8B7A= 86 B1       .1
INX             :\ 8B7C= E8          h
STX &B0         :\ 8B7D= 86 B0       .0
.L8B7F
LDA &A9         :\ 8B7F= A5 A9       %)
BNE L8B94       :\ 8B81= D0 11       P.
LDX &B0         :\ 8B83= A6 B0       &0
LDY &B1         :\ 8B85= A4 B1       $1
.L8B87
LDA &0F05,X     :\ 8B87= BD 05 0F    =..
STA (&BE),Y     :\ 8B8A= 91 BE       .>
INX             :\ 8B8C= E8          h
INY             :\ 8B8D= C8          H
DEC &B2         :\ 8B8E= C6 B2       F2
BNE L8B87       :\ 8B90= D0 F5       Pu
BEQ L8BBB       :\ 8B92= F0 27       p'
.L8B94
JSR L8C13       :\ 8B94= 20 13 8C     ..
LDA #&01        :\ 8B97= A9 01       ).
LDX &BB         :\ 8B99= A6 BB       &;
LDY &BC         :\ 8B9B= A4 BC       $<
INX             :\ 8B9D= E8          h
BNE L8BA1       :\ 8B9E= D0 01       P.
INY             :\ 8BA0= C8          H
.L8BA1
JSR &0406       :\ 8BA1= 20 06 04     ..
LDX &B0         :\ 8BA4= A6 B0       &0
.L8BA6
LDA &0F05,X     :\ 8BA6= BD 05 0F    =..
STA &FEE5       :\ 8BA9= 8D E5 FE    .e~
INX             :\ 8BAC= E8          h
LDY #&06        :\ 8BAD= A0 06        .
.L8BAF
DEY             :\ 8BAF= 88          .
BNE L8BAF       :\ 8BB0= D0 FD       P}
DEC &B2         :\ 8BB2= C6 B2       F2
BNE L8BA6       :\ 8BB4= D0 F0       Pp
LDA #&83        :\ 8BB6= A9 83       ).
JSR &0406       :\ 8BB8= 20 06 04     ..
.L8BBB
JMP L89D4       :\ 8BBB= 4C D4 89    LT.
 
.L8BBE
LDY #&09        :\ 8BBE= A0 09        .
LDA (&BB),Y     :\ 8BC0= B1 BB       1;
STA &0F06       :\ 8BC2= 8D 06 0F    ...
LDY #&05        :\ 8BC5= A0 05        .
LDA (&BB),Y     :\ 8BC7= B1 BB       1;
STA &0F07       :\ 8BC9= 8D 07 0F    ...
LDX #&0D        :\ 8BCC= A2 0D       ".
STX &0F08       :\ 8BCE= 8E 08 0F    ...
LDY #&02        :\ 8BD1= A0 02        .
STY &B0         :\ 8BD3= 84 B0       .0
STY &0F05       :\ 8BD5= 8C 05 0F    ...
INY             :\ 8BD8= C8          H
JSR L83C7       :\ 8BD9= 20 C7 83     G.
STX &B1         :\ 8BDC= 86 B1       .1
LDA &0F06       :\ 8BDE= AD 06 0F    -..
STA (&BB,X)     :\ 8BE1= 81 BB       .;
LDA &0F05       :\ 8BE3= AD 05 0F    -..
LDY #&09        :\ 8BE6= A0 09        .
ADC (&BB),Y     :\ 8BE8= 71 BB       q;
STA (&BB),Y     :\ 8BEA= 91 BB       .;
LDA &C8         :\ 8BEC= A5 C8       %H
SBC #&07        :\ 8BEE= E9 07       i.
STA &0F06       :\ 8BF0= 8D 06 0F    ...
STA &B2         :\ 8BF3= 85 B2       .2
BEQ L8BFA       :\ 8BF5= F0 03       p.
JSR L8B7F       :\ 8BF7= 20 7F 8B     ..
.L8BFA
LDX #&02        :\ 8BFA= A2 02       ".
.L8BFC
STA &0F07,X     :\ 8BFC= 9D 07 0F    ...
DEX             :\ 8BFF= CA          J
BPL L8BFC       :\ 8C00= 10 FA       .z
JSR L8A57       :\ 8C02= 20 57 8A     W.
SEC             :\ 8C05= 38          8
DEC &B2         :\ 8C06= C6 B2       F2
LDA &0F05       :\ 8C08= AD 05 0F    -..
STA &0F06       :\ 8C0B= 8D 06 0F    ...
JSR L8A5A       :\ 8C0E= 20 5A 8A     Z.
BEQ L8BBB       :\ 8C11= F0 A8       p(
.L8C13
LDA #&C3        :\ 8C13= A9 C3       )C
JSR &0406       :\ 8C15= 20 06 04     ..
BCC L8C13       :\ 8C18= 90 F9       .y
RTS             :\ 8C1A= 60          `


\ FSC 3 - *command
\ ================ 
.L8C1B
JSR L8649       :\ Store line pointer in zero page
LDX #&FF        :\ 8C1E= A2 FF       ".
STX &B9         :\ 8C20= 86 B9       .9
STX &97         :\ 8C22= 86 97       ..
.L8C24
LDY #&FF        :\ 8C24= A0 FF        .
.L8C26
INY             :\ 8C26= C8          H
INX             :\ 8C27= E8          h
.L8C28
LDA L8C4B,X  ; 8C28 BD 4B 8C    ½K.  Get char from command table
BMI L8C45    ; 8C2B 30 18       0.   b7=1, end of entry
EOR (&BE),Y  ; 8C2D 51 BE       Q¾   Does it match?
AND #&DF     ; 8C2F 29 DF       )ß   Ignore case
BEQ L8C26    ; 8C31 F0 F3       ðó   Matches, loop for another char
DEX          ; 8C33 CA          Ê    Doesn't match
.L8C34
INX          ; 8C34 E8          è    
LDA L8C4B+0,X ; 8C35 BD 4B 8C    ½K.  
BPL L8C34     ; 8C38 10 FA       .ú   Loop for end of entry
LDA (&BE),Y   ; 8C3A B1 BE       ±¾   Get command line character
INX           ; 8C3C E8          è    
CMP #&2E      ; 8C3D C9 2E       É.   Is it abbreviated?
BNE L8C24     ; 8C3F D0 E3       Ðã   No, loop back to check next entry
INY           ; 8C41 C8          È    
DEX           ; 8C42 CA          Ê    
BCS L8C28     ; 8C43 B0 E3       °ã   Abbreviated, jump to get address byte and jump back here
.L8C45
PHA           ; 8C45 48          H    Push high byte of address
LDA L8C4B+1,X ; 8C46 BD 4C 8C    ½L.  Get low byte
PHA           ; 8C49 48          H    Push low byte of address
RTS           ; 8C4A 60          `    Jump to routine
 
.L8C4B
EQUS "I."         :EQUB (L80C1-1)DIV256:EQUB (L80C1-1)AND255
EQUS "I AM"       :EQUB (L8082-1)DIV256:EQUB (L8082-1)AND255 
EQUS "EX"         :EQUB (L8C61-1)DIV256:EQUB (L8C61-1)AND255
EQUS "BYE",13     :EQUB (L83C0-1)DIV256:EQUB (L83C0-1)AND255
EQUS ""           :EQUB (L80C1-1)DIV256:EQUB (L80C1-1)AND255


\ *EX - examine directory
\ =======================
\ On entry, (&BE),Y=>parameters, Y=>character after 'X'
\
\ Bug, does not check for seperator, so matches eg *EXAMINE
\ Should check (&BE),Y<"!" and jump to L80C1 if not
\ LDY (&BE),Y
\ CMP #&21
\ BCC L8C61
\ JMP L80C1
\
.L8C61 
LDX #&01:LDA #&03:BNE L8C72


\ FSC 5 - *Cat
\ ============
.L8C67
LDX #&03:STX &B9:LDY #&FF
STY &97:INY:LDA #&0B

\ *CAT and *EX - Display directory contents
\ -----------------------------------------
\ A=&03=EX, A=&0B=CAT - Number of entries to fetch per call
\ X=&01=EX, X=&03=CAT - FSOp 3 subcode
\ Y=>parameters
\
.L8C72
STA &B5         :\ 8C72= 85 B5       .5
STX &B7         :\ 8C74= 86 B7       .7
LDA #&06        :\ 8C76= A9 06       ).
STA &0F05       :\ 8C78= 8D 05 0F    ...
JSR L86EA       :\ 8C7B= 20 EA 86     j.
LDX #&01        :\ 8C7E= A2 01       ".
JSR L8D84       :\ 8C80= 20 84 8D     ..
LDY #&12        :\ 8C83= A0 12        .
JSR L83C7       :\ 8C85= 20 C7 83     G.
LDX #&03        :\ 8C88= A2 03       ".
JSR L8D47       :\ 8C8A= 20 47 8D     G.
JSR L865C       :\ 8C8D= 20 5C 86     \.
PLP             :\ 8C90= 28          (
LDA &0F13       :\ 8C91= AD 13 0F    -..
JSR L8DBD       :\ 8C94= 20 BD 8D     =.
JSR L865C:EQUS ")     "
LDY &0F12:BNE L8CB0  :\ Skip past if public
JSR L865C:EQUS "Owner":EQUB 13
BNE L8CBA
.L8CB0
JSR L865C:EQUS "Public":EQUB 13
.L8CBA
LDY #&15
JSR L83C7            :\ 
INX                  :\ 
LDY #&10             :\ 
JSR L8D49            :\ 
JSR L865C:EQUS "    Option "
LDA &0E05:TAX        :\ Get option, save in X
JSR LBFF0            :\ Print option in hex - NB! Calls code in DFS half of ROM
JSR L865C:EQUS " ("
LDY L8D54,X           :\ Index into option strings
.L8CE2
LDA L8D54,Y:BMI L8CED :\ Get character, end at b7 set
JSR OSASCI            :\ Print character
INY:BNE L8CE2         :\ Loop to do next
.L8CED
JSR L865C:EQUS ")",13,"Dir. "
LDX #&11:JSR L8D47    :\ Print directory name at offset &11
JSR L865C:EQUS "     Lib. "
LDX #&1B:JSR L8D47    :\ Print library name at offset &1B
JSR OSNEWL

.L8D11
STY &0F06       :\ 8D11= 8C 06 0F    ...
STY &B4         :\ 8D14= 84 B4       .4
LDX &B5         :\ 8D16= A6 B5       &5
STX &0F07       :\ 8D18= 8E 07 0F    ...
LDX &B7         :\ 8D1B= A6 B7       &7
STX &0F05       :\ 8D1D= 8E 05 0F    ...
LDX #&03        :\ 8D20= A2 03       ".
JSR L8D84       :\ 8D22= 20 84 8D     ..
LDY #&03        :\ 8D25= A0 03        .
JSR L83C7       :\ 8D27= 20 C7 83     G.
.L8D2A
INX             :\ 8D2A= E8          h
LDA &0F05       :\ 8D2B= AD 05 0F    -..
BNE L8D33       :\ 8D2E= D0 03       P.
JMP OSNEWL      :\ 8D30= 4C E7 FF    Lg.
 
.L8D33
PHA             :\ 8D33= 48          H
.L8D34
INY             :\ 8D34= C8          H
LDA &0F05,Y     :\ 8D35= B9 05 0F    9..
BPL L8D34       :\ 8D38= 10 FA       .z
STA &0F04,Y     :\ 8D3A= 99 04 0F    ...
JSR L8D9F       :\ 8D3D= 20 9F 8D     ..
PLA             :\ 8D40= 68          h
CLC             :\ 8D41= 18          .
ADC &B4         :\ 8D42= 65 B4       e4
TAY             :\ 8D44= A8          (
BNE L8D11       :\ 8D45= D0 CA       PJ
.L8D47
LDY #&0A        :\ 8D47= A0 0A        .
.L8D49
LDA &0F05,X     :\ 8D49= BD 05 0F    =..
JSR OSASCI      :\ 8D4C= 20 E3 FF     c.
INX             :\ 8D4F= E8          h
DEY             :\ 8D50= 88          .
BNE L8D49       :\ 8D51= D0 F6       Pv
RTS             :\ 8D53= 60          `
 
\ Offsets into option strings
\ ---------------------------
.L8D54
EQUB L8D7F-L8D54 :\ => "Off"
EQUB L8D92-L8D54 :\ => "Load"
EQUB L8DBA-L8D54 :\ => "Run"
EQUB L8D6C-L8D54 :\ => "Exec"

\ Option commands
\ ---------------
.L8D58:EQUS "L."
.L8D5A:EQUS "!BOOT":EQUB 13
.L8D60:EQUS "E.!BOOT"
.L8D67:EQUB 13
.L8D68
EQUB L8D67 AND 255 :\ => off
EQUB L8D58 AND 255 :\ => *LOAD !BOOT
EQUB L8D5A AND 255 :\ => *RUN !BOOT
EQUB L8D60 AND 255 :\ => *EXEC !BOOT

.L8D6C
EQUS "Exec"

\ Print hex word at offset Y, followed by space
\ ---------------------------------------------
.L8D70
LDX #&04                    :\ Four bytes to print
.L8D72
LDA (&BB),Y:JSR LBFF0       :\ Print hex - NB! calls DFS half of ROM
DEY:DEX:BNE L8D72           :\ Loop for four bytes
.L8D7B
LDA #&20:BNE L8DD9       :\ Exit by printing a space

.L8D7F
EQUS "Off"

\ Copy command line to NetFS_Op transmit buffer
\ ---------------------------------------------
.L8D82
LDX #&00        :\ 8D82= A2 00       ".
.L8D84
LDY #&00        :\ 8D84= A0 00        .
.L8D86
LDA (&BE),Y     :\ 8D86= B1 BE       1>
STA &0F05,X     :\ 8D88= 9D 05 0F    ...
INX             :\ 8D8B= E8          h
.L8D8C
INY             :\ 8D8C= C8          H
EOR #&0D        :\ 8D8D= 49 0D       I.
BNE L8D86       :\ 8D8F= D0 F5       Pu
.L8D91
RTS             :\ 8D91= 60          `

.L8D92
EQUS "Load"     :\ 8D92= 4C 6F 61 64 Load

.L8D96
LDX #&00        :\ 8D96= A2 00       d.
.L8D98
LDA &0F05,X     :\ 8D98= BD 05 0F    =..
BMI L8D91       :\ 8D9B= 30 F4       0t
BNE L8DB4       :\ 8D9D= D0 15       P.
.L8D9F
LDY &B9         :\ 8D9F= A4 B9       $9
BMI L8DB2       :\ 8DA1= 30 0F       0.
INY             :\ 8DA3= C8          H
TYA             :\ 8DA4= 98          .
AND #&03        :\ 8DA5= 29 03       ).
STA &B9         :\ 8DA7= 85 B9       .9
BEQ L8DB2       :\ 8DA9= F0 07       p.
JSR L865C       :\ 8DAB= 20 5C 86     \.
EQUS "  "
EQUB &D0
EQUB &05

.L8DB2
LDA #&0D
.L8DB4
JSR OSASCI
INX             :\ 8DB7= E8          h
BNE L8D98       :\ 8DB8= D0 DE       P^
.L8DBA
EQUS "Run"      :\ 8DBA= 52 75       Ru

.L8DBD \ Print A in decimal
TAY
LDA #100:JSR L8DCA   :\ Print 100s
LDA #10:JSR L8DCA    :\ Print 10s
LDA #1               :\ Print 1s
.L8DCA
STA &B8         :\ 8DCA= 85 B8       .8
TYA             :\ 8DCC= 98          .
LDX #&2F        :\ 8DCD= A2 2F       "/
SEC             :\ 8DCF= 38          8
.L8DD0
INX             :\ 8DD0= E8          h
SBC &B8         :\ 8DD1= E5 B8       e8
BCS L8DD0       :\ 8DD3= B0 FB       0{
ADC &B8         :\ 8DD5= 65 B8       e8
TAY             :\ 8DD7= A8          (
TXA             :\ 8DD8= 8A          .
.L8DD9
JMP OSASCI      :\ 8DD9= 4C E3 FF    Lc.

IF ROM8K
 .LBFF0
 PHA
 LSR A:LSR A:LSR A:LSR A
 JSR LBFF8
 PLA:AND #15
 .LBFF8
 ORA #&30:CMP #&3A:BCC L8DD9
 ADC #&06:BNE L8DD9
ENDIF

.L8DDC 
JSR L86E8       :\ 8DDC= 20 E8 86     h.
JSR L8D82       :\ 8DDF= 20 82 8D     ..

.L8DE2
LDY #&00        :\ 8DE2= A0 00        .
CLC             :\ 8DE4= 18          .
JSR &FFC2       :\ 8DE5= 20 C2 FF     B.
.L8DE8
JSR &FFC5       :\ 8DE8= 20 C5 FF     E.
BCC L8DE8       :\ 8DEB= 90 FB       .{
JSR L837E       :\ 8DED= 20 7E 83     ~.
CLC             :\ 8DF0= 18          .
TYA             :\ 8DF1= 98          .
ADC &F2         :\ 8DF2= 65 F2       er
STA &0E0A       :\ 8DF4= 8D 0A 0E    ...
LDA &F3         :\ 8DF7= A5 F3       %s
ADC #&00        :\ 8DF9= 69 00       i.
STA &0E0B       :\ 8DFB= 8D 0B 0E    ...
LDX #&0E        :\ 8DFE= A2 0E       ".
STX &BC         :\ 8E00= 86 BC       .<
LDA #&10        :\ 8E02= A9 10       ).
STA &BB         :\ 8E04= 85 BB       .;
STA &0E16       :\ 8E06= 8D 16 0E    ...
LDX #&4A        :\ 8E09= A2 4A       "J
LDY #&05        :\ 8E0B= A0 05        .
JSR L8722       :\ 8E0D= 20 22 87     ".
LDA &0D67       :\ 8E10= AD 67 0D    -g.
BEQ L8E29       :\ 8E13= F0 14       p.
ADC &0F0B       :\ 8E15= 6D 0B 0F    m..
ADC &0F0C       :\ 8E18= 6D 0C 0F    m..
BCS L8E29       :\ 8E1B= B0 0C       0.
JSR L8C13       :\ 8E1D= 20 13 8C     ..
LDX #&09        :\ 8E20= A2 09       ".
LDY #&0F        :\ 8E22= A0 0F        .
LDA #&04        :\ 8E24= A9 04       ).
JMP &0406       :\ 8E26= 4C 06 04    L..
 
.L8E29
ROL A           :\ 8E29= 2A          *
JMP (&0F09)     :\ 8E2A= 6C 09 0F    l..

.L8E2D
STY &0E04       :\ 8E2D= 8C 04 0E    ...
BCC L8E35       :\ 8E30= 90 03       ..
.L8E32
STY &0E03       :\ 8E32= 8C 03 0E    ...
.L8E35
JMP L89B3       :\ 8E35= 4C B3 89    L3.
 
.L8E38
SEC             :\ 8E38= 38          8
.L8E39
LDX #&03        :\ 8E39= A2 03       ".
BCC L8E43       :\ 8E3B= 90 06       ..
.L8E3D
LDA &0F05,X     :\ 8E3D= BD 05 0F    =..
STA &0E02,X     :\ 8E40= 9D 02 0E    ...
.L8E43
DEX             :\ 8E43= CA          J
BPL L8E3D       :\ 8E44= 10 F7       .w
BCC L8E35       :\ 8E46= 90 ED       .m
LDY &0E05       :\ 8E48= AC 05 0E    ,..
LDX L8D68,Y     :\ 8E4B= BE 68 8D    >h.
LDY #&8D        :\ 8E4E= A0 8D        .
JMP OS_CLI      :\ 8E50= 4C F7 FF    Lw.
 
.L8E53
LDA &F0         :\ 8E53= A5 F0       %p
.L8E55
ASL A           :\ 8E55= 0A          .
ASL A           :\ 8E56= 0A          .
PHA             :\ 8E57= 48          H
ASL A           :\ 8E58= 0A          .
TSX             :\ 8E59= BA          :
ADC &0101,X     :\ 8E5A= 7D 01 01    }..
TAY             :\ 8E5D= A8          (
PLA             :\ 8E5E= 68          h
CMP #&48        :\ 8E5F= C9 48       IH
BCC L8E66       :\ 8E61= 90 03       ..
LDY #&00        :\ 8E63= A0 00        .
TYA             :\ 8E65= 98          .
.L8E66
RTS             :\ 8E66= 60          `


\ OSBYTE &32 (50) - Poll network transmit
\ =======================================
.L8E67 
LDY #&6F        :\ 8E67= A0 6F        o
LDA (&9C),Y     :\ 8E69= B1 9C       1.
BCC L8E7A       :\ 8E6B= 90 0D       ..


\ OSBYTE &33 (51) - Poll network receive
\ ======================================
.L8E6D
JSR L8E53       :\ 8E6D= 20 53 8E     S.
BCS L8E78       :\ 8E70= B0 06       0.
LDA (&9E),Y     :\ 8E72= B1 9E       1.
CMP #&3F        :\ 8E74= C9 3F       I?
BNE L8E7A       :\ 8E76= D0 02       P.
.L8E78
LDA #&00        :\ 8E78= A9 00       ).
.L8E7A
STA &F0         :\ 8E7A= 85 F0       .p
RTS             :\ 8E7C= 60          `


\ OSBYTE &34 (52) - Delete receive control block
\ ==============================================
.L8E7D 
JSR L8E53       :\ 8E7D= 20 53 8E     S.
BCS L8E78       :\ 8E80= B0 F6       0v
LDA #&3F        :\ 8E82= A9 3F       )?
STA (&9E),Y     :\ 8E84= 91 9E       ..
RTS             :\ 8E86= 60          `


\ SERVICE 8 - OSWORD HANDLER
\ ========================== 
.L8E87
LDA &EF:SBC #&0F:BMI L8EB7    :\ Exit if <&10
CMP #&05:BCS L8EB7            :\ Exit if >&14
JSR L8E9F:LDY #&02            :\ Dispatch OSWORD call
.L8E96
LDA (&9C),Y:STA &00AA,Y       :\ Restore workspace
DEY:BPL L8E96:RTS
 
.L8E9F
TAX:LDA L8EBD,X:PHA
LDA L8EB8,X:PHA:LDY #&02
.L8EAA
LDA &00AA,Y:STA (&9C),Y       :\ Save workspace
DEY:BPL L8EAA
INY:LDA (&F0),Y:STY &A9       :\ Get first byte from control block
.L8EB7
RTS                           :\ Jump to dispatch
 
\ OSWORD dispatch address low bytes
\ ---------------------------------
.L8EB8
EQUB L8EC2-1 AND 255          :\ OSWORD &10 - NetTx
EQUB L8F7C-1 AND 255          :\ OSWORD &11 - NetRx
EQUB L8EDC-1 AND 255          :\ OSWORD &12 - NetParams
EQUB L8F01-1 AND 255          :\ OSWORD &13 - NetInfo
EQUB L8FF0-1 AND 255          :\ OSWORD &14 - FSOp

\ OSWORD dispatch address high bytes
\ ----------------------------------
.L8EBD
EQUB (L8EC2-1) DIV 256          :\ OSWORD &10 - NetTx
EQUB (L8F7C-1) DIV 256          :\ OSWORD &11 - NetRx
EQUB (L8EDC-1) DIV 256          :\ OSWORD &12 - NetParams
EQUB (L8F01-1) DIV 256          :\ OSWORD &13 - NetInfo
EQUB (L8FF0-1) DIV 256          :\ OSWORD &14 - FSOp


\ OSWORD &10 - NetTx - Network Transmit
\ =====================================
.L8EC2
ASL &0D62                     :\ Transmission in progress?
TYA:BCC L8EFC                 :\ Yes, exit returning &00
LDA &9D:STA &AC:STA &A1       :\ &AB/C=>workspace
LDA #&6F:STA &AB:STA &A0      :\ &A0/1=>workspace
LDX #&0F:JSR L8F1C            :\ Copy control block to ws+&6F
JMP L9630                     :\ Jump to low level code


\ OSWORD &12 - NetParams
\ ======================
.L8EDC
LDA &9D         :\ 8EDC= A5 9D       %.
STA &AC         :\ 8EDE= 85 AC       .,
LDY #&7F        :\ 8EE0= A0 7F        .
LDA (&9C),Y     :\ 8EE2= B1 9C       1.
INY             :\ 8EE4= C8          H
STY &AB         :\ 8EE5= 84 AB       .+
TAX             :\ 8EE7= AA          *
DEX             :\ 8EE8= CA          J
LDY #&00        :\ 8EE9= A0 00        .
JSR L8F1C       :\ 8EEB= 20 1C 8F     ..
JMP L92F0       :\ 8EEE= 4C F0 92    Lp.
 
.L8EF1
LDY #&7F        :\ 8EF1= A0 7F        .
LDA (&9C),Y     :\ 8EF3= B1 9C       1.
LDY #&01        :\ 8EF5= A0 01        .
STA (&F0),Y     :\ 8EF7= 91 F0       .p
INY             :\ 8EF9= C8          H
LDA #&80        :\ 8EFA= A9 80       ).
.L8EFC
STA (&F0),Y     :\ 8EFC= 91 F0       .p
RTS             :\ 8EFE= 60          `
 
.L8EFF
EQUB &FF        :\ 8EFF= FF          .
EQUB &01        :\ 8F00= 01


\ OSWORD &13 - NetInfo - Read/Write network info
\ ==============================================
.L8F01
CMP  #&06
EQUB &B0
EOR (&C9,X)     :\ 8F04= 41 C9       AI
EQUW &B004      :\ 8F06= 04 B0       .0
EQUB &22        :\ 8F08= 22          "
LSR A           :\ 8F09= 4A          J
LDX #&0D        :\ 8F0A= A2 0D       ".
TAY             :\ 8F0C= A8          (
BEQ L8F11       :\ 8F0D= F0 02       p.
LDX &9F         :\ 8F0F= A6 9F       &.
.L8F11
STX &AC         :\ 8F11= 86 AC       .,
LDA L8EFF,Y     :\ 8F13= B9 FF 8E    9..
STA &AB         :\ 8F16= 85 AB       .+
LDX #&01        :\ 8F18= A2 01       ".
LDY #&01        :\ 8F1A= A0 01        .
.L8F1C
BCC L8F22       :\ 8F1C= 90 04       ..
LDA (&F0),Y     :\ 8F1E= B1 F0       1p
STA (&AB),Y     :\ 8F20= 91 AB       .+
.L8F22
LDA (&AB),Y     :\ 8F22= B1 AB       1+
STA (&F0),Y     :\ 8F24= 91 F0       .p
INY             :\ 8F26= C8          H
DEX             :\ 8F27= CA          J
BPL L8F1C       :\ 8F28= 10 F2       .r
RTS             :\ 8F2A= 60          `
 
.L8F2B
LSR A           :\ 8F2B= 4A          J
INY             :\ 8F2C= C8          H
LDA (&F0),Y     :\ 8F2D= B1 F0       1p
BCS L8F36       :\ 8F2F= B0 05       0.
LDA &0D63       :\ 8F31= AD 63 0D    -c.
STA (&F0),Y     :\ 8F34= 91 F0       .p
.L8F36
STA &0D63       :\ 8F36= 8D 63 0D    .c.
STA &0D65       :\ 8F39= 8D 65 0D    .e.
RTS             :\ 8F3C= 60          `
 
.L8F3D
LDY #&14        :\ 8F3D= A0 14        .
LDA (&9C),Y     :\ 8F3F= B1 9C       1.
LDY #&01        :\ 8F41= A0 01        .
STA (&F0),Y     :\ 8F43= 91 F0       .p
RTS             :\ 8F45= 60          `
 
.L8F46
CMP #&08        :\ 8F46= C9 08       I.
BEQ L8F3D       :\ 8F48= F0 F3       ps
CMP #&09        :\ 8F4A= C9 09       I.
BEQ L8EF1       :\ 8F4C= F0 A3       p#
BPL L8F69       :\ 8F4E= 10 19       ..
LDY #&03        :\ 8F50= A0 03        .
LSR A           :\ 8F52= 4A          J
BCC L8F70       :\ 8F53= 90 1B       ..
STY &A8         :\ 8F55= 84 A8       .(
.L8F57
LDY &A8         :\ 8F57= A4 A8       $(
LDA (&F0),Y     :\ 8F59= B1 F0       1p
JSR L869A       :\ 8F5B= 20 9A 86     ..
TYA             :\ 8F5E= 98          .
LDY &A8         :\ 8F5F= A4 A8       $(
STA &0E01,Y     :\ 8F61= 99 01 0E    ...
DEC &A8         :\ 8F64= C6 A8       F(
BNE L8F57       :\ 8F66= D0 EF       Po
RTS             :\ 8F68= 60          `
 
.L8F69
INY             :\ 8F69= C8          H
LDA &0E09       :\ 8F6A= AD 09 0E    -..
STA (&F0),Y     :\ 8F6D= 91 F0       .p
RTS             :\ 8F6F= 60          `
 
.L8F70
LDA &0E01,Y     :\ 8F70= B9 01 0E    9..
JSR L86B7       :\ 8F73= 20 B7 86     7.
STA (&F0),Y     :\ 8F76= 91 F0       .p
DEY             :\ 8F78= 88          .
BNE L8F70       :\ 8F79= D0 F5       Pu
RTS             :\ 8F7B= 60          `


\ OSWORD &11 - NetRx - Create/Read network receive block
\ ======================================================
.L8F7C
LDX &9F         :\ 8F7C= A6 9F       &.
STX &AC         :\ 8F7E= 86 AC       .,
STY &AB         :\ 8F80= 84 AB       .+
ROR &0D64       :\ 8F82= 6E 64 0D    nd.
LDA (&F0),Y     :\ 8F85= B1 F0       1p
STA &AA         :\ 8F87= 85 AA       .*
BNE L8FA6       :\ 8F89= D0 1B       P.
LDA #&03        :\ 8F8B= A9 03       ).
.L8F8D
JSR L8E55       :\ 8F8D= 20 55 8E     U.
BCS L8FCF       :\ 8F90= B0 3D       0=
LSR A           :\ 8F92= 4A          J
LSR A           :\ 8F93= 4A          J
TAX             :\ 8F94= AA          *
LDA (&AB),Y     :\ 8F95= B1 AB       1+
BEQ L8FCF       :\ 8F97= F0 36       p6
CMP #&3F        :\ 8F99= C9 3F       I?
BEQ L8FA1       :\ 8F9B= F0 04       p.
INX             :\ 8F9D= E8          h
TXA             :\ 8F9E= 8A          .
BNE L8F8D       :\ 8F9F= D0 EC       Pl
.L8FA1
TXA             :\ 8FA1= 8A          .
LDX #&00        :\ 8FA2= A2 00       ".
STA (&F0,X)     :\ 8FA4= 81 F0       .p
.L8FA6
JSR L8E55       :\ 8FA6= 20 55 8E     U.
BCS L8FCF       :\ 8FA9= B0 24       0$
DEY             :\ 8FAB= 88          .
STY &AB         :\ 8FAC= 84 AB       .+
LDA #&C0        :\ 8FAE= A9 C0       )@
LDY #&01        :\ 8FB0= A0 01        .
LDX #&0B        :\ 8FB2= A2 0B       ".
CPY &AA         :\ 8FB4= C4 AA       D*
ADC (&AB),Y     :\ 8FB6= 71 AB       q+
BEQ L8FBD       :\ 8FB8= F0 03       p.
BMI L8FCA       :\ 8FBA= 30 0E       0.
.L8FBC
CLC             :\ 8FBC= 18          .
.L8FBD
JSR L8F1C       :\ 8FBD= 20 1C 8F     ..
BCS L8FD1       :\ 8FC0= B0 0F       0.
LDA #&3F        :\ 8FC2= A9 3F       )?
LDY #&01        :\ 8FC4= A0 01        .
STA (&AB),Y     :\ 8FC6= 91 AB       .+
BNE L8FD1       :\ 8FC8= D0 07       P.
.L8FCA
ADC #&01        :\ 8FCA= 69 01       i.
BNE L8FBC       :\ 8FCC= D0 EE       Pn
DEY             :\ 8FCE= 88          .
.L8FCF
STA (&F0),Y     :\ 8FCF= 91 F0       .p
.L8FD1
ROL &0D64       :\ 8FD1= 2E 64 0D    .d.
RTS             :\ 8FD4= 60          `
 
.L8FD5
LDY #&1C        :\ 8FD5= A0 1C        .
LDA &F0         :\ 8FD7= A5 F0       %p
ADC #&01        :\ 8FD9= 69 01       i.
JSR L8FE6       :\ 8FDB= 20 E6 8F     f.
LDY #&01        :\ 8FDE= A0 01        .
LDA (&F0),Y     :\ 8FE0= B1 F0       1p
LDY #&20        :\ 8FE2= A0 20         
ADC &F0         :\ 8FE4= 65 F0       ep
.L8FE6
STA (&9E),Y     :\ 8FE6= 91 9E       ..
INY             :\ 8FE8= C8          H
LDA &F1         :\ 8FE9= A5 F1       %q
ADC #&00        :\ 8FEB= 69 00       i.
STA (&9E),Y     :\ 8FED= 91 9E       ..
RTS             :\ 8FEF= 60          `


\ OSWORD &14 - NetFS_Op - Send command to file server (and other stuff)
\ =====================================================================
.L8FF0
CMP #&01:BCS L903E            :\ Jump if not NetFS_Op
LDY #&23                      :\ Set up NetTx control block
.L8FF6
LDA L8395,Y:BNE L8FFE
LDA &0DE6,Y                   :\ Replace zero bytes with len, fs.net, fs.stn
.L8FFE
STA (&9E),Y:DEY
CPY #&17:BNE L8FF6
INY:STY &9A:JSR L8FD5         :\ Point NetTx start/end address to OSWORD block
LDY #&02
.L900D
LDA #&90:STA &97:STA (&F0),Y  :\ Store &90 reply port in OSWORD block
INY:INY                       :\ Step past function code
.L9015
LDA &0DFE,Y:STA (&F0),Y:INY   :\ Copy URD, CSD, LIB to OSWORD block
CPY #&07:BNE L9015
LDA &9F:STA &9B:CLI:JSR L85FF :\ Transmit the OSWORD &14 block
LDY #&20:LDA #&FF:STA (&9E),Y :\ Change the NetTx control block to a NetRx block
INY:STA (&9E),Y:LDY #&19
LDA #&90:STA (&9E),Y:DEY      :\ Listen on port &90
LDA #&7F:STA (&9E),Y          :\ b7=0 - no reception yet
JMP L8530                     :\ Jump to wait for a reception
 
.L903E
PHP             :\ 903E= 08          .
LDY #&01        :\ 903F= A0 01        .
LDA (&F0),Y     :\ 9041= B1 F0       1p
TAX             :\ 9043= AA          *
.L9044
INY             :\ 9044= C8          H
.L9045
LDA (&F0),Y     :\ 9045= B1 F0       1p
INY             :\ 9047= C8          H
STY &AB         :\ 9048= 84 AB       .+
LDY #&72        :\ 904A= A0 72        r
STA (&9C),Y     :\ 904C= 91 9C       ..
DEY             :\ 904E= 88          .
TXA             :\ 904F= 8A          .
STA (&9C),Y     :\ 9050= 91 9C       ..
PLP             :\ 9052= 28          (
BNE L9071       :\ 9053= D0 1C       P.
.L9055
LDY &AB         :\ 9055= A4 AB       $+
INC &AB         :\ 9057= E6 AB       f+
LDA (&F0),Y     :\ 9059= B1 F0       1p
BEQ L9070       :\ 905B= F0 13       p.
LDY #&7D        :\ 905D= A0 7D        }
STA (&9C),Y     :\ 905F= 91 9C       ..
PHA             :\ 9061= 48          H
JSR L917F       :\ 9062= 20 7F 91     ..
JSR L907C       :\ 9065= 20 7C 90     |.
.L9068
DEX             :\ 9068= CA          J
BNE L9068       :\ 9069= D0 FD       P}
PLA             :\ 906B= 68          h
EOR #&0D        :\ 906C= 49 0D       I.
BNE L9055       :\ 906E= D0 E5       Pe
.L9070
RTS             :\ 9070= 60          `
 
.L9071
JSR L917F       :\ 9071= 20 7F 91     ..
LDY #&7B        :\ 9074= A0 7B        {
LDA (&9C),Y     :\ 9076= B1 9C       1.
ADC #&03        :\ 9078= 69 03       i.
STA (&9C),Y     :\ 907A= 91 9C       ..
.L907C
CLI             :\ 907C= 58          X
JMP L85FF       :\ 907D= 4C FF 85    L..

\ NETV handler
\ ============
.L9080
PHP             :\ 9080= 08          .
PHA             :\ 9081= 48          H
TXA             :\ 9082= 8A          .
PHA             :\ 9083= 48          H
TYA             :\ 9084= 98          .
PHA             :\ 9085= 48          H
TSX             :\ 9086= BA          :
LDA &0103,X     :\ 9087= BD 03 01    =..
CMP #&09        :\ 908A= C9 09       I.
BCS L9092       :\ 908C= B0 04       0.
TAX             :\ 908E= AA          *
JSR L9099       :\ 908F= 20 99 90     ..
.L9092
PLA             :\ 9092= 68          h
TAY             :\ 9093= A8          (
PLA             :\ 9094= 68          h
TAX             :\ 9095= AA          *
PLA             :\ 9096= 68          h
PLP             :\ 9097= 28          (
RTS             :\ 9098= 60          `
 
.L9099
LDA L90AD,X     :\ 9099= BD AD 90    =-.
PHA             :\ 909C= 48          H
LDA L90A4,X     :\ 909D= BD A4 90    =$.
PHA             :\ 90A0= 48          H
LDA &EF         :\ 90A1= A5 EF       %o
RTS             :\ 90A3= 60          `
 
.L90A4
EQUB (L80F6-1) AND 255 :\ 0=null
EQUB (L91EA-1) AND 255 :\ 1=print char
EQUB (L91EA-1) AND 255 :\ 2=printer on
EQUB (L91EA-1) AND 255 :\ 3=printer off
EQUB (L90B6-1) AND 255 :\ 4=wrch
EQUB (L91DB-1) AND 255 :\ 5=printer select
EQUB (L80F6-1) AND 255 :\ 6=rdch
EQUB (L90E8-1) AND 255 :\ 7=osbyte
EQUB (L9154-1) AND 255 :\ 8=osword
.L90AD
EQUB (L80F6-1) DIV 256 :\ 0=null
EQUB (L91EA-1) DIV 256 :\ 1=print char
EQUB (L91EA-1) DIV 256 :\ 2=printer on
EQUB (L91EA-1) DIV 256 :\ 3=printer off
EQUB (L90B6-1) DIV 256 :\ 4=wrch
EQUB (L91DB-1) DIV 256 :\ 5=printer select
EQUB (L80F6-1) DIV 256 :\ 6=rdch
EQUB (L90E8-1) DIV 256 :\ 7=osbyte
EQUB (L9154-1) DIV 256 :\ 8=osword

\ NETV 4 - WRCH
\ -------------
.L90B6
TSX             :\ 90B6= BA
ROR &0106,X     :\ 90B7= 7E 06 01    ~..
ASL &0106,X     :\ 90BA= 1E 06 01    ...
TYA             :\ 90BD= 98          .
LDY #&DA        :\ 90BE= A0 DA        Z
STA (&9E),Y     :\ 90C0= 91 9E       ..
LDA #&00        :\ 90C2= A9 00       ).
.L90C4
LDY #&D9        :\ 90C4= A0 D9        Y
STA (&9E),Y     :\ 90C6= 91 9E       ..
LDA #&80        :\ 90C8= A9 80       ).
LDY #&0C        :\ 90CA= A0 0C        .
STA (&9E),Y     :\ 90CC= 91 9E       ..
LDA &9A         :\ 90CE= A5 9A       %.
PHA             :\ 90D0= 48          H
LDA &9B         :\ 90D1= A5 9B       %.
PHA             :\ 90D3= 48          H
STY &9A         :\ 90D4= 84 9A       ..
LDX &9F         :\ 90D6= A6 9F       &.
STX &9B         :\ 90D8= 86 9B       ..
JSR L85FF       :\ 90DA= 20 FF 85     ..
LDA #&3F        :\ 90DD= A9 3F       )?
STA (&9A,X)     :\ 90DF= 81 9A       ..
PLA             :\ 90E1= 68          h
STA &9B         :\ 90E2= 85 9B       ..
PLA             :\ 90E4= 68          h
STA &9A         :\ 90E5= 85 9A       ..
RTS             :\ 90E7= 60          `
 
.L90E8
LDY &F1         :\ 90E8= A4 F1       $q
CMP #&81        :\ 90EA= C9 81       I.
BEQ L9101       :\ 90EC= F0 13       p.
LDY #&01        :\ 90EE= A0 01        .
LDX #&09        :\ 90F0= A2 09       ".
JSR L913C       :\ 90F2= 20 3C 91     <.
BEQ L9101       :\ 90F5= F0 0A       p.
DEY             :\ 90F7= 88          .
DEY             :\ 90F8= 88          .
LDX #&0E        :\ 90F9= A2 0E       ".
JSR L913C       :\ 90FB= 20 3C 91     <.
BEQ L9101       :\ 90FE= F0 01       p.
INY             :\ 9100= C8          H
.L9101
LDX #&02        :\ 9101= A2 02       ".
TYA             :\ 9103= 98          .
BEQ L913B       :\ 9104= F0 35       p5
PHP             :\ 9106= 08          .
BPL L910A       :\ 9107= 10 01       ..
INX             :\ 9109= E8          h
.L910A
LDY #&DC        :\ 910A= A0 DC        \
.L910C
LDA &0015,Y     :\ 910C= B9 15 00    9..
STA (&9E),Y     :\ 910F= 91 9E       ..
DEY             :\ 9111= 88          .
CPY #&DA        :\ 9112= C0 DA       @Z
BPL L910C       :\ 9114= 10 F6       .v
TXA             :\ 9116= 8A          .
JSR L90C4       :\ 9117= 20 C4 90     D.
PLP             :\ 911A= 28          (
BPL L913B       :\ 911B= 10 1E       ..
LDA #&7F        :\ 911D= A9 7F       ).
LDY #&0C        :\ 911F= A0 0C        .
STA (&9E),Y     :\ 9121= 91 9E       ..
.L9123
LDA (&9E),Y     :\ 9123= B1 9E       1.
BPL L9123       :\ 9125= 10 FC       .|
TSX             :\ 9127= BA          :
LDY #&DD        :\ 9128= A0 DD        ]
LDA (&9E),Y     :\ 912A= B1 9E       1.
ORA #&44        :\ 912C= 09 44       .D
BNE L9134       :\ 912E= D0 04       P.
.L9130
DEY             :\ 9130= 88          .
DEX             :\ 9131= CA          J
LDA (&9E),Y     :\ 9132= B1 9E       1.
.L9134
STA &0106,X     :\ 9134= 9D 06 01    ...
CPY #&DA        :\ 9137= C0 DA       @Z
BNE L9130       :\ 9139= D0 F5       Pu
.L913B
RTS             :\ 913B= 60          `
 
.L913C
CMP L9145,X     :\ 913C= DD 45 91    ]E.
BEQ L9144       :\ 913F= F0 03       p.
DEX             :\ 9141= CA          J
BPL L913C       :\ 9142= 10 F8       .x
.L9144
RTS             :\ 9144= 60          `
 
.L9145
EQUW &0904      :\ 9145= 04 09       ..
ASL A           :\ 9147= 0A          .
ORA &9A,X       :\ 9148= 15 9A       ..
EQUB &9B        :\ 914A= 9B          .
SBC (&E2,X)     :\ 914B= E1 E2       ab
EQUB &E3        :\ 914D= E3          c
CPX &0B         :\ 914E= E4 0B       d.
EQUW &0F0C      :\ 9150= 0C 0F 79    ..y
EQUB &79
EQUB &7A        :\ 9153= 7A          z

.L9154
LDY #&0E        :\ 9154= A0 0E        .
CMP #&07        :\ 9156= C9 07       I.
BEQ L915E       :\ 9158= F0 04       p.
CMP #&08        :\ 915A= C9 08       I.
BNE L9144       :\ 915C= D0 E6       Pf
.L915E
LDX #&DB        :\ 915E= A2 DB       "[
STX &9E         :\ 9160= 86 9E       ..
.L9162
LDA (&F0),Y     :\ 9162= B1 F0       1p
STA (&9E),Y     :\ 9164= 91 9E       ..
DEY             :\ 9166= 88          .
BPL L9162       :\ 9167= 10 F9       .y
INY             :\ 9169= C8          H
DEC &9E         :\ 916A= C6 9E       F.
LDA &EF         :\ 916C= A5 EF       %o
STA (&9E),Y     :\ 916E= 91 9E       ..
STY &9E         :\ 9170= 84 9E       ..
LDY #&14        :\ 9172= A0 14        .
LDA #&E9        :\ 9174= A9 E9       )i
STA (&9E),Y     :\ 9176= 91 9E       ..
LDA #&01        :\ 9178= A9 01       ).
JSR L90C4       :\ 917A= 20 C4 90     D.
STX &9E         :\ 917D= 86 9E       ..
.L917F
LDX #&0D        :\ 917F= A2 0D       ".
LDY #&7C        :\ 9181= A0 7C        |
BIT L83B3       :\ 9183= 2C B3 83    ,3.
BVS L918D       :\ 9186= 70 05       p.

.L9188
LDY #&17        :\ 9188= A0 17        .
LDX #&1A        :\ 918A= A2 1A       ".
.L918C
CLV             :\ 918C= B8          8
.L918D
LDA L91B4,X     :\ 918D= BD B4 91    =4.
CMP #&FE:BEQ L91B0       :\ 9192= F0 1C       p.
CMP #&FD:BEQ L91AC       :\ 9196= F0 14       p.
CMP #&FC:BNE L91A4       :\ 919A= D0 08       P.
LDA &9D         :\ 919C= A5 9D       %.
BVS L91A2       :\ 919E= 70 02       p.
LDA &9F         :\ 91A0= A5 9F       %.
.L91A2
STA &9B         :\ 91A2= 85 9B       ..
.L91A4
BVS L91AA       :\ 91A4= 70 04       p.
STA (&9E),Y     :\ 91A6= 91 9E       ..
BVC L91AC       :\ 91A8= 50 02       P.
.L91AA
STA (&9C),Y     :\ 91AA= 91 9C       ..
.L91AC
DEY             :\ 91AC= 88          .
DEX             :\ 91AD= CA          J
BPL L918D       :\ 91AE= 10 DD       .]
.L91B0
INY             :\ 91B0= C8          H
STY &9A         :\ 91B1= 84 9A       ..
RTS             :\ 91B3= 60          `
 
.L91B4
STA &00         :\ 91B4= 85 00       ..
SBC &7DFD,X     :\ 91B6= FD FD 7D    }}}
EQUB &FC        :\ 91B9= FC          |
EQUB &FF        :\ 91BA= FF          .
EQUB &FF        :\ 91BB= FF          .
ROR &FFFC,X     :\ 91BC= 7E FC FF    ~|.
EQUB &FF        :\ 91BF= FF          .
BRK             :\ 91C0= 00          .
BRK             :\ 91C1= 00          .
EQUB &FE
EQUW &9380
SBC &D9FD,X     :\ 91C5= FD FD D9    }}Y
EQUB &FC        :\ 91C8= FC          |
EQUB &FF        :\ 91C9= FF          .
EQUB &FF        :\ 91CA= FF          .
DEC &FFFC,X     :\ 91CB= DE FC FF    ^|.
EQUB &FF        :\ 91CE= FF          .
INC &FDD1,X     :\ 91CF= FE D1 FD    ~Q}
SBC &FD1F,X     :\ 91D2= FD 1F FD    }.}
EQUB &FF        :\ 91D5= FF          .
EQUB &FF        :\ 91D6= FF          .
SBC &FFFD,X     :\ 91D7= FD FD FF    }}.
EQUB &FF        :\ 91DA= FF          .

.L91DB
DEX             :\ 91DB= CA          J
CPX &F0         :\ 91DC= E4 F0       dp
BNE L91E7       :\ 91DE= D0 07       P.
LDA #&1F        :\ 91E0= A9 1F       ).
STA &0D61       :\ 91E2= 8D 61 0D    .a.
LDA #&41        :\ 91E5= A9 41       )A
.L91E7
STA &99         :\ 91E7= 85 99       ..
.L91E9
RTS             :\ 91E9= 60          `

.L91EA
CPY #&04        :\ 91EA= C0 04       @.
BNE L91E9       :\ 91EC= D0 FB       P{
TXA             :\ 91EE= 8A          .
DEX             :\ 91EF= CA          J
BNE L9218       :\ 91F0= D0 26       P&
TSX             :\ 91F2= BA          :
ORA &0106,X     :\ 91F3= 1D 06 01    ...
STA &0106,X     :\ 91F6= 9D 06 01    ...
.L91F9
LDA #&91        :\ 91F9= A9 91       ).
LDX #&03        :\ 91FB= A2 03       ".
JSR OSBYTE      :\ 91FD= 20 F4 FF     t.
BCS L91E9       :\ 9200= B0 E7       0g
TYA             :\ 9202= 98          .
JSR L920F       :\ 9203= 20 0F 92     ..
CPY #&6E        :\ 9206= C0 6E       @n
BCC L91F9       :\ 9208= 90 EF       .o
JSR L9237       :\ 920A= 20 37 92     7.
BCC L91F9       :\ 920D= 90 EA       .j
.L920F
LDY &0D61       :\ 920F= AC 61 0D    ,a.
STA (&9C),Y     :\ 9212= 91 9C       ..
INC &0D61       :\ 9214= EE 61 0D    na.
RTS             :\ 9217= 60          `
 
.L9218
PHA             :\ 9218= 48          H
TXA             :\ 9219= 8A          .
EOR #&01        :\ 921A= 49 01       I.
JSR L920F       :\ 921C= 20 0F 92     ..
EOR &99         :\ 921F= 45 99       E.
ROR A           :\ 9221= 6A          j
BCC L922A       :\ 9222= 90 06       ..
ROL A           :\ 9224= 2A          *
STA &99         :\ 9225= 85 99       ..
JSR L9237       :\ 9227= 20 37 92     7.
.L922A
LDA &99         :\ 922A= A5 99       %.
AND #&F0        :\ 922C= 29 F0       )p
ROR A           :\ 922E= 6A          j
TAX             :\ 922F= AA          *
PLA             :\ 9230= 68          h
ROR A           :\ 9231= 6A          j
TXA             :\ 9232= 8A          .
ROL A           :\ 9233= 2A          *
STA &99         :\ 9234= 85 99       ..
RTS             :\ 9236= 60          `
 
.L9237
LDY #&08        :\ 9237= A0 08        .
LDA &0D61       :\ 9239= AD 61 0D    -a.
STA (&9E),Y     :\ 923C= 91 9E       ..
LDA &9D         :\ 923E= A5 9D       %.
INY             :\ 9240= C8          H
STA (&9E),Y     :\ 9241= 91 9E       ..
LDY #&05        :\ 9243= A0 05        .
STA (&9E),Y     :\ 9245= 91 9E       ..
LDY #&0B        :\ 9247= A0 0B        .
LDX #&26        :\ 9249= A2 26       "&
JSR L918C       :\ 924B= 20 8C 91     ..
DEY             :\ 924E= 88          .
LDA &99         :\ 924F= A5 99       %.
PHA             :\ 9251= 48          H
ROL A           :\ 9252= 2A          *
PLA             :\ 9253= 68          h
EOR #&80        :\ 9254= 49 80       I.
STA &99         :\ 9256= 85 99       ..
ROL A           :\ 9258= 2A          *
STA (&9E),Y     :\ 9259= 91 9E       ..
LDY #&1F        :\ 925B= A0 1F        .
STY &0D61       :\ 925D= 8C 61 0D    .a.
LDA #&00        :\ 9260= A9 00       ).
TAX             :\ 9262= AA          *
LDY &9F         :\ 9263= A4 9F       $.
CLI             :\ 9265= 58          X
.L9266
STX &9A         :\ 9266= 86 9A       ..
STY &9B         :\ 9268= 84 9B       ..
PHA             :\ 926A= 48          H
AND &0E08       :\ 926B= 2D 08 0E    -..
BEQ L9272       :\ 926E= F0 02       p.
LDA #&01        :\ 9270= A9 01       ).
.L9272
LDY #&00        :\ 9272= A0 00        .
ORA (&9A),Y     :\ 9274= 11 9A       ..
PHA             :\ 9276= 48          H
STA (&9A),Y     :\ 9277= 91 9A       ..
JSR L85FF       :\ 9279= 20 FF 85     ..
LDA #&FF        :\ 927C= A9 FF       ).
LDY #&08        :\ 927E= A0 08        .
STA (&9A),Y     :\ 9280= 91 9A       ..
INY             :\ 9282= C8          H
STA (&9A),Y     :\ 9283= 91 9A       ..
PLA             :\ 9285= 68          h
TAX             :\ 9286= AA          *
LDY #&D1        :\ 9287= A0 D1        Q
PLA             :\ 9289= 68          h
PHA             :\ 928A= 48          H
BEQ L928F       :\ 928B= F0 02       p.
LDY #&90        :\ 928D= A0 90        .
.L928F
TYA             :\ 928F= 98          .
LDY #&01        :\ 9290= A0 01        .
STA (&9A),Y     :\ 9292= 91 9A       ..
TXA             :\ 9294= 8A          .
DEY             :\ 9295= 88          .
PHA             :\ 9296= 48          H
.L9297
LDA #&7F        :\ 9297= A9 7F       ).
STA (&9A),Y     :\ 9299= 91 9A       ..
JSR L8530       :\ 929B= 20 30 85     0.
PLA             :\ 929E= 68          h
PHA             :\ 929F= 48          H
EOR (&9A),Y     :\ 92A0= 51 9A       Q.
ROR A           :\ 92A2= 6A          j
BCS L9297       :\ 92A3= B0 F2       0r
PLA             :\ 92A5= 68          h
PLA             :\ 92A6= 68          h
EOR &0E08       :\ 92A7= 4D 08 0E    M..
RTS             :\ 92AA= 60          `

\ Remote OS Call 2 - Read VIEW parameters
\ =======================================
.L92AB
LDA &AD         :\ 92AB= A5 AD       %-
PHA             :\ 92AD= 48          H
LDA #&E9        :\ 92AE= A9 E9       )i
STA &9E         :\ 92B0= 85 9E       ..
LDY #&00        :\ 92B2= A0 00        .
STY &AD         :\ 92B4= 84 AD       .-
LDA &0350       :\ 92B6= AD 50 03    -P.
STA (&9E),Y     :\ 92B9= 91 9E       ..
INC &9E         :\ 92BB= E6 9E       f.
LDA &0351       :\ 92BD= AD 51 03    -Q.
PHA             :\ 92C0= 48          H
TYA             :\ 92C1= 98          .
.L92C2
STA (&9E),Y     :\ 92C2= 91 9E       ..
LDX &9E         :\ 92C4= A6 9E       &.
LDY &9F         :\ 92C6= A4 9F       $.
LDA #&0B        :\ 92C8= A9 0B       ).
JSR OSWORD      :\ 92CA= 20 F1 FF     q.
PLA             :\ 92CD= 68          h
LDY #&00        :\ 92CE= A0 00        .
STA (&9E),Y     :\ 92D0= 91 9E       ..
INY             :\ 92D2= C8          H
LDA (&9E),Y     :\ 92D3= B1 9E       1.
PHA             :\ 92D5= 48          H
LDX &9E         :\ 92D6= A6 9E       &.
INC &9E         :\ 92D8= E6 9E       f.
INC &AD         :\ 92DA= E6 AD       f-
DEY             :\ 92DC= 88          .
LDA &AD         :\ 92DD= A5 AD       %-
CPX #&F9        :\ 92DF= E0 F9       `y
BNE L92C2       :\ 92E1= D0 DF       P_
PLA             :\ 92E3= 68          h
STY &AD         :\ 92E4= 84 AD       .-
INC &9E         :\ 92E6= E6 9E       f.
JSR L92F7       :\ 92E8= 20 F7 92     w.
INC &9E         :\ 92EB= E6 9E       f.
PLA             :\ 92ED= 68          h
STA &AD         :\ 92EE= 85 AD       .-
.L92F0
LDA &0D65       :\ 92F0= AD 65 0D    -e.
STA &0D63       :\ 92F3= 8D 63 0D    .c.
RTS             :\ 92F6= 60          `
 
.L92F7
LDA &0355       :\ 92F7= AD 55 03    -U.
STA (&9E),Y     :\ 92FA= 91 9E       ..
TAX             :\ 92FC= AA          *
JSR L930A       :\ 92FD= 20 0A 93     ..
INC &9E         :\ 9300= E6 9E       f.
TYA             :\ 9302= 98          .
STA (&9E,X)     :\ 9303= 81 9E       ..
JSR L9308       :\ 9305= 20 08 93     ..
.L9308
LDX #&00        :\ 9308= A2 00       ".
.L930A
LDY &AD         :\ 930A= A4 AD       $-
INC &AD         :\ 930C= E6 AD       f-
INC &9E         :\ 930E= E6 9E       f.
LDA L931E,Y     :\ 9310= B9 1E 93    9..
LDY #&FF        :\ 9313= A0 FF        .
JSR OSBYTE      :\ 9315= 20 F4 FF     t.
TXA             :\ 9318= 8A          .
LDX #&00        :\ 9319= A2 00       ".
STA (&9E,X)     :\ 931B= 81 9E       ..
RTS             :\ 931D= 60          `
.L931E
EQUB &85        :\ 931E= 85          .   OSBYTE screen start
EQUW &C3C2      :\ 931F= C2 C3       BC  OSBYTE Flash counters

