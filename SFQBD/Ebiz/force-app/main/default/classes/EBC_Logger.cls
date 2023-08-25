public with sharing class EBC_Logger {
    private List < EBizCharge_Logs__c > logList;
    private EBizcharge_Setting__c ebizChargeSettings;
    public EBC_Logger() {
        this(new DML());
    }
    public EBC_Logger(DML dml) {
        logList = new List < EBizCharge_Logs__c > ();
        getSettingsApxc(dml);
    }
    public void debug(String className, String methodName, String message) {
        debug(className, methodName, message, 'INFO');
    }
    public void debug(String className, String methodName, String message, String logLevel) {
        if (ebizChargeSettings != null && ebizChargeSettings.EBizCharge_IsLogEnable__c) {
            if (ebizChargeSettings.EBizcharge_IsLogErrorEnable__c && logLevel == 'ERROR') {
                EBizCharge_Logs__c logObj = new EBizCharge_Logs__c();
                logObj.EBizCharge_Class_Name__c = className;
                logObj.EBizCharge_Method_Name__c = methodName;
                logObj.EBizCharge_Message__c = message;
                logObj.EBizCharge_Log_Level__c = logLevel;
                logList.add(logObj);
            } else if (ebizChargeSettings.EBizcharge_IsLogExceptionEnable__c && logLevel == 'EXCEPTION') {
                EBizCharge_Logs__c logObj = new EBizCharge_Logs__c();
                logObj.EBizCharge_Class_Name__c = className;
                logObj.EBizCharge_Method_Name__c = methodName;
                logObj.EBizCharge_Message__c = message;
                logObj.EBizCharge_Log_Level__c = logLevel;
                logList.add(logObj);
            } else if (ebizChargeSettings.EBizcharge_IsLogInfoEnable__c && logLevel == 'INFO') {
                EBizCharge_Logs__c logObj = new EBizCharge_Logs__c();
                logObj.EBizCharge_Class_Name__c = className;
                logObj.EBizCharge_Method_Name__c = methodName;
                logObj.EBizCharge_Message__c = message;
                logObj.EBizCharge_Log_Level__c = logLevel;
                logList.add(logObj);
            } else if (ebizChargeSettings.EBizcharge_IsLogWarningEnable__c && logLevel == 'WARNING') {
                EBizCharge_Logs__c logObj = new EBizCharge_Logs__c();
                logObj.EBizCharge_Class_Name__c = className;
                logObj.EBizCharge_Method_Name__c = methodName;
                logObj.EBizCharge_Message__c = message;
                logObj.EBizCharge_Log_Level__c = logLevel;
                logList.add(logObj);
            } else {
                EBizCharge_Logs__c logObj = new EBizCharge_Logs__c();
                logObj.EBizCharge_Class_Name__c = className;
                logObj.EBizCharge_Method_Name__c = methodName;
                logObj.EBizCharge_Message__c = message;
                logObj.EBizCharge_Log_Level__c = logLevel;
                logList.add(logObj);
            }
        }
        system.debug(className + ' -- ' + methodName + ' -- ' + message);
    }
    public void saveLogs() {
        DML dml = new DML();
        if (logList != null) {
            dml.insertRecord(logList);
        }
        system.debug('Logger save function End');
    }
    public void getSettingsApxc(DML dml) {
        try {
            String querySelect = 'SELECT Id, EBizCharge_IsLogEnable__c, EBizcharge_IsLogErrorEnable__c, EBizcharge_IsLogExceptionEnable__c, EBizcharge_IsLogInfoEnable__c, EBizcharge_IsLogWarningEnable__c';
            String queryFrom = 'FROM EBizcharge_Setting__c';
            String queryOrderby = 'Order by CreatedDate DESC';
            ebizChargeSettings = (EBizcharge_Setting__c) dml.selectSingleRecord(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryOrderby);
        } catch (Exception e) {
            system.debug(e.getMessage());
        }
    }
}