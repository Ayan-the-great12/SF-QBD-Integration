@isTest
public with sharing class test_ebc_ProductAddorUpdateFlow {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        product2 prod = StaticMockData.getProduct2()[0];
        prod.EBizCharge_Internal_ID__c = '111111';
        prod.Name = 'Test Prod';
        prod.Description = 'Test Product Entry';
        prod.productCode = 'ABCD';
        prod.isActive = true;
        PricebookEntry pbookE = StaticMockData.getPricebookEntry()[0];
        EBizcharge_Setting__c settings = new EBizcharge_Setting__c();
        settings.Ebiz_C__Auto_Upload_Product__c = true;
        settings.Division_ID__c = '1234';
        insert settings;
        ProductAddorUpdateFlow.invoke_updateProduct(New product2[] {
            prod
        });
        ProductAddorUpdateFlow.invoke_updateProduct(dml, prod);
        string processStrMap = '{"saveACH":true, "saveCard":true, "AccountId" : "' + prod.Id + '", "Name": "Test", "Description":"TestDescription", "ProductCode" : "t2222", "IsActive" : true, "SendReceiptTo": true, "addEmails" : "test@test.com" }';
        ProductAddorUpdateFlow.invoke_AddProductFuture(processStrMap, '1111111', '8');
        ProductAddorUpdateFlow.invoke_AddProduct(dml, prod);
    }
}