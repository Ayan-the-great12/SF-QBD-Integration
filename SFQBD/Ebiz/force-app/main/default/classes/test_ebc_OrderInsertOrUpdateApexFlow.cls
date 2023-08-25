@isTest
public with sharing class test_ebc_OrderInsertOrUpdateApexFlow {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        List < Order > orderList = StaticMockData.getOrder();
        orderList[0].EBizCharge_Internal_ID__c = '111111';
        orderList[1].EBizCharge_Internal_ID__c = null;
        EBizcharge_Setting__c ES = StaticMockData.getEBizcharge_Setting()[0];
        OrderInsertOrUpdateApexFlow.invoke_updateOrder(orderList);
        OrderInsertOrUpdateApexFlow.invoke_AddOrderFuture('000111111');
    }
}