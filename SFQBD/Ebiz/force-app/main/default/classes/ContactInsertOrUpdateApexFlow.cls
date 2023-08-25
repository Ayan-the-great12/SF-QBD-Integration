public with sharing class ContactInsertOrUpdateApexFlow {
    public static string ClassName = 'ContactInsertOrUpdateApexFlow';
    public static string MethodName = Configuration.EMPTYSTRING;
    @InvocableMethod
    public static void invoke_updateContact(List < Contact > contacts) {
        EBC_Logger ebcLogger = new EBC_Logger();
        MethodName = 'invoke_updateContact';
        ebcLogger.debug(ClassName, MethodName, 'contacts is ' + contacts);
        Dml dml = new Dml();
        try {
            EBizcharge_Setting__c settings = new EBizcharge_Setting__c();
            settings = eBc_SettingController.getSettingsApxc(dml, ebcLogger);
            if (settings.Auto_Upload_Contact__c) {
                for (Contact contact: contacts) {
                    if (contact.EBizCharge_Contact_Internal_ID__c != null) {
                        String contactString = json.serialize(contact);
                        invoke_UpdateContactFuture(contactString);
                    } else {
                        invoke_AddContactFuture(contact.Id);
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @Future(callout = true)
    public static void invoke_AddContactFuture(string contactId) {
        EBC_Logger ebcLogger = new EBC_Logger();
        try {
            MethodName = 'invoke_AddContactFuture';
            DML dml = new DML();
            EBC_ComponentController.getDetailApxcContact(dml, contactId, string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact), ebcLogger);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @Future(callout = true)
    public static void invoke_UpdateContactFuture(string contactString) {
        EBC_Logger ebcLogger = new EBC_Logger();
        try {
            MethodName = 'invoke_UpdateContactFuture';
            DML dml = new DML();
            Contact contact = (Contact) Json.deserialize(contactString, Contact.class);
            eBc_UtilityController.invoke_addORUpdCustomerContact(dml, contact, eBc_UtilityController.getSecurityToken(dml, ebcLogger), string.valueOf(Enums.ENTITYACTIONS.updateCustomer), ebcLogger);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
}