@isTest
public  class test_UpdateSettings {

    @isTest(OnInstall=true)
    public static void testMethod1() {
        Integer len         = 10; //fake id
        Blob blobKey        = crypto.generateAesKey(128);
        String key          = EncodingUtil.convertToHex(blobKey);
        String reg          = key.substring(0,len);
        
        EBizcharge_Setting__c  ES = new EBizcharge_Setting__c();
        ES.Security_Token__c        = reg;
        ES.User_Name__c             = 'test-1';
        ES.Password__c              = '123';
        ES.Transaction_Filter_By__c  = 'Today ';
        ES.Email_Pending_Req_Filter_By__c  = 'Today ';
        ES.Sync_Orders_Filter_By__c  = 'Today';
        ES.Sync_Accounts_Filter_By__c  = 'Today';
        ES.Sync_Products_Filter_By__c  = 'Today';
        ES.Tax_Action__c  = 'Today';
        ES.Tax_Calculate_By__c  = 'Auto';
        ES.Tax_Manual_Type__c =  'Use Percent';
        ES.Tax_Default_Percent__c =  1;
        ES.Component_Label__c =  'test';
        ES.Tax_Action__c  = 'Tax Included';
        system.assertEquals('test-1', ES.User_Name__c);
        insert ES;
        delete ES;
    }
}