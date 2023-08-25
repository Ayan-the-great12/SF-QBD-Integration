@isTest
public with sharing class test_ebc_OrderItemDeleteApexFlow {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        List < OrderItem > ordItems = StaticMockData.getOrderItem();
        OrderItemDeleteApexFlow.OrderItemDelete(ordItems);
    }
}