DATA Plast;
INPUT Run Plasticizer Mix @6 Strength;
DATALINES;
1 1 1 42.9
1 1 2 75.4
1 1 3 47.15
1 2 1 45.2
1 2 2 69.8
1 2 3 45.5
1 3 1 44.4
1 3 2 71.6
1 3 3 46
2 1 1 41.6
2 1 2 65.6
2 1 3 41.6
2 2 1 43
2 2 2 65.3
2 2 3 42.15
2 3 1 41.8
2 3 2 69.4
2 3 3 43.6
3 1 1 28.9
3 1 2 54
3 1 3 29.45
3 2 1 30.7
3 2 2 55.5
3 2 3 31.1
3 3 1 28.3
3 3 2 56.6
3 3 3 30.45
;
RUN;

PROC PRINT data = Plast;
RUN;

/**Question 4: ANOVA Model for Split-Plot in RCBD Randomization**/
PROC MIXED data=Plast method=type3; 
class Run Mix Plasticizer;
model Strength = Mix Plasticizer Mix*Plasticizer;
random Run Run*Mix;
Store Plastout;
RUN;

/**Question 8: Tukey Adjusted Pairwise Comparisons for the Mix Factor**/
proc plm restore=Plastout; 
 lsmeans Mix / adjust=tukey plot=meanplot cl lines alpha=0.05; 
run;
