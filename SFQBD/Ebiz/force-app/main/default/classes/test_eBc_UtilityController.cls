@isTest
public class test_eBc_UtilityController {
    @isTest(OnInstall = true)
    static void testMethod_LOPM() {
        EBC_Logger ebcLogger = new EBC_Logger();
        DML dml = (DML) MockUtil.createMock(DML.class);
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account ac = StaticMockData.getAccount()[0];
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        eBc_UtilityController.GetCustomerSavedPaymentMethods(dml, null, 'internalID', ebcLogger);
        Test.stopTest();
    }
    @isTest(OnInstall = true)
    static void testMethod_getAllTransactions() {
        EBC_Logger ebcLogger = new EBC_Logger();
        DML dml = (DML) MockUtil.createMock(DML.class);
        eBc_UtilityController.getAllTransactions(dml, ebcLogger);
    }
    @isTest(OnInstall = true)
    static void testMethod_getCustomFieldDetails() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        Contact cont = StaticMockData.getContact()[0];
        List < Id > lst = new List < Id > ();
        lst.add(cont.Id);
        eBc_UtilityController.getCustomFieldDetails(dml, lst, ebcLogger);
    }
    @isTest(OnInstall = true)
    static void testMethod_getAccountsDetail() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        Account acc = StaticMockData.getAccount()[0];
        List < Id > lst = new List < Id > ();
        lst.add(acc.Id);
        eBc_UtilityController.getAccountsDetail(dml, lst, ebcLogger);
    }
    @isTest(OnInstall = true)
    static void testMethod_getOrdersDetail() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        order od = StaticMockData.getOrder()[0];
        List < Id > lst = new List < Id > ();
        lst.add(od.Id);
        try {
            eBc_UtilityController.getOrdersDetail(dml, lst, ebcLogger);
        } catch (exception err) {}
    }
    @isTest(OnInstall = true)
    static void testMethod_getContactsDetail() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        Contact cont = StaticMockData.getContact()[0];
        List < Id > lst = new List < Id > ();
        lst.add(cont.Id);
        try {
            eBc_UtilityController.getContactsDetail(dml, lst, ebcLogger);
        } catch (exception err) {}
    }
    @isTest(OnInstall = true)
    static void testMethod_getContactDetail() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        Contact cont = StaticMockData.getContact()[0];
        try {
            eBc_UtilityController.getContactDetail(dml, cont.Id, ebcLogger);
        } catch (exception err) {}
    }
    @isTest(OnInstall = true)
    static void testMethod_getCustomFieldDetail() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        Contact cont = StaticMockData.getContact()[0];
        try {
            eBc_UtilityController.getCustomFieldDetail(dml, cont.Id, ebcLogger);
        } catch (exception err) {}
    }
    @isTest(OnInstall = true)
    static void test_MarkEbizPaymentAsApplied() {
        EBC_Logger ebcLogger = new EBC_Logger();
        DML dml = (DML) MockUtil.createMock(DML.class);
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        try {
            eBc_UtilityController.MarkEbizPaymentAsApplied(dml, '', '', ebcLogger);
        } catch (Exception err) {}
    }
    @isTest(OnInstall = true)
    static void test_UpdateCustomObjectsFields() {
        EBC_Logger ebcLogger = new EBC_Logger();
        DML dml = (DML) MockUtil.createMock(DML.class);
        Account ac = StaticMockData.getAccount()[0];
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        try {
            eBc_UtilityController.UpdateCustomObjectsFields(dml, 'Account', ac.Id, ebcLogger);
        } catch (Exception err) {}
    }
    @isTest(OnInstall = true)
    static void test_runTransactionOnly() {
        EBC_Logger ebcLogger = new EBC_Logger();
        DML dml = (DML) MockUtil.createMock(DML.class);
        Account ac = StaticMockData.getAccount()[0];
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        transactionParams ts = new transactionParams();
        ts.methodID = '2';
        ts.accountID = ac.id;
        ts.Amount = 5;
        ts.Tax = 2;
        string strProcessPayment = '{ "saveACH": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp"}';
        Map < String, Object > mapProcessPayment = (Map < String, Object > ) JSON.deserializeUntyped(strProcessPayment);
        String command = '';
        Test.startTest();
        try {
            eBc_UtilityController.runTransactionOnly(dml, ts, ac, mapProcessPayment, command, ebcLogger);
        } catch (Exception err) {}
        Test.stopTest();
    }
    @isTest(OnInstall = true)
    static void test_runTransactionOnlyContact() {
        EBC_Logger ebcLogger = new EBC_Logger();
        DML dml = (DML) MockUtil.createMock(DML.class);
        Contact cont = StaticMockData.getContact()[0];
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        transactionParams ts = new transactionParams();
        ts.methodID = '2';
        ts.accountID = cont.id;
        ts.Amount = 5;
        ts.Tax = 2;
        string strProcessPayment = '{ "saveACH": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp"}';
        Map < String, Object > mapProcessPayment = (Map < String, Object > ) JSON.deserializeUntyped(strProcessPayment);
        String command = '';
        Test.startTest();
        try {
            eBc_UtilityController.runTransactionOnlyContact(dml, ts, cont, mapProcessPayment, ebcLogger);
        } catch (Exception err) {}
        Test.stopTest();
    }
    @isTest(OnInstall = true)
    static void test_runTransactionOnlyAccountTab() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        Account ac = StaticMockData.getAccount()[0];
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        transactionParams ts = new transactionParams();
        ts.methodID = '2';
        ts.accountID = ac.id;
        ts.Amount = 5;
        ts.Tax = 2;
        string strProcessPayment = '{ "saveACH": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp"}';
        Map < String, Object > mapProcessPayment = (Map < String, Object > ) JSON.deserializeUntyped(strProcessPayment);
        String command = '';
        Test.startTest();
        try {
            eBc_UtilityController.runTransactionOnlyAccountTab(dml, ts, ac, mapProcessPayment, command, ebcLogger);
        } catch (Exception err) {}
        Test.stopTest();
    }
    @isTest(OnInstall = true)
    static void test_runTransactionOnlyContactTab() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        Contact cont = StaticMockData.getContact()[0];
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        transactionParams ts = new transactionParams();
        ts.methodID = '2';
        ts.accountID = cont.id;
        ts.Amount = 5;
        ts.Tax = 2;
        string strProcessPayment = '{ "saveACH": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp"}';
        Map < String, Object > mapProcessPayment = (Map < String, Object > ) JSON.deserializeUntyped(strProcessPayment);
        String command = '';
        Test.startTest();
        try {
            eBc_UtilityController.runTransactionOnlyContactTab(dml, ts, cont, mapProcessPayment, command, ebcLogger);
        } catch (Exception err) {}
        Test.stopTest();
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
        Contact con = StaticMockData.getContact()[0];
        Order od = StaticMockData.getOrder()[0];
        Product2 p2 = StaticMockData.getProduct2()[0];
        if (string.isNotEmpty(od.id) && string.isNotEmpty(ac.id)) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            transactionParams ts = new transactionParams();
            ts.methodID = '1';
            ts.accountID = ac.id;
            ts.Amount = 5;
            ts.Tax = 2;
            Map < String, String > mapUpdCustomer = new Map < String, String > ();
            mapUpdCustomer.put(ac.Id, ac.Id);
            Map < String, String > mapUpdCustomerContact = new Map < String, String > ();
            mapUpdCustomerContact.put(con.Id, con.Id);
            Map < String, String > mapUpdOrders = new Map < String, String > ();
            mapUpdOrders.put(od.Id, od.Id);
            Map < String, String > mapUpdProducts = new Map < String, String > ();
            mapUpdProducts.put(p2.Id, p2.Id);
            string strProcessPayment = '{ "saveCard": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp"}';
            Map < String, Object > mapProcessPayment = (Map < String, Object > ) JSON.deserializeUntyped(strProcessPayment);
            eBc_UtilityController.invoke_SearchCustomer(dml, '123345678', ebcLogger);
            eBc_UtilityController.invoke_addORUpdCustomer(dml, ac, Token, 'action', ebcLogger);
            eBc_UtilityController.invoke_addORUpdCustomerContact(dml, con, Token, 'action', ebcLogger);
            eBc_UtilityController.invoke_addORUpdCustomerContact(dml, con, Token, 'addCustomer', ebcLogger);
            eBc_UtilityController.updCustomerInSF(dml, mapUpdCustomer, ebcLogger);
            eBc_UtilityController.updCustomerInSFContact(dml, mapUpdCustomerContact, ebcLogger);
            eBc_UtilityController.invoke_SearchOrder(dml, ac.Id, 'SalesOrderNo', ebcLogger);
            eBc_UtilityController.invoke_AddORUpdateOrder(dml, od, mapUpdCustomer, Token, 'action', ebcLogger);
            eBc_UtilityController.invoke_AddORUpdateOrder(dml, od, mapUpdCustomer, Token, 'addOrder', ebcLogger);
            eBc_UtilityController.updOrdersInSF(dml, mapUpdOrders, ebcLogger);
            eBc_UtilityController.invoke_addORUpdProduct(dml, p2, Token, 'action', ebcLogger);
            eBc_UtilityController.invoke_addORUpdProduct(dml, p2, Token, 'updProduct', ebcLogger);
            eBc_UtilityController.updProductsInSF(dml, mapUpdProducts, ebcLogger);
            eBc_UtilityController.getCheckData(ts, ebcLogger);
            Test.startTest();
            eBc_UtilityController.GetCustomerSavedPaymentMethods(dml, ac.Id, 'internalID', ebcLogger);
            eBc_UtilityController.updateAccountId(dml, ac.Id, 'internalID', ebcLogger);
            ebizchargeServicemodelSoap.TransactionResponse ebiz_transaction_response = eBc_UtilityController.runTransactionPayment(dml, ts, true, 'test@test.com', 'Command', ebcLogger);
            ebiz_transaction_response.ConvertedAmountCurrency = '5';
            ebiz_transaction_response.isDuplicate = false;
            String command = '';
            eBc_UtilityController.runTransactionOnly(dml, ts, ac, mapProcessPayment, command, ebcLogger);
            eBc_UtilityController.runRecurringPayment(dml, ts, true, 'recIntenalId', 'action', '', ebcLogger);
            eBc_UtilityController.updateRRScheduledPaymentStatus(dml, 'recIntenalId', 1, ebcLogger);
            eBc_UtilityController.saveStatusTransactionResponse(dml, ebiz_transaction_response, od.Id, 'paymentMethodID', 1, ebcLogger);
            try {
                eBc_UtilityController.runRecurringPayment(dml, ts, true, 'recIntenalId', 'Update','', ebcLogger);
            } catch (Exception err) {}
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
        Contact con = StaticMockData.getContact()[0];
        Order od = StaticMockData.getOrder()[0];
        Product2 p2 = StaticMockData.getProduct2()[0];
        if (string.isNotEmpty(od.id) && string.isNotEmpty(ac.id)) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            transactionParams ts = new transactionParams();
            ts.methodID = '1';
            ts.accountID = ac.id;
            ts.Amount = 5;
            ts.Tax = 2;
            Map < String, String > mapUpdCustomer = new Map < String, String > ();
            mapUpdCustomer.put(ac.Id, ac.Id);
            Map < String, String > mapUpdCustomerContact = new Map < String, String > ();
            mapUpdCustomerContact.put(con.Id, con.Id);
            Map < String, String > mapUpdOrders = new Map < String, String > ();
            mapUpdOrders.put(od.Id, od.Id);
            Map < String, String > mapUpdProducts = new Map < String, String > ();
            mapUpdProducts.put(p2.Id, p2.Id);
            string strProcessPayment = '{ "saveCard": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp"}';
            Map < String, Object > mapProcessPayment = (Map < String, Object > ) JSON.deserializeUntyped(strProcessPayment);
            eBc_UtilityController.invoke_SearchCustomer(dml, '123345678', ebcLogger);
            eBc_UtilityController.invoke_addORUpdCustomer(dml, ac, Token, 'action', ebcLogger);
            eBc_UtilityController.invoke_addORUpdCustomerContact(dml, con, Token, 'action', ebcLogger);
            eBc_UtilityController.invoke_addORUpdCustomerContact(dml, con, Token, 'addCustomer', ebcLogger);
            eBc_UtilityController.updCustomerInSF(dml, mapUpdCustomer, ebcLogger);
            eBc_UtilityController.updCustomerInSFContact(dml, mapUpdCustomerContact, ebcLogger);
            eBc_UtilityController.invoke_SearchOrder(dml, ac.Id, 'SalesOrderNo', ebcLogger);
            eBc_UtilityController.invoke_AddORUpdateOrder(dml, od, mapUpdCustomer, Token, 'action', ebcLogger);
            eBc_UtilityController.invoke_AddORUpdateOrder(dml, od, mapUpdCustomer, Token, 'addOrder', ebcLogger);
            eBc_UtilityController.updOrdersInSF(dml, mapUpdOrders, ebcLogger);
            eBc_UtilityController.invoke_addORUpdProduct(dml, p2, Token, 'action', ebcLogger);
            eBc_UtilityController.invoke_addORUpdProduct(dml, p2, Token, 'updProduct', ebcLogger);
            eBc_UtilityController.updProductsInSF(dml, mapUpdProducts, ebcLogger);
            Test.startTest();
            eBc_UtilityController.GetCustomerSavedPaymentMethods(dml, ac.Id, 'internalID', ebcLogger);
            ebizchargeServicemodelSoap.TransactionResponse ebiz_transaction_response = eBc_UtilityController.runTransactionPaymentContact(dml, ts, true, 'test@test.com', 'Command', ebcLogger);
            ebiz_transaction_response.ConvertedAmountCurrency = '5';
            ebiz_transaction_response.isDuplicate = false;
            String command = '';
            eBc_UtilityController.runTransactionOnly(dml, ts, ac, mapProcessPayment, command, ebcLogger);
            eBc_UtilityController.runRecurringPayment(dml, ts, true, 'recIntenalId', 'action','', ebcLogger);
            eBc_UtilityController.updateRRScheduledPaymentStatus(dml, 'recIntenalId', 1, ebcLogger);
            eBc_UtilityController.saveStatusTransactionResponse(dml, ebiz_transaction_response, od.Id, 'paymentMethodID', 1, ebcLogger);
            try {
                eBc_UtilityController.runRecurringPayment(dml, ts, true, 'recIntenalId', 'Update','', ebcLogger);
            } catch (Exception err) {}
            Test.stopTest();
        }
    }
    @isTest(OnInstall = true)
    static void testMethod4() {
        EBC_Logger ebcLogger = new EBC_Logger();
        DML dml = (DML) MockUtil.createMock(DML.class);
        String customerId = '111111111';
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account ac = StaticMockData.getAccount()[0];
        Order od = StaticMockData.getOrder()[0];
        Product2 p2 = StaticMockData.getProduct2()[0];
        list < Id > ProdIds = new list < Id > ();
        ProdIds.add(p2.Id);
        if (string.isNotEmpty(od.id) && string.isNotEmpty(ac.id)) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            transactionParams ts = new transactionParams();
            ts.methodID = '1';
            ts.accountID = ac.id;
            ts.Amount = 5;
            ts.Tax = 2;
            Map < String, String > mapUpdCustomer = new Map < String, String > ();
            mapUpdCustomer.put(ac.Id, ac.Id);
            Map < String, String > mapUpdOrders = new Map < String, String > ();
            mapUpdOrders.put(od.Id, od.Id);
            Map < String, String > mapUpdProducts = new Map < String, String > ();
            mapUpdProducts.put(p2.Id, p2.Id);
            string strProcessPayment = '{ "saveCard": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp"}';
            Map < String, Object > mapProcessPayment = (Map < String, Object > ) JSON.deserializeUntyped(strProcessPayment);
            Test.startTest();
            eBc_UtilityController.sendReceiptToCustomer(dml, 'ReferenceNo', 'test@test.com', ebcLogger);
            eBc_UtilityController.sendEmailbyGW(dml, true, 'test@test.com', 'TransactionRefNo', ebcLogger);
            eBc_UtilityController.runAVSCheck(dml, mapProcessPayment, ebcLogger);
            eBc_UtilityController.runAVSCheckContact(dml, mapProcessPayment, ebcLogger);
            ebizchargeServicemodelSoap.ArrayOfSearchFilter filters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
            eBc_UtilityController.searchPendingPayments(dml, system.now().Date().addDays(-1), system.now().Date().addDays(1), ebcLogger);
            eBc_UtilityController.searchPendingPaymentsCustomer(dml, system.now().Date().addDays(-1), system.now().Date().addDays(1), customerId, filters, ebcLogger);
            eBc_UtilityController.RemoveEbizWebFormPayment(dml, 'paymentInternalID', ebcLogger);
            eBc_UtilityController.ResendEbizWebFormEmail(dml, 'paymentInternalID', ebcLogger);
            eBc_UtilityController.MarkEbizWebFormPaymentAsApplied(dml, 'paymentInternalID', ebcLogger);
            eBc_UtilityController.MarkRecurringPaymentAsApplied(dml, 'paymentInternalID', ebcLogger);
            try {
                eBc_UtilityController.markAccountPaid(dml, ac.id, 'RefNumber', 1, ebcLogger);
            } catch (Exception e) {
                system.debug('ignore');
            }
            try {
                ebizchargeServicemodelSoap.TransactionObject transactionObject = new ebizchargeServicemodelSoap.TransactionObject();
                eBc_UtilityController.markOrderPaid(dml, od.Id, 'RefNumber', 2, transactionObject, '', '', '', ebcLogger);
            } catch (Exception e) {
                system.debug('ignore');
            }
            Contact cont = StaticMockData.getContact()[0];
            try {
                eBc_UtilityController.markContactPaid(dml, cont.Id, 'RefNumber', 2, ebcLogger);
            } catch (Exception e) {
                system.debug('ignore');
            }
            try {
                eBc_UtilityController.markCustomCustomerPaid(dml, cont.Id, 'RefNumber', 2, ebcLogger);
            } catch (Exception e) {
                system.debug('ignore');
            }
            Test.stopTest();
        }
    }
    @isTest(OnInstall = true)
    static void testMethod3() {
        EBC_Logger ebcLogger = new EBC_Logger();
        DML dml = (DML) MockUtil.createMock(DML.class);
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account ac = StaticMockData.getAccount()[0];
        Order od = StaticMockData.getOrder()[0];
        Product2 p2 = StaticMockData.getProduct2()[0];
        list < Id > ProdIds = new list < Id > ();
        ProdIds.add(p2.Id);
        if (string.isNotEmpty(od.id) && string.isNotEmpty(ac.id)) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            transactionParams ts = new transactionParams();
            ts.methodID = '1';
            ts.accountID = ac.id;
            ts.Amount = 5;
            ts.Tax = 2;
            Map < String, String > mapUpdCustomer = new Map < String, String > ();
            mapUpdCustomer.put(ac.Id, ac.Id);
            Map < String, String > mapUpdOrders = new Map < String, String > ();
            mapUpdOrders.put(od.Id, od.Id);
            Map < String, String > mapUpdProducts = new Map < String, String > ();
            mapUpdProducts.put(p2.Id, p2.Id);
            string strProcessPayment = '{ "saveCard": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp"}';
            Map < String, Object > mapProcessPayment = (Map < String, Object > ) JSON.deserializeUntyped(strProcessPayment);
            Test.startTest();
            EBizCharge_Transaction__c t = new EBizCharge_Transaction__c();
            eBc_UtilityController.saveTransaction(dml, 'RefNumber', t, ebcLogger);
            eBc_UtilityController.getProductsDetail(dml, ProdIds, ebcLogger);
            eBc_UtilityController.getOrderDetail(dml, od.Id, ebcLogger);
            Test.stopTest();
        }
    }
}