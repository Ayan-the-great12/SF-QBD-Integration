@isTest
public with sharing class Test_eBc_OrderAutoSync {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        Order ord = StaticMockData.getOrder()[0];
        List < Order > ordList = new List < Order > ();
        ordList.add(ord);
        eBc_OrderAutoSync.invoke_updateOrder(ordList);
    }
    @isTest(OnInstall = true)
    public static void testMethod2() {
        EBC_Logger ebcLogger = new EBC_Logger();
        Order ord = StaticMockData.getOrder()[0];
        eBc_OrderAutoSync.invoke_UpdateOrderFuture(ord.id);
        ord = StaticMockData.getOrder()[1];
        eBc_OrderAutoSync.invoke_UpdateOrderFuture(ord.id);
    }
}