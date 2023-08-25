public with sharing class LineItems {
    public static string ClassName = 'LineItems';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static List < OpportunityLineItem > getOpportunityLineItemsDetail(DML dml, String opportunityId, EBC_Logger ebcLogger) {
        MethodName = 'getOpportunityLineItemsDetail';
        List < OpportunityLineItem > opportunityLineItems = new List < OpportunityLineItem > ();
        String querySelect = 'SELECT Id,product2Id,product2.Name,product2.ProductCode,UnitPrice,Quantity,OpportunityId,Product2.Description,' + 'Product2.EBizCharge_Internal_ID__c,Product2.EBizCharge_Last_Sync_Date__c';
        String queryFrom = 'FROM OpportunityLineItem';
        String queryWhere = 'WHERE OpportunityId = \'' + String.escapeSingleQuotes(opportunityId) + '\'';
        try {
            opportunityLineItems = (List < OpportunityLineItem > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return opportunityLineItems;
    }
    public static List < OrderItem > getOrderItemsDetail(DML dml, String OrderId, EBC_Logger ebcLogger) {
        MethodName = 'getOrderItemsDetail';
        List < OrderItem > orderItem = new List < OrderItem > ();
        String querySelect = 'SELECT Id,product2Id,product2.Name,product2.ProductCode,UnitPrice,Quantity,OrderId,Product2.Description,' + 'Product2.EBizCharge_Internal_ID__c,Product2.EBizCharge_Last_Sync_Date__c';
        String queryFrom = 'FROM OrderItem';
        String queryWhere = 'WHERE OrderId = \'' + String.escapeSingleQuotes(OrderId) + '\'';
        try {
            orderItem = (List < OrderItem > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return orderItem;
    }
    public static List < QuoteLineItem > getQuoteLineItemsDetail(DML dml, String QuoteId, EBC_Logger ebcLogger) {
        MethodName = 'getQuoteLineItemsDetail';
        List < QuoteLineItem > quoteLineItem = new List < QuoteLineItem > ();
        String querySelect = 'SELECT Id,product2Id,product2.Name,product2.ProductCode,UnitPrice,Quantity,QuoteId,Product2.Description,' + 'Product2.EBizCharge_Internal_ID__c,Product2.EBizCharge_Last_Sync_Date__c';
        String queryFrom = 'FROM QuoteLineItem';
        String queryWhere = 'WHERE QuoteId = \'' + String.escapeSingleQuotes(QuoteId) + '\'';
        try {
            quoteLineItem = (List < QuoteLineItem > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return quoteLineItem;
    }
}