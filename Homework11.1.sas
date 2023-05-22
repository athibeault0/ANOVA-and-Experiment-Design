/**Experimenters were interested in the relative CO2 exchange (change in C02/plant fresh mass) for plants 
under two conditions. Three plants were randomly assigned to the conditions, then were measured at 4 time 
points.**/
Data co2;
INFILE datalines dlm="," dsd;
INPUT trt plant period co2exchange;
DATALINES;
1,1,1,-3.4
1,2,1,-4.4
1,3,1,-3.4
2,4,1,-3.2
2,5,1,-3.5
2,6,1,-3.9
1,1,2,-2.7
1,2,2,-3.2
1,3,2,-1
2,4,2,-3.4
2,5,2,-3.6
2,6,2,-4.4
1,1,3,-2.9
1,2,3,-3.5
1,3,3,-2.2
2,4,3,-2.4
2,5,3,-2.7
2,6,3,-2.4
1,1,4,-2.5
1,2,4,-3.2
1,3,4,-1.6
2,4,4,-1.6
2,5,4,-1.3
2,6,4,-1.6
;
RUN;

/**Question 3: Apply the model (using "type=VC") and submit the output illustrating the tests for fixed 
effects.**/
PROC MIXED DATA=co2;
CLASS trt plant period;
MODEL co2exchange = trt period trt*period / ddfm=kr solution ;
REPEATED /SUBJECT = plant(trt) type=VC rcorr; /*subject= specifies what experimental units the repeated measures are made on*/
TITLE 'Repeated Measures';
RUN; 
TITLE; /*This resets the title*/

/**Question 4: Assuming the correlations of errors within a plant are zero is equivalent to assuming the 
period observations are replicates with no relationship to one another. Verify.**/
PROC MIXED DATA=co2 METHOD=type3;
CLASS trt plant period;
MODEL co2exchange = trt period trt*period / ddfm=kr solution outpm=outmixed;
TITLE 'Repeated Measures';
RUN; 
TITLE;

/**Question 5: **/
PROC MIXED DATA=co2;
CLASS trt plant period;
MODEL co2exchange = trt period trt*period / ddfm=kr;
REPEATED period/SUBJECT=plant(trt) type=cs rcorr;
ods output FitStatistics=FitCS (rename=(value=CS))
FitStatistics=FitCSp;
title 'Compound Symmetry'; run;
title ' '; run;

proc mixed data=co2;
class trt plant period;
model co2exchange = trt period trt*period / ddfm=kr;
repeated period/subject=plant(trt) type=ar(1) rcorr;
ods output FitStatistics=FitAR1 (rename=(value=AR1))
FitStatistics=FitAR1p;
title 'Autoregressive Lag 1'; run;
title ' '; run;

proc mixed data=co2;
class trt plant period;
model co2exchange = trt period trt*period / ddfm=kr;
repeated period/subject=plant(trt) type=un rcorr;
ods output FitStatistics=FitUN (rename=(value=UN))
FitStatistics=FitUNp;
title 'Unstructured'; run;
title ' '; run;

proc mixed data=co2;
class trt plant period;
model co2exchange = trt period trt*period / ddfm=kr;
repeated period/subject=plant(trt) type=vc rcorr;
ods output FitStatistics=FitVC (rename=(value=VC))
FitStatistics=FitVCp;
title 'VC'; run;
title ' '; run;

data fits;
merge FitCS FitAR1 FitUN FitVC;
by descr;
run;
ods listing; proc print data=fits; 
run;

/**Question 6: Using the AICC as your criteria, run the repeated measure ANOVA model with the optimal covariance structure**/
PROC MIXED DATA=co2;
CLASS trt plant period;
MODEL co2exchange = trt period trt*period / ddfm=kr solution ;
REPEATED /SUBJECT = plant(trt) type=CS rcorr; /*subject= specifies what experimental units the repeated measures are made on*/
TITLE 'Repeated Measures';
RUN;
