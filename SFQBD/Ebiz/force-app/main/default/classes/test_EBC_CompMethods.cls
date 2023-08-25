@isTest
public class test_EBC_CompMethods {
    @isTest(OnInstall = true)
    static void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account ac = StaticMockData.getAccount()[0];
        if (string.isNotEmpty(ac.id) && string.isNotEmpty(ac.id)) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            EBC_CompMethods.invoke_SearchCustomer(dml, '232342423sdfsd', ebcLogger);
            EBC_CompMethods.invoke_SearchOrder(dml, '232342423sdfsd', '232223', ebcLogger);
            transactionParams ts = new transactionParams();
            ts.methodID = '1';
            ts.accountID = ac.id;
            Map < String, Object > mapProcessPayment = new Map < String, Object > ();
            mapProcessPayment.put('paymentType', 'Deposit');
            mapProcessPayment.put('saveCard', true);
            mapProcessPayment.put('saveACH', true);
            mapProcessPayment.put('saveACH', true);
            mapProcessPayment.put('SendReceiptTo', true);
            mapProcessPayment.put('addEmails', 'test@test.com');
            EBC_CompMethods.getAccountDetail(dml, ac.id, ebcLogger);
        }
    }
    @isTest(OnInstall = true)
    private static void Method2() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        Account ac = StaticMockData.getAccount()[0];
        order od = StaticMockData.getOrder()[0];
        if (string.isNotEmpty(od.id)) {
            try {
                EBC_CompMethods.invoke_addSaleOrder(dml, od, ebcLogger);
            } catch (Exception e) {
                system.debug('>>>>' + e.getMessage());
            }
        }
    }
    @isTest(OnInstall = true)
    private static void Method3() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        Account ac = StaticMockData.getAccount()[0];
        Contact con = StaticMockData.getContact()[0];
        Ebiz_C__EBizCharge_Fields_Config__c mockCustomer = StaticMockData.getEBizCharge_Fields_Config()[0];
        if (string.isNotEmpty(ac.id)) {
            EBC_CompMethods.invoke_addCustomer(dml, ac, ebcLogger);
            EBC_CompMethods.invoke_addCustomerContact(dml, con, ebcLogger);
            EBC_CompMethods.invoke_addCustomCustomer(dml, mockCustomer, ebcLogger);
        }
    }
    @isTest(OnInstall = true)
    static void testMethod5() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        Ebiz_C__EBizCharge_Fields_Config__c CustFields = StaticMockData.getEBizCharge_Fields_Config()[0];
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        transactionParams ts = new transactionParams();
        ts.methodID = '1';
        ts.accountID = CustFields.id;
        Map < String, Object > mapProcessPayment = new Map < String, Object > ();
        mapProcessPayment.put('paymentType', 'Deposit');
        mapProcessPayment.put('saveCard', true);
        mapProcessPayment.put('saveACH', true);
        mapProcessPayment.put('saveACH', true);
        mapProcessPayment.put('SendReceiptTo', true);
        mapProcessPayment.put('addEmails', 'test@test.com');
        ts.methodID = '2';
        test.startTest();
        EBC_CompMethods.runTransactionOnlyCustomCustomer(dml, ts, CustFields, mapProcessPayment, ebcLogger);
        test.stopTest();
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
        Contact con = StaticMockData.getContact()[0];
        order od = StaticMockData.getOrder()[0];
        if (string.isNotEmpty(ac.id) && string.isNotEmpty(ac.id)) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            transactionParams ts = new transactionParams();
            ts.methodID = '1';
            ts.accountID = ac.id;
            Map < String, Object > mapProcessPayment = new Map < String, Object > ();
            mapProcessPayment.put('paymentType', 'Deposit');
            mapProcessPayment.put('saveCard', true);
            mapProcessPayment.put('saveACH', true);
            mapProcessPayment.put('saveACH', true);
            mapProcessPayment.put('SendReceiptTo', true);
            mapProcessPayment.put('addEmails', 'test@test.com');
            Test.startTest();
            EBC_CompMethods.addPaymentMethod(dml, ts, 'ACH', ebcLogger);
            ts.methodID = '2';
            EBC_CompMethods.runTransactionOnly(dml, ts, ac, mapProcessPayment, ebcLogger);
            EBC_CompMethods.runTransactionOnlyContact(dml, ts, con, mapProcessPayment, ebcLogger);
            EBC_CompMethods.GetCustomerPaymentMethods(dml, ac.Id, 'internalID', ebcLogger);
            EBC_CompMethods.GetCustomerSavedPaymentMethods(dml, ac.Id, 'internalID', ebcLogger);
            EBC_CompMethods.runTransactionPayment(dml, ts, true, 'test@test.com', 'Command', ebcLogger);
            EBC_CompMethods.runTransactionOnly(dml, ts, ac, mapProcessPayment, ebcLogger);
            string addNewACHJSON = '{ "saveCard": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp"}';
            Map < String, Object > mpstrMap = (Map < String, Object > ) JSON.deserializeUntyped(addNewACHJSON);
            EBC_CompMethods.runAVSCheck(dml, mpstrMap, ebcLogger);
            ts.Amount = 5;
            ts.Tax = 2;
            EBC_CompMethods.runRecurringPayment(dml, ts, true, '', ebcLogger);
            EBC_CompMethods.CreateApplicationTransaction(dml, 'AccExternalId', 'RefNum', 'OrdNo', Od.Id, 'OrdExtId', 'Command', '', '', '', '', ebcLogger);
            EBC_CompMethods.getCheckData(ts, ebcLogger);
            EBizCharge_Transaction__c et = new EBizCharge_Transaction__c();
            try {
                EBC_CompMethods.saveTransaction(dml, 'RefNumber', et, ebcLogger);
            } catch (exception ex) {}
            Quote q = StaticMockData.getQuote()[0];
            Opportunity op = StaticMockData.getOpportunity()[0];
            EBC_CompMethods.invoke_addQuote(dml, q, ebcLogger);
            EBC_CompMethods.invoke_addOpportunity(dml, op, ebcLogger);
            EBC_CompMethods.getTransactionDetailGW('00000000', 'RefNumber');
            string ACHJSON = '{ "ContactId": "12121",  "conExternalId" :"34534" , "paymentType" : "test" , "Amount" : 2020 , "Tax" : 0.05, "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp"}';
            EBC_CompMethods.runAVSCheckContact(dml, (Map < String, Object > ) JSON.deserializeUntyped(ACHJSON), ebcLogger);
            EBC_CompMethods.getContactDetail(dml, '435234test', ebcLogger);
            EBC_CompMethods.getCustomFieldDetail(dml, '435234test', ebcLogger);
            EBC_CompMethods.invoke_addCustomerContact(dml, con, ebcLogger);
            Ebiz_C__EBizCharge_Fields_Config__c CustFields = StaticMockData.getEBizCharge_Fields_Config()[0];
            EBC_CompMethods.invoke_addCustomCustomer(dml, CustFields, ebcLogger);
            Test.stopTest();
        }
    }
}