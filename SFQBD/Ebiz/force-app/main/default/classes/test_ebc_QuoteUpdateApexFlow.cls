@isTest
public with sharing class test_ebc_QuoteUpdateApexFlow {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        List < Quote > quoteList = StaticMockData.getQuote();
        quoteList[0].EBizCharge_Internal_ID__c = '111111';
        quoteList[1].EBizCharge_Internal_ID__c = null;
        EBizcharge_Setting__c settings = new EBizcharge_Setting__c();
        QuoteUpdateApexFlow.invoke_updateQuote(quoteList);
        QuoteUpdateApexFlow.invoke_AddQuoteFuture('11111111');
    }
}