public with sharing class AccountInsertOrUpdateApexFlow {
    public static string ClassName = 'AccountInsertOrUpdateApexFlow';
    public static string MethodName = Configuration.EMPTYSTRING;
    @InvocableMethod
    public static void invoke_updateAccount(List < AccountWrapper > accounts) {
        MethodName = 'invoke_updateAccount';
        EBC_Logger ebcLogger = new EBC_Logger();
        ebcLogger.debug(ClassName, MethodName, 'accounts are ' + accounts);
        Dml dml = new Dml();
        try {
            EBizcharge_Setting__c settings = new EBizcharge_Setting__c();
            settings = eBc_SettingController.getSettingsApxc(dml, ebcLogger);
            if (settings.Auto_Upload_Account__c) {
                for (AccountWrapper account: accounts) {
                    if (account.accountRecord.EBizCharge_Internal_ID__c != null) {
                        String accountString = json.serialize(account.accountRecord);
                        String Old_Qbd_Id = account.Old_Qbd_Id;
                        invoke_UpdateAccountFuture(accountString,Old_Qbd_Id);
                    } else {
                        invoke_AddAccountFuture(account.accountRecord.Id);
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    public class AccountWrapper{   
        @InvocableVariable
        public String Old_Qbd_Id;
        @InvocableVariable
        public Account accountRecord;
    }
    @Future(callout = true)
    public static void invoke_AddAccountFuture(string accountId) {
        MethodName = 'invoke_AddAccountFuture';
        DML dml = new DML();
        EBC_Logger ebcLogger = new EBC_Logger();
        try {
            EBC_ComponentController.getDetailApxc(dml, accountId, string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account), ebcLogger);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @Future(callout = true)
    public static void invoke_UpdateAccountFuture(string accountString,string OldId) {
        MethodName = 'invoke_UpdateAccountFuture';
        EBC_Logger ebcLogger = new EBC_Logger();
        DML dml = new DML();
        try {
            Account account = (Account) Json.deserialize(accountString, Account.class);
            //SF-Qbd
            eBc_UtilityController.invoke_addORUpdCustomerQBD(dml, account, eBc_UtilityController.getSecurityToken(dml, ebcLogger),OldId,string.valueOf(Enums.ENTITYACTIONS.updateCustomer), ebcLogger);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
}