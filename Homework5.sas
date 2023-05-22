DATA assembly;
input Machine Config Power Time;
DATALINES;
1 1 1 10.2
1 1 1 13.1
1 1 2 16.2
1 1 2 16.9
1 2 1 4.2
1 2 1 5.2
1 2 2 8.0
1 2 2 9.1
2 1 1 12.0
2 1 1 13.5
2 1 2 12.6
2 1 2 14.6
2 2 1 4.1
2 2 1 6.1
2 2 2 4.0
2 2 2 6.1
3 1 1 13.1
3 1 1 12.9
3 1 2 12.9
3 1 2 13.7
3 2 1 4.1
3 2 1 6.1
3 2 2 2.2
3 2 2 3.8
;
RUN;
PROC PRINT data = assembly;
RUN;
/**Question 5**/
PROC MIXED data=assembly method=type3;
CLASS Machine Config Power;
MODEL Time = Machine Config Power Machine*Config Machine*Power Config*Power Machine*Config*Power;
STORE out2way;
RUN;
/**Question 7**/
PROC MIXED data=assembly method=type3 plots=all;
CLASS Machine Config Power;
MODEL Time = Machine Config Power Machine*Power;
STORE out2way2;
RUN;
/*F Critical Value*/
DATA Fvalue;                                                                                                                               
   q=finv(0.95, 5, 12);                                                                                                                   
   put q=;                                                                                                                           
RUN;
PROC PRINT data=Fvalue;
RUN;
/**Question 8 - How to get residual plots**/
PROC MIXED data=assembly method=type3 plots=all;
CLASS Machine Config Power;
MODEL Time = Machine Power Machine*Power;
STORE out2way2;
RUN;
/***************/
/**Question 15**/
PROC MIXED data=assembly method=type3 plots=all;
CLASS Machine Config Power;
MODEL Time = Machine Config(Machine) Power Machine*Power Config*Power; *the config(Machine) is nested;
STORE out2way3;
RUN;
/***************/
/**Question 16**/
PROC MIXED data=assembly method=type3;
CLASS Machine Config Power;
MODEL Time = Machine Config(Machine) Power Machine*Power;
STORE out2way4;
RUN;
/*F Critical Value*/
DATA Fvalue;                                                                                                                               
   q=finv(0.95, 3, 14);                                                                                                                   
   put q=;                                                                                                                           
RUN;
PROC PRINT data=Fvalue;
RUN;
/***************/

ods graphics on;
proc plm restore=out2way4;
lsmeans Machine*Power / adjust=tukey plot=meanplot cl lines;
run;
