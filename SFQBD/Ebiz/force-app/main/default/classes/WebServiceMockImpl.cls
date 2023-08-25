@isTest
global class WebServiceMockImpl implements WebServiceMock {
    Integer i = 0;
    global void doInvoke(Object stub, Object request, Map < String, Object > response, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
        system.debug('strat webservicemock');
        system.debug(request);
        ebizchargeServicemodelSoap.SearchPaymentFormPendingPayments_element Token_ele = new ebizchargeServicemodelSoap.SearchPaymentFormPendingPayments_element();
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Token_ele.securityToken = Token;
        system.debug('HitCounter->>>>>' + i++);
        if (request instanceof ebizchargeServicemodelSoap.GetEmailTemplates_element) {
            Ebiz_C.ebizchargeServicemodelSoap.EmailTemplate tp = new Ebiz_C.ebizchargeServicemodelSoap.EmailTemplate();
            tp.TemplateName = 'test';
            tp.TemplateInternalId = 'te23st';
            tp.TemplateSubject = 'test';
            tp.TemplateDescription = 'test';
            tp.TemplateText = 'TemplateHTML';
            tp.FromEmail = 'test@ebiz.com';
            tp.FromName = 'test@ebiz.com';
            tp.ReplyToEmail = 'test@ebiz.com';
            tp.ReplyToDisplayName = 'test@ebiz.com';
            tp.TemplateSource = 'test@ebiz.com';
            ebizchargeServicemodelSoap.ArrayOfEmailTemplate respElement = new ebizchargeServicemodelSoap.ArrayOfEmailTemplate();
            List < Ebiz_C.ebizchargeServicemodelSoap.EmailTemplate > Templetes = new List < Ebiz_C.ebizchargeServicemodelSoap.EmailTemplate > {};
            Templetes.add(tp);
            respElement.EmailTemplate = Templetes;
            ebizchargeServicemodelSoap.GetEmailTemplatesResponse_element eBizService = new ebizchargeServicemodelSoap.GetEmailTemplatesResponse_element();
            eBizService.GetEmailTemplatesResult = respElement;
            response.put('response_x', eBizService);
        }
        if (request instanceof ebizchargeServicemodelSoap.ArrayOfEmailTemplate) {
            Ebiz_C.ebizchargeServicemodelSoap.EmailTemplate tp = new Ebiz_C.ebizchargeServicemodelSoap.EmailTemplate();
            tp.TemplateName = 'test';
            tp.TemplateInternalId = 'te23st';
            tp.TemplateSubject = 'test';
            tp.TemplateDescription = 'test';
            tp.TemplateText = 'TemplateHTML';
            tp.FromEmail = 'test@ebiz.com';
            tp.FromName = 'test@ebiz.com';
            tp.ReplyToEmail = 'test@ebiz.com';
            tp.ReplyToDisplayName = 'test@ebiz.com';
            tp.TemplateSource = 'test@ebiz.com';
            ebizchargeServicemodelSoap.ArrayOfEmailTemplate respElement = new ebizchargeServicemodelSoap.ArrayOfEmailTemplate();
            List < Ebiz_C.ebizchargeServicemodelSoap.EmailTemplate > Templetes = new List < Ebiz_C.ebizchargeServicemodelSoap.EmailTemplate > {};
            Templetes.add(tp);
            respElement.EmailTemplate = Templetes;
            ebizchargeServicemodelSoap.eBizService eBizService = new ebizchargeServicemodelSoap.eBizService();
            eBizService.GetEmailTemplates(Token, tp.TemplateInternalId, tp.TemplateName);
            response.put('response_x', eBizService);
        }
        if (request instanceof ebizchargeServicemodelSoap.MerchantTransactionData) {
            system.debug('==>>Invoked');
            ebizchargeServicemodelSoap.MerchantTransactionData respElement = new ebizchargeServicemodelSoap.MerchantTransactionData();
            ebizchargeServicemodelSoap.eBizService eBizService = new ebizchargeServicemodelSoap.eBizService();
            respElement.TaxPercentage = 32;
            ebizchargeServicemodelSoap.GetMerchantTransactionData_element request_x = new ebizchargeServicemodelSoap.GetMerchantTransactionData_element();
            eBizService.GetMerchantTransactionData(Token);
            request_x.securityToken = Token;
            response.put('response_x', request_x);
        }
        if (request instanceof ebizchargeServicemodelSoap.Customer) {
            ebizchargeServicemodelSoap.Customer GetCustomerResult;
            GetCustomerResult.MerchantId = '2234';
            GetCustomerResult.CustomerInternalId = '2234';
            GetCustomerResult.CustomerId = '232342423sdfsd';
            GetCustomerResult.FirstName = 'FirstName';
            GetCustomerResult.FirstName = 'LastName';
            ebizchargeServicemodelSoap.GetCustomerResponse_element ebz = new ebizchargeServicemodelSoap.GetCustomerResponse_element();
            ebz.GetCustomerResult = GetCustomerResult;
            Map < String, ebizchargeServicemodelSoap.GetCustomerResponse_element > response_map_x = new Map < String, ebizchargeServicemodelSoap.GetCustomerResponse_element > ();
            response_map_x.put('data', ebz);
            response.put('response_x', response_map_x);
        }
        if (request instanceof ebizchargeServicemodelSoap.SalesOrder) {
            ebizchargeServicemodelSoap.SalesOrder order = new ebizchargeServicemodelSoap.SalesOrder();
            order.MerchantId = '2234';
            order.SubCustomerId = '232342423sdfsd';
            order.SalesOrderNumber = '232223';
            order.SalesOrderInternalId = '23423423';
            order.Date_x = '12-12-2002';
            order.Currency_x = 'doller';
            order.Amount = 23;
            order.DueDate = '12-12-2002';
            order.AmountDue = 23323;
            order.PoNum = '23323';
            order.DivisionId = '23323';
            order.TypeId = '23323';
            order.TypeId = '23323';
            ebizchargeServicemodelSoap.GetSalesOrderResponse_element salesElement = new ebizchargeServicemodelSoap.GetSalesOrderResponse_element();
            salesElement.GetSalesOrderResult = order;
            Map < String, ebizchargeServicemodelSoap.GetSalesOrderResponse_element > response_map_x = new Map < String, ebizchargeServicemodelSoap.GetSalesOrderResponse_element > ();
            response_map_x.put('order', salesElement);
            response.put('response_x', response_map_x);
        }
        if (request instanceof ebizchargeServicemodelSoap.SalesOrderResponse) {
            ebizchargeServicemodelSoap.SalesOrderResponse SalesOrder = new ebizchargeServicemodelSoap.SalesOrderResponse();
            SalesOrder.SalesOrderNumber = '232223';
            SalesOrder.SalesOrderInternalId = '232223';
            SalesOrder.Status = 'success';
            SalesOrder.StatusCode = 200;
            ebizchargeServicemodelSoap.AddSalesOrderResponse_element ResponseElement = new ebizchargeServicemodelSoap.AddSalesOrderResponse_element();
            ResponseElement.AddSalesOrderResult = SalesOrder;
            Map < String, ebizchargeServicemodelSoap.AddSalesOrderResponse_element > response_map_x = new Map < String, ebizchargeServicemodelSoap.AddSalesOrderResponse_element > ();
            response_map_x.put('SalesOrder', ResponseElement);
            response.put('response_x', response_map_x);
        }
        if (request instanceof ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile) {
            ebizchargeServicemodelSoap.PaymentMethodProfile pp = new ebizchargeServicemodelSoap.PaymentMethodProfile();
            pp.MethodType = '1';
            pp.MethodID = '1';
            pp.MethodName = 'test';
            pp.SecondarySort = 'test';
            pp.Account = 'test';
            pp.AccountHolderName = 'test';
            ebizchargeServicemodelSoap.PaymentMethodProfile[] ProfileArray = new ebizchargeServicemodelSoap.PaymentMethodProfile[] {};
            ProfileArray.add(pp);
            ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile MethodProfile = new ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile();
            MethodProfile.PaymentMethodProfile = ProfileArray;
            ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfilesResponse_element element = new ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfilesResponse_element();
            element.GetCustomerPaymentMethodProfilesResult = MethodProfile;
            Map < String, ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfilesResponse_element > response_map_x = new Map < String, ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfilesResponse_element > ();
            response.put('response_x', response_map_x);
        }
        if (request instanceof ebizchargeServicemodelSoap.GetCustomerToken_element) {
            ebizchargeServicemodelSoap.GetCustomerTokenResponse_element tokken = new ebizchargeServicemodelSoap.GetCustomerTokenResponse_element();
            tokken.GetCustomerTokenResult = '2342332423e32';
            ebizchargeServicemodelSoap.GetCustomerTokenResponse_element response_map_x = new ebizchargeServicemodelSoap.GetCustomerTokenResponse_element();
            response_map_x.GetCustomerTokenResult = '23432423423423';
            response.put('response_x', response_map_x);
        }
        if (request instanceof ebizchargeServicemodelSoap.TransactionResponse) {
            ebizchargeServicemodelSoap.TransactionResponse res = new ebizchargeServicemodelSoap.TransactionResponse();
            res.ResultCode = 'A';
            res.RemainingBalance = 0.00;
            res.RefNum = '000';
            res.ProfilerReason = 'test';
            res.VpasResultCode = '1';
            ebizchargeServicemodelSoap.runTransactionResponse_element element = new ebizchargeServicemodelSoap.runTransactionResponse_element();
            element.runTransactionResult = res;
            Map < String, ebizchargeServicemodelSoap.runTransactionResponse_element > response_map_x = new Map < String, ebizchargeServicemodelSoap.runTransactionResponse_element > ();
            response_map_x.put('res', element);
            response.put('response_x', response_map_x);
        }
        if (request instanceof ebizchargeServicemodelSoap.eBizService) {
            ebizchargeServicemodelSoap.AddInvoiceResponse_element element = new ebizchargeServicemodelSoap.AddInvoiceResponse_element();
            element.AddInvoiceResult = null;
            ebizchargeServicemodelSoap.AddCustomerPaymentMethodProfileResponse_element response_x = new ebizchargeServicemodelSoap.AddCustomerPaymentMethodProfileResponse_element();
            response_x.AddCustomerPaymentMethodProfileResult = 'test';
            Map < String, ebizchargeServicemodelSoap.AddCustomerPaymentMethodProfileResponse_element > response_map_x = new Map < String, ebizchargeServicemodelSoap.AddCustomerPaymentMethodProfileResponse_element > ();
            response_map_x.put('response_x', response_x);
            response_x = response_map_x.get('response_x');
        }
        if (request instanceof ebizchargeServicemodelSoap.ArrayOfRecurringBillingDetails) {
            ebizchargeServicemodelSoap.RecurringBillingDetails[] bills = new ebizchargeServicemodelSoap.RecurringBillingDetails[] {};
            ebizchargeServicemodelSoap.RecurringBillingDetails Bill = new ebizchargeServicemodelSoap.RecurringBillingDetails();
            Bill.ScheduledPaymentInternalId = 'test';
            Bill.CustomerInternalId = 'test';
            Bill.CustomerId = 'test';
            Bill.Amount = 0.00;
            Bill.Tax = 0.00;
            Bill.Enabled = true;
            Bill.NumLeft = '2';
            bills.add(Bill);
            ebizchargeServicemodelSoap.SearchScheduledRecurringPaymentsResponse_element response_x;
            ebizchargeServicemodelSoap.ArrayOfRecurringBillingDetails SearchScheduledRecurringPaymentsResult = new ebizchargeServicemodelSoap.ArrayOfRecurringBillingDetails();
            SearchScheduledRecurringPaymentsResult.RecurringBillingDetails = bills;
            ebizchargeServicemodelSoap.SearchScheduledRecurringPaymentsResponse_element element = new ebizchargeServicemodelSoap.SearchScheduledRecurringPaymentsResponse_element();
            element.SearchScheduledRecurringPaymentsResult = SearchScheduledRecurringPaymentsResult;
            Map < String, ebizchargeServicemodelSoap.SearchScheduledRecurringPaymentsResponse_element > response_map_x = new Map < String, ebizchargeServicemodelSoap.SearchScheduledRecurringPaymentsResponse_element > ();
            response_map_x.put('response_x', element);
            response_x = response_map_x.get('response_x');
        }
        if (request instanceof ebizchargeServicemodelSoap.SearchRecurringPayments_element) {
            system.debug('SearchRecurringPayments_element');
            ebizchargeServicemodelSoap.Payment[] payments = new ebizchargeServicemodelSoap.Payment[] {};
            ebizchargeServicemodelSoap.Payment p = new ebizchargeServicemodelSoap.Payment();
            p.CustomerId = '00100003HnnmuZZ';
            p.DatePaid = '1T4';
            payments.add(p);
            ebizchargeServicemodelSoap.ArrayOfPayment ap = new ebizchargeServicemodelSoap.ArrayOfPayment();
            ap.Payment = payments;
            ebizchargeServicemodelSoap.SearchRecurringPaymentsResponse_element element = new ebizchargeServicemodelSoap.SearchRecurringPaymentsResponse_element();
            element.SearchRecurringPaymentsResult = ap;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfiles_element) {
            ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile gr = new ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile();
            ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfilesResponse_element element = new ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfilesResponse_element();
            element.GetCustomerPaymentMethodProfilesResult = gr;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.AddCustomerPaymentMethodProfile_element) {
            ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile gr = new ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile();
            ebizchargeServicemodelSoap.AddCustomerPaymentMethodProfileResponse_element element = new ebizchargeServicemodelSoap.AddCustomerPaymentMethodProfileResponse_element();
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.GetTransactionDetails_element) {
            ebizchargeServicemodelSoap.TransactionObject rr = new ebizchargeServicemodelSoap.TransactionObject();
            rr.DateTime_x = string.valueOf(datetime.now());
            ebizchargeServicemodelSoap.TransactionResponse res = new ebizchargeServicemodelSoap.TransactionResponse();
            res.ResultCode = 'sfd';
            res.Result = 'test';
            res.ErrorCode = 'test';
            res.Error = 'test';
            res.CardCodeResultCode = 'test';
            res.CardCodeResult = 'test';
            res.BatchRefNum = 'test';
            res.BatchNum = 'test';
            res.AvsResultCode = 'test';
            res.AvsResult = 'test';
            res.AuthCode = 'test';
            res.AuthAmount = 2;
            res.Status = 'test';
            res.StatusCode = 'test';
            rr.response = res;
            ebizchargeServicemodelSoap.TransactionDetail d = new ebizchargeServicemodelSoap.TransactionDetail();
            d.NonTax = true;
            rr.Details = d;
            ebizchargeServicemodelSoap.CreditCardData cc = new ebizchargeServicemodelSoap.CreditCardData();
            rr.CreditCardData = cc;
            ebizchargeServicemodelSoap.GetTransactionDetailsResponse_element element = new ebizchargeServicemodelSoap.GetTransactionDetailsResponse_element();
            element.GetTransactionDetailsResult = rr;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.runTransaction_element) {
            system.debug('Mock >> runTransaction_element');
            ebizchargeServicemodelSoap.TransactionResponse objTest = new ebizchargeServicemodelSoap.TransactionResponse();
            objTest.ResultCode = 'A';
            objTest.AvsResultCode = 'YYY';
            objTest.AvsResult = 'T1&T2';
            objTest.RefNum = 'RefNo';
            objTest.ErrorCode = '0';
            ebizchargeServicemodelSoap.runTransactionResponse_element element = new ebizchargeServicemodelSoap.runTransactionResponse_element();
            element.runTransactionResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.runCustomerTransaction_element) {
            system.debug('Mock >> runCustomerTransaction_element');
            ebizchargeServicemodelSoap.TransactionResponse objTest = new ebizchargeServicemodelSoap.TransactionResponse();
            ebizchargeServicemodelSoap.runCustomerTransactionResponse_element element = new ebizchargeServicemodelSoap.runCustomerTransactionResponse_element();
            element.runCustomerTransactionResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.GetSalesOrder_element) {
            ebizchargeServicemodelSoap.SalesOrder objTest = new ebizchargeServicemodelSoap.SalesOrder();
            ebizchargeServicemodelSoap.GetSalesOrderResponse_element element = new ebizchargeServicemodelSoap.GetSalesOrderResponse_element();
            element.GetSalesOrderResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.SearchSalesOrders_element) {
            ebizchargeServicemodelSoap.ArrayOfSalesOrder objTest = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
            ebizchargeServicemodelSoap.SearchSalesOrdersResponse_element element = new ebizchargeServicemodelSoap.SearchSalesOrdersResponse_element();
            element.SearchSalesOrdersResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.GetPaymentsCount_element) {
            ebizchargeServicemodelSoap.GetPaymentsCountResponse_element element = new ebizchargeServicemodelSoap.GetPaymentsCountResponse_element();
            element.GetPaymentsCountResult = 1;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.GetMerchantData_element) {
            ebizchargeServicemodelSoap.MerchantData objTest = new ebizchargeServicemodelSoap.MerchantData();
            ebizchargeServicemodelSoap.GetMerchantDataResponse_element element = new ebizchargeServicemodelSoap.GetMerchantDataResponse_element();
            element.GetMerchantDataResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.ScheduleRecurringPayment_element) {
            ebizchargeServicemodelSoap.ScheduleRecurringPaymentResponse_element element = new ebizchargeServicemodelSoap.ScheduleRecurringPaymentResponse_element();
            element.ScheduleRecurringPaymentResult = 'objTest';
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.UploadAttachment_element) {
            ebizchargeServicemodelSoap.UploadAttachmentResponse objTest = new ebizchargeServicemodelSoap.UploadAttachmentResponse();
            ebizchargeServicemodelSoap.UploadAttachmentResponse_element element = new ebizchargeServicemodelSoap.UploadAttachmentResponse_element();
            element.UploadAttachmentResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfile_element) {
            system.debug('Mock >> GetCustomerPaymentMethodProfile_element');
            ebizchargeServicemodelSoap.PaymentMethodProfile objTest = new ebizchargeServicemodelSoap.PaymentMethodProfile();
            ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfileResponse_element element = new ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfileResponse_element();
            element.GetCustomerPaymentMethodProfileResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.ResendEbizWebFormEmail_element) {
            ebizchargeServicemodelSoap.ResendEbizWebFormEmailResponse_element element = new ebizchargeServicemodelSoap.ResendEbizWebFormEmailResponse_element();
            element.ResendEbizWebFormEmailResult = 'objTest';
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.MarkRecurringPaymentAsApplied_element) {
            ebizchargeServicemodelSoap.PaymentResponse objTest = new ebizchargeServicemodelSoap.PaymentResponse();
            ebizchargeServicemodelSoap.MarkRecurringPaymentAsAppliedResponse_element element = new ebizchargeServicemodelSoap.MarkRecurringPaymentAsAppliedResponse_element();
            element.MarkRecurringPaymentAsAppliedResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.SearchPaymentFormReceivedPayments_element) {
            ebizchargeServicemodelSoap.ArrayOfPayment objTest = new ebizchargeServicemodelSoap.ArrayOfPayment();
            ebizchargeServicemodelSoap.SearchPaymentFormReceivedPaymentsResponse_element element = new ebizchargeServicemodelSoap.SearchPaymentFormReceivedPaymentsResponse_element();
            element.SearchPaymentFormReceivedPaymentsResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.AddCustomer_element) {
            ebizchargeServicemodelSoap.CustomerResponse objTest = new ebizchargeServicemodelSoap.CustomerResponse();
            ebizchargeServicemodelSoap.AddCustomerResponse_element element = new ebizchargeServicemodelSoap.AddCustomerResponse_element();
            element.AddCustomerResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.UpdateTerms_element) {
            ebizchargeServicemodelSoap.TermsResponse objTest = new ebizchargeServicemodelSoap.TermsResponse();
            ebizchargeServicemodelSoap.UpdateTermsResponse_element element = new ebizchargeServicemodelSoap.UpdateTermsResponse_element();
            element.UpdateTermsResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.DeleteCustomerPaymentMethodProfile_element) {
            ebizchargeServicemodelSoap.DeleteCustomerPaymentMethodProfileResponse_element element = new ebizchargeServicemodelSoap.DeleteCustomerPaymentMethodProfileResponse_element();
            element.DeleteCustomerPaymentMethodProfileResult = true;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.AddInvoice_element) {
            ebizchargeServicemodelSoap.InvoiceResponse objTest = new ebizchargeServicemodelSoap.InvoiceResponse();
            ebizchargeServicemodelSoap.AddInvoiceResponse_element element = new ebizchargeServicemodelSoap.AddInvoiceResponse_element();
            element.AddInvoiceResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.AddItem_element) {
            ebizchargeServicemodelSoap.ItemDetailsResponse objTest = new ebizchargeServicemodelSoap.ItemDetailsResponse();
            ebizchargeServicemodelSoap.AddItemResponse_element element = new ebizchargeServicemodelSoap.AddItemResponse_element();
            element.AddItemResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.AddTerms_element) {
            ebizchargeServicemodelSoap.TermsResponse objTest = new ebizchargeServicemodelSoap.TermsResponse();
            ebizchargeServicemodelSoap.AddTermsResponse_element element = new ebizchargeServicemodelSoap.AddTermsResponse_element();
            element.AddTermsResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.GetGWCustomer_element) {
            ebizchargeServicemodelSoap.Customer objTest = new ebizchargeServicemodelSoap.Customer();
            ebizchargeServicemodelSoap.GetGWCustomerResponse_element element = new ebizchargeServicemodelSoap.GetGWCustomerResponse_element();
            element.GetGWCustomerResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.SearchInvoices_element) {
            ebizchargeServicemodelSoap.ArrayOfInvoice objTest = new ebizchargeServicemodelSoap.ArrayOfInvoice();
            ebizchargeServicemodelSoap.SearchInvoicesResponse_element element = new ebizchargeServicemodelSoap.SearchInvoicesResponse_element();
            element.SearchInvoicesResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.AddApplicationTransaction_element) {
            ebizchargeServicemodelSoap.ApplicationTransactionResponse objTest = new ebizchargeServicemodelSoap.ApplicationTransactionResponse();
            ebizchargeServicemodelSoap.AddApplicationTransactionResponse_element element = new ebizchargeServicemodelSoap.AddApplicationTransactionResponse_element();
            element.AddApplicationTransactionResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.UpdateCustomerPaymentMethodProfile_element) {
            ebizchargeServicemodelSoap.UpdateCustomerPaymentMethodProfileResponse_element element = new ebizchargeServicemodelSoap.UpdateCustomerPaymentMethodProfileResponse_element();
            element.UpdateCustomerPaymentMethodProfileResult = true;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.SearchTransactions_element) {
            ebizchargeServicemodelSoap.TransactionSearchResult objTest = new ebizchargeServicemodelSoap.TransactionSearchResult();
            ebizchargeServicemodelSoap.ArrayOfTransactionObject objTransactions = new ebizchargeServicemodelSoap.ArrayOfTransactionObject();
            objTest.Transactions = objTransactions;
            ebizchargeServicemodelSoap.TransactionObject[] TransactionObjectList = new ebizchargeServicemodelSoap.TransactionObject[] {};
            objTransactions.TransactionObject = TransactionObjectList;
            ebizchargeServicemodelSoap.TransactionObject objTO = new ebizchargeServicemodelSoap.TransactionObject();
            objTO.DateTime_x = string.valueOf(datetime.now());
            objTO.Source = 'Salesforce';
            objTO.CustomerID = 'CustomerID';
            ebizchargeServicemodelSoap.TransactionDetail objDetails = new ebizchargeServicemodelSoap.TransactionDetail();
            objDetails.Invoice = 'str';
            objTO.Details = objDetails;
            ebizchargeServicemodelSoap.TransactionResponse res = new ebizchargeServicemodelSoap.TransactionResponse();
            objTO.Response = res;
            ebizchargeServicemodelSoap.CreditCardData cc = new ebizchargeServicemodelSoap.CreditCardData();
            objTO.CreditCardData = cc;
            ebizchargeServicemodelSoap.CheckData chekData = new ebizchargeServicemodelSoap.CheckData();
            objTO.CheckData = chekData;
            TransactionObjectList.add(objTO);
            ebizchargeServicemodelSoap.SearchTransactionsResponse_element element = new ebizchargeServicemodelSoap.SearchTransactionsResponse_element();
            element.SearchTransactionsResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatus_element) {
            ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatusResponse objTest = new ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatusResponse();
            ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatusResponse_element element = new ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatusResponse_element();
            element.ModifyScheduledRecurringPaymentStatusResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.GetReceiptsList_element) {
            ebizchargeServicemodelSoap.ArrayOfReceipt objTest = new ebizchargeServicemodelSoap.ArrayOfReceipt();
            ebizchargeServicemodelSoap.Receipt receipt = new ebizchargeServicemodelSoap.Receipt();
            objTest.Receipt = new ebizchargeServicemodelSoap.Receipt[] {};
            objTest.Receipt.add(receipt);
            ebizchargeServicemodelSoap.GetReceiptsListResponse_element element = new ebizchargeServicemodelSoap.GetReceiptsListResponse_element();
            element.GetReceiptsListResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.EmailReceipt_element) {
            ebizchargeServicemodelSoap.EmailReceiptResponse objTest = new ebizchargeServicemodelSoap.EmailReceiptResponse();
            ebizchargeServicemodelSoap.EmailReceiptResponse_element element = new ebizchargeServicemodelSoap.EmailReceiptResponse_element();
            element.EmailReceiptResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.SearchEbizWebFormPendingPayments_element) {
            ebizchargeServicemodelSoap.ArrayOfPayment objTest = new ebizchargeServicemodelSoap.ArrayOfPayment();
            ebizchargeServicemodelSoap.SearchEbizWebFormPendingPaymentsResponse_element element = new ebizchargeServicemodelSoap.SearchEbizWebFormPendingPaymentsResponse_element();
            element.SearchEbizWebFormPendingPaymentsResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.DeleteEbizWebFormPayment_element) {
            ebizchargeServicemodelSoap.PaymentResponse objTest = new ebizchargeServicemodelSoap.PaymentResponse();
            ebizchargeServicemodelSoap.DeleteEbizWebFormPaymentResponse_element element = new ebizchargeServicemodelSoap.DeleteEbizWebFormPaymentResponse_element();
            element.DeleteEbizWebFormPaymentResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.MarkEbizWebFormPaymentAsApplied_element) {
            ebizchargeServicemodelSoap.PaymentResponse objTest = new ebizchargeServicemodelSoap.PaymentResponse();
            ebizchargeServicemodelSoap.MarkEbizWebFormPaymentAsAppliedResponse_element element = new ebizchargeServicemodelSoap.MarkEbizWebFormPaymentAsAppliedResponse_element();
            element.MarkEbizWebFormPaymentAsAppliedResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.GetMerchantTransactionData_element) {
            ebizchargeServicemodelSoap.MerchantTransactionData objTest = new ebizchargeServicemodelSoap.MerchantTransactionData();
            objTest.TaxPercentage = 12;
            ebizchargeServicemodelSoap.GetMerchantTransactionDataResponse_element element = new ebizchargeServicemodelSoap.GetMerchantTransactionDataResponse_element();
            element.GetMerchantTransactionDataResult = objTest;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.SearchScheduledRecurringPayments_element) {
            ebizchargeServicemodelSoap.ArrayOfRecurringBillingDetails SearchScheduledRecurringPaymentsResult = new ebizchargeServicemodelSoap.ArrayOfRecurringBillingDetails();
            ebizchargeServicemodelSoap.SearchScheduledRecurringPaymentsResponse_element element = new ebizchargeServicemodelSoap.SearchScheduledRecurringPaymentsResponse_element();
            element.SearchScheduledRecurringPaymentsResult = SearchScheduledRecurringPaymentsResult;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.GetApplicationData_element) {
            ebizchargeServicemodelSoap.ApplicationData GetApplicationDataResult = new ebizchargeServicemodelSoap.ApplicationData();
            GetApplicationDataResult.Base64ParametersString = '12';
            ebizchargeServicemodelSoap.GetApplicationDataResponse_element element = new ebizchargeServicemodelSoap.GetApplicationDataResponse_element();
            element.GetApplicationDataResult = GetApplicationDataResult;
            response.put('response_x', element);
        }
        if (request instanceof ebizchargeServicemodelSoap.SearchCustomerList_element) {
            Schema.DescribeSObjectResult r = Account.sObjectType.getDescribe();
            String keyPrefix = r.getKeyPrefix();
            ebizchargeServicemodelSoap.Customer con = new ebizchargeServicemodelSoap.Customer();
            list < ebizchargeServicemodelSoap.Customer > CustomerList = new list < ebizchargeServicemodelSoap.Customer > ();
            ebizchargeServicemodelSoap.ArrayOfCustomer arrofResponse = new ebizchargeServicemodelSoap.ArrayOfCustomer();
            ebizchargeServicemodelSoap.CustomerListSearchResult custResultResponse = new ebizchargeServicemodelSoap.CustomerListSearchResult();
            ebizchargeServicemodelSoap.SearchCustomerListResponse_element element = new ebizchargeServicemodelSoap.SearchCustomerListResponse_element();
            con.CustomerInternalId = '123456789';
            con.CustomerId = keyPrefix + 'F00001GLIrjQAH0';
            CustomerList.add(con);
            arrofResponse.Customer = CustomerList;
            custResultResponse.CustomerList = arrofResponse;
            custResultResponse.Count = 1;
            element.SearchCustomerListResult = custResultResponse;
            response.put('response_x', element);
        }
    }
}