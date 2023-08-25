public with sharing class CalloutRequestHelper {
  public string GetTransactionDetailsPayload(string securityId,String transactionRefNum){
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
    request.setMethod('POST');
    request.setHeader('Accept-Encoding', 'gzip,deflate');
    request.setHeader('Content-Type', 'text/XML');
    request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/GetTransactionDetails');
    String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">';
    xmlBodyString += '<soapenv:Header/>';
    xmlBodyString += '<soapenv:Body>';
    xmlBodyString += '<ebiz:GetTransactionDetails>';
    xmlBodyString += '<ebiz:securityToken>';
    xmlBodyString +=  securityId == null ?  '' : '<ebiz:SecurityId>' +securityId+'</ebiz:SecurityId>';//required
    //xmlBodyString +=  UserId == null ?  '' : '<ebiz:UserId>' +UserId+'</ebiz:UserId>';
    //xmlBodyString +=  Password == null ?  '' : '<ebiz:Password>' +UserId+'</ebiz:Password>';
    xmlBodyString += '</ebiz:securityToken>';
    xmlBodyString +=  transactionRefNum == null ?  '' :'<ebiz:transactionRefNum>' +transactionRefNum+'</ebiz:transactionRefNum>';//required 
    xmlBodyString += '</ebiz:GetTransactionDetails>';
    xmlBodyString += '</soapenv:Body>';
    xmlBodyString += '</soapenv:Envelope>';
    request.setBody(xmlBodyString);
    system.debug('<<<request ' + request);
    system.debug('<<<body ' + request.getBody());
    HttpResponse response = http.send(request);
    system.debug('<<<response code ' + response.getStatusCode());
    system.debug('<<<response ' + response.getBody());
    return response.getBody();
  }
  public string RunCustomerTransactionPayload(string securityId, String custNum, String paymentMethodID, CalloutModelClass.CustomerTransactionRequest tran){
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    string customFieldsArray ='';
      if(tran.CustomFields!=null){
      for(CalloutModelClass.FieldValue result: tran.CustomFields)
      {
       customFieldsArray += '<ebiz:FieldValue>';
       customFieldsArray += result.Field == null ?  '' : '<ebiz:Field>'+result.Field+'</ebiz:Field>';
       customFieldsArray += result.Value == null ?  '' : '<ebiz:Value>'+result.Value+'</ebiz:Value>';
       customFieldsArray += '</ebiz:FieldValue>';
      }
    }
    else{
      customFieldsArray ='';
    }
    string lineItemArray ='';
      if(tran.LineItems!=null){
      for(CalloutModelClass.LineItem result: tran.LineItems)
      {
        lineItemArray += '<ebiz:LineItem>';
        lineItemArray += result.DiscountRate == null ?  '' : '<ebiz:DiscountRate>'+result.DiscountRate+'</ebiz:DiscountRate>';
        lineItemArray += result.ProductRefNum == null ?  '' : '<ebiz:ProductRefNum>'+result.ProductRefNum+'</ebiz:ProductRefNum>';
        lineItemArray += result.SKU == null ?  '' : '<ebiz:SKU>'+result.SKU+'</ebiz:SKU>';
        lineItemArray += result.CommodityCode == null ?  '' : '<ebiz:CommodityCode>'+result.CommodityCode+'</ebiz:CommodityCode>';
        lineItemArray += result.ProductName == null ?  '' : '<ebiz:ProductName>'+result.ProductName+'</ebiz:ProductName>';
        lineItemArray += result.Description == null ?  '' : '<ebiz:Description>'+result.Description+'</ebiz:Description>';
        lineItemArray += result.DiscountAmount == null ?  '' : '<ebiz:DiscountAmount>'+result.DiscountAmount+'</ebiz:DiscountAmount>';
        lineItemArray += result.TaxRate == null ?  '' : '<ebiz:TaxRate>'+result.TaxRate+'</ebiz:TaxRate>';
        lineItemArray += result.UnitOfMeasure == null ?  '' : '<ebiz:UnitOfMeasure>'+result.UnitOfMeasure+'</ebiz:UnitOfMeasure>';
        lineItemArray += result.UnitPrice == null ?  '' :  '<ebiz:UnitPrice>'+result.UnitPrice+'</ebiz:UnitPrice>';
        lineItemArray += result.Qty == null ?  '' : '<ebiz:Qty>'+result.Qty+'</ebiz:Qty>';
        lineItemArray += result.Taxable == null ?  '' : '<ebiz:Taxable>'+result.Taxable+'</ebiz:Taxable>';
        lineItemArray += result.TaxAmount == null ?  '' : '<ebiz:TaxAmount>'+result.TaxAmount+'</ebiz:TaxAmount>';
        lineItemArray +=  '</ebiz:LineItem>';
      }
    }
    else{
      lineItemArray ='';
    }
    request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
    request.setMethod('POST');
    request.setHeader('Accept-Encoding', 'gzip,deflate');
    request.setHeader('Content-Type', 'text/XML');
    request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/runCustomerTransaction');
    String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">';
    xmlBodyString += '<soapenv:Header/>';
    xmlBodyString += '<soapenv:Body>';
    xmlBodyString += '<ebiz:runCustomerTransaction>';
    xmlBodyString += '<ebiz:securityToken>';
    xmlBodyString +=  securityId == null ?  '' : '<ebiz:SecurityId>' +securityId+'</ebiz:SecurityId>';//required
    //xmlBodyString +=  UserId == null ?  '' : '<ebiz:UserId>' +UserId+'</ebiz:UserId>';
    //xmlBodyString +=  Password == null ?  '' : '<ebiz:Password>' +UserId+'</ebiz:Password>';
    xmlBodyString += '</ebiz:securityToken>';
    xmlBodyString +=  custNum== null ?  '' : '<ebiz:custNum>'+custNum+'</ebiz:custNum>';
    xmlBodyString += paymentMethodID== null ?  '' : '<ebiz:paymentMethodID>'+paymentMethodID+'</ebiz:paymentMethodID>';
    xmlBodyString += '<ebiz:tran>';
    xmlBodyString += tran.isRecurring== null ?  '' : '<ebiz:isRecurring>'+tran.isRecurring+'</ebiz:isRecurring>';
    xmlBodyString += tran.InventoryLocation== null ?  '' : '<ebiz:InventoryLocation>'+tran.InventoryLocation+'</ebiz:InventoryLocation>';
    xmlBodyString += tran.IgnoreDuplicate== null ?  '' : '<ebiz:IgnoreDuplicate>'+tran.IgnoreDuplicate+'</ebiz:IgnoreDuplicate>';//required
    xmlBodyString += '<ebiz:Details>';
    xmlBodyString += tran.Details.NonTax== null ?  '' : '<ebiz:NonTax>'+tran.Details.NonTax+'</ebiz:NonTax>';//required
    xmlBodyString += tran.Details.Tax== null ?  '' : '<ebiz:Tax>'+tran.Details.Tax+'</ebiz:Tax>';//required
    xmlBodyString += tran.Details.Table== null ?  '' : '<ebiz:Table>'+tran.Details.Table+'</ebiz:Table>';
    xmlBodyString += tran.Details.Subtotal== null ?  '' : '<ebiz:Subtotal>'+tran.Details.Subtotal+'</ebiz:Subtotal>';//required  
    xmlBodyString += tran.Details.Shipping== null ?  '' : '<ebiz:Shipping>'+tran.Details.Shipping+'</ebiz:Shipping>';//required
    xmlBodyString += tran.Details.ShipFromZip== null ?  '' : '<ebiz:ShipFromZip>'+tran.Details.ShipFromZip+'</ebiz:ShipFromZip>';
    xmlBodyString += tran.Details.SessionID== null ?  '' : '<ebiz:SessionID>'+tran.Details.SessionID+'</ebiz:SessionID>';
    xmlBodyString += tran.Details.PONum== null ?  '' : '<ebiz:PONum>'+tran.Details.PONum+'</ebiz:PONum>';  
    xmlBodyString += tran.Details.OrderID== null ?  '' : '<ebiz:OrderID>'+tran.Details.OrderID+'</ebiz:OrderID>';
    xmlBodyString += tran.Details.Invoice== null ?  '' : '<ebiz:Invoice>'+tran.Details.Invoice+'</ebiz:Invoice>';
    xmlBodyString += tran.Details.Duty== null ?  '' : '<ebiz:Duty>'+tran.Details.Duty+'</ebiz:Duty>';//required
    xmlBodyString += tran.Details.Discount== null ?  '' : '<ebiz:Discount>'+tran.Details.Discount+'</ebiz:Discount>';//required
    xmlBodyString += tran.Details.Comments== null ?  '' : '<ebiz:Comments>'+tran.Details.Comments+'</ebiz:Comments>';
    xmlBodyString += tran.Details.Description== null ?  '' : '<ebiz:Description>'+tran.Details.Description+'</ebiz:Description>';
    xmlBodyString += tran.Details.Currency_x== null ?  '' : '<ebiz:Currency>'+tran.Details.Currency_x+'</ebiz:Currency>';
    xmlBodyString += tran.Details.Clerk== null ?  '' : '<ebiz:Clerk>'+tran.Details.Clerk+'</ebiz:Clerk>';
    xmlBodyString += tran.Details.Amount== null ?  '' : '<ebiz:Amount>'+tran.Details.Amount+'</ebiz:Amount>';//required
    xmlBodyString += tran.Details.AllowPartialAuth== null ?  '' : '<ebiz:AllowPartialAuth>'+tran.Details.AllowPartialAuth+'</ebiz:AllowPartialAuth>';//required
    xmlBodyString += tran.Details.Terminal== null ?  '' : '<ebiz:Terminal>'+tran.Details.Terminal+'</ebiz:Terminal>';
    xmlBodyString += tran.Details.Tip== null ?  '' : '<ebiz:Tip>'+tran.Details.Tip+'</ebiz:Tip>';//required
    xmlBodyString += ' </ebiz:Details>';
    xmlBodyString += tran.MerchReceiptName== null ?  '' : '<ebiz:MerchReceiptName>'+tran.MerchReceiptName+'</ebiz:MerchReceiptName>';
    xmlBodyString += tran.MerchReceiptEmail== null ?  '' : '<ebiz:MerchReceiptEmail>'+tran.MerchReceiptEmail+'</ebiz:MerchReceiptEmail>';
    xmlBodyString += tran.Software== null ?  '' : '<ebiz:Software>'+tran.Software+'</ebiz:Software>';
    xmlBodyString += tran.MerchReceipt== null ?  '' : '<ebiz:MerchReceipt>'+tran.MerchReceipt+'</ebiz:MerchReceipt>';
    xmlBodyString += tran.CustReceiptName== null ?  '' : '<ebiz:CustReceiptName>'+tran.CustReceiptName+'</ebiz:CustReceiptName>';
    xmlBodyString += tran.CustReceiptEmail== null ?  '' : '<ebiz:CustReceiptEmail>'+tran.CustReceiptEmail+'</ebiz:CustReceiptEmail>';
    xmlBodyString += tran.CustReceipt== null ?  '' : '<ebiz:CustReceipt>'+tran.CustReceipt+'</ebiz:CustReceipt>';//required
    if(tran.CustomFields!=null){
      xmlBodyString += '<ebiz:CustomFields>';
      xmlBodyString += customFieldsArray;
      xmlBodyString += '</ebiz:CustomFields>';
    }
    xmlBodyString += tran.ClientIP== null ?  '' : '<ebiz:ClientIP>'+tran.ClientIP+'</ebiz:ClientIP>';
    xmlBodyString += tran.CardCode== null ?  '' : '<ebiz:CardCode>'+tran.CardCode+'</ebiz:CardCode>';
    xmlBodyString += tran.Command== null ?  '' : '<ebiz:Command>'+tran.Command+'</ebiz:Command>';
    xmlBodyString += '<ebiz:LineItems>';
    xmlBodyString += lineItemArray;
    xmlBodyString += '</ebiz:LineItems>';
    xmlBodyString += '</ebiz:tran>';
    xmlBodyString += '</ebiz:runCustomerTransaction>';
    xmlBodyString += '</soapenv:Body>';
    xmlBodyString += '</soapenv:Envelope>';
    request.setBody(xmlBodyString);
    system.debug('<<<request ' + request);
    system.debug('<<<body ' + request.getBody());
    HttpResponse response = http.send(request);
    system.debug('<<<response code ' + response.getStatusCode());
    system.debug('<<<response ' + response.getBody());
    return response.getBody();
  }
  public string GetRecurringFrequencyListPayload(string securityId){
 Http http = new Http();
 HttpRequest request = new HttpRequest();
 request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
 request.setMethod('POST');
 request.setHeader('Accept-Encoding', 'gzip,deflate');
 request.setHeader('Content-Type', 'text/XML');
 request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/GetRecurringFrequencyList');
    String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">';
    xmlBodyString += '<soapenv:Header/>';
    xmlBodyString += '<soapenv:Body>';
    xmlBodyString += '<ebiz:GetRecurringFrequencyList>';
    xmlBodyString += '<ebiz:securityToken>';
    xmlBodyString +=  securityId == null ?  '' : '<ebiz:SecurityId>' +securityId+'</ebiz:SecurityId>';//required
    //xmlBodyString +=  UserId == null ?  '' : '<ebiz:UserId>' +UserId+'</ebiz:UserId>';
    //xmlBodyString +=  Password == null ?  '' : '<ebiz:Password>' +UserId+'</ebiz:Password>';
    xmlBodyString += '</ebiz:securityToken>';
    xmlBodyString += ' </ebiz:GetRecurringFrequencyList>';
    xmlBodyString += '</soapenv:Body>';
    xmlBodyString += '</soapenv:Envelope>';
    request.setBody(xmlBodyString);
    system.debug('<<<request ' + request);
    system.debug('<<<body ' + request.getBody());
    HttpResponse response = http.send(request);
    system.debug('<<<response code ' + response.getStatusCode());
    system.debug('<<<response ' + response.getBody());
    return response.getBody();
  }
  public string GetSalesOrderPayload(string securityId, String customerId, String salesOrderNumber){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/XML');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/GetSalesOrder');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
       '<soapenv:Header/>' +
       '<soapenv:Body>' +
       '<ebiz:GetSalesOrder xmlns="http://ebizcharge.servicemodel.soap">' +
       '<ebiz:securityToken>' +
       '<ebiz:SecurityId>' + securityId + '</ebiz:SecurityId>' +
       '<UserId>salesforce1</UserId>' +
       '<Password>salesforce1</Password>' +
       '</ebiz:securityToken>' +
       // '<ebiz:customerInternalId>'+customerClass.customerInternalId+ '<ebiz:customerInternalId/>'+ 
       '<ebiz:customerId>' + customerId + '</ebiz:customerId>' +
       //'<ebiz:subCustomerId>?</ebiz:subCustomerId>'+
       '<ebiz:salesOrderNumber>' + salesOrderNumber + '</ebiz:salesOrderNumber>' +
       // '<ebiz:salesOrderInternalId>?</ebiz:salesOrderInternalId>'+
       '</ebiz:GetSalesOrder>' +
       '</soapenv:Body>' +
       '</soapenv:Envelope>';
       request.setBody(xmlBodyString);
       system.debug('<<<request ' + request);
       system.debug('<<<body ' + request.getBody());
       HttpResponse response = http.send(request);
       system.debug('<<<response code ' + response.getStatusCode());
       system.debug('<<<response ' + response.getBody());
       return response.getBody();
    }
    public string AddApplicationTransactionPayload(string securityId, CalloutModelClass.ApplicationTransactionRequest applicationTransactionRequest){
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      string customFieldsArray ='';
      system.debug('filters'+applicationTransactionRequest.TransactionCustomFields);
      if(applicationTransactionRequest.TransactionCustomFields!=null){
      for(CalloutModelClass.EbizCustomField result: applicationTransactionRequest.TransactionCustomFields)
      {
       customFieldsArray += '<ebiz:EbizCustomField>'+
      '<ebiz:FieldId>'+result.FieldId+'</ebiz:FieldId>'+
      '<ebiz:FieldCaption>'+result.FieldCaption+'</ebiz:FieldCaption>'+
      '<ebiz:FieldName>'+result.FieldName+'</ebiz:FieldName>'+
      '<ebiz:FieldValue>'+result.FieldValue+'</ebiz:FieldValue>'+
      '<ebiz:FieldType>'+result.FieldType+'</ebiz:FieldType>'+
      '<ebiz:FieldDataType>'+result.FieldDataType+'</ebiz:FieldDataType>'+
      '<ebiz:FieldDescription>'+result.FieldDescription+'</ebiz:FieldDescription>'+
      '</ebiz:EbizCustomField>';
      }
    }
    else{
      customFieldsArray ='';
    }
      request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
      request.setMethod('POST');
      request.setHeader('Accept-Encoding','gzip,deflate');
      request.setHeader('Content-Type', 'text/xml; charset=utf-8');
      request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/AddApplicationTransaction');
      String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
      '<soapenv:Header/>' +
      '<soapenv:Body>' +
      '<ebiz:AddApplicationTransaction>' +
      '<ebiz:securityToken>' +
      '<ebiz:SecurityId>' + securityId + '</ebiz:SecurityId>' +
      '<ebiz:UserId>sfbridge1</ebiz:UserId>' +
      '<ebiz:Password>sfbridge1</ebiz:Password>' +
      '</ebiz:securityToken>' +
      '<ebiz:applicationTransactionRequest>' +
      '<ebiz:CustomerInternalId>' + applicationTransactionRequest.CustomerInternalId + '</ebiz:CustomerInternalId>' +
      '<ebiz:TransactionId>' + applicationTransactionRequest.TransactionId + '</ebiz:TransactionId>' +
      '<ebiz:TransactionTypeId>' + applicationTransactionRequest.TransactionTypeId + '</ebiz:TransactionTypeId>' +
      '<ebiz:SoftwareId>' + applicationTransactionRequest.SoftwareId + '</ebiz:SoftwareId>' +
      '<ebiz:LinkedToTypeId>' + applicationTransactionRequest.LinkedToTypeId + '</ebiz:LinkedToTypeId>' +
      '<ebiz:LinkedToInternalId>' + applicationTransactionRequest.LinkedToInternalId + '</ebiz:LinkedToInternalId>' +
      '<ebiz:LinkedToExternalUniqueId>' + applicationTransactionRequest.LinkedToExternalUniqueId + '</ebiz:LinkedToExternalUniqueId>' +
      '<ebiz:TransactionDate>' + applicationTransactionRequest.TransactionDate + '</ebiz:TransactionDate>' +
      '<ebiz:TransactionNotes>' + applicationTransactionRequest.TransactionNotes + '</ebiz:TransactionNotes>' +
      '<ebiz:TransactionExternalReferenceNumber></ebiz:TransactionExternalReferenceNumber>' +
      '<ebiz:TransactionCustomFields>' +
      customFieldsArray+
      '</ebiz:TransactionCustomFields>' +
      '</ebiz:applicationTransactionRequest>' +
      '</ebiz:AddApplicationTransaction>' +
      '</soapenv:Body>' +
      '</soapenv:Envelope>';
      request.setBody(xmlBodyString);
      system.debug('<<<request ' + request);
      system.debug('<<<body ' + request.getBody());
      HttpResponse response = http.send(request);
      system.debug('<<<response code ' + response.getStatusCode());
      system.debug('<<<response ' + response.getBody());
      return response.getBody();
    }
    public string GetApplicationDataPayload(String applicationId, String lookupKey, String applicationDataInternalId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('GET');
        request.setHeader('Accept-Encoding','gzip,deflate');
        request.setHeader('Content-Type', 'text/xml; charset=utf-8');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/GetApplicationData');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
        '<soapenv:Header/>' +
        '<soapenv:Body>' +
        '<ebiz:GetApplicationData>' +
        '<ebiz:applicationId>' + applicationId + '</ebiz:applicationId>' + 
        '<ebiz:lookupKey>' + lookupKey + '</ebiz:lookupKey>' + 
        '<ebiz:applicationDataInternalId>' + applicationDataInternalId + '</ebiz:applicationDataInternalId>' + 
        '</ebiz:GetApplicationData>' + 
        '</soapenv:Body>' +
        '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    }
    public string UpdateApplicationDataPayload(String applicationId, String lookupKey, String applicationDataInternalId, CalloutModelClass.ApplicationData applicationData){
      CalloutModelClass.SecurityToken securityToken = new CalloutModelClass.SecurityToken();
      string securityTokenString = ''; 
      if(applicationData.securityToken != null){
        securityTokenString += '<SecurityId>'+ applicationData.securityToken.SecurityId +'</SecurityId>' +
        '<UserId>' + applicationData.securityToken.UserId +'</UserId>' +
        '<Password>' + applicationData.securityToken.Password + '</Password>';
      }else{
        securityTokenString ='';
      }
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
      request.setMethod('GET');
      request.setHeader('Accept-Encoding','gzip,deflate');
      request.setHeader('Content-Type', 'text/xml; charset=utf-8');
      request.setHeader('SOAPAction', 'http://ebizcharge.servicemodel.soap/IeBizService/UpdateApplicationData');
      String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
      '<soapenv:Header/>' +
      '<soapenv:Body>' +
      '<UpdateApplicationData xmlns="http://ebizcharge.servicemodel.soap">' + 
      '<applicationId>' + applicationId + '</applicationId>' +
      '<lookupKey>' + lookupKey + '</lookupKey>' +
      '<applicationData>' +
      '<Base64ParametersString>' + applicationData.Base64ParametersString + '</Base64ParametersString>' + 
      '<securityToken>' +
      securityTokenString +
      '</securityToken>'+
      '<ApplicationDataInternalId>' + applicationDataInternalId + '</ApplicationDataInternalId>' +
      '</applicationData>' +
      '</UpdateApplicationData>' +
      '</soapenv:Body>' +
      '</soapenv:Envelope>';
      request.setBody(xmlBodyString);
      system.debug('<<<request ' + request);
      system.debug('<<<body ' + request.getBody());
      HttpResponse response = http.send(request);
      system.debug('<<<response code ' + response.getStatusCode());
      system.debug('<<<response ' + response.getBody());
      return response.getBody();
    }
    public string AddApplicationDataPayload(string securityId,String applicationId, String lookupKey, String base64String){
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
      request.setMethod('POST');
      request.setHeader('Accept-Encoding', 'gzip,deflate');
      request.setHeader('Content-Type', 'text/XML');
      request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/AddApplicationData');
      String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
      '<soapenv:Header/>' +
      '<soapenv:Body>' +
      '<ebiz:AddApplicationData>' + 
      '<ebiz:securityToken>' +
       '<ebiz:SecurityId>'+ securityId +'</ebiz:SecurityId>' +
       '<ebiz:UserId>sfbridge1</ebiz:UserId>' +
       '<ebiz:Password>sfbridge1</ebiz:Password>' +
       '</ebiz:securityToken>' +
       '<ebiz:applicationId>' + applicationId + '</ebiz:applicationId>' +
       '<ebiz:lookupKey>' + lookupKey + '</ebiz:lookupKey>' +
       '<ebiz:base64String>' + base64String + '</ebiz:base64String>' +
       '</ebiz:AddApplicationData>' +
       '</soapenv:Body>' +
       '</soapenv:Envelope>';
       request.setBody(xmlBodyString);
       system.debug('<<<request ' + request);
       system.debug('<<<body ' + request.getBody());
       HttpResponse response = http.send(request);
       system.debug('<<<response code ' + response.getStatusCode());
       system.debug('<<<response ' + response.getBody());
       return response.getBody();
    }
    public string ScheduleRecurringPaymentPayload(string securityId,String customerInternalId, String paymentMethodProfileId, CalloutModelClass.RecurringBilling recurringBilling){
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
      request.setMethod('POST');
      request.setHeader('Accept-Encoding','gzip,deflate');
      request.setHeader('Content-Type', 'text/xml; charset=utf-8');
      request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/ScheduleRecurringPayment');
      String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">';
      xmlBodyString += '<soapenv:Header/>';
      xmlBodyString += '<soapenv:Body>';
      xmlBodyString += '<ebiz:ScheduleRecurringPayment>';
      xmlBodyString += '<ebiz:securityToken>'; 
      xmlBodyString +=  securityId == null ?  '' : '<ebiz:SecurityId>' +securityId+'</ebiz:SecurityId>';//required
      //xmlBodyString +=  UserId == null ?  '' : '<ebiz:UserId>' +UserId+'</ebiz:UserId>';
      //xmlBodyString +=  Password == null ?  '' : '<ebiz:Password>' +UserId+'</ebiz:Password>';
      xmlBodyString += '</ebiz:securityToken>';
      xmlBodyString +=  customerInternalId == null ?  '' :'<ebiz:customerInternalId>' +customerInternalId+'</ebiz:customerInternalId>';
      xmlBodyString +=  paymentMethodProfileId == null ?  '' :'<ebiz:paymentMethodProfileId>' +paymentMethodProfileId+'</ebiz:paymentMethodProfileId>';
      xmlBodyString += '<ebiz:recurringBilling>';//required
      xmlBodyString +=  recurringBilling.Amount == null ?  '' : '<ebiz:Amount>' +recurringBilling.Amount+'</ebiz:Amount>';//required
      xmlBodyString +=  recurringBilling.Tax == null ?  '' : '<ebiz:Tax>' +recurringBilling.Tax+'</ebiz:Tax>';//required
      xmlBodyString +=  recurringBilling.Enabled == null ?  '' :'<ebiz:Enabled>' +recurringBilling.Enabled+'</ebiz:Enabled>'; +//required
      xmlBodyString +=  recurringBilling.Start == null ?  '' :'<ebiz:Start>' +recurringBilling.Start+'</ebiz:Start>'; +//required
      xmlBodyString +=  recurringBilling.Expire == null ?  '' :'<ebiz:Expire>' +recurringBilling.Expire+'</ebiz:Expire>'; +//required
      xmlBodyString +=  recurringBilling.Next == null ?  '' :'<ebiz:Next>' +recurringBilling.Next+'</ebiz:Next>'; +//required
      xmlBodyString += recurringBilling.NumLeft  == null ?  '' : '<ebiz:NumLeft>'+recurringBilling.NumLeft+'</ebiz:NumLeft>';
      xmlBodyString +=  recurringBilling.RepeatCount == null ?  '' : '<ebiz:RepeatCount>' +recurringBilling.RepeatCount+'</ebiz:RepeatCount>';//required
      xmlBodyString +=  recurringBilling.Schedule == null ?  '' : '<ebiz:Schedule>' +recurringBilling.Schedule+'</ebiz:Schedule>';
      if(recurringBilling.CustomScheduleObject != null){
        xmlBodyString += '<ebiz:CustomScheduleObject>';
        xmlBodyString += recurringBilling.CustomScheduleObject.Interval == null ? '' : '<ebiz:Interval>'+recurringBilling.CustomScheduleObject.Interval+'</ebiz:Interval>';
        xmlBodyString += recurringBilling.CustomScheduleObject.Frequency == null ? '' : '<ebiz:Frequency>'+recurringBilling.CustomScheduleObject.Frequency+'</ebiz:Frequency>';
        xmlBodyString += '</ebiz:CustomScheduleObject>';
      }
      xmlBodyString += recurringBilling.ScheduleName  == null ? '' : '<ebiz:ScheduleName>'+recurringBilling.ScheduleName+'</ebiz:ScheduleName>';
      xmlBodyString += recurringBilling.ReceiptNote  == null ? '' : '<ebiz:ReceiptNote>'+recurringBilling.ReceiptNote+'</ebiz:ReceiptNote>'; 
      xmlBodyString += recurringBilling.ReceiptTemplateName  == null ? '' : '<ebiz:ReceiptTemplateName>'+recurringBilling.ReceiptTemplateName+'</ebiz:ReceiptTemplateName>';
      xmlBodyString += recurringBilling.SendCustomerReceipt  == null ? '' : '<ebiz:SendCustomerReceipt>'+recurringBilling.SendCustomerReceipt+'</ebiz:SendCustomerReceipt>';//required
      xmlBodyString += '</ebiz:recurringBilling>';
      xmlBodyString += '</ebiz:ScheduleRecurringPayment>';
      xmlBodyString +='</soapenv:Body>';
      xmlBodyString += '</soapenv:Envelope>';
      request.setBody(xmlBodyString);
      system.debug('<<<request ' + request);
      system.debug('<<<body ' + request.getBody());
      HttpResponse response = http.send(request);
      system.debug('<<<response code ' + response.getStatusCode());
      system.debug('<<<response ' + response.getBody());
      return response.getBody();
    }
    public string SearchScheduledRecurringPaymentsPayload(string securityId, String customerInternalId, String customerId, Integer start, Integer limit_x, String sort_x){
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
      request.setMethod('POST');
      request.setHeader('Accept-Encoding','gzip,deflate');
      request.setHeader('Content-Type', 'text/xml; charset=utf-8');
      request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/SearchScheduledRecurringPayments');
      String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">';
       xmlBodyString += '<soapenv:Header/>';
       xmlBodyString += '<soapenv:Body>';
       xmlBodyString += '<ebiz:SearchScheduledRecurringPayments>';
      xmlBodyString += '<ebiz:securityToken>'; 
      xmlBodyString +=  securityId == null ?  '' : '<ebiz:SecurityId>' +securityId+'</ebiz:SecurityId>';//required
      //xmlBodyString +=  UserId == null ?  '' : '<ebiz:UserId>' +UserId+'</ebiz:UserId>';
      //xmlBodyString +=  Password == null ?  '' : '<ebiz:Password>' +UserId+'</ebiz:Password>';
      xmlBodyString += '</ebiz:securityToken>';
      xmlBodyString +=  customerInternalId == null ?  '' :'<ebiz:customerInternalId>' +customerInternalId+'</ebiz:customerInternalId>';
      xmlBodyString +=  customerId == null ?  '' : '<ebiz:customerId>' +customerId+'</ebiz:customerId>';
      xmlBodyString +=   start== null ?  '' : '<ebiz:start>' +start+'</ebiz:start>';//required
      xmlBodyString +=   limit_x== null ?  '' : '<ebiz:limit>' +limit_x+'</ebiz:limit>';//required
      xmlBodyString +=   sort_x== null ?  '' : '<ebiz:sort>' +sort_x+'</ebiz:sort>';
      xmlBodyString += '</ebiz:SearchScheduledRecurringPayments>';
      xmlBodyString += '</soapenv:Body>';
      xmlBodyString += '</soapenv:Envelope>';
      request.setBody(xmlBodyString);
      system.debug('<<<request ' + request);
      system.debug('<<<body ' + request.getBody());
      HttpResponse response = http.send(request);
      system.debug('<<<response code ' + response.getStatusCode());
      system.debug('<<<response ' + response.getBody());
      return response.getBody();
    }
    public string GetRecurringSchedulePreviewPayload(string securityId,CalloutModelClass.RecurringBilling recurringBilling){
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
      request.setMethod('POST');
      request.setHeader('Accept-Encoding','gzip,deflate');
      request.setHeader('Content-Type', 'text/xml; charset=utf-8');
      request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/GetRecurringSchedulePreview');
      String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">'; 
      xmlBodyString += '<soapenv:Header/>';
      xmlBodyString += '<soapenv:Body>';
      xmlBodyString += '<ebiz:GetRecurringSchedulePreview>';
      xmlBodyString += '<ebiz:securityToken>';
      xmlBodyString +=  securityId == null ?  '' : '<ebiz:SecurityId>' +securityId+'</ebiz:SecurityId>';//required
      //xmlBodyString +=  UserId == null ?  '' : '<ebiz:UserId>' +UserId+'</ebiz:UserId>';
      //xmlBodyString +=  Password == null ?  '' : '<ebiz:Password>' +UserId+'</ebiz:Password>';
      xmlBodyString += '</ebiz:securityToken>';
      xmlBodyString +=  '<ebiz:recurringBilling>';//required
      xmlBodyString +=  recurringBilling.Amount == null ?  '' : '<ebiz:Amount>' +recurringBilling.Amount+'</ebiz:Amount>';//required
      xmlBodyString +=  recurringBilling.Tax == null ?  '' : '<ebiz:Tax>' +recurringBilling.Tax+'</ebiz:Tax>';//required
      xmlBodyString +=  recurringBilling.Enabled == null ?  '' : '<ebiz:Enabled>' +recurringBilling.Enabled+'</ebiz:Enabled>';//required
      xmlBodyString +=  recurringBilling.Start == null ?  '' : '<ebiz:Start>' +recurringBilling.Start+'</ebiz:Start>';//required
      xmlBodyString +=  recurringBilling.Expire == null ?  '' : '<ebiz:Expire>' +recurringBilling.Expire+'</ebiz:Expire>';//required
      xmlBodyString +=  recurringBilling.Next == null ?  '' : '<ebiz:Next>' +recurringBilling.Next+'</ebiz:Next>';//required
      xmlBodyString +=  recurringBilling.NumLeft == null ?  '' : '<ebiz:NumLeft>' +recurringBilling.NumLeft+'</ebiz:NumLeft>';
      xmlBodyString +=  recurringBilling.RepeatCount == null ?  '' : '<ebiz:RepeatCount>' +recurringBilling.RepeatCount+'</ebiz:RepeatCount>';//required
      xmlBodyString +=  recurringBilling.Schedule == null ?  '' : '<ebiz:Schedule>' +recurringBilling.Schedule+'</ebiz:Schedule>';
      if(recurringBilling.CustomScheduleObject != null){
        xmlBodyString += '<ebiz:CustomScheduleObject>';
        xmlBodyString += recurringBilling.CustomScheduleObject.Interval == null ? '' : '<ebiz:Interval>'+recurringBilling.CustomScheduleObject.Interval+'</ebiz:Interval>';
        xmlBodyString += recurringBilling.CustomScheduleObject.Frequency == null ? '' : '<ebiz:Frequency>'+recurringBilling.CustomScheduleObject.Frequency+'</ebiz:Frequency>';
        xmlBodyString += '</ebiz:CustomScheduleObject>';
      }
      xmlBodyString += recurringBilling.ScheduleName  == null ? '' : '<ebiz:ScheduleName>'+recurringBilling.ScheduleName+'</ebiz:ScheduleName>';
      xmlBodyString += recurringBilling.ReceiptNote  == null ? '' : '<ebiz:ReceiptNote>'+recurringBilling.ReceiptNote+'</ebiz:ReceiptNote>'; 
      xmlBodyString += recurringBilling.ReceiptTemplateName  == null ? '' : '<ebiz:ReceiptTemplateName>'+recurringBilling.ReceiptTemplateName+'</ebiz:ReceiptTemplateName>';
      xmlBodyString += recurringBilling.SendCustomerReceipt  == null ? '' : '<ebiz:SendCustomerReceipt>'+recurringBilling.SendCustomerReceipt+'</ebiz:SendCustomerReceipt>';//required
      xmlBodyString += '</ebiz:recurringBilling>';
      xmlBodyString += '</ebiz:GetRecurringSchedulePreview>';
      xmlBodyString += '</soapenv:Body>';
      xmlBodyString += '</soapenv:Envelope>';
      request.setBody(xmlBodyString);
      system.debug('<<<request ' + request);
      system.debug('<<<body ' + request.getBody());
      HttpResponse response = http.send(request);
      system.debug('<<<response code ' + response.getStatusCode());
      system.debug('<<<response ' + response.getBody());
      return response.getBody();
    }
    public string ModifyScheduledRecurringPaymentStatusPayload(string securityId,String scheduledPaymentInternalId, Integer statusId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding','gzip,deflate');
        request.setHeader('Content-Type', 'text/xml; charset=utf-8');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/ModifyScheduledRecurringPaymentStatus');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">';
        xmlBodyString += '<soapenv:Header/>';
        xmlBodyString += '<soapenv:Body>';
        xmlBodyString += '<ebiz:ModifyScheduledRecurringPaymentStatus>';
        xmlBodyString += '<ebiz:securityToken>';
        xmlBodyString +=  securityId == null ?  '' : '<ebiz:SecurityId>' +securityId+'</ebiz:SecurityId>';//required
        //xmlBodyString +=  UserId == null ?  '' : '<ebiz:UserId>' +UserId+'</ebiz:UserId>';
        //xmlBodyString +=  Password == null ?  '' : '<ebiz:Password>' +UserId+'</ebiz:Password>';
        xmlBodyString += '</ebiz:securityToken>';
        xmlBodyString += scheduledPaymentInternalId == null ?  '' :'<ebiz:scheduledPaymentInternalId>'+scheduledPaymentInternalId+'</ebiz:scheduledPaymentInternalId>';//required
        xmlBodyString +=  statusId== null ?  '' :'<ebiz:statusId>'+statusId+'</ebiz:statusId>';//required
        xmlBodyString += '</ebiz:ModifyScheduledRecurringPaymentStatus>';
        xmlBodyString += '</soapenv:Body>';
        xmlBodyString += '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    }
    public string SearchRecurringPaymentsPayload(string securityId,String scheduledPaymentInternalId, String customerId, String customerInternalId, String fromDateTime, String toDateTime, Integer start, Integer limit_x, String sort_x){
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
      request.setMethod('POST');
      request.setHeader('Accept-Encoding', 'gzip,deflate');
      request.setHeader('Content-Type', 'text/XML');
      request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/SearchRecurringPayments');
      String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">';
      xmlBodyString += '<soapenv:Header/>';
      xmlBodyString += '<soapenv:Body>';
      xmlBodyString += '<ebiz:SearchRecurringPayments>';
      xmlBodyString += '<ebiz:securityToken>';
      xmlBodyString +=  securityId == null ?  '' : '<ebiz:SecurityId>' +securityId+'</ebiz:SecurityId>';//required
      //xmlBodyString +=  UserId == null ?  '' : '<ebiz:UserId>' +UserId+'</ebiz:UserId>';
      //xmlBodyString +=  Password == null ?  '' : '<ebiz:Password>' +UserId+'</ebiz:Password>';
      xmlBodyString += '</ebiz:securityToken>';
      xmlBodyString +=  scheduledPaymentInternalId == null ?  '' :'<ebiz:scheduledPaymentInternalId>'+scheduledPaymentInternalId+'</ebiz:scheduledPaymentInternalId>';
      xmlBodyString +=  customerId== null ?  '' :'<ebiz:customerId>'+customerId+'</ebiz:customerId>';
      xmlBodyString +=  customerInternalId== null ?  '' :'<ebiz:customerInternalId>'+customerInternalId+'</ebiz:customerInternalId>';
      xmlBodyString +=  fromDateTime== null ?  '' :'<ebiz:fromDateTime>'+fromDateTime+'</ebiz:fromDateTime>';//required
      xmlBodyString +=  toDateTime== null ?  '' :'<ebiz:toDateTime>'+toDateTime+'</ebiz:toDateTime>';//required
      xmlBodyString +=  start== null ?  '' :'<ebiz:start>'+start+'</ebiz:start>';//required
      xmlBodyString +=  limit_x== null ?  '' :'<ebiz:limit>'+limit_x+'</ebiz:limit>';//required
      xmlBodyString +=  sort_x== null ?  '' :'<ebiz:sort>'+sort_x+'</ebiz:sort>';
      xmlBodyString += '</ebiz:SearchRecurringPayments>';
      xmlBodyString += '</soapenv:Body>';
      xmlBodyString += '</soapenv:Envelope>';
      request.setBody(xmlBodyString);
      system.debug('<<<request ' + request);
      system.debug('<<<body ' + request.getBody());
      HttpResponse response = http.send(request);
      system.debug('<<<response code ' + response.getStatusCode());
      system.debug('<<<response ' + response.getBody());
      return response.getBody(); 
    }
    public string ModifyScheduledRecurringPaymentRecurringBillingPayload(string securityId, String scheduledPaymentInternalId, CalloutModelClass.RecurringBilling recurringBilling){
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
      request.setMethod('POST');
      request.setHeader('Accept-Encoding', 'gzip,deflate');
      request.setHeader('Content-Type', 'text/XML');
      request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/ModifyScheduledRecurringPayment_RecurringBilling');
      String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">';
      xmlBodyString += '<soapenv:Header/>';
      xmlBodyString += '<soapenv:Body>';
      xmlBodyString += '<ebiz:ModifyScheduledRecurringPayment_RecurringBilling>';
      xmlBodyString += '<ebiz:securityToken>';
      xmlBodyString +=  securityId == null ?  '' : '<ebiz:SecurityId>' +securityId+'</ebiz:SecurityId>';//required
      //xmlBodyString +=  UserId == null ?  '' : '<ebiz:UserId>' +UserId+'</ebiz:UserId>';
      //xmlBodyString +=  Password == null ?  '' : '<ebiz:Password>' +UserId+'</ebiz:Password>';
      xmlBodyString += '</ebiz:securityToken>';
      xmlBodyString +=  scheduledPaymentInternalId== null ?  '' :'<ebiz:scheduledPaymentInternalId>'+scheduledPaymentInternalId+'</ebiz:scheduledPaymentInternalId>'; 
      xmlBodyString += '<ebiz:recurringBilling>';
      xmlBodyString +=  recurringBilling.Amount == null ?  '' : '<ebiz:Amount>' +recurringBilling.Amount+'</ebiz:Amount>';//required
      xmlBodyString +=  recurringBilling.Tax == null ?  '' : '<ebiz:Tax>' +recurringBilling.Tax+'</ebiz:Tax>';//required
      xmlBodyString +=  recurringBilling.Enabled == null ?  '' :'<ebiz:Enabled>' +recurringBilling.Enabled+'</ebiz:Enabled>'; +//required
      xmlBodyString +=  recurringBilling.Start == null ?  '' :'<ebiz:Start>' +recurringBilling.Start+'</ebiz:Start>'; +//required
      xmlBodyString +=  recurringBilling.Expire == null ?  '' :'<ebiz:Expire>' +recurringBilling.Expire+'</ebiz:Expire>'; +//required
      xmlBodyString +=  recurringBilling.Next == null ?  '' :'<ebiz:Next>' +recurringBilling.Next+'</ebiz:Next>'; +//required
      xmlBodyString += recurringBilling.NumLeft  == null ?  '' : '<ebiz:NumLeft>'+recurringBilling.NumLeft+'</ebiz:NumLeft>';
      xmlBodyString +=  recurringBilling.RepeatCount == null ?  '' : '<ebiz:RepeatCount>' +recurringBilling.RepeatCount+'</ebiz:RepeatCount>';//required
      xmlBodyString +=  recurringBilling.Schedule == null ?  '' : '<ebiz:Schedule>' +recurringBilling.Schedule+'</ebiz:Schedule>';
      if(recurringBilling.CustomScheduleObject != null){
        xmlBodyString += '<ebiz:CustomScheduleObject>';
        xmlBodyString += recurringBilling.CustomScheduleObject.Interval == null ? '' : '<ebiz:Interval>'+recurringBilling.CustomScheduleObject.Interval+'</ebiz:Interval>';
        xmlBodyString += recurringBilling.CustomScheduleObject.Frequency == null ? '' : '<ebiz:Frequency>'+recurringBilling.CustomScheduleObject.Frequency+'</ebiz:Frequency>';
        xmlBodyString += '</ebiz:CustomScheduleObject>';
      }
      xmlBodyString += recurringBilling.ScheduleName  == null ? '' : '<ebiz:ScheduleName>'+recurringBilling.ScheduleName+'</ebiz:ScheduleName>';
      xmlBodyString += '<ebiz:ReceiptNote>'+recurringBilling.ReceiptNote+'</ebiz:ReceiptNote>'; 
      xmlBodyString += recurringBilling.ReceiptTemplateName  == null ? '' : '<ebiz:ReceiptTemplateName>'+recurringBilling.ReceiptTemplateName+'</ebiz:ReceiptTemplateName>';
      xmlBodyString += recurringBilling.SendCustomerReceipt  == null ? '' : '<ebiz:SendCustomerReceipt>'+recurringBilling.SendCustomerReceipt+'</ebiz:SendCustomerReceipt>';//required
      xmlBodyString += '</ebiz:recurringBilling>';
      xmlBodyString += '</ebiz:ModifyScheduledRecurringPayment_RecurringBilling>';
      xmlBodyString += '</soapenv:Body>';
      xmlBodyString += '</soapenv:Envelope>';
      request.setBody(xmlBodyString);
      system.debug('<<<request ' + request);
      system.debug('<<<body ' + request.getBody());
      HttpResponse response = http.send(request);
      system.debug('<<<response code ' + response.getStatusCode());
      system.debug('<<<response ' + response.getBody());
      return response.getBody(); 
    }
    public string GetCustomerPayload(string securityId, string customer){
     Http http = new Http();
     HttpRequest request = new HttpRequest();
     request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
     request.setMethod('GET');
     request.setHeader('Accept-Encoding','gzip,deflate');
     request.setHeader('Content-Type', 'text/xml; charset=utf-8');
     request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/GetCustomer');
     String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
       '<soapenv:Header/>' +
       '<soapenv:Body>' +
       '<ebiz:GetCustomer xmlns="http://ebizcharge.servicemodel.soap">' +
       '<ebiz:securityToken>' +
       '<ebiz:SecurityId>' + securityId + '</ebiz:SecurityId>' +
       '<UserId>salesforce1</UserId>' +
       '<Password>salesforce1</Password>' +
       '</ebiz:securityToken>' +
       // '<ebiz:customerInternalId>'+customerClass.customerInternalId+ '<ebiz:customerInternalId/>'+
       '<ebiz:customerId>' + customer + '</ebiz:customerId>' +
       '</ebiz:GetCustomer>' +
       '</soapenv:Body>' +
       '</soapenv:Envelope>';
     request.setBody(xmlBodyString);
     system.debug('<<<request ' + request);
     system.debug('<<<body ' + request.getBody());
     HttpResponse response = http.send(request);
     system.debug('<<<response code ' + response.getStatusCode());
     system.debug('<<<response ' + response.getBody());
     return response.getBody();
    }
    public string GetCustomerTokenPayload(string securityId, String customerId, String customerInternalId){
     Http http = new Http();
     HttpRequest request = new HttpRequest();
     request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
     request.setMethod('POST');
     request.setHeader('Accept-Encoding', 'gzip,deflate');
     request.setHeader('Content-Type', 'text/XML');
     request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/GetCustomerToken');
     String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
       '<soapenv:Header/>' +
       '<soapenv:Body>' +
       '<ebiz:GetCustomerToken xmlns="http://ebizcharge.servicemodel.soap">' +
       '<ebiz:securityToken>' +
       '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
       '<UserId>salesforce1</UserId>' +
       '<Password>salesforce1</Password>' +
       '</ebiz:securityToken>' +
       '<ebiz:customerId>'+customerId+'</ebiz:customerId>' +
       '<ebiz:customerInternalId>'+customerInternalId+'</ebiz:customerInternalId>' +
       '</ebiz:GetCustomerToken>' +
       '</soapenv:Body>' +
       '</soapenv:Envelope>';
     request.setBody(xmlBodyString);
     system.debug('<<<request ' + request);
     system.debug('<<<body ' + request.getBody());
     HttpResponse response = http.send(request);
     system.debug('<<<response code ' + response.getStatusCode());
     system.debug('<<<response ' + response.getBody());
     return response.getBody();
    }
    public string GetMerchantTransactionDataPayload(String securityId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/XML');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/GetMerchantTransactionData');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
          '<soapenv:Header/>' +
          '<soapenv:Body>' +
          '<ebiz:GetMerchantTransactionData xmlns="http://ebizcharge.servicemodel.soap">' +
          '<ebiz:securityToken>' +
          '<ebiz:SecurityId>' + securityId + '</ebiz:SecurityId>' +
          '<UserId>salesforce1</UserId>' +
          '<Password>salesforce1</Password>' +
          '</ebiz:securityToken>' +
          '</ebiz:GetMerchantTransactionData>' +
          '</soapenv:Body>' +
          '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    }
    public string GetCustomerPaymentMethodProfilePayload(String securityId, String customerToken, String paymentMethodId){
     Http http = new Http();
     HttpRequest request = new HttpRequest();
     request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
     request.setMethod('GET');
     request.setHeader('Accept-Encoding','gzip,deflate');
     request.setHeader('Content-Type', 'text/xml; charset=utf-8');
     request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/GetCustomerPaymentMethodProfile');
     String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
       '<soapenv:Header/>' +
       '<soapenv:Body>' +
       '<ebiz:GetCustomerPaymentMethodProfile xmlns="http://ebizcharge.servicemodel.soap">' +
       '<ebiz:securityToken>' +
       '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
       '<UserId>salesforce1</UserId>' +
       '<Password>salesforce1</Password>' +
       '</ebiz:securityToken>' +
       '<ebiz:customerToken>'+customerToken+'</ebiz:customerToken>' +
       '<ebiz:paymentMethodId>'+paymentMethodId+'</ebiz:paymentMethodId>' +
       '</ebiz:GetCustomerPaymentMethodProfile>' +
       '</soapenv:Body>' +
       '</soapenv:Envelope>';
     request.setBody(xmlBodyString);
     system.debug('<<<request ' + request);
     system.debug('<<<body ' + request.getBody());
     HttpResponse response = http.send(request);
     system.debug('<<<response code ' + response.getStatusCode());
     system.debug('<<<response ' + response.getBody());
     return response.getBody();
    }
    public string GetCustomerPaymentMethodProfilesPayload(String securityId, String customerToken) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/XML');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/GetCustomerPaymentMethodProfiles');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
        '<soapenv:Header/>' +
        '<soapenv:Body>' +
        '<ebiz:GetCustomerPaymentMethodProfiles xmlns="http://ebizcharge.servicemodel.soap">' +
        '<ebiz:securityToken>' +
        '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
        '<UserId>salesforce1</UserId>' +
        '<Password>salesforce1</Password>' +
        '</ebiz:securityToken>' +
        '<ebiz:customerToken>'+customerToken+'</ebiz:customerToken>' +
        '</ebiz:GetCustomerPaymentMethodProfiles>' +
        '</soapenv:Body>' +
        '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    }
    public string MarkEbizWebFormPaymentAsAppliedPayload(String securityId, String paymentInternalId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/XML');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/MarkEbizWebFormPaymentAsApplied');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
        '<soapenv:Header/>' +
        '<soapenv:Body>' +
        '<ebiz:MarkEbizWebFormPaymentAsApplied xmlns="http://ebizcharge.servicemodel.soap">' +
        '<ebiz:securityToken>' +
        '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
        '<UserId>salesforce1</UserId>' +
        '<Password>salesforce1</Password>' +
        '</ebiz:securityToken>' +
        '<ebiz:paymentInternalId>'+paymentInternalId+'</ebiz:paymentInternalId>' +
        '</ebiz:MarkEbizWebFormPaymentAsApplied>'+
        '</soapenv:Body>' +
        '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    } 
    public string GetEmailTemplatesPayload(String securityId){
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
      request.setMethod('POST');
      request.setHeader('Accept-Encoding', 'gzip,deflate');
      request.setHeader('Content-Type', 'text/XML');
      request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/GetEmailTemplates');
      String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
      '<soapenv:Header/>' +
      '<soapenv:Body>' +
      '<ebiz:GetEmailTemplates xmlns="http://ebizcharge.servicemodel.soap">' +
      '<ebiz:securityToken>' +
      '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
      '<UserId>salesforce1</UserId>' +
      '<Password>salesforce1</Password>' +
      '</ebiz:securityToken>' +
      '</ebiz:GetEmailTemplates>' +
      '</soapenv:Body>' +
      '</soapenv:Envelope>';
      request.setBody(xmlBodyString);
      system.debug('<<<request ' + request);
      system.debug('<<<body ' + request.getBody());
      HttpResponse response = http.send(request);
      system.debug('<<<response code ' + response.getStatusCode());
      system.debug('<<<response ' + response.getBody());
      return response.getBody();
    }
    public string EmailReceiptPayload(String securityId, String transactionRefNum, String receiptName, String emailAddress){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/XML');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/EmailReceipt');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
        '<soapenv:Header/>' +
        '<soapenv:Body>' +
        '<ebiz:EmailReceipt xmlns="http://ebizcharge.servicemodel.soap">' +
        '<ebiz:securityToken>' +
        '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
        '<UserId>salesforce1</UserId>' +
        '<Password>salesforce1</Password>' +
        '</ebiz:securityToken>' +
        '<ebiz:transactionRefNum>'+transactionRefNum+'</ebiz:transactionRefNum>'+
        '<ebiz:receiptName>'+receiptName+'</ebiz:receiptName>'+
        '<ebiz:emailAddress>'+emailAddress+'</ebiz:emailAddress>'+
        '</ebiz:EmailReceipt>'+
        '</soapenv:Body>' +
        '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    }
    public string GetReceiptsListPayload(String securityId, String receiptType){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/XML');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/GetReceiptsList');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
        '<soapenv:Header/>' +
        '<soapenv:Body>' +
        '<ebiz:GetReceiptsList xmlns="http://ebizcharge.servicemodel.soap">' +
        '<ebiz:securityToken>' +
        '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
        '<UserId>salesforce1</UserId>' +
        '<Password>salesforce1</Password>' +
        '</ebiz:securityToken>' +
        '<ebiz:receiptType>'+receiptType+'</ebiz:receiptType>'+
        '</ebiz:GetReceiptsList>' +
        '</soapenv:Body>' +
        '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    }
    public string SetDefaultCustomerPaymentMethodProfilePayload(String securityId, String customerToken, String paymentMethodId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/XML');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/SetDefaultCustomerPaymentMethodProfile');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
          '<soapenv:Header/>' +
          '<soapenv:Body>' +
          '<ebiz:SetDefaultCustomerPaymentMethodProfile xmlns="http://ebizcharge.servicemodel.soap">' +
          '<ebiz:securityToken>' +
          '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
          '<UserId>salesforce1</UserId>' +
          '<Password>salesforce1</Password>' +
          '</ebiz:securityToken>' +
          '<ebiz:customerToken>'+customerToken+'</ebiz:customerToken>' +
          '<ebiz:paymentMethodId>'+paymentMethodId+'</ebiz:paymentMethodId>' +
          '</ebiz:SetDefaultCustomerPaymentMethodProfile>' +
          '</soapenv:Body>' +
          '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    }
    public string ResendEbizWebFormEmailPayload(String securityId, String paymentInternalId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/XML');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/ResendEbizWebFormEmail');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
          '<soapenv:Header/>' +
          '<soapenv:Body>' +
          '<ebiz:ResendEbizWebFormEmail xmlns="http://ebizcharge.servicemodel.soap">' +
          '<ebiz:securityToken>' +
          '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
          '<UserId>salesforce1</UserId>' +
          '<Password>salesforce1</Password>' +
          '</ebiz:securityToken>' +
          '<ebiz:paymentInternalId>'+paymentInternalId+'</ebiz:paymentInternalId>' +
          '</ebiz:ResendEbizWebFormEmail>' +
          '</soapenv:Body>' +
          '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    }
    public string MarkPaymentAsAppliedPayload(String securityId, String paymentInternalId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/XML');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/MarkPaymentAsApplied');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
        '<soapenv:Header/>' +
        '<soapenv:Body>' +
        '<ebiz:MarkPaymentAsApplied xmlns="http://ebizcharge.servicemodel.soap">' +
        '<ebiz:securityToken>' +
        '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
        '<UserId>salesforce1</UserId>' +
        '<Password>salesforce1</Password>' +
        '</ebiz:securityToken>' +
        '<ebiz:invoiceNumber></ebiz:invoiceNumber>'+
        '<ebiz:paymentInternalId>'+paymentInternalId+'</ebiz:paymentInternalId>' +
        '</ebiz:MarkPaymentAsApplied>'+
        '</soapenv:Body>' +
        '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    }
    public string MarkRecurringPaymentAsAppliedPayload(String securityId, String paymentInternalId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/XML');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/MarkRecurringPaymentAsApplied');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
        '<soapenv:Header/>' +
        '<soapenv:Body>' +
        '<ebiz:MarkRecurringPaymentAsApplied xmlns="http://ebizcharge.servicemodel.soap">' +
        '<ebiz:securityToken>' +
        '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
        '<UserId>salesforce1</UserId>' +
        '<Password>salesforce1</Password>' +
        '</ebiz:securityToken>' +
        '<ebiz:invoiceNumber></ebiz:invoiceNumber>'+
        '<ebiz:paymentInternalId>'+paymentInternalId+'</ebiz:paymentInternalId>' +
        '</ebiz:MarkRecurringPaymentAsApplied>'+
        '</soapenv:Body>' +
        '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    }
    public string SearchSalesOrdersPayload(String securityId, String customerId, String subCustomerId, String salesOrderNumber, String salesOrderInternalId, CalloutModelClass.ArrayOfSearchFilter filters, Integer start, Integer limit_x, String sort_x, Boolean includeItems){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/XML');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/SearchSalesOrders');
        string filtersArray ='';
        system.debug('filters'+filters.SearchFilter);
        if(filters.SearchFilter!=null){
        for(CalloutModelClass.SearchFilter result: filters.SearchFilter)
        {
         filtersArray += '<ebiz:SearchFilter>'+
        '<ebiz:FieldName>'+result.FieldName+'</ebiz:FieldName>'+
        '<ebiz:ComparisonOperator>'+result.ComparisonOperator+'</ebiz:ComparisonOperator>'+
        '<ebiz:FieldValue>'+result.FieldValue+'</ebiz:FieldValue>'+
        '</ebiz:SearchFilter>';
        }
      }
      else{
        filtersArray ='';
      }
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
        '<soapenv:Header/>' +
        '<soapenv:Body>' +
        '<ebiz:SearchSalesOrders xmlns="http://ebizcharge.servicemodel.soap">' +
        '<ebiz:securityToken>' +
        '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
        '<UserId>salesforce1</UserId>' +
        '<Password>salesforce1</Password>' +
        '</ebiz:securityToken>' +
        '<ebiz:customerId>'+customerId+'</ebiz:customerId>'+
        '<ebiz:subCustomerId>'+subCustomerId+'</ebiz:subCustomerId>'+
        '<ebiz:salesOrderNumber>'+salesOrderNumber+'</ebiz:salesOrderNumber>'+
        '<ebiz:salesOrderInternalId>'+salesOrderInternalId+'</ebiz:salesOrderInternalId>'+
        '<ebiz:filters>'+
          filtersArray+
        '</ebiz:filters>'+
        '<ebiz:start>'+start+'</ebiz:start>'+
        '<ebiz:limit>'+limit_x+'</ebiz:limit>' +
        '<ebiz:sort>'+sort_x+'</ebiz:sort>'+
        '<ebiz:includeItems>'+includeItems+'</ebiz:includeItems>'+
        '</ebiz:SearchSalesOrders>'+
        '</soapenv:Body>' +
        '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    }
    public string DeleteEbizWebFormPaymentPayload(String securityId, String paymentInternalId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/XML');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/DeleteEbizWebFormPayment');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
        '<soapenv:Header/>' +
        '<soapenv:Body>' +
        '<ebiz:DeleteEbizWebFormPayment xmlns="http://ebizcharge.servicemodel.soap">' +
        '<ebiz:securityToken>' +
        '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
        '<UserId>salesforce1</UserId>' +
        '<Password>salesforce1</Password>' +
        '</ebiz:securityToken>' +
        '<ebiz:invoiceNumber></ebiz:invoiceNumber>'+
        '<ebiz:paymentInternalId>'+paymentInternalId+'</ebiz:paymentInternalId>' +
        '</ebiz:DeleteEbizWebFormPayment>'+
        '</soapenv:Body>' +
        '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    }
    public string AddCustomerPaymentMethodProfilePayload(String securityId, String customerInternalId, CalloutModelClass.PaymentMethodProfile paymentMethodProfile) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/XML');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/AddCustomerPaymentMethodProfile');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
        '<soapenv:Header/>' +
        '<soapenv:Body>' +
        '<ebiz:AddCustomerPaymentMethodProfile xmlns="http://ebizcharge.servicemodel.soap">' +
        '<ebiz:securityToken>' +
        '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
        '<UserId>salesforce1</UserId>' +
        '<Password>salesforce1</Password>' +
        '</ebiz:securityToken>' +
        '<ebiz:customerInternalId>'+customerInternalId+'</ebiz:customerInternalId>'+
        '<ebiz:paymentMethodProfile>'+
        '<ebiz:MethodType>'+paymentMethodProfile.MethodType+'</ebiz:MethodType>'+
        '<ebiz:MethodID>'+paymentMethodProfile.MethodID+'</ebiz:MethodID>'+
        '<ebiz:MethodName>'+paymentMethodProfile.MethodName+'</ebiz:MethodName>'+
        '<ebiz:SecondarySort>'+paymentMethodProfile.SecondarySort+'</ebiz:SecondarySort>'+
        '<ebiz:Created>'+paymentMethodProfile.Created+'</ebiz:Created>'+
        '<ebiz:Modified>'+paymentMethodProfile.Modified+'</ebiz:Modified>'+
        '<ebiz:Account>'+paymentMethodProfile.Account+'</ebiz:Account>'+
        '<ebiz:AccountType>'+paymentMethodProfile.AccountType+'</ebiz:AccountType>'+
        '<ebiz:AccountHolderName>'+paymentMethodProfile.AccountHolderName+'</ebiz:AccountHolderName>'+
        '<ebiz:DriversLicense>'+paymentMethodProfile.DriversLicense+'</ebiz:DriversLicense>'+
        '<ebiz:DriversLicenseState>'+paymentMethodProfile.DriversLicenseState+'</ebiz:DriversLicenseState>'+
        '<ebiz:RecordType>'+paymentMethodProfile.RecordType+'</ebiz:RecordType>'+
        '<ebiz:Routing>'+paymentMethodProfile.Routing+'</ebiz:Routing>'+
        '<ebiz:AvsStreet>'+paymentMethodProfile.AvsStreet+'</ebiz:AvsStreet>'+
        '<ebiz:AvsZip>'+paymentMethodProfile.AvsZip+'</ebiz:AvsZip>'+
        '<ebiz:CardCode>'+paymentMethodProfile.CardCode+'</ebiz:CardCode>'+
        '<ebiz:CardExpiration>'+paymentMethodProfile.CardExpiration+'</ebiz:CardExpiration>'+
        '<ebiz:CardNumber>'+paymentMethodProfile.CardNumber+'</ebiz:CardNumber>'+
        '<ebiz:CardType>'+paymentMethodProfile.CardType+'</ebiz:CardType>'+
        '<ebiz:Balance>'+paymentMethodProfile.Balance+'</ebiz:Balance>'+
        '<ebiz:MaxBalance>'+paymentMethodProfile.MaxBalance+'</ebiz:MaxBalance>'+
        '<ebiz:AutoReload>'+paymentMethodProfile.AutoReload+'</ebiz:AutoReload>'+
        '<ebiz:ReloadSchedule>'+paymentMethodProfile.ReloadSchedule+'</ebiz:ReloadSchedule>'+
        '<ebiz:ReloadThreshold>'+paymentMethodProfile.ReloadThreshold+'</ebiz:ReloadThreshold>'+
        '<ebiz:ReloadAmount>'+paymentMethodProfile.ReloadAmount+'</ebiz:ReloadAmount>'+
        '<ebiz:ReloadMethodID>'+paymentMethodProfile.ReloadMethodID+'</ebiz:ReloadMethodID>'+
        '</ebiz:paymentMethodProfile>'+
        '</ebiz:AddCustomerPaymentMethodProfile>'+
        '</soapenv:Body>' +
        '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    }
    public string DeleteCustomerPaymentMethodProfilePayload(String securityId, String customerToken, String paymentMethodId){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
        request.setMethod('POST');
        request.setHeader('Accept-Encoding', 'gzip,deflate');
        request.setHeader('Content-Type', 'text/XML');
        request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/DeleteCustomerPaymentMethodProfile');
        String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
        '<soapenv:Header/>' +
        '<soapenv:Body>' +
        '<ebiz:DeleteCustomerPaymentMethodProfile xmlns="http://ebizcharge.servicemodel.soap">' +
        '<ebiz:securityToken>' +
        '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
        '<UserId>salesforce1</UserId>' +
        '<Password>salesforce1</Password>' +
        '</ebiz:securityToken>' +
        '<ebiz:customerToken>'+customerToken+'</ebiz:customerToken>'+
        '<ebiz:paymentMethodId>'+paymentMethodId+'</ebiz:paymentMethodId>' +
        '</ebiz:DeleteCustomerPaymentMethodProfile>'+
        '</soapenv:Body>' +
        '</soapenv:Envelope>';
        request.setBody(xmlBodyString);
        system.debug('<<<request ' + request);
        system.debug('<<<body ' + request.getBody());
        HttpResponse response = http.send(request);
        system.debug('<<<response code ' + response.getStatusCode());
        system.debug('<<<response ' + response.getBody());
        return response.getBody();
    }
    public string UpdateCustomerPaymentMethodProfilePayload(String securityId, String customerToken, CalloutModelClass.PaymentMethodProfile paymentMethodProfile) {
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
      request.setMethod('POST');
      request.setHeader('Accept-Encoding', 'gzip,deflate');
      request.setHeader('Content-Type', 'text/XML');
      request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/UpdateCustomerPaymentMethodProfile');
      String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
      '<soapenv:Header/>' +
      '<soapenv:Body>' +
      '<ebiz:UpdateCustomerPaymentMethodProfile xmlns="http://ebizcharge.servicemodel.soap">' +
      '<ebiz:securityToken>' +
      '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
      '<UserId>salesforce1</UserId>' +
      '<Password>salesforce1</Password>' +
      '</ebiz:securityToken>' +
      '<ebiz:customerToken>'+customerToken+'</ebiz:customerToken>'+
      '<ebiz:paymentMethodProfile>'+
      '<ebiz:MethodType>'+paymentMethodProfile.MethodType+'</ebiz:MethodType>'+
      '<ebiz:MethodID>'+paymentMethodProfile.MethodID+'</ebiz:MethodID>'+
      '<ebiz:MethodName>'+paymentMethodProfile.MethodName+'</ebiz:MethodName>'+
      '<ebiz:SecondarySort>'+paymentMethodProfile.SecondarySort+'</ebiz:SecondarySort>'+
      '<ebiz:Created>'+paymentMethodProfile.Created+'</ebiz:Created>'+
      '<ebiz:Modified>'+paymentMethodProfile.Modified+'</ebiz:Modified>'+
      '<ebiz:Account>'+paymentMethodProfile.Account+'</ebiz:Account>'+
      '<ebiz:AccountType>'+paymentMethodProfile.AccountType+'</ebiz:AccountType>'+
      '<ebiz:AccountHolderName>'+paymentMethodProfile.AccountHolderName+'</ebiz:AccountHolderName>'+
      '<ebiz:DriversLicense>'+paymentMethodProfile.DriversLicense+'</ebiz:DriversLicense>'+
      '<ebiz:DriversLicenseState>'+paymentMethodProfile.DriversLicenseState+'</ebiz:DriversLicenseState>'+
      '<ebiz:RecordType>'+paymentMethodProfile.RecordType+'</ebiz:RecordType>'+
      '<ebiz:Routing>'+paymentMethodProfile.Routing+'</ebiz:Routing>'+
      '<ebiz:AvsStreet>'+paymentMethodProfile.AvsStreet+'</ebiz:AvsStreet>'+
      '<ebiz:AvsZip>'+paymentMethodProfile.AvsZip+'</ebiz:AvsZip>'+
      '<ebiz:CardCode>'+paymentMethodProfile.CardCode+'</ebiz:CardCode>'+
      '<ebiz:CardExpiration>'+paymentMethodProfile.CardExpiration+'</ebiz:CardExpiration>'+
      '<ebiz:CardNumber>'+paymentMethodProfile.CardNumber+'</ebiz:CardNumber>'+
      '<ebiz:CardType>'+paymentMethodProfile.CardType+'</ebiz:CardType>'+
      '<ebiz:Balance>'+paymentMethodProfile.Balance+'</ebiz:Balance>'+
      '<ebiz:MaxBalance>'+paymentMethodProfile.MaxBalance+'</ebiz:MaxBalance>'+
      '<ebiz:AutoReload>'+paymentMethodProfile.AutoReload+'</ebiz:AutoReload>'+
      '<ebiz:ReloadSchedule>'+paymentMethodProfile.ReloadSchedule+'</ebiz:ReloadSchedule>'+
      '<ebiz:ReloadThreshold>'+paymentMethodProfile.ReloadThreshold+'</ebiz:ReloadThreshold>'+
      '<ebiz:ReloadAmount>'+paymentMethodProfile.ReloadAmount+'</ebiz:ReloadAmount>'+
      '<ebiz:ReloadMethodID>'+paymentMethodProfile.ReloadMethodID+'</ebiz:ReloadMethodID>'+
      '</ebiz:paymentMethodProfile>'+
      '</ebiz:UpdateCustomerPaymentMethodProfile>'+
      '</soapenv:Body>' +
      '</soapenv:Envelope>';
      request.setBody(xmlBodyString);
      system.debug('<<<request ' + request);
      system.debug('<<<body ' + request.getBody());
      HttpResponse response = http.send(request);
      system.debug('<<<response code ' + response.getStatusCode());
      system.debug('<<<response ' + response.getBody());
      return response.getBody();
  }
  public string AddItemPayload(String securityId, CalloutModelClass.ItemDetails itemDetails){
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    string customFieldsArray ='';
        system.debug('filters'+itemDetails.ItemCustomFields);
        if(itemDetails.ItemCustomFields!=null){
        for(CalloutModelClass.EbizCustomField result: itemDetails.ItemCustomFields)
        {
          customFieldsArray += '<ebiz:EbizCustomField>'+
        '<ebiz:FieldId>'+result.FieldId+'</ebiz:FieldId>'+
        '<ebiz:FieldName>'+result.FieldName+'</ebiz:FieldName>'+
        '<ebiz:FieldValue>'+result.FieldValue+'</ebiz:FieldValue>'+
        '<ebiz:FieldType>'+result.FieldType+'</ebiz:FieldType>'+
        '<ebiz:FieldDataType>'+result.FieldDataType+'</ebiz:FieldDataType>'+
        '<ebiz:FieldDescription>'+result.FieldDescription+'</ebiz:FieldDescription>'+
        '</ebiz:EbizCustomField>';
        }
      }
      else{
        customFieldsArray ='';
      }
    request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
    request.setMethod('POST');
    request.setHeader('Accept-Encoding', 'gzip,deflate');
    request.setHeader('Content-Type', 'text/XML');
    request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/AddItem');
    String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
    '<soapenv:Header/>' +
    '<soapenv:Body>' +
    '<ebiz:AddItem xmlns="http://ebizcharge.servicemodel.soap">' +
    '<ebiz:securityToken>' +
    '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
    '<UserId>salesforce1</UserId>' +
    '<Password>salesforce1</Password>' +
    '</ebiz:securityToken>' +
    '<ebiz:itemDetails>'+
    '<ebiz:ItemInternalId>'+itemDetails.ItemInternalId+'</ebiz:ItemInternalId>'+
    '<ebiz:ItemId>'+itemDetails.ItemId+'</ebiz:ItemId>'+
    '<ebiz:Name>'+itemDetails.Name+'</ebiz:Name>'+
    '<ebiz:SKU>'+itemDetails.SKU+'</ebiz:SKU>'+
    '<ebiz:UPC>'+itemDetails.UPC+'</ebiz:UPC>'+
    '<ebiz:Description>'+itemDetails.Description+'</ebiz:Description>'+
    '<ebiz:UnitPrice>'+itemDetails.UnitPrice+'</ebiz:UnitPrice>'+
    '<ebiz:UnitCost>'+itemDetails.UnitCost+'</ebiz:UnitCost>'+
    '<ebiz:UnitOfMeasure>'+itemDetails.UnitOfMeasure+'</ebiz:UnitOfMeasure>'+
    '<ebiz:Active>'+itemDetails.Active+'</ebiz:Active>'+
    '<ebiz:ItemType>'+itemDetails.ItemType+'</ebiz:ItemType>'+
    '<ebiz:QtyOnHand>'+itemDetails.QtyOnHand+'</ebiz:QtyOnHand>'+
    '<ebiz:Taxable>'+itemDetails.Taxable+'</ebiz:Taxable>'+
    '<ebiz:TaxRate>'+itemDetails.TaxRate+'</ebiz:TaxRate>'+
    '<ebiz:SoftwareId>'+itemDetails.SoftwareId+'</ebiz:SoftwareId>'+
    '<ebiz:ItemCategoryId>'+itemDetails.ItemCategoryId+'</ebiz:ItemCategoryId>'+
    '<ebiz:ItemNotes>'+itemDetails.ItemNotes+'</ebiz:ItemNotes>'+
    '<ebiz:DateTimeCreated>'+itemDetails.DateTimeCreated+'</ebiz:DateTimeCreated>'+
    '<ebiz:DateTimeModified>'+itemDetails.DateTimeModified+'</ebiz:DateTimeModified>'+
    '<ebiz:ItemUniqueId>'+itemDetails.ItemUniqueId+'</ebiz:ItemUniqueId>'+
    '<ebiz:ImageUrl>'+itemDetails.ImageUrl+'</ebiz:ImageUrl>'+
    '<ebiz:TaxCategoryID>'+itemDetails.TaxCategoryID+'</ebiz:TaxCategoryID>'+
    '<ebiz:ItemCustomFields>'+
    customFieldsArray+
    '</ebiz:ItemCustomFields>'+
    '<ebiz:ItemLastSyncDateTime>'+itemDetails.ItemLastSyncDateTime+'</ebiz:ItemLastSyncDateTime>'+
    '<ebiz:DivisionId>'+itemDetails.DivisionId+'</ebiz:DivisionId>'+
    '<ebiz:LocationId>'+itemDetails.LocationId+'</ebiz:LocationId>'+
    '</ebiz:itemDetails>'+
    '</ebiz:AddItem>'+
    '</soapenv:Body>' +
    '</soapenv:Envelope>';
    request.setBody(xmlBodyString);
    system.debug('<<<request ' + request);
    system.debug('<<<body ' + request.getBody());
    HttpResponse response = http.send(request);
    system.debug('<<<response code ' + response.getStatusCode());
    system.debug('<<<response ' + response.getBody());
    return response.getBody();
  }
  public String SearchCustomerListPayload(string securityId,CalloutModelClass.ArrayOfSearchFilter filters, Integer start, Integer limit_x, String sort_x, Boolean includeCustomerToken, Boolean includePaymentMethodProfiles, Boolean countOnly) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
    request.setMethod('POST');
    request.setHeader('Accept-Encoding', 'gzip,deflate');
    request.setHeader('Content-Type', 'text/XML');
    request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/SearchCustomerList');
    string filtersArray ='';
    system.debug('filters'+filters.SearchFilter);
    if(filters.SearchFilter!=null){
    for(CalloutModelClass.SearchFilter result: filters.SearchFilter)
    {
     filtersArray += '<ebiz:SearchFilter>'+
    '<ebiz:FieldName>'+result.FieldName+'</ebiz:FieldName>'+
    '<ebiz:ComparisonOperator>'+result.ComparisonOperator+'</ebiz:ComparisonOperator>'+
    '<ebiz:FieldValue>'+result.FieldValue+'</ebiz:FieldValue>'+
    '</ebiz:SearchFilter>';
    }
    }
    else{
    filtersArray ='';
    }
    String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
    '<soapenv:Header/>' +
    '<soapenv:Body>' +
    '<ebiz:SearchCustomerList>' +
    '<ebiz:securityToken>' +
    '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
    '<ebiz:UserId>salesforce1</ebiz:UserId>' +
    '<ebiz:Password>salesforce1</ebiz:Password>' +
    '</ebiz:securityToken>' +
    '<ebiz:filters>'+
      filtersArray+
    '</ebiz:filters>'+
    '<ebiz:start>'+start+'</ebiz:start>'+
    '<ebiz:limit>'+limit_x+'</ebiz:limit>' +
    '<ebiz:sort>'+sort_x+'</ebiz:sort>'+
    '<ebiz:includeCustomerToken>'+includeCustomerToken+'</ebiz:includeCustomerToken>'+
    '<ebiz:includePaymentMethodProfiles>'+includePaymentMethodProfiles+'</ebiz:includePaymentMethodProfiles>'+
    '<ebiz:countOnly>'+countOnly+'</ebiz:countOnly>'+
    '</ebiz:SearchCustomerList>'+
    '</soapenv:Body>' +
    '</soapenv:Envelope>';
    request.setBody(xmlBodyString);
    system.debug('<<<request ' + request);
    system.debug('<<<body ' + request.getBody());
    HttpResponse response = http.send(request);
    system.debug('<<<response code ' + response.getStatusCode());
    system.debug('<<<response ' + response.getBody());
    return response.getBody();
    }
  public string SearchTransactionsPayload(String securityId,CalloutModelClass.ArrayOfSearchFilter filters, Boolean matchAll, Boolean countOnly, String start, String limit_x, String sort_x){
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    string customFieldsArray ='';
    if(filters.SearchFilter!=null){
    for(CalloutModelClass.SearchFilter result: filters.SearchFilter)
    {
     customFieldsArray += '<ebiz:SearchFilter>';
     customFieldsArray += result.FieldName == null ?  '' : '<ebiz:FieldName>'+result.FieldName+'</ebiz:FieldName>';
     customFieldsArray += result.ComparisonOperator == null ?  '' : '<ebiz:ComparisonOperator>'+result.ComparisonOperator+'</ebiz:ComparisonOperator>';
     customFieldsArray += result.FieldValue == null ?  '' : '<ebiz:FieldValue>'+result.FieldValue+'</ebiz:FieldValue>';
     customFieldsArray += '</ebiz:SearchFilter>';
    }
  }
  else{
    customFieldsArray ='';
  }
    request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
    request.setMethod('POST');
    request.setHeader('Accept-Encoding', 'gzip,deflate');
    request.setHeader('Content-Type', 'text/XML');
    request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/SearchTransactions');
    String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">';
    xmlBodyString += '<soapenv:Header/>';
    xmlBodyString += '<soapenv:Body>';
    xmlBodyString += '<ebiz:SearchTransactions>';
    xmlBodyString += '<ebiz:securityToken>';
    xmlBodyString +=  securityId == null ?  '' : '<ebiz:SecurityId>' +securityId+'</ebiz:SecurityId>';//required
    //xmlBodyString +=  UserId == null ?  '' : '<ebiz:UserId>' +UserId+'</ebiz:UserId>';
    //xmlBodyString +=  Password == null ?  '' : '<ebiz:Password>' +UserId+'</ebiz:Password>';
    xmlBodyString += '</ebiz:securityToken>';
    xmlBodyString +=  '<ebiz:filters>';
    xmlBodyString += customFieldsArray;
    xmlBodyString +=  '</ebiz:filters>';
    xmlBodyString += matchAll == null ?  '' : '<ebiz:matchAll>'+matchAll+'</ebiz:matchAll>';
    xmlBodyString += countOnly == null ?  '' : '<ebiz:countOnly>'+countOnly+'</ebiz:countOnly>';
    xmlBodyString += start == null ?  '' : '<ebiz:start>'+start+'</ebiz:start>';
    xmlBodyString += limit_x == null ?  '' : '<ebiz:limit>'+limit_x+'</ebiz:limit>';
    xmlBodyString += sort_x == null ?  '' : '<ebiz:sort>'+sort_x+'</ebiz:sort>';
    xmlBodyString += '</ebiz:SearchTransactions>';
    xmlBodyString += '</soapenv:Body>';
    xmlBodyString += '</soapenv:Envelope>';    
    request.setBody(xmlBodyString);
    system.debug('<<<request ' + request);
    system.debug('<<<body ' + request.getBody());
    HttpResponse response = http.send(request);
    system.debug('<<<response code ' + response.getStatusCode());
    system.debug('<<<response ' + response.getBody());
    return response.getBody();
  }
  public string UpdateItemPayload(String securityId, CalloutModelClass.ItemDetails itemDetails, String itemInternalId, String itemId){
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    string customFieldsArray ='';
        if(itemDetails.ItemCustomFields!=null){
        for(CalloutModelClass.EbizCustomField result: itemDetails.ItemCustomFields)
        {
          customFieldsArray += '<ebiz:EbizCustomField>'+
        '<ebiz:FieldId>'+result.FieldId+'</ebiz:FieldId>'+
        '<ebiz:FieldName>'+result.FieldName+'</ebiz:FieldName>'+
        '<ebiz:FieldValue>'+result.FieldValue+'</ebiz:FieldValue>'+
        '<ebiz:FieldType>'+result.FieldType+'</ebiz:FieldType>'+
        '<ebiz:FieldDataType>'+result.FieldDataType+'</ebiz:FieldDataType>'+
        '<ebiz:FieldDescription>'+result.FieldDescription+'</ebiz:FieldDescription>'+
        '</ebiz:EbizCustomField>';
        }
      }
      else{
        customFieldsArray ='';
      }
    request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
    request.setMethod('POST');
    request.setHeader('Accept-Encoding', 'gzip,deflate');
    request.setHeader('Content-Type', 'text/XML');
    request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/UpdateItem');
    String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
    '<soapenv:Header/>' +
    '<soapenv:Body>' +
    '<ebiz:UpdateItem xmlns="http://ebizcharge.servicemodel.soap">' +
    '<ebiz:securityToken>' +
    '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
    '<UserId>salesforce1</UserId>' +
    '<Password>salesforce1</Password>' +
    '</ebiz:securityToken>' +
    '<ebiz:itemDetails>'+
    '<ebiz:ItemInternalId>'+itemDetails.ItemInternalId+'</ebiz:ItemInternalId>'+
    '<ebiz:ItemId>'+itemDetails.ItemId+'</ebiz:ItemId>'+
    '<ebiz:Name>'+itemDetails.Name+'</ebiz:Name>'+
    '<ebiz:SKU>'+itemDetails.SKU+'</ebiz:SKU>'+
    '<ebiz:UPC>'+itemDetails.UPC+'</ebiz:UPC>'+
    '<ebiz:Description>'+itemDetails.Description+'</ebiz:Description>'+
    '<ebiz:UnitPrice>'+itemDetails.UnitPrice+'</ebiz:UnitPrice>'+
    '<ebiz:UnitCost>'+itemDetails.UnitCost+'</ebiz:UnitCost>'+
    '<ebiz:UnitOfMeasure>'+itemDetails.UnitOfMeasure+'</ebiz:UnitOfMeasure>'+
    '<ebiz:Active>'+itemDetails.Active+'</ebiz:Active>'+
    '<ebiz:ItemType>'+itemDetails.ItemType+'</ebiz:ItemType>'+
    '<ebiz:QtyOnHand>'+itemDetails.QtyOnHand+'</ebiz:QtyOnHand>'+
    '<ebiz:Taxable>'+itemDetails.Taxable+'</ebiz:Taxable>'+
    '<ebiz:TaxRate>'+itemDetails.TaxRate+'</ebiz:TaxRate>'+
    '<ebiz:SoftwareId>'+itemDetails.SoftwareId+'</ebiz:SoftwareId>'+
    '<ebiz:ItemCategoryId>'+itemDetails.ItemCategoryId+'</ebiz:ItemCategoryId>'+
    '<ebiz:ItemNotes>'+itemDetails.ItemNotes+'</ebiz:ItemNotes>'+
    '<ebiz:DateTimeCreated>'+itemDetails.DateTimeCreated+'</ebiz:DateTimeCreated>'+
    '<ebiz:DateTimeModified>'+itemDetails.DateTimeModified+'</ebiz:DateTimeModified>'+
    '<ebiz:ItemUniqueId>'+itemDetails.ItemUniqueId+'</ebiz:ItemUniqueId>'+
    '<ebiz:ImageUrl>'+itemDetails.ImageUrl+'</ebiz:ImageUrl>'+
    '<ebiz:TaxCategoryID>'+itemDetails.TaxCategoryID+'</ebiz:TaxCategoryID>'+
    '<ebiz:ItemCustomFields>'+
    customFieldsArray+
    '</ebiz:ItemCustomFields>'+
    '<ebiz:ItemLastSyncDateTime>'+itemDetails.ItemLastSyncDateTime+'</ebiz:ItemLastSyncDateTime>'+
    '<ebiz:DivisionId>'+itemDetails.DivisionId+'</ebiz:DivisionId>'+
    '<ebiz:LocationId>'+itemDetails.LocationId+'</ebiz:LocationId>'+
    '</ebiz:itemDetails>'+
    '<ebiz:itemInternalId>'+itemInternalId+'</ebiz:itemInternalId>'+
    '<ebiz:itemId>'+itemId+'</ebiz:itemId>'+
    '</ebiz:UpdateItem>'+
    '</soapenv:Body>' +
    '</soapenv:Envelope>';
    request.setBody(xmlBodyString);
    system.debug('<<<request ' + request);
    system.debug('<<<body ' + request.getBody());
    HttpResponse response = http.send(request);
    system.debug('<<<response code ' + response.getStatusCode());
    system.debug('<<<response ' + response.getBody());
    return response.getBody();
  }
  public string SearchItemsPayload(String securityId, String itemInternalId, String itemId, CalloutModelClass.ArrayOfSearchFilter filters, Integer start, Integer limit_x, String sort_x) {

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://soap;.ebizcharge.net/eBizService.svc');
    request.setMethod('POST');
    request.setHeader('Accept-Encoding', 'gzip,deflate');
    request.setHeader('Content-Type', 'text/XML');
    request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/SearchTransactions');
    string filtersArray ='';
    system.debug('filters'+filters.SearchFilter);
    if(filters.SearchFilter!=null){
    for(CalloutModelClass.SearchFilter result: filters.SearchFilter)
    {
     filtersArray += '<ebiz:SearchFilter>'+
    '<ebiz:FieldName>'+result.FieldName+'</ebiz:FieldName>'+
    '<ebiz:ComparisonOperator>'+result.ComparisonOperator+'</ebiz:ComparisonOperator>'+
    '<ebiz:FieldValue>'+result.FieldValue+'</ebiz:FieldValue>'+
    '</ebiz:SearchFilter>';
    }
  }
  else{
    filtersArray ='';
  }
    String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
    '<soapenv:Header/>' +
    '<soapenv:Body>' +
    '<ebiz:SearchItems xmlns="http://ebizcharge.servicemodel.soap">' +
    '<ebiz:securityToken>' +
    '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
    '<UserId>salesforce1</UserId>' +
    '<Password>salesforce1</Password>' +
    '</ebiz:securityToken>' +
    '<ebiz:itemInternalId>'+itemInternalId+'</ebiz:itemInternalId>'+
    '<ebiz:itemId>'+itemId+'</ebiz:itemId>'+
    '<ebiz:filters>'+
      filtersArray+
    '</ebiz:filters>'+
    '<ebiz:start>'+start+'</ebiz:start>'+
    '<ebiz:limit>'+limit_x+'</ebiz:limit>' +
    '<ebiz:sort>'+sort_x+'</ebiz:sort>'+
    '</ebiz:SearchItems>'+
    '</soapenv:Body>' +
    '</soapenv:Envelope>';
    request.setBody(xmlBodyString);
    system.debug('<<<request ' + request);
    system.debug('<<<body ' + request.getBody());
    HttpResponse response = http.send(request);
    system.debug('<<<response code ' + response.getStatusCode());
    system.debug('<<<response ' + response.getBody());
    return response.getBody();
}
  
public string  AddSalesOrderPayload(String securityId, CalloutModelClass.SalesOrder salesOrder) {
  Http http = new Http();
  HttpRequest request = new HttpRequest();
  string itemsArray ='';
  string itemsCustomFieldsArray = '';
  request.setEndpoint('https://soap.ebizcharge.net/eBizService.svc');
  request.setMethod('POST');
  request.setHeader('Accept-Encoding', 'gzip,deflate');
  request.setHeader('Content-Type', 'text/XML');
  request.setHeader('SOAPAction', 'http://eBizCharge.ServiceModel.SOAP/IeBizService/AddSalesOrder');
      system.debug('custom fields'+salesOrder.SalesOrderCustomFields);
       if(salesOrder.Items!=null){
      for(CalloutModelClass.CustomItem result: salesOrder.Items)
      {
        itemsArray += '<ebiz:Item>'+
      '<ebiz:ItemInternalId>'+result.ItemInternalId+'</ebiz:ItemInternalId>'+
      '<ebiz:ItemId>'+result.ItemId+'</ebiz:ItemId>'+
      '<ebiz:Name>'+result.Name+'</ebiz:Name>'+
      '<ebiz:Description>'+result.Description+'</ebiz:Description>'+
      '<ebiz:UnitPrice>'+result.UnitPrice+'</ebiz:UnitPrice>'+
      '<ebiz:Qty>'+result.Qty+'</ebiz:Qty>'+
      '<ebiz:Taxable>'+result.Taxable+'</ebiz:Taxable>'+
      '<ebiz:TaxRate>'+result.TaxRate+'</ebiz:TaxRate>'+
      '<ebiz:UnitOfMeasure>'+result.UnitOfMeasure+'</ebiz:UnitOfMeasure>'+
      '<ebiz:TotalLineAmount>'+result.TotalLineAmount+'</ebiz:TotalLineAmount>'+
      '<ebiz:TotalLineTax>'+result.TotalLineTax+'</ebiz:TotalLineTax>'+
      '<ebiz:ItemLineNumber>'+result.ItemLineNumber+'</ebiz:ItemLineNumber>'+
      '<ebiz:GrossPrice>'+result.GrossPrice+'</ebiz:GrossPrice>'+
      '<ebiz:WarrantyDiscount>'+result.WarrantyDiscount+'</ebiz:WarrantyDiscount>'+
      '<ebiz:SalesDiscount>'+result.SalesDiscount+'</ebiz:SalesDiscount>'+
      '<ebiz:ItemClass>'+result.ItemClass+'</ebiz:ItemClass>'+
      '<ebiz:ItemCustomFields>';
      if(result.ItemCustomFields!=null){
        for(CalloutModelClass.EbizCustomField result1: result.ItemCustomFields)
        {
          itemsCustomFieldsArray += '<ebiz:EbizCustomField>'+
        '<ebiz:FieldId>'+result1.FieldId+'</ebiz:FieldId>'+
        '<ebiz:FieldName>'+result1.FieldName+'</ebiz:FieldName>'+
        '<ebiz:FieldValue>'+result1.FieldValue+'</ebiz:FieldValue>'+
        '<ebiz:FieldType>'+result1.FieldType+'</ebiz:FieldType>'+
        '<ebiz:FieldDataType>'+result1.FieldDataType+'</ebiz:FieldDataType>'+
        '<ebiz:FieldDescription>'+result1.FieldDescription+'</ebiz:FieldDescription>'+
        '</ebiz:EbizCustomField>';
        }
      }
      
      itemsArray+=itemsCustomFieldsArray +
      '</ebiz:ItemCustomFields>'+'</ebiz:Item>';
      }
      }
     else{
       itemsArray ='';
     }
  
  string customFieldsArray ='';
      system.debug('custom fields'+salesOrder.SalesOrderCustomFields);
      if(salesOrder.SalesOrderCustomFields!=null){
      for(CalloutModelClass.EbizCustomField result: salesOrder.SalesOrderCustomFields)
      {
        customFieldsArray += '<ebiz:EbizCustomField>'+
      '<ebiz:FieldId>'+result.FieldId+'</ebiz:FieldId>'+
      '<ebiz:FieldName>'+result.FieldName+'</ebiz:FieldName>'+
      '<ebiz:FieldValue>'+result.FieldValue+'</ebiz:FieldValue>'+
      '<ebiz:FieldType>'+result.FieldType+'</ebiz:FieldType>'+
      '<ebiz:FieldDataType>'+result.FieldDataType+'</ebiz:FieldDataType>'+
      '<ebiz:FieldDescription>'+result.FieldDescription+'</ebiz:FieldDescription>'+
      '</ebiz:EbizCustomField>';
      }
    }
    else{
      customFieldsArray ='';
    }
    string billingAddress ='';
    CalloutModelClass.Address address = new CalloutModelClass.Address();
    if(salesOrder.BillingAddress!=null){
        billingAddress += 
      '<ebiz:FirstName>'+address.FirstName+'</ebiz:FirstName>'+
      '<ebiz:LastName>'+address.LastName+'</ebiz:LastName>'+
      '<ebiz:CompanyName>'+address.CompanyName+'</ebiz:CompanyName>'+
      '<ebiz:Address1>'+address.Address1+'</ebiz:Address1>'+
      '<ebiz:Address2>'+address.Address2+'</ebiz:Address2>'+
      '<ebiz:Address3>'+address.Address3+'</ebiz:Address3>'+
      '<ebiz:Address4>'+address.Address4+'</ebiz:Address4>'+
      '<ebiz:Address5>'+address.Address5+'</ebiz:Address5>'+
      '<ebiz:Address6>'+address.Address6+'</ebiz:Address6>'+
      '<ebiz:City>'+address.City+'</ebiz:City>'+
      '<ebiz:State>'+address.State+'</ebiz:State>'+
      '<ebiz:ZipCode>'+address.ZipCode+'</ZipCode:State>'+
      '<ebiz:Country>'+address.Country+'</ebiz:Country>'+
      '<ebiz:IsDefault>'+address.State+'</ebiz:IsDefault>'+
      '<ebiz:AddressId>'+address.State+'</ebiz:AddressId>';
   
    }
    else{
      billingAddress ='';
    }
    string shippingAddress ='';

    if(salesOrder.ShippingAddress!=null){
    
      shippingAddress += 
    '<ebiz:FirstName>'+address.FirstName+'</ebiz:FirstName>'+
    '<ebiz:LastName>'+address.LastName+'</ebiz:LastName>'+
    '<ebiz:CompanyName>'+address.CompanyName+'</ebiz:CompanyName>'+
    '<ebiz:Address1>'+address.Address1+'</ebiz:Address1>'+
    '<ebiz:Address2>'+address.Address2+'</ebiz:Address2>'+
    '<ebiz:Address3>'+address.Address3+'</ebiz:Address3>'+
    '<ebiz:Address4>'+address.Address4+'</ebiz:Address4>'+
    '<ebiz:Address5>'+address.Address5+'</ebiz:Address5>'+
    '<ebiz:Address6>'+address.Address6+'</ebiz:Address6>'+
    '<ebiz:City>'+address.City+'</ebiz:City>'+
    '<ebiz:State>'+address.State+'</ebiz:State>'+
    '<ebiz:ZipCode>'+address.ZipCode+'</ZipCode:State>'+
    '<ebiz:Country>'+address.Country+'</ebiz:Country>'+
    '<ebiz:IsDefault>'+address.State+'</ebiz:IsDefault>'+
    '<ebiz:AddressId>'+address.State+'</ebiz:AddressId>';
    
  }
  else{
    shippingAddress ='';
  }
  String xmlBodyString = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ebiz="http://eBizCharge.ServiceModel.SOAP">' +
  '<soapenv:Header/>' +
  '<soapenv:Body>' +
  '<ebiz:AddSalesOrder xmlns="http://ebizcharge.servicemodel.soap">' +
  '<ebiz:securityToken>' +
  '<ebiz:SecurityId>'+securityId+'</ebiz:SecurityId>' +
  '<UserId>salesforce1</UserId>' +
  '<Password>salesforce1</Password>' +
  '</ebiz:securityToken>' +
  '<ebiz:salesOrder>'+
  '<ebiz:MerchantId>'+salesOrder.MerchantId+'</ebiz:MerchantId>'+
  '<ebiz:CustomerId>'+salesOrder.CustomerId+'</ebiz:CustomerId>'+
  '<ebiz:SubCustomerId>'+salesOrder.SubCustomerId+'</ebiz:SubCustomerId>'+
  '<ebiz:SalesOrderNumber>'+salesOrder.SalesOrderNumber+'</ebiz:SalesOrderNumber>'+
  '<ebiz:SalesOrderInternalId>'+salesOrder.SalesOrderInternalId+'</ebiz:SalesOrderInternalId>'+
  '<ebiz:Date>'+salesOrder.Date_x+'</ebiz:Date>'+
  '<ebiz:Currency>'+salesOrder.Currency_x+'</ebiz:Currency>'+
  '<ebiz:Amount>'+salesOrder.Amount+'</ebiz:Amount>'+
  '<ebiz:DueDate>'+salesOrder.DueDate+'</ebiz:DueDate>'+
  '<ebiz:AmountDue>'+salesOrder.AmountDue+'</ebiz:AmountDue>'+
  '<ebiz:PoNum>'+salesOrder.PoNum+'</ebiz:PoNum>'+
  '<ebiz:DivisionId>'+salesOrder.DivisionId+'</ebiz:DivisionId>'+
  '<ebiz:TypeId>'+salesOrder.TypeId+'</ebiz:TypeId>'+
  '<ebiz:UploadedBy>'+salesOrder.UploadedBy+'</ebiz:UploadedBy>'+
  '<ebiz:UpdatedBy>'+salesOrder.UpdatedBy+'</ebiz:UpdatedBy>'+
  '<ebiz:DateUploaded>'+salesOrder.DateUploaded+'</ebiz:DateUploaded>'+
  '<ebiz:DateUpdated>'+salesOrder.DateUpdated+'</ebiz:DateUpdated>'+
  '<ebiz:isDeleted>'+salesOrder.isDeleted+'</ebiz:isDeleted>'+
  '<ebiz:DeletedBy>'+salesOrder.DeletedBy+'</ebiz:DeletedBy>'+
  '<ebiz:DateDeleted>'+salesOrder.DateDeleted+'</ebiz:DateDeleted>'+
  '<ebiz:Items>'+
   itemsArray+
  '</ebiz:Items>'+
  '<ebiz:Software>'+salesOrder.Software+'</ebiz:Software>'+
  '<ebiz:NotifyCustomer>'+salesOrder.NotifyCustomer+'</ebiz:NotifyCustomer>'+
  '<ebiz:EmailTemplateID>'+salesOrder.EmailTemplateID+'</ebiz:EmailTemplateID>'+
  '<ebiz:URL>'+salesOrder.URL+'</ebiz:URL>'+
  '<ebiz:TotalTaxAmount>'+salesOrder.TotalTaxAmount+'</ebiz:TotalTaxAmount>'+
  '<ebiz:UniqueId>'+salesOrder.UniqueId+'</ebiz:UniqueId>'+
  '<ebiz:Description>'+salesOrder.Description+'</ebiz:Description>'+
  '<ebiz:BillingAddress>'+
   billingAddress+
  '</ebiz:BillingAddress>'+
  '<ebiz:ShippingAddress>'+
   shippingAddress+
  '</ebiz:ShippingAddress>'+
  '<ebiz:CustomerMessage>'+salesOrder.CustomerMessage+'</ebiz:CustomerMessage>'+
  '<ebiz:Memo>'+salesOrder.Memo+'</ebiz:Memo>'+
  '<ebiz:ShipDate>'+salesOrder.ShipDate+'</ebiz:ShipDate>'+
  '<ebiz:ShipVia>'+salesOrder.ShipVia+'</ebiz:ShipVia>'+
  '<ebiz:SalesRepId>'+salesOrder.SalesRepId+'</ebiz:SalesRepId>'+
  '<ebiz:TermsId>'+salesOrder.TermsId+'</ebiz:TermsId>'+
  '<ebiz:IsToBeEmailed>'+salesOrder.IsToBeEmailed+'</ebiz:IsToBeEmailed>'+
  '<ebiz:IsToBePrinted>'+salesOrder.IsToBePrinted+'</ebiz:IsToBePrinted>'+
  '<ebiz:SalesOrderLastSyncDateTime>'+salesOrder.SalesOrderLastSyncDateTime+'</ebiz:SalesOrderLastSyncDateTime>'+
  '<ebiz:SalesOrderCustomFields>'+
  customFieldsArray+
  '</ebiz:SalesOrderCustomFields>'+
  '<ebiz:LocationId>'+salesOrder.LocationId+'</ebiz:LocationId>'+
  '</ebiz:salesOrder>'+
  '</ebiz:AddSalesOrder>'+
  '</soapenv:Body>' +
  '</soapenv:Envelope>';
  request.setBody(xmlBodyString);
  system.debug('<<<request ' + request);
  system.debug('<<<body ' + request.getBody());
  HttpResponse response = http.send(request);
  system.debug('<<<response code ' + response.getStatusCode());
  system.debug('<<<response ' + response.getBody());

  return response.getBody();

}

}