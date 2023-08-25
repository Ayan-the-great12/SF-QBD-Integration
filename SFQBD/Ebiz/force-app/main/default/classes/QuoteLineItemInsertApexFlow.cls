public with sharing class QuoteLineItemInsertApexFlow {
    @InvocableMethod
    public static void QuoteLineItemInsert(List < QuoteItem > quoteItems) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        for (QuoteItem quoteItem: quoteItems) {
            QuoteLineItemInsert(dml, quoteItem);
        }
    }
    public static void QuoteLineItemInsert(DML dml, QuoteItem quoteItem) {
        EBC_Logger ebcLogger = new EBC_Logger();
        string quoteId = null;
        QuoteLineItem QuoteLineItm = quoteItem.QuoteLineItemNew;
        Double QuoteLineItemTotalPriceOld = quoteItem.QuoteLineItemTotalPrice;
        quoteId = QuoteLineItm.quoteId;
        if (!string.isEmpty(quoteId) && quoteId != null) {
            UpdateQuoteTriggerHelper.UpdateQuoteAmountOnInsert(dml, quoteId, QuoteLineItm, QuoteLineItemTotalPriceOld, ebcLogger);
        }
    }
    public class QuoteItem {
        @InvocableVariable
        public QuoteLineItem QuoteLineItemNew;
        @InvocableVariable
        public Double QuoteLineItemTotalPrice;
    }
}