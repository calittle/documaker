BEGIN TRANSACTION
    -- Set the value of the new retention date
    DECLARE @NewRetentionDate AS VARCHAR(30);
    SET @NewRetentionDate = '2022-04-09 00:00:00.000';

    -- Update existing historical records. 
    -- Note: this applies to ALL records. Use a WHERE clause
    -- if necessary to apply to a subset of ALL records.
    UPDATE JOBSHIST SET JOBRETENTION = @NewRetentionDate;
    UPDATE TRNSHIST SET RETENTION    = @NewRetentionDate;
    UPDATE BCHS_RCPSHIST SET BCHRCPRETENTION = @NewRetentionDate;
    UPDATE BCHSHIST SET BCHRETENTION = @NewRetentionDate;
    UPDATE PUBSHIST SET PUBRETENTION = @NewRetentionDate;
COMMIT;