.TITLE  Decoder

.protect
.include '/RAID2/COURSE/mcs/mcs020/Technology_files/7nm_TT.pm'
.unprotect

.vec 'input.vec'

.global VDD GND
.subckt inverter vin vout
M1 vout  vin  GND   x  nmos_sram	m=1
M2 vout  vin  VDD   x  pmos_sram	m=1
.ends

.subckt inv_chain vin vout
X1 vin net0 inverter
x2 net0 vout inverter
.ends

.subckt nand_4	in0		in1		in2		in3		out
M3	n0	in0	GND	x	nmos_sram	m=1
M4	n1	in1	n0	x	nmos_sram	m=1
M5	n2	in2	n1	x	nmos_sram	m=1
M6	out	in3	n2	x	nmos_sram	m=1
M7	out	in0	VDD	x	pmos_sram	m=1
M8	out	in1	VDD	x	pmos_sram	m=1
M9	out	in2	VDD	x	pmos_sram	m=1
M10	out	in3	VDD	x	pmos_sram	m=1
.ends

.subckt and_4	in0		in1		in2		in3	out
x3	in0		in1		in2		in3	n3	nand_4
x4	n3	out	inverter
.ends

.subckt decoder_3to8	in0		in1		in2		out0	out1	out2	out3	out4	out5	out6	out7	en
x5	in0	n4	inverter
x6	in1	n5	inverter
x7	in2	n6	inverter
x8	n4	n5	n6	en	out0	and_4
x9	in0	n5	n6	en	out1	and_4
x10	n4	in1	n6	en	out2	and_4
x11	in0	in1	n6	en	out3	and_4
x12	n4	n5	in2	en	out4	and_4
x13	in0	n5	in2	en	out5	and_4
x14	n4	in1	in2	en	out6	and_4
x15	in0	in1	in2	en	out7	and_4
.ends

.subckt decoder_6to64	in0		in1		in2		in3		in4		in5		out0	out1	out2	out3	out4	out5	out6	out7	out8	out9	out10	out11	out12	out13	out14	out15	out16	out17	out18	out19	out20	out21	out22	out23	out24	out25	out26	out27	out28	out29	out30	out31	out32	out33	out34	out35	out36	out37	out38	out39	out40	out41	out42	out43	out44	out45	out46	out47	out48	out49	out50	out51	out52	out53	out54	out55	out56	out57	out58	out59	out60	out61	out62	out63	en
x16	in0	in1	in2	out0	out1	out2	out3	out4	out5	out6	out7	en0	decoder_3to8
x17	in0	in1	in2	out8	out9	out10	out11	out12	out13	out14	out15	en1	decoder_3to8
x18	in0	in1	in2	out16	out17	out18	out19	out20	out21	out22	out23	en2	decoder_3to8
x19	in0	in1	in2	out24	out25	out26	out27	out28	out29	out30	out31	en3	decoder_3to8
x20	in0	in1	in2	out32	out33	out34	out35	out36	out37	out38	out39	en4	decoder_3to8
x21	in0	in1	in2	out40	out41	out42	out43	out44	out45	out46	out47	en5	decoder_3to8
x22	in0	in1	in2	out48	out49	out50	out51	out52	out53	out54	out55	en6	decoder_3to8
x23	in0	in1	in2	out56	out57	out58	out59	out60	out61	out62	out63	en7	decoder_3to8
x24	in3	in4	in5	en0	en1	en2	en3	en4	en5	en6	en7	en	decoder_3to8
.ends

Xin0	Addr[0]	in_i[0]	inv_chain
Xin1	Addr[1]	in_i[1]	inv_chain
Xin2	Addr[2]	in_i[2]	inv_chain
Xin3	Addr[3]	in_i[3]	inv_chain
Xin4	Addr[4]	in_i[4]	inv_chain
Xin5	Addr[5]	in_i[5]	inv_chain

Xx0		in_i[0]	in_i[1]	in_i[2]	in_i[3]	in_i[4]	in_i[5]	WL[0]	WL[1]	WL[2]	WL[3]	WL[4]	WL[5]	WL[6]	WL[7]	WL[8]	WL[9]	WL[10]	WL[11]	WL[12]	WL[13]	WL[14]	WL[15]	WL[16]	WL[17]	WL[18]	WL[19]	WL[20]	WL[21]	WL[22]	WL[23]	WL[24]	WL[25]	WL[26]	WL[27]	WL[28]	WL[29]	WL[30]	WL[31]	WL[32]	WL[33]	WL[34]	WL[35]	WL[36]	WL[37]	WL[38]	WL[39]	WL[40]	WL[41]	WL[42]	WL[43]	WL[44]	WL[45]	WL[46]	WL[47]	WL[48]	WL[49]	WL[50]	WL[51]	WL[52]	WL[53]	WL[54]	WL[55]	WL[56]	WL[57]	WL[58]	WL[59]	WL[60]	WL[61]	WL[62]	WL[63]	clk	decoder_6to64

C0	WL[0]	GND	22.2592a
C1	WL[1]	GND	22.2592a
C2	WL[2]	GND	22.2592a
C3	WL[3]	GND	22.2592a
C4	WL[4]	GND	22.2592a
C5	WL[5]	GND	22.2592a
C6	WL[6]	GND	22.2592a
C7	WL[7]	GND	22.2592a
C8	WL[8]	GND	22.2592a
C9	WL[9]	GND	22.2592a
C10	WL[10]	GND	22.2592a
C11	WL[11]	GND	22.2592a
C12	WL[12]	GND	22.2592a
C13	WL[13]	GND	22.2592a
C14	WL[14]	GND	22.2592a
C15	WL[15]	GND	22.2592a
C16	WL[16]	GND	22.2592a
C17	WL[17]	GND	22.2592a
C18	WL[18]	GND	22.2592a
C19	WL[19]	GND	22.2592a
C20	WL[20]	GND	22.2592a
C21	WL[21]	GND	22.2592a
C22	WL[22]	GND	22.2592a
C23	WL[23]	GND	22.2592a
C24	WL[24]	GND	22.2592a
C25	WL[25]	GND	22.2592a
C26	WL[26]	GND	22.2592a
C27	WL[27]	GND	22.2592a
C28	WL[28]	GND	22.2592a
C29	WL[29]	GND	22.2592a
C30	WL[30]	GND	22.2592a
C31	WL[31]	GND	22.2592a
C32	WL[32]	GND	22.2592a
C33	WL[33]	GND	22.2592a
C34	WL[34]	GND	22.2592a
C35	WL[35]	GND	22.2592a
C36	WL[36]	GND	22.2592a
C37	WL[37]	GND	22.2592a
C38	WL[38]	GND	22.2592a
C39	WL[39]	GND	22.2592a
C40	WL[40]	GND	22.2592a
C41	WL[41]	GND	22.2592a
C42	WL[42]	GND	22.2592a
C43	WL[43]	GND	22.2592a
C44	WL[44]	GND	22.2592a
C45	WL[45]	GND	22.2592a
C46	WL[46]	GND	22.2592a
C47	WL[47]	GND	22.2592a
C48	WL[48]	GND	22.2592a
C49	WL[49]	GND	22.2592a
C50	WL[50]	GND	22.2592a
C51	WL[51]	GND	22.2592a
C52	WL[52]	GND	22.2592a
C53	WL[53]	GND	22.2592a
C54	WL[54]	GND	22.2592a
C55	WL[55]	GND	22.2592a
C56	WL[56]	GND	22.2592a
C57	WL[57]	GND	22.2592a
C58	WL[58]	GND	22.2592a
C59	WL[59]	GND	22.2592a
C60	WL[60]	GND	22.2592a
C61	WL[61]	GND	22.2592a
C62	WL[62]	GND	22.2592a
C63	WL[63]	GND	22.2592a

Vvdd VDD GND dc 0.7v

.op
.option post     
.options probe   
.probe v(*) i(*) 
.option captab   
.tran 0.01ns 70ns

.measure TRAN pwr avg power
.TEMP 25

.end
