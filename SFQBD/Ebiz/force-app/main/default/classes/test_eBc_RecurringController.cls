@isTest
public class test_eBc_RecurringController {
    @isTest(OnInstall = true)
    static void test_constructor_recurring() {
        eBc_RecurringController.Recurring rr = new eBc_RecurringController.Recurring();
        rr.accId = '';
        rr.accName = '';
        rr.accExtId = '';
        rr.rrPaymentIntId = '';
        rr.rrScheduleName = '';
        rr.rrScheduleStart = null;
        rr.rrScheduleEnd = null;
        rr.rrDateTimeCreated = null;
        rr.rrSchedule = null;
        rr.rrAmount = null;
        rr.rrTax = null;
        rr.rrNote = null;
        rr.rrObj = null;
        rr.rrMaskedPM = null;
        rr.rrPMType = null;
        rr.rrScheduleStatus = null;
        rr.rrPaymentMethodId = null;
        rr.RecurringHyperUrl = null;
        rr.isSelected = null;
    }
    @isTest(OnInstall = true)
    static void test_constructor_Detail() {
        eBc_RecurringController.Detail dt = new eBc_RecurringController.Detail();
        dt.TransInfo = null;
        dt.Settings = null;
    }
    @isTest(OnInstall = true)
    static void testMethod1() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Date s = Date.newInstance(2016, 12, 9);
        Date e = Date.newInstance(2016, 12, 9);
        Account ac = StaticMockData.getAccount()[0];
        String AccountID = ac.Id;
        Contact cont = StaticMockData.getContact()[0];
        order od = StaticMockData.getorder()[0];
        Opportunity opp = StaticMockData.getOpportunity()[0];
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        string UseExistingCard = '{"payBy":"UseExistingCard","selectedCard":"23424","CVC":"232","rrStartDate":"2020-12-12","rrEndDate":"2020-12-14"}';
        eBc_RecurringController.runRecurringApxc(UseExistingCard, 'Update');
        string UseExistingCard2 = '{"payBy":"AddNewCard","selectedCard":"23424","CVC":"232","rrStartDate":"2020-12-12","rrEndDate":"2020-12-14"}';
        eBc_RecurringController.runRecurringApxc(UseExistingCard2, 'Update');
        string AddNewCard = '{"isAVSCheck": true, "payBy":"AddNewCard","CardNumber":"23424","expiryYear":"2020","CVC":"232","CardHolderName":"test","BillingAddress":"test abc","ZipCode":"9843","saveCard":true,"expiryMonth":"12","rrStartDate":"2020-12-12","rrEndDate":"2020-12-14"}';
        eBc_RecurringController.runRecurringApxc(AddNewCard, 'Update');
        string AddNewCard3 = '{"isAVSCheck": true, "payBy":"NewACH","CardNumber":"23424","expiryYear":"2020","CVC":"232","CardHolderName":"test","BillingAddress":"test abc","ZipCode":"9843","saveCard":true,"expiryMonth":"12","rrStartDate":"2020-12-12","rrEndDate":"2020-12-14"}';
        eBc_RecurringController.getScheduledRecurringApxc(AccountID, 'All');
        try {
            eBc_RecurringController.getScheduledRecurringApxc(cont.Id, 'All');
        } catch (exception err) {}
        eBc_RecurringController.recurringWrapper wrapper = new eBc_RecurringController.recurringWrapper();
        eBc_RecurringController.getSettingsApxc();
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        test.startTest();
        eBc_RecurringController.ReceivedRRPaymentsApxc(AccountID, system.now().date().addDays(-1), system.now().date());
        try {
            eBc_RecurringController.ReceivedRRPaymentsApxc(cont.Id, system.now().date().addDays(-1), system.now().date());
        } catch (exception err) {}
        eBc_RecurringController.getAccountDetailApxc(AccountID);
        eBc_RecurringController.getSavedCardsApxc(AccountID, 'accExtId');
        eBc_RecurringController.updScheduledRRStatusApxc('recIntenalId', 1);
        eBc_RecurringController.ReceivedRRPaymentsApxc(null, null, null);
        eBc_RecurringController.getDetailApxc(ac.Id, 'Account');
        try {
            eBc_RecurringController.getDetailApxc(od.Id, 'Order');
        } catch (exception err) {}
        try {
            eBc_RecurringController.getDetailApxc(opp.Id, 'Opportunity');
        } catch (exception err) {}
        eBc_RecurringController.markRRPaymentAsApplied('PaymentInternalId', AccountID, 'RefNumber', 1);
        try {
            eBc_RecurringController.markRRPaymentAsApplied('PaymentInternalId', cont.Id, 'RefNumber', 1);
        } catch (exception err) {}
        eBc_RecurringController.invokeTransactionVoidApxc('avsRefNum');
        try {
            eBc_RecurringController.getAccountDetailApxc(cont.Id);
        } catch (exception err) {}
        try {
            eBc_RecurringController.getRecurringSchedulePreview('1900-01-01', '2021-01-01', 'daily');
        } catch (exception err) {}
        try {
            eBc_RecurringController.autoSyncAccountApxc('acid');
        } catch (exception err) {}
        test.stopTest();
    }
}