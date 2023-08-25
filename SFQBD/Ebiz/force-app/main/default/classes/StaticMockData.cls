public with sharing class StaticMockData {
    public StaticMockData() {}
    public static list < sObject > getObjectRecord(String query_from) {
        list < sObject > ls = new list < sObject > ();
        list < String > s = query_from.toLowercase().split('from');
        String from_objectName = s[1].trim();
        if (from_objectName == 'account') {
            ls = getAccount();
        }
        if (from_objectName == 'recordtype') {
            ls = getRecordType();
        } else if (from_objectName == 'opportunity') {
            ls = getOpportunity();
        } else if (from_objectName == 'contact') {
            ls = getContact();
        } else if (from_objectName == 'order') {
            ls = getOrder();
        } else if (from_objectName == 'orderitem') {
            ls = getOrderItem();
        } else if (from_objectName == 'quote') {
            ls = getQuote();
        } else if (from_objectName == 'quotelineitem') {
            ls = getQuoteLineItem();
        } else if (from_objectName == 'opportunitylineitem') {
            ls = getOpportunityLineItem();
        } else if (from_objectName == 'product2') {
            ls = getProduct2();
        } else if (from_objectName == 'pricebook2') {
            ls = getPricebook2();
        } else if (from_objectName == 'pricebookentry') {
            ls = getPricebookEntry();
        } else if (from_objectName == 'Ebiz_C__ebiz_object_config__c' || from_objectName == 'ebiz_object_config__c') {
            ls = getEBiz_Object_Config();
        } else if (from_objectName == 'Ebiz_C__ebizcharge_transaction__c' || from_objectName == 'ebizcharge_transaction__c') {
            ls = getEBizCharge_Transaction();
        } else if (from_objectName == 'Ebiz_C__ebizcharge_fields_config__c' || from_objectName == 'ebizcharge_fields_config__c') {
            ls = getEBizCharge_Fields_Config();
        } else if (from_objectName == 'Ebiz_C__ebizcharge_sync_log__c' || from_objectName == 'ebizcharge_sync_log__c') {
            ls = getEBizCharge_Sync_Log();
        } else if (from_objectName == 'Ebiz_C__ebizcharge_setting__c' || from_objectName == 'ebizcharge_setting__c') {
            ls = getEBizcharge_Setting();
        }
        return ls;
    }
    public static List < Account > getAccount() {
        List < Account > ls = new List < Account > ();
        Schema.DescribeSObjectResult r = Account.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            Account obj = new Account();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            obj.name = 'test' + i;
            obj.Description = 'test' + i;
            obj.First_Name__c = 'test' + i;
            obj.Last_Name__c = 'test' + i;
            obj.EBizCharge_Internal_ID__c = '123455';
            obj.EBizCharge_Email__c = i + 'test1@ebzi.com';
            ls.add(obj);
        }
        return ls;
    }
    public static List < RecordType > getRecordType() {
        List < RecordType > ls = new List < RecordType > ();
        String keyPrefix = '012';
        for (Integer i = 0; i < 4; i++) {
            RecordType obj = new RecordType();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            obj.name = 'test' + i;
            ls.add(obj);
        }
        return ls;
    }
    public static List < Opportunity > getOpportunity() {
        List < Opportunity > ls = new List < Opportunity > ();
        Schema.DescribeSObjectResult r = Opportunity.sObjectType.getDescribe();
        List < Pricebook2 > Pricebook2ls = getPricebook2();
        String keyPrefix = r.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            Opportunity obj = new Opportunity();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            obj.name = 'test' + i;
            obj.StageName = 'test';
            obj.CloseDate = date.today();
            obj.Pricebook2 = Pricebook2ls.get(i);
            ls.add(obj);
        }
        return ls;
    }
    public static List < Contact > getContact() {
        List < Contact > ls = new List < Contact > ();
        Schema.DescribeSObjectResult r = Contact.sObjectType.getDescribe();
        List < Account > accountls = getAccount();
        String keyPrefix = r.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            Contact obj = new Contact();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            obj.phone = '03333333' + i;
            obj.account = accountls.get(i);
            obj.Ebiz_C__EBizCharge_Contact_Internal_ID__c = '123';
            obj.Ebiz_C__EBizCharge_Contact_Amount__c = 0;
            ls.add(obj);
        }
        return ls;
    }
    public static List < Order > getOrder() {
        List < Order > ls = new List < Order > ();
        Schema.DescribeSObjectResult r = Order.sObjectType.getDescribe();
        List < Account > accountls = getAccount();
        List < Pricebook2 > Pricebook2ls = getPricebook2();
        String keyPrefix = r.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            Order obj = new Order();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            obj.account = accountls.get(i);
            obj.EffectiveDate = Date.today();
            obj.Status = 'Draft';
            obj.EBizCharge_Order_Status__c = 'UnpaidPaid';
            obj.EBizCharge_Order_Balance__c = 12.00;
            obj.EBizCharge_Reference_Number__c = '2345678' + i;
            obj.Pricebook2 = Pricebook2ls.get(i);
            ls.add(obj);
        }
        return ls;
    }
    public static List < OrderItem > getOrderItem() {
        List < OrderItem > ls = new List < OrderItem > ();
        Schema.DescribeSObjectResult r = OrderItem.sObjectType.getDescribe();
        List < Order > Orderls = getOrder();
        List < Product2 > Product2ls = getProduct2();
        List < PricebookEntry > PricebookEntryls = getPricebookEntry();
        String keyPrefix = r.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            OrderItem obj = new OrderItem();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            obj.Order = Orderls.get(i);
            obj.Quantity = 24;
            obj.UnitPrice = 240;
            obj.Product2 = Product2ls.get(i);
            obj.PricebookEntry = PricebookEntryls.get(i);
            ls.add(obj);
        }
        return ls;
    }
    public static List < Quote > getQuote() {
        List < Quote > ls = new List < Quote > ();
        Schema.DescribeSObjectResult r = Quote.sObjectType.getDescribe();
        List < Opportunity > Opportunityls = getOpportunity();
        List < Pricebook2 > Pricebook2ls = getPricebook2();
        String keyPrefix = r.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            Quote obj = new Quote();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            obj.name = 'Test Quote';
            obj.Opportunity = Opportunityls.get(i);
            obj.Status = 'Draft';
            obj.EBizCharge_Quote_Balance__c = 10;
            obj.EBizCharge_Reference_Number__c = '2345678' + i;
            obj.Pricebook2 = Pricebook2ls.get(i);
            ls.add(obj);
        }
        return ls;
    }
    public static List < QuoteLineItem > getQuoteLineItem() {
        List < QuoteLineItem > ls = new List < QuoteLineItem > ();
        Schema.DescribeSObjectResult r = QuoteLineItem.sObjectType.getDescribe();
        List < Quote > Quotels = getQuote();
        List < Product2 > Product2ls = getProduct2();
        List < PricebookEntry > PricebookEntryls = getPricebookEntry();
        String keyPrefix = r.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            QuoteLineItem obj = new QuoteLineItem();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            obj.Quote = Quotels.get(i);
            obj.Product2 = Product2ls.get(i);
            obj.Quantity = 24;
            obj.UnitPrice = 240;
            obj.PricebookEntry = PricebookEntryls.get(i);
            ls.add(obj);
        }
        return ls;
    }
    public static List < OpportunityLineItem > getOpportunityLineItem() {
        List < OpportunityLineItem > ls = new List < OpportunityLineItem > ();
        Schema.DescribeSObjectResult r = OpportunityLineItem.sObjectType.getDescribe();
        List < Opportunity > Opportunityls = getOpportunity();
        List < Product2 > Product2ls = getProduct2();
        List < PricebookEntry > PricebookEntryls = getPricebookEntry();
        String keyPrefix = r.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            OpportunityLineItem obj = new OpportunityLineItem();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            obj.Opportunity = Opportunityls.get(i);
            obj.Product2 = Product2ls.get(i);
            obj.Quantity = 24;
            obj.UnitPrice = 240;
            obj.PricebookEntry = PricebookEntryls.get(i);
            ls.add(obj);
        }
        return ls;
    }
    public static List < Product2 > getProduct2() {
        List < Product2 > ls = new List < Product2 > ();
        Schema.DescribeSObjectResult r = Product2.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            Product2 obj = new Product2();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            obj.Name = 'Test Product' + i;
            obj.Description = 'Test Product Entry 1';
            obj.productCode = 'ABC' + i;
            obj.isActive = true;
            obj.EBizCharge_Internal_ID__c = '232432423';
            obj.EBizCharge_Last_Sync_Date__c = date.today() - 10;
            ls.add(obj);
        }
        return ls;
    }
    public static List < Pricebook2 > getPricebook2() {
        List < Pricebook2 > ls = new List < Pricebook2 > ();
        Schema.DescribeSObjectResult r = Pricebook2.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            Pricebook2 obj = new Pricebook2();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            ls.add(obj);
        }
        return ls;
    }
    public static List < PricebookEntry > getPricebookEntry() {
        List < PricebookEntry > ls = new List < PricebookEntry > ();
        Schema.DescribeSObjectResult r = PricebookEntry.sObjectType.getDescribe();
        List < Product2 > Product2ls = getProduct2();
        List < Pricebook2 > Pricebook2ls = getPricebook2();
        String keyPrefix = r.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            PricebookEntry obj = new PricebookEntry();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            obj.Pricebook2 = Pricebook2ls.get(i);
            obj.Product2 = Product2ls.get(i);
            obj.UnitPrice = 1;
            obj.IsActive = true;
            obj.UseStandardPrice = false;
            ls.add(obj);
        }
        return ls;
    }
    public static List < Ebiz_C__EBiz_Object_Config__c > getEBiz_Object_Config() {
        List < Ebiz_C__EBiz_Object_Config__c > ls = new List < Ebiz_C__EBiz_Object_Config__c > ();
        Schema.DescribeSObjectResult r = Ebiz_C__EBiz_Object_Config__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            Ebiz_C__EBiz_Object_Config__c obj = new Ebiz_C__EBiz_Object_Config__c();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            ls.add(obj);
        }
        return ls;
    }
    public static List < EBizCharge_Transaction__c > getEBizCharge_Transaction() {
        List < EBizCharge_Transaction__c > ls = new List < EBizCharge_Transaction__c > ();
        Schema.DescribeSObjectResult r = EBizCharge_Transaction__c.sObjectType.getDescribe();
        Schema.DescribeSObjectResult contactDetail = Contact.sObjectType.getDescribe();
        Schema.DescribeSObjectResult fieldsConfigDetail = Ebiz_C__EBizCharge_Fields_Config__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        String contactkeyPrefix = contactDetail.getKeyPrefix();
        String fieldsConfigkeyPrefix = fieldsConfigDetail.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            EBizCharge_Transaction__c obj = new EBizCharge_Transaction__c();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            obj.Transaction_Type__c = 'refund';
            obj.Ref_Number__c = '23423432424';
            obj.Ebiz_C__Non_Tax__c = true;
            obj.Ebiz_C__EBizCharge_Fields_Id__c = fieldsConfigkeyPrefix + 'F00001GLIrjQAH' + i;
            obj.Ebiz_C__Contact_Id__c = contactkeyPrefix + 'F00001GLIrjQAH' + i;
            ls.add(obj);
        }
        return ls;
    }
    public static List < Ebiz_C__EBizCharge_Fields_Config__c > getEBizCharge_Fields_Config() {
        List < Ebiz_C__EBizCharge_Fields_Config__c > ls = new List < Ebiz_C__EBizCharge_Fields_Config__c > ();
        Schema.DescribeSObjectResult r = Ebiz_C__EBizCharge_Fields_Config__c.sObjectType.getDescribe();
        Schema.DescribeSObjectResult accountDetail = Account.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        String accountkeyPrefix = accountDetail.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            Ebiz_C__EBizCharge_Fields_Config__c obj = new Ebiz_C__EBizCharge_Fields_Config__c();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            obj.Ebiz_C__EBizCharge_Amount__c = 12.08;
            obj.Ebiz_C__EBizCharge_Amount_Source__c = 12.08;
            obj.Ebiz_C__EBizCharge_CustomerId__c = accountkeyPrefix + 'F00001GLIrjQAH' + i;
            obj.Ebiz_C__EBizCharge_Reference_Number__c = '23423423';
            obj.Ebiz_C__EBizCharge_Internal_ID__c = '123';
            obj.Name = 'test';
            ls.add(obj);
        }
        return ls;
    }
    public static List < EBizCharge_Sync_Log__c > getEBizCharge_Sync_Log() {
        List < EBizCharge_Sync_Log__c > ls = new List < EBizCharge_Sync_Log__c > ();
        Schema.DescribeSObjectResult r = EBizCharge_Sync_Log__c.sObjectType.getDescribe();
        List < Account > Accountls = getAccount();
        List < Order > Orderls = getOrder();
        List < Product2 > Product2ls = getProduct2();
        String keyPrefix = r.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            EBizCharge_Sync_Log__c obj = new EBizCharge_Sync_Log__c();
            obj.Id = keyPrefix + 'F00001GLIrjQAH' + i;
            obj.Name = 'BulkLog';
            obj.Account_Id__c = Accountls.get(i).id;
            obj.Account_Name__c = 'test Account';
            obj.Amount__c = 23.0;
            obj.Balance__c = 23.00;
            obj.First_Name__c = 'test';
            obj.Last_Name__c = 'test';
            obj.Email__c = 'test@ebiz.com';
            obj.Message__c = 'test';
            obj.Order_Date__c = date.today() - 2;
            obj.Order_Id__c = Orderls.get(i).id;
            obj.Order_Number__c = '23423423';
            obj.Phone__c = '09899232332';
            obj.Product_Id__c = Product2ls.get(i).id;
            obj.Product_Code__c = '234234';
            obj.Product_Name__c = 'test';
            obj.Quantity__c = 2.00;
            obj.Upload_Date_Time__c = datetime.now();
            obj.Description__c = 'test';
            obj.Type__c = 'Download';
            ls.add(obj);
        }
        return ls;
    }
    public static List < EBizcharge_Setting__c > getEBizcharge_Setting() {
        List < EBizcharge_Setting__c > ls = new List < EBizcharge_Setting__c > ();
        Schema.DescribeSObjectResult r = EBizcharge_Setting__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        for (Integer i = 0; i < 4; i++) {
            Integer len = 10; //fake id
            Blob blobKey = crypto.generateAesKey(128);
            String key = EncodingUtil.convertToHex(blobKey);
            String reg = key.substring(0, len);
            //Mock Data
            EBizcharge_Setting__c ES = new EBizcharge_Setting__c();
            ES.Security_Token__c = reg;
            ES.User_Name__c = 'test-1';
            ES.Password__c = '123';
            ES.Transaction_Filter_By__c = 'Today';
            ES.Email_Pending_Req_Filter_By__c = 'Today';
            ES.Sync_Orders_Filter_By__c = 'Today';
            ES.Sync_Accounts_Filter_By__c = 'Today';
            ES.Sync_Products_Filter_By__c = 'Today';
            ES.Tax_Action__c = 'Today';
            ES.Auto_Upload_Order__c = true;
            ES.Auto_Upload_Opportunity__c = true;
            ES.Auto_Upload_Quote__c = true;
            ES.Tax_Calculate_By__c = 'Auto';
            ES.Tax_Manual_Type__c = 'Use Percent';
            ES.Tax_Default_Percent__c = 1;
            ES.Component_Label__c = 'test';
            ES.Tax_Action__c = 'Tax Included';
            ES.Component_Label__c = 'test';
            ls.add(ES);
        }
        return ls;
    }
}