@isTest
public class test_eBc_AccountController {
    @isTest(OnInstall = true)
    static void test_processPaymentWithXCApxc() {
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account ac = StaticMockData.getAccount()[0];
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        string addNewACHJSON = '{"saveACH":true, "saveCard": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp"  }';
        try {
            eBc_AccountController.processPaymentWithXCApxc(addNewACHJSON);
        } catch (Exception err) {}
    }
    @isTest(OnInstall = true)
    static void test_getEmailTemplatesApxc() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account ac = StaticMockData.getAccount()[0];
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        try {
            eBc_AccountController.getEmailTemplatesApxc();
        } catch (Exception err) {}
    }
    @isTest(OnInstall = true)
    static void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account ac = StaticMockData.getAccount()[0];
        eBc_AccountController.AccountWrapper AccountWrapper = new eBc_AccountController.AccountWrapper();
        List < eBc_AccountController.AccountWrapper > AccountWrapperBulk = new List < eBc_AccountController.AccountWrapper > ();
        AccountWrapper.isSelected = true;
        AccountWrapper.accId = ac.id;
        AccountWrapper.accName = ac.Name;
        AccountWrapper.accAmount = 200;
        AccountWrapper.accFirstName = 'test 1';
        AccountWrapper.accLastName = 'test2';
        AccountWrapper.accEmail = 'test@test.com';
        AccountWrapper.accPhone = '234242423423';
        AccountWrapper.accExtId = ac.id;
        AccountWrapper.accStatus = 'Active';
        AccountWrapperBulk.add(AccountWrapper);
        if (string.isNotEmpty(ac.id) && string.isNotEmpty(ac.id)) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            eBc_AccountController.getSettingsApxc();
            transactionParams ts = new transactionParams();
            ts.methodID = '1';
            ts.accountID = ac.id;
            eBc_AccountController.getAllAccountsApxc();
            System.debug('ac.EBizCharge_Internal_ID__c:' + ac.EBizCharge_Internal_ID__c);
            ac.EBizCharge_Internal_ID__c = '123';
            eBc_AccountController.getAllAccountsApxc();
            ac.EBizCharge_Internal_ID__c = null;
            eBc_AccountController.syncAccountsApxc(AccountWrapperBulk);
            Test.startTest();
            eBc_AccountController.getAccountDetailApxc(ac.Id);
            eBc_AccountController.autoSyncAccountApxc(ac.Id);
            Test.stopTest();
        }
    }
    @isTest(OnInstall = true)
    static void testMethod2() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account ac = StaticMockData.getAccount()[0];
        eBc_AccountController.AccountWrapper AccountWrapper = new eBc_AccountController.AccountWrapper();
        List < eBc_AccountController.AccountWrapper > AccountWrapperBulk = new List < eBc_AccountController.AccountWrapper > ();
        AccountWrapper.isSelected = true;
        AccountWrapper.accId = ac.id;
        AccountWrapper.accName = ac.Name;
        AccountWrapper.accAmount = 200;
        AccountWrapper.accFirstName = 'test 1';
        AccountWrapper.accLastName = 'test2';
        AccountWrapper.accEmail = 'test@test.com';
        AccountWrapper.accPhone = '234242423423';
        AccountWrapper.accExtId = ac.id;
        AccountWrapper.accStatus = 'Active';
        AccountWrapperBulk.add(AccountWrapper);
        if (string.isNotEmpty(ac.id) && string.isNotEmpty(ac.id)) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            Test.startTest();
            string addNewACHJSON = '{"saveACH":true, "saveCard": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp"  }';
            Map < String, Object > newACHmap = (Map < String, Object > ) JSON.deserializeUntyped(addNewACHJSON);
            eBc_AccountController.AddPaymentMethod(dml, newACHmap, 'CreditCard', ebcLogger);
            eBc_AccountController.AddPaymentMethod(dml, newACHmap, 'saveACH', ebcLogger);
            string processStrMap = '{"saveACH":true, "saveCard":true, "AccountId" : "' + ac.Id + '", "Amount": 5, "Tax":3, "selectedCardId" : "44", "ExcludeTax" : true, "SendReceiptTo": true, "addEmails" : "test@test.com" }';
            Map < String, Object > mpProcess = (Map < String, Object > ) JSON.deserializeUntyped(processStrMap);
            eBc_AccountController.getSavedMethodsApxc(ac.Id, 'accExternalId');
            eBc_AccountController.processPayment(dml, mpProcess, 'ExistingACH', ebcLogger);
            eBc_AccountController.processPayment(dml, mpProcess, 'NewACH', ebcLogger);
            eBc_AccountController.processPayment(dml, mpProcess, 'ExistingCard', ebcLogger);
            string sendReqJSON = '{ "saveCard": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp" }';
            eBc_AccountController.addPaymentMehtodReqApxc(sendReqJSON, ac.Id, 'test1');
            string processStrMap2 = '{ "isAVSCheck" : true, "selectedCardId" : "44", "ExcludeTax" : true, "SendReceiptTo": true, "addEmails" : "test@test.com" }';
            eBc_AccountController.invokeTransactionVoidApxc('avsRefNum');
            eBc_AccountController.updateAccountInternalIds(dml, ebcLogger);
            eBc_AccountController.emailWrapperclass ec = new eBc_AccountController.emailWrapperclass();
            ec.TemplateName = 'Name';
            ec.TemplateType = 'Type';
            ec.TemplateInternalId = 'Id';
            ec.TemplateSubject = 'Subject';
            ec.FromEmail = 'Email';
            ec.ReplyToEmail = 'Email';
            Test.stopTest();
        }
    }
    @isTest(OnInstall = true)
    static void testMethod4() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account ac = StaticMockData.getAccount()[0];
        eBc_AccountController.AccountWrapper AccountWrapper = new eBc_AccountController.AccountWrapper();
        List < eBc_AccountController.AccountWrapper > AccountWrapperBulk = new List < eBc_AccountController.AccountWrapper > ();
        AccountWrapper.isSelected = true;
        AccountWrapper.accId = ac.id;
        AccountWrapper.accName = ac.Name;
        AccountWrapper.accAmount = 200;
        AccountWrapper.accFirstName = 'test 1';
        AccountWrapper.accLastName = 'test2';
        AccountWrapper.accEmail = 'test@test.com';
        AccountWrapper.accPhone = '234242423423';
        AccountWrapper.accExtId = ac.id;
        AccountWrapper.accBillingState = 'test2';
        AccountWrapper.accStatus = 'Active';
        AccountWrapperBulk.add(AccountWrapper);
        eBc_AccountController.accDetail AccountDetail = new eBc_AccountController.accDetail();
        AccountDetail.Settings = null;
        AccountDetail.UseFullAmountForAVS = true;
        if (string.isNotEmpty(ac.id) && string.isNotEmpty(ac.id)) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            Test.startTest();
            string processStrMap = '{"saveACH":true, "saveCard":true, "AccountId" : "' + ac.Id + '", "Amount": 5, "Tax":3, "selectedCardId" : "44", "ExcludeTax" : true, "SendReceiptTo": true, "addEmails" : "test@test.com" }';
            Map < String, Object > mpProcess = (Map < String, Object > ) JSON.deserializeUntyped(processStrMap);
            eBc_AccountController.processPayment(dml, mpProcess, 'NewCard', ebcLogger); //processPayment(Map<String, Object> strMap,String processBy )        
            string processStrMap2 = '{ "isAVSCheck" : true, "selectedCardId" : "44", "ExcludeTax" : true, "SendReceiptTo": true, "addEmails" : "test@test.com" }';
            try {
                eBc_AccountController.processPaymentWithNCApxc(processStrMap2);
            } catch (exception ex) {
                system.debug('test');
            }
            try {
                eBc_AccountController.procesPaymentWithSavedACHApxc(processStrMap);
            } catch (exception ex) {
                system.debug('test');
            }
            try {
                eBc_AccountController.processPaymentNewACHApxc(processStrMap);
            } catch (exception ex) {
                system.debug('test');
            }
            Test.stopTest();
        }
    }
    @isTest(OnInstall = true)
    static void testMethod3() {
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account ac = StaticMockData.getAccount()[0];
        eBc_AccountController.AccountWrapper AccountWrapper = new eBc_AccountController.AccountWrapper();
        List < eBc_AccountController.AccountWrapper > AccountWrapperBulk = new List < eBc_AccountController.AccountWrapper > ();
        AccountWrapper.isSelected = true;
        AccountWrapper.accId = ac.id;
        AccountWrapper.accName = ac.Name;
        AccountWrapper.accAmount = 200;
        AccountWrapper.accFirstName = 'test 1';
        AccountWrapper.accLastName = 'test2';
        AccountWrapper.accEmail = 'test@test.com';
        AccountWrapper.accPhone = '234242423423';
        AccountWrapper.accExtId = ac.id;
        AccountWrapper.accStatus = 'Active';
        AccountWrapperBulk.add(AccountWrapper);
        if (string.isNotEmpty(ac.id) && string.isNotEmpty(ac.id)) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            transactionParams ts = new transactionParams();
            ts.methodID = '1';
            ts.accountID = ac.id;
            eBc_AccountController.getAllAccountsApxc();
        }
    }
    @isTest(OnInstall = true)
    static void accountMockTest() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        EBC_Logger ebcLogger = new EBC_Logger();
        Account ac = StaticMockData.getAccount()[0];
        system.debug('Before Account functions');
        List < eBc_AccountController.AccountWrapper > accList = eBc_AccountController.getAllAccountsApxc();
        eBc_AccountController.autoSyncAccountApxc(ac.Id);
        try {
            eBc_AccountController.getPARecTypeId();
            eBc_AccountController.isPersonAccount();
        } catch (Exception e) {}
        system.debug('After Account functions');
    }
}