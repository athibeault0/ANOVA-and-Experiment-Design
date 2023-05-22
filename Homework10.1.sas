/**
A chemist who was studying the effect of soil charcoal produced at different temperatures 
on the metabolic quotient of the soils carried out his experiments using charcoals created 
at 4 temperatures: 450, 550, 650, 750 Celsius. The responses (metabolic quotients) obtained 
for 24 replicates of the experiment for each charcoal produced at a different temperature 
are given below.
(Data and scenario adapted from S.P. Bergeron, R.L. Bradley, A. Munson, W. Parsons, 2013.)
**/
OPTIONS NODATE;

DATA charcoal;
INPUT Y Trt Temp;
DATALINES;
6.124503 1 450
5.695579 1 450
5.666292 1 450
3.461703 1 450
3.444627 1 450
3.835655 1 450
4.86529 1 450
3.39831 1 450
3.869657 1 450
6.012032 1 450
3.619192 1 450
3.718232 1 450
3.712297 1 450
3.824265 1 450
3.391048 1 450
5.043185 1 450
2.775064 1 450
4.501684 1 450
5.347724 1 450
4.01752 1 450
4.079572 1 450
3.682722 1 450
4.607145 1 450
4.026703 1 450
3.071497 2 550
3.886192 2 550
3.255375 2 550
2.485779 2 550
2.776071 2 550
2.701192 2 550
4.293811 2 550
2.58143 2 550
3.089276 2 550
3.660114 2 550
2.102955 2 550
3.196761 2 550
2.98814 2 550
2.371399 2 550
2.732819 2 550
4.572554 2 550
4.686381 2 550
3.493607 2 550
2.240317 2 550
2.871472 2 550
1.440252 2 550
3.223204 2 550
4.348322 2 550
1.37108 2 550
2.155532 3 650
2.357123 3 650
2.25309 3 650
3.023233 3 650
3.417406 3 650
2.76865 3 650
3.407817 3 650
2.187389 3 650
2.557014 3 650
2.744948 3 650
2.747691 3 650
3.32874 3 650
4.360278 3 650
4.605961 3 650
1.259405 3 650
2.122035 3 650
3.848609 3 650
2.313037 3 650
1.257436 3 650
2.956469 3 650
2.972569 3 650
2.893713 3 650
2.707563 3 650
3.914291 3 650
1.627931 4 750
1.919911 4 750
0.466857 4 750
1.391987 4 750
2.020372 4 750
2.812368 4 750
1.108295 4 750
1.601386 4 750
2.273412 4 750
1.567505 4 750
0.535421 4 750
0.141824 4 750
0.59088 4 750
2.303477 4 750
0.67103 4 750
0.860923 4 750
2.043421 4 750
0.961692 4 750
2.113871 4 750
1.586568 4 750
1.494579 4 750
0.916457 4 750
1.964408 4 750
1.585427 4 750
;
RUN;

/**Question 3: The chemist wants to learn whether the temperature used to create the 
charcoal has any effect on metabolic quotients. Ignoring any potential trend analysis, 
run a suitable analysis at 5% level to answer the chemists' question.**/
PROC MIXED data = charcoal method = type3;
CLASS Trt;
MODEL Y = Trt; /*Temp is fixed*/
RUN;

/** Question 4: Now suppose the chemist is interested in studying the trend relationship 
between the metabolic quotient and temperature used to create the charcoal. Obtain a 
scatter plot. What is the order of the response curve you would suggest, based on the 
scatter plot?
**/
PROC SGPLOT data=charcoal;
   TITLE 'Linear Regression';
   REG y=Y x=Temp;
RUN;

PROC SGPLOT data=charcoal;
   TITLE 'Quadratic Regression';
   REG y=Y x=Temp /degree = 2;
   SCATTER y=Y x=Temp;
RUN;

PROC SGPLOT data=charcoal;
   TITLE 'Cubic Regression';
   REG y=Y x=Temp /degree = 3;
   SCATTER y=Y x=Temp;
RUN;

/**Question 6: Fit a cubic polynomial regression model using the least square estimates**/
data charcoal_cubic;
SET charcoal;
Temp2 = Temp**2;
Temp3 = Temp**3;
RUN;
PROC MIXED data = charcoal_cubic method = type3;
MODEL Y = Temp Temp2 Temp3 / solution; /*Temp is fixed*/
RUN;

/*LS Mean estimates, i.e. treatment means*/
proc glm data=charcoal;
 class Temp;
 model Y = Temp;
 contrast 'cubic' density -1 3 -3 1;
 lsmeans Temp;
run;

/**Question 8: Verify the cubic orthogonal contrast (-1,3,-3,1)**/
PROC SUMMARY DATA = charcoal;
class Temp;
VAR Y;
output out=charcoalSummary mean=Mean stderr=SE;
run;

PROC PRINT data=charcoalSummary;
title 'Summary statistics for charcoal data';
run;

/**Question 9: Fit the highest polynomial model using the orthogonal contrasts 
coefficients for the metabolic quotient study. Discuss the results and decide 
on the order of the polynomial that we should proceed the analysis with**/
proc iml;
 x={450 550 650 750}; 
 xpoly=orpol(x,3); /* the '4' is the df for the quantitative factor */
 Temp=x`; new=Temp || xpoly;
 create out1 from new[colname={"Temp" "Tempp0" "Tempp1" "Tempp2" "Tempp3"}];
 append from new; close out1; 
quit;
proc print data=out1; 
run;

/*Setting up the appropriate data frames*/
proc sort data=charcoal; 
 by Temp; 
run;
data ortho_poly; merge out1 charcoal; 
 by Temp; 
run;
/*Model using the orthogonal polynomial coefficients from IML*/
proc mixed data=ortho_poly method=type1;
 class;
 model Y = Tempp1 Tempp2 Tempp3 / solution;
 title 'Using Orthogonal Coefficients from IML';
run;
/**We can clearly see the cubios polynomial is the most appropriate 
as the model is heirarchical**/
