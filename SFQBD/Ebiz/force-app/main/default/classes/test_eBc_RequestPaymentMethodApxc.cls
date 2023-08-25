@isTest
public with sharing class test_eBc_RequestPaymentMethodApxc {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        String sDate = '1900-1-1';
        String eDate = '2100-1-1';
        eBc_RequestPaymentMethodApxc.PaymentMethodsContact payMethodCon = new eBc_RequestPaymentMethodApxc.PaymentMethodsContact();
        payMethodCon.ContactInfo = null;
        payMethodCon.savedPaymentMethods = null;
        payMethodCon.SavedPaymentMethodslist = null;
        eBc_RequestPaymentMethodApxc.PaymentMethodsCustomCust paymentMethod = new eBc_RequestPaymentMethodApxc.PaymentMethodsCustomCust();
        paymentMethod.ContactInfo = null;
        paymentMethod.savedPaymentMethods = null;
        paymentMethod.SavedPaymentMethodslist = null;
        Account ac = StaticMockData.getAccount()[0];
        eBc_RequestPaymentMethodApxc.CustomerWrapper accWrap = new eBc_RequestPaymentMethodApxc.CustomerWrapper();
        List < eBc_RequestPaymentMethodApxc.CustomerWrapper > custWrap = new List < eBc_RequestPaymentMethodApxc.CustomerWrapper > ();
        accWrap.accId = '42332';
        accWrap.accName = ac.Name;
        accWrap.dateCreated = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        accWrap.accAmount = 4;
        accWrap.savedPaymentMethods = null;
        accWrap.SavedPaymentMethodslist = null;
        accWrap.MethodType = 'V';
        accWrap.toDate = Date.today();
        accWrap.fromDate = Date.today();
        accWrap.objectName = 'testObj';
        accWrap.accShippingStreet = 'fake';
        accWrap.accShippingCountry = 'VA';
        accWrap.accShippingPostalCode = '777';
        accWrap.accShippingState = 'test';
        accWrap.accShippingCity = 'VA';
        accWrap.HyperUrlAccount = '11111';
        accWrap.paymentmethodurl = 'View Payment Method';
        accWrap.accEmail = 'test@gmail.com';
        accWrap.accExtId = '78646';
        accWrap.isSelected = false;
        custWrap.add(accWrap);
        eBc_RequestPaymentMethodApxc.wrapperConfigObject configWrap = new eBc_RequestPaymentMethodApxc.wrapperConfigObject();
        configWrap.EBizCharge_Amount_fields_list = null;
        configWrap.config = null;
        configWrap.EBizCharge_EBizCharge_Email_list = null;
        configWrap.EBizCharge_name_fields_list = null;
        eBc_RequestPaymentMethodApxc.customerMethod custMeth = new eBc_RequestPaymentMethodApxc.customerMethod();
        custMeth.Routing = '11111';
        custMeth.AccountType = 'test';
        custMeth.Account = 'Account';
        custMeth.CardCode = '11111';
        string sendReqJSON = '{ "saveCard": true,  "CardNumber" :"34534" , "expiryMonth" : "5" , "expiryYear" : "2020" , "CVCNumber" : "ccvCo", "CardHolderName" : "ccName" , "ZipCode" : "sdfp" }';
        eBc_RequestPaymentMethodApxc.addPayMehtodReqApxc(sendReqJSON, custWrap);
        eBc_RequestPaymentMethodApxc.getSettingsApxc();
        eBc_RequestPaymentMethodApxc.getCustomersApxc(sDate, eDate, null, null, null, null);
    }
    @isTest(OnInstall = true)
    public static void testMethod2() {
        eBc_RequestPaymentMethodApxc.getEmailTemplatesApxc();
    }
    @isTest(OnInstall = true)
    static void test_getDetailApxc() {
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account acc = StaticMockData.getAccount()[0];
        eBc_RequestPaymentMethodApxc.dropdownVals dVals = new eBc_RequestPaymentMethodApxc.dropdownVals();
        dVals.label = 'testlabel';
        dVals.value = '45000';
        eBc_RequestPaymentMethodApxc.Detail dl = new eBc_RequestPaymentMethodApxc.Detail();
        dl.OppId = '';
        dl.OppName = '';
        dl.UseFullAmountForAVS = false;
        dl.quoteDetail = null;
        dl.ContactInternalId = '547690';
        dl.ZipCode = '45000';
        dl.ContactId = '45000';
        dl.TransInfo = null;
        dl.SavedPaymentMethodslist = null;
        dl.Settings = null;
        dl.ordDetail = null;
        dl.savedPaymentMethods = null;
        dl.OpportunityDetail = null;
        dl.CustomCustInternalId = '546547878';
        dl.ContactInfo = null;
        dl.ContactName = '45000';
        dl.contactDetail = null;
        dl.AccountInternalId = '88888';
        dl.Address = '45000';
        dl.CustomCustInfo = null;
        dl.CustomCustId = '45000';
        dl.CustomCustName = 'test';
        dl.CustomCustInternalId = '45000';
        dl.Object_label = 'test';
        dl.AccountName = 'test';
        dl.AccountId = 'test';
        dl.AccountInfo = null;
        if (!Schema.sObjectType.Account.fields.getMap().containsKey('isPersonAccount')) {
            acc.Name = 'test1@ebzi.com'; //conditioned by waseem as per Person Account issue
        }
        acc.EBizCharge_Internal_ID__c = '';
        try {
            eBc_RequestPaymentMethodApxc.getCustPaymentMethodsApx(acc.id, 'Account');
        } catch (exception err) {}
    }
    @isTest(OnInstall = true)
    public static void test_getPendingPaymentsApxc() {
        String sDate = '1900-1-1';
        String eDate = '2100-1-1';
        String webformType = '';
        eBc_RequestPaymentMethodApxc.getReceivedPaymentsApxc(sDate, eDate, webformType);
        try {
            eBc_RequestPaymentMethodApxc.getPendingRequestPaymentsApxc(sDate, eDate, webformType);
        } catch (Exception err) {}
    }
    @isTest(OnInstall = true)
    public static void test_constructor_emailTemplate() {
        try {
            eBc_RequestPaymentMethodApxc.emailTemplate em_obj = new eBc_RequestPaymentMethodApxc.emailTemplate();
            em_obj.TemplateName = 'test';
            em_obj.TemplateType = 'bb';
            em_obj.TemplateInternalId = '2342342';
            em_obj.TemplateSubject = 'test subject';
            em_obj.TemplateFromName = 'testfrom';
            em_obj.FromEmail = 'abc@cs.com';
            em_obj.ReplyToEmail = 'testemail';
        } catch (Exception err) {}
    }
    @isTest(OnInstall = true)
    public static void testMethod5() {
        eBc_RequestPaymentMethodApxc.Payments payments_obj = new eBc_RequestPaymentMethodApxc.Payments();
        List < eBc_RequestPaymentMethodApxc.Payments > paymentsList = new List < eBc_RequestPaymentMethodApxc.Payments > ();
        payments_obj.CustomerId = '24234';
        payments_obj.CustomerEmailAddress = 'test@gmail.com';
        payments_obj.PaymentInternalId = '2342342';
        payments_obj.PaymentRequestDateTime = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        paymentsList.add(payments_obj);
        eBc_RequestPaymentMethodApxc.removePendingPaymentsApxc(paymentsList);
    }
    @isTest(OnInstall = true)
    public static void testMethod6() {
        eBc_RequestPaymentMethodApxc.PendingPayments pendingpay = new eBc_RequestPaymentMethodApxc.PendingPayments();
        pendingpay.fromDate = Date.today();
        pendingpay.toDate = Date.today();
        List < eBc_RequestPaymentMethodApxc.Payments > paymentsList = new List < eBc_RequestPaymentMethodApxc.Payments > ();
        eBc_RequestPaymentMethodApxc.Payments payments_obj = new eBc_RequestPaymentMethodApxc.Payments();
        payments_obj.OrderId = '234';
        payments_obj.cardClass = 'cardClass';
        payments_obj.accName = 'test';
        payments_obj.ResendCount = 2;
        payments_obj.CustomerId = '24234';
        payments_obj.CustomerEmailAddress = 'test@gmail.com';
        payments_obj.CustomerName = 'test';
        payments_obj.DivisionId = '2423432';
        payments_obj.InvoiceNumber = '23423432';
        payments_obj.InvoiceInternalId = '23423432';
        payments_obj.PaymentInternalId = '2342342';
        payments_obj.InvoiceDate = '2017-12-12';
        payments_obj.PaymentRequestDateTime = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        payments_obj.InvoiceDueDate = '2017-12-12';
        payments_obj.PoNum = '123';
        payments_obj.InvoiceAmount = '12.00';
        payments_obj.AmountDue = '0.00';
        payments_obj.AuthCode = '2234424auwweew';
        payments_obj.RefNum = '234234';
        payments_obj.Last4 = '08773';
        payments_obj.PaymentMethod = 'V';
        payments_obj.DatePaid = '2017-12-12';
        payments_obj.PayDate = Date.today();
        payments_obj.PayTime = '2017-12-12';
        payments_obj.PaymentMethodId = '201777';
        payments_obj.TypeId = '201777';
        payments_obj.PaymentSourceId = '201777';
        payments_obj.TransactionLookupKey = '201777';
        payments_obj.ExternalTxnId = '201777';
        payments_obj.contactName = 'test';
        payments_obj.contactURL = '201777';
        payments_obj.PaidAmount = 08;
        paymentsList.add(payments_obj);
        eBc_RequestPaymentMethodApxc.removeRecievedPaymentsApxc(paymentsList);
        eBc_RequestPaymentMethodApxc.resendPendingPaymentApx(paymentsList);
    }
}