data HW1;
   infile datalines delimiter=','; 
   input state $ rice;
   datalines;
AR,4.8
AR,5.0
AR,5.4
AR,5.6
AR,5.6
AR,6.0
CA,1.5
CA,4.0
CA,4.9
CA,5.3
CA,5.4
CA,5.6
TX,5.6
TX,6.6
TX,6.9
TX,7.1
TX,7.5
TX,7.7
;
   PROC MEANS DATA = HW1 mean;
class state;
VAR rice;
run;
PROC MEANS DATA = HW1 var;
class state;
VAR rice;
run;
PROC MEANS DATA = HW1 std;
class state;
VAR rice;
run;
PROC SUMMARY DATA = HW1;
class state;
VAR rice;
output out=stateSummary mean=Mean stderr=SE;
run;

PROC PRINT data=stateSummary;
title 'Summary statistics for Rice data';
run;
PROC SGPLOT  DATA = HW1;
	yaxis label="Arsenic Levels";
	xaxis label="Location";
	title h=1 "Distribution of Arsenic Levels by Location";
   	VBOX rice / category = state;
RUN; 
