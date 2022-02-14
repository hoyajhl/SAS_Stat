%LET BASE_DATE = '201912'; %PUT &BASE_DATE.; /* '201912' put이용:  (문자형)으로 */

/* CALL SYMPUT 사용*/ 
DATA _NULL_; 
CALL SYMPUT('VALUE','나이'); /*매크로변수 'VALUE'을 만들고 이 값을 나이로 저장*/
RUN;  
%PUT &=VALUE;   /*매크로변수 VALUE의 값을 확인*/
DATA _NULL_; 
SET SASHELP.CLASS; 
CALL SYMPUT(NAME,AGE); /*매크로변수 대상 칼럼: NAME, 매크로변수와 같은 행의 칼럼AGE 값을 매크로 결과값으로 저장*/
RUN;    
%PUT &=알프레드; /*매크로변수 알프레드의 결과값 확인*/
%PUT &=존;  /*매크로변수 존의 결과값을 확인/

/*SQL, SAS MACRO 연동*/
PROC SQL; 
	SELECT COUNT(NAME) INTO: CNT    /*칼럼NAME의 갯수를 매크로변수 CNT로 생성*/
	FROM SASHELP.CLASS;   
QUIT;   
%PUT &=CNT; *매크로변수 CNT의 결과값을 확인;

/*매크로 문장 활용 1*/
 %MACRO TEST; /*매크로TEST를 생성*/
PROC SQL;
	CREATE TABLE TEST_1 AS
	SELECT *
	FROM SASHELP.CLASS;
QUIT;  
%MEND;  
%TEST;  

/*매크로 문장 활용 2; 매크로+매크로 변수 활용*/
%MACRO TEST2(CUT); /*매크로TEST2를 생성, CUT이라는 매크로 변수도 함께 생성*/
PROC SQL;
	CREATE TABLE TEST_2 AS
	SELECT *
	FROM SASHELP.CLASS
	WHERE AGE=&CUT.; *칼럼AGE의 값이 &CUT.의 값과 동일한 행만 추출;
QUIT;   
%MEND;  
%TEST2(11); *매크로 변수 cut을 11로 설정;


/*매크로 문장 활용 3; 매크로 변수 활용*/
%MACRO TEST3(CUT, CUT2); /*매크로TEST3를 생성과 CUT과 CUT2라는 매크로변수도 함께 생성*/
PROC SQL;
	CREATE TABLE TEST_3 AS
	SELECT *
	FROM SASHELP.CLASS
	WHERE AGE>&CUT. AND SEX=&CUT2.; *해당 MACRO변수 조건;
QUIT;   
%MEND; 
%TEST3(12,'여'); 


/*매크로의 자동화 %DO ~ %TO*/
%MACRO TEST(CUT,CUT2);  /*매크로TEST를 생성, 매크로변수CUT을  생성*/
%DO n=&CUT. %TO 15;    /*매크로용 DO명령어-> 매크로 변수 n을 생성, n는 &CUT.부터 15까지 시행*/  
PROC SQL;
	CREATE TABLE TEST_&n. AS    /*매크로변수 n 의 순서대로 테이블TEST_13, TEST_14, TEST_15를 생성*/
	SELECT *
	FROM SASHELP.CLASS
	WHERE AGE=&CUT. AND SEX=&CUT2. ;
QUIT;
%END; 
%MEND;  
%TEST(13,'여');  

/*매크로 문장 활용 3; 매크로 변수 활용*/
%MACRO TEST3(CUT, CUT2); /*매크로TEST3를 생성과 CUT과 CUT2라는 매크로변수도 함께 생성*/
PROC SQL;
	CREATE TABLE TEST_3 AS
	SELECT *
	FROM SASHELP.CLASS
	WHERE AGE>&CUT. AND SEX=&CUT2.; *해당 MACRO변수 조건;
QUIT;   
%MEND; 
%TEST3(12,'여'); 

/* DO UNTIL */ DATA TEMP; 
SUM_I = 0; DO UNTIL(SUM_I >= 10); 
SUM_I=SUM_I+1; OUTPUT; END; RUN;  *10에서 끝;
/* DO WHILE */ DATA TEMP; SUM_I = 0; DO WHILE(SUM_I < 10);
SUM_I=SUM_I+1; OUTPUT; END; RUN; *10에서 끝;
*차이점 존재: DO UNTIL은 괄호 안에 반복이 종료되는 조건을 입력하고 DO WHILE문은 괄호안에 반복이 지속되는 조건을 입력;

/*scan 함수 활용*/
data SCAN;
     arg  = 'ABC.DEF(X=Y)';
     word = scan(arg,3);    *X=Y, 3번째 구분자로 선택; 
     put word;
     word1 = scan(arg,-3); *ABC;
     put word1;
	 word2 = scan(arg,2);  *DEF;
	 put word2;
run;

*macro 응용 part;
%MACRO LOOP(VAR_LIST);
%LET i=1; /* 반복문 시작 */
%DO %UNTIL ( %SCAN ( &VAR_LIST. , &i. ) = %STR( ) );  *var_list: list에서 해당하는 i번째 var 선택;
%LET VAR_NAME = %SCAN ( &VAR_LIST. , &i. ) ;  *i번째 var 지정해서 매크로 변수(VAR_NAME)으로 저장;
/*반복 로직*/ 
PROC SQL ;
	CREATE TABLE &VAR_NAME. AS SELECT "&VAR_NAME." AS VAR_NAME , SUM( TARGET = 0 ) AS normal_dt,SUM(TARGET = 1 ) AS abnormal_dt 
	FROM jh.data
	GROUP BY 1;
QUIT ; 
%LET i= %EVAL(&i.+1); /* EVAL() : 숫자형 연산 함수 */ 
%END; 
DATA VAR_TOT ; SET &VAR_LIST. ;RUN; /* 개별 테이블 이어 붙이기 */ 
PROC DELETE DATA = &VAR_LIST. ;RUN; /* 개별 테이블 삭제 */ 
%MEND loop; 
/* 매크로 호출 */ 
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
 %put CEIL conversion: %sysevalf(&a +&b, ceil);  *ceil: 올림;
 %put FLOOR conversion: %sysevalf(&a +&b, floor); *floor: 내림;
 %put INTEGER conversion: %sysevalf(&a +&b, integer); *정수 부분;
 %mend figureit;
%figureit(100,1.59)

*** macro 저장  확인;
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

