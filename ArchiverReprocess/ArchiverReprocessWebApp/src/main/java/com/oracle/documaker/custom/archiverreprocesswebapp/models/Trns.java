package com.oracle.documaker.custom.archiverreprocesswebapp.models;

public class Trns {
    private long jobId;
    private long trnId;
    private String trnModifyTime;
    public void setTrnId(long value){this.trnId=value;}
    public long getTrnId(){return this.trnId;}

    public void setJobId(long value){this.jobId=value;}
    public long getJobId(){return this.jobId;}

    public void setTrnModifyTime(String value){this.trnModifyTime=value;}
    public String getTrnModifyTime(){return this.trnModifyTime;}
}
