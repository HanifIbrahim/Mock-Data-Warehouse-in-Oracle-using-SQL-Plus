/*READ THE COMMENTS*/

/* ETL Script
The following is the ETL Script used for the project. CSV files are premade and data from them is imported into SQL Developer using SQL Loader.*/

/*Command Prompt is opened using windows key + r and typing in ‘cmd’ \ and the working directory is set to the desktop:*/

/*
cd c:\users\studentfirst\desktop
*/


/* SQL Plus is initialized in the shell: */

/*
sqlplus / as sysdba
Enter user-name: DBST_USER
Enter password: SecurePassword
*/


/*Table is created using script generated from Oracle Data Import Wizard using the class-dim.csv, DIM_ACADEMIC_PRGM.csv, DIM_PROFESSOR.csv, and student_dim.csv (all uploaded in the group locker and linked in the final report) and choosing import method ‘SQL*Loader Utility’. Datatypes are adjusted and matched as below and constraints are added. Code is ran in SQL Plus (Oracle SQL Worksheet is okay too):*/

/* Note, fix the date format for all date entries in the dim-class.csv to DD-MM-RR uniformly manually.*/

SET DEFINE OFF
CREATE TABLE DIM_CLASS ( 
class_id INTEGER NOT NULL,
class_name VARCHAR2(128),
class_code VARCHAR2(128),
class_credit INTEGER,
class_start_date DATE,
class_end_date DATE,
class_term VARCHAR2(26));

ALTER TABLE DIM_CLASS ADD CONSTRAINT CLASS_pk PRIMARY KEY ( class_id );

SET DEFINE OFF
CREATE TABLE DIM_ACADEMIC_PROGRAM ( 
ID INTEGER NOT NULL,
NAME VARCHAR2(128) NOT NULL,
COLLEGE VARCHAR2(128) NOT NULL,
TYPE VARCHAR2(26),
CREDIT_HOUR_COST_IN_STATE NUMBER(6, 2),
CREDIT_HOUR_COST_OUT_STATE NUMBER(6, 2),
CREDIT_HOURS NUMBER(3) NOT NULL);

ALTER TABLE DIM_ACADEMIC_PROGRAM ADD CONSTRAINT AC_PGRM_pk PRIMARY KEY ( id );

SET DEFINE OFF
CREATE TABLE DIM_PROFESSOR ( 
ID INTEGER NOT NULL,
LAST_NAME VARCHAR2(60) NOT NULL,
FIRST_NAME VARCHAR2(50) NOT NULL,
POSITION VARCHAR2(30) NOT NULL,
CREDENTIAL VARCHAR2(26),
COLLEGE VARCHAR2(80),
ALMA_MATER VARCHAR2(128),
IS_TENURED CHAR(3),
SPECIALTY VARCHAR2(512),
EMAIL VARCHAR2(48),
PHONE VARCHAR2(15));

ALTER TABLE DIM_PROFESSOR ADD CONSTRAINT PROF_pk PRIMARY KEY ( id );

SET DEFINE OFF
CREATE TABLE DIM_STUDENTS ( 
stud_id INTEGER NOT NULL,
stud_first_name VARCHAR2(48) NOT NULL,
stud_last_name VARCHAR2(48) NOT NULL,
stud_phone VARCHAR2(15),
stud_birth_date DATE NOT NULL,
stud_grade NUMBER(5, 3),
stud_email VARCHAR2(48) NOT NULL,
stud_learning_type VARCHAR2(16),
stud_gender VARCHAR2(10),
stud_street_address VARCHAR2(128),
stud_state VARCHAR2(2),
stud_city VARCHAR2(64),
stud_zipcode NUMBER(5));

ALTER TABLE DIM_STUDENTS ADD CONSTRAINT STUDENT_pk PRIMARY KEY ( stud_id );

/* .ctl .sh and .bat files are found in C:\Users\StudentFirst\Desktop. */

/* SQL Plus quit its process using this command within the command prompt: */
/*
exit
*/

/* The following is generated into the control file: */

/* .ctl file code for CLASS DIM */
load data 
infile 'class-dim.csv' "str '\n'"
append
into table DIM_CLASS
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( class_id,
             class_name CHAR(4000),
             class_code CHAR(4000),
             class_credit,
             class_start_date DATE "DD-MON-RR",
             class_end_date DATE "DD-MON-RR",
             class_term CHAR(4000)
           )
/* .ctl file code for ACADEMIC PROGRAM DIM */
load data
infile 'DIM_ACADEMIC_PRGM.csv' "str '\r\n'"
append
into table DIM_ACADEMIC_PROGRAM
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( ID,
             NAME CHAR(4000),
             COLLEGE CHAR(4000),
             TYPE CHAR(4000),
             CREDIT_HOUR_COST_IN_STATE,
             CREDIT_HOUR_COST_OUT_STATE,
             CREDIT_HOURS
           )

/* .ctl file code for PROFESSOR DIM */
load data
infile 'DIM_PROFESSOR.csv' "str '\r\n'"
append
into table DIM_PROFESSOR
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( ID,
             LAST_NAME CHAR(4000),
             FIRST_NAME CHAR(4000),
             POSITION CHAR(4000),
             CREDENTIAL CHAR(4000),
             COLLEGE CHAR(4000),
             ALMA_MATER CHAR(4000),
             IS_TENURED CHAR(4000),
             SPECIALTY CHAR(4000),
             EMAIL CHAR(4000),
             PHONE CHAR(4000)
           )

/* .ctl file code for STUDENT DIM */
load data
infile 'student_dim.csv' "str '\r\n'"
append
into table DIM_STUDENT
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( stud_id,
             stud_first_name CHAR(4000),
             stud_last_name CHAR(4000),
             stud_phone CHAR(4000),
             stud_birth_date DATE "DD-MON-RR",
             stud_grade,
             stud_email CHAR(4000),
             stud_learning_type CHAR(4000),
             stud_gender CHAR(4000),
             stud_street_address CHAR(4000),
             stud_state CHAR(4000),
             stud_city CHAR(4000),
             stud_zipcode
           )

/* SQL Loader Utility is invoked within the command prompt: */

/* 
sqlldr userid=DBST_USER control=class-dim.ctl log=track1.log
Password: SecurePassword

sqlldr userid=DBST_USER control=DIM_ACADEMIC_PRGM.ctl log=track2.log
Password: SecurePassword

sqlldr userid=DBST_USER control=DIM_PROFESSOR.ctl log=track3.log
Password: SecurePassword

sqlldr userid=DBST_USER control=student_dim.ctl log=track4.log
Password: SecurePassword
*/

/*Data is then loaded into the Oracle SQL Developer.*/

/*
FACT TABLE ETL SCRIPT
The process for the FACT table is below. First, the tables are created. For FACT_EXTRACT, the script is generated using Oracle Data Import Wizard with the FACT TABLE SOURCE. Refer to the issues portion of this paper (delete the rows with NULL and change the 3o to 30 in the FACT_TABLE_SOURCE.csv file):

Note: change the datatype to the respective types listed below */

SET DEFINE OFF /* import the FACT_TABLE_SOURCE.csv */
CREATE TABLE FACT_EXTRACT  ( 
id INTEGER,
student_ID INTEGER,
course_id INTEGER,
Class_name VARCHAR2(128),
letter_grade VARCHAR2(26),
grade NUMBER(38),
datetime DATE, /* change to mm/dd/yyyy HH24:MI format */ 
semester VARCHAR2(26),
professor_id INTEGER,
Professor_name VARCHAR2(26),
Academic_PRGM_Degree_ID INTEGER);

/* .ctl .sh and .bat files are found in C:\Users\StudentFirst\Desktop. */

CREATE TABLE FACT_GOOD (
Id INTEGER,
student_id INTEGER,
course_id INTEGER,
Professor_id INTEGER,
Academic_Prgm_Degree_id INTEGER,
Datetime DATE,
Grade NUMBER(38));

CREATE TABLE FACT_BAD (
Class_name VARCHAR2(128),
letter_grade VARCHAR2(26),
semester VARCHAR2(26),
professor_name VARCHAR2(26));

CREATE TABLE FACT_COURSE_REGISTRATION (
Id INTEGER NOT NULL,
student_id INTEGER NOT NULL,
course_id INTEGER NOT NULL,
Professor_id INTEGER NOT NULL,
Academic_Prgm_Degree_id INTEGER NOT NULL,
Datetime DATE NOT NULL,
Grade NUMBER(5,0));

ALTER TABLE FACT_COURSE_REGISTRATION ADD CONSTRAINT REG_pk PRIMARY KEY ( id );
ALTER TABLE FACT_COURSE_REGISTRATION
    ADD CONSTRAINT REG_ACAD_PRGM_fk FOREIGN KEY ( Academic_prgm_degree_id )
        REFERENCES DIM_ACADEMIC_PROGRAM ( id );
ALTER TABLE FACT_COURSE_REGISTRATION
    ADD CONSTRAINT REG_CLASS_fk FOREIGN KEY ( course_id )
        REFERENCES DIM_CLASS ( class_id );
ALTER TABLE FACT_COURSE_REGISTRATION
    ADD CONSTRAINT REG_PROF_fk FOREIGN KEY ( Professor_id )
        REFERENCES DIM_PROFESSOR ( id );
ALTER TABLE FACT_COURSE_REGISTRATION
    ADD CONSTRAINT REG_ST_fk FOREIGN KEY ( student_id )
        REFERENCES DIM_STUDENT ( stud_id );

/*
Data is loaded into fact extract:
*/
load data
infile 'FACT_TABLE_SOURCE.csv' "str '\r\n'"
append
into table FACT_EXTRACT
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( id,
             student_ID,
             course_id,
             Class_name CHAR(4000),
             letter_grade CHAR(4000),
             grade,
             datetime DATE “mm/dd/yyyy HH24:MI”,
             semester CHAR(4000),
             professor_id,
             Professor_name CHAR(4000),
             Academic_PRGM_Degree_ID
           )

/*
Using in the cmd prompt:
*/
/*
sqlldr userid=DBST_USER control=FACT_TABLE_SOURCE.ctl log=track4.log
Password: SecurePassword
*/

/*
SQL Plus is initialized:

sqlplus / as sysdba
*/

/* This is the transform step. Both tables are populated using: */

INSERT ALL
INTO FACT_GOOD (
    id, student_id, course_id, professor_id, academic_prgm_degree_id, datetime, grade
    ) values (
    id, student_id, course_id, professor_id, academic_prgm_degree_id, datetime, grade
    )
INTO FACT_BAD (
    class_name, letter_grade, semester, professor_name
    ) values (class_name, letter_grade, semester, professor_name
    )
SELECT * FROM FACT_EXTRACT;

/* This is the load step. Data is loaded into registration fact: */

MERGE INTO FACT_REGISTRATION FACT
USING (SELECT * FROM FACT_GOOD) GOOD
ON (
    FACT.id = GOOD.id AND
    FACT.student_id = GOOD.student_id AND
    FACT.course_id = GOOD.course_id AND
    FACT.professor_id = GOOD.professor_id AND
    FACT.academic_prgm_degree_id = GOOD.academic_prgm_degree_id)
WHEN MATCHED THEN UPDATE SET
    FACT.datetime = GOOD.datetime,
    FACT.grade = GOOD.grade
WHEN NOT MATCHED THEN INSERT VALUES
    (
    GOOD.id,
    GOOD.student_id,
    GOOD.course_id,
    GOOD.professor_id,
    GOOD.academic_prgm_degree_id,
    GOOD.datetime,
    GOOD.grade
    );

