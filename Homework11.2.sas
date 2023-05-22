/**Investigators were interested in the effect of color treatments on apple sales. Difference sequences 
of the color treated apples were sold in stores, with the sequences spanning 3 periods. A total of 6 
sequences are used and 9 stores (3 sequences were applied in 2 stores and the remaining sequences were 
applied in only one store, for a total of 9 stores).**/
Data apples;
INFILE datalines dlm="," dsd;
INPUT Store period sequence treatment x1 x2 sales;
DATALINES;
1,1,1,1,0,0,1000
1,2,1,2,1,0,700
1,3,1,3,0,1,625
2,1,2,2,0,0,500
2,2,2,3,0,1,500
2,3,2,1,-1,-1,450
3,1,3,3,0,0,1000
3,2,3,1,-1,-1,800
3,3,3,2,1,0,500
4,1,4,1,0,0,900
4,2,4,3,1,0,600
4,3,4,2,-1,-1,525
5,1,5,2,0,0,575
5,2,5,1,0,1,650
5,3,5,3,1,0,475
6,1,6,3,0,0,825
6,2,6,2,-1,-1,600
6,3,6,1,0,1,750
7,1,1,1,0,0,750
7,2,1,2,1,0,575
7,3,1,3,0,1,550
8,1,2,2,0,0,500
8,2,2,3,0,1,700
8,3,2,1,-1,-1,600
9,1,3,3,0,0,375
9,2,3,1,-1,-1,400
9,3,3,2,1,0,300
;
RUN;

PROC PRINT data=apples;
RUN;

/*Question 11: Obtaining fit Statistics for CSH, CS, AR(1), UN*/
proc mixed data=apples;
class period sequence treatment Store;
model sales = period treatment sequence x1 x2/ddfm=kr;
repeated period / subject=store(sequence) type=CSH rcorr;
ods output FitStatistics=FitCSH (rename=(value=CSH)) FitStatistics=FitCSHp; 
title 'HETEROGENOUS COMPOUND SYMMETRY'; 
run; 
proc mixed data=apples;
class period sequence treatment Store;
model sales = period treatment sequence x1 x2/ddfm=kr;
repeated period / subject=store(sequence) type=CS rcorr;
ods output FitStatistics=FitCS (rename=(value=CS)) FitStatistics=FitCSp; 
title 'Compound Symmetry'; 
run; 
proc mixed data=apples;
class period sequence treatment Store;
model sales = period treatment sequence x1 x2/ddfm=kr;
repeated period / subject=store(sequence) type=AR(1) rcorr;
ods output FitStatistics=FitAR1 (rename=(value=AR1)) FitStatistics=FitAR1p; 
title 'Autoregressive Lag 1'; 
run; 
proc mixed data=apples;
class period sequence treatment Store;
model sales = period treatment sequence x1 x2/ddfm=kr;
repeated period / subject=store(sequence) type=UN rcorr;
ods output FitStatistics=FitUN (rename=(value=UN)) FitStatistics=FitUNp; 
title 'Unstructured'; 
run; 
data fits; 
merge FITCSH FitCS FitAR1 FitUN; 
by descr; 
run; 
ods listing; title 'Summerized Fit Statistics'; run;
proc print data=fits; run;

/**Question 12:**/

/* Model Adjusting for carryover effects */ 
proc mixed data=apples;
class period sequence treatment Store;
model sales = period treatment sequence x1 x2/ddfm=kr;
repeated period / subject=store(sequence) type=UN rcorr;
STORE apples_out;
run; 

proc plm restore=apples_out; 
  lsmeans treatment / adjust=tukey plot=meanplot cl lines; 
  ods exclude diffs diffplot; 
run; 
 
/* Reduced Model, Ignoring carryover effects */ 
proc mixed data=apples;
class period sequence treatment Store;
model sales = period treatment sequence /ddfm=kr;
repeated period / subject=store(sequence) type=UN rcorr;
lsmeans treatment / pdiff adjust=tukey; 
run; 
