/*******************************************************************************

PROGRAM:        m_bign.sas  
AUTHOR:         Hengwei Liu
PURPOSE:        Calculate the big N in table column headers 
SAS VERSION :   SAS 9.4 in Linux
********************************************************************************
THIS PART MUST BE FILLED IN FOR EVERY MODIFICATION THAT IS MADE
DATE         BY      DESCRIPTION

*******************************************************************************/
%macro m_bign(classvar=, inadsl=adsl, where=);
	%if &where ne %then
		%do;

			data _&inadsl;
				set &inadsl;
				where &where;
				run;
		%end;
	%else
		%do;

			data _&inadsl;
				set &inadsl;
				run;
		%end;
			

			%global tot;

			proc sql noprint;
				select count(distinct &classvar) into :tot trimmed from _&inadsl;
				quit; 

				%do k=1 %to &tot;
					%global val&k bign&k;
				%end;
            

			proc sql noprint;
				select distinct &classvar into :val1-:val&tot from _&inadsl;
				select count(distinct usubjid) into :bign1-:bign&tot from _&inadsl group by &classvar;
			quit;

%mend;
