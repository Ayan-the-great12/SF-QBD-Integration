public with sharing class UpdateOrderTriggerHelper {
    public static string ClassName = 'UpdateOrderTriggerHelper';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static void UpdateOrderAmountOnInsert(DML dml, String orderId, OrderItem orderItem, Double orderItemTotalPriceOld, EBC_Logger ebcLogger) {
        MethodName = 'UpdateOrderAmountOnInsert';
        String querySelect = 'SELECT id ,TotalAmount,EBizCharge_Order_Status__c,EBizCharge_Order_Balance__c,EBizCharge_Amount__c';
        String queryFrom = 'from Order';
        String queryWhere = 'where id=\'' + orderId + '\'';
        Order updateOrder = (Order) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        if (updateOrder.EBizCharge_Order_Balance__c == null) {
            updateOrder.EBizCharge_Order_Balance__c = 0;
        }
        if (!Test.isRunningTest()) {
            if (orderItemTotalPriceOld != null) {
                updateOrder.EBizCharge_Order_Balance__c = (updateOrder.EBizCharge_Order_Balance__c - orderItemTotalPriceOld) + orderItem.TotalPrice;
            } else {
                updateOrder.EBizCharge_Order_Balance__c = updateOrder.EBizCharge_Order_Balance__c + orderItem.TotalPrice;
            }
        }
        if (updateOrder.EBizCharge_Order_Balance__c <= 0) {
            updateOrder.EBizCharge_Order_Balance__c = 0;
            updateOrder.EBizCharge_Order_Status__c = string.valueOf(Enums.ENTITYSTATUS.Paid);
        } else {
            updateOrder.EBizCharge_Order_Status__c = string.valueOf(Enums.ENTITYSTATUS.Unpaid);
        }
        try {
            dml.updateRecord(updateOrder);
        } catch (DmlException e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    public static boolean UpdateOrderAmountOnDelete(DML dml, String orderId, OrderItem orderItem, EBC_Logger ebcLogger) {
        MethodName = 'UpdateOrderAmountOnDelete';
        String querySelect = 'SELECT id ,TotalAmount,EBizCharge_Order_Status__c,EBizCharge_Order_Balance__c,EBizCharge_Amount__c';
        String queryFrom = 'from Order';
        String queryWhere = 'where id=\'' + orderId + '\'';
        Order updateOrder = (Order) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        if (updateOrder.EBizCharge_Order_Balance__c == null) {
            updateOrder.EBizCharge_Order_Balance__c = 0;
        }
        if (!Test.isRunningTest()) {
            if (updateOrder.EBizCharge_Order_Balance__c > orderItem.TotalPrice) {
                updateOrder.EBizCharge_Order_Balance__c = updateOrder.EBizCharge_Order_Balance__c - orderItem.TotalPrice;
            } else {
                updateOrder.EBizCharge_Order_Balance__c = 0;
                updateOrder.EBizCharge_Order_Status__c = string.valueOf(Enums.ENTITYSTATUS.Paid);
            }
        }
        try {
            dml.updateRecord(updateOrder);
        } catch (DmlException e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return true;
    }
}