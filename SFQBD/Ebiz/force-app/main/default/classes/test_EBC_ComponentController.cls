@isTest
public class test_EBC_ComponentController {
    @isTest(OnInstall = true)
    static void test_getDetailApxc() {
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account acc = StaticMockData.getAccount()[0];
        if (!Schema.sObjectType.Account.fields.getMap().containsKey('isPersonAccount')) {
            acc.Name = 'test1@ebzi.com'; //conditioned by waseem as per Person Account issue
        }
        acc.EBizCharge_Internal_ID__c = '';
        try {
            EBC_ComponentController.getDetailApxc(acc.id, 'Account');
        } catch (exception err) {}
    }
    @isTest(OnInstall = true)
    static void test_UpdateCustomerInfoFromSchema() {
        Ebiz_C__EBizCharge_Fields_Config__c c = StaticMockData.getEBizCharge_Fields_Config()[0];
        try {
            EBC_ComponentController.UpdateCustomerInfoFromSchema(c.Id, c.Name);
        } catch (exception err) {}
    }
    @isTest(OnInstall = true)
    static void testMethod1() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        EBC_Logger ebcLogger = new EBC_Logger();
        EBizcharge_Setting__c ES = StaticMockData.getEBizcharge_Setting()[0];
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        if (true) {
            Account acc = StaticMockData.getAccount()[0];
            if (!Schema.sObjectType.Account.fields.getMap().containsKey('isPersonAccount')) {
                acc.Name = 'test1@ebzi.com'; //conditioned by waseem as per Person Account issue
            }
            acc.EBizCharge_Internal_ID__c = 'test';
            Contact con = StaticMockData.getContact()[0];
            EBizCharge_Transaction__c ebiz = StaticMockData.getEBizCharge_Transaction()[0];
            Product2 p = StaticMockData.getProduct2()[0];
            Id pricebookId = Test.getStandardPricebookId();
            order od = StaticMockData.getOrder()[0];
            OrderItem i = StaticMockData.getOrderItem()[0];
            OrderItem oi = new OrderItem();
            oi.OrderId = od.id;
            oi.Quantity = 24;
            oi.UnitPrice = 240;
            oi.Product2id = p.id;
            oi.Description = 'Test OrderItem Entry 1';
            Opportunity testOpportunity = StaticMockData.getOpportunity()[0];
            Quote test_quote = StaticMockData.getQuote()[0];
            QuoteLineItem qli = StaticMockData.getQuoteLineItem()[0];
            String BodyEmail = '{"AccountId":"' + acc.id + '","AccInternalId":"234243rwrw","Amount":23.00,"Tax":23.00,"PaymentTotal":23.00,"fromName":"test","fromEmail":"test@ebiz.com","toEmail":"test@ebiz.com","Subject":"test","Notes":"test","TemplateId":"test2","OrderTotal":23,"OrderBalance":34.00,"rrStartDate":"2050-12-30","rrEndDate":"2050-12-30","payBy":"AddNewCard","OrderId":"' + od.Id + '"}';
            String BodyEmail_2 = '{"AccountId":"' + acc.id + '","AccInternalId":"234243rwrw","Amount":23.00,"Tax":23.00,"PaymentTotal":23.00,"fromName":"test","fromEmail":"test@ebiz.com","toEmail":"test@ebiz.com","Subject":"test","Notes":"test","TemplateId":"test2","OrderTotal":23,"OrderBalance":34.00,"rrStartDate":"2050-12-30","rrEndDate":"2050-12-30","payBy":"addNewACH"}';
            String BodyEmail_3 = '{"AccountId":"' + acc.id + '","AccInternalId":"234243rwrw","Amount":23.00,"Tax":23.00,"PaymentTotal":23.00,"fromName":"test","fromEmail":"test@ebiz.com","toEmail":"test@ebiz.com","Subject":"test","Notes":"test","TemplateId":"test2","OrderTotal":23,"OrderBalance":34.00,"rrStartDate":"2050-12-30","rrEndDate":"2050-12-30","payBy":"addNewACH","OrdersfID":"' + od.Id + '","paymentType":"Sale","ContactId":"' + con.id + '"}';
            String BodyEmail_3_quote = '{"AccountId":"' + acc.id + '","AccInternalId":"234243rwrw","Amount":23.00,"Tax":23.00,"PaymentTotal":23.00,"fromName":"test","fromEmail":"test@ebiz.com","toEmail":"test@ebiz.com","Subject":"test","Notes":"test","TemplateId":"test2","OrderTotal":23,"OrderBalance":34.00,"rrStartDate":"2050-12-30","rrEndDate":"2050-12-30","payBy":"addNewACH","OrdersfID":"' + test_quote.Id + '","paymentType":"Sale" }';
            String BodyEmail_3_procesPaymentWithSavedACHApxc = '{"AccountId":"' + acc.id + '","AccInternalId":"234243rwrw","Amount":23.00,"Tax":23.00,"PaymentTotal":23.00,"fromName":"test","fromEmail":"test@ebiz.com","toEmail":"test@ebiz.com","Subject":"test","Notes":"test","TemplateId":"test2","OrderTotal":23,"OrderBalance":34.00,"rrStartDate":"2050-12-30","rrEndDate":"2050-12-30","payBy":"ExistingACH","OrdersfID":"' + od.Id + '","paymentType":"Sale","ContactId":"' + con.id + '"}';
            String BodyEmail_4 = '{"AccountId":"' + acc.id + '","OpportunityId":"' + testOpportunity.id + '","AccInternalId":"234243rwrw","Amount":23.00,"Tax":23.00,"PaymentTotal":23.00,"fromName":"test","fromEmail":"test@ebiz.com","toEmail":"test@ebiz.com","Subject":"test","Notes":"test","TemplateId":"test2","OrderTotal":23,"OrderBalance":34.00,"rrStartDate":"2050-12-30","rrEndDate":"2050-12-30","payBy":"addNewACH"}';
            String BodyEmail_test = '{"AccountId":"' + acc.id + '","AccInternalId":"234243rwrw","Amount":23.00,"Tax":23.00,"PaymentTotal":23.00,"fromName":"test","fromEmail":"test@ebiz.com","toEmail":"test@ebiz.com","Subject":"test","Notes":"test","TemplateId":"test2","OrderTotal":23,"OrderBalance":34.00,"rrStartDate":"2050-12-30","rrEndDate":"2050-12-30","payBy":"AddNewCard","OrderId":"' + od.Id + '","rrIndefinit":true}';
            String BodyEmail5 = '{"AccountId":"' + acc.id + '","AccInternalId":"234243rwrw","Amount":23.00,"Tax":23.00,"PaymentTotal":23.00,"fromName":"test","fromEmail":"test@ebiz.com","toEmail":"test@ebiz.com","Subject":"test","Notes":"test","TemplateId":"test2","OrderTotal":23,"OrderBalance":34.00,"rrStartDate":"2050-12-30","rrEndDate":"2050-12-30","payBy":"UseExistingCard","selectedCardId":"123","cvcNo":"123","OrderId":"' + od.Id + '"}';
            String BodyEmail6 = '{"AccountId":"' + acc.id + '","AccInternalId":"234243rwrw","Amount":23.00,"Tax":23.00,"PaymentTotal":23.00,"fromName":"test","fromEmail":"test@ebiz.com","toEmail":"test@ebiz.com","Subject":"test","Notes":"test","TemplateId":"test2","OrderTotal":23,"OrderBalance":34.00,"rrStartDate":"2050-12-30","rrEndDate":"2050-12-30","payBy":"savedACH","selectedACHId":"123","cvcNo":"123","OrderId":"' + od.Id + '"}';
            String BodyEmail_test_contact = '{"AccountId":"' + acc.id + '","AccInternalId":"234243rwrw","Amount":23.00,"Tax":23.00,"PaymentTotal":23.00,"fromName":"test","fromEmail":"test@ebiz.com","toEmail":"test@ebiz.com","Subject":"test","Notes":"test","TemplateId":"test2","OrderTotal":23,"OrderBalance":34.00,"rrStartDate":"2050-12-30","rrEndDate":"2050-12-30","payBy":"addNewACH","accHolderName":"test","accNumber":"123","accRoutNumber":"123","OrderId":"' + od.Id + '"}';
            EBC_ComponentController.Payments Pay = new EBC_ComponentController.Payments();
            EBC_ComponentController.transactionWrapper transWrap = new EBC_ComponentController.transactionWrapper();
            transWrap.userId = '1234444';
            transWrap.TransType = 'test';
            transWrap.RefNumURL = '333333';
            transWrap.transHyperURL = 'test';
            transWrap.refNum = '666666';
            transWrap.dateTimeTransaction = system.now();
            transWrap.paymentMethod = 'v';
            transWrap.contact = '098888888';
            transWrap.formattedDateTimeTransaction = system.now();
            transWrap.CardType = 'Creditcard';
            transWrap.amountPaid = 2.9;
            transWrap.tcount = 2;
            EBC_ComponentController.receivedPayments receivedPay = new EBC_ComponentController.receivedPayments();
            receivedPay.isSelected = true;
            receivedPay.PaymentMethodId = '12346789';
            receivedPay.CustomerEmailAddress = 'abc.as@tekhqs.com';
            receivedPay.PaymentMethodId = '12346789';
            receivedPay.OrderHyperUrl = '12346789';
            receivedPay.OrderId = '12346789';
            receivedPay.tcount = 12;
            receivedPay.CustomerId = '1234678965';
            receivedPay.CustomerName = 'Alley';
            receivedPay.DivisionId = '111111';
            receivedPay.InvoiceNumber = '12222';
            receivedPay.InvoiceInternalId = 'A111111l';
            receivedPay.InvoiceDate = '20-07-2020';
            receivedPay.InvoiceDueDate = '20-07-2020';
            receivedPay.AmountDue = '20.9';
            receivedPay.AuthCode = '44444';
            receivedPay.PoNum = '20999';
            receivedPay.InvoiceAmount = '20.9';
            receivedPay.RefNum = '209999';
            receivedPay.Last4 = '2019';
            receivedPay.PaymentMethod = '';
            receivedPay.DatePaid = '20-07-2020';
            receivedPay.PaymentRequestTime = '';
            receivedPay.ResendCount = 2;
            receivedPay.PaymentInternalId = '';
            receivedPay.PaymentRequestDate = Date.today();
            receivedPay.TypeId = '';
            receivedPay.PaymentRequestDateTime = Datetime.now();
            receivedPay.PaymentSourceId = '';
            receivedPay.TransactionLookupKey = '';
            receivedPay.ExternalTxnId = '';
            receivedPay.PaidAmount = 20.5;
            EBC_ComponentController.receivedPay rPay = new EBC_ComponentController.receivedPay();
            rPay.fromDate = Date.today();
            rPay.toDate = Date.today();
            rPay.recPaymentList = null;
            EBC_ComponentController.getReceivedPaymentEmailsApxc('2020-05-05', '2020-05-05', new Opportunity(), 'test');
            EBC_ComponentController.getReceivedPaymentsWithTypeApxc('2020-05-05', '2020-05-05', new Order(), 'Order', 'webformType');
            EBC_ComponentController.getReceivedPaymentsWithTypeApxc('2020-05-05', '2020-05-05', new Opportunity(), 'Opportunity', 'webformType');
            EBC_ComponentController.getReceivedPaymentsWithTypeApxc('2020-05-05', '2020-05-05', new Quote(), 'Quote', 'webformType');
            EBC_ComponentController.markPaymentAsApplied('123456', '12345678', '12345', '123456', 5000);
            transactionParams ts = new transactionParams();
            ts.methodID = '1';
            ts.accountID = acc.id;
            Map < String, Object > mapProcessPayment = new Map < String, Object > ();
            mapProcessPayment.put('paymentType', 'Deposit');
            mapProcessPayment.put('saveCard', true);
            mapProcessPayment.put('saveACH', true);
            mapProcessPayment.put('saveACH', true);
            mapProcessPayment.put('SendReceiptTo', true);
            mapProcessPayment.put('addEmails', 'test@test.com');
            EBC_ComponentController.saveSettingsApxc(ES);
            EBC_ComponentController.getDetailApxc(od.id, 'Order');
            try {
                EBC_ComponentController.getDetailApxc(con.id, 'Contact');
            } catch (exception err) {}
            try {
                EBC_ComponentController.getDetailApxc(acc.id, 'Account');
            } catch (exception err) {}
            try {
                EBC_ComponentController.getDetailApxc(test_quote.id, 'Quote');
            } catch (exception err) {}
            EBC_ComponentController.getDetailApxcContact(con.id, 'Contact');
            try {
                EBC_ComponentController.getDetailApxc(testOpportunity.id, 'Opportunity');
            } catch (Exception ex) {
                system.debug('');
            }
            EBC_ComponentController.getCustPaymentMethodsApx(acc.id);
            EBC_ComponentController.getCustPaymentMethodsContactApx(con.id);
            EBC_ComponentController.getEmailTemplatesApxc();
            try {
                EBC_ComponentController.sendEmailPayReqApxc(BodyEmail, acc, 'Order', new Quote());
            } catch (exception err) {}
            try {
                EBC_ComponentController.sendEmailPayReqApxc(BodyEmail, acc, 'Quote', new Quote());
            } catch (exception err) {}
            try {
                EBC_ComponentController.sendEmailPayReqApxc(BodyEmail, acc, '', new Quote());
            } catch (exception err) {}
            try {
                EBC_ComponentController.sendEmailPayReqApxc(BodyEmail, acc, 'Account', new Quote());
            } catch (exception err) {}
            try {
                EBC_ComponentController.sendEmailPayReqApxc(BodyEmail, acc, 'Opportunity', new Quote());
            } catch (exception err) {}
            EBC_ComponentController.addPaymentMehtodReqApxc(BodyEmail, acc, null);
            EBC_ComponentController.addPaymentMehtodReqApxcContact(BodyEmail, con, null);
            EBC_ComponentController.AddPaymentMethodContact(dml, mapProcessPayment, 'CreditCard', ebcLogger);
            EBC_ComponentController.AddPaymentMethodContact(dml, mapProcessPayment, 'saveACH', ebcLogger);
            EBC_ComponentController.runRecurringApxc(BodyEmail_test, acc, 'Order');
            try {
                EBC_ComponentController.runRecurringApxc(BodyEmail, acc, '');
            } catch (exception err) {}
            try {
                EBC_ComponentController.runRecurringApxc(BodyEmail5, acc, '');
            } catch (exception err) {}
            try {
                EBC_ComponentController.runRecurringApxc(BodyEmail6, acc, '');
            } catch (exception err) {}
            EBC_ComponentController.runRecurringApxcContact(BodyEmail_test, con, 'Contact');
            try {
                EBC_ComponentController.runRecurringApxcContact(BodyEmail5, con, 'Contact');
            } catch (exception err) {}
            try {
                EBC_ComponentController.runRecurringApxcContact(BodyEmail6, con, 'Contact');
            } catch (exception err) {}
            try {
                EBC_ComponentController.runRecurringApxcContact(BodyEmail_test_contact, con, 'Contact');
            } catch (exception err) {}
            EBC_ComponentController.runRecurringApxc(BodyEmail_2, acc, 'Order');
            EBC_ComponentController.getTransactionApxc(ebiz.Ref_Number__c);
            EBC_ComponentController.capturePaymentApxc(od, 23, null, 0);
            try {
                EBC_ComponentController.capturePaymentApxc(od, 23, test_quote, 0);
            } catch (exception err) {}
            EBC_ComponentController.processPaymentNewACHApxc(BodyEmail_3, acc, od, 'Account', new Quote());
            EBC_ComponentController.processPaymentNewACHApxc(BodyEmail_3, acc, od, 'Order', new Quote());
            EBC_ComponentController.processPaymentNewACHApxc(BodyEmail_4, acc, od, 'Opportunity', new Quote());
            EBC_ComponentController.invokeTransactionVoidApxc(ebiz.Ref_Number__c);
            EBC_ComponentController.processPaymentWithXCApxc(BodyEmail_3, acc, od, 'Order', test_quote);
            EBC_ComponentController.processPaymentWithXCApxc(BodyEmail_3_quote, acc, od, 'Quote', test_quote);
            EBC_ComponentController.processPaymentWithXCApxcContact(BodyEmail_3, con, 'Contact1');
            EBC_ComponentController.processPaymentWithXCApxcContact(BodyEmail_3_procesPaymentWithSavedACHApxc, con, 'Order');
            Ebiz_C__EBiz_Object_Config__c config = new Ebiz_C__EBiz_Object_Config__c();
            config.Ebiz_C__EBizAmountApi__c = '';
            config.Ebiz_C__EBizCustomerEmailApi__c = '';
            config.Ebiz_C__EBizCustomerNameApi__c = '';
            EBC_ComponentController.SaveObjectConfig(config);
            EBC_ComponentController.SaveObjectConfigClose(config);
            EBC_ComponentController.GetObjLabel('Account', ebcLogger);
            EBC_ComponentController.GetObjLabelSettings('Account');
            EBC_ComponentController.GETObjConfig('Account');
            Ebiz_C__EBizCharge_Fields_Config__c c = StaticMockData.getEBizCharge_Fields_Config()[0];
            EBC_ComponentController.getDetailApxcCustomCustomer(c.Ebiz_C__EBizCharge_CustomerId__c, 'Ebiz_C__EBizCharge_Fields_Config__c');
            EBC_ComponentController.getCustPaymentMethodsCustomApx(c.Ebiz_C__EBizCharge_CustomerId__c);
            EBC_ComponentController.UpdateInternalIdCustomCustomer(c.Ebiz_C__EBizCharge_CustomerId__c);
            EBC_ComponentController.processPaymentWithXCApxcCustomCustomer(BodyEmail_3, c, 'Contact1');
            EBC_ComponentController.addPaymentMehtodReqApxcCustomCustomer(BodyEmail, c, null);
            try {
                EBC_ComponentController.processPaymentWithNCApxcCustomCustomer(BodyEmail_3, c, 'Contact1');
            } catch (Exception ex) {}
            try {
                EBC_ComponentController.processPaymentNewACHApxcCustomCustomer(BodyEmail_3, c, 'ObjName');
            } catch (Exception ex) {}
            EBC_ComponentController.runRecurringApxcCustomCustomer(BodyEmail_test, c, 'Custom');
            try {
                EBC_ComponentController.runRecurringApxcCustomCustomer(BodyEmail5, c, 'Custom');
            } catch (Exception ex) {}
            try {
                EBC_ComponentController.runRecurringApxcCustomCustomer(BodyEmail6, c, 'Custom');
            } catch (Exception ex) {}
            try {
                EBC_ComponentController.runRecurringApxcCustomCustomer(BodyEmail_test_contact, c, 'Custom');
            } catch (Exception ex) {}
            try {
                EBC_ComponentController.procesPaymentWithSavedACHApxcCustomCustomer(BodyEmail_3, c, 'ObjName');
            } catch (Exception ex) {}
            try {
                EBC_ComponentController.procesPaymentWithSavedACHApxcContact(BodyEmail_3, con, 'ObjName');
            } catch (Exception ex) {}
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            Test.startTest();
            String BodyEmail_5 = '{"isAVSCheck":true, "saveCard":true}';
            try {
                EBC_ComponentController.processPaymentWithNCApxc(BodyEmail_3, acc, od, 'Order', new Quote());
            } catch (Exception ex) {}
            try {
                EBC_ComponentController.processPaymentWithNCApxcContact(BodyEmail_5, con, 'Contact');
            } catch (Exception ex) {}
            Ebiz_C__EBizCharge_Fields_Config__c ccConfig = new Ebiz_C__EBizCharge_Fields_Config__c();
            try {
                EBC_ComponentController.processPaymentWithNCApxcCustomCustomer(BodyEmail_5, ccConfig, 'Contact');
            } catch (Exception ex) {}
            Test.stopTest();
            EBC_ComponentController.getCompSettingsApxc();
            string addNewACHJSON = '{ "Amount":1, "Tax":1,"isAVSCheck": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp" }';
            string existingACHJSON = '{"Amount":1, "Tax":1, "selectedACHId":"123", "isAVSCheck": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp" }';
            Map < String, Object > newACHmap = (Map < String, Object > ) JSON.deserializeUntyped(addNewACHJSON);
            try {
                EBC_ComponentController.procesPaymentWithSavedACHApxc(existingACHJSON, acc, od, 'Quote', test_quote);
            } catch (Exception ex) {}
            try {
                EBC_ComponentController.processPaymentNewACHApxcContact(addNewACHJSON, con, 'Contact');
            } catch (Exception ex) {}
            try {
                EBC_ComponentController.processPaymentWithNCApxc(addNewACHJSON, acc, od, 'Account', new Quote());
            } catch (Exception ex) {}
            EBC_ComponentController.emailTemplate et = new EBC_ComponentController.emailTemplate();
            et.TemplateName = 'Test Name';
            et.TemplateType = 'Test Type';
            et.TemplateInternalId = 'Test ID';
            et.TemplateSubject = 'Test Subject';
            et.TemplateFromName = 'Test  From Name';
            et.FromEmail = 'Test  Email';
            et.ReplyToEmail = 'Test@test.com ';
            EBC_ComponentController.customerMethod cm = new EBC_ComponentController.customerMethod();
            cm.CardCode = '';
            cm.Account = '';
            cm.AccountType = '';
            cm.Routing = '';
            EBC_ComponentController.Detail dl = new EBC_ComponentController.Detail();
            dl.OppId = '';
            dl.OppName = '';
            dl.UseFullAmountForAVS = false;
            dl.quoteDetail = null;
            dl.ContactInternalId = '547690';
            dl.ZipCode = '45000';
            dl.TransInfo = null;
            dl.SavedPaymentMethodslist = null;
            dl.Settings = null;
            dl.ordDetail = null;
            dl.savedPaymentMethods = null;
            dl.OpportunityDetail = null;
            dl.CustomCustInternalId = '546547878';
            String ordNum = '1111';
            EBC_ComponentController.getPendingPaymentsCustomerApxc('2020-05-05', '2020-05-05', new Opportunity(), 'test');
            EBC_ComponentController.getPendingPaymentsWithTypeApxc('2020-05-05', '2020-05-05', new Opportunity(), 'Opportunity', 'webformType');
            EBC_ComponentController.getPendingPaymentsWithTypeApxc('2020-05-05', '2020-05-05', new Account(), 'Account', 'webformType');
            EBC_ComponentController.getPendingPaymentsWithTypeApxc(null, null, new Contact(), 'Contact', 'webformType');
            String paymentFrequency = 'Daily';
            EBC_ComponentController.getRecurringSchedulePreview('2020-05-05', '2020-05-05', paymentFrequency);
            EBC_ComponentController.getPendingPaymentsApxc('2020-05-05', '2020-05-05', ordNum);
            try {
                EBC_ComponentController.getTransactionsCustomObjectApxc('5667677');
            } catch (Exception ex) {}
            try {
                EBC_ComponentController.getTransactionsContactApxc(con.id);
            } catch (Exception ex) {}
            testOpportunity.AccountId = acc.id;
            try {
                EBC_ComponentController.getTransactionsOppApxc(testOpportunity);
            } catch (Exception ex) {}
            try {
                EBC_ComponentController.getTransactionsOrderApxc(od);
            } catch (Exception ex) {}
            try {
                EBC_ComponentController.getTransactionsAccountApxc(acc);
            } catch (Exception ex) {}
            try {
                EBC_ComponentController.getTransactionsQuoteApxc(test_quote);
            } catch (Exception ex) {}
        }
    }
}