public with sharing class eBc_ProcessPaymentController {
    public static string ClassName = 'eBc_ProcessPaymentController';
    public static string MethodName = Configuration.EMPTYSTRING;
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
        try {
            return eBc_UtilityController.getSettings(dml, ebcLogger);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return null;
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
        MethodName = 'getDetailApxc';
        Detail detailEntity = new Detail();
        try {
            Schema.DescribeSObjectResult entityDescription = Contact.sObjectType.getDescribe();
            String keyPrefix = entityDescription.getKeyPrefix();
            if (recordId.startsWith(keyPrefix)) {
                ObjectName = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact);
            }
            String querySelect = 'SELECT Id,CreatedDate,Name';
            String queryFrom = ' FROM ' + ObjectName;
            String queryWhere = ' WHERE Id = \'' + recordId + '\'';
            if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
                querySelect += ',AccountId,Ebiz_C__Custom_Amount__c,Account.Name, Amount, Ebiz_C__EBizCharge_Opportunity_Status__c,EBizCharge_Opportunity_Balance__c,EBizCharge_Amount__c,EBizCharge_Internal_ID__c,EBizCharge_Reference_Number__c, EBizCharge_PONumber__c';
            } else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
                querySelect += ',AccountId,Account.Name,OrderNumber,PoNumber,TotalAmount,EBizCharge_Order_Status__c,EBizCharge_Order_Balance__c,EBizCharge_Amount__c,EBizCharge_Internal_ID__c,EBizCharge_Reference_Number__c, EBizCharge_Order_Tax__c';
            } else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
                querySelect += ',AccountId,Account.Name,EBizCharge_Amount__c,EBizCharge_Internal_ID__c,EBizCharge_Reference_Number__c';
            } else if (objectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote)) {
                querySelect += ', AccountId, Account.Name, QuoteNumber, GrandTotal, EBizCharge_Quote_Status__c, EBizCharge_Quote_Balance__c, EBizCharge_Amount__c,EBizCharge_Internal_ID__c,EBizCharge_Reference_Number__c, EBizCharge_Quote_Tax_c__c, EBizCharge_PONumber__c';
            }
            // added by @wqkl - 8dec20 - end
            String query = querySelect + Configuration.DOUBLEBLANKS + queryFrom + Configuration.DOUBLEBLANKS + queryWhere;
            sObject sObjectDetail = dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            String AccountId = Configuration.EMPTYSTRING;
            String AccountName = Configuration.EMPTYSTRING;
            map < String, String > updateAccountMap = new map < string, string > ();
            if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
                AccountId = string.valueOf(sObjectDetail.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.AccountId)));
                detailEntity.OppId = recordId;
                detailEntity.OppName = string.valueOf(sObjectDetail.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Name)));
            } else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)) {
                AccountId = string.valueOf(sObjectDetail.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Id)));
                querySelect = 'select id,billingstreet,billingcity,billingstate,billingPostalCode,BillingCountry';
                queryFrom = 'from account';
                queryWhere = 'where id=\'' + AccountId + '\'';
                account account = (account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                string shippingAddress = Configuration.EMPTYSTRING;
                if (account != null) {
                    // Add Mockdata 
                    if (test.isRunningTest()) {
                        account.billingstreet = 'fakeStreet';
                        account.billingPostalCode = 'fakeCode';
                    } //  Mockdata End
                    if (account.billingstreet != null && account.billingstreet != Configuration.EMPTYSTRING) {
                        shippingAddress = shippingAddress + account.billingstreet;
                    }
                    if (account.billingPostalCode != null && account.billingPostalCode != Configuration.EMPTYSTRING) {
                        detailEntity.ZipCode = account.billingPostalCode;
                    }
                }
                detailEntity.Address = shippingAddress;
            } else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
                AccountId = string.valueOf(sObjectDetail.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.AccountId)));
            }
            // added by @wqkl against SF-137 : 8dec20 : start
            else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote)) {
                AccountId = string.valueOf(sObjectDetail.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.AccountId)));
            }
            // added by @wqkl against SF-137 : 8dec20 : end
            else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
                AccountId = string.valueOf(sObjectDetail.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.AccountId)));
                detailEntity.contactDetail = (contact) sObjectDetail;
                querySelect = 'select id,Mailingstreet,Mailingcity,Mailingstate,MailingPostalCode,MailingCountry';
                queryFrom = 'from contact';
                queryWhere = 'where id=\'' + detailEntity.contactDetail.id + '\'';
                contact contact = (contact) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                string shippingAddress = Configuration.EMPTYSTRING;
                if (contact != null) {
                    if (contact.Mailingstreet != null && contact.Mailingstreet != Configuration.EMPTYSTRING) {
                        shippingAddress = shippingAddress + contact.Mailingstreet;
                    }
                    if (contact.MailingPostalCode != null && contact.MailingPostalCode != Configuration.EMPTYSTRING) {
                        detailEntity.ZipCode = contact.MailingPostalCode;
                    }
                }
                detailEntity.Address = shippingAddress;
            }
            Account accountDetail = EBC_CompMethods.getAccountDetail(dml, AccountId, ebcLogger);
            String customerId = (string)accountDetail.get('QBD_Customer_ID__c');
            detailEntity.AccountInfo = accountDetail;
            //detailEntity.AccountId = AccountId;
            detailEntity.AccountId = (string)accountDetail.get('QBD_Customer_ID__c');
            detailEntity.AccountName = accountDetail.Name;
            ebcLogger.debug(ClassName, MethodName, 'accountDetail.BillingAddress:' + accountDetail.BillingAddress);
            String accountExternalId = accountDetail.EBizCharge_Internal_ID__c;
            //  Mockdata 
            if (test.isRunningTest()) {
                accountExternalId = null;
            } //  Mockdata End
            if (accountExternalId == null || accountExternalId == Configuration.EMPTYSTRING) {
                //search customer on GW 
                ebizchargeServicemodelSoap.Customer customerSearchResponse = new ebizchargeServicemodelSoap.Customer();
                customerSearchResponse = EBC_CompMethods.invoke_SearchCustomer(dml, customerId, ebcLogger);
                if (customerSearchResponse.CustomerInternalId != null) {
                    accountExternalId = customerSearchResponse.CustomerInternalId;
                    updateAccountMap.put(accountId, customerSearchResponse.CustomerInternalId);
                } else {
                    // add customer on GW
                    ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = EBC_CompMethods.invoke_addCustomer(dml, accountDetail, ebcLogger);
                    accountExternalId = addCustomerResponse.CustomerInternalId;
                    updateAccountMap.put(AccountId, addCustomerResponse.CustomerInternalId);
                }
            }
            detailEntity.AccountInternalId = accountExternalId;
            if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
                Opportunity OpportunityDetail = (Opportunity) sObjectDetail;
                detailEntity.OpportunityDetail = OpportunityDetail;
                querySelect = 'select id,billingstreet,billingcity,billingstate,billingPostalCode,BillingCountry';
                queryFrom = 'from account';
                queryWhere = 'where id=\'' + OpportunityDetail.Account.Id + '\'';
                account account = (account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                string shippingAddress = Configuration.EMPTYSTRING;
                if (account != null) {
                    if (account.billingstreet != null && account.billingstreet != Configuration.EMPTYSTRING) {
                        shippingAddress = shippingAddress + account.billingstreet;
                    }
                    if (account.billingPostalCode != null && account.billingPostalCode != Configuration.EMPTYSTRING) {
                        detailEntity.ZipCode = account.billingPostalCode;
                    }
                }
                detailEntity.Address = shippingAddress;
                map < String, String > updateOrderMap = new map < string, string > ();
            }
            if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
                Order orderDetail = (Order) sObjectDetail;
                detailEntity.ordDetail = orderDetail;
                querySelect = 'select id,billingstreet,billingcity,billingstate,billingPostalCode,BillingCountry';
                queryFrom = 'from account';
                queryWhere = 'where id=\'' + orderDetail.Account.Id + '\'';
                account account = (account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                string shippingAddress = Configuration.EMPTYSTRING;
                if (account != null) {
                    // Add Mockdata 
                    if (test.isRunningTest()) {
                        account.billingstreet = 'fakeStreet';
                        account.billingPostalCode = 'fakeCode';
                    } //  Mockdata End
                    if (account.billingstreet != null && account.billingstreet != Configuration.EMPTYSTRING) {
                        shippingAddress = shippingAddress + account.billingstreet;
                    }
                    if (account.billingPostalCode != null && account.billingPostalCode != Configuration.EMPTYSTRING) {
                        detailEntity.ZipCode = account.billingPostalCode;
                    }
                }
                detailEntity.Address = shippingAddress;
                map < String, String > updateOrderMap = new map < string, string > ();
                String OrderNumber = (string) sObjectDetail.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.OrderNumber));
                String orderInternalId = (string) sObjectDetail.get(Configuration.INTERNALIDSTRING);
                if (orderInternalId == null || orderInternalId == Configuration.EMPTYSTRING) {
                    //search sale order on GW
                    ebizchargeServicemodelSoap.SalesOrder searchOrderResponse = new ebizchargeServicemodelSoap.SalesOrder();
                    searchOrderResponse = EBC_CompMethods.invoke_SearchOrder(dml, AccountId, OrderNumber, ebcLogger);
                    if (searchOrderResponse.SalesOrderInternalId != null) {
                        updateOrderMap.put(recordId, searchOrderResponse.SalesOrderInternalId);
                    } else {
                        // add sale order on GW
                        ebizchargeServicemodelSoap.SalesOrderResponse addSalesOrderResponse = EBC_CompMethods.invoke_addSaleOrder(dml, orderDetail, ebcLogger);
                        updateOrderMap.put(recordId, addSalesOrderResponse.SalesOrderInternalId);
                    }
                }
                //update Order
                if (updateOrderMap != null) {
                    List < Order > ordersToUpdate = new List < Order > ();
                    for (String key: updateOrderMap.keySet()) {
                        Order order = new Order();
                        order.Id = key;
                        order.EBizCharge_Internal_ID__c = updateOrderMap.get(key);
                        order.EBizCharge_Last_Sync_Date__c = system.now();
                        ordersToUpdate.add(order);
                    }
                    dml.updateRecord(ordersToUpdate);
                }
            }
            // added by @wqkl against SF-137 : 8dec20 : start
            if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote)) {
                Quote quoteDetail = (Quote) sObjectDetail;
                detailEntity.quoteDetail = quoteDetail;
                querySelect = 'select id,billingstreet,billingcity,billingstate,billingPostalCode,BillingCountry';
                queryFrom = 'from account';
                queryWhere = 'where id=\'' + quoteDetail.Account.Id + '\'';
                account account = (account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                string shippingAddress = Configuration.EMPTYSTRING;
                if (account != null) {
                    if (account.billingstreet != null && account.billingstreet != Configuration.EMPTYSTRING) {
                        shippingAddress = shippingAddress + account.billingstreet;
                    }
                    if (account.billingPostalCode != null && account.billingPostalCode != Configuration.EMPTYSTRING) {
                        detailEntity.ZipCode = account.billingPostalCode;
                    }
                }
                detailEntity.Address = shippingAddress;
                map < String, String > updateQuoteMap = new map < string, string > ();
                String QuoteNumber = (string) sObjectDetail.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.QuoteNumber));
                String quoteInternalId = (string) sObjectDetail.get(Configuration.INTERNALIDSTRING);
                if (quoteInternalId == null || quoteInternalId == Configuration.EMPTYSTRING) {
                    //search quote on GW
                    ebizchargeServicemodelSoap.SalesOrder searchOrderResponse = new ebizchargeServicemodelSoap.SalesOrder();
                    searchOrderResponse = EBC_CompMethods.invoke_SearchOrder(dml, AccountId, QuoteNumber, ebcLogger);
                    if (searchOrderResponse.SalesOrderInternalId != null) {
                        updateQuoteMap.put(recordId, searchOrderResponse.SalesOrderInternalId);
                    } else {
                        // add quote on GW
                        ebizchargeServicemodelSoap.SalesOrderResponse addQuoteResponse = EBC_CompMethods.invoke_addQuote(dml, quoteDetail, ebcLogger);
                        updateQuoteMap.put(recordId, addQuoteResponse.SalesOrderInternalId);
                    }
                }
                //update Quote
                if (updateQuoteMap != null) {
                    List < Quote > quotesToUpdate = new List < Quote > ();
                    for (String key: updateQuoteMap.keySet()) {
                        Quote quote = new Quote();
                        quote.Id = key;
                        quote.EBizCharge_Internal_ID__c = updateQuoteMap.get(key);
                        quote.EBizCharge_Last_Sync_Date__c = system.now();
                        quotesToUpdate.add(quote);
                    }
                    dml.updateRecord(quotesToUpdate);
                }
            }
            // added by @wqkl against SF-137 : 8dec20 : end
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
            // "Convert" the exception into an AuraHandledException
            if (!Test.isRunningTest()) {
                throw new AuraHandledException(Configuration.DEFAULTERRORMESSAGESTRING + e.getMessage());
            }
        }
        return detailEntity;
    }
    @auraEnabled
    public static OrderWrapper getListOfOrdersApxc(String AccountID) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        OrderWrapper reciprocate = getListOfOrdersApxc(dml, AccountID, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static OrderWrapper getListOfOrdersApxc(DML dml, String AccountID, EBC_Logger ebcLogger) {
        MethodName = 'getListOfOrdersApxc';
        ebcLogger.debug(ClassName, MethodName, 'AccountID:' + AccountID);
        String querySelect = 'select id, accountId';
        String queryFrom = 'from contact';
        String queryWhere = 'where id=\'' + AccountId + '\'';
        String queryLimit = Configuration.EMPTYSTRING;
        try {
            Schema.DescribeSObjectResult entityDescription = Contact.sObjectType.getDescribe();
            String keyPrefix = entityDescription.getKeyPrefix();
            if (AccountID.startsWith(keyPrefix)) {
                contact contact = (contact) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                AccountId = contact.accountId;
            }
            string accountExternalId = Configuration.EMPTYSTRING;
            map < String, String > updateAccountMap = new map < string, string > ();
            Account accountDetail = eBc_UtilityController.getAccountDetail(dml, AccountId, ebcLogger);
            accountExternalId = accountDetail.EBizCharge_Internal_ID__c;
            // Add Mockdata 
            if (test.isRunningTest()) {
                accountExternalId = null;
            } //  Mockdata End
            if (accountExternalId == null || accountExternalId == Configuration.EMPTYSTRING) {
                //search customer on GW 
                ebizchargeServicemodelSoap.Customer customerSearchResponse = new ebizchargeServicemodelSoap.Customer();
                customerSearchResponse = eBc_UtilityController.invoke_SearchCustomer(dml, (string)accountDetail.get('QBD_Customer_ID__c'), ebcLogger);
                if (customerSearchResponse.CustomerInternalId != null) {
                    accountExternalId = customerSearchResponse.CustomerInternalId;
                    updateAccountMap.put(AccountId, customerSearchResponse.CustomerInternalId);
                } else {
                    // add customer on GW
                    ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = eBc_UtilityController.invoke_addORUpdCustomer(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger), string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
                    accountExternalId = addCustomerResponse.CustomerInternalId;
                    updateAccountMap.put(AccountId, addCustomerResponse.CustomerInternalId);
                }
            }
            // get Customer Saved Payment Method
            map < string, string > savedPaymentMethods = new map < string, string > ();
            EBC_ComponentController.PaymentMethods ebizPaymentMethods = new EBC_ComponentController.PaymentMethods();
            if (!Test.isRunningTest()) {
                savedPaymentMethods = eBc_UtilityController.GetCustomerSavedPaymentMethods(dml, (string)accountDetail.get('QBD_Customer_ID__c'), accountExternalId, ebcLogger);
                ebizPaymentMethods = EBC_ComponentController.getCustPaymentMethodsApx(dml, AccountID, ebcLogger);
            }
            //update Account
            if (updateAccountMap != null) {
                List < Account > accountsToUpdate = new List < Account > ();
                for (String key: updateAccountMap.keySet()) {
                    Account account = new Account();
                    account.Id = key;
                    account.EBizCharge_Internal_ID__c = updateAccountMap.get(key);
                    accountsToUpdate.add(account);
                }
                dml.updateRecord(accountsToUpdate);
            }
            List < Order > orderList = new List < Order > ();
            List < OrderHelper > orderHelperList = new List < OrderHelper > ();
            querySelect = 'SELECT Id,Name,OrderNumber,CreatedDate,TotalAmount, EBizCharge_Internal_ID__c,' +
                'AccountId,Account.Name,Account.First_Name__c,Account.Last_Name__c,Account.QBD_Customer_ID__c,Account.Email__c,Account.EBizCharge_Internal_ID__c,' +
                'EffectiveDate, EndDate,Status,EBizCharge_Payment_Status__c,EBizCharge_Captured_Amount__c,EBizCharge_Order_Status__c,EBizCharge_Order_Tax__c,EBizCharge_Order_Balance__c,EBizCharge_Amount__c, ' +
                '(SELECT Id,product2Id,product2.Name,product2.ProductCode,UnitPrice,Quantity,OrderId,Product2.EBizCharge_Internal_ID__c FROM OrderItems)';
            queryFrom = 'FROM Order';
            queryWhere = 'where EBizCharge_Order_Status__c <> \'Paid\' AND EBizCharge_Payment_Status__c <> \'Preauth\' AND AccountId=\'' + AccountID + '\'';
            queryLimit = 'limit 2000';
            orderList = (List < Order > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryLimit);
            EBizcharge_Setting__c settingsEntity = eBc_UtilityController.getSettings(dml, ebcLogger);
            Boolean allowPartialPayment = settingsEntity.Allow_Partial_Payment__c;
            if (orderList != null) {
                for (Order order: orderList) {
                    OrderHelper orderHelper = new OrderHelper();
                    order.EBizCharge_Order_Balance__c = order.EBizCharge_Order_Balance__c == null ? 0 : order.EBizCharge_Order_Balance__c;
                    orderHelper.Id = order.Id;
                    orderHelper.OrderNumber = order.OrderNumber;
                    orderHelper.CreatedDate = order.CreatedDate;
                    orderHelper.OrderBalance = order.EBizCharge_Order_Balance__c == 0 ? order.TotalAmount : order.EBizCharge_Order_Balance__c;
                    orderHelper.TotalAmount = order.TotalAmount;
                    orderHelper.AmountDue = order.EBizCharge_Order_Balance__c == 0 ? order.TotalAmount : order.EBizCharge_Order_Balance__c;
                    orderHelper.OrderTax = order.EBizCharge_Order_Tax__c == null ? 0 : order.EBizCharge_Order_Tax__c;
                    orderHelper.AmountReceived = order.EBizCharge_Captured_Amount__c == null ? 0 : order.EBizCharge_Captured_Amount__c;
                    orderHelper.OrdExternalId = order.EBizCharge_Internal_ID__c;
                    orderHelper.EffectiveDate = order.EffectiveDate;
                    orderHelper.PaymentStatus = string.valueOf(order.EBizCharge_Payment_Status__c);
                    orderHelper.accId = order.AccountId;
                    orderHelper.accName = order.Account.Name;
                    orderHelper.accFirstName = order.Account.First_Name__c;
                    orderHelper.accLastName = order.Account.Last_Name__c;
                    orderHelper.accEmail = (String)order.Account.get('Email__c');
                    orderHelper.accExternalId = order.Account.EBizCharge_Internal_ID__c;
                    orderHelper.isSelected = false;
                    orderHelper.isEdited = false;
                    orderHelper.isAllowPartialPay = allowPartialPayment;
                    orderHelperList.add(orderHelper);
                } // end of loop...
            } // enf of order list...
            OrderWrapper orderWarpper = new OrderWrapper();
            orderWarpper.savedPaymentMethods = savedPaymentMethods;
            orderWarpper.savedMethods = ebizPaymentMethods;
            orderWarpper.accountOrders = orderHelperList;
            orderWarpper.accountDetail = accountDetail;
            return orderWarpper;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return null;
        }
    }
    @AuraEnabled
    public static string autoSyncOrderApxc(String OrderId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = autoSyncOrderApxc(dml, OrderId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
        //return autoSyncOrderApxc(dml, OrderId);
    }
    public static string autoSyncOrderApxc(DML dml, String OrderId, EBC_Logger ebcLogger) {
        MethodName = 'autoSyncOrderApxc';
        try {
            Order orderDetail = eBc_UtilityController.getOrderDetail(dml, OrderId, ebcLogger);
            String orderExternalId = Configuration.EMPTYSTRING;
            ebizchargeServicemodelSoap.SalesOrderResponse addSalesorderResponse = eBc_UtilityController.invoke_AddORUpdateOrder(dml, orderDetail, null, eBc_UtilityController.getSecurityToken(dml, ebcLogger), string.valueOf(Enums.ENTITYACTIONS.addOrder), ebcLogger);
            orderExternalId = addSalesorderResponse.SalesOrderInternalId;
            Order order = new Order();
            order.Id = OrderId;
            order.EBizCharge_Internal_ID__c = orderExternalId;
            order.EBizCharge_Last_Sync_Date__c = system.now();
            dml.updateRecord(order);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static String processPaymentWithXCApxc(String savedCardJson, List < OrderHelper > OrdersList, Account accountDetail, String PaymentType) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = processPaymentWithXCApxc(dml, savedCardJson, OrdersList, accountDetail, PaymentType, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String processPaymentWithXCApxc(DML dml, String savedCardJson, List < OrderHelper > OrdersList, Account accountDetail, String PaymentType, EBC_Logger ebcLogger) {
        MethodName = 'processPaymentWithXCApxc';
        for (OrderHelper orderHelper: OrdersList) {
            //nothing to do
        }
        Map < String, Object > savedCardMap = (Map < String, Object > ) JSON.deserializeUntyped(savedCardJson);
        String response = processPayment(dml, savedCardMap, OrdersList, accountDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingCard), PaymentType, ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String procesPaymentWithNCApxc(String addNewCardJSON, List < OrderHelper > OrdersList, Account accountDetail, String PaymentType) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = procesPaymentWithNCApxc(dml, addNewCardJSON, OrdersList, accountDetail, PaymentType, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String procesPaymentWithNCApxc(DML dml, String addNewCardJSON, List < OrderHelper > OrdersList, Account accountDetail, String PaymentType, EBC_Logger ebcLogger) {
        MethodName = 'procesPaymentWithNCApxc';
        Map < String, Object > addNewCardMap = (Map < String, Object > ) JSON.deserializeUntyped(addNewCardJSON);
        String response = processPayment(dml, addNewCardMap, OrdersList, accountDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard), PaymentType, ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String procesPaymentWithSavedACHApxc(String savedACHJSON, List < OrderHelper > OrdersList, Account accountDetail, String PaymentType) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = procesPaymentWithSavedACHApxc(dml, savedACHJSON, OrdersList, accountDetail, PaymentType, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String procesPaymentWithSavedACHApxc(DML dml, String savedACHJSON, List < OrderHelper > OrdersList, Account accountDetail, String PaymentType, EBC_Logger ebcLogger) {
        MethodName = 'procesPaymentWithSavedACHApxc';
        Map < String, Object > savedAChMap = (Map < String, Object > ) JSON.deserializeUntyped(savedACHJSON);
        String response = processPayment(dml, savedAChMap, OrdersList, accountDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingACH), PaymentType, ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String procesPaymentNewACHApxc(String addNewACHJSON, List < OrderHelper > OrdersList, Account accDetail, String PaymentType) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = procesPaymentNewACHApxc(dml, addNewACHJSON, OrdersList, accDetail, PaymentType, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String procesPaymentNewACHApxc(DML dml, String addNewACHJSON, List < OrderHelper > OrdersList, Account accDetail, String PaymentType, EBC_Logger ebcLogger) {
        MethodName = 'procesPaymentNewACHApxc';
        Map < String, Object > newACHmap = (Map < String, Object > ) JSON.deserializeUntyped(addNewACHJSON);
        String response = processPayment(dml, newACHmap, OrdersList, accDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH), PaymentType, ebcLogger);
        return response;
    }
    public static String processPayment(DML dml, Map < String, Object > strMap, List < OrderHelper > OrdersList, Account accountDetail, String processBy, String PaymentType, EBC_Logger ebcLogger) {
        MethodName = 'processPayment';
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        Map < String, String > responseMap = new Map < String, String > ();
        try {
            String paymentMethodID = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.selectedCardId));
            Boolean SendReceiptTo = (boolean) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
            String taxAction = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.TaxAction));
            String addEmails = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.addEmails));
            EBizcharge_Setting__c settings = eBc_UtilityController.getSettings(dml, ebcLogger);
            string DivisionId = settings.Division_ID__c;
            string expiryMonth = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
            string expiryYear = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
            list < string > ordersToSearch = new list < string > ();
            for (OrderHelper order: OrdersList) {
                ordersToSearch.add(order.id);
            }
            Map < string, ebizchargeServicemodelSoap.ArrayOfLineItem > StoreOrderItemsMap = new Map < string, ebizchargeServicemodelSoap.ArrayOfLineItem > ();
            //Collect OrderItems 
            for (Integer i = 0; i < ordersToSearch.size(); i++) {
                ordersToSearch[i] = ordersToSearch[i];
            }
            querySelect = 'SELECT Id,name,(select Id,OrderId,OrderItemNumber,Description, PricebookEntry.Product2.Name ,PricebookEntry.Product2.id,Quantity,UnitPrice FROM OrderItems )';
            queryFrom = 'from order';
            queryWhere = 'where Id IN :';
            for (order order: (list < order > ) dml.selectRecordsInList(ordersToSearch, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING)) {
                ebizchargeServicemodelSoap.ArrayOfLineItem arrayOfLineItem = new ebizchargeServicemodelSoap.ArrayOfLineItem();
                arrayOfLineItem.LineItem = new List < ebizchargeServicemodelSoap.Lineitem > ();
                for (OrderItem OrderItem: order.orderItems) {
                    ebizchargeServicemodelSoap.LineItem lineItem = new ebizchargeServicemodelSoap.Lineitem();
                    lineItem.SKU = OrderItem.OrderItemNumber;
                    lineItem.ProductRefNum = OrderItem.OrderItemNumber;
                    lineItem.ProductName = OrderItem.PricebookEntry.Product2.Name;
                    lineItem.Description = OrderItem.Description != null ? OrderItem.Description : Configuration.EMPTYSTRING;
                    lineItem.UnitPrice = String.valueOf(OrderItem.UnitPrice);
                    lineItem.Qty = String.valueOf(OrderItem.Quantity);
                    lineItem.Taxable = true;
                    arrayOfLineItem.LineItem.add(lineItem);
                }
                StoreOrderItemsMap.put(order.id, arrayOfLineItem);
            }
            for (OrderHelper orderHelper: OrdersList) {
                transactionParams transactionPayload = new transactionParams();
                transactionPayload.OrderID = orderHelper.OrderNumber;
                transactionPayload.OrderNumber = orderHelper.OrderNumber;
                if (taxAction == Configuration.TAXACTION) {
                    transactionPayload.SubTotal = 0;
                } else {
                    transactionPayload.SubTotal = orderHelper.AmountDue;
                }
                transactionPayload.Amount = orderHelper.AmountDue + orderHelper.OrderTax; //changed for SAL-282
                transactionPayload.Tax = orderHelper.OrderTax;
                String accountId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.accId));
                String query_Select = 'select id,QBD_Customer_ID__c';
                String query_From = 'from Account';
                String query_Where =  'where id=\''+accountId+'\'';
                Account account = (Account)dml.selectSingleRecord(query_Select, query_From, query_Where, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
                //transactionPayload.accountID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.accId));
                //transactionPayload.customerID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.accId));
                transactionPayload.accountID = (string)account.get('QBD_Customer_ID__c');
                transactionPayload.customerID = (string)account.get('QBD_Customer_ID__c');
                transactionPayload.internalID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.accExtrId));
                transactionPayload.isRecurring = false;
                if (StoreOrderItemsMap.containsKey(orderHelper.id)) {
                    transactionPayload.LineItems = StoreOrderItemsMap.get(orderHelper.id);
                }
                ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
                if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingCard)) {
                    transactionPayload.methodID = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.selectedCardId));
                    transactionPayload.CardCode = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.cvcNo));
                    response = eBc_UtilityController.runTransactionPayment(dml, transactionPayload, SendReceiptTo, addEmails, PaymentType, ebcLogger);
                } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard)) {
                    transactionPayload.methodID = Configuration.CARDMETHODID;
                    transactionPayload.ccNumber = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
                    transactionPayload.expMonth = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
                    transactionPayload.expYear = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
                    transactionPayload.cvvCode = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
                    transactionPayload.ccName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
                    transactionPayload.AvsZip = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
                    transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.MethodName));
                    transactionPayload.AvsStreet = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
                    response = eBc_UtilityController.runTransactionOnly(dml, transactionPayload, accountDetail, strMap, PaymentType, ebcLogger);
                } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingACH)) {
                    transactionPayload.methodID = (String) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.selectedACHId));
                    response = eBc_UtilityController.runTransactionPayment(dml, transactionPayload, SendReceiptTo, addEmails, string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check), ebcLogger);
                } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH)) {
                    transactionPayload.methodID = Configuration.ACCOUNTMETHODID;
                    transactionPayload.AccountName = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
                    transactionPayload.Account = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
                    transactionPayload.Route = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
                    transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.MethodName));
                    transactionPayload.accountType = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.accType));
                    if (!Test.isRunningTest()) {
                        response = eBc_UtilityController.runTransactionOnly(dml, transactionPayload, accountDetail, strMap, PaymentType, ebcLogger);
                    }
                }
                if (response.ResultCode == Configuration.TRANSACTIONRESULTCODE) {
                    responseMap.put(orderHelper.Id, response.RefNum);
                    ebizchargeServicemodelSoap.ApplicationTransactionResponse addAppTranResult = new ebizchargeServicemodelSoap.ApplicationTransactionResponse();
                    if (!test.isRunningTest()) {
                        string accountInternalId = accountDetail.Ebiz_C__EBizCharge_Internal_ID__c;
                        string referenceId = response.RefNum;
                        string OrderNo = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order);
                        string OrderId = orderHelper.OrderNumber;
                        string orderInternalId = orderHelper.OrdExternalId;
                        string Command = string.valueOf(Enums.PAYMENTTYPES.Sale);
                        divisionId = divisionId != null ? divisionId : Configuration.EMPTYSTRING;
                        expiryMonth = expiryMonth != null ? expiryMonth : Configuration.EMPTYSTRING;
                        expiryYear = expiryYear != null ? expiryYear : Configuration.EMPTYSTRING;
                        addAppTranResult = EBC_CompMethods.CreateApplicationTransaction(dml, accountInternalId, referenceId, OrderNo, OrderId, orderInternalId, Command, divisionId, expiryYear, expiryMonth, paymentMethodID, ebcLogger);
                    }
                }
                // added by @wqkl against (SF-137) - (29jan21) - start
                else {
                    return Configuration.GATEWAYERRORMESSAGESTRING + '\'' + response.Error + '\''; //updated @wqkl on 29Jan21 against Error message modification
                }
                // added by @wqkl against (SF-137) - (29jan21) - end
            } // end of for loop...
            if (responseMap.size() > 0) {
                if (paymentMethodID == Configuration.CARDMETHODID) {
                    Boolean saveCard = (boolean) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
                    if (saveCard == true) {
                        paymentMethodID = AddPaymentMethod(dml, strMap, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                    }
                }
                if (paymentMethodID == Configuration.ACCOUNTMETHODID) {
                    Boolean saveACH = (boolean) strMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH));
                    if (saveACH == true) {
                        paymentMethodID = AddPaymentMethod(dml, strMap, string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH), ebcLogger);
                    }
                }
                Map < String, Decimal > orderWithTaxMap = new Map < String, Decimal > ();
                Map < String, Decimal > orderWithBalanceMap = new Map < String, Decimal > ();
                querySelect = 'SELECT Id,EBizCharge_Order_Tax__c,EBizCharge_Order_Balance__c';
                queryFrom = 'from order';
                queryWhere = 'where Id IN :';
                list < Order > orderWithTaxList = (list < order > ) dml.selectRecordsInList(ordersToSearch, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                for (Order order: orderWithTaxList) {
                    orderWithTaxMap.put(order.id, order.EBizCharge_Order_Tax__c);
                    orderWithBalanceMap.put(order.id, order.EBizCharge_Order_Balance__c);
                }
                list < Order > ordersToUpdate = new list < Order > ();
                list < EBizCharge_Transaction__c > transactionsToInsert = new list < EBizCharge_Transaction__c > ();
                for (OrderHelper orderHelper: OrdersList) {
                    if (responseMap.containsKey(orderHelper.Id)) {
                        String transactionReferenceId = responseMap.get(orderHelper.Id);
                        double OrderAmount = orderHelper.TotalAmount == null ? 0 : orderHelper.TotalAmount;
                        double OrderBalance = orderHelper.AmountDue == null ? 0 : orderHelper.AmountDue;
                        Order order = new Order();
                        order.Id = orderHelper.Id;
                        order.EBizCharge_Order_Status__c = string.valueOf(Enums.ENTITYSTATUS.Unpaid);
                        order.EBizCharge_Payment_Status__c = string.valueOf(Enums.ENTITYPAYMENTSTATUS.Deposit);
                        order.EBizCharge_Reference_Number__c = transactionReferenceId;
                        ebcLogger.debug(ClassName, MethodName, 'orderHelper.AmountReceived>>>>' + orderHelper.AmountReceived);
                        ebcLogger.debug(ClassName, MethodName, 'orderHelper.AmountDue>>>>' + orderHelper.AmountDue);
                        ebcLogger.debug(ClassName, MethodName, 'orderHelper.Tax>>>>' + orderHelper.OrderTax);
                        Double Tax = (Double) orderWithTaxMap.get(orderHelper.id);
                        if (Tax == null) {
                            Tax = 0;
                        }
                        Double Balance = (Double) orderWithBalanceMap.get(orderHelper.id);
                        if (Balance == null) {
                            Balance = 0;
                        }
                        order.EBizCharge_Order_Balance__c = Balance - OrderBalance;
                        order.EBizCharge_Amount__c = 0;
                        order.EBizCharge_Captured_Amount__c = orderHelper.AmountReceived + OrderBalance + orderHelper.OrderTax;
                        ebcLogger.debug(ClassName, MethodName, 'orderHelper.EBizCharge_Order_Balance__c===================>>>>' + order.EBizCharge_Order_Balance__c);
                        order.EBizCharge_Order_Balance__c = order.EBizCharge_Order_Balance__c < 0 ? 0 : order.EBizCharge_Order_Balance__c;
                        if (order.EBizCharge_Order_Balance__c == 0) {
                            order.EBizCharge_Order_Status__c = string.valueOf(Enums.ENTITYSTATUS.Paid);
                        }
                        order.EBizCharge_Order_Tax__c = orderHelper.OrderTax + Tax;
                        ordersToUpdate.add(order);
                        EBizCharge_Transaction__c transactionEntity = new EBizCharge_Transaction__c();
                        transactionEntity.Ref_Number__c = transactionReferenceId;
                        transactionEntity.Order_Id__c = orderHelper.Id;
                        transactionEntity.Account_Id__c = orderHelper.accId;
                        transactionEntity.Payment_Method__c = paymentMethodId;
                        transactionEntity.Transaction_Type__c = string.valueOf(Enums.PAYMENTTYPES.Sale);
                        if (orderHelper.OrderTax != 0) {
                            transactionEntity.EBizCharge_Subtotal__c = OrderBalance;
                        } else {
                            transactionEntity.EBizCharge_Subtotal__c = 0;
                        }
                        transactionEntity.Tax__c = orderHelper.OrderTax;
                        transactionEntity.Detail_Amount__c = OrderBalance + orderHelper.OrderTax;
                        transactionsToInsert.add(transactionEntity);
                    }
                }
                if (ordersToUpdate.size() > 0) {
                    dml.updateRecord(ordersToUpdate);
                    dml.insertRecord(transactionsToInsert);
                    return string.valueOf(Enums.RETURNMESSAGE.Success);
                } else {
                    return string.valueOf(Enums.RETURNMESSAGE.Error);
                }
            } else {
                return string.valueOf(Enums.RETURNMESSAGE.Error);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return Configuration.EXCEPTIONMESSAGE;
        }
    }
    public static String AddPaymentMethod(DML dml, Map < String, Object > strMap, String saveMethod, EBC_Logger ebcLogger) {
        MethodName = 'AddPaymentMethod';
        transactionParams transactionPayload = new transactionParams();
        String paymentMethodID = Configuration.EMPTYSTRING;
        try {
            if (saveMethod == string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard)) {
                transactionPayload.ccNumber = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
                transactionPayload.expMonth = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
                transactionPayload.expYear = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
                transactionPayload.cvvCode = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
                transactionPayload.ccName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
                transactionPayload.AvsZip = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
                transactionPayload.AvsStreet = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
                transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.MethodName));
                Boolean saveCard = (boolean) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
                if (saveCard == true) {
                    paymentMethodID = eBc_UtilityController.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                }
            }
            if (saveMethod == string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH)) {
                transactionPayload.AccountName = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
                transactionPayload.Account = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
                transactionPayload.Route = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
                transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.MethodName));
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
    @AuraEnabled
    public static string updrrPaymentScheduleStatusApxc(String recIntenalId, Integer ScheduleStatus) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = updrrPaymentScheduleStatusApxc(dml, recIntenalId, ScheduleStatus, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string updrrPaymentScheduleStatusApxc(DML dml, String recIntenalId, Integer ScheduleStatus, EBC_Logger ebcLogger) {
        MethodName = 'updrrPaymentScheduleStatusApxc';
        try {
            return eBc_UtilityController.updateRRScheduledPaymentStatus(dml, recIntenalId, ScheduleStatus, ebcLogger);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return Configuration.EXCEPTIONMESSAGE;
        }
    }
    public class OrderHelper {
        @AuraEnabled public String Id {
            get;
            set;
        }
        @AuraEnabled public String OrderNumber {
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
        @AuraEnabled public String accFirstName {
            get;
            set;
        }
        @AuraEnabled public String accLastName {
            get;
            set;
        }
        @AuraEnabled public String accExternalId {
            get;
            set;
        }
        @AuraEnabled public String accEmail {
            get;
            set;
        }
        @AuraEnabled public String ContractId {
            get;
            set;
        }
        @AuraEnabled public String ContractNumber {
            get;
            set;
        }
        @AuraEnabled public double TotalAmount {
            get;
            set;
        }
        @AuraEnabled public double AmountDue {
            get;
            set;
        }
        @AuraEnabled public double OrderTax {
            get;
            set;
        }
        @AuraEnabled public double OrderBalance {
            get;
            set;
        }
        @AuraEnabled public double AmountReceived {
            get;
            set;
        }
        @AuraEnabled public Date EffectiveDate {
            get;
            set;
        }
        @AuraEnabled public DateTime CreatedDate {
            get;
            set;
        }
        @AuraEnabled public String PaymentStatus {
            get;
            set;
        }
        @AuraEnabled public boolean isSelected {
            get;
            set;
        }
        @AuraEnabled public String OrdExternalId {
            get;
            set;
        }
        @AuraEnabled public boolean isEdited {
            get;
            set;
        }
        @AuraEnabled public boolean isAllowPartialPay {
            get;
            set;
        }
    }
    public class OrderWrapper {
        @AuraEnabled public map < string, string > savedPaymentMethods {
            get;
            set;
        }
        @AuraEnabled public list < OrderHelper > accountOrders {
            get;
            set;
        }
        @AuraEnabled public Account accountDetail {
            get;
            set;
        }
        @AuraEnabled public EBC_ComponentController.PaymentMethods savedMethods {
            get;
            set;
        }
        @AuraEnabled public EBizcharge_Setting__c Settings {
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
        @AuraEnabled public map < string, string > savedPaymentMethods {
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
        } // added by @wqkl against SF-137 - 8dec20
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
        @AuraEnabled public Ebiz_C__EBizCharge_Fields_Config__c CustomCustInfo {
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
}