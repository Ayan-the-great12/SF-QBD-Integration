public with sharing class EbizCharge_Fields_Config_Update_Handler {
    public static string ClassName = 'EbizCharge_Fields_Config_Update_Handler';
    public static string MethodName = Configuration.EMPTYSTRING;
    @InvocableMethod
    public static void updateFieldsConfig(List < EBizCharge_Fields_Config > fieldsConfig) {
        MethodName = 'updateFieldsConfig';
        EBC_Logger ebcLogger = new EBC_Logger();
        Dml dml = new Dml();
        for (EBizCharge_Fields_Config fieldConfig: fieldsConfig) {
                string customCustomerId = fieldConfig.newRecord.Ebiz_C__EBizCharge_CustomerId__c;
                id findType = (id) customCustomerId;
                Schema.SObjectType token = findType.getSObjectType();
                Schema.DescribeSObjectResult schemaDescription = token.getDescribe();
                string sObjName = schemaDescription.getName();//query for Custom object//getName()of contact//then put email on it
                string fields = Configuration.EMPTYSTRING;
                String querySelect = Configuration.EMPTYSTRING;
                String queryFrom = Configuration.EMPTYSTRING;
                String queryWhere = Configuration.EMPTYSTRING;
                querySelect = 'SELECT id,Ebiz_C__EBizCustomerNameApi__c,Ebiz_C__EBizCustomerEmailApi__c,Ebiz_C__EBizAmountApi__c,Ebiz_C__EBizReferenceContactApi__c,Ebiz_C__EBizReferenceAccountApi__c';
                queryFrom = 'FROM Ebiz_C__EBiz_Object_Config__c';
                queryWhere = 'where Name =\'' + String.escapeSingleQuotes(sObjName) + '\'';
                Ebiz_C__EBiz_Object_Config__c configurationObject = (Ebiz_C__EBiz_Object_Config__c) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                if (string.isNotBlank(configurationObject.Ebiz_C__EBizCustomerNameApi__c) && string.isNotEmpty(configurationObject.Ebiz_C__EBizCustomerNameApi__c) && configurationObject.Ebiz_C__EBizCustomerNameApi__c != null) {
                    fields += configurationObject.Ebiz_C__EBizCustomerNameApi__c + Configuration.APINAMESEPARATOR;
                } else {
                    fields += Configuration.EMPTYSTRING;
                }
                if (string.isNotBlank(configurationObject.Ebiz_C__EBizCustomerEmailApi__c) && string.isNotEmpty(configurationObject.Ebiz_C__EBizCustomerEmailApi__c) && configurationObject.Ebiz_C__EBizCustomerEmailApi__c != null) {
                    fields += configurationObject.Ebiz_C__EBizCustomerEmailApi__c + Configuration.APINAMESEPARATOR;
                } else {
                    fields += Configuration.EMPTYSTRING;
                }
                if (string.isNotBlank(configurationObject.Ebiz_C__EBizAmountApi__c) && string.isNotEmpty(configurationObject.Ebiz_C__EBizAmountApi__c) && configurationObject.Ebiz_C__EBizAmountApi__c != null) {
                    fields += configurationObject.Ebiz_C__EBizAmountApi__c + Configuration.APINAMESEPARATOR;
                } else {
                    fields += Configuration.EMPTYSTRING;
                }
                if (string.isNotBlank(configurationObject.Ebiz_C__EBizReferenceContactApi__c) && string.isNotBlank(configurationObject.Ebiz_C__EBizReferenceContactApi__c) && configurationObject.Ebiz_C__EBizReferenceContactApi__c != null) {
                    fields += configurationObject.Ebiz_C__EBizReferenceContactApi__c + Configuration.APINAMESEPARATOR;
                } else {
                    fields += Configuration.EMPTYSTRING;
                }
                if (string.isNotBlank(configurationObject.Ebiz_C__EBizReferenceAccountApi__c) && string.isNotBlank(configurationObject.Ebiz_C__EBizReferenceAccountApi__c) && configurationObject.Ebiz_C__EBizReferenceAccountApi__c != null) {
                    fields += configurationObject.Ebiz_C__EBizReferenceAccountApi__c + Configuration.APINAMESEPARATOR;
                } else {
                    fields += Configuration.EMPTYSTRING;
                }
                querySelect = 'SELECT id,' + fields + string.valueOf(Enums.FIELDNAMES.createddate);
                queryFrom = 'FROM '  + sObjName + Configuration.EMPTYSTRING;
                queryWhere = 'where id =\'' + String.escapeSingleQuotes(customCustomerId) + '\'';
                sObject sObjectEntity = (sObject) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                if(fieldConfig.newContactEmail != null && fieldConfig.newContactEmail != Configuration.EMPTYSTRING && fieldConfig.newContactEmail != fieldConfig.oldContactEmail)
                {
                    if (string.isNotBlank(configurationObject.Ebiz_C__EBizReferenceContactApi__c) && string.isNotBlank(configurationObject.Ebiz_C__EBizReferenceContactApi__c) && configurationObject.Ebiz_C__EBizReferenceContactApi__c != null) {
                        sObjectEntity.put(configurationObject.Ebiz_C__EBizCustomerEmailApi__c, fieldConfig.newContactEmail);
                    }
                    
                }
                else if(fieldConfig.newAccountEmail != null && fieldConfig.newAccountEmail != Configuration.EMPTYSTRING && fieldConfig.newAccountEmail != fieldConfig.oldAccountEmail)
                {
                    if (string.isNotBlank(configurationObject.Ebiz_C__EBizReferenceAccountApi__c) && string.isNotBlank(configurationObject.Ebiz_C__EBizReferenceAccountApi__c) && configurationObject.Ebiz_C__EBizReferenceAccountApi__c != null) {
                        sObjectEntity.put(configurationObject.Ebiz_C__EBizCustomerEmailApi__c, fieldConfig.newAccountEmail);
                    }
                }
            dml.updateRecord(sObjectEntity);
        }
    }
    public class EBizCharge_Fields_Config {
        @InvocableVariable
        public String oldAccountEmail;
        @InvocableVariable
        public String oldRecordEmail;
        @InvocableVariable
        public String newRecordEmail;
        @InvocableVariable
        public String oldContactEmail;
        @InvocableVariable
        public String newContactEmail;
        @InvocableVariable
        public String newAccountEmail;
        @InvocableVariable
        public EBizCharge_Fields_Config__c newRecord;
    }
}