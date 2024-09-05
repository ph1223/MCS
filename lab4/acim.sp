*****Example for including .vec file as input pattern****** 
.TITLE Analog CIM
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
Vvref Vref GND 0.343v
Vclk clk GND pulse( 0v 0.7v 0.5n 0.01n 0.01n 0.48n 1n)
Vpre pre GND pulse( 0v 0.7v 0.5n 0.01n 0.01n 0.38n 1n)
*****************************
**   Circuit Description   **
*****************************

.subckt SRAM_8T WL RWL BL BLB RBL
Mpr	 q	 qb  VDD  x  pmos_sram  m=1
Mnr  q   qb  GND  x  nmos_sram  m=1

Mpl  qb  q   VDD  x  pmos_sram  m=1
Mnl  qb  q   GND  x  nmos_sram  m=1

Mnpr BL  WL  q    x  nmos_sram  m=1
Mnpl BLB WL  qb   x  nmos_sram  m=1

Mnn2	 n  qb	 GND  x  nmos_sram  m=1
Mnn3  RBL RWL n   x  nmos_sram  m=1
.ends

.subckt compare in1 in2 out
Mp1   n1   n1   VDD  x  pmos_lvt  m=1
Mp2   n3   n3   VDD  x  pmos_lvt  m=1
Mp3   n4   n3   VDD  x  pmos_lvt  m=1
Mp4  out   n4   VDD  x  pmos_lvt  m=1

Mn1   n1   n1   GND  x  nmos_lvt  m=1
Mn2   n3  in1    n2  x  nmos_lvt  m=1
Mn3   n2   n1   GND  x  nmos_lvt  m=1
Mn4   n4  in2    n2  x  nmos_lvt  m=1
Mn5  out   n1   GND  x  nmos_lvt  m=1
.ends

Mp1   RBL  pre  VDD  x  pmos_lvt  m=1

x1 GND In1 VDD VDD RBL SRAM_8T 
x2 GND In2 VDD VDD RBL SRAM_8T 
x3 GND In3 VDD VDD RBL SRAM_8T 
x4 GND In4 VDD VDD RBL SRAM_8T 
x5 GND In5 VDD VDD RBL SRAM_8T 
x6 GND In6 VDD VDD RBL SRAM_8T 
x7 GND In7 VDD VDD RBL SRAM_8T 
x8 GND In8 VDD VDD RBL SRAM_8T
x9 GND In9 VDD VDD RBL SRAM_8T

x10 RBL Vref output compare
CRBL   RBL GND 27fF

.IC V(x1.qb) = 0.7v
.IC V(x2.qb) = 0v
.IC V(x3.qb) = 0.7v
.IC V(x4.qb) = 0v
.IC V(x5.qb) = 0.7v
.IC V(x6.qb) = 0.7v
.IC V(x7.qb) = 0.7v
.IC V(x8.qb) = 0v
.IC V(x9.qb) = 0.7v

*****************************
**    Simulator setting    **
*****************************
.op
.option post     
.options probe   
.probe v(*) i(*) 
.option captab   
.tran 0.01ns 10ns
.TEMP 25

.measure TRAN AvgPower avg power from=0n to=9n
.meas tran PeakPower MAX Power	from=0n to=9n

.end