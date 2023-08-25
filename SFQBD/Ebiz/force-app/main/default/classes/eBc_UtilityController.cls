public with sharing class eBc_UtilityController {
    public static string ClassName = 'eBc_UtilityController';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    public static ebizchargeServicemodelSoap.Customer invoke_SearchCustomer(DML dml, String customerId, EBC_Logger ebcLogger) {
        MethodName = 'invoke_SearchCustomer';
        ebizchargeServicemodelSoap.Customer response = new ebizchargeServicemodelSoap.Customer();
        try {
            response = ebiz.GetCustomer(getSecurityToken(dml, ebcLogger), customerId, Configuration.EMPTYSTRING);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return response;
    }
    public static ebizchargeServicemodelSoap.CustomerResponse invoke_addORUpdCustomer(DML dml, Account account, ebizchargeServicemodelSoap.SecurityToken securityToken, String action, EBC_Logger ebcLogger) {
        MethodName = 'invoke_addORUpdCustomer';
        ebizchargeServicemodelSoap.Customer customer = new ebizchargeServicemodelSoap.Customer();
        //customer.CustomerId = account.id;
         customer.CustomerId = (String)account.get('QBD_Customer_ID__c');//For SF-Qbd
        customer.FirstName = account.First_Name__c;
        customer.LastName = account.Last_Name__c;
        //customer.Email = account.EBizCharge_Email__c;
        customer.Email =  (String)account.get('Email__c');//For SF-Qbd
        customer.CompanyName = account.Name;
        customer.Phone = account.Phone;
        customer.Fax = account.Fax;
        customer.WebSite = account.Website;
        customer.SoftwareId = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        EBizcharge_Setting__c ebizchargeSettings = getSettings(dml, ebcLogger);
        if (ebizchargeSettings.Division_ID__c != null) {
            customer.DivisionId = ebizchargeSettings.Division_ID__c;
        }
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
        customer.BillingAddress = billingAddress;
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
        customer.ShippingAddress = shippingAddress;
        ebizchargeServicemodelSoap.EbizCustomField ebizCustomField = new ebizchargeServicemodelSoap.EbizCustomField();
        ebizCustomField.FieldName = string.valueOf(Enums.FIELDNAMES.dateupdated);
        ebizCustomField.FieldValue = String.valueOfGmt(DateTime.now());
        ebizchargeServicemodelSoap.ArrayOfEbizCustomField customFields = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
        customFields.EbizCustomField = new List < ebizchargeServicemodelSoap.EbizCustomField > ();
        customFields.EbizCustomField.add(ebizCustomField);
        customer.CustomerCustomFields = customFields;
        ebizchargeServicemodelSoap.CustomerResponse customerResponse = new ebizchargeServicemodelSoap.CustomerResponse();
        try {
            if (action == string.valueOf(Enums.ENTITYACTIONS.addCustomer)) {
                customerResponse = ebiz.addCustomer(securityToken, customer);
            } else {
                //customerResponse = ebiz.UpdateCustomer(securityToken, customer, account.Id, account.EBizCharge_Internal_ID__c);
                customerResponse = ebiz.UpdateCustomer(securityToken, customer, (String)account.get('QBD_Customer_ID__c'), account.EBizCharge_Internal_ID__c);//For SF-Qbd
            }
        } catch (Exception e) {
            customerResponse.StatusCode = 0;
            customerResponse.Error = Configuration.EXCEPTIONSTRING + e.getMessage();
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return customerResponse;
    }
    // This Function invoke_addORUpdCustomerQBD is write for AccountInsertOrUpdate Flow  
    public static ebizchargeServicemodelSoap.CustomerResponse invoke_addORUpdCustomerQBD(DML dml,Account acc,ebizchargeServicemodelSoap.SecurityToken st,String Old_Qbd_Id,String action,EBC_Logger ebcLogger){ 
        ebizchargeServicemodelSoap.Customer cst = new ebizchargeServicemodelSoap.Customer();
         cst.CustomerId  = (String)acc.get('QBD_Customer_ID__c');
         cst.FirstName   = acc.First_Name__c;  
         cst.LastName    = acc.Last_Name__c;  
         //cst.Email       = acc.EBizCharge_Email__c;
         cst.Email       = (String)acc.get('Email__c');
         cst.CompanyName = acc.Name;
         cst.Phone       = acc.Phone;
         cst.Fax         = acc.Fax;
         cst.WebSite     = acc.Website;
         cst.SoftwareId  = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
         EBizcharge_Setting__c ebizchargeSettings = getSettings(dml,ebcLogger);
         if(ebizchargeSettings.Division_ID__c!=null){
             cst.DivisionId = ebizchargeSettings.Division_ID__c;
         }
         ebizchargeServicemodelSoap.Address billingAdds = new ebizchargeServicemodelSoap.Address();
         billingAdds.FirstName    = acc.First_Name__c; 
         billingAdds.LastName     = acc.Last_Name__c; 
         billingAdds.CompanyName  = acc.Name;
         billingAdds.Address1     = acc.BillingStreet;
         billingAdds.Address2     = '';        
         billingAdds.City         = acc.BillingCity;
         billingAdds.State        = acc.BillingState;
         billingAdds.ZipCode      = acc.BillingPostalCode;
         billingAdds.Country      = acc.BillingCountry;     
         cst.BillingAddress       = billingAdds;
         ebizchargeServicemodelSoap.Address shippingAdds = new ebizchargeServicemodelSoap.Address();
         shippingAdds.FirstName   = acc.First_Name__c;//acc.EBizCharge_First_Name__c;
         shippingAdds.LastName    = acc.Last_Name__c;//acc.EBizCharge_Last_Name__c;
         shippingAdds.CompanyName = acc.Name;
         shippingAdds.Address1    = acc.ShippingStreet;
         shippingAdds.Address2    = '';        
         shippingAdds.City        = acc.ShippingCity;
         shippingAdds.State       = acc.ShippingState;
         shippingAdds.ZipCode     = acc.ShippingPostalCode;
         shippingAdds.Country     = acc.ShippingCountry; 
         cst.ShippingAddress      = shippingAdds;
         ebizchargeServicemodelSoap.EbizCustomField ebizCstmField = new ebizchargeServicemodelSoap.EbizCustomField();
         ebizCstmField.FieldName = string.valueOf(Enums.FIELDNAMES.dateupdated);
         ebizCstmField.FieldValue = String.valueOfGmt(DateTime.now());
         ebizchargeServicemodelSoap.ArrayOfEbizCustomField arrCstmField = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
         arrCstmField.EbizCustomField = new List<ebizchargeServicemodelSoap.EbizCustomField>();
         arrCstmField.EbizCustomField.add(ebizCstmField);
         cst.CustomerCustomFields = arrCstmField;
         ebizchargeServicemodelSoap.CustomerResponse Customer_response = new ebizchargeServicemodelSoap.CustomerResponse();
         try{
             if(action == string.valueOf(Enums.ENTITYACTIONS.addCustomer)){
                 Customer_response = ebiz.addCustomer(st, cst);    
             }else{
                  Customer_response = ebiz.UpdateCustomer(st,cst,Old_Qbd_Id,acc.EBizCharge_Internal_ID__c);
             }
         } catch(Exception e) {
             Customer_response.StatusCode = 0;
             Customer_response.Error = Configuration.EXCEPTIONSTRING + e.getMessage();
             ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
         }
         return Customer_response;
    }
    public static ebizchargeServicemodelSoap.CustomerResponse invoke_addORUpdCustomerContact(DML dml, Contact contact, ebizchargeServicemodelSoap.SecurityToken securityToken, String action, EBC_Logger ebcLogger) {
        MethodName = 'invoke_addORUpdCustomerContact';
        ebizchargeServicemodelSoap.Customer customer = new ebizchargeServicemodelSoap.Customer();
        customer.CustomerId = contact.id;
        customer.FirstName = contact.FirstName;
        customer.LastName = contact.LastName;
        customer.Email = contact.Email;
        customer.CompanyName = contact.Name;
        customer.Phone = contact.Phone;
        customer.Fax = contact.Fax;
        customer.WebSite = Configuration.EMPTYSTRING;
        customer.SoftwareId = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        ebizchargeServicemodelSoap.Address billingAddress = new ebizchargeServicemodelSoap.Address();
        billingAddress.FirstName = contact.FirstName;
        billingAddress.LastName = contact.LastName;
        billingAddress.CompanyName = contact.Name;
        billingAddress.Address1 = contact.MailingStreet;
        billingAddress.Address2 = Configuration.EMPTYSTRING;
        billingAddress.City = contact.MailingCity;
        billingAddress.State = contact.MailingState;
        billingAddress.ZipCode = contact.MailingPostalCode;
        billingAddress.Country = contact.MailingCountry;
        customer.BillingAddress = billingAddress;
        EBizcharge_Setting__c ebizchargeSettings = getSettings(dml, ebcLogger);
        if (test.isRunningTest()) {
            ebizchargeSettings.Division_ID__c = '1111111';
        }
        if (ebizchargeSettings.Division_ID__c != null) {
            customer.DivisionId = ebizchargeSettings.Division_ID__c;
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
        customer.ShippingAddress = shippingAddress;
        ebizchargeServicemodelSoap.CustomerResponse customerResponse = new ebizchargeServicemodelSoap.CustomerResponse();
        try {
            if (action == string.valueOf(Enums.ENTITYACTIONS.addCustomer)) {
                customerResponse = ebiz.addCustomer(securityToken, customer);
            } else {
                customerResponse = ebiz.UpdateCustomer(securityToken, customer, contact.Id, contact.EBizCharge_Contact_Internal_ID__c);
            }
        } catch (Exception e) {
            customerResponse.StatusCode = 0;
            customerResponse.Error = Configuration.EXCEPTIONSTRING + e.getMessage();
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return customerResponse;
    }
    public static String updCustomerInSF(DML dml, map < String, String > customersToUpdate, EBC_Logger ebcLogger) {
        MethodName = 'updCustomerInSF';
        List < Account > updateCustomers = new List < Account > ();
        for (String key: customersToUpdate.keySet()) {
            Account account = new Account();
            account.Id = key;
            account.EBizCharge_Internal_ID__c = customersToUpdate.get(key);
            account.EBizCharge_Last_Sync_Date__c = system.now();
            updateCustomers.add(account);
        }
        try {
            dml.updateRecord(updateCustomers);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (DmlException e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    public static String updCustomerInSFContact(DML dml, map < String, String > customersToUpdate, EBC_Logger ebcLogger) {
        MethodName = 'updCustomerInSFContact';
        List < Contact > updateCustomers = new List < Contact > ();
        for (String key: customersToUpdate.keySet()) {
            Contact contact = new Contact();
            contact.Id = key;
            contact.Ebiz_C__EBizCharge_Contact_Internal_ID__c = customersToUpdate.get(key);
            contact.EBizCharge_Last_Sync_Date__c = system.now();
            updateCustomers.add(contact);
        }
        try {
            dml.updateRecord(updateCustomers);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (DmlException e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    public static Ebiz_C__EBizCharge_Fields_Config__c UpdateCustomObjectsFields(DML dml, string objectName, string customerId, EBC_Logger ebcLogger) {
        MethodName = 'UpdateCustomObjectsFields';
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        string Query = Configuration.EMPTYSTRING;
        string Fields = Configuration.EMPTYSTRING;
        querySelect = 'SELECT id,Ebiz_C__EBizCustomerNameApi__c,Ebiz_C__EBizCustomerEmailApi__c,Ebiz_C__EBizAmountApi__c';
        queryFrom = 'FROM Ebiz_C__EBiz_Object_Config__c';
        queryWhere = 'where Name =\'' + objectName + '\'';
        Ebiz_C__EBiz_Object_Config__c configurationObject = (Ebiz_C__EBiz_Object_Config__c) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        Ebiz_C__EBizCharge_Fields_Config__c fieldsConfiguration = new Ebiz_C__EBizCharge_Fields_Config__c();
        if (string.isNotBlank(configurationObject.Ebiz_C__EBizCustomerNameApi__c) && string.isNotEmpty(configurationObject.Ebiz_C__EBizCustomerNameApi__c) && configurationObject.Ebiz_C__EBizCustomerNameApi__c != null) {
            Fields += configurationObject.Ebiz_C__EBizCustomerNameApi__c + Configuration.APINAMESEPARATOR;
        } else {
            Fields += Configuration.EMPTYSTRING;
        }
        if (string.isNotBlank(configurationObject.Ebiz_C__EBizCustomerEmailApi__c) && string.isNotEmpty(configurationObject.Ebiz_C__EBizCustomerEmailApi__c) && configurationObject.Ebiz_C__EBizCustomerEmailApi__c != null) {
            Fields += configurationObject.Ebiz_C__EBizCustomerEmailApi__c + Configuration.APINAMESEPARATOR;
        } else {
            Fields += Configuration.EMPTYSTRING;
        }
        if (string.isNotBlank(configurationObject.Ebiz_C__EBizAmountApi__c) && string.isNotEmpty(configurationObject.Ebiz_C__EBizAmountApi__c) && configurationObject.Ebiz_C__EBizAmountApi__c != null) {
            Fields += configurationObject.Ebiz_C__EBizAmountApi__c + Configuration.APINAMESEPARATOR;
        } else {
            Fields += Configuration.EMPTYSTRING;
        }
        querySelect = 'SELECT id,' + Fields + string.valueOf(Enums.FIELDNAMES.createddate);
        queryFrom = 'FROM ' + objectName + Configuration.EMPTYSTRING;
        queryWhere = 'where id =\'' + customerId + '\'';
        List < sObject > standardObjects = dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        fieldsConfiguration.Ebiz_C__EBizCharge_CustomerId__c = customerId;
        for (sObject s: standardObjects) {
            if (string.isNotBlank(configurationObject.Ebiz_C__EBizCustomerNameApi__c) && string.isNotEmpty(configurationObject.Ebiz_C__EBizCustomerNameApi__c) && configurationObject.Ebiz_C__EBizCustomerNameApi__c != null) {
                fieldsConfiguration.Name = string.valueOf(s.get(configurationObject.Ebiz_C__EBizCustomerNameApi__c));
            } else {
                fieldsConfiguration.Name = 'Customer' + '-' + customerId.right(5);
            }
            if (string.isNotBlank(configurationObject.Ebiz_C__EBizCustomerEmailApi__c) && string.isNotEmpty(configurationObject.Ebiz_C__EBizCustomerEmailApi__c) && configurationObject.Ebiz_C__EBizCustomerEmailApi__c != null) {
                fieldsConfiguration.Ebiz_C__EBizCharge_Email__c = string.valueOf(s.get(configurationObject.Ebiz_C__EBizCustomerEmailApi__c));
            } else {
                fieldsConfiguration.Ebiz_C__EBizCharge_Email__c = Configuration.EMPTYSTRING;
            }
            try {
                if (string.isNotBlank(configurationObject.Ebiz_C__EBizAmountApi__c) && string.isNotEmpty(configurationObject.Ebiz_C__EBizAmountApi__c) && configurationObject.Ebiz_C__EBizAmountApi__c != null) {
                    string TempField = string.valueOf(s.get(configurationObject.Ebiz_C__EBizAmountApi__c));
                    fieldsConfiguration.Ebiz_C__EBizCharge_Amount_Source__c = Decimal.valueOf(TempField);
                } else {
                    fieldsConfiguration.Ebiz_C__EBizCharge_Amount_Source__c = 0.0;
                }
            } catch (Exception e) {
                fieldsConfiguration.Ebiz_C__EBizCharge_Amount_Source__c = 0.0;
            }
        }
        ebcLogger.debug(ClassName, MethodName, 'fieldsConfiguration.Name>>>>' + fieldsConfiguration.Name);
        ebcLogger.debug(ClassName, MethodName, 'fieldsConfiguration.Email>>>>' + fieldsConfiguration.Ebiz_C__EBizCharge_Email__c);
        ebcLogger.debug(ClassName, MethodName, 'fieldsConfiguration.Amount>>>>' + fieldsConfiguration.Ebiz_C__EBizCharge_Amount__c);
        dml.upsertRecord(fieldsConfiguration, 'Ebiz_C__EBizCharge_Fields_Config__c.Ebiz_C__EBizCharge_CustomerId__c');
        return fieldsConfiguration;
    }
    public static ebizchargeServicemodelSoap.SalesOrder invoke_SearchOrder(DML dml, String customerId, String orderNumber, EBC_Logger ebcLogger) {
        MethodName = 'invoke_SearchOrder';
        ebizchargeServicemodelSoap.SalesOrder response = new ebizchargeServicemodelSoap.SalesOrder();
        try {
            response = ebiz.GetSalesOrder(getSecurityToken(dml, ebcLogger), customerId, Configuration.EMPTYSTRING, orderNumber, Configuration.EMPTYSTRING);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return response;
    }
    public static ebizchargeServicemodelSoap.SalesOrderResponse invoke_AddORUpdateOrder(DML dml, Order order, map < String, String > productsToUpdate, ebizchargeServicemodelSoap.SecurityToken securityToken, String action, EBC_Logger ebcLogger) {
        MethodName = 'invoke_AddORUpdateOrder';
        ebizchargeServicemodelSoap.SalesOrder salesOrder = new ebizchargeServicemodelSoap.SalesOrder();
         String querySelect = 'select id,QBD_Customer_ID__c';
        String queryFrom = 'from Account';
        String queryWere =  'where id=\''+order.AccountId+'\'';
        Account account =(Account)dml.selectSingleRecord(querySelect,queryFrom,queryWere,Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
        //salesOrder.CustomerId = order.AccountId;
        salesOrder.CustomerId = (string)account.get('QBD_Customer_ID__c');//For SF-Qbd
        salesOrder.SubCustomerId = null;
        salesOrder.SalesOrderNumber = order.OrderNumber;
        salesOrder.Amount = order.TotalAmount;
        salesOrder.AmountDue = order.TotalAmount;
        if (!test.isRunningTest()) {
            String ordCreatedDate = String.valueOf(order.CreatedDate);
            salesOrder.Date_x = String.valueOf(Datetime.valueOfGmt(ordCreatedDate.replace('T', ' ')));
        }
        salesOrder.DueDate = Configuration.EMPTYSTRING;
        salesOrder.TotalTaxAmount = 0;
        salesOrder.PoNum = order.PoNumber;
        salesOrder.NotifyCustomer = false;
        salesOrder.IsToBeEmailed = false;
        salesOrder.IsToBePrinted = false;
        salesOrder.Software = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        salesOrder.ShipDate = null;
        salesOrder.Items = null;
        EBizcharge_Setting__c ebizchargeSettings = getSettings(dml, ebcLogger);
        if (test.isRunningTest()) {
            ebizchargeSettings.Division_ID__c = '1111111';
        }
        if (ebizchargeSettings.Division_ID__c != null) {
            salesOrder.DivisionId = ebizchargeSettings.Division_ID__c;
        }
        ebizchargeServicemodelSoap.EbizCustomField ebizCustomField = new ebizchargeServicemodelSoap.EbizCustomField();
        ebizCustomField.FieldName = string.valueOf(Enums.FIELDNAMES.dateupdated);
        ebizCustomField.FieldValue = String.valueOfGmt(DateTime.now());
        ebizchargeServicemodelSoap.ArrayOfEbizCustomField customFields = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
        customFields.EbizCustomField = new List < ebizchargeServicemodelSoap.EbizCustomField > ();
        customFields.EbizCustomField.add(ebizCustomField);
        salesOrder.SalesOrderCustomFields = customFields;
        if (!test.isRunningTest()) {
            if (order.OrderItems != null) {
                ebizchargeServicemodelSoap.ArrayOfCustomItem items = new ebizchargeServicemodelSoap.ArrayOfCustomItem();
                ebizchargeServicemodelSoap.CustomItem[] customItems = new List < ebizchargeServicemodelSoap.CustomItem > ();
                for (OrderItem orderItem: order.OrderItems) {
                    ebizchargeServicemodelSoap.CustomItem item = new ebizchargeServicemodelSoap.CustomItem();
                    String productInternalId = productsToUpdate.get(orderItem.Product2Id);
                    ebcLogger.debug(ClassName, MethodName, 'productInternalId>>>' + productInternalId);
                    if (productInternalId != null && productInternalId != Configuration.EMPTYSTRING) {
                        item.ItemInternalId = productInternalId;
                        item.ItemId = orderItem.Product2Id;
                        item.Name = orderItem.product2.Name;
                        item.UnitPrice = orderItem.UnitPrice;
                        item.Qty = orderItem.Quantity;
                        item.Taxable = false;
                        item.Description = ((orderItem.product2.Description != null) ? orderItem.product2.Description : Configuration.EMPTYSTRING);
                        customItems.add(item);
                    }
                    items.Item = customItems;
                    salesOrder.Items = items;
                }
            }
        }
        ebizchargeServicemodelSoap.SalesOrderResponse orderResponse = new ebizchargeServicemodelSoap.SalesOrderResponse();
        try {
            if (action == string.valueOf(Enums.ENTITYACTIONS.addOrder)) {
                orderResponse = ebiz.AddSalesOrder(securityToken, salesOrder);
            } else {
                orderResponse = ebiz.UpdateSalesOrder(securityToken, salesOrder, order.AccountId, Configuration.EMPTYSTRING, order.OrderNumber, order.EBizCharge_Internal_ID__c);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            orderResponse.StatusCode = 0;
            orderResponse.Error = Configuration.EXCEPTIONSTRING + e.getMessage();
        }
        return orderResponse;
    }
    public static String updOrdersInSF(DML dml, map < String, String > ordersToUpdate, EBC_Logger ebcLogger) {
        MethodName = 'updOrdersInSF';
        List < Order > updateOrders = new List < Order > ();
        updateOrders = new List < Order > ();
        for (String key: ordersToUpdate.keySet()) {
            Order order = new Order();
            order.Id = key;
            order.EBizCharge_Internal_ID__c = ordersToUpdate.get(key);
            order.EBizCharge_Last_Sync_Date__c = system.now();
            updateOrders.add(order);
        }
        try {
            dml.updateRecord(updateOrders);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (DmlException e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    public static ebizchargeServicemodelSoap.ItemDetailsResponse invoke_addORUpdProduct(DML dml, Product2 product, ebizchargeServicemodelSoap.SecurityToken securityToken, string action, EBC_Logger ebcLogger) {
        MethodName = 'invoke_addORUpdProduct';
        ebizchargeServicemodelSoap.ItemDetails item = new ebizchargeServicemodelSoap.ItemDetails();
        item.ItemId = product.Id;
        item.Name = product.Name;
        item.SKU = product.ProductCode;
        item.Active = product.IsActive;
        item.Description = ((product.Description != null) ? product.Description : Configuration.EMPTYSTRING);
        item.UnitPrice = 0;
        item.UnitCost = 0;
        item.QtyOnHand = 0;
        item.Taxable = false;
        item.TaxRate = 0;
        item.SoftwareId = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        EBizcharge_Setting__c ebizchargeSettings = getSettings(dml, ebcLogger);
        if (test.isRunningTest()) {
            ebizchargeSettings.Division_ID__c = '1111111';
        }
        if (ebizchargeSettings.Division_ID__c != null) {
            item.DivisionId = ebizchargeSettings.Division_ID__c;
            item.ItemUniqueId = ebizchargeSettings.Division_ID__c;
        }
        ebizchargeServicemodelSoap.EbizCustomField ebizCustomField = new ebizchargeServicemodelSoap.EbizCustomField();
        ebizCustomField.FieldName = string.valueOf(Enums.FIELDNAMES.dateupdated);
        ebizCustomField.FieldValue = String.valueOfGmt(DateTime.now());
        ebizchargeServicemodelSoap.ArrayOfEbizCustomField customFields = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
        customFields.EbizCustomField = new List < ebizchargeServicemodelSoap.EbizCustomField > ();
        customFields.EbizCustomField.add(ebizCustomField);
        item.ItemCustomFields = customFields;
        ebizchargeServicemodelSoap.ItemDetailsResponse response = new ebizchargeServicemodelSoap.ItemDetailsResponse();
        try {
            if (action == string.valueOf(Enums.ENTITYACTIONS.updProduct)) {
                response = ebiz.UpdateItem(securityToken, item, product.EBizCharge_Internal_ID__c, product.Id);
            } else {
                response = ebiz.AddItem(securityToken, item);
            }
        } catch (Exception e) {
            response.StatusCode = 0;
            response.Error = Configuration.EXCEPTIONSTRING + e.getMessage();
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return response;
    }
    public static String updProductsInSF(DML dml, map < String, String > productsToUpdate, EBC_Logger ebcLogger) {
        MethodName = 'updProductsInSF';
        List < Product2 > updateProducts = new List < Product2 > ();
        updateProducts = new List < Product2 > ();
        for (String key: productsToUpdate.keySet()) {
            Product2 product = new Product2();
            product.Id = key;
            product.EBizCharge_Internal_ID__c = productsToUpdate.get(key);
            product.EBizCharge_Last_Sync_Date__c = system.now();
            updateProducts.add(product);
        }
        try {
            dml.updateRecord(updateProducts);
            return 'Success';
        } catch (DmlException e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    public static map < string, string > GetCustomerSavedPaymentMethods(DML dml, String accountID, String internalID, EBC_Logger ebcLogger) {
        MethodName = 'GetCustomerSavedPaymentMethods';
        map < String, String > paymentMethods = new map < String, String > ();
        string customerToken = getCustomerToken(dml, accountID, internalID, ebcLogger);
        if (string.isBlank(customerToken)) {
            return paymentMethods;
        }
        ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile paymentMethodProfileArray = new ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile();
        ebizchargeServicemodelSoap.PaymentMethodProfile[] paymentMethodProfiles;
        //if(!test.isRunningTest()){
        paymentMethodProfileArray = ebiz.GetCustomerPaymentMethodProfiles(getSecurityToken(dml, ebcLogger), customerToken);
        paymentMethodProfiles = paymentMethodProfileArray.PaymentMethodProfile;
        //}
        if (paymentMethodProfiles != null) {
            for (ebizchargeServicemodelSoap.PaymentMethodProfile paymentMethodProfile: paymentMethodProfiles) {
                if (paymentMethodProfile.CardNumber == null) {
                    string method = Configuration.EMPTYSTRING;
                    ebcLogger.debug(ClassName, MethodName, 'paymentMethodProfile.MethodName->>>>>>>>>>>' + paymentMethodProfile.MethodName);
                    if (!string.isEmpty(paymentMethodProfile.MethodName)) {
                        method = Configuration.APINAMESEPARATOR + paymentMethodProfile.MethodName;
                    }
                    paymentMethods.put(paymentMethodProfile.MethodID + Configuration.PAYMENTMETHODSEPARATOR, paymentMethodProfile.Routing + '^' + paymentMethodProfile.Account + method);
                } else {
                    string method = Configuration.EMPTYSTRING;
                    ebcLogger.debug(ClassName, MethodName, 'paymentMethodProfile.MethodName->>>>>>>>>>>' + paymentMethodProfile.MethodName);
                    if (!string.isEmpty(paymentMethodProfile.MethodName)) {
                        method = Configuration.APINAMESEPARATOR + paymentMethodProfile.MethodName;
                    }
                    string cardType = Configuration.EMPTYSTRING;
                    if (paymentMethodProfile.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.V)) {
                        cardType = string.valueOf(Enums.CARDTYPES.VISA);
                    } else if (paymentMethodProfile.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.M)) {
                        cardType = string.valueOf(Enums.CARDTYPES.MC);
                    } else if (paymentMethodProfile.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.A)) {
                        cardType = string.valueOf(Enums.CARDTYPES.AMEX);
                    } else if (paymentMethodProfile.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.DS)) {
                        cardType = string.valueOf(Enums.CARDTYPES.DISC);
                    }
                    paymentMethods.put(paymentMethodProfile.MethodID + Configuration.PAYMENTMETHODIDSEPARATOR, cardType + Configuration.CARDENDING + paymentMethodProfile.CardNumber.replace(string.valueOf(Enums.CARDCOMPARISONSTRINGS.X), Configuration.EMPTYSTRING) + method);
                }
            }
        }
        return paymentMethods;
    }
    public static ebizchargeServicemodelSoap.TransactionResponse runTransactionPayment(DML dml, transactionParams transactionParameters, Boolean sendReceiptTo, String email, string command, EBC_Logger ebcLogger) {
        MethodName = 'runTransactionPayment';
        String paymentMethodID = Configuration.EMPTYSTRING;
        paymentMethodID = transactionParameters.methodID;
        String accountID = transactionParameters.accountID;
        string customerToken = getCustomerToken(dml, accountID, transactionParameters.internalID, ebcLogger);
        ebizchargeServicemodelSoap.CustomerTransactionRequest transactionRequest = new ebizchargeServicemodelSoap.CustomerTransactionRequest();
        transactionRequest.isRecurring = transactionParameters.isRecurring;
        transactionRequest.IgnoreDuplicate = true;
        transactionRequest.Software = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        transactionRequest.MerchReceipt = false;
        //SAL-483
        transactionRequest.CustReceipt = false;
        transactionRequest.CardCode = transactionParameters.CardCode;
        transactionRequest.Command = command;
        transactionRequest.LineItems = transactionParameters.LineItems;
        transactionRequest.Details = getTransactionDetails(transactionParameters, ebcLogger);
        transactionRequest.LineItems = transactionParameters.LineItems;
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        if (!test.isRunningTest()) {
            response = ebiz.runCustomerTransaction(getSecurityToken(dml, ebcLogger), customerToken, paymentMethodID, transactionRequest);
        }
        String transactionRefNo = Configuration.EMPTYSTRING;
        if (test.isRunningTest()) {
            response.ResultCode = 'A';
        }
        if (response.ResultCode == string.valueOf(Enums.CARDCOMPARISONSTRINGS.A)) {
            transactionRefNo = response.RefNum;
            
            if (sendReceiptTo == true && (email != null && email != Configuration.EMPTYSTRING)) {
                //SAL-483
                ebizchargeServicemodelSoap.EmailReceiptResponse emailReceiptResponse = new ebizchargeServicemodelSoap.EmailReceiptResponse();
                emailReceiptResponse = ebiz.EmailReceipt(getSecurityToken(dml, ebcLogger), transactionRefNo, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, email);
                if (emailReceiptResponse.StatusCode == 1) {
                    ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent');
                } else {
                    ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent Error ');
                }
            }
        }
        return response;
    }
    public static ebizchargeServicemodelSoap.TransactionResponse runTransactionPaymentContact(DML dml, transactionParams transactionParameters, Boolean sendReceiptTo, String email, string command, EBC_Logger ebcLogger) {
        MethodName = 'runTransactionPaymentContact';
        String paymentMethodID = Configuration.EMPTYSTRING;
        paymentMethodID = transactionParameters.methodID;
        //SalesForce Account object id
        String accountID = transactionParameters.accountID;
        string customerToken = getCustomerToken(dml, accountID, transactionParameters.internalID, ebcLogger);
        ebizchargeServicemodelSoap.CustomerTransactionRequest transactionRequest = new ebizchargeServicemodelSoap.CustomerTransactionRequest();
        transactionRequest.isRecurring = transactionParameters.isRecurring;
        transactionRequest.IgnoreDuplicate = true;
        transactionRequest.Software = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        transactionRequest.MerchReceipt = false;
        //SAL-483
        transactionRequest.CustReceipt = false;
        transactionRequest.CardCode = transactionParameters.CardCode;
        transactionRequest.Command = command;
        transactionRequest.LineItems = transactionParameters.LineItems;
        transactionRequest.Details = getTransactionDetails(transactionParameters, ebcLogger);
        transactionRequest.LineItems = transactionParameters.LineItems;
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        if (!test.isRunningTest()) {
            response = ebiz.runCustomerTransaction(getSecurityToken(dml, ebcLogger), customerToken, paymentMethodID, transactionRequest);
        }
        String transactionRefNo = Configuration.EMPTYSTRING;
        if (test.isRunningTest()) {
            response.ResultCode = 'A';
        }
        if (response.ResultCode == string.valueOf(Enums.CARDCOMPARISONSTRINGS.A)) {
            transactionRefNo = response.RefNum;
            
            if (sendReceiptTo == true && (email != null && email != Configuration.EMPTYSTRING)) {
                //SAL-483
                ebizchargeServicemodelSoap.EmailReceiptResponse emailReceiptResponse = new ebizchargeServicemodelSoap.EmailReceiptResponse();
                emailReceiptResponse = ebiz.EmailReceipt(getSecurityToken(dml, ebcLogger), transactionRefNo, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, email);
                if (emailReceiptResponse.StatusCode == 1) {
                    ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent');
                } else {
                    ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent Error ');
                }
            }
        }
        return response;
    }
    public static ebizchargeServicemodelSoap.TransactionResponse runTransactionOnly(DML dml, transactionParams transactionParameters, Account account, Map < String, Object > mapProcessPayment, String command, EBC_Logger ebcLogger) {
        MethodName = 'runTransactionOnly';
        ebizchargeServicemodelSoap.TransactionRequestObject transactionRequest = new ebizchargeServicemodelSoap.TransactionRequestObject();
        String email = (string) mapProcessPayment.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.addEmails));
        Boolean sendReceiptTo = (boolean) mapProcessPayment.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
        String saleCommand = Configuration.EMPTYSTRING;
        string paymentMethodID = transactionParameters.methodID;
        transactionRequest.CustomerID = transactionParameters.customerId;
        if (paymentMethodID == Configuration.CARDMETHODID) {
            //'AuthOnly';
            saleCommand = string.valueOf(Enums.PAYMENTTYPES.Sale);
            transactionRequest.AccountHolder = transactionParameters.ccName;
            transactionRequest.CreditCardData = getCardData(transactionParameters, ebcLogger);
            Boolean saveCard = (boolean) mapProcessPayment.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
            if (saveCard == true) {
                paymentMethodID = addPaymentMethod(dml, transactionParameters, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                transactionParameters.methodID = paymentMethodID;
            }
        }
        if (paymentMethodID == Configuration.ACCOUNTMETHODID) {
            saleCommand = string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check);
            transactionRequest.AccountHolder = transactionParameters.AccountName;
            transactionRequest.CheckData = getCheckData(transactionParameters, ebcLogger);
            Boolean saveACH = (boolean) mapProcessPayment.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH));
            if (saveACH == true) {
                paymentMethodID = addPaymentMethod(dml, transactionParameters, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH), ebcLogger);
                transactionParameters.methodID = paymentMethodID;
            }
        }
        transactionRequest.BillingAddress = getBillingAddress(account, ebcLogger);
        transactionRequest.ShippingAddress = getShippingAddress(account, ebcLogger);
        transactionRequest.isRecurring = false;
        transactionRequest.IgnoreDuplicate = true;
        transactionRequest.Software = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        //SAL-483
        transactionRequest.CustReceipt = false;
        transactionRequest.Command = saleCommand;
        transactionRequest.Details = getTransactionDetails(transactionParameters, ebcLogger);
        transactionRequest.LineItems = transactionParameters.LineItems;
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        ebizchargeServicemodelSoap.SecurityToken securityToken = getSecurityToken(dml, ebcLogger);
        response = ebiz.runTransaction(securityToken, transactionRequest);
        String transactionRefNo = Configuration.EMPTYSTRING;
        if (response.ResultCode == string.valueOf(Enums.CARDCOMPARISONSTRINGS.A)) {
            transactionRefNo = response.RefNum;
            
            if (test.isRunningTest()) {
                sendReceiptTo = true;
                email = 'abc@sc.com';
            }
            if (sendReceiptTo == true && (email != null && email != Configuration.EMPTYSTRING)) {
                //SAL-483
                ebizchargeServicemodelSoap.EmailReceiptResponse emailReceiptResponse = new ebizchargeServicemodelSoap.EmailReceiptResponse();
                emailReceiptResponse = ebiz.EmailReceipt(securityToken, transactionRefNo, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, email);
                if (emailReceiptResponse.StatusCode == 1) {
                    ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent');
                } else {
                    ebcLogger.debug(ClassName, MethodName, 'EmailSent>>>Email Sent Error ');
                }
            }
        }
        return response;
    }
    public static ebizchargeServicemodelSoap.TransactionResponse runTransactionOnlyAccountTab(DML dml, transactionParams transactionParameters, Account account, Map < String, Object > mapProcessPayment, String paymentMethod, EBC_Logger ebcLogger) {
        MethodName = 'runTransactionOnlyAccountTab';
        ebizchargeServicemodelSoap.TransactionRequestObject transactionRequest = new ebizchargeServicemodelSoap.TransactionRequestObject();
        String saleCommand = Configuration.EMPTYSTRING;
        string paymentMethodID = transactionParameters.methodID;
        transactionRequest.CustomerID = transactionParameters.customerId;
        if (test.isRunningTest()) {
            paymentMethodID = '1';
        }
        if (paymentMethodID == Configuration.CARDMETHODID) {
            //'AuthOnly';
            saleCommand = string.valueOf(Enums.PAYMENTTYPES.Sale);
            transactionRequest.AccountHolder = transactionParameters.ccName;
            transactionRequest.CreditCardData = getCardData(transactionParameters, ebcLogger);
            Boolean saveCard = (boolean) mapProcessPayment.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
            if (test.isRunningTest()) {
                saveCard = true;
            }
            if (saveCard == true) {
                paymentMethodID = paymentMethod;
                transactionParameters.methodID = paymentMethodID;
            }
        }
        if (test.isRunningTest()) {
            paymentMethodID = '2';
        }
        if (paymentMethodID == Configuration.ACCOUNTMETHODID) {
            saleCommand = string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check);
            transactionRequest.AccountHolder = transactionParameters.AccountName;
            transactionRequest.CheckData = getCheckData(transactionParameters, ebcLogger);
            Boolean saveACH = (boolean) mapProcessPayment.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH));
            if (saveACH == true) {
                paymentMethodID = paymentMethod;
                transactionParameters.methodID = paymentMethodID;
            }
        }
        transactionRequest.BillingAddress = getBillingAddress(account, ebcLogger);
        transactionRequest.ShippingAddress = getShippingAddress(account, ebcLogger);
        transactionRequest.isRecurring = false;
        transactionRequest.IgnoreDuplicate = true;
        transactionRequest.Software = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        //SAL-483
        transactionRequest.CustReceipt = false;
        transactionRequest.Command = saleCommand;
        transactionRequest.Details = getTransactionDetails(transactionParameters, ebcLogger);
        transactionRequest.LineItems = transactionParameters.LineItems;
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        ebizchargeServicemodelSoap.SecurityToken securityToken = getSecurityToken(dml, ebcLogger);
        response = ebiz.runTransaction(securityToken, transactionRequest);
        return response;
    }
    public static ebizchargeServicemodelSoap.TransactionResponse runTransactionOnlyContact(DML dml, transactionParams transactionParameters, Contact contact, Map < String, Object > mapProcessPayment, EBC_Logger ebcLogger) {
        MethodName = 'runTransactionOnlyContact';
        ebizchargeServicemodelSoap.TransactionRequestObject transactionRequest = new ebizchargeServicemodelSoap.TransactionRequestObject();
        String saleCommand = Configuration.EMPTYSTRING;
        string paymentMethodID = transactionParameters.methodID;
        transactionRequest.CustomerID = transactionParameters.customerId;
        if (test.isRunningTest()) {
            paymentMethodID = '1';
        }
        if (paymentMethodID == Configuration.CARDMETHODID) {
            //'AuthOnly';
            saleCommand = string.valueOf(Enums.PAYMENTTYPES.Sale);
            transactionRequest.AccountHolder = transactionParameters.ccName;
            transactionRequest.CreditCardData = getCardData(transactionParameters, ebcLogger);
            Boolean saveCard = (boolean) mapProcessPayment.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
            if (test.isRunningTest()) {
                saveCard = true;
            }
            if (saveCard == true) {
                paymentMethodID = addPaymentMethod(dml, transactionParameters, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                transactionParameters.methodID = paymentMethodID;
            }
        }
        if (test.isRunningTest()) {
            paymentMethodID = '2';
        }
        if (paymentMethodID == Configuration.ACCOUNTMETHODID) {
            saleCommand = string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check);
            transactionRequest.AccountHolder = transactionParameters.AccountName;
            transactionRequest.CheckData = getCheckData(transactionParameters, ebcLogger);
            Boolean saveACH = (boolean) mapProcessPayment.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH));
            if (saveACH == true) {
                paymentMethodID = addPaymentMethod(dml, transactionParameters, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH), ebcLogger);
                transactionParameters.methodID = paymentMethodID;
            }
        }
        transactionRequest.BillingAddress = getBillingAddressContact(contact, ebcLogger);
        transactionRequest.ShippingAddress = getShippingAddressContact(contact, ebcLogger);
        transactionRequest.isRecurring = false;
        transactionRequest.IgnoreDuplicate = true;
        transactionRequest.Software = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        transactionRequest.CustReceipt = (boolean) mapProcessPayment.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
        transactionRequest.Command = saleCommand;
        transactionRequest.Details = getTransactionDetails(transactionParameters, ebcLogger);
        transactionRequest.LineItems = transactionParameters.LineItems;
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        ebizchargeServicemodelSoap.SecurityToken securityToken = getSecurityToken(dml, ebcLogger);
        response = ebiz.runTransaction(securityToken, transactionRequest);
        return response;
    }
    public static ebizchargeServicemodelSoap.TransactionResponse runTransactionOnlyContactTab(DML dml, transactionParams transactionParameters, Contact contact, Map < String, Object > mapProcessPayment, String methodId, EBC_Logger ebcLogger) {
        MethodName = 'runTransactionOnlyContactTab';
        ebizchargeServicemodelSoap.TransactionRequestObject transactionRequest = new ebizchargeServicemodelSoap.TransactionRequestObject();
        String saleCommand = Configuration.EMPTYSTRING;
        string paymentMethodID = transactionParameters.methodID;
        transactionRequest.CustomerID = transactionParameters.customerId;
        if (test.isRunningTest()) {
            paymentMethodID = '1';
        }
        if (paymentMethodID == Configuration.CARDMETHODID) {
            //'AuthOnly';
            saleCommand = string.valueOf(Enums.PAYMENTTYPES.Sale);
            transactionRequest.AccountHolder = transactionParameters.ccName;
            transactionRequest.CreditCardData = getCardData(transactionParameters, ebcLogger);
            Boolean saveCard = (boolean) mapProcessPayment.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
            if (test.isRunningTest()) {
                saveCard = true;
            }
            if (saveCard == true) {
                paymentMethodID = methodId;
                transactionParameters.methodID = paymentMethodID;
            }
        }
        if (test.isRunningTest()) {
            paymentMethodID = '2';
        }
        if (paymentMethodID == Configuration.ACCOUNTMETHODID) {
            saleCommand = string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check);
            transactionRequest.AccountHolder = transactionParameters.AccountName;
            transactionRequest.CheckData = getCheckData(transactionParameters, ebcLogger);
            Boolean saveACH = (boolean) mapProcessPayment.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH));
            if (saveACH == true) {
                paymentMethodID = methodId;
                transactionParameters.methodID = paymentMethodID;
            }
        }
        transactionRequest.BillingAddress = getBillingAddressContact(contact, ebcLogger);
        transactionRequest.ShippingAddress = getShippingAddressContact(contact, ebcLogger);
        transactionRequest.isRecurring = false;
        transactionRequest.IgnoreDuplicate = true;
        transactionRequest.Software = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        //SAL-483
        transactionRequest.CustReceipt = false;
        transactionRequest.Command = saleCommand;
        transactionRequest.Details = getTransactionDetails(transactionParameters, ebcLogger);
        transactionRequest.LineItems = transactionParameters.LineItems;
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        ebizchargeServicemodelSoap.SecurityToken securityToken = getSecurityToken(dml, ebcLogger);
        response = ebiz.runTransaction(securityToken, transactionRequest);
        return response;
    }
    public static string runRecurringPayment(DML dml, transactionParams transactionParameters, Boolean sendReceiptTo, String recurringIntenalId, String action, String emailRecipients, EBC_Logger ebcLogger) {
        MethodName = 'runRecurringPayment';
        ebizchargeServicemodelSoap.RecurringBilling recurringBilling = new ebizchargeServicemodelSoap.RecurringBilling();
        recurringBilling.Amount = transactionParameters.Amount + transactionParameters.Tax;
        recurringBilling.Tax = transactionParameters.Tax;
        recurringBilling.Enabled = true;
        recurringBilling.Start = transactionParameters.Start;
        recurringBilling.Expire = transactionParameters.Expire;
        recurringBilling.ScheduleName = transactionParameters.ScheduleName;
        recurringBilling.Schedule = transactionParameters.Schedule;
        recurringBilling.Next = transactionParameters.Expire;
        recurringBilling.RepeatCount = 1;
        recurringBilling.ReceiptNote = transactionParameters.Notes;
        recurringBilling.SendCustomerReceipt = sendReceiptTo;
        recurringBilling.CustomerEmailList = emailRecipients;
        string recurringResponse = Configuration.EMPTYSTRING;
        try {
            if (action == Configuration.UPDATEACTION) {
                ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentResponse modifyRecurringResponse = new ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentResponse();
                ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentResponse modifyPaymentProfile = new ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentResponse();
                modifyRecurringResponse = ebiz.ModifyScheduledRecurringPayment_RecurringBilling(getSecurityToken(dml, ebcLogger), recurringIntenalId, recurringBilling);
                modifyPaymentProfile = ebiz.ModifyScheduledRecurringPayment_PaymentMethodProfile(getSecurityToken(dml, ebcLogger), recurringIntenalId, transactionParameters.methodID);
                recurringResponse = modifyRecurringResponse.Status;
            } else {
                recurringResponse = ebiz.ScheduleRecurringPayment(getSecurityToken(dml, ebcLogger), transactionParameters.internalID, transactionParameters.methodID, recurringBilling);
            }
        } catch (CalloutException e) {
            recurringResponse = e.getMessage();
        }
        return recurringResponse;
    }
    public static string updateRRScheduledPaymentStatus(DML dml, String recurringIntenalId, Integer scheduleStatus, EBC_Logger ebcLogger) {
        MethodName = 'updateRRScheduledPaymentStatus';
        ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatusResponse response = new ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatusResponse();
        response = ebiz.ModifyScheduledRecurringPaymentStatus(getSecurityToken(dml, ebcLogger), recurringIntenalId, scheduleStatus);
        return string.valueOf(Enums.RETURNMESSAGE.statusUpdated);
    }
    public static string saveStatusTransactionResponse(DML dml, ebizchargeServicemodelSoap.TransactionResponse transactionResponse, String orderNumber, string paymentMethodID, decimal paymentStatus, EBC_Logger ebcLogger) {
        MethodName = 'saveStatusTransactionResponse';
        EBizCharge_Transaction__c transactionToSave = new EBizCharge_Transaction__c();
        transactionToSave.Order_Id__c = orderNumber;
        transactionToSave.Customer_Number__c = transactionResponse.CustNum;
        transactionToSave.Result_Code__c = transactionResponse.ResultCode;
        transactionToSave.Result__c = transactionResponse.Result;
        transactionToSave.Remaining_Balance__c = transactionResponse.RemainingBalance;
        transactionToSave.Ref_Number__c = transactionResponse.RefNum;
        transactionToSave.Profiler_Reason__c = transactionResponse.ProfilerReason;
        transactionToSave.Profiler_Response__c = transactionResponse.ProfilerResponse;
        transactionToSave.Profiler_Score__c = transactionResponse.ProfilerScore;
        transactionToSave.Payload__c = transactionResponse.Payload;
        transactionToSave.isDuplicate__c = transactionResponse.isDuplicate;
        transactionToSave.Error_Code__c = transactionResponse.ErrorCode;
        transactionToSave.Error__c = transactionResponse.Error;
        transactionToSave.Vpas_Result_Code__c = transactionResponse.VpasResultCode;
        transactionToSave.Converted_Amount_Currency__c = double.valueOf(transactionResponse.ConvertedAmountCurrency);
        transactionToSave.Converted_Amount__c = transactionResponse.ConvertedAmount;
        transactionToSave.Conversion_Rate__c = transactionResponse.ConversionRate;
        transactionToSave.Card_Code_Result_Code__c = transactionResponse.CardLevelResultCode;
        transactionToSave.Card_Level_Result__c = transactionResponse.CardLevelResult;
        transactionToSave.Card_Code_Result_Code__c = transactionResponse.CardCodeResultCode;
        transactionToSave.Card_Code_Result__c = transactionResponse.CardCodeResult;
        transactionToSave.Batch_Ref_Number__c = transactionResponse.BatchRefNum;
        transactionToSave.Batch_Number__c = transactionResponse.BatchNum;
        transactionToSave.Avs_Result_Code__c = transactionResponse.AvsResultCode;
        transactionToSave.Avs_Result__c = transactionResponse.AvsResult;
        transactionToSave.Auth_Code__c = transactionResponse.AuthCode;
        transactionToSave.Auth_Amount__c = transactionResponse.AuthAmount;
        transactionToSave.Acs_Url__c = transactionResponse.AcsUrl;
        transactionToSave.Status__c = transactionResponse.Status;
        transactionToSave.Status_Code__c = transactionResponse.StatusCode;
        dml.insertRecord(transactionToSave);
        return transactionToSave.Ref_Number__c;
    }
    public static string addPaymentMethod(DML dml, transactionParams transactionParameters, string methodType, EBC_Logger ebcLogger) {
        MethodName = 'addPaymentMethod';
        ebizchargeServicemodelSoap.PaymentMethodProfile paymentMethod = new ebizchargeServicemodelSoap.PaymentMethodProfile();
        paymentMethod.MethodType = methodType;
        paymentMethod.SecondarySort = Configuration.CARDMETHODID;
        paymentMethod.Created = system.Date.today();
        paymentMethod.Modified = system.Date.today();
        if (methodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard)) {
            paymentMethod.CardNumber = transactionParameters.ccNumber;
            paymentMethod.CardExpiration = transactionParameters.expMonth + transactionParameters.expYear;
            paymentMethod.CardCode = transactionParameters.cvvCode;
            paymentMethod.AccountHolderName = transactionParameters.ccName;
            paymentMethod.MethodName = transactionParameters.MethodName;
            paymentMethod.AvsStreet = transactionParameters.AvsStreet;
            paymentMethod.AvsZip = transactionParameters.AvsZip;
        }
        if (methodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH)) {
            paymentMethod.AccountHolderName = transactionParameters.AccountName;
            paymentMethod.Account = transactionParameters.Account;
            paymentMethod.AccountType = transactionParameters.accountType;
            paymentMethod.Routing = transactionParameters.Route;
            paymentMethod.MethodName = transactionParameters.MethodName;
        }
        string methodID = ebiz.AddCustomerPaymentMethodProfile(getSecurityToken(dml, ebcLogger), transactionParameters.internalID, paymentMethod);
        return methodID;
    }
    public static ebizchargeServicemodelSoap.TransactionDetail getTransactionDetails(transactionParams transactionParameters, EBC_Logger ebcLogger) {
        MethodName = 'getTransactionDetails';
        ebizchargeServicemodelSoap.TransactionDetail transactionDetail = new ebizchargeServicemodelSoap.TransactionDetail();
        ebcLogger.debug(ClassName, MethodName, 'transactionParameters.accountID:' + transactionParameters.accountID);
        ebcLogger.debug(ClassName, MethodName, 'transactionParameters.customerId:' + transactionParameters.customerId);
        ebcLogger.debug(ClassName, MethodName, 'transactionParameters.OrderId:' + transactionParameters.OrderId);
        if (transactionParameters.OrderId != null && transactionParameters.OrderId != Configuration.DEFAULTORDERNUMBER) {
            transactionDetail.OrderID = transactionParameters.OrderId;
            transactionDetail.Invoice = transactionParameters.OrderNumber;
        } else if (transactionParameters.accountID == null) {
            transactionDetail.OrderID = transactionParameters.customerId;
            transactionDetail.Invoice = transactionParameters.customerId;
        } else {
            transactionDetail.OrderID = transactionParameters.accountID;
            transactionDetail.Invoice = transactionParameters.accountID;
        }
        transactionDetail.PONum = transactionParameters.PoNum;
        transactionDetail.Terminal = transactionParameters.Terminal;
        transactionDetail.NonTax = false;
        transactionDetail.Tax = transactionParameters.Tax;
        transactionDetail.Subtotal = transactionParameters.SubTotal;
        transactionDetail.Shipping = 0;
        transactionDetail.Duty = 0;
        transactionDetail.Discount = 0;
        transactionDetail.Tip = 0;
        transactionDetail.Amount = transactionParameters.Amount;
        transactionDetail.AllowPartialAuth = false;
        transactionDetail.Clerk = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        transactionDetail.Description = 'Order Processed from Salesforce Order Component';
        return transactionDetail;
    }
    public static ebizchargeServicemodelSoap.GwAddress getBillingAddress(Account account, EBC_Logger ebcLogger) {
        MethodName = 'getBillingAddress';
        ebizchargeServicemodelSoap.GwAddress billingAddress = new ebizchargeServicemodelSoap.GwAddress();
        billingAddress.City = account.BillingCity;
        billingAddress.Company = Configuration.EMPTYSTRING;
        billingAddress.Country = Configuration.EMPTYSTRING;
        //billingAddress.Email = account.EBizCharge_Email__c;
        billingAddress.Email = (String)account.get('Email__c');//For SF-Qbd
        billingAddress.Fax = Configuration.EMPTYSTRING;
        billingAddress.FirstName = account.First_Name__c;
        billingAddress.LastName = account.Last_Name__c;
        billingAddress.Phone = Configuration.EMPTYSTRING;
        billingAddress.State = account.BillingState;
        billingAddress.Street = account.BillingStreet;
        billingAddress.Street2 = Configuration.EMPTYSTRING;
        billingAddress.Zip = account.BillingPostalCode;
        return billingAddress;
    }
    public static ebizchargeServicemodelSoap.GwAddress getBillingAddressContact(Contact contact, EBC_Logger ebcLogger) {
        MethodName = 'getBillingAddressContact';
        ebizchargeServicemodelSoap.GwAddress billingAddress = new ebizchargeServicemodelSoap.GwAddress();
        billingAddress.City = contact.OtherCity;
        billingAddress.Company = Configuration.EMPTYSTRING;
        billingAddress.Country = Configuration.EMPTYSTRING;
        billingAddress.Email = contact.Email;
        billingAddress.Fax = Configuration.EMPTYSTRING;
        billingAddress.FirstName = contact.FirstName;
        billingAddress.LastName = contact.LastName;
        billingAddress.Phone = Configuration.EMPTYSTRING;
        billingAddress.State = contact.OtherState;
        billingAddress.Street = contact.OtherStreet;
        billingAddress.Street2 = Configuration.EMPTYSTRING;
        billingAddress.Zip = contact.OtherPostalCode;
        return billingAddress;
    }
    public static ebizchargeServicemodelSoap.GwAddress getShippingAddress(Account account, EBC_Logger ebcLogger) {
        MethodName = 'getShippingAddress';
        ebizchargeServicemodelSoap.GwAddress shippingAddress = new ebizchargeServicemodelSoap.GwAddress();
        shippingAddress.City = account.ShippingCity;
        shippingAddress.Company = Configuration.EMPTYSTRING;
        shippingAddress.Country = Configuration.EMPTYSTRING;
        //shippingAddress.Email = account.EBizCharge_Email__c;
        shippingAddress.Email = (String)account.get('Email__c');
        shippingAddress.Fax = Configuration.EMPTYSTRING;
        shippingAddress.FirstName = account.First_Name__c;
        shippingAddress.LastName = account.Last_Name__c;
        shippingAddress.Phone = account.Phone;
        shippingAddress.State = account.ShippingState;
        shippingAddress.Street = account.ShippingStreet;
        shippingAddress.Street2 = Configuration.EMPTYSTRING;
        shippingAddress.Zip = account.ShippingPostalCode;
        return shippingAddress;
    }
    public static ebizchargeServicemodelSoap.GwAddress getShippingAddressContact(Contact contact, EBC_Logger ebcLogger) {
        MethodName = 'getShippingAddressContact';
        ebizchargeServicemodelSoap.GwAddress shippingAddress = new ebizchargeServicemodelSoap.GwAddress();
        shippingAddress.City = contact.MailingCity;
        shippingAddress.Company = Configuration.EMPTYSTRING;
        shippingAddress.Country = Configuration.EMPTYSTRING;
        shippingAddress.Email = contact.Email;
        shippingAddress.Fax = Configuration.EMPTYSTRING;
        shippingAddress.FirstName = contact.FirstName;
        shippingAddress.LastName = contact.LastName;
        shippingAddress.Phone = contact.Phone;
        shippingAddress.State = contact.MailingState;
        shippingAddress.Street = contact.MailingStreet;
        shippingAddress.Street2 = Configuration.EMPTYSTRING;
        shippingAddress.Zip = contact.MailingPostalCode;
        return shippingAddress;
    }
    public static ebizchargeServicemodelSoap.CreditCardData getCardData(transactionParams transactionParameters, EBC_Logger ebcLogger) {
        MethodName = 'getCardData';
        ebizchargeServicemodelSoap.CreditCardData creditCardData = new ebizchargeServicemodelSoap.CreditCardData();
        creditCardData.Pares = Configuration.EMPTYSTRING;
        creditCardData.MagSupport = Configuration.EMPTYSTRING;
        creditCardData.MagStripe = Configuration.EMPTYSTRING;
        creditCardData.ECI = Configuration.EMPTYSTRING;
        creditCardData.DUKPT = Configuration.EMPTYSTRING;
        creditCardData.XID = Configuration.EMPTYSTRING;
        creditCardData.Signature = Configuration.EMPTYSTRING;
        creditCardData.TermType = Configuration.EMPTYSTRING;
        creditCardData.CardPresent = false;
        creditCardData.AvsZip = transactionParameters.AvsZip;
        creditCardData.AvsStreet = transactionParameters.AvsStreet;
        creditCardData.CardNumber = transactionParameters.ccNumber;
        creditCardData.CardCode = transactionParameters.cvvCode;
        creditCardData.CAVV = transactionParameters.cvvCode;
        creditCardData.CardExpiration = transactionParameters.expMonth + transactionParameters.expYear;
        creditCardData.InternalCardAuth = false;
        return creditCardData;
    }
    public static void markCustomCustomerPaidEmailPay(DML dml, string customCustomerId, String referenceNumber, Decimal amount, EBC_Logger ebcLogger) {
        MethodName = 'markCustomCustomerPaidEmailPay';
        
        Id customerId = customCustomerId;
        String sObjName = customerId.getSObjectType().getDescribe().getName();
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        string fields = Configuration.EMPTYSTRING;
        querySelect = 'SELECT id,Ebiz_C__EBizCustomerNameApi__c,Ebiz_C__EBizCustomerEmailApi__c,Ebiz_C__EBizAmountApi__c,Ebiz_C__EBizReferenceContactApi__c,Ebiz_C__EBizReceivedAmountApi__c,Ebiz_C__EBizReferenceAccountApi__c';
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
        if (string.isNotBlank(configurationObject.Ebiz_C__EBizReceivedAmountApi__c) && string.isNotEmpty(configurationObject.Ebiz_C__EBizReceivedAmountApi__c) && configurationObject.Ebiz_C__EBizReceivedAmountApi__c != null) {
            fields += configurationObject.Ebiz_C__EBizReceivedAmountApi__c + Configuration.APINAMESEPARATOR;
        } else {
            fields += Configuration.EMPTYSTRING;
        }
        if (string.isNotBlank(configurationObject.Ebiz_C__EBizReferenceContactApi__c) && string.isNotBlank(configurationObject.Ebiz_C__EBizReferenceContactApi__c) && configurationObject.Ebiz_C__EBizReferenceContactApi__c != null) {
            fields += configurationObject.Ebiz_C__EBizReferenceContactApi__c + Configuration.APINAMESEPARATOR;
        } else {
            fields += Configuration.EMPTYSTRING;
        }
        querySelect = 'SELECT id,' + fields + string.valueOf(Enums.FIELDNAMES.createddate);
        queryFrom = 'FROM '  + sObjName + Configuration.EMPTYSTRING;
        queryWhere = 'where id =\'' + String.escapeSingleQuotes(customCustomerId) + '\'';
        List < sObject > customObjects = (List < sObject >)dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        for (sObject sObjectEntity: customObjects) {
            if(sObjectEntity != null){
                if (configurationObject.Ebiz_C__EBizReceivedAmountApi__c != null && string.isNotBlank(configurationObject.Ebiz_C__EBizReceivedAmountApi__c) && string.isNotEmpty(configurationObject.Ebiz_C__EBizReceivedAmountApi__c)) {
                    string amountFieldValue = string.valueOf(sObjectEntity.get(configurationObject.Ebiz_C__EBizReceivedAmountApi__c));
                    if(amountFieldValue == null){
                        amountFieldValue = Configuration.ZEROSTRING;
                    }
                    Decimal totalAmount = decimal.valueOf(amountFieldValue) + amount;
                    sObjectEntity.put(configurationObject.Ebiz_C__EBizReceivedAmountApi__c , totalAmount);
                    dml.updateRecord(sObjectEntity);
                 }
            }
            EBizCharge_Transaction__c transactionToSave = new EBizCharge_Transaction__c();
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Ref_Number__c.isCreateable()) {
                transactionToSave.Ref_Number__c = referenceNumber;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Detail_Amount__c.isCreateable()) {
                transactionToSave.Detail_Amount__c = amount;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.isCreateable()) {
                dml.insertRecord(transactionToSave);
            }
        }
    }
    public static ebizchargeServicemodelSoap.CheckData getCheckData(transactionParams transactionParameters, EBC_Logger ebcLogger) {
        MethodName = 'getCheckData';
        ebizchargeServicemodelSoap.CheckData checkData = new ebizchargeServicemodelSoap.CheckData();
        checkData.Account = transactionParameters.Account;
        checkData.AccountType = transactionParameters.accountType;
        checkData.CheckNumber = transactionParameters.Account;
        checkData.DriversLicense = 'xxxxx';
        checkData.DriversLicenseState = 'xx';
        checkData.RecordType = Configuration.EMPTYSTRING;
        checkData.Routing = transactionParameters.Route;
        checkData.MICR = Configuration.EMPTYSTRING;
        checkData.AuxOnUS = Configuration.EMPTYSTRING;
        checkData.EpcCode = Configuration.EMPTYSTRING;
        checkData.FrontImage = Configuration.EMPTYSTRING;
        checkData.BackImage = Configuration.EMPTYSTRING;
        return checkData;
    }
    public Static String sendReceiptToCustomer(DML dml, String ReferenceNo, String sendTo, EBC_Logger ebcLogger) {
        MethodName = 'sendReceiptToCustomer';
        //SAL-483
        ebizchargeServicemodelSoap.EmailReceiptResponse emailReceiptResponse = new ebizchargeServicemodelSoap.EmailReceiptResponse();
        emailReceiptResponse = ebiz.EmailReceipt(getSecurityToken(dml, ebcLogger), ReferenceNo, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, sendTo);
        return null;
    }
    public static void sendEmailbyGW(DML dml, Boolean sendReceiptTo, String email, String transactionRefNo, EBC_Logger ebcLogger) {
        MethodName = 'sendEmailbyGW';
        ebizchargeServicemodelSoap.SecurityToken securityToken = getSecurityToken(dml, ebcLogger);
        //SAL-483
        ebizchargeServicemodelSoap.EmailReceiptResponse emailReceiptResponse = new ebizchargeServicemodelSoap.EmailReceiptResponse();
        emailReceiptResponse = ebiz.EmailReceipt(securityToken, transactionRefNo, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, email);
        if (emailReceiptResponse.StatusCode == 1) {
            ebcLogger.debug(ClassName, MethodName, 'Email Sent ');
        } else {
            ebcLogger.debug(ClassName, MethodName, 'Email Sent Error ');
        }
    }
    public static ebizchargeServicemodelSoap.TransactionResponse runAVSCheck(DML dml, Map < String, Object > dataMap, EBC_Logger ebcLogger) {
        MethodName = 'runAVSCheck';
        Boolean isAVSMatched = true;
        string accountId = (string) dataMap.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.AccountId));
        string AccExternalId = (string) dataMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.AccInternalId));
        String saleCommand = string.valueOf(Enums.PAYMENTTYPES.AuthOnly);
        ebizchargeServicemodelSoap.MerchantTransactionData response;
        response = ebiz.GetMerchantTransactionData(eBc_UtilityController.getSecurityToken(dml, ebcLogger));
        Double amount = (double) dataMap.get(string.valueOf(Enums.FIELDNAMES.Amount));
        Double tax = (double) dataMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Tax));
        transactionParams transactionParameters = new transactionParams();
        transactionParameters.accountID = accountId;
        transactionParameters.customerId = accountId;
        transactionParameters.internalID = AccExternalId;
        transactionParameters.SubTotal = 0;
        transactionParameters.Amount = 0.05;
        transactionParameters.Tax = 0;
        transactionParameters.isRecurring = false;
        transactionParameters.SoftwareId = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        transactionParameters.methodID = Configuration.CARDMETHODID;
        transactionParameters.ccNumber = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
        transactionParameters.expMonth = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
        transactionParameters.expYear = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
        transactionParameters.cvvCode = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
        transactionParameters.ccName = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
        transactionParameters.AvsZip = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
        transactionParameters.AvsStreet = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
        ebizchargeServicemodelSoap.TransactionRequestObject transactionRequest = new ebizchargeServicemodelSoap.TransactionRequestObject();
        transactionRequest.AccountHolder = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
        transactionRequest.CreditCardData = getCardData(transactionParameters, ebcLogger);
        transactionRequest.BillingAddress = null;
        transactionRequest.ShippingAddress = null;
        transactionRequest.isRecurring = false;
        transactionRequest.IgnoreDuplicate = true;
        transactionRequest.Software = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        transactionRequest.CustReceipt = false;
        transactionRequest.Command = saleCommand;
        transactionRequest.Details = getTransactionDetails(transactionParameters, ebcLogger);
        ebizchargeServicemodelSoap.TransactionResponse result = new ebizchargeServicemodelSoap.TransactionResponse();
        result = ebiz.runTransaction(getSecurityToken(dml, ebcLogger), transactionRequest);
        return result;
    }
    public static ebizchargeServicemodelSoap.TransactionResponse runAVSCheckContact(DML dml, Map < String, Object > dataMap, EBC_Logger ebcLogger) {
        MethodName = 'runAVSCheckContact';
        Boolean isAVSMatched = true;
        string ConId = (string) dataMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ConId));
        string ConExternalId = (string) dataMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ConExternalId));
        String saleCommand = string.valueOf(Enums.PAYMENTTYPES.AuthOnly);
        ebcLogger.debug(ClassName, MethodName, '>>>ConExternalId>>>>>>>>>>>>>>' + ConExternalId);
        transactionParams transactionParameters = new transactionParams();
        transactionParameters.accountID = ConId;
        transactionParameters.customerId = ConId;
        transactionParameters.internalID = ConExternalId;
        transactionParameters.SubTotal = 0;
        ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
        responseMerchant = ebiz.GetMerchantTransactionData(getSecurityToken(dml, ebcLogger));
        string paymentType = (string) dataMap.get('paymentType');
        double amount = (double) dataMap.get(string.valueOf(Enums.FIELDNAMES.Amount));
        double tax = (double) dataMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Tax));
        transactionParameters.Amount = 0.05;
        transactionParameters.Tax = 0;
        transactionParameters.isRecurring = false;
        transactionParameters.SoftwareId = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        transactionParameters.methodID = Configuration.CARDMETHODID;
        transactionParameters.ccNumber = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
        transactionParameters.expMonth = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
        transactionParameters.expYear = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
        transactionParameters.cvvCode = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
        transactionParameters.ccName = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
        transactionParameters.AvsZip = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
        transactionParameters.AvsStreet = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
        ebizchargeServicemodelSoap.TransactionRequestObject transactionRequest = new ebizchargeServicemodelSoap.TransactionRequestObject();
        transactionRequest.AccountHolder = (String) dataMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
        transactionRequest.CreditCardData = getCardData(transactionParameters, ebcLogger);
        transactionRequest.BillingAddress = null;
        transactionRequest.ShippingAddress = null;
        transactionRequest.isRecurring = false;
        transactionRequest.IgnoreDuplicate = true;
        transactionRequest.Software = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
        transactionRequest.CustReceipt = false;
        transactionRequest.Command = saleCommand;
        transactionRequest.Details = getTransactionDetails(transactionParameters, ebcLogger);
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        response = ebiz.runTransaction(getSecurityToken(dml, ebcLogger), transactionRequest);
        return response;
    }
    public static list < ebizchargeServicemodelSoap.Payment > searchPendingPayments(DML dml, date startDate, date endDate, EBC_Logger ebcLogger) {
        MethodName = 'searchPendingPayments';
        ebizchargeServicemodelSoap.ArrayOfPayment paymentsArray = new ebizchargeServicemodelSoap.ArrayOfPayment();
        list < ebizchargeServicemodelSoap.Payment > payments = new list < ebizchargeServicemodelSoap.Payment > ();
        paymentsArray = ebiz.SearchEbizWebFormPendingPayments(getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, startDate, endDate, null, 0, 100, Configuration.CARDMETHODID);
        payments = paymentsArray.Payment;
        return payments;
    }
    public static list < ebizchargeServicemodelSoap.Payment > searchPendingPaymentsCustomer(DML dml, date startDate, date endDate, String customerId, ebizchargeServicemodelSoap.ArrayOfSearchFilter filters, EBC_Logger ebcLogger) {
        MethodName = 'searchPendingPaymentsCustomer';
        ebizchargeServicemodelSoap.ArrayOfPayment paymentsArray = new ebizchargeServicemodelSoap.ArrayOfPayment();
        list < ebizchargeServicemodelSoap.Payment > payments = new list < ebizchargeServicemodelSoap.Payment > ();
        paymentsArray = ebiz.SearchEbizWebFormPendingPayments(getSecurityToken(dml, ebcLogger), customerId, startDate, endDate, filters, 0, 100, Configuration.CARDMETHODID);
        payments = paymentsArray.Payment;
        return payments;
    }
    public static ebizchargeServicemodelSoap.PaymentResponse removeEbizWebFormPayment(DML dml, string paymentInternalID, EBC_Logger ebcLogger) {
        MethodName = 'removeEbizWebFormPayment';
        ebizchargeServicemodelSoap.PaymentResponse response = ebiz.DeleteEbizWebFormPayment(getSecurityToken(dml, ebcLogger), paymentInternalID);
        return response;
    }
    public static string ResendEbizWebFormEmail(DML dml, string paymentInternalID, EBC_Logger ebcLogger) {
        MethodName = 'ResendEbizWebFormEmail';
        string response = ebiz.ResendEbizWebFormEmail(getSecurityToken(dml, ebcLogger), paymentInternalID);
        return response;
    }
    public static ebizchargeServicemodelSoap.PaymentResponse MarkEbizWebFormPaymentAsApplied(DML dml, string paymentInternalID, EBC_Logger ebcLogger) {
        MethodName = 'MarkEbizWebFormPaymentAsApplied';
        ebizchargeServicemodelSoap.PaymentResponse response = ebiz.MarkEbizWebFormPaymentAsApplied(getSecurityToken(dml, ebcLogger), paymentInternalID);
        return response;
    }
    public static ebizchargeServicemodelSoap.PaymentResponse MarkEbizPaymentAsApplied(DML dml, String invoiceNumber, string paymentInternalID, EBC_Logger ebcLogger) {
        MethodName = 'MarkEbizPaymentAsApplied';
        ebizchargeServicemodelSoap.PaymentResponse response = ebiz.MarkPaymentAsApplied(getSecurityToken(dml, ebcLogger), invoiceNumber, paymentInternalID);
        return response;
    }
    public static ebizchargeServicemodelSoap.PaymentResponse MarkRecurringPaymentAsApplied(DML dml, string paymentInternalID, EBC_Logger ebcLogger) {
        MethodName = 'MarkRecurringPaymentAsApplied';
        ebizchargeServicemodelSoap.PaymentResponse response = ebiz.MarkRecurringPaymentAsApplied(getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, paymentInternalID);
        return response;
    }
    public static void markAccountPaid(DML dml, string accountId, String referenceNumber, Decimal Amount, EBC_Logger ebcLogger) {
        MethodName = 'markAccountPaid';
        String querySelect = 'SELECT Id,EBizCharge_Amount__c,EBizCharge_Reference_Number__c,QBD_Customer_ID__c';
        String queryFrom = 'FROM Account';
        String queryWhere = 'where Id =\'' + accountId + '\'';
        Account account = (Account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        if (account.EBizCharge_Amount__c != null) {
            account.EBizCharge_Amount__c = account.EBizCharge_Amount__c + Amount;
        } else {
            account.EBizCharge_Amount__c = Amount;
        }
        account.EBizCharge_Reference_Number__c = referenceNumber;
        dml.updateRecord(account);
    }
    public static void updateAccountId(DML dml, string accountId, string internalID, EBC_Logger ebcLogger) {
        MethodName = 'updateAccountId';
        String querySelect = 'SELECT Id';
        String queryFrom = 'FROM Account';
        String queryWhere = 'where Id =\'' + accountId + '\'';
        Account account = (Account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        account.Ebiz_C__EBizCharge_Internal_ID__c = internalID;
        dml.updateRecord(account);
    }
    public static void markContactPaid(DML dml, string contactId, String referenceNumber, Decimal Amount, EBC_Logger ebcLogger) {
        MethodName = 'markContactPaid';
        String querySelect = 'SELECT Id,Ebiz_C__EBizCharge_Contact_Amount__c ,Ebiz_C__EBizCharge_Contact_Reference_Number__c';
        String queryFrom = 'FROM Contact';
        String queryWhere = 'where Id =\'' + contactId + '\'';
        Contact contact = (Contact) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        contact.Ebiz_C__EBizCharge_Contact_Amount__c = contact.Ebiz_C__EBizCharge_Contact_Amount__c + Amount;
        contact.Ebiz_C__EBizCharge_Contact_Reference_Number__c = referenceNumber;
        dml.updateRecord(contact);
    }
    public static void markCustomCustomerPaid(DML dml, string contactId, String referenceNumber, Decimal Amount, EBC_Logger ebcLogger) {
        MethodName = 'markCustomCustomerPaid';
        String querySelect = 'SELECT Id,Ebiz_C__EBizCharge_Amount__c  ,Ebiz_C__EBizCharge_Reference_Number__c';
        String queryFrom = 'FROM Ebiz_C__EBizCharge_Fields_Config__c';
        String queryWhere = 'where Ebiz_C__EBizCharge_CustomerId__c =\'' + contactId + '\'';
        Ebiz_C__EBizCharge_Fields_Config__c contact = (Ebiz_C__EBizCharge_Fields_Config__c) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        contact.Ebiz_C__EBizCharge_Amount__c = contact.Ebiz_C__EBizCharge_Amount__c + Amount;
        contact.Ebiz_C__EBizCharge_Reference_Number__c = referenceNumber;
        dml.updateRecord(contact);
    }
    public static void markOrderPaid(DML dml, string orderId, string referenceNumber, double paidAmount, ebizchargeServicemodelSoap.TransactionObject transactionObject, String paymentMethodID, String expiryYear, String expiryMonth, EBC_Logger ebcLogger) {
        MethodName = 'markOrderPaid';
        String DivisionId = Configuration.EMPTYSTRING;
        EBizcharge_Setting__c ebizchargeSettings = getSettings(dml, ebcLogger);
        if (test.isRunningTest()) {
            ebizchargeSettings.Division_ID__c = '1111111';
        }
        if (ebizchargeSettings.Division_ID__c != null) {
            DivisionId = ebizchargeSettings.Division_ID__c;
        }
        ebizchargeServicemodelSoap.TransactionDetail transactionDetail = new ebizchargeServicemodelSoap.TransactionDetail();
        transactionDetail = transactionObject.Details;
        Double shipping = (Double) transactionDetail.Shipping;
        ebizchargeServicemodelSoap.ApplicationTransactionResponse transactionResponse = new ebizchargeServicemodelSoap.ApplicationTransactionResponse();
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        ebcLogger.debug(ClassName, MethodName, 'OrderId:' + orderId);
        ebcLogger.debug(ClassName, MethodName, 'referenceNumber:' + referenceNumber);
        ebcLogger.debug(ClassName, MethodName, 'PaidAmount:' + paidAmount);
        id findType = (id) orderId;
        Schema.SObjectType token = findType.getSObjectType();
        Schema.DescribeSObjectResult schemaDescription = token.getDescribe();
        if (schemaDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
            querySelect = 'SELECT Id,EBizCharge_Internal_ID__c,Account.EBizCharge_Internal_ID__c,AccountId,TotalAmount,EBizCharge_Order_Balance__c,EBizCharge_Amount__c, EBizCharge_Order_Tax__c,EBizCharge_Captured_Amount__c';
            queryFrom = 'FROM Order';
            queryWhere = 'where Id =\'' + orderId + '\'';
            Order order = (Order) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            double OrderAmount = order.TotalAmount == null ? 0 : order.TotalAmount;
            double eBizAmount = order.EBizCharge_Captured_Amount__c == null ? 0 : order.EBizCharge_Captured_Amount__c;
            double orderBalance = order.EBizCharge_Order_Balance__c == null ? 0 : order.EBizCharge_Order_Balance__c;
            Order ordertoUpdate = new Order();
            ordertoUpdate.Id = orderId;
            ordertoUpdate.EBizCharge_Payment_Status__c = Configuration.PAIDBYEMAILSTATUS;
            ordertoUpdate.EBizCharge_Order_Status__c = string.valueOf(Enums.ENTITYSTATUS.Unpaid);
            ordertoUpdate.EBizCharge_Reference_Number__c = referenceNumber;
            ordertoUpdate.EBizCharge_Captured_Amount__c = (eBizAmount == null ? 0 : eBizAmount) + paidAmount;
            if (orderBalance != null && orderBalance != 0) {
                ordertoUpdate.EBizCharge_Order_Balance__c = orderBalance - shipping;
            }
            ordertoUpdate.EBizCharge_Order_Balance__c = ordertoUpdate.EBizCharge_Order_Balance__c <= 0 ? 0 : ordertoUpdate.EBizCharge_Order_Balance__c;
            if (ordertoUpdate.EBizCharge_Order_Balance__c == 0) {
                ordertoUpdate.EBizCharge_Order_Status__c = string.valueOf(Enums.ENTITYSTATUS.Paid);
            }
            if (paidAmount != shipping) {
                if (ordertoUpdate.EBizCharge_Order_Tax__c != null && ordertoUpdate.EBizCharge_Order_Tax__c != 0) {
                    ordertoUpdate.EBizCharge_Order_Tax__c = ordertoUpdate.EBizCharge_Order_Tax__c + transactionDetail.Tax;
                } else {
                    ordertoUpdate.EBizCharge_Order_Tax__c = transactionDetail.Tax;
                }
            }
            transactionResponse = EBC_CompMethods.CreateApplicationTransaction(dml, ordertoUpdate.Account.EBizCharge_Internal_ID__c, referenceNumber, string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order), orderId, ordertoUpdate.EBizCharge_Internal_ID__c, string.valueOf(Enums.PAYMENTTYPES.Sale), divisionId, expiryYear, expiryMonth, paymentMethodID, ebcLogger);
            dml.updateRecord(ordertoUpdate);
            EBizCharge_Transaction__c transactionToSave = new EBizCharge_Transaction__c();
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Order_Id__c.isCreateable()) {
                transactionToSave.Order_Id__c = orderId;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Account_Id__c.isCreateable()) {
                transactionToSave.Account_Id__c = order.AccountId;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Ref_Number__c.isCreateable()) {
                transactionToSave.Ref_Number__c = referenceNumber;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Detail_Amount__c.isCreateable()) {
                transactionToSave.Detail_Amount__c = transactionDetail.Amount;
            }
            if (shipping != paidAmount) {
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.EBizCharge_Subtotal__c.isCreateable()) {
                    transactionToSave.EBizCharge_Subtotal__c = shipping;
                }
            } else {
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.EBizCharge_Subtotal__c.isCreateable()) {
                    transactionToSave.EBizCharge_Subtotal__c = 0;
                }
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Transaction_Type__c.isCreateable()) {
                transactionToSave.Transaction_Type__c = transactionObject.TransactionType;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Invoice__c.isCreateable()) {
                transactionToSave.Invoice__c = transactionDetail.Invoice;
            }
            if (shipping == paidAmount) {
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Tax__c.isCreateable()) {
                    transactionToSave.Tax__c = 0;
                }
            } else {
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Tax__c.isCreateable()) {
                    transactionToSave.Tax__c = transactionDetail.Tax;
                }
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.isCreateable()) {
                dml.insertRecord(transactionToSave);
            }
            getTransactionDetailGW(transactionToSave.Id, referenceNumber);
        } else if (schemaDescription.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote)) {
            querySelect = 'SELECT Id,Account.EBizCharge_Internal_ID__c,EBizCharge_Internal_ID__c,AccountId,GrandTotal,EBizCharge_Quote_Balance__c,EBizCharge_Amount__c, EBizCharge_Quote_Tax_c__c,EBizCharge_Captured_Amount__c';
            queryFrom = 'FROM Quote';
            queryWhere = 'where Id =\'' + orderId + '\'';
            Quote quote = (Quote) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            double QuoteAmount = quote.GrandTotal == null ? 0 : quote.GrandTotal;
            double eBizAmount = quote.EBizCharge_Captured_Amount__c == null ? 0 : quote.EBizCharge_Captured_Amount__c;
            double QuoteBalance = quote.EBizCharge_Quote_Balance__c == null ? 0 : quote.EBizCharge_Quote_Balance__c;
            ebcLogger.debug(ClassName, MethodName, 'quote.EBizCharge_Quote_Tax_c__c:' + quote.EBizCharge_Quote_Tax_c__c);
            Quote quotetoUpdate = new Quote();
            quotetoUpdate.Id = orderId;
            quotetoUpdate.EBizCharge_Payment_Status__c = Configuration.PAIDBYEMAILSTATUS;
            quotetoUpdate.EBizCharge_Quote_Status__c = string.valueOf(Enums.ENTITYSTATUS.Unpaid);
            quotetoUpdate.EBizCharge_Reference_Number__c = referenceNumber;
            quotetoUpdate.EBizCharge_Captured_Amount__c = (eBizAmount == null ? 0 : eBizAmount) + paidAmount;
            if (QuoteBalance != null && QuoteBalance != 0) {
                quotetoUpdate.EBizCharge_Quote_Balance__c = QuoteBalance - shipping;
            }
            quotetoUpdate.EBizCharge_Quote_Balance__c = quotetoUpdate.EBizCharge_Quote_Balance__c <= 0 ? 0 : quotetoUpdate.EBizCharge_Quote_Balance__c;
            if (quotetoUpdate.EBizCharge_Quote_Balance__c == 0) {
                quotetoUpdate.EBizCharge_Quote_Status__c = string.valueOf(Enums.ENTITYSTATUS.Paid);
            }
            if (paidAmount != shipping) {
                if (quote.EBizCharge_Quote_Tax_c__c != null && quote.EBizCharge_Quote_Tax_c__c != 0) {
                    quotetoUpdate.EBizCharge_Quote_Tax_c__c = quote.EBizCharge_Quote_Tax_c__c + transactionDetail.Tax;
                } else {
                    quotetoUpdate.EBizCharge_Quote_Tax_c__c = transactionDetail.Tax;
                }
            }
            transactionResponse = EBC_CompMethods.CreateApplicationTransaction(dml, quote.Account.EBizCharge_Internal_ID__c, referenceNumber, string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote), orderId, quote.EBizCharge_Internal_ID__c, string.valueOf(Enums.PAYMENTTYPES.Sale), divisionId, expiryYear, expiryMonth, paymentMethodID, ebcLogger);
            dml.updateRecord(quotetoUpdate);
            EBizCharge_Transaction__c transactionToSave = new EBizCharge_Transaction__c();
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Quote_Id__c.isCreateable()) {
                transactionToSave.Quote_Id__c = orderId;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Account_Id__c.isCreateable()) {
                transactionToSave.Account_Id__c = quote.AccountId;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Ref_Number__c.isCreateable()) {
                transactionToSave.Ref_Number__c = referenceNumber;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Detail_Amount__c.isCreateable()) {
                transactionToSave.Detail_Amount__c = transactionDetail.Amount;
            }
            if (shipping != paidAmount) {
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.EBizCharge_Subtotal__c.isCreateable()) {
                    transactionToSave.EBizCharge_Subtotal__c = shipping;
                }
            } else {
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.EBizCharge_Subtotal__c.isCreateable()) {
                    transactionToSave.EBizCharge_Subtotal__c = 0;
                }
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Transaction_Type__c.isCreateable()) {
                transactionToSave.Transaction_Type__c = transactionObject.TransactionType;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Invoice__c.isCreateable()) {
                transactionToSave.Invoice__c = transactionDetail.Invoice;
            }
            if (shipping == paidAmount) {
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Tax__c.isCreateable()) {
                    transactionToSave.Tax__c = 0;
                }
            } else {
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Tax__c.isCreateable()) {
                    transactionToSave.Tax__c = transactionDetail.Tax;
                }
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.isCreateable()) {
                dml.insertRecord(transactionToSave);
            }
            getTransactionDetailGW(transactionToSave.Id, referenceNumber);
        } else {
            querySelect = 'SELECT Id,EBizCharge_Internal_ID__c,Account.EBizCharge_Internal_ID__c,Ebiz_C__EBizCharge_Amount__c ,AccountId';
            queryFrom = 'FROM Opportunity';
            queryWhere = 'where Id =\'' + orderId + '\'';
            Opportunity opportunity = (Opportunity) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            Opportunity opportunityToUpdate = new Opportunity();
            opportunityToUpdate.id = opportunity.id;
            opportunityToUpdate.EBizCharge_Reference_Number__c = referenceNumber;
            transactionResponse = EBC_CompMethods.CreateApplicationTransaction(dml, opportunity.Account.EBizCharge_Internal_ID__c, referenceNumber, 'Opportunity', orderId, opportunity.EBizCharge_Internal_ID__c, string.valueOf(Enums.PAYMENTTYPES.Sale), divisionId, expiryYear, expiryMonth, paymentMethodID, ebcLogger);
            dml.updateRecord(opportunityToUpdate);
            querySelect = 'SELECT Id,Ebiz_C__EBizCharge_Amount__c ,Ebiz_C__EBizCharge_Reference_Number__c,EBizCharge_Account_Tax__c';
            queryFrom = 'from Account';
            queryWhere = 'where id =\'' + opportunity.AccountId + '\'';
            Account account = (Account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            account.EBizCharge_Amount__c = (account.Ebiz_C__EBizCharge_Amount__c == null ? 0 : account.Ebiz_C__EBizCharge_Amount__c) + paidAmount;
            if (paidAmount != shipping) {
                if (account.EBizCharge_Account_Tax__c != null && account.EBizCharge_Account_Tax__c != 0) {
                    account.EBizCharge_Account_Tax__c = account.EBizCharge_Account_Tax__c + transactionDetail.Tax;
                } else {
                    account.EBizCharge_Account_Tax__c = transactionDetail.Tax;
                }
            }
            dml.updateRecord(account);
            ebcLogger.debug(ClassName, MethodName, 'Ebiz_C__EBizCharge_Reference_Number__c>>>>>' + account.Ebiz_C__EBizCharge_Reference_Number__c);
            EBizCharge_Transaction__c transactionToSave = new EBizCharge_Transaction__c();
            transactionToSave.Opportunity_Id__c = opportunityToUpdate.id;
            transactionToSave.Account_Id__c = account.id;
            transactionToSave.Ref_Number__c = referenceNumber;
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Detail_Amount__c.isCreateable()) {
                transactionToSave.Detail_Amount__c = transactionDetail.Amount;
            }
            if (shipping != paidAmount) {
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.EBizCharge_Subtotal__c.isCreateable()) {
                    transactionToSave.EBizCharge_Subtotal__c = shipping;
                }
            } else {
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.EBizCharge_Subtotal__c.isCreateable()) {
                    transactionToSave.EBizCharge_Subtotal__c = 0;
                }
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Transaction_Type__c.isCreateable()) {
                transactionToSave.Transaction_Type__c = transactionObject.TransactionType;
            }
            if (shipping == paidAmount) {
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Tax__c.isCreateable()) {
                    transactionToSave.Tax__c = 0;
                }
            } else {
                if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Tax__c.isCreateable()) {
                    transactionToSave.Tax__c = transactionDetail.Tax;
                }
            }
            dml.insertRecord(transactionToSave);
            getTransactionDetailGW(transactionToSave.Id, referenceNumber);
        }
    }
    public static void saveTransaction(DML dml, String referenceNumber, EBizCharge_Transaction__c transactionToSave, EBC_Logger ebcLogger) {
        MethodName = 'saveTransaction';
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.TransactionObject transactionRequest = new ebizchargeServicemodelSoap.TransactionObject();
        transactionRequest = ebiz.GetTransactionDetails(getSecurityToken(dml, ebcLogger), referenceNumber);
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Ref_Number__c.isCreateable()) {
            transactionToSave.Ref_Number__c = referenceNumber;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.CreatedDateTime__c.isCreateable()) {
            transactionToSave.CreatedDateTime__c = dateTime.valueOf(transactionRequest.DateTime_x);
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Status__c.isCreateable()) {
            transactionToSave.Status__c = transactionRequest.Status;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Transaction_Type__c.isCreateable()) {
            transactionToSave.Transaction_Type__c = transactionRequest.TransactionType;
        }
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        response = transactionRequest.Response;
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Customer_Number__c.isCreateable()) {
            transactionToSave.Customer_Number__c = response.CustNum;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Result_Code__c.isCreateable()) {
            transactionToSave.Result_Code__c = response.ResultCode;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Result__c.isCreateable()) {
            transactionToSave.Result__c = response.Result;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Error_Code__c.isCreateable()) {
            transactionToSave.Error_Code__c = response.ErrorCode;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Error__c.isCreateable()) {
            transactionToSave.Error__c = response.Error;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Code_Result_Code__c.isCreateable()) {
            transactionToSave.Card_Code_Result_Code__c = response.CardCodeResultCode;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Code_Result__c.isCreateable()) {
            transactionToSave.Card_Code_Result__c = response.CardCodeResult;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Batch_Ref_Number__c.isCreateable()) {
            transactionToSave.Batch_Ref_Number__c = response.BatchRefNum;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Batch_Number__c.isCreateable()) {
            transactionToSave.Batch_Number__c = response.BatchNum;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Avs_Result_Code__c.isCreateable()) {
            transactionToSave.Avs_Result_Code__c = response.AvsResultCode;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Avs_Result__c.isCreateable()) {
            transactionToSave.Avs_Result__c = response.AvsResult;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Auth_Code__c.isCreateable()) {
            transactionToSave.Auth_Code__c = response.AuthCode;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Auth_Amount__c.isCreateable()) {
            transactionToSave.Auth_Amount__c = response.AuthAmount;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Response_Status__c.isCreateable()) {
            transactionToSave.Response_Status__c = response.Status;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Response_Status_Code__c.isCreateable()) {
            transactionToSave.Response_Status_Code__c = response.StatusCode;
        }
        ebizchargeServicemodelSoap.TransactionDetail transactionDetail = new ebizchargeServicemodelSoap.TransactionDetail();
        transactionDetail = transactionRequest.Details;
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Non_Tax__c.isCreateable()) {
            transactionToSave.Non_Tax__c = transactionDetail.NonTax;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Tax__c.isCreateable()) {
            transactionToSave.Tax__c = transactionDetail.Tax;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Ship_From_Zip__c.isCreateable()) {
            transactionToSave.Ship_From_Zip__c = transactionDetail.ShipFromZip;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.PONum__c.isCreateable()) {
            transactionToSave.PONum__c = transactionDetail.PONum;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Invoice__c.isCreateable()) {
            transactionToSave.Invoice__c = transactionDetail.Invoice;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Description__c.isCreateable()) {
            transactionToSave.Description__c = transactionDetail.Description;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Detail_Amount__c.isCreateable()) {
            transactionToSave.Detail_Amount__c = transactionDetail.Amount;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.EBizCharge_Subtotal__c.isCreateable()) {
            transactionToSave.EBizCharge_Subtotal__c = transactionDetail.Subtotal;
        }
        ebizchargeServicemodelSoap.CreditCardData creditCardData = new ebizchargeServicemodelSoap.CreditCardData();
        creditCardData = transactionRequest.CreditCardData;
        if (test.isRunningTest()) {
            creditCardData.CardNumber = '122222222';
        }
        if (creditCardData.CardNumber != null) {
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Number__c.isCreateable()) {
                transactionToSave.Card_Number__c = creditCardData.CardNumber;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Last_X_Digit__c.isCreateable()) {
                transactionToSave.Last_X_Digit__c = (creditCardData.CardNumber).right(4);
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Type__c.isCreateable()) {
                transactionToSave.Card_Type__c = creditCardData.CardType;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Present__c.isCreateable()) {
                transactionToSave.Card_Present__c = true;
            }
        } else {
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Present__c.isCreateable()) {
                transactionToSave.Card_Present__c = false;
            }
        }
        ebizchargeServicemodelSoap.CheckData checkData = new ebizchargeServicemodelSoap.CheckData();
        checkData = transactionRequest.CheckData;
        if (checkData != null) {
            if (checkData.Account != null) {
                transactionToSave.Last_X_Digit__c = (checkData.Account).right(4);
                transactionToSave.Card_Type__c = string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH);
            }
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Avs_Zip__c.isCreateable()) {
            transactionToSave.Avs_Zip__c = creditCardData.AvsZip;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Avs_Street__c.isCreateable()) {
            transactionToSave.Avs_Street__c = creditCardData.AvsStreet;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.isCreateable()) {
            dml.insertRecord(transactionToSave);
        }
    }
    @future(callout = true)
    public static void getTransactionDetailGW(String transactionId, String referenceNumber) {
        MethodName = 'getTransactionDetailGW';
        DML dml = new DML();
        EBC_Logger ebcLogger = new EBC_Logger();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.TransactionObject transactionRequest = new ebizchargeServicemodelSoap.TransactionObject();
        transactionRequest = ebiz.GetTransactionDetails(EBC_CompMethods.getSecurityToken(dml, ebcLogger), referenceNumber);
        EBizCharge_Transaction__c transactionToSave = new EBizCharge_Transaction__c();
        transactionToSave.Id = transactionId;
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Status__c.isUpdateable()) {
            transactionToSave.Status__c = transactionRequest.Status;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Transaction_Type__c.isUpdateable()) {
            transactionToSave.Transaction_Type__c = transactionRequest.TransactionType;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.CreatedDateTime__c.isUpdateable()) {
            transactionToSave.CreatedDateTime__c = dateTime.valueOf(transactionRequest.DateTime_x);
        }
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        response = transactionRequest.Response;
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Customer_Number__c.isUpdateable()) {
            transactionToSave.Customer_Number__c = response.CustNum;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Result_Code__c.isUpdateable()) {
            transactionToSave.Result_Code__c = response.ResultCode;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Result__c.isUpdateable()) {
            transactionToSave.Result__c = response.Result;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Error_Code__c.isUpdateable()) {
            transactionToSave.Error_Code__c = response.ErrorCode;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Error__c.isUpdateable()) {
            transactionToSave.Error__c = response.Error;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Code_Result_Code__c.isUpdateable()) {
            transactionToSave.Card_Code_Result_Code__c = response.CardCodeResultCode;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Code_Result__c.isUpdateable()) {
            transactionToSave.Card_Code_Result__c = response.CardCodeResult;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Batch_Ref_Number__c.isUpdateable()) {
            transactionToSave.Batch_Ref_Number__c = response.BatchRefNum;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Batch_Number__c.isUpdateable()) {
            transactionToSave.Batch_Number__c = response.BatchNum;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Avs_Result_Code__c.isUpdateable()) {
            transactionToSave.Avs_Result_Code__c = response.AvsResultCode;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Avs_Result__c.isUpdateable()) {
            transactionToSave.Avs_Result__c = response.AvsResult;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Auth_Code__c.isUpdateable()) {
            transactionToSave.Auth_Code__c = response.AuthCode;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Auth_Amount__c.isUpdateable()) {
            transactionToSave.Auth_Amount__c = response.AuthAmount;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Response_Status__c.isUpdateable()) {
            transactionToSave.Response_Status__c = response.Status;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Response_Status_Code__c.isUpdateable()) {
            transactionToSave.Response_Status_Code__c = response.StatusCode;
        }
        ebizchargeServicemodelSoap.TransactionDetail transactionDetail = new ebizchargeServicemodelSoap.TransactionDetail();
        transactionDetail = transactionRequest.Details;
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Non_Tax__c.isUpdateable()) {
            transactionToSave.Non_Tax__c = transactionDetail.NonTax;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Tax__c.isUpdateable()) {
            transactionToSave.Tax__c = transactionDetail.Tax;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Ship_From_Zip__c.isUpdateable()) {
            transactionToSave.Ship_From_Zip__c = transactionDetail.ShipFromZip;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.PONum__c.isUpdateable()) {
            transactionToSave.PONum__c = transactionDetail.PONum;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Invoice__c.isUpdateable()) {
            transactionToSave.Invoice__c = transactionDetail.Invoice;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Description__c.isUpdateable()) {
            transactionToSave.Description__c = transactionDetail.Description;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Detail_Amount__c.isUpdateable()) {
            transactionToSave.Detail_Amount__c = transactionDetail.Amount;
        }
        ebizchargeServicemodelSoap.CreditCardData creditCardData = new ebizchargeServicemodelSoap.CreditCardData();
        creditCardData = transactionRequest.CreditCardData;
        if (test.isRunningTest()) {
            creditCardData.CardNumber = '122222222';
        }
        if (creditCardData.CardNumber != null) {
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Number__c.isUpdateable()) {
                transactionToSave.Card_Number__c = creditCardData.CardNumber;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Last_X_Digit__c.isUpdateable()) {
                transactionToSave.Last_X_Digit__c = (creditCardData.CardNumber).right(4);
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Type__c.isUpdateable()) {
                transactionToSave.Card_Type__c = creditCardData.CardType;
            }
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Present__c.isUpdateable()) {
                transactionToSave.Card_Present__c = true;
            }
        } else {
            if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Card_Present__c.isUpdateable()) {
                transactionToSave.Card_Present__c = false;
            }
        }
        ebizchargeServicemodelSoap.CheckData checkData = new ebizchargeServicemodelSoap.CheckData();
        checkData = transactionRequest.CheckData;
        if (checkData != null) {
            if (checkData.Account != null) {
                transactionToSave.Last_X_Digit__c = (checkData.Account).right(4);
                transactionToSave.Card_Type__c = string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH);
            }
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Avs_Zip__c.isUpdateable()) {
            transactionToSave.Avs_Zip__c = creditCardData.AvsZip;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.fields.Avs_Street__c.isUpdateable()) {
            transactionToSave.Avs_Street__c = creditCardData.AvsStreet;
        }
        if (Schema.sObjectType.EBizCharge_Transaction__c.isUpdateable()) {
            if (!Test.isRunningTest()) {
                dml.updateRecord(transactionToSave);
            }
        }
    }
    public static List < Product2 > getProductsDetail(DML dml, list < Id > productIds, EBC_Logger ebcLogger) {
        MethodName = 'getProductsDetail';
        list < String > ProdIdsStr = new list < String > ();
        for (Integer i = 0; i < productIds.size(); i++) {
            ProdIdsStr.add(productIds[i]);
        }
        String querySelect = 'SELECT Id,Name,IsActive,ProductCode,Description,EBizCharge_Internal_ID__c';
        String queryFrom = 'FROM Product2';
        String queryWhere = 'WHERE Id IN :';
        List < Product2 > prodList = (List < Product2 > ) dml.selectRecordsInList(ProdIdsStr, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        return prodList;
    }
    public static Order getOrderDetail(DML dml, String orderId, EBC_Logger ebcLogger) {
        MethodName = 'getOrderDetail';
        String querySelect = 'SELECT Id,Name,OrderNumber,CreatedDate,TotalAmount,EndDate,EffectiveDate,PoNumber,PoDate,ContractId,Status,' + 'ActivatedDate,Description,' + 'EBizCharge_Internal_ID__c,EBizCharge_Order_Status__c,EBizCharge_Payment_Status__c,EBizCharge_Last_Sync_Date__c,  ' + 'AccountId,Account.Name,Account.First_Name__c,Account.Last_Name__c,Account.Email__c,Account.EBizCharge_Internal_ID__c,Account.EBizCharge_Need_to_Sync__c,' + 'Account.EBizCharge_Amount__c,Account.EBizCharge_Last_Sync_Date__c,Account.EBizCharge_Reference_Number__c,' + 'BillingAddress,BillingStreet, BillingPostalCode, BillingCity, BillingCountry, BillingState,' + 'ShippingAddress,ShippingCity, ShippingState, ShippingStreet, ShippingPostalCode, ShippingCountry,' + '(SELECT Id,product2Id,product2.Name,product2.ProductCode,UnitPrice,Quantity,OrderId,Product2.Description,' + 'Product2.EBizCharge_Internal_ID__c,Product2.EBizCharge_Last_Sync_Date__c FROM OrderItems)';
        String queryFrom = 'FROM Order';
        String queryWhere = 'WHERE Id = \'' + OrderId + '\'';
        return (Order) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
    }
    public static List < Order > getOrdersDetail(DML dml, List < String > orderNumbers, EBC_Logger ebcLogger) {
        MethodName = 'getOrdersDetail';
        List < Order > ordList = new List < Order > ();
        try {
            for (Integer i = 0; i < orderNumbers.size(); i++) {
                orderNumbers[i] = orderNumbers[i];
            }
            String querySelect = 'SELECT Id,Name,OrderNumber,CreatedDate,TotalAmount,EndDate,EffectiveDate,PoNumber,PoDate,ContractId,Status,' + 'ActivatedDate,Description,' + 'EBizCharge_Internal_ID__c,EBizCharge_Order_Status__c,EBizCharge_Payment_Status__c,EBizCharge_Last_Sync_Date__c,  ' + 'AccountId,Account.Name,Account.First_Name__c,Account.Last_Name__c,Account.Email__c,Account.EBizCharge_Internal_ID__c,Account.EBizCharge_Need_to_Sync__c,' + 'Account.EBizCharge_Amount__c,Account.EBizCharge_Last_Sync_Date__c,Account.EBizCharge_Reference_Number__c,' + 'BillingAddress,BillingStreet, BillingPostalCode, BillingCity, BillingCountry, BillingState,' + 'ShippingAddress,ShippingCity, ShippingState, ShippingStreet, ShippingPostalCode, ShippingCountry,' + '(SELECT Id,product2Id,product2.Name,product2.ProductCode,UnitPrice,Quantity,OrderId,Product2.Description,' + 'Product2.EBizCharge_Internal_ID__c,Product2.EBizCharge_Last_Sync_Date__c FROM OrderItems)';
            String queryFrom = 'FROM Order';
            String queryWhere = 'WHERE OrderNumber IN :';
            ordList = (List < Order > ) dml.selectRecordsInList(orderNumbers, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        } catch (Exception e) {}
        return ordList;
    }
    public static Account getAccountDetail(DML dml, string accountId, EBC_Logger ebcLogger) {
        MethodName = 'getAccountDetail';
        String querySelect = 'SELECT  ' + 'Id,Name,First_Name__c,Last_Name__c,Email__c,QBD_Customer_ID__c,EBizCharge_Custom_Tax__c,EBizCharge_Amount__c,' + 'Phone, Fax, Website,EBizCharge_Internal_ID__c,EBizCharge_Account_Tax__c,' + 'BillingAddress,BillingStreet, BillingPostalCode, BillingCity, BillingCountry, BillingState,' + 'ShippingCity, ShippingState, ShippingAddress,ShippingStreet, ShippingPostalCode, ShippingCountry';
        String queryFrom = 'FROM Account ';
        String queryWhere = 'where Id =\'' + AccountId + '\'';
        Account account = (Account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        return account;
    }
    public static Contact getContactDetail(DML dml, string contactId, EBC_Logger ebcLogger) {
        MethodName = 'getContactDetail';
        String querySelect = 'SELECT account.Name,Id, Name, createdById ,Email, FirstName, LastName  ,Phone, ' + 'Fax,MailingCountry,MailingState ,OtherAddress,OtherCity,OtherCountry,OtherState ,OtherStreet ,OtherPostalCode , ' + 'Ebiz_C__EBizCharge_Contact_Internal_ID__c,MailingCity,MailingStreet  ,MailingPostalCode ,Ebiz_C__EBizCharge_Contact_Amount__c,EBizCharge_Contact_Tax__c ';
        String queryFrom = 'FROM Contact';
        String queryWhere = 'where Id =\'' + contactId + '\'';
        Contact contact = (Contact) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        return contact;
    }
    public static Ebiz_C__EBizCharge_Fields_Config__c getCustomFieldDetail(DML dml, string customId, EBC_Logger ebcLogger) {
        MethodName = 'getCustomFieldDetail';
        String querySelect = 'SELECT Id, Name, Ebiz_C__EBizCharge_Internal_ID__c ,Ebiz_C__EBizCharge_Amount__c  ,' + 'Ebiz_C__EBizCharge_CustomerId__c ,Ebiz_C__EBizCharge_Email__c,Email__c  ,Ebiz_C__EBizCharge_Last_Sync_Date__c ,' + 'Ebiz_C__EBizCharge_Reference_Number__c ';
        String queryFrom = 'FROM Ebiz_C__EBizCharge_Fields_Config__c';
        String queryWhere = 'where Ebiz_C__EBizCharge_CustomerId__c =\'' + customId + '\'';
        Ebiz_C__EBizCharge_Fields_Config__c configObject = (Ebiz_C__EBizCharge_Fields_Config__c) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        return configObject;
    }
    public static List < Ebiz_C__EBizCharge_Fields_Config__c > getCustomFieldDetails(DML dml, List < Id > customIds, EBC_Logger ebcLogger) {
        MethodName = 'getCustomFieldDetails';
        list < String > ContactIdStr = new list < String > ();
        for (Integer i = 0; i < customIds.size(); i++) {
            ContactIdStr.add(customIds[i]);
        }
        String querySelect = 'SELECT Id, Name, Ebiz_C__EBizCharge_Internal_ID__c ,Ebiz_C__EBizCharge_Amount__c  ,' + 'Ebiz_C__EBizCharge_CustomerId__c ,Ebiz_C__EBizCharge_Email__c,Email__c,Ebiz_C__EBizCharge_Last_Sync_Date__c ,' + 'Ebiz_C__EBizCharge_Reference_Number__c ';
        String queryFrom = 'FROM Ebiz_C__EBizCharge_Fields_Config__c';
        String queryWhere = 'where Ebiz_C__EBizCharge_CustomerId__c IN :';
        List < Ebiz_C__EBizCharge_Fields_Config__c > ebzc = (List < Ebiz_C__EBizCharge_Fields_Config__c > ) dml.selectRecordsInList(ContactIdStr, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        return ebzc;
    }
    public static List < Account > getAccountsDetail(DML dml, List < Id > accountIds, EBC_Logger ebcLogger) {
        MethodName = 'getAccountsDetail';
        List < String > accountStringIds = new List < String > ();
        for (Integer i = 0; i < accountIds.size(); i++) {
            accountStringIds.add(accountIds[i]);
        }
        String querySelect = 'SELECT  ' + 'id, Name, First_Name__c, Last_Name__c, Email__c,QBD_Customer_ID__c,EBizCharge_Amount__c,EBizCharge_Internal_ID__c, ' + 'Phone, Fax, Website,' + 'BillingAddress, ShippingAddress, BillingStreet, BillingPostalCode, BillingCity, BillingCountry, BillingState,' + 'ShippingCity, ShippingState, ShippingStreet, ShippingPostalCode, ShippingCountry';
        String queryFrom = 'FROM Account';
        String queryWhere = 'where id IN :';
        List < Account > accList = (List < Account > ) dml.selectRecordsInList(accountStringIds, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        ebcLogger.debug(ClassName, MethodName, 'getAccountsDetail results: ' + accList);
        return accList;
    }
    public static List<Account> getAccountsDetailForQbd(DML dml,List<String> accountIds,EBC_Logger ebcLogger){
        String query_select ='SELECT  '+
            'id, Name, First_Name__c, Last_Name__c,Email__c,EBizCharge_Amount__c,EBizCharge_Internal_ID__c,QBD_Customer_ID__c,'+
            'Phone, Fax, Website,'+
            'BillingAddress, ShippingAddress, BillingStreet, BillingPostalCode, BillingCity, BillingCountry, BillingState,'+
            'ShippingCity, ShippingState, ShippingStreet, ShippingPostalCode, ShippingCountry';
        String query_from = 'FROM Account';
        String query_where = 'where QBD_Customer_ID__c IN :';
        system.debug('getAccountsDetail query : '+query_select+' '+query_from+' '+query_where);
        List<Account>  accList = (List<Account>)dml.selectRecordsInList(accountIds,query_select,query_from,query_where,Configuration.EMPTYSTRING,Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
        return accList;
    }
    public static List < Contact > getContactsDetail(DML dml, List < Id > contactIds, EBC_Logger ebcLogger) {
        MethodName = 'getContactsDetail';
        list < String > contactStringIds = new list < String > ();
        for (Integer i = 0; i < contactIds.size(); i++) {
            contactStringIds.add(contactIds[i]);
        }
        String querySelect = 'SELECT Id, Name, createdById ,Email, FirstName, LastName  ,Phone, Fax,MailingCountry,' + 'MailingState ,OtherAddress,OtherCity,OtherCountry,OtherState ,OtherStreet ,OtherPostalCode ,' + 'Ebiz_C__EBizCharge_Contact_Internal_ID__c,MailingCity,MailingStreet  ,MailingPostalCode ,' + 'Ebiz_C__EBizCharge_Contact_Amount__c';
        String queryFrom = 'FROM Contact';
        String queryWhere = 'where id IN :';
        List < Contact > contacts = (List < Contact > ) dml.selectRecordsInList(contactStringIds, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        return contacts;
    }
    public static list < EBizCharge_Transaction__c > getAllTransactions(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getAllTransactions';
        String querySelect = 'SELECT Id,Name,Order_Id__c,Order_Number__c,Ref_Number__c,Auth_Code__c,Auth_Amount__c,' + 'Result__c,Result_Code__c,Error__c,Error_Code__c,Status__c,Status_Code__c';
        String queryFrom = 'FROM EBizCharge_Transaction__c';
        String queryOrderBy = 'Order by CreatedDate DESC';
        String query_limit = 'limit 25000';
        return (list < EBizCharge_Transaction__c > ) dml.selectRecords(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryOrderBy, query_limit);
    }
    public static EBizcharge_Setting__c getSettings(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getSettings';
        String querySelect = 'SELECT AutoPay_bi_annually__c,AutoPay_four_week__c,AutoPay_annually__c,' + 'AutoPay_bi_weekly__c,AutoPay_quarterly__c,AutoPay_weekly__c,AutoPay_bi_monthly__c,AutoPay_daily__c,' + 'AutoPay_monthly__c,Enable_all_frequencies__c,Disable_all_frequencies__c,' + 'Sync_Recurring_Payment_Filter_By__c,Allow_Opportunity_Payment_Type__c,' + 'Allow_Quote_Payment_Type__c,Payments_Tab__c,Auto_Upload_Opportunity__c,Auto_Upload_Quote__c,' + 'Currency__c,Id,Security_Token__c,User_Name__c,Password__c,Transaction_Filter_By__c,' + 'Email_Pending_Req_Filter_By__c,Sync_Orders_Filter_By__c,Sync_Accounts_Filter_By__c,Sync_Products_Filter_By__c,' + 'Allow_Partial_Payment__c,Allow_Order_Payment_Type__c,Show_Tax_Field__c,' + 'Tax_Action__c,Tax_Calculate_By__c,Tax_Manual_Type__c,Tax_Default_Percent__c,Auto_Upload_Order__c,' + 'Auto_Upload_Account__c,Auto_Upload_Product__c,Auto_Apply_Received_Payment__c,Component_Label__c,' + 'Auto_Upload_Contact__c,Division_ID__c,Ebizcharge_Transaction_Last_Sync_Date__c,Ebizcharge_Product_Last_Sync_Date__c,Ebizcharge_Accounts_Last_Sync_Date__c,Ebizcharge_Orders_Last_Sync_Date__c';
        String queryFrom = 'FROM EBizcharge_Setting__c';
        String queryOrderBy = 'Order by CreatedDate DESC';
        return (EBizcharge_Setting__c) dml.selectSingleRecord(querySelect, queryFrom, Configuration.EMPTYSTRING, queryOrderBy, Configuration.EMPTYSTRING);
    }
    public static ebizchargeServicemodelSoap.SecurityToken getSecurityToken(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getSecurityToken';
        String querySelect = 'SELECT Id,Security_Token__c,User_Name__c,Password__c,Component_Label__c';
        String queryFrom = 'FROM EBizcharge_Setting__c';
        String queryOrderBy = 'Order by CreatedDate DESC';
        EBizcharge_Setting__c settings = (EBizcharge_Setting__c) dml.selectSingleRecord(querySelect, queryFrom, Configuration.EMPTYSTRING, queryOrderBy, Configuration.EMPTYSTRING);
        ebizchargeServicemodelSoap.SecurityToken securityToken = new ebizchargeServicemodelSoap.SecurityToken();
        securityToken.SecurityId = settings.Security_Token__c;
        securityToken.UserId = settings.User_Name__c;
        securityToken.Password = settings.Password__c;
        return securityToken;
    }
    public static string getCustomerToken(DML dml, string customerId, string internalID, EBC_Logger ebcLogger) {
        MethodName = 'getCustomerToken';
        string customerToken;
        ebizchargeServicemodelSoap.GetCustomerToken_element customer = new ebizchargeServicemodelSoap.GetCustomerToken_element();
        if(customerId != null || customerId != Configuration.EMPTYSTRING){
            customerToken = ebiz.GetCustomerToken(getSecurityToken(dml, ebcLogger),customerId, internalID);
        }else{
          customerToken = ebiz.GetCustomerToken(getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, internalID);
        }
        return customerToken;
    }
}