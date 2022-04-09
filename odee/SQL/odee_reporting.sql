-- *
-- * ODEE Reporting
-- * Updated 28 Jan 2021
-- * Andy Little, andy.little@oracle.com
-- *

DEFINE end_upper_date_bound = '2020-12-31T23:59:59';
DEFINE end_lower_date_bound = '2020-01-01T00:00:00';
DEFINE assembly_line = 'DMKR_ASLINE';

SET VERIFY OFF;
SET FEEDBACK OFF;

SELECT
  --COUNT(XMLCast(XMLQuery('$p//Form/name' PASSING T.TRNNAPOLXML as "p" RETURNING CONTENT) AS VARCHAR2(30))) Quantity,
  XMLCast(XMLQuery('declare namespace ns2="oracle/documaker/napol/model"; (: :) $p//ns2:Form/@name' PASSING T.TRNNAPOLXML as "p" RETURNING CONTENT) AS VARCHAR2(30)) TheTrigger
  --,count(*)
FROM &&assembly_line..TRNS T
WHERE 
  XMLExists('declare namespace ns2="oracle/documaker/napol/model"; (: :) $p//ns2:Form/@name' PASSING T.TRNNAPOLXML as "p") 
  and T.TRNENDTIME BETWEEN TO_DATE( '&&end_lower_date_bound', 'YYYY-MM-DD"T"HH24:MI:SS') AND TO_DATE( '&&end_upper_date_bound', 'YYYY-MM-DD"T"HH24:MI:SS')
  and T.TRNSTATUS IN (999) 
  and T.TRNNAPOLTYPE=0 
  and T.TRN_ID = 13
--GROUP BY XMLCast(XMLQuery('declare namespace ns2="oracle/documaker/napol/model";$p//ns2:Form/@name' PASSING T.TRNNAPOLXML as "p" RETURNING CONTENT) AS VARCHAR2(30))
;




-- * Replace your date boundaries for reporting here. Currently this is used to 
-- * filter the BCHENDTIME, so transactions that start outside the boundary are
-- * included; only those that finish outside the boundary are excluded.
DEFINE end_upper_date_bound = '2020-11-30T23:59:59';
DEFINE end_lower_date_bound = '2020-11-01T00:00:00';
-- * Define the assembly line here.
DEFINE assembly_line = 'DMKR_ASLINE';

-- * Title/Header/Footer only works in PL/SQL
TTITLE CENTER "Alamere Corporation: Print Report";
BTITLE CENTER "Confidential";
REPHEADER PAGE CENTER 'PERFECT';

SET VERIFY OFF;
SET FEEDBACK OFF;

SELECT
  SUM(B.BCHTRNCOUNT)    as Transactions,
  SUM(B.BCHPAGECOUNT)   as Pages,
  SUM(B.BCHSHEETCOUNT)  as Sheets,
  B.BCHPRTTYPE          as "Type",
  B.BCHNAME             as "Batch Name",
  B.BCHARCDEST          as "Destination"
  
FROM &&assembly_line..BCHS B
WHERE 
  B.BCHENDTIME BETWEEN 
      TO_DATE( '&&end_lower_date_bound', 'YYYY-MM-DD"T"HH24:MI:SS')
    AND
      TO_DATE( '&&end_upper_date_bound', 'YYYY-MM-DD"T"HH24:MI:SS')
  and 
  -- can add other status values here if you want to capture
  -- batches that haven't finished yet or errored, e.g.
  -- 411, 415, 416, 421, 431, 441
  B.BCHSTATUS IN (999)

-- order of these elements is important based on how you want to
-- aggregate the data.
GROUP BY B.BCHPRTTYPE, B.BCHNAME, B.BCHARCDEST;
