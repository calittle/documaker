/*
send-email-errors.sql
This example for Oracle DB demonstrates creating a trigger on the ERRS table that fires an email whenever a row is inserted.

This is not production-ready code! You will want to have a DBA review this and make recommendations.

You may wish to use a decoupled trigger/send paradigm. In such a model, TRNS updates would complete regardless of SMTP
errors. The trigger would instead insert a record into a new, separate table (such as EMAIL_JOBS). A DB job would need to be 
created which periodically scans for rows in the EMAIL_JOBS table, and then handles the SMTP work to send the emails and
remove the rows from the EMAIL_JOBS table. This design is detailed here: https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:7267435205059

If you want to create other types of email, look at other options here: https://oracle-base.com/articles/misc/email-from-oracle-plsql
*/ 

/*
CREATE
1. Attach trigger to the ERRS table. 
*/

CONNECT / as sysdba;

CREATE OR REPLACE TRIGGER DMKR_ASLINE.SEND_EMAIL 
AFTER INSERT ON DMKR_ASLINE.ERRS FOR EACH ROW
declare
l_mail_conn   UTL_SMTP.connection;
BEGIN
  -- ==== NOTE WELL =====
  -- You might want to consider filtering out which INSERTed messages are worthy of sending in email.
  -- A single transaction could result in multiple errors, so you might instead consider putting this trigger
  -- on AFTER UPDATE of the JOBS or TRNS table, and only send if the status code is like *41. 
  -- Or you could filter on the contents of the INSERTed ERRS message and determine if you really want to email it at all.


  -- this should be self-explanatory: replace with your email host and port. 
  l_mail_conn := UTL_SMTP.open_connection('your-email-host', your-email-port);
  UTL_SMTP.helo(l_mail_conn, 'your-email-host');
  -- This particular design is not doing authentication, but you can add this if you want to.
  UTL_SMTP.mail(l_mail_conn, 'from@address');
  UTL_SMTP.rcpt(l_mail_conn, 'to@address');
  
  UTL_SMTP.open_data(l_mail_conn);
  
  -- The send date of the email.
  UTL_SMTP.write_data(l_mail_conn, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
  -- Insert the to address here.
  UTL_SMTP.write_data(l_mail_conn, 'To: to@address' || UTL_TCP.crlf);
  -- Insert the from address here.
  UTL_SMTP.write_data(l_mail_conn, 'From: from@address' || UTL_TCP.crlf);
  -- Craft the subject line of the email; note where error data is included.
  UTL_SMTP.write_data(l_mail_conn, 'Subject: DocFactory Error: ' || :new.ERROR_CODE|| UTL_TCP.crlf);
  -- Insert the reply-to address, if you need.
  UTL_SMTP.write_data(l_mail_conn, 'Reply-To: reply@address ' || UTL_TCP.crlf || UTL_TCP.crlf);
  -- Craft the body of the message; note where the error details are included.
  UTL_SMTP.write_data(l_mail_conn, 'The following error was received from ' || :new.ERRPROGRAM || ' on ' || :new.ERRHOSTNAME || ' at ' || :new.ERRTIME || UTL_TCP.crlf  || :new.ERRMESSAGE || UTL_TCP.crlf || UTL_TCP.crlf);
  UTL_SMTP.close_data(l_mail_conn);

  UTL_SMTP.quit(l_mail_conn);

END;
/

/*
SECURE
2. In order to access the UTL_SMTP library, you will need to create an ACL 
that grants the DMKR_ADMIN and DMKR_ASLINE users access to the SMTP library.
*/
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
TEST
3. This is a test insert-and-rollback that should cause the email trigger to be fired, and then the error message removed.
Note: you will no-doubt see how this design should not be used in production because a rollback still fires the email. The design
mentioned in the link above will facilitate rollback of the email notifications, but this is a quick-and-easy test.
*/

DECLARE
BEGIN
  insert into DMKR_ASLINE.ERRS
  (JOB_ID, TRN_ID, ERROR_CODE, ERRDATA, ERRMESSAGE, ERRHOSTNAME, ERRPROGRAM)  
  values (
  1,1,'123','errdata','msg','localhost','test');
  rollback; 
END;
/
