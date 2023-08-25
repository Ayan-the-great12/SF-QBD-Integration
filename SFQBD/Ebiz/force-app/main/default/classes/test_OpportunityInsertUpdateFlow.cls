@isTest
public with sharing class test_OpportunityInsertUpdateFlow {
    public static testMethod void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        List < opportunity > opportunityList = StaticMockData.getOpportunity();
        opportunityList[0].EBizCharge_Internal_ID__c = '111111111';
        opportunityList[1].EBizCharge_Internal_ID__c = null;
        EBizcharge_Setting__c ES = StaticMockData.getEBizcharge_Setting()[0];
        OpportunityInsertOrUpdateApexFlow.invoke_updateOpportunity(opportunityList);
        OpportunityInsertOrUpdateApexFlow.invoke_AddOpportunityFuture('111111111'); //System.AuraHandledException: Script-thrown exception
    }
}