OPTIONS NODATE NONUMBER;

DATA HW3;
input @1 Method $ @3 EM 5.2;
DATALINES;
M1  5.95
M1  4.78
M1  4.28
M1  5.04
M1  4.56
M2 10.61
M2 13.13
M2 10.91
M2  9.26
M2 11.04
M3 17.00
M3 20.88
M3 20.06
M3 15.25
M3 23.74
M4  7.51
M4  6.82
M4  6.23
M4  6.49
M4  5.91
RUN;
/*Basic Data Set*/
PROC PRINT data = HW3;
RUN;

/*Summary Statistics*/
PROC SUMMARY data = HW3;
class Method;
var EM;
output out=output1 mean=mean stderr=se;
RUN;
PROC PRINT data=output1;
title 'Summary Output for HW3 Data';
RUN;

/*#2 Boxplot*/
PROC SGPLOT  DATA = HW3;
	yaxis label="Elastic Modulus";
	xaxis label="Compaction Method";
	title h=1 "Distribution of Elastic Modulus Distribution per Method";
   	VBOX EM / category = Method;
RUN; 

/*#4 ANOVA model*/
PROC MIXED data=HW3 method=type3 plots=all; 
class Method;
model EM = Method;
store myresults; /*myresults stores results*/
title 'ANOVA of HW3 Data';
RUN;

/*#6 ANOVA F Critical Value*/
DATA Fvalue;                                                                                                                               
   q=finv(0.95, 3, 16);                                                                                                                   
   put q=;                                                                                                                           
RUN;
 
proc print data=work.Fvalue;
 run;

/*#10 Pairwise comparisons using Tukey adjustment. lsmeans statement below 
outputs the estimates means, performs the Tukey paired  comparisons, plots 
the data. Use proc plm procedure for post estimation analysis*/
PROC PLM restore=myresults; 
lsmeans Method / adjust=tukey plot=meanplot cl lines; 
RUN;

/*#12. Testing for contrasts of interest with Bonferroni adjustment*/
PROC PLM restore=myresults; 
lsmeans Method / adjust=tukey plot=meanplot cl lines; 
estimate 'Compare M1 with M2 and M3 and M4 ' Method 3 -1  -1 -1/ adjust=bon;
RUN;

/*#13. Testing for contrasts of interest with Bonferroni adjustment*/
PROC PLM restore=myresults; 
lsmeans Method / adjust=tukey plot=meanplot cl lines; 
estimate 'Compare M1 with M2 and M3 and M4' Method 3 -1 -1 -1,
			'Compare M2 and M3 with M1' Method -2 1 1 0/ adjust=bon;
RUN;

/*#14 Box-Cox*/
PROC TRANSREG data=HW3;
model boxcox(EM)=class(Method);
RUN;

/*#15 Transformed Data*/
DATA TransformedHW3;
   SET HW3;
   lambda = -0.25;
   QRootEM = (EM**lambda);
RUN;
PROC MIXED data=TransformedHW3 method=type3 plots=all; 
class Method;
model QRootEM = Method;
store QRootEMresults;
title 'ANOVA of TransformedHW3 Data';
RUN;

/*#16a Power*/
PROC SUMMARY data = TransformedHW3;
class Method;
var QRootEM;
output out=output2 mean=mean stderr=se;
RUN;
PROC PRINT data= output2;
RUN;

PROC POWER;
onewayanova alpha=.05 test=overall
groupmeans=(0.67493 0.55070 0.47866 0.62552)
npergroup=5 stddev=0.017515
power=.;
RUN;

/*#16b Power*/
PROC POWER;
onewayanova alpha=.01 test=overall
groupmeans=(0.67493 0.55070 0.47866 0.62552)
npergroup=5 stddev=0.017515
power=.;
RUN;
