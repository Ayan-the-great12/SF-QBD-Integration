public with sharing class eBc_SettingController {
    public static string ClassName = 'eBc_SettingController';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    @AuraEnabled
    public static EBizcharge_Setting__c getSettingsApxc() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        EBizcharge_Setting__c reciprocate = getSettingsApxc(dml, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static EBizcharge_Setting__c getSettingsApxc(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getSettingsApxc';
        ebcLogger.debug(ClassName, MethodName, '<<CheckingSettingsF');
        EBizcharge_Setting__c settingsEntity = new EBizcharge_Setting__c();
        String querySelect = 'SELECT AutoPay_bi_annually__c,AutoPay_four_week__c,' +
            'AutoPay_annually__c,AutoPay_bi_weekly__c,AutoPay_quarterly__c,' +
            'AutoPay_weekly__c,AutoPay_bi_monthly__c,AutoPay_daily__c,AutoPay_monthly__c,' +
            'Enable_all_frequencies__c,Disable_all_frequencies__c,' +
            'EBizCharge_IsLogEnable__c,EBizcharge_IsLogErrorEnable__c,EBizcharge_IsLogInfoEnable__c,EBizcharge_IsLogWarningEnable__c,EBizcharge_IsLogExceptionEnable__c,' +
            'Auto_Upload_Order__c,Auto_Upload_Account__c,Auto_Upload_Contact__c,Auto_Upload_Opportunity__c,' +
            'Auto_Upload_Quote__c,EBizcharge_Sync_Accounts_OnInstall__c,EBizcharge_Sync_Contacts_OnInstall__c,' +
            'Division_ID__c,Data_Flow_Direction__c,Application_ID__c,Sync_Recurring_Payment_Filter_By__c,Payments_Tab__c,' +
            'Data_Integration__c,Use_Custom_Opportunity_Amount__c,Id,Security_Token__c,User_Name__c,Password__c,' +
            'Transaction_Filter_By__c,Email_Pending_Req_Filter_By__c,Sync_Orders_Filter_By__c,' +
            'Sync_Accounts_Filter_By__c,Sync_Products_Filter_By__c,Allow_Partial_Payment__c,Allow_Order_Payment_Type__c,' +
            'Allow_Opportunity_Payment_Type__c,Allow_Quote_Payment_Type__c,Show_Tax_Field__c,Tax_Action__c,Tax_Calculate_By__c,' +
            'Tax_Manual_Type__c,Tax_Default_Percent__c,' +
            'Auto_Upload_Product__c,Auto_Apply_Received_Payment__c,' +
            'Component_Label__c,Currency__c,Ebizcharge_Transaction_Last_Sync_Date__c,Ebizcharge_Product_Last_Sync_Date__c,Ebizcharge_Accounts_Last_Sync_Date__c,Ebizcharge_Orders_Last_Sync_Date__c';
        String queryFrom = 'FROM EBizcharge_Setting__c';
        String queryWhere = Configuration.EMPTYSTRING;
        String queryOrderby = 'Order by CreatedDate DESC';
        try {
            settingsEntity = (EBizcharge_Setting__c) dml.selectSingleRecord(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryOrderby);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return settingsEntity;
    }
    @AuraEnabled
    public static String runTransactionsJob() {
        System.schedule('Scheduled Job 1', '0 0 * * * ?', new TransactionsShedulable());
        System.schedule('Scheduled Job 2', '0 10 * * * ?', new TransactionsShedulable());
        System.schedule('Scheduled Job 3', '0 20 * * * ?', new TransactionsShedulable());
        System.schedule('Scheduled Job 4', '0 30 * * * ?', new TransactionsShedulable());
        System.schedule('Scheduled Job 5', '0 40 * * * ?', new TransactionsShedulable());
        System.schedule('Scheduled Job 6', '0 50 * * * ?', new TransactionsShedulable());
        return Configuration.SUCCESSMESSAGE;
    }
    @AuraEnabled
    public static String getApplicationDataApxc(String applicationID, String lookupID) {
        MethodName = 'getApplicationDataApxc';
        EBC_Logger ebcLogger = new EBC_Logger();
        ebizchargeServicemodelSoap.ApplicationData applicationData;
        String payload = Configuration.EMPTYSTRING;
        try {
            applicationData = ebiz.getApplicationData(applicationID, lookupID, Configuration.EMPTYSTRING);
            Blob payloadBlob = EncodingUtil.base64Decode(applicationData.Base64ParametersString);
            payload = payloadBlob.toString();
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return payload;
    }
    @AuraEnabled
    public static String saveSettingsApxc(EBizcharge_Setting__c Settings) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = saveSettingsApxc(dml, Settings, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String saveSettingsApxc(DML dml, EBizcharge_Setting__c Settings, EBC_Logger ebcLogger) {
        MethodName = 'saveSettingsApxc';
        try {
            if (Settings.Tax_Action__c == 'Tax Included') {
                ebizchargeServicemodelSoap.MerchantTransactionData response;
                response = ebiz.GetMerchantTransactionData(eBc_UtilityController.getSecurityToken(dml, ebcLogger));
                Settings.Tax_Default_Percent__c = response.TaxPercentage.setScale(2, RoundingMode.CEILING);
            }
            dml.upsertRecord(Settings, 'EBizcharge_Setting__c.Id');
            //dml.upsertRecord(Settings, 'Ebiz_C__EBizcharge_Setting__c.Id');
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return Configuration.SUCCESSMESSAGE;
    }
    @AuraEnabled
    public static List < EBizcharge_Setting__c > getSettingsList() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < EBizcharge_Setting__c > reciprocate = getSettingsList(dml, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < EBizcharge_Setting__c > getSettingsList(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getSettingsList';
        List < EBizcharge_Setting__c > settingsList = new List < EBizcharge_Setting__c > ();
        try {
            String querySelect = 'SELECT id, Name,Security_Token__c, User_Name__c, Password__c';
            String queryFrom = 'FROM EBizcharge_Setting__c';
            settingsList = (List < EBizcharge_Setting__c > ) dml.selectRecords(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return settingsList;
    }
    @AuraEnabled
    public static EBizcharge_Setting__c getSettingRecord(String recID) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        EBizcharge_Setting__c reciprocate = getSettingRecord(dml, recID, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static EBizcharge_Setting__c getSettingRecord(DML dml, String recID, EBC_Logger ebcLogger) {
        MethodName = 'getSettingRecord';
        EBizcharge_Setting__c settingsEntity = new EBizcharge_Setting__c();
        try {
            String querySelect = 'SELECT id, Name, Security_Token__c, User_Name__c, Password__c';
            String queryFrom = 'FROM EBizcharge_Setting__c';
            String queryWhere = 'where Id = \'' + recID + '\'';
            settingsEntity = (EBizcharge_Setting__c) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return settingsEntity;
    }
    @AuraEnabled
    public static List < Map < String, String >> getListOfEmailTemplates() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < Map < String, String >> reciprocate = getListOfEmailTemplates(dml, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < Map < String, String >> getListOfEmailTemplates(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getListOfEmailTemplates';
        List < Map < String, String >> returnEmailTemplates = new List < Map < String, String >> ();
        returnEmailTemplates.add(new Map < String, String > {
            'value' => Configuration.EMPTYSTRING,
            'label' => 'None'
        });
        ebizchargeServicemodelSoap.ArrayOfEmailTemplate emailTemplateResponse = new ebizchargeServicemodelSoap.ArrayOfEmailTemplate();
        ebizchargeServicemodelSoap.EmailTemplate[] ebizEmailTemplates;
        try {
            emailTemplateResponse = ebiz.GetEmailTemplates(eBc_UtilityController.getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            ebizEmailTemplates = emailTemplateResponse.EmailTemplate;
            if (ebizEmailTemplates != null) {
                for (ebizchargeServicemodelSoap.EmailTemplate emailTemplate: ebizEmailTemplates) {
                    returnEmailTemplates.add(new Map < String, String > {
                        'value' => emailTemplate.TemplateInternalId,
                        'label' => emailTemplate.TemplateName
                    });
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnEmailTemplates;
    }
}