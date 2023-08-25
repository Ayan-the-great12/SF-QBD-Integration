@isTest
public with sharing class Test_eBc_QuoteAutoSync {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        Quote qItem = StaticMockData.getQuote()[0];
        List < Quote > osQuote = new List < Quote > ();
        osQuote.add(qItem);
        eBc_QuoteAutoSync.invoke_updateQuote(osQuote);
    }
    @isTest(OnInstall = true)
    public static void testMethod2() {
        EBC_Logger ebcLogger = new EBC_Logger();
        Quote qItem = StaticMockData.getQuote()[0];
        eBc_QuoteAutoSync.invoke_UpdateQuoteFuture(qItem.id);
        qItem = StaticMockData.getQuote()[1];
        eBc_QuoteAutoSync.invoke_UpdateQuoteFuture(qItem.id);
    }
}