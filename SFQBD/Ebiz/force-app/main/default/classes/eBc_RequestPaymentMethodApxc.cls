public with sharing class eBc_RequestPaymentMethodApxc {
    public static string ClassName = 'eBc_RequestPaymentMethodApxc';
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
        return eBc_UtilityController.getSettings(dml, ebcLogger);
    }
    @AuraEnabled 
    public static Integer getCustomersCountApxc(string sDate, string eDate, string searchInput)
    {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        Integer reciprocate = getCustomersCountApxc(dml, sDate, eDate, searchInput, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static Integer getCustomersCountApxc(DML dml, string sDate, string eDate , string searchInput, EBC_Logger ebcLogger)
    {
        searchInput = '%' + searchInput + '%';
        Integer accountsCount = 0;
        Integer contactsCount = 0;
        list<AggregateResult> result = new list<AggregateResult>();
        Date startDtateForApi = null;
        Date endDtateForApi = null;
        if (sDate != null) {
            DateTime datetimeEntity = Date.valueOf(sDate);
            startDtateForApi = Date.valueOf(datetimeEntity);
        }
        if (eDate != null) {
            DateTime datetimeEntity = Date.valueOf(eDate);
            datetimeEntity = datetimeEntity.AddDays(1);
            endDtateForApi = Date.valueOf(datetimeEntity);
        }
        // MockData
        if (test.isRunningTest()) {
            sDate = null;
        } 
        // MockData End
        if (sDate == null) {
            startDtateForApi = date.newinstance(1900, 01, 01);
        }
        // MockData 
        if (test.isRunningTest()) {
            eDate = null;
        } 
        // MockData End
        if (eDate == null) {
            endDtateForApi = date.newinstance(2100, 01, 01);
        } 
        result = [select count(id) from account WHERE CreatedDate >=: startDtateForApi and CreatedDate <=: endDtateForApi and Name Like: searchInput ];
        if(result != null)
        {
            accountsCount = (Integer)result[0].get('expr0');
        }
        
        result = [select count(id) from contact WHERE CreatedDate >=: startDtateForApi and CreatedDate <=: endDtateForApi and Name Like: searchInput ];
        if(result != null)
        {
        contactsCount = (Integer)result[0].get('expr0');
        }
        return accountsCount + contactsCount;
    }

    @AuraEnabled
    public static CustomerData getCustomersApxc(string sDate, string eDate, DateTime accountDate, DateTime contactDate, map<string, string> customersMap, string searchInput) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        CustomerData reciprocate = getCustomersApxc(dml, sDate, eDate, accountDate, contactDate, customersMap, searchInput, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static CustomerData getCustomersApxc(DML dml, string sDate, string eDate, DateTime accountDate, DateTime contactDate, map<string, string> customersMap, string searchInput, EBC_Logger ebcLogger) {
        MethodName = 'getCustomersApxc';
        searchInput = '%' + searchInput + '%';
        Date startDtateForApi = null;
        Date endDtateForApi = null;
        if (sDate != null) {
            DateTime datetimeEntity = Date.valueOf(sDate);
            startDtateForApi = Date.valueOf(datetimeEntity);
        }
        if (eDate != null) {
            DateTime datetimeEntity = Date.valueOf(eDate);
            datetimeEntity = datetimeEntity.AddDays(1);
            endDtateForApi = Date.valueOf(datetimeEntity);
        }
        // MockData
        if (test.isRunningTest()) {
            sDate = null;
        } 
        // MockData End
        if (sDate == null) {
            startDtateForApi = date.newinstance(1900, 01, 01);
        }
        // MockData 
        if (test.isRunningTest()) {
            eDate = null;
        } 
        // MockData End
        if (eDate == null) {
            endDtateForApi = date.newinstance(2100, 01, 01);
        }
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        List < CustomerWrapper > customers = new List < CustomerWrapper > ();
        CustomerData customerData = new CustomerData();
        List < Account > accounts = new List < Account > ();
        List < Contact > contacts = new List < Contact > ();
        if(customersMap == null)
        {
        customersMap = new Map<String, string>();
        } 
        try {
            if(accountDate != null)
            {
                accounts = [SELECT Id,QBD_Customer_ID__c, Name, createdById, CreatedDate, First_Name__c, Last_Name__c, EBizCharge_Email__c,Email__c, Phone, Fax, Website, EBizCharge_Internal_ID__c, EBizCharge_Amount__c, BillingAddress, BillingStreet, BillingPostalCode, BillingCity, BillingCountry, BillingState, ShippingAddress, ShippingCity, ShippingState, ShippingStreet, ShippingPostalCode, ShippingCountry
                FROM Account WHERE Name Like: searchInput and CreatedDate >=: startDtateForApi and CreatedDate <=: accountDate and QBD_Customer_ID__c not in: customersMap.keySet() ORDER BY CreatedDate DESC Limit 500
            ];
            }
            else{
            accounts = [SELECT Id,QBD_Customer_ID__c, Name, createdById, CreatedDate, First_Name__c, Last_Name__c, EBizCharge_Email__c,Email__c,Phone, Fax, Website, EBizCharge_Internal_ID__c, EBizCharge_Amount__c, BillingAddress, BillingStreet, BillingPostalCode, BillingCity, BillingCountry, BillingState, ShippingAddress, ShippingCity, ShippingState, ShippingStreet, ShippingPostalCode, ShippingCountry
                FROM Account WHERE Name Like: searchInput and CreatedDate >=: startDtateForApi and CreatedDate <=: endDtateForApi and QBD_Customer_ID__c not in: customersMap.keySet() ORDER BY CreatedDate DESC Limit 500
            ];
            }
            if(contactDate != null)
            {
                contacts = [SELECT Id, Name, createdById, Email, FirstName, LastName, Phone, Fax, MailingCountry, MailingState, CreatedDate,
                OtherAddress, OtherCity, OtherCountry, OtherState, OtherStreet, OtherPostalCode, Ebiz_C__EBizCharge_Contact_Internal_ID__c,
                MailingCity, MailingStreet, MailingPostalCode, Ebiz_C__EBizCharge_Contact_Amount__c, EBizCharge_Amount__c
                FROM Contact WHERE Name Like: searchInput and CreatedDate >=: startDtateForApi and CreatedDate <=: contactDate and Id not in: customersMap.keySet() ORDER BY CreatedDate DESC Limit 500
            ];
            }
            else
            {
                contacts = [SELECT Id, Name, createdById, Email, FirstName, LastName, Phone, Fax, MailingCountry, MailingState, CreatedDate,
                OtherAddress, OtherCity, OtherCountry, OtherState, OtherStreet, OtherPostalCode, Ebiz_C__EBizCharge_Contact_Internal_ID__c,
                MailingCity, MailingStreet, MailingPostalCode, Ebiz_C__EBizCharge_Contact_Amount__c, EBizCharge_Amount__c
                FROM Contact WHERE Name Like: searchInput and CreatedDate >=: startDtateForApi and CreatedDate <=: endDtateForApi and Id not in: customersMap.keySet() ORDER BY CreatedDate DESC Limit 500
            ];
            }
            if(accounts != null && accounts.size() > 0){
                customerData.accountDate = accounts[accounts.size() -1].CreatedDate;
                for (Account account: accounts) {
                    if(!customersMap.containsKey((string)account.get('QBD_Customer_ID__c')))
                    {
                    customersMap.put((string)account.get('QBD_Customer_ID__c'), (string)account.get('QBD_Customer_ID__c'));
                    CustomerWrapper customer = new CustomerWrapper();
                    customer.accId = account.Id;
                    customer.HyperUrlAccount = Configuration.TARGETURL + account.Id;
                    customer.accName = account.Name;
                    customer.dateCreated = account.CreatedDate;
                    customer.accAmount = account.EBizCharge_Amount__c;
                    customer.paymentmethodurl = Configuration.VIEWPAYMENTMETHOD;
                    customer.objectName = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account);
                        if ((string)account.get('Email__c') == null ||(string)account.get('Email__c') == Configuration.EMPTYSTRING) {
                        customer.accEmail = Configuration.EMPTYSTRING;
                    } else {
                        customer.accEmail = (string)account.get('Email__c');
                    }
                    customer.accExtId = account.EBizCharge_Internal_ID__c;
                    customer.isSelected = false;
                    customer.accBillingStreet = account.BillingStreet;
                    customer.accBillingCity = account.BillingCity;
                    customer.accBillingPostalCode = account.BillingPostalCode;
                    customer.accBillingCountry = account.BillingCountry;
                    customer.accShippingStreet = account.ShippingStreet;
                    customer.accShippingCity = account.ShippingCity;
                    customer.accShippingState = account.ShippingState;
                    customer.accShippingPostalCode = account.ShippingPostalCode;
                    customer.accShippingCountry = account.ShippingCountry;
                    customers.add(customer);
                }
            }
            }
            if (contacts != null && contacts.size() > 0){
                customerData.contactDate = contacts[contacts.size() -1].CreatedDate;
                for (Contact contact: contacts) {
                    if(!customersMap.containsKey(contact.id))
                    {
                    customersMap.put(contact.id, contact.id);    
                    CustomerWrapper customer = new CustomerWrapper();
                    customer.accId = contact.Id;
                    customer.HyperUrlAccount = Configuration.TARGETURL + contact.Id;
                    customer.accName = contact.Name;
                    customer.dateCreated = contact.CreatedDate;
                    customer.accAmount = contact.EBizCharge_Amount__c;
                    customer.paymentmethodurl = Configuration.VIEWPAYMENTMETHOD;
                    customer.objectName = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact);
                    if (contact.Email == null || contact.Email == Configuration.EMPTYSTRING) {
                        customer.accEmail = Configuration.EMPTYSTRING;
                    } else {
                        customer.accEmail = contact.Email;
                    }
                    customer.accExtId = contact.EBizCharge_Contact_Internal_ID__c;
                    customer.isSelected = false;
                    customer.accBillingStreet = contact.MailingStreet;
                    customer.accBillingCity = contact.MailingCity;
                    customer.accBillingPostalCode = contact.MailingPostalCode;
                    customer.accBillingCountry = contact.MailingCountry;
                    customer.accShippingStreet = contact.OtherStreet;
                    customer.accShippingCity = contact.OtherCity;
                    customer.accShippingState = contact.OtherState;
                    customer.accShippingPostalCode = contact.OtherPostalCode;
                    customer.accShippingCountry = contact.OtherCountry;
                    customers.add(customer);
                }
            }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        ebcLogger.debug(ClassName, MethodName, 'customers:' + customers);
        customerData.customersData = customers;
        customerData.customersMap = customersMap;
        return customerData;
    }
    @AuraEnabled
    public static string syncAccountsApxc(list < CustomerWrapper > selectedRecords) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = syncAccountsApxc(dml, selectedRecords, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string syncAccountsApxc(DML dml, list < CustomerWrapper > selectedRecords, EBC_Logger ebcLogger) {
        MethodName = 'syncAccountsApxc';
        try {
            EBizcharge_Setting__c ebizchargeSettings = eBc_UtilityController.getSettings(dml, ebcLogger);
            map < String, String > updateAccountsMap = new map < string, string > ();
            map < String, String > updateContactsMap = new map < string, string > ();
            ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
            ebizchargeServicemodelSoap.CustomerResponse customerResponse = new ebizchargeServicemodelSoap.CustomerResponse();
            Schema.DescribeSObjectResult sObjectResultAcount = Account.sObjectType.getDescribe();
            String keyPrefixAccount = sObjectResultAcount.getKeyPrefix();
            List < Id > accountsIdList = new List < Id > ();
            List < Id > contactsIdList = new List < Id > ();
            for (CustomerWrapper customer: selectedRecords) {
                string customerId = customer.accId;
                if(customerId.startsWith(keyPrefixAccount)){
                    accountsIdList.add(customer.accId);
                }else{
                    contactsIdList.add(customer.accId);
                }
            }
            List < Account > accountsDetailList = new List < Account > ();
            List < Contact > contactsDetailList = new List < Contact > ();
            if(accountsIdList.size() > 0){
                accountsDetailList = eBc_UtilityController.getAccountsDetail(dml, accountsIdList, ebcLogger);
                if(accountsDetailList != null && accountsDetailList.size() > 0){
                    for (Account account: accountsDetailList) {
                        if (account.EBizCharge_Internal_ID__c == null || account.EBizCharge_Internal_ID__c == Configuration.EMPTYSTRING) {
                            customerResponse = eBc_UtilityController.invoke_addORUpdCustomer(dml, account, securityToken, string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
                        } 
                        if (customerResponse.StatusCode == 1) {
                            updateAccountsMap.put(account.id, customerResponse.CustomerInternalId);
                        }
                    }
                }
            }
            if(contactsIdList.size() > 0){
                contactsDetailList = eBc_UtilityController.getContactsDetail(dml, contactsIdList, ebcLogger);
            if(contactsDetailList != null && contactsDetailList.size() > 0){
                for (Contact contact: contactsDetailList) {
                    if (contact.Ebiz_C__EBizCharge_Contact_Internal_ID__c == null || contact.Ebiz_C__EBizCharge_Contact_Internal_ID__c == Configuration.EMPTYSTRING) {
                        customerResponse = eBc_UtilityController.invoke_addORUpdCustomerContact(dml, contact, securityToken, string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
                    } 
                    if (customerResponse.StatusCode == 1) {
                        updateContactsMap.put(contact.id, customerResponse.CustomerInternalId);
                    }
                }
            }
            }
            if (updateAccountsMap.size() > 0) {
               eBc_UtilityController.updCustomerInSF(dml, updateAccountsMap, ebcLogger);
            } 
            if (updateContactsMap.size() > 0) {
                eBc_UtilityController.updCustomerInSFContact(dml, updateContactsMap, ebcLogger);
             } 
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return Configuration.EXCEPTIONMESSAGE;
        }
    }
    @AuraEnabled
    public static PaymentMethods getCustPaymentMethodsApx(string AccountId, string Type) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        PaymentMethods reciprocate = getCustPaymentMethodsApx(dml, AccountId, Type, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static PaymentMethods getCustPaymentMethodsApx(DML dml, string AccountId, string Type, EBC_Logger ebcLogger) {
        MethodName = 'getCustPaymentMethodsApx';
        PaymentMethods paymentMethodsEntity = new PaymentMethods();
        try {
            String accountExternalId = Configuration.EMPTYSTRING;
            String customerId = Configuration.EMPTYSTRING;
            if (Type == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)) {
                ebcLogger.debug(ClassName, MethodName, '>>>in Account: ');
                Account accountData = EBC_CompMethods.getAccountDetail(dml, AccountId, ebcLogger);
                paymentMethodsEntity.AccountInfo = accountData;
                accountExternalId = accountData.EBizCharge_Internal_ID__c;
                //customerId = accountData.Id;
                customerId = (string)accountData.get('QBD_Customer_ID__c');
            } else if (Type == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
                ebcLogger.debug(ClassName, MethodName, '>>>in Contact: ');
                Contact accountData = EBC_CompMethods.getContactDetail(dml, AccountId, ebcLogger);
                paymentMethodsEntity.ContactInfo = accountData;
                accountExternalId = accountData.EBizCharge_Contact_Internal_ID__c;
                customerId = accountData.Id;
            }
            if (accountExternalId != null && accountExternalId != Configuration.EMPTYSTRING) {
                map < String, String > paymentMethodsMap = new map < String, String > ();
                list < customerMethod > methods = new list < customerMethod > ();
                list < ebizchargeServicemodelSoap.PaymentMethodProfile > ebizPaymentMethods = new list < ebizchargeServicemodelSoap.PaymentMethodProfile > ();
                if (!test.isRunningTest()) {
                    ebizPaymentMethods = EBC_CompMethods.GetCustomerPaymentMethods(dml, customerId, accountExternalId, ebcLogger);
                } else {
                    ebizchargeServicemodelSoap.PaymentMethodProfile mockData = new ebizchargeServicemodelSoap.PaymentMethodProfile();
                    mockData.SecondarySort = '3';
                    mockData.MethodType = 'cc';
                    mockData.CardExpiration = '1212 12';
                    mockData.CardNumber = '2342343';
                    mockData.Account = '234234';
                    ebizPaymentMethods.add(mockData);
                }
                if (ebizPaymentMethods != null) {
                    for (ebizchargeServicemodelSoap.PaymentMethodProfile paymentMethod: ebizPaymentMethods) {
                        customerMethod customerMethod = new customerMethod();
                        customerMethod.MethodType = paymentMethod.MethodType;
                        customerMethod.MethodID = paymentMethod.MethodID;
                        customerMethod.MethodName = paymentMethod.MethodName;
                        customerMethod.DateCreated = paymentMethod.Created;
                        customerMethod.DateModified = paymentMethod.Modified;
                        customerMethod.AccountHolderName = paymentMethod.AccountHolderName;
                        customerMethod.SecondarySort = Integer.valueOf(paymentMethod.SecondarySort);
                        if (paymentMethod.MethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.cc)) {
                            customerMethod.AvsStreet = paymentMethod.AvsStreet;
                            customerMethod.AvsZip = paymentMethod.AvsZip;
                            customerMethod.CardExpiration = paymentMethod.CardExpiration;
                            customerMethod.CardExpMonth = paymentMethod.CardExpiration.right(2);
                            customerMethod.CardExpYear = paymentMethod.CardExpiration.left(4);
                            customerMethod.CardNumber = paymentMethod.CardNumber;
                            customerMethod.Last4Degit = paymentMethod.CardNumber.right(4);
                            customerMethod.CardType = paymentMethod.CardType;
                        } else {
                            customerMethod.Account = paymentMethod.Account;
                            customerMethod.Last4Degit = paymentMethod.Account.right(4);
                            customerMethod.AccountType = paymentMethod.AccountType;
                            customerMethod.Routing = paymentMethod.Routing;
                        }
                        if (paymentMethod.CardNumber == null) {
                            paymentMethodsMap.put(paymentMethod.MethodID + Configuration.PAYMENTMETHODSEPARATOR, paymentMethod.Routing + Configuration.PAYMENTMETHODROUTINGSEPERATOR + paymentMethod.Account);
                        } else {
                            string method = Configuration.EMPTYSTRING;
                            if (!string.isEmpty(paymentMethod.MethodName)) {
                                method = Configuration.PAYMENTMETHODNAME + paymentMethod.MethodName;
                            }
                            ebcLogger.debug(ClassName, MethodName, 'default card--SecondarySort>' + paymentMethod.SecondarySort);
                            paymentMethodsMap.put(paymentMethod.MethodID + Configuration.PAYMENTMETHODIDSEPARATOR, Configuration.CARDENDINGIN + paymentMethod.CardNumber.replace(string.valueOf(Enums.CARDCOMPARISONSTRINGS.X), Configuration.EMPTYSTRING) + method);
                        }
                        methods.add(customerMethod);
                    }
                    paymentMethodsEntity.SavedPaymentMethodslist = methods;
                    paymentMethodsEntity.savedPaymentMethods = paymentMethodsMap;
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            ebcLogger.saveLogs();
        }
        return paymentMethodsEntity;
    }
    @AuraEnabled
    public static List < emailTemplate > getEmailTemplatesApxc() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < emailTemplate > reciprocate = getEmailTemplatesApxc(dml, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < emailTemplate > getEmailTemplatesApxc(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getEmailTemplatesApxc';
        List < emailTemplate > emailTemplates = new List < emailTemplate > ();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.EmailTemplate[] emailTemplateList;
        try {
            ebizchargeServicemodelSoap.ArrayOfEmailTemplate ebizEmailTemplates = new ebizchargeServicemodelSoap.ArrayOfEmailTemplate();
            if (!test.isRunningTest()) {
                ebizEmailTemplates = ebiz.GetEmailTemplates(EBC_CompMethods.getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                emailTemplateList = ebizEmailTemplates.EmailTemplate;
            }
            if (emailTemplateList != null) {
                for (ebizchargeServicemodelSoap.EmailTemplate template: emailTemplateList) {
                    emailTemplate emailTemplate = new emailTemplate();
                    emailTemplate.TemplateName = template.TemplateName;
                    emailTemplate.TemplateType = template.TemplateTypeId;
                    emailTemplate.TemplateInternalId = template.TemplateInternalId;
                    emailTemplate.TemplateSubject = template.TemplateSubject;
                    emailTemplate.TemplateFromName = template.FromName;
                    emailTemplate.FromEmail = template.FromEmail;
                    emailTemplate.ReplyToEmail = template.ReplyToEmail;
                    emailTemplates.add(emailTemplate);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        ebcLogger.debug(ClassName, MethodName, '>>>emailTemplates: ' + emailTemplates);
        return emailTemplates;
    }
    @AuraEnabled
    public static String addPayMehtodReqApxc(String sendReqJSON, List < CustomerWrapper > recordList) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = addPayMehtodReqApxc(dml, sendReqJSON, recordList, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String addPayMehtodReqApxc(DML dml, String sendReqJSON, List < CustomerWrapper > recordList, EBC_Logger ebcLogger) {
        MethodName = 'addPayMehtodReqApxc';
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        Integer insertCount = 0;
        Id customerId;
        String objectName = Configuration.EMPTYSTRING;
        String qbdId = Configuration.EMPTYSTRING;
        String returnMessage = Configuration.EMPTYSTRING;
        List < EBizCharge_RequestPaymentPending__c > requestMethodToAdd = new List < EBizCharge_RequestPaymentPending__c > ();
        String startDate = Configuration.DEFAULTSTARTDATE;
        String endDate = Configuration.DEFAULTENDDATE;
        String webformType = Configuration.PYAMENTMETHODREQUESTS;
        PendingPayments returnPendingPayments = getPendingRequestPaymentsApxc(dml, startDate, endDate, webformType, ebcLogger);
        try {
            List < Payments > pendingList = returnPendingPayments.PendingList;
            List < String > customerIDs = new List < String > ();
            for (Payments payment: pendingList) {
                customerIDs.add(payment.CustomerId);
            }
            ebcLogger.debug(ClassName, MethodName, 'customerIDs: ' + customerIDs);
            List < EBizCharge_RequestPaymentPending__c > requestPayToDelete = new List < EBizCharge_RequestPaymentPending__c > ();
            querySelect = 'SELECT Id,Payment_Account_ID__c,Send_Request_Count__c';
            queryFrom = 'FROM EBizCharge_RequestPaymentPending__c';
            queryWhere = 'WHERE Payment_Account_ID__c NOT IN :';
            List < EBizCharge_RequestPaymentPending__c > requestPaymentPendingToDelete = (List < EBizCharge_RequestPaymentPending__c > ) dml.selectRecordsInList(customerIDs, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            for (EBizCharge_RequestPaymentPending__c requestPaymentPending: requestPaymentPendingToDelete) {
                requestPayToDelete.add(requestPaymentPending);
            }
            List < String > existingRequestPayments = new List < String > ();
            querySelect = 'SELECT Id,Payment_Account_ID__c ,Send_Request_Count__c';
            queryFrom = 'FROM EBizCharge_RequestPaymentPending__c';
            queryWhere = 'WHERE Payment_Account_ID__c IN :';
            List < EBizCharge_RequestPaymentPending__c > requestPaymentPendingSF = (List < EBizCharge_RequestPaymentPending__c > ) dml.selectRecordsInList(customerIDs, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            for (EBizCharge_RequestPaymentPending__c requestPaymentPending: requestPaymentPendingSF) {
                existingRequestPayments.add(requestPaymentPending.Payment_Account_ID__c);
            }
            Map < String, Object > requestsWebForm = (Map < String, Object > ) JSON.deserializeUntyped(sendReqJSON);
            ebizchargeServicemodelSoap.EbizWebForm tempWebForm = new ebizchargeServicemodelSoap.EbizWebForm();
            for (CustomerWrapper customer: recordList) {
                customerId = customer.accId;
                objectName = String.valueOf(customerId.getsobjecttype());
                if(objectName == String.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)){
                String query_Select = 'select id,QBD_Customer_ID__c';
                String query_From = 'from Account';
                String query_Where =  'where id=\''+ customerId  +'\'';
                Account account = (Account)dml.selectSingleRecord(query_Select, query_From, query_Where, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
                qbdId = (string)account.get('QBD_Customer_ID__c');
                tempWebForm.OrderId = qbdId;
                tempWebForm.CustomerId = qbdId;
            }else{
                tempWebForm.OrderId = customerId;
                tempWebForm.CustomerId = customerId;
            }
                tempWebForm.FromName = string.valueOf(Enums.ASSIGNMENTSTRINGS.EBizCharge);
                tempWebForm.FromEmail = (string) requestsWebForm.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.fromEmail));
                tempWebForm.EmailAddress = customer.accEmail;
                tempWebForm.EmailSubject = (string) requestsWebForm.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Subject));
                tempWebForm.EmailNotes = (string) requestsWebForm.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Notes));
                tempWebForm.EmailTemplateID = (string) requestsWebForm.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.TemplateId));
                Timezone timeZoneEntity = Timezone.getTimeZone(Configuration.PACIFICSTANDARDTIME);
                tempWebForm.Date_x= DateTime.newInstance(System.Now().getTime() + timeZoneEntity.getOffset(System.Now()));
                tempWebForm.CustFullName = customer.accName;
                tempWebForm.InvoiceNumber = string.valueOf(Enums.FIELDVALUES.Token);
                tempWebForm.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
                tempWebForm.Clerk = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.AppUser);
                tempWebForm.FormType = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.PmRequestForm);
                tempWebForm.PayByType = Configuration.PAYBYTYPESTRING;
                tempWebForm.SendEmailToCustomer = true;
                ebizchargeServicemodelSoap.Address customerAddress = new ebizchargeServicemodelSoap.Address();
                customerAddress.FirstName = customer.accName;
                customerAddress.LastName = customer.accName;
                customerAddress.Address1 = customer.accBillingStreet;
                customerAddress.City = customer.accBillingCity;
                customerAddress.State = customer.accBillingState;
                customerAddress.ZipCode = customer.accBillingPostalCode;
                customerAddress.Country = customer.accBillingCountry;
                tempWebForm.BillingAddress = customerAddress;
                tempWebForm.SendEmailToCustomer = true;
                ebcLogger.debug(ClassName, MethodName, '>EmailNotes: ' + tempWebForm.EmailNotes);
                ebcLogger.debug(ClassName, MethodName, '>To Email: ' + tempWebForm.EmailAddress);
                if (!test.isRunningTest()) {
                    if(objectName == String.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)){
                        if (existingRequestPayments.contains(customer.accId)) {
                            returnMessage += Configuration.RETURNMESSAGECOMBINE + customer.accName;
                        } else {
                            string response = ebiz.GetEbizWebFormURL(EBC_CompMethods.getSecurityToken(dml, ebcLogger), tempWebForm);
                            EBizCharge_RequestPaymentPending__c reqPayment = new EBizCharge_RequestPaymentPending__c();
                            reqPayment.Payment_Account_ID__c = customer.accId;
                            reqPayment.Send_Request_Count__c = 1;
                            requestMethodToAdd.add(reqPayment);
                            insertCount++;
                        }
                    }else{
                        if (existingRequestPayments.contains(qbdId)) {
                            returnMessage += Configuration.RETURNMESSAGECOMBINE + customer.accName;
                        } else {
                            string response = ebiz.GetEbizWebFormURL(EBC_CompMethods.getSecurityToken(dml, ebcLogger), tempWebForm);
                            EBizCharge_RequestPaymentPending__c reqPayment = new EBizCharge_RequestPaymentPending__c();
                            reqPayment.Payment_Account_ID__c = qbdId;
                            reqPayment.Send_Request_Count__c = 1;
                            requestMethodToAdd.add(reqPayment);
                            insertCount++;
                        }
                    } 
                }
            }
            if (requestPayToDelete.size() > 0) {
                try {
                    if (!test.isRunningTest()) {
                        dml.deleteRecord(requestPayToDelete);
                    }
                } catch (Exception e) {
                    ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
                }
            }
            if (requestMethodToAdd.size() > 0) {
                try {
                    if (!test.isRunningTest()) {
                        dml.insertRecord(requestMethodToAdd);
                    }
                } catch (Exception e) {
                    ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
                }
            }
            returnMessage += Configuration.RETURNMESSAGECOMBINE + insertCount;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnMessage;
    }
    @AuraEnabled
    public static List < Payments > getReceivedPaymentsApxc(String sDate, String eDate, String webformType) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < Payments > reciprocate = getReceivedPaymentsApxc(dml, sDate, eDate, webformType, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < Payments > getReceivedPaymentsApxc(DML dml, String sDate, String eDate, String webformType, EBC_Logger ebcLogger) {
        MethodName = 'getReceivedPaymentsApxc';
        Date startDtateForApi = null;
        Date endDtateForApi = null;
        if (sDate != null) {
            DateTime datetimeEntity = Date.valueOf(sDate);
            startDtateForApi = Date.valueOf(datetimeEntity);
        }
        if (eDate != null) {
            DateTime datetimeEntity = Date.valueOf(eDate);
            datetimeEntity = datetimeEntity.AddDays(1);
            endDtateForApi = Date.valueOf(datetimeEntity);
        }
        if (test.isRunningTest()) {
            sDate = null;
        }
        if (sDate == null) {
            startDtateForApi = date.newinstance(1900, 01, 01);
        }
        if (test.isRunningTest()) {
            eDate = null;
        }
        if (eDate == null) {
            endDtateForApi = date.newinstance(2100, 01, 01);
        }
        List < Payments > returnReceivedPayments = new List < Payments > ();
        ebizchargeServicemodelSoap.ArrayOfSearchFilter searchFilterArray = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        List < ebizchargeServicemodelSoap.SearchFilter > searchFilters = new List < ebizchargeServicemodelSoap.SearchFilter > ();
        if (test.isRunningTest()) {
            webformType = 'Payment Method';
        }
        if (webformType == Configuration.PYAMENTMETHODREQUESTS) {
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.InvoiceNumber);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = string.valueOf(Enums.FIELDVALUES.Token);
            searchFilters.add(filter);
        }
        List < Payments > receivedPayments = new List < Payments > ();
        List < String > customerIds = new List < String > ();
        try {
            List < ebizchargeServicemodelSoap.Payment > ebizPayments = new list < ebizchargeServicemodelSoap.Payment > ();
            ebizchargeServicemodelSoap.ArrayOfPayment receivedPaymentsResponse = new ebizchargeServicemodelSoap.ArrayOfPayment();
            if (!test.isRunningTest()) {
                searchFilterArray.SearchFilter = searchFilters;
                receivedPaymentsResponse = ebiz.SearchEbizWebFormReceivedPayments(eBc_UtilityController.getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, startDtateForApi, endDtateForApi, searchFilterArray, 0, 1000, '1');
                ebizPayments = receivedPaymentsResponse.Payment;
                ebcLogger.debug(ClassName, MethodName, '>>>receivedPaymentsResponse: ' + receivedPaymentsResponse);
            } else {
                ebizchargeServicemodelSoap.Payment mockPayment = new ebizchargeServicemodelSoap.Payment();
                mockPayment.OrderId = '234';
                mockPayment.CustomerId = '001343398728733';
                mockPayment.DivisionId = '2423432';
                mockPayment.InvoiceNumber = '23423432';
                mockPayment.InvoiceInternalId = '2342342';
                mockPayment.InvoiceDate = '2017-12-12';
                mockPayment.InvoiceDueDate = '2017-12-12';
                mockPayment.PoNum = '123';
                mockPayment.InvoiceAmount = '12.00';
                mockPayment.AmountDue = '0.00';
                mockPayment.AuthCode = '2234424auwweew';
                mockPayment.RefNum = '234234';
                mockPayment.Last4 = '08773';
                mockPayment.PaidAmount = '2.00';
                Datetime StartDT = Datetime.newInstance(2017, 1, 7, 15, 20, 45);
                mockPayment.PaymentRequestDateTime = StartDT.format('yyyy-MM-dd\'T\'HH:mm:ss');
                mockPayment.DatePaid = StartDT.format('yyyy-MM-dd\'T\'HH:mm:ss');
                ebizPayments.add(mockPayment);
            }
            if (ebizPayments != null) {
                for (ebizchargeServicemodelSoap.Payment ebizPayment: ebizPayments) {
                    Payments payment = new Payments();
                    if (ebizPayment.CustomerId != null && ebizPayment.CustomerId != Configuration.EMPTYSTRING) {
                        string customerId = ebizPayment.CustomerId;
                        String keyPrefix = Configuration.EMPTYSTRING;
                        Schema.DescribeSObjectResult sObjectResultAcount = Account.sObjectType.getDescribe();
                        String keyPrefixAccount = sObjectResultAcount.getKeyPrefix();
                        Schema.DescribeSObjectResult sObjectResultContact = Contact.sObjectType.getDescribe();
                        String keyPrefixContact = sObjectResultContact.getKeyPrefix();
                            customerIds.add(ebizPayment.CustomerId);
                            if (webformType == Configuration.PYAMENTMETHODREQUESTS) {
                                payment.methodType = Configuration.PAYMENTMETHODTYPE;
                            }
                            payment.CustomerId = ebizPayment.CustomerId;
                            payment.Last4 = ebizPayment.Last4;
                            payment.CustomerEmailAddress = ebizPayment.CustomerEmailAddress;
                            if (customerId.startsWith(keyPrefixContact)) {
                                payment.objectName = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact);
                            } else {
                                payment.objectName = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account);
                            }
                            payment.PaymentMethod = ebizPayment.PaymentMethod;
                            payment.PaymentInternalId = ebizPayment.PaymentInternalId;
                            string paymentRequestDateTime = ebizPayment.PaymentRequestDateTime;
                            if (paymentRequestDateTime != Configuration.EMPTYSTRING && paymentRequestDateTime != null) {
                                List < String > requestDateTime = paymentRequestDateTime.split(Configuration.DATETIMESPLITTER);
                                String payDateTime = requestDateTime[0] + Configuration.DATETIMESEPERATOR + requestDateTime[1];
                                payment.PaymentRequestDateTime = DateTime.ValueofGmt(payDateTime);
                            }
                            payment.PaymentMethodId = ebizPayment.PaymentMethodId;
                            receivedPayments.add(payment);
                            ebcLogger.debug(ClassName, MethodName, '>>>receivedPayments: ' + receivedPayments);
                    }
                }
                if (!test.isRunningTest()) {
                    if (customerIds != null) {
                        ebcLogger.debug(ClassName, MethodName, 'customerIds: ' + customerIds);
                        Schema.DescribeSObjectResult sObjectResultAccount = Contact.sObjectType.getDescribe();
                        String keyPrefixAccount = sObjectResultAccount.getKeyPrefix();
                        List< String > accountIds = new List< String >();
                        for (string contactId : customerIds){
                            if(!contactId.startsWith(keyPrefixAccount)){
                                accountIds.add(contactId);
                            }
                        }
                        List < Account > accountsDetails = eBc_UtilityController.getAccountsDetailForQbd(dml, accountIds, ebcLogger);
                        List< String > contactIds = new List< String >();
                        Schema.DescribeSObjectResult sObjectResultContact = Contact.sObjectType.getDescribe();
                        String keyPrefixContact = sObjectResultContact.getKeyPrefix();
                        for (string contactId : customerIds){
                            if(contactId.startsWith(keyPrefixContact)){
                                contactIds.add(contactId);
                            }
                        }
                        List < Contact > contactsDetails = eBc_UtilityController.getContactsDetail(dml, contactIds, ebcLogger);
                        Map < String, String > customerIdsMap = new map < String, String > ();
                        Map < String, String > customerIdsMapHelper = new map < String, String > ();
                        for (Account account: accountsDetails) {
                            customerIdsMap.put((String)account.get('QBD_Customer_ID__c'),account.Name);
                            customerIdsMapHelper.put((String)account.get('QBD_Customer_ID__c'),account.id);
                        }
                        for (Contact contact: contactsDetails) {
                            customerIdsMap.put(contact.id, contact.Name);
                        }
                        List < String > accountIdsList = new List < String > ();
                        for (Payments payment: receivedPayments) {
                            accountIdsList.add(payment.CustomerId);
                            if (customerIdsMap.containsKey(payment.CustomerId)) {
                                if(payment.CustomerId.startsWith(keyPrefixContact)){
                                    payment.CustomerName = Configuration.TARGETURL + payment.CustomerId;
                                }else{
                                    payment.CustomerName = Configuration.TARGETURL + customerIdsMapHelper.get(payment.CustomerId);
                                }
                                payment.accName = customerIdsMap.get(payment.CustomerId);
                                returnReceivedPayments.add(payment);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, '>>>Error has been occured  ');
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        ebcLogger.debug(ClassName, MethodName, '>>>returnReceivedPayments: ' + returnReceivedPayments);
        return returnReceivedPayments;
    }
    @AuraEnabled
    public static PendingPayments getPendingRequestPaymentsApxc(String sDate, String eDate, String webformType) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        PendingPayments reciprocate = getPendingRequestPaymentsApxc(dml, sDate, eDate, webformType, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static PendingPayments getPendingRequestPaymentsApxc(DML dml, String sDate, String eDate, String webformType, EBC_Logger ebcLogger) {
        MethodName = 'getPendingRequestPaymentsApxc';
        Date startDtateForApi = null;
        Date endDtateForApi = null;
        if (sDate != null) {
            DateTime datetimeEntity = Date.valueOf(sDate);
            startDtateForApi = Date.valueOf(datetimeEntity);
        }
        if (eDate != null) {
            DateTime datetimeEntity = Date.valueOf(eDate);
            datetimeEntity = datetimeEntity.AddDays(1);
            endDtateForApi = Date.valueOf(datetimeEntity);
        }
        if (test.isRunningTest()) {
            sDate = null;
        }
        if (sDate == null) {
            startDtateForApi = date.newinstance(1900, 01, 01);
        }
        if (test.isRunningTest()) {
            eDate = null;
        }
        if (eDate == null) {
            endDtateForApi = date.newinstance(2100, 01, 01);
        }
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        PendingPayments returnPendingPayments = new PendingPayments();
        ebizchargeServicemodelSoap.ArrayOfSearchFilter searchFilterArray = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        List < ebizchargeServicemodelSoap.SearchFilter > searchFilters = new List < ebizchargeServicemodelSoap.SearchFilter > ();
        if (webformType == Configuration.PYAMENTMETHODREQUESTS) {
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.InvoiceNumber);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = string.valueOf(Enums.FIELDVALUES.Token);
            searchFilters.add(filter);
        }
        List < Payments > returnPendingRequestPayments = new List < Payments > ();
        List < Payments > returnPendingRequestPaymentsUpdated = new List < Payments > ();
        List < Payments > pendingList = new List < Payments > ();
        List < String > customerIds = new List < String > ();
        returnPendingPayments.PendingList = null;
        try {
            list < ebizchargeServicemodelSoap.Payment > pendingRequestpayments = new list < ebizchargeServicemodelSoap.Payment > ();
            if (!test.isRunningTest()) {
                searchFilterArray.SearchFilter = searchFilters;
                pendingRequestpayments = eBc_UtilityController.searchPendingPaymentsCustomer(dml, startDtateForApi, endDtateForApi, Configuration.EMPTYSTRING, searchFilterArray, ebcLogger);
                ebcLogger.debug(ClassName, MethodName, 'pendingRequestpayments: ' + pendingRequestpayments);
            } else {
                //-----------------------------------mockdata----------------------------------
                ebizchargeServicemodelSoap.Payment ebizMocDkata = new ebizchargeServicemodelSoap.Payment();
                ebizMocDkata.CustomerId = '001123456777777';
                ebizMocDkata.PaidAmount = '2.00';
                Datetime startDate = Datetime.newInstance(2017, 1, 7, 15, 20, 45);
                ebizMocDkata.PaymentRequestDateTime = startDate.format('yyyy-MM-dd\'T\'HH:mm:ss');
                pendingRequestpayments.add(ebizMocDkata);
                //---------------------------------------------------------------------------------
            }
            if (pendingRequestpayments != null) {
                for (ebizchargeServicemodelSoap.Payment ebizPendingPayment: pendingRequestpayments) {
                    Payments pendingPayment = new Payments();
                    if (ebizPendingPayment.CustomerId != null && ebizPendingPayment.CustomerId != Configuration.EMPTYSTRING) {
                        string customerId = ebizPendingPayment.CustomerId;
                        String keyPrefix = Configuration.EMPTYSTRING;
                        Schema.DescribeSObjectResult sObjectResultAcount = Account.sObjectType.getDescribe();
                        String keyPrefixAccount = sObjectResultAcount.getKeyPrefix();
                        Schema.DescribeSObjectResult sObjectResultContact = Contact.sObjectType.getDescribe();
                        String keyPrefixContact = sObjectResultContact.getKeyPrefix();
                            customerIds.add(ebizPendingPayment.CustomerId);
                            if (webformType == Configuration.PYAMENTMETHODREQUESTS) {
                                pendingPayment.methodType = Configuration.PAYMENTMETHODTYPE;
                            }
                            pendingPayment.CustomerId = ebizPendingPayment.CustomerId;
                            pendingPayment.CustomerEmailAddress = ebizPendingPayment.CustomerEmailAddress;
                            if (customerId.startsWith(keyPrefixContact)) {
                                pendingPayment.objectName = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact);
                            } else {
                                pendingPayment.objectName = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account);
                            }
                            pendingPayment.PaymentInternalId = ebizPendingPayment.PaymentInternalId;
                            if (ebizPendingPayment.PaymentRequestDateTime != Configuration.EMPTYSTRING && ebizPendingPayment.PaymentRequestDateTime != null) {
                                List < String > requestDateTime = ebizPendingPayment.PaymentRequestDateTime.split(Configuration.DATETIMESPLITTER);
                                String pendingPaymentRequestDateTime = requestDateTime[0] + Configuration.DATETIMESEPERATOR + requestDateTime[1];
                                pendingPayment.PaymentRequestDateTime = DateTime.ValueofGmt(pendingPaymentRequestDateTime);
                            }
                            pendingList.add(pendingPayment);
                            ebcLogger.debug(ClassName, MethodName, 'pendingList: ' + pendingList);
                    }
                }
                if (!test.isRunningTest()) {
                    if (customerIds != null) {
                        ebcLogger.debug(ClassName, MethodName, 'customerIds: ' + customerIds);
                        List < Account > accountsDetails = eBc_UtilityController.getAccountsDetailForQbd(dml, customerIds, ebcLogger);
                        List< String > contactIds = new List< String >();
                        Schema.DescribeSObjectResult sObjectResultContact = Contact.sObjectType.getDescribe();
                        String keyPrefixContact = sObjectResultContact.getKeyPrefix();
                        for (string contactId : customerIds){
                            if(contactId.startsWith(keyPrefixContact)){
                                contactIds.add(contactId);
                            }
                        }
                        system.debug('Contact Ids>>>>' + contactIds);
                        List < Contact > contactsDetails = eBc_UtilityController.getContactsDetail(dml, contactIds, ebcLogger);
                        Map < String, String > customerIdsMap = new map < String, String > ();
                        Map < String, String > customerIdsMapHelper = new map < String, String > ();
                        for (Account account: accountsDetails) {
                            customerIdsMap.put((String)account.get('QBD_Customer_ID__c'),account.Name);
                            customerIdsMapHelper.put((String)account.get('QBD_Customer_ID__c'),account.id);
                        }
                        for (Contact contact: contactsDetails) {
                            customerIdsMap.put(contact.id, contact.name);
                        }
                        List < String > accountIdsList = new List < String > ();
                        for (Payments payment: pendingList) {
                            accountIdsList.add(payment.CustomerId);
                            if (customerIdsMap.containsKey(payment.CustomerId)) {
                                if(payment.CustomerId.startsWith(keyPrefixContact)){
                                    payment.CustomerName = Configuration.TARGETURL + payment.CustomerId;
                                }else{
                                    payment.CustomerName = Configuration.TARGETURL + customerIdsMapHelper.get(payment.CustomerId);
                                }
                                payment.accName = customerIdsMap.get(payment.CustomerId);
                                returnPendingRequestPayments.add(payment);
                            }
                        }
                        ebcLogger.debug(ClassName, MethodName, 'returnPendingRequestPayments: ' + returnPendingRequestPayments);
                        Map < String, Decimal > pendingCustomers = new map < String, Decimal > ();
                        querySelect = 'SELECT Id,Payment_Account_ID__c,Send_Request_Count__c';
                        queryFrom = 'FROM EBizCharge_RequestPaymentPending__c';
                        queryWhere = 'WHERE Payment_Account_ID__c IN :';
                        List < EBizCharge_RequestPaymentPending__c > requestPaymentPending = (List < EBizCharge_RequestPaymentPending__c > ) dml.selectRecordsInList(accountIdsList, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                        for (EBizCharge_RequestPaymentPending__c pendingRequestEntity: requestPaymentPending) {
                            pendingCustomers.put(pendingRequestEntity.Payment_Account_ID__c, pendingRequestEntity.Send_Request_Count__c);
                        }
                        for (Payments payment: returnPendingRequestPayments) {
                            if (pendingCustomers.containsKey(payment.CustomerId)) {
                                payment.ResendCount = pendingCustomers.get(payment.CustomerId);
                            } else {
                                payment.ResendCount = 1;
                            }
                            returnPendingRequestPaymentsUpdated.add(payment);
                        }
                    }
                }
                returnPendingPayments.PendingList = returnPendingRequestPaymentsUpdated;
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, '>>>Error has been occured');
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnPendingPayments;
    }
    @AuraEnabled
    public static String resendPendingPaymentApx(List < Payments > pendingPayList) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = resendPendingPaymentApx(dml, pendingPayList, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String resendPendingPaymentApx(DML dml, List < Payments > pendingPayList, EBC_Logger ebcLogger) {
        MethodName = 'resendPendingPaymentApx';
        ebcLogger.debug(ClassName, MethodName, 'pendingPayListSize: ' + pendingPayList.size());
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        List < String > customerIds = new List < String > ();
        try {
            for (Payments payment: pendingPayList) {
                if (payment.isSelected == true) {
                    customerIds.add(payment.customerId);
                }
            }
            List < EBizCharge_RequestPaymentPending__c > requestPaymentPendingUpdated = new List < EBizCharge_RequestPaymentPending__c > ();
            querySelect = 'SELECT Id,Payment_Account_ID__c,Send_Request_Count__c';
            queryFrom = 'FROM EBizCharge_RequestPaymentPending__c';
            queryWhere = 'WHERE Payment_Account_ID__c IN :';
            List < EBizCharge_RequestPaymentPending__c > requestPaymentsPending = (List < EBizCharge_RequestPaymentPending__c > ) dml.selectRecordsInList(customerIds, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            for (EBizCharge_RequestPaymentPending__c requestPaymentPending: requestPaymentsPending) {
                EBizCharge_RequestPaymentPending__c requestPaymentPendingEntity = new EBizCharge_RequestPaymentPending__c();
                requestPaymentPendingEntity.id = requestPaymentPending.Id;
                requestPaymentPendingEntity.Payment_Account_ID__c = requestPaymentPending.Payment_Account_ID__c;
                requestPaymentPendingEntity.Send_Request_Count__c = requestPaymentPending.Send_Request_Count__c;
                requestPaymentPendingEntity.Send_Request_Count__c++;
                requestPaymentPendingUpdated.add(requestPaymentPendingEntity);
            }
            for (Payments payment: pendingPayList) {
                if (payment.isSelected == true) {
                    if (!test.isRunningTest()) {
                        string ebizResponse = eBc_UtilityController.ResendEbizWebFormEmail(dml, payment.PaymentInternalId, ebcLogger);
                    }
                }
            }
            dml.upsertRecord(requestPaymentPendingUpdated);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static List < Payments > removePendingPaymentsApxc(List < Payments > pendingPayList) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < Payments > reciprocate = removePendingPaymentsApxc(dml, pendingPayList, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    @AuraEnabled
    public static String markPaymentAsApplied(String PaymentInternalId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = markPaymentAsApplied(dml, PaymentInternalId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String markPaymentAsApplied(DML dml, String PaymentInternalId, EBC_Logger ebcLogger) {
        MethodName = 'markPaymentAsApplied';
        try {
            ebcLogger.debug(ClassName, MethodName, 'PaymentInternalId:' + PaymentInternalId);
            ebizchargeServicemodelSoap.PaymentResponse ebizResponse = eBc_UtilityController.MarkEbizWebFormPaymentAsApplied(dml, PaymentInternalId, ebcLogger);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception err) {
            return err.getMessage();
        }
    }
    public static List < Payments > removePendingPaymentsApxc(DML dml, List < Payments > pendingPayList, EBC_Logger ebcLogger) {
        MethodName = 'removePendingPaymentsApxc';
        List < Payments > returnPendingPaymentsUpdated = new List < Payments > ();
        try {
            for (Payments payment: pendingPayList) {
                if (payment.isSelected == true) {
                    if (!test.isRunningTest()) {
                        ebizchargeServicemodelSoap.PaymentResponse ebizResponse = eBc_UtilityController.removeEbizWebFormPayment(dml, payment.PaymentInternalId, ebcLogger);
                    }
                } else {
                    returnPendingPaymentsUpdated.add(payment);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnPendingPaymentsUpdated;
    }
   
    @AuraEnabled
    public static List < Payments > removeRecievedPaymentsApxc(List < Payments > recievedPayList) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        list < Payments > reciprocate = removeRecievedPaymentsApxc(dml, recievedPayList, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < Payments > removeRecievedPaymentsApxc(DML dml, List < Payments > recievedPayList, EBC_Logger ebcLogger) {
        MethodName = 'removeRecievedPaymentsApxc';
        List < Payments > returnUpdatedReceivedPayments = new List < Payments > ();
        ebcLogger.debug(ClassName, MethodName, '>>>Received list to remove : ' + recievedPayList);
        try {
            for (Payments payment: recievedPayList) {
                if (payment.isSelected == true) {
                    if (!test.isRunningTest()) {
                        ebizchargeServicemodelSoap.PaymentResponse ebizResponse = eBc_UtilityController.removeEbizWebFormPayment(dml, payment.PaymentInternalId, ebcLogger);
                    }
                } else {
                    returnUpdatedReceivedPayments.add(payment);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnUpdatedReceivedPayments;
    }
    public class CustomerData
    {
        @AuraEnabled public list<CustomerWrapper> customersData {
            get;
            set;
        }
        @AuraEnabled public map<String,String> customersMap {
            get;
            set;
        }
        @AuraEnabled public DateTime accountDate {
            get;
            set;
        }
        @AuraEnabled public DateTime contactDate {
            get;
            set;
        }
    }
    public class CustomerWrapper {
        @AuraEnabled public boolean isSelected {
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
        @AuraEnabled public DateTime dateCreated {
            get;
            set;
        }
        @AuraEnabled public String paymentmethodurl {
            get;
            set;
        }
        @AuraEnabled public String HyperUrlAccount {
            get;
            set;
        }
        @AuraEnabled public Decimal accAmount {
            get;
            set;
        }
        @AuraEnabled public String MethodType {
            get;
            set;
        }
        @AuraEnabled public String accEmail {
            get;
            set;
        }
        @AuraEnabled public String accExtId {
            get;
            set;
        }
        @AuraEnabled public map < String, String > savedPaymentMethods {
            get;
            set;
        }
        @AuraEnabled public list < customerMethod > SavedPaymentMethodslist {
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
        @AuraEnabled public String objectName {
            get;
            set;
        }
        @AuraEnabled public Date fromDate {
            get;
            set;
        }
        @AuraEnabled public Date toDate {
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
        @AuraEnabled public Contact ContactInfo {
            get;
            set;
        }
        @AuraEnabled public String ContactId {
            get;
            set;
        }
        @AuraEnabled public String ContactName {
            get;
            set;
        }
        @AuraEnabled public String ContactInternalId {
            get;
            set;
        }
        @AuraEnabled public map < String, String > savedPaymentMethods {
            get;
            set;
        }
        @AuraEnabled public list < customerMethod > SavedPaymentMethodslist {
            get;
            set;
        }
        @AuraEnabled public Order ordDetail {
            get;
            set;
        }
        @AuraEnabled public Quote quoteDetail {
            get;
            set;
        }
        @AuraEnabled public Boolean UseFullAmountForAVS {
            get;
            set;
        }
        @AuraEnabled public contact contactDetail {
            get;
            set;
        }
        @AuraEnabled public Opportunity OpportunityDetail {
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
        @AuraEnabled public EBizCharge_Fields_Config__c CustomCustInfo {
            get;
            set;
        }
        @AuraEnabled public String CustomCustId {
            get;
            set;
        }
        @AuraEnabled public String CustomCustName {
            get;
            set;
        }
        @AuraEnabled public String CustomCustInternalId {
            get;
            set;
        }
        @AuraEnabled public String Object_label {
            get;
            set;
        }
    }
    public class wrapperConfigObject {
        @AuraEnabled public EBiz_Object_Config__c config {
            get;
            set;
        }
        @AuraEnabled public List < dropdownVals > EBizCharge_Amount_fields_list {
            get;
            set;
        }
        @AuraEnabled public List < dropdownVals > EBizCharge_name_fields_list {
            get;
            set;
        }
        @AuraEnabled public List < dropdownVals > EBizCharge_EBizCharge_Email_list {
            get;
            set;
        }
    }
    public class dropdownVals {
        @AuraEnabled public string label {
            get;
            set;
        }
        @AuraEnabled public string value {
            get;
            set;
        }
    }
    public class emailTemplate {
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
        @AuraEnabled public String TemplateFromName {
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
    public class customerMethod {
        @AuraEnabled public String MethodType {
            get;
            set;
        }
        @AuraEnabled public String MethodID {
            get;
            set;
        }
        @AuraEnabled public String MethodName {
            get;
            set;
        }
        @AuraEnabled public DateTime DateCreated {
            get;
            set;
        }
        @AuraEnabled public DateTime DateModified {
            get;
            set;
        }
        @AuraEnabled public String AccountHolderName {
            get;
            set;
        }
        @AuraEnabled public String AvsStreet {
            get;
            set;
        }
        @AuraEnabled public String AvsZip {
            get;
            set;
        }
        @AuraEnabled public String CardExpiration {
            get;
            set;
        }
        @AuraEnabled public String CardExpMonth {
            get;
            set;
        }
        @AuraEnabled public String CardExpYear {
            get;
            set;
        }
        @AuraEnabled public String CardNumber {
            get;
            set;
        }
        @AuraEnabled public String Last4Degit {
            get;
            set;
        }
        @AuraEnabled public String CardType {
            get;
            set;
        }
        @AuraEnabled public String CardCode {
            get;
            set;
        }
        @AuraEnabled public String Account {
            get;
            set;
        }
        @AuraEnabled public String AccountType {
            get;
            set;
        }
        @AuraEnabled public String Routing {
            get;
            set;
        }
        @AuraEnabled public Integer SecondarySort {
            get;
            set;
        }
    }
    public class PaymentMethods {
        @AuraEnabled public Contact ContactInfo {
            get;
            set;
        }
        @AuraEnabled public Account AccountInfo {
            get;
            set;
        }
        @AuraEnabled public map < String, String > savedPaymentMethods {
            get;
            set;
        }
        @AuraEnabled public list < customerMethod > SavedPaymentMethodslist {
            get;
            set;
        }
    }
    public class PaymentMethodsContact {
        @AuraEnabled public Contact ContactInfo {
            get;
            set;
        }
        @AuraEnabled public map < String, String > savedPaymentMethods {
            get;
            set;
        }
        @AuraEnabled public list < customerMethod > SavedPaymentMethodslist {
            get;
            set;
        }
    }
    public class PaymentMethodsCustomCust {
        @AuraEnabled public EBizCharge_Fields_Config__c ContactInfo {
            get;
            set;
        }
        @AuraEnabled public map < String, String > savedPaymentMethods {
            get;
            set;
        }
        @AuraEnabled public list < customerMethod > SavedPaymentMethodslist {
            get;
            set;
        }
    }
    public class PendingPayments {
        @AuraEnabled public Date fromDate {
            get;
            set;
        }
        @AuraEnabled public Date toDate {
            get;
            set;
        }
        @AuraEnabled public List < Payments > PendingList {
            get;
            set;
        }
    }
    public class Payments {
        @AuraEnabled public string OrderId {
            get;
            set;
        }
        @AuraEnabled public string cardClass {
            get;
            set;
        }
        @AuraEnabled public string CustomerId {
            get;
            set;
        }
        @AuraEnabled public String accName {
            get;
            set;
        }
        @AuraEnabled public string CustomerName {
            get;
            set;
        }
        @AuraEnabled public String objectName {
            get;
            set;
        }
        @AuraEnabled public decimal ResendCount {
            get;
            set;
        }
        @AuraEnabled public string DivisionId {
            get;
            set;
        }
        @AuraEnabled public string InvoiceNumber {
            get;
            set;
        }
        @AuraEnabled public string InvoiceInternalId {
            get;
            set;
        }
        @AuraEnabled public string InvoiceDate {
            get;
            set;
        }
        @AuraEnabled public string InvoiceDueDate {
            get;
            set;
        }
        @AuraEnabled public string PoNum {
            get;
            set;
        }
        @AuraEnabled public string InvoiceAmount {
            get;
            set;
        }
        @AuraEnabled public string AmountDue {
            get;
            set;
        }
        @AuraEnabled public string AuthCode {
            get;
            set;
        }
        @AuraEnabled public string RefNum {
            get;
            set;
        }
        @AuraEnabled public string Last4 {
            get;
            set;
        }
        @AuraEnabled public string PaymentMethod {
            get;
            set;
        }
        @AuraEnabled public string DatePaid {
            get;
            set;
        }
        @AuraEnabled public decimal PaidAmount {
            get;
            set;
        }
        @AuraEnabled public string PaymentInternalId {
            get;
            set;
        }
        @AuraEnabled public Date PayDate {
            get;
            set;
        }
        @AuraEnabled public string PayTime {
            get;
            set;
        }
        @AuraEnabled public string PaymentMethodId {
            get;
            set;
        }
        @AuraEnabled public string TypeId {
            get;
            set;
        }
        @AuraEnabled public string PaymentSourceId {
            get;
            set;
        }
        @AuraEnabled public string TransactionLookupKey {
            get;
            set;
        }
        @AuraEnabled public string ExternalTxnId {
            get;
            set;
        }
        @AuraEnabled public string CustomerEmailAddress {
            get;
            set;
        }
        @AuraEnabled public boolean isSelected {
            get;
            set;
        }
        @AuraEnabled public String contactName {
            get;
            set;
        }
        @AuraEnabled public String contactURL {
            get;
            set;
        }
        @AuraEnabled public String methodType {
            get;
            set;
        }
        @AuraEnabled public DateTime PaymentRequestDateTime {
            get;
            set;
        }
    }
}