******** Digital Electronics, Multiplexer Design*******


************ Library *************
.prot
.inc '45nm.pm'
.unprot

********* Params*******
.param			Lmin=45n
+Vdd=1V
.global  Vdd


****** Sources ******
VSupply			Vs		0		DC		  Vdd
Vina				Va		0		pulse		Vdd 0 0n 500p 500p 2ns 4ns
Vinx				Vx		0		DC    1

****** SUBCKT and ******
.subckt andGate x y GND  SUPPLY out
Mp2				k		  x	 SUPPLY 	 SUPPLY		  pmos		l='Lmin'		w='Lmin*2'
Mp1				k		  y	 SUPPLY		 SUPPLY		  pmos		l='Lmin'		w='Lmin*2'
Mn1       s     x   GND     GND     nmos    l='Lmin'    w='Lmin*2'
Mn2       k     y   s     s     nmos    l='Lmin'    w='Lmin*2'

Mp3				out		  k	 SUPPLY 	 SUPPLY		 pmos		 l='Lmin'		w='Lmin*2'
Mn3       out     k   GND     GND     nmos   l='Lmin'    w='Lmin'
.ends andGate

****** SUBCKT inverter ******
.subckt inverterGate p GND  SUPPLY q
Mp4				q		  p	 SUPPLY 	 SUPPLY		 pmos		l='Lmin'		w='Lmin*2'
Mn4       q     p   GND     GND     nmos   l='Lmin'    w='Lmin'
.ends inverterGate

****** Main Circuit *****
Xinv1  Vx 0 Vs xb inverterGate
Xinv2  xb 0 Vs z inverterGate
Xand1  z Va 0 Vs y1 andGate
Xand2  xb Va 0 Vs y2 andGate

*********Type of Analysis***
.MEASURE TRAN tphl
+ trig V(Va) val = '0.5*Vdd'  rise = 1
+ targ V(y1) val = '0.5*Vdd'  rise = 1

.MEASURE TRAN tplh
+ trig V(Va) val = '0.5*Vdd'  fall = 1
+ targ V(y1) val = '0.5*Vdd'  fall = 1

.MEASURE TRAN tpd  param = '(tphl + tplh)/2'

.MEASURE TRAN AVGpower avg Power
.MEASURE TRAN PDP param = 'tpd * avgpower'


.tran  0.1ns  20ns
.op
.end
