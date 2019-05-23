Data Overdoses;
infile "/home/shiggins0/sasuser.v94/Final CDC Cause of Death Data.txt" firstobs=2 DLM='
';
length oldname $ 35 countycode $ 7 cause $ 55 causecode $ 4 quoteyear $ 6 yearcode $ 6  deaths 3 pop 8 cruderate $ 10; 
input oldname countycode cause causecode quoteyear yearcode deaths pop cruderate;
FIPS = dequote(countycode);
name = dequote(oldname);
year = dequote(quoteyear);
Run;



Data Medicare;
Proc Import Out=work.Medicare  datafile = "/home/shiggins0/sasuser.v94/Final Medicare Data.xls" DBMS=XLS replace;
namerow=5;
datarow=6;
Getnames=yes;
sheet="county";
Run;



Data Regions;
Set medicare;

if "state name"n in('Connecticut', 'Maine', 'Massachusetts', 'New Hampshire', 'Rhode Island', 'Vermont', 'New Jersey', 'New York', 'Pennsylvania') then region = "North East";
else if "state name"n in('Illinois', 'Indiana', 'Michigan', 'Ohio', 'Wisconsin', 'Iowa', 'Kansas', 'Minnesota', 'Missouri', 'Nebraska', 'North Dakota', 'South Dakota') then region = "Midwest";
else if "state name"n in('Delaware', 'Florida', 'Georgia', 'Maryland', 'North Carolina', 'South Carolina', 'Virginia', 'West Virginia', 'Alabama', 'Kentucky', 'Mississippi', 'Tennessee', 'Arkansas', 'Louisiana', 'Oklahoma', 'Texas') then region = "South";
else if "state name"n in('Arizona', 'Colorado', 'Idaho', 'Montana', 'Nevada', 'New Mexico', 'Utah', 'Wyoming', 'Alaska', 'California', 'Hawaii', 'Oregon', 'Washington') then region = "West";

proc means sum;
class region;
var 'Opioid Claims'n "Overall Claims"n;
Title "Sum of Opiod Claims and Overall Claims by Region";
run;

data graph;
length newregion$ 10;
input newregion$ avgPrescribingRate;

datalines;
Midwest 0.0598
Northeast 0.042
South 0.0631
West 0.0625
;

proc print;
Title "Prescribing Rates by Region";
run;

proc sgplot data = graph;
needle x = newregion y=avgPrescribingRate;
Title "Average Prescribing Rate by Region";
run;



