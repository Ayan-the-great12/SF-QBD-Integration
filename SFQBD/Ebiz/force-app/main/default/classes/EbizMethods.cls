public class EbizMethods {
    
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    
    /*
    public static ebizchargeServicemodelSoap.SecurityToken getSecurityToken()
    {
        ebiz_setting__c eb_st = [SELECT Security_Id__c, User_Id__c,Password__c FROM ebiz_setting__c limit 1];
        ebizchargeServicemodelSoap.SecurityToken st = new ebizchargeServicemodelSoap.SecurityToken();
        st.SecurityId = eb_st.Security_Id__c;//'57980acf-fbc1-4813-94d3-ad9027784a74';
        st.UserId = eb_st.User_Id__c;//'Cbs';
        st.Password = eb_st.Password__c ;//'Cbs12358!';
        
        return st;
    }
    
    public static ebiz_setting__c getSettings()
    {
        ebiz_setting__c eb_st = [SELECT Security_Id__c, User_Id__c,Password__c
                                 FROM ebiz_setting__c limit 1];
        
        return eb_st;
    }
    
    public static string getCustomerToken(string customerID, string internalID)
    {       
        
        ebizchargeServicemodelSoap.GetCustomerToken_element cst = new ebizchargeServicemodelSoap.GetCustomerToken_element();
        system.debug('customerID: ' + customerID);
        system.debug('customerInternalID: ' + internalID);
        string customerToken = ebiz.GetCustomerToken(getSecurityToken(), customerID, internalID);
        system.debug('customerToken: ' + customerToken);
        return customerToken;
    }
    
    public static Order getOrderDetail(string OrderNumber)
    {
        //Order Information
        Order ebzo = new Order();
        try{
        ebzo = [SELECT
                       Id,CreatedDate,
                       AccountId, ContractId, 
                       ActivatedById, ActivatedDate, BillToContactId,BillingAddress,         
                       CreatedById, CustomerAuthorizedById, CustomerAuthorizedDate, Description, LastModifiedById, 
                       OpportunityId, TotalAmount, EndDate, Name, OrderNumber, 
                       OwnerId, OrderReferenceNumber, EffectiveDate, OriginalOrderId,
                       PoDate, PoNumber, IsReductionOrder, ShipToContactId, ShippingAddress, Status ,
                       
                       EBizCharge_Payment_Status__c,  Payment_Status__c,           
                       
                       BillingStreet, BillingPostalCode, BillingCity, BillingCountry, BillingState,
                       ShippingCity, ShippingState, ShippingStreet, ShippingPostalCode, ShippingCountry
                       
                       FROM Order  where OrderNumber=:OrderNumber limit 1];
        }catch(Exception e){}
        return ebzo;
    }
    
    public static Account getAccountDetail(string AccountId)
    {
        Account  ebzc = [SELECT        
                         id, Name,
                         
                         EBizCharge_Internal_ID__c,                         
                         BillingAddress, ShippingAddress,
                         
                         BillingStreet, BillingPostalCode, BillingCity, BillingCountry, BillingState,
                         
                         ShippingCity, ShippingState, ShippingStreet, ShippingPostalCode, ShippingCountry  
                         
                         FROM Account  where id=:AccountId limit 1];
        
        return ebzc;
    }
    public static void runTransactionPaymentByEmail(transactionParams tparm, Order ebizOrder, Account ebizAccount, string reqEmailID)
    {
        
        string tranID = runTransactionPayment(tparm, ebizOrder, ebizAccount, 'E');
        
        EBizCharge_Payment_Request__c epr = [select id , Name, Requested_Email__c, Status__c, Order_Number__c, Transaction_Number__c from EBizCharge_Payment_Request__c where id=:reqEmailID limit 1];
        
        EBizCharge_Payment_Request__c[] updateReq = new EBizCharge_Payment_Request__c[0];
        
        epr.Transaction_Number__c =  tranID;
        epr.Status__c = 'Approved';
        updateReq.add(epr);
        
        system.debug('updated epr last:' + epr);
        update updateReq;
        
        
    }
    public static string runTransactionPayment(transactionParams tparm, Order ebizOrder, Account ebizAccount, string clientSource)
    {
        system.debug('runTransactionPayment.tparm ' + tparm);
        system.debug('runTransactionPayment.ebizOrder ' + ebizOrder);
        system.debug('runTransactionPayment.ebizAccount ' + ebizAccount);
        
        ebiz_setting__c eb_st = getSettings();
        string saleCommand = '';
        if(!string.isBlank(eb_st.Payment_Action__c))
        {
            if(eb_st.Payment_Action__c == 'Authorize Only')
            {
                saleCommand = 'AuthOnly';
            }else
            {
                saleCommand = 'Sale';
            }
        }
        
        boolean customerRecipts = true;
        
        if(!string.isBlank(eb_st.Send_Customer_Receipt__c))
        {
            if(eb_st.Send_Customer_Receipt__c == 'Yes')
            {
                customerRecipts = true;
            }else
            {
                customerRecipts = false;
            }
        }
        
        //Receipt_Template__c
        boolean is_Receipt_Template = false;
        if(!string.isBlank(eb_st.Receipt_Template__c))
        {
            if(eb_st.Receipt_Template__c == '0')
            {
                is_Receipt_Template = false;
            }else
            {
                is_Receipt_Template = true;                
            }
        }
        
        system.debug('runTransactionPayment.tparm.internalID ' + tparm.internalID);
        if(string.isBlank(tparm.internalID))// checking internal id of customer for ebiz charge, if not there then will create customer on ebizcharge and return internal id
        {
            system.debug('runTransactionPayment.tparm.internalID.isBlank addEbizCustomer.before' + tparm.internalID);
            tparm.internalID = addEbizCustomer(ebizAccount, tparm.accountID);            
            system.debug('runTransactionPayment.tparm.internalID.isBlank addEbizCustomer.after' + tparm.internalID);
        }
        decimal paymentStatus = 1;
        string paymentMethodID='';
        
        if(tparm.methodID=='1')
        {
            system.debug('runTransactionPayment.tparm.methodID ' + 'CreditCard');
            paymentMethodID = addPaymentMethod(tparm, 'CreditCard');
            system.debug('runTransactionPayment.tparm.methodID.CreditCard ' + paymentMethodID);
        }
        else if(tparm.methodID=='2')
        {
            saleCommand = 'Check';
            system.debug('runTransactionPayment.tparm.methodID ' + 'ACH');
            paymentMethodID = addPaymentMethod(tparm, 'ACH');
            system.debug('runTransactionPayment.tparm.methodID.ACH ' + paymentMethodID);
            
        }else
        {            
            paymentMethodID = tparm.methodID;
            system.debug('runTransactionPayment.tparm.methodID.else ' + paymentMethodID);
        }
        
        system.debug('getCustomerToken(ebizAccount.id, tparm.internalID); ' + ebizAccount.id);
        String accID15 = ebizAccount.id; //SalesForce Account object id
        //accID15 = accID15.left(15);
        system.debug('accID15 ' + accID15);
        string customerToken = getCustomerToken(accID15, tparm.internalID);
        
        ebizchargeServicemodelSoap.CustomerTransactionRequest tran = new ebizchargeServicemodelSoap.CustomerTransactionRequest();
        
        system.debug('eb_st.Payment_Action__c ' + eb_st.Payment_Action__c);
        system.debug('saleCommand ' + saleCommand);
        
        tran.isRecurring = tparm.isRecurring;
        tran.IgnoreDuplicate= true;
        tran.Software = 'salesforce';
        tran.MerchReceipt=false;
        if(is_Receipt_Template == false && customerRecipts == true)
        {
            tran.CustReceipt = true;
        }else
        {
            tran.CustReceipt = false;
        }
        tran.Command = saleCommand;
        
        tran.Details = getTransactionDetails(ebizOrder);        
        
        tran.LineItems = getLineItems(ebizOrder.Id);
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        
        system.debug('runTransactionPayment.ebiz.runCustomerTransaction ' + 'before');
        
        response = ebiz.runCustomerTransaction(getSecurityToken(), customerToken, paymentMethodID, tran);
        
        system.debug('runTransactionPayment.ebiz.runCustomerTransaction ' + 'after');
        
        system.debug('runTransactionPayment.ebiz.isRecurring ' + tparm.isRecurring); 
        if(tparm.isRecurring)
        {
            system.debug('runTransactionPayment.ebiz.isRecurring ' + 'start'); 
            runRecurringPayment(tparm, ebizAccount);
            system.debug('runTransactionPayment.ebiz.isRecurring ' + 'end'); 
        }
        if(response.ResultCode=='A')
        {
            if(is_Receipt_Template == true && customerRecipts == true)
            {
                
                ebizchargeServicemodelSoap.EmailReceiptResponse emailReceiptResponse = new ebizchargeServicemodelSoap.EmailReceiptResponse();
                
                system.debug('EmailReceiptResponse ' + 'before');
                string tran_ref_number = '';
                tran_ref_number = response.RefNum;
                system.debug('tran_ref_number ' + tran_ref_number);
                system.debug('eb_st.Receipt_Template__c:' + eb_st.Receipt_Template__c);
                emailReceiptResponse = ebiz.EmailReceipt(getSecurityToken(), tran_ref_number,  eb_st.Receipt_Template__c,'', ebizAccount.Email__c);
                if (emailReceiptResponse.StatusCode == 1)
                {
                    system.debug('Email Sent ');
                }else{
                    system.debug('Email Sent Error ');
                }
                
                system.debug('EmailReceiptResponse ' + 'after');
            }
        }
        
        
        string tranID = saveStatusTransactionResponse(response, ebizOrder.OrderNumber, paymentMethodID, paymentStatus, clientSource);
        
        system.debug('runTransactionPayment.ebiz.saveTransactionResponse ' + 'after' + tranID);
        
        
        
        
        return tranID;
    }
    
    
    public static string runTransactionOnly(transactionParams tparm, Order ebizOrder, Account ebizAccount, string clientSource)
    {
        system.debug('runTransactionOnly.tparm ' + tparm);
        system.debug('runTransactionOnly.ebizOrder ' + ebizOrder);
        system.debug('runTransactionOnly.ebizAccount ' + ebizAccount);
        
        ebiz_setting__c eb_st = getSettings();
        string saleCommand = '';
        if(!string.isBlank(eb_st.Payment_Action__c))
        {
            if(eb_st.Payment_Action__c == 'Authorize Only')
            {
                saleCommand = 'AuthOnly';
            }else
            {
                saleCommand = 'Sale';
            }
        } 
        
        boolean customerRecipts = true;
        
        if(!string.isBlank(eb_st.Send_Customer_Receipt__c))
        {
            if(eb_st.Send_Customer_Receipt__c == 'Yes')
            {
                customerRecipts = true;
            }else
            {
                customerRecipts = false;
            }
        }
        
        
        
        //Receipt_Template__c
        boolean is_Receipt_Template = false;
        if(!string.isBlank(eb_st.Receipt_Template__c))
        {
            if(eb_st.Receipt_Template__c == '0')
            {
                is_Receipt_Template = false;
            }else
            {
                is_Receipt_Template = true;                
            }
        }
        
        decimal paymentStatus = 1;
        string paymentMethodID='';
        
        ebizchargeServicemodelSoap.TransactionRequestObject tran = new ebizchargeServicemodelSoap.TransactionRequestObject();
        
        
        if(tparm.methodID=='1') // credit card 
        {
            tran.CreditCardData = getCardData(tparm);
            tran.AccountHolder = tparm.ccName;
        }
        else if(tparm.methodID=='2') //c heck 
        {
            saleCommand = 'Check';
            tran.CheckData = getCheckData(tparm);
        }
        
        
        tran.BillingAddress = getBillingAddress(ebizAccount);
        tran.ShippingAddress = getShippingAddress(ebizAccount);
        
        system.debug('eb_st.Payment_Action__c ' + eb_st.Payment_Action__c);
        system.debug('saleCommand ' + saleCommand);
        
        tran.isRecurring = tparm.isRecurring;
        tran.IgnoreDuplicate= true;
        tran.Software = 'salesforce';
        //tran.MerchReceipt=false;
        if(is_Receipt_Template == false && customerRecipts == true)
        {
            tran.CustReceipt = true;
        }else
        {
            tran.CustReceipt = false;
        }
        
        tran.Command = saleCommand;
        
        tran.Details = getTransactionDetails(ebizOrder);        
        
        tran.LineItems = getLineItems(ebizOrder.Id); // all bought products will come in this 
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        
        system.debug('runTransactionOnly.ebiz.runTransaction ' + 'before');
        
        response = ebiz.runTransaction(getSecurityToken(), tran);
        
        system.debug('runTransactionOnly.ebiz.runTransaction ' + 'after');
        
        system.debug('runTransactionOnly.ebiz.isRecurring ' + tparm.isRecurring); 
        if(tparm.isRecurring) // so that credit card get charged after month/year/week etc 
        {
            system.debug('runTransactionOnly.ebiz.isRecurring ' + 'start'); 
            runRecurringPayment(tparm, ebizAccount);
            system.debug('runTransactionOnly.ebiz.isRecurring ' + 'end'); 
        }
        
        if(response.ResultCode=='A')
        {
            if(is_Receipt_Template == true && customerRecipts == true)
            {
                
                ebizchargeServicemodelSoap.EmailReceiptResponse emailReceiptResponse = new ebizchargeServicemodelSoap.EmailReceiptResponse();
                
                system.debug('EmailReceiptResponse ' + 'before');
                string tran_ref_number = '';
                tran_ref_number = response.RefNum; // successful order is assigned a refnum
                system.debug('tran_ref_number ' + tran_ref_number);
                system.debug('eb_st.Receipt_Template__c ' + eb_st.Receipt_Template__c);
                emailReceiptResponse = ebiz.EmailReceipt(getSecurityToken(), tran_ref_number,  eb_st.Receipt_Template__c, '', ebizAccount.Email__c);
                if (emailReceiptResponse.StatusCode == 1)
                {
                    system.debug('Email Sent ');
                }else{
                    system.debug('Email Sent Error ');
                }
                
                system.debug('EmailReceiptResponse ' + 'after');
            }
        }
        
        string tranID = saveStatusTransactionResponse(response, ebizOrder.OrderNumber, paymentMethodID, paymentStatus, clientSource);
        
        system.debug('runTransactionOnly.ebiz.saveTransactionResponse ' + 'after' + tranID);
        
        
        
        return tranID;
    }
    public static string runTransactionRefund(string RefNumber, string transid, string Auth_Code, string OrderNumber, decimal AuthAmount, string methodType, string clientSource)
    {
        system.debug('runTransactionRefund.RefNumber ' + RefNumber);
        system.debug('runTransactionRefund.transid ' + transid);
        system.debug('runTransactionRefund.OrderNumber ' + OrderNumber);
        system.debug('runTransactionRefund.AuthAmount ' + AuthAmount);
        system.debug('runTransactionRefund.methodType ' + methodType);
        
        
        string paymentMethodID='';
        decimal paymentStatus = 1;
        if(methodType=='r') // cc refund
        {            
            paymentMethodID = 'cc:refund';  
            paymentStatus = 2;
        }
        if(methodType=='v') // void 
        {
            paymentMethodID = 'Void'; 
            paymentStatus = 3;
            
        }
        
        
        ebizchargeServicemodelSoap.TransactionRequestObject tran = new ebizchargeServicemodelSoap.TransactionRequestObject();
        if(methodType=='r')
        { 
            ebizchargeServicemodelSoap.TransactionDetail tranDetail = new ebizchargeServicemodelSoap.TransactionDetail();
            tranDetail.Amount = AuthAmount;
            tranDetail.NonTax = false;
            tranDetail.Tax = 0;
            //tranDetail.Table = '';
            tranDetail.Subtotal = 0;
            tranDetail.Shipping = 0;
            //tranDetail.ShipFromZip = '';
            //tranDetail.SessionID = '';
            //tranDetail.OrderID = ebzo.Name;
            //tranDetail.Invoice = '';
            tranDetail.Duty = 0;
            tranDetail.Discount = 0;
            //tranDetail.Comments = ebzo.Notes__c;
            //tranDetail.Description = ebzo.Descripton__c;
            //tranDetail.Currency_x = '';
            //tranDetail.Clerk = '';
            //tranDetail.Amount = ebzo.Order_Total__c;
            tranDetail.AllowPartialAuth = false;
            //tranDetail.Terminal = '';
            tranDetail.Tip = 0;
            tran.Details = tranDetail;
        }
        tran.Command = paymentMethodID;
        tran.IgnoreDuplicate = true;
        tran.AuthCode = Auth_Code;
        tran.RefNum = RefNumber;
        tran.IsRecurring = false;
        tran.CustReceipt = true;
        //tran.AccountHolder = true;
        
        
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        
        system.debug('runTransactionRefund ' + 'before');
        response = ebiz.runTransaction(getSecurityToken(), tran);
        system.debug('runTransactionRefund ' + 'after');
        string tranID = saveStatusTransactionResponse(response, OrderNumber, paymentMethodID, paymentStatus, clientSource);
        
        system.debug('runTransactionRefund.ebiz.saveTransactionResponse ' + 'after' + tranID);
        return tranID;
        
    }
    
    public static ebizchargeServicemodelSoap.GwAddress getBillingAddress(Account ebizAccount)
    {
        ebizchargeServicemodelSoap.GwAddress billingAdds = new ebizchargeServicemodelSoap.GwAddress();
        
        billingAdds.City = ebizAccount.BillingCity;
        billingAdds.Company ='';
        billingAdds.Country = '';
        billingAdds.Email = ebizAccount.Email__c;
        billingAdds.Fax = '';
        billingAdds.FirstName = ebizAccount.First_Name__c;
        billingAdds.LastName = ebizAccount.Last_Name__c;
        billingAdds.Phone='';
        billingAdds.State = ebizAccount.BillingState;
        billingAdds.Street = ebizAccount.BillingStreet;
        billingAdds.Street2='';
        billingAdds.Zip = ebizAccount.BillingPostalCode;
        
        
        return billingAdds;
    }
    
    public static ebizchargeServicemodelSoap.GwAddress getShippingAddress(Account ebizAccount)
    {
        ebizchargeServicemodelSoap.GwAddress shippingAdds = new ebizchargeServicemodelSoap.GwAddress();
        
        shippingAdds.City = ebizAccount.ShippingCity;
        shippingAdds.Company ='';
        shippingAdds.Country = '';
        shippingAdds.Email = ebizAccount.Email__c;
        shippingAdds.Fax = '';
        shippingAdds.FirstName = ebizAccount.First_Name__c;
        shippingAdds.LastName = ebizAccount.Last_Name__c;
        shippingAdds.Phone='';
        shippingAdds.State = ebizAccount.ShippingState;
        shippingAdds.Street = ebizAccount.ShippingStreet;
        shippingAdds.Street2='';
        shippingAdds.Zip = ebizAccount.ShippingPostalCode;
        
        
        
        return shippingAdds;
    }
    
    public static ebizchargeServicemodelSoap.CreditCardData getCardData(transactionParams tparm)
    {
        ebizchargeServicemodelSoap.CreditCardData ccData = new ebizchargeServicemodelSoap.CreditCardData();
        
        ccData.CAVV = tparm.cvvCode;
        ccData.Pares = '';
        ccData.MagSupport = '';
        ccData.MagStripe = '';
        ccData.InternalCardAuth = false;
        ccData.ECI = '';
        ccData.DUKPT = '';
        ccData.XID = '';
        //ccData.CardType = ebzo.Card_Type__c;
        ccData.CardPresent = false;
        ccData.CardNumber = tparm.ccNumber;
        ccData.CardExpiration = tparm.expMonth + tparm.expYear;
        ccData.CardCode = tparm.cvvCode;
        ccData.AvsZip = '';
        ccData.AvsStreet = '';
        ccData.Signature = '';
        ccData.TermType = '';
        
        return ccData;
    }
    
    public static ebizchargeServicemodelSoap.CheckData getCheckData(transactionParams tparm)
    {
        ebizchargeServicemodelSoap.CheckData chkData = new ebizchargeServicemodelSoap.CheckData();
        
        chkData.Account = tparm.eeAccount;
        chkData.AccountType = '';
        chkData.CheckNumber = '';
        chkData.DriversLicense = '';
        chkData.DriversLicenseState = '';
        chkData.RecordType = '';
        chkData.Routing = tparm.eeRout;
        chkData.MICR = '';
        chkData.AuxOnUS = '';
        chkData.EpcCode = '';
        chkData.FrontImage = '';
        chkData.BackImage = '';
        
        return chkData;
    }
    
    public static string addPaymentMethod(transactionParams tparm, string methodType)
    {        
        ebizchargeServicemodelSoap.PaymentMethodProfile paymentMethod = new ebizchargeServicemodelSoap.PaymentMethodProfile();
        
        //paymentMethod.MethodType = methodType;
        paymentMethod.SecondarySort = '0';
        paymentMethod.Created = system.Date.today();
        paymentMethod.Modified = system.Date.today();
        if(methodType=='CreditCard')
        {
            paymentMethod.CardNumber = tparm.ccNumber;
            paymentMethod.CardExpiration =tparm.expMonth +  tparm.expYear;//tparm.expYear + '-' + tparm.expMonth;
            paymentMethod.CardCode = tparm.cvvCode;
            paymentMethod.AccountHolderName = tparm.ccName;
        }
        if(methodType=='ACH')
        {
            paymentMethod.Account = tparm.eeAccount;
            //paymentMethod.AccountType = ;
            paymentMethod.Routing = tparm.eeRout;
            
        }
        system.debug('paymentMethod.SecondarySort.tparm.internalID ' + tparm.internalID);
        system.debug('paymentMethod.Created ' + paymentMethod.Created);
        system.debug('paymentMethod.SecondarySort ' + paymentMethod.SecondarySort);
        system.debug('paymentMethod.CardNumber ' + paymentMethod.CardNumber);
        system.debug('paymentMethod.CardExpiration ' + paymentMethod.CardExpiration);
        system.debug('paymentMethod.CardCode ' + paymentMethod.CardCode);
        system.debug('paymentMethod.AccountHolderName ' + paymentMethod.AccountHolderName);
        system.debug('paymentMethod.Account ' + paymentMethod.Account);
        system.debug('paymentMethod.Routing ' + paymentMethod.Routing);
        
        
        string methodID = ebiz.AddCustomerPaymentMethodProfile(getSecurityToken(), tparm.internalID, paymentMethod);
        system.debug('AddCustomerPaymentMethodProfile: ' + methodID);
        return methodID;
    }
    
    public static string addEbizCustomer(Account ebizAccount, string AccountId)
    {
        ebizchargeServicemodelSoap.Customer cst = new ebizchargeServicemodelSoap.Customer();
        
        //cst.MerchantId = '';
        cst.CustomerId = ebizAccount.id;
        cst.FirstName = ebizAccount.First_Name__c;
        cst.LastName = ebizAccount.Last_Name__c;
        cst.CompanyName = '';
        cst.Phone = ebizAccount.Phone;
        cst.Fax = ebizAccount.Fax;
        cst.Email = ebizAccount.Email__c;
        cst.WebSite = '';
        
        ebizchargeServicemodelSoap.Address billingAdds = new ebizchargeServicemodelSoap.Address();
        
        system.debug('line 2');
        billingAdds.FirstName = ebizAccount.First_Name__c;
        billingAdds.LastName = ebizAccount.Last_Name__c;
        billingAdds.CompanyName ='';
        
        billingAdds.Address1 = ebizAccount.BillingStreet;
        billingAdds.Address2='';        
        billingAdds.City = ebizAccount.BillingCity;
        billingAdds.State = ebizAccount.BillingState;
        billingAdds.ZipCode = ebizAccount.BillingPostalCode;
        billingAdds.Country = ebizAccount.BillingCountry;
        system.debug('line 3');
        cst.BillingAddress = billingAdds;
        
        system.debug('line 4');
        //ebizchargeServicemodelSoap.Address ShippingAddress
        ebizchargeServicemodelSoap.Address shippingAdds = new ebizchargeServicemodelSoap.Address();
        system.debug('line 5');
        shippingAdds.FirstName = ebizAccount.First_Name__c;
        shippingAdds.LastName = ebizAccount.Last_Name__c;
        shippingAdds.CompanyName ='';
        
        shippingAdds.Address1 = ebizAccount.ShippingStreet;
        shippingAdds.Address2='';        
        shippingAdds.City = ebizAccount.ShippingCity;
        shippingAdds.State = ebizAccount.ShippingState;
        shippingAdds.ZipCode = ebizAccount.ShippingPostalCode;
        shippingAdds.Country = ebizAccount.ShippingCountry;
        
        cst.ShippingAddress = shippingAdds;
        
        system.debug('customer response before ');
        // customer method and response.
        ebizchargeServicemodelSoap.CustomerResponse ebiz_customer_response = new ebizchargeServicemodelSoap.CustomerResponse();
        
        ebiz_customer_response = ebiz.addCustomer(getSecurityToken(), cst);
        
        system.debug('customer statusCode ' + ebiz_customer_response.StatusCode);
        system.debug('ebiz_customer_response.CustomerId '+ ebiz_customer_response.CustomerId);
        system.debug('ebiz_customer_response.CustomerInternalId '+ ebiz_customer_response.CustomerInternalId);
        system.debug('ebiz_customer_response.Status '+ ebiz_customer_response.Status);
        system.debug('ebiz_customer_response.Error '+ ebiz_customer_response.Error);
        system.debug('ebiz_customer_response.ErrorCode '+ ebiz_customer_response.ErrorCode);
        if(ebiz_customer_response.StatusCode==1)
        {
            system.debug('customer internal id '+ ebiz_customer_response.CustomerInternalId);
            
            updateCustomerInfoAfterCallOut(AccountId, ebiz_customer_response.CustomerInternalId);
            
            return ebiz_customer_response.CustomerInternalId;
        }
        
        return '';
    }
    
    public static ebizchargeServicemodelSoap.TransactionDetail getTransactionDetails(Order ebizOrder)
    {
        ebizchargeServicemodelSoap.TransactionDetail tranDetail = new ebizchargeServicemodelSoap.TransactionDetail();
        
        system.debug('getTransactionDetails');
        
        system.debug('ebzo.OrderNumber '+ ebizOrder.OrderNumber);
        system.debug('ebzo.ContractId '+ ebizOrder.ContractId);
        system.debug('ebzo.Description '+ ebizOrder.Description);
        system.debug('ebzo.TotalAmount '+ ebizOrder.TotalAmount);
        
        
        tranDetail.NonTax = false;
        tranDetail.Tax = 0;
        //tranDetail.Table = '';
        tranDetail.Subtotal = 0;
        tranDetail.Shipping = 0;
        //tranDetail.ShipFromZip = '';
        //tranDetail.SessionID = '';
        tranDetail.OrderID = ebizOrder.OrderNumber;
        tranDetail.Invoice = ebizOrder.ContractId;
        tranDetail.Duty = 0;
        tranDetail.Discount = 0;
        //tranDetail.Comments = '';
        tranDetail.Description = ebizOrder.Description;
        //tranDetail.Currency_x = '';
        //tranDetail.Clerk = '';
        tranDetail.Amount = ebizOrder.TotalAmount;
        tranDetail.AllowPartialAuth = false;
        //tranDetail.Terminal = '';
        tranDetail.Tip = 0;    
        
        
        return tranDetail;
    }
    
    public static ebizchargeServicemodelSoap.ArrayOfLineItem getLineItems(string OrderNumber)
    {
        system.debug('getLineItems OrderNumber:'+ OrderNumber);
        ebizchargeServicemodelSoap.ArrayOfLineItem arrLineItems = new ebizchargeServicemodelSoap.ArrayOfLineItem();
        ebizchargeServicemodelSoap.LineItem[] lineArr = new List<ebizchargeServicemodelSoap.LineItem>();
        
        Integer i = 0;
        List<OrderItem> ordItm = getOrderItems(OrderNumber);
        
        system.debug('getLineItems ordItm: '+ ordItm);
        
        for(OrderItem oitm : ordItm )
            //for (Integer i = 0; i < ordItm..size ; i++)
        {
            ebizchargeServicemodelSoap.LineItem line = new ebizchargeServicemodelSoap.Lineitem();
            
            Product2  prd =  getProductDetail(oitm.Product2Id);
            
            system.debug('getLineItems Product2 '+ prd);
            system.debug('getLineItems oitm.Product2Id '+ oitm.Product2Id);
            system.debug('getLineItems prd.ProductCode '+ prd.ProductCode);
            system.debug('getLineItems prd.Name '+ prd.Name);
            system.debug('getLineItems prd.Description '+ prd.Description);
            system.debug('getLineItems oitm.UnitPrice '+ oitm.UnitPrice);
            system.debug('getLineItems oitm.Quantity '+ oitm.Quantity);
            
            line.SKU = prd.ProductCode;
            line.ProductRefNum = oitm.Product2Id;        
            line.ProductName = prd.Name;  
            if(prd.Description!=null)
            {
                line.Description = prd.Description;        
            }
            //line.Description = prd.Description ==null ?'':prd.Description;        
            line.UnitPrice =  String.valueOf(oitm.UnitPrice);
            line.Qty = String.valueOf(oitm.Quantity);
            line.Taxable = false;
            
            lineArr.add(line);        
            //arrLineItems.LineItem[i] = line;   
            i = i +1;
        }        
        
        arrLineItems.LineItem = lineArr;
        
        system.debug('linesitems '+ arrLineItems);
        
        return arrLineItems;
        
    }
    
    public static ebizchargeServicemodelSoap.ArrayOfTransactionLineItem getTransactionLineItems(string OrderNumber)
    {
        system.debug('getLineItems OrderNumber:'+ OrderNumber);
        ebizchargeServicemodelSoap.ArrayOfTransactionLineItem arrLineItems = new ebizchargeServicemodelSoap.ArrayOfTransactionLineItem();
        ebizchargeServicemodelSoap.TransactionLineItem[] lineArr = new List<ebizchargeServicemodelSoap.TransactionLineItem>();
        
        Integer i = 0;
        List<OrderItem> ordItm = getOrderItems(OrderNumber);
        
        system.debug('getLineItems ordItm: '+ ordItm);
        
        for(OrderItem oitm : ordItm )
            //for (Integer i = 0; i < ordItm..size ; i++)
        {
            ebizchargeServicemodelSoap.TransactionLineItem line = new ebizchargeServicemodelSoap.TransactionLineItem();
            
            Product2  prd =  getProductDetail(oitm.Product2Id);
            
            system.debug('getLineItems Product2 '+ prd);
            system.debug('getLineItems oitm.Product2Id '+ oitm.Product2Id);
            system.debug('getLineItems prd.ProductCode '+ prd.ProductCode);
            system.debug('getLineItems prd.Name '+ prd.Name);
            system.debug('getLineItems prd.Description '+ prd.Description);
            system.debug('getLineItems oitm.UnitPrice '+ oitm.UnitPrice);
            system.debug('getLineItems oitm.Quantity '+ oitm.Quantity);
            
            line.ProductRefNum = oitm.Product2Id;        
            line.SKU = prd.ProductCode;
            line.CommodityCode = '0';
            
            line.ProductName = prd.Name;  
            if(prd.Description!=null)
            {
                line.Description = prd.Description;        
            }else{
                line.Description = ''; 
            }
            line.DiscountAmount = 0;
            line.DiscountRate = 0;
            line.UnitOfMeasure = '0';
            line.UnitPrice =  oitm.UnitPrice;
            line.Qty = oitm.Quantity;
            line.Taxable = false;
            line.TaxAmount = 0;
            line.TaxRate = 0;
            
            lineArr.add(line);        
            //arrLineItems.LineItem[i] = line;   
            i = i +1;
        }        
        
        arrLineItems.TransactionLineItem = lineArr;
        
        system.debug('linesitems '+ arrLineItems);
        
        return arrLineItems;
        
    }
    
    public static List<OrderItem> getOrderItems(string OrderNumber)
    {
        system.debug('ordItm getOrderItems OrderNumber:'+ OrderNumber);
        //OrderItem
        List<OrderItem> ordItm   = [SELECT
                                    Product2Id, Quantity, UnitPrice, TotalPrice
                                    FROM OrderItem  where OrderId=:OrderNumber ];
        
        system.debug('ordItm Product2Id '+ ordItm);
        
        return ordItm;
    }
    
    public static Product2 getProductDetail(string Product2Id)
    {
        system.debug('getProductDetail Product2Id '+ Product2Id);
        Product2  prd = [SELECT
                         ProductCode, Description, Name
                         FROM Product2  where id=:Product2Id limit 1];
        
        return prd;
        
    }
    
    
    public static void saveTransactionResponse(ebizchargeServicemodelSoap.TransactionResponse ebiz_transaction_response, Order ebizOrder)
    {
        //saving transaction response.
        List<Transaction__c> newTranResponse = new List<Transaction__c>();
        
        Transaction__c resTran = new Transaction__c();
        
        system.debug('tran response '+ ebiz_transaction_response.ResultCode);
        system.debug('tran response '+ ebiz_transaction_response.Result);
        system.debug('tran response '+ ebiz_transaction_response.ErrorCode);
        system.debug('tran response '+ ebiz_transaction_response.Error);
        
        if(ebiz_transaction_response.ResultCode=='A')
        {
            system.debug('ebiz_transaction_response.ResultCode '+ ebiz_transaction_response.ResultCode);
            Order[] updatedOrders = new Order[0];
            
            ebizOrder.EBizCharge_Payment_Status__c = 1;
            ebizOrder.Payment_Status__c = 'Paid';
            updatedOrders.add(ebizOrder);
            
            update updatedOrders;
            system.debug('update order ebiz status end');
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Payment Approved: ' + ebiz_transaction_response.ResultCode));        
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Payment Failed: ' + ebiz_transaction_response.ResultCode));        
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ebiz_transaction_response.Error));        
        }
        resTran.Order_Number__c = ebizOrder.OrderNumber;
        resTran.Customer_Number__c = ebiz_transaction_response.CustNum;
        resTran.Result_Code__c   = ebiz_transaction_response.ResultCode;
        resTran.Result__c   = ebiz_transaction_response.Result;
        resTran.Remaining_Balance__c   = ebiz_transaction_response.RemainingBalance;
        resTran.Ref_Number__c= ebiz_transaction_response.RefNum;
        resTran.Profiler_Reason__c= ebiz_transaction_response.ProfilerReason;
        resTran.Profiler_Response__c= ebiz_transaction_response.ProfilerResponse;
        resTran.Profiler_Score__c= ebiz_transaction_response.ProfilerScore;
        resTran.Payload__c= ebiz_transaction_response.Payload;
        resTran.isDuplicate__c= ebiz_transaction_response.isDuplicate;
        resTran.Error_Code__c= ebiz_transaction_response.ErrorCode;
        resTran.Error__c= ebiz_transaction_response.Error;
        resTran.Vpas_Result_Code__c= ebiz_transaction_response.VpasResultCode;
        resTran.Converted_Amount_Currency__c= ebiz_transaction_response.ConvertedAmountCurrency;
        resTran.Converted_Amount__c= ebiz_transaction_response.ConvertedAmount;
        resTran.Conversion_Rate__c= ebiz_transaction_response.ConversionRate;
        resTran.Card_Code_Result_Code__c= ebiz_transaction_response.CardLevelResultCode;
        resTran.Card_Level_Result__c= ebiz_transaction_response.CardLevelResult;
        resTran.Card_Code_Result_Code__c= ebiz_transaction_response.CardCodeResultCode;
        resTran.Card_Code_Result__c= ebiz_transaction_response.CardCodeResult;
        resTran.Batch_Ref_Number__c= ebiz_transaction_response.BatchRefNum;
        resTran.Batch_Number__c= ebiz_transaction_response.BatchNum;
        resTran.Avs_Result_Code__c= ebiz_transaction_response.AvsResultCode;
        resTran.Avs_Result__c= ebiz_transaction_response.AvsResult;
        resTran.Auth_Code__c= ebiz_transaction_response.AuthCode;
        resTran.Auth_Amount__c= ebiz_transaction_response.AuthAmount;
        resTran.Acs_Url__c= ebiz_transaction_response.AcsUrl;
        resTran.Status__c= ebiz_transaction_response.Status;
        resTran.Status_Code__c= ebiz_transaction_response.StatusCode;
        system.debug('tran response after ');
        newTranResponse.add(resTran);
        system.debug('tran response 1 ');
        insert newTranResponse;
        system.debug('tran response 2 ');
    }
    
    
    public static string saveStatusTransactionResponse(ebizchargeServicemodelSoap.TransactionResponse ebiz_transaction_response, string OrderNumber, string paymentMethodID, decimal paymentStatus, string clientSource)
    {
        
        system.debug('runTransactionPayment.ebiz.ebiz_transaction_response.OrderNumber ' + OrderNumber);
        Order ebizOrder = getOrderDetail(OrderNumber);
        
        Transaction__c resTran = new Transaction__c();
        
        system.debug('tran response '+ ebiz_transaction_response.ResultCode);
        system.debug('tran response '+ ebiz_transaction_response.Result);
        system.debug('tran response '+ ebiz_transaction_response.ErrorCode);
        system.debug('tran response '+ ebiz_transaction_response.Error);
        
        system.debug('runTransactionPayment.ebiz.ebiz_transaction_response.ResultCode ' + ebiz_transaction_response.ResultCode);
        if(ebiz_transaction_response.ResultCode=='A')
        {
            system.debug('ebiz_transaction_response.ResultCode '+ ebiz_transaction_response.ResultCode);
            Order[] updatedOrders = new Order[0];
            
            ebizOrder.EBizCharge_Payment_Status__c =  paymentStatus;
            ebizOrder.Payment_Status__c = 'Paid';
            
            updatedOrders.add(ebizOrder);
            if(clientSource != 'E')
            {
                update updatedOrders;
            }
            
            
            system.debug('update order ebiz status end');
            
            
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Payment Approved: ' + ebiz_transaction_response.ResultCode));        
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Payment Failed: ' + ebiz_transaction_response.ResultCode));        
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ebiz_transaction_response.Error));        
        }
        
        resTran.Order_Number__c = ebizOrder.OrderNumber;
        resTran.Customer_Number__c = ebiz_transaction_response.CustNum;
        resTran.Result_Code__c   = ebiz_transaction_response.ResultCode;
        resTran.Result__c   = ebiz_transaction_response.Result;
        resTran.Remaining_Balance__c   = ebiz_transaction_response.RemainingBalance;
        resTran.Ref_Number__c= ebiz_transaction_response.RefNum;
        resTran.Profiler_Reason__c= ebiz_transaction_response.ProfilerReason;
        resTran.Profiler_Response__c= ebiz_transaction_response.ProfilerResponse;
        resTran.Profiler_Score__c= ebiz_transaction_response.ProfilerScore;
        resTran.Payload__c= ebiz_transaction_response.Payload;
        resTran.isDuplicate__c= ebiz_transaction_response.isDuplicate;
        resTran.Error_Code__c= ebiz_transaction_response.ErrorCode;
        resTran.Error__c= ebiz_transaction_response.Error;
        resTran.Vpas_Result_Code__c= ebiz_transaction_response.VpasResultCode;
        resTran.Converted_Amount_Currency__c= ebiz_transaction_response.ConvertedAmountCurrency;
        resTran.Converted_Amount__c= ebiz_transaction_response.ConvertedAmount;
        resTran.Conversion_Rate__c= ebiz_transaction_response.ConversionRate;
        resTran.Card_Code_Result_Code__c= ebiz_transaction_response.CardLevelResultCode;
        resTran.Card_Level_Result__c= ebiz_transaction_response.CardLevelResult;
        resTran.Card_Code_Result_Code__c= ebiz_transaction_response.CardCodeResultCode;
        resTran.Card_Code_Result__c= ebiz_transaction_response.CardCodeResult;
        resTran.Batch_Ref_Number__c= ebiz_transaction_response.BatchRefNum;
        resTran.Batch_Number__c= ebiz_transaction_response.BatchNum;
        resTran.Avs_Result_Code__c= ebiz_transaction_response.AvsResultCode;
        resTran.Avs_Result__c= ebiz_transaction_response.AvsResult;
        resTran.Auth_Code__c= ebiz_transaction_response.AuthCode;
        resTran.Auth_Amount__c= ebiz_transaction_response.AuthAmount;
        resTran.Acs_Url__c= ebiz_transaction_response.AcsUrl;
        resTran.Status__c= ebiz_transaction_response.Status;
        resTran.Status_Code__c= ebiz_transaction_response.StatusCode;
        system.debug('tran response after ');
        //newTranResponse.add(resTran);
        system.debug('tran response 1 ');
        
        //insert newTranResponse;
        insert resTran;
        
        system.debug('tran response 2 ');
        system.debug('return resTran.Name ' +resTran.Name);
        system.debug('return resTran.id ' +resTran.id);
        system.debug('ebiz_transaction_response.RefNum: ' + ebiz_transaction_response.RefNum);
        return ebiz_transaction_response.RefNum;
    }
    
    
    
    public static void runRecurringPayment(transactionParams tparm, Account ebizAccount)
    {
        system.debug('runTransactionPayment.tparm ' + tparm);        
        system.debug('runTransactionPayment.ebizAccount ' + ebizAccount);
        
        system.debug('runTransactionPayment.tparm.internalID ' + tparm.internalID);
        if(string.isBlank(tparm.internalID))
        {
            system.debug('runTransactionPayment.tparm.internalID.isBlank addEbizCustomer.before' + tparm.internalID);
            tparm.internalID = addEbizCustomer(ebizAccount, tparm.accountID);            
            system.debug('runTransactionPayment.tparm.internalID.isBlank addEbizCustomer.after' + tparm.internalID);
        }
        
        string paymentMethodID='';
        if(tparm.methodID=='1') // in case new credit card
        {
            system.debug('runTransactionPayment.tparm.methodID ' + 'CreditCard');
            paymentMethodID = addPaymentMethod(tparm, 'CreditCard');
            system.debug('runTransactionPayment.tparm.methodID.CreditCard ' + paymentMethodID);
        }
        else
        {            
            paymentMethodID = tparm.methodID;
            system.debug('runTransactionPayment.tparm.methodID.else ' + paymentMethodID);
        }
        
        //string customerToken = getCustomerToken(ebizAccount.id, tparm.internalID);
        ebizchargeServicemodelSoap.RecurringBilling rccbilling = new ebizchargeServicemodelSoap.RecurringBilling();
        
        
        rccbilling.Amount = tparm.Amount;
        rccbilling.Tax= tparm.Tax;
        rccbilling.Enabled = true;
        rccbilling.Start=tparm.Start;
        rccbilling.Expire = tparm.Expire;
        rccbilling.ScheduleName = 'RECURRING PAYMENT';//tparm.ScheduleName;
        rccbilling.Schedule = tparm.Schedule;
        rccbilling.Next = tparm.Expire;
        rccbilling.RepeatCount = 1;
        rccbilling.ReceiptNote = tparm.ScheduleName;
        rccbilling.SendCustomerReceipt = true;
        
        system.debug('rccbilling.Amount ' + rccbilling.Amount);        
        system.debug('rccbilling.Tax ' + rccbilling.Tax);        
        system.debug('rccbilling.Start ' + rccbilling.Start);        
        system.debug('rccbilling.Expire ' + rccbilling.Expire);        
        system.debug('rccbilling.Schedule ' + rccbilling.Schedule);        
        system.debug('rccbilling.ScheduleName ' + rccbilling.ScheduleName);        
        system.debug('rccbilling.SendCustomerReceipt ' + rccbilling.SendCustomerReceipt);        
        system.debug('rccbilling.ReceiptTemplateName ' + rccbilling.ReceiptTemplateName);        
        
        
        system.debug('runRecurringPayment.ebiz.ScheduleRecurringPayment ' + 'before');
        string response = ebiz.ScheduleRecurringPayment(getSecurityToken(), tparm.internalID, paymentMethodID, rccbilling);
        system.debug('runRecurringPayment.ebiz.ScheduleRecurringPayment after response: ' + response);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Recurring payment scheduled sucessfully:' + response));        
        
        
    }
    
    public static string GetEbizWebFormURL(string OrderNumber, string toEmail, string emailFrom, string TemplateInternalId)
    {
        system.debug('GetEbizWebFormURL: ' + OrderNumber);
        
        Order ebizOrder = EbizMethods.getOrderDetail(OrderNumber);            
        Account ebizAccount = EbizMethods.getAccountDetail(ebizOrder.AccountId); 
        
        ebizchargeServicemodelSoap.EbizWebForm tempWebForm = new ebizchargeServicemodelSoap.EbizWebForm();
        
        
        string emailSubject='EBizCharge Payment Request Notification';
        string emailNotes='';
        //string TemplateInternalId='';
        //string emailFrom='';
        
        tempWebForm.FromEmail = emailFrom;
        tempWebForm.FromName = 'EBizCharge';
        tempWebForm.EmailAddress = toEmail;
        tempWebForm.EmailNotes = emailNotes;
        tempWebForm.EmailSubject = emailSubject;
        tempWebForm.EmailTemplateID = TemplateInternalId;
        //tempWebForm.EmailTemplateName = 'Request Payment T1';
        
        tempWebForm.SendEmailToCustomer = true;        
        tempWebForm.CustomerId = ebizOrder.AccountId;
        tempWebForm.CustFullName = ebizAccount.First_Name__c + ' ' + ebizAccount.Last_Name__c;
        
        tempWebForm.InvoiceNumber = orderNumber;        
        tempWebForm.PoNum = orderNumber;
        tempWebForm.OrderId = orderNumber;
        
        tempWebForm.Date_x = ebizOrder.CreatedDate;
        tempWebForm.DueDate = ebizOrder.CreatedDate;
        
        tempWebForm.TotalAmount = ebizOrder.TotalAmount;
        tempWebForm.AmountDue = ebizOrder.TotalAmount;
        tempWebForm.TipAmount = ebizOrder.TotalAmount;
        tempWebForm.ShippingAmount = ebizOrder.TotalAmount;
        tempWebForm.DutyAmount = ebizOrder.TotalAmount;
        tempWebForm.TaxAmount = ebizOrder.TotalAmount;
        
        tempWebForm.Description = '';
        
        ebizchargeServicemodelSoap.Address billingAdds = new ebizchargeServicemodelSoap.Address();
        
        system.debug('line 2');
        billingAdds.FirstName = ebizAccount.First_Name__c;
        billingAdds.LastName = ebizAccount.Last_Name__c;
        billingAdds.CompanyName ='';
        
        billingAdds.Address1 = ebizAccount.BillingStreet;
        
        billingAdds.City = ebizAccount.BillingCity;
        billingAdds.State = ebizAccount.BillingState;
        billingAdds.ZipCode = ebizAccount.BillingPostalCode;
        billingAdds.Country = ebizAccount.BillingCountry;
        billingAdds.IsDefault = false;
        system.debug('line 3');
        
        tempWebForm.BillingAddress = billingAdds;
        
        system.debug('line 4');
        //ebizchargeServicemodelSoap.Address ShippingAddress
        ebizchargeServicemodelSoap.Address shippingAdds = new ebizchargeServicemodelSoap.Address();
        system.debug('line 5');
        shippingAdds.FirstName = ebizAccount.First_Name__c;
        shippingAdds.LastName = ebizAccount.Last_Name__c;
        shippingAdds.CompanyName ='';
        
        shippingAdds.Address1 = ebizAccount.ShippingStreet;
        
        shippingAdds.City = ebizAccount.ShippingCity;
        shippingAdds.State = ebizAccount.ShippingState;
        shippingAdds.ZipCode = ebizAccount.ShippingPostalCode;
        shippingAdds.Country = ebizAccount.ShippingCountry;
        shippingAdds.IsDefault = false;
        tempWebForm.ShippingAddress = shippingAdds;
        
        tempWebForm.ApprovedURL = '0';
        tempWebForm.DeclinedURL = '0';
        tempWebForm.ErrorURL = '0';
        tempWebForm.DisplayDefaultResultPage = 0;
        tempWebForm.PayByType = 'aaa';
        tempWebForm.AllowedPaymentMethods = 'aaa';
        tempWebForm.SavePaymentMethod = false;
        tempWebForm.ShowSavedPaymentMethods = false;
        tempWebForm.CountryCode = '0';
        tempWebForm.CurrencyCode = '0';
        tempWebForm.ProcessingCommand = '0';
        tempWebForm.SoftwareId = 'SalesforceApp';
        tempWebForm.TransactionLookupKey = 'false';
        
        
        //tran.LineItems = getLineItems(ebizOrder.Id);
        tempWebForm.LineItems = getTransactionLineItems(ebizOrder.Id);
        
        
        tempWebForm.Clerk = '?';
        tempWebForm.Terminal = '?';
        tempWebForm.ShowViewInvoiceLink = false;
        tempWebForm.InvoiceInternalId = '';
        
        string response = ebiz.GetEbizWebFormURL(getSecurityToken(), tempWebForm);
        
        
        return response;
    }
    
    public static ebizchargeServicemodelSoap.Payment[] searchPendingPayments(date startDate, date endDate)
    {
        //ebizchargeServicemodelSoap.ArrayOfPayment[] arrpendings;
        ebizchargeServicemodelSoap.ArrayOfPayment arrpendings = new ebizchargeServicemodelSoap.ArrayOfPayment();
        
        ebizchargeServicemodelSoap.Payment[] paymentlist ;//= new List<ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile>();
        arrpendings = ebiz.SearchEbizWebFormPendingPayments(getSecurityToken(), '', startDate, endDate, null, 0, 1000, '');
        
        paymentlist = arrpendings.Payment;
        
        return paymentlist;
        
    }
    
    public static ebizchargeServicemodelSoap.Payment[] SearchEbizWebFormReceivedPayments(date startDate, date endDate)
    {
        //ebizchargeServicemodelSoap.ArrayOfPayment[] arrpendings;
        ebizchargeServicemodelSoap.ArrayOfPayment arrpendings = new ebizchargeServicemodelSoap.ArrayOfPayment();
        
        ebizchargeServicemodelSoap.Payment[] paymentlist ;//= new List<ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile>();
        arrpendings = ebiz.SearchEbizWebFormReceivedPayments(getSecurityToken(), '', startDate, endDate, null, 0, 1000, '');
        
        paymentlist = arrpendings.Payment;
        
        return paymentlist;
        
    }
    
    public static ebizchargeServicemodelSoap.PaymentResponse DeleteEbizWebFormPayment(string paymentInternalID)
    {
        
        ebizchargeServicemodelSoap.PaymentResponse response = ebiz.DeleteEbizWebFormPayment(getSecurityToken(), paymentInternalID);
        
        return response;
        
    }
    
    public static string ResendEbizWebFormEmail(string paymentInternalID)
    {
        
        string response = ebiz.ResendEbizWebFormEmail(getSecurityToken(), paymentInternalID);
        
        return response;
        
    }
    
    public static ebizchargeServicemodelSoap.PaymentResponse MarkEbizWebFormPaymentAsApplied(string paymentInternalID)
    {
        
        
        
        ebizchargeServicemodelSoap.PaymentResponse response = ebiz.MarkEbizWebFormPaymentAsApplied(getSecurityToken(), paymentInternalID);
        
        
        
        return response;
        
    }
    
    public static ebizchargeServicemodelSoap.PaymentResponse MarkEbizPaymentAsApplied(String invoiceNumber,string paymentInternalID)
    {
        
        
        
        ebizchargeServicemodelSoap.PaymentResponse response = ebiz.MarkPaymentAsApplied(getSecurityToken(), invoiceNumber, paymentInternalID);
        
        
        
        return response;
        
    }
    
    @future(callout=true)
    public static void markOrderPaid(string OrderNumber)
    {
        system.debug('markOrderPaid.OrderNumber ' + OrderNumber);
        Order ebizOrder = getOrderDetail(OrderNumber);                  
        
        Order[] updatedOrders = new Order[0];
        
        ebizOrder.EBizCharge_Payment_Status__c =  1;
        ebizOrder.Payment_Status__c = 'Paid_Email';
        updatedOrders.add(ebizOrder);
        update updatedOrders;
    }
    
    
    @future(callout=true)
    public static void invokeStandardAccount_AddCustomer(string accountid) {
        system.debug('invokeStandardAccount_AddCustomer ');
        system.debug('contact account id '+ accountid);
        

        Account ebzc = EbizMethods.getAccountDetail(accountid);
        ebiz_setting__c eb_st = [SELECT Security_Id__c, User_Id__c,Password__c FROM ebiz_setting__c limit 1];
        
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        
        //security token object
        ebizchargeServicemodelSoap.SecurityToken st = new ebizchargeServicemodelSoap.SecurityToken();
        st.SecurityId = eb_st.Security_Id__c;//'57980acf-fbc1-4813-94d3-ad9027784a74';
        st.UserId = eb_st.User_Id__c;//'Cbs';
        st.Password = eb_st.Password__c ;//'Cbs12358!';
        
        system.debug('line 1');
        
        system.debug('ebzc.Account ' + ebzc.id);
        system.debug('ebzc.FirstName ' + ebzc.First_Name__c);
        system.debug('ebzc.LastName ' + ebzc.Last_Name__c);
        system.debug('ebzc.Phone ' + ebzc.Phone);
        system.debug('ebzc.Fax ' + ebzc.Fax);
        system.debug('ebzc.Email ' + ebzc.Email__c);
        
        system.debug('ebzc.MailingStreet ' + ebzc.BillingStreet);
        system.debug('ebzc.MailingCity ' + ebzc.BillingCity);
        system.debug('ebzc.MailingState ' + ebzc.BillingState);
        system.debug('ebzc.MailingPostalCode ' + ebzc.BillingPostalCode);
        system.debug('ebzc.MailingCountry ' + ebzc.BillingCountry);
        
        ebizchargeServicemodelSoap.Customer cst = new ebizchargeServicemodelSoap.Customer();
        
        //cst.MerchantId = '';
        cst.CustomerId = ebzc.id;
        cst.FirstName = ebzc.First_Name__c;
        cst.LastName = ebzc.Last_Name__c;
        cst.CompanyName = ebzc.Name;
        cst.Phone = ebzc.Phone;
        cst.Fax = ebzc.Fax;
        cst.Email = ebzc.Email__c;
        cst.WebSite = ebzc.Website;
        
        ebizchargeServicemodelSoap.Address billingAdds = new ebizchargeServicemodelSoap.Address();
        
        system.debug('line 2');
        billingAdds.FirstName = ebzc.First_Name__c;
        billingAdds.LastName = ebzc.Last_Name__c;
        billingAdds.CompanyName ='';
        
        billingAdds.Address1 = ebzc.BillingStreet;
        billingAdds.Address2='';        
        billingAdds.City = ebzc.BillingCity;
        billingAdds.State = ebzc.BillingState;
        billingAdds.ZipCode = ebzc.BillingPostalCode;
        billingAdds.Country = ebzc.BillingCountry;
        system.debug('line 3');
        cst.BillingAddress = billingAdds;
        
        system.debug('line 4');
        //ebizchargeServicemodelSoap.Address ShippingAddress
        ebizchargeServicemodelSoap.Address shippingAdds = new ebizchargeServicemodelSoap.Address();
        system.debug('line 5');
        shippingAdds.FirstName = ebzc.First_Name__c;
        shippingAdds.LastName = ebzc.Last_Name__c;
        shippingAdds.CompanyName ='';
        
        shippingAdds.Address1 = ebzc.ShippingStreet;
        shippingAdds.Address2='';        
        shippingAdds.City = ebzc.ShippingCity;
        shippingAdds.State = ebzc.ShippingState;
        shippingAdds.ZipCode = ebzc.ShippingPostalCode;
        shippingAdds.Country = ebzc.ShippingCountry;
        
        cst.ShippingAddress = shippingAdds;
        
        system.debug('customer response before ');
        // customer method and response.
        ebizchargeServicemodelSoap.CustomerResponse ebiz_customer_response = new ebizchargeServicemodelSoap.CustomerResponse();
        
        ebiz_customer_response = ebiz.addCustomer(st, cst);
        
        system.debug('customer statusCode ' + ebiz_customer_response.StatusCode);
        system.debug('ebiz_customer_response.CustomerId '+ ebiz_customer_response.CustomerId);
        system.debug('ebiz_customer_response.CustomerInternalId '+ ebiz_customer_response.CustomerInternalId);
        system.debug('ebiz_customer_response.Status '+ ebiz_customer_response.Status);
        system.debug('ebiz_customer_response.Error '+ ebiz_customer_response.Error);
        system.debug('ebiz_customer_response.ErrorCode '+ ebiz_customer_response.ErrorCode);
        
        system.debug('ebiz_customer_response.StatusCode ' + ebiz_customer_response.StatusCode);
        
        if(ebiz_customer_response.StatusCode==1)
        {
            system.debug('updateCustomerInfoAfterCallOutSimple before '+ ebiz_customer_response.CustomerInternalId);

            eBizMethods.updateCustomerInfoAfterCallOutSimple(accountID, ebiz_customer_response.CustomerInternalId);
            system.debug('updateCustomerInfoAfterCallOutSimple after ');            
            
        }
        
        
    }
    
    @future(callout=true)
    public static void updateCustomerInfoAfterCallOut(string accountID, string CustomerInternalId)
    {
        Account ebizAccount = EbizMethods.getAccountDetail(accountID);
        
        Account[] updatedAccounts = new Account[0];
        
        ebizAccount.EBizCharge_Internal_ID__c = CustomerInternalId;
        updatedAccounts.add(ebizAccount);
        
        update updatedAccounts;
        
        system.debug('customer after update internal id ');
    }
    
    
    public static void updateCustomerInfoAfterCallOutSimple(string accountID, string CustomerInternalId)
    {
        Account ebizAccount = EbizMethods.getAccountDetail(accountID);
        
        Account[] updatedAccounts = new Account[0];
        
        ebizAccount.EBizCharge_Internal_ID__c = CustomerInternalId;
        updatedAccounts.add(ebizAccount);
        
        update updatedAccounts;
        
        system.debug('customer after update internal id ');
    }
    
    @future(callout=true)
    public static void invokeStandardAccount_UpdateCustomer(string accountid) {
        
        system.debug('invokeStandardAccount_UpdateCustomer ');
        system.debug('contact account id '+ accountid);
        
        //Order Information
        
        Account ebzc = EbizMethods.getAccountDetail(accountid);
        
        ebiz_setting__c eb_st = [SELECT Security_Id__c, User_Id__c,Password__c FROM ebiz_setting__c limit 1];
        
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        
        //security token object
        ebizchargeServicemodelSoap.SecurityToken st = new ebizchargeServicemodelSoap.SecurityToken();
        st.SecurityId = eb_st.Security_Id__c;//'57980acf-fbc1-4813-94d3-ad9027784a74';
        st.UserId = eb_st.User_Id__c;//'Cbs';
        st.Password = eb_st.Password__c ;//'Cbs12358!';
        
        system.debug('line 1');
        
        system.debug('ebzc.Account ' + accountid);
        system.debug('ebzc.FirstName ' + ebzc.First_Name__c);
        system.debug('ebzc.LastName ' + ebzc.Last_Name__c);
        system.debug('ebzc.Phone ' + ebzc.Phone);
        system.debug('ebzc.Fax ' + ebzc.Fax);
        system.debug('ebzc.Email ' + ebzc.Email__c);
        
        system.debug('ebzc.MailingStreet ' + ebzc.BillingStreet);
        system.debug('ebzc.MailingCity ' + ebzc.BillingCity);
        system.debug('ebzc.MailingState ' + ebzc.BillingState);
        system.debug('ebzc.MailingPostalCode ' + ebzc.BillingPostalCode);
        system.debug('ebzc.MailingCountry ' + ebzc.BillingCountry);
        
        ebizchargeServicemodelSoap.Customer cst = new ebizchargeServicemodelSoap.Customer();
        
        //cst.MerchantId = '';
        cst.CustomerInternalId = ebzc.EBizCharge_Internal_ID__c;
        cst.CustomerId = accountid;
        cst.FirstName = ebzc.First_Name__c;
        cst.LastName = ebzc.Last_Name__c;
        cst.CompanyName = ebzc.Name;
        cst.Phone = ebzc.Phone;
        cst.Fax = ebzc.Fax;
        cst.Email = ebzc.Email__c;
        cst.WebSite = ebzc.Website;
        
        ebizchargeServicemodelSoap.Address billingAdds = new ebizchargeServicemodelSoap.Address();
        
        system.debug('line 2');
        billingAdds.FirstName = ebzc.First_Name__c;
        billingAdds.LastName = ebzc.Last_Name__c;
        billingAdds.CompanyName = ebzc.Name;
        
        billingAdds.Address1 = ebzc.BillingStreet;
        billingAdds.Address2='';        
        billingAdds.City = ebzc.BillingCity;
        billingAdds.State = ebzc.BillingState;
        billingAdds.ZipCode = ebzc.BillingPostalCode;
        billingAdds.Country = ebzc.BillingCountry;
        system.debug('line 3');
        cst.BillingAddress = billingAdds;
        
        system.debug('line 4');
        //ebizchargeServicemodelSoap.Address ShippingAddress
        ebizchargeServicemodelSoap.Address shippingAdds = new ebizchargeServicemodelSoap.Address();
        system.debug('line 5');
        shippingAdds.FirstName = ebzc.First_Name__c;
        shippingAdds.LastName = ebzc.Last_Name__c;
        shippingAdds.CompanyName =ebzc.Name;
        
        shippingAdds.Address1 = ebzc.ShippingStreet;
        shippingAdds.Address2='';        
        shippingAdds.City = ebzc.ShippingCity;
        shippingAdds.State = ebzc.ShippingState;
        shippingAdds.ZipCode = ebzc.ShippingPostalCode;
        shippingAdds.Country = ebzc.ShippingCountry;
        
        cst.ShippingAddress = shippingAdds;
        
        system.debug('customer response before ' +ebzc.EBizCharge_Internal_ID__c);
        // customer method and response.
        ebizchargeServicemodelSoap.CustomerResponse ebiz_customer_response = new ebizchargeServicemodelSoap.CustomerResponse();
        
        ebiz_customer_response = ebiz.UpdateCustomer(st, cst, '', ebzc.EBizCharge_Internal_ID__c);
        
        system.debug('customer statusCode ' + ebiz_customer_response.StatusCode);
        system.debug('ebiz_customer_response.CustomerId '+ ebiz_customer_response.CustomerId);
        system.debug('ebiz_customer_response.CustomerInternalId '+ ebiz_customer_response.CustomerInternalId);
        system.debug('ebiz_customer_response.Status '+ ebiz_customer_response.Status);
        system.debug('ebiz_customer_response.Error '+ ebiz_customer_response.Error);
        system.debug('ebiz_customer_response.ErrorCode '+ ebiz_customer_response.ErrorCode);
        
        
        //ebiz_customer_response.CustomerId
        //ebiz_customer_response.CustomerInternalId
        //ebiz_customer_response.Status
        //ebiz_customer_response.StatusCode
        //ebiz_customer_response.Error
        //ebiz_customer_response.ErrorCode
        
    }
    
    public static void syncAccount(String accountID)
    {
        Account ebzc = EbizMethods.getAccountDetail(accountid);
        
        if(string.isBlank(ebzc.EBizCharge_Internal_ID__c))
        {
            system.debug('if(string.isBlank(ebzc.EBizCharge_Internal_ID__c))'+accountid);
            invokeStandardAccount_AddCustomer(accountid);
        }
    }
    
    public static void syncAllProducts()
    {
        List<Product2>  prd = [SELECT
                               id, IsActive,
                         ProductCode, Description, Name
                         FROM Product2];
        
        for(Product2 p : prd)
        {
            AddProductsToEBizCharge(p);
        }
    }
    
    public static void AddProductsToEBizCharge(Product2 p)
    {
        ebizchargeServicemodelSoap.ItemDetails item = new ebizchargeServicemodelSoap.ItemDetails();
        
        item.ItemId = p.id;
        item.Name = p.Name;
        item.SKU = p.ProductCode;
        item.Description = p.Description;
        item.Active = p.IsActive;
        
        item.UnitPrice = 0;
        item.UnitCost = 0;
        item.QtyOnHand = 0;
        item.Taxable = false;
        item.TaxRate = 0;
        item.SoftwareId = 'SalesforceApp';
        item.Active = p.IsActive;
        item.Active = p.IsActive;

        system.debug('Item: ' + item);
        
        ebizchargeServicemodelSoap.ItemDetailsResponse response = ebiz.AddItem(getSecurityToken(), item);
        
        system.debug('ItemDetailsResponse: ' + response);
    }
    */
    
}