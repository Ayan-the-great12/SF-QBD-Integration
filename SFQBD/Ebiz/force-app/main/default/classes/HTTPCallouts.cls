public class HTTPCallouts { 
    public CalloutModelClass.ApplicationData GetApplicationData(String applicationId, String lookupKey, String applicationDataInternalId) {
        CalloutRequestHelper payload = new CalloutRequestHelper();
        String responseBody = payload.GetApplicationDataPayload(applicationId,lookupKey,applicationDataInternalId);
        CalloutModelClass.ApplicationData applicationDataClass = new CalloutModelClass.ApplicationData();
        XPath xpath = new XPath(responseBody);
        Dom.XmlNode[] getApplicationResultList = xpath.find('/s:Envelope/s:Body/GetApplicationDataResponse/GetApplicationDataResult');
        Dom.XmlNode[] securityTokenList = xpath.find('/s:Envelope/s:Body/GetApplicationDataResponse/GetApplicationDataResult/securityToken');
        for (Dom.XmlNode result: getApplicationResultList) {
            applicationDataClass.ApplicationId = CheckValue(xpath.getText(result, ',', 'ApplicationId'));
            applicationDataClass.LookupKey = CheckValue(xpath.getText(result, ',', 'LookupKey'));
            applicationDataClass.Base64ParametersString = CheckValue(xpath.getText(result, ',', 'Base64ParametersString'));
            applicationDataClass.ApplicationDataInternalId = CheckValue(xpath.getText(result, ',', 'ApplicationDataInternalId'));
        }
        CalloutModelClass.SecurityToken securityTokenClass = new  CalloutModelClass.SecurityToken();
        for (Dom.XmlNode result: securityTokenList) {
            securityTokenClass.SecurityId = CheckValue(xpath.getText(result, ',', 'SecurityId'));
            securityTokenClass.UserId = CheckValue(xpath.getText(result, ',', 'UserId'));
            securityTokenClass.Password = CheckValue(xpath.getText(result, ',', 'Password'));
        }
      applicationDataClass.securityToken = securityTokenClass;
      system.debug('ApplicationData Class with all members>>' + applicationDataClass);
      return applicationDataClass;
    } 
    public CalloutModelClass.ApplicationDataResponse AddApplicationData(string securityId,String applicationId, String lookupKey, String base64String) {
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.AddApplicationDataPayload(securityId,applicationId,lookupKey,base64String);
      CalloutModelClass.ApplicationDataResponse applicationDataResponseClass = new CalloutModelClass.ApplicationDataResponse();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] applicationDataResultList = xpath.find('/s:Envelope/s:Body/AddApplicationDataResponse/AddApplicationDataResult');
      for (Dom.XmlNode result: applicationDataResultList) {
        applicationDataResponseClass.ApplicationDataInternalId = CheckValue(xpath.getText(result, ',', 'ApplicationDataInternalId'));
        applicationDataResponseClass.Status = CheckValue(xpath.getText(result, ',', 'Status'));
        applicationDataResponseClass.StatusCode = CheckValue(xpath.getText(result, ',', 'StatusCode'));
        applicationDataResponseClass.Error = CheckValue(xpath.getText(result, ',', 'Error'));
        applicationDataResponseClass.ErrorCode = CheckValue(xpath.getText(result, ',', 'ErrorCode'));
      }
      system.debug('ApplicationDataResponse Class with all members>>' + applicationDataResponseClass);
      return applicationDataResponseClass;
    }
    public CalloutModelClass.GetScheduledDatesResponse GetRecurringSchedulePreview(string securityId, CalloutModelClass.RecurringBilling recurringBilling){
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.GetRecurringSchedulePreviewPayload(securityId,recurringBilling);
      CalloutModelClass.GetScheduledDatesResponse getRecurringSchedulePreviewClass = new CalloutModelClass.GetScheduledDatesResponse();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] getRecurringSchedulePreviewList = xpath.find('/s:Envelope/s:Body/GetRecurringSchedulePreviewResponse/GetRecurringSchedulePreviewResult');
      for (Dom.XmlNode result: getRecurringSchedulePreviewList) {
        getRecurringSchedulePreviewClass.ScheduledDates = CheckValue(xpath.getText(result, ',', 'ScheduledDates'));
        getRecurringSchedulePreviewClass.Status = CheckValue(xpath.getText(result, ',', 'Status'));
        getRecurringSchedulePreviewClass.StatusCode = CheckValue(xpath.getText(result, ',', 'StatusCode'));
        getRecurringSchedulePreviewClass.Error = CheckValue(xpath.getText(result, ',', 'Error'));
        getRecurringSchedulePreviewClass.ErrorCode = CheckValue(xpath.getText(result, ',', 'ErrorCode'));
      }
      system.debug('GetScheduledDatesResponse Class with all members>>' + getRecurringSchedulePreviewClass);
      return getRecurringSchedulePreviewClass;
    }
    public String ScheduleRecurringPayment(string securityId,String customerInternalId, String paymentMethodProfileId, CalloutModelClass.RecurringBilling recurringBilling){
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.ScheduleRecurringPaymentPayload(securityId,customerInternalId,paymentMethodProfileId,recurringBilling);
      String responseFromGateway ;
       XPath xpath = new XPath(responseBody);
       Dom.XmlNode[] scheduleRecurringPaymentList = xpath.find('/s:Envelope/s:Body/ScheduleRecurringPaymentResponse');
       Dom.XmlNode result = scheduleRecurringPaymentList.get(0);
       responseFromGateway = xpath.getText(result, ',', 'ScheduleRecurringPaymentResult');
       system.debug('responseFromGateway>>' + responseFromGateway);
       return responseFromGateway;
    }
    public CalloutModelClass.ApplicationDataResponse UpdateApplicationData(String applicationId, String lookupKey, String applicationDataInternalId, CalloutModelClass.ApplicationData applicationData){
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.UpdateApplicationDataPayload(applicationId,lookupKey,applicationDataInternalId,applicationData);
      CalloutModelClass.ApplicationDataResponse updateApplicationDataResponseClass = new CalloutModelClass.ApplicationDataResponse();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] updateApplicationDataResultList = xpath.find('/s:Envelope/s:Body/UpdateApplicationDataResponse/UpdateApplicationDataResult');
      for (Dom.XmlNode result: updateApplicationDataResultList) {
        updateApplicationDataResponseClass.ApplicationDataInternalId = CheckValue(xpath.getText(result, ',', 'ApplicationDataInternalId'));
        updateApplicationDataResponseClass.Status = CheckValue(xpath.getText(result, ',', 'Status'));
        updateApplicationDataResponseClass.StatusCode = CheckValue(xpath.getText(result, ',', 'StatusCode'));
        updateApplicationDataResponseClass.Error = CheckValue(xpath.getText(result, ',', 'Error'));
        updateApplicationDataResponseClass.ErrorCode = CheckValue(xpath.getText(result, ',', 'ErrorCode'));
      }
      system.debug('UpdateApplicationDataResponse Class with all members>>' + updateApplicationDataResponseClass);
      return updateApplicationDataResponseClass;
    }
    public CalloutModelClass.ArrayOfRecurringFrequency GetRecurringFrequencyList(string securityId)
    {
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.GetRecurringFrequencyListPayload(securityId);
      CalloutModelClass.ArrayOfRecurringFrequency getRecurringFrequencyListClass = new CalloutModelClass.ArrayOfRecurringFrequency();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] getRecurringFrequencyList = xpath.find('/s:Envelope/s:Body/GetRecurringFrequencyListResponse/GetRecurringFrequencyListResult/RecurringFrequency');
      List<CalloutModelClass.RecurringFrequency> recurringFrequencyLocal = new List<CalloutModelClass.RecurringFrequency>();
      for (Dom.XmlNode result: getRecurringFrequencyList){
        CalloutModelClass.RecurringFrequency recurringFrequency = new CalloutModelClass.RecurringFrequency(); 
        recurringFrequency.FrequencyInternalId = CheckValue(xpath.getText(result, ',', 'FrequencyInternalId'));
        recurringFrequency.FrequencyId = CheckValue(xpath.getText(result, ',', 'FrequencyId'));
        recurringFrequency.FrequencyDescription = CheckValue(xpath.getText(result, ',', 'FrequencyDescription'));
        recurringFrequency.FrequencyNotes = CheckValue(xpath.getText(result, ',', 'FrequencyNotes'));
        recurringFrequencyLocal.add(recurringFrequency);
        getRecurringFrequencyListClass.RecurringFrequency = recurringFrequencyLocal;
    }
    system.debug('GetRecurringFrequencyList Class with all members>>' + getRecurringFrequencyListClass);
    return getRecurringFrequencyListClass; 
  }
    public CalloutModelClass.ApplicationTransactionResponse AddApplicationTransaction(String securityId, CalloutModelClass.ApplicationTransactionRequest applicationTransactionRequest){
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.AddApplicationTransactionPayload(securityId,applicationTransactionRequest);
      CalloutModelClass.ApplicationTransactionResponse applicationTransactionResponseClass = new CalloutModelClass.ApplicationTransactionResponse();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] applicationTransactionResultList = xpath.find('/s:Envelope/s:Body/AddApplicationTransactionResponse/AddApplicationTransactionResult');
      for (Dom.XmlNode result: applicationTransactionResultList) {
        applicationTransactionResponseClass.ApplicationTransactionInternalId = CheckValue(xpath.getText(result, ',', 'ApplicationTransactionInternalId'));
        applicationTransactionResponseClass.Status = CheckValue(xpath.getText(result, ',', 'Status'));
        applicationTransactionResponseClass.StatusCode = CheckValue(xpath.getText(result, ',', 'StatusCode'));
        applicationTransactionResponseClass.Error = CheckValue(xpath.getText(result, ',', 'Error'));
        applicationTransactionResponseClass.ErrorCode = CheckValue(xpath.getText(result, ',', 'ErrorCode'));
      }
      system.debug('AddApplicationTransactionResponse Class with all members>>' + applicationTransactionResponseClass);
      return applicationTransactionResponseClass;
    }
    //CalloutModelClass.ArrayOfSalesOrder
    public CalloutModelClass.ArrayOfSalesOrder  SearchSalesOrders(String securityId, String customerId, String subCustomerId, String salesOrderNumber, String salesOrderInternalId, CalloutModelClass.ArrayOfSearchFilter filters, Integer start, Integer limit_x, String sort_x, Boolean includeItems) {
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.SearchSalesOrdersPayload(securityId ,customerId ,subCustomerId ,salesOrderNumber ,salesOrderInternalId ,filters ,start ,limit_x ,sort_x , includeItems);
      CalloutModelClass.ArrayOfSalesOrder arrayOfSalesOrders = new CalloutModelClass.ArrayOfSalesOrder();
      List<CalloutModelClass.SalesOrder> salesOrderLocal = new List<CalloutModelClass.SalesOrder> (); 
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] getSalesOrderResultList = xpath.find('/s:Envelope/s:Body/SearchSalesOrdersResponse/SearchSalesOrdersResult/SalesOrder');
      Dom.XmlNode[] billingAddressList = xpath.find('/s:Envelope/s:Body/SearchSalesOrdersResponse/SearchSalesOrdersResult/SalesOrder/BillingAddress');
      Dom.XmlNode[] shippingAddressList = xpath.find('/s:Envelope/s:Body/SearchSalesOrdersResponse/SearchSalesOrdersResult/SalesOrder/ShippingAddress');
      Dom.XmlNode[] salesOrderCustomFieldsList = xpath.find('/s:Envelope/s:Body/SearchSalesOrdersResponse/SearchSalesOrdersResult/SalesOrder/SalesOrderCustomFields/EbizCustomField');
      Integer tempCount = 1;
      for (Dom.XmlNode result: getSalesOrderResultList) {
        CalloutModelClass.SalesOrder salesOrderClass = new CalloutModelClass.SalesOrder();
        Dom.XmlNode[] itemsList = xpath.find('/s:Envelope/s:Body/SearchSalesOrdersResponse/SearchSalesOrdersResult/SalesOrder['+tempCount+']/Items/Item');
        salesOrderClass.MerchantId = CheckValue(xpath.getText(result, ',', 'MerchantId'));
        salesOrderClass.CustomerId = CheckValue(xpath.getText(result, ',', 'CustomerId'));
        salesOrderClass.SubCustomerId = CheckValue(xpath.getText(result, ',', 'SubCustomerId'));
        salesOrderClass.SalesOrderNumber = CheckValue(xpath.getText(result, ',', 'SalesOrderNumber'));
        salesOrderClass.SalesOrderInternalId = CheckValue(xpath.getText(result, ',', 'SalesOrderInternalId'));
        salesOrderClass.Date_x = CheckValue(xpath.getText(result, ',', 'Date'));
        salesOrderClass.Currency_x = CheckValue(xpath.getText(result, ',','Currency'));
        salesOrderClass.Amount = CheckValue(xpath.getText(result, ',', 'Amount'));
        salesOrderClass.DueDate = CheckValue(xpath.getText(result, ',', 'DueDate'));
        salesOrderClass.AmountDue = CheckValue(xpath.getText(result, ',', 'AmountDue'));
        salesOrderClass.PoNum = CheckValue(xpath.getText(result, ',', 'PoNum'));
        salesOrderClass.DivisionId = CheckValue(xpath.getText(result, ',', 'DivisionId'));
        salesOrderClass.TypeId = CheckValue(xpath.getText(result, ',', 'TypeId'));
        salesOrderClass.UploadedBy = CheckValue(xpath.getText(result, ',', 'UploadedBy'));
        salesOrderClass.UpdatedBy = CheckValue(xpath.getText(result, ',', 'UpdatedBy'));
        salesOrderClass.DateUploaded = CheckValue(xpath.getText(result, ',', 'DateUploaded'));
        salesOrderClass.DateUpdated = CheckValue(xpath.getText(result, ',', 'DateUpdated'));
        salesOrderClass.isDeleted = CheckValue(xpath.getText(result, ',', 'isDeleted'));
        salesOrderClass.DeletedBy = CheckValue(xpath.getText(result, ',', 'DeletedBy'));
        salesOrderClass.DateDeleted = CheckValue(xpath.getText(result, ',', 'DateDeleted'));
        salesOrderClass.Software = CheckValue(xpath.getText(result, ',', 'Software'));
        salesOrderClass.NotifyCustomer = CheckValue(xpath.getText(result, ',', 'NotifyCustomer'));
        salesOrderClass.EmailTemplateID = CheckValue(xpath.getText(result, ',', 'EmailTemplateID'));
        salesOrderClass.URL = CheckValue(xpath.getText(result, ',', 'URL'));
        salesOrderClass.TotalTaxAmount = CheckValue(xpath.getText(result, ',', 'TotalTaxAmount'));
        salesOrderClass.UniqueId = CheckValue(xpath.getText(result, ',', 'UniqueId'));
        salesOrderClass.Description = CheckValue(xpath.getText(result, ',', 'Description'));
        salesOrderClass.CustomerMessage = CheckValue(xpath.getText(result, ',', 'CustomerMessage'));
        salesOrderClass.Memo = CheckValue(xpath.getText(result, ',', 'Memo'));
        salesOrderClass.ShipDate = CheckValue(xpath.getText(result, ',', 'ShipDate'));
        salesOrderClass.ShipVia = CheckValue(xpath.getText(result, ',', 'ShipVia'));
        salesOrderClass.SalesRepId = CheckValue(xpath.getText(result, ',', 'SalesRepId'));
        salesOrderClass.TermsId = CheckValue(xpath.getText(result, ',', 'TermsId'));
        salesOrderClass.IsToBeEmailed = CheckValue(xpath.getText(result, ',', 'IsToBeEmailed'));
        salesOrderClass.IsToBePrinted = CheckValue(xpath.getText(result, ',', 'IsToBePrinted'));
        salesOrderClass.SalesOrderLastSyncDateTime = CheckValue(xpath.getText(result, ',', 'SalesOrderLastSyncDateTime'));
        salesOrderClass.LocationId = CheckValue(xpath.getText(result, ',', 'LocationId'));
  
      
        CalloutModelClass.Address billingAddress = new CalloutModelClass.Address();
      for (Dom.XmlNode address: billingAddressList) {
        billingAddress.FirstName = CheckValue(xpath.getText(address, ',', 'FirstName'));
        billingAddress.LastName = CheckValue(xpath.getText(address, ',', 'LastName'));
        billingAddress.CompanyName = CheckValue(xpath.getText(address, ',', 'CompanyName'));
        billingAddress.Address1 = CheckValue(xpath.getText(address, ',', 'Address1'));
        billingAddress.Address2 = CheckValue(xpath.getText(address, ',', 'Address2'));
        billingAddress.Address3 = CheckValue(xpath.getText(address, ',', 'Address3'));
        billingAddress.Address4 = CheckValue(xpath.getText(address, ',', 'Address4'));
        billingAddress.Address5 = CheckValue(xpath.getText(address, ',', 'Address5'));
        billingAddress.Address6 = CheckValue(xpath.getText(address, ',', 'Address6'));
        billingAddress.City = CheckValue(xpath.getText(address, ',', 'City'));
        billingAddress.State = CheckValue(xpath.getText(address, ',', 'State'));
        billingAddress.ZipCode = CheckValue(xpath.getText(address, ',', 'ZipCode'));
        billingAddress.Country = CheckValue(xpath.getText(address, ',', 'Country'));
        billingAddress.IsDefault = CheckValue(xpath.getText(address, ',', 'IsDefault'));
        salesOrderClass.BillingAddress = billingAddress;
      }
  
      CalloutModelClass.Address shippingAddress = new CalloutModelClass.Address();
      for (Dom.XmlNode address: shippingAddressList) {
        shippingAddress.FirstName = CheckValue(xpath.getText(address, ',', 'FirstName'));
        shippingAddress.LastName = CheckValue(xpath.getText(address, ',', 'LastName'));
        shippingAddress.CompanyName = CheckValue(xpath.getText(address, ',', 'CompanyName'));
        shippingAddress.Address1 = CheckValue(xpath.getText(address, ',', 'Address1'));
        shippingAddress.Address2 = CheckValue(xpath.getText(address, ',', 'Address2'));
        shippingAddress.Address3 = CheckValue(xpath.getText(address, ',', 'Address3'));
        shippingAddress.Address4 = CheckValue(xpath.getText(address, ',', 'Address4'));
        shippingAddress.Address5 = CheckValue(xpath.getText(address, ',', 'Address5'));
        shippingAddress.Address6 = CheckValue(xpath.getText(address, ',', 'Address6'));
        shippingAddress.City = CheckValue(xpath.getText(address, ',', 'City'));
        shippingAddress.State = CheckValue(xpath.getText(address, ',', 'State'));
        shippingAddress.ZipCode = CheckValue(xpath.getText(address, ',', 'ZipCode'));
        shippingAddress.Country = CheckValue(xpath.getText(address, ',', 'Country'));
        shippingAddress.IsDefault = CheckValue(xpath.getText(address, ',', 'IsDefault'));
        salesOrderClass.ShippingAddress = shippingAddress;
        system.debug('check>>' + shippingAddress.Address1);
      }
  
         Integer temp = 1;
         List < CalloutModelClass.CustomItem > itemsLocal = new List < CalloutModelClass.CustomItem > ();
  
      for (Dom.XmlNode item: itemsList) {
       Dom.XmlNode[] itemCustomFieldsList = xpath.find('/s:Envelope/s:Body/SearchSalesOrdersResponse/SearchSalesOrdersResult/SalesOrder/Items/Item['+temp+']/ItemCustomFields/EbizCustomField');
       CalloutModelClass.CustomItem customItem = new CalloutModelClass.CustomItem();
        customItem.ItemInternalId = CheckValue(xpath.getText(item, ',', 'ItemInternalId'));
        customItem.ItemId = CheckValue(xpath.getText(item, ',', 'ItemId'));
        customItem.Name = CheckValue(xpath.getText(item, ',', 'Name'));
        customItem.Description = CheckValue(xpath.getText(item, ',', 'Description'));
        customItem.UnitPrice = CheckValue(xpath.getText(item, ',', 'UnitPrice'));
        customItem.Qty = CheckValue(xpath.getText(item, ',', 'Qty'));
        customItem.Taxable = CheckValue(xpath.getText(item, ',', 'Taxable'));
        customItem.TaxRate = CheckValue(xpath.getText(item, ',', 'TaxRate'));
        customItem.UnitOfMeasure = CheckValue(xpath.getText(item, ',', 'UnitOfMeasure'));
        customItem.TotalLineAmount = CheckValue(xpath.getText(item, ',', 'TotalLineAmount'));
        customItem.TotalLineTax = CheckValue(xpath.getText(item, ',', 'TotalLineTax'));
        customItem.ItemLineNumber = CheckValue(xpath.getText(item, ',', 'ItemLineNumber'));
        customItem.GrossPrice = CheckValue(xpath.getText(item, ',', 'GrossPrice'));
        customItem.WarrantyDiscount = CheckValue(xpath.getText(item, ',', 'WarrantyDiscount'));
        customItem.SalesDiscount = CheckValue(xpath.getText(item, ',', 'SalesDiscount'));
        customItem.ItemClass = CheckValue(xpath.getText(item, ',', 'ItemClass'));
       List < CalloutModelClass.EbizCustomField > itemCustomFieldsLocal = new List < CalloutModelClass.EbizCustomField > ();
      
       for (Dom.XmlNode customfield: itemCustomFieldsList) {
         
        CalloutModelClass.EbizCustomField itemCustomFields = new CalloutModelClass.EbizCustomField();
         itemCustomFields.FieldId = CheckValue(xpath.getText(customfield, ',', 'FieldId'));
         itemCustomFields.FieldCaption = CheckValue(xpath.getText(customfield, ',', 'FieldCaption'));
         itemCustomFields.FieldName = CheckValue(xpath.getText(customfield, ',', 'FieldName'));
         itemCustomFields.FieldValue = CheckValue(xpath.getText(customfield, ',', 'FieldValue'));
         itemCustomFields.FieldType = CheckValue(xpath.getText(customfield, ',', 'FieldType'));
         itemCustomFields.FieldDataType = CheckValue(xpath.getText(customfield, ',', 'FieldDataType'));
         itemCustomFields.FieldDescription = CheckValue(xpath.getText(customfield, ',', 'FieldDescription'));
         itemCustomFieldsLocal.add(itemCustomFields);
         //add to Items class
         customItem.ItemCustomFields = itemCustomFieldsLocal;
         system.debug('custom item custom field>>' + itemCustomFields);
         system.debug('custom iustom field local>>' + itemCustomFieldsLocal);
       }
       
       itemsLocal.add(customItem);
       
       //add to customer class
        salesOrderClass.Items = itemsLocal;
       temp++;
       system.debug('payment mathod class>>' + customItem);
       system.debug('payment mathod class local>>' + itemsLocal);
     }
  
      List < CalloutModelClass.EbizCustomField > salesOrderCustomFieldsLocal = new List < CalloutModelClass.EbizCustomField > ();
      for (Dom.XmlNode customfield: salesOrderCustomFieldsList) {
        CalloutModelClass.EbizCustomField salesOrderCustomFields = new CalloutModelClass.EbizCustomField();
        salesOrderCustomFields.FieldId = CheckValue(xpath.getText(customfield, ',', 'FieldId'));
        salesOrderCustomFields.FieldCaption = CheckValue(xpath.getText(customfield, ',', 'FieldCaption'));
        salesOrderCustomFields.FieldName = CheckValue(xpath.getText(customfield, ',', 'FieldName'));
        salesOrderCustomFields.FieldValue = CheckValue(xpath.getText(customfield, ',', 'FieldValue'));
        salesOrderCustomFields.FieldType = CheckValue(xpath.getText(customfield, ',', 'FieldType'));
        salesOrderCustomFields.FieldDataType = CheckValue(xpath.getText(customfield, ',', 'FieldDataType'));
        salesOrderCustomFields.FieldDescription = CheckValue(xpath.getText(customfield, ',', 'FieldDescription'));
        salesOrderCustomFieldsLocal.add(salesOrderCustomFields);
        //add to salesorder class
        salesOrderClass.SalesOrderCustomFields = salesOrderCustomFieldsLocal;
        system.debug('custom class>>' + salesOrderCustomFields);
        system.debug('custom class local>>' + salesOrderCustomFieldsLocal);
      }
      salesOrderLocal.add(salesOrderClass);
      system.debug('billibg company name found>>' + billingAddress.CompanyName);
      system.debug('salesorder item class>>' + salesOrderClass.Items);
      system.debug('SalesOrder class with all members>>' + salesOrderClass);
      
      arrayOfSalesOrders.SalesOrder = salesOrderLocal;
      tempCount++;
      
    }
    system.debug('array of SalesOrders before return>>' + arrayOfSalesOrders);
      return arrayOfSalesOrders;  
     }

    public CalloutModelClass.CustomerListSearchResult SearchCustomerList(string securityId,CalloutModelClass.ArrayOfSearchFilter filters, Integer start, Integer limit_x, String sort_x, Boolean includeCustomerToken, Boolean includePaymentMethodProfiles, Boolean countOnly){
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.SearchCustomerListPayload(securityId,filters,start,limit_x,sort_x,includeCustomerToken,includePaymentMethodProfiles,countOnly);
      CalloutModelClass.CustomerListSearchResult searchCustomerListClass = new CalloutModelClass.CustomerListSearchResult();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] searchCustomerResponseList = xpath.find('/s:Envelope/s:Body/SearchCustomerListResponse/SearchCustomerListResult');
      Dom.XmlNode[] CustomerList = xpath.find('/s:Envelope/s:Body/SearchCustomerListResponse/SearchCustomerListResult/CustomerList/Customer');
      for (Dom.XmlNode result: searchCustomerResponseList){
        searchCustomerListClass.Start = CheckValue(xpath.getText(result, ',', 'Start'));
        searchCustomerListClass.Limit_x = CheckValue(xpath.getText(result, ',', 'Limit'));
        searchCustomerListClass.Count = CheckValue(xpath.getText(result, ',', 'Count'));
      }
      Integer tempCount = 1;
      list<CalloutModelClass.Customer> CustomerLocal = new list<CalloutModelClass.Customer>();
      for (Dom.XmlNode result: CustomerList){
        CalloutModelClass.Customer customerResult = new CalloutModelClass.Customer();
        Dom.XmlNode[] customerCustomFieldsList = xpath.find('/s:Envelope/s:Body/SearchCustomerListResponse/SearchCustomerListResult/CustomerList/Customer['+tempCount+']/CustomerCustomFields/EbizCustomField');
        Dom.XmlNode[] paymentMethodProfileList = xpath.find('/s:Envelope/s:Body/SearchCustomerListResponse/SearchCustomerListResult/CustomerList/Customer['+tempCount+']/PaymentMethodProfiles/PaymentMethodProfile');
        Dom.XmlNode[] billingAddressList = xpath.find('/s:Envelope/s:Body/SearchCustomerListResponse/SearchCustomerListResult/CustomerList/Customer['+tempCount+']/BillingAddress');
        Dom.XmlNode[] shippingAddressList = xpath.find('/s:Envelope/s:Body/SearchCustomerListResponse/SearchCustomerListResult/CustomerList/Customer['+tempCount+']/ShippingAddress');
        customerResult.MerchantId = CheckValue(xpath.getText(result, ',', 'MerchantId'));
        customerResult.CustomerInternalId = CheckValue(xpath.getText(result, ',', 'CustomerInternalId'));
        customerResult.CustomerId = CheckValue(xpath.getText(result, ',', 'CustomerId'));
        customerResult.FirstName = CheckValue(xpath.getText(result, ',', 'FirstName'));
        customerResult.LastName = CheckValue(xpath.getText(result, ',', 'LastName'));
        customerResult.CompanyName = CheckValue(xpath.getText(result, ',', 'CompanyName'));
        customerResult.Phone = CheckValue(xpath.getText(result, ',', 'Phone'));
        customerResult.CellPhone = CheckValue(xpath.getText(result, ',', 'CellPhone'));
        customerResult.Fax = CheckValue(xpath.getText(result, ',', 'Fax'));
        customerResult.Email = CheckValue(xpath.getText(result, ',', 'Email'));
        customerResult.WebSite = CheckValue(xpath.getText(result, ',', 'WebSite'));
        customerResult.CustomerToken = CheckValue(xpath.getText(result, ',', 'CustomerToken'));
        customerResult.CustomerNotes = CheckValue(xpath.getText(result, ',', 'CustomerNotes'));
        customerResult.SoftwareId = CheckValue(xpath.getText(result, ',', 'SoftwareId'));
        customerResult.CustomerLastSyncDateTime = CheckValue(xpath.getText(result, ',', 'CustomerLastSyncDateTime'));
        customerResult.DivisionId = CheckValue(xpath.getText(result, ',', 'DivisionId'));
        customerResult.DateTimeCreated = CheckValue(xpath.getText(result, ',', 'DateTimeCreated'));
        customerResult.DateTimeModified = CheckValue(xpath.getText(result, ',', 'DateTimeModified'));

        CalloutModelClass.Address billingAddress = new CalloutModelClass.Address();
        for (Dom.XmlNode address: billingAddressList) {
          billingAddress.FirstName = CheckValue(xpath.getText(address, ',', 'FirstName'));
          billingAddress.LastName = CheckValue(xpath.getText(address, ',', 'LastName'));
          billingAddress.CompanyName = CheckValue(xpath.getText(address, ',', 'CompanyName'));
          billingAddress.Address1 = CheckValue(xpath.getText(address, ',', 'Address1'));
          billingAddress.Address2 = CheckValue(xpath.getText(address, ',', 'Address2'));
          billingAddress.Address3 = CheckValue(xpath.getText(address, ',', 'Address3'));
          billingAddress.Address4 = CheckValue(xpath.getText(address, ',', 'Address4'));
          billingAddress.Address5 = CheckValue(xpath.getText(address, ',', 'Address5'));
          billingAddress.Address6 = CheckValue(xpath.getText(address, ',', 'Address6'));
          billingAddress.City = CheckValue(xpath.getText(address, ',', 'City'));
          billingAddress.State = CheckValue(xpath.getText(address, ',', 'State'));
          billingAddress.ZipCode = CheckValue(xpath.getText(address, ',', 'ZipCode'));
          billingAddress.Country = CheckValue(xpath.getText(address, ',', 'Country'));
          billingAddress.IsDefault = CheckValue(xpath.getText(address, ',', 'IsDefault'));
          customerResult.BillingAddress = billingAddress;
        }
        CalloutModelClass.Address shippingAddress = new CalloutModelClass.Address();
        for (Dom.XmlNode address: shippingAddressList) {
          shippingAddress.FirstName = CheckValue(xpath.getText(address, ',', 'FirstName'));
          shippingAddress.LastName = CheckValue(xpath.getText(address, ',', 'LastName'));
          shippingAddress.CompanyName = CheckValue(xpath.getText(address, ',', 'CompanyName'));
          shippingAddress.Address1 = CheckValue(xpath.getText(address, ',', 'Address1'));
          shippingAddress.Address2 = CheckValue(xpath.getText(address, ',', 'Address2'));
          shippingAddress.Address3 = CheckValue(xpath.getText(address, ',', 'Address3'));
          shippingAddress.Address4 = CheckValue(xpath.getText(address, ',', 'Address4'));
          shippingAddress.Address5 = CheckValue(xpath.getText(address, ',', 'Address5'));
          shippingAddress.Address6 = CheckValue(xpath.getText(address, ',', 'Address6'));
          shippingAddress.City = CheckValue(xpath.getText(address, ',', 'City'));
          shippingAddress.State = CheckValue(xpath.getText(address, ',', 'State'));
          shippingAddress.ZipCode = CheckValue(xpath.getText(address, ',', 'ZipCode'));
          shippingAddress.Country = CheckValue(xpath.getText(address, ',', 'Country'));
          shippingAddress.IsDefault = CheckValue(xpath.getText(address, ',', 'IsDefault'));
          customerResult.ShippingAddress = shippingAddress;
        }
        List < CalloutModelClass.EbizCustomField > customerCustomFieldsLocal = new List < CalloutModelClass.EbizCustomField > ();
        for (Dom.XmlNode customfield: customerCustomFieldsList) {
         CalloutModelClass.EbizCustomField customerCustomFields = new CalloutModelClass.EbizCustomField();
          customerCustomFields.FieldId = CheckValue(xpath.getText(customfield, ',', 'FieldId'));
          customerCustomFields.FieldCaption = CheckValue(xpath.getText(customfield, ',', 'FieldCaption'));
          customerCustomFields.FieldName = CheckValue(xpath.getText(customfield, ',', 'FieldName'));
          customerCustomFields.FieldValue = CheckValue(xpath.getText(customfield, ',', 'FieldValue'));
          customerCustomFields.FieldType = CheckValue(xpath.getText(customfield, ',', 'FieldType'));
          customerCustomFields.FieldDataType = CheckValue(xpath.getText(customfield, ',', 'FieldDataType'));
          customerCustomFields.FieldDescription = CheckValue(xpath.getText(customfield, ',', 'FieldDescription'));
          customerCustomFieldsLocal.add(customerCustomFields);
          customerResult.CustomerCustomFields = customerCustomFieldsLocal;
        }
        List < CalloutModelClass.PaymentMethodProfile > paymentMethodProfileLocal = new List < CalloutModelClass.PaymentMethodProfile > ();
       for (Dom.XmlNode paymentMethod: paymentMethodProfileList) {
        CalloutModelClass.PaymentMethodProfile paymentMethodProfile = new CalloutModelClass.PaymentMethodProfile();
        paymentMethodProfile.MethodType = CheckValue(xpath.getText(paymentMethod, ',', 'MethodType'));
        paymentMethodProfile.MethodID = CheckValue(xpath.getText(paymentMethod, ',', 'MethodID'));
        paymentMethodProfile.MethodName = CheckValue(xpath.getText(paymentMethod, ',', 'MethodName'));
        paymentMethodProfile.SecondarySort = CheckValue(xpath.getText(paymentMethod, ',', 'SecondarySort'));
        paymentMethodProfile.Created = CheckValue(xpath.getText(paymentMethod, ',', 'Created'));
        paymentMethodProfile.Modified = CheckValue(xpath.getText(paymentMethod, ',', 'Modified'));
        paymentMethodProfile.Account = CheckValue(xpath.getText(paymentMethod, ',', 'Account'));
        paymentMethodProfile.AccountType = CheckValue(xpath.getText(paymentMethod, ',', 'AccountType'));
        paymentMethodProfile.AccountHolderName = CheckValue(xpath.getText(paymentMethod, ',', 'AccountHolderName'));
        paymentMethodProfile.DriversLicense = CheckValue(xpath.getText(paymentMethod, ',', 'DriversLicense'));
        paymentMethodProfile.DriversLicenseState = CheckValue(xpath.getText(paymentMethod, ',', 'DriversLicenseState'));
        paymentMethodProfile.RecordType = CheckValue(xpath.getText(paymentMethod, ',', 'RecordType'));
        paymentMethodProfile.Routing = CheckValue(xpath.getText(paymentMethod, ',', 'Routing'));
        paymentMethodProfile.AvsStreet = CheckValue(xpath.getText(paymentMethod, ',', 'AvsStreet'));
        paymentMethodProfile.AvsZip = CheckValue(xpath.getText(paymentMethod, ',', 'AvsZip'));
        paymentMethodProfile.CardCode = CheckValue(xpath.getText(paymentMethod, ',', 'CardCode'));
        paymentMethodProfile.CardExpiration = CheckValue(xpath.getText(paymentMethod, ',', 'CardExpiration'));
        paymentMethodProfile.CardNumber = CheckValue(xpath.getText(paymentMethod, ',', 'CardNumber'));
        paymentMethodProfile.CardType = CheckValue(xpath.getText(paymentMethod, ',', 'CardType'));
        paymentMethodProfile.Balance = CheckValue(xpath.getText(paymentMethod, ',', 'Balance'));
        paymentMethodProfile.MaxBalance = CheckValue(xpath.getText(paymentMethod, ',', 'MaxBalance'));
        paymentMethodProfile.AutoReload = CheckValue(xpath.getText(paymentMethod, ',', 'AutoReload'));
        paymentMethodProfile.ReloadSchedule = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadSchedule'));
        paymentMethodProfile.ReloadThreshold = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadThreshold'));
        paymentMethodProfile.ReloadAmount = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadAmount'));
        paymentMethodProfile.ReloadMethodID = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadMethodID'));
        paymentMethodProfileLocal.add(paymentMethodProfile);
        customerResult.PaymentMethodProfile = paymentMethodProfileLocal;
      }
         CustomerLocal.add(customerResult);
         searchCustomerListClass.CustomerList = CustomerLocal;
         tempCount++;
      }
      system.debug('SearchCustomerList Class with all members>>' + searchCustomerListClass);
      return searchCustomerListClass;
    } 
    public CalloutModelClass.TransactionSearchResult SearchTransactions(String securityId,CalloutModelClass.ArrayOfSearchFilter filters, Boolean matchAll, Boolean countOnly, String start, String limit_x, String sort_x){
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.SearchTransactionsPayload(securityId,filters,matchAll,countOnly,start,limit_x,sort_x);
      CalloutModelClass.TransactionSearchResult searchTransactionsClass = new CalloutModelClass.TransactionSearchResult();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] searchTransactionsResponseList = xpath.find('/s:Envelope/s:Body/SearchTransactionsResponse/SearchTransactionsResult');
      Dom.XmlNode[] searchTransactionObjectList = xpath.find('/s:Envelope/s:Body/SearchTransactionsResponse/SearchTransactionsResult/Transactions/TransactionObject');
      Dom.XmlNode[] shippingAddressList = xpath.find('/s:Envelope/s:Body/SearchTransactionsResponse/SearchTransactionsResult/Transactions/TransactionObject/ShippingAddress');
      Dom.XmlNode[] billingAddressList = xpath.find('/s:Envelope/s:Body/SearchTransactionsResponse/SearchTransactionsResult/Transactions/TransactionObject/BillingAddress');
      Dom.XmlNode[] responseList = xpath.find('/s:Envelope/s:Body/SearchTransactionsResponse/SearchTransactionsResult/Transactions/TransactionObject/Response');
      Dom.XmlNode[] detailList = xpath.find('/s:Envelope/s:Body/SearchTransactionsResponse/SearchTransactionsResult/Transactions/TransactionObject/Details');
      Dom.XmlNode[] creditCardDataList = xpath.find('/s:Envelope/s:Body/SearchTransactionsResponse/SearchTransactionsResult/Transactions/TransactionObject/CreditCardData');
      Dom.XmlNode[] checkTraceList = xpath.find('/s:Envelope/s:Body/SearchTransactionsResponse/SearchTransactionsResult/Transactions/TransactionObject/CheckTrace');
      Dom.XmlNode[] checkDataList = xpath.find('/s:Envelope/s:Body/SearchTransactionsResponse/SearchTransactionsResult/Transactions/TransactionObject/CheckData');
      
      for (Dom.XmlNode result: searchTransactionsResponseList){
        searchTransactionsClass.ErrorsCount = CheckValue(xpath.getText(result, ',', 'ErrorsCount'));
        searchTransactionsClass.TransactionsMatched = CheckValue(xpath.getText(result, ',', 'TransactionsMatched'));
        searchTransactionsClass.StartIndex = CheckValue(xpath.getText(result, ',', 'StartIndex'));
        searchTransactionsClass.SalesCount = CheckValue(xpath.getText(result, ',', 'SalesCount'));
        searchTransactionsClass.SalesAmount = CheckValue(xpath.getText(result, ',', 'SalesAmount'));
        searchTransactionsClass.Limit_x = CheckValue(xpath.getText(result, ',', 'Limit'));
        searchTransactionsClass.VoidsCount = CheckValue(xpath.getText(result, ',', 'VoidsCount'));
        searchTransactionsClass.ErrorsAmount = CheckValue(xpath.getText(result, ',', 'ErrorsAmount'));
        searchTransactionsClass.DeclinesCount = CheckValue(xpath.getText(result, ',', 'DeclinesCount'));
        searchTransactionsClass.DeclinesAmount = CheckValue(xpath.getText(result, ',', 'DeclinesAmount'));
        searchTransactionsClass.CreditsCount = CheckValue(xpath.getText(result, ',', 'CreditsCount'));
        searchTransactionsClass.CreditsAmount = CheckValue(xpath.getText(result, ',', 'CreditsAmount'));
        searchTransactionsClass.AuthOnlyCount = CheckValue(xpath.getText(result, ',', 'AuthOnlyCount'));
        searchTransactionsClass.AuthOnlyAmount = CheckValue(xpath.getText(result, ',', 'AuthOnlyAmount'));
        searchTransactionsClass.TransactionsReturned = CheckValue(xpath.getText(result, ',', 'TransactionsReturned'));
        searchTransactionsClass.VoidsAmount = CheckValue(xpath.getText(result, ',', 'VoidsAmount'));
      }
      Integer tempCount = 1;
      List<CalloutModelClass.TransactionObject>  transactionObjectLocal = new List<CalloutModelClass.TransactionObject>(); 
      for (Dom.XmlNode result: searchTransactionObjectList){
        CalloutModelClass.TransactionObject transactionObjectResult = new CalloutModelClass.TransactionObject();
        Dom.XmlNode[] lineItemList = xpath.find('/s:Envelope/s:Body/SearchTransactionsResponse/SearchTransactionsResult/Transactions/TransactionObject['+tempCount+']/LineItems/LineItem');
        Dom.XmlNode[]  fieldValueList = xpath.find('/s:Envelope/s:Body/SearchTransactionsResponse/SearchTransactionsResult/Transactions/TransactionObject['+tempCount+']/FieldValue');
        transactionObjectResult.DateTime_x = CheckValue(xpath.getText(result, ',', 'DateTime'));
        transactionObjectResult.Source = CheckValue(xpath.getText(result, ',', 'Source'));
        transactionObjectResult.ServerIP = CheckValue(xpath.getText(result, ',', 'ServerIP'));
        transactionObjectResult.User_x = CheckValue(xpath.getText(result, ',', 'User'));
        transactionObjectResult.CustomerID = CheckValue(xpath.getText(result, ',', 'CustomerID'));
        transactionObjectResult.ClientIP = CheckValue(xpath.getText(result, ',', 'ClientIP'));
        transactionObjectResult.AccountHolder = CheckValue(xpath.getText(result, ',', 'AccountHolder'));
        transactionObjectResult.Status = CheckValue(xpath.getText(result, ',', 'Status'));
        transactionObjectResult.TransactionType = CheckValue(xpath.getText(result, ',', 'TransactionType'));

        CalloutModelClass.GwAddress billingAddress = new CalloutModelClass.GwAddress();
        for (Dom.XmlNode address : billingAddressList) {
          billingAddress.City = CheckValue(xpath.getText(address, ',', 'City'));
          billingAddress.Company = CheckValue(xpath.getText(address, ',', 'Company'));
          billingAddress.Country = CheckValue(xpath.getText(address, ',', 'Country'));
          billingAddress.Email = CheckValue(xpath.getText(address, ',', 'Email'));
          billingAddress.Fax = CheckValue(xpath.getText(address, ',', 'Fax'));
          billingAddress.FirstName = CheckValue(xpath.getText(address, ',', 'FirstName'));
          billingAddress.LastName = CheckValue(xpath.getText(address, ',', 'LastName'));
          billingAddress.Phone = CheckValue(xpath.getText(address, ',', 'Phone'));
          billingAddress.State = CheckValue(xpath.getText(address, ',', 'State'));
          billingAddress.Street = CheckValue(xpath.getText(address, ',', 'Street'));
          billingAddress.Street2 = CheckValue(xpath.getText(address, ',', 'Street2'));
          billingAddress.Zip = CheckValue(xpath.getText(address, ',', 'Zip'));
          transactionObjectResult.BillingAddress = billingAddress;
          //getTransactionDetailsClass.BillingAddress = billingAddress;
        }
        CalloutModelClass.GwAddress shippingAddress = new CalloutModelClass.GwAddress();
        for (Dom.XmlNode address: shippingAddressList) {
          shippingAddress.City = CheckValue(xpath.getText(address, ',', 'City'));
          shippingAddress.Company = CheckValue(xpath.getText(address, ',', 'Company'));
          shippingAddress.Country = CheckValue(xpath.getText(address, ',', 'Country'));
          shippingAddress.Email = CheckValue(xpath.getText(address, ',', 'Email'));
          shippingAddress.Fax = CheckValue(xpath.getText(address, ',', 'Fax'));
          shippingAddress.FirstName = CheckValue(xpath.getText(address, ',', 'FirstName'));
          shippingAddress.LastName = CheckValue(xpath.getText(address, ',', 'LastName'));
          shippingAddress.Phone = CheckValue(xpath.getText(address, ',', 'Phone'));
          shippingAddress.State = CheckValue(xpath.getText(address, ',', 'State'));
          shippingAddress.Street = CheckValue(xpath.getText(address, ',', 'Street'));
          shippingAddress.Street2 = CheckValue(xpath.getText(address, ',', 'Street2'));
          shippingAddress.Zip = CheckValue(xpath.getText(address, ',', 'Zip'));
          transactionObjectResult.ShippingAddress = shippingAddress;
        }
        CalloutModelClass.TransactionResponse transactionResponse = new CalloutModelClass.TransactionResponse();
      for (Dom.XmlNode response: responseList) {
        transactionResponse.CustNum = CheckValue(xpath.getText(response, ',', 'CustNum'));
        transactionResponse.ResultCode = CheckValue(xpath.getText(response, ',', 'ResultCode'));
        transactionResponse.Result = CheckValue(xpath.getText(response, ',', 'Result'));
        transactionResponse.RemainingBalance = CheckValue(xpath.getText(response, ',', 'RemainingBalance'));
        transactionResponse.RefNum = CheckValue(xpath.getText(response, ',', 'RefNum'));
        transactionResponse.ProfilerReason = CheckValue(xpath.getText(response, ',', 'ProfilerReason'));
        transactionResponse.ProfilerResponse = CheckValue(xpath.getText(response, ',', 'ProfilerResponse'));
        transactionResponse.ProfilerScore = CheckValue(xpath.getText(response, ',', 'ProfilerScore'));
        transactionResponse.Payload = CheckValue(xpath.getText(response, ',', 'Payload'));
        transactionResponse.isDuplicate = CheckValue(xpath.getText(response, ',', 'isDuplicate'));
        transactionResponse.ErrorCode = CheckValue(xpath.getText(response, ',', 'ErrorCode'));
        transactionResponse.Error = CheckValue(xpath.getText(response, ',', 'Error'));
        transactionResponse.VpasResultCode = CheckValue(xpath.getText(response, ',', 'VpasResultCode'));
        transactionResponse.ConvertedAmountCurrency = CheckValue(xpath.getText(response, ',', 'ConvertedAmountCurrency'));
        transactionResponse.ConvertedAmount = CheckValue(xpath.getText(response, ',', 'ConvertedAmount'));
        transactionResponse.ConversionRate = CheckValue(xpath.getText(response, ',', 'ConversionRate'));
        transactionResponse.CardLevelResultCode = CheckValue(xpath.getText(response, ',', 'CardLevelResultCode'));
        transactionResponse.CardLevelResult = CheckValue(xpath.getText(response, ',', 'CardLevelResult'));
        transactionResponse.CardCodeResultCode = CheckValue(xpath.getText(response, ',', 'CardCodeResultCode'));
        transactionResponse.CardCodeResult = CheckValue(xpath.getText(response, ',', 'CardCodeResult'));
        transactionResponse.BatchRefNum = CheckValue(xpath.getText(response, ',', 'BatchRefNum'));
        transactionResponse.BatchNum = CheckValue(xpath.getText(response, ',', 'BatchNum'));
        transactionResponse.AvsResultCode = CheckValue(xpath.getText(response, ',', 'AvsResultCode')); 
        transactionResponse.AvsResult = CheckValue(xpath.getText(response, ',', 'AvsResult'));
        transactionResponse.AuthCode = CheckValue(xpath.getText(response, ',', 'AuthCode'));
        transactionResponse.AuthAmount = CheckValue(xpath.getText(response, ',', 'AuthAmount'));
        transactionResponse.AcsUrl = CheckValue(xpath.getText(response, ',', 'AcsUrl'));
        transactionResponse.Status = CheckValue(xpath.getText(response, ',', 'Status'));
        transactionResponse.StatusCode = CheckValue(xpath.getText(response, ',', 'StatusCode'));
        transactionObjectResult.Response = transactionResponse;
      }
      CalloutModelClass.TransactionDetail details = new CalloutModelClass.TransactionDetail();
      for (Dom.XmlNode response: detailList) {
        details.NonTax = CheckValue(xpath.getText(response, ',', 'NonTax'));
        details.Tax = CheckValue(xpath.getText(response, ',', 'Tax'));
        details.Table = CheckValue(xpath.getText(response, ',', 'Table'));
        details.Subtotal = CheckValue(xpath.getText(response, ',', 'Subtotal'));
        details.Shipping = CheckValue(xpath.getText(response, ',', 'Shipping'));
        details.ShipFromZip = CheckValue(xpath.getText(response, ',', 'ShipFromZip'));
        details.SessionID = CheckValue(xpath.getText(response, ',', 'SessionID'));
        details.PONum = CheckValue(xpath.getText(response, ',', 'PONum')); 
        details.OrderID = CheckValue(xpath.getText(response, ',', 'OrderID'));
        details.Invoice = CheckValue(xpath.getText(response, ',', 'Invoice'));
        details.Duty = CheckValue(xpath.getText(response, ',', 'Duty'));
        details.Discount = CheckValue(xpath.getText(response, ',', 'Discount'));
        details.Comments = CheckValue(xpath.getText(response, ',', 'Comments'));
        details.Description = CheckValue(xpath.getText(response, ',', 'Description'));
        details.Currency_x = CheckValue(xpath.getText(response, ',', 'Currency'));
        details.Clerk = CheckValue(xpath.getText(response, ',', 'Clerk'));
        details.Amount = CheckValue(xpath.getText(response, ',', 'Amount'));
        details.AllowPartialAuth = CheckValue(xpath.getText(response, ',', 'AllowPartialAuth'));
        details.Terminal = CheckValue(xpath.getText(response, ',', 'Terminal'));
        details.Tip = CheckValue(xpath.getText(response, ',', 'Tip'));
        transactionObjectResult.Details = details;
      }
      CalloutModelClass.CreditCardData creditCard = new CalloutModelClass.CreditCardData();
      for (Dom.XmlNode response:creditCardDataList) {
        creditCard.CAVV = CheckValue(xpath.getText(response, ',', 'CAVV'));
        creditCard.Pares = CheckValue(xpath.getText(response, ',', 'Pares'));
        creditCard.MagSupport = CheckValue(xpath.getText(response, ',', 'MagSupport'));
        creditCard.MagStripe = CheckValue(xpath.getText(response, ',', 'MagStripe'));
        creditCard.InternalCardAuth = CheckValue(xpath.getText(response, ',', 'InternalCardAuth'));
        creditCard.ECI = CheckValue(xpath.getText(response, ',', 'ECI'));
        creditCard.DUKPT = CheckValue(xpath.getText(response, ',', 'DUKPT'));
        creditCard.XID = CheckValue(xpath.getText(response, ',', 'XID'));
        creditCard.CardType = CheckValue(xpath.getText(response, ',', 'CardType'));
        creditCard.CardPresent = CheckValue(xpath.getText(response, ',', 'CardPresent'));
        creditCard.CardNumber = CheckValue(xpath.getText(response, ',', 'CardNumber'));
        creditCard.CardExpiration = CheckValue(xpath.getText(response, ',', 'CardExpiration'));
        creditCard.CardCode = CheckValue(xpath.getText(response, ',', 'CardCode'));
        creditCard.AvsZip = CheckValue(xpath.getText(response, ',', 'AvsZip'));
        creditCard.AvsStreet = CheckValue(xpath.getText(response, ',', 'AvsStreet'));
        creditCard.Signature = CheckValue(xpath.getText(response, ',', 'Signature'));
        creditCard.TermType = CheckValue(xpath.getText(response, ',', 'TermType'));
        transactionObjectResult.CreditCardData = creditCard;
      }
      CalloutModelClass.CheckTrace checkTrace = new CalloutModelClass.CheckTrace();
      for (Dom.XmlNode response:checkTraceList) {
        checkTrace.Status = CheckValue(xpath.getText(response, ',', 'Status'));
        checkTrace.StatusCode = CheckValue(xpath.getText(response, ',', 'StatusCode'));
        checkTrace.BankNote = CheckValue(xpath.getText(response, ',', 'BankNote'));
        checkTrace.Effective = CheckValue(xpath.getText(response, ',', 'Effective'));
        checkTrace.Processed = CheckValue(xpath.getText(response, ',', 'Processed'));
        checkTrace.Returned = CheckValue(xpath.getText(response, ',', 'Returned'));
        checkTrace.ReturnCode = CheckValue(xpath.getText(response, ',', 'ReturnCode'));
        checkTrace.Reason = CheckValue(xpath.getText(response, ',', 'Reason'));
        checkTrace.Settled = CheckValue(xpath.getText(response, ',', 'Settled'));
        checkTrace.TrackingNum = CheckValue(xpath.getText(response, ',', 'TrackingNum'));
        transactionObjectResult.CheckTrace = checkTrace;
      }
      CalloutModelClass.CheckData checkData = new CalloutModelClass.CheckData();
      for (Dom.XmlNode response:checkDataList) {
        checkData.Account = CheckValue(xpath.getText(response, ',', 'Account'));
        checkData.AccountType = CheckValue(xpath.getText(response, ',', 'AccountType'));
        checkData.CheckNumber = CheckValue(xpath.getText(response, ',', 'CheckNumber'));
        checkData.DriversLicense = CheckValue(xpath.getText(response, ',', 'DriversLicense'));
        checkData.DriversLicenseState = CheckValue(xpath.getText(response, ',', 'DriversLicenseState'));
        checkData.RecordType = CheckValue(xpath.getText(response, ',', 'RecordType'));
        checkData.Routing = CheckValue(xpath.getText(response, ',', 'Routing'));
        checkData.MICR = CheckValue(xpath.getText(response, ',', 'MICR'));
        checkData.AuxOnUS = CheckValue(xpath.getText(response, ',', 'AuxOnUS'));
        checkData.EpcCode = CheckValue(xpath.getText(response, ',', 'EpcCode'));
        checkData.FrontImage = CheckValue(xpath.getText(response, ',', 'FrontImage'));
        checkData.BackImage = CheckValue(xpath.getText(response, ',', 'BackImage'));
        transactionObjectResult.CheckData = checkData;
      }
      List < CalloutModelClass.FieldValue> fieldValueLocal = new List < CalloutModelClass.FieldValue> ();
      for (Dom.XmlNode response: fieldValueList) {
        CalloutModelClass.FieldValue fieldValue = new CalloutModelClass.FieldValue();
        fieldValue.Field = CheckValue(xpath.getText(response, ',', 'Field'));
        fieldValue.Value = CheckValue(xpath.getText(response, ',', 'Value'));
        fieldValueLocal.add(fieldValue);
        transactionObjectResult.CustomFields = fieldValueLocal;
      }
      List < CalloutModelClass.LineItem> lineItemLocal = new List < CalloutModelClass.LineItem> ();
      for (Dom.XmlNode item: lineItemList) {
        CalloutModelClass.LineItem lineItem = new CalloutModelClass.LineItem();
        lineItem.DiscountRate = CheckValue(xpath.getText(item, ',', 'DiscountRate'));
        lineItem.ProductRefNum = CheckValue(xpath.getText(item, ',', 'ProductRefNum'));
        lineItem.SKU = CheckValue(xpath.getText(item, ',', 'SKU'));
        lineItem.CommodityCode = CheckValue(xpath.getText(item, ',', 'CommodityCode'));
        lineItem.ProductName = CheckValue(xpath.getText(item, ',', 'ProductName'));
        lineItem.Description = CheckValue(xpath.getText(item, ',', 'Description'));
        lineItem.DiscountAmount = CheckValue(xpath.getText(item, ',', 'DiscountAmount'));
        lineItem.TaxRate = CheckValue(xpath.getText(item, ',', 'TaxRate'));
        lineItem.UnitOfMeasure = CheckValue(xpath.getText(item, ',', 'UnitOfMeasure'));
        lineItem.UnitPrice = CheckValue(xpath.getText(item, ',', 'UnitPrice'));
        lineItem.Qty = CheckValue(xpath.getText(item, ',', 'Qty'));
        lineItem.Taxable = CheckValue(xpath.getText(item, ',', 'Taxable'));
        lineItem.TaxAmount = CheckValue(xpath.getText(item, ',', 'TaxAmount'));
        lineItemLocal.add(lineItem);
        transactionObjectResult.LineItems = lineItemLocal;
      }
        transactionObjectLocal.add(transactionObjectResult);
        searchTransactionsClass.Transactions = transactionObjectLocal;
        tempCount++;
      }
      system.debug('SearchTransactions Class with all members>>' + searchTransactionsClass);
      return searchTransactionsClass;
    }
    public CalloutModelClass.TransactionObject GetTransactionDetails(string securityId,String transactionRefNum){
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.GetTransactionDetailsPayload(securityId,transactionRefNum);
      CalloutModelClass.TransactionObject getTransactionDetailsClass = new CalloutModelClass.TransactionObject();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] getTransactionDetailsResponseList = xpath.find('/s:Envelope/s:Body/GetTransactionDetailsResponse/GetTransactionDetailsResult');
      Dom.XmlNode[] billingAddressList = xpath.find('/s:Envelope/s:Body/GetTransactionDetailsResponse/GetTransactionDetailsResult/BillingAddress');
      Dom.XmlNode[] shippingAddressList = xpath.find('/s:Envelope/s:Body/GetTransactionDetailsResponse/GetTransactionDetailsResult/ShippingAddress');
      Dom.XmlNode[] responseList = xpath.find('/s:Envelope/s:Body/GetTransactionDetailsResponse/GetTransactionDetailsResult/Response');
      Dom.XmlNode[] detailList = xpath.find('/s:Envelope/s:Body/GetTransactionDetailsResponse/GetTransactionDetailsResult/Details');
      Dom.XmlNode[] lineItemList = xpath.find('/s:Envelope/s:Body/GetTransactionDetailsResponse/GetTransactionDetailsResult/LineItems/LineItem');
      Dom.XmlNode[] creditCardDataList = xpath.find('/s:Envelope/s:Body/GetTransactionDetailsResponse/GetTransactionDetailsResult/CreditCardData');
      Dom.XmlNode[] checkDataList = xpath.find('/s:Envelope/s:Body/GetTransactionDetailsResponse/GetTransactionDetailsResult/CheckData');
      Dom.XmlNode[] checkTraceList = xpath.find('/s:Envelope/s:Body/GetTransactionDetailsResponse/GetTransactionDetailsResult/CheckTrace');
      Dom.XmlNode[] fieldValueList = xpath.find('/s:Envelope/s:Body/GetTransactionDetailsResponse/GetTransactionDetailsResult/FieldValue');
      for (Dom.XmlNode result: getTransactionDetailsResponseList) {
        getTransactionDetailsClass.DateTime_x = CheckValue(xpath.getText(result, ',', 'DateTime'));
        getTransactionDetailsClass.Source = CheckValue(xpath.getText(result, ',', 'Source'));
        getTransactionDetailsClass.ServerIP = CheckValue(xpath.getText(result, ',', 'ServerIP'));
        getTransactionDetailsClass.User_x = CheckValue(xpath.getText(result, ',', 'User'));
        getTransactionDetailsClass.CustomerID = CheckValue(xpath.getText(result, ',', 'CustomerID'));
        getTransactionDetailsClass.ClientIP = CheckValue(xpath.getText(result, ',', 'ClientIP'));
        getTransactionDetailsClass.AccountHolder = CheckValue(xpath.getText(result, ',', 'AccountHolder'));
        getTransactionDetailsClass.Status = CheckValue(xpath.getText(result, ',', 'Status'));
        getTransactionDetailsClass.TransactionType = CheckValue(xpath.getText(result, ',', 'TransactionType'));
      }
      CalloutModelClass.GwAddress billingAddress = new CalloutModelClass.GwAddress();
      for (Dom.XmlNode address : billingAddressList) {
        billingAddress.City = CheckValue(xpath.getText(address, ',', 'City'));
        billingAddress.Company = CheckValue(xpath.getText(address, ',', 'Company'));
        billingAddress.Country = CheckValue(xpath.getText(address, ',', 'Country'));
        billingAddress.Email = CheckValue(xpath.getText(address, ',', 'Email'));
        billingAddress.Fax = CheckValue(xpath.getText(address, ',', 'Fax'));
        billingAddress.FirstName = CheckValue(xpath.getText(address, ',', 'FirstName'));
        billingAddress.LastName = CheckValue(xpath.getText(address, ',', 'LastName'));
        billingAddress.Phone = CheckValue(xpath.getText(address, ',', 'Phone'));
        billingAddress.State = CheckValue(xpath.getText(address, ',', 'State'));
        billingAddress.Street = CheckValue(xpath.getText(address, ',', 'Street'));
        billingAddress.Street2 = CheckValue(xpath.getText(address, ',', 'Street2'));
        billingAddress.Zip = CheckValue(xpath.getText(address, ',', 'Zip'));
        getTransactionDetailsClass.BillingAddress = billingAddress;
      }
      CalloutModelClass.GwAddress shippingAddress = new CalloutModelClass.GwAddress();
      for (Dom.XmlNode address: shippingAddressList) {
        shippingAddress.City = CheckValue(xpath.getText(address, ',', 'City'));
        shippingAddress.Company = CheckValue(xpath.getText(address, ',', 'Company'));
        shippingAddress.Country = CheckValue(xpath.getText(address, ',', 'Country'));
        shippingAddress.Email = CheckValue(xpath.getText(address, ',', 'Email'));
        shippingAddress.Fax = CheckValue(xpath.getText(address, ',', 'Fax'));
        shippingAddress.FirstName = CheckValue(xpath.getText(address, ',', 'FirstName'));
        shippingAddress.LastName = CheckValue(xpath.getText(address, ',', 'LastName'));
        shippingAddress.Phone = CheckValue(xpath.getText(address, ',', 'Phone'));
        shippingAddress.State = CheckValue(xpath.getText(address, ',', 'State'));
        shippingAddress.Street = CheckValue(xpath.getText(address, ',', 'Street'));
        shippingAddress.Street2 = CheckValue(xpath.getText(address, ',', 'Street2'));
        shippingAddress.Zip = CheckValue(xpath.getText(address, ',', 'Zip'));
        getTransactionDetailsClass.ShippingAddress = shippingAddress;
      }
      CalloutModelClass.TransactionResponse transactionResponse = new CalloutModelClass.TransactionResponse();
      for (Dom.XmlNode response: responseList) {
        transactionResponse.CustNum = CheckValue(xpath.getText(response, ',', 'CustNum'));
        transactionResponse.ResultCode = CheckValue(xpath.getText(response, ',', 'ResultCode'));
        transactionResponse.Result = CheckValue(xpath.getText(response, ',', 'Result'));
        transactionResponse.RemainingBalance = CheckValue(xpath.getText(response, ',', 'RemainingBalance'));
        transactionResponse.RefNum = CheckValue(xpath.getText(response, ',', 'RefNum'));
        transactionResponse.ProfilerReason = CheckValue(xpath.getText(response, ',', 'ProfilerReason'));
        transactionResponse.ProfilerResponse = CheckValue(xpath.getText(response, ',', 'ProfilerResponse'));
        transactionResponse.ProfilerScore = CheckValue(xpath.getText(response, ',', 'ProfilerScore'));
        transactionResponse.Payload = CheckValue(xpath.getText(response, ',', 'Payload'));
        transactionResponse.isDuplicate = CheckValue(xpath.getText(response, ',', 'isDuplicate'));
        transactionResponse.ErrorCode = CheckValue(xpath.getText(response, ',', 'ErrorCode'));
        transactionResponse.Error = CheckValue(xpath.getText(response, ',', 'Error'));
        transactionResponse.VpasResultCode = CheckValue(xpath.getText(response, ',', 'VpasResultCode'));
        transactionResponse.ConvertedAmountCurrency = CheckValue(xpath.getText(response, ',', 'ConvertedAmountCurrency'));
        transactionResponse.ConvertedAmount = CheckValue(xpath.getText(response, ',', 'ConvertedAmount'));
        transactionResponse.ConversionRate = CheckValue(xpath.getText(response, ',', 'ConversionRate'));
        transactionResponse.CardLevelResultCode = CheckValue(xpath.getText(response, ',', 'CardLevelResultCode'));
        transactionResponse.CardLevelResult = CheckValue(xpath.getText(response, ',', 'CardLevelResult'));
        transactionResponse.CardCodeResultCode = CheckValue(xpath.getText(response, ',', 'CardCodeResultCode'));
        transactionResponse.CardCodeResult = CheckValue(xpath.getText(response, ',', 'CardCodeResult'));
        transactionResponse.BatchRefNum = CheckValue(xpath.getText(response, ',', 'BatchRefNum'));
        transactionResponse.BatchNum = CheckValue(xpath.getText(response, ',', 'BatchNum'));
        transactionResponse.AvsResultCode = CheckValue(xpath.getText(response, ',', 'AvsResultCode')); 
        transactionResponse.AvsResult = CheckValue(xpath.getText(response, ',', 'AvsResult'));
        transactionResponse.AuthCode = CheckValue(xpath.getText(response, ',', 'AuthCode'));
        transactionResponse.AuthAmount = CheckValue(xpath.getText(response, ',', 'AuthAmount'));
        transactionResponse.AcsUrl = CheckValue(xpath.getText(response, ',', 'AcsUrl'));
        transactionResponse.Status = CheckValue(xpath.getText(response, ',', 'Status'));
        transactionResponse.StatusCode = CheckValue(xpath.getText(response, ',', 'StatusCode'));
        getTransactionDetailsClass.Response = transactionResponse;
      }
      CalloutModelClass.CreditCardData creditCard = new CalloutModelClass.CreditCardData();
      for (Dom.XmlNode response:creditCardDataList) {
        creditCard.CAVV = CheckValue(xpath.getText(response, ',', 'CAVV'));
        creditCard.Pares = CheckValue(xpath.getText(response, ',', 'Pares'));
        creditCard.MagSupport = CheckValue(xpath.getText(response, ',', 'MagSupport'));
        creditCard.MagStripe = CheckValue(xpath.getText(response, ',', 'MagStripe'));
        creditCard.InternalCardAuth = CheckValue(xpath.getText(response, ',', 'InternalCardAuth'));
        creditCard.ECI = CheckValue(xpath.getText(response, ',', 'ECI'));
        creditCard.DUKPT = CheckValue(xpath.getText(response, ',', 'DUKPT'));
        creditCard.XID = CheckValue(xpath.getText(response, ',', 'XID'));
        creditCard.CardType = CheckValue(xpath.getText(response, ',', 'CardType'));
        creditCard.CardPresent = CheckValue(xpath.getText(response, ',', 'CardPresent'));
        creditCard.CardNumber = CheckValue(xpath.getText(response, ',', 'CardNumber'));
        creditCard.CardExpiration = CheckValue(xpath.getText(response, ',', 'CardExpiration'));
        creditCard.CardCode = CheckValue(xpath.getText(response, ',', 'CardCode'));
        creditCard.AvsZip = CheckValue(xpath.getText(response, ',', 'AvsZip'));
        creditCard.AvsStreet = CheckValue(xpath.getText(response, ',', 'AvsStreet'));
        creditCard.Signature = CheckValue(xpath.getText(response, ',', 'Signature'));
        creditCard.TermType = CheckValue(xpath.getText(response, ',', 'TermType'));
        getTransactionDetailsClass.CreditCardData = creditCard;
      }
      CalloutModelClass.TransactionDetail details = new CalloutModelClass.TransactionDetail();
      for (Dom.XmlNode response: detailList) {
        details.NonTax = CheckValue(xpath.getText(response, ',', 'NonTax'));
        details.Tax = CheckValue(xpath.getText(response, ',', 'Tax'));
        details.Table = CheckValue(xpath.getText(response, ',', 'Table'));
        details.Subtotal = CheckValue(xpath.getText(response, ',', 'Subtotal'));
        details.Shipping = CheckValue(xpath.getText(response, ',', 'Shipping'));
        details.ShipFromZip = CheckValue(xpath.getText(response, ',', 'ShipFromZip'));
        details.SessionID = CheckValue(xpath.getText(response, ',', 'SessionID'));
        details.PONum = CheckValue(xpath.getText(response, ',', 'PONum')); 
        details.OrderID = CheckValue(xpath.getText(response, ',', 'OrderID'));
        details.Invoice = CheckValue(xpath.getText(response, ',', 'Invoice'));
        details.Duty = CheckValue(xpath.getText(response, ',', 'Duty'));
        details.Discount = CheckValue(xpath.getText(response, ',', 'Discount'));
        details.Comments = CheckValue(xpath.getText(response, ',', 'Comments'));
        details.Description = CheckValue(xpath.getText(response, ',', 'Description'));
        details.Currency_x = CheckValue(xpath.getText(response, ',', 'Currency'));
        details.Clerk = CheckValue(xpath.getText(response, ',', 'Clerk'));
        details.Amount = CheckValue(xpath.getText(response, ',', 'Amount'));
        details.AllowPartialAuth = CheckValue(xpath.getText(response, ',', 'AllowPartialAuth'));
        details.Terminal = CheckValue(xpath.getText(response, ',', 'Terminal'));
        details.Tip = CheckValue(xpath.getText(response, ',', 'Tip'));
        getTransactionDetailsClass.Details = details;
      }
      List < CalloutModelClass.LineItem> lineItemLocal = new List < CalloutModelClass.LineItem> ();
      for (Dom.XmlNode item: lineItemList) {
        CalloutModelClass.LineItem lineItem = new CalloutModelClass.LineItem();
        lineItem.DiscountRate = CheckValue(xpath.getText(item, ',', 'DiscountRate'));
        lineItem.ProductRefNum = CheckValue(xpath.getText(item, ',', 'ProductRefNum'));
        lineItem.SKU = CheckValue(xpath.getText(item, ',', 'SKU'));
        lineItem.CommodityCode = CheckValue(xpath.getText(item, ',', 'CommodityCode'));
        lineItem.ProductName = CheckValue(xpath.getText(item, ',', 'ProductName'));
        lineItem.Description = CheckValue(xpath.getText(item, ',', 'Description'));
        lineItem.DiscountAmount = CheckValue(xpath.getText(item, ',', 'DiscountAmount'));
        lineItem.TaxRate = CheckValue(xpath.getText(item, ',', 'TaxRate'));
        lineItem.UnitOfMeasure = CheckValue(xpath.getText(item, ',', 'UnitOfMeasure'));
        lineItem.UnitPrice = CheckValue(xpath.getText(item, ',', 'UnitPrice'));
        lineItem.Qty = CheckValue(xpath.getText(item, ',', 'Qty'));
        lineItem.Taxable = CheckValue(xpath.getText(item, ',', 'Taxable'));
        lineItem.TaxAmount = CheckValue(xpath.getText(item, ',', 'TaxAmount'));
        lineItemLocal.add(lineItem);
        getTransactionDetailsClass.LineItems = lineItemLocal;
      }
      List < CalloutModelClass.FieldValue> fieldValueLocal = new List < CalloutModelClass.FieldValue> ();
      for (Dom.XmlNode response: fieldValueList) {
        CalloutModelClass.FieldValue fieldValue = new CalloutModelClass.FieldValue();
        fieldValue.Field = CheckValue(xpath.getText(response, ',', 'Field'));
        fieldValue.Value = CheckValue(xpath.getText(response, ',', 'Value'));
        fieldValueLocal.add(fieldValue);
        getTransactionDetailsClass.CustomFields = fieldValueLocal;
      }
      CalloutModelClass.CheckData checkData = new CalloutModelClass.CheckData();
      for (Dom.XmlNode response:checkDataList) {
        checkData.Account = CheckValue(xpath.getText(response, ',', 'Account'));
        checkData.AccountType = CheckValue(xpath.getText(response, ',', 'AccountType'));
        checkData.CheckNumber = CheckValue(xpath.getText(response, ',', 'CheckNumber'));
        checkData.DriversLicense = CheckValue(xpath.getText(response, ',', 'DriversLicense'));
        checkData.DriversLicenseState = CheckValue(xpath.getText(response, ',', 'DriversLicenseState'));
        checkData.RecordType = CheckValue(xpath.getText(response, ',', 'RecordType'));
        checkData.Routing = CheckValue(xpath.getText(response, ',', 'Routing'));
        checkData.MICR = CheckValue(xpath.getText(response, ',', 'MICR'));
        checkData.AuxOnUS = CheckValue(xpath.getText(response, ',', 'AuxOnUS'));
        checkData.EpcCode = CheckValue(xpath.getText(response, ',', 'EpcCode'));
        checkData.FrontImage = CheckValue(xpath.getText(response, ',', 'FrontImage'));
        checkData.BackImage = CheckValue(xpath.getText(response, ',', 'BackImage'));
        getTransactionDetailsClass.CheckData = checkData;
      }
      CalloutModelClass.CheckTrace checkTrace = new CalloutModelClass.CheckTrace();
      for (Dom.XmlNode response:checkTraceList) {
        checkTrace.Status = CheckValue(xpath.getText(response, ',', 'Status'));
        checkTrace.StatusCode = CheckValue(xpath.getText(response, ',', 'StatusCode'));
        checkTrace.BankNote = CheckValue(xpath.getText(response, ',', 'BankNote'));
        checkTrace.Effective = CheckValue(xpath.getText(response, ',', 'Effective'));
        checkTrace.Processed = CheckValue(xpath.getText(response, ',', 'Processed'));
        checkTrace.Returned = CheckValue(xpath.getText(response, ',', 'Returned'));
        checkTrace.ReturnCode = CheckValue(xpath.getText(response, ',', 'ReturnCode'));
        checkTrace.Reason = CheckValue(xpath.getText(response, ',', 'Reason'));
        checkTrace.Settled = CheckValue(xpath.getText(response, ',', 'Settled'));
        checkTrace.TrackingNum = CheckValue(xpath.getText(response, ',', 'TrackingNum'));
        getTransactionDetailsClass.CheckTrace = checkTrace;
      }
      system.debug('GetTransactionDetails Class with all members>>' + getTransactionDetailsClass);
      return getTransactionDetailsClass;
    }
    public CalloutModelClass.TransactionResponse runCustomerTransaction(string securityId, String custNum, String paymentMethodID, CalloutModelClass.CustomerTransactionRequest tran){
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.RunCustomerTransactionPayload(securityId,custNum,paymentMethodID,tran);
      CalloutModelClass.TransactionResponse runCustomerTransactionClass = new CalloutModelClass.TransactionResponse();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] runCustomerTransactionList = xpath.find('/s:Envelope/s:Body/runCustomerTransactionResponse/runCustomerTransactionResult');
      for (Dom.XmlNode result: runCustomerTransactionList) {
        runCustomerTransactionClass.CustNum = CheckValue(xpath.getText(result, ',', 'CustNum'));
        runCustomerTransactionClass.ResultCode = CheckValue(xpath.getText(result, ',', 'ResultCode'));
        runCustomerTransactionClass.Result = CheckValue(xpath.getText(result, ',', 'Result'));
        runCustomerTransactionClass.RemainingBalance = CheckValue(xpath.getText(result, ',', 'RemainingBalance'));
        runCustomerTransactionClass.RefNum = CheckValue(xpath.getText(result, ',', 'RefNum'));
        runCustomerTransactionClass.ProfilerReason = CheckValue(xpath.getText(result, ',', 'ProfilerReason'));
        runCustomerTransactionClass.ProfilerResponse = CheckValue(xpath.getText(result, ',', 'ProfilerResponse'));
        runCustomerTransactionClass.ProfilerScore = CheckValue(xpath.getText(result, ',', 'ProfilerScore'));
        runCustomerTransactionClass.Payload = CheckValue(xpath.getText(result, ',', 'Payload'));
        runCustomerTransactionClass.isDuplicate = CheckValue(xpath.getText(result, ',', 'isDuplicate'));
        runCustomerTransactionClass.ErrorCode = CheckValue(xpath.getText(result, ',', 'ErrorCode'));  
        runCustomerTransactionClass.Error = CheckValue(xpath.getText(result, ',', 'Error'));
        runCustomerTransactionClass.VpasResultCode = CheckValue(xpath.getText(result, ',', 'VpasResultCode'));
        runCustomerTransactionClass.ConvertedAmountCurrency = CheckValue(xpath.getText(result, ',', 'ConvertedAmountCurrency'));  
        runCustomerTransactionClass.ConvertedAmount = CheckValue(xpath.getText(result, ',', 'ConvertedAmount'));
        runCustomerTransactionClass.ConversionRate = CheckValue(xpath.getText(result, ',', 'ConversionRate'));
        runCustomerTransactionClass.CardLevelResultCode = CheckValue(xpath.getText(result, ',', 'CardLevelResultCode'));
        runCustomerTransactionClass.CardLevelResult = CheckValue(xpath.getText(result, ',', 'CardLevelResult'));
        runCustomerTransactionClass.CardCodeResultCode = CheckValue(xpath.getText(result, ',', 'CardCodeResultCode'));
        runCustomerTransactionClass.CardCodeResult = CheckValue(xpath.getText(result, ',', 'CardCodeResult'));
        runCustomerTransactionClass.BatchRefNum = CheckValue(xpath.getText(result, ',', 'BatchRefNum'));
        runCustomerTransactionClass.BatchNum = CheckValue(xpath.getText(result, ',', 'BatchNum'));
        runCustomerTransactionClass.AvsResultCode = CheckValue(xpath.getText(result, ',', 'AvsResultCode'));
        runCustomerTransactionClass.AvsResult = CheckValue(xpath.getText(result, ',', 'AvsResult'));
        runCustomerTransactionClass.AuthCode = CheckValue(xpath.getText(result, ',', 'AuthCode'));
        runCustomerTransactionClass.AuthAmount = CheckValue(xpath.getText(result, ',', 'AuthAmount'));
        runCustomerTransactionClass.AcsUrl = CheckValue(xpath.getText(result, ',', 'AcsUrl'));
        runCustomerTransactionClass.Status = CheckValue(xpath.getText(result, ',', 'Status'));
        runCustomerTransactionClass.StatusCode = CheckValue(xpath.getText(result, ',', 'StatusCode'));
      }
      system.debug('runCustomerTransaction Class with all members>>' + runCustomerTransactionClass);
      return runCustomerTransactionClass;
    }
    public CalloutModelClass.ArrayOfRecurringBillingDetails SearchScheduledRecurringPayments(string securityId, String customerInternalId, String customerId, Integer start, Integer limit_x, String sort_x){
     CalloutRequestHelper payload = new CalloutRequestHelper();
     String responseBody = payload.SearchScheduledRecurringPaymentsPayload(securityId,customerInternalId,customerId,start,limit_x,sort_x);
     CalloutModelClass.ArrayOfRecurringBillingDetails arrayOfRecurringBillingDetailsClass = new CalloutModelClass.ArrayOfRecurringBillingDetails();
     List <CalloutModelClass.RecurringBillingDetails> recurringBillingDetailsLocal = new  List <CalloutModelClass.RecurringBillingDetails>();
     XPath xpath = new XPath(responseBody);
     Dom.XmlNode[] searchScheduledRecurringPaymentsList = xpath.find('/s:Envelope/s:Body/SearchScheduledRecurringPaymentsResponse/SearchScheduledRecurringPaymentsResult/RecurringBillingDetails');
     for (Dom.XmlNode result: searchScheduledRecurringPaymentsList) {
        CalloutModelClass.RecurringBillingDetails recurringBillingDetailsClass = new  CalloutModelClass.RecurringBillingDetails();
        recurringBillingDetailsClass.ScheduledPaymentInternalId = CheckValue(xpath.getText(result, ',', 'ScheduledPaymentInternalId'));
        recurringBillingDetailsClass.CustomerInternalId = CheckValue(xpath.getText(result, ',', 'CustomerInternalId'));
        recurringBillingDetailsClass.CustomerId = CheckValue(xpath.getText(result, ',', 'CustomerId'));
        recurringBillingDetailsClass.Amount = CheckValue(xpath.getText(result, ',', 'Amount'));
        recurringBillingDetailsClass.Tax = CheckValue(xpath.getText(result, ',', 'Tax '));
        recurringBillingDetailsClass.Enabled = CheckValue(xpath.getText(result, ',', 'Enabled'));
        recurringBillingDetailsClass.Start = CheckValue(xpath.getText(result, ',', 'Start'));
        recurringBillingDetailsClass.Expire = CheckValue(xpath.getText(result, ',', 'Expire'));
        recurringBillingDetailsClass.Next = CheckValue(xpath.getText(result, ',', 'Next'));
        recurringBillingDetailsClass.NumLeft = CheckValue(xpath.getText(result, ',', 'NumLeft'));
        recurringBillingDetailsClass.RepeatCount = CheckValue(xpath.getText(result, ',', 'RepeatCount'));
        recurringBillingDetailsClass.Schedule = CheckValue(xpath.getText(result, ',', 'Schedule'));
        recurringBillingDetailsClass.ScheduleName = CheckValue(xpath.getText(result, ',', 'ScheduleName'));
        recurringBillingDetailsClass.ReceiptNote = CheckValue(xpath.getText(result, ',', 'ReceiptNote'));
        recurringBillingDetailsClass.ReceiptTemplateName = CheckValue(xpath.getText(result, ',', 'ReceiptTemplateName'));
        recurringBillingDetailsClass.SendCustomerReceipt = CheckValue(xpath.getText(result, ',', 'SendCustomerReceipt'));
        recurringBillingDetailsClass.CustNum = CheckValue(xpath.getText(result, ',', 'CustNum'));
        recurringBillingDetailsClass.PaymentMethodId = CheckValue(xpath.getText(result, ',', 'PaymentMethodId'));
        recurringBillingDetailsClass.MaskedPM = CheckValue(xpath.getText(result, ',', 'MaskedPM'));
        recurringBillingDetailsClass.PMHolderName = CheckValue(xpath.getText(result, ',', 'PMHolderName'));
        recurringBillingDetailsClass.PMExpirationYear = CheckValue(xpath.getText(result, ',', 'PMExpirationYear'));
        recurringBillingDetailsClass.PMExpirationMonth = CheckValue(xpath.getText(result, ',', 'PMExpirationMonth'));
        recurringBillingDetailsClass.PmType = CheckValue(xpath.getText(result, ',', 'PmType'));
        recurringBillingDetailsClass.ScheduleStatus = CheckValue(xpath.getText(result, ',', 'ScheduleStatus'));
        recurringBillingDetailsClass.DateTimeCreated = CheckValue(xpath.getText(result, ',', 'DateTimeCreated'));
        recurringBillingDetailsClass.DateTimeModified = CheckValue(xpath.getText(result, ',', 'DateTimeModified'));
        recurringBillingDetailsClass.CustomerFirstName = CheckValue(xpath.getText(result, ',', 'CustomerFirstName'));
        recurringBillingDetailsClass.CustomerLastName = CheckValue(xpath.getText(result, ',', 'CustomerLastName'));
        recurringBillingDetailsClass.CustomerCompanyName = CheckValue(xpath.getText(result, ',', 'CustomerCompanyName'));
        recurringBillingDetailsClass.CustomerEmailList = CheckValue(xpath.getText(result, ',', 'CustomerEmailList'));
        recurringBillingDetailsLocal.add(recurringBillingDetailsClass);
        arrayOfRecurringBillingDetailsClass.RecurringBillingDetails = recurringBillingDetailsLocal;
        system.debug('RecurringBillingDetails class>>' + recurringBillingDetailsClass);
        system.debug('RecurringBillingDetails class local>>' + recurringBillingDetailsLocal);
    }
    system.debug('SearchScheduledRecurringPaymentsResponse Class with all members>>' + arrayOfRecurringBillingDetailsClass);
    return arrayOfRecurringBillingDetailsClass;
    }
    public CalloutModelClass.ModifyScheduledRecurringPaymentResponse ModifyScheduledRecurringPaymentRecurringBilling(String securityId, String scheduledPaymentInternalId, CalloutModelClass.RecurringBilling recurringBilling){
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.ModifyScheduledRecurringPaymentRecurringBillingPayload(securityId,scheduledPaymentInternalId,recurringBilling);
      CalloutModelClass.ModifyScheduledRecurringPaymentResponse modifyScheduledRecurringPaymentRecurringBillingListClass = new CalloutModelClass.ModifyScheduledRecurringPaymentResponse();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] modifyScheduledRecurringPaymentRecurringBillingList = xpath.find('/s:Envelope/s:Body/ModifyScheduledRecurringPayment_RecurringBillingResponse/ModifyScheduledRecurringPayment_RecurringBillingResult');
      for (Dom.XmlNode result: modifyScheduledRecurringPaymentRecurringBillingList) {
        modifyScheduledRecurringPaymentRecurringBillingListClass.Status = CheckValue(xpath.getText(result, ',', 'Status'));
        modifyScheduledRecurringPaymentRecurringBillingListClass.StatusCode = CheckValue(xpath.getText(result, ',', 'StatusCode'));
        modifyScheduledRecurringPaymentRecurringBillingListClass.Error = CheckValue(xpath.getText(result, ',', 'Error'));
        modifyScheduledRecurringPaymentRecurringBillingListClass.ErrorCode = CheckValue(xpath.getText(result, ',', 'ErrorCode'));
      }
      system.debug('modifyScheduledRecurringPaymentRecurringBillingList Class with all members>>' + modifyScheduledRecurringPaymentRecurringBillingListClass);
      return modifyScheduledRecurringPaymentRecurringBillingListClass;
    }
    public CalloutModelClass.ModifyScheduledRecurringPaymentStatusResponse ModifyScheduledRecurringPaymentStatus(String securityId,String scheduledPaymentInternalId, Integer statusId){
        CalloutRequestHelper payload = new CalloutRequestHelper();
        String responseBody = payload.ModifyScheduledRecurringPaymentStatusPayload(securityId,scheduledPaymentInternalId,statusId);
        CalloutModelClass.ModifyScheduledRecurringPaymentStatusResponse modifyScheduledRecurringPaymentStatusResponseClass = new CalloutModelClass.ModifyScheduledRecurringPaymentStatusResponse();
        XPath xpath = new XPath(responseBody);
        Dom.XmlNode[] modifyScheduledRecurringPaymentStatusResultList = xpath.find('/s:Envelope/s:Body/ModifyScheduledRecurringPaymentStatusResponse/ModifyScheduledRecurringPaymentStatusResult');
        for (Dom.XmlNode result: modifyScheduledRecurringPaymentStatusResultList) {
            modifyScheduledRecurringPaymentStatusResponseClass.Status = CheckValue(xpath.getText(result, ',', 'Status'));
            modifyScheduledRecurringPaymentStatusResponseClass.StatusCode = CheckValue(xpath.getText(result, ',', 'StatusCode'));
            modifyScheduledRecurringPaymentStatusResponseClass.Error = CheckValue(xpath.getText(result, ',', 'Error'));
            modifyScheduledRecurringPaymentStatusResponseClass.ErrorCode = CheckValue(xpath.getText(result, ',', 'ErrorCode'));
          }
          system.debug('ModifyScheduledRecurringPaymentStatus Class with all members>>' + modifyScheduledRecurringPaymentStatusResponseClass);
          return modifyScheduledRecurringPaymentStatusResponseClass;
    }
    public CalloutModelClass.ArrayOfPayment SearchRecurringPayments(string securityId,String scheduledPaymentInternalId, String customerId, String customerInternalId, String fromDateTime, String toDateTime, Integer start, Integer limit_x, String sort_x){
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.SearchRecurringPaymentsPayload(securityId,scheduledPaymentInternalId,customerId,customerInternalId,fromDateTime,toDateTime,start,limit_x,sort_x);
      CalloutModelClass.ArrayOfPayment arrayOfPaymentClass = new CalloutModelClass.ArrayOfPayment();
      List<CalloutModelClass.Payment> paymentLocal = new List<CalloutModelClass.Payment>();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[]  arrayOfPaymentResultList = xpath.find('/s:Envelope/s:Body/SearchRecurringPaymentsResponse/SearchRecurringPaymentsResult/Payment');
      for (Dom.XmlNode result: arrayOfPaymentResultList) {
        CalloutModelClass.Payment paymentClass = new  CalloutModelClass.Payment();
        paymentClass.MerchantId = CheckValue(xpath.getText(result, ',', 'MerchantId'));
        paymentClass.CustomerId = CheckValue(xpath.getText(result, ',', 'CustomerId'));
        paymentClass.SubCustomerId = CheckValue(xpath.getText(result, ',', 'SubCustomerId'));
        paymentClass.DivisionId = CheckValue(xpath.getText(result, ',', 'DivisionId'));
        paymentClass.InvoiceNumber = CheckValue(xpath.getText(result, ',', 'InvoiceNumber'));
        paymentClass.InvoiceInternalId = CheckValue(xpath.getText(result, ',', 'InvoiceInternalId'));
        paymentClass.InvoiceDate = CheckValue(xpath.getText(result, ',', 'InvoiceDate'));
        paymentClass.InvoiceDueDate = CheckValue(xpath.getText(result, ',', 'InvoiceDueDate'));
        paymentClass.PoNum = CheckValue(xpath.getText(result, ',', 'PoNum'));
        paymentClass.SoNum = CheckValue(xpath.getText(result, ',', 'SoNum'));
        paymentClass.InvoiceAmount = CheckValue(xpath.getText(result, ',', 'InvoiceAmount'));
        paymentClass.AmountDue = CheckValue(xpath.getText(result, ',', 'AmountDue'));
        paymentClass.Currency_x = CheckValue(xpath.getText(result, ',', 'Currency'));
        paymentClass.AuthCode = CheckValue(xpath.getText(result, ',', 'AuthCode'));
        paymentClass.RefNum = CheckValue(xpath.getText(result, ',', 'RefNum'));
        paymentClass.Last4 = CheckValue(xpath.getText(result, ',', 'Last4'));
        paymentClass.PaymentMethod = CheckValue(xpath.getText(result, ',', 'PaymentMethod'));
        paymentClass.DatePaid = CheckValue(xpath.getText(result, ',', 'DatePaid'));
        paymentClass.PaidAmount = CheckValue(xpath.getText(result, ',', 'PaidAmount'));
        paymentClass.PaymentInternalId = CheckValue(xpath.getText(result, ',', 'PaymentInternalId'));
        paymentClass.ScheduledPaymentInternalId = CheckValue(xpath.getText(result, ',','ScheduledPaymentInternalId'));
        paymentClass.PaymentRequestDateTime = CheckValue(xpath.getText(result, ',', 'PaymentRequestDateTime'));
        paymentClass.CustNum = CheckValue(xpath.getText(result, ',', 'CustNum'));
        paymentClass.PaymentMethodId = CheckValue(xpath.getText(result, ',', 'PaymentMethodId'));
        paymentClass.PaymentType = CheckValue(xpath.getText(result, ',', 'PaymentType'));
        paymentClass.TypeId = CheckValue(xpath.getText(result, ',', 'TypeId'));   
        paymentClass.PaymentSourceId = CheckValue(xpath.getText(result, ',', 'PaymentSourceId'));
        paymentClass.TransactionLookupKey = CheckValue(xpath.getText(result, ',', 'TransactionLookupKey'));
        paymentClass.ExternalTxnId = CheckValue(xpath.getText(result, ',', 'ExternalTxnId'));
        paymentClass.Description = CheckValue(xpath.getText(result, ',', 'Description'));
        paymentClass.CustomerEmailAddress = CheckValue(xpath.getText(result, ',', 'CustomerEmailAddress'));
        paymentClass.DocumentTypeId = CheckValue(xpath.getText(result, ',', 'DocumentTypeId'));
        paymentClass.OrderId = CheckValue(xpath.getText(result, ',', 'OrderId'));
        paymentLocal.add(paymentClass);
        arrayOfPaymentClass.Payment = paymentLocal;
        system.debug('payment class>>' + paymentClass);
        system.debug('payment class local>>' + paymentLocal);
      }
      system.debug(' arrayOfPaymentClass with all members>>' + arrayOfPaymentClass);
      return arrayOfPaymentClass;
    }
    public CalloutModelClass.Customer GetCustomer(String securityId, String customer) {
     CalloutRequestHelper payload = new CalloutRequestHelper();
     String responseBody = payload.GetCustomerPayload(securityId,customer);
     CalloutModelClass.Customer customerClass = new CalloutModelClass.Customer();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] getCustomerResultList = xpath.find('/s:Envelope/s:Body/GetCustomerResponse/GetCustomerResult');
      Dom.XmlNode[] billingAddressList = xpath.find('/s:Envelope/s:Body/GetCustomerResponse/GetCustomerResult/BillingAddress');
      Dom.XmlNode[] shippingAddressList = xpath.find('/s:Envelope/s:Body/GetCustomerResponse/GetCustomerResult/ShippingAddress');
      Dom.XmlNode[] paymentMethodProfilesList = xpath.find('/s:Envelope/s:Body/GetCustomerResponse/GetCustomerResult/PaymentMethodProfiles/PaymentMethodProfile');
      Dom.XmlNode[] customerCustomFieldsList = xpath.find('/s:Envelope/s:Body/GetCustomerResponse/GetCustomerResult/CustomerCustomFields/EbizCustomField');
      for (Dom.XmlNode result: getCustomerResultList) {
        customerClass.MerchantId = CheckValue(xpath.getText(result, ',', 'MerchantId'));
        customerClass.CustomerInternalId = CheckValue(xpath.getText(result, ',', 'CustomerInternalId'));
        customerClass.CustomerId = CheckValue(xpath.getText(result, ',', 'CustomerId'));
        customerClass.FirstName = CheckValue(xpath.getText(result, ',', 'FirstName'));
        customerClass.LastName = CheckValue(xpath.getText(result, ',', 'LastName'));
        customerClass.CompanyName = CheckValue(xpath.getText(result, ',', 'CompanyName'));
        customerClass.Phone = CheckValue(xpath.getText(result, ',', 'Phone'));
        customerClass.CellPhone = CheckValue(xpath.getText(result, ',', 'CellPhone'));
        customerClass.Fax = CheckValue(xpath.getText(result, ',', 'Fax'));
        customerClass.Email = CheckValue(xpath.getText(result, ',', 'Email'));
        customerClass.WebSite = CheckValue(xpath.getText(result, ',', 'WebSite'));
        customerClass.customerToken = CheckValue(xpath.getText(result, ',', 'customerToken'));
        customerClass.CustomerNotes = CheckValue(xpath.getText(result, ',', 'CustomerNotes'));
        customerClass.DateTimeCreated = CheckValue(xpath.getText(result, ',', 'DateTimeCreated'));
        customerClass.DateTimeModified = CheckValue(xpath.getText(result, ',', 'DateTimeModified'));
        customerClass.SoftwareId = string.valueOf(Enums.FIELDVALUES.SalesforceApp);
      }
      CalloutModelClass.Address billingAddress = new CalloutModelClass.Address();
      for (Dom.XmlNode address: billingAddressList) {
        billingAddress.FirstName = CheckValue(xpath.getText(address, ',', 'FirstName'));
        billingAddress.LastName = CheckValue(xpath.getText(address, ',', 'LastName'));
        billingAddress.CompanyName = CheckValue(xpath.getText(address, ',', 'CompanyName'));
        billingAddress.Address1 = CheckValue(xpath.getText(address, ',', 'Address1'));
        billingAddress.Address2 = CheckValue(xpath.getText(address, ',', 'Address2'));
        billingAddress.Address3 = CheckValue(xpath.getText(address, ',', 'Address3'));
        billingAddress.Address4 = CheckValue(xpath.getText(address, ',', 'Address4'));
        billingAddress.Address5 = CheckValue(xpath.getText(address, ',', 'Address5'));
        billingAddress.Address6 = CheckValue(xpath.getText(address, ',', 'Address6'));
        billingAddress.City = CheckValue(xpath.getText(address, ',', 'City'));
        billingAddress.State = CheckValue(xpath.getText(address, ',', 'State'));
        billingAddress.ZipCode = CheckValue(xpath.getText(address, ',', 'ZipCode'));
        billingAddress.Country = CheckValue(xpath.getText(address, ',', 'Country'));
        billingAddress.IsDefault = CheckValue(xpath.getText(address, ',', 'IsDefault'));
        customerClass.BillingAddress = billingAddress;
      }
      CalloutModelClass.Address shippingAddress = new CalloutModelClass.Address();
      for (Dom.XmlNode address: shippingAddressList) {
        shippingAddress.FirstName = CheckValue(xpath.getText(address, ',', 'FirstName'));
        shippingAddress.LastName = CheckValue(xpath.getText(address, ',', 'LastName'));
        shippingAddress.CompanyName = CheckValue(xpath.getText(address, ',', 'CompanyName'));
        shippingAddress.Address1 = CheckValue(xpath.getText(address, ',', 'Address1'));
        shippingAddress.Address2 = CheckValue(xpath.getText(address, ',', 'Address2'));
        shippingAddress.Address3 = CheckValue(xpath.getText(address, ',', 'Address3'));
        shippingAddress.Address4 = CheckValue(xpath.getText(address, ',', 'Address4'));
        shippingAddress.Address5 = CheckValue(xpath.getText(address, ',', 'Address5'));
        shippingAddress.Address6 = CheckValue(xpath.getText(address, ',', 'Address6'));
        shippingAddress.City = CheckValue(xpath.getText(address, ',', 'City'));
        shippingAddress.State = CheckValue(xpath.getText(address, ',', 'State'));
        shippingAddress.ZipCode = CheckValue(xpath.getText(address, ',', 'ZipCode'));
        shippingAddress.Country = CheckValue(xpath.getText(address, ',', 'Country'));
        shippingAddress.IsDefault = CheckValue(xpath.getText(address, ',', 'IsDefault'));
        customerClass.ShippingAddress = shippingAddress;
        system.debug('check>>' + shippingAddress.Address1);
      }
  
      List < CalloutModelClass.PaymentMethodProfile > paymentMethodProfileLocal = new List < CalloutModelClass.PaymentMethodProfile > ();
      for (Dom.XmlNode paymentMethod: paymentMethodProfilesList) {
        CalloutModelClass.PaymentMethodProfile paymentMethodProfile = new CalloutModelClass.PaymentMethodProfile();
        paymentMethodProfile.MethodType = CheckValue(xpath.getText(paymentMethod, ',', 'MethodType'));
        paymentMethodProfile.MethodID = CheckValue(xpath.getText(paymentMethod, ',', 'MethodID'));
        paymentMethodProfile.MethodName = CheckValue(xpath.getText(paymentMethod, ',', 'MethodName'));
        paymentMethodProfile.SecondarySort = CheckValue(xpath.getText(paymentMethod, ',', 'SecondarySort'));
        paymentMethodProfile.Created = CheckValue(xpath.getText(paymentMethod, ',', 'Created'));
        paymentMethodProfile.Modified = CheckValue(xpath.getText(paymentMethod, ',', 'Modified'));
        paymentMethodProfile.Account = CheckValue(xpath.getText(paymentMethod, ',', 'Account'));
        paymentMethodProfile.AccountType = CheckValue(xpath.getText(paymentMethod, ',', 'AccountType'));
        paymentMethodProfile.AccountHolderName = CheckValue(xpath.getText(paymentMethod, ',', 'AccountHolderName'));
        paymentMethodProfile.DriversLicense = CheckValue(xpath.getText(paymentMethod, ',', 'DriversLicense'));
        paymentMethodProfile.DriversLicenseState = CheckValue(xpath.getText(paymentMethod, ',', 'DriversLicenseState'));
        paymentMethodProfile.RecordType = CheckValue(xpath.getText(paymentMethod, ',', 'RecordType'));
        paymentMethodProfile.Routing = CheckValue(xpath.getText(paymentMethod, ',', 'Routing'));
        paymentMethodProfile.AvsStreet = CheckValue(xpath.getText(paymentMethod, ',', 'AvsStreet'));
        paymentMethodProfile.AvsZip = CheckValue(xpath.getText(paymentMethod, ',', 'AvsZip'));
        paymentMethodProfile.CardCode = CheckValue(xpath.getText(paymentMethod, ',', 'CardCode'));
        paymentMethodProfile.CardExpiration = CheckValue(xpath.getText(paymentMethod, ',', 'CardExpiration'));
        paymentMethodProfile.CardNumber = CheckValue(xpath.getText(paymentMethod, ',', 'CardNumber'));
        paymentMethodProfile.CardType = CheckValue(xpath.getText(paymentMethod, ',', 'CardType'));
        paymentMethodProfile.Balance = CheckValue(xpath.getText(paymentMethod, ',', 'Balance'));
        paymentMethodProfile.MaxBalance = CheckValue(xpath.getText(paymentMethod, ',', 'MaxBalance'));
        paymentMethodProfile.AutoReload = CheckValue(xpath.getText(paymentMethod, ',', 'AutoReload'));
        paymentMethodProfile.ReloadSchedule = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadSchedule'));
        paymentMethodProfile.ReloadThreshold = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadThreshold'));
        paymentMethodProfile.ReloadAmount = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadAmount'));
        paymentMethodProfile.ReloadMethodID = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadMethodID'));
        paymentMethodProfileLocal.add(paymentMethodProfile);
        //add to customer class
        customerClass.PaymentMethodProfile = paymentMethodProfileLocal;
        system.debug('payment mathod class>>' + paymentMethodProfile);
        system.debug('payment mathod class local>>' + paymentMethodProfileLocal);
      }
  
      List < CalloutModelClass.EbizCustomField > customerCustomFieldsLocal = new List < CalloutModelClass.EbizCustomField > ();
      for (Dom.XmlNode customfield: customerCustomFieldsList) {
       CalloutModelClass.EbizCustomField customerCustomFields = new CalloutModelClass.EbizCustomField();
        customerCustomFields.FieldId = CheckValue(xpath.getText(customfield, ',', 'FieldId'));
        customerCustomFields.FieldCaption = CheckValue(xpath.getText(customfield, ',', 'FieldCaption'));
        customerCustomFields.FieldName = CheckValue(xpath.getText(customfield, ',', 'FieldName'));
        customerCustomFields.FieldValue = CheckValue(xpath.getText(customfield, ',', 'FieldValue'));
        customerCustomFields.FieldType = CheckValue(xpath.getText(customfield, ',', 'FieldType'));
        customerCustomFields.FieldDataType = CheckValue(xpath.getText(customfield, ',', 'FieldDataType'));
        customerCustomFields.FieldDescription = CheckValue(xpath.getText(customfield, ',', 'FieldDescription'));
        customerCustomFieldsLocal.add(customerCustomFields);
        //add to customer class
        customerClass.CustomerCustomFields = customerCustomFieldsLocal;
        system.debug('payment mathod class>>' + customerCustomFields);
        system.debug('payment mathod class local>>' + customerCustomFieldsLocal);
      }
      system.debug('billibg company name found>>' + billingAddress.CompanyName);
      system.debug('customer class>>' + customerClass.paymentMethodProfile);
      system.debug('customer class with all members>>' + customerClass);
      return customerClass;
    }
    //getSaleOrder
    public CalloutModelClass.SalesOrder GetSalesOrder(string securityId, String customerId, String salesOrderNumber) {
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.GetSalesOrderPayload(securityId,customerId,salesOrderNumber);
      CalloutModelClass.SalesOrder salesOrderClass = new CalloutModelClass.SalesOrder();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] getSalesOrderResultList = xpath.find('/s:Envelope/s:Body/GetSalesOrderResponse/GetSalesOrderResult');
      Dom.XmlNode[] billingAddressList = xpath.find('/s:Envelope/s:Body/GetSalesOrderResponse/GetSalesOrderResult/BillingAddress');
      Dom.XmlNode[] shippingAddressList = xpath.find('/s:Envelope/s:Body/GetSalesOrderResponse/GetSalesOrderResult/ShippingAddress');
      Dom.XmlNode[] itemsList = xpath.find('/s:Envelope/s:Body/GetSalesOrderResponse/GetSalesOrderResult/Items/Item');
      Dom.XmlNode[] salesOrderCustomFieldsList = xpath.find('/s:Envelope/s:Body/GetSalesOrderResponse/GetSalesOrderResult/SalesOrderCustomFields/EbizCustomField');
      for (Dom.XmlNode result: getSalesOrderResultList) {
        salesOrderClass.MerchantId = CheckValue(xpath.getText(result, ',', 'MerchantId'));
        salesOrderClass.CustomerId = CheckValue(xpath.getText(result, ',', 'CustomerId'));
        salesOrderClass.SubCustomerId = CheckValue(xpath.getText(result, ',', 'SubCustomerId'));
        salesOrderClass.SalesOrderNumber = CheckValue(xpath.getText(result, ',', 'SalesOrderNumber'));
        salesOrderClass.SalesOrderInternalId = CheckValue(xpath.getText(result, ',', 'SalesOrderInternalId'));
        salesOrderClass.Date_x = CheckValue(xpath.getText(result, ',', 'Date'));
        salesOrderClass.Currency_x = CheckValue(xpath.getText(result, ',','Currency'));
        salesOrderClass.Amount = CheckValue(xpath.getText(result, ',', 'Amount'));
        salesOrderClass.DueDate = CheckValue(xpath.getText(result, ',', 'DueDate'));
        salesOrderClass.AmountDue = CheckValue(xpath.getText(result, ',', 'AmountDue'));
        salesOrderClass.PoNum = CheckValue(xpath.getText(result, ',', 'PoNum'));
        salesOrderClass.DivisionId = CheckValue(xpath.getText(result, ',', 'DivisionId'));
        salesOrderClass.TypeId = CheckValue(xpath.getText(result, ',', 'TypeId'));
        salesOrderClass.UploadedBy = CheckValue(xpath.getText(result, ',', 'UploadedBy'));
        salesOrderClass.UpdatedBy = CheckValue(xpath.getText(result, ',', 'UpdatedBy'));
        salesOrderClass.DateUploaded = CheckValue(xpath.getText(result, ',', 'DateUploaded'));
        salesOrderClass.DateUpdated = CheckValue(xpath.getText(result, ',', 'DateUpdated'));
        salesOrderClass.isDeleted = CheckValue(xpath.getText(result, ',', 'isDeleted'));
        salesOrderClass.DeletedBy = CheckValue(xpath.getText(result, ',', 'DeletedBy'));
        salesOrderClass.DateDeleted = CheckValue(xpath.getText(result, ',', 'DateDeleted'));
        salesOrderClass.Software = CheckValue(xpath.getText(result, ',', 'Software'));
        salesOrderClass.NotifyCustomer = CheckValue(xpath.getText(result, ',', 'NotifyCustomer'));
        salesOrderClass.EmailTemplateID = CheckValue(xpath.getText(result, ',', 'EmailTemplateID'));
        salesOrderClass.URL = CheckValue(xpath.getText(result, ',', 'URL'));
        salesOrderClass.TotalTaxAmount = CheckValue(xpath.getText(result, ',', 'TotalTaxAmount'));
        salesOrderClass.UniqueId = CheckValue(xpath.getText(result, ',', 'UniqueId'));
        salesOrderClass.Description = CheckValue(xpath.getText(result, ',', 'Description'));
        salesOrderClass.CustomerMessage = CheckValue(xpath.getText(result, ',', 'CustomerMessage'));
        salesOrderClass.Memo = CheckValue(xpath.getText(result, ',', 'Memo'));
        salesOrderClass.ShipDate = CheckValue(xpath.getText(result, ',', 'ShipDate'));
        salesOrderClass.ShipVia = CheckValue(xpath.getText(result, ',', 'ShipVia'));
        salesOrderClass.SalesRepId = CheckValue(xpath.getText(result, ',', 'SalesRepId'));
        salesOrderClass.TermsId = CheckValue(xpath.getText(result, ',', 'TermsId'));
        salesOrderClass.IsToBeEmailed = CheckValue(xpath.getText(result, ',', 'IsToBeEmailed'));
        salesOrderClass.IsToBePrinted = CheckValue(xpath.getText(result, ',', 'IsToBePrinted'));
        salesOrderClass.SalesOrderLastSyncDateTime = CheckValue(xpath.getText(result, ',', 'SalesOrderLastSyncDateTime'));
        salesOrderClass.LocationId = CheckValue(xpath.getText(result, ',', 'LocationId'));
  
      }
      CalloutModelClass.Address billingAddress = new CalloutModelClass.Address();
      for (Dom.XmlNode address: billingAddressList) {
        billingAddress.FirstName = CheckValue(xpath.getText(address, ',', 'FirstName'));
        billingAddress.LastName = CheckValue(xpath.getText(address, ',', 'LastName'));
        billingAddress.CompanyName = CheckValue(xpath.getText(address, ',', 'CompanyName'));
        billingAddress.Address1 = CheckValue(xpath.getText(address, ',', 'Address1'));
        billingAddress.Address2 = CheckValue(xpath.getText(address, ',', 'Address2'));
        billingAddress.Address3 = CheckValue(xpath.getText(address, ',', 'Address3'));
        billingAddress.Address4 = CheckValue(xpath.getText(address, ',', 'Address4'));
        billingAddress.Address5 = CheckValue(xpath.getText(address, ',', 'Address5'));
        billingAddress.Address6 = CheckValue(xpath.getText(address, ',', 'Address6'));
        billingAddress.City = CheckValue(xpath.getText(address, ',', 'City'));
        billingAddress.State = CheckValue(xpath.getText(address, ',', 'State'));
        billingAddress.ZipCode = CheckValue(xpath.getText(address, ',', 'ZipCode'));
        billingAddress.Country = CheckValue(xpath.getText(address, ',', 'Country'));
        billingAddress.IsDefault = CheckValue(xpath.getText(address, ',', 'IsDefault'));
        salesOrderClass.BillingAddress = billingAddress;
      }
  
      CalloutModelClass.Address shippingAddress = new CalloutModelClass.Address();
      for (Dom.XmlNode address: shippingAddressList) {
        shippingAddress.FirstName = CheckValue(xpath.getText(address, ',', 'FirstName'));
        shippingAddress.LastName = CheckValue(xpath.getText(address, ',', 'LastName'));
        shippingAddress.CompanyName = CheckValue(xpath.getText(address, ',', 'CompanyName'));
        shippingAddress.Address1 = CheckValue(xpath.getText(address, ',', 'Address1'));
        shippingAddress.Address2 = CheckValue(xpath.getText(address, ',', 'Address2'));
        shippingAddress.Address3 = CheckValue(xpath.getText(address, ',', 'Address3'));
        shippingAddress.Address4 = CheckValue(xpath.getText(address, ',', 'Address4'));
        shippingAddress.Address5 = CheckValue(xpath.getText(address, ',', 'Address5'));
        shippingAddress.Address6 = CheckValue(xpath.getText(address, ',', 'Address6'));
        shippingAddress.City = CheckValue(xpath.getText(address, ',', 'City'));
        shippingAddress.State = CheckValue(xpath.getText(address, ',', 'State'));
        shippingAddress.ZipCode = CheckValue(xpath.getText(address, ',', 'ZipCode'));
        shippingAddress.Country = CheckValue(xpath.getText(address, ',', 'Country'));
        shippingAddress.IsDefault = CheckValue(xpath.getText(address, ',', 'IsDefault'));
        salesOrderClass.ShippingAddress = shippingAddress;
        system.debug('check>>' + shippingAddress.Address1);
      }
  
         Integer temp = 1;
         List < CalloutModelClass.CustomItem > itemsLocal = new List < CalloutModelClass.CustomItem > ();
  
      for (Dom.XmlNode item: itemsList) {
       Dom.XmlNode[] itemCustomFieldsList = xpath.find('/s:Envelope/s:Body/GetSalesOrderResponse/GetSalesOrderResult/Items/Item['+temp+']/ItemCustomFields/EbizCustomField');
       CalloutModelClass.CustomItem customItem = new CalloutModelClass.CustomItem();
        customItem.ItemInternalId = CheckValue(xpath.getText(item, ',', 'ItemInternalId'));
        customItem.ItemId = CheckValue(xpath.getText(item, ',', 'ItemId'));
        customItem.Name = CheckValue(xpath.getText(item, ',', 'Name'));
        customItem.Description = CheckValue(xpath.getText(item, ',', 'Description'));
        customItem.UnitPrice = CheckValue(xpath.getText(item, ',', 'UnitPrice'));
        customItem.Qty = CheckValue(xpath.getText(item, ',', 'Qty'));
        customItem.Taxable = CheckValue(xpath.getText(item, ',', 'Taxable'));
        customItem.TaxRate = CheckValue(xpath.getText(item, ',', 'TaxRate'));
        customItem.UnitOfMeasure = CheckValue(xpath.getText(item, ',', 'UnitOfMeasure'));
        customItem.TotalLineAmount = CheckValue(xpath.getText(item, ',', 'TotalLineAmount'));
        customItem.TotalLineTax = CheckValue(xpath.getText(item, ',', 'TotalLineTax'));
        customItem.ItemLineNumber = CheckValue(xpath.getText(item, ',', 'ItemLineNumber'));
        customItem.GrossPrice = CheckValue(xpath.getText(item, ',', 'GrossPrice'));
        customItem.WarrantyDiscount = CheckValue(xpath.getText(item, ',', 'WarrantyDiscount'));
        customItem.SalesDiscount = CheckValue(xpath.getText(item, ',', 'SalesDiscount'));
        customItem.ItemClass = CheckValue(xpath.getText(item, ',', 'ItemClass'));
       List < CalloutModelClass.EbizCustomField > itemCustomFieldsLocal = new List < CalloutModelClass.EbizCustomField > ();
      
       for (Dom.XmlNode customfield: itemCustomFieldsList) {
         
         CalloutModelClass.EbizCustomField itemCustomFields = new CalloutModelClass.EbizCustomField();
         itemCustomFields.FieldId = CheckValue(xpath.getText(customfield, ',', 'FieldId'));
         itemCustomFields.FieldCaption = CheckValue(xpath.getText(customfield, ',', 'FieldCaption'));
         itemCustomFields.FieldName = CheckValue(xpath.getText(customfield, ',', 'FieldName'));
         itemCustomFields.FieldValue = CheckValue(xpath.getText(customfield, ',', 'FieldValue'));
         itemCustomFields.FieldType = CheckValue(xpath.getText(customfield, ',', 'FieldType'));
         itemCustomFields.FieldDataType = CheckValue(xpath.getText(customfield, ',', 'FieldDataType'));
         itemCustomFields.FieldDescription = CheckValue(xpath.getText(customfield, ',', 'FieldDescription'));
         itemCustomFieldsLocal.add(itemCustomFields);
         //add to Items class
         customItem.ItemCustomFields = itemCustomFieldsLocal;
         system.debug('custom item custom field>>' + itemCustomFields);
         system.debug('custom iustom field local>>' + itemCustomFieldsLocal);
       }
       
       itemsLocal.add(customItem);
       
       //add to saleorder class
       salesOrderClass.Items = itemsLocal;
       temp++;
       system.debug('payment mathod class>>' + customItem);
       system.debug('payment mathod class local>>' + itemsLocal);
     }
  
      List < CalloutModelClass.EbizCustomField > salesOrderCustomFieldsLocal = new List < CalloutModelClass.EbizCustomField > ();
      for (Dom.XmlNode customfield: salesOrderCustomFieldsList) {
       CalloutModelClass.EbizCustomField salesOrderCustomFields = new CalloutModelClass.EbizCustomField();
        salesOrderCustomFields.FieldId = CheckValue(xpath.getText(customfield, ',', 'FieldId'));
        salesOrderCustomFields.FieldCaption = CheckValue(xpath.getText(customfield, ',', 'FieldCaption'));
        salesOrderCustomFields.FieldName = CheckValue(xpath.getText(customfield, ',', 'FieldName'));
        salesOrderCustomFields.FieldValue = CheckValue(xpath.getText(customfield, ',', 'FieldValue'));
        salesOrderCustomFields.FieldType = CheckValue(xpath.getText(customfield, ',', 'FieldType'));
        salesOrderCustomFields.FieldDataType = CheckValue(xpath.getText(customfield, ',', 'FieldDataType'));
        salesOrderCustomFields.FieldDescription = CheckValue(xpath.getText(customfield, ',', 'FieldDescription'));
        salesOrderCustomFieldsLocal.add(salesOrderCustomFields);
        //add to salesorder class
        salesOrderClass.SalesOrderCustomFields = salesOrderCustomFieldsLocal;
        system.debug('custom class>>' + salesOrderCustomFields);
        system.debug('custom class local>>' + salesOrderCustomFieldsLocal);
      }
  
      system.debug('billibg company name found>>' + billingAddress.CompanyName);
      system.debug('salesorder item class>>' + salesOrderClass.Items);
      system.debug('SalesOrder class with all members>>' + salesOrderClass);
      return salesOrderClass;
    }
    //getCustomerToken
     public String GetCustomerToken(string securityId, String customerId, String customerInternalId) {
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.GetCustomerTokenPayload(securityId,customerId,customerInternalId);
      String customerToken = '';
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] getCustomerTokenResultList = xpath.find('/s:Envelope/s:Body/GetCustomerTokenResponse');
      Dom.XmlNode result = getCustomerTokenResultList.get(0);
      customerToken = xpath.getText(result, ',', 'GetCustomerTokenResult');
      system.debug('getCustomerToken>>' + customerToken);
      return customerToken;
    }
    public CalloutModelClass.MerchantTransactionData GetMerchantTransactionData(String securityId) {
     CalloutRequestHelper payload = new CalloutRequestHelper();
     String responseBody = payload.GetMerchantTransactionDataPayload(securityId);
     CalloutModelClass.MerchantTransactionData merchantTransactionDataClass = new CalloutModelClass.MerchantTransactionData();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] getMerchantTransactionDataResultList = xpath.find('/s:Envelope/s:Body/GetMerchantTransactionDataResponse/GetMerchantTransactionDataResult');
      for (Dom.XmlNode result: getMerchantTransactionDataResultList) {
        merchantTransactionDataClass.ItemSKU = CheckValue(xpath.getText(result, ',', 'ItemSKU'));
        merchantTransactionDataClass.ItemCommodityCode = CheckValue(xpath.getText(result, ',', 'ItemCommodityCode'));
        merchantTransactionDataClass.ItemName = CheckValue(xpath.getText(result, ',', 'ItemName'));
        merchantTransactionDataClass.ItemDescription = CheckValue(xpath.getText(result, ',', 'ItemDescription'));
        merchantTransactionDataClass.ItemDiscountAmount = CheckValue(xpath.getText(result, ',', 'ItemDiscountAmount'));
        merchantTransactionDataClass.ItemDiscountRate = CheckValue(xpath.getText(result, ',', 'ItemDiscountRate'));
        merchantTransactionDataClass.ItemUnitOfMeasure = CheckValue(xpath.getText(result, ',', 'ItemUnitOfMeasure'));
        merchantTransactionDataClass.ItemUnitPrice = CheckValue(xpath.getText(result, ',', 'ItemUnitPrice'));
        merchantTransactionDataClass.ItemQty = CheckValue(xpath.getText(result, ',', 'ItemQty'));
        merchantTransactionDataClass.ItemTaxable = CheckValue(xpath.getText(result, ',', 'ItemTaxable'));
        merchantTransactionDataClass.ItemTaxAmount = CheckValue(xpath.getText(result, ',', 'ItemTaxAmount'));
        merchantTransactionDataClass.ItemTaxRate = CheckValue(xpath.getText(result, ',', 'ItemTaxRate'));
        merchantTransactionDataClass.DutyAmount = CheckValue(xpath.getText(result, ',', 'DutyAmount'));
        merchantTransactionDataClass.ShipFromZip = CheckValue(xpath.getText(result, ',', 'ShipFromZip'));
        merchantTransactionDataClass.ShippingAmount = CheckValue(xpath.getText(result, ',', 'ShippingAmount'));
        merchantTransactionDataClass.DiscountAmount = CheckValue(xpath.getText(result, ',', 'DiscountAmount '));
        merchantTransactionDataClass.AvsStreet = CheckValue(xpath.getText(result, ',', 'AvsStreet'));
        merchantTransactionDataClass.AvsZip = CheckValue(xpath.getText(result, ',', 'AvsZip'));
        merchantTransactionDataClass.AutoTax = CheckValue(xpath.getText(result, ',', 'AutoTax'));
        merchantTransactionDataClass.TaxPercentage = CheckValue(xpath.getText(result, ',', 'TaxPercentage'));
        merchantTransactionDataClass.AutoTip = CheckValue(xpath.getText(result, ',', 'AutoTip'));
        merchantTransactionDataClass.TipPercentage = CheckValue(xpath.getText(result, ',', 'TipPercentage'));
        merchantTransactionDataClass.PreAuthPercentage = CheckValue(xpath.getText(result, ',', 'PreAuthPercentage'));
        merchantTransactionDataClass.ExpireAuthAfter = CheckValue(xpath.getText(result, ',', 'ExpireAuthAfter'));
        merchantTransactionDataClass.AutoDiscount = CheckValue(xpath.getText(result, ',', 'AutoDiscount'));
        merchantTransactionDataClass.AutoItemDiscount = CheckValue(xpath.getText(result, ',', 'AutoItemDiscount'));
        merchantTransactionDataClass.DiscountPercentage = CheckValue(xpath.getText(result, ',', 'DiscountPercentage'));
        merchantTransactionDataClass.UseCaptureEnhancement = CheckValue(xpath.getText(result, ',', 'UseCaptureEnhancement'));
        merchantTransactionDataClass.IsEMVEnabled = CheckValue(xpath.getText(result, ',', 'IsEMVEnabled'));
        merchantTransactionDataClass.EnableAVSWarnings = CheckValue(xpath.getText(result, ',', 'EnableAVSWarnings'));
        merchantTransactionDataClass.EnableCVVWarnings = CheckValue(xpath.getText(result, ',', 'EnableCVVWarnings'));
        merchantTransactionDataClass.UseFullAmountForAVS = CheckValue(xpath.getText(result, ',', 'UseFullAmountForAVS'));
        merchantTransactionDataClass.DeclineTransactionIfAVSWarningsAreDisabled = CheckValue(xpath.getText(result, ',', 'DeclineTransactionIfAVSWarningsAreDisabled'));
        merchantTransactionDataClass.VerifyCreditCardBeforeSaving = CheckValue(xpath.getText(result, ',', 'VerifyCreditCardBeforeSaving'));
        merchantTransactionDataClass.AllowACHPayments = CheckValue(xpath.getText(result, ',', 'AllowACHPayments'));
        merchantTransactionDataClass.AllowACHPayments = CheckValue(xpath.getText(result, ',', 'AllowACHPayments'));
        merchantTransactionDataClass.IsSurchargeEnabled = CheckValue(xpath.getText(result, ',', 'IsSurchargeEnabled'));
        merchantTransactionDataClass.SurchargePercentage = CheckValue(xpath.getText(result, ',', 'SurchargePercentage'));
        merchantTransactionDataClass.SurchargeCaption = CheckValue(xpath.getText(result, ',', 'SurchargeCaption'));
  
      }
      system.debug('Marchent class>>' + merchantTransactionDataClass);
      return merchantTransactionDataClass;
  
    }
    public CalloutModelClass.PaymentMethodProfile GetCustomerPaymentMethodProfile(String securityId, String customerToken, String paymentMethodId) {
      CalloutRequestHelper payload = new CalloutRequestHelper();
      String responseBody = payload.GetCustomerPaymentMethodProfilePayload(securityId,customerToken,paymentMethodId);
      CalloutModelClass.PaymentMethodProfile paymentMethodProfile = new CalloutModelClass.PaymentMethodProfile();
      XPath xpath = new XPath(responseBody);
      Dom.XmlNode[] paymentMethodProfilesList = xpath.find('/s:Envelope/s:Body/GetCustomerPaymentMethodProfileResponse/GetCustomerPaymentMethodProfileResult');
      for (Dom.XmlNode paymentMethod: paymentMethodProfilesList) {
       paymentMethodProfile.MethodType = CheckValue(xpath.getText(paymentMethod, ',', 'MethodType'));
       paymentMethodProfile.MethodID = CheckValue(xpath.getText(paymentMethod, ',', 'MethodID'));
       paymentMethodProfile.MethodName = CheckValue(xpath.getText(paymentMethod, ',', 'MethodName'));
       paymentMethodProfile.SecondarySort = CheckValue(xpath.getText(paymentMethod, ',', 'SecondarySort'));
       paymentMethodProfile.Created = CheckValue(xpath.getText(paymentMethod, ',', 'Created'));
       paymentMethodProfile.Modified = CheckValue(xpath.getText(paymentMethod, ',', 'Modified'));
       paymentMethodProfile.Account = CheckValue(xpath.getText(paymentMethod, ',', 'Account'));
       paymentMethodProfile.AccountType = CheckValue(xpath.getText(paymentMethod, ',', 'AccountType'));
       paymentMethodProfile.AccountHolderName = CheckValue(xpath.getText(paymentMethod, ',', 'AccountHolderName'));
       paymentMethodProfile.DriversLicense = CheckValue(xpath.getText(paymentMethod, ',', 'DriversLicense'));
       paymentMethodProfile.DriversLicenseState = CheckValue(xpath.getText(paymentMethod, ',', 'DriversLicenseState'));
       paymentMethodProfile.RecordType = CheckValue(xpath.getText(paymentMethod, ',', 'RecordType'));
       paymentMethodProfile.Routing = CheckValue(xpath.getText(paymentMethod, ',', 'Routing'));
       paymentMethodProfile.AvsStreet = CheckValue(xpath.getText(paymentMethod, ',', 'AvsStreet'));
       paymentMethodProfile.AvsZip = CheckValue(xpath.getText(paymentMethod, ',', 'AvsZip'));
       paymentMethodProfile.CardCode = CheckValue(xpath.getText(paymentMethod, ',', 'CardCode'));
       paymentMethodProfile.CardExpiration = CheckValue(xpath.getText(paymentMethod, ',', 'CardExpiration'));
       paymentMethodProfile.CardNumber = CheckValue(xpath.getText(paymentMethod, ',', 'CardNumber'));
       paymentMethodProfile.CardType = CheckValue(xpath.getText(paymentMethod, ',', 'CardType'));
       paymentMethodProfile.Balance = CheckValue(xpath.getText(paymentMethod, ',', 'Balance'));
       paymentMethodProfile.MaxBalance = CheckValue(xpath.getText(paymentMethod, ',', 'MaxBalance'));
       paymentMethodProfile.AutoReload = CheckValue(xpath.getText(paymentMethod, ',', 'AutoReload'));
       paymentMethodProfile.ReloadSchedule = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadSchedule'));
       paymentMethodProfile.ReloadThreshold = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadThreshold'));
       paymentMethodProfile.ReloadAmount = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadAmount'));
       paymentMethodProfile.ReloadMethodID = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadMethodID'));
      }
      system.debug('Payment method class>>' + paymentMethodProfile);
      return paymentMethodProfile;
      
    }
    public CalloutModelClass.ArrayOfPaymentMethodProfile GetCustomerPaymentMethodProfiles(String securityId, String customerToken) {
       CalloutRequestHelper payload = new CalloutRequestHelper();
       String responseBody = payload.GetCustomerPaymentMethodProfilesPayload(securityId,customerToken);
       CalloutModelClass.ArrayOfPaymentMethodProfile arrayOfPaymentMethodProfile = new CalloutModelClass.ArrayOfPaymentMethodProfile();
       XPath xpath = new XPath(responseBody);
       Dom.XmlNode[] paymentMethodProfilesList = xpath.find('/s:Envelope/s:Body/GetCustomerPaymentMethodProfilesResponse/GetCustomerPaymentMethodProfilesResult/PaymentMethodProfile');
       List < CalloutModelClass.PaymentMethodProfile > paymentMethodProfileLocal = new List < CalloutModelClass.PaymentMethodProfile > ();
       for (Dom.XmlNode paymentMethod: paymentMethodProfilesList) {
         CalloutModelClass.PaymentMethodProfile paymentMethodProfile = new CalloutModelClass.PaymentMethodProfile();
         paymentMethodProfile.MethodType = CheckValue(xpath.getText(paymentMethod, ',', 'MethodType'));
         paymentMethodProfile.MethodID = CheckValue(xpath.getText(paymentMethod, ',', 'MethodID'));
         paymentMethodProfile.MethodName = CheckValue(xpath.getText(paymentMethod, ',', 'MethodName'));
         paymentMethodProfile.SecondarySort = CheckValue(xpath.getText(paymentMethod, ',', 'SecondarySort'));
         paymentMethodProfile.Created = CheckValue(xpath.getText(paymentMethod, ',', 'Created'));
         paymentMethodProfile.Modified = CheckValue(xpath.getText(paymentMethod, ',', 'Modified'));
         paymentMethodProfile.Account = CheckValue(xpath.getText(paymentMethod, ',', 'Account'));
         paymentMethodProfile.AccountType = CheckValue(xpath.getText(paymentMethod, ',', 'AccountType'));
         paymentMethodProfile.AccountHolderName = CheckValue(xpath.getText(paymentMethod, ',', 'AccountHolderName'));
         paymentMethodProfile.DriversLicense = CheckValue(xpath.getText(paymentMethod, ',', 'DriversLicense'));
         paymentMethodProfile.DriversLicenseState = CheckValue(xpath.getText(paymentMethod, ',', 'DriversLicenseState'));
         paymentMethodProfile.RecordType = CheckValue(xpath.getText(paymentMethod, ',', 'RecordType'));
         paymentMethodProfile.Routing = CheckValue(xpath.getText(paymentMethod, ',', 'Routing'));
         paymentMethodProfile.AvsStreet = CheckValue(xpath.getText(paymentMethod, ',', 'AvsStreet'));
         paymentMethodProfile.AvsZip = CheckValue(xpath.getText(paymentMethod, ',', 'AvsZip'));
         paymentMethodProfile.CardCode = CheckValue(xpath.getText(paymentMethod, ',', 'CardCode'));
         paymentMethodProfile.CardExpiration = CheckValue(xpath.getText(paymentMethod, ',', 'CardExpiration'));
         paymentMethodProfile.CardNumber = CheckValue(xpath.getText(paymentMethod, ',', 'CardNumber'));
         paymentMethodProfile.CardType = CheckValue(xpath.getText(paymentMethod, ',', 'CardType'));
         paymentMethodProfile.Balance = CheckValue(xpath.getText(paymentMethod, ',', 'Balance'));
         paymentMethodProfile.MaxBalance = CheckValue(xpath.getText(paymentMethod, ',', 'MaxBalance'));
         paymentMethodProfile.AutoReload = CheckValue(xpath.getText(paymentMethod, ',', 'AutoReload'));
         paymentMethodProfile.ReloadSchedule = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadSchedule'));
         paymentMethodProfile.ReloadThreshold = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadThreshold'));
         paymentMethodProfile.ReloadAmount = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadAmount'));
         paymentMethodProfile.ReloadMethodID = CheckValue(xpath.getText(paymentMethod, ',', 'ReloadMethodID'));
         paymentMethodProfileLocal.add(paymentMethodProfile);
         //add to customer class
         arrayOfPaymentMethodProfile.PaymentMethodProfiles = paymentMethodProfileLocal;
         system.debug('payment mathod class>>' + paymentMethodProfile);
         system.debug('payment mathod class local>>' + paymentMethodProfileLocal);
       }
       system.debug('Array of payments profile>>'+arrayOfPaymentMethodProfile);
       return arrayOfPaymentMethodProfile;
    }
    public CalloutModelClass.PaymentResponse MarkEbizWebFormPaymentAsApplied(String securityId, String paymentInternalId) {
       CalloutRequestHelper payload = new CalloutRequestHelper();
       String responseBody = payload.MarkEbizWebFormPaymentAsAppliedPayload(securityId,paymentInternalId);
       CalloutModelClass.PaymentResponse paymentResponseClass = new CalloutModelClass.PaymentResponse();
       XPath xpath = new XPath(responseBody);
       Dom.XmlNode[] paymentResponseList = xpath.find('/s:Envelope/s:Body/MarkEbizWebFormPaymentAsAppliedResponse/MarkEbizWebFormPaymentAsAppliedResult');
       for (Dom.XmlNode result: paymentResponseList) {
         paymentResponseClass.PaymentInternalId   = CheckValue(xpath.getText(result, ',', 'PaymentInternalId'));
         paymentResponseClass.Status   = CheckValue(xpath.getText(result, ',', 'Status'));
         paymentResponseClass.StatusCode   = CheckValue(xpath.getText(result, ',', 'StatusCode'));
         paymentResponseClass.Error   = CheckValue(xpath.getText(result, ',', 'Error'));
         paymentResponseClass.ErrorCode   = CheckValue(xpath.getText(result, ',', 'ErrorCode'));
       }
       system.debug('Payment Response Class>>'+paymentResponseClass);
       return paymentResponseClass;
    }
    public CalloutModelClass.ArrayOfEmailTemplate GetEmailTemplates(String securityId) {
       CalloutRequestHelper payload = new CalloutRequestHelper();
       String responseBody = payload.GetEmailTemplatesPayload(securityId);
       CalloutModelClass.ArrayOfEmailTemplate  arrayOfEmailTemplate= new CalloutModelClass.ArrayOfEmailTemplate();
       XPath xpath = new XPath(responseBody);
       Dom.XmlNode[] emailTemplateList = xpath.find('/s:Envelope/s:Body/GetEmailTemplatesResponse/GetEmailTemplatesResult/EmailTemplate');
       List < CalloutModelClass.EmailTemplate > emailTemplateLocal = new List < CalloutModelClass.EmailTemplate > ();
       for (Dom.XmlNode email: emailTemplateList) {
         CalloutModelClass.EmailTemplate emailTemplate = new CalloutModelClass.EmailTemplate();
         emailTemplate.TemplateName   = CheckValue(xpath.getText(email, ',', 'TemplateName'));
         emailTemplate.TemplateInternalId   = CheckValue(xpath.getText(email, ',', 'TemplateInternalId'));
         emailTemplate.TemplateSubject   = CheckValue(xpath.getText(email, ',', 'TemplateSubject'));
         emailTemplate.TemplateDescription   = CheckValue(xpath.getText(email, ',', 'TemplateDescription'));
         emailTemplate.TemplateHTML   = CheckValue(xpath.getText(email, ',', 'TemplateHTML'));
         emailTemplate.TemplateText   = CheckValue(xpath.getText(email, ',', 'TemplateText'));
         emailTemplate.FromEmail   = CheckValue(xpath.getText(email, ',', 'FromEmail'));
         emailTemplate.FromName   = CheckValue(xpath.getText(email, ',', 'FromName'));
         emailTemplate.ReplyToEmail   = CheckValue(xpath.getText(email, ',', 'ReplyToEmail'));
         emailTemplate.ReplyToDisplayName   = CheckValue(xpath.getText(email, ',', 'ReplyToDisplayName'));
         emailTemplate.TemplateSource   = CheckValue(xpath.getText(email, ',', 'TemplateSource'));
         emailTemplate.TemplateTypeId   = CheckValue(xpath.getText(email, ',', 'TemplateTypeId'));
         emailTemplateLocal.add(emailTemplate);
         //add to customer class
         arrayOfEmailTemplate.EmailTemplate = emailTemplateLocal;
         system.debug('Email templete class>>' + emailTemplate);
         system.debug('All email templetes class local>>' + emailTemplateLocal);
       }
       system.debug('Array of email templetes>>'+arrayOfEmailTemplate);
       return arrayOfEmailTemplate;
    
    }
    public CalloutModelClass.EmailReceiptResponse EmailReceipt(String securityId, String transactionRefNum, String receiptName, String emailAddress) {
       CalloutRequestHelper payload = new CalloutRequestHelper();
       String responseBody = payload.EmailReceiptPayload(securityId,transactionRefNum,receiptName,emailAddress);
       CalloutModelClass.EmailReceiptResponse emailReceiptResultClass = new CalloutModelClass.EmailReceiptResponse();
       XPath xpath = new XPath(responseBody);
       Dom.XmlNode[] emailReceiptResponseList = xpath.find('/s:Envelope/s:Body/EmailReceiptResponse/EmailReceiptResult');
       for (Dom.XmlNode result: emailReceiptResponseList) {
          emailReceiptResultClass.Status   = CheckValue(xpath.getText(result, ',', 'Status'));
          emailReceiptResultClass.StatusCode   = CheckValue(xpath.getText(result, ',', 'StatusCode'));
          emailReceiptResultClass.Error   = CheckValue(xpath.getText(result, ',', 'Error'));
          emailReceiptResultClass.ErrorCode   = CheckValue(xpath.getText(result, ',', 'ErrorCode'));
       }
       system.debug('Payment Response Class>>'+emailReceiptResultClass);
       return emailReceiptResultClass;
    
    }
    public CalloutModelClass.ArrayOfReceipt GetReceiptsList(String securityId, String receiptType) {
       CalloutRequestHelper payload = new CalloutRequestHelper();
       String responseBody = payload.GetReceiptsListPayload(securityId,receiptType);
       CalloutModelClass.ArrayOfReceipt  arrayOfReceipt = new CalloutModelClass.ArrayOfReceipt();
       XPath xpath = new XPath(responseBody);
       Dom.XmlNode[] arrayOfReceiptList = xpath.find('/s:Envelope/s:Body/GetReceiptsListResponse/GetReceiptsListResult/Receipt');
       List < CalloutModelClass.Receipt > receiptLocal = new List < CalloutModelClass.Receipt > ();
       for (Dom.XmlNode email: arrayOfReceiptList) {
         CalloutModelClass.Receipt receipt = new CalloutModelClass.Receipt();
         receipt.ReceiptRefNum  = CheckValue(xpath.getText(email, ',', 'ReceiptRefNum'));
         receipt.Name = CheckValue(xpath.getText(email, ',', 'Name'));
         receipt.Subject = CheckValue(xpath.getText(email, ',', 'Subject'));
         receipt.FromEmail = CheckValue(xpath.getText(email, ',', 'FromEmail'));
         receipt.Target = CheckValue(xpath.getText(email, ',', 'Target'));
         receipt.ContentType = CheckValue(xpath.getText(email, ',', 'ContentType'));
         receipt.TemplateHTML = CheckValue(xpath.getText(email, ',', 'TemplateHTML'));
         receipt.TemplateText = CheckValue(xpath.getText(email, ',', 'TemplateText'));
         receiptLocal.add(receipt);
         //add to customer class
         arrayOfReceipt.Receipt = receiptLocal;
         system.debug('recipt class>>' + receipt);
         system.debug('All Reciept>>' + receiptLocal);
       }
       system.debug('Array of Reciept>>'+arrayOfReceipt);
       return arrayOfReceipt;
 
    }
    public String SetDefaultCustomerPaymentMethodProfile(String securityId, String customerToken, String paymentMethodId) {
       CalloutRequestHelper payload = new CalloutRequestHelper();
       String responseBody = payload.SetDefaultCustomerPaymentMethodProfilePayload(securityId,customerToken,paymentMethodId);
       String responseFromGateway ;
       XPath xpath = new XPath(responseBody);
       Dom.XmlNode[] setDefaultCustomerPaymentMethodProfileList = xpath.find('/s:Envelope/s:Body/SetDefaultCustomerPaymentMethodProfileResponse');
       Dom.XmlNode result = setDefaultCustomerPaymentMethodProfileList.get(0);
       responseFromGateway = xpath.getText(result, ',', 'SetDefaultCustomerPaymentMethodProfileResult');
       system.debug('responseFromGateway>>' + responseFromGateway);
       return responseFromGateway;
    }
    public String ResendEbizWebFormEmail(String securityId, String paymentInternalId) {
       CalloutRequestHelper payload = new CalloutRequestHelper();
       String responseBody = payload.ResendEbizWebFormEmailPayload(securityId,paymentInternalId);
       String responseFromGateway ;
       XPath xpath = new XPath(responseBody);
       Dom.XmlNode[] resendEbizWebFormEmailList = xpath.find('/s:Envelope/s:Body/ResendEbizWebFormEmailResponse');
       Dom.XmlNode result = resendEbizWebFormEmailList.get(0);
       responseFromGateway = xpath.getText(result, ',', 'ResendEbizWebFormEmailResult');
       system.debug('responseFromGateway>>' + responseFromGateway);
       return responseFromGateway;
    }
    public CalloutModelClass.PaymentResponse MarkPaymentAsApplied(String securityId, String paymentInternalId) {
       CalloutRequestHelper payload = new CalloutRequestHelper();
       String responseBody = payload.MarkPaymentAsAppliedPayload(securityId,paymentInternalId);
       CalloutModelClass.PaymentResponse paymentResponseClass = new CalloutModelClass.PaymentResponse();
       XPath xpath = new XPath(responseBody);
       Dom.XmlNode[] paymentResponseList = xpath.find('/s:Envelope/s:Body/MarkPaymentAsAppliedResponse/MarkPaymentAsAppliedResult');
       for (Dom.XmlNode result: paymentResponseList) {
         paymentResponseClass.PaymentInternalId   = CheckValue(xpath.getText(result, ',', 'PaymentInternalId'));
         paymentResponseClass.Status   = CheckValue(xpath.getText(result, ',', 'Status'));
         paymentResponseClass.StatusCode   = CheckValue(xpath.getText(result, ',', 'StatusCode'));
         paymentResponseClass.Error   = CheckValue(xpath.getText(result, ',', 'Error'));
         paymentResponseClass.ErrorCode   = CheckValue(xpath.getText(result, ',', 'ErrorCode'));
       }
       system.debug('Payment Response Class>>'+paymentResponseClass);
       return paymentResponseClass;
    }
    public CalloutModelClass.PaymentResponse MarkRecurringPaymentAsApplied(String securityId, String paymentInternalId) {
     CalloutRequestHelper payload = new CalloutRequestHelper();
     String responseBody = payload.MarkRecurringPaymentAsAppliedPayload(securityId,paymentInternalId);
     CalloutModelClass.PaymentResponse paymentResponseClass = new CalloutModelClass.PaymentResponse();
     XPath xpath = new XPath(responseBody);
     Dom.XmlNode[] paymentResponseList = xpath.find('/s:Envelope/s:Body/MarkRecurringPaymentAsAppliedResponse/MarkRecurringPaymentAsAppliedResult');
     for (Dom.XmlNode result: paymentResponseList) {
       paymentResponseClass.PaymentInternalId   = CheckValue(xpath.getText(result, ',', 'PaymentInternalId'));
       paymentResponseClass.Status   = CheckValue(xpath.getText(result, ',', 'Status'));
       paymentResponseClass.StatusCode   = CheckValue(xpath.getText(result, ',', 'StatusCode'));
       paymentResponseClass.Error   = CheckValue(xpath.getText(result, ',', 'Error'));
       paymentResponseClass.ErrorCode   = CheckValue(xpath.getText(result, ',', 'ErrorCode'));
     }
     system.debug('Payment Response Class>>'+paymentResponseClass);
     return paymentResponseClass;
 
    }
    
    public CalloutModelClass.PaymentResponse DeleteEbizWebFormPayment(string securityId, String paymentInternalId) {
     CalloutRequestHelper payload = new CalloutRequestHelper();
     String responseBody = payload.DeleteEbizWebFormPaymentPayload(securityId,paymentInternalId);
     CalloutModelClass.PaymentResponse paymentResponseClass = new CalloutModelClass.PaymentResponse();
     XPath xpath = new XPath(responseBody);
     Dom.XmlNode[] paymentResponseList = xpath.find('/s:Envelope/s:Body/DeleteEbizWebFormPaymentResponse/DeleteEbizWebFormPaymentResult');
     for (Dom.XmlNode result: paymentResponseList) {
       paymentResponseClass.PaymentInternalId   = CheckValue(xpath.getText(result, ',', 'PaymentInternalId'));
       paymentResponseClass.Status   = CheckValue(xpath.getText(result, ',', 'Status'));
       paymentResponseClass.StatusCode   = CheckValue(xpath.getText(result, ',', 'StatusCode'));
       paymentResponseClass.Error   = CheckValue(xpath.getText(result, ',', 'Error'));
       paymentResponseClass.ErrorCode   = CheckValue(xpath.getText(result, ',', 'ErrorCode'));   
      }
      system.debug('before return>>' + paymentResponseClass);
      return paymentResponseClass;
    }
    public string AddCustomerPaymentMethodProfile(String securityId, String customerInternalId, CalloutModelClass.PaymentMethodProfile paymentMethodProfile) {
     CalloutRequestHelper payload = new CalloutRequestHelper();
     String responseBody = payload.AddCustomerPaymentMethodProfilePayload(securityId,customerInternalId,paymentMethodProfile);
     String responseFromGateway ;
     XPath xpath = new XPath(responseBody);
     Dom.XmlNode[] addCustomerPaymentMethodProfileList = xpath.find('/s:Envelope/s:Body/AddCustomerPaymentMethodProfileResponse');
     Dom.XmlNode result = addCustomerPaymentMethodProfileList.get(0);
     responseFromGateway = xpath.getText(result, ',', 'AddCustomerPaymentMethodProfileResult');
     system.debug('responseFromGateway>>' + responseFromGateway);
     return responseFromGateway;
    }
    public Boolean DeleteCustomerPaymentMethodProfile(String securityId, String customerToken, String paymentMethodId) {
     CalloutRequestHelper payload = new CalloutRequestHelper();
     String responseBody = payload.DeleteCustomerPaymentMethodProfilePayload(securityId,customerToken,paymentMethodId);
     Boolean responseFromGateway ;
     XPath xpath = new XPath(responseBody);
     Dom.XmlNode[] deleteCustomerPaymentMethodProfileList = xpath.find('/s:Envelope/s:Body/DeleteCustomerPaymentMethodProfileResponse');
     Dom.XmlNode result = deleteCustomerPaymentMethodProfileList.get(0);
     responseFromGateway = Boolean.valueOf(xpath.getText(result, ',', 'DeleteCustomerPaymentMethodProfileResult'));
     system.debug('responseFromGateway>>' + responseFromGateway);
     return responseFromGateway;
 
    }
    public Boolean UpdateCustomerPaymentMethodProfile(String securityId, String customerToken, CalloutModelClass.PaymentMethodProfile paymentMethodProfile) {
     CalloutRequestHelper payload = new CalloutRequestHelper();
     String responseBody = payload.UpdateCustomerPaymentMethodProfilePayload(securityId,customerToken,paymentMethodProfile);
     Boolean responseFromGateway ;
     XPath xpath = new XPath(responseBody);
     Dom.XmlNode[] updateCustomerPaymentMethodProfileList = xpath.find('/s:Envelope/s:Body/UpdateCustomerPaymentMethodProfileResponse');
     Dom.XmlNode result = updateCustomerPaymentMethodProfileList.get(0);
     responseFromGateway = Boolean.valueOf(xpath.getText(result, ',', 'UpdateCustomerPaymentMethodProfileResult'));
     system.debug('responseFromGateway>>' + responseFromGateway);
     return responseFromGateway;
   
   }
   public CalloutModelClass.ItemDetailsResponse AddItem(String securityId, CalloutModelClass.ItemDetails itemDetails) {
     CalloutRequestHelper payload = new CalloutRequestHelper();
     String responseBody = payload.AddItemPayload(securityId,itemDetails);
     CalloutModelClass.ItemDetailsResponse itemDetailsResponseClass = new CalloutModelClass.ItemDetailsResponse();
     XPath xpath = new XPath(responseBody);
     Dom.XmlNode[] itemDetailsResponseList = xpath.find('/s:Envelope/s:Body/AddItemResponse/AddItemResult');
     for (Dom.XmlNode result: itemDetailsResponseList) {
       itemDetailsResponseClass.ItemInternalId   = CheckValue(xpath.getText(result, ',', 'ItemInternalId'));
       itemDetailsResponseClass.Status   = CheckValue(xpath.getText(result, ',', 'Status'));
       itemDetailsResponseClass.StatusCode   = CheckValue(xpath.getText(result, ',', 'StatusCode'));
       itemDetailsResponseClass.Error   = CheckValue(xpath.getText(result, ',', 'Error'));
       itemDetailsResponseClass.ErrorCode   = CheckValue(xpath.getText(result, ',', 'ErrorCode'));   
      }
      system.debug('before return>>' + itemDetailsResponseClass);
      return itemDetailsResponseClass;
   }
   public CalloutModelClass.ItemDetailsResponse UpdateItem(String securityId, CalloutModelClass.ItemDetails itemDetails, String itemInternalId, String itemId) {
     CalloutRequestHelper payload = new CalloutRequestHelper();
     String responseBody = payload.UpdateItemPayload(securityId,itemDetails,itemInternalId,itemId);
     CalloutModelClass.ItemDetailsResponse itemDetailsResponseClass = new CalloutModelClass.ItemDetailsResponse();
     XPath xpath = new XPath(responseBody);
     Dom.XmlNode[] itemDetailsResponseList = xpath.find('/s:Envelope/s:Body/UpdateItemResponse/UpdateItemResult');
     for (Dom.XmlNode result: itemDetailsResponseList) {
       itemDetailsResponseClass.ItemInternalId   = CheckValue(xpath.getText(result, ',', 'ItemInternalId'));
       itemDetailsResponseClass.Status   = CheckValue(xpath.getText(result, ',', 'Status'));
       itemDetailsResponseClass.StatusCode   = CheckValue(xpath.getText(result, ',', 'StatusCode'));
       itemDetailsResponseClass.Error   = CheckValue(xpath.getText(result, ',', 'Error'));
       itemDetailsResponseClass.ErrorCode   = CheckValue(xpath.getText(result, ',', 'ErrorCode'));   
      }
      system.debug('before return>>' + itemDetailsResponseClass);
      return itemDetailsResponseClass;
   }
   public CalloutModelClass.ArrayOfItemDetails SearchItems(String securityId, String itemInternalId, String itemId, CalloutModelClass.ArrayOfSearchFilter filters, Integer start, Integer limit_x, String sort_x)  {
     CalloutRequestHelper payload = new CalloutRequestHelper();
     String responseBody = payload.SearchItemsPayload(securityId ,itemInternalId ,itemId ,filters ,start ,limit_x ,sort_x);
     CalloutModelClass.ArrayOfItemDetails arrayOfSearchItems = new CalloutModelClass.ArrayOfItemDetails();
     List<CalloutModelClass.ItemDetails> itemDetailsLocal = new List<CalloutModelClass.ItemDetails> (); 
     XPath xpath = new XPath(responseBody);
     Dom.XmlNode[] itemDetailsResultList = xpath.find('/s:Envelope/s:Body/SearchItemsResponse/SearchItemsResult/ItemDetails');
     Integer tempCount = 1;
     for (Dom.XmlNode result: itemDetailsResultList) {
       CalloutModelClass.ItemDetails itemDetailsClass = new CalloutModelClass.ItemDetails();
       Dom.XmlNode[] itemDetailsCustomFieldsList = xpath.find('/s:Envelope/s:Body/SearchItemsResponse/SearchItemsResult/ItemDetails['+tempCount+']/ItemCustomFields/EbizCustomField');
       itemDetailsClass.ItemInternalId = CheckValue(xpath.getText(result, ',', 'ItemInternalId'));
       itemDetailsClass.ItemId = CheckValue(xpath.getText(result, ',', 'ItemId'));
       itemDetailsClass.Name = CheckValue(xpath.getText(result, ',', 'Name'));
       itemDetailsClass.SKU = CheckValue(xpath.getText(result, ',', 'SKU'));
       itemDetailsClass.UPC = CheckValue(xpath.getText(result, ',', 'UPC'));
       itemDetailsClass.Description = CheckValue(xpath.getText(result, ',', 'Description'));
       itemDetailsClass.UnitPrice = CheckValue(xpath.getText(result, ',','UnitPrice'));
       itemDetailsClass.UnitCost = CheckValue(xpath.getText(result, ',', 'UnitCost'));
       itemDetailsClass.UnitOfMeasure = CheckValue(xpath.getText(result, ',', 'UnitOfMeasure'));
       itemDetailsClass.Active = CheckValue(xpath.getText(result, ',', 'Active'));
       itemDetailsClass.QtyOnHand = CheckValue(xpath.getText(result, ',', 'QtyOnHand'));
       itemDetailsClass.Taxable = CheckValue(xpath.getText(result, ',', 'Taxable'));
       itemDetailsClass.TaxRate = CheckValue(xpath.getText(result, ',', 'TaxRate'));
       itemDetailsClass.SoftwareId = CheckValue(xpath.getText(result, ',', 'SoftwareId'));
       itemDetailsClass.ItemCategoryId = CheckValue(xpath.getText(result, ',', 'ItemCategoryId'));
       itemDetailsClass.ItemNotes = CheckValue(xpath.getText(result, ',', 'ItemNotes'));
       itemDetailsClass.DateTimeCreated = CheckValue(xpath.getText(result, ',', 'DateTimeCreated'));
       itemDetailsClass.DateTimeModified = CheckValue(xpath.getText(result, ',', 'DateTimeModified'));
       itemDetailsClass.ItemUniqueId = CheckValue(xpath.getText(result, ',', 'ItemUniqueId'));
       itemDetailsClass.ImageUrl = CheckValue(xpath.getText(result, ',', 'ImageUrl'));
       itemDetailsClass.TaxCategoryID = CheckValue(xpath.getText(result, ',', 'TaxCategoryID'));
       itemDetailsClass.ItemLastSyncDateTime = CheckValue(xpath.getText(result, ',', 'ItemLastSyncDateTime'));
       itemDetailsClass.DivisionId = CheckValue(xpath.getText(result, ',', 'DivisionId'));
       itemDetailsClass.LocationId = CheckValue(xpath.getText(result, ',', 'LocationId'));
       List < CalloutModelClass.EbizCustomField > itemDetailsCustomFieldsLocal = new List < CalloutModelClass.EbizCustomField > ();
     for (Dom.XmlNode customfield: itemDetailsCustomFieldsList) {
       CalloutModelClass.EbizCustomField itemDetailsCustomFields = new CalloutModelClass.EbizCustomField();
       itemDetailsCustomFields.FieldId = CheckValue(xpath.getText(customfield, ',', 'FieldId'));
       itemDetailsCustomFields.FieldCaption = CheckValue(xpath.getText(customfield, ',', 'FieldCaption'));
       itemDetailsCustomFields.FieldName = CheckValue(xpath.getText(customfield, ',', 'FieldName'));
       itemDetailsCustomFields.FieldValue = CheckValue(xpath.getText(customfield, ',', 'FieldValue'));
       itemDetailsCustomFields.FieldType = CheckValue(xpath.getText(customfield, ',', 'FieldType'));
       itemDetailsCustomFields.FieldDataType = CheckValue(xpath.getText(customfield, ',', 'FieldDataType'));
       itemDetailsCustomFields.FieldDescription = CheckValue(xpath.getText(customfield, ',', 'FieldDescription'));
       itemDetailsCustomFieldsLocal.add(itemDetailsCustomFields);
       //add to Items
       itemDetailsClass.ItemCustomFields = itemDetailsCustomFieldsLocal;
       system.debug('custom class>>' + itemDetailsCustomFields);
       system.debug('custom class local>>' + itemDetailsCustomFieldsLocal);
     }
 
     itemDetailsLocal.add(itemDetailsClass);
     arrayOfSearchItems.ItemDetails = itemDetailsLocal;
     tempCount++;
     }
     system.debug('array of SalesOrders before return>>' + arrayOfSearchItems);
     return arrayOfSearchItems;
 
   }
   public CalloutModelClass.SalesOrderResponse AddSalesOrder(String securityId, CalloutModelClass.SalesOrder salesOrder) {
     CalloutRequestHelper payload = new CalloutRequestHelper();
     String responseBody = payload.AddSalesOrderPayload(securityId,salesOrder);
     CalloutModelClass.SalesOrderResponse salesOrderResponse = new CalloutModelClass.SalesOrderResponse();
     XPath xpath = new XPath(responseBody);
     Dom.XmlNode[] salesOrderResponseList = xpath.find('/s:Envelope/s:Body/AddSalesOrderResponse/AddSalesOrderResult');
     for (Dom.XmlNode result: salesOrderResponseList) {
       salesOrderResponse.SalesOrderNumber   = CheckValue(xpath.getText(result, ',', 'SalesOrderNumber'));
       salesOrderResponse.SalesOrderInternalId   = CheckValue(xpath.getText(result, ',', 'SalesOrderInternalId'));
       salesOrderResponse.Status   = CheckValue(xpath.getText(result, ',', 'Status'));
       salesOrderResponse.StatusCode   = CheckValue(xpath.getText(result, ',', 'StatusCode'));
       salesOrderResponse.Error   = CheckValue(xpath.getText(result, ',', 'Error'));
       salesOrderResponse.ErrorCode   = CheckValue(xpath.getText(result, ',', 'ErrorCode'));   
      }
      system.debug('before return>>' + salesOrderResponse);
      return salesOrderResponse;
 
   }
    public String CheckValue(String value) {
      string EmptyString = '';
      string ret = null;
      system.debug('valueis>>' + value);
      if (value != EmptyString) {
        system.debug('if valueis>>' + value);
        return value;
      } else {
        return ret;
      }
    }
  }