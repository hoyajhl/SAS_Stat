PROC CONTENTS DATA = SASHELP.HEART POSITION VARNUM SHORT;
RUN ; /*Contents �ɼ� �߰�*/
PROC MEANS DATA= SASHELP.HEART; CLASS Sex; 
VAR Diastolic;/* OUTPUT OUT=MEANS_OF_DIASTOLIC;*/ 
RUN;
/* 2�� �̻��� ������ ������ �� ��� ������ ���̺� ��� */ 
PROC FREQ DATA=SASHELP.HEART; 
TABLES Status*Smoking_Status;
RUN;
PROC FREQ DATA=SASHELP.HEART; 
TABLES Status / NOCOL NOROW NOCUM NOPERCENT MISSING;
RUN;
DATA heart; set  SASHELP.HEART;run; 
PROC SORT DATA = heart; 
BY DESCENDING Status;
RUN; /* Status �÷��� �������� �������� ���� */ 
PROC SORT DATA =  heart; 
BY Status;
RUN;/* Status �÷��� �������� �������� ����(�⺻=��������) */  
PROC SORT DATA =  heart;
BY _ALL_; 
RUN; /* ��� �÷��� �������� �������� ����(�⺻=��������) */
/* Ư�� ���� �������� �ߺ����� */ 
PROC SORT DATA = Heart  OUT=Heart_1 
/* �ߺ� ���ŵ� �����͸� ���� ���̺�� ���� */ 
DUPOUT =HEART_2 /* �ߺ��� �ִ� �����͸� ���� ���̺�� ���� */
NODUPKEY; /* BY ������ ������ �� �������� �ߺ����� */ 
BY Height Weight ; /* �ش� �� �������� ���� �� �ߺ����� ���� */ 
RUN; 
/* ��� ���� �������� �ߺ����� */ 
PROC SORT DATA = HEART OUT = HEART_1 
/* �ߺ� ���ŵ� �����͸�  ���̺�� out */ DUPOUT =HEART_2 
/* �ߺ��� �ִ� �����͸� ������ out */ NODUPKEY; 
/* BY ������ ������ �� �������� �ߺ����� */ BY _ALL_ ;
/* �ش� �� �������� ���� �� �ߺ����� ���� */ RUN;
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
by a b c;   *��� a.b.c ������: ���� ��ġ�ؾ��ϸ� ���� ��� ��;
run;
/*SUBSTR - ���ڿ�/������ ���� ���� �Լ�*/
DATA TEMP; BASE_DATE = '20191231'; 
BASE_MONTH = substr(BASE_DATE,1,6); /* BASE_DATE�� 1��°���� �� 6�ڸ� ���ڿ� ���� */ 
RUN; /* BASE_MONTH = '201912' */
/*CATS , COMPRESS - ���ڿ�/������ ���� ���� �Լ�*/
DATA TEMP; BASE_MONTH = '201912'; /* CATS - ���� ���� �� ���� */
BASE_DATE1 = CATS(BASE_MONTH,'01'); 
BASE_DATE2 = CATS(BASE_MONTH,' 01 ');
/* COMPRESS - ���� �������� �ʰ� ���� */ BASE_DATE3 = COMPRESS(BASE_MONTH,'01');
BASE_DATE4 = COMPRESS(BASE_MONTH,' 01 '); 
/* || - ���� �������� �ʰ� ���� */ BASE_DATE5 = BASE_MONTH||'01'; 
BASE_DATE6 = BASE_MONTH||' 01 ';
RUN;
DATA TMP; 
start= INPUT('20181130',yymmdd8.) ;  *input: ���ڸ� ���� ������ �ٲ� ��;
end= INPUT('20191231',yymmdd8.) ;
interval_day=intck('day',start,end);  /* intck: ���� ����,  �� ���� �Ⱓ */ 
interval_month=intck('month',start,end);   /* �� ���� �Ⱓ */
interval_year=intck('year',start,end); /* �� ���� �Ⱓ */ 
run;
