DATA cookie;
Input Shortening TrayTemp BakeTemp Batch Diameter;
/**
TrayTemp = low (-1), mid (0), high (1)
BakeTemp = hot (1), roomT (2)
**/
DATALINES;
100 2 -1 1 3.41
100 1 -1 1 3.58
100 2 0 1 3.38
100 1 0 1 3.75
100 2 1 1 3.76
100 1 1 1 3.67
80 2 -1 2 1.68
80 1 -1 2 2.27
80 2 0 2 1.83
80 1 0 2 2.59
80 2 1 2 1.83
80 1 1 2 2.24
100 2 -1 3 3.31
100 1 -1 3 3.44
100 2 0 3 3.37
100 1 0 3 3.56
100 2 1 3 3.59
100 1 1 3 3.34
80 2 -1 4 1.44
80 1 -1 4 1.84
80 2 0 4 1.73
80 1 0 4 2.22
80 2 1 4 1.78
80 1 1 4 2.22
;
RUN;

PROC PRINT data = cookie;
RUN;

/**Question 12: ANOVA Model for Split-Plot in RCBD Randomization**/
PROC MIXED data=cookie method=type3; 
class Batch Shortening BakeTemp TrayTemp;
model Diameter = Shortening TrayTemp Shortening*TrayTemp;
random BakeTemp Shortening*BakeTemp BakeTemp*TrayTemp;
Store cookieout;
RUN;

PROC PLM restore=cookieout; 
 lsmeans Shortening*TrayTemp / adjust=tukey plot=meanplot cl lines alpha=0.05; 
RUN;

/**Question 15**/
PROC PLM restore=cookieout; 
 lsmeans Shortening / adjust=tukey plot=meanplot cl lines alpha=0.05; 
RUN;
