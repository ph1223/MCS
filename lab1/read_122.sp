.title Noise Margin in Read Operation 1:2:2

*****************************
**     Library setting     **
*****************************
.protect
.include "/RAID2/COURSE/mcs/mcs020/Technology_files/7nm_TT.pm"
.unprotect 

*****************************
**   Circuit Description   **
*****************************
*** By default, m = 1 ***
*** for 1:1:1, the "m" of mos must equal to 1 ***

Mpr  q   gr  VDD  x  pmos_sram  m=1
Mnr  q   gr  GND  x  nmos_sram  m=2

Mpl  qb  gl  VDD  x  pmos_sram  m=1
Mnl  qb  gl  GND  x  nmos_sram  m=2

Mnpr BL  WL  q    x  nmos_sram  m=2
Mnpl BLB WL  qb   x  nmos_sram  m=2

*****************************
**     Voltage Source      **
*****************************
.global VDD GND
.PARAM  BITCAP=1E-12
.PARAM  vdd_v=0.7
+   wl_v=0.7
+   bl_v=0.7
+   blb_v=0.7

VVDD VDD GND vdd_v
VWL  WL  GND wl_v

CBLB BLB GND BITCAP
CBL  BL  GND BITCAP

.ic V(BL) =bl_v
.ic V(BLB)=blb_v
 
*************************************
** Voltage control Voltage Source  **
*************************************
ELi gl GND VCVS POLY(2) v1 GND u GND 0 '1/sqrt(2)' '1/sqrt(2)'
Ev1 v1 GND VCVS POLY(2) qb GND u GND 0 'sqrt(2)'   1
ERi gr GND VCVS POLY(2) v2 GND u GND 0 '1/sqrt(2)' '-1/sqrt(2)'
Ev2 v2 GND VCVS POLY(2) q  GND u GND 0 'sqrt(2)'   -1

Vu u GND 0

*****************************
**       DC Analysis       **
*****************************
.op
.dc Vu '-1/sqrt(2)' '1/sqrt(2)' 0.0001 data = dataM

*****************************
**    Simulator setting    **
*****************************
.option post 
.options probe
.probe v(*) i(*)

.TEMP 25

.data   dataM
+   vdd_v   wl_v    bl_v    blb_v
+   0.7     0.7     0.7     0.7
+   0.6     0.6     0.6     0.6
+   0.5     0.5     0.5     0.5
+   0.4     0.4     0.4     0.4
.enddata
*****************************
**      Measurement        **
*****************************
*.measure dc max_1 max v(v1,v2)
*.measure dc max_2 max v(v2,v1)
*.measure dc SNM param='min(max_1,max_2)/sqrt(2)' 


.measure cross_point when v(v1) = v(v2)
.measure dc max_1 max v(v1,v2) FROM = 'cross_point' TO = '-cross_point'
.measure dc max_2 max v(v2,v1) FROM = 'cross_point' TO = '-cross_point'
.measure dc SNM param='(min(max_1,max_2)/sqrt(2))'

.alter
.data   dataM
+   vdd_v   wl_v    bl_v    blb_v
+   0.7     0.9     0.7     0.7
+   0.7     0.8     0.7     0.7
+   0.7     0.7     0.7     0.7
+   0.7     0.6     0.7     0.7
+   0.7     0.5     0.7     0.7
.enddata

.end