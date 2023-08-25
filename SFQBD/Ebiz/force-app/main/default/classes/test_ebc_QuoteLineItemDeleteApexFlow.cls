@isTest
public with sharing class test_ebc_QuoteLineItemDeleteApexFlow {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        QuoteLineItem qItem = StaticMockData.getQuoteLineItem()[0];
        List < QuoteLineItem > quoItem = new List < QuoteLineItem > ();
        QuoteLineItemDeleteApexFlow.QuoteLineItemDelete(dml, qItem);
        QuoteLineItemDeleteApexFlow.QuoteLineItemDelete(quoItem);
    }
}