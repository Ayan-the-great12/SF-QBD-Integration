@isTest
public with sharing class test_ContactInsertOrUpdateApexFlow {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        Contact con = StaticMockData.getContact()[0];
        String contString = JSON.serialize(con);
        EBC_Logger ebcLogger = new EBC_Logger();
        EBizcharge_Setting__c settings = new EBizcharge_Setting__c();
        settings.Auto_Upload_Contact__c = true;
        insert settings;
        ContactInsertOrUpdateApexFlow.invoke_updateContact(New Contact[] {
            con
        });
        ContactInsertOrUpdateApexFlow.invoke_UpdateContactFuture(contString);
        ContactInsertOrUpdateApexFlow.invoke_AddContactFuture('0031h00000e2pEjAAI');
    }
}