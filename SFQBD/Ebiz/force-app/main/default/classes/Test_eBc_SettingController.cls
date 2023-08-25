@isTest
public class Test_eBc_SettingController {
    @isTest(OnInstall = true)
    static void testMethod1() {
        EBC_Logger ebcLogger = new EBC_Logger();
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBizcharge_Setting__c ES = StaticMockData.getEBizcharge_Setting()[0];
        eBc_UtilityController.getSecurityToken(dml, ebcLogger);
        EBizcharge_Setting__c GetTestRecord = eBc_SettingController.getSettingsApxc();
        eBc_SettingController.getSettingsList();
        eBc_SettingController.getSettingRecord(ES.id);
        eBc_SettingController.getSettingsApxc();
    }
    @isTest(OnInstall = true)
    static void testMethod2() {
        EBC_Logger ebcLogger = new EBC_Logger();
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBizcharge_Setting__c ES = StaticMockData.getEBizcharge_Setting()[0];
        eBc_UtilityController.getSecurityToken(dml, ebcLogger);
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        eBc_SettingController.getListOfEmailTemplates();
        eBc_SettingController.saveSettingsApxc(ES);
        eBc_SettingController.getSettingsApxc();
        eBc_SettingController.getApplicationDataApxc('app1111', 'test');
        eBc_SettingController.getSettingsList();
        eBc_SettingController.getSettingRecord('test');
        eBc_SettingController.runTransactionsJob();
        Test.StopTest();
    }
}