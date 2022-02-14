*macro concept;
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
