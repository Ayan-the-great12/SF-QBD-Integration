@isTest
public with sharing class test_ebc_QuoteLineItemInsertApexFlow {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        QuoteLineItem qlitem = StaticMockData.getQuoteLineItem()[0];
        List < QuoteLineItemInsertApexFlow.QuoteItem > quoItem = new List < QuoteLineItemInsertApexFlow.QuoteItem > ();
        QuoteLineItemInsertApexFlow.QuoteItem olw = new QuoteLineItemInsertApexFlow.QuoteItem();
        olw.QuoteLineItemTotalPrice = 12;
        olw.QuoteLineItemNew = qlitem;
        quoItem.add(olw);
        QuoteLineItemInsertApexFlow.QuoteLineItemInsert(quoItem);
    }
}