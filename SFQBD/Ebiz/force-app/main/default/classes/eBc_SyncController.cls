public with sharing class eBc_SyncController {
    @AuraEnabled
    public static EBizcharge_Setting__c getSettingsApxc() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        return getSettingsApxc(dml, ebcLogger);
    }
    public static EBizcharge_Setting__c getSettingsApxc(DML dml, EBC_Logger ebcLogger) {
        return eBc_UtilityController.getSettings(dml, ebcLogger);
    }
}