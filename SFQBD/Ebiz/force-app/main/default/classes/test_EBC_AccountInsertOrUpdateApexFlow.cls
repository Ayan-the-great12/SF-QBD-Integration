@isTest
public class test_EBC_AccountInsertOrUpdateApexFlow {
    public static testMethod void doTest() {
        Account acc = StaticMockData.getAccount()[0];
        EBC_Logger ebcLogger = new EBC_Logger();
        String myJSON = JSON.serialize(acc);
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBizcharge_Setting__c settings = new EBizcharge_Setting__c();
        settings.Security_Token__c = 'reg';
        settings.User_Name__c = 'test-1';
        settings.Password__c = 'test-1';
        settings = eBc_SettingController.getSettingsApxc(dml, ebcLogger);
        settings.Auto_Upload_Account__c = true;
        insert settings;
        AccountInsertOrUpdateApexFlow.invoke_updateAccount(New List<AccountInsertOrUpdateApexFlow.AccountWrapper>());
        AccountInsertOrUpdateApexFlow.invoke_UpdateAccountFuture(myJSON,'1212341');
    }
    public static testMethod void doTest1() {
        Account acc = StaticMockData.getAccount()[0];
        acc.EBizCharge_Internal_ID__c = null;
        EBC_Logger ebcLogger = new EBC_Logger();
        String myJSON = JSON.serialize(acc);
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBizcharge_Setting__c settings = new EBizcharge_Setting__c();
        settings.Security_Token__c = 'reg';
        settings.User_Name__c = 'test-1';
        settings.Password__c = 'test-1';
        settings = eBc_SettingController.getSettingsApxc(dml, ebcLogger);
        settings.Auto_Upload_Account__c = true;
        insert settings;
        AccountInsertOrUpdateApexFlow.invoke_updateAccount(New List<AccountInsertOrUpdateApexFlow.AccountWrapper>());
        AccountInsertOrUpdateApexFlow.invoke_AddAccountFuture(acc.Id);
        try {
            AccountInsertOrUpdateApexFlow.invoke_updateAccount(New List<AccountInsertOrUpdateApexFlow.AccountWrapper>());
            AccountInsertOrUpdateApexFlow.invoke_AddAccountFuture(null);
        } catch (DmlException e) {}
    }
}