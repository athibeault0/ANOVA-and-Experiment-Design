data tirebrands;
input brand $ mileage ic1 ic2 ic3 ec1 ec2 ec3;
        /* ic=indicator coding ec=effect coding */
datalines;
Apollo    32.998      1      0      0      1      0      0
Apollo    36.435      1      0      0      1      0      0
Apollo    32.777      1      0      0      1      0      0
Apollo    37.637      1      0      0      1      0      0
Apollo    36.304      1      0      0      1      0      0
Bridgestone    33.523      0      1      0      0      1      0
Bridgestone    31.995      0      1      0      0      1      0
Bridgestone    35.006      0      1      0      0      1      0
Bridgestone    27.879      0      1      0      0      1      0
Bridgestone    31.297      0      1      0      0      1      0
CEAT    34.4456498808749      0      0      1      0      0      1
CEAT    32.8065811516262      0      0      1      0      0      1
CEAT    33.4149893917138      0      0      1      0      0      1
CEAT    36.8611766884671      0      0      1      0      0      1
CEAT    36.9727672389126      0      0      1      0      0      1
Falken    39.596      0      0      0      -1      -1      -1
Falken    38.937      0      0      0      -1      -1      -1
Falken    36.124      0      0      0      -1      -1      -1
Falken    37.695      0      0      0      -1      -1      -1
Falken    36.586      0      0      0      -1      -1      -1
;
run;
PROC PRINT data = tirebrands;
RUN;
/**Question 2, 3**/
PROC SUMMARY DATA = tirebrands;
class brand;
VAR mileage;
output out=output1 mean=Mean stderr=SE;
run;
PROC PRINT data=output1;
title 'Summary Output for TIREBRANDS';
RUN;
/**Question 4**/
/*cell means model*/        
proc mixed data=tirebrands method=type3;
  class brand;
  model mileage = brand /noint solution;
  ods select Type3 SolutionF;
  title 'Cell Means Model';
run;
/**Question 5**/
 /*overall mean model*/        
proc mixed data=tirebrands method=type3;
  model mileage = / solution;
  ods select Type3 SolutionF;
  title 'Overall Mean Model';
run;
/**Question 6**/
/*Regular ANOVA model*/
proc mixed data=tirebrands method=type3;
   class brand;
   model mileage = brand / solution;
   lsmeans brand;
   ods select Type3 SolutionF;
   title 'Regular ANOVA Model';
run;
PROC PRINT data =tirebrands;
VAR brand mileage;
SUM mileage;
RUN;
/**Question 8**/
proc reg data=tirebrands;
 model mileage =ic1 ic2 ic3;
 ods select ANOVA FitStatistics ParameterEstimates;
 title 'Indicator Coding';        
run;
/**Question 9**/
proc reg data=tirebrands;
 model mileage =ic1 ic2 ic3;
 ods select ANOVA FitStatistics ParameterEstimates;
 title 'Indicator Coding';        
run;
