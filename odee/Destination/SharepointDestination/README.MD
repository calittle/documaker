# Custom Archiver SharePoint Destination
andy.little@oracle.com
4 March 2024

A custom `Destination` for Oracle Documaker Enterprise Edition that integrates with SharePoint for document delivery.

## Installation
1. Deploy JAR file to `docfactory\lib` on all nodes.
2. Deploy `target\lib` files to `docfactory\lib` on all nodes. Note: if a shaded JAR is used, this step can be skipped.
3. Use a SQL client to execute the following statement. Replace `DMKR_ADMIN` with name of Documaker Admin schema. This will enable the use of the custom destination. Note that the `DISPLAY` and `DESCRIPTION` values may be changed, but `ID` (`Telesign`) must remain as-is since it correlates to other settings below.
```sql
INSERT INTO DMKR_ADMIN.DMKR_TRANSLAT (SYS_ID, AL_ID, APP_ID, LOCALE_ID, GROUP_ID, ID, DISPLAY, DESCRIPTION, DISPLAYSEQ) VALUES (1, 1, 0, 'en', 'BCHINGS.BCHINGARCDEST',  'Telesign', 'Telesign', 'Telesign Messagingin Integration', 1);
```
## Configuration
2. Update Documaker Administrator with configuration settings. Verify `SYS_ID`, `AL_ID` are correct. Replace `DMKR_ADMIN` with name of Documaker Admin schema.
```sql
INSERT INTO DMKR_ADMIN.ALCONFIGCONTEXT (SYS_ID,AL_ID,CONTEXT_NAME,CATEGORY,GROUP_NAME,PROPERTY,VALUE,ACTIVE,USERTAG1,NOTES,USER_ID,USER_NAME) values (1,1,'LOG4J', 'Loggers','Logger','name', 'com.oracle.documaker.custom',1,null,'Logs diagnostic and error information Connector package.',null,'installer');
INSERT INTO DMKR_ADMIN.APPCONFIGCONTEXT (SYS_ID, AL_ID, APP_ID, CTX_ID, CONTEXT_NAME, GROUP_NAME, PROPERTY, VALUE, VALUE_TYPE, VALUE_REF, GROUPSEQ, CATEGORY, ACTIVE, IS_SECRET, IS_ENCRYPT, CREATETIME, MODIFYTIME, USERTAG1, NOTES, USER_ID, USER_NAME) VALUES (&system_id., &al_id., 9, null, 'LOG4J', 'com.oracle.documaker.custom.destinations.Telesign', 'priority', 'DEBUG', 0, null, 1, 'Logger', 1, 0, 0, TO_TIMESTAMP('2024-03-04 22:32:05.027902', 'YYYY-MM-DD HH24:MI:SS.FF6'), TO_TIMESTAMP('2024-03-04 22:32:05.027977', 'YYYY-MM-DD HH24:MI:SS.FF6'), null, 'Set to ERROR for general production, DEBUG for debugging.', 2, 'documaker');
INSERT INTO DMKR_ADMIN.APPCONFIGCONTEXT (SYS_ID, AL_ID, APP_ID, CTX_ID, CONTEXT_NAME, GROUP_NAME, PROPERTY, VALUE, VALUE_TYPE, VALUE_REF, GROUPSEQ, CATEGORY, ACTIVE, IS_SECRET, IS_ENCRYPT, CREATETIME, MODIFYTIME, USERTAG1, NOTES, USER_ID, USER_NAME) VALUES (&system_id., &al_id., 9, null, 'LOG4J', 'com.oracle.documaker.custom.destinations.TelesignDestination', 'priority', 'DEBUG', 0, null, 1, 'Logger', 1, 0, 0, TO_TIMESTAMP('2024-03-04 22:32:05.027902', 'YYYY-MM-DD HH24:MI:SS.FF6'), TO_TIMESTAMP('2024-03-04 22:32:05.027977', 'YYYY-MM-DD HH24:MI:SS.FF6'), null, 'Set to ERROR for general production, DEBUG for debugging.', 2, 'documaker');
INSERT INTO DMKR_ADMIN.APPCONFIGCONTEXT (SYS_ID, AL_ID, APP_ID, CONTEXT_NAME, GROUP_NAME, PROPERTY, VALUE, VALUE_TYPE, VALUE_REF, GROUPSEQ, CATEGORY, ACTIVE, IS_SECRET, IS_ENCRYPT, USER_ID, USER_NAME) VALUES (1, 1, 9, 'DESTINATION', 'Configuration', 'default', null, 0, null, 1, 'Telesign', 1, 0, 0, 2, 'documaker');
INSERT INTO DMKR_ADMIN.APPCONFIGCONTEXT (SYS_ID, AL_ID, APP_ID, CONTEXT_NAME, GROUP_NAME, PROPERTY, VALUE, VALUE_TYPE, VALUE_REF, GROUPSEQ, CATEGORY, ACTIVE, IS_SECRET, IS_ENCRYPT, USER_ID, USER_NAME) VALUES (1, 1, 9, 'DESTINATION', 'Configuration', 'destination.name', 'com.oracle.documaker.custom.destinations.TelesignDestination', 0, null, 1, 'Telesign', 1, 0, 0, 2, 'documaker');
INSERT INTO DMKR_ADMIN.APPCONFIGCONTEXT (SYS_ID, AL_ID, APP_ID, CONTEXT_NAME, GROUP_NAME, PROPERTY, VALUE, VALUE_TYPE, VALUE_REF, GROUPSEQ, CATEGORY, ACTIVE, IS_SECRET, IS_ENCRYPT, USER_ID, USER_NAME) VALUES (1, 1, 9, 'DESTINATION', 'Configuration', 'Telesign.customerid', 'Telesign Customer ID', 0, null, 1, 'Telesign', 1, 0, 0, 2, 'documaker');
INSERT INTO DMKR_ADMIN.APPCONFIGCONTEXT (SYS_ID, AL_ID, APP_ID, CONTEXT_NAME, GROUP_NAME, PROPERTY, VALUE, VALUE_TYPE, VALUE_REF, GROUPSEQ, CATEGORY, ACTIVE, IS_SECRET, IS_ENCRYPT, USER_ID, USER_NAME) VALUES (1, 1, 9, 'DESTINATION', 'Configuration', 'Telesign.apikey', 'Telesign API Key', 0, null, 1, 'Telesign', 1, 0, 0, 2, 'documaker');
INSERT INTO DMKR_ADMIN_1270.APPCONFIGCONTEXT (SYS_ID, AL_ID, APP_ID, CONTEXT_NAME, GROUP_NAME, PROPERTY, VALUE, VALUE_TYPE, VALUE_REF, GROUPSEQ, CATEGORY, ACTIVE, IS_SECRET, IS_ENCRYPT, USER_ID, USER_NAME) VALUES (1, 1, 9, 'DESTINATION', 'Defaults', 'default', null, 0, null, 1, 'Telesign', 1, 0, 0, 2, 'documaker');
INSERT INTO DMKR_ADMIN_1270.APPCONFIGCONTEXT (SYS_ID, AL_ID, APP_ID, CONTEXT_NAME, GROUP_NAME, PROPERTY, VALUE, VALUE_TYPE, VALUE_REF, GROUPSEQ, CATEGORY, ACTIVE, IS_SECRET, IS_ENCRYPT, USER_ID, USER_NAME) VALUES (1, 1, 9, 'DESTINATION', 'Mappings', 'default', null, 0, null, 1, 'Telesign', 1, 0, 0, 2, 'documaker');
INSERT INTO DMKR_ADMIN_1270.APPCONFIGCONTEXT (SYS_ID, AL_ID, APP_ID, CONTEXT_NAME, GROUP_NAME, PROPERTY, VALUE, VALUE_TYPE, VALUE_REF, GROUPSEQ, CATEGORY, ACTIVE, IS_SECRET, IS_ENCRYPT, USER_ID, USER_NAME) VALUES (1, 1, 9, 'DESTINATION', 'Mappings', 'docname', '{PUBS.PUBUNIQUEID}', 0, null, 1, 'FileNet', 1, 0, 0,2, 'documaker');
INSERT INTO DMKR_ADMIN_1270.APPCONFIGCONTEXT (SYS_ID, AL_ID, APP_ID, CONTEXT_NAME, GROUP_NAME, PROPERTY, VALUE, VALUE_TYPE, VALUE_REF, GROUPSEQ, CATEGORY, ACTIVE, IS_SECRET, IS_ENCRYPT, USER_ID, USER_NAME) VALUES (1, 1, 9, 'DESTINATION', 'Mappings', 'custom.repositoryId', 'OSTORE2', 0, null, 1, 'FileNet', 1, 0, 0,2, 'documaker');
INSERT INTO DMKR_ADMIN_1270.APPCONFIGCONTEXT (SYS_ID, AL_ID, APP_ID, CONTEXT_NAME, GROUP_NAME, PROPERTY, VALUE, VALUE_TYPE, VALUE_REF, GROUPSEQ, CATEGORY, ACTIVE, IS_SECRET, IS_ENCRYPT, USER_ID, USER_NAME) VALUES (1, 1, 9, 'DESTINATION', 'Mappings', 'docname', '{PUBS.PUBUNIQUEID}', 0, null, 1, 'FileNet', 1, 0, 0,2, 'documaker');
commit;
```