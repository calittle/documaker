SET SERVEROUTPUT ON;
DECLARE 
  v_sql  LONG;
    
  l_max         DMKR_ASLINE.jobs.jobstarttime%TYPE;
  l_min         DMKR_ASLINE.jobs.jobendtime%TYPE;
  l_jobs_avg    float;
  l_trns_avg    float;
  l_pubs_avg    float;
  l_bchs_avg    float;
  l_jobs_count int := 0;  
  l_trns_count int := 0; 
  l_pubs_count int := 0;
  
BEGIN  
/*
Create a table to hold our statistical data.
Run this script as a user with CREATE TABLE rights in the DMKR_ADMIN schema.

  dts           timestamp(0), -- Time the stats were logged. Precision (0) is to the second, which should be fine.
  assy_line     varchar(255), -- Name of the assembly line for these stats.
  period_start  timestamp(0), -- Starting time of the reporting period. 
  period_end    timestamp(0), -- Ending time of the reporting period.
  total_jobs    integer,      -- Total # of jobs processed in the reporting period.
  total_trans   integer,      -- Total # of transactions processed in the reporting period.
  total_pubs    integer,      -- Total # of publications generated in the reporting period.
  -- Note: integer type supports value of up to (2^31)-1 = 2,147,483,647 
  -- so reporting period must not contain more than that number of records.
  -- Otherwise should change this type to LONGINTEGER or NUMBER. 
  avg_job_time  float,        -- Average time for job to complete in the reporting period.
  avg_tran_time float,        -- Average time for tran to complete in the reporting period.
  avg_pub_time  float,        -- Average time for pub to complete in the reporting period.
  avg_bchg_time float        -- Average time for batching to complete in the reporting period.
  -- Note: these times may be skewed by any transactions where interactive is involved
  -- so it may be useful to exclude those transactions from any SQL statements that
  -- calculate these values.
*/
  v_sql := 'CREATE TABLE dmkr_admin.odee_stats (
  dts timestamp(0), 
  assy_line varchar(255),
  period_start timestamp(0),
  period_end timestamp(0),
  total_jobs integer,     
  total_trans integer,     
  total_pubs integer,     
  avg_job_time float,        
  avg_tran_time float,
  avg_pub_time float,
  avg_bch_time float
  )';
execute immediate v_sql;
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE = -955 THEN
      NULL; --suppress the "table already exists" error      
    ELSE
      RAISE;
    END IF;

/*
Here is where we set the parameters for the query.
Ideally this would become a stored procedure where these
two poinst are passed as parameters.
*/
  l_max := TO_DATE('31/07/2019 23:59:59','dd/mm/yyyy hh24:mi:ss');
  l_min := TO_DATE('1/07/2019 00:00:00','dd/mm/yyyy hh24:mi:ss');

SELECT 
  COUNT(JOB_ID) INTO l_jobs_count
FROM DMKR_ASLINE.JOBS 
WHERE 
  JOBSTARTTIME BETWEEN l_min AND l_max;
  -- J.JOBENDTIME BETWEEN l_startmin AND l_startmax;
  -- J.JOBENDTIME <= l_max AND J.JOBSTARTTIME >= l_min;

-- Here's the sticky part:
-- Should our query include jobs that started _before_ the reporting window,
-- but completed _during_ the reporting window? And should it contain jobs
-- that started _during_ the reporting window but have not completed?
-- That's a decision to be made by implementation.  

-- In this example, we are including only jobs that started during the 
-- reporting window. This will definitely skew numbers for a given reporting
-- period, so consider carefully. A few examples are provided in the comment
-- above that you might use.

-- Also, you may elect to exclude jobs that were processed through Documaker 
-- Interactive, and to do that you will need to craft an SQL WHERE clause more 
-- exclusivity: perhaps by checking TRNS.CURRUSER and/or TRNS.CURRGROUP, 
-- or by correlating with TRNSLOG to filter out jobs processed by Interactive.
-- But that exercise is left to the implementation...

SELECT COUNT(TRN_ID) INTO l_trns_count
FROM DMKR_ASLINE.TRNS 
WHERE 
  TRNSTARTTIME BETWEEN l_min AND l_max;
-- You should constrain the where clause as you did above for JOBS.
-- You could use a SELECT statement in the WHERE clause, like so:
-- WHERE TRN_ID IN (SELECT TRN_ID FROM TRNS WHERE JOB_ID ... )
-- This will take a little longer to run, but will ultimately ensure that 
-- you are taking in ONLY the records you need.

SELECT COUNT(PUB_ID) INTO l_pubs_count
FROM DMKR_ASLINE.PUBS 
WHERE 
  PUBSTARTTIME BETWEEN l_min AND l_max;
-- You should constrain the where clause as you did above for JOBS and TRNS
-- however it will be slightly more complex due to the relationship between
-- JOBS/TRNS and PUBS being contained in a fourth table: BCHS_RCPS:
-- WHERE PUB_ID IN (SELECT PUB_ID FROM BCHS_RCPS WHERE JOB_ID IN 
--  (SELECT JOB_ID FROM JOBS WHERE ... ))

-- Once you have worked out the above, do the time calculations.
-- Note: since Count() is an aggregate function we cannot combine
-- with row functions like AVG() so we have to execute separately.
-- Note that the WHERE clauses need to be adjusted just as before.
-- this has not been adequately tested to validate that the differencing
-- and averaging works as expected .. Note that the ENDTIME+0 and STARTTIME+0 is used
-- to cast the timestamp as a number which is needed for avg() function.
SELECT 
  AVG((JOBENDTIME+0) - (JOBSTARTTIME+0))*24*60*60 INTO l_jobs_avg
FROM DMKR_ASLINE.JOBS WHERE 
  JOBSTARTTIME BETWEEN l_min AND l_max AND 
  JOBENDTIME IS NOT NULL;

SELECT 
  AVG((TRNENDTIME+0) - (TRNSTARTTIME+0))*24*60*60 INTO l_trns_avg
FROM DMKR_ASLINE.TRNS WHERE 
  TRNSTARTTIME BETWEEN l_min AND l_max AND 
  TRNENDTIME IS NOT NULL;

SELECT 
  AVG((PUBENDTIME+0) - (PUBSTARTTIME+0))*24*60*60 INTO l_pubs_avg
FROM DMKR_ASLINE.PUBS WHERE 
  PUBSTARTTIME BETWEEN l_min AND l_max AND 
  PUBENDTIME IS NOT NULL;

SELECT 
  AVG((BCHENDTIME+0) - (BCHSTARTTIME+0))*24*60*60 INTO l_bchs_avg
FROM DMKR_ASLINE.BCHS WHERE 
  BCHSTARTTIME BETWEEN l_min AND l_max AND 
  BCHENDTIME IS NOT NULL;

INSERT INTO DMKR_ADMIN.ODEE_STATS VALUES (
CURRENT_DATE,
'AL1',  -- Ideally you would want to replace this with a variable.
l_min,
l_max,
l_jobs_count,
l_trns_count,
l_pubs_count,
l_jobs_avg,
l_trns_avg,
l_pubs_avg,
l_bchs_avg
);
  
END;
