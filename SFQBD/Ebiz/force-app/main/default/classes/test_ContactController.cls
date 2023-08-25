@isTest
public class test_ContactController {
    @isTest(OnInstall = true)
    static void test_getSettingsApxc() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        try {
            EBizcharge_Setting__c ES = eBc_ContactController.getSettingsApxc();
        } catch (Exception err) {}
    }
    @isTest(OnInstall = true)
    static void test_getSavedMethodsApxc() {
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account ac = StaticMockData.getAccount()[0];
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        try {
            eBc_ContactController.getSavedMethodsApxc(ac.Id, 'internalID');
        } catch (Exception err) {}
    }
    @isTest(OnInstall = true)
    static void testMethod1() {
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Contact ac = StaticMockData.getContact()[0];
        eBc_ContactController.ContactDetail ContactWrapper = new eBc_ContactController.ContactDetail();
        ContactWrapper.Settings = null;
        ContactWrapper.UseFullAmountForAVS = true;
        eBc_ContactController.ContactWrapper AccountWrapper = new eBc_ContactController.ContactWrapper();
        List < eBc_ContactController.ContactWrapper > AccountWrapperBulk = new List < eBc_ContactController.ContactWrapper > ();
        AccountWrapper.isSelected = true;
        AccountWrapper.conId = ac.id;
        AccountWrapper.conName = ac.Name;
        AccountWrapper.conAmount = 200;
        AccountWrapper.conFirstName = 'test 1';
        AccountWrapper.conLastName = 'test2';
        AccountWrapper.conEmail = 'test@test.com';
        AccountWrapper.conPhone = '234242423423';
        AccountWrapper.conExtId = ac.id;
        AccountWrapper.conStatus = 'Active';
        AccountWrapperBulk.add(AccountWrapper);
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        eBc_AccountController.getSettingsApxc();
        transactionParams ts = new transactionParams();
        ts.methodID = '1';
        ts.accountID = ac.id;
        eBc_ContactController.getAllContactsApxc();
        eBc_ContactController.syncContactApxc(AccountWrapperBulk);
        Test.startTest();
        eBc_ContactController.getContactDetailApxc(ac.Id);
        eBc_ContactController.autoSyncContactApxc(ac.Id);
        Test.stopTest();
    }
    @isTest(OnInstall = true)
    static void testMethod2() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Contact ac = StaticMockData.getContact()[0];
        eBc_ContactController.ContactWrapper AccountWrapper = new eBc_ContactController.ContactWrapper();
        List < eBc_ContactController.ContactWrapper > AccountWrapperBulk = new List < eBc_ContactController.ContactWrapper > ();
        AccountWrapper.isSelected = true;
        AccountWrapper.conId = ac.id;
        AccountWrapper.conName = ac.Name;
        AccountWrapper.conAmount = 200;
        AccountWrapper.conFirstName = 'test 1';
        AccountWrapper.conLastName = 'test2';
        AccountWrapper.conEmail = 'test@test.com';
        AccountWrapper.conPhone = '234242423423';
        AccountWrapper.conExtId = ac.id;
        AccountWrapper.conStatus = 'Active';
        AccountWrapperBulk.add(AccountWrapper);
        if (string.isNotEmpty(ac.id) && string.isNotEmpty(ac.id)) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            Test.startTest();
            string addNewACHJSON = '{"saveACH":true, "saveCard": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp"  }';
            Map < String, Object > newACHmap = (Map < String, Object > ) JSON.deserializeUntyped(addNewACHJSON);
            eBc_ContactController.AddPaymentMethodContact(dml, newACHmap, 'CreditCard', ebcLogger);
            eBc_ContactController.AddPaymentMethodContact(dml, newACHmap, 'saveACH', ebcLogger);
            eBc_ContactController.AddPaymentMethod(dml, newACHmap, 'saveACH', ebcLogger);
            eBc_ContactController.AddPaymentMethod(dml, newACHmap, 'CreditCard', ebcLogger);
            string processStrMap = '{ "ConId" : "' + ac.Id + '", "Amount": 5, "Tax":3, "selectedCardId" : "44", "ExcludeTax" : true, "SendReceiptTo": true, "addEmails" : "test@test.com" }';
            Map < String, Object > mpProcess = (Map < String, Object > ) JSON.deserializeUntyped(processStrMap);
            eBc_AccountController.getSavedMethodsApxc(ac.Id, 'accExternalId');
            eBc_ContactController.AddPaymentMethodContact(dml, mpProcess, 'ExistingACH', ebcLogger);
            eBc_ContactController.AddPaymentMethodContact(dml, mpProcess, 'NewACH', ebcLogger);
            string sendReqJSON = '{ "saveCard": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp" }';
            eBc_ContactController.addPaymentMehtodReqApxc(sendReqJSON, ac.Id, 'test1');
            string processStrMap2 = '{ "isAVSCheck" : true, "selectedCardId" : "44", "ExcludeTax" : true, "SendReceiptTo": true, "addEmails" : "test@test.com" }';
            eBc_ContactController.invokeTransactionVoidApxc('avsRefNum');
            eBc_ContactController.emailWrapperclass ec = new eBc_ContactController.emailWrapperclass();
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
        Contact ac = StaticMockData.getContact()[0];
        eBc_ContactController.ContactWrapper AccountWrapper = new eBc_ContactController.ContactWrapper();
        List < eBc_ContactController.ContactWrapper > AccountWrapperBulk = new List < eBc_ContactController.ContactWrapper > ();
        AccountWrapper.isSelected = true;
        AccountWrapper.conId = ac.id;
        AccountWrapper.conName = ac.Name;
        AccountWrapper.conAmount = 200;
        AccountWrapper.conFirstName = 'test 1';
        AccountWrapper.conLastName = 'test2';
        AccountWrapper.conEmail = 'test@test.com';
        AccountWrapper.conPhone = '234242423423';
        AccountWrapper.conExtId = ac.id;
        AccountWrapper.conStatus = 'Active';
        AccountWrapperBulk.add(AccountWrapper);
        if (string.isNotEmpty(ac.id) && string.isNotEmpty(ac.id)) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            Test.startTest();
            string processStrMap = '{"saveACH": true, "ConId" : "' + ac.Id + '", "Amount": 5, "Tax":3, "selectedCardId" : "44", "ExcludeTax" : true, "SendReceiptTo": true, "addEmails" : "test@test.com" }';
            Map < String, Object > mpProcess = (Map < String, Object > ) JSON.deserializeUntyped(processStrMap);
            string processStrMap2 = '{"saveCard": true, "saveACH": true, "isAVSCheck" : true, "selectedCardId" : "44", "ExcludeTax" : true, "SendReceiptTo": true, "addEmails" : "test@test.com" }';
            try {
                eBc_ContactController.processPaymentWithNCApxc(processStrMap2);
            } catch (exception ex) {
                system.debug('test');
            }
            try {
                eBc_ContactController.processPaymentWithNCApxc(processStrMap2);
            } catch (exception ex) {
                system.debug('test');
            }
            try {
                eBc_ContactController.procesPaymentWithSavedACHApxc(processStrMap);
            } catch (exception ex) {
                system.debug('test');
            }
            try {
                eBc_ContactController.processPaymentWithXCApxc(processStrMap);
            } catch (exception ex) {
                system.debug('test');
            }
            try {
                eBc_ContactController.processPaymentNewACHApxc(processStrMap);
            } catch (exception ex) {
                system.debug('test');
            }
            try {
                eBc_ContactController.getEmailTemplatesApxc();
            } catch (exception ex) {
                system.debug('test');
            }
            try {
                eBc_ContactController.processPaymentContact(dml, mpProcess, 'NewCard', ebcLogger);
            } catch (exception ex) {
                system.debug('test');
            } //processPayment(Map<String, Object> strMap,String processBy )
            Test.stopTest();
        }
    }
    @isTest(OnInstall = true)
    static void testMethod3() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Contact ac = StaticMockData.getContact()[0];
        eBc_ContactController.ContactWrapper AccountWrapper = new eBc_ContactController.ContactWrapper();
        List < eBc_ContactController.ContactWrapper > AccountWrapperBulk = new List < eBc_ContactController.ContactWrapper > ();
        AccountWrapper.isSelected = true;
        AccountWrapper.conId = ac.id;
        AccountWrapper.conName = ac.Name;
        AccountWrapper.conAmount = 200;
        AccountWrapper.conFirstName = 'test 1';
        AccountWrapper.conLastName = 'test2';
        AccountWrapper.conEmail = 'test@test.com';
        AccountWrapper.conPhone = '234242423423';
        AccountWrapper.conExtId = ac.id;
        AccountWrapper.conStatus = 'Active';
        AccountWrapperBulk.add(AccountWrapper);
        if (string.isNotEmpty(ac.id) && string.isNotEmpty(ac.id)) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            transactionParams ts = new transactionParams();
            ts.methodID = '1';
            ts.accountID = ac.id;
            eBc_ContactController.getAllContactsApxc();
            eBc_ContactController.updateContactInternalIds(dml, ebcLogger);
        }
    }
    @isTest(OnInstall = true)
    public static void testMock() { //----hide for mocking  
        DML dml = (DML) MockUtil.createMock(DML.class);
        List < account > a = (List < account > ) dml.selectRecords('select id,name', 'from account', '', '', '', '');
        system.debug(a);
    }
}