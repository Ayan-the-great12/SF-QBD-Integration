@isTest
public class test_eBc_SyncUploadController {
    @isTest(OnInstall = true)
    public static void test_contructor_OrderWrapper_ContactWrapper() {
        eBc_SyncUploadController.OrderWrapper ow = new eBc_SyncUploadController.OrderWrapper();
        ow.EBizChargePaymentStatus = null;
        eBc_SyncUploadController.ContactWrapper cw = new eBc_SyncUploadController.ContactWrapper();
        cw.Id = null;
        cw.conName = null;
        cw.HyperUrlContact = null;
        cw.conExternalId = null;
        cw.conFirstName = null;
        cw.conLastName = null;
        cw.conEmail = null;
        cw.conPhone = null;
        cw.conAmount = null;
        cw.conLastSync = null;
        cw.isSelected = null;
    }
    @isTest(OnInstall = true)
    public static void test_syncOrdersGwApxc() {
        Account acc = StaticMockData.getAccount()[0];
        if (!Schema.sObjectType.Account.fields.getMap().containsKey('isPersonAccount')) {
            acc.Name = 'test1@ebzi.com'; //conditioned by @wqkl against Person Account Issues - (14jan21)
        }
        Product2 product = StaticMockData.getProduct2()[0];
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = StaticMockData.getPricebookEntry()[0];
        Order od = StaticMockData.getOrder()[0];
        OrderItem i = StaticMockData.getOrderItem()[0];
        eBc_SyncUploadController.OrderWrapper os = new eBc_SyncUploadController.OrderWrapper();
        os.Id = od.id;
        os.OrderNumber = '23424234232';
        os.CreatedDate = DateTime.now();
        os.EBizChargeId = '';
        os.accId = acc.id;
        os.accExternalId = acc.id;
        os.accName = 'test';
        os.accEmail = 'test@ebiz.com';
        os.TotalAmount = 23.00;
        os.EffectiveDate = date.today();
        os.Status = 'paid';
        os.PaymentStatus = 'paid';
        os.isSelected = true;
        List < OrderItem > loi = new List < OrderItem > ();
        loi.add(i);
        os.OrditemsList = loi;
        List < eBc_SyncUploadController.OrderWrapper > osBulk = new List < eBc_SyncUploadController.OrderWrapper > ();
        osBulk.add(os);
        try {
            eBc_SyncUploadController.syncOrdersGwApxc(osBulk);
        } catch (exception err) {}
    }
    @isTest(OnInstall = true)
    public static void test_getSettingsApxc() {
        eBc_SyncUploadController.getSettingsApxc();
    }
    @isTest(OnInstall = true)
    public static void testMethod1() {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EBizcharge_Setting__c ES = StaticMockData.getEBizcharge_Setting()[0];
        Account acc = StaticMockData.getAccount()[0];
        if (!Schema.sObjectType.Account.fields.getMap().containsKey('isPersonAccount')) {
            acc.Name = 'test1@ebzi.com'; //conditioned by @wqkl against Person Account Issues - (14jan21)
        }
        Contact Con = StaticMockData.getContact()[0];
        List < Id > accBulk = new List < Id > ();
        accBulk.add(acc.id);
        Account temp_acc = StaticMockData.getAccount()[0];
        if (!Schema.sObjectType.Account.fields.getMap().containsKey('isPersonAccount')) {
            temp_acc.Name = 'test1@ebzi.com'; //conditioned by @wqkl against Person Account Issues - (14jan21)
        }
        List < Id > temp_accBulk = new List < Id > ();
        temp_accBulk.add(temp_acc.id);
        List < Id > conBulk = new List < Id > ();
        conBulk.add(Con.id);
        Product2 product = StaticMockData.getProduct2()[0];
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = StaticMockData.getPricebookEntry()[0];
        Order od = StaticMockData.getOrder()[0];
        OrderItem i = StaticMockData.getOrderItem()[0];
        eBc_SyncUploadController.ContactWrapper conWrapper = new eBc_SyncUploadController.ContactWrapper();
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
        List < OrderItem > loi = new List < OrderItem > ();
        loi.add(i);
        os.OrditemsList = loi;
        List < Id > ProductBulk = new List < Id > ();
        ProductBulk.add(product.id);
        EBizCharge_Sync_Log__c SyncLog = StaticMockData.getEBizCharge_Sync_Log()[0];
        List < eBc_SyncUploadController.OrderWrapper > osBulk = new List < eBc_SyncUploadController.OrderWrapper > ();
        osBulk.add(os);
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = uniqueUserName);
        System.runAs(u) {
            Test.startTest();
            date S_date = date.today() - 2;
            date E_date = date.today() + 2;
            ES.Sync_Accounts_Filter_By__c = '';
            try {
                eBc_SyncUploadController.getAllAccountsApxc(null, null);
            } catch (exception err) {}
            try {
                eBc_SyncUploadController.getAllContactApxc(null, null);
            } catch (exception err) {}
            try {
                eBc_SyncUploadController.getAllProductsApxc(null, null);
            } catch (exception err) {}
            ES.Sync_Accounts_Filter_By__c = 'Past Week';
            try {
                eBc_SyncUploadController.getAllAccountsApxc(null, null);
            } catch (exception err) {}
            try {
                eBc_SyncUploadController.getAllContactApxc(null, null);
            } catch (exception err) {}
            ES.Sync_Accounts_Filter_By__c = 'Today';
            try {
                eBc_SyncUploadController.getAllAccountsApxc(date.today() - 1, date.today() - 2);
            } catch (exception err) {}
            eBc_SyncUploadController.getAllAccountsApxc(null, null);
            eBc_SyncUploadController.getAllContactApxc(null, null);
            try {
                eBc_SyncUploadController.getAllContactApxc(date.today() - 1, date.today() - 2);
            } catch (exception err) {}
            ES.Sync_Accounts_Filter_By__c = 'Past Month';
            eBc_SyncUploadController.getAllAccountsApxc(null, null);
            eBc_SyncUploadController.getAllContactApxc(null, null);
            ES.Sync_Accounts_Filter_By__c = 'Past Year';
            eBc_SyncUploadController.getAllAccountsApxc(null, null);
            eBc_SyncUploadController.getAllContactApxc(null, null);
            eBc_SyncUploadController.syncAccountsGwApxc(accBulk);
            try {
                eBc_SyncUploadController.syncAccountsGwApxc(temp_accBulk);
            } catch (exception err) {}
            eBc_SyncUploadController.syncContactGwApxc(conBulk);
            eBc_SyncUploadController.syncProductsGwApxc(ProductBulk);
            eBc_SyncUploadController.getLogApxc(SyncLog.Name);
            Test.stopTest();
            eBc_SyncUploadController.syncOrdersGwApxc(osBulk);
            date fromDate = system.Now().Date();
            date toDate = system.Now().Date().addDays(1);
            eBc_SyncUploadController.getAllProductsApxc(fromDate, toDate);
            ES.Sync_Products_Filter_By__c = 'Today';
            try {
                eBc_SyncUploadController.getAllProductsApxc(null, null);
            } catch (exception err) {}
            ES.Sync_Products_Filter_By__c = '';
            try {
                eBc_SyncUploadController.getAllProductsApxc(null, null);
            } catch (exception err) {}
            ES.Sync_Products_Filter_By__c = 'Past Week';
            eBc_SyncUploadController.getAllProductsApxc(null, null);
            ES.Sync_Products_Filter_By__c = 'Past Month';
            eBc_SyncUploadController.getAllProductsApxc(null, null);
            ES.Sync_Products_Filter_By__c = 'Past Year';
            eBc_SyncUploadController.getAllProductsApxc(null, null);
            eBc_SyncUploadController.getAllProductsApxc(fromDate, toDate);
            eBc_SyncUploadController.getAllProductsApxc(null, null);
            eBc_SyncUploadController.getAllOrdersApxc(acc.Id, od.Id, fromDate, toDate);
            eBc_SyncUploadController.getAllOrdersApxc(acc.Id, null, fromDate, toDate);
            eBc_SyncUploadController.getAllOrdersApxc(null, od.Id, fromDate, toDate);
            eBc_SyncUploadController.getAllOrdersApxc(null, null, fromDate, toDate);
            eBc_SyncUploadController.getAllOrdersApxc(acc.Id, od.Id, null, null);
            eBc_SyncUploadController.getAllOrdersApxc(acc.Id, null, null, null);
            eBc_SyncUploadController.getAllOrdersApxc(null, od.Id, null, null);
            eBc_SyncUploadController.getAllOrdersApxc(null, null, null, null);
        }
    }
    @isTest(OnInstall = true)
    public static void clearlogMethod() {
        Account acc = StaticMockData.getAccount()[0];
        List < Id > accBulk = new List < Id > ();
        accBulk.add(acc.id);
        Order od = StaticMockData.getOrder()[0];
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
        try {
            eBc_SyncUploadController.getLogApxcContact(SyncLog.Name);
        } catch (exception err) {}
        eBc_SyncUploadController.clearLogApxc('BulkLog');
        eBc_SyncUploadController.ProductWrapper pw = new eBc_SyncUploadController.ProductWrapper();
        pw.Id = 'id';
        pw.HyperUrlProduct = 'testProd';
        pw.prodExternalId = 'Exid';
        pw.prodCode = 'code';
        pw.prodName = 'name';
        pw.prodPrice = 'price';
        pw.prodQuantity = 'quantity';
        pw.prodDescription = 'decription';
        pw.prodLastSync = system.now();
        pw.isSelected = true;
    }
}