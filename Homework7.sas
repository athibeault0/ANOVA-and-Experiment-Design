DATA Eff;
Input Scientist Batch Formulation Efficacy;
DATALINES;
1 1 1 85
1 2 2 76
1 3 3 77
1 4 4 87
1 5 5 81
2 1 2 81
2 2 3 83
2 3 4 97
2 4 5 90
2 5 1 91
3 1 3 80
3 2 4 88
3 3 5 85
3 4 1 85
3 5 2 82
4 1 4 83
4 2 5 85
4 3 1 86
4 4 2 84
4 5 3 88
5 1 5 83
5 2 1 97
5 3 2 80
5 4 3 83
5 5 4 92
;
RUN;

PROC MIXED data=Eff covtest method=type3 alpha = 0.05;
CLASS Driver Car;
MODEL MPG =;
RANDOM Driver Car Driver*Car;
RUN;

/**Q5: Model**/
proc mixed data=Eff method=type3;
class Scientist Batch Formulation;
model Efficacy = Formulation;
random Scientist Batch;
run;

/**Q11: Full Model**/
proc mixed data=Eff method=type3;
class Scientist Batch Formulation;
model Efficacy = Formulation;
Store Efficacy;
random Batch;
run;

/**Q14: Full Model**/
proc plm restore=Eff; 
 lsmeans Formulation / adjust=tukey plot=meanplot cl lines alpha=0.01; 
run;
