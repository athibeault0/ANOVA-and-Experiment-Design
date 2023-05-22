DATA temp;
input A 1-2 B 3-4 C 5-6 D 7-8;
DATALINES;
09190916
13171014
12140819
10181213
11171318
12150716
07141315
;
RUN;
PROC MEANS data = temp mean;
RUN;
PROC MEANS data = temp std;
RUN;
DATA pvalue;
p=1-PROBF(16.0691,3,24);
put	p=;
RUN;
PROC PRINT data=pvalue;
RUN;
