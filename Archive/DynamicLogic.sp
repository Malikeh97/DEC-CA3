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
Vina				Va		0		DC    0
Vinx				Vx		0		DC    0
Vclk        _clk  0   pulse		Vdd 0 0n 500p 500p 2ns 4ns


****** SUBCKT and ******
.subckt andGate x y clk GND  SUPPLY out
Mp3				z		  clk	  SUPPLY 	SUPPLY	 	  pmos	  l='Lmin'		w='Lmin*2'
Mn5       z   x     s     s     nmos   l='Lmin'    w='Lmin'
Mn6       s     y     j     j       nmos   l='Lmin'    w='Lmin'
Mn7       j     clk     GND    GND    nmos   l='Lmin'    w='Lmin'

Mp2				out		  clk	  SUPPLY 	SUPPLY	 	   pmos	  l='Lmin'		w='Lmin*2'
Mn3       out     z     d     d     nmos   l='Lmin'    w='Lmin'
Mn4       d       clk    GND    GND    nmos   l='Lmin'    w='Lmin'
.ends andGate

****** SUBCKT inverter ******
.subckt inverterGate in clk GND  SUPPLY out
Mp1				out		  clk	    SUPPLY 	  SUPPLY	 	   pmos	  l='Lmin'		w='Lmin*2'
Mn1       out     in     d     d     nmos   l='Lmin'    w='Lmin'
Mn2       d       clk    GND    GND    nmos   l='Lmin'    w='Lmin'
.ends inverterGate

****** Main Circuit *****
Xinv1  Vx _clk 0  Vs xb inverterGate
Xinv2  xb _clk 0  Vs z inverterGate
Xand1  z Va _clk 0  Vs y1 andGate
Xand2  xb Va _clk 0  Vs y2 andGate



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
