/*******************************************************************************
PROGRAM:        m_orr.sas  
AUTHOR:         Hengwei Liu
PURPOSE:        calculate proportion with confidence interval, output is in one 
line format proportion (lower limit, upper limit). 
SAS VERSION :   SAS 9.4 in Linux
********************************************************************************
THIS PART MUST BE FILLED IN FOR EVERY MODIFICATION THAT IS MADE
DATE         BY      DESCRIPTION

*******************************************************************************/
%macro m_orr(tagn=, tag=, indata=, classvar=, outdata=, catlabel= , where=, indent=N, cond=%quote(avalc in ('CR','PR')));
	%if &where ne %then
		%do;

			data _&indata;
				set &indata;
				where &where;
			run;

		%end;
	%else
		%do;

			data _&indata;
				set &indata;
			run;

		%end;

	data _&indata;
		set _&indata;

		if &cond then
			cat='0';
		else cat='1';
		run;


	proc sort data=_&indata;
		by &classvar;
	run;

	proc freq data=_&indata;
		by &classvar;

		table cat/out=out1;
	run;

	proc sql noprint;
		create table fram as 
			select distinct &classvar from out1;
			quit;


	data fram;
		set fram;
		cat='0';
		output;
		cat='1';
		output;
	run;

	data out1;
		length countc $15.;
		merge out1 fram;
		by &classvar cat;

		if count<.z then
			count=0;

		%do k=1 %to &tot;
			if &classvar="&&val&k" then
				perc=put(100*count/&&bign&k,5.1);
		%end;

		if count>0 then
			countc=perc;
		else countc='0';
	run;

	proc transpose data=out1 out=out2 prefix=p_;
		var countc;
		id &classvar;
		where cat='0';
	run;

	ods output binomial=bino;

	proc freq data=out1;
		by &classvar;

		table cat/binomial;
			exact binomial;
			weight count/zeroes;
	run;

	data bino1;
		set bino;
		n1c=put(100*nvalue1, 4.1);
		where name1 in ('XL_BIN');
		run;

	data bino2;
		set bino;
		n2c=put(100*nvalue1,4.1);
		where name1 in ('XU_BIN');
		run;

	data bino3;
		merge bino1 bino2;
		by &classvar;
		ci=compbl('('||n1c||', '||n2c||')');
	run;

	proc transpose data=bino3 out=bino4 prefix=c_;
		var ci;
		id &classvar;
		run;


	data &outdata;
		length %do k=1 %to &tot;
		&&val&k
		%end;
		$30. catlabel tag $100.;
		merge out2 bino4;
		tagn=%eval(&tagn);
		tag="&tag";
		indent="&indent";
		catlabel="&catlabel";

		%do k=1 %to &tot;
			&&val&k=strip(p_&&val&k)||' '||strip(c_&&val&k);
		%end;
	run;

%mend;
