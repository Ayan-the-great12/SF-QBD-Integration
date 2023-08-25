public with sharing class EBC_CompMethods {
    public static string ClassName = 'EBC_CompMethods';
    public static string MethodName = Configuration.EMPTYSTRING;
    public enum salesOrderType {
        Opportunity,
        Order,
        Quote
    }
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    public static ebizchargeServicemodelSoap.Customer invoke_SearchCustomer(DML dml, String CustomerId, EBC_Logger ebcLogger) {
        MethodName = 'invoke_SearchCustomer';
        ebizchargeServicemodelSoap.Customer response = new ebizchargeServicemodelSoap.Customer();
        try {
            response = ebiz.GetCustomer(getSecurityToken(dml, ebcLogger), CustomerId, Configuration.EMPTYSTRING);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            ebcLogger.debug(ClassName, MethodName, '>>Error has been occured in GetCustomer: ');
        }
        return response;
    }
    public static ebizchargeServicemodelSoap.CustomerResponse invoke_addCustomer(DML dml, Account account, EBC_Logger ebcLogger) {
        MethodName = 'invoke_addCustomer';
        ebizchargeServicemodelSoap.Customer ebizCustomer = new ebizchargeServicemodelSoap.Customer();
        ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = new ebizchargeServicemodelSoap.CustomerResponse();
        ebizCustomer.CustomerId  = (String)account.get('QBD_Customer_ID__c');//For SF-QBD
        ebizCustomer.FirstName = account.First_Name__c;
        ebizCustomer.LastName = account.Last_Name__c;
         ebizCustomer.Email       = (String)account.get('Email__c');//For SF-QBD
        ebizCustomer.CompanyName = account.Name;
        ebizCustomer.Phone = account.Phone;
        ebizCustomer.Fax = account.Fax;
        ebizCustomer.WebSite = account.Website;
        ebizchargeServicemodelSoap.Address billingAddress = new ebizchargeServicemodelSoap.Address();
        billingAddress.FirstName = account.First_Name__c;
        billingAddress.LastName = account.Last_Name__c;
        billingAddress.CompanyName = account.Name;
        billingAddress.Address1 = account.BillingStreet;
        billingAddress.Address2 = Configuration.EMPTYSTRING;
        billingAddress.City = account.BillingCity;
        billingAddress.State = account.BillingState;
        billingAddress.ZipCode = account.BillingPostalCode;
        billingAddress.Country = account.BillingCountry;
        ebizCustomer.BillingAddress = billingAddress;
        EBizcharge_Setting__c ebizchargeSettings = eBc_UtilityController.getSettings(dml, ebcLogger);
        //  Mockdata     
        if (test.isRunningTest()) {
            ebizchargeSettings.Division_ID__c = '1111111111';
        } //  Mockdata End
        if (ebizchargeSettings.Division_ID__c != null) {
            ebizCustomer.DivisionId = ebizchargeSettings.Division_ID__c;
        }
        ebizchargeServicemodelSoap.Address shippingAddress = new ebizchargeServicemodelSoap.Address();
        shippingAddress.FirstName = account.First_Name__c;
        shippingAddress.LastName = account.Last_Name__c;
        shippingAddress.CompanyName = account.Name;
        shippingAddress.Address1 = account.ShippingStreet;
        shippingAddress.Address2 = Configuration.EMPTYSTRING;
        shippingAddress.City = account.ShippingCity;
        shippingAddress.State = account.ShippingState;
        shippingAddress.ZipCode = account.ShippingPostalCode;
        shippingAddress.Country = account.ShippingCountry;
        ebizCustomer.ShippingAddress = shippingAddress;
        try {
            addCustomerResponse = ebiz.addCustomer(getSecurityToken(dml, ebcLogger), ebizCustomer);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return addCustomerResponse;
    }
    public static ebizchargeServicemodelSoap.CustomerResponse invoke_addCustomerContact(DML dml, Contact contact, EBC_Logger ebcLogger) {
        MethodName = 'invoke_addCustomerContact';
        ebizchargeServicemodelSoap.Customer ebizCustomer = new ebizchargeServicemodelSoap.Customer();
        ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = new ebizchargeServicemodelSoap.CustomerResponse();
        ebizCustomer.CustomerId = contact.id;
        ebizCustomer.FirstName = contact.FirstName;
        ebizCustomer.LastName = contact.LastName;
        ebizCustomer.Email = contact.Email;
        ebizCustomer.CompanyName = contact.Name;
        ebizCustomer.Phone = contact.Phone;
        ebizCustomer.Fax = contact.Fax;
        ebizCustomer.WebSite = Configuration.EMPTYSTRING;
        ebizchargeServicemodelSoap.Address billingAddress = new ebizchargeServicemodelSoap.Address();
        billingAddress.FirstName = contact.FirstName;
        billingAddress.LastName = contact.LastName;
        billingAddress.CompanyName = contact.Name;
        billingAddress.Address1 = contact.OtherStreet;
        billingAddress.Address2 = Configuration.EMPTYSTRING;
        billingAddress.City = contact.OtherCity;
        billingAddress.State = contact.OtherState;
        billingAddress.ZipCode = contact.OtherPostalCode;
        billingAddress.Country = contact.OtherCountry;
        ebizCustomer.BillingAddress = billingAddress;
        EBizcharge_Setting__c ebizchargeSettings = eBc_UtilityController.getSettings(dml, ebcLogger);
        //  Mockdata 
        if (test.isRunningTest()) {
            ebizchargeSettings.Division_ID__c = '1111111111';
        } //  Mockdata End
        if (ebizchargeSettings.Division_ID__c != null) {
            ebizCustomer.DivisionId = ebizchargeSettings.Division_ID__c;
        }
        ebizchargeServicemodelSoap.Address shippingAddress = new ebizchargeServicemodelSoap.Address();
        shippingAddress.FirstName = contact.FirstName;
        shippingAddress.LastName = contact.LastName;
        shippingAddress.CompanyName = contact.Name;
        shippingAddress.Address1 = contact.MailingStreet;
        shippingAddress.Address2 = Configuration.EMPTYSTRING;
        shippingAddress.City = contact.MailingCity;
        shippingAddress.State = contact.MailingState;
        shippingAddress.ZipCode = contact.MailingPostalCode;
        shippingAddress.Country = contact.MailingCountry;
        ebizCustomer.ShippingAddress = shippingAddress;
        try {
            addCustomerResponse = ebiz.addCustomer(getSecurityToken(dml, ebcLogger), ebizCustomer);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return addCustomerResponse;
    }
    public static ebizchargeServicemodelSoap.CustomerResponse invoke_addCustomCustomer(DML dml, Ebiz_C__EBizCharge_Fields_Config__c ebizConfig, EBC_Logger ebcLogger) {
        MethodName = 'invoke_addCustomCustomer';
        ebizchargeServicemodelSoap.Customer ebizCustomer = new ebizchargeServicemodelSoap.Customer();
        ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = new ebizchargeServicemodelSoap.CustomerResponse();
        ebizCustomer.CustomerId = ebizConfig.Ebiz_C__EBizCharge_CustomerId__c;
        ebizCustomer.FirstName = ebizConfig.Name;
        ebizCustomer.LastName = Configuration.EMPTYSTRING;
        ebizCustomer.Email = ebizConfig.Ebiz_C__EBizCharge_Email__c;
        ebizCustomer.CompanyName = ebizConfig.Name;
        ebizCustomer.Phone = Configuration.EMPTYSTRING;
        ebizCustomer.Fax = Configuration.EMPTYSTRING;
        ebizCustomer.WebSite = Configuration.EMPTYSTRING;
        EBizcharge_Setting__c ebizchargeSettings = eBc_UtilityController.getSettings(dml, ebcLogger);
        if (test.isRunningTest()) { //  Mockdata 
            ebizchargeSettings.Division_ID__c = '1111111111111';
        } //  Mockdata End
        if (ebizchargeSettings.Division_ID__c != null) {
            ebizCustomer.DivisionId = ebizchargeSettings.Division_ID__c;
        }
        ebizchargeServicemodelSoap.Address billingAddress = new ebizchargeServicemodelSoap.Address();
        billingAddress.FirstName = ebizConfig.Name;
        billingAddress.LastName = Configuration.EMPTYSTRING;
        billingAddress.CompanyName = ebizConfig.Name;
        billingAddress.Address1 = Configuration.EMPTYSTRING;
        billingAddress.Address2 = Configuration.EMPTYSTRING;
        billingAddress.City = Configuration.EMPTYSTRING;
        billingAddress.State = Configuration.EMPTYSTRING;
        billingAddress.ZipCode = Configuration.EMPTYSTRING;
        billingAddress.Country = Configuration.EMPTYSTRING;
        ebizchargeServicemodelSoap.Address shippingAddress = new ebizchargeServicemodelSoap.Address();
        try {
            addCustomerResponse = ebiz.addCustomer(getSecurityToken(dml, ebcLogger), ebizCustomer);
            ebcLogger.debug(ClassName, MethodName, 'subtotal in process payment is' + 'addCustomerResponse>>>>>>>>>>>>>>>>>>>>>>>>' + addCustomerResponse);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return addCustomerResponse;
    }
    public static ebizchargeServicemodelSoap.SalesOrder invoke_SearchOrder(DML dml, String CustomerId, String SalesOrderNo, EBC_Logger ebcLogger) {
        MethodName = 'invoke_SearchOrder';
        ebizchargeServicemodelSoap.SalesOrder ebizResponse = new ebizchargeServicemodelSoap.SalesOrder();
        try {
            ebizResponse = ebiz.GetSalesOrder(getSecurityToken(dml, ebcLogger), CustomerId, Configuration.EMPTYSTRING, SalesOrderNo, Configuration.EMPTYSTRING);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return ebizResponse;
    }
    public static ebizchargeServicemodelSoap.SalesOrderResponse invoke_addSaleOrder(DML dml, Order order, EBC_Logger ebcLogger) {
        MethodName = 'invoke_addSaleOrder';
        ebizchargeServicemodelSoap.SalesOrder ebizSalesOrder = new ebizchargeServicemodelSoap.SalesOrder();
        ebizchargeServicemodelSoap.SalesOrderResponse saleorderResponse = new ebizchargeServicemodelSoap.SalesOrderResponse();
        try {
        String querySelect = 'select id,QBD_Customer_ID__c';
        String queryFrom = 'from Account';
        String queryWhere =  'where id=\''+order.AccountId+'\'';
        Account account = (Account)dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
            //ebizSalesOrder.CustomerId = order.AccountId;
            ebizSalesOrder.CustomerId = (string)account.get('QBD_Customer_ID__c');//For SF-QBD
            ebizSalesOrder.SalesOrderNumber = order.OrderNumber;
            ebizSalesOrder.Amount = order.TotalAmount;
            ebizSalesOrder.PoNum = order.PoNumber;
            ebizSalesOrder.Software = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            ebizSalesOrder.TypeId = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order);
            EBizcharge_Setting__c ebizchargeSettings = eBc_UtilityController.getSettings(dml, ebcLogger);
            //  Mockdata
            if (test.isRunningTest()) {
                ebizchargeSettings.Division_ID__c = '1111111111111';
            } //  Mockdata End
            if (ebizchargeSettings.Division_ID__c != null) {
                ebizSalesOrder.DivisionId = ebizchargeSettings.Division_ID__c;
            }
            saleorderResponse = ebiz.AddSalesOrder(getSecurityToken(dml, ebcLogger), ebizSalesOrder);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return saleorderResponse;
    }
    public static ebizchargeServicemodelSoap.SalesOrderResponse invoke_addQuote(DML dml, Quote quote, EBC_Logger ebcLogger) {
        MethodName = 'invoke_addQuote';
        ebizchargeServicemodelSoap.SalesOrder ebizSalesOrder = new ebizchargeServicemodelSoap.SalesOrder();
        String quoteId = (String) quote.Id;
        String querySelect = 'select id,QBD_Customer_ID__c';
        String queryFrom = 'from Account';
        String queryWhere =  'where id=\''+quote.AccountId+'\'';
        Account account = (Account)dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
        //ebizSalesOrder.CustomerId = quote.AccountId;
        ebizSalesOrder.CustomerId = (String)account.get('QBD_Customer_ID__c');//For SF-QBD
        ebizSalesOrder.SalesOrderNumber = quote.QuoteNumber;
        ebizSalesOrder.Amount = quote.Ebiz_C__EBizCharge_Amount__c;
        ebizSalesOrder.PoNum = quote.EBizCharge_PONumber__c;
        ebizSalesOrder.Software = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
        ebizSalesOrder.TypeId = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote);
        EBizcharge_Setting__c ebizchargeSettings = eBc_UtilityController.getSettings(dml, ebcLogger);
        //  Mockdata 
        if (test.isRunningTest()) {
            ebizchargeSettings.Division_ID__c = '1111111111111';
        } //  Mockdata End
        if (ebizchargeSettings.Division_ID__c != null) {
            ebizSalesOrder.DivisionId = ebizchargeSettings.Division_ID__c;
        }
        ebizchargeServicemodelSoap.SalesOrderResponse quoteResponse = new ebizchargeServicemodelSoap.SalesOrderResponse();
        try {
            List < QuoteLineItem > quotLineItem = LineItems.getQuoteLineItemsDetail(dml, quoteId, ebcLogger);
            ebcLogger.debug(ClassName, MethodName, '>>>quotLineItem: ' + quotLineItem);
            if (quotLineItem != null) {
                ebizchargeServicemodelSoap.ArrayOfCustomItem customItems = new ebizchargeServicemodelSoap.ArrayOfCustomItem();
                ebizchargeServicemodelSoap.CustomItem[] ebizItems = new List < ebizchargeServicemodelSoap.CustomItem > ();
                for (QuoteLineItem quotItem: quotLineItem) {
                    ebizchargeServicemodelSoap.CustomItem ebizCustomItem = new ebizchargeServicemodelSoap.CustomItem();
                    ebcLogger.debug(ClassName, MethodName, '>>>quoteItem.Product2Id: ' + quotItem.Product2Id);
                    if (quotItem.Product2Id != null) {
                        ebizCustomItem.ItemInternalId = quotItem.Product2Id;
                        ebizCustomItem.ItemId = quotItem.Product2Id;
                        ebizCustomItem.Name = quotItem.product2.Name;
                        ebizCustomItem.UnitPrice = quotItem.UnitPrice;
                        ebizCustomItem.Qty = quotItem.Quantity;
                        ebizCustomItem.Taxable = false;
                        ebizCustomItem.Description = ((quotItem.product2.Description != null) ? quotItem.product2.Description : Configuration.EMPTYSTRING);
                        ebizchargeServicemodelSoap.ArrayOfEbizCustomField customFields = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
                        list < ebizchargeServicemodelSoap.EbizCustomField > ebizCustomFields = new list < ebizchargeServicemodelSoap.EbizCustomField > ();
                        ebizchargeServicemodelSoap.EbizCustomField itemIdField = new ebizchargeServicemodelSoap.EbizCustomField();
                        itemIdField.FieldName = string.valueOf(Enums.FIELDNAMES.Id);
                        itemIdField.FieldValue = quotItem.Id;
                        ebizCustomFields.add(itemIdField);
                        customFields.EbizCustomField = ebizCustomFields;
                        ebizCustomItem.ItemCustomFields = customFields;
                        ebizItems.add(ebizCustomItem);
                    }
                }
                customItems.Item = ebizItems;
                ebcLogger.debug(ClassName, MethodName, '>>>quoteItem items list: ' + ebizItems);
                ebizSalesOrder.Items = customItems;
            }
            quoteResponse = ebiz.AddSalesOrder(getSecurityToken(dml, ebcLogger), ebizSalesOrder);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return quoteResponse;
    }
    public static ebizchargeServicemodelSoap.SalesOrderResponse invoke_addOpportunity(DML dml, Opportunity opportunity, EBC_Logger ebcLogger) {
        MethodName = 'invoke_addOpportunity';
        ebizchargeServicemodelSoap.SalesOrder ebizSalesOrder = new ebizchargeServicemodelSoap.SalesOrder();
          String querySelect = 'select id,QBD_Customer_ID__c';
        String queryFrom = 'from Account';
        String queryWhere =  'where id=\''+opportunity.AccountId+'\'';
        Account account = (Account)dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
        //ebizSalesOrder.CustomerId = opportunity.AccountId;
        ebizSalesOrder.CustomerId =  (String)account.get('QBD_Customer_ID__c');//For SF-QBD
        ebizSalesOrder.SalesOrderNumber = opportunity.id;
        ebizSalesOrder.Amount = opportunity.Amount;
        ebizSalesOrder.PoNum = opportunity.EBizCharge_PONumber__c;
        ebizSalesOrder.Software = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
        ebizSalesOrder.TypeId = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity);
        EBizcharge_Setting__c ebizchargeSettings = eBc_UtilityController.getSettings(dml, ebcLogger);
        //  Mockdata
        if (test.isRunningTest()) {
            ebizchargeSettings.Division_ID__c = '1111111111111';
        } //  Mockdata End
        if (ebizchargeSettings.Division_ID__c != null) {
            ebizSalesOrder.DivisionId = ebizchargeSettings.Division_ID__c;
        }
        ebizchargeServicemodelSoap.SalesOrderResponse opportunityResponse = new ebizchargeServicemodelSoap.SalesOrderResponse();
        try {
            opportunityResponse = ebiz.AddSalesOrder(getSecurityToken(dml, ebcLogger), ebizSalesOrder);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return opportunityResponse;
    }
    public static list < ebizchargeServicemodelSoap.PaymentMethodProfile > GetCustomerPaymentMethods(DML dml, String accountID, String internalID, EBC_Logger ebcLogger) {
        MethodName = 'GetCustomerPaymentMethods';
        list < ebizchargeServicemodelSoap.PaymentMethodProfile > paymentMethodProfiles = new list < ebizchargeServicemodelSoap.PaymentMethodProfile > ();
        try {
            string customerToken = getCustomerToken(dml, accountID, internalID, ebcLogger);
            ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile paymentMethodProfile = new ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile();
            paymentMethodProfile = ebiz.GetCustomerPaymentMethodProfiles(getSecurityToken(dml, ebcLogger), customerToken);
            paymentMethodProfiles = paymentMethodProfile.PaymentMethodProfile;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return paymentMethodProfiles;
    }
    public static map < string, string > GetCustomerSavedPaymentMethods(DML dml, String accountID, String internalID, EBC_Logger ebcLogger) {
        MethodName = 'GetCustomerSavedPaymentMethods';
        map < String, String > paymentMethods = new map < String, String > ();
        try {
            string customerToken = getCustomerToken(dml, accountID, internalID, ebcLogger);
            if (string.isBlank(customerToken)) {
                return paymentMethods;
            }
            ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile paymentMethodProfile = new ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile();
            ebizchargeServicemodelSoap.PaymentMethodProfile[] paymentMethodProfiles;
            if (!test.isRunningTest()) {
                paymentMethodProfile = ebiz.GetCustomerPaymentMethodProfiles(getSecurityToken(dml, ebcLogger), customerToken);
            }
            paymentMethodProfiles = paymentMethodProfile.PaymentMethodProfile;
            if (paymentMethodProfiles != null) {
                for (ebizchargeServicemodelSoap.PaymentMethodProfile paymentMethodProfle: paymentMethodProfiles) {
                    if (paymentMethodProfle.CardNumber == null) {
                        paymentMethods.put(paymentMethodProfle.MethodID + '@E', paymentMethodProfle.Routing + '^' + paymentMethodProfle.Account);
                    } else {
                        paymentMethods.put(paymentMethodProfle.MethodID + '@C', paymentMethodProfle.CardNumber + '^' + paymentMethodProfle.CardExpiration);
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return paymentMethods;
    }
    public static string runTransactionPayment(DML dml, transactionParams transactionPayload, Boolean sendRecptTo, String addEmails, string Command, EBC_Logger ebcLogger) {
        MethodName = 'runTransactionPayment';
        String transactionRefNo = Configuration.EMPTYSTRING;
        try {
            String paymentMethodID = Configuration.EMPTYSTRING;
            paymentMethodID = transactionPayload.methodID;
            String accountId = transactionPayload.accountID;
            string customerToken = getCustomerToken(dml, accountId, transactionPayload.internalID, ebcLogger);
            ebizchargeServicemodelSoap.CustomerTransactionRequest transactionRequest = new ebizchargeServicemodelSoap.CustomerTransactionRequest();
            transactionRequest.isRecurring = transactionPayload.isRecurring;
            transactionRequest.IgnoreDuplicate = true;
            transactionRequest.Software = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            transactionRequest.MerchReceipt = false;
            transactionRequest.CustReceipt = false;
            transactionRequest.CardCode = transactionPayload.CardCode;
            transactionRequest.Command = Command;
            transactionRequest.Details = getTransactionDetails(transactionPayload, ebcLogger);
            if (transactionPayload.LineItems != null) {
                transactionRequest.LineItems = transactionPayload.LineItems;
            }
            ebcLogger.debug(ClassName, MethodName, 'transaction data is:' + transactionRequest.Details);
            ebizchargeServicemodelSoap.TransactionResponse transactionResponse = new ebizchargeServicemodelSoap.TransactionResponse();
            transactionResponse = ebiz.runCustomerTransaction(getSecurityToken(dml, ebcLogger), customerToken, paymentMethodID, transactionRequest);
            //  Mockdata 
            if (test.isRunningTest()) {
                transactionResponse.ResultCode = 'A';
            } //  Mockdata End
            system.debug('Transaction Result code>>>:' + transactionResponse.ResultCode);//'A'
            system.debug('Add Emails>>>:' + addEmails);
            if (transactionResponse.ResultCode == Configuration.TRANSACTIONRESULTCODE) {
                transactionRefNo = transactionResponse.RefNum;
                if (sendRecptTo == true && (addEmails != null && addEmails != Configuration.EMPTYSTRING)) {
                    ebizchargeServicemodelSoap.EmailReceiptResponse emailReceiptResponse = new ebizchargeServicemodelSoap.EmailReceiptResponse();
                    emailReceiptResponse = ebiz.EmailReceipt(getSecurityToken(dml, ebcLogger), transactionRefNo, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, addEmails);
                    if (emailReceiptResponse.StatusCode == 1) {
                        ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent ');
                    } else {
                        ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent Error ');
                    }
                }
            } else {
                transactionRefNo = 'Error: ' + transactionResponse.Error;
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return transactionRefNo;
    }
    public static ebizchargeServicemodelSoap.TransactionResponse runTransactionOnly(DML dml, transactionParams transactionPayload, Account accountEntity, Map < String, Object > processPayment, EBC_Logger ebcLogger) {
        MethodName = 'runTransactionOnly';
        ebcLogger.debug(ClassName, MethodName, '>>>transactionPayload:' + transactionPayload);
        ebcLogger.debug(ClassName, MethodName, '>>>accountEntity:' + accountEntity);
        ebcLogger.debug(ClassName, MethodName, '>>>processPayment:' + processPayment);
        ebizchargeServicemodelSoap.TransactionRequestObject transactionRequest = new ebizchargeServicemodelSoap.TransactionRequestObject();
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        String saleCommand = Configuration.EMPTYSTRING;
        try {
            string paymentMethodID = transactionPayload.methodID;
            transactionRequest.CustomerID = transactionPayload.customerID;
            //  Mockdata 
            if (test.isRunningTest()) {
                paymentMethodID = '1';
            } //  Mockdata End
            if (paymentMethodID == Configuration.CARDMETHODID) {
                string paymentType = (string) processPayment.get((string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType)));
                if (paymentType == string.valueOf(Enums.PAYMENTTYPES.Deposit) || paymentType == string.valueOf(Enums.PAYMENTTYPES.Sale)) {
                    saleCommand = string.valueOf(Enums.PAYMENTTYPES.Sale);
                } else {
                    saleCommand = string.valueOf(Enums.PAYMENTTYPES.AuthOnly);
                }
                transactionRequest.AccountHolder = transactionPayload.ccName;
                transactionRequest.CreditCardData = getCardData(transactionPayload, ebcLogger);
                Boolean saveCard = (boolean) processPayment.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
                if (saveCard == true) {
                    paymentMethodID = addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                    transactionPayload.methodID = paymentMethodID;
                }
            }
            //  Mockdata 
            if (test.isRunningTest()) {
                paymentMethodID = '2';
            } //  Mockdata End
            if (paymentMethodID == Configuration.ACCOUNTMETHODID) {
                saleCommand = string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check);
                transactionRequest.AccountHolder = transactionPayload.AccountName;
                transactionRequest.CheckData = getCheckData(transactionPayload, ebcLogger);
                ebcLogger.debug(ClassName, MethodName, '>>>processPayment:' + (boolean) processPayment.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.saveACH)));
                Boolean saveACH = (boolean) processPayment.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.saveACH));
                if (saveACH == true) {
                    paymentMethodID = addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH), ebcLogger);
                    transactionPayload.methodID = paymentMethodID;
                }
            }
            Boolean sendRecptTo = (boolean) processPayment.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
            String addEmailsTo = (string) processPayment.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.addEmails));
            ebcLogger.debug(ClassName, MethodName, '>>>addEmailsTo:' + addEmailsTo);
            transactionRequest.BillingAddress = getBillingAddress(accountEntity, ebcLogger);
            transactionRequest.ShippingAddress = getShippingAddress(accountEntity, ebcLogger);
            transactionRequest.isRecurring = false;
            transactionRequest.IgnoreDuplicate = true;
            transactionRequest.Software = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            transactionRequest.CustReceipt = false; //sendReceiptTo; SAL-483
            transactionRequest.Command = saleCommand;
            transactionRequest.Details = getTransactionDetails(transactionPayload, ebcLogger);
            ebcLogger.debug(ClassName, MethodName, '>>>transactionRequest.Details:' + transactionRequest.Details);
            transactionRequest.LineItems = transactionPayload.LineItems;
            ebizchargeServicemodelSoap.SecurityToken securityToken = getSecurityToken(dml, ebcLogger);
            ebcLogger.debug(ClassName, MethodName, 'transactionRequest:' + transactionRequest);
            response = ebiz.runTransaction(securityToken, transactionRequest);
            String transactionRefNo = Configuration.EMPTYSTRING;
            if (response.ResultCode == Configuration.TRANSACTIONRESULTCODE) {
                transactionRefNo = response.RefNum + '@' + paymentMethodID;
                if (sendRecptTo == true && (addEmailsTo != null && addEmailsTo != Configuration.EMPTYSTRING)) {

                    ebizchargeServicemodelSoap.EmailReceiptResponse emailReceiptResponse = new ebizchargeServicemodelSoap.EmailReceiptResponse();
                    emailReceiptResponse = ebiz.EmailReceipt(securityToken, transactionRefNo.substringBefore('@'), Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, addEmailsTo);
                    if (emailReceiptResponse.StatusCode == 1) {
                        ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent');
                    } else {
                        ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent Error ');
                    }
                }
            } else {
                transactionRefNo = 'Error: ' + response.Error;
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return response;
    }
    public static ebizchargeServicemodelSoap.TransactionResponse runTransactionOnlyContact(DML dml, transactionParams transactionPayload, Contact contactEntity, Map < String, Object > processPayment, EBC_Logger ebcLogger) {
        MethodName = 'runTransactionOnlyContact';
        ebizchargeServicemodelSoap.TransactionRequestObject transactionRequest = new ebizchargeServicemodelSoap.TransactionRequestObject();
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        String saleCommand = Configuration.EMPTYSTRING;
        try {
            string paymentMethodID = transactionPayload.methodID;
            transactionRequest.CustomerID = transactionPayload.customerID;
            //  Mockdata 
            if (test.isRunningTest()) {
                paymentMethodID = '1';
            } //  Mockdata End
            if (paymentMethodID == Configuration.CARDMETHODID) {
                string paymentType = (string) processPayment.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType));
                if (paymentType == string.valueOf(Enums.PAYMENTTYPES.Deposit) || paymentType == string.valueOf(Enums.PAYMENTTYPES.Sale)) {
                    saleCommand = string.valueOf(Enums.PAYMENTTYPES.Sale);
                } else {
                    saleCommand = string.valueOf(Enums.PAYMENTTYPES.AuthOnly);
                }
                transactionRequest.AccountHolder = transactionPayload.ccName;
                transactionRequest.CreditCardData = getCardData(transactionPayload, ebcLogger);
                Boolean saveCard = (boolean) processPayment.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
                if (saveCard == true) {
                    paymentMethodID = addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                    transactionPayload.methodID = paymentMethodID;
                }
            }
            //  Mockdata
            if (test.isRunningTest()) {
                paymentMethodID = '2';
            } //  Mockdata End
            if (paymentMethodID == Configuration.ACCOUNTMETHODID) {
                saleCommand = string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check);
                transactionRequest.AccountHolder = transactionPayload.AccountName;
                transactionRequest.CheckData = getCheckData(transactionPayload, ebcLogger);
                Boolean saveACH = (boolean) processPayment.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.saveACH));
                if (saveACH == true) {
                    paymentMethodID = addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH), ebcLogger);
                    transactionPayload.methodID = paymentMethodID;
                }
            }
            Boolean sendRecptTo = (boolean) processPayment.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
            String addEmailsTo = (string) processPayment.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.addEmails));
            transactionRequest.BillingAddress = getBillingAddressContact(contactEntity, ebcLogger);
            transactionRequest.ShippingAddress = getShippingAddressContact(contactEntity, ebcLogger);
            transactionRequest.isRecurring = false;
            transactionRequest.IgnoreDuplicate = true;
            transactionRequest.Software = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            transactionRequest.CustReceipt = false;
            transactionRequest.Command = saleCommand;
            transactionRequest.Details = getTransactionDetails(transactionPayload, ebcLogger);
            transactionRequest.LineItems = transactionPayload.LineItems;
            ebizchargeServicemodelSoap.SecurityToken securityToken = getSecurityToken(dml, ebcLogger);
            response = ebiz.runTransaction(securityToken, transactionRequest);
            String transactionRefNo = Configuration.EMPTYSTRING;
            if (response.ResultCode == Configuration.TRANSACTIONRESULTCODE) {
                transactionRefNo = response.RefNum + '@' + paymentMethodID;
                //  Mockdata 
                if (test.isRunningTest()) {
                    contactEntity.Email = 'abc@cs.com';
                } //  Mockdata End  
                if (sendRecptTo == true && (addEmailsTo != null && addEmailsTo != Configuration.EMPTYSTRING)) {
                    ebizchargeServicemodelSoap.EmailReceiptResponse emailReceiptResponse = new ebizchargeServicemodelSoap.EmailReceiptResponse();
                    emailReceiptResponse = ebiz.EmailReceipt(securityToken, transactionRefNo.substringBefore('@'), Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, addEmailsTo);
                    if (emailReceiptResponse.StatusCode == 1) {
                        ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent ');
                    } else {
                        ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent Error ');
                    }
                }
            } else {
                transactionRefNo = 'Error: ' + response.Error;
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return response;
    }
    public static ebizchargeServicemodelSoap.TransactionResponse runTransactionOnlyCustomCustomer(DML dml, transactionParams transactionPayload, Ebiz_C__EBizCharge_Fields_Config__c customCustomerEntity, Map < String, Object > processPayment, EBC_Logger ebcLogger) {
        MethodName = 'runTransactionOnlyCustomCustomer';
        ebizchargeServicemodelSoap.TransactionRequestObject transactionRequest = new ebizchargeServicemodelSoap.TransactionRequestObject();
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        String saleCommand = Configuration.EMPTYSTRING;
        try {
            string paymentMethodID = transactionPayload.methodID;
            transactionRequest.CustomerID = transactionPayload.customerID;
            //  Mockdata 
            if (test.isRunningTest()) {
                paymentMethodID = '1';
            } //  Mockdata End
            if (paymentMethodID == Configuration.CARDMETHODID) {
                string paymentType = (string) processPayment.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType));
                ebcLogger.debug(ClassName, MethodName, '>>>paymentType:' + paymentType);
                if (paymentType == string.valueOf(Enums.PAYMENTTYPES.Deposit) || paymentType == string.valueOf(Enums.PAYMENTTYPES.Sale)) {
                    saleCommand = string.valueOf(Enums.PAYMENTTYPES.Sale);
                } else {
                    saleCommand = string.valueOf(Enums.PAYMENTTYPES.AuthOnly);
                }
                transactionRequest.AccountHolder = transactionPayload.ccName;
                transactionRequest.CreditCardData = getCardData(transactionPayload, ebcLogger);
                Boolean saveCard = (boolean) processPayment.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
                if (saveCard == true) {
                    paymentMethodID = addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                    transactionPayload.methodID = paymentMethodID;
                }
            }
            //  Mockdata 
            if (test.isRunningTest()) {
                paymentMethodID = '2';
            } //  Mockdata End
            if (paymentMethodID == Configuration.ACCOUNTMETHODID) {
                saleCommand = string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check);
                transactionRequest.AccountHolder = transactionPayload.AccountName;
                transactionRequest.CheckData = getCheckData(transactionPayload, ebcLogger);
                Boolean saveACH = (boolean) processPayment.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.saveACH));
                if (saveACH == true) {
                    paymentMethodID = addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH), ebcLogger);
                    transactionPayload.methodID = paymentMethodID;
                }
            }
            Boolean sendRecptTo = (boolean) processPayment.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
            String addEmailsTo = (string) processPayment.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.addEmails));
            transactionRequest.isRecurring = false;
            transactionRequest.IgnoreDuplicate = true;
            transactionRequest.Software = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            transactionRequest.CustReceipt = false;
            transactionRequest.Command = saleCommand;
            transactionRequest.Details = getTransactionDetails(transactionPayload, ebcLogger);
            ebizchargeServicemodelSoap.SecurityToken securityToken = getSecurityToken(dml, ebcLogger);
            response = ebiz.runTransaction(securityToken, transactionRequest);
            String transactionRefNo = Configuration.EMPTYSTRING;
            if (response.ResultCode == Configuration.TRANSACTIONRESULTCODE) {
                transactionRefNo = response.RefNum + '@' + paymentMethodID;
                //  Mockdata 
                if (test.isRunningTest()) {
                    customCustomerEntity.EBizCharge_Email__c = 'abc@sc.com';
                } //  Mockdata End
                
                if (sendRecptTo == true && (addEmailsTo != null && addEmailsTo != Configuration.EMPTYSTRING)) {
                    ebizchargeServicemodelSoap.EmailReceiptResponse emailReceiptResponse = new ebizchargeServicemodelSoap.EmailReceiptResponse();
                    emailReceiptResponse = ebiz.EmailReceipt(securityToken, transactionRefNo.substringBefore('@'), Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, addEmailsTo);
                    if (emailReceiptResponse.StatusCode == 1) {
                        ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent ');
                    } else {
                        ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent Error ');
                    }
                }
            } else {
                transactionRefNo = 'Error: ' + response.Error;
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return response;
    }
    public static ebizchargeServicemodelSoap.GwAddress getBillingAddressContact(Contact ebizContact, EBC_Logger ebcLogger) {
        MethodName = 'getBillingAddressContact';
        ebizchargeServicemodelSoap.GwAddress billingAddress = new ebizchargeServicemodelSoap.GwAddress();
        try {
            billingAddress.City = ebizContact.OtherCity;
            billingAddress.Company = Configuration.EMPTYSTRING;
            billingAddress.Country = Configuration.EMPTYSTRING;
            billingAddress.Email = ebizContact.Email;
            billingAddress.Fax = Configuration.EMPTYSTRING;
            billingAddress.FirstName = ebizContact.FirstName;
            billingAddress.LastName = ebizContact.LastName;
            billingAddress.Phone = Configuration.EMPTYSTRING;
            billingAddress.State = ebizContact.OtherState;
            billingAddress.Street = ebizContact.OtherStreet;
            billingAddress.Street2 = Configuration.EMPTYSTRING;
            billingAddress.Zip = ebizContact.OtherPostalCode;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return billingAddress;
    }
    public static ebizchargeServicemodelSoap.GwAddress getShippingAddressContact(Contact ebizContact, EBC_Logger ebcLogger) {
        MethodName = 'getShippingAddressContact';
        ebizchargeServicemodelSoap.GwAddress shippingAddress = new ebizchargeServicemodelSoap.GwAddress();
        try {
            shippingAddress.City = ebizContact.MailingCity;
            shippingAddress.Company = Configuration.EMPTYSTRING;
            shippingAddress.Country = Configuration.EMPTYSTRING;
            shippingAddress.Email = ebizContact.Email;
            shippingAddress.Fax = Configuration.EMPTYSTRING;
            shippingAddress.FirstName = ebizContact.FirstName;
            shippingAddress.LastName = ebizContact.LastName;
            shippingAddress.Phone = ebizContact.Phone;
            shippingAddress.State = ebizContact.MailingState;
            shippingAddress.Street = ebizContact.MailingStreet;
            shippingAddress.Street2 = Configuration.EMPTYSTRING;
            shippingAddress.Zip = ebizContact.MailingPostalCode;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return shippingAddress;
    }
    public static ebizchargeServicemodelSoap.TransactionResponse runAVSCheck(DML dml, Map < String, Object > strMap, EBC_Logger ebcLogger) {
        MethodName = 'runAVSCheck';
        Boolean isAVSMatched = true;
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        try {
            string accountId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId));
            string accExternalId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccInternalId));
            String saleCommand = string.valueOf(Enums.PAYMENTTYPES.AuthOnly);
            ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
            responseMerchant = ebiz.GetMerchantTransactionData(getSecurityToken(dml, ebcLogger));
            string paymentType = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType));
            double amount = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Amount));
            double tax = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Tax));
            transactionParams transactionPayload = new transactionParams();
            transactionPayload.accountID = accountId;
            transactionPayload.customerID = accountId;
            transactionPayload.internalID = accExternalId;
            transactionPayload.SubTotal = 0;
            if (responseMerchant.UseFullAmountForAVS == true) {
                transactionPayload.Amount = amount + tax;
            } else {
                transactionPayload.Amount = 0.05;
            }
            transactionPayload.Tax = 0;
            transactionPayload.isRecurring = false;
            transactionPayload.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            transactionPayload.methodID = Configuration.CARDMETHODID;
            transactionPayload.ccNumber = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
            transactionPayload.expMonth = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
            transactionPayload.expYear = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
            transactionPayload.cvvCode = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
            transactionPayload.ccName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
            transactionPayload.AvsZip = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
            transactionPayload.AvsStreet = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
            ebizchargeServicemodelSoap.TransactionRequestObject transactionRequest = new ebizchargeServicemodelSoap.TransactionRequestObject();
            transactionRequest.AccountHolder = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
            transactionRequest.CreditCardData = getCardData(transactionPayload, ebcLogger);
            transactionRequest.BillingAddress = null;
            transactionRequest.ShippingAddress = null;
            transactionRequest.isRecurring = false;
            transactionRequest.IgnoreDuplicate = true;
            transactionRequest.Software = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            transactionRequest.CustReceipt = false;
            transactionRequest.Command = saleCommand;
            transactionRequest.Details = getTransactionDetails(transactionPayload, ebcLogger);
            response = ebiz.runTransaction(getSecurityToken(dml, ebcLogger), transactionRequest);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return response;
    }
    public static ebizchargeServicemodelSoap.TransactionResponse runAVSCheckContact(DML dml, Map < String, Object > strMap, EBC_Logger ebcLogger) {
        MethodName = 'runAVSCheckContact';
        Boolean isAVSMatched = true;
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        try {
            string accountId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ContactId));
            string accExternalId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.conExternalId));
            String saleCommand = string.valueOf(Enums.PAYMENTTYPES.AuthOnly);
            ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
            responseMerchant = ebiz.GetMerchantTransactionData(getSecurityToken(dml, ebcLogger));
            string paymentType = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType));
            double amount = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Amount));
            double tax = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Tax));
            transactionParams transactionPayload = new transactionParams();
            transactionPayload.accountID = accountId;
            transactionPayload.customerID = accountId;
            transactionPayload.internalID = accExternalId;
            transactionPayload.SubTotal = 0;
            if (responseMerchant.UseFullAmountForAVS == true) {
                transactionPayload.Amount = amount + tax;
            } else {
                transactionPayload.Amount = 0.05;
            }
            transactionPayload.Tax = 0;
            transactionPayload.isRecurring = false;
            transactionPayload.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            transactionPayload.methodID = Configuration.CARDMETHODID;
            transactionPayload.ccNumber = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
            transactionPayload.expMonth = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
            transactionPayload.expYear = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
            transactionPayload.cvvCode = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
            transactionPayload.ccName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
            transactionPayload.AvsZip = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
            transactionPayload.AvsStreet = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
            ebizchargeServicemodelSoap.TransactionRequestObject transactionRequest = new ebizchargeServicemodelSoap.TransactionRequestObject();
            transactionRequest.AccountHolder = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
            transactionRequest.CreditCardData = getCardData(transactionPayload, ebcLogger);
            transactionRequest.BillingAddress = null;
            transactionRequest.ShippingAddress = null;
            transactionRequest.isRecurring = false;
            transactionRequest.IgnoreDuplicate = true;
            transactionRequest.Software = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            transactionRequest.CustReceipt = false;
            transactionRequest.Command = saleCommand;
            transactionRequest.Details = getTransactionDetails(transactionPayload, ebcLogger);
            response = ebiz.runTransaction(getSecurityToken(dml, ebcLogger), transactionRequest);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return response;
    }
    public static string runRecurringPayment(DML dml, transactionParams transactionPayload, Boolean SendReceiptTo, String emailRecipients, EBC_Logger ebcLogger) {
        MethodName = 'runRecurringPayment';
        ebcLogger.debug(ClassName, MethodName, 'transactionPayload:' + transactionPayload);
        ebcLogger.debug(ClassName, MethodName, 'SendReceiptTo:' + SendReceiptTo);
        ebizchargeServicemodelSoap.RecurringBilling recurringBilling = new ebizchargeServicemodelSoap.RecurringBilling();
        try {
            recurringBilling.Amount = transactionPayload.Amount + transactionPayload.Tax;
            recurringBilling.Tax = transactionPayload.Tax;
            recurringBilling.Enabled = true;
            recurringBilling.Start = transactionPayload.Start;
            recurringBilling.Expire = transactionPayload.Expire;
            recurringBilling.ScheduleName = transactionPayload.ScheduleName;
            recurringBilling.Schedule = transactionPayload.Schedule;
            recurringBilling.Next = transactionPayload.Expire;
            recurringBilling.RepeatCount = 1;
            recurringBilling.ReceiptNote = (transactionPayload.Notes == null || transactionPayload.Notes == Configuration.EMPTYSTRING) ? Configuration.EMPTYSTRING : transactionPayload.Notes;
            recurringBilling.SendCustomerReceipt = SendReceiptTo;
            recurringBilling.CustomerEmailList = emailRecipients;
            string response = ebiz.ScheduleRecurringPayment(getSecurityToken(dml, ebcLogger), transactionPayload.internalID, transactionPayload.methodID, recurringBilling);
            ebcLogger.debug(ClassName, MethodName, '>>>transactionPayload.internalID>>>>>>' + transactionPayload.internalID);
            ebcLogger.debug(ClassName, MethodName, '>>>response>>>>>>>>>>>>>>' + response);
            return 'rrScheduled';
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return Configuration.EXCEPTIONMESSAGE;
        }
    }
    public static ebizchargeServicemodelSoap.ApplicationTransactionResponse CreateApplicationTransaction(DML dml, String AccExternalId, String refNumber, String orderNumber, String orderId, String orderExternalId, String Command, string divisionId, string expiryYear, string expiryMonth, string paymentMethodID, EBC_Logger ebcLogger) {
        MethodName = 'CreateApplicationTransaction';
        ebizchargeServicemodelSoap.ApplicationTransactionRequest applicationTransactionCall = new ebizchargeServicemodelSoap.ApplicationTransactionRequest();
        ebizchargeServicemodelSoap.ApplicationTransactionResponse applicationReponse = new ebizchargeServicemodelSoap.ApplicationTransactionResponse();
        try {
            applicationTransactionCall.CustomerInternalId = AccExternalId;
            applicationTransactionCall.TransactionId = refNumber;
            applicationTransactionCall.TransactionTypeId = Command;
            applicationTransactionCall.LinkedToTypeId = orderNumber;
            applicationTransactionCall.LinkedToInternalId = orderExternalId;
            applicationTransactionCall.LinkedToExternalUniqueId = orderId;
            applicationTransactionCall.TransactionDate = string.valueOf(system.today());
            applicationTransactionCall.TransactionNotes = 'Transaction Reference Number: ' + refNumber + ' Order Number: ' + orderNumber;
            applicationTransactionCall.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            ebcLogger.debug(ClassName, MethodName, '>>>applicationTransactionCall:' + applicationTransactionCall);
            ebizchargeServicemodelSoap.ArrayOfEbizCustomField customFields = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
            list < ebizchargeServicemodelSoap.EbizCustomField > ebizCustomFields = new list < ebizchargeServicemodelSoap.EbizCustomField > ();
            ebizchargeServicemodelSoap.EbizCustomField divisionIdField = new ebizchargeServicemodelSoap.EbizCustomField();
            divisionIdField.FieldName = string.valueOf(Enums.FIELDNAMES.DivisionId);
            divisionIdField.FieldValue = DivisionId;
            ebizchargeServicemodelSoap.EbizCustomField expiryYearField = new ebizchargeServicemodelSoap.EbizCustomField();
            expiryYearField.FieldName = string.valueOf(Enums.FIELDNAMES.ExpirationYear);
            expiryYearField.FieldValue = expiryYear;
            ebizchargeServicemodelSoap.EbizCustomField expiryMonthField = new ebizchargeServicemodelSoap.EbizCustomField();
            expiryMonthField.FieldName = string.valueOf(Enums.FIELDNAMES.ExpirationMonth);
            expiryMonthField.FieldValue = expiryMonth;
            ebizchargeServicemodelSoap.EbizCustomField paymentMethodIdField = new ebizchargeServicemodelSoap.EbizCustomField();
            paymentMethodIdField.FieldName = string.valueOf(Enums.FIELDNAMES.PaymentMethodId);
            paymentMethodIdField.FieldValue = paymentMethodID;
            ebizCustomFields.add(divisionIdField);
            ebizCustomFields.add(expiryYearField);
            ebizCustomFields.add(expiryMonthField);
            ebizCustomFields.add(paymentMethodIdField);
            customFields.EbizCustomField = ebizCustomFields;
            applicationTransactionCall.TransactionCustomFields = customFields;
            applicationReponse = ebiz.AddApplicationTransaction(getSecurityToken(dml, ebcLogger), applicationTransactionCall);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return applicationReponse;
    }
    public static string addPaymentMethod(DML dml, transactionParams transactionPayload, string methodType, EBC_Logger ebcLogger) {
        MethodName = 'addPaymentMethod';
        ebizchargeServicemodelSoap.PaymentMethodProfile paymentMethod = new ebizchargeServicemodelSoap.PaymentMethodProfile();
        string methodID;
        paymentMethod.MethodType = methodType;
        paymentMethod.SecondarySort = '1';
        paymentMethod.Created = system.Date.today();
        paymentMethod.Modified = system.Date.today();
        try {
            if (methodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard)) {
                paymentMethod.CardNumber = transactionPayload.ccNumber;
                paymentMethod.CardExpiration = transactionPayload.expMonth + transactionPayload.expYear;
                paymentMethod.CardCode = transactionPayload.cvvCode;
                paymentMethod.AccountHolderName = transactionPayload.ccName;
                paymentMethod.AvsStreet = transactionPayload.AvsStreet;
                paymentMethod.AvsZip = transactionPayload.AvsZip;
                paymentMethod.MethodName = transactionPayload.MethodName;
            }
            if (methodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH)) {
                paymentMethod.AccountHolderName = transactionPayload.AccountName;
                paymentMethod.Account = transactionPayload.Account;
                //paymentMethod.AccountType = string.valueOf(Enums.ACCOUNTTYPES.Checking);
                paymentMethod.AccountType = transactionPayload.accountType;
                paymentMethod.Routing = transactionPayload.Route;
                paymentMethod.MethodName = transactionPayload.MethodName;
            }
            ebcLogger.debug(ClassName, MethodName, '>>>transactionPayload.internalID:' + transactionPayload.internalID);
            ebcLogger.debug(ClassName, MethodName, '>>>paymentMethod:' + paymentMethod);
            methodID = ebiz.AddCustomerPaymentMethodProfile(getSecurityToken(dml, ebcLogger), transactionPayload.internalID, paymentMethod);
            ebcLogger.debug(ClassName, MethodName, '>>>methodID:' + methodID);
            return methodID;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    public static ebizchargeServicemodelSoap.TransactionDetail getTransactionDetails(transactionParams transactionPayload, EBC_Logger ebcLogger) {
        MethodName = 'getTransactionDetails';
        ebizchargeServicemodelSoap.TransactionDetail transactionDetail = new ebizchargeServicemodelSoap.TransactionDetail();
        ebcLogger.debug(ClassName, MethodName, '>>>transactionPayload.accountID:' + transactionPayload.accountID);
        ebcLogger.debug(ClassName, MethodName, '>>>transactionPayload.customerID:' + transactionPayload.customerID);
        ebcLogger.debug(ClassName, MethodName, '>>>transactionPayload.OrderId:' + transactionPayload.OrderId);
        try {
            if (transactionPayload.OrderId != null && transactionPayload.OrderId != Configuration.DEFAULTORDERNUMBER) {
                transactionDetail.OrderID = transactionPayload.OrderId;
                if(transactionPayload.OrderNumber != null){
                    transactionDetail.Invoice = transactionPayload.OrderNumber;
                }else{
                    transactionDetail.Invoice = transactionPayload.OrderId;
                }
            } else if (transactionPayload.accountID == null) {
                transactionDetail.OrderID = transactionPayload.customerID;
                transactionDetail.Invoice = transactionPayload.customerID;
            } else {
                transactionDetail.OrderID = transactionPayload.accountID;
                transactionDetail.Invoice = transactionPayload.accountID;
            }
            transactionDetail.PONum = transactionPayload.PoNum;
            transactionDetail.Terminal = transactionPayload.Terminal;
            transactionDetail.NonTax = false;
            transactionDetail.Tax = transactionPayload.Tax;
            transactionDetail.Subtotal = transactionPayload.SubTotal;
            transactionDetail.Shipping = 0;
            transactionDetail.Duty = 0;
            transactionDetail.Discount = 0;
            transactionDetail.Tip = 0;
            transactionDetail.Amount = transactionPayload.Amount;
            transactionDetail.Terminal = transactionPayload.Terminal;
            transactionDetail.Clerk = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            transactionDetail.AllowPartialAuth = false;
            transactionDetail.Description = transactionPayload.Description;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return transactionDetail;
    }
    public static ebizchargeServicemodelSoap.GwAddress getBillingAddress(Account ebizAccount, EBC_Logger ebcLogger) {
        MethodName = 'getBillingAddress';
        ebizchargeServicemodelSoap.GwAddress billingAddress = new ebizchargeServicemodelSoap.GwAddress();
        try {
            billingAddress.City = (ebizAccount.BillingCity != null) ? ebizAccount.BillingCity : Configuration.EMPTYSTRING;
            billingAddress.Company = Configuration.EMPTYSTRING;
            billingAddress.Country = Configuration.EMPTYSTRING;
            //billingAddress.Email = (ebizAccount.EBizCharge_Email__c != null) ? ebizAccount.EBizCharge_Email__c : Configuration.EMPTYSTRING;
            billingAddress.Email  = ((String)ebizAccount.get('Email__c') != null) ? (String)ebizAccount.get('Email__c') : Configuration.EMPTYSTRING;//For SF-QBD
            billingAddress.Fax = Configuration.EMPTYSTRING;
            billingAddress.FirstName = (ebizAccount.First_Name__c != null) ? ebizAccount.First_Name__c : Configuration.EMPTYSTRING;
            billingAddress.LastName = (ebizAccount.Last_Name__c != null) ? ebizAccount.Last_Name__c : Configuration.EMPTYSTRING;
            billingAddress.Phone = Configuration.EMPTYSTRING;
            billingAddress.State = (ebizAccount.BillingState != null) ? ebizAccount.BillingState : Configuration.EMPTYSTRING;
            billingAddress.Street = (ebizAccount.BillingStreet != null) ? ebizAccount.BillingStreet : Configuration.EMPTYSTRING;
            billingAddress.Street2 = Configuration.EMPTYSTRING;
            billingAddress.Zip = (ebizAccount.BillingPostalCode != null) ? ebizAccount.BillingPostalCode : Configuration.EMPTYSTRING;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return billingAddress;
    }
    public static ebizchargeServicemodelSoap.GwAddress getShippingAddress(Account ebizAccount, EBC_Logger ebcLogger) {
        MethodName = 'getShippingAddress';
        ebizchargeServicemodelSoap.GwAddress shippingAddress = new ebizchargeServicemodelSoap.GwAddress();
        try {
            shippingAddress.City = (ebizAccount.ShippingCity != null) ? ebizAccount.ShippingCity : Configuration.EMPTYSTRING;
            shippingAddress.Company = Configuration.EMPTYSTRING;
            shippingAddress.Country = Configuration.EMPTYSTRING;
            //shippingAddress.Email = (ebizAccount.EBizCharge_Email__c != null) ? ebizAccount.EBizCharge_Email__c : Configuration.EMPTYSTRING;
            shippingAddress.Email  = ((String)ebizAccount.get('Email__c') != null) ? (String)ebizAccount.get('Email__c') : Configuration.EMPTYSTRING;//For SF-QBD
            shippingAddress.Fax = Configuration.EMPTYSTRING;
            shippingAddress.FirstName = (ebizAccount.First_Name__c != null) ? ebizAccount.First_Name__c : Configuration.EMPTYSTRING;
            shippingAddress.LastName = (ebizAccount.Last_Name__c != null) ? ebizAccount.Last_Name__c : Configuration.EMPTYSTRING;
            shippingAddress.Phone = (ebizAccount.Phone != null) ? ebizAccount.Phone : Configuration.EMPTYSTRING;
            shippingAddress.State = (ebizAccount.ShippingState != null) ? ebizAccount.ShippingState : Configuration.EMPTYSTRING;
            shippingAddress.Street = (ebizAccount.ShippingStreet != null) ? ebizAccount.ShippingStreet : Configuration.EMPTYSTRING;
            shippingAddress.Street2 = Configuration.EMPTYSTRING;
            shippingAddress.Zip = (ebizAccount.ShippingPostalCode != null) ? ebizAccount.ShippingPostalCode : Configuration.EMPTYSTRING;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return shippingAddress;
    }
    public static ebizchargeServicemodelSoap.CreditCardData getCardData(transactionParams transactionPayload, EBC_Logger ebcLogger) {
        MethodName = 'getCardData';
        ebizchargeServicemodelSoap.CreditCardData creditCardData = new ebizchargeServicemodelSoap.CreditCardData();
        try {
            creditCardData.Pares = Configuration.EMPTYSTRING;
            creditCardData.MagSupport = Configuration.EMPTYSTRING;
            creditCardData.MagStripe = Configuration.EMPTYSTRING;
            creditCardData.ECI = Configuration.EMPTYSTRING;
            creditCardData.DUKPT = Configuration.EMPTYSTRING;
            creditCardData.XID = Configuration.EMPTYSTRING;
            creditCardData.Signature = Configuration.EMPTYSTRING;
            creditCardData.TermType = Configuration.EMPTYSTRING;
            creditCardData.CardPresent = false;
            creditCardData.AvsZip = transactionPayload.AvsZip;
            creditCardData.AvsStreet = transactionPayload.AvsStreet;
            creditCardData.CardNumber = transactionPayload.ccNumber;
            creditCardData.CardCode = transactionPayload.cvvCode;
            creditCardData.CAVV = transactionPayload.cvvCode;
            creditCardData.CardExpiration = transactionPayload.expMonth + transactionPayload.expYear;
            creditCardData.InternalCardAuth = false;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return creditCardData;
    }
    public static ebizchargeServicemodelSoap.CheckData getCheckData(transactionParams transactionPayload, EBC_Logger ebcLogger) {
        MethodName = 'getCheckData';
        ebizchargeServicemodelSoap.CheckData CheckData = new ebizchargeServicemodelSoap.CheckData();
        try {
            CheckData.Account = transactionPayload.Account;
            //CheckData.AccountType = string.valueOf(Enums.ACCOUNTTYPES.Checking);
            CheckData.AccountType = transactionPayload.accountType;
            CheckData.CheckNumber = transactionPayload.Account;
            CheckData.DriversLicense = 'xxxxx';
            CheckData.DriversLicenseState = 'xx';
            CheckData.RecordType = Configuration.EMPTYSTRING;
            CheckData.Routing = transactionPayload.Route;
            CheckData.MICR = Configuration.EMPTYSTRING;
            CheckData.AuxOnUS = Configuration.EMPTYSTRING;
            CheckData.EpcCode = Configuration.EMPTYSTRING;
            CheckData.FrontImage = Configuration.EMPTYSTRING;
            CheckData.BackImage = Configuration.EMPTYSTRING;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return CheckData;
    }
    public static void saveTransaction(DML dml, String refNumber, EBizCharge_Transaction__c transactionEntity, EBC_Logger ebcLogger) {
        MethodName = 'saveTransaction';
        ebcLogger.debug(ClassName, MethodName, '>>>refNumber:' + refNumber);
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.TransactionObject ebizTransaction = new ebizchargeServicemodelSoap.TransactionObject();
        try {
            ebizTransaction = ebiz.GetTransactionDetails(getSecurityToken(dml, ebcLogger), refNumber);
            
            transactionEntity.Ref_Number__c = refNumber;
            transactionEntity.CreatedDateTime__c = dateTime.valueOf(ebizTransaction.DateTime_x);
            transactionEntity.Status__c = ebizTransaction.Status;
            transactionEntity.Transaction_Type__c = ebizTransaction.TransactionType;
            ebizchargeServicemodelSoap.TransactionResponse transactionResponse = new ebizchargeServicemodelSoap.TransactionResponse();
            transactionResponse = ebizTransaction.Response;
            transactionEntity.Customer_Number__c = transactionResponse.CustNum;
            transactionEntity.Result_Code__c = transactionResponse.ResultCode;
            transactionEntity.Result__c = transactionResponse.Result;
            transactionEntity.Error_Code__c = transactionResponse.ErrorCode;
            transactionEntity.Error__c = transactionResponse.Error;
            transactionEntity.Card_Code_Result_Code__c = transactionResponse.CardCodeResultCode;
            transactionEntity.Card_Code_Result__c = transactionResponse.CardCodeResult;
            transactionEntity.Batch_Ref_Number__c = transactionResponse.BatchRefNum;
            transactionEntity.Batch_Number__c = transactionResponse.BatchNum;
            transactionEntity.Avs_Result_Code__c = transactionResponse.AvsResultCode;
            transactionEntity.Avs_Result__c = transactionResponse.AvsResult;
            transactionEntity.Auth_Code__c = transactionResponse.AuthCode;
            transactionEntity.Auth_Amount__c = transactionResponse.AuthAmount;
            transactionEntity.Response_Status__c = transactionResponse.Status;
            transactionEntity.Response_Status_Code__c = transactionResponse.StatusCode;
            ebizchargeServicemodelSoap.TransactionDetail transactionDetail = new ebizchargeServicemodelSoap.TransactionDetail();
            transactionDetail = ebizTransaction.Details;
            Schema.DescribeSObjectResult sObjectResultContact = Contact.sObjectType.getDescribe();
            String keyPrefixContact = sObjectResultContact.getKeyPrefix();
            if(transactionDetail.Terminal!= null || transactionDetail.Terminal!= Configuration.EMPTYSTRING){
               if(transactionDetail.Terminal.startsWith(keyPrefixContact)){
                transactionEntity.Contact_Id__c = transactionDetail.Terminal;
               }
            }
            transactionEntity.Non_Tax__c = transactionDetail.NonTax;
            transactionEntity.Tax__c = transactionDetail.Tax;
            transactionEntity.Ship_From_Zip__c = transactionDetail.ShipFromZip;
            transactionEntity.PONum__c = transactionDetail.PONum;
            transactionEntity.Invoice__c = transactionDetail.Invoice;
            transactionEntity.Description__c = transactionDetail.Description;
            transactionEntity.Detail_Amount__c = transactionDetail.Amount;
            if (transactionDetail.Subtotal > transactionDetail.Amount) {
                transactionEntity.EBizCharge_Subtotal__c = transactionDetail.Amount - transactionDetail.Tax;
            } else {
                transactionEntity.EBizCharge_Subtotal__c = transactionDetail.Subtotal;
            }
            if (transactionDetail.Subtotal == 0) {
                transactionEntity.Tax__c = 0;
            }
            ebizchargeServicemodelSoap.CreditCardData creditCardData = new ebizchargeServicemodelSoap.CreditCardData();
            creditCardData = ebizTransaction.CreditCardData;
            if (test.isRunningTest()) {
                creditCardData.CardNumber = '00000000';
            }
            if (creditCardData.CardNumber != null) {
                transactionEntity.Card_Number__c = creditCardData.CardNumber;
                transactionEntity.Last_X_Digit__c = (creditCardData.CardNumber).right(4);
                transactionEntity.Card_Type__c = creditCardData.CardType;
                transactionEntity.Card_Present__c = true;
            } else {
                transactionEntity.Card_Present__c = false;
            }
            ebizchargeServicemodelSoap.CheckData accountData = new ebizchargeServicemodelSoap.CheckData();
            accountData = ebizTransaction.CheckData;
            if (accountData != null) {
                if (accountData.Account != null) {
                    transactionEntity.Last_X_Digit__c = (accountData.Account).right(4);
                    transactionEntity.Card_Type__c = string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH);
                }
            }
            transactionEntity.Avs_Zip__c = creditCardData.AvsZip;
            transactionEntity.Avs_Street__c = creditCardData.AvsStreet;
            dml.insertRecord(transactionEntity);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @future(callout = true)
    public static void getTransactionDetailGW(String transactionId, String refNumber) {
        MethodName = 'getTransactionDetailGW';
        EBC_Logger ebcLogger = new EBC_Logger();
        DML dml = new DML();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.TransactionObject ebizTransaction = new ebizchargeServicemodelSoap.TransactionObject();
        try {
            ebizTransaction = ebiz.GetTransactionDetails(getSecurityToken(dml, ebcLogger), refNumber);
            EBizCharge_Transaction__c transactionEntity = new EBizCharge_Transaction__c();
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Id.isUpdateable()) {
                transactionEntity.Id = transactionId;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Status__c.isUpdateable()) {
                transactionEntity.Status__c = ebizTransaction.Status;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Transaction_Type__c.isUpdateable()) {
                transactionEntity.Transaction_Type__c = ebizTransaction.TransactionType;
            }
            ebizchargeServicemodelSoap.TransactionResponse transactionResponse = new ebizchargeServicemodelSoap.TransactionResponse();
            transactionResponse = ebizTransaction.Response;
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Customer_Number__c.isUpdateable()) {
                transactionEntity.Customer_Number__c = transactionResponse.CustNum;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Result_Code__c.isUpdateable()) {
                transactionEntity.Result_Code__c = transactionResponse.ResultCode;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Result__c.isUpdateable()) {
                transactionEntity.Result__c = transactionResponse.Result;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Error_Code__c.isUpdateable()) {
                transactionEntity.Error_Code__c = transactionResponse.ErrorCode;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Error__c.isUpdateable()) {
                transactionEntity.Error__c = transactionResponse.Error;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Code_Result_Code__c.isUpdateable()) {
                transactionEntity.Card_Code_Result_Code__c = transactionResponse.CardCodeResultCode;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Code_Result__c.isUpdateable()) {
                transactionEntity.Card_Code_Result__c = transactionResponse.CardCodeResult;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Batch_Ref_Number__c.isUpdateable()) {
                transactionEntity.Batch_Ref_Number__c = transactionResponse.BatchRefNum;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Batch_Number__c.isUpdateable()) {
                transactionEntity.Batch_Number__c = transactionResponse.BatchNum;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Avs_Result_Code__c.isUpdateable()) {
                transactionEntity.Avs_Result_Code__c = transactionResponse.AvsResultCode;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Avs_Result__c.isUpdateable()) {
                transactionEntity.Avs_Result__c = transactionResponse.AvsResult;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Auth_Code__c.isUpdateable()) {
                transactionEntity.Auth_Code__c = transactionResponse.AuthCode;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Auth_Amount__c.isUpdateable()) {
                transactionEntity.Auth_Amount__c = transactionResponse.AuthAmount;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Response_Status__c.isUpdateable()) {
                transactionEntity.Response_Status__c = transactionResponse.Status;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Response_Status_Code__c.isUpdateable()) {
                transactionEntity.Response_Status_Code__c = transactionResponse.StatusCode;
            }
            ebizchargeServicemodelSoap.TransactionDetail transactionDetail = new ebizchargeServicemodelSoap.TransactionDetail();
            transactionDetail = ebizTransaction.Details;
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Non_Tax__c.isUpdateable()) {
                transactionEntity.Non_Tax__c = transactionDetail.NonTax;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Tax__c.isUpdateable()) {
                transactionEntity.Tax__c = transactionDetail.Tax;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Ship_From_Zip__c.isUpdateable()) {
                transactionEntity.Ship_From_Zip__c = transactionDetail.ShipFromZip;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.PONum__c.isUpdateable()) {
                transactionEntity.PONum__c = transactionDetail.PONum;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Invoice__c.isUpdateable()) {
                transactionEntity.Invoice__c = transactionDetail.Invoice;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Description__c.isUpdateable()) {
                transactionEntity.Description__c = transactionDetail.Description;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Detail_Amount__c.isUpdateable()) {
                transactionEntity.Detail_Amount__c = transactionDetail.Amount;
            }
            ebizchargeServicemodelSoap.CreditCardData creditCardData = new ebizchargeServicemodelSoap.CreditCardData();
            creditCardData = ebizTransaction.CreditCardData;
            //  Mockdata 
            if (test.isRunningTest()) {
                creditCardData.CardNumber = '11111222';
            } //  Mockdata End
            if (creditCardData.CardNumber != null) {
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Number__c.isUpdateable()) {
                    transactionEntity.Card_Number__c = creditCardData.CardNumber;
                }
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Last_X_Digit__c.isUpdateable()) {
                    transactionEntity.Last_X_Digit__c = (creditCardData.CardNumber).right(4);
                }
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Type__c.isUpdateable()) {
                    transactionEntity.Card_Type__c = creditCardData.CardType;
                }
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Present__c.isUpdateable()) {
                    transactionEntity.Card_Present__c = true;
                }
            } else {
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Present__c.isUpdateable()) {
                    transactionEntity.Card_Present__c = false;
                }
            }
            ebizchargeServicemodelSoap.CheckData accountData = new ebizchargeServicemodelSoap.CheckData();
            accountData = ebizTransaction.CheckData;
            if (accountData != null) {
                if (accountData.Account != null) {
                    transactionEntity.Last_X_Digit__c = (accountData.Account).right(4);
                    transactionEntity.Card_Type__c = string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH);
                }
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Avs_Zip__c.isUpdateable()) {
                transactionEntity.Avs_Zip__c = creditCardData.AvsZip;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Avs_Street__c.isUpdateable()) {
                transactionEntity.Avs_Street__c = creditCardData.AvsStreet;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.isUpdateable()) {
                dml.updateRecord(transactionEntity);
                // update transactionEntity;
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            // ebcLogger.saveLogs();
        }
    }
    public static Account getAccountDetail(DML dml, string accountId, EBC_Logger ebcLogger) {
        MethodName = 'getAccountDetail';
        String query_select = 'SELECT id,DDA_Enc__c,DDA_Type__c,ABA__c,ABA_Debit__c,DDA_Enc_Debit__c,DDA_Debit_Type__c,EBizCharge_Custom_Tax__c, Name,First_Name__c,Last_Name__c,Email__c,QBD_Customer_ID__c,EBizCharge_Amount__c,' +
            'EBizCharge_Reference_Number__c, Phone, Fax, Website,EBizCharge_Internal_ID__c,BillingAddress,BillingStreet, ' +
            'BillingPostalCode, BillingCity, BillingCountry, BillingState,ShippingCity, ShippingState, ShippingAddress,' +
            'ShippingStreet, ShippingPostalCode, ShippingCountry, EBizCharge_Account_Tax__c';
        String query_from = 'FROM Account';
        String query_where = 'where id =\'' + String.escapeSingleQuotes(accountId) + '\'';
        try {
            Account account = (Account) dml.selectSingleRecord(query_select, query_from, query_where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            return account;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return null;
        }
    }
    public static Contact getContactDetail(DML dml, string contactId, EBC_Logger ebcLogger) {
        MethodName = 'getContactDetail';
        String query_select = 'SELECT EBizCharge_Contact_Tax__c, Id, Name, createdById ,Email, FirstName, LastName  ,Phone, Fax,MailingCountry,' +
            'MailingState ,OtherAddress,OtherCity,OtherCountry,OtherState ,OtherStreet ,OtherPostalCode , ' +
            'Ebiz_C__EBizCharge_Contact_Internal_ID__c,MailingCity,MailingStreet  ,MailingPostalCode ,' +
            'Ebiz_C__EBizCharge_Contact_Amount__c , AccountId, Account.Name';
        String query_from = 'FROM Contact';
        String query_where = 'where Id =\'' + String.escapeSingleQuotes(contactId) + '\'';
        try {
            Contact contact = (Contact) dml.selectSingleRecord(query_select, query_from, query_where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            return contact;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return null;
        }
    }
    public static Ebiz_C__EBizCharge_Fields_Config__c getCustomFieldDetail(DML dml, string customObjectId, EBC_Logger ebcLogger) {
        MethodName = 'getCustomFieldDetail';
        String query_select = 'SELECT Id, Name, Ebiz_C__EBizCharge_Internal_ID__c ,Ebiz_C__EBizCharge_Amount__c, ' +
        'Ebiz_C__EBizCharge_Amount_Source__c   ,Ebiz_C__EBizCharge_CustomerId__c ,Email__c,'+
        'Ebiz_C__EBizCharge_Last_Sync_Date__c ,Ebiz_C__EBizCharge_Reference_Number__c';
        String query_from = 'FROM Ebiz_C__EBizCharge_Fields_Config__c';
        String query_where = 'where Ebiz_C__EBizCharge_CustomerId__c =\'' + String.escapeSingleQuotes(customObjectId) + '\'';
        try {
            Ebiz_C__EBizCharge_Fields_Config__c customObject = (Ebiz_C__EBizCharge_Fields_Config__c) dml.selectSingleRecord(query_select, query_from, query_where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            return customObject;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return null;
        }
    }
    public static ebizchargeServicemodelSoap.SecurityToken getSecurityToken(DML dml, EBC_Logger ebcLogger) {
        ebizchargeServicemodelSoap.SecurityToken securityToken = new ebizchargeServicemodelSoap.SecurityToken();
        String query_select = 'SELECT Security_Token__c, User_Name__c,Password__c';
        String query_from = 'FROM EBizcharge_Setting__c';
        String query_limit = 'limit 1';
        try {
            for (EBizcharge_Setting__c settings: (list < EBizcharge_Setting__c > ) dml.selectRecords(query_select, query_from, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, query_limit)) {
                securityToken.SecurityId = settings.Security_Token__c;
                securityToken.UserId = settings.User_Name__c;
                securityToken.Password = settings.Password__c;
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return securityToken;
    }
    public static string getCustomerToken(DML dml, string customerID, string internalID, EBC_Logger ebcLogger) {
        MethodName = 'getCustomerToken';
        ebizchargeServicemodelSoap.GetCustomerToken_element ebizCustomer = new ebizchargeServicemodelSoap.GetCustomerToken_element();
        try {
            string customerToken = ebiz.GetCustomerToken(getSecurityToken(dml, ebcLogger), customerID, internalID);
            //string customerToken = ebiz.GetCustomerToken(getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, internalID);
            return customerToken;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return null;
        }
    }
}