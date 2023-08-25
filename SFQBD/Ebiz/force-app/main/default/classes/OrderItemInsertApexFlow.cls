public with sharing class OrderItemInsertApexFlow {
    @InvocableMethod
    public static void OrderItemInsert(List < OrderLineItem > orders) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        for (OrderLineItem orderItem: orders) {
            OrderItemInsert(dml, orderItem);
        }
    }
    public static void OrderItemInsert(DML dml, OrderLineItem orderLineItem) {
        EBC_Logger ebcLogger = new EBC_Logger();
        string orderId = null;
        OrderItem orderitem = orderLineItem.OrderItemNew;
        orderId = orderitem.orderId;
        Double orderItemTotalPriceOld = orderLineItem.OrderItemTotalPrice;
        if (!string.isEmpty(orderId) && orderId != null) {
            UpdateOrderTriggerHelper.UpdateOrderAmountOnInsert(dml, orderId, orderitem, orderItemTotalPriceOld, ebcLogger);
        }
    }
    public class OrderLineItem {
        @InvocableVariable
        public OrderItem OrderItemNew;
        @InvocableVariable
        public Double OrderItemTotalPrice;
    }
}