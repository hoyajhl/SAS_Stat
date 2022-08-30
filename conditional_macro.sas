# macro conditional processing 
%macro dv(name=,path=);
libname &name &path; run;
%mend;

%dv(name=jh,path='C:/Hoya/github/sas')

%macro sm(c=,r=,op=,byvar=,tvar=,avar1=,avar2=);
%if &c=s %then %do;
proc sort data=&r out=&op;
by &byvar;run;
%end;

%else %if $c=f %then %do;
proc freq data=&op;
table &tvar;
by &byvar;run;
%end;

%else %if &c=m %then %do;
proc means data=&op;
by &byvar;
var &avar1 &avar2;
run;
%end;
%mend; 

%sm(c=m,r=sashelp.class,op=class,byvar=sex,tvar=age,avar1=height,avar2=weight)