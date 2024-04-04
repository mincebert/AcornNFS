\ LOW LEVEL ECONET CONTROL
\ ======================== 

IF (VERSION AND &FF0)=&0340
 SKIPTO &9660
ENDIF

IF VERSION=&0365
 SKIPTO &9650
ENDIF

\ ======================== 
\ LOW LEVEL ECONET CONTROL
\ ======================== 
.L9630:JMP L9B6E       :\ Transmit block pointed to by (&A0)
.L9633:JMP L967A       :\ Initialise drivers
.L9636:JMP L9F57       :\ NMI Claimed, I have to relinquish it
.L9639:JMP L9698       :\ NMI Released, I can take over
.L963C
LDA #&04
BIT SYSVIA+&D:BNE L9646:\ VIA interupt for Remote Call, jump to process
LDA #&05:RTS           :\ Return unclaimed

\ Immediates &83,&84,&85 cause callback via IRQ
\ ---------------------------------------------
.L9646
TXA:PHA:TYA:PHA        :\ Save registers
LDA SYSVIA+&B:AND #&E3
ORA &0D51:STA SYSVIA+&B:\ Restore System VIA settings
LDA SYSVIA+&A          :\ Read shift register to clear it
LDA #&04:STA SYSVIA+&D :\ Clear shift register interupt
STA SYSVIA+&E          :\ Disable shift register interupt
LDY &0D57              :\ Get control byte
CPY #&86:BCS L9672     :\ If Halt/Cont/MType, skip past
LDA &0D63:STA &0D65    :\ Save protection mask
ORA #&1C:STA &0D63     :\ Protect against OSProc/UserProc/JSR
.L9672
LDA #L9B20 DIV 256:PHA :\ Push high byte of subroutine
LDA L9B20-&83,Y:PHA:RTS:\ Push low byte of subroutine and jump to it

\ Initialise drivers
\ ------------------ 
.L967A
BIT INTOFF           :\ Disable ADLC NMIs
JSR L9F3D            :\ Initialise ADLC
LDA #&EA:LDX #&00
STX &0D66            :\ Not using NMIs
LDY #&FF:JSR OSBYTE  :\ Get Tube flag
STX &0D67
LDA #&8F:LDX #&0C
LDY #&FF:JSR OSBYTE  :\ Claim NMIs

\ NMI has been released, I can take them over
\ -------------------------------------------
.L9698
LDY #&20
.L969A
LDA L9F7D-1,Y:STA &0CFF,Y :\ Copy background NMI code to NMI space
DEY:BNE L969A
LDA &F4:STA &0D07         :\ Put ROM number in NMI code
LDA #&80:STA &0D62
STA &0D66
LDA INTOFF:STA &0D22      :\ Put station number in NMI code
STY &0D23:STY &98
BIT INTON                 :\ Enable ADLC NMIs
RTS

\ Continuation of NMI code
.L96BF
LDA #&01
BIT ADLC+1:BEQ L96FE     :\ Not start of frame
LDA ADLC+2               :\ Get first data byte
CMP INTOFF:BEQ L96D7     :\ Dest=me
CMP #&FF:BNE L96EA       :\ Dest=not me & not broadcast
LDA #&40:STA &0D4A       :\ Note that broadcast being received
.L96D7
LDA #L96DC AND 255
JMP &0D11                :\ Continue receiving this frame

.L96DC 
BIT ADLC+1      :\ 96DC= 2C A1 FE    ,!~
BPL L96FE       :\ 96DF= 10 1D       ..
LDA ADLC+2      :\ 96E1= AD A2 FE    -"~
BEQ L96F2       :\ 96E4= F0 0C       p.
EOR #&FF        :\ 96E6= 49 FF       I.
BEQ L96F5       :\ 96E8= F0 0B       p.
.L96EA
LDA #&A2:STA ADLC+0   :\ Ignore this frame
JMP L99EB
 
.L96F2
STA &0D4A       :\ 96F2= 8D 4A 0D    .J.
.L96F5
STA &A2         :\ 96F5= 85 A2       ."
LDA #L970E AND 255 :\ 96F7= A9 0E       ).
LDY #L970E DIV 256 :\ 96F9= A0 97        .
JMP &0D0E       :\ 96FB= 4C 0E 0D    L..
 
\ Second byte or later
\ --------------------
.L96FE
LDA ADLC+1      :\ 96FE= AD A1 FE    -!~
AND #&81        :\ 9701= 29 81       ).
BEQ L970B       :\ 9703= F0 06       p.
JSR L9F3D       :\ 9705= 20 3D 9F     =.
JMP L99EB       :\ 9708= 4C EB 99    Lk.
 
.L970B
JMP L99E8       :\ 970B= 4C E8 99    Lh.
 
.L970E
LDY &A2         :\ 970E= A4 A2       $"
LDA ADLC+1      :\ 9710= AD A1 FE    -!~
.L9713
BPL L96FE       :\ 9713= 10 E9       .i
LDA ADLC+2      :\ 9715= AD A2 FE    -"~
STA &0D3D,Y     :\ 9718= 99 3D 0D    .=.
INY             :\ 971B= C8          H
LDA ADLC+1      :\ 971C= AD A1 FE    -!~
BMI L9723       :\ 971F= 30 02       0.
BNE L9738       :\ 9721= D0 15       P.
.L9723
LDA ADLC+2      :\ 9723= AD A2 FE    -"~
STA &0D3D,Y     :\ 9726= 99 3D 0D    .=.
INY             :\ 9729= C8          H
CPY #&0C        :\ 972A= C0 0C       @.
BEQ L9738       :\ 972C= F0 0A       p.
STY &A2         :\ 972E= 84 A2       ."
LDA ADLC+1      :\ 9730= AD A1 FE    -!~
BNE L9713       :\ 9733= D0 DE       P^
JMP &0D14       :\ 9735= 4C 14 0D    L..
 
.L9738
LDA #&00:STA ADLC+0       :\
LDA #&84:STA ADLC+1       :\
LDA #&02:BIT ADLC+1       :\
BEQ L96FE
BPL L96FE
LDA ADLC+2:STA &0D3D,Y
LDA #&44:STA ADLC+0
SEC:ROR &98               :\ Set b7 of &98
LDA &0D40:BNE L9761       :\ Port non-zero, deal with normal reception
JMP L9A46                 :\ Port zero, jump to do immediate operation

\ Reception on non-zero port
\ -------------------------- 
.L9761
BIT &0D4A:BVC L976B       :\ Not a broadcast
LDA #&07:STA ADLC+1       :\ Ok to ADLC
.L976B
BIT &0D64:BPL L97AE       :\
LDA #&C0:LDY #&00         :\ Look at receive block at &00C0, (FSOp block)

\ Search receive blocks
\ ---------------------
.L9774
STA &A6:STY &A7           :\ &A6/&=>recive block area
.L9778
LDY #&00
LDA (&A6),Y:BEQ L97AB     :\ End of blocks, jump to exit
CMP #&7F:BNE L979E
INY:LDA (&A6),Y:BEQ L978C :\ Listen on any port
CMP &0D40:BNE L979E       :\ Port doesn't match, try next
.L978C
INY:LDA (&A6),Y:BEQ L97B9 :\ Listen to any station
CMP &0D3D:BNE L979E       :\ Station doesn't match, try next
INY:LDA (&A6),Y
CMP &0D3E:BEQ L97B9       :\ Nets match, jump to process
.L979E
                          :\ Step to next receive block
LDA &A7:BEQ L97AE         :\ Block at &00xx, exit
LDA &A6:CLC:ADC #&0C      :\ Step to next receive block
STA &A6:BCC L9778         :\ Loop back to check this one
.L97AB
JMP L9835                 :\ All checked, exit
 
.L97AE
BIT &0D64:BVC L97AB
LDA #&00:LDY &9F          :\ Point to private workspace
BNE L9774                 :\ Jump to search receive blocks

\ Receive block matches
\ ---------------------
.L97B9
LDA #&03:STA &0D5C        :\
JSR L9ECA
BCC L9835                 :\ Exit
BIT &0D4A:BVC L97CB       :\ Not a broadcast
JMP L99F2
 
.L97CB
LDA #&44:STA ADLC+0
LDA #&A7:STA ADLC+1
LDA #L97DC AND 255
LDY #L97DC DIV 256        :\ Next NMI handler=&97DC
JMP L9907                 :\ Return to NMI routine
 
.L97DC
LDA #&82:STA ADLC+0
LDA #L97E6 AND 255  :\ Next NMI handler=&97E6
IF (P% AND 255)>&10
 JMP &0D11          :\ Set next NMI routine and return
ELSE
 LDY #L97E6 DIV 256 :\ Next NMI handler=&97E6
 JMP &0D0E          :\ Set next NMI routine and return
ENDIF
 
.L97E6
LDA #&01           :\ 97E6= A9 01       ).
BIT ADLC+1         :\ 97E8= 2C A1 FE    ,!~
BEQ L9835          :\ 97EB= F0 48       pH
LDA ADLC+2         :\ 97ED= AD A2 FE    -"~
CMP INTOFF         :\ 97F0= CD 18 FE    M.~
BNE L9835          :\ 97F3= D0 40       P@
LDA #L97FA AND 255 :\ 97F5= A9 FA       )z
JMP &0D11          :\ 97F7= 4C 11 0D    L..
 
.L97FA
BIT ADLC+1      :\ 97FA= 2C A1 FE    ,!~
BPL L9835       :\ 97FD= 10 36       .6
LDA ADLC+2      :\ 97FF= AD A2 FE    -"~
BNE L9835       :\ 9802= D0 31       P1
LDA #L9810 AND 255 :\ 9804= A9 10       ).
LDY #L9810 DIV 256 :\ 9806= A0 98        .
BIT ADLC+0      :\ 9808= 2C A0 FE    , ~
BMI L9810       :\ 980B= 30 03       0.
JMP &0D0E       :\ 980D= 4C 0E 0D    L..
 
.L9810
BIT ADLC+1      :\ 9810= 2C A1 FE    ,!~
BPL L9835       :\ 9813= 10 20       . 
LDA ADLC+2      :\ 9815= AD A2 FE    -"~
LDA ADLC+2      :\ 9818= AD A2 FE    -"~
.L981B
LDA #&02        :\ 981B= A9 02       ).
BIT &0D4A       :\ 981D= 2C 4A 0D    ,J.
BNE L982E       :\ 9820= D0 0C       P.
LDA #L9843 AND 255 :\ 9822= A9 43       )C
LDY #L9843 DIV 256 :\ 9824= A0 98        .
BIT ADLC+0      :\ 9826= 2C A0 FE    , ~
BMI L9843       :\ 9829= 30 18       0.
JMP &0D0E       :\ 982B= 4C 0E 0D    L..
 
.L982E
LDA #L98A0 AND 255 :\ 982E= A9 A0       ) 
LDY #L98A0 DIV 256 :\ 9830= A0 98        .
JMP &0D0E       :\ 9832= 4C 0E 0D    L..
 
.L9835
LDA &0D4A       :\ 9835= AD 4A 0D    -J.
BPL L983D       :\ 9838= 10 03       ..
JMP L9EAC       :\ 983A= 4C AC 9E    L,.
 
.L983D
JSR L9F3D       :\ 983D= 20 3D 9F     =.
JMP L99DB       :\ 9840= 4C DB 99    L[.
 
.L9843
LDY &A2         :\ 9843= A4 A2       $"
LDA ADLC+1      :\ 9845= AD A1 FE    -!~
.L9848
BPL L9877       :\ 9848= 10 2D       .-
LDA ADLC+2      :\ 984A= AD A2 FE    -"~
STA (&A4),Y     :\ 984D= 91 A4       .$
INY             :\ 984F= C8          H
BNE L9858       :\ 9850= D0 06       P.
INC &A5         :\ 9852= E6 A5       f%
DEC &A3         :\ 9854= C6 A3       F#
BEQ L9835       :\ 9856= F0 DD       p]
.L9858
LDA ADLC+1      :\ 9858= AD A1 FE    -!~
BMI L985F       :\ 985B= 30 02       0.
BNE L9877       :\ 985D= D0 18       P.
.L985F
LDA ADLC+2      :\ 985F= AD A2 FE    -"~
STA (&A4),Y     :\ 9862= 91 A4       .$
INY             :\ 9864= C8          H
STY &A2         :\ 9865= 84 A2       ."
BNE L986F       :\ 9867= D0 06       P.
INC &A5         :\ 9869= E6 A5       f%
DEC &A3         :\ 986B= C6 A3       F#
BEQ L9877       :\ 986D= F0 08       p.
.L986F
LDA ADLC+1      :\ 986F= AD A1 FE    -!~
BNE L9848       :\ 9872= D0 D4       PT
JMP &0D14       :\ 9874= 4C 14 0D    L..
 
.L9877
LDA #&84        :\ 9877= A9 84       ).
STA ADLC+1      :\ 9879= 8D A1 FE    .!~
LDA #&00        :\ 987C= A9 00       ).
STA ADLC+0      :\ 987E= 8D A0 FE    . ~
STY &A2         :\ 9881= 84 A2       ."
LDA #&02        :\ 9883= A9 02       ).
BIT ADLC+1      :\ 9885= 2C A1 FE    ,!~
BEQ L9835       :\ 9888= F0 AB       p+
BPL L989D       :\ 988A= 10 11       ..
LDA &A3         :\ 988C= A5 A3       %#
.L988E
BEQ L9835       :\ 988E= F0 A5       p%
LDA ADLC+2      :\ 9890= AD A2 FE    -"~
LDY &A2         :\ 9893= A4 A2       $"
STA (&A4),Y     :\ 9895= 91 A4       .$
INC &A2         :\ 9897= E6 A2       f"
BNE L989D       :\ 9899= D0 02       P.
INC &A5         :\ 989B= E6 A5       f%
.L989D
JMP L98EE       :\ 989D= 4C EE 98    Ln.
 
.L98A0
LDA ADLC+1      :\ 98A0= AD A1 FE    -!~
.L98A3
BPL L98C3       :\ 98A3= 10 1E       ..
LDA ADLC+2      :\ 98A5= AD A2 FE    -"~
JSR L9A37       :\ 98A8= 20 37 9A     7.
BEQ L988E       :\ 98AB= F0 E1       pa
STA TUBEIO+5    :\ 98AD= 8D E5 FE    .e~
LDA ADLC+2      :\ 98B0= AD A2 FE    -"~
STA TUBEIO+5    :\ 98B3= 8D E5 FE    .e~
JSR L9A37       :\ 98B6= 20 37 9A     7.
BEQ L98C3       :\ 98B9= F0 08       p.
LDA ADLC+1      :\ 98BB= AD A1 FE    -!~
BNE L98A3       :\ 98BE= D0 E3       Pc
JMP &0D14       :\ 98C0= 4C 14 0D    L..
 
.L98C3
LDA #&00        :\ 98C3= A9 00       ).
STA ADLC+0      :\ 98C5= 8D A0 FE    . ~
LDA #&84        :\ 98C8= A9 84       ).
STA ADLC+1      :\ 98CA= 8D A1 FE    .!~
LDA #&02        :\ 98CD= A9 02       ).
BIT ADLC+1      :\ 98CF= 2C A1 FE    ,!~
BEQ L988E       :\ 98D2= F0 BA       p:
BPL L98EE       :\ 98D4= 10 18       ..
LDA &A2         :\ 98D6= A5 A2       %"
ORA &A3         :\ 98D8= 05 A3       .#
ORA &A4         :\ 98DA= 05 A4       .$
ORA &A5         :\ 98DC= 05 A5       .%
BEQ L988E       :\ 98DE= F0 AE       p.
LDA ADLC+2      :\ 98E0= AD A2 FE    -"~
STA &0D5D       :\ 98E3= 8D 5D 0D    .].
LDA #&20        :\ 98E6= A9 20       ) 
ORA &0D4A       :\ 98E8= 0D 4A 0D    .J.
STA &0D4A       :\ 98EB= 8D 4A 0D    .J.
.L98EE
LDA &0D4A       :\ 98EE= AD 4A 0D    -J.
BPL L98F9       :\ 98F1= 10 06       ..
JSR L994E       :\ 98F3= 20 4E 99     N.
JMP L9EA8       :\ 98F6= 4C A8 9E    L(.
 
.L98F9
LDA #&44        :\ 98F9= A9 44       )D
STA ADLC+0      :\ 98FB= 8D A0 FE    . ~
LDA #&A7        :\ 98FE= A9 A7       )'
STA ADLC+1      :\ 9900= 8D A1 FE    .!~
LDA #L9995 AND 255 :\ 9903= A9 95       ).
LDY #L9995 DIV 256 :\ 9905= A0 99        .
.L9907
STA &0D4B       :\ 9907= 8D 4B 0D    .K.
STY &0D4C       :\ 990A= 8C 4C 0D    .L.
LDA &0D3D       :\ 990D= AD 3D 0D    -=.
BIT ADLC+0      :\ 9910= 2C A0 FE    , ~
BVC L994B       :\ 9913= 50 36       P6
STA ADLC+2      :\ 9915= 8D A2 FE    ."~
LDA &0D3E       :\ 9918= AD 3E 0D    ->.
STA ADLC+2      :\ 991B= 8D A2 FE    ."~
LDA #L9925 AND 255 :\ 991E= A9 25       )%
LDY #L9925 DIV 256 :\ 9920= A0 99        .
JMP &0D0E       :\ 9922= 4C 0E 0D    L..

.L9925 
LDA INTOFF      :\ 9925= AD 18 FE    -.~
BIT ADLC+0      :\ 9928= 2C A0 FE    , ~
BVC L994B       :\ 992B= 50 1E       P.
STA ADLC+2      :\ 992D= 8D A2 FE    ."~
LDA #&00        :\ 9930= A9 00       ).
STA ADLC+2      :\ 9932= 8D A2 FE    ."~
LDA &0D4A       :\ 9935= AD 4A 0D    -J.
BMI L9948       :\ 9938= 30 0E       0.
LDA #&3F        :\ 993A= A9 3F       )?
STA ADLC+1      :\ 993C= 8D A1 FE    .!~
LDA &0D4B       :\ 993F= AD 4B 0D    -K.
LDY &0D4C       :\ 9942= AC 4C 0D    ,L.
JMP &0D0E       :\ 9945= 4C 0E 0D    L..
 
.L9948
JMP L9DB3       :\ 9948= 4C B3 9D    L3.
 
.L994B
JMP L9835       :\ 994B= 4C 35 98    L5.
 
.L994E
LDA #&02        :\ 994E= A9 02       ).
BIT &0D4A       :\ 9950= 2C 4A 0D    ,J.
BEQ L9994       :\ 9953= F0 3F       p?
CLC             :\ 9955= 18          .
PHP             :\ 9956= 08          .
LDY #&08        :\ 9957= A0 08        .
.L9959
LDA (&A6),Y     :\ 9959= B1 A6       1&
PLP             :\ 995B= 28          (
ADC &009A,Y     :\ 995C= 79 9A 00    y..
STA (&A6),Y     :\ 995F= 91 A6       .&
INY             :\ 9961= C8          H
PHP             :\ 9962= 08          .
CPY #&0C        :\ 9963= C0 0C       @.
BCC L9959       :\ 9965= 90 F2       .r
PLP             :\ 9967= 28          (
LDA #&20        :\ 9968= A9 20       ) 
BIT &0D4A       :\ 996A= 2C 4A 0D    ,J.
BEQ L9992       :\ 996D= F0 23       p#
TXA             :\ 996F= 8A          .
PHA             :\ 9970= 48          H
LDA #&08        :\ 9971= A9 08       ).
CLC             :\ 9973= 18          .
ADC &A6         :\ 9974= 65 A6       e&
TAX             :\ 9976= AA          *
LDY &A7         :\ 9977= A4 A7       $'
.L9979
LDA #&01        :\ 9979= A9 01       ).
JSR &0406       :\ 997B= 20 06 04     ..
LDA &0D5D       :\ 997E= AD 5D 0D    -].
STA TUBEIO+5    :\ 9981= 8D E5 FE    .e~
SEC             :\ 9984= 38          8
LDY #&08        :\ 9985= A0 08        .
.L9987
LDA #&00        :\ 9987= A9 00       ).
ADC (&A6),Y     :\ 9989= 71 A6       q&
STA (&A6),Y     :\ 998B= 91 A6       .&
INY             :\ 998D= C8          H
BCS L9987       :\ 998E= B0 F7       0w
PLA             :\ 9990= 68          h
TAX             :\ 9991= AA          *
.L9992
LDA #&FF        :\ 9992= A9 FF       ).
.L9994
RTS             :\ 9994= 60          `
 
.L9995
LDA &0D40       :\ 9995= AD 40 0D    -@.
.L9999
BNE L99A4       :\ 9998= D0 0A       P.
LDY &0D3F       :\ 999A= AC 3F 0D    ,?.
CPY #&82        :\ 999D= C0 82       @.
BEQ L99A4       :\ 999F= F0 03       p.
JMP L9AE7       :\ 99A1= 4C E7 9A    Lg.
 
.L99A4
JSR L994E       :\ 99A4= 20 4E 99     N.
BNE L99BB       :\ 99A7= D0 12       P.
LDA &A2         :\ 99A9= A5 A2       %"
CLC             :\ 99AB= 18          .
ADC &A4         :\ 99AC= 65 A4       e$
BCC L99B2       :\ 99AE= 90 02       ..
INC &A5         :\ 99B0= E6 A5       f%
.L99B2
LDY #&08        :\ 99B2= A0 08        .
STA (&A6),Y     :\ 99B4= 91 A6       .&
INY             :\ 99B6= C8          H
LDA &A5         :\ 99B7= A5 A5       %%
STA (&A6),Y     :\ 99B9= 91 A6       .&
.L99BB
LDA &0D40       :\ 99BB= AD 40 0D    -@.
BEQ L99DB       :\ 99BE= F0 1B       p.
LDA &0D3E       :\ 99C0= AD 3E 0D    ->.
LDY #&03        :\ 99C3= A0 03        .
STA (&A6),Y     :\ 99C5= 91 A6       .&
DEY             :\ 99C7= 88          .
LDA &0D3D       :\ 99C8= AD 3D 0D    -=.
STA (&A6),Y     :\ 99CB= 91 A6       .&
DEY             :\ 99CD= 88          .
LDA &0D40       :\ 99CE= AD 40 0D    -@.
STA (&A6),Y     :\ 99D1= 91 A6       .&
DEY             :\ 99D3= 88          .
LDA &0D3F       :\ 99D4= AD 3F 0D    -?.
ORA #&80        :\ 99D7= 09 80       ..
STA (&A6),Y     :\ 99D9= 91 A6       .&
.L99DB
LDA #&02        :\ 99DB= A9 02       ).
AND &0D67       :\ 99DD= 2D 67 0D    -g.
BIT &0D4A       :\ 99E0= 2C 4A 0D    ,J.
BEQ L99E8       :\ 99E3= F0 03       p.
JSR L9A2B       :\ 99E5= 20 2B 9A     +.

\ Immediate operation protected against
.L99E8
JSR L9F4C       :\ 99E8= 20 4C 9F     L.
.L99EB
LDA #L96BF AND 255 :\ 99EB= A9 BF       )?
LDY #L96BF DIV 256 :\ 99ED= A0 96        .
JMP &0D0E       :\ 99EF= 4C 0E 0D    L..
 
.L99F2
TXA             :\ 99F2= 8A          .
PHA             :\ 99F3= 48          H
LDX #&04        :\ 99F4= A2 04       ".
LDA #&02        :\ 99F6= A9 02       ).
.L99F8
BIT &0D4A       :\ 99F8= 2C 4A 0D    ,J.
BNE L9A19       :\ 99FB= D0 1C       P.
LDY &A2         :\ 99FD= A4 A2       $"
.L99FF
LDA &0D3D,X     :\ 99FF= BD 3D 0D    ==.
STA (&A4),Y     :\ 9A02= 91 A4       .$
INY             :\ 9A04= C8          H
BNE L9A0D       :\ 9A05= D0 06       P.
INC &A5         :\ 9A07= E6 A5       f%
DEC &A3         :\ 9A09= C6 A3       F#
BEQ L9A6E       :\ 9A0B= F0 61       pa
.L9A0D
INX             :\ 9A0D= E8          h
STY &A2         :\ 9A0E= 84 A2       ."
CPX #&0C        :\ 9A10= E0 0C       `.
BNE L99FF       :\ 9A12= D0 EB       Pk
.L9A14
PLA             :\ 9A14= 68          h
TAX             :\ 9A15= AA          *
JMP L99A4       :\ 9A16= 4C A4 99    L$.
 
.L9A19
LDA &0D3D,X     :\ 9A19= BD 3D 0D    ==.
STA TUBEIO+5    :\ 9A1C= 8D E5 FE    .e~
JSR L9A37       :\ 9A1F= 20 37 9A     7.
BEQ L9A70       :\ 9A22= F0 4C       pL
INX             :\ 9A24= E8          h
CPX #&0C        :\ 9A25= E0 0C       `.
BNE L9A19       :\ 9A27= D0 F0       Pp
BEQ L9A14       :\ 9A29= F0 E9       pi
.L9A2B
BIT &98         :\ 9A2B= 24 98       $.
BMI L9A34       :\ 9A2D= 30 05       0.
LDA #&82        :\ 9A2F= A9 82       ).
JSR &0406       :\ 9A31= 20 06 04     ..
.L9A34
LSR &98         :\ 9A34= 46 98       F.
RTS             :\ 9A36= 60          `
 
.L9A37
INC &A2         :\ 9A37= E6 A2       f"
BNE L9A45       :\ 9A39= D0 0A       P.
INC &A3         :\ 9A3B= E6 A3       f#
BNE L9A45       :\ 9A3D= D0 06       P.
INC &A4         :\ 9A3F= E6 A4       f$
BNE L9A45       :\ 9A41= D0 02       P.
INC &A5         :\ 9A43= E6 A5       f%
.L9A45
RTS             :\ 9A45= 60          `


\ =================== 
\ Immediate Operation
\ =================== 
.L9A46
LDY &0D3F                :\ Get control byte - immediate operation
CPY #&81:BCC L9A76
CPY #&89:BCS L9A76       :\ Out of range, jump to exit
CPY #&87:BCS L9A63       :\ Continue and MachineType, skip protection checking
TYA:SEC:SBC #&81:TAY     :\ Y=0..6
LDA &0D63                :\ Get protection mask
.L9A5D
ROR A:DEY:BPL L9A5D      :\ Rotate protection mask through to carry
BCS L99E8                :\ Operation protected against, jump to ignore
.L9A63
LDY &0D3F                :\ Get control byte again
LDA #L9A81 DIV 256:PHA   :\ Push high byte of dispatch address
LDA L9A79-&81,Y:PHA:RTS  :\ Push low byte of address and jump to it
 
.L9A6E
INC &A2         :\ 9A6E= E6 A2       f"
.L9A70
CPX #&0B        :\ 9A70= E0 0B       `.
BEQ L9A14       :\ 9A72= F0 A0       p 
PLA             :\ 9A74= 68          h
TAX             :\ 9A75= AA          *

\ Immediate operation out of range
.L9A76
JMP L9835       :\ 9A76= 4C 35 98    L5.

\ Immediate operation dispatch table
\ ---------------------------------- 
.L9A79
EQUB (L9ABC-1) AND 255  :\ Immediate &81 - Peek
EQUB (L9A9F-1) AND 255  :\ Immediate &82 - Poke
EQUB (L9A81-1) AND 255  :\ Immediate &83 - RemoteJSR
EQUB (L9A81-1) AND 255  :\ Immediate &84 - RemotePROC
EQUB (L9A81-1) AND 255  :\ Immediate &85 - RemoteOSPROC
EQUB (L9AD6-1) AND 255  :\ Immediate &86 - Halt
EQUB (L9AD6-1) AND 255  :\ Immediate &87 - Continue
EQUB (L9AAA-1) AND 255  :\ Immediate &88 - MachinePeek

\ Immediate &83, &84, &85 - RemoteJSR, RemotePROC, RemoteOSPROC
\ -------------------------------------------------------------
.L9A81
LDA #&00:STA &A4
LDA #&82:STA &A2
LDA #&01:STA &A3
LDA &9D:STA &A5
LDY #&03
.L9A93
LDA &0D41,Y:STA &0D58,Y :\ Save &0D41-&0D44
DEY:BPL L9A93
JMP L97CB
 
\ Immediate &82 - Poke
\ --------------------
.L9A9F
LDA #&3D:STA &A6
LDA #&0D:STA &A7
JMP L97B9

\ Immediate &88 - MachinePeek
\ ---------------------------
.L9AAA 
LDA #&01:STA &A3   :\ Length=&01FC
LDA #&FC:STA &A2
LDA #(L8021-&FC) AND 255:STA &A4 :\ Address=&7F25
LDA #(L8021-&FC) DIV 256:STA &A5 :\ &7F25+&FC=L8021 -> machine info block
BNE L9ACE

\ Immediate &81 - Peek
\ --------------------
.L9ABC
LDA #&3D:STA &A6
LDA #&0D:STA &A7
LDA #&02:STA &0D5C
JSR L9ECA:BCC L9B1D
.L9ACE
LDA &0D4A:ORA #&80:STA &0D4A

\ Immediate &86, &87 - Halt, Continue
\ -----------------------------------
.L9AD6
LDA #&44:STA ADLC+0
LDA #&A7:STA ADLC+1
LDA #L9AFD AND 255
LDY #L9AFD DIV 256
JMP L9907
 
.L9AE7
LDA &A2         :\ 9AE7= A5 A2       %"
CLC             :\ 9AE9= 18          .
ADC #&80        :\ 9AEA= 69 80       i.
LDY #&7F        :\ 9AEC= A0 7F        .
STA (&9C),Y     :\ 9AEE= 91 9C       ..
LDY #&80        :\ 9AF0= A0 80        .
LDA &0D3D       :\ 9AF2= AD 3D 0D    -=.
STA (&9C),Y     :\ 9AF5= 91 9C       ..
INY             :\ 9AF7= C8          H
LDA &0D3E       :\ 9AF8= AD 3E 0D    ->.
STA (&9C),Y     :\ 9AFB= 91 9C       ..
.L9AFD
LDA &0D3F       :\ 9AFD= AD 3F 0D    -?.
STA &0D57       :\ 9B00= 8D 57 0D    .W.
LDA #&84        :\ 9B03= A9 84       ).
STA SYSVIA+&E   :\ 9B05= 8D 4E FE    .N~
LDA SYSVIA+&B   :\ 9B08= AD 4B FE    -K~
AND #&1C        :\ 9B0B= 29 1C       ).
STA &0D51       :\ 9B0D= 8D 51 0D    .Q.
LDA SYSVIA+&B   :\ 9B10= AD 4B FE    -K~
AND #&E3        :\ 9B13= 29 E3       )c
ORA #&08        :\ 9B15= 09 08       ..
STA SYSVIA+&B   :\ 9B17= 8D 4B FE    .K~
BIT SYSVIA+&A   :\ 9B1A= 2C 4A FE    ,J~
.L9B1D
JMP L99E8       :\ 9B1D= 4C E8 99    Lh.

\ Low byte of dispatch addresses of immediate IRQs
\ ------------------------------------------------ 
.L9B20
EQUB (L9B25-1) AND 255     :\ Immediate &83 - RemoteJSR
EQUB (L9B2E-1) AND 255     :\ Immediate &84 - RemoteUser
EQUB (L9B3C-1) AND 255     :\ Immediate &85 - RemoteOS
EQUB (L9B48-1) AND 255     :\ Immediate &86 - Halt
EQUB (L9B5F-1) AND 255     :\ Immediate &87 - Continue

\ RemoteJSR
\ ---------
.L9B25
LDA #(L9B67-1) DIV 256:PHA :\ Stack return address
LDA #(L9B67-1) AND 255:PHA
JMP (&0D58)                :\ Jump to passed address

\ RemoteUser
\ ----------
.L9B2E
LDY #&08                   :\ Event 8 - Econet Event
LDX &0D58:LDA &0D59        :\ AX=parameter
JSR &FFBF:JMP L9B67        :\ Generate an event, then return

\ RemoteOS
\ --------
.L9B3C
LDX &0D58:LDY &0D59        :\ Get parameters
JSR L8000:JMP L9B67        :\ Call to process RemoteOS call, jump to return

\ Halt
\ ----
.L9B48
LDA #&04
BIT &0D64:BNE L9B67        :\ Already halted, exit
ORA &0D64:STA &0D64        :\ Set 'halted' flag
LDA #&04:CLI               :\ Allow IRQs to get in
.L9B58
BIT &0D64:BNE L9B58        :\ Loop until somebody turns 'Halt' flag off
BEQ L9B67                  :\ Jump to finish

\ Continue
\ --------
.L9B5F
LDA &0D64:AND #&FB:STA &0D64 :\ Clear the 'Halt' flag
.L9B67
PLA:TAY:PLA:TAX            :\ Restore registers
LDA #&00:RTS               :\ Claim call and return

.L9B6E
TXA             :\ 9B6E= 8A          .
PHA             :\ 9B6F= 48          H
LDY #&02        :\ 9B70= A0 02        .
LDA (&A0),Y     :\ 9B72= B1 A0       1 
STA &0D20       :\ 9B74= 8D 20 0D    . .
INY             :\ 9B77= C8          H
LDA (&A0),Y     :\ 9B78= B1 A0       1 
STA &0D21       :\ 9B7A= 8D 21 0D    .!.
LDY #&00        :\ 9B7D= A0 00        .
LDA (&A0),Y     :\ 9B7F= B1 A0       1 
BMI L9B86       :\ 9B81= 30 03       0.
JMP L9C11       :\ 9B83= 4C 11 9C    L..
 
.L9B86
STA &0D24       :\ 9B86= 8D 24 0D    .$.
TAX             :\ 9B89= AA          *
INY             :\ 9B8A= C8          H
LDA (&A0),Y     :\ 9B8B= B1 A0       1 
STA &0D25       :\ 9B8D= 8D 25 0D    .%.
BNE L9BC5       :\ 9B90= D0 33       P3
CPX #&83        :\ 9B92= E0 83       `.
BCS L9BB1       :\ 9B94= B0 1B       0.
SEC             :\ 9B96= 38          8
PHP             :\ 9B97= 08          .
LDY #&08        :\ 9B98= A0 08        .
.L9B9A
LDA (&A0),Y     :\ 9B9A= B1 A0       1 
DEY             :\ 9B9C= 88          .
DEY             :\ 9B9D= 88          .
DEY             :\ 9B9E= 88          .
DEY             :\ 9B9F= 88          .
PLP             :\ 9BA0= 28          (
SBC (&A0),Y     :\ 9BA1= F1 A0       q 
STA &0D26,Y     :\ 9BA3= 99 26 0D    .&.
INY             :\ 9BA6= C8          H
INY             :\ 9BA7= C8          H
INY             :\ 9BA8= C8          H
INY             :\ 9BA9= C8          H
INY             :\ 9BAA= C8          H
PHP             :\ 9BAB= 08          .
CPY #&0C        :\ 9BAC= C0 0C       @.
BCC L9B9A       :\ 9BAE= 90 EA       .j
PLP             :\ 9BB0= 28          (
.L9BB1
CPX #&81        :\ 9BB1= E0 81       `.
BCC L9C11       :\ 9BB3= 90 5C       .\
CPX #&89        :\ 9BB5= E0 89       `.
BCS L9C11       :\ 9BB7= B0 58       0X
LDY #&0C        :\ 9BB9= A0 0C        .
.L9BBB
LDA (&A0),Y     :\ 9BBB= B1 A0       1 
STA &0D1A,Y     :\ 9BBD= 99 1A 0D    ...
INY             :\ 9BC0= C8          H
CPY #&10        :\ 9BC1= C0 10       @.
BCC L9BBB       :\ 9BC3= 90 F6       .v
.L9BC5
LDA #&20        :\ 9BC5= A9 20       ) 
BIT ADLC+1      :\ 9BC7= 2C A1 FE    ,!~
BNE L9C21       :\ 9BCA= D0 55       PU
LDA #&FD        :\ 9BCC= A9 FD       )}
PHA             :\ 9BCE= 48          H
LDA #&06        :\ 9BCF= A9 06       ).
STA &0D50       :\ 9BD1= 8D 50 0D    .P.
LDA #&00        :\ 9BD4= A9 00       ).
STA &0D4F       :\ 9BD6= 8D 4F 0D    .O.
PHA             :\ 9BD9= 48          H
PHA             :\ 9BDA= 48          H
LDY #&E7        :\ 9BDB= A0 E7        g
.L9BDD
IF VERSION<&0365
 LDA #&04       :\ 9BDD= A9 04       ).
 PHP            :\ 9BDF= 08          .
 SEI            :\ 9BE0= 78          x
 .L9BE1
 BIT INTOFF     :\ Disable ADLC NMIs
 BIT INTOFF     :\ Do it twice in case one squeezed through
ELSE
 PHP            :\ 9BDF= 08          .
 SEI            :\ 9BE0= 78          x
 LDA #&40
 STA &0D1C      :\ Remove re-enable code in NMI routine
 .L9BE1
 BIT INTOFF     :\ Disable ADLC NMIs
 LDA #&04
ENDIF
BIT ADLC+1      :\ 9BE7= 2C A1 FE    ,!~
BEQ L9BFB       :\ 9BEA= F0 0F       p.
LDA ADLC+0      :\ 9BEC= AD A0 FE    - ~
LDA #&67        :\ 9BEF= A9 67       )g
STA ADLC+1      :\ 9BF1= 8D A1 FE    .!~
LDA #&10        :\ 9BF4= A9 10       ).
BIT ADLC+0      :\ 9BF6= 2C A0 FE    , ~
BNE L9C2F       :\ 9BF9= D0 34       P4
.L9BFB
IF VERSION>=&0365
 LDA #&2C       :\ Restore re-enable code
 STA &0D1C
ENDIF
BIT INTON       :\ 9BFB= 2C 20 FE    , ~
PLP             :\ 9BFE= 28          (
TSX             :\ 9BFF= BA          :
INC &0101,X     :\ 9C00= FE 01 01    ~..
BNE L9BDD       :\ 9C03= D0 D8       PX
INC &0102,X     :\ 9C05= FE 02 01    ~..
BNE L9BDD       :\ 9C08= D0 D3       PS
INC &0103,X     :\ 9C0A= FE 03 01    ~..
BNE L9BDD       :\ 9C0D= D0 CE       PN
BEQ L9C15       :\ 9C0F= F0 04       p.
.L9C11
LDA #&44        :\ 9C11= A9 44       )D
BNE L9C23       :\ 9C13= D0 0E       P.
.L9C15
LDA #&07        :\ 9C15= A9 07       ).
STA ADLC+1      :\ 9C17= 8D A1 FE    .!~
PLA             :\ 9C1A= 68          h
PLA             :\ 9C1B= 68          h
PLA             :\ 9C1C= 68          h
LDA #&40        :\ 9C1D= A9 40       )@
BNE L9C23       :\ 9C1F= D0 02       P.
.L9C21
LDA #&43        :\ 9C21= A9 43       )C
.L9C23
LDY #&00        :\ 9C23= A0 00        .
STA (&A0),Y     :\ 9C25= 91 A0       . 
LDA #&80        :\ 9C27= A9 80       ).
STA &0D62       :\ 9C29= 8D 62 0D    .b.
PLA             :\ 9C2C= 68          h
TAX             :\ 9C2D= AA          *
RTS             :\ 9C2E= 60          `
 
.L9C2F
IF VERSION>=&0365
 LDX #&C0
 STX ADLC+0
ENDIF
STY ADLC+1      :\ 9C2F= 8C A1 FE    .!~
LDX #&44        :\ 9C32= A2 44       "D
STX ADLC+0      :\ 9C34= 8E A0 FE    . ~
LDX #L9CCC AND 255 :\ 9C37= A2 CC       "L
LDY #L9CCC DIV 256 :\ 9C39= A0 9C        .
STX &0D0C       :\ 9C3B= 8E 0C 0D    ...
STY &0D0D       :\ 9C3E= 8C 0D 0D    ...
SEC             :\ 9C41= 38          8
ROR &98         :\ 9C42= 66 98       f.
IF VERSION>=&0365
 LDA #&2C
 STA &0D1C
ENDIF
BIT INTON       :\ 9C44= 2C 20 FE    , ~
LDA &0D25       :\ 9C47= AD 25 0D    -%.
BNE L9C8E       :\ 9C4A= D0 42       PB
LDY &0D24       :\ 9C4C= AC 24 0D    ,$.
LDA L9EC2-&81,Y :\ 9C4F= B9 41 9E    9A.
STA &0D4A       :\ 9C52= 8D 4A 0D    .J.
LDA L9EBA-&81,Y :\ 9C55= B9 39 9E    99.
STA &0D50       :\ 9C58= 8D 50 0D    .P.
LDA #L9C63 DIV 256 :\ 9C5B= A9 9C       ).
PHA                :\ 9C5D= 48          H
LDA L9C63-&81,Y    :\ 9C5E= B9 E2 9B    9b.
PHA                :\ 9C61= 48          H
RTS                :\ 9C62= 60          `
 
.L9C63
EQUB (L9C6F-1) AND 255 :\ &81 PEEK
EQUB (L9C73-1) AND 255 :\ &82 POKE
EQUB (L9CB5-1) AND 255 :\ &83 
EQUB (L9CB5-1) AND 255 :\ &84 
EQUB (L9CB5-1) AND 255 :\ &85 HALT
EQUB (L9CC5-1) AND 255 :\ &87 CONT
EQUB (L9CC5-1) AND 255 :\ &88 PING
EQUB (L9C6B-1) AND 255 :\ &89 

.L9C6B
LDA #&03        :\ 9C6B= A9 03       ).
BNE L9CB7       :\ 9C6D= D0 48       PH
.L9C6F
LDA #&03        :\ 9C6F= A9 03       ).
BNE L9C75       :\ 9C71= D0 02       P.
.L9C73
LDA #&02        :\ 9C73= A9 02       ).
.L9C75
STA &0D5C       :\ 9C75= 8D 5C 0D    .\.
CLC             :\ 9C78= 18          .
PHP             :\ 9C79= 08          .
LDY #&0C        :\ 9C7A= A0 0C        .
.L9C7C
LDA &0D1E,Y     :\ 9C7C= B9 1E 0D    9..
PLP             :\ 9C7F= 28          (
ADC (&A0),Y     :\ 9C80= 71 A0       q 
STA &0D1E,Y     :\ 9C82= 99 1E 0D    ...
INY             :\ 9C85= C8          H
PHP             :\ 9C86= 08          .
CPY #&10        :\ 9C87= C0 10       @.
BCC L9C7C       :\ 9C89= 90 F1       .q
PLP             :\ 9C8B= 28          (
BNE L9CBA       :\ 9C8C= D0 2C       P,
.L9C8E
LDA &0D20       :\ 9C8E= AD 20 0D    - .
AND &0D21       :\ 9C91= 2D 21 0D    -!.
CMP #&FF        :\ 9C94= C9 FF       I.
BNE L9CB0       :\ 9C96= D0 18       P.
LDA #&0E        :\ 9C98= A9 0E       ).
STA &0D50       :\ 9C9A= 8D 50 0D    .P.
LDA #&40        :\ 9C9D= A9 40       )@
STA &0D4A       :\ 9C9F= 8D 4A 0D    .J.
LDY #&04        :\ 9CA2= A0 04        .
.L9CA4
LDA (&A0),Y     :\ 9CA4= B1 A0       1 
STA &0D22,Y     :\ 9CA6= 99 22 0D    .".
INY             :\ 9CA9= C8          H
CPY #&0C        :\ 9CAA= C0 0C       @.
BCC L9CA4       :\ 9CAC= 90 F6       .v
BCS L9CC5       :\ 9CAE= B0 15       0.
.L9CB0
LDA #&00        :\ 9CB0= A9 00       ).
STA &0D4A       :\ 9CB2= 8D 4A 0D    .J.
.L9CB5
LDA #&02        :\ 9CB5= A9 02       ).
.L9CB7
STA &0D5C       :\ 9CB7= 8D 5C 0D    .\.
.L9CBA
LDA &A0         :\ 9CBA= A5 A0       % 
STA &A6         :\ 9CBC= 85 A6       .&
LDA &A1         :\ 9CBE= A5 A1       %!
STA &A7         :\ 9CC0= 85 A7       .'
JSR L9ECA       :\ 9CC2= 20 CA 9E     J.
.L9CC5
PLP             :\ 9CC5= 28          (
PLA             :\ 9CC6= 68          h
PLA             :\ 9CC7= 68          h
PLA             :\ 9CC8= 68          h
PLA             :\ 9CC9= 68          h
TAX             :\ 9CCA= AA          *
RTS             :\ 9CCB= 60          `
 
.L9CCC
LDY &0D4F       :\ 9CCC= AC 4F 0D    ,O.
BIT ADLC+0      :\ 9CCF= 2C A0 FE    , ~
.L9CD2
BVC L9CF6       :\ 9CD2= 50 22       P"
LDA &0D20,Y     :\ 9CD4= B9 20 0D    9 .
STA ADLC+2      :\ 9CD7= 8D A2 FE    ."~
INY             :\ 9CDA= C8          H
LDA &0D20,Y     :\ 9CDB= B9 20 0D    9 .
INY             :\ 9CDE= C8          H
STY &0D4F       :\ 9CDF= 8C 4F 0D    .O.
STA ADLC+2      :\ 9CE2= 8D A2 FE    ."~
CPY &0D50       :\ 9CE5= CC 50 0D    LP.
BCS L9D08       :\ 9CE8= B0 1E       0.
BIT ADLC+0      :\ 9CEA= 2C A0 FE    , ~
BMI L9CD2       :\ 9CED= 30 E3       0c
JMP &0D14       :\ 9CEF= 4C 14 0D    L..
 
.L9CF2
LDA #&42        :\ 9CF2= A9 42       )B
BNE L9CFD       :\ 9CF4= D0 07       P.
.L9CF6
LDA #&67        :\ 9CF6= A9 67       )g
STA ADLC+1      :\ 9CF8= 8D A1 FE    .!~
LDA #&41        :\ 9CFB= A9 41       )A
.L9CFD
LDY INTOFF      :\ 9CFD= AC 18 FE    ,.~
.L9D00
PHA             :\ 9D00= 48          H
PLA             :\ 9D01= 68          h
INY             :\ 9D02= C8          H
BNE L9D00       :\ 9D03= D0 FB       P{
JMP L9EAE       :\ 9D05= 4C AE 9E    L..
 
.L9D08
LDA #&3F        :\ 9D08= A9 3F       )?
STA ADLC+1      :\ 9D0A= 8D A1 FE    .!~
LDA #L9D14 AND 255 :\ 9D0D= A9 14       ).
LDY #L9D14 DIV 256 :\ 9D0F= A0 9D        .
JMP &0D0E       :\ 9D11= 4C 0E 0D    L..
 
.L9D14
LDA #&82        :\ 9D14= A9 82       ).
STA ADLC+0      :\ 9D16= 8D A0 FE    . ~
BIT &0D4A       :\ 9D19= 2C 4A 0D    ,J.
BVC L9D21       :\ 9D1C= 50 03       P.
JMP L9EA8       :\ 9D1E= 4C A8 9E    L(.
 
.L9D21
LDA #&01        :\ 9D21= A9 01       ).
BIT &0D4A       :\ 9D23= 2C 4A 0D    ,J.
BEQ L9D2B       :\ 9D26= F0 03       p.
JMP L9E50       :\ 9D28= 4C 50 9E    LP.
 
.L9D2B
LDA #L9D30 AND 255 :\ 9D2B= A9 30       )0
JMP &0D11       :\ 9D2D= 4C 11 0D    L..
 
.L9D30
LDA #&01        :\ 9D30= A9 01       ).
BIT ADLC+1      :\ 9D32= 2C A1 FE    ,!~
BEQ L9CF2       :\ 9D35= F0 BB       p;
LDA ADLC+2      :\ 9D37= AD A2 FE    -"~
CMP INTOFF      :\ 9D3A= CD 18 FE    M.~
BNE L9D58       :\ 9D3D= D0 19       P.
LDA #L9D44 AND 255 :\ 9D3F= A9 44       )D
JMP &0D11       :\ 9D41= 4C 11 0D    L..
 
.L9D44
BIT ADLC+1      :\ 9D44= 2C A1 FE    ,!~
BPL L9D58       :\ 9D47= 10 0F       ..
LDA ADLC+2      :\ 9D49= AD A2 FE    -"~
BNE L9D58       :\ 9D4C= D0 0A       P.
LDA #L9D5B AND 255 :\ 9D4E= A9 5B       )[
BIT ADLC+0      :\ 9D50= 2C A0 FE    , ~
BMI L9D5B       :\ 9D53= 30 06       0.
JMP &0D11       :\ 9D55= 4C 11 0D    L..
 
.L9D58
JMP L9EAC       :\ 9D58= 4C AC 9E    L,.
 
.L9D5B
BIT ADLC+1      :\ 9D5B= 2C A1 FE    ,!~
BPL L9D58       :\ 9D5E= 10 F8       .x
LDA ADLC+2      :\ 9D60= AD A2 FE    -"~
CMP &0D20       :\ 9D63= CD 20 0D    M .
BNE L9D58       :\ 9D66= D0 F0       Pp
LDA ADLC+2      :\ 9D68= AD A2 FE    -"~
CMP &0D21       :\ 9D6B= CD 21 0D    M!.
BNE L9D58       :\ 9D6E= D0 E8       Ph
LDA #&02        :\ 9D70= A9 02       ).
BIT ADLC+1      :\ 9D72= 2C A1 FE    ,!~
BEQ L9D58       :\ 9D75= F0 E1       pa
LDA #&A7        :\ 9D77= A9 A7       )'
STA ADLC+1      :\ 9D79= 8D A1 FE    .!~
LDA #&44        :\ 9D7C= A9 44       )D
STA ADLC+0      :\ 9D7E= 8D A0 FE    . ~
LDA #L9E50 AND 255 :\ 9D81= A9 50       )P
LDY #L9E50 DIV 256 :\ 9D83= A0 9E        .
STA &0D4B       :\ 9D85= 8D 4B 0D    .K.
STY &0D4C       :\ 9D88= 8C 4C 0D    .L.
LDA &0D20       :\ 9D8B= AD 20 0D    - .
BIT ADLC+0      :\ 9D8E= 2C A0 FE    , ~
BVC L9DCD       :\ 9D91= 50 3A       P:
STA ADLC+2      :\ 9D93= 8D A2 FE    ."~
LDA &0D21       :\ 9D96= AD 21 0D    -!.
STA ADLC+2      :\ 9D99= 8D A2 FE    ."~
LDA #L9DA3 AND 255 :\ 9D9C= A9 A3       )#
LDY #L9DA3 DIV 256 :\ 9D9E= A0 9D        .
JMP &0D0E       :\ 9DA0= 4C 0E 0D    L..
 
.L9DA3
LDA INTOFF      :\ 9DA3= AD 18 FE    -.~
BIT ADLC+0      :\ 9DA6= 2C A0 FE    , ~
BVC L9DCD       :\ 9DA9= 50 22       P"
STA ADLC+2      :\ 9DAB= 8D A2 FE    ."~
LDA #&00        :\ 9DAE= A9 00       ).
STA ADLC+2      :\ 9DB0= 8D A2 FE    ."~
.L9DB3
LDA #&02        :\ 9DB3= A9 02       ).
BIT &0D4A       :\ 9DB5= 2C 4A 0D    ,J.
BNE L9DC1       :\ 9DB8= D0 07       P.
LDA #L9DC8 AND 255 :\ 9DBA= A9 C8       )H
LDY #L9DC8 DIV 256 :\ 9DBC= A0 9D        .
JMP &0D0E       :\ 9DBE= 4C 0E 0D    L..
 
.L9DC1
LDA #L9E0F AND 255 :\ 9DC1= A9 0F       ).
LDY #L9E0F DIV 256 :\ 9DC3= A0 9E        .
JMP &0D0E       :\ 9DC5= 4C 0E 0D    L..
 
.L9DC8
LDY &A2         :\ 9DC8= A4 A2       $"
BIT ADLC+0      :\ 9DCA= 2C A0 FE    , ~
.L9DCD
BVC L9E48       :\ 9DCD= 50 79       Py
LDA (&A4),Y     :\ 9DCF= B1 A4       1$
STA ADLC+2      :\ 9DD1= 8D A2 FE    ."~
INY             :\ 9DD4= C8          H
BNE L9DDD       :\ 9DD5= D0 06       P.
DEC &A3         :\ 9DD7= C6 A3       F#
BEQ L9DF5       :\ 9DD9= F0 1A       p.
INC &A5         :\ 9DDB= E6 A5       f%
.L9DDD
LDA (&A4),Y     :\ 9DDD= B1 A4       1$
STA ADLC+2      :\ 9DDF= 8D A2 FE    ."~
INY             :\ 9DE2= C8          H
STY &A2         :\ 9DE3= 84 A2       ."
BNE L9DED       :\ 9DE5= D0 06       P.
DEC &A3         :\ 9DE7= C6 A3       F#
BEQ L9DF5       :\ 9DE9= F0 0A       p.
INC &A5         :\ 9DEB= E6 A5       f%
.L9DED
BIT ADLC+0      :\ 9DED= 2C A0 FE    , ~
BMI L9DCD       :\ 9DF0= 30 DB       0[
JMP &0D14       :\ 9DF2= 4C 14 0D    L..
 
.L9DF5
LDA #&3F        :\ 9DF5= A9 3F       )?
STA ADLC+1      :\ 9DF7= 8D A1 FE    .!~
LDA &0D4A       :\ 9DFA= AD 4A 0D    -J.
BPL L9E06       :\ 9DFD= 10 07       ..
LDA #L99DB AND 255 :\ 9DFF= A9 DB       )[
LDY #L99DB DIV 256 :\ 9E01= A0 99        .
JMP &0D0E       :\ 9E03= 4C 0E 0D    L..
 
.L9E06
LDA &0D4B       :\ 9E06= AD 4B 0D    -K.
LDY &0D4C       :\ 9E09= AC 4C 0D    ,L.
JMP &0D0E       :\ 9E0C= 4C 0E 0D    L..

.L9E0F
BIT ADLC+0      :\ 9E0F= 2C A0 FE    , ~
.L9E12
BVC L9E48       :\ 9E12= 50 34       P4
LDA TUBEIO+5    :\ 9E14= AD E5 FE    -e~
STA ADLC+2      :\ 9E17= 8D A2 FE    ."~
INC &A2         :\ 9E1A= E6 A2       f"
BNE L9E2A       :\ 9E1C= D0 0C       P.
INC &A3         :\ 9E1E= E6 A3       f#
BNE L9E2A       :\ 9E20= D0 08       P.
INC &A4         :\ 9E22= E6 A4       f$
BNE L9E2A       :\ 9E24= D0 04       P.
INC &A5         :\ 9E26= E6 A5       f%
BEQ L9DF5       :\ 9E28= F0 CB       pK
.L9E2A
LDA TUBEIO+5    :\ 9E2A= AD E5 FE    -e~
STA ADLC+2      :\ 9E2D= 8D A2 FE    ."~
INC &A2         :\ 9E30= E6 A2       f"
BNE L9E40       :\ 9E32= D0 0C       P.
INC &A3         :\ 9E34= E6 A3       f#
BNE L9E40       :\ 9E36= D0 08       P.
.L9E38
INC &A4         :\ 9E38= E6 A4       f$
BNE L9E40       :\ 9E3A= D0 04       P.
INC &A5         :\ 9E3C= E6 A5       f%
BEQ L9DF5       :\ 9E3E= F0 B5       p5
.L9E40
BIT ADLC+0      :\ 9E40= 2C A0 FE    , ~
BMI L9E12       :\ 9E43= 30 CD       0M
JMP &0D14       :\ 9E45= 4C 14 0D    L..
 
.L9E48
LDA &0D4A       :\ 9E48= AD 4A 0D    -J.
BPL L9EAC       :\ 9E4B= 10 5F       ._
JMP L99DB       :\ 9E4D= 4C DB 99    L[.
 
.L9E50
LDA #&82        :\ 9E50= A9 82       ).
STA ADLC+0      :\ 9E52= 8D A0 FE    . ~
LDA #L9E5C AND 255 :\ 9E55= A9 5C       )\
LDY #L9E5C DIV 256 :\ 9E57= A0 9E        .
JMP &0D0E       :\ 9E59= 4C 0E 0D    L..
 
.L9E5C
LDA #&01        :\ 9E5C= A9 01       ).
BIT ADLC+1      :\ 9E5E= 2C A1 FE    ,!~
BEQ L9EAC       :\ 9E61= F0 49       pI
LDA ADLC+2      :\ 9E63= AD A2 FE    -"~
CMP INTOFF      :\ 9E66= CD 18 FE    M.~
BNE L9EAC       :\ 9E69= D0 41       PA
LDA #L9E70 AND 255 :\ 9E6B= A9 70       )p
JMP &0D11       :\ 9E6D= 4C 11 0D    L..
 
.L9E70
BIT ADLC+1      :\ 9E70= 2C A1 FE    ,!~
BPL L9EAC       :\ 9E73= 10 37       .7
LDA ADLC+2      :\ 9E75= AD A2 FE    -"~
BNE L9EAC       :\ 9E78= D0 32       P2
LDA #L9E84 AND 255 :\ 9E7A= A9 84       ).
BIT ADLC+0      :\ 9E7C= 2C A0 FE    , ~
BMI L9E84       :\ 9E7F= 30 03       0.
JMP &0D11       :\ 9E81= 4C 11 0D    L..
 
.L9E84
BIT ADLC+1      :\ 9E84= 2C A1 FE    ,!~
BPL L9EAC       :\ 9E87= 10 23       .#
LDA ADLC+2      :\ 9E89= AD A2 FE    -"~
CMP &0D20       :\ 9E8C= CD 20 0D    M .
BNE L9EAC       :\ 9E8F= D0 1B       P.
LDA ADLC+2      :\ 9E91= AD A2 FE    -"~
CMP &0D21       :\ 9E94= CD 21 0D    M!.
BNE L9EAC       :\ 9E97= D0 13       P.
LDA &0D4A       :\ 9E99= AD 4A 0D    -J.
BPL L9EA1       :\ 9E9C= 10 03       ..
JMP L981B       :\ 9E9E= 4C 1B 98    L..
 
.L9EA1
LDA #&02        :\ 9EA1= A9 02       ).
BIT ADLC+1      :\ 9EA3= 2C A1 FE    ,!~
BEQ L9EAC       :\ 9EA6= F0 04       p.
.L9EA8
LDA #&00        :\ 9EA8= A9 00       ).
BEQ L9EAE       :\ 9EAA= F0 02       p.
.L9EAC
LDA #&41        :\ 9EAC= A9 41       )A
.L9EAE
LDY #&00        :\ 9EAE= A0 00        .
STA (&A0),Y     :\ 9EB0= 91 A0       . 
LDA #&80        :\ 9EB2= A9 80       ).
STA &0D62       :\ 9EB4= 8D 62 0D    .b.
JMP L99DB       :\ 9EB7= 4C DB 99    L[.
 
.L9EBA
ASL &0A0E       :\ 9EBA= 0E 0E 0A    ...
ASL A           :\ 9EBD= 0A          .
ASL A           :\ 9EBE= 0A          .
ASL &06         :\ 9EBF= 06 06       ..
ASL A           :\ 9EC1= 0A          .
.L9EC2
STA (&00,X)     :\ 9EC2= 81 00       ..
BRK             :\ 9EC4= 00          .
BRK             :\ 9EC5= 00          .
BRK             :\ 9EC6= 00          .
ORA (&01,X)     :\ 9EC7= 01 01       ..
EQUB &81        :\ 9EC9= 81 A0       . 

.L9ECA
EQUB &A0
ASL &B1         :\ 9ECB= 06 B1       .1
LDX &C8         :\ 9ECD= A6 C8       &H
AND (&A6),Y     :\ 9ECF= 31 A6       1&
CMP #&FF        :\ 9ED1= C9 FF       I.
BEQ L9F19       :\ 9ED3= F0 44       pD
LDA &0D67       :\ 9ED5= AD 67 0D    -g.
BEQ L9F19       :\ 9ED8= F0 3F       p?
LDA &0D4A       :\ 9EDA= AD 4A 0D    -J.
ORA #&02        :\ 9EDD= 09 02       ..
STA &0D4A       :\ 9EDF= 8D 4A 0D    .J.
SEC             :\ 9EE2= 38          8
PHP             :\ 9EE3= 08          .
LDY #&04        :\ 9EE4= A0 04        .
.L9EE6
LDA (&A6),Y     :\ 9EE6= B1 A6       1&
INY             :\ 9EE8= C8          H
INY             :\ 9EE9= C8          H
INY             :\ 9EEA= C8          H
INY             :\ 9EEB= C8          H
PLP             :\ 9EEC= 28          (
SBC (&A6),Y     :\ 9EED= F1 A6       q&
STA &009A,Y     :\ 9EEF= 99 9A 00    ...
DEY             :\ 9EF2= 88          .
DEY             :\ 9EF3= 88          .
DEY             :\ 9EF4= 88          .
PHP             :\ 9EF5= 08          .
CPY #&08        :\ 9EF6= C0 08       @.
BCC L9EE6       :\ 9EF8= 90 EC       .l
PLP             :\ 9EFA= 28          (
TXA             :\ 9EFB= 8A          .
PHA             :\ 9EFC= 48          H
LDA #&04        :\ 9EFD= A9 04       ).
CLC             :\ 9EFF= 18          .
ADC &A6         :\ 9F00= 65 A6       e&
TAX             :\ 9F02= AA          *
LDY &A7         :\ 9F03= A4 A7       $'
LDA #&C2        :\ 9F05= A9 C2       )B
JSR &0406       :\ 9F07= 20 06 04     ..
BCC L9F16       :\ 9F0A= 90 0A       ..
LDA &0D5C       :\ 9F0C= AD 5C 0D    -\.
JSR &0406       :\ 9F0F= 20 06 04     ..
JSR L9A2B       :\ 9F12= 20 2B 9A     +.
SEC             :\ 9F15= 38          8
.L9F16
PLA             :\ 9F16= 68          h
TAX             :\ 9F17= AA          *
RTS             :\ 9F18= 60          `
 
.L9F19
LDY #&04        :\ 9F19= A0 04        .
LDA (&A6),Y     :\ 9F1B= B1 A6       1&
LDY #&08        :\ 9F1D= A0 08        .
SEC             :\ 9F1F= 38          8
SBC (&A6),Y     :\ 9F20= F1 A6       q&
STA &A2         :\ 9F22= 85 A2       ."
LDY #&05        :\ 9F24= A0 05        .
LDA (&A6),Y     :\ 9F26= B1 A6       1&
SBC #&00        :\ 9F28= E9 00       i.
STA &A5         :\ 9F2A= 85 A5       .%
LDY #&08        :\ 9F2C= A0 08        .
LDA (&A6),Y     :\ 9F2E= B1 A6       1&
STA &A4         :\ 9F30= 85 A4       .$
LDY #&09        :\ 9F32= A0 09        .
LDA (&A6),Y     :\ 9F34= B1 A6       1&
SEC             :\ 9F36= 38          8
SBC &A5         :\ 9F37= E5 A5       e%
STA &A3         :\ 9F39= 85 A3       .#
SEC             :\ 9F3B= 38          8
RTS             :\ 9F3C= 60          `
 
.L9F3D
LDA #&C1:STA ADLC+0
LDA #&1E:STA ADLC+3
LDA #&00:STA ADLC+1
.L9F4C
LDA #&82:STA ADLC+0    :\ Put ADLC into standby
LDA #&67:STA ADLC+1
RTS

\ Somebody claiming NMIs. I'll have to relinquish NMI control
\ ----------------------------------------------------------- 
.L9F57
BIT &0D66:BPL L9F7A    :\ I'm not using NMIs, put stand ADLC down and return
.L9F5C
LDA &0D0C:CMP #L96BF AND 255:BNE L9F5C
LDA &0D0D:CMP #L96BF DIV 256:BNE L9F5C :\ Wait until NMI idle code in place
IF VERSION<&0365
 BIT INTOFF            :\ Disable ADLC
ELSE
 LDA #&40
 STA &0D1C
ENDIF
BIT INTOFF             :\ Disable ADLC
LDA #&00:STA &0D62     :\ No tranmission in progress
STA &0D66              :\ I'm not using NMIs
LDY #&05               :\ Return with Y=net fs number
.L9F7A
JMP L9F4C              :\ Jump to stand ADLC down and return

\ Background NMI code 
.L9F7D
BIT INTOFF         :\ 0D00 Disable ADLC NMIs
PHA:TYA:PHA        :\ 0D03 Save registers
LDA #&00:STA ROMSEL:\ 0D06 Select NFS ROM
JMP L96BF          :\ 0D0B Jump to rest of code
 
.L9D8B
STY &0D0D          :\ 0D0E Store next NMI routine
STA &0D0C          :\ 0D11
LDA &F4:STA ROMSEL :\ 0D14 Restore ROM
PLA:TAY:PLA        :\ 0D19 Restore registers
BIT INTON          :\ 0D1C Enable ADLC NMIs
RTI                :\ 0D1F

