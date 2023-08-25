public with sharing class UpdateQuoteTriggerHelper {
    public static string ClassName = 'UpdateOrderTriggerHelper';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static void UpdateQuoteAmountOnInsert(DML dml, String QuoteId, QuoteLineItem QuoteLineItm, Double QuoteLineItemTotalPriceOld, EBC_Logger ebcLogger) {
        MethodName = 'UpdateQuoteAmountOnInsert';
        String querySelect = 'SELECT id ,GrandTotal,EBizCharge_Quote_Status__c,EBizCharge_Quote_Balance__c,EBizCharge_Amount__c';
        String queryFrom = 'from Quote';
        String queryWhere = 'where id=\'' + QuoteId + '\'';
        Quote updateQuote = (Quote) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        if (updateQuote.EBizCharge_Quote_Balance__c == null) {
            updateQuote.EBizCharge_Quote_Balance__c = 0;
        }
        if (!Test.isRunningTest()) {
            if (QuoteLineItemTotalPriceOld != null) {
                updateQuote.EBizCharge_Quote_Balance__c = (updateQuote.EBizCharge_Quote_Balance__c - QuoteLineItemTotalPriceOld) + QuoteLineItm.TotalPrice;
            } else {
                updateQuote.EBizCharge_Quote_Balance__c = updateQuote.EBizCharge_Quote_Balance__c + QuoteLineItm.TotalPrice;
            }
        }
        if (updateQuote.EBizCharge_Quote_Balance__c <= 0) {
            updateQuote.EBizCharge_Quote_Balance__c = 0;
            updateQuote.EBizCharge_Quote_Status__c = string.valueOf(Enums.ENTITYSTATUS.Paid);
        } else {
            updateQuote.EBizCharge_Quote_Status__c = string.valueOf(Enums.ENTITYSTATUS.Unpaid);
        }
        try {
            dml.updateRecord(updateQuote);
        } catch (DmlException e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    public static boolean UpdateQuoteAmountOnDelete(DML dml, String QuoteId, QuoteLineItem QuoteLineItm, EBC_Logger ebcLogger) {
        MethodName = 'UpdateQuoteAmountOnDelete';
        String querySelect = 'SELECT id ,GrandTotal,EBizCharge_Quote_Status__c,EBizCharge_Quote_Balance__c,EBizCharge_Amount__c';
        String queryFrom = 'from Quote';
        String queryWhere = 'where id=\'' + QuoteId + '\'';
        Quote updateQuote = (Quote) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        if (updateQuote.EBizCharge_Quote_Balance__c == null) {
            updateQuote.EBizCharge_Quote_Balance__c = 0;
        }
        if (!Test.isRunningTest()) {
            if (updateQuote.EBizCharge_Quote_Balance__c > QuoteLineItm.TotalPrice) {
                updateQuote.EBizCharge_Quote_Balance__c = updateQuote.EBizCharge_Quote_Balance__c - QuoteLineItm.TotalPrice;
            } else {
                updateQuote.EBizCharge_Quote_Balance__c = 0;
                updateQuote.EBizCharge_Quote_Status__c = string.valueOf(Enums.ENTITYSTATUS.Paid);
            }
        }
        try {
            dml.updateRecord(updateQuote);
        } catch (DmlException e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return true;
    }
}