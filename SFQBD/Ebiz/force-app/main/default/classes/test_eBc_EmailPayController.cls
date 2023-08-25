@isTest
public class test_eBc_EmailPayController {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        Account acc = StaticMockData.getAccount()[0];
        order od = StaticMockData.getorder()[0];
        eBc_EmailPayController.getSettingsApxc();
        if (acc.id != null) {
            eBc_EmailPayController.getListOfOrdersApxc(acc.id, od.id);
            eBc_EmailPayController.getListOfOrdersApxc(acc.id, null);
            eBc_EmailPayController.getListOfOrdersApxc(null, od.id);
        }
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = uniqueUserName);
        System.runAs(u) {
            Test.startTest();
            testMethod2();
            testMethod3();
            testMethod4();
            testMethod5();
            testMethod6();
            testmehtod7(acc.id);
            Test.stopTest();
        }
    }
    public static void testMethod2() {
        eBc_EmailPayController.getEmailTemplatesApxc();
    }
    public static void testMethod3() {
        eBc_EmailPayController.helperWrapper helper = new eBc_EmailPayController.helperWrapper();
        eBc_EmailPayController.helperWrapper[] helper_bulk = new eBc_EmailPayController.helperWrapper[] {};
        Account act = StaticMockData.getAccount()[0];
        helper.OrderNumber = '234324';
        helper.Id = '2';
        helper.accId = '32';
        helper.accName = 'test account';
        helper.accFirstName = 'test account';
        helper.accLastName = 'test account';
        helper.accExternalId = '1231231312';
        helper.accEmail = 'test@ebizCharge.com';
        helper.ContractId = '23';
        helper.ContractNumber = '23';
        helper.TotalAmount = 23.00;
        helper.AmountDue = 23.00;
        helper.OrderTax = 2.00;
        helper.OrderTax = 2.00;
        helper.emailTemplatelist = new List < eBc_EmailPayController.emailWrapperclass > ();
        eBc_EmailPayController.emailWrapperclass ewp = new eBc_EmailPayController.emailWrapperclass();
        ewp.TemplateName = '';
        ewp.TemplateType = '';
        ewp.TemplateInternalId = '';
        ewp.TemplateSubject = '';
        ewp.FromEmail = '';
        ewp.ReplyToEmail = '';
        helper_bulk.add(helper);
        system.assertEquals('32', helper.accId);
        string emailjson = '{"fromEmail":"test@test.com","toEmail":"test@test.com","Subject":"test","TemplateId":"wer2342343"}';
        eBc_EmailPayController.sendEmailPayReqApxc(emailjson, helper_bulk, act);
    }
    public static void testMethod4() {
        eBc_EmailPayController.getPendingPaymentsApxc('2017-12-09', '2017-12-12');
    }
    @isTest(OnInstall = true)
    public static void test_getPendingPaymentsApxc() {
        try {
            eBc_EmailPayController.getPendingPaymentsApxc(null, null);
        } catch (Exception err) {}
    }
    @isTest(OnInstall = true)
    public static void test_constructor_emailWrapperclass() {
        try {
            eBc_EmailPayController.emailWrapperclass em_obj = new eBc_EmailPayController.emailWrapperclass();
        } catch (Exception err) {}
    }
    public static void testMethod5() {
        eBc_EmailPayController.Payments payments_obj = new eBc_EmailPayController.Payments();
        List < eBc_EmailPayController.Payments > paymentsList = new List < eBc_EmailPayController.Payments > ();
        payments_obj.OrderId = '234';
        payments_obj.CustomerId = '24234';
        payments_obj.CustomerName = 'test';
        payments_obj.DivisionId = '2423432';
        payments_obj.InvoiceNumber = '23423432';
        payments_obj.InvoiceInternalId = '2342342';
        payments_obj.InvoiceDate = '2017-12-12';
        payments_obj.InvoiceDueDate = '2017-12-12';
        payments_obj.PoNum = '123';
        payments_obj.InvoiceAmount = '12.00';
        payments_obj.AmountDue = '0.00';
        payments_obj.AuthCode = '2234424auwweew';
        payments_obj.RefNum = '234234';
        payments_obj.ResendCount = 2;
        payments_obj.Last4 = '08773';
        payments_obj.isSelected = true;
        system.assertEquals(true, payments_obj.isSelected);
        paymentsList.add(payments_obj);
        payments_obj.isSelected = false;
        paymentsList.add(payments_obj);
        eBc_EmailPayController.removePendingPaymentsApxc(paymentsList);
        eBc_EmailPayController.removeRecievedPaymentsApxc(paymentsList);
    }
    public static void testMethod6() {
        DML dml = (DML) MockUtil.createMock(DML.class);
        List < eBc_EmailPayController.Payments > paymentsList = new List < eBc_EmailPayController.Payments > ();
        eBc_EmailPayController.Payments payments_obj = new eBc_EmailPayController.Payments();
        payments_obj.OrderId = '234';
        payments_obj.CustomerId = '24234';
        payments_obj.CustomerName = 'test';
        payments_obj.DivisionId = '2423432';
        payments_obj.InvoiceNumber = '23423432';
        payments_obj.InvoiceInternalId = '2342342';
        payments_obj.InvoiceDate = '2017-12-12';
        payments_obj.InvoiceDueDate = '2017-12-12';
        payments_obj.PoNum = '123';
        payments_obj.InvoiceAmount = '12.00';
        payments_obj.AmountDue = '0.00';
        payments_obj.AuthCode = '2234424auwweew';
        payments_obj.RefNum = '234234';
        payments_obj.Last4 = '08773';
        payments_obj.isSelected = true;
        system.assertEquals(true, payments_obj.isSelected);
        paymentsList.add(payments_obj);
        eBc_EmailPayController.resendPendingPaymentApx(paymentsList);
    }
    public static void testmehtod7(string Accid) {
        date st = Date.today() - 1;
        date en = Date.today();
        eBc_EmailPayController.getReceivedPaymentsApxc(Accid, st, en);
        eBc_EmailPayController.markPaymentAsApplied('123456', '12345678', '12345', '123456', 5000);
        eBc_EmailPayController.Payments p = new eBc_EmailPayController.Payments();
        p.RefNum = '12345';
        p.PaymentInternalId = '12345';
        p.PoNum = '12345';
        p.OrderId = '12345';
        p.PaidAmount = 500;
        List < eBc_EmailPayController.Payments > plist = new List < eBc_EmailPayController.Payments > ();
        plist.add(p);
        eBc_EmailPayController.markAllPaymentsAsApplied(plist);
    }
}