public with sharing class MockData {
    public static Account GenrateDataAccount() {
        String obj = 'Account';
        Map < String, Schema.SObjectType > gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(obj);
        Schema.DescribeSObjectResult GetFields = sobjType.getDescribe();
        Map < String, Schema.SObjectField > fieldsMap = GetFields.fields.getMap();
        Map < String, String > AccountFields = new Map < String, String > ();
        Account acc_Object = new Account();
        SObject sobj = acc_Object;
        for (String fMap: fieldsMap.keySet()) {
            Schema.SObjectField field = fieldsMap.get(fMap);
            Schema.DisplayType FldType = field.getDescribe().getType();
            Schema.DescribeFieldResult describeResult = fieldsMap.get(fMap).getDescribe();
            if (describeResult.isCreateable() && !describeResult.isNillable() && !describeResult.isDefaultedOnCreate()) {
                sobj.put(fMap, GenrateDataTypesValues(FldType, fMap, obj));
            }
            // added by @wqkl against Person Account issue fix - (08jan21) - start
            if (fMap == 'recordtypeid' && Schema.sObjectType.Account.fields.getMap().containsKey('isPersonAccount')) {
                sobj.put(fMap, Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId());
            }
            if (fMap == 'lastname' && Schema.sObjectType.Account.fields.getMap().containsKey('isPersonAccount')) {
                sobj.put(fMap, 'Test');
            }
            // added by @wqkl against Person Account issue fix - (08jan21) - end
        }
        Account update_Acc = (Account) sobj;
        Insert update_Acc;
        return update_Acc;
    }
    public static Opportunity GenrateDataOpp(Id accID) {
        String obj = 'Opportunity';
        Map < String, Schema.SObjectType > gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(obj);
        Schema.DescribeSObjectResult GetFields = sobjType.getDescribe();
        Map < String, Schema.SObjectField > fieldsMap = GetFields.fields.getMap();
        Map < String, String > AccountFields = new Map < String, String > ();
        Opportunity Opportunity_Object = new Opportunity();
        Opportunity_Object.AccountId = accID;
        SObject sobj = Opportunity_Object;
        for (String fMap: fieldsMap.keySet()) {
            Schema.SObjectField field = fieldsMap.get(fMap);
            Schema.DisplayType FldType = field.getDescribe().getType();
            Schema.DescribeFieldResult describeResult = fieldsMap.get(fMap).getDescribe();
            if (describeResult.isCreateable() && !describeResult.isNillable() && !describeResult.isDefaultedOnCreate()) {
                sobj.put(fMap, GenrateDataTypesValues(FldType, fMap, obj));
            }
        }
        Opportunity update_Opportunity = (Opportunity) sobj;
        Insert update_Opportunity;
        return update_Opportunity;
    }
    public static Contact GenrateDataContact() {
        String obj = 'Contact';
        Map < String, Schema.SObjectType > gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(obj);
        Schema.DescribeSObjectResult GetFields = sobjType.getDescribe();
        Map < String, Schema.SObjectField > fieldsMap = GetFields.fields.getMap();
        Map < String, String > AccountFields = new Map < String, String > ();
        Contact Contact_Object = new Contact();
        SObject sobj = Contact_Object;
        for (String fMap: fieldsMap.keySet()) {
            Schema.SObjectField field = fieldsMap.get(fMap);
            Schema.DisplayType FldType = field.getDescribe().getType();
            Schema.DescribeFieldResult describeResult = fieldsMap.get(fMap).getDescribe();
            if (describeResult.isCreateable() && !describeResult.isNillable() && !describeResult.isDefaultedOnCreate()) {
                sobj.put(fMap, GenrateDataTypesValues(FldType, fMap, obj));
            }
        }
        Contact update_Contact = (Contact) sobj;
        Insert update_Contact;
        return update_Contact;
    }
    public static Order GenrateDataOrder() {
        String obj = 'Order';
        Map < String, Schema.SObjectType > gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(obj);
        Schema.DescribeSObjectResult GetFields = sobjType.getDescribe();
        Map < String, Schema.SObjectField > fieldsMap = GetFields.fields.getMap();
        Map < String, String > AccountFields = new Map < String, String > ();
        Order Contact_Object = new Order();
        SObject sobj = Contact_Object;
        for (String fMap: fieldsMap.keySet()) {
            Schema.SObjectField field = fieldsMap.get(fMap);
            Schema.DisplayType FldType = field.getDescribe().getType();
            Schema.DescribeFieldResult describeResult = fieldsMap.get(fMap).getDescribe();
            if (describeResult.isCreateable() && !describeResult.isNillable() && !describeResult.isDefaultedOnCreate()) {
                sobj.put(fMap, GenrateDataTypesValues(FldType, fMap, obj));
            }
        }
        Order Order_Contact = (Order) sobj;
        //Insert Order_Contact;
        return Order_Contact;
    }
    public static Object GenrateDataTypesValues(Schema.DisplayType parms, String FieldName, String Obj) {
        if (parms == Schema.DisplayType.TextArea) {
            return 'Test';
        }
        if (parms == Schema.DisplayType.STRING) {
            return 'Test';
        }
        if (parms == Schema.DisplayType.Double) {
            return 10.10;
        }
        if (parms == Schema.DisplayType.Date) {
            return Date.newInstance(2016, 12, 9);
        }
        if (parms == Schema.DisplayType.DateTime) {
            return System.today() + 5;
        }
        if (parms == Schema.DisplayType.Time) {
            return Time.newInstance(2, 23, 33, 1602);
        }
        if (parms == Schema.DisplayType.Email) {
            return 'test@test.com';
        }
        if (parms == Schema.DisplayType.PERCENT) {
            return 0.3;
        }
        if (parms == Schema.DisplayType.Phone) {
            return '0323233223';
        }
        if (parms == Schema.DisplayType.Integer) {
            return 0323223;
        }
        if (parms == Schema.DisplayType.Currency) {
            Decimal dc = 23.00;
            return dc;
        }
        if (parms == Schema.DisplayType.URL) {
            return 'www.salesforce.com';
        }
        if (parms == Schema.DisplayType.Picklist) {
            return getPickListValuesIntoList(Obj, FieldName);
        }
        if (parms == Schema.DisplayType.Long) {
            long dc = 2300;
            return dc;
        }
        if (parms == Schema.DisplayType.LOCATION) {
            return Location.newInstance(0.00, 0.00);
        }
        if (parms == Schema.DisplayType.ENCRYPTEDSTRING) {
            //Data to encrypt
            Blob data = Blob.valueOf('B');
            Blob cryptoValue = Crypto.generateAesKey(256);
            Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoValue, data);
            Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoValue, encryptedData);
            String decryptedDataString = decryptedData.toString();
            return decryptedDataString;
        }
        if (parms == Schema.DisplayType.MULTIPICKLIST) {
            return getPickListValuesIntoList(Obj, FieldName) + ';' + getPickListValuesIntoList(Obj, FieldName);
        }
        return 'String';
    }
    public static String getPickListValuesIntoList(String Obj, String Field) {
        system.debug('Obj>>>>>' + Obj);
        system.debug('Field>>>>>' + Field);
        Map < String, Schema.SObjectType > gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(Obj);
        Schema.DescribeSObjectResult GetFields = sobjType.getDescribe();
        Map < String, Schema.SObjectField > fieldsMap = GetFields.fields.getMap();
        List < String > getOBJ = new List < String > ();
        Schema.DescribeFieldResult studentStatus = fieldsMap.get(Field).getDescribe();
        List < Schema.PicklistEntry > StatusValues = studentStatus.getPicklistValues();
        for (Schema.PicklistEntry pickListVal: StatusValues) {
            system.debug('>>>pickListVal.getLabel()' + pickListVal.getLabel());
            getOBJ.add(pickListVal.getLabel());
            //pickListValuesList.add(pickListVal.getLabel());
        }
        system.debug('>>>getOBJ.get(0)>>>>>' + getOBJ.get(0));
        return getOBJ.get(0);
    }
}