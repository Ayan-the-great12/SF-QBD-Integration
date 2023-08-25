@isTest
public class test_transactionParams {
    @isTest(OnInstall = true)
    static void testMethod1() {
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
        insert ES;
        system.assertEquals('test-1', ES.User_Name__c);
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        transactionParams ts = new transactionParams();
        ts.paymentType = 'test';
        ts.OrderID = 'test';
        ts.OrderNumber = 'test';
        ts.accountID = 'test';
        ts.customerID = 'test';
        ts.internalID = 'test';
        ts.customerToken = 'test';
        ts.ccNumber = 'test';
        ts.expMonth = 'test';
        ts.expYear = 'test';
        ts.cvvCode = 'test';
        ts.ccName = 'test';
        ts.AvsZip = 'test';
        ts.AvsStreet = 'test';
        ts.CardCode = 'test';
        ts.saveCard = true;
        ts.AccountName = 'test';
        ts.Account = 'test';
        ts.Route = 'test';
        ts.saveAccount = true;
        ts.methodID = 'test';
        ts.isRecurring = true;
        ts.SubTotal = 0.00;
        ts.Amount = 0.00;
        ts.Tax = 0.00;
        ts.Schedule = 'test';
        ts.ScheduleName = 'test';
        ts.Notes = 'test';
        ts.SoftwareId = 'test';
    }
}