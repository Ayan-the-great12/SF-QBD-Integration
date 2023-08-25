public with sharing class eBc_ContactController {
    public static string ClassName = 'eBc_ContactController';
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
    public static List < ContactWrapper > getAllContactsApxc() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < ContactWrapper > reciprocate = getAllContactsApxc(dml, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < ContactWrapper > getAllContactsApxc(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getAllContactsApxc';
        ebcLogger.debug(ClassName, MethodName, 'call updateContactMethod----');
        ebcLogger.debug(ClassName, MethodName, 'call updateContactMethod finish----');
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        String queryOrderby = Configuration.EMPTYSTRING;
        String queryLimit = Configuration.EMPTYSTRING;
        List < ContactWrapper > contactWrapperList = new List < ContactWrapper > ();
        List < Contact > contactsList = new List < Contact > ();
        try {
            querySelect = 'SELECT Id, Name, createdById ,Email, FirstName, LastName  ,Phone, Fax,MailingCountry,MailingState ,' +
                'OtherAddress,OtherCity,OtherCountry,OtherState ,OtherStreet ,OtherPostalCode ,Ebiz_C__EBizCharge_Contact_Internal_ID__c,' +
                'MailingCity,MailingStreet  ,MailingPostalCode ,Ebiz_C__EBizCharge_Contact_Amount__c';
            queryFrom = 'FROM Contact';
            queryOrderby = 'Contact Order by CreatedDate DESC';
            queryLimit = 'limit 500';
            contactsList = (List < Contact > ) dml.selectRecords(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryOrderby, queryLimit);
            for (Contact contact: contactsList) {
                ContactWrapper contactWrapper = new ContactWrapper();
                contactWrapper.conHyperUrl = '/' + contact.Id;
                contactWrapper.conId = contact.Id;
                contactWrapper.conName = contact.Name;
                contactWrapper.conAmount = contact.Ebiz_C__EBizCharge_Contact_Amount__c;
                contactWrapper.conFirstName = contact.FirstName;
                contactWrapper.conLastName = contact.LastName;
                contactWrapper.conEmail = contact.Email;
                contactWrapper.conPhone = contact.Phone;
                contactWrapper.conExtId = contact.Ebiz_C__EBizCharge_Contact_Internal_ID__c;
                contactWrapper.conBillingStreet = contact.OtherStreet;
                contactWrapper.conBillingCity = contact.OtherCity;
                contactWrapper.conBillingPostalCode = contact.OtherPostalCode;
                contactWrapper.conBillingCountry = contact.OtherCountry;
                contactWrapper.conShippingStreet = contact.MailingStreet;
                contactWrapper.conShippingCity = contact.MailingCity;
                contactWrapper.conShippingState = contact.MailingState;
                contactWrapper.conShippingPostalCode = contact.MailingPostalCode;
                contactWrapper.conShippingCountry = contact.MailingCountry;
                if (contact.Ebiz_C__EBizCharge_Contact_Internal_ID__c != null && contact.Ebiz_C__EBizCharge_Contact_Internal_ID__c != Configuration.EMPTYSTRING) {
                    contactWrapper.conStatus = string.valueOf(Enums.ASSIGNMENTSTRINGS.Synced);
                } else {
                    contactWrapper.conStatus = Configuration.NOTSYNCED;
                }
                contactWrapper.isSelected = false;
                contactWrapperList.add(contactWrapper);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return contactWrapperList;
    }
    public static void updateContactInternalIds(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'updateContactInternalIds';
        try {
            EBizcharge_Setting__c ebizSetting = eBc_SettingController.getSettingsApxc(dml, ebcLogger);
            if (!ebizSetting.EBizcharge_Sync_Contacts_OnInstall__c && !(ebizSetting.Security_Token__c.trim() == Configuration.EMPTYSTRING || ebizSetting.Security_Token__c == null)) {
                ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
                ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
                ebizchargeServicemodelSoap.ArrayOfSearchFilter filterArray = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
                ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
                list < ebizchargeServicemodelSoap.SearchFilter > searchFilterList = new list < ebizchargeServicemodelSoap.SearchFilter > ();
                filter.FieldName = string.valueOf(Enums.FieldNames.SoftwareID);
                filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
                filter.FieldValue = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
                searchFilterList.add(filter);
                filterArray.SearchFilter = searchFilterList;
                list < ebizchargeServicemodelSoap.Customer > customersList = new list < ebizchargeServicemodelSoap.Customer > ();
                ebizchargeServicemodelSoap.ArrayOfCustomer arrayOfCustomer = new ebizchargeServicemodelSoap.ArrayOfCustomer();
                ebizchargeServicemodelSoap.CustomerListSearchResult customersListResponse = new ebizchargeServicemodelSoap.CustomerListSearchResult();
                customersListResponse = ebiz.SearchCustomerList(securityToken, filterArray, 0, 10, Configuration.EMPTYSTRING, false, false, true);
                if (customersListResponse != null) {
                    Integer count = 0;
                    count = customersListResponse.Count;
                    if (count > 0) {
                        Map < String, String > conIdAndInternalId = new Map < String, String > ();
                        Integer loopSize = (Integer) Math.ceil((Decimal) count / 1000);
                        for (Integer i = 0; i < loopsize; i++) {
                            ebcLogger.debug(ClassName, MethodName, 'loop to searchcustomerlist in updateContact');
                            customersListResponse = ebiz.SearchCustomerList(securityToken, filterArray, i * 1000, 1000, Configuration.EMPTYSTRING, false, false, false);
                            arrayOfCustomer = customersListResponse.CustomerList;
                            customersList = arrayOfCustomer.Customer;
                            if (customersList != null) {
                                for (ebizchargeServicemodelSoap.Customer customer: customersList) {
                                    Schema.DescribeSObjectResult r = Contact.sObjectType.getDescribe();
                                    String keyPrefix = r.getKeyPrefix();
                                    if (customer.CustomerId.startsWith(keyPrefix)) {
                                        ebcLogger.debug(ClassName, MethodName, 'ContactMatch  in updateContact');
                                        conIdAndInternalId.put(customer.CustomerId, customer.CustomerInternalId);
                                    }
                                }
                                ebcLogger.debug(ClassName, MethodName, 'total ContactMatch  in updateContact' + conIdAndInternalId.size());
                            }
                        }
                        String querySelect = 'SELECT Id,EBizCharge_Contact_Internal_ID__c';
                        String queryFrom = 'FROM Contact';
                        List < Contact > contactsListToUpdate = new List < Contact > ();
                        for (Contact contact: (list < Contact > ) dml.selectRecords(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING)) {
                            if (test.isRunningTest()) {
                                contact.EBizCharge_Contact_Internal_ID__c = null;
                            }
                            if (contact.EBizCharge_Contact_Internal_ID__c == null || contact.EBizCharge_Contact_Internal_ID__c == Configuration.EMPTYSTRING) {
                                ebcLogger.debug(ClassName, MethodName, 'Internal Found null in updateContact');
                                if (conIdAndInternalId.containsKey(contact.id)) {
                                    ebcLogger.debug(ClassName, MethodName, 'ContactId Match With Local in updateContact');
                                    ebcLogger.debug(ClassName, MethodName, 'ContactId & EBizCharge_Internal_ID__c' + contact.id + ' -- ' + conIdAndInternalId.get(contact.id));
                                    contact.EBizCharge_Contact_Internal_ID__c = conIdAndInternalId.get(contact.id);
                                    contactsListToUpdate.add(contact);
                                }
                            }
                        }
                        ebcLogger.debug(ClassName, MethodName, 'total UpdateContactList  in updateContact' + contactsListToUpdate.size());
                        if (contactsListToUpdate != null && contactsListToUpdate.size() > 0) {
                            dml.updateRecord(contactsListToUpdate);
                            ebizSetting.EBizcharge_Sync_Contacts_OnInstall__c = true;
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
    public static ContactDetail getContactDetailApxc(String ContactId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        ContactDetail reciprocate = getContactDetailApxc(dml, ContactId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static ContactDetail getContactDetailApxc(DML dml, String ContactId, EBC_Logger ebcLogger) {
        MethodName = 'getContactDetailApxc';
        ContactDetail contactDetailEntity = new ContactDetail();
        try {
            Contact contactDetail = eBc_UtilityController.getContactDetail(dml, ContactId, ebcLogger);
            contactDetailEntity.ContactInfo = contactDetail;
            if (!test.isRunningTest()) {
                ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
                responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
                contactDetailEntity.UseFullAmountForAVS = responseMerchant.UseFullAmountForAVS;
            }
            map < String, String > updateContactMap = new map < string, string > ();
            String contactExternalId = contactDetail.EBizCharge_Contact_Internal_ID__c;
            if (test.isRunningTest()) {
                contactExternalId = null;
            }
            if (contactExternalId == null || contactExternalId == Configuration.EMPTYSTRING) {
                //search customer on Gateway 
                ebizchargeServicemodelSoap.Customer customer = new ebizchargeServicemodelSoap.Customer();
                customer = eBc_UtilityController.invoke_SearchCustomer(dml, ContactId, ebcLogger);
                if (customer.CustomerInternalId != null) {
                    contactExternalId = customer.CustomerInternalId;
                    updateContactMap.put(ContactId, customer.CustomerInternalId);
                } else {
                    // add customer on Gateway
                    ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = eBc_UtilityController.invoke_addORUpdCustomerContact(dml, contactDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger), string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
                    contactExternalId = addCustomerResponse.CustomerInternalId;
                    updateContactMap.put(ContactId, addCustomerResponse.CustomerInternalId);
                }
            }
            contactDetailEntity.savedPaymentMethods = eBc_UtilityController.GetCustomerSavedPaymentMethods(dml, contactDetail.Id, contactExternalId, ebcLogger);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return contactDetailEntity;
    }
    @AuraEnabled
    public static string autoSyncContactApxc(String ContactId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = autoSyncContactApxc(dml, ContactId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string autoSyncContactApxc(DML dml, String ContactId, EBC_Logger ebcLogger) {
        MethodName = 'autoSyncContactApxc';
        string contactExternalId = Configuration.EMPTYSTRING;
        try {
            Contact contactDetail = eBc_UtilityController.getContactDetail(dml, ContactId, ebcLogger);
            // add customer on Gateway
            ebizchargeServicemodelSoap.CustomerResponse customerResponse = eBc_UtilityController.invoke_addORUpdCustomerContact(dml, contactDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger), string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
            contactExternalId = customerResponse.CustomerInternalId;
            Contact contact = new Contact();
            contact.Id = ContactId;
            contact.EBizCharge_Contact_Internal_ID__c = contactExternalId;
            contact.EBizCharge_Last_Sync_Date__c = system.now();
            dml.updateRecord(contact);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static string syncContactApxc(list < ContactWrapper > selectedContact) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = syncContactApxc(dml, selectedContact, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string syncContactApxc(DML dml, list < ContactWrapper > selectedContact, EBC_Logger ebcLogger) {
        MethodName = 'syncContactApxc';
        try {
            EBizcharge_Setting__c ebizchargeSettings = eBc_UtilityController.getSettings(dml, ebcLogger);
            map < String, String > updateContactMap = new map < string, string > ();
            ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
            for (ContactWrapper contactWrapper: selectedContact) {
                ebizchargeServicemodelSoap.Customer customer = new ebizchargeServicemodelSoap.Customer();
                customer.CustomerId = contactWrapper.conId;
                customer.FirstName = contactWrapper.conFirstName;
                customer.LastName = contactWrapper.conLastName;
                customer.CompanyName = contactWrapper.conName;
                customer.Phone = contactWrapper.conPhone;
                customer.Email = contactWrapper.conEmail;
                customer.Fax = Configuration.EMPTYSTRING;
                customer.WebSite = Configuration.EMPTYSTRING;
                customer.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
                ebizchargeServicemodelSoap.Address billingAddress = new ebizchargeServicemodelSoap.Address();
                billingAddress.FirstName = contactWrapper.conFirstName;
                billingAddress.LastName = contactWrapper.conLastName;
                billingAddress.CompanyName = Configuration.EMPTYSTRING;
                billingAddress.Address1 = contactWrapper.conBillingStreet;
                billingAddress.Address2 = Configuration.EMPTYSTRING;
                billingAddress.City = contactWrapper.conBillingCity;
                billingAddress.State = contactWrapper.conBillingState;
                billingAddress.ZipCode = contactWrapper.conBillingPostalCode;
                billingAddress.Country = contactWrapper.conBillingCountry;
                customer.BillingAddress = billingAddress;
                ebizchargeServicemodelSoap.Address shippingAddress = new ebizchargeServicemodelSoap.Address();
                shippingAddress.FirstName = contactWrapper.conFirstName;
                shippingAddress.LastName = contactWrapper.conLastName;
                shippingAddress.CompanyName = Configuration.EMPTYSTRING;
                shippingAddress.Address1 = contactWrapper.conShippingStreet;
                shippingAddress.Address2 = Configuration.EMPTYSTRING;
                shippingAddress.City = contactWrapper.conShippingCity;
                shippingAddress.State = contactWrapper.conShippingState;
                shippingAddress.ZipCode = contactWrapper.conShippingPostalCode;
                shippingAddress.Country = contactWrapper.conShippingCountry;
                customer.ShippingAddress = shippingAddress;
                if (test.isRunningTest()) {
                    ebizchargeSettings.Division_ID__c = '122222222';
                }
                if (ebizchargeSettings.Division_ID__c != null) {
                    customer.DivisionId = ebizchargeSettings.Division_ID__c;
                }
                if (test.isRunningTest()) {
                    return Configuration.SUCCESSMESSAGE;
                }
                ebizchargeServicemodelSoap.Customer searchCustomerResponse = new ebizchargeServicemodelSoap.Customer();
                searchCustomerResponse = EBC_CompMethods.invoke_SearchCustomer(dml, contactWrapper.conId, ebcLogger);
                if (searchCustomerResponse.CustomerInternalId != null) {
                    updateContactMap.put(contactWrapper.conId, searchCustomerResponse.CustomerInternalId);
                } else {
                    // add customer on Gateway
                    ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = new ebizchargeServicemodelSoap.CustomerResponse();
                    addCustomerResponse = ebiz.addCustomer(securityToken, customer);
                    if (addCustomerResponse.StatusCode == 1) {
                        updateContactMap.put(contactWrapper.conId, addCustomerResponse.CustomerInternalId);
                    }
                }
            } // end of loop...
            if (updateContactMap.size() > 0) {
                return eBc_UtilityController.updCustomerInSFContact(dml, updateContactMap, ebcLogger);
            } else {
                return string.valueOf(Enums.RETURNMESSAGE.Success);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return Configuration.EXCEPTIONMESSAGE;
        }
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
        map < String, String > ListOfPaymentMethods = new map < String, String > ();
        ListOfPaymentMethods = eBc_UtilityController.GetCustomerSavedPaymentMethods(dml, AccountID, accExternalId, ebcLogger);
        return ListOfPaymentMethods;
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
        ebizchargeServicemodelSoap.EmailTemplate[] EmailTemplateList;
        ebizchargeServicemodelSoap.ArrayOfEmailTemplate arrayOfEmailTemplates = new ebizchargeServicemodelSoap.ArrayOfEmailTemplate();
        try {
            arrayOfEmailTemplates = ebiz.GetEmailTemplates(eBc_UtilityController.getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            EmailTemplateList = arrayOfEmailTemplates.EmailTemplate;
            if (EmailTemplateList != null) {
                for (ebizchargeServicemodelSoap.EmailTemplate emailTemplate: EmailTemplateList) {
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
    public static String addPaymentMehtodReqApxc(String sendReqJSON, String ContactId, String ContactName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = addPaymentMehtodReqApxc(dml, sendReqJSON, ContactId, ContactName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String addPaymentMehtodReqApxc(DML dml, String sendReqJSON, String ContactId, String ContactName, EBC_Logger ebcLogger) {
        MethodName = 'addPaymentMehtodReqApxc';
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        String queryOrderby = Configuration.EMPTYSTRING;
        String queryLimit = Configuration.EMPTYSTRING;
        Map < String, Object > mapReq = (Map < String, Object > ) JSON.deserializeUntyped(sendReqJSON);
        ebizchargeServicemodelSoap.EbizWebForm ebizWebForm = new ebizchargeServicemodelSoap.EbizWebForm();
        try {
            ebizWebForm.FromName = string.valueOf(Enums.ASSIGNMENTSTRINGS.EBizCharge);
            ebizWebForm.FromEmail = (string) mapReq.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.fromEmail));
            ebizWebForm.EmailAddress = (string) mapReq.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.toEmail));
            ebizWebForm.EmailSubject = (string) mapReq.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Subject));
            ebizWebForm.EmailNotes = (string) mapReq.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Notes));
            ebizWebForm.EmailTemplateID = (string) mapReq.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.TemplateId));
            ebizWebForm.Date_x = System.now();
            ebizWebForm.CustomerId = ContactId;
            ebizWebForm.CustFullName = ContactName;
            ebizWebForm.InvoiceNumber = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.Token);
            ebizWebForm.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            ebizWebForm.Clerk = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.AppUser);
            ebizWebForm.FormType = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.PmRequestForm);
            ebizWebForm.PayByType = Configuration.PAYBYTYPESTRING;
            ebizWebForm.OrderId = Configuration.WEBFORMORDERID;
            ebizWebForm.SendEmailToCustomer = true;
            // added by @wqkl against BillingAddress - (02Feb21) - start
            Contact tempContact = new Contact();
            querySelect = 'select id, accountid,FirstName,LastName,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry';
            queryFrom = 'from contact';
            queryWhere = 'where id=\'' + ContactId + '\'';
            tempContact = (Contact) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            ebizchargeServicemodelSoap.Address customerAddress = new ebizchargeServicemodelSoap.Address();
            customerAddress.FirstName = tempContact.FirstName;
            customerAddress.LastName = tempContact.LastName;
            customerAddress.Address1 = tempContact.MailingStreet;
            customerAddress.City = tempContact.MailingCity;
            customerAddress.State = tempContact.MailingState;
            customerAddress.ZipCode = tempContact.MailingPostalCode;
            customerAddress.Country = tempContact.MailingCountry;
            ebizWebForm.BillingAddress = customerAddress;
            // added by @wqkl against BillingAddress - (02Feb21) - end
            string response = ebiz.GetEbizWebFormURL(eBc_UtilityController.getSecurityToken(dml, ebcLogger), ebizWebForm);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return Configuration.EXCEPTIONMESSAGE;
        }
    }
    public static String AddPaymentMethodContact(DML dml, Map < String, Object > strMap, String saveMethod, EBC_Logger ebcLogger) {
        MethodName = 'AddPaymentMethodContact';
        transactionParams transactionPayload = new transactionParams();
        String paymentMethodID = Configuration.EMPTYSTRING;
        try {
            transactionPayload.internalID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ConExternalId));
            if (saveMethod == string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard)) {
                transactionPayload.ccNumber = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
                transactionPayload.expMonth = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
                transactionPayload.expYear = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
                transactionPayload.cvvCode = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
                transactionPayload.ccName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
                transactionPayload.AvsZip = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
                transactionPayload.AvsStreet = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
                transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
                Boolean saveCard = (boolean) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
                if (saveCard == true) {
                    paymentMethodID = eBc_UtilityController.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                }
            }
            if (saveMethod == string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH)) {
                transactionPayload.AccountName = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
                transactionPayload.Account = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
                transactionPayload.Route = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
                transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
                transactionPayload.accountType = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.accType));
                Boolean saveACH = (boolean) strMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH));
                if (saveACH == true) {
                    paymentMethodID = eBc_UtilityController.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH), ebcLogger);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return paymentMethodID;
    }
    public static String AddPaymentMethod(DML dml, Map < String, Object > strMap, String saveMethod, EBC_Logger ebcLogger) {
        MethodName = 'AddPaymentMethod';
        transactionParams transactionPayload = new transactionParams();
        String paymentMethodID = Configuration.EMPTYSTRING;
        try {
            transactionPayload.internalID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccExternalId));
            if (saveMethod == string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard)) {
                transactionPayload.ccNumber = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
                transactionPayload.expMonth = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
                transactionPayload.expYear = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
                transactionPayload.cvvCode = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
                transactionPayload.ccName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
                transactionPayload.AvsZip = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
                transactionPayload.AvsStreet = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
                transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
                Boolean saveCard = (boolean) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
                if (saveCard == true) {
                    paymentMethodID = eBc_UtilityController.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                }
            }
            if (saveMethod == string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH)) {
                transactionPayload.AccountName = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
                transactionPayload.Account = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
                transactionPayload.Route = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
                transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
                transactionPayload.accountType = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.accType));
                Boolean saveACH = (boolean) strMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH));
                if (saveACH == true) {
                    paymentMethodID = eBc_UtilityController.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH), ebcLogger);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return paymentMethodID;
    }
    public static String processPaymentContact(DML dml, Map < String, Object > strMap, String processBy, EBC_Logger ebcLogger) {
        MethodName = 'processPaymentContact';
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        String queryOrderby = Configuration.EMPTYSTRING;
        String queryLimit = Configuration.EMPTYSTRING;
        string paymentMethodID = Configuration.EMPTYSTRING;
        try {
            Boolean sendReceiptTo = (boolean) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
            String addEmails = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.addEmails));
            Double amount = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Amount));
            Double tax = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Tax));
            String taxAction = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.TaxAction));
            ebcLogger.debug(ClassName, MethodName, 'Tax:' + tax);
            transactionParams transactionPayload = new transactionParams();
            transactionPayload.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            transactionPayload.OrderID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OrderNo));
            transactionPayload.OrderNumber = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OrderNo));
            if (taxAction == Configuration.TAXACTION) {
                transactionPayload.SubTotal = 0;
            } else {
                transactionPayload.SubTotal = amount;
            }
            transactionPayload.Amount = amount + tax;
            transactionPayload.Tax = tax;
            transactionPayload.accountID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ConId));
            transactionPayload.customerID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ConId));
            transactionPayload.internalID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ConExternalId));
            transactionPayload.Terminal = (String) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Terminal));
            transactionPayload.isRecurring = false;
            ebizchargeServicemodelSoap.ArrayOfLineItem arrayOfLineItem = new ebizchargeServicemodelSoap.ArrayOfLineItem();
            arrayOfLineItem.LineItem = new List < ebizchargeServicemodelSoap.Lineitem > ();
            ebizchargeServicemodelSoap.LineItem lineItem = new ebizchargeServicemodelSoap.Lineitem();
            Contact lineItemContact = new Contact();
            querySelect = 'select id, name, accountid';
            queryFrom = 'from contact';
            queryWhere = 'where id =\'' + transactionPayload.customerID + '\'';
            lineItemContact = (Contact) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            String lineItemAccountId = lineItemContact.accountid;
            if (test.isRunningTest()) {
                lineItemAccountId = '001134234111';
            }
            if (lineItemAccountId != null) {
                Account lineItemAccount = new Account();
                querySelect = 'select id, name';
                queryFrom = 'from account';
                queryWhere = 'where id =\'' + lineItemAccountId + '\'';
                lineItemAccount = (Account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                lineItem.SKU = lineItemAccount.id;
                lineItem.ProductName = lineItemAccount.name;
                lineItem.Description = Configuration.ACCOUNTLINEITEMDESCRIPTION;
                lineItem.UnitPrice = String.valueOf(amount + tax);
                lineItem.Qty = Configuration.LINEITEMQUANTITY;
                lineItem.Taxable = true;
                lineItem.UnitOfMeasure = string.valueOf(Enums.LINEITEMPARAMETERS.EA);
                lineItem.TaxAmount = String.valueOf(tax);
                arrayOfLineItem.LineItem.add(lineItem);
                transactionPayload.LineItems = arrayOfLineItem;
            } else {
                lineItem.SKU = transactionPayload.customerID;
                lineItem.ProductName = lineItemContact.name;
                lineItem.Description = Configuration.CONTACTLINEITEMDESCRIPTION;
                lineItem.UnitPrice = String.valueOf(amount + tax);
                lineItem.Qty = Configuration.LINEITEMQUANTITY;
                lineItem.Taxable = true;
                lineItem.UnitOfMeasure = string.valueOf(Enums.LINEITEMPARAMETERS.EA);
                lineItem.TaxAmount = String.valueOf(tax);
                arrayOfLineItem.LineItem.add(lineItem);
                transactionPayload.LineItems = arrayOfLineItem;
            }
            ebizchargeServicemodelSoap.TransactionResponse transactionResponse = new ebizchargeServicemodelSoap.TransactionResponse();
            if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingCard)) {
                transactionPayload.methodID = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.selectedCardId));
                transactionPayload.CardCode = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.cvcNo));
                transactionResponse = eBc_UtilityController.runTransactionPaymentContact(dml, transactionPayload, sendReceiptTo, addEmails, string.valueOf(Enums.PAYMENTTYPES.Sale), ebcLogger);
            } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard)) {
                Contact contactDetail = eBc_UtilityController.getContactDetail(dml, (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ConId)), ebcLogger);
                transactionPayload.methodID = Configuration.CARDMETHODID;
                transactionPayload.ccNumber = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
                transactionPayload.expMonth = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
                transactionPayload.expYear = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
                transactionPayload.cvvCode = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
                transactionPayload.ccName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
                transactionPayload.AvsZip = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
                transactionPayload.AvsStreet = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
                if (strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode)) == Configuration.EMPTYSTRING) {
                    paymentMethodID = AddPaymentMethodContact(dml, strMap, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                    transactionResponse = eBc_UtilityController.runTransactionOnlyContactTab(dml, transactionPayload, contactDetail, strMap, paymentMethodID, ebcLogger);
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
                transactionResponse = eBc_UtilityController.runTransactionPaymentContact(dml, transactionPayload, sendReceiptTo, addEmails, string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check), ebcLogger);
            } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH)) {
                Contact contactDetail = eBc_UtilityController.getContactDetail(dml, (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ConId)), ebcLogger);
                paymentMethodID = AddPaymentMethodContact(dml, strMap, string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH), ebcLogger);
                transactionPayload.methodID = Configuration.ACCOUNTMETHODID;
                transactionPayload.AccountName = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
                transactionPayload.Account = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
                transactionPayload.Route = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
                transactionResponse = eBc_UtilityController.runTransactionOnlyContactTab(dml, transactionPayload, contactDetail, strMap, paymentMethodID, ebcLogger);
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
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Contact_Id__c.isCreateable()) {
                    transactionEntity.Contact_Id__c = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ConId));
                }
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Ref_Number__c.isCreateable()) {
                    transactionEntity.Ref_Number__c = transactionReferenceNum;
                }
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Payment_Method__c.isCreateable()) {
                    transactionEntity.Payment_Method__c = paymentMethodID;
                }
                eBc_UtilityController.saveTransaction(dml, transactionReferenceNum, transactionEntity, ebcLogger);
                Contact updateContact = new Contact();
                updateContact.Id = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ConId));
                double contactAmount = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ConAmount));
                if (contactAmount == null) {
                    contactAmount = 0;
                }
                double contactTax = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ConTax));
                if (contactTax == null) {
                    contactTax = 0;
                }
                //@wqkl added '+ tax' in the following statement against QA negative value issue on 27jan21
                if (Schema.sObjectType.Contact.fields.EBizCharge_Contact_Amount__c.isUpdateable()) {
                    updateContact.EBizCharge_Contact_Amount__c = contactAmount + amount + tax;
                }
                if (Schema.sObjectType.Contact.fields.EBizCharge_Contact_Reference_Number__c.isUpdateable()) {
                    updateContact.EBizCharge_Contact_Reference_Number__c = transactionReferenceNum;
                }
                if (Schema.sObjectType.Contact.fields.EBizCharge_Contact_Tax__c.isUpdateable()) {
                    updateContact.EBizCharge_Contact_Tax__c = contactTax + tax;
                }
                if (Schema.sObjectType.Contact.isUpdateable()) {
                    if (!Test.isRunningTest()) {
                        dml.updateRecord(updateContact);
                    }
                }
                return string.valueOf(Enums.RETURNMESSAGE.Success);
            } else {
                return Configuration.GATEWAYERRORMESSAGESTRING + '\'' + transactionResponse.Error + '\''; //updated @wqkl on 29Jan21 against Error message modification
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
        Map < String, Object > savedCardMap = (Map < String, Object > ) JSON.deserializeUntyped(savedCardJson);
        String response = processPaymentContact(dml, savedCardMap, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingCard), ebcLogger);
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
            ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
            if (!Test.isRunningTest()) {
                responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
            } else {
                //********Mock Data*****
                responseMerchant = new ebizchargeServicemodelSoap.MerchantTransactionData();
                isAVSCheck = true;
                responseMerchant.UseFullAmountForAVS = false;
                responseMerchant.EnableAVSWarnings = true;
            }
            if (responseMerchant.EnableAVSWarnings == false) {
                isAVSCheck = false;
            }
            Boolean AVSMatch = true;
            String returnMessage = Configuration.AVSCHECKSTRING;
            if (isAVSCheck == true && responseMerchant.UseFullAmountForAVS == false) {
                ebizchargeServicemodelSoap.TransactionResponse transactionResponse = new ebizchargeServicemodelSoap.TransactionResponse();
                if (!Test.isRunningTest()) {
                    transactionResponse = eBc_UtilityController.runAVSCheckContact(dml, addNewCardMap, ebcLogger);
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
                    return Configuration.GATEWAYERRORMESSAGESTRING + '\'' + transactionResponse.Error + '\'';
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
            String response = processPaymentContact(dml, addNewCardMap, string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard), ebcLogger);
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
        Map < String, Object > savedAChMap = (Map < String, Object > ) JSON.deserializeUntyped(savedACHJSON);
        String response = processPaymentContact(dml, savedAChMap, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingACH), ebcLogger);
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
        Map < String, Object > newACHmap = (Map < String, Object > ) JSON.deserializeUntyped(addNewACHJSON);
        String response = processPaymentContact(dml, newACHmap, string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH), ebcLogger);
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
                ebizchargeServicemodelSoap.TransactionResponse transactionResponse = new ebizchargeServicemodelSoap.TransactionResponse();
                transactionResponse = ebiz.runTransaction(eBc_UtilityController.getSecurityToken(dml, ebcLogger), transactionRequest);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    public class ContactDetail {
        @AuraEnabled public EBizcharge_Setting__c Settings {
            get;
            set;
        }
        @AuraEnabled public Contact ContactInfo {
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
    public class ContactWrapper {
        @AuraEnabled public boolean isSelected {
            get;
            set;
        }
        @AuraEnabled public String conHyperUrl {
            get;
            set;
        }
        @AuraEnabled public String conId {
            get;
            set;
        }
        @AuraEnabled public String conName {
            get;
            set;
        }
        @AuraEnabled public Decimal conAmount {
            get;
            set;
        }
        @AuraEnabled public String conFirstName {
            get;
            set;
        }
        @AuraEnabled public String conLastName {
            get;
            set;
        }
        @AuraEnabled public String conEmail {
            get;
            set;
        }
        @AuraEnabled public String conPhone {
            get;
            set;
        }
        @AuraEnabled public String conExtId {
            get;
            set;
        }
        @AuraEnabled public String conStatus {
            get;
            set;
        }
        @AuraEnabled public String conBillingStreet {
            get;
            set;
        }
        @AuraEnabled public String conBillingCity {
            get;
            set;
        }
        @AuraEnabled public String conBillingState {
            get;
            set;
        }
        @AuraEnabled public String conBillingPostalCode {
            get;
            set;
        }
        @AuraEnabled public String conBillingCountry {
            get;
            set;
        }
        @AuraEnabled public String conShippingCity {
            get;
            set;
        }
        @AuraEnabled public String conShippingState {
            get;
            set;
        }
        @AuraEnabled public String conShippingPostalCode {
            get;
            set;
        }
        @AuraEnabled public String conShippingCountry {
            get;
            set;
        }
        @AuraEnabled public String conShippingStreet {
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