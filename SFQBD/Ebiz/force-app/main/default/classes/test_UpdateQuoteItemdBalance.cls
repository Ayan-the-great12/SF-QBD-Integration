// class added by @uzair_Hassan. 21 Dec 2020
@isTest
public with sharing class test_UpdateQuoteItemdBalance {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        Integer len = 10; //fake id
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        String reg = key.substring(0, len);
        EBizcharge_Setting__c ES = new EBizcharge_Setting__c();
        ES.Security_Token__c = reg;
        ES.User_Name__c = 'test-1';
        ES.Password__c = '123';
        ES.Transaction_Filter_By__c = 'Today ';
        ES.Email_Pending_Req_Filter_By__c = 'Today ';
        ES.Sync_Orders_Filter_By__c = 'Today';
        ES.Sync_Accounts_Filter_By__c = 'Today';
        ES.Sync_Products_Filter_By__c = 'Today';
        ES.Tax_Action__c = 'Today';
        ES.Tax_Calculate_By__c = 'Auto';
        ES.Tax_Manual_Type__c = 'Use Percent';
        ES.Tax_Default_Percent__c = 1;
        ES.Component_Label__c = 'test';
        ES.Tax_Action__c = 'Tax Included';
        system.assertEquals('test-1', ES.User_Name__c);
        insert ES;
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account act = MockData.GenrateDataAccount();
        act.First_Name__c = 'test2';
        act.Last_Name__c = 'test1';
        act.EBizCharge_Email__c = 'test@ebzi.com';
        act.Name = 'test1@ebzi.com';
        system.assertEquals('test2', act.First_Name__c);
        Product2 p = new Product2();
        p.Name = ' Test Product ';
        p.Description = 'Test Product Entry 1';
        p.productCode = 'ABC';
        p.isActive = true;
        insert p;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = p.Id;
        standardPrice.UnitPrice = 1;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice;
        // Insert Opportunity
        Opportunity opp = MockData.GenrateDataOpp(act.Id);
        opp.Name = 'Test Opportunity';
        opp.Pricebook2Id = pricebookId;
        // Insert Quote
        Quote q = new Quote();
        q.name = 'Test Quote';
        q.OpportunityId = opp.Id;
        q.Status = 'Draft';
        q.EBizCharge_Quote_Balance__c = 10;
        q.Pricebook2Id = pricebookId;
        insert q;
        // Insert Quote Line Item
        QuoteLineItem qli = new QuoteLineItem();
        qli.QuoteId = q.Id;
        qli.Product2Id = p.Id;
        qli.Quantity = 24;
        qli.UnitPrice = 240;
        qli.PricebookEntryId = standardPrice.id;
        insert qli;
        update qli;
        Delete[Select id from QuoteLineItem where id = : qli.Id];
    }
}