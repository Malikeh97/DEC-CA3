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
Vclk        _clk  0   pulse		Vdd 0 0n 500p 500p 1ns 5ns

****** SUBCKT inverter ******
.subckt inverterGate in  GND  SUPPLY out
Mp1				out		  GND	 SUPPLY 	 SUPPLY		 pmos		l='Lmin'		w='Lmin'
Mn1       out     in   GND     GND     nmos   l='Lmin'    w='Lmin*2'
.ends inverterGate

****** SUBCKT and ******
.subckt andGate x y clk GND  SUPPLY out
Mp2				s		  clk	  SUPPLY 	SUPPLY	 	  pmos	  l='Lmin'		w='Lmin*2'
Mn2       s   x     j    j     nmos   l='Lmin'    w='Lmin'
Mn3       j     y     k     k       nmos   l='Lmin'    w='Lmin'
Mn4       k     clk     GND    GND    nmos   l='Lmin'    w='Lmin'

Mp3				s		  out	  SUPPLY 	SUPPLY	 	   pmos	  l='Lmin'		w='Lmin*2'
Xinv3     s GND  SUPPLY out inverterGate
.ends andGate

****** Main Circuit *****
Xinv1  Vx 0  Vs xb inverterGate
Xinv2  xb 0  Vs z inverterGate
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
