@istest
public with sharing class test_ebc_OrderItemInsertApexFlow {
    
    @isTest(OnInstall=true)
    public static void testMethod1() {
        DML dml = (DML)MockUtil.createMock(DML.class);
        OrderItem ordItem = StaticMockData.getOrderItem()[0];
        OrderItemInsertApexFlow.OrderLineItem olw = new OrderItemInsertApexFlow.OrderLineItem();
        olw.OrderItemTotalPrice = 12;
        olw.OrderItemNew = ordItem;
        List<OrderItemInsertApexFlow.OrderLineItem> lineItem = new List<OrderItemInsertApexFlow.OrderLineItem>();
        lineItem.add(olw);
        OrderItemInsertApexFlow.OrderItemInsert(lineItem);
    }
}