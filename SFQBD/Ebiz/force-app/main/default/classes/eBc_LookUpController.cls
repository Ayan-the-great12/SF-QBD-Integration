public with sharing class eBc_LookUpController {
    public static string ClassName = 'eBc_LookUpController';
    public static string MethodName = Configuration.EMPTYSTRING;
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, String parentId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < sObject > reciprocate = fetchLookUpValues(dml, searchKeyWord, ObjectName, parentId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
        //return fetchLookUpValues(dml, searchKeyWord, ObjectName, parentId);
    }
    public static List < sObject > fetchLookUpValues(DML dml, String searchKeyWord, String ObjectName, String parentId, EBC_Logger ebcLogger) {
        MethodName = 'fetchLookUpValues';
        ebcLogger.debug(ClassName, MethodName, 'parentId:' + parentId);
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        String queryOrderby = Configuration.EMPTYSTRING;
        String queryLimit = Configuration.EMPTYSTRING;
        List < sObject > returnList = new List < sObject > ();
        try {
            if (parentId == 'null') {
                String searchKey = Configuration.EMPTYSTRING;
                String condition = Configuration.EMPTYSTRING;
                String fields = Configuration.EMPTYSTRING;
                if (ObjectName == 'account') {
                    fields = 'Name';
                    if (searchKeyWord != null && searchKeyWord != Configuration.EMPTYSTRING) {
                        searchKey = searchKeyWord + '%';
                        condition = 'WHERE Name LIKE \'' + searchKey + '\'';
                    }
                }
                if (ObjectName == 'contact') {
                    fields = 'Name';
                    if (searchKeyWord != null && searchKeyWord != Configuration.EMPTYSTRING) {
                        searchKey = searchKeyWord + '%';
                        condition = 'WHERE Name LIKE \'' + searchKey + '\'';
                    }
                } else if (ObjectName == 'Order') {
                    fields = 'OrderNumber';
                    if (searchKeyWord != null && searchKeyWord != Configuration.EMPTYSTRING) {
                        searchKey = searchKeyWord + '%';
                        condition = 'WHERE OrderNumber LIKE \'' + searchKey + '\' AND EBizCharge_Order_Status__c <> \'Paid\' AND (EBizCharge_Order_Balance__c = null OR EBizCharge_Order_Balance__c > 0) ';
                    } else {
                        condition = 'WHERE EBizCharge_Order_Status__c <> \'Paid\' AND (EBizCharge_Order_Balance__c = null OR EBizCharge_Order_Balance__c > 0) ';
                    }
                }
                querySelect = 'SELECT Id,' + fields;
                queryFrom = 'FROM ' + ObjectName;
                queryWhere = condition;
                queryOrderby = 'order by createdDate DESC';
                queryLimit = 'limit 10';
                List < sObject > sObjectsList = (List < sObject > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, queryOrderby, queryLimit);
                for (sObject entity: sObjectsList) {
                    returnList.add(entity);
                }
            } else {
                String searchKey = Configuration.EMPTYSTRING;
                String condition = Configuration.EMPTYSTRING;
                String fields = Configuration.EMPTYSTRING;
                if (ObjectName == 'contact') {
                    fields = 'Name, Email';
                    if (searchKeyWord != null && searchKeyWord != Configuration.EMPTYSTRING) {
                        searchKey = searchKeyWord + '%';
                        condition = 'WHERE Name LIKE \'' + searchKey + '\' AND accountId=:parentId';
                    } else {
                        condition = 'WHERE accountId=\'' + parentId + '\'';
                    }
                }
                querySelect = 'SELECT Id,' + fields;
                queryFrom = 'FROM ' + ObjectName;
                queryWhere = condition;
                queryOrderby = 'order by createdDate DESC';
                queryLimit = 'limit 10';
                List < sObject > sObjectsList = (List < sObject > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, queryOrderby, queryLimit);
                for (sObject entity: sObjectsList) {
                    returnList.add(entity);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnList;
    }
    @AuraEnabled
    public static List < lookupFields > fetchLookUpValuescurringRe(String searchKeyWord, String tabName) {
        MethodName = 'fetchLookUpValuescurringRe';
        EBC_Logger ebcLogger = new EBC_Logger();
        List < lookupFields > returnList = new List < lookupFields > ();
        List < List < SObject >> searchList = new List < List < SObject >> ();
        try {
            if (tabName == 'ProcessPayment') {
                searchList = [FIND: searchKeyWord IN ALL fields RETURNING Account(Id, Name), Contact(Id, Name where accountID != null)];
            } else {
                searchList = [FIND: searchKeyWord IN ALL fields RETURNING Account(Id, Name), Contact(Id, Name), Ebiz_C__EBizCharge_Fields_Config__c(Ebiz_C__EBizCharge_CustomerId__c, Name)];
            }
            List < Account > searchedAccounts = searchList[0];
            List < Contact > searchedContacts = searchList[1];
            List < Ebiz_C__EBizCharge_Fields_Config__c > searchedCustomEntities = new List < Ebiz_C__EBizCharge_Fields_Config__c > ();
            if (tabName != 'ProcessPayment') {
                searchedCustomEntities = searchList[2];
            }
            for (contact contact: searchedContacts) {
                lookupFields lookupFields = new lookupFields();
                lookupFields.Name = contact.Name;
                lookupFields.Id = contact.Id;
                lookupFields.Icon = 'standard:contact';
                lookupFields.ObjectAPIName = 'contact';
                returnList.add(lookupFields);
            }
            for (Account account: searchedAccounts) {
                lookupFields lookupFields = new lookupFields();
                lookupFields.Name = account.Name;
                lookupFields.Id = account.Id;
                lookupFields.Icon = 'standard:account';
                lookupFields.ObjectAPIName = 'account';
                returnList.add(lookupFields);
            }
            if (tabName != 'ProcessPayment') {
                for (Ebiz_C__EBizCharge_Fields_Config__c customEntity: searchedCustomEntities) {
                    lookupFields lookupFields = new lookupFields();
                    lookupFields.Name = customEntity.Name;
                    lookupFields.Id = customEntity.Ebiz_C__EBizCharge_CustomerId__c;
                    lookupFields.Icon = 'standard:client';
                    returnList.add(lookupFields);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        ebcLogger.saveLogs();
        return returnList;
    }
    public class lookupFields {
        @AuraEnabled public String Name {
            get;
            set;
        }
        @AuraEnabled public String Id {
            get;
            set;
        }
        @AuraEnabled public String Icon {
            get;
            set;
        }
        @AuraEnabled public String ObjectAPIName {
            get;
            set;
        } // --Muhammad Ali SAL-116
    }
}