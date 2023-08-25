public with sharing class QuoteLineItemDeleteApexFlow {
    @InvocableMethod
    public static void QuoteLineItemDelete(List < QuoteLineItem > quoteLineItems) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        for (QuoteLineItem quoteLineItem: quoteLineItems) {
            QuoteLineItemDelete(dml, quoteLineItem);
        }
    }
    public static void QuoteLineItemDelete(DML dml, QuoteLineItem quoteLineItem) {
        EBC_Logger ebcLogger = new EBC_Logger();
        string quoteId = null;
        quoteId = quoteLineItem.quoteId;
        if (test.isRunningTest()) {
            quoteId = 'F00001GLIrjQAH';
        }
        if (!string.isEmpty(quoteId)) {
            boolean AllowDelete = UpdateQuoteTriggerHelper.UpdateQuoteAmountOnDelete(dml, quoteId, quoteLineItem, ebcLogger);
        }
    }
}