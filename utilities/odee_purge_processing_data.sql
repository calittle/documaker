---------------------------------------------------------
---------------------------------------------------------
-- Purpose: Drop processing data DMKR_ASLINE schema for Oracle DB.
-- The following script will clear out the Assembly Line 
-- processing tables for your 12.6.3 ODEE system where the 
-- database type is Oracle.
-- Usage: Change the string "${assemblyLine.schema}" with 
-- your Assembly Line schema name.  Then uncomment
-- the ALTER, TRUNCATE, COMMIT, and exit statements.
--
-- Note: The ALTER TABLE * SHRINK SPACE CASCADE DDL statements 
-- may fail with ORA-10637 SQL Errors if 
-- Oracle DB is older than 11.2.0.3.4 or 11.2.0.4 with 
-- deferred segments enabled (default) because of Oracle 
-- Bug 13649031, but this error can be ignored or you must 
-- patch your older version of Database server. 
---------------------------------------------------------
---------------------------------------------------------

---------------------------------------------------------
---------------------------------------------------------
-- Drop processing data DMKR_ASLINE schema
---------------------------------------------------------
---------------------------------------------------------

-- ALTER SESSION SET CURRENT_SCHEMA=${assemblyLine.schema};

-- ALTER TRIGGER BCHSHIST_INS_TRG DISABLE;
-- ALTER TRIGGER JOBSHIST_INS_TRG DISABLE;
-- ALTER TRIGGER RCPSHIST_INS_TRG DISABLE;
-- ALTER TRIGGER TRNSHIST_INS_TRG DISABLE;
-- ALTER TRIGGER PUBSHIST_INS_TRG DISABLE;
-- ALTER TRIGGER BCHS_RCPSHIST_INS_TRG DISABLE;
-- COMMIT;

-- ALTER TABLE TRNS DISABLE CONSTRAINT JOBS_TRNS;
-- ALTER TABLE PUBS DISABLE CONSTRAINT BCHS_PUB;
-- ALTER TABLE RCPS DISABLE CONSTRAINT TRNS_RCPS;
-- DROP INDEX TRNS_DI_IX_1;
-- DROP INDEX TRNS_APPSTATE_STCD; 
-- DROP INDEX TRNSLOG_ID_ASSTR; 
-- COMMIT;

-- TRUNCATE TABLE PUBS;
-- TRUNCATE TABLE BCHS;
-- TRUNCATE TABLE BCHS_RCPS;
-- TRUNCATE TABLE RCPS;
-- TRUNCATE TABLE TRNS;
-- TRUNCATE TABLE JOBS;
-- COMMIT;

-- TRUNCATE TABLE LOGS;
-- TRUNCATE TABLE ERRS;
-- TRUNCATE TABLE TRNSLOG;
-- COMMIT;

-- TRUNCATE TABLE JOBSHIST;
-- TRUNCATE TABLE TRNSHIST;
-- TRUNCATE TABLE RCPSHIST;
-- TRUNCATE TABLE BCHSHIST;
-- TRUNCATE TABLE PUBSHIST;
-- COMMIT;

-- ALTER TABLE JOBS ENABLE ROW MOVEMENT;
-- ALTER TABLE JOBS SHRINK SPACE CASCADE;
-- ALTER TABLE TRNS ENABLE ROW MOVEMENT;
-- ALTER TABLE TRNS SHRINK SPACE CASCADE;
-- ALTER TABLE RCPS ENABLE ROW MOVEMENT;
-- ALTER TABLE RCPS SHRINK SPACE CASCADE;
-- ALTER TABLE BCHS ENABLE ROW MOVEMENT;
-- ALTER TABLE BCHS SHRINK SPACE CASCADE;
-- ALTER TABLE BCHS_RCPS ENABLE ROW MOVEMENT;
-- ALTER TABLE BCHS_RCPS SHRINK SPACE CASCADE;
-- ALTER TABLE PUBS ENABLE ROW MOVEMENT;
-- ALTER TABLE PUBS SHRINK SPACE CASCADE;

-- ALTER TABLE JOBSHIST ENABLE ROW MOVEMENT;
-- ALTER TABLE JOBSHIST SHRINK SPACE CASCADE;
-- ALTER TABLE TRNSHIST ENABLE ROW MOVEMENT;
-- ALTER TABLE TRNSHIST SHRINK SPACE CASCADE;
-- ALTER TABLE RCPSHIST ENABLE ROW MOVEMENT;
-- ALTER TABLE RCPSHIST SHRINK SPACE CASCADE;
-- ALTER TABLE BCHSHIST ENABLE ROW MOVEMENT;
-- ALTER TABLE BCHSHIST SHRINK SPACE CASCADE;
-- ALTER TABLE PUBSHIST ENABLE ROW MOVEMENT;
-- ALTER TABLE PUBSHIST SHRINK SPACE CASCADE;
-- ALTER TABLE LOGS ENABLE ROW MOVEMENT;
-- ALTER TABLE LOGS SHRINK SPACE CASCADE;
-- ALTER TABLE TRNSLOG ENABLE ROW MOVEMENT;
-- ALTER TABLE TRNSLOG SHRINK SPACE CASCADE;
-- ALTER TABLE ERRS ENABLE ROW MOVEMENT;
-- ALTER TABLE ERRS SHRINK SPACE CASCADE;

-- CREATE INDEX TRNS_DI_IX_1 ON TRNS ( CURRUSER ASC, STATUSCODE DESC, APPROVALSTATE ASC, CURRAPP_ID ASC, MODIFYTIME DESC) ;
-- CREATE INDEX TRNS_APPSTATE_STCD ON TRNS ( CURRUSER ASC , APPROVALSTATE ASC , STATUSCODE ASC );
-- CREATE INDEX TRNSLOG_ID_ASSTR ON TRNSLOG ( CAST(TRNSLOG_ID as NVARCHAR2(47)) ASC );
-- ALTER TRIGGER BCHSHIST_INS_TRG ENABLE;
-- ALTER TRIGGER JOBSHIST_INS_TRG ENABLE;
-- ALTER TRIGGER RCPSHIST_INS_TRG ENABLE;
-- ALTER TRIGGER TRNSHIST_INS_TRG ENABLE;
-- ALTER TRIGGER PUBSHIST_INS_TRG ENABLE;
-- ALTER TRIGGER BCHS_RCPSHIST_INS_TRG ENABLE;
-- COMMIT;

-- ALTER TABLE TRNS ENABLE CONSTRAINT JOBS_TRNS;
-- ALTER TABLE PUBS ENABLE CONSTRAINT BCHS_PUB;
-- ALTER TABLE RCPS ENABLE CONSTRAINT TRNS_RCPS;
-- COMMIT;

-- exit;
