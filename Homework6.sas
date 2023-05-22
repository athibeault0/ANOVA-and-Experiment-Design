DATA gas;
input Driver Car Rep MPG;
DATALINES;
1 1 1 25.3
1 1 2 25.2
1 2 1 28.9
1 2 2 30
1 3 1 24.8
1 3 2 25.1
1 4 1 28.4
1 4 2 27.9
1 5 1 27.1
1 5 2 26.6
2 1 1 33.6
2 1 2 32.9
2 2 1 36.7
2 2 2 36.5
2 3 1 31.7
2 3 2 31.9
2 4 1 35.6
2 4 2 35
2 5 1 33.7
2 5 2 33.9
3 1 1 27.7
3 1 2 28.5
3 2 1 30.7
3 2 2 30.4
3 3 1 26.9
3 3 2 26.3
3 4 1 29.7
3 4 2 30.2
3 5 1 29.2
3 5 2 28.9
4 1 1 29.2
4 1 2 29.3
4 2 1 32.4
4 2 2 32.4
4 3 1 27.7
4 3 2 28.9
4 4 1 31.8
4 4 2 30.7
4 5 1 30.3
4 5 2 29.9
;
RUN;

/**Question 4: Full Model for Two Factor Crossed Random Effects**/
PROC MIXED data=gas covtest method=type3 alpha = 0.05;
CLASS Driver Car;
MODEL MPG =;
RANDOM Driver Car Driver*Car;
RUN;

/**Question 7: Reduced/ Additive Model for Two Factor Random Effects**/
PROC MIXED data=gas covtest method=type3 alpha = 0.05;
CLASS Driver Car;
MODEL MPG = / solution cl alpha = 0.05;
RANDOM Driver Car;
RUN;

/**Question 14: Additive Model for Two Factor Effects**/
PROC MIXED data=gas method=type3 alpha = 0.05;
CLASS Driver Car;
MODEL MPG = Driver;
RANDOM Car;
STORE gasout;
RUN;
/**Question 18: Bonferroni Correction**/
PROC PLM restore=gasout; 
estimate 'Compare young to old drivers' Driver 1 1 -1 -1, 
	'Compare female to male' Driver 1 -1 -1 1/adjust=bon alpha=0.1;
RUN;

/**Question 20: Mixed Model, Driver = Fixed, Car = Random**/
PROC MIXED data=gas method=type3 alpha = 0.05;
CLASS Driver Car;
MODEL MPG = Driver Car(Driver)/ solution cl alpha = 0.05;
STORE gasout2;
RUN;

/**Question 22: Tukey**/
proc plm restore=gasout2; 
 lsmeans Driver / adjust=tukey plot=meanplot cl lines alpha=0.01; 
run;
