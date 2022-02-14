PROC CONTENTS DATA = SASHELP.HEART POSITION VARNUM SHORT;
RUN ; /*Contents 옵션 추가*/
PROC MEANS DATA= SASHELP.HEART; CLASS Sex; 
VAR Diastolic;/* OUTPUT OUT=MEANS_OF_DIASTOLIC;*/ 
RUN;
/* 2개 이상의 변수를 나란히 쓸 경우 각각의 테이블 출력 */ 
PROC FREQ DATA=SASHELP.HEART; 
TABLES Status*Smoking_Status;
RUN;
PROC FREQ DATA=SASHELP.HEART; 
TABLES Status / NOCOL NOROW NOCUM NOPERCENT MISSING;
RUN;
DATA heart; set  SASHELP.HEART;run; 
PROC SORT DATA = heart; 
BY DESCENDING Status;
RUN; /* Status 컬럼을 기준으로 내림차순 정렬 */ 
PROC SORT DATA =  heart; 
BY Status;
RUN;/* Status 컬럼을 기준으로 오름차순 정렬(기본=오름차순) */  
PROC SORT DATA =  heart;
BY _ALL_; 
RUN; /* 모든 컬럼을 기준으로 오름차순 정렬(기본=오름차순) */
/* 특정 열을 기준으로 중복제거 */ 
PROC SORT DATA = Heart  OUT=Heart_1 
/* 중복 제거된 데이터를 별도 테이블로 생성 */ 
DUPOUT =HEART_2 /* 중복이 있는 데이터를 별도 테이블로 생성 */
NODUPKEY; /* BY 다음에 나오는 열 기준으로 중복제거 */ 
BY Height Weight ; /* 해당 열 기준으로 정렬 및 중복제거 수행 */ 
RUN; 
/* 모든 열을 기준으로 중복제거 */ 
PROC SORT DATA = HEART OUT = HEART_1 
/* 중복 제거된 데이터를  테이블로 out */ DUPOUT =HEART_2 
/* 중복이 있는 데이터를 별도로 out */ NODUPKEY; 
/* BY 다음에 나오는 열 기준으로 중복제거 */ BY _ALL_ ;
/* 해당 열 기준으로 정렬 및 중복제거 수행 */ RUN;
data dupyes;
input a b c;
datalines;
1 3 5
1 3 5
1 3 5
2 4 5
2 4 5
2 4 7
1 2 3
1 2 7
3 2 1
;
run;
proc sort data=dupyes out=dupno dupout=dupdup nodupkey;
by a b c;   *모든 a.b.c 교집합: 전부 일치해야하만 제거 대상 됨;
run;
/*SUBSTR - 문자열/문자형 변수 추출 함수*/
DATA TEMP; BASE_DATE = '20191231'; 
BASE_MONTH = substr(BASE_DATE,1,6); /* BASE_DATE의 1번째부터 총 6자리 문자열 추출 */ 
RUN; /* BASE_MONTH = '201912' */
/*CATS , COMPRESS - 문자열/문자형 변수 결합 함수*/
DATA TEMP; BASE_MONTH = '201912'; /* CATS - 여백 제거 후 결합 */
BASE_DATE1 = CATS(BASE_MONTH,'01'); 
BASE_DATE2 = CATS(BASE_MONTH,' 01 ');
/* COMPRESS - 여백 제거하지 않고 제거 */ BASE_DATE3 = COMPRESS(BASE_MONTH,'01');
BASE_DATE4 = COMPRESS(BASE_MONTH,' 01 '); 
/* || - 여백 제거하지 않고 결합 */ BASE_DATE5 = BASE_MONTH||'01'; 
BASE_DATE6 = BASE_MONTH||' 01 ';
RUN;
DATA TMP; 
start= INPUT('20181130',yymmdd8.) ;  *input: 문자를 숫자 변수로 바꿔 줌;
end= INPUT('20191231',yymmdd8.) ;
interval_day=intck('day',start,end);  /* intck: 사이 간격,  일 단위 기간 */ 
interval_month=intck('month',start,end);   /* 월 단위 기간 */
interval_year=intck('year',start,end); /* 연 단위 기간 */ 
run;
