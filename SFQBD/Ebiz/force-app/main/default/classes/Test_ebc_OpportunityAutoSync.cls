@isTest
public with sharing class Test_ebc_OpportunityAutoSync {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        Opportunity oItem = StaticMockData.getOpportunity()[0];
        List < Opportunity > osOOP = new List < Opportunity > ();
        osOOP.add(oItem);
        Product2 p = StaticMockData.getProduct2()[0];
        Id pricebookId = Test.getStandardPricebookId();
        eBc_OpportunityAutoSync.invoke_updateOpportunity(osOOP);
        eBc_OpportunityAutoSync.invoke_UpdateOpportunityFuture(oItem.id);
    }
    @isTest(OnInstall = true)
    public static void testMethod2() {
        EBC_Logger ebcLogger = new EBC_Logger();
        Opportunity oItem = StaticMockData.getOpportunity()[0];
        eBc_OpportunityAutoSync.invoke_UpdateOpportunityFuture(oItem.id);
        oItem = StaticMockData.getOpportunity()[1];
        eBc_OpportunityAutoSync.invoke_UpdateOpportunityFuture(oItem.id);
    }
}