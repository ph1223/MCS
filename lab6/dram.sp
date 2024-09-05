*****Example for including .vec file as input pattern****** 
.TITLE Dram
*****************************
**     Library setting     **
*****************************
.protect
.include "/RAID2/COURSE/mcs/mcs020/Technology_files/7nm_TT.pm"
.unprotect

***************************************
**           Input vector            **
***************************************
.VEC 'input.vec'

*****************************
**     Voltage Source      **
*****************************
.global VDD GND

Vvdd VDD GND 0.7v
Vvcc VCC GND 0.35v
*****************************
**   Circuit Description   **
*****************************

.subckt dram_cell BL wl plate_node
Ma   n1  wl  BL  x  nmos_lvt
Cc1   n1  plate_node  20fF 
.ends

.subckt SA SAN SAP BL BLB
Mp1   BL    BLB  n2   x  pmos_lvt
Mp2   BLB   BL   n2   x  pmos_lvt
Mn1   BL    BLB  n3   x  nmos_lvt
Mn2   BLB   BL   n3   x  nmos_lvt

Mm1   n2    SAP  VDD  x  pmos_lvt
Mm2   n3    SAN  GND  x  nmos_lvt
.ends

.subckt V_EQ EQ BL BLB pre
Me1   pre   EQ   BL   x  nmos_lvt
Me2   pre   EQ   BLB  x  nmos_lvt
Me3   BL    EQ   BLB  x  nmos_lvt
.ends

.subckt inverter vin vout
Mp  vout  vin  VDD  x  pmos_lvt
Mn  vout  vin  GND  x  nmos_lvt
.ends

.subckt inverter_chain vin vout
xa  vin  n0    inverter
xb  n0   vout  inverter
.ends

x1 BL WL VCC dram_cell
x2 SAN SAP BL BLB SA
x3 EQ BL BLB VCC V_EQ

Mc1   BL   CSL  out   x  nmos_lvt
Mc2   BLB  CSL  outb  x  nmos_lvt
Mw1   n4   WE   out   x  nmos_lvt
Mw2   n5   WE   outb  x  nmos_lvt

x4 in  n4 inverter_chain
x5 inb n5 inverter_chain

C1  BL   GND  30fF  
C2  BLB  GND  30fF

*.ic V(BL) = 0
*.ic V(BLB) = 0
.ic V(x1.n1) = 0.7
*****************************
**    Simulator setting    **
*****************************
.op
.option post     
.options probe   
.probe v(*) i(*) 
.option captab   
.tran 0.01ns 160ns
.TEMP 25

*.measure TRAN AvgPower avg power from=0n to=9n
*.meas tran PeakPower MAX Power	from=0n to=9n

.end