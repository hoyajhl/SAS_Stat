*macro concept;
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
