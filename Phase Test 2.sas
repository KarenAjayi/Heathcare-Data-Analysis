filename cwd '/home/u63784063/Data_Mining_Application_and_Techniques/Phase Test';
filename npda '/home/u63784063/Data_Mining_Application_and_Techniques/Phase Test/npda1.csv';
libname Test '/home/u63784063/Data_Mining_Application_and_Techniques/Phase Test';

proc import datafile= npda dbms= CSV out= NPDA replace;
    getnames= no;
run;

data npda;

LENGTH
        Unit        $ 5
		Region      $20
        patients7 	3 
		target7   	8
		patients6 	3
		target6 	8 
		patients5 	3
		target5 	8
		patients4 	3 
		target4 	8
		patients3 	3
		target3		8
		patients2	3
		target2		8
		patients1	3
		target1		8
	;
	
FORMAT 
		Unit        $CHAR5.
		Region      $CHAR20.
        patients7 	Best3. 
		target7   	Best8.
		patients6 	Best3.
		target6 	Best8. 
		patients5 	Best3.
		target5 	Best8.
		patients4 	Best3. 
		target4 	Best8.
		patients3 	Best3.
		target3		Best8.
		patients2	Best3.
		target2		Best8.
		patients1	Best3.
		target1		Best8.
	;
		
INFILE NPDA
        LRECL=200
        TERMSTR=CRLF
        DLM=','
        MISSOVER
        DSD 
		FIRSTOBS=2
	;

INPUT 
		Unit        :  $CHAR5.
		Region      :  $CHAR20.
        patients7 	:	Best3. 
		target7   	:	Best8.
		patients6 	:	Best3.
		target6 	:	Best8. 
		patients5 	:	Best3.
		target5 	:	Best8.
		patients4 	:	Best3. 
		target4 	:	Best8.
		patients3 	:	Best3.
		target3		:	Best8.
		patients2	:	Best3.
		target2		:	Best8.
		patients1	:	Best3.
		target1		:	Best8.
	;

RUN;

proc print data = NPDA (obs = 5);
run;

proc freq data= NPDA (obs = 5);
run;

proc contents data= NPDA;
run;

ods exclude enginehost ;
proc contents data= NPDA varnum ;
run; 
ods exclude none ;

 data PDUNIT;
LENGTH
        Unit        $ 5
		Region      $20
        patients7 	3 
		target7   	8
		patients6 	3
		target6 	8 
		patients5 	3
		target5 	8
		patients4 	3 
		target4 	8
		patients3 	3
		target3		8
		patients2	3
		target2		8
		patients1	3
		target1		8
	;
	
FORMAT 
		Unit        $CHAR5.
		Region      $CHAR20.
        patients7 	Best3. 
		target7   	Best8.
		patients6 	Best3.
		target6 	Best8. 
		patients5 	Best3.
		target5 	Best8.
		patients4 	Best3. 
		target4 	Best8.
		patients3 	Best3.
		target3		Best8.
		patients2	Best3.
		target2		Best8.
		patients1	Best3.
		target1		Best8.
	;
		
INFILE NPDA
        LRECL=200
        TERMSTR=CRLF
        DLM=','
        MISSOVER
        DSD 
		FIRSTOBS=2
	;

INPUT 
		Unit        :  $CHAR5.
		Region      :  $CHAR20.
        patients7 	:	Best3. 
		target7   	:	Best8.
		patients6 	:	Best3.
		target6 	:	Best8. 
		patients5 	:	Best3.
		target5 	:	Best8.
		patients4 	:	Best3. 
		target4 	:	Best8.
		patients3 	:	Best3.
		target3		:	Best8.
		patients2	:	Best3.
		target2		:	Best8.
		patients1	:	Best3.
		target1		:	Best8.
	;
	
 
 label         
 unit= 'PD Unit'         
 region= 'Region'         
 target1= 'HbA1c 2011'         
 target2= 'HbA1c 2012'         
 target3= 'HbA1c 2013'         
 target4= 'HbA1c 2014'         
 target5= 'HbA1c 2015'         
 target6= 'HbA1c 2016'         
 target7= 'HbA1c 2017'         
 patients1= 'Patients 2011'         
 patients2= 'Patients 2012'         
 patients3= 'Patients 2013'         
 patients4= 'Patients 2014'         
 patients5= 'Patients 2015'         
 patients6= 'Patients 2016'         
 patients7= 'Patients 2017'         
 ; 

 run;    
 proc print data= PDUNIT (obs= 5) label ;
  run;  
  
  proc format;
invalue Regiondivide
        'London and South East' = 1
		'South Central' = 1
		'South West' = 1
		'East Midlands' = 2
		'East of England' = 2
        'Wales' = 2
		'West Midlands' = 2
		'Yorkshire and Humber' = 3
		'North East' = 3
		'North West' = 3
		
        other = .
        ;
    value Regiondivide
        . = 'missing'
        1 = 'North'
        2 = 'Middle'
        3 = 'South'
        ;
run;

data PDRegion;
set PDUNIT;
locval = input(Region,Regiondivide.);
format locval Regiondivide.;
run;

proc print data= PDRegion (obs = 5) label;
run;

Data PDRegion_North;
set PDRegion;
if region not in ('East Midlands', 'East of England', 'Wales', 'West Midlands');;
run;

proc print data= PDRegion_North (obs = 5) label;
run;


proc tabulate data=PDRegion;
   class locval;
   var
   patients7
target7
patients6
target6
patients5
target5
patients4
target4
patients3
target3
Patients2
target2
Patients1
target1
;
   table (patients7
target7
patients6
target6
patients5
target5
patients4
target4
patients3
target3
Patients2
target2
Patients1
target1) * locval,
         ( n nmiss min q1 median q3 max mean std);
   format mean std percent8.;
run;

proc ttest data=PDRegion_North;
   class locval ;
  var target6 ;
  run;
 
  proc anova data=PDRegion;
  class locval;
  model  target6= locval;
  run;
  
proc sgscatter data=NPDA;
  plot target1*patients1 / reg=(cli clm) grid;
 run;
 proc sgscatter data=NPDA;
 plot target2*patients2 / reg=(cli clm) grid;
 run;
 proc sgscatter data=NPDA;
  plot target3*patients3 / reg=(cli clm) grid;
  run;
  proc sgscatter data=NPDA;
  plot target4*patients4 / reg=(cli clm) grid;
  run;
  proc sgscatter data=NPDA;
  plot target5*patients5 / reg=(cli clm) grid;
  run;
  proc sgscatter data=NPDA;
  plot target6*patients6 / reg=(cli clm) grid;
  run;
  proc sgscatter data=NPDA;
  plot target7*patients7 / reg=(cli clm) grid;
run;

proc reg data=NPDA;
model target3 = patients3;
run;



proc means data=PDRegion;
class locval;
var target6;
run;

proc univariate
	data = PDRegion;
	var target6;
	qqplot target6 / normal(mu=est sigma=est); 
run;


 

