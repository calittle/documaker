/*
send-email-trns.sql
This example for Oracle DB demonstrates creating a trigger on the TRNS table that fires an email whenever an existing row in
the table is updated -- specifically the TRNSTATUS column. The trigger further evaluates the TRNSTATUS to determine if it is 
an error condition, and if so, sends the first error for that TRN_ID.

This is not production-ready code! You will want to have a DBA review this and make recommendations.

This is an updated version of send-email-errors.sql that operates on updates to the TRNS.TRNSTATUS column.
This version only sends an email if the TRNSTATUS value is *41 (141, 241, *41), and it sends the details of only 
the first error. You can modify this to grab _all_ errors and include them if you wish using a looping structure.

You may wish to use a decoupled trigger/send paradigm. In such a model, TRNS updates would complete regardless of SMTP
errors. The trigger would instead insert a record into a new, separate table (such as EMAIL_JOBS). A DB job would need to be 
created which periodically scans for rows in the EMAIL_JOBS table, and then handles the SMTP work to send the emails and
remove the rows from the EMAIL_JOBS table. This design is detailed here: https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:7267435205059

If you want to create other types of email, look at other options here: https://oracle-base.com/articles/misc/email-from-oracle-plsql
*/

create or replace trigger email_on_error_update 
after update of trnstatus on dmkr_asline.trns 
for each row 
when (mod(new.trnstatus,100)=41) 
declare
  l_mail_conn       UTL_SMTP.connection;
  r_err        dmkr_asline.errs%ROWTYPE;
BEGIN
    -- get only the first error for this trn_id
    -- if you want to get all errors for this trn_id use this instead:
    -- SELECT * INTO r_err FROM ERRS WHERE TRN_ID = :new.trn_id ORDER BY ERRTIME DESC 
    SELECT * INTO r_err FROM (
      SELECT * FROM ERRS WHERE TRN_ID = :new.trn_id ORDER BY ERRTIME DESC 
    ) WHERE ROWNUM = 1;

  -- update with your email host and port, 
  -- and other relevant details (to, from, reply-to)
  l_mail_conn := UTL_SMTP.open_connection('your-email-host', your-email-port);
  UTL_SMTP.helo(l_mail_conn, 'your-email-host');
  UTL_SMTP.mail(l_mail_conn, 'from@address');
  UTL_SMTP.rcpt(l_mail_conn, 'to@address');  
  UTL_SMTP.open_data(l_mail_conn);  
  UTL_SMTP.write_data(l_mail_conn, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
  UTL_SMTP.write_data(l_mail_conn, 'To: to@address' || UTL_TCP.crlf);
  UTL_SMTP.write_data(l_mail_conn, 'From: from@address' || UTL_TCP.crlf);
  UTL_SMTP.write_data(l_mail_conn, 'Subject: DocFactory Error: ' || r_err.ERROR_CODE|| UTL_TCP.crlf);
  UTL_SMTP.write_data(l_mail_conn, 'Reply-To: reply@address ' || UTL_TCP.crlf || UTL_TCP.crlf);
  UTL_SMTP.write_data(l_mail_conn, 'The following error was received from ' || 
    r_err.ERRPROGRAM || ' on ' || 
    r_err.ERRHOSTNAME || ' at ' || 
    r_err.ERRTIME || UTL_TCP.crlf  || 
    r_err.ERRMESSAGE || UTL_TCP.crlf || UTL_TCP.crlf);
  UTL_SMTP.close_data(l_mail_conn);

  UTL_SMTP.quit(l_mail_conn);

END;
/
/* ACLs are still needed, make sure the host/port settings match what's in your trigger! */
BEGIN
  DBMS_NETWORK_ACL_ADMIN.append_host_ace (
    host       => 'your-email-host', 
    lower_port => your-email-port,
    upper_port => your-email-port,
    ace        => xs$ace_type(privilege_list => xs$name_list('smtp'),
                              principal_name => 'dmkr_admin',
                              principal_type => xs_acl.ptype_db)); 

DBMS_NETWORK_ACL_ADMIN.append_host_ace (
    host       => 'your-email-host', 
    lower_port => your-email-port,
    upper_port => your-email-port,
    ace        => xs$ace_type(privilege_list => xs$name_list('smtp'),
                              principal_name => 'dmkr_asline',
                              principal_type => xs_acl.ptype_db)); 
END;
/

/* 
And finally, a test. You'll need to do this part yourself, using a transaction that's already 
got an error entered in the ERRS table.
*/
DECLARE
BEGIN
  UPDATE DMKR_ASLINE.TRNS
  SET TRNSTATUS=941 WHERE TRN_ID = ?
  rollback; 
END;
/
