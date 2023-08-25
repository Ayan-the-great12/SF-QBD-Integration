@isTest
public class test_eBc_ProcessPaymentController {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account act = StaticMockData.getAccount()[0];
        Opportunity opp = StaticMockData.getOpportunity()[0];
        Product2 p = StaticMockData.getProduct2()[0];
        PricebookEntry standardPrice = StaticMockData.getPricebookEntry()[0];
        Order o = StaticMockData.getOrder()[0];
        OrderItem i = StaticMockData.getOrderItem()[0];
        System.debug('i.Product2id:' + i.Product2id);
        eBc_ProcessPaymentController.autoSyncOrderApxc(o.Id);
        eBc_ProcessPaymentController.OrderHelper ordrHelper = new eBc_ProcessPaymentController.OrderHelper();
        ordrHelper.Id = o.Id;
        ordrHelper.OrderNumber = '12';
        ordrHelper.accId = 'acid';
        ordrHelper.accName = 'actname';
        ordrHelper.accFirstName = 'actFirstname';
        ordrHelper.accLastName = 'Lastname';
        ordrHelper.accExternalId = 'actExternalID';
        ordrHelper.accEmail = 'accEmail';
        ordrHelper.ContractId = 'Contract';
        ordrHelper.ContractNumber = '45634534';
        ordrHelper.TotalAmount = 2;
        ordrHelper.AmountDue = 3;
        ordrHelper.OrderTax = 4;
        ordrHelper.OrderBalance = 5;
        ordrHelper.AmountReceived = 6;
        ordrHelper.CreatedDate = system.today();
        ordrHelper.PaymentStatus = '';
        ordrHelper.isSelected = true;
        ordrHelper.OrdExternalId = '32423';
        ordrHelper.isEdited = true;
        ordrHelper.isAllowPartialPay = true;
        List < eBc_ProcessPaymentController.OrderHelper > OrdersList = new List < eBc_ProcessPaymentController.OrderHelper > ();
        OrdersList.add(ordrHelper);
        String PaymentType = '';
        eBc_ProcessPaymentController.getSettingsApxc();
        eBc_ProcessPaymentController.getDetailApxc(o.Id, 'Order');
        eBc_ProcessPaymentController.getDetailApxc(act.Id, 'Account');
        eBc_ProcessPaymentController.getDetailApxc(opp.Id, 'Opportunity');
        Test.startTest();
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        string processStrMap = '{ "selectedCardId" : "44", "ExcludeTax" : true, "SendReceiptTo": true, "addEmails" : "test@test.com" }';
        eBc_ProcessPaymentController.procesPaymentNewACHApxc(processStrMap, OrdersList, act, PaymentType);
        eBc_ProcessPaymentController.getListOfOrdersApxc(act.Id);
        try {
            eBc_ProcessPaymentController.processPaymentWithXCApxc(processStrMap, OrdersList, act, PaymentType);
        } catch (Exception ex) {}
        string addNewACHJSON = '{ "saveCard": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp"}';
        Map < String, Object > newACHmap = (Map < String, Object > ) JSON.deserializeUntyped(addNewACHJSON);
        try {
            eBc_ProcessPaymentController.AddPaymentMethod(dml, newACHmap, 'CreditCard', ebcLogger);
        } catch (Exception ex) {}
        try {
            eBc_ProcessPaymentController.AddPaymentMethod(dml, newACHmap, 'saveACH', ebcLogger);
        } catch (Exception ex) {}
        try {
            eBc_ProcessPaymentController.procesPaymentWithNCApxc('addNewCardJSON', OrdersList, act, PaymentType);
        } catch (Exception ex) {}
        try {
            eBc_ProcessPaymentController.procesPaymentWithSavedACHApxc('savedACHJSON', OrdersList, act, PaymentType);
        } catch (Exception ex) {}
        try {
            eBc_ProcessPaymentController.processPayment(dml, newACHmap, OrdersList, act, 'NewCard', PaymentType, ebcLogger);
        } catch (Exception ex) {}
        try {
            eBc_ProcessPaymentController.processPayment(dml, newACHmap, OrdersList, act, 'ExistingACH', PaymentType, ebcLogger);
        } catch (Exception ex) {}
        eBc_ProcessPaymentController.updrrPaymentScheduleStatusApxc('recIntenalId', 1);
        Test.stopTest();
        eBc_ProcessPaymentController.OrderWrapper ordWr = new eBc_ProcessPaymentController.OrderWrapper();
        ordWr.Settings = null;
        eBc_ProcessPaymentController.Detail dl = new eBc_ProcessPaymentController.Detail();
        dl.TransInfo = null;
        dl.Settings = null;
        dl.ContactId = '1234';
        dl.ContactName = 'test';
        dl.ContactInfo = null;
        dl.contactDetail = null;
        dl.quoteDetail = null;
        dl.ContactInternalId = '11111';
        dl.ordDetail = null;
        dl.savedPaymentMethods = null;
        dl.OpportunityDetail = null;
        dl.CustomCustInfo = null;
        dl.CustomCustId = '11111';
        dl.CustomCustName = 'test';
        dl.CustomCustInternalId = '11111';
        dl.Object_label = 'test';
        dl.SavedPaymentMethodslist = null;
        eBc_ProcessPaymentController.customerMethod cm = new eBc_ProcessPaymentController.customerMethod();
        cm.MethodType = 'test';
        cm.MethodID = 'test';
        cm.MethodName = 'test';
        cm.DateCreated = date.today();
        cm.DateModified = date.today();
        cm.AccountHolderName = 'test';
        cm.AvsStreet = 'test';
        cm.AvsZip = 'test';
        cm.CardExpiration = 'test';
        cm.CardExpMonth = 'test';
        cm.CardExpYear = 'test';
        cm.CardNumber = 'test';
        cm.Last4Degit = 'test';
        cm.CardType = 'test';
        cm.CardCode = 'test';
        cm.Account = 'test';
        cm.AccountType = 'test';
        cm.Routing = 'test';
        cm.SecondarySort = 12;
    }
}