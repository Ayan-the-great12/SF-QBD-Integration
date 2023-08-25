public with sharing class eBc_AccountController {
    public static string ClassName = 'eBc_AccountController';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    @auraEnabled
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
        return eBc_UtilityController.getSettings(dml, ebcLogger);
    }
    @AuraEnabled
    public static List < AccountWrapper > getAllAccountsApxc() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < AccountWrapper > reciprocate = getAllAccountsApxc(dml, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < AccountWrapper > getAllAccountsApxc(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getAllAccountsApxc';
        ebcLogger.debug(ClassName, MethodName, 'call updateAccountMethod----');
        // Commenting call as sync on package installation functionality not required in Production
        ebcLogger.debug(ClassName, MethodName, 'call updateAccountMethod finish----');
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryOrderby = Configuration.EMPTYSTRING;
        String queryLimit = Configuration.EMPTYSTRING;
        List < AccountWrapper > accountWrapperList = new List < AccountWrapper > ();
        List < Account > accountsList = new List < Account > ();
        try {   //For SF-Qbd, added four fields in select query "Gateway_Monthly_Fee__c","Approved_Date__c","QBD_Customer_ID__c","Email__c"
            querySelect = 'SELECT Id, Name,Gateway_Monthly_Fee__c,Approved_Date__c,QBD_Customer_ID__c,Email__c,createdById, First_Name__c,Last_Name__c,EBizCharge_Email__c, Phone, Fax, Website,' +
                'EBizCharge_Internal_ID__c,EBizCharge_Amount__c,' +
                'BillingAddress, BillingStreet, BillingPostalCode, BillingCity, BillingCountry, BillingState,' +
                'ShippingAddress,ShippingCity, ShippingState, ShippingStreet, ShippingPostalCode, ShippingCountry';
            queryfrom = 'FROM Account';
            queryOrderby = 'Order by CreatedDate DESC';
            queryLimit = 'limit 500';
            accountsList = (List < Account > ) dml.selectRecords(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryOrderby, queryLimit);
            for (Account account: accountsList) {
                AccountWrapper accountWrapper = new AccountWrapper();
                accountWrapper.accHyperUrl = '/' + account.Id;
                accountWrapper.accId = account.Id;
                accountWrapper.accName = account.Name;
                accountWrapper.accAmount = account.EBizCharge_Amount__c;
                accountWrapper.accFirstName = account.First_Name__c;
                accountWrapper.accLastName = account.Last_Name__c;
                accountWrapper.accEmail =  (String)account.get('Email__c');//For SF-Qbd 
                accountWrapper.accPhone = account.Phone;
                accountWrapper.accExtId = account.EBizCharge_Internal_ID__c;
                accountWrapper.accBillingStreet = account.BillingStreet;
                accountWrapper.accBillingCity = account.BillingCity;
                accountWrapper.accBillingPostalCode = account.BillingPostalCode;
                accountWrapper.accBillingCountry = account.BillingCountry;
                accountWrapper.accShippingStreet = account.ShippingStreet;
                accountWrapper.accShippingCity = account.ShippingCountry;
                accountWrapper.accShippingState = account.ShippingState;
                accountWrapper.accShippingPostalCode = account.ShippingPostalCode;
                accountWrapper.accShippingCountry = account.ShippingCountry;
                accountWrapper.Qbd_Customer_Id    = (String)account.get('QBD_Customer_ID__c');//For SF-Qbd 
                accountWrapper.Gateway_Monthly_Fee = (Decimal)account.get('Gateway_Monthly_Fee__c');//For SF-Qbd 
                accountWrapper.Approved_Date = (Date)account.get('Approved_Date__c');//For SF-Qbd 
                ebcLogger.debug(ClassName, MethodName, 'account.EBizCharge_Internal_ID__c:' + account.EBizCharge_Internal_ID__c);
                if (account.EBizCharge_Internal_ID__c != null && account.EBizCharge_Internal_ID__c != Configuration.EMPTYSTRING) {
                    accountWrapper.accStatus = string.valueOf(Enums.ASSIGNMENTSTRINGS.Synced);
                } else {
                    accountWrapper.accStatus = Configuration.NOTSYNCED;
                }
                accountWrapper.isSelected = false;
                accountWrapperList.add(accountWrapper);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            throw new AuraHandledException(Configuration.EXCEPTIONSTRING + e.getMessage());
        }
        return accountWrapperList;
    }
    public static void updateAccountInternalIds(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'updateAccountInternalIds';
        try {
            EBizcharge_Setting__c ebizSetting = eBc_SettingController.getSettingsApxc(dml, ebcLogger);
            if (!ebizSetting.EBizcharge_Sync_Accounts_OnInstall__c && !(ebizSetting.Security_Token__c.trim() == Configuration.EMPTYSTRING || ebizSetting.Security_Token__c == null)) {
                ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
                ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
                ebizchargeServicemodelSoap.ArrayOfSearchFilter filterArray = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
                ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
                list < ebizchargeServicemodelSoap.SearchFilter > searchFilterList = new list < ebizchargeServicemodelSoap.SearchFilter > ();
                filter.FieldName = string.valueOf(Enums.FIELDNAMES.SoftwareID);
                filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
                filter.FieldValue = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
                searchFilterList.add(filter);
                filterArray.SearchFilter = searchFilterList;
                list < ebizchargeServicemodelSoap.Customer > customerList = new list < ebizchargeServicemodelSoap.Customer > ();
                ebizchargeServicemodelSoap.ArrayOfCustomer arrayOfCustomer = new ebizchargeServicemodelSoap.ArrayOfCustomer();
                ebizchargeServicemodelSoap.CustomerListSearchResult customersResponseList = new ebizchargeServicemodelSoap.CustomerListSearchResult();
                customersResponseList = ebiz.SearchCustomerList(securityToken, filterArray, 0, 10, Configuration.EMPTYSTRING, false, false, true);
                if (customersResponseList != null) {
                    Integer count = 0;
                    count = customersResponseList.Count;
                    if (count > 0) {
                        Map < String, String > accountsInternalIdMap = new Map < String, String > ();
                        Integer loopSize = (Integer) Math.ceil((Decimal) count / 1000);
                        for (Integer i = 0; i < loopsize; i++) {
                            ebcLogger.debug(ClassName, MethodName, 'loop to searchcustomerlist in updateAccount');
                            customersResponseList = ebiz.SearchCustomerList(securityToken, filterArray, i * 1000, 1000, Configuration.EMPTYSTRING, false, false, false);
                            arrayOfCustomer = customersResponseList.CustomerList;
                            customerList = arrayOfCustomer.Customer;
                            if (customerList != null) {
                                for (ebizchargeServicemodelSoap.Customer customer: customerList) {
                                    Schema.DescribeSObjectResult r = Account.sObjectType.getDescribe();
                                    String keyPrefix = r.getKeyPrefix();
                                    if (customer.CustomerId.startsWith(keyPrefix)) {
                                        ebcLogger.debug(ClassName, MethodName, 'AccountMatch  in updateAccount');
                                        accountsInternalIdMap.put(customer.CustomerId, customer.CustomerInternalId);
                                    }
                                }
                                ebcLogger.debug(ClassName, MethodName, 'total AccountMatch  in updateAccount' + accountsInternalIdMap.size());
                            }
                        }
                        String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c';
                        String queryFrom = 'FROM Account';
                        List < Account > accountsListToUpdate = new List < Account > ();
                        for (Account account: (list < Account > ) dml.selectRecords(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING)) {
                            if (test.isRunningTest()) {
                                account.EBizCharge_Internal_ID__c = null;
                            }
                            if (account.EBizCharge_Internal_ID__c == null || account.EBizCharge_Internal_ID__c == Configuration.EMPTYSTRING) {
                                ebcLogger.debug(ClassName, MethodName, 'Internal Found null in updateAccount');
                                if (accountsInternalIdMap.containsKey(account.id)) {
                                    ebcLogger.debug(ClassName, MethodName, 'AccountId Match With Local in updateAccount');
                                    ebcLogger.debug(ClassName, MethodName, 'AccountId & EBizCharge_Internal_ID__c' + account.id + ' -- ' + accountsInternalIdMap.get(account.id));
                                    account.EBizCharge_Internal_ID__c = accountsInternalIdMap.get(account.id);
                                    accountsListToUpdate.add(account);
                                }
                            }
                        }
                        ebcLogger.debug(ClassName, MethodName, 'total UpdateAccountList  in updateAccount' + accountsListToUpdate.size());
                        if (accountsListToUpdate != null && accountsListToUpdate.size() > 0) {
                            dml.updateRecord(accountsListToUpdate);
                            ebizSetting.EBizcharge_Sync_Accounts_OnInstall__c = true;
                            dml.updateRecord(ebizSetting);
                        }
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @AuraEnabled
    public static accDetail getAccountDetailApxc(String AccountId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        accDetail reciprocate = getAccountDetailApxc(dml, AccountId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static accDetail getAccountDetailApxc(DML dml, String AccountId, EBC_Logger ebcLogger) {
        MethodName = 'getAccountDetailApxc';
        accDetail accountDetailEntity = new accDetail();
        try {
            String querySelect = 'select id,QBD_Customer_ID__c';
            String queryFrom = 'from Account';
            String queryWhere =  'where id=\''+ AccountId+'\'';
            Account account = (Account)dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
            Account accountDetail = eBc_UtilityController.getAccountDetail(dml, AccountId, ebcLogger);
            accountDetailEntity.AccountInfo = accountDetail;
            if (!test.isRunningTest()) {
                ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
                responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
                accountDetailEntity.UseFullAmountForAVS = responseMerchant.UseFullAmountForAVS;
            }
            map < String, String > updateAccountMap = new map < string, string > ();
            String accountExternalId = accountDetail.EBizCharge_Internal_ID__c;
            // MockData 
            if (test.isRunningTest()) {
                accountExternalId = null;
            } // MockData End
            if (accountExternalId == null || accountExternalId == Configuration.EMPTYSTRING) {
                //search customer on Gateway 
                ebizchargeServicemodelSoap.Customer cstRes = new ebizchargeServicemodelSoap.Customer();
                cstRes = eBc_UtilityController.invoke_SearchCustomer(dml, (string)account.get('QBD_Customer_ID__c'), ebcLogger);
                if (cstRes.CustomerInternalId != null) {
                    accountExternalId = cstRes.CustomerInternalId;
                    updateAccountMap.put(accountId, cstRes.CustomerInternalId);
                } else {
                    // add customer on Gateway
                    ebizchargeServicemodelSoap.CustomerResponse customerResponse = eBc_UtilityController.invoke_addORUpdCustomer(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger), string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
                    accountExternalId = customerResponse.CustomerInternalId;
                    updateAccountMap.put(AccountId, customerResponse.CustomerInternalId);
                }
            }
            accountDetailEntity.savedPaymentMethods = eBc_UtilityController.GetCustomerSavedPaymentMethods(dml, (string)accountDetail.get('QBD_Customer_ID__c'), accountExternalId, ebcLogger);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return accountDetailEntity;
    }
    @AuraEnabled
    public static string autoSyncAccountApxc(String AccountId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = autoSyncAccountApxc(dml, AccountId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string autoSyncAccountApxc(DML dml, String AccountId, EBC_Logger ebcLogger) {
        MethodName = 'autoSyncAccountApxc';
        string accountExternalId = Configuration.EMPTYSTRING;
        try {
            Account accountDetail = eBc_UtilityController.getAccountDetail(dml, AccountId, ebcLogger);
            // add customer on Gateway
            ebizchargeServicemodelSoap.CustomerResponse customerResponse = eBc_UtilityController.invoke_addORUpdCustomer(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger), string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
            accountExternalId = customerResponse.CustomerInternalId;
            Account account = new Account();
            account.Id = AccountId;
            account.EBizCharge_Internal_ID__c = accountExternalId;
            account.EBizCharge_Last_Sync_Date__c = system.now();
            dml.updateRecord(account);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static string syncAccountsApxc(list < AccountWrapper > selectedAccountCol) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = syncAccountsApxc(dml, selectedAccountCol, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string syncAccountsApxc(DML dml, list < AccountWrapper > selectedAccountCol, EBC_Logger ebcLogger) {
        MethodName = 'syncAccountsApxc';
        try {
            EBizcharge_Setting__c ebizchargeSettings = eBc_UtilityController.getSettings(dml, ebcLogger);
            map < String, String > updateAccountsMap = new map < string, string > ();
            ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
            ebizchargeServicemodelSoap.CustomerResponse customerResponse = new ebizchargeServicemodelSoap.CustomerResponse();
            List < Id > accountsIdList = new List < Id > ();
            for (AccountWrapper accountWrapper: selectedAccountCol) {
                accountsIdList.add(accountWrapper.accId);
            }
            List < Account > accountsDetailList = new List < Account > ();
            accountsDetailList = eBc_UtilityController.getAccountsDetail(dml, accountsIdList, ebcLogger);
            for (Account account: accountsDetailList) {
                if (account.EBizCharge_Internal_ID__c != null && account.EBizCharge_Internal_ID__c != Configuration.EMPTYSTRING) {
                    customerResponse = eBc_UtilityController.invoke_addORUpdCustomer(dml, account, securityToken, string.valueOf(Enums.ENTITYACTIONS.updCustomer), ebcLogger);
                } else {
                    ebizchargeServicemodelSoap.Customer responseFromGetCustomer = new ebizchargeServicemodelSoap.Customer();
                    try {
                     if((String)account.get('QBD_Customer_ID__c') !=null && (String)account.get('QBD_Customer_ID__c') != Configuration.EMPTYSTRING)
                    {
                        responseFromGetCustomer = ebiz.GetCustomer(securityToken,(String)account.get('QBD_Customer_ID__c'), Configuration.EMPTYSTRING);
                        customerResponse.StatusCode = 1;
                        customerResponse.CustomerInternalId = responseFromGetCustomer.CustomerInternalId;
                    }
                    } catch (Exception e) {
                        ebcLogger.debug(ClassName, MethodName, '>>Error has been occured in GetCustomer' + e.getMessage());
                        customerResponse = eBc_UtilityController.invoke_addORUpdCustomer(dml, account, securityToken, string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
                    }
                }
                if (test.isRunningTest()) {
                    customerResponse.StatusCode = 1;
                }
                if (customerResponse.StatusCode == 1) {
                    ebcLogger.debug(ClassName, MethodName, 'OK!');
                    updateAccountsMap.put(account.id, customerResponse.CustomerInternalId);
                } else {
                    ebcLogger.debug(ClassName, MethodName, 'Error!');
                }
            }
            if (updateAccountsMap.size() > 0) {
                return eBc_UtilityController.updCustomerInSF(dml, updateAccountsMap, ebcLogger);
            } else {
                return string.valueOf(Enums.RETURNMESSAGE.Success);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return Configuration.EXCEPTIONMESSAGE;
        }
        // added by @wqkl against (SF-137) - (19jan21) - end
    }
    @AuraEnabled
    public static map < String, String > getSavedMethodsApxc(String accountId, String accExternalId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        map < String, String > reciprocate = getSavedMethodsApxc(dml, accountId, accExternalId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static map < String, String > getSavedMethodsApxc(DML dml, String accountId, String accExternalId, EBC_Logger ebcLogger) {
        MethodName = 'getSavedMethodsApxc';
        map < String, String > listOfPaymentMethods = new map < String, String > ();
        String querySelect = 'select id,QBD_Customer_ID__c';
        String queryFrom = 'from Account';
        String queryWhere =  'where id=\''+ accountId +'\'';
        Account account = (Account)dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
        listOfPaymentMethods = eBc_UtilityController.GetCustomerSavedPaymentMethods(dml,(String)account.get('QBD_Customer_ID__c'), accExternalId, ebcLogger);
        return listOfPaymentMethods;
    }
    @AuraEnabled
    public static List < emailWrapperclass > getEmailTemplatesApxc() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < emailWrapperclass > reciprocate = getEmailTemplatesApxc(dml, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < emailWrapperclass > getEmailTemplatesApxc(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getEmailTemplatesApxc';
        List < emailWrapperclass > emailWrapperList = new List < emailWrapperclass > ();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.EmailTemplate[] emailTemplateList;
        ebizchargeServicemodelSoap.ArrayOfEmailTemplate arrayOfEmailTemplates = new ebizchargeServicemodelSoap.ArrayOfEmailTemplate();
        try {
            arrayOfEmailTemplates = ebiz.GetEmailTemplates(eBc_UtilityController.getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            emailTemplateList = arrayOfEmailTemplates.EmailTemplate;
            if (emailTemplateList != null) {
                for (ebizchargeServicemodelSoap.EmailTemplate emailTemplate: emailTemplateList) {
                    emailWrapperclass emailWrapper = new emailWrapperclass();
                    emailWrapper.TemplateName = emailTemplate.TemplateName;
                    emailWrapper.TemplateType = emailTemplate.TemplateTypeId;
                    emailWrapper.TemplateInternalId = emailTemplate.TemplateInternalId;
                    emailWrapper.TemplateSubject = emailTemplate.TemplateSubject;
                    emailWrapper.FromEmail = emailTemplate.FromEmail;
                    emailWrapper.ReplyToEmail = emailTemplate.ReplyToEmail;
                    emailWrapperList.add(emailWrapper);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return emailWrapperList;
    }
    @AuraEnabled
    public static String addPaymentMehtodReqApxc(String sendReqJSON, String AccountId, String AccountName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = addPaymentMehtodReqApxc(dml, sendReqJSON, AccountId, AccountName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String addPaymentMehtodReqApxc(DML dml, String sendReqJSON, String AccountId, String AccountName, EBC_Logger ebcLogger) {
        MethodName = 'addPaymentMehtodReqApxc';
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        String queryLimit = Configuration.EMPTYSTRING;
        Map < String, Object > requestMap = (Map < String, Object > ) JSON.deserializeUntyped(sendReqJSON);
        ebizchargeServicemodelSoap.EbizWebForm ebizWebForm = new ebizchargeServicemodelSoap.EbizWebForm();
        try {
            ebizWebForm.FromName = string.valueOf(Enums.ASSIGNMENTSTRINGS.EBizCharge);
            ebizWebForm.FromEmail = (string) requestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.fromEmail));
            ebizWebForm.EmailAddress = (string) requestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.toEmail));
            ebizWebForm.EmailSubject = (string) requestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Subject));
            ebizWebForm.EmailNotes = (string) requestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Notes));
            ebizWebForm.EmailTemplateID = (string) requestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.TemplateId));
            ebizWebForm.Date_x = System.now();
            ebizWebForm.CustomerId = AccountId;
            ebizWebForm.CustFullName = AccountName;
            ebizWebForm.InvoiceNumber = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.Token);
            ebizWebForm.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            ebizWebForm.Clerk = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.AppUser);
            ebizWebForm.FormType = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.PmRequestForm);
            ebizWebForm.PayByType = Configuration.PAYBYTYPESTRING;
            ebizWebForm.OrderId = Configuration.WEBFORMORDERID;
            ebizWebForm.SendEmailToCustomer = true;
            // added by @wqkl against BillingAddress - (02Feb21) - start
            Account accountObject = new Account();
            querySelect = 'select id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry';
            queryFrom = 'from account';
            //queryWhere = 'where id=\'' + AccountId + '\'';
            queryWhere = 'where QBD_Customer_ID__c=\''+AccountId+'\'';//For SF-Qbd
            accountObject = (Account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            ebizchargeServicemodelSoap.Address customerAddress = new ebizchargeServicemodelSoap.Address();
            customerAddress.FirstName = accountObject.Name;
            customerAddress.LastName = accountObject.Name;
            customerAddress.Address1 = accountObject.BillingStreet;
            customerAddress.City = accountObject.BillingCity;
            customerAddress.State = accountObject.BillingState;
            customerAddress.ZipCode = accountObject.BillingPostalCode;
            customerAddress.Country = accountObject.BillingCountry;
            ebizWebForm.BillingAddress = customerAddress;
            // added by @wqkl against BillingAddress - (02Feb21) - end
            string addPMresponse = ebiz.GetEbizWebFormURL(eBc_UtilityController.getSecurityToken(dml, ebcLogger), ebizWebForm);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return Configuration.EXCEPTIONMESSAGE;
        }
    }
    public static String AddPaymentMethod(DML dml,Map<String, Object> strMap, String saveMethod,EBC_Logger ebcLogger){
        MethodName = 'addPaymentMethod';
        transactionParams tranParm = new transactionParams();
        String paymentMethodID = Configuration.EMPTYSTRING;
        tranParm.internalID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccExternalId));
        if(saveMethod == string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard)){
            tranParm.ccNumber  = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
            tranParm.expMonth  = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
            tranParm.expYear   = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
            tranParm.cvvCode   = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
            tranParm.ccName    = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
            tranParm.AvsZip    = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
            tranParm.AvsStreet = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
            tranParm.MethodName = (String)strMap.get('MethodName');
            Boolean saveCard     = (boolean)strMap.get('saveCard');
            if(saveCard == true){
                paymentMethodID = eBc_UtilityController.addPaymentMethod(dml,tranParm, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard),ebcLogger);    
            }
        }
        if(saveMethod == string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH)){
            tranParm.AccountName  = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
            tranParm.Account      = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
            tranParm.Route         = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
            Boolean saveACH = (boolean)strMap.get('saveACH');
            if(saveACH == true){
                paymentMethodID = eBc_UtilityController.addPaymentMethod(dml,tranParm, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH),ebcLogger);
            }
        }
        return paymentMethodID;
    }
    public static String processPayment(DML dml, Map < String, Object > strMap, String processBy, EBC_Logger ebcLogger) {
        MethodName = 'processPayment';
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        String queryLimit = Configuration.EMPTYSTRING;
        string paymentMethodID = Configuration.EMPTYSTRING;
        try {
            Boolean sendReceiptTo = (boolean) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
            String addEmails = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.addEmails));
            Double amount = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Amount));
            Double tax = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Tax));
            String taxAction = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.TaxAction));
            transactionParams transactionPayload = new transactionParams();
            transactionPayload.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            transactionPayload.OrderID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OrderNo));
            transactionPayload.OrderNumber = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OrderNo));
            transactionPayload.Terminal = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Terminal));
            if (taxAction == Configuration.TAXACTION) {
                transactionPayload.SubTotal = 0;
            } else {
                transactionPayload.SubTotal = amount;
            }
            string accountId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId));
            transactionPayload.Amount = amount + tax;
            transactionPayload.Tax = tax;
            String query_Select = 'select id,QBD_Customer_ID__c';
            String query_From = 'from Account';
            String query_Where =  'where id=\''+accountId+'\'';
            Account account = (Account)dml.selectSingleRecord(query_Select, query_From, query_Where, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
            // transactionPayload.accountID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId));
            // transactionPayload.customerID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId));
            transactionPayload.accountID = (string)account.get('QBD_Customer_ID__c');
            transactionPayload.customerID = (string)account.get('QBD_Customer_ID__c');
            transactionPayload.internalID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccExternalId));
            transactionPayload.isRecurring = false;
            ebcLogger.debug(ClassName, MethodName, '>>>>processBy>>>' + processBy);
            ebizchargeServicemodelSoap.ArrayOfLineItem lineItemsList = new ebizchargeServicemodelSoap.ArrayOfLineItem();
            lineItemsList.LineItem = new List < ebizchargeServicemodelSoap.Lineitem > ();
            ebizchargeServicemodelSoap.LineItem lineItem = new ebizchargeServicemodelSoap.Lineitem();
            Account lineItemAccount = new Account();
            querySelect = 'select id, name';
            queryFrom = 'from account';
            queryWhere = 'where id =\'' + accountId + '\'';
            lineItemAccount = (Account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            lineItem.SKU = accountId;
            lineItem.ProductName = lineItemAccount.name;
            lineItem.Description = Configuration.ACCOUNTLINEITEMDESCRIPTION;
            lineItem.UnitPrice = String.valueOf(amount + tax);
            lineItem.Qty = Configuration.LINEITEMQUANTITY;
            lineItem.Taxable = true;
            lineItem.UnitOfMeasure = string.valueOf(Enums.LINEITEMPARAMETERS.EA);
            lineItem.TaxAmount = String.valueOf(tax);
            lineItemsList.LineItem.add(lineItem);
            transactionPayload.LineItems = lineItemsList;
            ebizchargeServicemodelSoap.TransactionResponse transactionResponse = new ebizchargeServicemodelSoap.TransactionResponse();
            ebcLogger.debug(ClassName, MethodName, 'processBy:' + processBy);
            if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingCard)) {
                ebcLogger.debug(ClassName, MethodName, 'ECentry:');
                transactionPayload.methodID = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.selectedCardId));
                transactionPayload.CardCode = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.cvcNo));
                if (!Test.isRunningTest()) { //waseem added condition
                    transactionResponse = eBc_UtilityController.runTransactionPayment(dml, transactionPayload, sendReceiptTo, addEmails, string.valueOf(Enums.PAYMENTTYPES.Sale), ebcLogger);
                }
            } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard)) {
                Account accDetail = eBc_UtilityController.getAccountDetail(dml, (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId)), ebcLogger);
                transactionPayload.methodID = Configuration.CARDMETHODID;
                transactionPayload.ccNumber = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
                transactionPayload.expMonth = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
                transactionPayload.expYear = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
                transactionPayload.cvvCode = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
                transactionPayload.ccName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
                transactionPayload.AvsZip = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
                transactionPayload.AvsStreet = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
                //-----------------------UseFullAmountForAVS-----------------
                if (strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode)) == Configuration.EMPTYSTRING) {
                    paymentMethodID = AddPaymentMethod(dml, strMap, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                    transactionResponse = eBc_UtilityController.runTransactionOnlyAccountTab(dml, transactionPayload, accDetail, strMap, paymentMethodID, ebcLogger);
                }
                //AVS Checks - Start
                //avs checks when UseFullAmountForAVS is true
                ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
                responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
                String returnMessage = Configuration.AVSCHECKSTRING;
                if (strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode)) == Configuration.EMPTYSTRING) {
                    if (responseMerchant.UseFullAmountForAVS == true) {
                        Boolean isAVSCheck = (boolean) strMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isAVSCheck));
                        Boolean AVSMatch = true;
                        if (isAVSCheck == true) {
                            if (transactionResponse.ErrorCode == '0') {
                                returnMessage += transactionResponse.RefNum + '@';
                                if (transactionResponse.CardCodeResultCode != 'M') {
                                    returnMessage += 'CardCodeNotMatch@';
                                    AVSMatch = false;
                                } else {
                                    returnMessage += 'CardCodeMatch@';
                                }
                                if (transactionResponse.AvsResultCode != 'YYY' || transactionResponse.AvsResultCode != 'Y' || transactionResponse.AvsResultCode != 'YYA' || transactionResponse.AvsResultCode != 'YYD' ||
                                    transactionResponse.AvsResultCode != 'YYX' || transactionResponse.AvsResultCode != 'X' || transactionResponse.AvsResultCode != 'GGG' || transactionResponse.AvsResultCode != 'D') {
                                    if (transactionResponse.AvsResultCode == 'NNN' || transactionResponse.AvsResultCode == 'NN' || transactionResponse.AvsResultCode == 'N') {
                                        returnMessage += 'AddressNotMatch@';
                                        returnMessage += 'ZipNotMatch@';
                                        AVSMatch = false;
                                    } else if (transactionResponse.AvsResultCode == 'NYZ' || transactionResponse.AvsResultCode == 'Z' || transactionResponse.AvsResultCode == 'NYW' || transactionResponse.AvsResultCode == 'W' ||
                                        transactionResponse.AvsResultCode == 'P') {
                                        returnMessage += 'AddressNotMatch@';
                                        returnMessage += 'ZipCodeMatch@';
                                        AVSMatch = false;
                                    } else if (transactionResponse.AvsResultCode == 'YNA' || transactionResponse.AvsResultCode == 'A' || transactionResponse.AvsResultCode == 'YNY' ||
                                        transactionResponse.AvsResultCode == 'B' || transactionResponse.AvsResultCode == 'M') {
                                        returnMessage += 'AddressMatch@';
                                        returnMessage += 'ZipNotMatch@';
                                        AVSMatch = false;
                                    } else if (transactionResponse.AvsResultCode == 'YYG') {
                                        returnMessage += 'AddressMatch@';
                                        returnMessage += 'Not Compatible@';
                                        AVSMatch = false;
                                    } else if (transactionResponse.AvsResultCode == 'YGG') {
                                        returnMessage += 'Not Compatible@';
                                        returnMessage += 'ZipCodeMatch@';
                                        AVSMatch = false;
                                    } else if (transactionResponse.AvsResultCode == 'XXW') {
                                        returnMessage += 'Card Number Not On File@';
                                        returnMessage += ' @';
                                        AVSMatch = false;
                                    } else if (transactionResponse.AvsResultCode == 'XXU') {
                                        returnMessage += 'Address Information not verified for domestic transaction@';
                                        returnMessage += ' @';
                                        AVSMatch = false;
                                    } else if (transactionResponse.AvsResultCode == 'XXR' || transactionResponse.AvsResultCode == 'R' || transactionResponse.AvsResultCode == 'U' || transactionResponse.AvsResultCode == 'E') {
                                        returnMessage += 'Retry / System Unavailable@';
                                        returnMessage += ' @';
                                        AVSMatch = false;
                                    } else if (transactionResponse.AvsResultCode == 'XXS' || transactionResponse.AvsResultCode == 'S') {
                                        returnMessage += 'Service Not Supported@';
                                        returnMessage += ' @';
                                        AVSMatch = false;
                                    } else if (transactionResponse.AvsResultCode == 'XXE') {
                                        returnMessage += 'Address Verification Not Allowed For Card Type@';
                                        returnMessage += ' @';
                                        AVSMatch = false;
                                    } else if (transactionResponse.AvsResultCode == 'XXG' || transactionResponse.AvsResultCode == 'G' || transactionResponse.AvsResultCode == 'C' || transactionResponse.AvsResultCode == 'I') {
                                        returnMessage += 'Global Non-AVS participant@';
                                        returnMessage += ' @';
                                        AVSMatch = false;
                                    } else if (transactionResponse.AvsResultCode == 'YYY' && transactionResponse.CardCodeResultCode == 'P') {
                                        returnMessage += 'AddressMatch@';
                                        returnMessage += 'ZipCodeMatch@';
                                    } else {
                                        returnMessage += ' @';
                                        returnMessage += ' @';
                                    }
                                } else {
                                    string add = transactionResponse.AvsResult;
                                    if (add.contains('No AVS response')) {
                                        returnMessage += 'StreetNotMatch@';
                                        returnMessage += 'ZipNotMatch@';
                                        AVSMatch = false;
                                    } else {
                                        list < string > arr = add.split('&');
                                        string address = arr[0].substringAfter(':');
                                        string zipcode = arr[1].substringAfter(':');
                                        if (address.trim() != 'Match') {
                                            returnMessage += 'AddressNotMatch@';
                                            AVSMatch = false;
                                        } else {
                                            returnMessage += 'AddressMatch@';
                                        }
                                        if (zipcode.trim() != 'Match') {
                                            returnMessage += 'ZipNotMatch@';
                                            AVSMatch = false;
                                        } else {
                                            returnMessage += 'ZipCodeMatch@';
                                        }
                                    }
                                }
                            } else {
                                return Configuration.GATEWAYERRORMESSAGESTRING + '\'' + transactionResponse.Error + '\''; //updated @wqkl on 29Jan21 against Error message modification
                            }
                            if (AVSMatch != true) {
                                returnMessage += transactionResponse.ResultCode + '@';
                                returnMessage += transactionPayload.methodID + '@';
                                returnMessage += transactionResponse.Error + '@';
                                ebcLogger.debug(ClassName, MethodName, 'resResultCode:' + strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode)));
                                ebcLogger.debug(ClassName, MethodName, 'paymentMethodIDVar:' + strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentMethodIDVar)));
                                ebcLogger.debug(ClassName, MethodName, 'resError:' + strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resError)));
                                ebcLogger.debug(ClassName, MethodName, 'returnMessage:' + returnMessage);
                                return returnMessage.removeEnd('@');
                            }
                        }
                    }
                }
                //AVS Checks - End
                if (responseMerchant.UseFullAmountForAVS == true && strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode)) != Configuration.EMPTYSTRING) {
                    ebcLogger.debug(ClassName, MethodName, 'resResultCode:' + strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode)));
                    ebcLogger.debug(ClassName, MethodName, 'paymentMethodIDVar:' + strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentMethodIDVar)));
                    ebcLogger.debug(ClassName, MethodName, 'resError:' + strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resError)));
                    ebcLogger.debug(ClassName, MethodName, 'avsRefNum:' + strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.avsRefNum)));
                    transactionResponse.ResultCode = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode));
                    paymentMethodID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentMethodIDVar));
                    transactionResponse.Error = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resError));
                    transactionResponse.RefNum = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.avsRefNum));
                }
            } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingACH)) {
                transactionPayload.methodID = (String) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.selectedACHId));
                transactionResponse = eBc_UtilityController.runTransactionPayment(dml, transactionPayload, sendReceiptTo, addEmails, string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check), ebcLogger);
            } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH)) {
                Account accDetail = eBc_UtilityController.getAccountDetail(dml, (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId)), ebcLogger);
                paymentMethodID = AddPaymentMethod(dml, strMap, string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH), ebcLogger);
                transactionPayload.methodID = Configuration.ACCOUNTMETHODID;
                transactionPayload.AccountName = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
                transactionPayload.Account = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
                transactionPayload.Route = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
                transactionPayload.accountType = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.accType));
                transactionResponse = eBc_UtilityController.runTransactionOnlyAccountTab(dml, transactionPayload, accDetail, strMap, paymentMethodID, ebcLogger);
            }
            String transactionReferenceNum = Configuration.EMPTYSTRING;
            if (transactionResponse.ResultCode == 'A') {
                transactionReferenceNum = transactionResponse.RefNum;
                if ((processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard)) || (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH))) {
                    
                    if (sendReceiptTo == true && (addEmails != null && addEmails != Configuration.EMPTYSTRING)) {
                        //SAL-483
                        ebizchargeServicemodelSoap.EmailReceiptResponse emailReceiptResponse = new ebizchargeServicemodelSoap.EmailReceiptResponse();
                        emailReceiptResponse = ebiz.EmailReceipt(eBc_UtilityController.getSecurityToken(dml, ebcLogger), transactionReferenceNum, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, addEmails);
                        if (emailReceiptResponse.StatusCode == 1) {
                            ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent');
                        } else {
                            ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent Error ');
                        }
                    }
                }
                EBizCharge_Transaction__c transactionEntity = new EBizCharge_Transaction__c();
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Account_Id__c.isCreateable()) {
                    transactionEntity.Account_Id__c = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId));
                }
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Ref_Number__c.isCreateable()) {
                    transactionEntity.Ref_Number__c = transactionReferenceNum;
                }
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Payment_Method__c.isCreateable()) {
                    transactionEntity.Payment_Method__c = paymentMethodID;
                }
                eBc_UtilityController.saveTransaction(dml, transactionReferenceNum, transactionEntity, ebcLogger);
                Account updateAccount = new Account();
                updateAccount.Id = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId));
                double accountAmount = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.accAmount));
                if (accountAmount == null) {
                    accountAmount = 0;
                }
                double accountTax = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.accTax));
                if (accountTax == null) {
                    accountTax = 0;
                }
                if (Schema.sObjectType.Account.fields.EBizCharge_Amount__c.isUpdateable()) {
                    updateAccount.EBizCharge_Amount__c = accountAmount + amount + tax;
                }
                if (Schema.sObjectType.Account.fields.EBizCharge_Reference_Number__c.isUpdateable()) {
                    updateAccount.EBizCharge_Reference_Number__c = transactionReferenceNum;
                }
                if (Schema.sObjectType.Account.fields.EBizCharge_Account_Tax__c.isUpdateable()) {
                    updateAccount.EBizCharge_Account_Tax__c = accountTax + tax;
                }
                if (Schema.sObjectType.Account.isUpdateable()) {
                    if (!Test.isRunningTest()) {
                        dml.updateRecord(updateAccount);
                    }
                }
                return string.valueOf(Enums.RETURNMESSAGE.Success);
            } else {
                return Configuration.ERRORMESSAGESTRING + transactionResponse.Error;
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return Configuration.EXCEPTIONMESSAGE;
        }
    }
    @AuraEnabled
    public static String processPaymentWithXCApxc(String savedCardJson) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = processPaymentWithXCApxc(dml, savedCardJson, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String processPaymentWithXCApxc(DML dml, String savedCardJson, EBC_Logger ebcLogger) {
        MethodName = 'processPaymentWithXCApxc';
        Map < String, Object > savedCardMap = (Map < String, Object > ) JSON.deserializeUntyped(savedCardJson);
        String response = processPayment(dml, savedCardMap, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingCard), ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String processPaymentWithNCApxc(String addNewCardJSON) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = processPaymentWithNCApxc(dml, addNewCardJSON, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String processPaymentWithNCApxc(DML dml, String addNewCardJSON, EBC_Logger ebcLogger) {
        MethodName = 'processPaymentWithNCApxc';
        try {
            Map < String, Object > addNewCardMap = (Map < String, Object > ) JSON.deserializeUntyped(addNewCardJSON);
            Boolean isAVSCheck = (boolean) addNewCardMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isAVSCheck));
            ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant = new ebizchargeServicemodelSoap.MerchantTransactionData();
            if (!Test.isRunningTest()) {
                responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
            } else {
                //********Mock Data*****
                responseMerchant.EnableAVSWarnings = true;
                isAVSCheck = true;
                responseMerchant.UseFullAmountForAVS = false;
            }
            if (responseMerchant.EnableAVSWarnings == false) {
                isAVSCheck = false;
            }
            Boolean AVSMatch = true;
            String returnMessage = Configuration.AVSCHECKSTRING;
            if (isAVSCheck == true && responseMerchant.UseFullAmountForAVS == false) {
                ebizchargeServicemodelSoap.TransactionResponse transactionResponse = new ebizchargeServicemodelSoap.TransactionResponse();
                if (!Test.isRunningTest()) {
                    transactionResponse = eBc_UtilityController.runAVSCheck(dml, addNewCardMap, ebcLogger);
                } else {
                    //********Mock Data*****
                    transactionResponse = new ebizchargeServicemodelSoap.TransactionResponse();
                    transactionResponse.AvsResultCode = 'YYY';
                    transactionResponse.AvsResult = 'rt&data';
                    transactionResponse.ErrorCode = '0';
                    transactionResponse.CardCodeResultCode = 'M';
                }
                if (transactionResponse.ErrorCode == '0') {
                    returnMessage += transactionResponse.RefNum + '@';
                    if (transactionResponse.CardCodeResultCode != 'M') {
                        returnMessage += 'CardCodeNotMatch@';
                        AVSMatch = false;
                    } else {
                        returnMessage += 'CardCodeMatch@';
                    }
                    if (transactionResponse.AvsResultCode != 'YYY' || transactionResponse.AvsResultCode != 'Y' || transactionResponse.AvsResultCode != 'YYA' || transactionResponse.AvsResultCode != 'YYD' ||
                        transactionResponse.AvsResultCode != 'YYX' || transactionResponse.AvsResultCode != 'X' || transactionResponse.AvsResultCode != 'GGG' || transactionResponse.AvsResultCode != 'D') {
                        if (transactionResponse.AvsResultCode == 'NNN' || transactionResponse.AvsResultCode == 'NN' || transactionResponse.AvsResultCode == 'N') {
                            returnMessage += 'AddressNotMatch@';
                            returnMessage += 'ZipNotMatch@';
                            AVSMatch = false;
                        } else if (transactionResponse.AvsResultCode == 'NYZ' || transactionResponse.AvsResultCode == 'Z' || transactionResponse.AvsResultCode == 'NYW' || transactionResponse.AvsResultCode == 'W' ||
                            transactionResponse.AvsResultCode == 'P') {
                            returnMessage += 'AddressNotMatch@';
                            returnMessage += 'ZipCodeMatch@';
                            AVSMatch = false;
                        } else if (transactionResponse.AvsResultCode == 'YNA' || transactionResponse.AvsResultCode == 'A' || transactionResponse.AvsResultCode == 'YNY' ||
                            transactionResponse.AvsResultCode == 'B' || transactionResponse.AvsResultCode == 'M') {
                            returnMessage += 'AddressMatch@';
                            returnMessage += 'ZipNotMatch@';
                            AVSMatch = false;
                        } else if (transactionResponse.AvsResultCode == 'YYG') {
                            returnMessage += 'AddressMatch@';
                            returnMessage += 'Not Compatible@';
                            AVSMatch = false;
                        } else if (transactionResponse.AvsResultCode == 'YGG') {
                            returnMessage += 'Not Compatible@';
                            returnMessage += 'ZipCodeMatch@';
                            AVSMatch = false;
                        } else if (transactionResponse.AvsResultCode == 'XXW') {
                            returnMessage += 'Card Number Not On File@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (transactionResponse.AvsResultCode == 'XXU') {
                            returnMessage += 'Address Information not verified for domestic transaction@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (transactionResponse.AvsResultCode == 'XXR' || transactionResponse.AvsResultCode == 'R' || transactionResponse.AvsResultCode == 'U' || transactionResponse.AvsResultCode == 'E') {
                            returnMessage += 'Retry / System Unavailable@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (transactionResponse.AvsResultCode == 'XXS' || transactionResponse.AvsResultCode == 'S') {
                            returnMessage += 'Service Not Supported@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (transactionResponse.AvsResultCode == 'XXE') {
                            returnMessage += 'Address Verification Not Allowed For Card Type@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (transactionResponse.AvsResultCode == 'XXG' || transactionResponse.AvsResultCode == 'G' || transactionResponse.AvsResultCode == 'C' || transactionResponse.AvsResultCode == 'I') {
                            returnMessage += 'Global Non-AVS participant@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (transactionResponse.AvsResultCode == 'YYY' && transactionResponse.CardCodeResultCode == 'P') {
                            returnMessage += 'AddressMatch@';
                            returnMessage += 'ZipCodeMatch@';
                        } else {
                            returnMessage += ' @';
                            returnMessage += ' @';
                        }
                    } else {
                        string add = transactionResponse.AvsResult;
                        if (add.contains('No AVS response')) {
                            returnMessage += 'StreetNotMatch@';
                            returnMessage += 'ZipNotMatch@';
                            AVSMatch = false;
                        } else {
                            list < string > arr = add.split('&');
                            string address = arr[0].substringAfter(':');
                            string zipcode = arr[1].substringAfter(':');
                            if (address.trim() != 'Match') {
                                returnMessage += 'AddressNotMatch@';
                                AVSMatch = false;
                            } else {
                                returnMessage += 'AddressMatch@';
                            }
                            if (zipcode.trim() != 'Match') {
                                returnMessage += 'ZipNotMatch@';
                                AVSMatch = false;
                            } else {
                                returnMessage += 'ZipCodeMatch@';
                            }
                        }
                    }
                } else {
                    return Configuration.GATEWAYERRORMESSAGESTRING + '\'' + transactionResponse.Error + '\''; //updated @wqkl on 29Jan21 against Error message modification
                }
                if (AVSMatch != true) {
                    returnMessage += '@';
                    returnMessage += '@';
                    returnMessage += '@';
                    return returnMessage.removeEnd('@');
                } else {
                    invokeTransactionVoidApxc(dml, transactionResponse.RefNum, ebcLogger);
                }
            }
            String response = processPayment(dml, addNewCardMap, string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard), ebcLogger);
            return response;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return Configuration.EXCEPTIONMESSAGE;
        }
    }
    @AuraEnabled
    public static String procesPaymentWithSavedACHApxc(String savedACHJSON) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = procesPaymentWithSavedACHApxc(dml, savedACHJSON, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String procesPaymentWithSavedACHApxc(DML dml, String savedACHJSON, EBC_Logger ebcLogger) {
        MethodName = 'procesPaymentWithSavedACHApxc';
        Map < String, Object > savedAChMap = (Map < String, Object > ) JSON.deserializeUntyped(savedACHJSON);
        String response = processPayment(dml, savedAChMap, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingACH), ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String processPaymentNewACHApxc(String addNewACHJSON) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = processPaymentNewACHApxc(dml, addNewACHJSON, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String processPaymentNewACHApxc(DML dml, String addNewACHJSON, EBC_Logger ebcLogger) {
        MethodName = 'processPaymentNewACHApxc';
        Map < String, Object > newACHmap = (Map < String, Object > ) JSON.deserializeUntyped(addNewACHJSON);
        String response = processPayment(dml, newACHmap, string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH), ebcLogger);
        return response;
    }
    @AuraEnabled
    public static void invokeTransactionVoidApxc(String avsRefNum) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        invokeTransactionVoidApxc(dml, avsRefNum, ebcLogger);
        ebcLogger.saveLogs();
    }
    public static void invokeTransactionVoidApxc(DML dml, String avsRefNum, EBC_Logger ebcLogger) {
        MethodName = 'invokeTransactionVoidApxc';
        ebizchargeServicemodelSoap.TransactionRequestObject transactionRequest = new ebizchargeServicemodelSoap.TransactionRequestObject();
        String paymentMethodID = Configuration.VOIDTRANSACTIONCOMMAND;
        Decimal paymentStatus = 3;
        transactionRequest.Command = paymentMethodID;
        transactionRequest.IgnoreDuplicate = true;
        transactionRequest.RefNum = avsRefNum;
        transactionRequest.IsRecurring = false;
        transactionRequest.CustReceipt = false;
        try {
            if (!test.isRunningTest()) {
                ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
                response = ebiz.runTransaction(eBc_UtilityController.getSecurityToken(dml, ebcLogger), transactionRequest);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    // added by @wqkl against Person Account RecType issue fix - (21jan21) - start
    @AuraEnabled
    public static Id getPARecTypeId() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        Id reciprocate = getPARecTypeId(dml, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static Id getPARecTypeId(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getPARecTypeId';
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        String queryLimit = Configuration.EMPTYSTRING;
        Id recordTypeId;
        try {
            if (Schema.sObjectType.Account.fields.getMap().containsKey('isPersonAccount')) {
                querySelect = 'Select id,name,sObjectType,DeveloperName';
                queryFrom = 'from RecordType';
                queryWhere = 'where sObjectType = \'Account\' and DeveloperName =\'PersonAccount\'';
                RecordType recordType = (RecordType) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                recordTypeId = recordType.Id;
            } else {
                recordTypeId = null;
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return recordTypeId;
    }
    @AuraEnabled
    public static Boolean isPersonAccount() {
        return Schema.sObjectType.Account.fields.getMap().containsKey('isPersonAccount');
    }
    @AuraEnabled 
    public static List<RecordType> accountRecordDataApxc() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List<RecordType> reciprocate = accountRecordDataApxc(dml,ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static  List<RecordType>  accountRecordDataApxc(DML dml,EBC_Logger ebcLogger) {
        MethodName = 'accountRecordDataApxc';
       string  querySelect = 'SELECT Id,Name';
       string  queryfrom = 'FROM RecordType';
       string queryWhere = 'where sObjectType = \'Account\'';
       List<RecordType>  accountsList = (List<RecordType>)dml.selectRecords(querySelect, queryFrom, queryWhere,  Configuration.EMPTYSTRING,  Configuration.EMPTYSTRING,  Configuration.EMPTYSTRING);
    return accountsList;
    }
    public class accDetail {
        @AuraEnabled public EBizcharge_Setting__c Settings {
            get;
            set;
        }
        @AuraEnabled public Account AccountInfo {
            get;
            set;
        }
        @AuraEnabled public map < string, string > savedPaymentMethods {
            get;
            set;
        }
        @AuraEnabled public Boolean UseFullAmountForAVS {
            get;
            set;
        }
    }
    public class AccountWrapper {
        @AuraEnabled public boolean isSelected {
            get;
            set;
        }
        @AuraEnabled public String accHyperUrl {
            get;
            set;
        }
        @AuraEnabled public String accId {
            get;
            set;
        }
        @AuraEnabled public String accName {
            get;
            set;
        }
        @AuraEnabled public Decimal accAmount {
            get;
            set;
        }
        @AuraEnabled public String accFirstName {
            get;
            set;
        }
        @AuraEnabled public String accLastName {
            get;
            set;
        }
        @AuraEnabled public String accEmail {
            get;
            set;
        }
        @AuraEnabled public String accPhone {
            get;
            set;
        }
        @AuraEnabled public String accExtId {
            get;
            set;
        }
        @AuraEnabled public String accStatus {
            get;
            set;
        }
        @AuraEnabled public String accBillingStreet {
            get;
            set;
        }
        @AuraEnabled public String accBillingCity {
            get;
            set;
        }
        @AuraEnabled public String accBillingState {
            get;
            set;
        }
        @AuraEnabled public String accBillingPostalCode {
            get;
            set;
        }
        @AuraEnabled public String accBillingCountry {
            get;
            set;
        }
        @AuraEnabled public String accShippingCity {
            get;
            set;
        }
        @AuraEnabled public String accShippingState {
            get;
            set;
        }
        @AuraEnabled public String accShippingPostalCode {
            get;
            set;
        }
        @AuraEnabled public String accShippingCountry {
            get;
            set;
        }
        @AuraEnabled public String accShippingStreet {
            get;
            set;
        }
        @AuraEnabled public Decimal Gateway_Monthly_Fee {
            get;
            set;
        }
        @AuraEnabled public Date Approved_Date {
            get; 
            set;
        }
        @AuraEnabled public String Qbd_Customer_Id {
            get; 
            set;
        }
    }
    public class emailWrapperclass {
        @AuraEnabled public String TemplateName {
            get;
            set;
        }
        @AuraEnabled public String TemplateType {
            get;
            set;
        }
        @AuraEnabled public String TemplateInternalId {
            get;
            set;
        }
        @AuraEnabled public String TemplateSubject {
            get;
            set;
        }
        @AuraEnabled public String FromEmail {
            get;
            set;
        }
        @AuraEnabled public String ReplyToEmail {
            get;
            set;
        }
    }
}