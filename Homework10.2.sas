/**
A graduate student hypothesized that a person's profession has an influence on their 
efficiency with chopsticks. To test this, he planned an experiment in which he measured 
the chopstick efficiency of 10 subjects (by counting how many peanuts they could pick up 
within a specific time span) all from different professions. 
**/
DATA chopstick;
INFILE datalines dlm="," dsd;
INPUT Efficiency Length Profession;
DATALINES;
19.55,180,1
27.24,180,2
28.76,180,3
20.19,180,4
21.91,180,5
27.62,180,6
29.46,180,7
26.35,180,8
26.69,180,9
30.22,180,10
23.53,210,1
26.39,210,2
30.90,210,3
26.05,210,4
23.27,210,5
29.17,210,6
30.93,210,7
23.55,210,8
32.55,210,9
28.87,210,10
31.34,240,1
29.94,240,2
32.95,240,3
29.40,240,4
32.32,240,5
28.36,240,6
28.49,240,7
32.24,240,8
36.15,240,9
30.62,240,10
24.40,270,1
25.88,270,2
27.97,270,3
24.54,270,4
22.66,270,5
28.94,270,6
30.72,270,7
26.70,270,8
30.27,270,9
26.29,270,10
22.50,300,1
23.10,300,2
28.26,300,3
25.55,300,4
26.71,300,5
27.88,300,6
21.07,300,7
23.44,300,8
28.82,300,9
27.77,300,10
21.32,330,1
26.18,330,2
25.93,330,3
28.61,330,4
20.54,330,5
26.44,330,6
29.36,330,7
19.77,330,8
21.69,330,9
24.64,330,10
;
RUN;

PROC PRINT data = chopstick;
RUN;

/**New data set with quadratic terms**/
data chopstick2; 
  set chopstick;
  Length2 = Length**2;
run;

PROC PRINT data = chopstick2;
RUN;

/**Question 10's model**/
proc mixed data=chopstick2 method=type1;
class Profession;
model Efficiency = Profession Length Length2 Length*Profession Length2*Profession;
run;

/**Question 13: Fit a reduced polynomial model**/
proc mixed data=chopstick2 method=type1;
class Profession;
model Efficiency = Profession Length Length2 / solution;
STORE OUT = out2;
run;

/**Question 14: What is the estimated difference in efficiency for Profession 
9 vs Profession 1 when the chopstick length is 210 (and length2 is 44100)**/
PROC PLM restore=out2; 
 lsmeans Profession / pdiff at Length=210 pdiff at Length2=44100 adjust=tukey plot=meanplot cl lines alpha=0.05; 
RUN;

/**Question 15: What is the 95% confidence interval for the estimated efficiency 
for Profession 5 when the length is 240 (specifying length2 as well)**/
PROC PLM restore=out2; 
 lsmeans Profession / pdiff at Length=240 pdiff at Length2=57600 adjust=tukey plot=meanplot cl lines alpha=0.05; 
RUN;
