/****/
Data diet;
INFILE datalines dlm = "," dsd;
INPUT id gender $ age height diettype $ initialweight finalweight;
weightloss = initialweight - finalweight;
DATALINES;
1,"Female",22,159,"A",58,54.2
2,"Female",46,192,"A",60,54
3,"Female",55,170,"A",64,63.3
4,"Female",33,171,"A",64,61.1
5,"Female",50,170,"A",65,62.2
6,"Female",50,201,"A",66,64
7,"Female",37,174,"A",67,65
8,"Female",28,176,"A",69,60.5
9,"Female",28,165,"A",70,68.1
10,"Female",45,165,"A",70,66.9
11,"Female",60,173,"A",72,70.5
12,"Female",48,156,"A",72,69
13,"Female",41,163,"A",72,68.4
14,"Female",37,167,"A",82,81.1
27,"Female",44,174,"B",58,60.1
28,"Female",37,172,"B",58,56
29,"Female",41,165,"B",59,57.3
30,"Female",43,171,"B",61,56.7
31,"Female",20,169,"B",62,55
32,"Female",51,174,"B",63,62.4
33,"Female",31,163,"B",63,60.3
34,"Female",54,173,"B",63,59.4
35,"Female",50,166,"B",65,62
36,"Female",48,163,"B",66,64
37,"Female",16,165,"B",68,63.8
38,"Female",37,167,"B",68,63.3
39,"Female",30,161,"B",76,72.7
40,"Female",29,169,"B",77,77.5
52,"Female",51,165,"C",60,53
53,"Female",35,169,"C",62,56.4
54,"Female",21,159,"C",64,60.6
55,"Female",22,169,"C",65,58.2
56,"Female",36,160,"C",66,58.2
57,"Female",20,169,"C",67,61.6
58,"Female",35,163,"C",67,60.2
59,"Female",45,155,"C",69,61.8
60,"Female",58,141,"C",70,63
61,"Female",37,170,"C",70,62.7
62,"Female",31,170,"C",72,71.1
63,"Female",35,171,"C",72,64.4
64,"Female",56,171,"C",73,68.9
65,"Female",48,153,"C",75,68.7
66,"Female",41,157,"C",76,71
15,"Male",39,168,"A",71,71.6
16,"Male",31,158,"A",72,70.9
17,"Male",40,173,"A",74,69.5
18,"Male",50,160,"A",78,73.9
19,"Male",43,162,"A",80,71
20,"Male",25,165,"A",80,77.6
21,"Male",52,177,"A",83,79.1
22,"Male",42,166,"A",85,81.5
23,"Male",39,166,"A",87,81.9
24,"Male",40,190,"A",88,84.5
41,"Male",51,191,"B",71,66.8
42,"Male",38,199,"B",75,72.6
43,"Male",54,196,"B",75,69.2
44,"Male",33,190,"B",76,72.5
45,"Male",45,160,"B",78,72.7
46,"Male",37,194,"B",78,76.3
47,"Male",44,163,"B",79,73.6
48,"Male",40,171,"B",79,72.9
49,"Male",37,198,"B",79,71.1
50,"Male",39,180,"B",80,81.4
51,"Male",31,182,"B",80,75.7
67,"Male",36,155,"C",71,68.5
68,"Male",47,179,"C",73,72.1
69,"Male",29,166,"C",76,72.5
70,"Male",37,173,"C",78,77.5
71,"Male",31,177,"C",78,75.2
72,"Male",26,179,"C",78,69.4
73,"Male",40,179,"C",79,74.5
74,"Male",35,183,"C",83,80.2
75,"Male",49,177,"C",84,79.9
76,"Male",28,164,"C",85,79.7
77,"Male",40,167,"C",87,77.8
78,"Male",51,175,"C",88,81.9
;
RUN;
/*Print Raw Data*/
PROC PRINT data = diet;
RUN;

/*Print Summary data*/
PROC REPORT data = diet NOWINDOWS HEADLINE SPLIT="*";
    TITLE 'Diet Summary';
	COLUMN gender n age height;
	DEFINE gender / group 'Gender';
	DEFINE n / 'Number of*Participants' width = 12;
	DEFINE age / mean 'Average Age';
	DEFINE height / mean 'Average Height';
RUN;

/*******EDA********/
/*Boxplot: weight by gender*/
PROC SGPLOT DATA = diet;
	yaxis label="Initial Weight";
	xaxis label="Participant Gender";
	title h=1 "Distribution of Initial Weight per Gender";
   	VBOX initialweight / category = gender;
RUN; 

/*Hist: weightloss by diet*/
proc univariate data=diet;
  class diettype;
  var weightloss;      /* computes descriptive statisitcs */
  histogram weightloss / nrows=3 odstitle="Weight Loss by Diet Type";
  ods select histogram; /* display on the histograms */
run;

/*Hist: weightloss by diet*/
proc univariate data=diet;
  class diettype;
  var weightloss;      /* computes descriptive statisitcs */
  Title "Distribution of Weight Loss per Diet Type";
  histogram weightloss / kernel overlay;
run;

PROC SGPANEL data=diet;    
panelby diettype / rows=1 columns=3 ;
vbox weightloss / category= gender;
Title "Weight Loss per Diet Type";
RUN;

PROC CORR data=diet plots=matrix(histogram);
    VAR age height weightloss;
RUN;
/************/

/******Modeling******/
/**gender diettype and interaction Model**/
PROC MIXED data=diet method=type3 plots=all;
class gender diettype;
model weightloss = gender diettype gender*diettype;
STORE diet1;
RUN;

/**MEGA Model: not significant**/
PROC MIXED data=diet method=type3;
class gender diettype;
model weightloss = gender diettype gender*diettype;
RANDOM age height age*diettype height*diettype gender*age*diettype gender*height*diettype age*height*diettype gender*age*height*diettype;
RUN;

/*Tukey Comparison*/
PROC PLM restore=diet1; 
lsmeans gender*diettype / adjust=tukey plot=meanplot cl lines; 
RUN;


