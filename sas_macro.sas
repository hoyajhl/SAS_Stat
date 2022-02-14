%LET BASE_DATE = '201912'; %PUT &BASE_DATE.; /* '201912' put�̿�:  (������)���� */

/* CALL SYMPUT ���*/ 
DATA _NULL_; 
CALL SYMPUT('VALUE','����'); /*��ũ�κ��� 'VALUE'�� ����� �� ���� ���̷� ����*/
RUN;  
%PUT &=VALUE;   /*��ũ�κ��� VALUE�� ���� Ȯ��*/
DATA _NULL_; 
SET SASHELP.CLASS; 
CALL SYMPUT(NAME,AGE); /*��ũ�κ��� ��� Į��: NAME, ��ũ�κ����� ���� ���� Į��AGE ���� ��ũ�� ��������� ����*/
RUN;    
%PUT &=��������; /*��ũ�κ��� ���������� ����� Ȯ��*/
%PUT &=��;  /*��ũ�κ��� ���� ������� Ȯ��/

/*SQL, SAS MACRO ����*/
PROC SQL; 
	SELECT COUNT(NAME) INTO: CNT    /*Į��NAME�� ������ ��ũ�κ��� CNT�� ����*/
	FROM SASHELP.CLASS;   
QUIT;   
%PUT &=CNT; *��ũ�κ��� CNT�� ������� Ȯ��;

/*��ũ�� ���� Ȱ�� 1*/
 %MACRO TEST; /*��ũ��TEST�� ����*/
PROC SQL;
	CREATE TABLE TEST_1 AS
	SELECT *
	FROM SASHELP.CLASS;
QUIT;  
%MEND;  
%TEST;  

/*��ũ�� ���� Ȱ�� 2; ��ũ��+��ũ�� ���� Ȱ��*/
%MACRO TEST2(CUT); /*��ũ��TEST2�� ����, CUT�̶�� ��ũ�� ������ �Բ� ����*/
PROC SQL;
	CREATE TABLE TEST_2 AS
	SELECT *
	FROM SASHELP.CLASS
	WHERE AGE=&CUT.; *Į��AGE�� ���� &CUT.�� ���� ������ �ุ ����;
QUIT;   
%MEND;  
%TEST2(11); *��ũ�� ���� cut�� 11�� ����;


/*��ũ�� ���� Ȱ�� 3; ��ũ�� ���� Ȱ��*/
%MACRO TEST3(CUT, CUT2); /*��ũ��TEST3�� ������ CUT�� CUT2��� ��ũ�κ����� �Բ� ����*/
PROC SQL;
	CREATE TABLE TEST_3 AS
	SELECT *
	FROM SASHELP.CLASS
	WHERE AGE>&CUT. AND SEX=&CUT2.; *�ش� MACRO���� ����;
QUIT;   
%MEND; 
%TEST3(12,'��'); 


/*��ũ���� �ڵ�ȭ %DO ~ %TO*/
%MACRO TEST(CUT,CUT2);  /*��ũ��TEST�� ����, ��ũ�κ���CUT��  ����*/
%DO n=&CUT. %TO 15;    /*��ũ�ο� DO��ɾ�-> ��ũ�� ���� n�� ����, n�� &CUT.���� 15���� ����*/  
PROC SQL;
	CREATE TABLE TEST_&n. AS    /*��ũ�κ��� n �� ������� ���̺�TEST_13, TEST_14, TEST_15�� ����*/
	SELECT *
	FROM SASHELP.CLASS
	WHERE AGE=&CUT. AND SEX=&CUT2. ;
QUIT;
%END; 
%MEND;  
%TEST(13,'��');  

/*��ũ�� ���� Ȱ�� 3; ��ũ�� ���� Ȱ��*/
%MACRO TEST3(CUT, CUT2); /*��ũ��TEST3�� ������ CUT�� CUT2��� ��ũ�κ����� �Բ� ����*/
PROC SQL;
	CREATE TABLE TEST_3 AS
	SELECT *
	FROM SASHELP.CLASS
	WHERE AGE>&CUT. AND SEX=&CUT2.; *�ش� MACRO���� ����;
QUIT;   
%MEND; 
%TEST3(12,'��'); 

/* DO UNTIL */ DATA TEMP; 
SUM_I = 0; DO UNTIL(SUM_I >= 10); 
SUM_I=SUM_I+1; OUTPUT; END; RUN;  *10���� ��;
/* DO WHILE */ DATA TEMP; SUM_I = 0; DO WHILE(SUM_I < 10);
SUM_I=SUM_I+1; OUTPUT; END; RUN; *10���� ��;
*������ ����: DO UNTIL�� ��ȣ �ȿ� �ݺ��� ����Ǵ� ������ �Է��ϰ� DO WHILE���� ��ȣ�ȿ� �ݺ��� ���ӵǴ� ������ �Է�;

/*scan �Լ� Ȱ��*/
data SCAN;
     arg  = 'ABC.DEF(X=Y)';
     word = scan(arg,3);    *X=Y, 3��° �����ڷ� ����; 
     put word;
     word1 = scan(arg,-3); *ABC;
     put word1;
	 word2 = scan(arg,2);  *DEF;
	 put word2;
run;

*macro ���� part;
%MACRO LOOP(VAR_LIST);
%LET i=1; /* �ݺ��� ���� */
%DO %UNTIL ( %SCAN ( &VAR_LIST. , &i. ) = %STR( ) );  *var_list: list���� �ش��ϴ� i��° var ����;
%LET VAR_NAME = %SCAN ( &VAR_LIST. , &i. ) ;  *i��° var �����ؼ� ��ũ�� ����(VAR_NAME)���� ����;
/*�ݺ� ����*/ 
PROC SQL ;
	CREATE TABLE &VAR_NAME. AS SELECT "&VAR_NAME." AS VAR_NAME , SUM( TARGET = 0 ) AS normal_dt,SUM(TARGET = 1 ) AS abnormal_dt 
	FROM jh.data
	GROUP BY 1;
QUIT ; 
%LET i= %EVAL(&i.+1); /* EVAL() : ������ ���� �Լ� */ 
%END; 
DATA VAR_TOT ; SET &VAR_LIST. ;RUN; /* ���� ���̺� �̾� ���̱� */ 
PROC DELETE DATA = &VAR_LIST. ;RUN; /* ���� ���̺� ���� */ 
%MEND loop; 
/* ��ũ�� ȣ�� */ 
%LET VAR_LIST = col1 col2 col3 col4 col5 ; 
%LOOP(&VAR_LIST.);

*IF then DO, else DO statement;
%macro choice(status);
 data fees;
 set sasuser.all;
 %if &status=PAID %then %do;
 where paid='Y';
 keep student_name course_code begin_date totalfee;
 %end;
 %else %do;
 where paid='N';
 keep student_name course_code begin_date totalfee latechg;
 latechg=fee*0.1;
 %end;
 /* add local surcharge */
 if location='Boston' then totalfee=fee*1.06;
 else if location='Seattle' then totalfee=fee*1.025;
 else if location='Dallas' then totalfee=fee*1.05;
 run;
%mend choice;

options mprint mlogic;
%choice(PAID)


%macro hex(start=1,stop=10,incr=1);
 %local i;
 data _null_;
 %do i=&start %to &stop %by &incr;
 value=&i;
 put "Hexadecimal form of &i is " value hex6.;
 %end;
 run;
%mend hex;

options mprint mlogic;
%hex(start=20,stop=30,incr=2)

%macro figureit(a,b);
 %let y=%sysevalf(&a+&b);
 %put The result with SYSEVALF is: &y;
 %put BOOLEAN conversion: %sysevalf(&a +&b, boolean); *boolean;
 %put CEIL conversion: %sysevalf(&a +&b, ceil);  *ceil: �ø�;
 %put FLOOR conversion: %sysevalf(&a +&b, floor); *floor: ����;
 %put INTEGER conversion: %sysevalf(&a +&b, integer); *���� �κ�;
 %mend figureit;
%figureit(100,1.59)

*** macro ����  Ȯ��;
proc catalog cat=work.sasmacr;
contents;
title "Default Storage of SAS Macros";
quit;

%macro prtlast;
 %if &syslast ne _NULL_ %then %do;
 proc print data=&syslast(obs=5);
 title "Listing of &syslast data set";
 run;%end
 %else %put No data set has been created yet.;
%mend;

