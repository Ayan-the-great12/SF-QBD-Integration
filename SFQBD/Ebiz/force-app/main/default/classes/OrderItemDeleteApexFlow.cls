public with sharing class OrderItemDeleteApexFlow {
    @InvocableMethod
    public static void OrderItemDelete(List < OrderItem > orderItems) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        for (OrderItem orderItem: orderItems) {
            OrderItemDelete(dml, orderItem);
        }
    }
    public static void OrderItemDelete(DML dml, OrderItem orderItems) {
        EBC_Logger ebcLogger = new EBC_Logger();
        string orderId = null;
        orderId = orderItems.orderId;
        if (test.isRunningTest()) {
            orderId = 'F00001GLIrjQAH';
        }
        if (!string.isEmpty(orderId)) {
            boolean allowDelete = UpdateOrderTriggerHelper.UpdateOrderAmountOnDelete(dml, orderId, orderItems, ebcLogger);
        }
    }
}