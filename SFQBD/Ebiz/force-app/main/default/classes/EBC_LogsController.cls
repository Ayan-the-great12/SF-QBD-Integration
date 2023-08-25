public with sharing class EBC_LogsController {
    @AuraEnabled
    public static list < Ebiz_C__EBizCharge_Logs__c > fetchLogs() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        return fetchLogs(dml);
    }
    public static list < Ebiz_C__EBizCharge_Logs__c > fetchLogs(DML dml) {
        List < Ebiz_C__EBizCharge_Logs__c > customLogs = new List < Ebiz_C__EBizCharge_Logs__c > ();
        String querySelect = 'select EBizCharge_Class_Name__c, EBizCharge_Method_Name__c, EBizCharge_Message__c, EBizCharge_Log_Level__c';
        String queryFrom = 'from EBizCharge_Logs__c';
        String queryOrderby = 'Order By CreatedDate';
        customLogs = (list < Ebiz_C__EBizCharge_Logs__c > ) dml.selectRecords(querySelect, queryFrom, '', '', queryOrderby, '');
        return customLogs;
    }
    @AuraEnabled
    public static list < Ebiz_C__EBizCharge_Logs__c > FilterdfetchLogs(list < String > LogLevel) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        return FilterdfetchLogs(dml, LogLevel);
    }
    public static list < Ebiz_C__EBizCharge_Logs__c > FilterdfetchLogs(DML dml, list < String > LogLevel) {
        List < Ebiz_C__EBizCharge_Logs__c > customLogs = new List < Ebiz_C__EBizCharge_Logs__c > ();
        String querySelect = 'select EBizCharge_Class_Name__c, EBizCharge_Method_Name__c, EBizCharge_Message__c, EBizCharge_Log_Level__c';
        String queryFrom = 'from EBizCharge_Logs__c';
        String queryOrderby = 'Order By CreatedDate';
        String querywhere = 'Where EBizCharge_Log_Level__c in :';
        customLogs = (list < Ebiz_C__EBizCharge_Logs__c > ) dml.selectRecordsInList(LogLevel, querySelect, queryFrom, querywhere, '', queryOrderby, '');
        return customLogs;
    }
    @AuraEnabled
    public static void RemoveLogs() {
        try {
            List < Ebiz_C__EBizCharge_Logs__c > customLogs = [SELECT Ebiz_C__EBizCharge_Class_Name__c, Ebiz_C__EBizCharge_Method_Name__c, Ebiz_C__EBizCharge_Message__c, Ebiz_C__EBizCharge_Log_Level__c from Ebiz_C__EBizCharge_Logs__c];
            if (Schema.sObjectType.Ebiz_C__EBizCharge_Logs__c.isDeletable())
                delete customLogs;
        } catch (Exception e) {
            throw new AuraHandledException('Unable to delete logs: ' + e.getMessage());
        }
    }
}