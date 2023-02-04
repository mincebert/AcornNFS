\ TUBE SYSTEM
\ ===========
.L9321
LDA #&FF        :\ 0016= A9 FF       ).
JSR &069E       :\ 0018= 20 9E 06     ..
LDA &FEE3       :\ 001B= AD E3 FE    -c~
LDA #&00        :\ 001E= A9 00       ).
JSR &0695       :\ 0020= 20 95 06     ..
TAY             :\ 0023= A8          (
LDA (&FD),Y     :\ 0024= B1 FD       1}
JSR &0695       :\ 0026= 20 95 06     ..
.L9334
INY             :\ 0029= C8          H
LDA (&FD),Y     :\ 002A= B1 FD       1}
JSR &0695       :\ 002C= 20 95 06     ..
TAX             :\ 002F= AA          *
BNE L9334       :\ 0030= D0 F7       Pw
LDX #&FF        :\ 0032= A2 FF       ".
TXS             :\ 0034= 9A          .
CLI             :\ 0035= 58          X
.L9341
BIT &FEE0       :\ 0036= 2C E0 FE    ,`~
BPL L934C       :\ 0039= 10 06       ..
.L9346
LDA &FEE1       :\ 003B= AD E1 FE    -a~
JSR OSWRCH      :\ 003E= 20 EE FF     n.
.L934C
BIT &FEE2       :\ 0041= 2C E2 FE    ,b~
BPL L9341       :\ 0044= 10 F0       .p
BIT &FEE0       :\ 0046= 2C E0 FE    ,`~
BMI L9346       :\ 0049= 30 F0       0p
LDX &FEE3       :\ 004B= AE E3 FE    .c~
STX &51         :\ 004E= 86 51       .Q
JMP (&0500)     :\ 0050= 6C 00 05    l..
.L935E
EQUW &8000      :\ 0053
EQUW &0000      :\ 0055

.LTUBE		:\ Copied to &0400
.L9362
JMP &0484       :\ 9362= 4C 84 04    L..
 
JMP &06A7       :\ 9365= 4C A7 06    L'.
 
CMP #&80        :\ 9368= C9 80       I.
BCC L9397       :\ 936A= 90 2B       .+
CMP #&C0        :\ 936C= C9 C0       I@
BCS L938A       :\ 936E= B0 1A       0.
ORA #&40        :\ 9370= 09 40       .@
CMP &15         :\ 9372= C5 15       E.
BNE L9396       :\ 9374= D0 20       P 
PHP             :\ 9376= 08          .
SEI             :\ 9377= 78          x
LDA #&05        :\ 9378= A9 05       ).
JSR &069E       :\ 937A= 20 9E 06     ..
LDA &15         :\ 937D= A5 15       %.
JSR &069E       :\ 937F= 20 9E 06     ..
PLP             :\ 9382= 28          (
LDA #&80        :\ 9383= A9 80       ).
STA &15         :\ 9385= 85 15       ..
STA &14         :\ 9387= 85 14       ..
RTS             :\ 9389= 60          `
 
.L938A
ASL &14         :\ 938A= 06 14       ..
BCS L9394       :\ 938C= B0 06       0.
CMP &15         :\ 938E= C5 15       E.
BEQ L9396       :\ 9390= F0 04       p.
CLC             :\ 9392= 18          .
RTS             :\ 9393= 60          `
 
.L9394
STA &15         :\ 9394= 85 15       ..
.L9396
RTS             :\ 9396= 60          `
 
.L9397
PHP             :\ 9397= 08          .
SEI             :\ 9398= 78          x
STY &13         :\ 9399= 84 13       ..
STX &12         :\ 939B= 86 12       ..
JSR &069E       :\ 939D= 20 9E 06     ..
TAX             :\ 93A0= AA          *
LDY #&03        :\ 93A1= A0 03        .
LDA &15         :\ 93A3= A5 15       %.
JSR &069E       :\ 93A5= 20 9E 06     ..
.L93A8
LDA (&12),Y     :\ 93A8= B1 12       1.
JSR &069E       :\ 93AA= 20 9E 06     ..
DEY             :\ 93AD= 88          .
BPL L93A8       :\ 93AE= 10 F8       .x
LDY #&18        :\ 93B0= A0 18        .
STY &FEE0       :\ 93B2= 8C E0 FE    .`~
LDA &0518,X     :\ 93B5= BD 18 05    =..
STA &FEE0       :\ 93B8= 8D E0 FE    .`~
LSR A           :\ 93BB= 4A          J
LSR A           :\ 93BC= 4A          J
BCC L93C5       :\ 93BD= 90 06       ..
BIT &FEE5       :\ 93BF= 2C E5 FE    ,e~
BIT &FEE5       :\ 93C2= 2C E5 FE    ,e~
.L93C5
JSR &069E       :\ 93C5= 20 9E 06     ..
.L93C8
BIT &FEE6       :\ 93C8= 2C E6 FE    ,f~
BVC L93C8       :\ 93CB= 50 FB       P{
BCS L93DC       :\ 93CD= B0 0D       0.
CPX #&04        :\ 93CF= E0 04       `.
BNE L93E4       :\ 93D1= D0 11       P.
.L93D3
JSR &0414       :\ 93D3= 20 14 04     ..
JSR &0695       :\ 93D6= 20 95 06     ..
JMP &0032       :\ 93D9= 4C 32 00    L2.
 
.L93DC
LSR A           :\ 93DC= 4A          J
BCC L93E4       :\ 93DD= 90 05       ..
LDY #&88        :\ 93DF= A0 88        .
STY &FEE0       :\ 93E1= 8C E0 FE    .`~
.L93E4
PLP             :\ 93E4= 28          (
RTS             :\ 93E5= 60          `
 
CLI             :\ 93E6= 58          X
BCS L93FA       :\ 93E7= B0 11       0.
BNE L93EE       :\ 93E9= D0 03       P.
JMP &059C       :\ 93EB= 4C 9C 05    L..
 
.L93EE
LDX #&00        :\ 93EE= A2 00       ".
LDY #&FF        :\ 93F0= A0 FF        .
LDA #&FD        :\ 93F2= A9 FD       )}
JSR OSBYTE      :\ 93F4= 20 F4 FF     t.
TXA             :\ 93F7= 8A          .
BEQ L93D3       :\ 93F8= F0 D9       pY
.L93FA
LDA #&FF        :\ 93FA= A9 FF       ).
JSR &0406       :\ 93FC= 20 06 04     ..
BCC L93FA       :\ 93FF= 90 F9       .y
JSR &04D2       :\ 9401= 20 D2 04     R.
.L9404
LDA #&07        :\ 9404= A9 07       ).
JSR &04CB       :\ 9406= 20 CB 04     K.
LDY #&00        :\ 9409= A0 00        .
STY &00         :\ 940B= 84 00       ..
.L940D
LDA (&00),Y     :\ 940D= B1 00       1.
STA &FEE5       :\ 940F= 8D E5 FE    .e~
NOP             :\ 9412= EA          j
NOP             :\ 9413= EA          j
NOP             :\ 9414= EA          j
INY             :\ 9415= C8          H
BNE L940D       :\ 9416= D0 F5       Pu
INC &54         :\ 9418= E6 54       fT
BNE L9422       :\ 941A= D0 06       P.
INC &55         :\ 941C= E6 55       fU
BNE L9422       :\ 941E= D0 02       P.
INC &56         :\ 9420= E6 56       fV
.L9422
INC &01         :\ 9422= E6 01       f.
BIT &01         :\ 9424= 24 01       $.
BVC L9404       :\ 9426= 50 DC       P\
JSR &04D2       :\ 9428= 20 D2 04     R.
LDA #&04        :\ 942B= A9 04       ).
LDY #&00        :\ 942D= A0 00        .
LDX #&53        :\ 942F= A2 53       "S
JMP &0406       :\ 9431= 4C 06 04    L..
 
LDA #&80        :\ 9434= A9 80       ).
STA &54         :\ 9436= 85 54       .T
STA &01         :\ 9438= 85 01       ..
LDA #&20        :\ 943A= A9 20       ) 
AND L8006       :\ 943C= 2D 06 80    -..
TAY             :\ 943F= A8          (
STY &53         :\ 9440= 84 53       .S
BEQ L945D       :\ 9442= F0 19       p.
LDX L8007       :\ 9444= AE 07 80    ...
.L9447
INX               :\ 9447= E8          h
LDA L8000+0,X     :\ 9448= BD 00 80    =..
BNE L9447         :\ 944B= D0 FA       Pz
LDA L8000+1,X     :\ 944D= BD 01 80    =..
STA &53           :\ 9450= 85 53       .S
LDA L8000+2,X     :\ 9452= BD 02 80    =..
STA &54           :\ 9455= 85 54       .T
LDY L8000+3,X     :\ 9457= BC 03 80    <..
LDA L8000+4,X     :\ 945A= BD 04 80    =..
.L945D
STA &56         :\ 945D= 85 56       .V
STY &55         :\ 945F= 84 55       .U
RTS             :\ 9461= 60          `
 
.L9462
EQUB &37        :\ 9462= 37          7
ORA &96         :\ 9463= 05 96       ..
ORA &F2         :\ 9465= 05 F2       .r
ORA &07         :\ 9467= 05 07       ..
ASL &27         :\ 9469= 06 27       .'
ASL &68         :\ 946B= 06 68       .h
ASL &5E         :\ 946D= 06 5E       .^
ORA &2D         :\ 946F= 05 2D       .-
ORA &20         :\ 9471= 05 20       . 
ORA &42         :\ 9473= 05 42       .B
ORA &A9         :\ 9475= 05 A9       .)
ORA &D1         :\ 9477= 05 D1       .Q
ORA &86         :\ 9479= 05 86       ..
DEY             :\ 947B= 88          .
STX &98,Y       :\ 947C= 96 98       ..
CLC             :\ 947E= 18          .
CLC             :\ 947F= 18          .
EQUB &82        :\ 9480= 82          .
CLC             :\ 9481= 18          .
JSR &06C5       :\ 9482= 20 C5 06     E.
TAY             :\ 9485= A8          (
JSR &06C5       :\ 9486= 20 C5 06     E.
JSR OSBPUT      :\ 9489= 20 D4 FF     T.
JMP &059C       :\ 948C= 4C 9C 05    L..
 
JSR &06C5       :\ 948F= 20 C5 06     E.
TAY             :\ 9492= A8          (
JSR OSBGET      :\ 9493= 20 D7 FF     W.
JMP &053A       :\ 9496= 4C 3A 05    L:.
 
JSR OSRDCH      :\ 9499= 20 E0 FF     `.
ROR A           :\ 949C= 6A          j
JSR &0695       :\ 949D= 20 95 06     ..
ROL A           :\ 94A0= 2A          *
JMP &059E       :\ 94A1= 4C 9E 05    L..
 
JSR &06C5       :\ 94A4= 20 C5 06     E.
BEQ L94B4       :\ 94A7= F0 0B       p.
PHA             :\ 94A9= 48          H
JSR &0582       :\ 94AA= 20 82 05     ..
PLA             :\ 94AD= 68          h
JSR OSFIND      :\ 94AE= 20 CE FF     N.
JMP &059E       :\ 94B1= 4C 9E 05    L..
 
.L94B4
JSR &06C5       :\ 94B4= 20 C5 06     E.
TAY             :\ 94B7= A8          (
LDA #&00        :\ 94B8= A9 00       ).
JSR OSFIND      :\ 94BA= 20 CE FF     N.
JMP &059C       :\ 94BD= 4C 9C 05    L..
 
JSR &06C5       :\ 94C0= 20 C5 06     E.
TAY             :\ 94C3= A8          (
LDX #&04        :\ 94C4= A2 04       ".
.L94C6
JSR &06C5       :\ 94C6= 20 C5 06     E.
STA &FF,X       :\ 94C9= 95 FF       ..
DEX             :\ 94CB= CA          J
BNE L94C6       :\ 94CC= D0 F8       Px
JSR &06C5       :\ 94CE= 20 C5 06     E.
JSR OSARGS      :\ 94D1= 20 DA FF     Z.
JSR &0695       :\ 94D4= 20 95 06     ..
LDX #&03        :\ 94D7= A2 03       ".
.L94D9
LDA &00,X       :\ 94D9= B5 00       5.
JSR &0695       :\ 94DB= 20 95 06     ..
DEX             :\ 94DE= CA          J
BPL L94D9       :\ 94DF= 10 F8       .x
JMP &0036       :\ 94E1= 4C 36 00    L6.
 
LDX #&00        :\ 94E4= A2 00       ".
LDY #&00        :\ 94E6= A0 00        .
.L94E8
JSR &06C5       :\ 94E8= 20 C5 06     E.
STA &0700,Y     :\ 94EB= 99 00 07    ...
INY             :\ 94EE= C8          H
BEQ L94F5       :\ 94EF= F0 04       p.
CMP #&0D        :\ 94F1= C9 0D       I.
BNE L94E8       :\ 94F3= D0 F3       Ps
.L94F5
LDY #&07        :\ 94F5= A0 07        .
RTS             :\ 94F7= 60          `
 
JSR &0582       :\ 94F8= 20 82 05     ..
JSR OS_CLI      :\ 94FB= 20 F7 FF     w.
LDA #&7F        :\ 94FE= A9 7F       ).
.L9500
BIT &FEE2       :\ 9500= 2C E2 FE    ,b~
BVC L9500       :\ 9503= 50 FB       P{
STA &FEE3       :\ 9505= 8D E3 FE    .c~
.L9508
JMP &0036       :\ 9508= 4C 36 00    L6.
 
LDX #&10        :\ 950B= A2 10       ".
.L950D
JSR &06C5       :\ 950D= 20 C5 06     E.
STA &01,X       :\ 9510= 95 01       ..
DEX             :\ 9512= CA          J
BNE L950D       :\ 9513= D0 F8       Px
JSR &0582       :\ 9515= 20 82 05     ..
STX &00         :\ 9518= 86 00       ..
STY &01         :\ 951A= 84 01       ..
LDY #&00        :\ 951C= A0 00        .
JSR &06C5       :\ 951E= 20 C5 06     E.
JSR OSFILE      :\ 9521= 20 DD FF     ].
JSR &0695       :\ 9524= 20 95 06     ..
LDX #&10        :\ 9527= A2 10       ".
.L9529
LDA &01,X       :\ 9529= B5 01       5.
JSR &0695       :\ 952B= 20 95 06     ..
DEX             :\ 952E= CA          J
BNE L9529       :\ 952F= D0 F8       Px
BEQ L9508       :\ 9531= F0 D5       pU
LDX #&0D        :\ 9533= A2 0D       ".
.L9535
JSR &06C5       :\ 9535= 20 C5 06     E.
STA &FF,X       :\ 9538= 95 FF       ..
DEX             :\ 953A= CA          J
BNE L9535       :\ 953B= D0 F8       Px
JSR &06C5       :\ 953D= 20 C5 06     E.
LDY #&00        :\ 9540= A0 00        .
JSR OSGBPB      :\ 9542= 20 D1 FF     Q.
PHA             :\ 9545= 48          H
LDX #&0C        :\ 9546= A2 0C       ".
.L9548
LDA &00,X       :\ 9548= B5 00       5.
JSR &0695       :\ 954A= 20 95 06     ..
DEX             :\ 954D= CA          J
BPL L9548       :\ 954E= 10 F8       .x
PLA             :\ 9550= 68          h
JMP &053A       :\ 9551= 4C 3A 05    L:.
 
JSR &06C5       :\ 9554= 20 C5 06     E.
TAX             :\ 9557= AA          *
JSR &06C5       :\ 9558= 20 C5 06     E.
JSR OSBYTE      :\ 955B= 20 F4 FF     t.
.L955E
BIT &FEE2       :\ 955E= 2C E2 FE    ,b~
BVC L955E       :\ 9561= 50 FB       P{
STX &FEE3       :\ 9563= 8E E3 FE    .c~
.L9566
JMP &0036       :\ 9566= 4C 36 00    L6.
 
JSR &06C5       :\ 9569= 20 C5 06     E.
TAX             :\ 956C= AA          *
JSR &06C5       :\ 956D= 20 C5 06     E.
TAY             :\ 9570= A8          (
JSR &06C5       :\ 9571= 20 C5 06     E.
JSR OSBYTE      :\ 9574= 20 F4 FF     t.
EOR #&9D        :\ 9577= 49 9D       I.
BEQ L9566       :\ 9579= F0 EB       pk
ROR A           :\ 957B= 6A          j
JSR &0695       :\ 957C= 20 95 06     ..
.L957F
BIT &FEE2       :\ 957F= 2C E2 FE    ,b~
BVC L957F       :\ 9582= 50 FB       P{
STY &FEE3       :\ 9584= 8C E3 FE    .c~
BVS L955E       :\ 9587= 70 D5       pU
JSR &06C5       :\ 9589= 20 C5 06     E.
TAY             :\ 958C= A8          (
.L958D
BIT &FEE2       :\ 958D= 2C E2 FE    ,b~
BPL L958D       :\ 9590= 10 FB       .{
LDX &FEE3       :\ 9592= AE E3 FE    .c~
DEX             :\ 9595= CA          J
BMI L95A7       :\ 9596= 30 0F       0.
.L9598
BIT &FEE2       :\ 9598= 2C E2 FE    ,b~
BPL L9598       :\ 959B= 10 FB       .{
LDA &FEE3       :\ 959D= AD E3 FE    -c~
STA &0128,X     :\ 95A0= 9D 28 01    .(.
DEX             :\ 95A3= CA          J
BPL L9598       :\ 95A4= 10 F2       .r
TYA             :\ 95A6= 98          .
.L95A7
LDX #&28        :\ 95A7= A2 28       "(
LDY #&01        :\ 95A9= A0 01        .
JSR OSWORD      :\ 95AB= 20 F1 FF     q.
.L95AE
BIT &FEE2       :\ 95AE= 2C E2 FE    ,b~
BPL L95AE       :\ 95B1= 10 FB       .{
LDX &FEE3       :\ 95B3= AE E3 FE    .c~
DEX             :\ 95B6= CA          J
BMI L95C7       :\ 95B7= 30 0E       0.
.L95B9
LDY &0128,X     :\ 95B9= BC 28 01    <(.
.L95BC
BIT &FEE2       :\ 95BC= 2C E2 FE    ,b~
BVC L95BC       :\ 95BF= 50 FB       P{
STY &FEE3       :\ 95C1= 8C E3 FE    .c~
DEX             :\ 95C4= CA          J
BPL L95B9       :\ 95C5= 10 F2       .r
.L95C7
JMP &0036       :\ 95C7= 4C 36 00    L6.
 
LDX #&04        :\ 95CA= A2 04       ".
.L95CC
JSR &06C5       :\ 95CC= 20 C5 06     E.
STA &00,X       :\ 95CF= 95 00       ..
DEX             :\ 95D1= CA          J
BPL L95CC       :\ 95D2= 10 F8       .x
INX             :\ 95D4= E8          h
LDY #&00        :\ 95D5= A0 00        .
TXA             :\ 95D7= 8A          .
JSR OSWORD      :\ 95D8= 20 F1 FF     q.
BCC L95E2       :\ 95DB= 90 05       ..
LDA #&FF        :\ 95DD= A9 FF       ).
JMP &059E       :\ 95DF= 4C 9E 05    L..
 
.L95E2
LDX #&00        :\ 95E2= A2 00       ".
LDA #&7F        :\ 95E4= A9 7F       ).
JSR &0695       :\ 95E6= 20 95 06     ..
.L95E9
LDA &0700,X     :\ 95E9= BD 00 07    =..
JSR &0695       :\ 95EC= 20 95 06     ..
INX             :\ 95EF= E8          h
CMP #&0D        :\ 95F0= C9 0D       I.
BNE L95E9       :\ 95F2= D0 F5       Pu
JMP &0036       :\ 95F4= 4C 36 00    L6.
 
.L95F7
BIT &FEE2       :\ 95F7= 2C E2 FE    ,b~
BVC L95F7       :\ 95FA= 50 FB       P{
STA &FEE3       :\ 95FC= 8D E3 FE    .c~
RTS             :\ 95FF= 60          `
 
.L9600
BIT &FEE6       :\ 9600= 2C E6 FE    ,f~
BVC L9600       :\ 9603= 50 FB       P{
STA &FEE7       :\ 9605= 8D E7 FE    .g~
RTS             :\ 9608= 60          `
 
LDA &FF         :\ 9609= A5 FF       %.
SEC             :\ 960B= 38          8
ROR A           :\ 960C= 6A          j
BMI L961E       :\ 960D= 30 0F       0.
PHA             :\ 960F= 48          H
LDA #&00        :\ 9610= A9 00       ).
JSR &06BC       :\ 9612= 20 BC 06     <.
TYA             :\ 9615= 98          .
JSR &06BC       :\ 9616= 20 BC 06     <.
TXA             :\ 9619= 8A          .
JSR &06BC       :\ 961A= 20 BC 06     <.
PLA             :\ 961D= 68          h
.L961E
BIT &FEE0       :\ 961E= 2C E0 FE    ,`~
BVC L961E       :\ 9621= 50 FB       P{
STA &FEE1       :\ 9623= 8D E1 FE    .a~
RTS             :\ 9626= 60          `
 
.L9627
BIT &FEE2       :\ 9627= 2C E2 FE    ,b~
BPL L9627       :\ 962A= 10 FB       .{
LDA &FEE3       :\ 962C= AD E3 FE    -c~
RTS             :\ 962F= 60          `

