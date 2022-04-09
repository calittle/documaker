-------------------------------------------------
-------------------------------------------------
-- Create Primary account for DMKR_ADMIN schema
-------------------------------------------------
-------------------------------------------------

-- Documaker Administration Database Schema/User Name
DEF system_schema="dmkr_admin"
-- Documaker Administration Database Password
DEF system_passwdNoEnc="Documaker12"
-- System ID Number
DEF system_id="1"
-- System Name
DEF system_name="System 1"
-- Documaker Administration Database Data Location 
DEF system_folder="AD1SG"
-- Admin Group 
DEF admin_group="Documaker Administrators"
-- Admin User
DEF admin_user="documaker"

-- ACCEPT system_schema default 'dmkr_admin' prompt 'Enter the Documaker Administration Database Schema/User Name:'
-- ACCEPT system_passwdNoEnc default '' prompt 'Enter the Documaker Administration Database Password:'
-- ACCEPT system_id default '1' prompt 'Enter the System ID Number:'
-- ACCEPT system_name default 'System 1' prompt 'Enter the System Name:'
-- ACCEPT system_folder default '/data/' prompt 'Enter the Documaker Adminstration Database Data Location:'
-- ACCEPT admin_group default 'Documaker Administrators' prompt 'Enter the Documaker Admin Group:'
-- ACCEPT admin_user default 'documaker' prompt 'Enter the Documaker Admin User:'


----- DROP USER &system_schema. CASCADE;
----- DROP TABLESPACE &system_schema. -- INCLUDING CONTENTS;
----- remove the &system_schema..dbf after dropping TABLESPACE

WHENEVER SQLERROR EXIT SQL.SQLCODE; 


--ALTER SYSTEM SET DB_CREATE_FILE_DEST = '&system_folder.';
--ALTER DATABASE ADD LOGFILE MEMBER '&system_folder.&system_schema.03a.log' TO GROUP 10;
--ALTER DATABASE ADD LOGFILE MEMBER '&system_folder.&system_schema.03b.log' TO GROUP 10 SIZE ;

CREATE SMALLFILE TABLESPACE &system_schema. DATAFILE '&system_folder.&system_schema..dbf' SIZE 200M AUTOEXTEND ON NEXT 1M MAXSIZE 2G LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;

CREATE USER &system_schema.
    IDENTIFIED BY &system_passwdNoEnc.
    DEFAULT TABLESPACE &system_schema.
    TEMPORARY TABLESPACE TEMP
    PROFILE DEFAULT 
    ACCOUNT UNLOCK 
;

GRANT CONNECT, CREATE SESSION, UNLIMITED TABLESPACE TO &system_schema.
;

ALTER SESSION SET CURRENT_SCHEMA=&system_schema.;

-------------------------------------------------
-------------------------------------------------
-- Create Registry schema
-------------------------------------------------
-------------------------------------------------
---- Added Drop Statements commented out

---- --Backing out queues in DB:
-- --BEGIN
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..SCHEDULERREQ' ); 
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..RECEIVERREM' ); 
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..IDENTIFIERREQ' ); 
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..ASSEMBLERREQ' ); 
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..DISTRIBUTORREQ' ); 
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..BATCHERREQ' ); 
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..PRESENTERREQ' ); 
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..ARCHIVERREQ' ); 
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..PUBLISHERREQ' ); 
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..PUBNOTIFIERREQ' ); 
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..RECEIVERRES' ); 
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..RECEIVERREQ' ); 
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..DWSREQ' ); 
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..DWSRES' );
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..IDSREQ' ); 
-- --dbms_aqadm.stop_queue( queue_name=>'&system_schema..IDSRES' ); 
-- --END;
-- --/
-- --COMMIT;

-- --BEGIN
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..SCHEDULERREQ' ); 
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..RECEIVERREM' ); 
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..IDENTIFIERREQ' ); 
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..ASSEMBLERREQ' ); 
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..DISTRIBUTORREQ' ); 
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..BATCHERREQ' ); 
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..PRESENTERREQ' ); 
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..ARCHIVERREQ' ); 
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..PUBLISHERREQ' ); 
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..PUBNOTIFIERREQ' ); 
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..RECEIVERRES' ); 
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..RECEIVERREQ' ); 
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..DWSREQ' ); 
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..DWSRES' );
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..IDSREQ' ); 
-- --dbms_aqadm.drop_queue( queue_name=>'&system_schema..IDSRES' ); 
-- --END;
-- --/
-- --COMMIT;

-- --BEGIN
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_SCHEDULERREQ' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_RECEIVERREM' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_IDENTIFIERREQ' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_ASSEMBLERREQ' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_DISTRIBUTORREQ' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_BATCHERREQ' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_PRESENTERREQ' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_ARCHIVERREQ' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_PUBLISHERREQ' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_PUBNOTIFIERREQ' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_RECEIVERRES' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_RECEIVERREQ' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_DWSREQ' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_DWSRES' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_IDSREQ' ); 
-- --dbms_aqadm.drop_queue_table( queue_table=>'&system_schema..DMKRQ_IDSRES' ); 
-- --END;
-- --/
-- --COMMIT;

-- DROP TABLE S_ROW_ID CASCADE CONSTRAINTS;
-- DROP TRIGGER APPCONFIGCONTEXT_CTX_ID_TRG;
-- DROP SEQUENCE APPCONFIGCONTEXT_CTX_ID_SEQ;
-- DROP TRIGGER ALCONFIGCONTEXT_CTX_ID_TRG;
-- DROP SEQUENCE ALCONFIGCONTEXT_CTX_ID_SEQ;
-- DROP TRIGGER SYSCONFIGCONTEXT_CTX_ID_TRG;
-- DROP SEQUENCE SYSCONFIGCONTEXT_CTX_ID_SEQ;
-- DROP TRIGGER APPS_APP_ID_TRG; 
-- DROP SEQUENCE APPS_APP_ID_SEQ;
-- DROP TRIGGER ALS_AL_ID_TRG; 
-- DROP SEQUENCE ALS_AL_ID_SEQ;
-- DROP TRIGGER SYSS_SYS_ID_TRG; 
-- DROP SEQUENCE SYSS_SYS_ID_SEQ;
-- DROP TRIGGER SYSCFGCTX_BEFINS_TRG;
-- DROP TRIGGER SYSCFGCTX_BEFUPD_TRG;
-- DROP TRIGGER ALCFGCTX_BEFINS_TRG;
-- DROP TRIGGER ALCFGCTX_BEFUPD_TRG;
-- DROP TRIGGER APPCFGCTX_BEFINS_TRG;
-- DROP TRIGGER APPCFGCTX_BEFUPD_TRG;
-- DROP SEQUENCE CFGCTXLOG_ID_SEQ;
-- DROP TRIGGER CFGCTXLOG_ID_TRG;
-- DROP TRIGGER SYSCFGCTX_INS_TRG;
-- DROP TRIGGER SYSCFGCTX_UPD_TRG;
-- DROP TRIGGER SYSCFGCTX_DEL_TRG;
-- DROP TRIGGER DMKR_STAT_INFO_UPD_TRG;
-- DROP TRIGGER DMKR_STAT_INFO_INS_TRG;
-- DROP TRIGGER DMKR_TRANSLAT_INS_TRG; 
-- DROP TRIGGER DMKR_TRANSLAT_UPD_TRG; 
-- DROP TRIGGER DMKR_TRANSLAT_DEL_TRG;
-- DROP TRIGGER ALCFGCTX_INS_TRG;
-- DROP TRIGGER ALCFGCTX_UPD_TRG;
-- DROP TRIGGER ALCFGCTX_DEL_TRG; 
-- DROP TRIGGER APPCFGCTX_INS_TRG;
-- DROP TRIGGER APPCFGCTX_UPD_TRG;
-- DROP TRIGGER APPCFGCTX_DEL_TRG;
-- DROP TRIGGER DMKR_ABILITYSETS_TRG;
-- DROP SEQUENCE DMKR_ABILITYSETS_SEQ;
-- DROP TRIGGER DMKR_ENTITIES_DEL_TRG; 
-- DROP TRIGGER DMKR_ENTITIES_UPD_TRG;
-- DROP TRIGGER DMKR_ENTITIES_TRG;
-- DROP SEQUENCE DMKR_ENTITIES_SEQ;


-- DROP TABLE ALCONFIGCONTEXT CASCADE CONSTRAINTS;
-- DROP TABLE ALS CASCADE CONSTRAINTS;
-- DROP TABLE APPCONFIGCONTEXT CASCADE CONSTRAINTS;
-- DROP TABLE APPS CASCADE CONSTRAINTS;
-- DROP TABLE SYSCONFIGCONTEXT CASCADE CONSTRAINTS;
-- DROP TABLE SYSS CASCADE CONSTRAINTS;
-- DROP TABLE CONFIGCONTEXTLOG CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_ABILITIES CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_ABILITIES_TRANSLATIONS CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_ABILITYSETS CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_ABILITYSET_ABILITY CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_ABILITYTYPES CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_APPLICATION_ABILITY CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_APPRLEVELSENTITIES CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_APPROVERLEVELS CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_ENTITIES CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_ENTITYTYPE_TRANSLATIONS CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_ENTITY_ABILITYSET CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_ENTITY_PREFS CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_ENTITY_TO_ENTITY CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_STAT_INFO CASCADE CONSTRAINTS;
-- DROP TABLE DMKR_TRANSLAT CASCADE CONSTRAINTS;

-- Generated by Oracle SQL Developer Data Modeler Version: 2.0.0 Build: 584
--   at:        2010-11-01 09:49:16
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g


CREATE TABLE ALCONFIGCONTEXT 
    ( 
     SYS_ID NUMBER (38)  NOT NULL , 
     AL_ID NUMBER (38)  NOT NULL , 
     CTX_ID NUMBER (38) NOT NULL, 
     CONTEXT_NAME NVARCHAR2 (256) , 
     GROUP_NAME NVARCHAR2 (256)  NOT NULL , 
     PROPERTY NVARCHAR2 (256)  NOT NULL , 
     VALUE NVARCHAR2 (1000) , 
     VALUE_TYPE NUMBER (10) DEFAULT 0, 
     VALUE_REF NVARCHAR2 (256) , 
     GROUPSEQ NUMBER (10) DEFAULT 1 , 
     CATEGORY NVARCHAR2 (50) , 
     ACTIVE NUMBER (5) DEFAULT 1 , 
     IS_SECRET NUMBER (5) DEFAULT 0 , 
     IS_ENCRYPT NUMBER (5) DEFAULT 0 , 
     CREATETIME TIMESTAMP , 
     MODIFYTIME TIMESTAMP , 
     USERTAG1 NVARCHAR2 (256) , 
     NOTES NVARCHAR2 (2000) , 
     USER_ID NUMBER (38) , 
     USER_NAME NVARCHAR2 (256) 
    ) LOGGING 
;



COMMENT ON TABLE ALCONFIGCONTEXT IS 'Assembly Line Configuration Context'
;

COMMENT ON COLUMN ALCONFIGCONTEXT.CTX_ID IS 'Context ID primary key' 
;

COMMENT ON COLUMN ALCONFIGCONTEXT.CONTEXT_NAME IS 'Context grouping of associated GROUP_NAMEs.  ' 
;

COMMENT ON COLUMN ALCONFIGCONTEXT.GROUPSEQ IS 'Sequence of order of Properties under a Group_Name.  
Important if Properties are repeated and make a listing of values.' 
;

COMMENT ON COLUMN ALCONFIGCONTEXT.CATEGORY IS 'Category of the Property' 
;

COMMENT ON COLUMN ALCONFIGCONTEXT.PROPERTY IS 'Property Name' 
;

COMMENT ON COLUMN ALCONFIGCONTEXT.VALUE IS 'Value of the Property' 
;

COMMENT ON COLUMN ALCONFIGCONTEXT.VALUE_TYPE IS 'Value type of the Property:
0=Alphanumeric (default)
1=Alphanumeric Multiline
2=Numeric
3=Alpha
4=PickList
5=Boolean
6=Schedule
7=Date Time'
;

COMMENT ON COLUMN ALCONFIGCONTEXT.VALUE_REF IS 'Additional reference for value types. Example, used for PickList lookups from DMKR_TRANSLAT.' ;

COMMENT ON COLUMN ALCONFIGCONTEXT.ACTIVE IS 'Denotes if the configuration row is active (TRUE=1) or inactive (FALSE=0).
Inactive will not be evaluated by the processes using the setting. ' 
;

COMMENT ON COLUMN ALCONFIGCONTEXT.IS_SECRET IS 'Value is secret and should not be displayed.' 
;

COMMENT ON COLUMN ALCONFIGCONTEXT.IS_ENCRYPT IS 'Value is to be Encrypted. ' 
;

COMMENT ON COLUMN ALCONFIGCONTEXT.CREATETIME IS 'UTC time for when the entry was inserted.' 
;

COMMENT ON COLUMN ALCONFIGCONTEXT.MODIFYTIME IS 'UTC time for when the entry was last modified.' 
;

COMMENT ON COLUMN ALCONFIGCONTEXT.USERTAG1 IS 'Tag column to allow for comma delimited user tags for searching.' 
;

COMMENT ON COLUMN ALCONFIGCONTEXT.NOTES IS 'Notes about configuration option row. ' 
;

COMMENT ON COLUMN ALCONFIGCONTEXT.USER_ID IS 'Last User_Id to modify the row.' 
;

COMMENT ON COLUMN ALCONFIGCONTEXT.USER_NAME IS 'User Name that created or last changed the configuration option.' 
;

ALTER TABLE ALCONFIGCONTEXT 
    ADD CONSTRAINT ALCFGCTX_PK PRIMARY KEY ( CTX_ID, AL_ID, SYS_ID ) ;

CREATE INDEX ALCFG_IDX1 ON ALCONFIGCONTEXT
    (
     GROUP_NAME ASC, 
     PROPERTY ASC, 
     ACTIVE ASC, 
     SYS_ID ASC , 
     AL_ID ASC , 
     CTX_ID ASC 
    )
;
CREATE INDEX ALCFG_IDX2 ON ALCONFIGCONTEXT
    (
     GROUP_NAME ASC, 
     CONTEXT_NAME ASC, 
     ACTIVE ASC, 
     SYS_ID ASC , 
     AL_ID ASC , 
     CTX_ID ASC 
    )
;
CREATE INDEX ALCFG_IDX3 ON ALCONFIGCONTEXT
    (
     GROUP_NAME ASC, 
     CONTEXT_NAME ASC, 
     ACTIVE ASC, 
     SYS_ID ASC , 
     AL_ID ASC , 
     PROPERTY ASC , 
     CTX_ID ASC 
    )
;
CREATE INDEX ALCFG_IDX4 ON ALCONFIGCONTEXT
    (
     CONTEXT_NAME ASC, 
     CATEGORY ASC, 
     GROUP_NAME ASC, 
     SYS_ID ASC , 
     AL_ID ASC , 
     ACTIVE ASC
    )
;
CREATE INDEX ALCFG_IDX5 ON ALCONFIGCONTEXT
    (
     SYS_ID ASC , 
     AL_ID ASC , 
     ACTIVE ASC, 
     GROUP_NAME ASC
    )
;


CREATE TABLE ALS 
    ( 
     SYS_ID NUMBER (38)  NOT NULL , 
     AL_ID NUMBER (38)  NOT NULL , 
     ALNAME NVARCHAR2 (256)  NOT NULL , 
     ALTYPE NUMBER (5) , 
     ALDESCR NVARCHAR2 (256) , 
     ALUNIQUE_ID NVARCHAR2 (47)  NOT NULL , 
     ALCREATED TIMESTAMP 
    ) LOGGING 
;



COMMENT ON TABLE ALS IS 'Document Factory Assembly Lines'
;

COMMENT ON COLUMN ALS.SYS_ID IS 'Foreign key for the System ' 
;

COMMENT ON COLUMN ALS.AL_ID IS 'Auto Assigned primary key for the Assembly Line' 
;

COMMENT ON COLUMN ALS.ALNAME IS 'Deployment time assigned Name of the Assembly Line' 
;

COMMENT ON COLUMN ALS.ALTYPE IS 'Classification Type of the Assembly Line' 
;

COMMENT ON COLUMN ALS.ALDESCR IS 'Deployment time assigned description for the Assembly Line' 
;

COMMENT ON COLUMN ALS.ALUNIQUE_ID IS 'Deployment time assigned guid for the Assembly Line.
Used to obtain the AL_ID from the insert.' 
;

COMMENT ON COLUMN ALS.ALCREATED IS 'UTC date time deployment of the Assembly Line' 
;

ALTER TABLE ALS 
    ADD CONSTRAINT ALS_PK PRIMARY KEY ( AL_ID, SYS_ID ) ;


CREATE TABLE APPCONFIGCONTEXT 
    ( 
     SYS_ID NUMBER (38)  NOT NULL , 
     AL_ID NUMBER (38)  NOT NULL , 
     APP_ID NUMBER (38)  NOT NULL , 
     CTX_ID NUMBER (38) NOT NULL, 
     CONTEXT_NAME NVARCHAR2 (256) , 
     GROUP_NAME NVARCHAR2 (256)  NOT NULL , 
     PROPERTY NVARCHAR2 (256)  NOT NULL , 
     VALUE NVARCHAR2 (1000) , 
     VALUE_TYPE NUMBER (10) DEFAULT 0, 
     VALUE_REF NVARCHAR2 (256) , 
     GROUPSEQ NUMBER (10) DEFAULT 1 , 
     CATEGORY NVARCHAR2 (50) , 
     ACTIVE NUMBER (5) DEFAULT 1 , 
     IS_SECRET NUMBER (5) DEFAULT 0 , 
     IS_ENCRYPT NUMBER (5) DEFAULT 0 , 
     CREATETIME TIMESTAMP , 
     MODIFYTIME TIMESTAMP , 
     USERTAG1 NVARCHAR2 (256) , 
     NOTES NVARCHAR2 (2000) , 
     USER_ID NUMBER (38) , 
     USER_NAME NVARCHAR2 (256) 
    ) LOGGING 
;



COMMENT ON TABLE APPCONFIGCONTEXT IS 'Document Factory System Configuration Context'
;

COMMENT ON COLUMN APPCONFIGCONTEXT.CTX_ID IS 'Context ID primary key' 
;

COMMENT ON COLUMN APPCONFIGCONTEXT.CONTEXT_NAME IS 'Context grouping of associated GROUP_NAMEs.  ' 
;

COMMENT ON COLUMN APPCONFIGCONTEXT.GROUPSEQ IS 'Sequence of order of Properties under a Group_Name.  
Important if Properties are repeated and make a listing of values.' 
;

COMMENT ON COLUMN APPCONFIGCONTEXT.CATEGORY IS 'Category of the Property' 
;

COMMENT ON COLUMN APPCONFIGCONTEXT.ACTIVE IS 'Denotes if the configuration row is active (TRUE=1) or inactive (FALSE=0).
Inactive will not be evaluated by the processes using the setting. ' 
;

COMMENT ON COLUMN APPCONFIGCONTEXT.PROPERTY IS 'Property Name' 
;

COMMENT ON COLUMN APPCONFIGCONTEXT.VALUE IS 'Value of the Property' 
;

COMMENT ON COLUMN APPCONFIGCONTEXT.VALUE_TYPE IS 'Value type of the Property:
0=Alphanumeric (default)
1=Alphanumeric Multiline
2=Numeric
3=Alpha
4=PickList
5=Boolean
6=Schedule
7=Date Time'
;

COMMENT ON COLUMN APPCONFIGCONTEXT.VALUE_REF IS 'Additional reference for value types. Example, used for PickList lookups from DMKR_TRANSLAT ' ;

COMMENT ON COLUMN APPCONFIGCONTEXT.IS_SECRET IS 'Value is secret and should not be displayed.' 
;

COMMENT ON COLUMN APPCONFIGCONTEXT.IS_ENCRYPT IS 'Value is to be Encrypted. ' 
;

COMMENT ON COLUMN APPCONFIGCONTEXT.CREATETIME IS 'UTC time for when the entry was inserted.' 
;

COMMENT ON COLUMN APPCONFIGCONTEXT.MODIFYTIME IS 'UTC time for when the entry was last modified.' 
;

COMMENT ON COLUMN APPCONFIGCONTEXT.USERTAG1 IS 'Tag column to allow for comma delimited user tags for searching.' 
;

COMMENT ON COLUMN APPCONFIGCONTEXT.NOTES IS 'Notes about configuration option row. ' 
;

COMMENT ON COLUMN APPCONFIGCONTEXT.USER_ID IS 'Last User_id to modify the row.' 
;

COMMENT ON COLUMN APPCONFIGCONTEXT.USER_NAME IS 'User Name that created or last changed the configuration option.' 
;

ALTER TABLE APPCONFIGCONTEXT 
    ADD CONSTRAINT APPCFGCTX_PK PRIMARY KEY ( CTX_ID, APP_ID, AL_ID, SYS_ID ) ;

CREATE INDEX APPCFG_IDX1 ON APPCONFIGCONTEXT
    (
     CONTEXT_NAME ASC,
     CATEGORY ASC,
     GROUP_NAME ASC,
     SYS_ID ASC, 
     AL_ID ASC, 
     APP_ID ASC, 
     ACTIVE ASC
    )
;
CREATE INDEX APPCFG_IDX2 ON APPCONFIGCONTEXT
    (
     CONTEXT_NAME ASC,
     SYS_ID ASC, 
     AL_ID ASC, 
     APP_ID ASC, 
     PROPERTY ASC
    )
;
CREATE INDEX APPCFG_IDX3 ON APPCONFIGCONTEXT
    (
     SYS_ID ASC, 
     AL_ID ASC, 
     APP_ID ASC, 
     CONTEXT_NAME ASC,
     CATEGORY ASC,
     GROUP_NAME ASC,
     ACTIVE ASC
    )
;
CREATE INDEX APPCFG_IDX4 ON APPCONFIGCONTEXT
    (
     SYS_ID ASC, 
     AL_ID ASC, 
     APP_ID ASC, 
     ACTIVE ASC,
     GROUP_NAME ASC
    )
;
CREATE INDEX APPCFG_IDX5 ON APPCONFIGCONTEXT
    (
     GROUP_NAME ASC,
     PROPERTY ASC,
     ACTIVE ASC,
     SYS_ID ASC, 
     AL_ID ASC, 
     APP_ID ASC, 
     CTX_ID ASC
    )
;


CREATE TABLE APPS 
    ( 
     SYS_ID NUMBER (38)  NOT NULL , 
     AL_ID NUMBER (38)  NOT NULL , 
     APP_ID NUMBER (38)  NOT NULL , 
     APPNAME NVARCHAR2 (256)  NOT NULL , 
     APPTYPE NUMBER (5) , 
     APPDESCR NVARCHAR2 (256) , 
     APPUNIQUE_ID NVARCHAR2 (47)  NOT NULL , 
     APPCREATED TIMESTAMP 
    ) LOGGING 
;



COMMENT ON TABLE APPS IS 'Document Factory Applications'
;

COMMENT ON COLUMN APPS.SYS_ID IS 'Foreign key for the System ' 
;

COMMENT ON COLUMN APPS.AL_ID IS 'Foreign key for the Assembly Line' 
;

COMMENT ON COLUMN APPS.APP_ID IS 'Auto Assigned primary key for the Application' 
;

COMMENT ON COLUMN APPS.APPNAME IS 'Deployment time assigned Name of the Application' 
;

COMMENT ON COLUMN APPS.APPTYPE IS 'Application Type used for associating approprate ability sets per application.' 
;

COMMENT ON COLUMN APPS.APPDESCR IS 'Deployment time assigned description for the Application' 
;

COMMENT ON COLUMN APPS.APPUNIQUE_ID IS 'Deployment time assigned guid for the Assembly Line.
Used to obtain the AL_ID from the insert.' 
;

COMMENT ON COLUMN APPS.APPCREATED IS 'UTC date time deployment of the Application' 
;

ALTER TABLE APPS 
    ADD CONSTRAINT APPS_PK PRIMARY KEY ( APP_ID, AL_ID, SYS_ID ) ;


CREATE TABLE CONFIGCONTEXTLOG 
    ( 
     LOG_ID NUMBER (38)  NOT NULL , 
     SYS_ID NUMBER (38) , 
     AL_ID NUMBER (38) , 
     APP_ID NUMBER (38) , 
     CTX_ID NUMBER (38) , 
     CONTEXT_NAME NVARCHAR2 (256) , 
     GROUP_NAME NVARCHAR2 (256) , 
     PROPERTY NVARCHAR2 (256) , 
     VALUE NVARCHAR2 (1000) , 
     VALUE_TYPE NUMBER (10) DEFAULT 0, 
     VALUE_REF NVARCHAR2 (256) , 
     GROUPSEQ NUMBER (10) , 
     CATEGORY NVARCHAR2 (50) , 
     ACTIVE NUMBER (5) , 
     IS_SECRET NUMBER (5) , 
     IS_ENCRYPT NUMBER (5) , 
     CREATETIME TIMESTAMP , 
     MODIFYTIME TIMESTAMP , 
     USERTAG1 NVARCHAR2 (256) , 
     NOTES NVARCHAR2 (2000) , 
     USER_ID NUMBER (38) , 
     USER_NAME NVARCHAR2 (256) , 
     LOGTIME TIMESTAMP , 
     ACTION NUMBER (10) 
    ) LOGGING 
;


COMMENT ON TABLE CONFIGCONTEXTLOG IS 'Document Factory System Configuration Context'
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.LOG_ID IS 'Autogenerated sequence for the log entry. ' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.CTX_ID IS 'Context ID' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.CONTEXT_NAME IS 'Context grouping of associated GROUP_NAMEs.  ' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.GROUPSEQ IS 'Sequence of order of Properties under a Group_Name.  
Important if Properties are repeated and make a listing of values.' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.CATEGORY IS 'Category of the Property' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.ACTIVE IS 'Denotes if the configuration row is active (TRUE=1) or inactive (FALSE=0).
Inactive will not be evaluated by the processes using the setting. ' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.PROPERTY IS 'Property Name' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.VALUE IS 'Value of the Property' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.VALUE_TYPE IS 'Value type of the Property:
0=Alphanumeric (default)
1=Alphanumeric Multiline
2=Numeric
3=Alpha
4=PickList
5=Boolean
6=Schedule
7=Date Time'
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.VALUE_REF IS 'Additional reference for value types. Example, used for PickList lookups from DMKR_TRANSLAT ' ;

COMMENT ON COLUMN CONFIGCONTEXTLOG.IS_SECRET IS 'Value is secret and should not be displayed.' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.IS_ENCRYPT IS 'Value is to be Encrypted. ' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.CREATETIME IS 'UTC time for when the entry was inserted.' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.MODIFYTIME IS 'UTC time for when the entry was last modified.' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.USERTAG1 IS 'Tag column to allow for comma delimited user tags for searching.' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.NOTES IS 'Notes about configuration option row. ' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.USER_ID IS 'USER_ID that made the change. ' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.USER_NAME IS 'User Name associated with the USER_ID at the time of the change.' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.LOGTIME IS 'UTC time of the log insert.' 
;

COMMENT ON COLUMN CONFIGCONTEXTLOG.ACTION IS 'Picklist of action performed related to the log entry.
0=New Config
1=Changed Config
2=Deleted Config' 
;

ALTER TABLE CONFIGCONTEXTLOG 
    ADD CONSTRAINT CFGCTXLOG_PK PRIMARY KEY ( LOG_ID ) ;

CREATE INDEX CFGCTXLOG_CHG_INDEX ON CONFIGCONTEXTLOG  
    (
     LOGTIME DESC , 
     SYS_ID ASC , 
     AL_ID ASC , 
     APP_ID ASC , 
     CONTEXT_NAME ASC
    )
;

CREATE INDEX CFGCTXLOG_CHG_IDX2 ON CONFIGCONTEXTLOG  
    (
     SYS_ID ASC , 
     CONTEXT_NAME ASC,
     LOGTIME DESC , 
     AL_ID ASC , 
     APP_ID ASC , 
     CTX_ID ASC 
    )
;


CREATE TABLE DMKR_ABILITIES 
    ( 
     ID NUMBER (38)  NOT NULL , 
     NAME NVARCHAR2 (256)  NOT NULL 
    ) LOGGING 
;


CREATE UNIQUE INDEX DMKR_ABILITIES_NAME_INDEX ON DMKR_ABILITIES 
    ( 
     NAME ASC 
    ) 
    NOLOGGING 
    NOCOMPRESS 
    NOPARALLEL 
;

ALTER TABLE DMKR_ABILITIES 
    ADD CONSTRAINT DMKR_ABILITIES_PK PRIMARY KEY ( ID ) ;


CREATE TABLE DMKR_ABILITIES_TRANSLATIONS 
    ( 
     ABILITY_ID NUMBER (38)  NOT NULL , 
     LANGUAGE NVARCHAR2 (30)  NOT NULL , 
     ABILITY_NAME NVARCHAR2 (256)  NOT NULL , 
     ABILITY_DESCRIPTION NVARCHAR2 (2000)  NOT NULL , 
     SOURCE_LANG NVARCHAR2 (30)  NOT NULL 
    ) LOGGING 
;


CREATE INDEX DMKR_ABILITIES_TRANS_ID_INDEX ON DMKR_ABILITIES_TRANSLATIONS 
    ( 
     ABILITY_ID ASC 
    ) 
    NOLOGGING 
    NOCOMPRESS 
    NOPARALLEL 
;

ALTER TABLE DMKR_ABILITIES_TRANSLATIONS 
    ADD CONSTRAINT DMKR_ABILITIES_TRANSLATIO_PK PRIMARY KEY ( ABILITY_ID, LANGUAGE ) ;


CREATE TABLE DMKR_ABILITYSETS 
    ( 
     ID NUMBER (38)  NOT NULL , 
     APP_ID NUMBER (38)  NOT NULL , 
     NAME NVARCHAR2 (500)  NOT NULL , 
     DESCRIPTION NVARCHAR2 (2000)  NOT NULL , 
     EDITABLE NUMBER (5) DEFAULT 1 
    ) LOGGING 
;



ALTER TABLE DMKR_ABILITYSETS 
    ADD CONSTRAINT DMKR_ABILITYSETS_PK PRIMARY KEY ( ID, APP_ID ) ;


CREATE TABLE DMKR_ABILITYSET_ABILITY 
    ( 
     ABILITYSETID NUMBER (38)  NOT NULL , 
     APP_ID NUMBER (38)  NOT NULL , 
     ABILITYID NUMBER (38)  NOT NULL , 
     ABILITYTYPEID NUMBER (38) DEFAULT 1  NOT NULL , 
     VISIBLE NUMBER (5) DEFAULT 0  NOT NULL , 
     EDITABLE NUMBER (5) DEFAULT 0  NOT NULL , 
     ACCESSIBLE NUMBER (5) DEFAULT 0  NOT NULL 
    ) LOGGING 
;



ALTER TABLE DMKR_ABILITYSET_ABILITY 
    ADD CONSTRAINT DMKR_ABILITYSET_ABILITY_PK PRIMARY KEY ( ABILITYID, ABILITYSETID, APP_ID, ABILITYTYPEID ) ;


CREATE TABLE DMKR_ABILITYTYPES 
    ( 
     ID NUMBER (38)  NOT NULL , 
     NAME NVARCHAR2 (256)  NOT NULL , 
     DESCRIPTION NVARCHAR2 (2000)  NOT NULL 
    ) LOGGING 
;



ALTER TABLE DMKR_ABILITYTYPES 
    ADD CONSTRAINT DMKR_ABILITYTYPES_PK PRIMARY KEY ( ID ) ;


CREATE TABLE DMKR_APPLICATION_ABILITY 
    ( 
     APPLICATION_TYPE NUMBER (5)  NOT NULL , 
     ABILITY_ID NUMBER (38)  NOT NULL 
    ) LOGGING 
;



ALTER TABLE DMKR_APPLICATION_ABILITY 
    ADD CONSTRAINT DMKR_APPLICATION_ABILITY_PK PRIMARY KEY ( ABILITY_ID, APPLICATION_TYPE ) ;


CREATE TABLE DMKR_APPRLEVELSENTITIES 
    ( 
     APP_ID NUMBER (38)  NOT NULL , 
     ENTITYID NVARCHAR2 (500)  NOT NULL , 
     ENTITYNAME NVARCHAR2 (500)  NOT NULL , 
     ENTITYTYPE NUMBER (10)  NOT NULL , 
     LEVELNUM NUMBER (20) 
    ) LOGGING 
;



ALTER TABLE DMKR_APPRLEVELSENTITIES 
    ADD CONSTRAINT DMKR_APPRLEVELSENTITIES_PK PRIMARY KEY ( ENTITYID, APP_ID ) ;


CREATE TABLE DMKR_APPROVERLEVELS 
    ( 
     APP_ID NUMBER (38)  NOT NULL , 
     LEVELNUM NUMBER (20)  NOT NULL , 
     DESCRIPTION NVARCHAR2 (500) 
    ) LOGGING 
;



ALTER TABLE DMKR_APPROVERLEVELS 
    ADD CONSTRAINT DMKR_APPROVERLEVELS_PK PRIMARY KEY ( LEVELNUM, APP_ID ) ;


CREATE TABLE DMKR_ENTITIES 
    ( 
     ID NUMBER (38)  NOT NULL , 
     ENTITYTYPE NUMBER (38)  NOT NULL , 
     DISPLAYNAME NVARCHAR2 (500)  NOT NULL , 
     REPOSITORYNAME NVARCHAR2 (500)  NOT NULL , 
     NAME NVARCHAR2 (500)  NOT NULL , 
     TITLE NVARCHAR2 (500) , 
     MANAGER NVARCHAR2 (500) , 
     BUSINESS_EMAIL NVARCHAR2 (500) , 
     BUSINESS_PHONE NVARCHAR2 (20) , 
     BUSINESS_STATE NVARCHAR2 (100) , 
     BUSINESS_CITY NVARCHAR2 (100) , 
     BUSINESS_COUNTRY NVARCHAR2 (100) , 
     LAST_UPDATE TIMESTAMP , 
     ACTIVE NUMBER (5) DEFAULT 1  NOT NULL 
    ) LOGGING 
;



ALTER TABLE DMKR_ENTITIES 
    ADD CONSTRAINT DMKR_ENTITIES_TYPECHECK 
    CHECK ( ENTITYTYPE = 1 OR ENTITYTYPE = 2) 
;


ALTER TABLE DMKR_ENTITIES 
    ADD CONSTRAINT DMKR_ENTITIES_ACTIVECHECK 
    CHECK ( ACTIVE = 1 OR ACTIVE = 0) 
;

CREATE UNIQUE INDEX DMKR_ENTITIES_REPONAME_INDEX ON DMKR_ENTITIES 
    ( 
     REPOSITORYNAME ASC 
    ) 
    NOLOGGING 
    NOCOMPRESS 
    NOPARALLEL 
;

ALTER TABLE DMKR_ENTITIES 
    ADD CONSTRAINT DMKR_ENTITIES_PK PRIMARY KEY ( ID ) ;


CREATE TABLE DMKR_ENTITYTYPE_TRANSLATIONS 
    ( 
     ENTITYTYPE_ID NUMBER (38)  NOT NULL , 
     LANGUAGE NVARCHAR2 (30)  NOT NULL , 
     ENTITYTYPE_NAME NVARCHAR2 (256)  NOT NULL , 
     ENTITYTYPE_DESCRIPTION NVARCHAR2 (500)  NOT NULL , 
     SOURCE_LANG NVARCHAR2 (30)  NOT NULL 
    ) LOGGING 
;



ALTER TABLE DMKR_ENTITYTYPE_TRANSLATIONS 
    ADD CONSTRAINT DMKR_ENTITYTYPE_TRANSLATIO_CK1 
    CHECK ( ENTITYTYPE_ID = 1 OR ENTITYTYPE_ID = 2) 
;


ALTER TABLE DMKR_ENTITYTYPE_TRANSLATIONS 
    ADD CONSTRAINT DMKR_ENTITYTYPE_TRANSLATIO_PK PRIMARY KEY ( ENTITYTYPE_ID, LANGUAGE ) ;


CREATE TABLE DMKR_ENTITY_ABILITYSET 
    ( 
     ENTITYID NUMBER (38)  NOT NULL , 
     ABILITYSETID NUMBER (38)  NOT NULL , 
     APP_ID NUMBER (38)  NOT NULL 
    ) LOGGING 
;


CREATE INDEX DMKR_E2AS_ABILITYSETID_INDEX ON DMKR_ENTITY_ABILITYSET 
    ( 
     ABILITYSETID ASC 
    ) 
    NOLOGGING 
    NOCOMPRESS 
    NOPARALLEL 
;
CREATE INDEX DMKR_E2AS_APPID_INDEX ON DMKR_ENTITY_ABILITYSET 
    ( 
     APP_ID ASC 
    ) 
    NOLOGGING 
    NOCOMPRESS 
    NOPARALLEL 
;
CREATE INDEX DMKR_E2AS_ENTITYID_INDEX ON DMKR_ENTITY_ABILITYSET 
    ( 
     ENTITYID ASC 
    ) 
    NOLOGGING 
    NOCOMPRESS 
    NOPARALLEL 
;

ALTER TABLE DMKR_ENTITY_ABILITYSET 
    ADD CONSTRAINT DMKR_ENTITY_ABILITYSET_PK PRIMARY KEY ( ABILITYSETID, APP_ID, ENTITYID ) ;


CREATE TABLE DMKR_ENTITY_PREFS 
    ( 
     SYS_ID NUMBER (38)  NOT NULL , 
     AL_ID NUMBER (38)  NOT NULL , 
     APP_ID NUMBER (38)  NOT NULL , 
     ENT_ID NUMBER (38)  NOT NULL , 
     ENTPROP NVARCHAR2 (256)  NOT NULL , 
     ENTVALUE NVARCHAR2 (1000) , 
     ENTDATAXML XMLTYPE , 
     ENTDATABLOB BLOB 
    ) LOGGING 
    XMLTYPE ENTDATAXML STORE AS CLOB 
    ( 
        STORAGE ( 
            PCTINCREASE 0 
            MINEXTENTS 1 
            MAXEXTENTS UNLIMITED 
            FREELISTS 1 
            BUFFER_POOL DEFAULT 
        ) 
        RETENTION 
        ENABLE STORAGE IN ROW
        CACHE 
    ) 
;



ALTER TABLE DMKR_ENTITY_PREFS 
    ADD CONSTRAINT DMKR_ENTPREFS_PK PRIMARY KEY ( AL_ID, SYS_ID, ENTPROP, ENT_ID, APP_ID ) ;


CREATE TABLE DMKR_ENTITY_TO_ENTITY 
    ( 
     GROUP_ID NUMBER (38)  NOT NULL , 
     USER_ID NUMBER (38)  NOT NULL 
    ) LOGGING 
;

ALTER TABLE DMKR_ENTITY_TO_ENTITY 
    ADD CONSTRAINT DMKR_ENTITY_TO_ENTITY_PK PRIMARY KEY ( GROUP_ID, USER_ID ) ;

CREATE INDEX DMKR_ENTITY_TO_ENTITY_IDS2
    ON DMKR_ENTITY_TO_ENTITY
    (
    USER_ID, 
    GROUP_ID
    )
;

CREATE TABLE DMKR_TRANSLAT 
    ( 
     SYS_ID NUMBER (38)  NOT NULL , 
     AL_ID NUMBER (38)  NOT NULL , 
     APP_ID NUMBER (38)  NOT NULL , 
     LOCALE_ID NVARCHAR2 (10)  NOT NULL , 
     GROUP_ID NVARCHAR2 (256)  NOT NULL , 
     ID NVARCHAR2 (256)  NOT NULL , 
     DISPLAY NVARCHAR2 (1000)  NOT NULL , 
     DESCRIPTION NVARCHAR2 (1000), 
     DISPLAYSEQ NUMBER (10) DEFAULT 1     
    ) LOGGING 
;



COMMENT ON COLUMN DMKR_TRANSLAT.SYS_ID IS 'System ID from the system registry tables.' 
;

COMMENT ON COLUMN DMKR_TRANSLAT.AL_ID IS 'Assembly Line ID from the system registry tables.' 
;

COMMENT ON COLUMN DMKR_TRANSLAT.APP_ID IS 'Application ID from the system registry tables.' 
;

COMMENT ON COLUMN DMKR_TRANSLAT.LOCALE_ID IS 'Locale' 
;

COMMENT ON COLUMN DMKR_TRANSLAT.GROUP_ID IS 'Application Group ID to identify a portion in the UI by a name for lookup.' 
;

COMMENT ON COLUMN DMKR_TRANSLAT.ID IS 'Application Picklist values to store.' 
;

COMMENT ON COLUMN DMKR_TRANSLAT.DISPLAY IS 'Application Picklist values to display to the app user.' 
;

COMMENT ON COLUMN DMKR_TRANSLAT.DESCRIPTION IS 'Description for the item, usually a tool-tip for the end user. ' 
;

ALTER TABLE DMKR_TRANSLAT 
    ADD CONSTRAINT DMKR_TRANSLAT_PK PRIMARY KEY ( SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID ) ;

CREATE TABLE DMKR_STAT_INFO
    ( 
     STATNAME NVARCHAR2 (256) NOT NULL, 
     STATTIME TIMESTAMP , 
     STATACTION NUMBER (10) 
    ) LOGGING 
;

ALTER TABLE DMKR_STAT_INFO 
    ADD CONSTRAINT DMKRSTATINFO_PK PRIMARY KEY ( STATNAME ) ;

CREATE TABLE SYSCONFIGCONTEXT 
    ( 
     SYS_ID NUMBER (38) NOT NULL , 
     CTX_ID NUMBER (38) NOT NULL, 
     CONTEXT_NAME NVARCHAR2 (256) , 
     GROUP_NAME NVARCHAR2 (256)  NOT NULL , 
     PROPERTY NVARCHAR2 (256)  NOT NULL , 
     VALUE NVARCHAR2 (1000) , 
     VALUE_TYPE NUMBER (10) DEFAULT 0, 
     VALUE_REF NVARCHAR2 (256) , 
     GROUPSEQ NUMBER (10) DEFAULT 1 ,    
     CATEGORY NVARCHAR2 (50) , 
     ACTIVE NUMBER (5) DEFAULT 1 , 
     IS_SECRET NUMBER (5) DEFAULT 0 , 
     IS_ENCRYPT NUMBER (5) DEFAULT 0 , 
     CREATETIME TIMESTAMP , 
     MODIFYTIME TIMESTAMP , 
     USERTAG1 NVARCHAR2 (256) , 
     NOTES NVARCHAR2 (2000) , 
     USER_ID NUMBER (38) , 
     USER_NAME NVARCHAR2 (256) 
    ) LOGGING 
;



COMMENT ON TABLE SYSCONFIGCONTEXT IS 'Document Factory System Configuration Context'
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.CTX_ID IS 'Context ID primary key' 
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.CONTEXT_NAME IS 'Context grouping of associated GROUP_NAMEs.  ' 
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.GROUPSEQ IS 'Sequence of order of Properties under a Group_Name.  
Important if Properties are repeated and make a listing of values.' 
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.CATEGORY IS 'Category of the Property' 
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.ACTIVE IS 'Denotes if the configuration row is active (TRUE=1) or inactive (FALSE=0).
Inactive will not be evaluated by the processes using the setting. ' 
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.PROPERTY IS 'Property Name' 
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.VALUE IS 'Value of the Property' 
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.VALUE_TYPE IS 'Value type of the Property:
0=Alphanumeric (default)
1=Alphanumeric Multiline
2=Numeric
3=Alpha
4=PickList
5=Boolean
6=Schedule
7=Date Time'
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.VALUE_REF IS 'Additional reference for value types. Example, used for PickList lookups from DMKR_TRANSLAT ' ;

COMMENT ON COLUMN SYSCONFIGCONTEXT.IS_SECRET IS 'Value is secret and should not be displayed.' 
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.IS_ENCRYPT IS 'Value is to be Encrypted. ' 
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.CREATETIME IS 'UTC time for when the entry was inserted.' 
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.MODIFYTIME IS 'UTC time for when the entry was last modified.' 
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.USERTAG1 IS 'Tag column to allow for comma delimited user tags for searching.' 
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.NOTES IS 'Notes about configuration option row. ' 
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.USER_ID IS 'Last User_id to modify the row.' 
;

COMMENT ON COLUMN SYSCONFIGCONTEXT.USER_NAME IS 'User Name that created or last changed the configuration option.' 
;

ALTER TABLE SYSCONFIGCONTEXT 
    ADD CONSTRAINT SYSCFGCTX_PK PRIMARY KEY ( CTX_ID, SYS_ID ) ;

CREATE INDEX SYSCFG_IDX1 ON SYSCONFIGCONTEXT
    (
     GROUP_NAME ASC,
     PROPERTY ASC,
     ACTIVE ASC,
     SYS_ID ASC, 
     CTX_ID ASC
    )
;

CREATE INDEX SYSCFG_IDX2 ON SYSCONFIGCONTEXT
    (
     CONTEXT_NAME ASC,
     CATEGORY ASC,
     GROUP_NAME ASC,
     SYS_ID ASC, 
     ACTIVE ASC
    )
;


CREATE TABLE SYSS 
    ( 
     SYS_ID NUMBER (38)  NOT NULL , 
     SYSNAME NVARCHAR2 (256)  NOT NULL , 
     SYSTYPE NUMBER (5) , 
     SYSDESCR NVARCHAR2 (256) , 
     SYSUNIQUE_ID NVARCHAR2 (47)  NOT NULL , 
     SYSCREATED TIMESTAMP 
    ) LOGGING 
;



COMMENT ON TABLE SYSS IS 'Document Factory Systems'
;

COMMENT ON COLUMN SYSS.SYS_ID IS 'Auto Assigned primary key for the System' 
;

COMMENT ON COLUMN SYSS.SYSNAME IS 'Deployment time assigned Name of System' 
;

COMMENT ON COLUMN SYSS.SYSTYPE IS 'Classification Type of the System' 
;

COMMENT ON COLUMN SYSS.SYSDESCR IS 'Deployment time assigned description for the System' 
;

COMMENT ON COLUMN SYSS.SYSUNIQUE_ID IS 'Deployment time assigned guid for the System' 
;

COMMENT ON COLUMN SYSS.SYSCREATED IS 'UTC date time deployment of the System' 
;

ALTER TABLE SYSS 
    ADD CONSTRAINT SYSS_PK PRIMARY KEY ( SYS_ID ) ;



ALTER TABLE ALCONFIGCONTEXT 
    ADD CONSTRAINT ALS_ALCFGCTX FOREIGN KEY 
    ( 
     AL_ID,
     SYS_ID
    ) 
    REFERENCES ALS 
    ( 
     AL_ID,
     SYS_ID
    ) 
    ON DELETE CASCADE 
    NOT DEFERRABLE 
;


ALTER TABLE APPS 
    ADD CONSTRAINT ALS_APPS FOREIGN KEY 
    ( 
     AL_ID,
     SYS_ID
    ) 
    REFERENCES ALS 
    ( 
     AL_ID,
     SYS_ID
    ) 
    ON DELETE CASCADE 
    NOT DEFERRABLE 
;


ALTER TABLE APPCONFIGCONTEXT 
    ADD CONSTRAINT APPS_APPCFGCTX FOREIGN KEY 
    ( 
     APP_ID,
     AL_ID,
     SYS_ID
    ) 
    REFERENCES APPS 
    ( 
     APP_ID,
     AL_ID,
     SYS_ID
    ) 
    ON DELETE CASCADE 
    NOT DEFERRABLE 
;


ALTER TABLE DMKR_ABILITIES_TRANSLATIONS 
    ADD CONSTRAINT DMKR_ABILITIES_TRANSLATIO_FK1 FOREIGN KEY 
    ( 
     ABILITY_ID
    ) 
    REFERENCES DMKR_ABILITIES 
    ( 
     ID
    ) 
    NOT DEFERRABLE 
;


ALTER TABLE DMKR_ABILITYSET_ABILITY 
    ADD CONSTRAINT DMKR_ABILITYSET_ABILIITY_FK2 FOREIGN KEY 
    ( 
     ABILITYSETID,
     APP_ID
    ) 
    REFERENCES DMKR_ABILITYSETS 
    ( 
     ID,
     APP_ID
    ) 
    ON DELETE CASCADE 
    NOT DEFERRABLE 
;


ALTER TABLE DMKR_ABILITYSET_ABILITY 
    ADD CONSTRAINT DMKR_ABILITYSET_ABILITY_D_FK1 FOREIGN KEY 
    ( 
     ABILITYTYPEID
    ) 
    REFERENCES DMKR_ABILITYTYPES 
    ( 
     ID
    ) 
    NOT DEFERRABLE 
;


ALTER TABLE DMKR_ABILITYSET_ABILITY 
    ADD CONSTRAINT DMKR_ABILITYSET_ABILITY_D_FK2 FOREIGN KEY 
    ( 
     ABILITYID
    ) 
    REFERENCES DMKR_ABILITIES 
    ( 
     ID
    ) 
    ON DELETE CASCADE 
    NOT DEFERRABLE 
;


ALTER TABLE DMKR_APPLICATION_ABILITY 
    ADD CONSTRAINT DMKR_APPLICATION_ABILITY_FK1 FOREIGN KEY 
    ( 
     ABILITY_ID
    ) 
    REFERENCES DMKR_ABILITIES 
    ( 
     ID
    ) 
    NOT DEFERRABLE 
;


ALTER TABLE DMKR_ENTITY_ABILITYSET 
    ADD CONSTRAINT DMKR_ENTITY_ABILITYSET_FK FOREIGN KEY 
    ( 
     ENTITYID
    ) 
    REFERENCES DMKR_ENTITIES 
    ( 
     ID
    ) 
    ON DELETE CASCADE 
    NOT DEFERRABLE 
;


ALTER TABLE DMKR_ENTITY_ABILITYSET 
    ADD CONSTRAINT DMKR_ENTITY_ABILITYSET_FK2 FOREIGN KEY 
    ( 
     ABILITYSETID,
     APP_ID
    ) 
    REFERENCES DMKR_ABILITYSETS 
    ( 
     ID,
     APP_ID
    ) 
    ON DELETE CASCADE 
    NOT DEFERRABLE 
;


ALTER TABLE DMKR_ENTITY_TO_ENTITY 
    ADD CONSTRAINT DMKR_ENTITY_TO_ENTITY_FK1 FOREIGN KEY 
    ( 
     GROUP_ID
    ) 
    REFERENCES DMKR_ENTITIES 
    ( 
     ID
    ) 
    ON DELETE CASCADE 
    NOT DEFERRABLE 
;


ALTER TABLE DMKR_ENTITY_TO_ENTITY 
    ADD CONSTRAINT DMKR_ENTITY_TO_ENTITY_FK2 FOREIGN KEY 
    ( 
     USER_ID
    ) 
    REFERENCES DMKR_ENTITIES 
    ( 
     ID
    ) 
    ON DELETE CASCADE 
    NOT DEFERRABLE 
;


ALTER TABLE ALS 
    ADD CONSTRAINT SYSS_ALS FOREIGN KEY 
    ( 
     SYS_ID
    ) 
    REFERENCES SYSS 
    ( 
     SYS_ID
    ) 
    ON DELETE CASCADE 
    NOT DEFERRABLE 
;


ALTER TABLE SYSCONFIGCONTEXT 
    ADD CONSTRAINT SYSS_SYSCFGCTX FOREIGN KEY 
    ( 
     SYS_ID
    ) 
    REFERENCES SYSS 
    ( 
     SYS_ID
    ) 
    ON DELETE CASCADE 
    NOT DEFERRABLE 
;


-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            21
-- CREATE INDEX                             6
-- ALTER TABLE                             38
-- CREATE VIEW                              0
-- CREATE PROCEDURE                         0
-- CREATE TRIGGER                           0
-- CREATE STRUCTURED TYPE                   0
-- CREATE COLLECTION TYPE                   0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE SNAPSHOT                          0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              1
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

-- Adding all the Sequences and Triggers to the end that Oracle SQL Developer Data Modeler 
-- does not create:

COMMIT;

CREATE SEQUENCE SYSS_SYS_ID_SEQ INCREMENT BY 1 START WITH 11 NOCACHE;
CREATE OR REPLACE TRIGGER SYSS_SYS_ID_TRG 
   BEFORE INSERT ON SYSS 
      FOR EACH ROW 
         BEGIN 
           IF (:NEW.SYS_ID is null) THEN
             SELECT SYSS_SYS_ID_SEQ.nextval INTO :NEW.SYS_ID FROM DUAL; 
           END IF;
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.SYSCREATED FROM DUAL;
         END SYSS_SYS_ID_TRG;
/

CREATE SEQUENCE SYSCONFIGCONTEXT_CTX_ID_SEQ INCREMENT BY 1 START WITH 1 NOCACHE;
CREATE OR REPLACE TRIGGER SYSCONFIGCONTEXT_CTX_ID_TRG 
   BEFORE INSERT ON SYSCONFIGCONTEXT 
      FOR EACH ROW 
         BEGIN 
           IF (:NEW.CTX_ID is null) THEN
              SELECT SYSCONFIGCONTEXT_CTX_ID_SEQ.nextval INTO :NEW.CTX_ID FROM DUAL; 
           END IF;
         END SYSCONFIGCONTEXT_CTX_ID_TRG;
/

CREATE SEQUENCE ALS_AL_ID_SEQ INCREMENT BY 1 START WITH 101 NOCACHE;
CREATE OR REPLACE TRIGGER ALS_AL_ID_TRG 
   BEFORE INSERT ON ALS 
      FOR EACH ROW 
         BEGIN 
           IF (:NEW.AL_ID is null) THEN
              SELECT ALS_AL_ID_SEQ.nextval INTO :NEW.AL_ID FROM DUAL; 
           END IF;
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.ALCREATED FROM DUAL;
         END ALS_AL_ID_TRG;
/

CREATE SEQUENCE ALCONFIGCONTEXT_CTX_ID_SEQ INCREMENT BY 1 START WITH 1 NOCACHE;
CREATE OR REPLACE TRIGGER ALCONFIGCONTEXT_CTX_ID_TRG 
   BEFORE INSERT ON ALCONFIGCONTEXT 
      FOR EACH ROW 
         BEGIN 
           IF (:NEW.CTX_ID is null) THEN
              SELECT ALCONFIGCONTEXT_CTX_ID_SEQ.nextval INTO :NEW.CTX_ID FROM DUAL; 
           END IF;
         END ALCONFIGCONTEXT_CTX_ID_TRG;
/


CREATE SEQUENCE APPS_APP_ID_SEQ INCREMENT BY 1 START WITH 1001 NOCACHE;
CREATE OR REPLACE TRIGGER APPS_APP_ID_TRG 
   BEFORE INSERT ON APPS 
      FOR EACH ROW 
         BEGIN 
           IF (:NEW.APP_ID is null) THEN
              SELECT APPS_APP_ID_SEQ.nextval INTO :NEW.APP_ID FROM DUAL; 
           END IF;
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.APPCREATED FROM DUAL;
         END APPS_APP_ID_TRG;
/

CREATE SEQUENCE APPCONFIGCONTEXT_CTX_ID_SEQ INCREMENT BY 1 START WITH 1 NOCACHE;
CREATE OR REPLACE TRIGGER APPCONFIGCONTEXT_CTX_ID_TRG 
   BEFORE INSERT ON APPCONFIGCONTEXT 
      FOR EACH ROW 
         BEGIN 
           IF (:NEW.CTX_ID is null) THEN
              SELECT APPCONFIGCONTEXT_CTX_ID_SEQ.nextval INTO :NEW.CTX_ID FROM DUAL; 
           END IF;
         END APPCONFIGCONTEXT_CTX_ID_TRG;
/


CREATE OR REPLACE TRIGGER SYSCFGCTX_BEFINS_TRG 
   BEFORE INSERT ON SYSCONFIGCONTEXT
      FOR EACH ROW 
         BEGIN 
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.CREATETIME FROM DUAL;
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.MODIFYTIME FROM DUAL;
         END SYSCFGCTX_BEFINS_TRG;
/

CREATE OR REPLACE TRIGGER SYSCFGCTX_BEFUPD_TRG 
   BEFORE UPDATE ON SYSCONFIGCONTEXT
      FOR EACH ROW 
         BEGIN 
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.MODIFYTIME FROM DUAL;
         END SYSCFGCTX_BEFUPD_TRG;
/

CREATE OR REPLACE TRIGGER ALCFGCTX_BEFINS_TRG 
   BEFORE INSERT ON ALCONFIGCONTEXT
      FOR EACH ROW 
         BEGIN 
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.CREATETIME FROM DUAL;
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.MODIFYTIME FROM DUAL;
         END ALCFGCTX_BEFINS_TRG;
/

CREATE OR REPLACE TRIGGER ALCFGCTX_BEFUPD_TRG 
   BEFORE UPDATE ON ALCONFIGCONTEXT
      FOR EACH ROW 
         BEGIN 
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.MODIFYTIME FROM DUAL;
         END ALCFGCX_BEFUPD_TRG;
/

CREATE OR REPLACE TRIGGER APPCFGCTX_BEFINS_TRG 
   BEFORE INSERT ON APPCONFIGCONTEXT
      FOR EACH ROW 
         BEGIN 
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.CREATETIME FROM DUAL;
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.MODIFYTIME FROM DUAL;
         END APPCFGCTX_BEFINS_TRG;
/

CREATE OR REPLACE TRIGGER APPCFGCTX_BEFUPD_TRG 
   BEFORE UPDATE ON APPCONFIGCONTEXT
      FOR EACH ROW 
         BEGIN 
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.MODIFYTIME FROM DUAL;
         END APPCFGCTX_BEFUPD_TRG;
/

CREATE SEQUENCE CFGCTXLOG_ID_SEQ INCREMENT BY 1 START WITH 1 NOCACHE;
CREATE OR REPLACE TRIGGER CFGCTXLOG_ID_TRG 
   BEFORE INSERT ON CONFIGCONTEXTLOG
      FOR EACH ROW 
         BEGIN 
           IF (:NEW.LOG_ID is null OR :NEW.LOG_ID = 0) THEN
             SELECT CFGCTXLOG_ID_SEQ.nextval INTO :NEW.LOG_ID FROM DUAL; 
           END IF;
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.LOGTIME FROM DUAL;
         END CFGCTXLOG_ID_TRG;
/

CREATE OR REPLACE TRIGGER SYSCFGCTX_INS_TRG 
   AFTER INSERT ON SYSCONFIGCONTEXT
      FOR EACH ROW
         BEGIN
            INSERT INTO CONFIGCONTEXTLOG (
                SYS_ID,CTX_ID,CONTEXT_NAME,GROUP_NAME,PROPERTY,VALUE,
                VALUE_TYPE,VALUE_REF,GROUPSEQ,CATEGORY,ACTIVE,IS_SECRET,IS_ENCRYPT,
                CREATETIME,MODIFYTIME,USERTAG1,NOTES,USER_ID,USER_NAME,ACTION
            ) VALUES (
                :NEW.SYS_ID,:NEW.CTX_ID,:NEW.CONTEXT_NAME,:NEW.GROUP_NAME,:NEW.PROPERTY,:NEW.VALUE,
                :NEW.VALUE_TYPE,:NEW.VALUE_REF,:NEW.GROUPSEQ,:NEW.CATEGORY,:NEW.ACTIVE,:NEW.IS_SECRET,:NEW.IS_ENCRYPT,
                :NEW.CREATETIME,:NEW.MODIFYTIME,:NEW.USERTAG1,:NEW.NOTES,:NEW.USER_ID,:NEW.USER_NAME,0
            );
         END SYSCFGCTX_INS_TRG;
/

CREATE OR REPLACE TRIGGER SYSCFGCTX_UPD_TRG 
   AFTER UPDATE ON SYSCONFIGCONTEXT 
      FOR EACH ROW
         BEGIN
            INSERT INTO CONFIGCONTEXTLOG (
                SYS_ID,CTX_ID,CONTEXT_NAME,GROUP_NAME,PROPERTY,VALUE,
                GROUPSEQ,CATEGORY,ACTIVE,IS_SECRET,IS_ENCRYPT,
                CREATETIME,MODIFYTIME,USERTAG1,NOTES,USER_ID,USER_NAME,ACTION
            ) VALUES (
                :OLD.SYS_ID,:OLD.CTX_ID,:OLD.CONTEXT_NAME,:OLD.GROUP_NAME,:OLD.PROPERTY,:OLD.VALUE,
                :OLD.GROUPSEQ,:OLD.CATEGORY,:OLD.ACTIVE,:OLD.IS_SECRET,:OLD.IS_ENCRYPT,
                :OLD.CREATETIME,:OLD.MODIFYTIME,:OLD.USERTAG1,:OLD.NOTES,:OLD.USER_ID,:OLD.USER_NAME,1
            );
         END SYSCFGCTX_UPD_TRG;
/

CREATE OR REPLACE TRIGGER SYSCFGCTX_DEL_TRG 
   AFTER DELETE ON SYSCONFIGCONTEXT
      FOR EACH ROW
         BEGIN
            INSERT INTO CONFIGCONTEXTLOG (
                SYS_ID,CTX_ID,CONTEXT_NAME,GROUP_NAME,PROPERTY,VALUE,
                GROUPSEQ,CATEGORY,ACTIVE,IS_SECRET,IS_ENCRYPT,
                CREATETIME,MODIFYTIME,USERTAG1,NOTES,USER_ID,USER_NAME,ACTION
            ) VALUES (
                :OLD.SYS_ID,:OLD.CTX_ID,:OLD.CONTEXT_NAME,:OLD.GROUP_NAME,:OLD.PROPERTY,:OLD.VALUE,
                :OLD.GROUPSEQ,:OLD.CATEGORY,:OLD.ACTIVE,:OLD.IS_SECRET,:OLD.IS_ENCRYPT,
                :OLD.CREATETIME,:OLD.MODIFYTIME,:OLD.USERTAG1,:OLD.NOTES,:OLD.USER_ID,:OLD.USER_NAME,2
            );
         END SYSCFGCTX_DEL_TRG;
/

CREATE OR REPLACE TRIGGER ALCFGCTX_INS_TRG 
   AFTER INSERT ON ALCONFIGCONTEXT 
      FOR EACH ROW
         BEGIN
            INSERT INTO CONFIGCONTEXTLOG (
                SYS_ID,AL_ID,CTX_ID,CONTEXT_NAME,GROUP_NAME,PROPERTY,VALUE,
                GROUPSEQ,CATEGORY,ACTIVE,IS_SECRET,IS_ENCRYPT,
                CREATETIME,MODIFYTIME,USERTAG1,NOTES,USER_ID,USER_NAME,ACTION
            ) VALUES (
                :NEW.SYS_ID,:NEW.AL_ID,:NEW.CTX_ID,:NEW.CONTEXT_NAME,:NEW.GROUP_NAME,:NEW.PROPERTY,:NEW.VALUE,
                :NEW.GROUPSEQ,:NEW.CATEGORY,:NEW.ACTIVE,:NEW.IS_SECRET,:NEW.IS_ENCRYPT,
                :NEW.CREATETIME,:NEW.MODIFYTIME,:NEW.USERTAG1,:NEW.NOTES,:NEW.USER_ID,:NEW.USER_NAME,0
            );
         END ALCFGCTX_INS_TRG;
/

CREATE OR REPLACE TRIGGER ALCFGCTX_UPD_TRG 
   AFTER UPDATE ON ALCONFIGCONTEXT
      FOR EACH ROW
         BEGIN
            INSERT INTO CONFIGCONTEXTLOG (
                SYS_ID,AL_ID,CTX_ID,CONTEXT_NAME,GROUP_NAME,PROPERTY,VALUE,
                GROUPSEQ,CATEGORY,ACTIVE,IS_SECRET,IS_ENCRYPT,
                CREATETIME,MODIFYTIME,USERTAG1,NOTES,USER_ID,USER_NAME,ACTION
            ) VALUES (
                :OLD.SYS_ID,:OLD.AL_ID,:OLD.CTX_ID,:OLD.CONTEXT_NAME,:OLD.GROUP_NAME,:OLD.PROPERTY,:OLD.VALUE,
                :OLD.GROUPSEQ,:OLD.CATEGORY,:OLD.ACTIVE,:OLD.IS_SECRET,:OLD.IS_ENCRYPT,
                :OLD.CREATETIME,:OLD.MODIFYTIME,:OLD.USERTAG1,:OLD.NOTES,:OLD.USER_ID,:OLD.USER_NAME,1
            );
         END ALCFGCTX_UPD_TRG;
/

CREATE OR REPLACE TRIGGER ALCFGCTX_DEL_TRG 
   AFTER DELETE ON ALCONFIGCONTEXT
      FOR EACH ROW
         BEGIN
            INSERT INTO CONFIGCONTEXTLOG (
                SYS_ID,AL_ID,CTX_ID,CONTEXT_NAME,GROUP_NAME,PROPERTY,VALUE,
                GROUPSEQ,CATEGORY,ACTIVE,IS_SECRET,IS_ENCRYPT,
                CREATETIME,MODIFYTIME,USERTAG1,NOTES,USER_ID,USER_NAME,ACTION
            ) VALUES (
                :OLD.SYS_ID,:OLD.AL_ID,:OLD.CTX_ID,:OLD.CONTEXT_NAME,:OLD.GROUP_NAME,:OLD.PROPERTY,:OLD.VALUE,
                :OLD.GROUPSEQ,:OLD.CATEGORY,:OLD.ACTIVE,:OLD.IS_SECRET,:OLD.IS_ENCRYPT,
                :OLD.CREATETIME,:OLD.MODIFYTIME,:OLD.USERTAG1,:OLD.NOTES,:OLD.USER_ID,:OLD.USER_NAME,2
            );
         END ALCFGCTX_DEL_TRG;
/

CREATE OR REPLACE TRIGGER APPCFGCTX_INS_TRG 
   AFTER INSERT ON APPCONFIGCONTEXT 
      FOR EACH ROW
         BEGIN
            INSERT INTO CONFIGCONTEXTLOG (
                SYS_ID,AL_ID,APP_ID,CTX_ID,CONTEXT_NAME,GROUP_NAME,PROPERTY,VALUE,
                GROUPSEQ,CATEGORY,ACTIVE,IS_SECRET,IS_ENCRYPT,
                CREATETIME,MODIFYTIME,USERTAG1,NOTES,USER_ID,USER_NAME,ACTION
            ) VALUES (
                :NEW.SYS_ID,:NEW.AL_ID,:NEW.APP_ID,:NEW.CTX_ID,:NEW.CONTEXT_NAME,:NEW.GROUP_NAME,:NEW.PROPERTY,:NEW.VALUE,
                :NEW.GROUPSEQ,:NEW.CATEGORY,:NEW.ACTIVE,:NEW.IS_SECRET,:NEW.IS_ENCRYPT,
                :NEW.CREATETIME,:NEW.MODIFYTIME,:NEW.USERTAG1,:NEW.NOTES,:NEW.USER_ID,:NEW.USER_NAME,0
            );
         END APPCFGCTX_INS_TRG;
/

CREATE OR REPLACE TRIGGER APPCFGCTX_UPD_TRG 
   AFTER UPDATE ON APPCONFIGCONTEXT
      FOR EACH ROW
         BEGIN
            INSERT INTO CONFIGCONTEXTLOG (
                SYS_ID,AL_ID,APP_ID,CTX_ID,CONTEXT_NAME,GROUP_NAME,PROPERTY,VALUE,
                GROUPSEQ,CATEGORY,ACTIVE,IS_SECRET,IS_ENCRYPT,
                CREATETIME,MODIFYTIME,USERTAG1,NOTES,USER_ID,USER_NAME,ACTION
            ) VALUES (
                :OLD.SYS_ID,:OLD.AL_ID,:OLD.APP_ID,:OLD.CTX_ID,:OLD.CONTEXT_NAME,:OLD.GROUP_NAME,:OLD.PROPERTY,:OLD.VALUE,
                :OLD.GROUPSEQ,:OLD.CATEGORY,:OLD.ACTIVE,:OLD.IS_SECRET,:OLD.IS_ENCRYPT,
                :OLD.CREATETIME,:OLD.MODIFYTIME,:OLD.USERTAG1,:OLD.NOTES,:OLD.USER_ID,:OLD.USER_NAME,1
            );
         END APPCFGCTX_UPD_TRG;
/

CREATE OR REPLACE TRIGGER APPCFGCTX_DEL_TRG 
   AFTER DELETE ON APPCONFIGCONTEXT
      FOR EACH ROW
         BEGIN
            INSERT INTO CONFIGCONTEXTLOG (
                SYS_ID,AL_ID,APP_ID,CTX_ID,CONTEXT_NAME,GROUP_NAME,PROPERTY,VALUE,
                GROUPSEQ,CATEGORY,ACTIVE,IS_SECRET,IS_ENCRYPT,
                CREATETIME,MODIFYTIME,USERTAG1,NOTES,USER_ID,ACTION
            ) VALUES (
                :OLD.SYS_ID,:OLD.AL_ID,:OLD.APP_ID,:OLD.CTX_ID,:OLD.CONTEXT_NAME,:OLD.GROUP_NAME,:OLD.PROPERTY,:OLD.VALUE,
                :OLD.GROUPSEQ,:OLD.CATEGORY,:OLD.ACTIVE,:OLD.IS_SECRET,:OLD.IS_ENCRYPT,
                :OLD.CREATETIME,:OLD.MODIFYTIME,:OLD.USERTAG1,:OLD.NOTES,:OLD.USER_ID,2
            );
         END APPCFGCTX_DEL_TRG;
/

CREATE OR REPLACE TRIGGER DMKR_STAT_INFO_INS_TRG 
   BEFORE INSERT ON DMKR_STAT_INFO
      FOR EACH ROW 
         BEGIN 
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.STATTIME FROM DUAL;
         END DMKR_TABLE_STAT_UPD_TRG;
/

CREATE OR REPLACE TRIGGER DMKR_STAT_INFO_UPD_TRG 
   BEFORE UPDATE ON DMKR_STAT_INFO
      FOR EACH ROW 
         BEGIN 
           SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.STATTIME FROM DUAL;
         END DMKR_STAT_INFO_UPD_TRG;
/

CREATE OR REPLACE TRIGGER DMKR_TRANSLAT_INS_TRG 
   AFTER INSERT ON DMKR_TRANSLAT
      FOR EACH ROW
         BEGIN
            UPDATE DMKR_STAT_INFO SET STATACTION=0 WHERE STATNAME='DMKR_TRANSLAT';
         END DMKR_TRANSLAT_INS_TRG;
/

CREATE OR REPLACE TRIGGER DMKR_TRANSLAT_UPD_TRG 
   AFTER UPDATE ON DMKR_TRANSLAT
      FOR EACH ROW
         BEGIN
            UPDATE DMKR_STAT_INFO SET STATACTION=1 WHERE STATNAME='DMKR_TRANSLAT';
         END DMKR_TRANSLAT_UPD_TRG;
/

CREATE OR REPLACE TRIGGER DMKR_TRANSLAT_DEL_TRG 
   AFTER DELETE ON DMKR_TRANSLAT
      FOR EACH ROW
         BEGIN
            UPDATE DMKR_STAT_INFO SET STATACTION=2 WHERE STATNAME='DMKR_TRANSLAT';
         END DMKR_TRANSLAT_DEL_TRG;
/


COMMIT;


ALTER TABLE DMKR_APPRLEVELSENTITIES
ADD CONSTRAINT DMKR_APPRLEVELSENTITIES_FK1 FOREIGN KEY
(
  APP_ID 
, LEVELNUM 
)
REFERENCES DMKR_APPROVERLEVELS
(
  APP_ID 
, LEVELNUM 
)
ON DELETE CASCADE ENABLE;

COMMIT;


CREATE SEQUENCE DMKR_ABILITYSETS_SEQ  INCREMENT BY 1 START WITH 1001 CACHE 20 NOORDER NOCYCLE ;
CREATE OR REPLACE TRIGGER DMKR_ABILITYSETS_TRG 
   BEFORE INSERT ON DMKR_ABILITYSETS 
      FOR EACH ROW 
         BEGIN
            IF (:NEW.ID is null) THEN
              SELECT DMKR_ABILITYSETS_SEQ.NEXTVAL INTO :NEW.ID FROM DUAL;
            END IF;
         END DMKR_ABILITYSETS_TRG;
/

CREATE SEQUENCE DMKR_ENTITIES_SEQ  INCREMENT BY 1 START WITH 1001 CACHE 20 NOORDER NOCYCLE ;
CREATE OR REPLACE TRIGGER DMKR_ENTITIES_TRG 
   BEFORE INSERT ON DMKR_ENTITIES 
      FOR EACH ROW 
         BEGIN
            SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.LAST_UPDATE FROM DUAL;
            UPDATE DMKR_STAT_INFO SET STATACTION=0 WHERE STATNAME='DMKR_ENTITIES';
         END DMKR_ENTITIES_TRG;
/

CREATE OR REPLACE TRIGGER DMKR_ENTITIES_UPD_TRG 
   BEFORE UPDATE ON DMKR_ENTITIES 
      FOR EACH ROW 
         BEGIN
            SELECT TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP AT TIME ZONE 'GMT','YYYY.MM.DD HH24:MI:SS.FF'),'YYYY.MM.DD HH24:MI:SS.FF') INTO :NEW.LAST_UPDATE FROM DUAL;
            UPDATE DMKR_STAT_INFO SET STATACTION=1 WHERE STATNAME='DMKR_ENTITIES';
         END DMKR_ENTITIES_UPD_TRG;
/

CREATE OR REPLACE TRIGGER DMKR_ENTITIES_DEL_TRG 
   AFTER DELETE ON DMKR_ENTITIES 
      FOR EACH ROW 
         BEGIN
            UPDATE DMKR_STAT_INFO SET STATACTION=2 WHERE STATNAME='DMKR_ENTITIES';
         END DMKR_ENTITIES_DEL_TRG;
/

COMMIT;


---- Required Data Section:
---- Registry Tables
REM INSERTING into SYSS
Insert into SYSS (SYS_ID,SYSNAME,SYSTYPE,SYSDESCR,SYSUNIQUE_ID) values ( &system_id. , '&system_name.' , null , '&system_name. Group' , '&system_id.ps4YCyf9sumchSpGh-qUxg11313-Arfe032' );

REM INSERTING into SYSCONFIGCONTEXT
Insert into SYSCONFIGCONTEXT (SYS_ID,CONTEXT_NAME,CATEGORY,GROUP_NAME,PROPERTY,VALUE,ACTIVE,USERTAG1,NOTES,USER_ID,USER_NAME) values ( &system_id. ,'INSTALLER' , 'INFO' , 'DBSCHEMA' ,'VERSION','12.6.4' , 1 , null , null , null , 'installer' );
Insert into SYSCONFIGCONTEXT (SYS_ID,CONTEXT_NAME,CATEGORY,GROUP_NAME,PROPERTY,VALUE,ACTIVE,USERTAG1,NOTES,USER_ID,USER_NAME) values ( &system_id. ,'LOG4J' , 'Loggers' , 'Logger' ,'name' , 'root' , 1 , null , 'The root fall-back logger for a Log4J configuration.' , null , 'installer' );
Insert into SYSCONFIGCONTEXT (SYS_ID,CONTEXT_NAME,CATEGORY,GROUP_NAME,PROPERTY,VALUE,ACTIVE,USERTAG1,NOTES,USER_ID,USER_NAME) values ( &system_id. ,'LOG4J' , 'Logger' , 'root' ,'additivity' , 'false' , 1 , null , null , null , 'installer' );
Insert into SYSCONFIGCONTEXT (SYS_ID,CONTEXT_NAME,CATEGORY,GROUP_NAME,PROPERTY,VALUE,ACTIVE,USERTAG1,NOTES,USER_ID,USER_NAME) values ( &system_id. ,'LOG4J' , 'Logger' , 'root' , 'class' , 'oracle.documaker.log4j.logger.DFLogger' , 1 , null , null , null , 'installer' );
Insert into SYSCONFIGCONTEXT (SYS_ID,CONTEXT_NAME,CATEGORY,GROUP_NAME,PROPERTY,VALUE,ACTIVE,USERTAG1,NOTES,USER_ID,USER_NAME) values ( &system_id. ,'LOG4J' , 'Logger' , 'root' , 'appender-ref' , 'stdout' , 1 , null , null , null , 'installer' );
Insert into SYSCONFIGCONTEXT (SYS_ID,CONTEXT_NAME,CATEGORY,GROUP_NAME,PROPERTY,VALUE,ACTIVE,USERTAG1,NOTES,USER_ID,USER_NAME) values ( &system_id. ,'LOG4J' , 'Logger' , 'root' , 'appender-ref' , 'roll' , 1 , null , null , null , 'installer' );
Insert into SYSCONFIGCONTEXT (SYS_ID,CONTEXT_NAME,CATEGORY,GROUP_NAME,PROPERTY,VALUE,ACTIVE,USERTAG1,NOTES,USER_ID,USER_NAME) values ( &system_id. ,'LOG4J' , 'Logger' , 'root' , 'priority' , 'error' , 1 , null , null , null , 'installer' );


REM INSERTING into ALS
Insert into ALS (SYS_ID,AL_ID,ALNAME,ALTYPE,ALDESCR,ALUNIQUE_ID) values ( &system_id. , 0 , 'All' , null , 'Factory Across All Assembly Lines' , '&system_id.0-v4CuBpTwirWPbhpJ4wyI0gR7h1zcyvXVB' );

REM INSERTING into APPS
Insert into APPS (SYS_ID,AL_ID,APP_ID,APPNAME,APPTYPE,APPDESCR,APPUNIQUE_ID) VALUES ( &system_id. , 0 , 101 , 'DocumakerAdmin' , 101 , 'Documaker Administrator Application' , '&system_id.0-tZiBv192a-6363-4f5b-ad-0f250d1a92' );
Insert into APPS (SYS_ID,AL_ID,APP_ID,APPNAME,APPTYPE,APPDESCR,APPUNIQUE_ID) values ( &system_id. , 0 , 111 , 'DocumakerDashboard' , 111 , 'Documaker Dashboard Application' , '&system_id.0-7ce6-4dc2-b63a-e765b76a8f6a-afZ5W' );

REM INSERTING into APPCONFIGCONTEXT
Insert into APPCONFIGCONTEXT (SYS_ID,AL_ID,APP_ID,CONTEXT_NAME,CATEGORY,GROUP_NAME,PROPERTY,VALUE,ACTIVE,USERTAG1,NOTES,USER_ID,USER_NAME) values ( &system_id. , 0 , 101 , 'HELP' , 'HLP' , 'general' , 'helpLink' , '//DocumakerAdministratorHelp/index.html' , 1 , null , null , null , 'installer' );
Insert into APPCONFIGCONTEXT (SYS_ID,AL_ID,APP_ID,CONTEXT_NAME,CATEGORY,GROUP_NAME,PROPERTY,VALUE,ACTIVE,USERTAG1,NOTES,USER_ID,USER_NAME) values ( &system_id. , 0 , 111 , 'HELP' , 'HLP' , 'general' ,  'helpLink' , '//DocumakerDashboardHelp/index.html' , 1 , null , null , null , 'installer' );


-- Abilities and Entities

-- Insert the ability sets which define the application roles (these are non-editable)
REM INSERTING into DMKR_ABILITYSETS
Insert into DMKR_ABILITYSETS (ID,APP_ID,NAME,DESCRIPTION,EDITABLE) values ( 1 , 201 , 'Approvers' , 'These users can approve transactions for distribution.' , 0 );
Insert into DMKR_ABILITYSETS (ID,APP_ID,NAME,DESCRIPTION,EDITABLE) values ( 2 , 201 , 'Drafters' , 'These users can create transactions for approval.' , 0 );
Insert into DMKR_ABILITYSETS (ID,APP_ID,NAME,DESCRIPTION,EDITABLE) values ( 3 , 201 , 'Administrators' , 'These users can administrate.', 0 );
Insert into DMKR_ABILITYSETS (ID,APP_ID,NAME,DESCRIPTION,EDITABLE) values ( 6 , 101 , 'Documaker Administrator' , 'These users can administrate the Documaker System.' , 0 );


-- Insert the application abilities
REM INSERTING into DMKR_ABILITIES
Insert into DMKR_ABILITIES (ID,NAME) values (1,'WIP_SHOW');
Insert into DMKR_ABILITIES (ID,NAME) values (2,'WIP_ACTION_DELETE');
Insert into DMKR_ABILITIES (ID,NAME) values (3,'WIP_ACTION_TOGGLE');
Insert into DMKR_ABILITIES (ID,NAME) values (4,'WIP_ACTION_MANUAL_ASSIGN');
Insert into DMKR_ABILITIES (ID,NAME) values (5,'WIP_ACTION_CANCELDISTRIBUTION');
Insert into DMKR_ABILITIES (ID,NAME) values (6,'WIP_ACTION_PREVIEW');
Insert into DMKR_ABILITIES (ID,NAME) values (7,'WIP_ACTION_EDIT');
Insert into DMKR_ABILITIES (ID,NAME) values (8,'WIP_ACTION_NEWDOCUMENT');
Insert into DMKR_ABILITIES (ID,NAME) values (9,'WIP_ACTION_REJECT');
Insert into DMKR_ABILITIES (ID,NAME) values (10,'WIP_ACTION_SUBMIT');
Insert into DMKR_ABILITIES (ID,NAME) values (11,'WIP_ACTION_APPROVE');
Insert into DMKR_ABILITIES (ID,NAME) values (12,'WIP_ACTION_COMPOSE');
Insert into DMKR_ABILITIES (ID,NAME) values (13,'WIP_ACTION_SEARCH');
Insert into DMKR_ABILITIES (ID,NAME) values (14,'WIP_ACTION_REFRESH');
Insert into DMKR_ABILITIES (ID,NAME) values (15,'WIP_TAB_COMPLETE');
Insert into DMKR_ABILITIES (ID,NAME) values (16,'WIP_TAB_UNASSIGNED');
Insert into DMKR_ABILITIES (ID,NAME) values (17,'WIP_TAB_REVIEW');
Insert into DMKR_ABILITIES (ID,NAME) values (18,'WIP_TAB_PENDING');
Insert into DMKR_ABILITIES (ID,NAME) values (19,'WIP_TAB_ASSIGNMENT');
Insert into DMKR_ABILITIES (ID,NAME) values (20,'ENTRY_ACTION_FORMLIST_SHOW');
Insert into DMKR_ABILITIES (ID,NAME) values (21,'ENTRY_ACTION_FORMLIST_LIST');
Insert into DMKR_ABILITIES (ID,NAME) values (22,'ENTRY_ACTION_FORMLIST_ADD');
Insert into DMKR_ABILITIES (ID,NAME) values (23,'ENTRY_ACTION_FORMLIST_DELETE');
Insert into DMKR_ABILITIES (ID,NAME) values (24,'ENTRY_ACTION_FORMLIST_ADDFAVORITE');
Insert into DMKR_ABILITIES (ID,NAME) values (25,'FAVORITE_SHOW');
Insert into DMKR_ABILITIES (ID,NAME) values (26,'FAVORITE_ACTION_DELETE');
Insert into DMKR_ABILITIES (ID,NAME) values (27,'FAVORITES_ACTION_SAVE');
Insert into DMKR_ABILITIES (ID,NAME) values (28,'FAVORITE_ACTION_ADD');
Insert into DMKR_ABILITIES (ID,NAME) values (29,'FAVORITE_ACTION_REARRANGE');
Insert into DMKR_ABILITIES (ID,NAME) values (30,'ENTRY_ACTION_ADDRESSEE_SHOW');
Insert into DMKR_ABILITIES (ID,NAME) values (31,'ENTRY_ACTION_ADDRESSEEDIST_SHOW');
Insert into DMKR_ABILITIES (ID,NAME) values (32,'ENTRY_ACTION_ADDRESSEEDETAIL_SHOW');
Insert into DMKR_ABILITIES (ID,NAME) values (33,'ENTRY_ACTION_DISTRIBUTION_CREATE');
Insert into DMKR_ABILITIES (ID,NAME) values (34,'ENTRY_ACTION_ADDRESSEE_LIST');
Insert into DMKR_ABILITIES (ID,NAME) values (35,'ENTRY_ACTION_DISTRIBUTION_DELETE');
Insert into DMKR_ABILITIES (ID,NAME) values (36,'ENTRY_ACTION_ADDRESSEEDIST_SAVE');
Insert into DMKR_ABILITIES (ID,NAME) values (37,'ENTRY_ACTION_ADDRESSEEDIST_SAVEADD');
Insert into DMKR_ABILITIES (ID,NAME) values (38,'ENTRY_ACTION_ADDRESSEEDIST_CANCEL');
Insert into DMKR_ABILITIES (ID,NAME) values (39,'ENTRY_ACTION_ADDRESSEEDETAIL_ADD');
Insert into DMKR_ABILITIES (ID,NAME) values (40,'ENTRY_ACTION_ADDRESSEEDETAIL_DELETE');
Insert into DMKR_ABILITIES (ID,NAME) values (41,'ENTRY_ACTION_ATTACHMENTS_SHOW');
Insert into DMKR_ABILITIES (ID,NAME) values (42,'ENTRY_ACTION_ATTACHMENTS_LIST');
Insert into DMKR_ABILITIES (ID,NAME) values (43,'ENTRY_ACTION_ATTACHMENTS_ADD');
Insert into DMKR_ABILITIES (ID,NAME) values (44,'ENTRY_ACTION_ATTACHMENTS_DELETE');
Insert into DMKR_ABILITIES (ID,NAME) values (45,'WIP_TAB_PROPS');
Insert into DMKR_ABILITIES (ID,NAME) values (46,'WIP_TAB_ADVPROPS');
Insert into DMKR_ABILITIES (ID,NAME) values (47,'WIP_TAB_FORMS');
Insert into DMKR_ABILITIES (ID,NAME) values (48,'WIP_TAB_ATTACH');
Insert into DMKR_ABILITIES (ID,NAME) values (49,'WIP_TAB_DISTRIB');
Insert into DMKR_ABILITIES (ID,NAME) values (50,'WIP_TAB_HISTORY');
Insert into DMKR_ABILITIES (ID,NAME) values (51,'WIP_ACTION_FORM_ATTACHMENT_DIST_PREVIEW');
Insert into DMKR_ABILITIES (ID,NAME) values (52,'NAVTAB_FORMS');
Insert into DMKR_ABILITIES (ID,NAME) values (53,'NAVTAB_ATTACHMENTS');
Insert into DMKR_ABILITIES (ID,NAME) values (54,'NAVTAB_ADDRESSEES');
Insert into DMKR_ABILITIES (ID,NAME) values (55,'NAVTAB_DOCUMENTS');
Insert into DMKR_ABILITIES (ID,NAME) values (56,'SAVE_TRANSACTION');
Insert into DMKR_ABILITIES (ID,NAME) values (57,'FAVORITE_BASKET_SHOW');
Insert into DMKR_ABILITIES (ID,NAME) values (58,'WIP_TAB_TRACKING');
Insert into DMKR_ABILITIES (ID,NAME) values (59,'NAVTAB_ATTACHMENTS_UCM');
Insert into DMKR_ABILITIES (ID,NAME) values (60,'NAVTAB_ATTACHMENTS_LFS');
Insert into DMKR_ABILITIES (ID,NAME) values (61,'WIP_ACTION_EXTERNAL');
Insert into DMKR_ABILITIES (ID,NAME) values (62,'WIP_ACTION_EXTERNAL_FILE');
Insert into DMKR_ABILITIES (ID,NAME) values ( 63 ,'ENTRY_ACTION_EDIT_ALL');
Insert into DMKR_ABILITIES (ID,NAME) values ( 64 ,'WIP_ACTION_VIEW_COMPARE');
Insert into DMKR_ABILITIES (ID,NAME) values ( 65 ,'WIP_ACTION_ADJUST_COMPARE');
Insert into DMKR_ABILITIES (ID,NAME) values ( 66 ,'NAVTAB_COMPARE');
Insert into DMKR_ABILITIES (ID,NAME) values ( 67 ,'ENTRY_ACTION_PLUGINSAVE');
Insert into DMKR_ABILITIES (ID,NAME) values ( 68 ,'ENTRY_ACTION_PLUGINSAVE_COMPARE'); 
Insert into DMKR_ABILITIES (ID,NAME) values ( 69 ,'ANALYTICS_SHOW');
Insert into DMKR_ABILITIES (ID,NAME) values ( 70 ,'OJET_WIPEDIT');
Insert into DMKR_ABILITIES (ID,NAME) values ( 71 ,'OJET_WIP_ACTION_SUBMIT');
Insert into DMKR_ABILITIES (ID,NAME) values ( 72 ,'OJET_WIP_ACTION_SAVE');
Insert into DMKR_ABILITIES (ID,NAME) values ( 73 ,'WIP_ACTION_SAVE');



-- Insert the links from an application type to an ability type
REM INSERTING into DMKR_APPLICATION_ABILITY
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,1);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,2);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,3);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,4);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,5);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,6);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,7);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,8);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,9);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,10);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,11);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,12);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,13);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,14);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,15);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,16);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,17);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,18);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,19);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,20);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,21);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,22);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,23);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,24);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,25);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,26);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,27);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,28);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,29);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,30);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,31);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,32);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,33);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,34);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,35);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,36);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,37);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,38);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,39);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,40);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,41);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,42);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,43);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,44);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,45);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,46);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,47);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,48);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,49);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,50);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,51);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,52);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,53);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,54);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,55);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,56);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,57);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,58);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,59);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,60);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,61);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,62);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,63);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,64);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,65);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,66);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,67);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,68);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,69);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,70);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,71);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,72);
Insert into DMKR_APPLICATION_ABILITY (APPLICATION_TYPE,ABILITY_ID) values (201,73);

-- Create the default ability type
REM INSERTING into DMKR_ABILITYTYPES
Insert into DMKR_ABILITYTYPES (ID,NAME,DESCRIPTION) values (1,'Default','The default ability type');

-- Initialize the abilities for the Approvers and Drafters ability sets
REM INSERTING into DMKR_ABILITYSET_ABILITY
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,1,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,2,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,3,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,4,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,5,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,6,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,7,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,8,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,9,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,10,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,11,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,12,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,13,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,14,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,15,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,16,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,17,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,18,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,19,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,20,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,21,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,22,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,23,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,24,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,25,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,26,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,27,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,28,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,29,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,30,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,31,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,32,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,33,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,34,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,35,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,36,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,37,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,38,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,39,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,40,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,41,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,42,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,43,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,44,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,45,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,46,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,47,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,48,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,49,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,50,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,51,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,52,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,53,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,54,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,55,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,56,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,57,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,58,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,59,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,60,1,1,1,1);

Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,1,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,2,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,3,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,4,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,5,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,6,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,7,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,8,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,9,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,10,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,11,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,12,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,13,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,14,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,15,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,16,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,17,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,18,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,19,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,20,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,21,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,22,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,23,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,24,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,25,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,26,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,27,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,28,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,29,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,30,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,31,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,32,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,33,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,34,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,35,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,36,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,37,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,38,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,39,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,40,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,41,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,42,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,43,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,44,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,45,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,46,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,47,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,48,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,49,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,50,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,51,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,52,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,53,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,54,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,55,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,56,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,57,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,58,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,59,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,60,1,1,1,1);

Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,1,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,2,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,3,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,4,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,5,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,6,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,7,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,8,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,9,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,10,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,11,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,12,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,13,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,14,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,15,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,16,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,17,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,18,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,19,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,20,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,21,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,22,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,23,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,24,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,25,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,26,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,27,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,28,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,29,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,30,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,31,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,32,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,33,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,34,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,35,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,36,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,37,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,38,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,39,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,40,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,41,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,42,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,43,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,44,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,45,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,46,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,47,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,48,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,49,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,50,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,51,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,52,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,53,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,54,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,55,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,56,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,57,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,58,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,59,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,60,1,1,1,1);

Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,61,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,62,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,61,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,62,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,61,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,62,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values ( 1 , 201 , 63 , 1 , 0 , 0 , 0 );
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values ( 2 , 201 , 63 , 1 , 0 , 0 , 0 );
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values ( 3 , 201 , 63 , 1 , 0 , 0 , 0 );

Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,64,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,64,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,64,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,65,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,65,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,65,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,66,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,66,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,66,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,67,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,67,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,67,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,68,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,68,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,68,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,69,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,69,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,69,1,1,1,1);

Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,70,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,71,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,72,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (1,201,73,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,70,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,71,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,72,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (2,201,73,1,1,1,1);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,70,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,71,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,72,1,0,0,0);
Insert into DMKR_ABILITYSET_ABILITY (ABILITYSETID,APP_ID,ABILITYID,ABILITYTYPEID,VISIBLE,EDITABLE,ACCESSIBLE) values (3,201,73,1,1,1,1);

-- BEGIN TRANSLATIONS English @
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 10 , 'en' , 'Submit' , 'Can submit a document or transaction for approval and distribution' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 11 , 'en' , 'Approve' , 'Can approve a document or transaction for further approval or distribution' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 12 , 'en' , 'Compose' , 'Can compose a document or transactions' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 13 , 'en' , 'Search' , 'Can search a document or transactions' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 14 , 'en' , 'Refresh' , 'Can refresh a document or transactions' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 15 , 'en' , 'Complete Tab' , 'Distributed(completed) tab' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 16 , 'en' , 'Unassigned Tab' , 'Unassigned tab' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 17 , 'en' , 'Review Tab' , 'For review tab' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 18 , 'en' , 'Pending Tab' , 'Pending distribution tab' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 19 , 'en' , 'Assignment' , 'My assignment tab' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 1 , 'en' , 'Group' , 'An enterprise group or role' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 20 , 'en' , 'Form list show' , 'Can show something' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 21 , 'en' , 'Form list list' , 'List all the forms' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 22 , 'en' , 'Form list add' , 'Add a form' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 23 , 'en' , 'Form list delete' , 'Delete a form' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 24 , 'en' , 'Form list add favorite' , 'Form list add favorite' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 25 , 'en' , 'Favorite show' , 'Can show favorite' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 26 , 'en' , 'Favorite delete' , 'Delete favorite' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 27 , 'en' , 'Favorite save' , 'Save favorite' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 28 , 'en' , 'Favorite add' , 'Add to favorite' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 29 , 'en' , 'Favorite rearrange' , 'Rearrange favorite' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 2 , 'en' , 'User' , 'An individual enterprise user account' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 30 , 'en' , 'Addressee show' , 'Can show addressee' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 31 , 'en' , 'Addressee Edit show' , 'Can show addressee edit' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 32 , 'en' , 'Addressee Detail show' , 'Can show addressee detail' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 33 , 'en' , 'Distribution create' , 'Create a distribution' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 34 , 'en' , 'Addressee list' , 'List all addressees' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 35 , 'en' , 'Distribution delete' , 'Delete a distribution' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 36 , 'en' , 'Addressee Edit save' , 'Save entry in addressee edit' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 37 , 'en' , 'Addressee Edit save and add' , 'Save and add entry in addressee edit' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 38 , 'en' , 'Addressee Edit Cancel' , 'Cancel entry in addressee edit' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 39 , 'en' , 'Addressee Detail add' , 'Add entry in addressee detail' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 3 , 'en' , 'Toggle' , 'Can toggle something' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 40 , 'en' , 'Addressee Detail Delete' , 'Delete entry in addressee detail' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 41 , 'en' , 'Attachment show' , 'Can show attachment' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 42 , 'en' , 'Attachment list' , 'List all the attachments' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 43 , 'en' , 'Attachment add' , 'Add an attachment' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 44 , 'en' , 'Attachment delete' , 'Delete an attachment' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 45 , 'en' , 'Props tab' , 'Properties tab' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 46 , 'en' , 'Adv Props tab' , 'Advanced Properties tab' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 47 , 'en' , 'Forms tab' , 'Forms tab' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 48 , 'en' , 'Attach tab' , 'Attachments tab' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 49 , 'en' , 'Distribution tab' , 'Distribution tab' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 4 , 'en' , 'Manual Assign' , 'Can assign a document or transaction to another user or group' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 50 , 'en' , 'History tab' , 'History tab' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 51 , 'en' , 'Refresh' , 'Refresh forms attachments distribution and preview' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 52 , 'en' , 'Forms pane' , 'Forms navigation pane' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 53 , 'en' , 'Add attachment pane' , 'Add attachment navigation pane' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 54 , 'en' , 'Update Addressees pane' , 'Update Addressees navigation pane' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 55 , 'en' , 'Document pane' , 'Document navigation pane' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 56 , 'en' , 'Save transaction button' , 'Save transaction' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 57 , 'en' , 'Show favorite basket' , 'Show favorite basket' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 58 , 'en' , 'Tracking Tab' , 'Tracking tab' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 59 , 'en' , 'Add WebCenter attachment' , 'Add WebCenter attachment' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 5 , 'en' , 'Cancel Distribution' , 'Can cancel distribution' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 60 , 'en' , 'Add LSF attachment' , 'Add LSF attachment' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 61 , 'en' , 'External Data' , 'Create new document from corporate data' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 62 , 'en' , 'External Data File' , 'Create new document from XML data file' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 63 , 'en' , 'Edit All Fields' , 'Can edit all fields regardless of field attribute.  Reserved for power user to allow editing of all fields even when entry mode of WIP is enabled within ENTRY_ACTION_PLUGIN_INIT group.' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 64 , 'en' , 'Compare Documents' , 'Compare Documents.' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 65 , 'en' , 'Compare and Adjust Documents' , 'Compare and Adjust Documents.' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 66 , 'en' , 'Compare Tab' , 'Compare Tab.' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 67 , 'en' , 'Save Document' , 'Save Document.' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 68 , 'en' , 'Save Document' , 'Save Document.' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 69 , 'en' , 'Show Analytics tab' , 'Show Analytics tab.' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 6 , 'en' , 'Preview' , 'Can preview documents or transactions' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 7 , 'en' , 'Edit' , 'Can edit documents or transactions' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 8 , 'en' , 'New Document' , 'Can create a new document' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 9 , 'en' , 'Reject' , 'Can reject a document or transaction before distribution' , 'en' );
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 70, 'en' , 'Enable Thin Client Editor', 'Enables the Thin Client Editor', 'en');
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 71, 'en' , 'Submit with Thin Client Editor', 'Can submit a document or transaction for approval and distribution using the Thin Client Editor', 'en');
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 72, 'en' , 'Save with Thin Client Editor', 'Can save the document or transaction being edited in the Thin Client Editor', 'en');
INSERT INTO DMKR_ABILITIES_TRANSLATIONS (ABILITY_ID, LANGUAGE, ABILITY_NAME, ABILITY_DESCRIPTION, SOURCE_LANG) VALUES ( 73, 'en' , 'Save with WipEdit', 'Can save the document or transaction being edited in WipEdit', 'en');


INSERT INTO DMKR_ENTITYTYPE_TRANSLATIONS (ENTITYTYPE_ID, LANGUAGE, ENTITYTYPE_NAME, ENTITYTYPE_DESCRIPTION, SOURCE_LANG) VALUES ( 1 ,'en','Group','An enterprise group or role','en');
INSERT INTO DMKR_ENTITYTYPE_TRANSLATIONS (ENTITYTYPE_ID, LANGUAGE, ENTITYTYPE_NAME, ENTITYTYPE_DESCRIPTION, SOURCE_LANG) VALUES ( 2 ,'en','User','An individual enterprise user account','en');

INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'BOOLEAN.STRING' , 'false' , 'False' , 'False' , 2 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'BOOLEAN.STRING' , 'true' , 'True' , 'True' , 1 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'CONFIGCONTEXT.VALUETYPE' , '0' , 'Alphanumeric' , 'Alphanumeric' , 1 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'CONFIGCONTEXT.VALUETYPE' , '1' , 'Alphanumeric-multiline' , 'Alphanumeric-multiline' , 2 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'CONFIGCONTEXT.VALUETYPE' , '2' , 'Numeric' , 'Numeric' , 3 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'CONFIGCONTEXT.VALUETYPE' , '3' , 'Alpha' , 'Alpha' , 4 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'CONFIGCONTEXT.VALUETYPE' , '4' , 'PickList' , 'PickList' , 5 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'CONFIGCONTEXT.VALUETYPE' , '5' , 'Boolean' , 'Boolean' , 6 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'CONFIGCONTEXT.VALUETYPE' , '6' , 'Schedule' , 'Schedule' , 7 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'CONFIGCONTEXT.VALUETYPE' , '7' , 'Date Time' , 'Date Time' , 8 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'CONFIGCONTEXT.VALUETYPE' , '8' , 'Group Name Lookup' , 'Group Name Lookup' , 9 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'FTP.PROT.LEVEL' , 'C' , 'Clear' , 'Clear' , 4 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'FTP.PROT.LEVEL' , 'E' , 'Confidential' , 'Confidential' , 2 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'FTP.PROT.LEVEL' , 'P' , 'Private' , 'Private' , 1 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'FTP.PROT.LEVEL' , 'S' , 'Safe' , 'Safe' , 3 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'FTP.PROTOCOL.TYPE' , 'ftp' , 'FTP' , 'FTP' , 1 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'FTP.PROTOCOL.TYPE' , 'ftpes' , 'FTPS Explicit' , 'FTPS Explicit' , 3 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'FTP.PROTOCOL.TYPE' , 'ftps' , 'FTPS Implicit' , 'FTPS Implicit' , 4 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'FTP.PROTOCOL.TYPE' , 'sftp' , 'Secure FTP' , 'Secure FTP' , 2 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'FTP.TRANSFER.MODE' , 'Active' , 'Active' , 'Active' , 2 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'FTP.TRANSFER.MODE' , 'Passive' , 'Passive' , 'Passive' , 1 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.FILTER.OPERATORS' , '!=' , '!=' , '!=' , 6 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.FILTER.OPERATORS' , '<=' , '<=' , '<=' , 4 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.FILTER.OPERATORS' , '<' , '<' , '<' , 1 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.FILTER.OPERATORS' , '=' , '=' , '=' , 5 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.FILTER.OPERATORS' , '>=' , '>=' , '>=' , 3 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.FILTER.OPERATORS' , '>' , '>' , '>' , 2 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.FILTER.VALUETYPES' , 'java.lang.Double' , 'java.lang.Double' , 'java.lang.Double' , 3 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.FILTER.VALUETYPES' , 'java.lang.Integer' , 'java.lang.Integer' , 'java.lang.Integer' , 2 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.FILTER.VALUETYPES' , 'java.lang.Long' , 'java.lang.Long' , 'java.lang.Long' , 4 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.FILTER.VALUETYPES' , 'java.lang.String' , 'java.lang.String' , 'java.lang.String' , 1 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.PRIORITIES' , '10' , '10' , '10' , 10 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.PRIORITIES' , '1' , '1' , '1' , 1 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.PRIORITIES' , '2' , '2' , '2' , 2 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.PRIORITIES' , '3' , '3' , '3' , 3 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.PRIORITIES' , '4' , '4' , '4' , 4 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.PRIORITIES' , '5' , '5' , '5' , 5 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.PRIORITIES' , '6' , '6' , '6' , 6 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.PRIORITIES' , '7' , '7' , '7' , 7 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.PRIORITIES' , '8' , '8' , '8' , 8 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.PRIORITIES' , '9' , '9' , '9' , 9 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.RETENTION.BASES' , 'COLUMN' , 'Column' , 'Column' , 2 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.RETENTION.BASES' , 'CURRENT_DATE' , 'Current Date' , 'Current Date' , 1 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.RETENTION.TYPES' , '1' , 'Simple' , 'Simple' , 1 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.RETENTION.TYPES' , '2' , 'Complex' , 'Complex' , 2 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.RETENTION.VALUES' , 'DAYS' , 'Days' , 'Days' , 3 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.RETENTION.VALUES' , 'MONTHS' , 'Months' , 'Months' , 2 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.RETENTION.VALUES' , 'YEARS' , 'Years' , 'Years' , 1 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.SOURCES' , 'errs' , 'Errs' , 'Errs' , 4 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.SOURCES' , 'historical' , 'Historical' , 'Historical' , 2 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.SOURCES' , 'live' , 'Live' , 'Live' , 1 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'HISTORIAN.SOURCES' , 'logs' , 'Logs' , 'Logs' , 3 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'LOG4J.LOGGER.PRIORITY' , 'all' , 'All' , 'All' , 6 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'LOG4J.LOGGER.PRIORITY' , 'debug' , 'Debug' , 'Debug' , 5 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'LOG4J.LOGGER.PRIORITY' , 'error' , 'Error' , 'Error' , 1 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'LOG4J.LOGGER.PRIORITY' , 'fatal' , 'Fatal' , 'Fatal' , 2 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'LOG4J.LOGGER.PRIORITY' , 'info' , 'Info' , 'Info' , 3 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'LOG4J.LOGGER.PRIORITY' , 'warn' , 'Warning' , 'Warning' , 4 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'ar_SA' , 'Arabic (Saudi Arabia)' , 'Arabic (Saudi Arabia)' , 1 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'de_DE' , 'German (Germany)' , 'German (Germany)' , 2 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'en_AU' , 'English (Australia)' , 'English (Australia)' , 3 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'en_CA' , 'English (Canada)' , 'English (Canada)' , 4 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'en_GB' , 'English (United Kingdom)' , 'English (United Kingdom)' , 5 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'en_US' , 'English (United States)' , 'English (United States)' , 6 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'es_ES' , 'Spanish (Spain)' , 'Spanish (Spain)' , 7 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'fr_CA' , 'French (Canada)' , 'French (Canada)' , 8 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'fr_FR' , 'French (France)' , 'French (France)' , 9 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'hi_IN' , 'Hindi (India)' , 'Hindi (India)' , 10 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'it_IT' , 'Italian (Italy)' , 'Italian (Italy)' , 11 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'iw_IL' , 'Hebrew (Israel)' , 'Hebrew (Israel)' , 12 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'ja_JP' , 'Japanese (Japan)' , 'Japanese (Japan)' , 13 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'ko_KR' , 'Korean (South Korea)' , 'Korean (South Korea)' , 14 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'nl_NL' , 'Dutch (Netherlands)' , 'Dutch (Netherlands)' , 15 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'pt_BR' , 'Portuguese (Brazil)' , 'Portuguese (Brazil)' , 16 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'sv_SE' , 'Swedish (Sweden)' , 'Swedish (Sweden)' , 17 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'th_TH_TH' , 'Thai (Thai digits) (Thailand)' , 'Thai (Thai digits) (Thailand)' , 19 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'th_TH' , 'Thai (Western digits) (Thailand)' , 'Thai (Western digits) (Thailand)' , 18 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'zh_CN' , 'Chinese (Simplified) (China)' , 'Chinese (Simplified) (China)' , 20 );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES ( &system_id. , 0 , 101 , 'en' , 'NOTIFICATION.LANGUAGES' , 'zh_TW' , 'Chinese (Traditional) (Taiwan)' , 'Chinese (Traditional) (Taiwan)' , 21 );

INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '0' , '0 - Job Not Ready' , '0 - Job Not Ready' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '101' , '101 - Job Pending' , '101 - Job Pending' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '111' , '111 - Job Ready' , '111 - Job Ready' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '121' , '121 - Job Scheduled' , '121 - Job Scheduled' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '131' , '131 - Job Processing' , '131 - Job Processing' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '141' , '141 - Job Error' , '141 - Job Error' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '190' , '190 - Job Processed' , '190 - Job Processed' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '201' , '201 - Assembly Pending' , '201 - Assembly Pending' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '211' , '211 - Assembly Ready' , '211 - Assembly Ready' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '221' , '221 - Assembly Scheduled' , '221 - Assembly Scheduled' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '231' , '231 - Assembly Processing' , '231 - Assembly Processing' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '241' , '241 - Assembly Error' , '241 - Assembly Error' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '288' , '288 - Assembly Deleted' , '288 - Assembly Deleted' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '290' , '290 - Assembly Processed' , '290 - Assembly Processed' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '301' , '301 - Distribution Pending' , '301 - Distribution Pending' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '311' , '311 - Distribution Ready' , '311 - Distribution Ready' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '321' , '321 - Distribution Scheduled' , '321 - Distribution Scheduled' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '331' , '331 - Distribution Processing' , '331 - Distribution Processing' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '341' , '341 - Distribution Error' , '341 - Distribution Error' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '390' , '390 - Distribution Processed' , '390 - Distribution Processed' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '401' , '401 - Batching Pending' , '401 - Batching Pending' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '411' , '411 - Batching Ready' , '411 - Batching Ready' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '415' , '415 - Batching Processing' , '415 - Batching Processing' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '416' , '416 - Batching Scheduled' , '416 - Batching Scheduled' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '419' , '419 - Immediate Batch Presentation Ready' , '419 - Immediate Batch Presentation Ready' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '420' , '420 - Scheduled Batch Presentation Ready' , '420 - Scheduled Batch Presentation Ready' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '421' , '421 - Presentation Scheduled' , '421 - Presentation Scheduled' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '431' , '431 - Presentation Processing' , '431 - Presentation Processing' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '441' , '441 - Presentation Error' , '441 - Presentation Error' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '490' , '490 - Presentation Completed' , '490 - Presentation Completed' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '501' , '501 - Archive Pending' , '501 - Archive Pending' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '511' , '511 - Archive Ready' , '511 - Archive Ready' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '521' , '521 - Archive Scheduled' , '521 - Archive Scheduled' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '531' , '531 - Archive Processing' , '531 - Archive Processing' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '541' , '541 - Archive Error' , '541 - Archive Error' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '590' , '590 - Archive Completed' , '590 - Archive Completed' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '601' , '601 - Publication Pending' , '601 - Publication Pending' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '611' , '611 - Publication Ready' , '611 - Publication Ready' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '621' , '621 - Publication Scheduled' , '621 - Publication Scheduled' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '631' , '631 - Publication Processing' , '631 - Publication Processing' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '641' , '641 - Publication Error' , '641 - Publication Error' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '690' , '690 - Publication Complete' , '690 - Publication Complete' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '701' , '701 - Notification Pending' , '701 - Notification Pending' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '711' , '711 - Notification Ready' , '711 - Notification Ready' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '721' , '721 - Notification Scheduled' , '721 - Notification Scheduled' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '731' , '731 - Notification Processing' , '731 - Notification Processing' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '741' , '741 - Notification Error' , '741 - Notification Error' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '790' , '790 - Notification Complete' , '790 - Notification Complete' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '888' , '888 - Canceled' , '888 - Canceled' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'AL.STATUS' , '999' , '999 - All Completed' , '999 - All Completed' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'BCHS.BCHTYPE' , '0' , 'Immediate' , 'Immediate' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'BCHS.BCHTYPE' , '1' , 'Scheduled' , 'Scheduled' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'TAGS.TAGTYPE' , 'BCHS' , 'Batch' , 'Batch' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'TAGS.TAGTYPE' , 'ERRS' , 'Error' , 'Error' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'TAGS.TAGTYPE' , 'JOBS' , 'Job' , 'Job' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'TAGS.TAGTYPE' , 'LOGS' , 'Log' , 'Log' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'TAGS.TAGTYPE' , 'PUBS' , 'Publication' , 'Publication' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'TAGS.TAGTYPE' , 'RCPS' , 'Recipient' , 'Recipient' );
INSERT INTO DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION) VALUES ( &system_id. , 0 , 111 , 'en' , 'TAGS.TAGTYPE' , 'TRNS' , 'Transaction' , 'Transaction' );
-- END TRANSLATIONS English @


-- Initial entity insert into DMKR_ENTITIES
REM INSERTING into DMKR_ENTITIES
Insert into DMKR_ENTITIES (ID,ENTITYTYPE,DISPLAYNAME,REPOSITORYNAME,NAME) values (1,1,'&admin_group.','&system_id.1','&admin_group.'); 
Insert into DMKR_ENTITIES (ID,ENTITYTYPE,DISPLAYNAME,REPOSITORYNAME,NAME) values (2,2,'&admin_user.','&system_id.7','&admin_user.');

-- Begin Example data for DMKR_ENTITY_ABILITYSET
Insert into DMKR_ENTITY_ABILITYSET (ENTITYID,ABILITYSETID,APP_ID) VALUES (1,3,201);
Insert into DMKR_ENTITY_ABILITYSET (ENTITYID,ABILITYSETID,APP_ID) values (1,6,101);

-- Begin Example data for Documaker Interactive user
Insert into DMKR_ENTITY_TO_ENTITY(GROUP_ID,USER_ID) values (1,2);


-- Seed for tables being watched for changes. 
REM INSERTING into DMKR_STAT_INFO
Insert into DMKR_STAT_INFO(STATNAME,STATACTION) VALUES ('DMKR_TRANSLAT',0);
Insert into DMKR_STAT_INFO(STATNAME,STATACTION) VALUES ('DMKR_ENTITIES',0);

COMMIT;


CREATE TABLE S_ROW_ID 
    (
     START_ID NUMBER(38),
     NEXT_ID NUMBER(38), 
     MAX_ID NUMBER(38),
     AUX_START_ID NUMBER(38),
     AUX_MAX_ID NUMBER(38),
     CONSTRAINT next_less_than_max CHECK(NEXT_ID<=MAX_ID),
     CONSTRAINT start_less_than_next CHECK(START_ID<=NEXT_ID),
     CONSTRAINT auxStart_less_than_auxMax CHECK(AUX_START_ID<=AUX_MAX_ID)
);

-- Inserts for S_ROW_ID sequencing table 
Insert into S_ROW_ID (START_ID,NEXT_ID,MAX_ID,AUX_START_ID,AUX_MAX_ID) VALUES ( 0, 4000 , 999999999999999999 , 1 , 2 );

COMMIT;


-- ADF Section
WHENEVER SQLERROR CONTINUE; 
set echo off

Rem  Copyright (c) 2011 by Oracle Corporation
Rem
Rem    NAME
Rem      adfbc_create_statesnapshottables.sql - Drop/Create BC4J Snapshot Objects
Rem
Rem    DESCRIPTION
Rem
Rem      This SQL script will create the database objects that BC4J
Rem      requires to support transaction state passivation/activation
Rem      
Rem    COMMAND
Rem      
Rem      @adfbc_create_statesnapshottables.sql PS_TXN PS_TXN_SEQ 50 PCOLL_CONTROL <<TXN_USER_ID>>
Rem
Rem      PS_TXN          - The txn table stores snapshots of pending changes
Rem                        made to BC4J application module instances. The snapshot information
Rem                        is stored as an XML document that encodes the unposted changes in
Rem                        an application module instance. Only pending data changes are
Rem                        stored in the snapshot, along with information about the current
Rem                        state of active iterators (i.e. "current row" pointers information).
Rem                        The value of the COLLID column corresponds to the value returned
Rem                        by the ApplicationModule.passivateState() method.
Rem      PS_TXN_SEQ      - This sequence is used to assign the next
Rem                        persistent snapshot Id for Application Module pending state
Rem                        management.
Rem      50              - The default value with which the sequence will be incremented every time
Rem                        the framework needs a set of ids. The framework will use one id value
Rem                        for each record inserted in the PS_TXN table. A value of 50 would mean
Rem                        that the framework will increment the sequence after inserting 50 snapshots.
Rem      PCOLL_CONTROL   - The  control table maintains the list of
Rem                        the persistent collection storage tables that the BC4J runtime
Rem                        has created and functions as a concurrency control mechanism.
Rem                        When a table named TABNAME is in use for storing some active sessions
Rem                        pending state, the corresponding row in  PCOLL_CONTROL is locked.
Rem      <<TXN_USER_ID>> - The user id to grant permissions to insert/update records in the
Rem                        above objects.
Rem
Rem
Rem    NOTES
Rem
Rem      By default, BC4J will create these objects in the schema of the
Rem      internal database user the first time that the application makes
Rem      a passivation request.  This script is intended for advanced users
Rem      who require more control over the creation and naming of these objects.
Rem
Rem      This script should not be used to perform routine cleanup of the
Rem      BC4J snapshot tables as it may lead to loss of active state.  Please
Rem      see the package defined in $JDEV_HOME/BC4J/bin/bc4jcleanup.sql
Rem      for a set of procedures to cleanup stale snapshot records.
Rem
Rem      The application developer should not modify this script. The BC4J
Rem      runtime framework makes certain assumptions about the structures
Rem      of the snapshot objects.  
Rem
Rem      If the names of the database objects above are customized the
Rem      application developer should be sure to specify these custom names to
Rem      the BC4J runtime framework with the following BC4J properties:
Rem
Rem         jbo.control_table_name - The control table name
Rem         jbo.txn_table_name - The txn table name
Rem         jbo.txn_seq_name - The txn sequence name
Rem
Rem      An application developer may also specify an increment clause for the
Rem      transaction sequence.  If a sequence increment clause has been
Rem      specified then BC4J will use an in-memory cache equal to the
Rem      increment size for txn passivation ids.  This may improve passivation
Rem      performance.  If the sequence increment size is specified the
Rem      application developer should be sure to declare that size to the BC4J
Rem      runtime framework with the following BC4J property:
Rem
Rem      jbo.txn_seq_inc - A postive value indicating the txn sequence size.
Rem
Rem      If the application developer is using the bc4j_cleanup package
Rem      to administer the snapshot objects then the developer should also
Rem      reexecute that package DDL (bc4jcleanup.sql) with the custom
Rem      table name values.
Rem
Rem      Please see the following whitepaper for more information about
Rem      the database object required by BC4J:
Rem
Rem      http://otn.oracle.com/products/jdev/htdocs/bc4j/bc4j_temp_tables.html
Rem
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     sekorupo   05/23/11 - XbranchMerge sekorupo_bug-12543686 from main
Rem     sekorupo   02/05/11 - XbranchMerge sekorupo_bug-11671838 from main
Rem     jsmiljan   05/02/02 - Creation
Rem     jsmiljan   12/20/03 - Added a storage clause to the transaction table.
Rem                           See performance bug 3241879.
Rem     jsmiljan   01/27/04 - Added an increment by clause to the sequence.
Rem     sekorupo   12/14/10 - Added a reverse index which helps by reducing contention 
Rem                           that can happen when the rate of inserts is high.
Rem     dbajpai    12/14/10 - Add the .sql script to JRF distribution
Rem     sekorupo   12/16/10 - Add procedure for granting permissions to the table
Rem     dbajpai    12/18/10 - Validated and updated the new .sql script to JRF.
Rem     sekorupo   01/29/11 - Create objects using script arguments.

CREATE OR REPLACE PROCEDURE adfbc_state_tables_grant_perms (
    p_txntable      IN     VARCHAR2,
    p_txnseq        IN     VARCHAR2,
    p_controltable  IN     VARCHAR2,
    p_username      IN     VARCHAR2
)
IS
BEGIN
  if p_username = sys_context('USERENV', 'CURRENT_USER') then
     dbms_output.put_line('User already has privilege');
     return;
  else
     dbms_output.put_line('Granting permissions to ' || p_username);
     execute immediate 'GRANT SELECT, UPDATE, INSERT, DELETE ON ' || p_txntable ||  ' TO ' || p_username;
     execute immediate 'GRANT SELECT ON ' || p_txnseq ||  ' TO ' || p_username;
     execute immediate 'GRANT SELECT, UPDATE, INSERT, DELETE ON ' || p_controltable ||  ' TO ' || p_username;
  end if;
END;
/

Rem uncomment the following block and comment the next block to prompt the user for the variable values
Rem define def_adfbc_txn_tab_name = PS_TXN
Rem define def_adfbc_txn_seq_name = PS_TXN_SEQ
Rem define def_adfbc_txn_seq_increment = 50
Rem define def_adfbc_control_tab_name = PCOLL_CONTROL
Rem define def_txn_tab_user = &system_schema.
Rem accept adfbc_txn_tab_name default &def_adfbc_txn_tab_name prompt 'Please enter a txn table name [&def_adfbc_txn_tab_name]:  '
Rem accept adfbc_txn_seq_name default &def_adfbc_txn_seq_name prompt 'Please enter a txn sequence name [&def_adfbc_txn_seq_name]:  '
Rem accept adfbc_txn_seq_increment default &def_adfbc_txn_seq_increment prompt 'Please enter a positive txn sequence increment [&def_adfbc_txn_seq_increment]:  '
Rem accept adfbc_control_tab_name default &def_adfbc_control_tab_name prompt 'Please enter a control table name [&def_adfbc_control_tab_name]:  '
Rem accept adfbc_txn_tab_user default &_USER prompt 'Please enter a user to grant permissions for the &adfbc_txn_tab_name [&_USER]: '

define adfbc_txn_tab_name = PS_TXN ;
define adfbc_txn_seq_name = PS_TXN_SEQ ;
define adfbc_txn_seq_increment = 50 ;
define adfbc_control_tab_name = PCOLL_CONTROL ;
define adfbc_txn_tab_user = &system_schema. ;

define adfbc_txn_tab_index_suffix = _INDEX ;
define adfbc_pk_suffix = _PK ;

--drop table &adfbc_txn_tab_name
--/

--drop sequence &adfbc_txn_seq_name
--/

--drop table &adfbc_control_tab_name
--/

create table &adfbc_control_tab_name(
     tabname varchar2(128) NOT NULL
   , rowcreatedate date
   , createdate date
   , updatedate date
   , constraint &adfbc_control_tab_name&adfbc_pk_suffix primary key (tabname))
/

create sequence &adfbc_txn_seq_name increment by &adfbc_txn_seq_increment
/

create table &adfbc_txn_tab_name(
     id number(20) NOT NULL
   , parentid number(20)
   , collid number(10)
   , content blob
   , creation_date date DEFAULT sysdate
   , constraint &adfbc_txn_tab_name&adfbc_pk_suffix primary key (collid, id) using index (create index &adfbc_txn_tab_name&adfbc_txn_tab_index_suffix on &adfbc_txn_tab_name (collid, id) reverse))
storage (maxextents unlimited)
lob (content) store as (enable storage in row chunk 4096 cache)
/

call adfbc_state_tables_grant_perms('&adfbc_txn_tab_name', '&adfbc_txn_seq_name', '&adfbc_control_tab_name', '&adfbc_txn_tab_user')
/
drop procedure adfbc_state_tables_grant_perms
/


Rem
Rem $Header: $
Rem
Rem  Copyright (c) 2000 by Oracle Corporation
Rem
Rem    NAME
Rem      bc4jcleanup.sql - Utilities to clean temporary BC4J storage
Rem
Rem    DESCRIPTION
Rem
Rem      This package contains procedures to clean out rows
Rem      in the database used by BC4J to store user session state
Rem      and storage used by temporary persistent collections.
Rem
Rem    NOTES
Rem
Rem      You can schedule periodic cleanup of your BC4J temporary
Rem      persistence storage by submitting an invocation of the
Rem      appropriate procedure in this package as a database job.
Rem
Rem      You can use an anonymous PL/SQL block like the following
Rem      to schedule the execution of bc4j_cleanup.session_state()
Rem      to run starting tomorrow at 2:00am and each day thereafter
Rem      to cleanup sessions whose state is over 1 day (1440 minutes) old.
Rem
Rem     SET SERVEROUTPUT ON
Rem     DECLARE
Rem       jobId    BINARY_INTEGER;
Rem       firstRun DATE;
Rem     BEGIN
Rem     -- Start the job tomorrow at 2am
Rem     firstRun := TO_DATE(TO_CHAR(SYSDATE+1,'DD-MON-YYYY')||' 02:00',
Rem                 'DD-MON-YYYY HH24:MI');
Rem
Rem     -- Submit the job, indicating it should repeat once a day
Rem     dbms_job.submit(job       => jobId,
Rem                     -- Run the BC4J Cleanup for Session State
Rem                     -- to cleanup sessions older than 1 day (1440 minutes)
Rem                     what      => 'bc4j_cleanup.session_state(1440);',
Rem                     next_date => firstRun,
Rem                     -- When completed, automatically reschedule
Rem                     -- for 1 day later
Rem                     interval  => 'SYSDATE + 1'
Rem                    );
Rem     dbms_output.put_line('Successfully submitted job. Job Id is '||jobId);
Rem    END;
Rem
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem     jsmiljan   05/02/01 -  Added support for custom snapshot object names
Rem     smuench    12/07/01 -  Update for PColl Changes
Rem     smuench    09/06/00 -  Creation
Rem

CREATE OR REPLACE PACKAGE bc4j_cleanup IS
  --
  -- Cleanup application module session state storage for sessions
  -- older than a given date.
  --
  PROCEDURE Session_State( olderThan         DATE  );
  --
  -- Cleanup application module session state storage for sessions
  -- older than a given number of minutes.
  --
  PROCEDURE Session_State( olderThan_minutes INTEGER );
  --
  -- Cleanup persistent collection storage for large-rowset
  -- "spillover" for collections last accessed before a given date
  --
  PROCEDURE Persistent_Collections( olderThan DATE );
  --
  -- Cleanup persistent collection storage for large-rowset
  -- "spillover" for collections last accessed a given number of days ago.
  --
  PROCEDURE Persistent_Collections( olderThan_days NUMBER );
END bc4j_cleanup;
.
/
show errors
CREATE OR REPLACE PACKAGE BODY bc4j_cleanup IS
  row_already_locked EXCEPTION;
  table_not_found    EXCEPTION;
  PRAGMA EXCEPTION_INIT(row_already_locked,-54);
  PRAGMA EXCEPTION_INIT(table_not_found,-942);
  TYPE ref_cursor IS REF CURSOR;
  cur_Rowid               ROWID;
  MINUTES_IN_DAY CONSTANT INTEGER := 1440;
  sessCursorStmt CONSTANT VARCHAR2(80) :=
     'SELECT rowid AS id FROM &adfbc_txn_tab_name WHERE creation_date < :minDate';
  lockCursorStmt CONSTANT VARCHAR2(80) :=
     'SELECT 2 FROM &adfbc_txn_tab_name WHERE rowid = :theRowid FOR UPDATE NOWAIT';
  deleteCursorStmt CONSTANT VARCHAR2(80) :=
     'DELETE FROM &adfbc_txn_tab_name WHERE rowid = :theRowid';
  pcollCursorStmt CONSTANT VARCHAR2(90) :=
     'SELECT rowid AS id FROM &adfbc_control_tab_name WHERE updatedate < :minDate'||
     ' and tabname <> ''&adfbc_txn_tab_name''';
  pcollLockCursorStmt CONSTANT VARCHAR2(90) :=
     'SELECT TABNAME FROM &adfbc_control_tab_name WHERE rowid = :id FOR UPDATE NOWAIT';
  pcollDeleteCursorStmt CONSTANT VARCHAR2(80) :=
     'DELETE FROM &adfbc_control_tab_name WHERE rowid = :theRowid';
  PROCEDURE Session_State( olderThan DATE  ) IS
    cur_Session ref_cursor;
    cur_Lock    ref_cursor;
    tmpval      NUMBER;
  BEGIN
    OPEN cur_Session FOR sessCursorStmt USING olderThan;
    LOOP
      FETCH cur_Session INTO cur_Rowid;
      EXIT WHEN cur_Session%NOTFOUND;
        BEGIN
          OPEN cur_Lock FOR lockCursorStmt USING cur_Rowid;
          FETCH cur_Lock INTO tmpval;
          CLOSE cur_Lock;
          EXECUTE IMMEDIATE deleteCursorStmt USING cur_Rowid;
          COMMIT;
        EXCEPTION
          WHEN row_already_locked THEN
            CLOSE cur_Lock; -- Just ignore rows that we cannot lock
        END;
    END LOOP;
  EXCEPTION
    WHEN table_not_found THEN
      NULL; -- Ignore if &adfbc_txn_tab_name table not found
  END;

  PROCEDURE Session_State( olderThan_minutes INTEGER ) IS
  BEGIN
    -- Ignore negative values for olderThan_minutes
    IF olderThan_minutes < 0 THEN
      RETURN;
    END IF;
    Session_State( SYSDATE - olderThan_minutes/MINUTES_IN_DAY );
  END;

  PROCEDURE Persistent_Collections( olderThan DATE ) IS
    cur_PCollControl ref_cursor;
    cur_Lock         ref_cursor;
    spillTableName   VARCHAR2(80);
  BEGIN
    OPEN cur_PCollControl FOR pcollCursorStmt USING olderThan;
    LOOP
      FETCH cur_PCollControl INTO cur_Rowid;
      EXIT WHEN cur_PCollControl%NOTFOUND;
        BEGIN
          -- Lock the "old" PColl Control Row, selecting spill-over table name
          OPEN cur_Lock FOR pcollLockCursorStmt USING cur_Rowid;
          FETCH cur_Lock INTO spillTableName;
          CLOSE cur_Lock;
          -- Delete the row keeping track of temporary spill-over table
          EXECUTE IMMEDIATE pcollDeleteCursorStmt USING cur_Rowid;
          -- Drop the temporary spill-over table
          EXECUTE IMMEDIATE 'drop table "'||spillTableName||'"';
          -- Drop the temporary spill-over table's key table
          EXECUTE IMMEDIATE 'drop table "'||spillTableName||'_ky"';
          COMMIT;
        EXCEPTION
          WHEN row_already_locked THEN
            CLOSE cur_Lock; -- Just ignore rows that we cannot lock
        END;
    END LOOP;
  EXCEPTION
    WHEN table_not_found THEN
      NULL; -- Ignore if &adfbc_control_tab_name table not found
  END;

  PROCEDURE Persistent_Collections( olderThan_days NUMBER ) IS
  BEGIN
    -- Ignore negative values for olderThan_days
    IF olderThan_days < 0 THEN
      RETURN;
    END IF;
    Persistent_Collections( SYSDATE - olderThan_days );
  END;
END bc4j_cleanup;
.
/
show errors
COMMIT;
declare
   l_job_exists number;
begin
   select count(*) into l_job_exists
     from dba_scheduler_jobs
    where owner = '&system_schema.' and job_name='BC4J_CLEANUP_JOB';
   if l_job_exists = 1 then
      sys.dbms_scheduler.drop_job(job_name => '&system_schema..BC4J_CLEANUP_JOB', defer => false, force => false);
   end if;
end;
/
show errors;
COMMIT;
BEGIN
sys.dbms_scheduler.create_job(
job_name => '&system_schema..BC4J_CLEANUP_JOB',
job_type => 'PLSQL_BLOCK',
job_action => 'begin
bc4j_cleanup.session_state(60);
end;',
repeat_interval => 'FREQ=HOURLY',
start_date => systimestamp at time zone 'America/New_York',
job_class => '"DEFAULT_JOB_CLASS"',
auto_drop => FALSE,
enabled => TRUE);
END;
.
/
show errors
COMMIT;

undefine adfbc_control_tab_name ;
undefine adfbc_txn_tab_name ;
undefine adfbc_txn_seq_name ;
undefine adfbc_txn_seq_increment ;
undefine adfbc_pk_suffix ;
undefine adfbc_txn_tab_index_suffix ;
undefine adfbc_txn_tab_user ;

Rem undefine def_adfbc_txn_tab_name ;
Rem undefine def_adfbc_txn_seq_name ;
Rem undefine def_adfbc_txn_seq_increment ;
Rem undefine def_adfbc_control_tab_name ;


-- REM UNDEF admin_user;
-- REM UNDEF admin_group;
-- REM UNDEF system_folder;
-- REM UNDEF system_name;
-- REM UNDEF system_id;
-- REM UNDEF system_passwdNoEnc;
-- REM UNDEF system_schema;

