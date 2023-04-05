DATA gas;
INPUT Insulation $ AvgOutTemp GasConsumption;
DATALINES;
Before -0.8 7.2
Before 0.4 6.4
Before 2.9 5.8
Before 3.6 5.6
Before 4.2 5.8
Before 5.4 4.9
Before 6.0 4.3
Before 6.2 4.5
Before 6.9 3.7
Before 7.4 4.2
Before 7.5 3.9
Before 8.0 4.0
Before 9.1 3.1
After -0.7 4.8
After 1.0 4.7
After 1.5 4.2
After 2.3 4.1
After 2.5 3.5
After 3.9 3.9
After 4.0 3.7
After 4.3 3.5
After 4.7 3.5
After 4.9 3.7
After 5.0 3.6
After 6.2 2.8
After 7.2 2.8
After 8.0 2.7
After 8.8 1.3
;
RUN;

/**Question 6: Test the insulation (fixed) saved on the average gas consumption**/
PROC MIXED data = gas method = type3;
CLASS Insulation;
MODEL GasConsumption = Insulation; /*ignoring potential associations*/
STORE gasout;
RUN;

/**Question 7: Plot gas consumption against the average outside temperature for before/ after insulation**/
ods graphics on;
PROC SGPLOT data=gas;
   styleattrs datalinepatterns=(solid);
   reg y=AvgOutTemp x=GasConsumption / group=Insulation;
RUN;
/**Initially, we can see AvgOutTemp by GasConsumption grouped by the Insulation status.
As expected, we can see the relationship for both Insulation groups that as the AvgOutTemp decreases, GasConsumption increases (colder outside means you would likely need to use more energy to heat your home).
We do see a noticeable difference in trends for the Insulation groups. Clearly, after insulation was installed, it reduced the amount of gas consumed at all average outside temperatures. We can also see that the slopes of the two insulation treatment levels do appear to be equal as the lines for each group are roughly parallel.**/

/**Question 8: Model under the assumption the avg outside temperature is the same before/ after insulation**/
PROC MIXED data = gas method = type3;
CLASS Insulation;
MODEL GasConsumption = Insulation;
RANDOM AvgOutTemp;
STORE gasout1;
RUN;

/**Question 10: LS Estimates**/
PROC MIXED data=gas;
CLASS Insulation;
MODEL GasConsumption = Insulation AvgOutTemp/ noint solution;
ODS SELECT SolutionF;
TITLE 'Equal Slopes Model';
RUN;

/**Question 12: 90% CI for the adjusted treatment mean difference for before and after insulation**/
PROC PLM restore=gasout1; 
 lsmeans Insulation / adjust=tukey plot=meanplot cl lines alpha=0.1; 
RUN;
/*using the Differences of Insulation Least Squares Means table*/

/**Question 13: **/
PROC MIXED data = gas method = type3;
CLASS Insulation;
MODEL GasConsumption = Insulation;
RANDOM AvgOutTemp;
STORE gasout2;
RUN;

/**Question 13: **/
PROC MIXED data = gas method = type3;
CLASS Insulation;
MODEL GasConsumption = Insulation;
RANDOM AvgOutTemp Insulation*AvgOutTemp;
STORE gasout3;
RUN;

/**Question 15: Model Diagnostics**/
PROC MIXED data=gas method=type3 plots=all;
CLASS Insulation;
MODEL GasConsumption = Insulation AvgOutTemp Insulation*AvgOutTemp / noint solution;
STORE gasout4;
RUN;

/**Question 17: 90% CIs for the estimated difference in average gas consumption for before and after insulation when the average outside temperature is 15 degrees celsius**/
PROC PLM restore=gasout1; 
 lsmeans Insulation / pdiff at AvgOutTemp=15 adjust=tukey plot=meanplot cl lines alpha=0.1; 
RUN;
/*using the Differences of Insulation Least Squares Means table*/



