@isTest
public class test_eBc_SyncDownloadController {
    @isTest(OnInstall = true)
    public static void testMethod1() {
        EBizcharge_Setting__c ES = StaticMockData.getEBizcharge_Setting()[0];
        ES.Ebizcharge_Transaction_Last_Sync_Date__c = Datetime.now();
        ES.Ebizcharge_Product_Last_Sync_Date__c = Datetime.now();
        ES.Ebizcharge_Accounts_Last_Sync_Date__c = Datetime.now();
        ES.Ebizcharge_Orders_Last_Sync_Date__c = Datetime.now();
        insert ES;
        Product2 prodtest = StaticMockData.getProduct2()[0];
        PricebookEntry standardPrice = StaticMockData.getPricebookEntry()[0];
        Account acc = StaticMockData.getAccount()[0];
        List < Id > accBulk = new List < Id > ();
        accBulk.add(acc.id);
        order od = StaticMockData.getorder()[0];
        eBc_SyncUploadController.OrderWrapper os = new eBc_SyncUploadController.OrderWrapper();
        os.Id = od.id;
        os.OrderNumber = '23424234232';
        os.CreatedDate = DateTime.now();
        os.EBizChargeId = 'wrwerw32442342';
        os.accId = acc.id;
        os.accExternalId = acc.id;
        os.accName = 'test';
        os.accEmail = 'test@ebiz.com';
        os.TotalAmount = 23.00;
        os.EffectiveDate = date.today();
        os.Status = 'paid';
        os.PaymentStatus = 'paid';
        os.isSelected = true;
        Product2 product = StaticMockData.getProduct2()[0];
        List < Id > ProductBulk = new List < Id > ();
        ProductBulk.add(product.id);
        EBizCharge_Sync_Log__c SyncLog = StaticMockData.getEBizCharge_Sync_Log()[0];
        List < eBc_SyncUploadController.OrderWrapper > osBulk = new List < eBc_SyncUploadController.OrderWrapper > ();
        osBulk.add(os);
        eBc_SyncDownloadController.PaymentWrapper PaymentWrapper = new eBc_SyncDownloadController.PaymentWrapper();
        PaymentWrapper.CustomerId = acc.Id;
        PaymentWrapper.CustomerName = 'test';
        PaymentWrapper.InvoiceNumber = '2342';
        PaymentWrapper.InvoiceInternalId = '23423';
        PaymentWrapper.InvoiceDate = date.today();
        PaymentWrapper.InvoiceDueDate = date.today() + 12;
        PaymentWrapper.PoNum = 'test';
        PaymentWrapper.InvoiceAmount = '12.00';
        PaymentWrapper.AmountDue = '23.00';
        PaymentWrapper.AuthCode = '2343';
        PaymentWrapper.RefNum = '234';
        PaymentWrapper.Last4 = 'test';
        PaymentWrapper.PaymentMethod = 'ACH';
        PaymentWrapper.DatePaid = Datetime.now();
        PaymentWrapper.PaidAmount = '23.00';
        PaymentWrapper.PaymentInternalId = 'test324234';
        PaymentWrapper.CustNum = 'test';
        PaymentWrapper.PaymentMethodId = '1';
        PaymentWrapper.PaymentType = 'ACH';
        PaymentWrapper.TypeId = '44455';
        PaymentWrapper.isSelected = true;
        List < eBc_SyncDownloadController.PaymentWrapper > PaymentBulk = new List < eBc_SyncDownloadController.PaymentWrapper > ();
        PaymentBulk.add(PaymentWrapper);
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = uniqueUserName);
        System.runAs(u) {
            Test.startTest();
            date S_date = date.today() - 2;
            date E_date = date.today() + 2;
            Integer startLimit = 1;
            Integer endLimit = 4;
            String startLimitPayments = '1';
            String endLimitPayments = '4';
            try {
                eBc_SyncDownloadController.getOrdersApxc('{fromDate:20/04/2021,toDate:20/04/2021}', startLimit, endLimit);
            } catch (exception ex) {}
            try {
                eBc_SyncDownloadController.getAccountsApxc('{fromDate:20/04/2021,toDate:20/04/2021}', startLimit, endLimit);
            } catch (exception ex) {}
            try {
                eBc_SyncDownloadController.getAccountsCountApxc();
            } catch (exception ex) {}
            try {
                eBc_SyncDownloadController.getProductsApxc(startLimit, startLimit);
            } catch (exception ex) {}
            try {
                eBc_SyncDownloadController.getPaymentsApxc(startLimitPayments, endLimitPayments);
            } catch (exception ex) {}
            try {
                eBc_SyncDownloadController.getDownloadOrdersApxc('{fromDate:20/04/2021,toDate:20/04/2021}', startLimit, endLimit);
            } catch (exception ex) {}
            try {
                eBc_SyncDownloadController.findProductsApxc('{fromDate:20/04/2021,toDate:20/04/2021}', startLimit, endLimit);
            } catch (exception ex) {}
            try {
                eBc_SyncDownloadController.getAccountsDownloadApxc(startLimit, startLimit);
            } catch (exception ex) {}
            try {
                eBc_SyncDownloadController.findPaymentsApxc('{fromDate:20/04/2021,toDate:20/04/2021}', startLimitPayments, endLimitPayments);
            } catch (exception ex) {}
            eBc_SyncDownloadController.getLogApxc(SyncLog.Name);
            eBc_SyncDownloadController.clearLogApxc('test');
            Test.stopTest();
            eBc_SyncDownloadController.ProductWrapper pw = new eBc_SyncDownloadController.ProductWrapper();
            pw.Id = 'id';
            pw.prodExternalId = '232432423';
            pw.prodCode = 'code';
            pw.prodName = 'name';
            pw.UnitOfMeasure = 'unit';
            pw.prodPrice = 12;
            pw.prodQuantity = 4;
            pw.prodSoftware = 'quantity';
            pw.prodDescription = 'decription';
            pw.prodLastSync = system.now();
            pw.isSelected = true;
            pw.FormatedTransDate = Datetime.now();
            pw.dateTimeTransaction = Datetime.now();
            pw.fromDate = date.today();
            pw.toDate = date.today();
            pw.UpdatedDate = Datetime.now();
            eBc_SyncDownloadController.OrderWrapper ow = new eBc_SyncDownloadController.OrderWrapper();
            ow.Id = 'id';
            ow.OrderNumber = 'onum';
            ow.CreatedDate = system.now().Date();
            ow.EndDate = system.now().Date();
            ow.EBizChargeId = 'chargeId';
            ow.PoNumber = 'ponumber';
            ow.accId = 'acId';
            ow.accExternalId = 'ExId';
            ow.accName = 'accName';
            ow.accEmail = 'accEmail';
            ow.TotalAmount = 12;
            ow.EffectiveDate = system.now().Date();
            ow.DatePaid = String.valueOf(system.now());
            ow.Status = 'status';
            ow.Portal = 'portal';
            ow.PaymentStatus = '';
            ow.isSelected = true;
            ow.EBizChargePaymentStatus = null;
            ow.UpdatedDate = system.now().Date();
            ow.DivisionId = '576878';
            ow.AmountDue = 23;
            ow.AmountPaid = 20;
            ow.Type = 'Test';
            ow.fromDate = date.today() + 12;
            ow.toDate = date.today();
            ow.OrderPayments = null;
            ow.OrditemsList = null;
            List < eBc_SyncDownloadController.OrderWrapper > owList = new List < eBc_SyncDownloadController.OrderWrapper > ();
            owList.add(ow);
            eBc_SyncDownloadController.getUpdatedOrdersApxc(owlist);
            eBc_SyncDownloadController.importOrderApxc(owlist);
            eBc_SyncDownloadController.AccountsData acdata = new eBc_SyncDownloadController.AccountsData();
            acdata.fromDate = date.today() + 12;
            acdata.toDate = date.today();
            acdata.AccountsList = null;
            eBc_SyncDownloadController.AccountWrapper acw = new eBc_SyncDownloadController.AccountWrapper();
            acw.Id = 'id';
            acw.accName = 'acctName';
            acw.accExternalId = '123455';
            acw.accFirstName = 'FirstName';
            acw.accLastName = 'LastName';
            acw.accEmail = 'acctEmail';
            acw.accPhone = '12234324';
            acw.accAmount = 12;
            acw.accLastSync = system.Now().Date();
            acw.isImported = true;
            acw.HyperUrlAccount = '76589';
            acw.accDateTimeCreated = Datetime.now();
            acw.accDateTimeModified = Datetime.now();
            eBc_SyncDownloadController.TransactionsWrapper tw = new eBc_SyncDownloadController.TransactionsWrapper();
            tw.RefNumber = '23423432424';
            tw.OrderNumber = 'test';
            tw.OrderId = 'test';
            tw.CustomerId = 'test';
            tw.AccountName = 'test';
            tw.TransDate = 'test';
            tw.FormatedTransDate = String.valueof(Datetime.now());
            tw.TransTime = 'test';
            tw.Source = 'test';
            tw.TransType = 'test';
            tw.CustNum = 'test';
            tw.AuthCode = 'test';
            tw.AuthAmount = 20;
            tw.Tax = 0.5;
            tw.Result = 'test';
            tw.ResultCode = 'test';
            tw.Error = 'test';
            tw.ErrorCode = 'test';
            tw.Status = 'test';
            tw.StatusCode = 'test';
            tw.DateTime_x = String.valueof(Datetime.now());
            tw.Terminal = 'test';
            tw.CardType = 'test';
            tw.CardNumber = 'test';
            tw.checkAccount = 'test';
            tw.PaymentMethod = 'Card';
            tw.CardClass = 'tset';
            tw.CreatedDate = Datetime.now();
            tw.fromDate = date.today() + 100;
            tw.toDate = date.today();
            tw.RemainingBalance = 09;
            tw.isDuplicate = true;
            tw.ConvertedAmount = 11;
            tw.ConvertedAmountCurrency = '12';
            tw.ConversionRate = 01;
            tw.CardCodeResultCode = '000';
            tw.CardCodeResult = 'test';
            tw.BatchRefNum = '123';
            tw.BatchNum = '999';
            tw.AvsResultCode = '777';
            tw.AvsResult = 'test';
            tw.NonTax = true;
            tw.Table = 'test';
            tw.Subtotal = 4;
            tw.Shipping = 4;
            tw.ShipFromZip = '123';
            tw.PONum = '7666';
            tw.Duty = 4;
            tw.Discount = 4;
            tw.Comments = 'test';
            tw.Description = 'test';
            tw.Currency_x = '23';
            tw.Clerk = 'test';
            tw.Amount = 4;
            tw.AllowPartialAuth = true;
            tw.Tip = 4;
            tw.PayBy = 'test';
            tw.isSelected = true;
            List < eBc_SyncDownloadController.TransactionsWrapper > tranList = new List < eBc_SyncDownloadController.TransactionsWrapper > ();
            tranList.add(tw);
            eBc_SyncDownloadController.getUpdatedPaymentsApxc(tranList);
            eBc_SyncDownloadController.importReceivedPaymentApxc(tranList);
            List < eBc_SyncDownloadController.AccountWrapper > awList = new List < eBc_SyncDownloadController.AccountWrapper > ();
            awList.add(acw);
            eBc_SyncDownloadController.getUpdatedAccountsApxc(awList, awList, ES);
            eBc_SyncDownloadController.importAccountApxc(awList);
            List < eBc_SyncDownloadController.ProductWrapper > pwList = new List < eBc_SyncDownloadController.ProductWrapper > ();
            pwList.add(pw);
            eBc_SyncDownloadController.getUpdatedProductsApxc(pwList);
            eBc_SyncDownloadController.importProductApxc(pwList);
        }
    }
}