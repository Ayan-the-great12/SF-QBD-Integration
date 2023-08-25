public with sharing class eBc_RecurringController {
    public static string ClassName = 'eBc_RecurringController';
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
        return eBc_UtilityController.getSettings(dml, ebcLogger);
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
        string accountInternalId = Configuration.EMPTYSTRING;
        try {
            Account accountDetail = eBc_UtilityController.getAccountDetail(dml, AccountId, ebcLogger);
            // add customer on Gateway
            ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = eBc_UtilityController.invoke_addORUpdCustomer(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger), 'addCustomer', ebcLogger);
            accountInternalId = addCustomerResponse.CustomerInternalId;
            Account account = new Account();
            //account.Id = AccountId;
            account.Id = (string)accountDetail.get('QBD_Customer_ID__c');
            account.EBizCharge_Internal_ID__c = accountInternalId;
            account.EBizCharge_Last_Sync_Date__c = system.now();
            dml.updateRecord(account);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return Configuration.EXCEPTIONMESSAGE;
        }
    }
    @auraEnabled
    public static AccountWrapper getAccountDetailApxc(String objID) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        AccountWrapper reciprocate = getAccountDetailApxc(dml, objID, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static AccountWrapper getAccountDetailApxc(DML dml, String objID, EBC_Logger ebcLogger) {
        AccountWrapper accountWrapper = new AccountWrapper();
        Account accountDetail;
        Contact contactDetail;
        Ebiz_C__EBizCharge_Fields_Config__c customEntityDetail;
        string accountInternalId = Configuration.EMPTYSTRING;
        try {
            id identifier = (id) objID;
            Schema.SObjectType sObjectType = identifier.getSObjectType();
            Schema.DescribeSObjectResult sObjectDescription = sObjectType.getDescribe();
            if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)) {
                accountDetail = eBc_UtilityController.getAccountDetail(dml, objID, ebcLogger);
                accountInternalId = accountDetail.EBizCharge_Internal_ID__c;
                //sf-628=============
                string querySelect = 'select id,billingstreet,billingcity,billingstate,billingPostalCode,BillingCountry';
                string queryFrom = 'from account';
                string queryWhere = 'where id=\'' + objID + '\'';
                account accountEntity = (account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                string shippingAddress = Configuration.EMPTYSTRING;
                if (accountEntity != null) {
                    if (accountEntity.billingstreet != null && accountEntity.billingstreet != Configuration.EMPTYSTRING) {
                        shippingAddress = shippingAddress + accountEntity.billingstreet;
                    }
                    if (accountEntity.billingPostalCode != null && accountEntity.billingPostalCode != Configuration.EMPTYSTRING) {
                        accountWrapper.ZipCode = accountEntity.billingPostalCode;
                    }
                }
                accountWrapper.Address = shippingAddress;
                accountWrapper.Object_Name = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account);
                if (test.isRunningTest()) {
                    accountInternalId = '';
                }
                if (accountInternalId == null || accountInternalId == Configuration.EMPTYSTRING) {
                    // sync if Account on Gateway
                    ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = eBc_UtilityController.invoke_addORUpdCustomer(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger), 'addCustomer', ebcLogger);
                    accountInternalId = addCustomerResponse.CustomerInternalId;
                    accountDetail.EBizCharge_Internal_ID__c = accountInternalId;
                }
            }
            if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
                // sync if contact customer on 
                contactDetail = eBc_UtilityController.getContactDetail(dml, objID, ebcLogger);
                accountInternalId = contactDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c;
                //sf-628=============
                string querySelect = 'select id,Mailingstreet,Mailingcity,Mailingstate,MailingPostalCode,MailingCountry';
                string queryFrom = 'from contact';
                string queryWhere = 'where id=\'' + contactDetail.Id + '\'';
                Contact contactEntity = (Contact) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                string shippingAddress = Configuration.EMPTYSTRING;
                if (contactEntity != null) {
                    if (contactEntity.Mailingstreet != null && contactEntity.Mailingstreet != Configuration.EMPTYSTRING) {
                        shippingAddress = shippingAddress + contactEntity.Mailingstreet;
                    }
                    if (contactEntity.MailingPostalCode != null && contactEntity.MailingPostalCode != Configuration.EMPTYSTRING) {
                        accountWrapper.ZipCode = contactEntity.MailingPostalCode;
                    }
                }
                accountWrapper.Address = shippingAddress;
                accountWrapper.Object_Name = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact);
                if (test.isRunningTest()) {
                    accountInternalId = '';
                }
                if (accountInternalId == null || accountInternalId == Configuration.EMPTYSTRING) {
                    ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = eBc_UtilityController.invoke_addORUpdCustomerContact(dml, contactDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger), 'addCustomer', ebcLogger);
                    accountInternalId = addCustomerResponse.CustomerInternalId;
                    contactDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c = accountInternalId;
                }
            }
            if (sObjectDescription.getName().contains(Configuration.CUSTOMOBJECTIDENTFIER)) {
                customEntityDetail = eBc_UtilityController.getCustomFieldDetail(dml, objID, ebcLogger);
                accountInternalId = customEntityDetail.EBizCharge_Internal_ID__c;
                accountWrapper.Object_Name = string.valueOf(Enums.SALESFORCEOBJECTNAMES.custom);
            }
            // get Customer Saved Payment Method
            map < string, string > savedPaymentMethods = eBc_UtilityController.GetCustomerSavedPaymentMethods(dml, objID, accountInternalId, ebcLogger);
            accountWrapper.savedPaymentMethods = savedPaymentMethods;
            ebcLogger.debug(ClassName, MethodName, '<Check123 ' + savedPaymentMethods);
            accountWrapper.accountDetail = accountDetail;
            accountWrapper.contactDetail = contactDetail;
            accountWrapper.custDetail = customEntityDetail;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return accountWrapper;
    }
    @auraEnabled
    public static AccountWrapper getSavedCardsApxc(String AccountID, String accExtId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        AccountWrapper reciprocate = getSavedCardsApxc(dml, AccountID, accExtId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static AccountWrapper getSavedCardsApxc(DML dml, String AccountID, String accExtId, EBC_Logger ebcLogger) {
        AccountWrapper accountWrapper = new AccountWrapper();
        String querySelect = 'select id,QBD_Customer_ID__c';
        String queryFrom = 'from Account';
        String queryWhere =  'where id=\''+ AccountID+'\'';
        Account account = (Account)dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
        map < string, string > savedPaymentMethods = eBc_UtilityController.GetCustomerSavedPaymentMethods(dml, (string)account.get('QBD_Customer_ID__c'), accExtId, ebcLogger);
        accountWrapper.savedPaymentMethods = savedPaymentMethods;
        return accountWrapper;
    }
    @auraEnabled
    public static String runRecurringApxc(String rrInfoJSON, String actionStatus) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = runRecurringApxc(dml, rrInfoJSON, actionStatus, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String runRecurringApxc(DML dml, String rrInfoJSON, String actionStatus, EBC_Logger ebcLogger) {
        String returnMessage = Configuration.EMPTYSTRING;
        try {
            Map < String, Object > recurringDetailMap = (Map < String, Object > ) JSON.deserializeUntyped(rrInfoJSON);
            Boolean isAVSCheck = (boolean) recurringDetailMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isAVSCheck));
            ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
            if (!Test.isRunningTest()) {
                responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
                if (responseMerchant.EnableAVSWarnings == false) {
                    isAVSCheck = false;
                }
            } else {
                responseMerchant = new ebizchargeServicemodelSoap.MerchantTransactionData();
                responseMerchant.UseFullAmountForAVS = false;
            }
            String customerId = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.accId));
            String querySelect = 'select id,QBD_Customer_ID__c';
            String queryFrom = 'from Account';
            String queryWhere =  'where id=\''+customerId +'\'';
            Account account = (Account)dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
            Boolean AVSMatch = true;
            returnMessage = Configuration.AVSCHECKSTRING;
            String paymentType = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.payBy));
            //String accountId = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.accId));
            String accountId = (string)account.get('QBD_Customer_ID__c');
            String accExtrId = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.accExtrId));
            String objtype = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.objectName));
            Boolean sendReceiptTo = (boolean) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
            String addEmails = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.addEmails));
            String customerToken = Configuration.EMPTYSTRING;
            if (!Test.isRunningTest()) {
                customerToken = eBc_UtilityController.getCustomerToken(dml, accountId, accExtrId, ebcLogger);
            }
            transactionParams transactionPayload = new transactionParams();
            transactionPayload.accountID = accountId;
            transactionPayload.customerID = accountId;
            transactionPayload.internalID = accExtrId;
            transactionPayload.customerToken = customerToken;
            transactionPayload.Amount = (double) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Amount));
            transactionPayload.Tax = (double) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Tax));
            string startDate = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrStartDate));
            string endDate = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrEndDate));
            Boolean recurringIndefinite = (Boolean) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrIndefinit));
            if (recurringIndefinite == true) {
                endDate = Configuration.DEFAULTENDDATE;
            }
            transactionPayload.Start = Date.valueOf(startDate);
            transactionPayload.Expire = Date.valueOf(endDate);
            transactionPayload.ScheduleName = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrPayName));
            transactionPayload.Schedule = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrFrequency));
            transactionPayload.Notes = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrNotes));
            ebcLogger.debug(ClassName, MethodName, 'PAymenttypevalue ' + paymentType);
            if (paymentType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.UseExistingCard)) {
                transactionPayload.methodID = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.selectedCard));
                transactionPayload.CardCode = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
            } else if (paymentType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.AddNewCard)) {
                if (isAVSCheck == true && responseMerchant.UseFullAmountForAVS == false) {
                    ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
                    if (!Test.isRunningTest()) {
                        response = eBc_UtilityController.runAVSCheck(dml, recurringDetailMap, ebcLogger);
                    } else {
                        response.CardCodeResultCode = 'Y';
                        response.AvsResultCode = 'YYY';
                        response.AvsResult = 'test&Y';
                    }
                    if (response.ErrorCode == '0') {
                        returnMessage += response.RefNum + '@';
                        if (response.CardCodeResultCode != 'M') {
                            returnMessage += 'CardCodeNotMatch@';
                            AVSMatch = false;
                        } else {
                            returnMessage += 'CardCodeMatch@';
                        }
                        if (response.AvsResultCode != 'YYY' || response.AvsResultCode != 'Y' || response.AvsResultCode != 'YYA' || response.AvsResultCode != 'YYD' || response.AvsResultCode != 'YYX' || response.AvsResultCode != 'X' || response.AvsResultCode != 'GGG' || response.AvsResultCode != 'D') {
                            if (response.AvsResultCode == 'NNN' || response.AvsResultCode == 'NN' || response.AvsResultCode == 'N') {
                                returnMessage += 'AddressNotMatch@';
                                returnMessage += 'ZipNotMatch@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == 'NYZ' || response.AvsResultCode == 'Z' || response.AvsResultCode == 'NYW' || response.AvsResultCode == 'W' || response.AvsResultCode == 'P') {
                                returnMessage += 'AddressNotMatch@';
                                returnMessage += 'ZipCodeMatch@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == 'YNA' || response.AvsResultCode == 'A' || response.AvsResultCode == 'YNY' || response.AvsResultCode == 'B' || response.AvsResultCode == 'M') {
                                returnMessage += 'AddressMatch@';
                                returnMessage += 'ZipNotMatch@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == 'YYG') {
                                returnMessage += 'AddressMatch@';
                                returnMessage += 'Not Compatible@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == 'YGG') {
                                returnMessage += 'Not Compatible@';
                                returnMessage += 'ZipCodeMatch@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == 'XXW') {
                                returnMessage += 'Card Number Not On File@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == 'XXU') {
                                returnMessage += 'Address Information not verified for domestic transaction@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == 'XXR' || response.AvsResultCode == 'R' || response.AvsResultCode == 'U' || response.AvsResultCode == 'E') {
                                returnMessage += 'Retry / System Unavailable@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == 'XXS' || response.AvsResultCode == 'S') {
                                returnMessage += 'Service Not Supported@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == 'XXE') {
                                returnMessage += 'Address Verification Not Allowed For Card Type@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == 'XXG' || response.AvsResultCode == 'G' || response.AvsResultCode == 'C' || response.AvsResultCode == 'I') {
                                returnMessage += 'Global Non-AVS participant@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == 'YYY' && response.CardCodeResultCode == 'P') {
                                returnMessage += 'AddressMatch@';
                                returnMessage += 'ZipCodeMatch@';
                            } else {
                                returnMessage += ' @';
                                returnMessage += ' @';
                            }
                        } else {
                            string responseAVSstring = response.AvsResult;
                            if (responseAVSstring.contains('No AVS response')) {
                                returnMessage += 'StreetNotMatch@';
                                returnMessage += 'ZipNotMatch@';
                                AVSMatch = false;
                            } else {
                                list < string > arr = responseAVSstring.split('&');
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
                        if (AVSMatch != true) {
                            return returnMessage.removeEnd('@');
                        } else {
                            invokeTransactionVoidApxc(dml, response.RefNum, ebcLogger);
                        }
                    } else {
                        return Configuration.GATEWAYERRORMESSAGESTRING + '\'' + response.Error + '\''; //updated @wqkl on 29Jan21 against Error message modification
                    }
                }
                transactionPayload.ccNumber = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
                transactionPayload.expMonth = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
                transactionPayload.expYear = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
                transactionPayload.cvvCode = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
                transactionPayload.ccName = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
                transactionPayload.AvsStreet = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
                transactionPayload.AvsZip = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
                transactionPayload.saveCard = (boolean) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
                transactionPayload.MethodName = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
                if (!Test.isRunningTest()) {
                    transactionPayload.methodID = eBc_UtilityController.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                }
            } else if (paymentType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.savedACH)) {
                transactionPayload.methodID = (String) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.selectedACHId));
                ebcLogger.debug(ClassName, MethodName, '>>PConatct,pay ' + paymentType);
            } else if (paymentType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.addNewACH)) {
                transactionPayload.AccountName = (string) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
                ebcLogger.debug(ClassName, MethodName, '>>bankaccountcheck');
                transactionPayload.Account = (string) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
                transactionPayload.Route = (string) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
                transactionPayload.MethodName = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
                transactionPayload.accountType = (String) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.accType));
                transactionPayload.methodID = eBc_UtilityController.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH), ebcLogger);
            }
            string response = Configuration.EMPTYSTRING;
            if (!Test.isRunningTest()) {
                if (actionStatus == Configuration.UPDATEACTION) {
                    String scheduledPaymentId = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.SchedPayInternalId));
                    response = eBc_UtilityController.runRecurringPayment(dml, transactionPayload, sendReceiptTo, scheduledPaymentId, actionStatus, addEmails, ebcLogger);
                    ebcLogger.debug(ClassName, MethodName, 'FromNew ' + response);
                } else {
                    response = eBc_UtilityController.runRecurringPayment(dml, transactionPayload, sendReceiptTo, Configuration.EMPTYSTRING, actionStatus, addEmails, ebcLogger);
                }
            }
            returnMessage = 'RecurringScheduled@' + response;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            returnMessage = 'Exception@' + e;
        }
        return returnMessage;
    }
    @auraEnabled
    public static List < recurring > getScheduledRecurringApxc(String SearchId, String Status) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < recurring > reciprocate = getScheduledRecurringApxc(dml, SearchId, Status, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < recurring > getScheduledRecurringApxc(DML dml, String SearchId, String Status, EBC_Logger ebcLogger) {
        string accountInternalId = Configuration.EMPTYSTRING;
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.RecurringBillingDetails[] recurringBillingDetailsList;
        ebizchargeServicemodelSoap.ArrayOfRecurringBillingDetails arrayOfRecurring = new ebizchargeServicemodelSoap.ArrayOfRecurringBillingDetails();
        Account accountDetail = new Account();
        Contact contactDetail = new Contact();
        Ebiz_C__EBizCharge_Fields_Config__c customEntityDetail = new Ebiz_C__EBizCharge_Fields_Config__c();
        list < recurring > recurringRecords = new list < recurring > ();
        try {
            if (SearchId != null && SearchId != Configuration.EMPTYSTRING) {
                string custId = Configuration.EMPTYSTRING;
                id identifier = (id) SearchId;
                Schema.SObjectType sObjectType = identifier.getSObjectType();
                Schema.DescribeSObjectResult sObjectDescription = sObjectType.getDescribe();
                if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)) {
                    ebcLogger.debug(ClassName, MethodName, '>>>sObjectDescription.getName()' + sObjectDescription.getName());
                    accountDetail = eBc_UtilityController.getAccountDetail(dml, SearchId, ebcLogger);
                    accountInternalId = accountDetail.EBizCharge_Internal_ID__c;
                    custId =(String)accountDetail.get('QBD_Customer_ID__c');
                }
                if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
                    ebcLogger.debug(ClassName, MethodName, '>>>sObjectDescription.getName()' + sObjectDescription.getName());
                    contactDetail = eBc_UtilityController.getContactDetail(dml, SearchId, ebcLogger);
                    accountInternalId = contactDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c;
                    custId = contactDetail.Id;
                }
                if (sObjectDescription.getName().contains(Configuration.CUSTOMOBJECTIDENTFIER)) {
                    customEntityDetail = eBc_UtilityController.getCustomFieldDetail(dml, SearchId, ebcLogger);
                    accountInternalId = customEntityDetail.EBizCharge_Internal_ID__c;
                }
                if (accountInternalId != null && accountInternalId != Configuration.EMPTYSTRING) {
                    arrayOfRecurring = ebiz.SearchScheduledRecurringPayments(eBc_UtilityController.getSecurityToken(dml, ebcLogger), accountInternalId,custId , 0, 1000, '1');
                }
            } else {
                arrayOfRecurring = ebiz.SearchScheduledRecurringPayments(eBc_UtilityController.getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, 0, 10000, '1');
            }
            recurringBillingDetailsList = arrayOfRecurring.RecurringBillingDetails;
            List < String > customerIds = new List < String > ();
            list < recurring > scheduledList = new list < recurring > ();
            if (Test.isRunningTest()) {
                ebizchargeServicemodelSoap.RecurringBillingDetails mockData = new ebizchargeServicemodelSoap.RecurringBillingDetails();
                mockData.CustomerId = SearchId;
                mockData.DateTimeCreated = '10/30/2016 3:30:22';
                recurringBillingDetailsList = new ebizchargeServicemodelSoap.RecurringBillingDetails[] {};
                recurringBillingDetailsList.add(mockData);
            }
            for (ebizchargeServicemodelSoap.RecurringBillingDetails recurringDetail: recurringBillingDetailsList) {
                recurring recurring = new recurring();
                if (recurringDetail.CustomerId != null && recurringDetail.CustomerId != Configuration.EMPTYSTRING) {
                    string customerId = recurringDetail.CustomerId;
                    Schema.DescribeSObjectResult accountDescription = Account.sObjectType.getDescribe();
                    String accountPrefix = accountDescription.getKeyPrefix();
                    Schema.DescribeSObjectResult contactDescription = Contact.sObjectType.getDescribe();
                    String contactPrefix = contactDescription.getKeyPrefix();
                    // if ((customerId.startsWith(accountPrefix) || customerId.startsWith(contactPrefix)) || (customerId.length() == 15 || customerId.length() == 18)) {
                        ebcLogger.debug(ClassName, MethodName, 'CustomerId>>>>>>' + CustomerId);
                        customerIds.add(recurringDetail.CustomerId);
                        recurring.accId = recurringDetail.CustomerId;
                        if (accountDetail.Name != null && accountDetail.Name != Configuration.EMPTYSTRING) {
                            recurring.accName = accountDetail.Name;
                        } else {
                            recurring.accName = Configuration.EMPTYSTRING;
                        }
                        string datetimeString = recurringDetail.DateTimeCreated;
                        list < String > splittedDatetime = datetimeString.split(' ');
                        Date dateEntity = Date.parse(splittedDatetime[0]);
                        String[] splittedDateString = splittedDatetime[1].split(':');
                        Time timeEntity = Time.newInstance(Integer.valueOf(splittedDateString[0]) //hour
                            , Integer.valueOf(splittedDateString[1]) //min
                            , Integer.valueOf(splittedDateString[2]) //sec
                            , 0);
                        DateTime sDateTime = DateTime.newInstance(dateEntity, timeEntity);
                        ebcLogger.debug(ClassName, MethodName, '->>recurringDetail.Tax' + recurringDetail.Tax);
                        recurring.rrDateTimeCreated = sDateTime;
                        recurring.accExtId = recurringDetail.CustomerInternalId;
                        recurring.rrPaymentIntId = string.valueOf(recurringDetail.ScheduledPaymentInternalId);
                        recurring.rrScheduleName = recurringDetail.ScheduleName;
                        recurring.rrScheduleStart = recurringDetail.Start;
                        recurring.rrScheduleEnd = recurringDetail.Expire;
                        recurring.rrSchedule = recurringDetail.Schedule;
                        recurring.rrAmount = recurringDetail.Amount;
                        recurring.rrTax = recurringDetail.Tax;
                        recurring.rrNote = recurringDetail.ReceiptNote;
                        recurring.rrMaskedPM = recurringDetail.MaskedPM;
                        recurring.rrPMType = recurringDetail.PMType;
                        recurring.rrScheduleStatus = recurringDetail.ScheduleStatus;
                        recurring.rrPaymentMethodId = recurringDetail.PaymentMethodId;
                        recurring.emails = recurringDetail.CustomerEmailList;
                        recurring.sendReceipt = recurringDetail.SendCustomerReceipt;
                        recurring.isSelected = false;
                        if (Status != null && Status != Configuration.EMPTYSTRING) {
                            if (Status == Configuration.FILTERSHOWALL) {
                                scheduledList.add(recurring);
                            } else if (Status == recurringDetail.ScheduleStatus) {
                                scheduledList.add(recurring);
                            }
                        } else {
                            scheduledList.add(recurring);
                        }
                    //}
                }
            } // end of loop...
            list < String > contactIds = new list < String > ();
            list < String > accountsIds = new list < String > ();
            for (string identifier: customerIds) {
            try{
                id key = (id) identifier;
                Schema.SObjectType sObjectType = key.getSObjectType();
                Schema.DescribeSObjectResult sObjectDescription = sObjectType.getDescribe();
                if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)) {
                    accountsIds.add(key);
                }
                if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
                    contactIds.add(key);  
                }
            }catch(Exception e){
                accountsIds.add(identifier);
            }
            }
            if (Test.isRunningTest()) {
                return null;
            }
            if (customerIds != null) {
                Map < String, String > customerIdsMap = new map < String, String > ();
                Map< String,String > customerIdsMap2 = new map< String,String >();
                if (accountsIds.size() > 0) {
                    List < Account > accountInfolist = eBc_UtilityController.getAccountsDetailForQbd(dml, accountsIds, ebcLogger);
                    for (Account account: accountInfolist) {
                        customerIdsMap.put((String)account.get('QBD_Customer_ID__c'), account.Name);
                        customerIdsMap2.put((String)account.get('QBD_Customer_ID__c'), account.Id);
                    }
                }
                if (contactIds.size() > 0) {
                    List < Contact > contactDetailList = eBc_UtilityController.getContactsDetail(dml, contactIds, ebcLogger);
                    for (Contact contact: contactDetailList) {
                        customerIdsMap.put(contact.id, contact.Name);
                    }
                }
                for (recurring recurring: scheduledList) {
                    if (customerIdsMap.containsKey(recurring.accId)) {
                    try{
                        id identifier = (id) recurring.accId;
                        Schema.SObjectType sObjectType = identifier.getSObjectType();
                        Schema.DescribeSObjectResult sObjectDescription = sObjectType.getDescribe();
                        if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)) {
                            recurring.accName = customerIdsMap.get(recurring.accId);
                            //recurring.RecurringHyperUrl = Configuration.URLIDENTIFIER + recurring.accId;
                            recurring.RecurringHyperUrl = Configuration.URLIDENTIFIER + customerIdsMap2.get(recurring.accId);
                        }
                        if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
                            recurring.RecurringHyperUrl = Configuration.URLIDENTIFIER + recurring.accId;
                            recurring.accName = customerIdsMap.get(recurring.accId);
                        }
                        // if (sObjectDescription.getName().contains(Configuration.CUSTOMOBJECTIDENTFIER)) {
                        //     recurring.RecurringHyperUrl = Configuration.URLIDENTIFIER + recurring.accId;
                        //     recurring.accName = customerIdsMap.get(recurring.accId);
                        // }
                }catch(Exception e){
                    recurring.accName = customerIdsMap.get(recurring.accId);
                    recurring.RecurringHyperUrl = '/'+customerIdsMap2.get(recurring.accId);
                }
                    recurringRecords.add(recurring);
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return recurringRecords;
    }
    @auraEnabled
    public static List < recurringWrapper > ReceivedRRPaymentsApxc(String AccountId, Date fromDate, Date toDate) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < recurringWrapper > reciprocate = ReceivedRRPaymentsApxc(dml, AccountId, fromDate, toDate, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
        //return ReceivedRRPaymentsApxc(dml, AccountId, fromDate, toDate);
    }
    public static List < recurringWrapper > ReceivedRRPaymentsApxc(DML dml, String AccountId, Date fromDate, Date toDate, EBC_Logger ebcLogger) {
        List < recurringWrapper > recurringList = new List < recurringWrapper > ();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.ArrayOfPayment searchRecurringPaymentsResult;
        List < ebizchargeServicemodelSoap.Payment > paymentlist = new list < ebizchargeServicemodelSoap.Payment > ();
        string entityIdentifier = Configuration.EMPTYSTRING;
        string entityName = Configuration.EMPTYSTRING;
        try {
            if (AccountId != null && AccountId != Configuration.EMPTYSTRING) {
                id identifier = (id) AccountId;
                Schema.SObjectType sObjectType = identifier.getSObjectType();
                Schema.DescribeSObjectResult sObjectDescription = sObjectType.getDescribe();
                if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)) {
                    Account accountDetail = eBc_UtilityController.getAccountDetail(dml, AccountId, ebcLogger);
                    entityIdentifier = accountDetail.EBizCharge_Internal_ID__c;
                    entityName = accountDetail.Name;
                }
                if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
                    contact accountDetail = eBc_UtilityController.getContactDetail(dml, AccountId, ebcLogger);
                    entityIdentifier = accountDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c;
                    entityName = accountDetail.Name;
                }
                if (sObjectDescription.getName().contains(Configuration.CUSTOMOBJECTIDENTFIER)) {
                    Ebiz_C__EBizCharge_Fields_Config__c customEntityDetail = eBc_UtilityController.getCustomFieldDetail(dml, AccountId, ebcLogger);
                    entityIdentifier = customEntityDetail.EBizCharge_Internal_ID__c;
                    entityName = customEntityDetail.Name;
                }
            }
            Account accountData;
            if(AccountId != null){
                String querySelect = 'select id,QBD_Customer_ID__c';
                String queryFrom = 'from Account';
                String queryWhere =  'where id=\''+ AccountId+'\'';
                accountData = (Account)dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
            } 
            if (fromDate != null && toDate != null && AccountId != null) {
                searchRecurringPaymentsResult = eBiz.SearchRecurringPayments(eBc_UtilityController.getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, (string)accountData.get('QBD_Customer_ID__c'), entityIdentifier, fromDate, toDate, 0, 1000, '1');
            } else if (fromDate != null && toDate != null) {
                searchRecurringPaymentsResult = eBiz.SearchRecurringPayments(eBc_UtilityController.getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, fromDate, toDate, 0, 1000, '1');
            } else {
                searchRecurringPaymentsResult = eBiz.SearchRecurringPayments(eBc_UtilityController.getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, (string)accountData.get('QBD_Customer_ID__c'), entityIdentifier, fromDate, toDate, 0, 1000, '1');
            }
            paymentlist = searchRecurringPaymentsResult.Payment;
            List < String > customerIds = new List < String > ();
            if (paymentlist != null) {
                for (ebizchargeServicemodelSoap.Payment payment: paymentlist) {
                    recurringWrapper recurringWrapper = new recurringWrapper();
                    if (payment.CustomerId != null && payment.CustomerId != Configuration.EMPTYSTRING) {
                        string customerId = payment.CustomerId;
                        Schema.DescribeSObjectResult accountDescription = Account.sObjectType.getDescribe();
                        String accountPrefix = accountDescription.getKeyPrefix();
                        Schema.DescribeSObjectResult contactDescription = Contact.sObjectType.getDescribe();
                        String contactPrefix = contactDescription.getKeyPrefix();
                            customerIds.add(payment.CustomerId);
                            if (entityName != null && entityName != Configuration.EMPTYSTRING) {
                                recurringWrapper.rrCustomerName = entityName;
                            } else {
                                recurringWrapper.rrCustomerName = Configuration.EMPTYSTRING;
                            }
                            recurringWrapper.rrCustomerId = payment.CustomerId;
                            recurringWrapper.RecurringHyperUrl = Configuration.URLIDENTIFIER + payment.CustomerId;
                            recurringWrapper.rrCustomerName = entityName;
                            recurringWrapper.rrInvoiceNumber = payment.InvoiceNumber;
                            recurringWrapper.rrAmountDue = payment.AmountDue;
                            recurringWrapper.rrAuthCode = payment.AuthCode;
                            recurringWrapper.rrRefNum = payment.RefNum;
                            recurringWrapper.rrLast4 = payment.Last4;
                            recurringWrapper.rrPaymentMethod = payment.PaymentMethod;
                            string datetimeString = payment.DatePaid;
                            List < String > splittedDatetime = datetimeString.split(Configuration.DATETIMESEPARATOR);
                            recurringWrapper.rrDatePaid = Date.valueOf(splittedDatetime[0]);
                            recurringWrapper.rrTimePaid = splittedDatetime[1];
                            recurringWrapper.rrPaidAmount = payment.PaidAmount;
                            recurringWrapper.rrCustNum = payment.CustNum;
                            recurringWrapper.rrPaymentMethodId = payment.PaymentMethodId;
                            recurringWrapper.rrPaymentInternalId = payment.PaymentInternalId;
                            recurringWrapper.rrSchedPayInternalId = payment.ScheduledPaymentInternalId;
                            recurringWrapper.rrScheduledName = Configuration.EMPTYSTRING;
                            recurringWrapper.rrFrequency = Configuration.EMPTYSTRING;
                            recurringList.add(recurringWrapper);
                    }
                } // end of loop...
            }
            list < recurringWrapper > recurringWrapperRecords = new list < recurringWrapper > ();
            list < String > contactIds = new list < String > ();
            list < String > accountsIds = new list < String > ();
            for (string identifier: customerIds) {
                id key = (id) identifier;
                Schema.SObjectType sObjectType = key.getSObjectType();
                Schema.DescribeSObjectResult sObjectDescription = sObjectType.getDescribe();
                ebcLogger.debug(ClassName, MethodName, 'getName>>>' + sObjectDescription.getName());
                ebcLogger.debug(ClassName, MethodName, 'key>>>' + key);
                if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)) {
                    ebcLogger.debug(ClassName, MethodName, 'getName>>>' + sObjectDescription.getName());
                    ebcLogger.debug(ClassName, MethodName, 'key>>>' + key);
                    accountsIds.add(key);
                }
                if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
                    ebcLogger.debug(ClassName, MethodName, 'getName>>>' + sObjectDescription.getName());
                    ebcLogger.debug(ClassName, MethodName, 'key>>>' + key);
                    contactIds.add(key);
                }
            }
            if (customerIds != null) {
                Map < Id, String > customerIdsMap = new map < Id, String > ();
                if (accountsIds.size() > 0) {
                    List < Account > accountInfolist = eBc_UtilityController.getAccountsDetail(dml, accountsIds, ebcLogger);
                    for (Account account: accountInfolist) {
                        customerIdsMap.put(account.id, account.Name);
                    }
                }
                if (contactIds.size() > 0) {
                    List < Contact > contactDetailList = eBc_UtilityController.getContactsDetail(dml, contactIds, ebcLogger);
                    for (Contact contact: contactDetailList) {
                        customerIdsMap.put(contact.id, contact.Name);
                    }
                }
                for (recurringWrapper recurringWrapper: recurringList) {
                    if (customerIdsMap.containsKey(recurringWrapper.rrCustomerId)) {
                        recurringWrapper.rrCustomerName = customerIdsMap.get(recurringWrapper.rrCustomerId);
                        recurringWrapperRecords.add(recurringWrapper);
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return recurringList;
    }
    @auraEnabled
    public static string updScheduledRRStatusApxc(String recIntenalId, Integer ScheduleStatus) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = updScheduledRRStatusApxc(dml, recIntenalId, ScheduleStatus, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string updScheduledRRStatusApxc(DML dml, String recIntenalId, Integer ScheduleStatus, EBC_Logger ebcLogger) {
        ebcLogger.debug(ClassName, MethodName, 'FunctionCheck ');
        ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatusResponse response = new ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatusResponse();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        try {
            response = ebiz.ModifyScheduledRecurringPaymentStatus(eBc_UtilityController.getSecurityToken(dml, ebcLogger), recIntenalId, ScheduleStatus);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        if (response.Status == string.valueOf(Enums.RETURNMESSAGE.Success)) {
            return string.valueOf(Enums.RETURNMESSAGE.statusUpdated);
        } else {
            return response.Error;
        }
    }
    @AuraEnabled
    public static String markRRPaymentAsApplied(String PaymentInternalId, String AccountId, String RefNumber, Decimal Amount) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = markRRPaymentAsApplied(dml, PaymentInternalId, AccountId, RefNumber, Amount, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String markRRPaymentAsApplied(DML dml, String PaymentInternalId, String AccountId, String RefNumber, Decimal Amount, EBC_Logger ebcLogger) {
        ebizchargeServicemodelSoap.PaymentResponse response = null;
        try {
            if (!test.isRunningTest()) {
                response = eBc_UtilityController.MarkRecurringPaymentAsApplied(dml, PaymentInternalId, ebcLogger);
            }
            EBizCharge_Transaction__c transactionEntity = new EBizCharge_Transaction__c();
            id identifier = (id) AccountId;
            Schema.SObjectType sObjectType = identifier.getSObjectType();
            Schema.DescribeSObjectResult sObjectDescription = sObjectType.getDescribe();
            if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)) {
                transactionEntity.Account_Id__c = AccountId;
            }
            if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
                transactionEntity.Contact_Id__c = AccountId;
            }
            if (sObjectDescription.getName().contains(Configuration.CUSTOMOBJECTIDENTFIER)) {
                transactionEntity.Ebiz_C__EBizCharge_Fields_Id__c = AccountId;
            }
            transactionEntity.Auth_Amount__c = Amount;
            eBc_UtilityController.saveTransaction(dml, RefNumber, transactionEntity, ebcLogger);
            if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)) {
                eBc_UtilityController.markAccountPaid(dml, AccountId, RefNumber, Amount, ebcLogger);
            }
            if (sObjectDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
                eBc_UtilityController.markContactPaid(dml, AccountId, RefNumber, Amount, ebcLogger);
            }
            if (sObjectDescription.getName().contains(Configuration.CUSTOMOBJECTIDENTFIER)) {
                eBc_UtilityController.markCustomCustomerPaid(dml, AccountId, RefNumber, Amount, ebcLogger);
            }
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static Detail getDetailApxc(String recordId, String ObjectName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        Detail reciprocate = getDetailApxc(dml, recordId, ObjectName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static Detail getDetailApxc(DML dml, String recordId, String ObjectName, EBC_Logger ebcLogger) {
        Detail detail = new Detail();
        String querySelect = 'SELECT Id,CreatedDate,Name';
        String queryFrom = ' FROM ' + ObjectName;
        String queryWhere = ' WHERE Id = \'' + recordId + '\'';
        try {
            if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
                querySelect += ',AccountId';
            } else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
                querySelect += ',AccountId,Account.Name,OrderNumber,PoNumber,TotalAmount,EBizCharge_Order_Status__c,EBizCharge_Order_Balance__c,EBizCharge_Amount__c,EBizCharge_Internal_ID__c,EBizCharge_Reference_Number__c ';
            }
            sObject sObjectRecord = dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            String accountId = Configuration.EMPTYSTRING;
            String accountName = Configuration.EMPTYSTRING;
            map < String, String > updateAccountMap = new map < string, string > ();
            if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
                accountId = string.valueOf(sObjectRecord.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.AccountId)));
                detail.OppId = recordId;
                detail.OppName = string.valueOf(sObjectRecord.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Name)));
            } else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)) {
                accountId = string.valueOf(sObjectRecord.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Id)));
            } else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
                accountId = string.valueOf(sObjectRecord.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.AccountId)));
            }
            Account accountDetail = EBC_CompMethods.getAccountDetail(dml, accountId, ebcLogger);
            accountId = (string)accountDetail.get('QBD_Customer_ID__c');
            detail.AccountInfo = accountDetail;
            detail.AccountId = accountId;
            detail.AccountName = accountDetail.Name;
            String accountInternalId = accountDetail.EBizCharge_Internal_ID__c;
            if (test.isRunningTest()) {
                accountInternalId = null;
            }
            if (accountInternalId == null || accountInternalId == Configuration.EMPTYSTRING) {
                //search customer on Gateway 
                ebizchargeServicemodelSoap.Customer searchCustomerResponse = new ebizchargeServicemodelSoap.Customer();
                searchCustomerResponse = EBC_CompMethods.invoke_SearchCustomer(dml, accountId, ebcLogger);
                if (searchCustomerResponse.CustomerInternalId != null) {
                    accountInternalId = searchCustomerResponse.CustomerInternalId;
                    updateAccountMap.put(AccountId, searchCustomerResponse.CustomerInternalId);
                } else {
                    // add customer on Gateway
                    ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = EBC_CompMethods.invoke_addCustomer(dml, accountDetail, ebcLogger);
                    accountInternalId = addCustomerResponse.CustomerInternalId;
                    updateAccountMap.put(AccountId, addCustomerResponse.CustomerInternalId);
                }
            }
            detail.AccountInternalId = accountInternalId;
            //update Account
            if (updateAccountMap != null) {
                List < Account > accountsToUpdate = new List < Account > ();
                for (String key: updateAccountMap.keySet()) {
                    Account account = new Account();
                    account.Id = key;
                    account.EBizCharge_Internal_ID__c = updateAccountMap.get(key);
                    account.EBizCharge_Last_Sync_Date__c = system.now();
                    accountsToUpdate.add(account);
                }
                dml.updateRecord(accountsToUpdate);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            throw new AuraHandledException(Configuration.DEFAULTERRORMESSAGESTRING + e.getMessage());
        }
        return detail;
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
    @AuraEnabled
    public static String getRecurringSchedulePreview(String startDate, String endDate, String paymentFrequency) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = getRecurringSchedulePreview(dml, startDate, endDate, paymentFrequency, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String getRecurringSchedulePreview(DML dml, String startDate, String endDate, String paymentFrequency, EBC_Logger ebcLogger) {
        ebcLogger.debug(ClassName, MethodName, 'getRecurringSchedulePreview : ' + startDate + ' - ' + endDate + ' - ' + ' - ' + paymentFrequency);
        String responseToReturn = Configuration.EMPTYSTRING;
        try {
            ebizchargeServicemodelSoap.RecurringBilling recurringBilling = new ebizchargeServicemodelSoap.RecurringBilling();
            recurringBilling.Start = Date.valueOf(startDate);
            recurringBilling.Expire = Date.valueOf(endDate);
            recurringBilling.Schedule = paymentFrequency;
            recurringBilling.Amount = 50;
            recurringBilling.Tax = 1;
            recurringBilling.Enabled = true;
            recurringBilling.ScheduleName = '1';
            recurringBilling.Next = Date.valueOf(endDate);
            recurringBilling.RepeatCount = 1;
            recurringBilling.ReceiptNote = Configuration.RECEIPTNOTE;
            recurringBilling.SendCustomerReceipt = true;
            ebizchargeServicemodelSoap.GetScheduledDatesResponse response = new ebizchargeServicemodelSoap.GetScheduledDatesResponse();
            response = ebiz.GetRecurringSchedulePreview(eBc_UtilityController.getSecurityToken(dml, ebcLogger), recurringBilling);
            if (response != null) {
                responseToReturn = response.ScheduledDates;
                ebcLogger.debug(ClassName, MethodName, 'getRecurringSchedulePreview success' + responseToReturn);
            } else {
                responseToReturn = string.valueOf(Enums.RETURNMESSAGE.Error);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            responseToReturn = string.valueOf(Enums.RETURNMESSAGE.Error);
        }
        return responseToReturn;
    }
    public class recurringWrapper {
        @AuraEnabled public String rrCustomerId {
            get;
            set;
        }
        @AuraEnabled public String rrCustomerName {
            get;
            set;
        }
        @AuraEnabled public String rrInvoiceNumber {
            get;
            set;
        }
        @AuraEnabled public String rrAmountDue {
            get;
            set;
        }
        @AuraEnabled public String rrAuthCode {
            get;
            set;
        }
        @AuraEnabled public String rrRefNum {
            get;
            set;
        }
        @AuraEnabled public String rrLast4 {
            get;
            set;
        }
        @AuraEnabled public String rrPaymentMethod {
            get;
            set;
        }
        @AuraEnabled public Date rrDatePaid {
            get;
            set;
        }
        @AuraEnabled public String rrTimePaid {
            get;
            set;
        }
        @AuraEnabled public String rrPaidAmount {
            get;
            set;
        }
        @AuraEnabled public String rrCustNum {
            get;
            set;
        }
        @AuraEnabled public String rrPaymentMethodId {
            get;
            set;
        }
        @AuraEnabled public String rrPaymentInternalId {
            get;
            set;
        }
        @AuraEnabled public String rrSchedPayInternalId {
            get;
            set;
        }
        @AuraEnabled public String rrScheduledName {
            get;
            set;
        }
        @AuraEnabled public String rrFrequency {
            get;
            set;
        }
        @AuraEnabled public String RecurringHyperUrl {
            get;
            set;
        }
    }
    public class Recurring {
        @AuraEnabled public String accId {
            get;
            set;
        }
        @AuraEnabled public String accName {
            get;
            set;
        }
        @AuraEnabled public String accExtId {
            get;
            set;
        }
        @AuraEnabled public String rrPaymentIntId {
            get;
            set;
        }
        @AuraEnabled public String rrScheduleName {
            get;
            set;
        }
        @AuraEnabled public Datetime rrScheduleStart {
            get;
            set;
        }
        @AuraEnabled public Datetime rrScheduleEnd {
            get;
            set;
        }
        @AuraEnabled public Datetime rrDateTimeCreated {
            get;
            set;
        }
        @AuraEnabled public String rrSchedule {
            get;
            set;
        }
        @AuraEnabled public Decimal rrAmount {
            get;
            set;
        }
        @AuraEnabled public Decimal rrTax {
            get;
            set;
        }
        @AuraEnabled public String rrNote {
            get;
            set;
        }
        @AuraEnabled public String rrObj {
            get;
            set;
        }
        @AuraEnabled public String rrMaskedPM {
            get;
            set;
        }
        @AuraEnabled public String rrPMType {
            get;
            set;
        }
        @AuraEnabled public String rrScheduleStatus {
            get;
            set;
        }
        @AuraEnabled public String rrPaymentMethodId {
            get;
            set;
        }
        @AuraEnabled public String RecurringHyperUrl {
            get;
            set;
        }
        @AuraEnabled public boolean isSelected {
            get;
            set;
        }
        @AuraEnabled public String emails {
            get;
            set;
        }
        @AuraEnabled public Boolean sendReceipt {
            get;
            set;
        }
    }
    public class Detail {
        @AuraEnabled public EBizCharge_Transaction__c TransInfo {
            get;
            set;
        }
        @AuraEnabled public EBizcharge_Setting__c Settings {
            get;
            set;
        }
        @AuraEnabled public String OppId {
            get;
            set;
        }
        @AuraEnabled public String OppName {
            get;
            set;
        }
        @AuraEnabled public Account AccountInfo {
            get;
            set;
        }
        @AuraEnabled public String AccountId {
            get;
            set;
        }
        @AuraEnabled public String AccountName {
            get;
            set;
        }
        @AuraEnabled public String AccountInternalId {
            get;
            set;
        }
    }
    public class AccountWrapper {
        @AuraEnabled public String Object_Name {
            get;
            set;
        }
        @AuraEnabled public map < string, string > savedPaymentMethods {
            get;
            set;
        }
        @AuraEnabled public Account accountDetail {
            get;
            set;
        }
        @AuraEnabled public Contact contactDetail {
            get;
            set;
        }
        @AuraEnabled public Ebiz_C__EBizCharge_Fields_Config__c custDetail {
            get;
            set;
        }
        @AuraEnabled public String Address {
            get;
            set;
        }
        @AuraEnabled public String ZipCode {
            get;
            set;
        }
    }
}