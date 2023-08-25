@isTest
public class test_ebizchargeServicemodelSoap {
    @isTest(OnInstall = true)
    static void testMethod1() {
        Integer len = 10; //fake id
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        String reg = key.substring(0, len);
        EBizcharge_Setting__c ES = new EBizcharge_Setting__c();
        ES.Security_Token__c = reg;
        ES.User_Name__c = 'test-1';
        ES.Password__c = '123';
        ES.Transaction_Filter_By__c = 'Today ';
        ES.Email_Pending_Req_Filter_By__c = 'Today ';
        ES.Sync_Orders_Filter_By__c = 'Today';
        ES.Sync_Accounts_Filter_By__c = 'Today';
        ES.Sync_Products_Filter_By__c = 'Today';
        ES.Tax_Action__c = 'Today';
        ES.Tax_Calculate_By__c = 'Auto';
        ES.Tax_Manual_Type__c = 'Use Percent';
        ES.Tax_Default_Percent__c = 1;
        ES.Component_Label__c = 'test';
        ES.Tax_Action__c = 'Tax Included';
        system.assertEquals('test-1', ES.User_Name__c);
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        if (true) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
            mock.setStaticResource('Test_WS');
            mock.setStatusCode(200);
            Test.setMock(HttpCalloutMock.class, mock);
            String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
            User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = uniqueUserName);
            String uniqueUserName1 = 'standarduser1' + DateTime.now().getTime() + '@testorg.com';
            User u1 = new User(Alias = 'standt', Email = 'standarduser@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = uniqueUserName1);
            system.runAs(u1) {
                ebizchargeServicemodelSoap.eBizService MockeBizService = new ebizchargeServicemodelSoap.eBizService();
            }
            System.runAs(u) {
                test.startTest();
                ebizchargeServicemodelSoap.CustomSalesOrder SO = new ebizchargeServicemodelSoap.CustomSalesOrder();
                ebizchargeServicemodelSoap.ArrayOfCustomItem ArrCustItem = new ebizchargeServicemodelSoap.ArrayOfCustomItem();
                ebizchargeServicemodelSoap.CustomItem CustItem = new ebizchargeServicemodelSoap.CustomItem();
                ebizchargeServicemodelSoap.Customer Customer = new ebizchargeServicemodelSoap.Customer();
                ebizchargeServicemodelSoap.SearchPaymentFormPendingPaymentsResponse_element SearchPaymentFormPendingPaymentsResponse_element = new ebizchargeServicemodelSoap.SearchPaymentFormPendingPaymentsResponse_element();
                ebizchargeServicemodelSoap.ModifyScheduledRecurringPayment_RecurringBilling_element ModifyScheduledRecurringPayment_RecurringBilling_element = new ebizchargeServicemodelSoap.ModifyScheduledRecurringPayment_RecurringBilling_element();
                ebizchargeServicemodelSoap.UpdateMerchantDataResponse_element UpdateMerchantDataResponse_element = new ebizchargeServicemodelSoap.UpdateMerchantDataResponse_element();
                ebizchargeServicemodelSoap.SearchCustomerList_element SearchCustomerList_element = new ebizchargeServicemodelSoap.SearchCustomerList_element();
                ebizchargeServicemodelSoap.SearchItems_element SearchItems_element = new ebizchargeServicemodelSoap.SearchItems_element();
                ebizchargeServicemodelSoap.AddSalesOrder_element AddSalesOrder_element = new ebizchargeServicemodelSoap.AddSalesOrder_element();
                ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile ArrayOfPaymentMethodProfile = new ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfile();
                ebizchargeServicemodelSoap.UpdateApplicationDataResponse_element UpdateApplicationDataResponse_element = new ebizchargeServicemodelSoap.UpdateApplicationDataResponse_element();
                ebizchargeServicemodelSoap.SearchCustomersResponse_element SearchCustomersResponse_element = new ebizchargeServicemodelSoap.SearchCustomersResponse_element();
                ebizchargeServicemodelSoap.EPaymentForm EPaymentForm = new ebizchargeServicemodelSoap.EPaymentForm();
                ebizchargeServicemodelSoap.DeleteEbizWebFormPayment_element DeleteEbizWebFormPayment_element = new ebizchargeServicemodelSoap.DeleteEbizWebFormPayment_element();
                ebizchargeServicemodelSoap.GetEmailTemplates_element GetEmailTemplates_element = new ebizchargeServicemodelSoap.GetEmailTemplates_element();
                ebizchargeServicemodelSoap.GetReceiptsListResponse_element GetReceiptsListResponse_element = new ebizchargeServicemodelSoap.GetReceiptsListResponse_element();
                ebizchargeServicemodelSoap.UpdateMerchantData_element UpdateMerchantData_element = new ebizchargeServicemodelSoap.UpdateMerchantData_element();
                ebizchargeServicemodelSoap.ArrayOfInvoice ArrayOfInvoice = new ebizchargeServicemodelSoap.ArrayOfInvoice();
                ebizchargeServicemodelSoap.FieldValue FieldValue = new ebizchargeServicemodelSoap.FieldValue();
                ebizchargeServicemodelSoap.GetMerchantTransactionDataBySK_element GetMerchantTransactionDataBySK_element = new ebizchargeServicemodelSoap.GetMerchantTransactionDataBySK_element();
                ebizchargeServicemodelSoap.GetCustomerResponse_element GetCustomerResponse_element = new ebizchargeServicemodelSoap.GetCustomerResponse_element();
                ebizchargeServicemodelSoap.AddSubCustomer_element AddSubCustomer_element = new ebizchargeServicemodelSoap.AddSubCustomer_element();
                ebizchargeServicemodelSoap.SearchTransactions_element SearchTransactions_element = new ebizchargeServicemodelSoap.SearchTransactions_element();
                ebizchargeServicemodelSoap.AddApplicationDataResponse_element AddApplicationDataResponse_element = new ebizchargeServicemodelSoap.AddApplicationDataResponse_element();
                ebizchargeServicemodelSoap.GetSalesRepResponse_element GetSalesRepResponse_element = new ebizchargeServicemodelSoap.GetSalesRepResponse_element();
                ebizchargeServicemodelSoap.AddCustomerPaymentMethodProfileResponse_element AddCustomerPaymentMethodProfileResponse_element = new ebizchargeServicemodelSoap.AddCustomerPaymentMethodProfileResponse_element();
                ebizchargeServicemodelSoap.runCustomerTransactionResponse_element runCustomerTransactionResponse_element = new ebizchargeServicemodelSoap.runCustomerTransactionResponse_element();
                ebizchargeServicemodelSoap.UpdateApplicationData_element UpdateApplicationData_element = new ebizchargeServicemodelSoap.UpdateApplicationData_element();
                ebizchargeServicemodelSoap.BatchStatus BatchStatus = new ebizchargeServicemodelSoap.BatchStatus();
                ebizchargeServicemodelSoap.ArrayOfEbizCustomField ArrayOfEbizCustomField = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
                ebizchargeServicemodelSoap.ResendEbizWebFormEmail_element ResendEbizWebFormEmail_element = new ebizchargeServicemodelSoap.ResendEbizWebFormEmail_element();
                ebizchargeServicemodelSoap.UpdateTermsResponse_element UpdateTermsResponse_element = new ebizchargeServicemodelSoap.UpdateTermsResponse_element();
                ebizchargeServicemodelSoap.SearchInvoices_element SearchInvoices_element = new ebizchargeServicemodelSoap.SearchInvoices_element();
                ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatus_element ModifyScheduledRecurringPaymentStatus_element = new ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatus_element();
                ebizchargeServicemodelSoap.GetPaymentFormURLResponse_element GetPaymentFormURLResponse_element = new ebizchargeServicemodelSoap.GetPaymentFormURLResponse_element();
                ebizchargeServicemodelSoap.UpdateCustomerPaymentMethodProfileResponse_element UpdateCustomerPaymentMethodProfileResponse_element = new ebizchargeServicemodelSoap.UpdateCustomerPaymentMethodProfileResponse_element();
                ebizchargeServicemodelSoap.UpdateSalesRepResponse_element UpdateSalesRepResponse_element = new ebizchargeServicemodelSoap.UpdateSalesRepResponse_element();
                ebizchargeServicemodelSoap.GetTerms_element GetTerms_element = new ebizchargeServicemodelSoap.GetTerms_element();
                ebizchargeServicemodelSoap.GetBatchTransactions_element GetBatchTransactions_element = new ebizchargeServicemodelSoap.GetBatchTransactions_element();
                ebizchargeServicemodelSoap.UpdateUserData_element UpdateUserData_element = new ebizchargeServicemodelSoap.UpdateUserData_element();
                ebizchargeServicemodelSoap.GetUserDataResponse_element GetUserDataResponse_element = new ebizchargeServicemodelSoap.GetUserDataResponse_element();
                ebizchargeServicemodelSoap.MarkEbizWebFormPaymentAsApplied_element MarkEbizWebFormPaymentAsApplied_element = new ebizchargeServicemodelSoap.MarkEbizWebFormPaymentAsApplied_element();
                ebizchargeServicemodelSoap.ModifyScheduledRecurringPayment_PaymentMethodProfileResponse_element ModifyScheduledRecurringPayment_PaymentMethodProfileResponse_element = new ebizchargeServicemodelSoap.ModifyScheduledRecurringPayment_PaymentMethodProfileResponse_element();
                ebizchargeServicemodelSoap.DeleteEbizWebFormPaymentResponse_element DeleteEbizWebFormPaymentResponse_element = new ebizchargeServicemodelSoap.DeleteEbizWebFormPaymentResponse_element();
                ebizchargeServicemodelSoap.GetInvoice_element GetInvoice_element = new ebizchargeServicemodelSoap.GetInvoice_element();
                ebizchargeServicemodelSoap.PaymentMethodProfile PaymentMethodProfile = new ebizchargeServicemodelSoap.PaymentMethodProfile();
                ebizchargeServicemodelSoap.SearchRecurringPaymentsResponse_element SearchRecurringPaymentsResponse_element = new ebizchargeServicemodelSoap.SearchRecurringPaymentsResponse_element();
                ebizchargeServicemodelSoap.InvoiceResponse InvoiceResponse = new ebizchargeServicemodelSoap.InvoiceResponse();
                ebizchargeServicemodelSoap.UpdateItemResponse_element UpdateItemResponse_element = new ebizchargeServicemodelSoap.UpdateItemResponse_element();
                ebizchargeServicemodelSoap.GetMerchantDataResponse_element GetMerchantDataResponse_element = new ebizchargeServicemodelSoap.GetMerchantDataResponse_element();
                ebizchargeServicemodelSoap.runCustomerTransaction_element runCustomerTransaction_element = new ebizchargeServicemodelSoap.runCustomerTransaction_element();
                ebizchargeServicemodelSoap.AddCustomer_element AddCustomer_element = new ebizchargeServicemodelSoap.AddCustomer_element();
                ebizchargeServicemodelSoap.MerchantTransactionData MerchantTransactionData = new ebizchargeServicemodelSoap.MerchantTransactionData();
                ebizchargeServicemodelSoap.SearchTermsResponse_element SearchTermsResponse_element = new ebizchargeServicemodelSoap.SearchTermsResponse_element();
                ebizchargeServicemodelSoap.InvoicePaymentResponse InvoicePaymentResponse = new ebizchargeServicemodelSoap.InvoicePaymentResponse();
                ebizchargeServicemodelSoap.CheckTrace CheckTrace = new ebizchargeServicemodelSoap.CheckTrace();
                ebizchargeServicemodelSoap.ArrayOfRecurringBilling ArrayOfRecurringBilling = new ebizchargeServicemodelSoap.ArrayOfRecurringBilling();
                ebizchargeServicemodelSoap.CloseBatch_element CloseBatch_element = new ebizchargeServicemodelSoap.CloseBatch_element();
                ebizchargeServicemodelSoap.ApplicationDataResponse ApplicationDataResponse = new ebizchargeServicemodelSoap.ApplicationDataResponse();
                ebizchargeServicemodelSoap.AddTerms_element AddTerms_element = new ebizchargeServicemodelSoap.AddTerms_element();
                ebizchargeServicemodelSoap.AddPaymentResponse_element AddPaymentResponse_element = new ebizchargeServicemodelSoap.AddPaymentResponse_element();
                ebizchargeServicemodelSoap.AddUserData_element AddUserData_element = new ebizchargeServicemodelSoap.AddUserData_element();
                ebizchargeServicemodelSoap.GetMerchantTransactionDataBySKResponse_element GetMerchantTransactionDataBySKResponse_element = new ebizchargeServicemodelSoap.GetMerchantTransactionDataBySKResponse_element();
                ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatusResponse_element ModifyScheduledRecurringPaymentStatusResponse_element = new ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatusResponse_element();
                ebizchargeServicemodelSoap.LoginResponse_element LoginResponse_element = new ebizchargeServicemodelSoap.LoginResponse_element();
                ebizchargeServicemodelSoap.UpdateTerms_element UpdateTerms_element = new ebizchargeServicemodelSoap.UpdateTerms_element();
                ebizchargeServicemodelSoap.MerchantSettings MerchantSettings = new ebizchargeServicemodelSoap.MerchantSettings();
                ebizchargeServicemodelSoap.UpdateCustomerResponse_element UpdateCustomerResponse_element = new ebizchargeServicemodelSoap.UpdateCustomerResponse_element();
                ebizchargeServicemodelSoap.GetPaymentsByGatewayRefNum_element GetPaymentsByGatewayRefNum_element = new ebizchargeServicemodelSoap.GetPaymentsByGatewayRefNum_element();
                ebizchargeServicemodelSoap.ModifyScheduledRecurringPayment_RecurringBillingResponse_element ModifyScheduledRecurringPayment_RecurringBillingResponse_element = new ebizchargeServicemodelSoap.ModifyScheduledRecurringPayment_RecurringBillingResponse_element();
                ebizchargeServicemodelSoap.MarkEbizWebFormPaymentAsAppliedResponse_element MarkEbizWebFormPaymentAsAppliedResponse_element = new ebizchargeServicemodelSoap.MarkEbizWebFormPaymentAsAppliedResponse_element();
                ebizchargeServicemodelSoap.GetSalesOrder_element GetSalesOrder_element = new ebizchargeServicemodelSoap.GetSalesOrder_element();
                ebizchargeServicemodelSoap.GetMerchantTransactionData_element GetMerchantTransactionData_element = new ebizchargeServicemodelSoap.GetMerchantTransactionData_element();
                ebizchargeServicemodelSoap.TransactionObject TransactionObject = new ebizchargeServicemodelSoap.TransactionObject();
                ebizchargeServicemodelSoap.SearchBatches_element SearchBatches_element = new ebizchargeServicemodelSoap.SearchBatches_element();
                ebizchargeServicemodelSoap.GetTransactionDetails_element GetTransactionDetails_element = new ebizchargeServicemodelSoap.GetTransactionDetails_element();
                ebizchargeServicemodelSoap.InvoicePaymentDetails InvoicePaymentDetails = new ebizchargeServicemodelSoap.InvoicePaymentDetails();
                ebizchargeServicemodelSoap.AddCustomerPaymentMethodProfile_element AddCustomerPaymentMethodProfile_element = new ebizchargeServicemodelSoap.AddCustomerPaymentMethodProfile_element();
                ebizchargeServicemodelSoap.AddItemResponse_element AddItemResponse_element = new ebizchargeServicemodelSoap.AddItemResponse_element();
                ebizchargeServicemodelSoap.ArrayOfTerms ArrayOfTerms = new ebizchargeServicemodelSoap.ArrayOfTerms();
                ebizchargeServicemodelSoap.SearchSalesOrdersResponse_element SearchSalesOrdersResponse_element = new ebizchargeServicemodelSoap.SearchSalesOrdersResponse_element();
                ebizchargeServicemodelSoap.ArrayOfReceipt ArrayOfReceipt = new ebizchargeServicemodelSoap.ArrayOfReceipt();
                ebizchargeServicemodelSoap.MarkPaymentAsAppliedResponse_element MarkPaymentAsAppliedResponse_element = new ebizchargeServicemodelSoap.MarkPaymentAsAppliedResponse_element();
                ebizchargeServicemodelSoap.GetPaymentsByGatewayRefNumResponse_element GetPaymentsByGatewayRefNumResponse_element = new ebizchargeServicemodelSoap.GetPaymentsByGatewayRefNumResponse_element();
                ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentResponse ModifyScheduledRecurringPaymentResponse = new ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentResponse();
                ebizchargeServicemodelSoap.GetBatchTransactionsResponse_element GetBatchTransactionsResponse_element = new ebizchargeServicemodelSoap.GetBatchTransactionsResponse_element();
                ebizchargeServicemodelSoap.GetEbizWebFormURLResponse_element GetEbizWebFormURLResponse_element = new ebizchargeServicemodelSoap.GetEbizWebFormURLResponse_element();
                ebizchargeServicemodelSoap.AddInvoicePayment_element AddInvoicePayment_element = new ebizchargeServicemodelSoap.AddInvoicePayment_element();
                ebizchargeServicemodelSoap.UserSettings UserSettings = new ebizchargeServicemodelSoap.UserSettings();
                ebizchargeServicemodelSoap.GetInvoiceResponse_element GetInvoiceResponse_element = new ebizchargeServicemodelSoap.GetInvoiceResponse_element();
                ebizchargeServicemodelSoap.ResendPaymentFormEmail_element ResendPaymentFormEmail_element = new ebizchargeServicemodelSoap.ResendPaymentFormEmail_element();
                ebizchargeServicemodelSoap.ApplicationTransactionRequest ApplicationTransactionRequest = new ebizchargeServicemodelSoap.ApplicationTransactionRequest();
                ebizchargeServicemodelSoap.SubCustomerResponse SubCustomerResponse = new ebizchargeServicemodelSoap.SubCustomerResponse();
                ebizchargeServicemodelSoap.AuthenticateSK_element AuthenticateSK_element = new ebizchargeServicemodelSoap.AuthenticateSK_element();
                ebizchargeServicemodelSoap.GetInvoicePaymentsResponse_element GetInvoicePaymentsResponse_element = new ebizchargeServicemodelSoap.GetInvoicePaymentsResponse_element();
                ebizchargeServicemodelSoap.EmailTemplate EmailTemplate = new ebizchargeServicemodelSoap.EmailTemplate();
                ebizchargeServicemodelSoap.MarkPaymentAsApplied_element MarkPaymentAsApplied_element = new ebizchargeServicemodelSoap.MarkPaymentAsApplied_element();
                ebizchargeServicemodelSoap.ApplicationTransactionResponse ApplicationTransactionResponse = new ebizchargeServicemodelSoap.ApplicationTransactionResponse();
                ebizchargeServicemodelSoap.ArrayOfPayment ArrayOfPayment = new ebizchargeServicemodelSoap.ArrayOfPayment();
                ebizchargeServicemodelSoap.MarkRecurringPaymentAsApplied_element MarkRecurringPaymentAsApplied_element = new ebizchargeServicemodelSoap.MarkRecurringPaymentAsApplied_element();
                ebizchargeServicemodelSoap.CustomerResponse CustomerResponse = new ebizchargeServicemodelSoap.CustomerResponse();
                ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatusResponse ModifyScheduledRecurringPaymentStatusResponse = new ebizchargeServicemodelSoap.ModifyScheduledRecurringPaymentStatusResponse();
                ebizchargeServicemodelSoap.SearchRecurringPayments_element SearchRecurringPayments_element = new ebizchargeServicemodelSoap.SearchRecurringPayments_element();
                ebizchargeServicemodelSoap.ArrayOfFieldValue ArrayOfFieldValue = new ebizchargeServicemodelSoap.ArrayOfFieldValue();
                ebizchargeServicemodelSoap.GetApplicationDataResponse_element GetApplicationDataResponse_element = new ebizchargeServicemodelSoap.GetApplicationDataResponse_element();
                ebizchargeServicemodelSoap.AddApplicationTransaction_element AddApplicationTransaction_element = new ebizchargeServicemodelSoap.AddApplicationTransaction_element();
                ebizchargeServicemodelSoap.ApplicationData ApplicationData = new ebizchargeServicemodelSoap.ApplicationData();
                ebizchargeServicemodelSoap.SearchSalesReps_element SearchSalesReps_element = new ebizchargeServicemodelSoap.SearchSalesReps_element();
                ebizchargeServicemodelSoap.GetApplicationData_element GetApplicationData_element = new ebizchargeServicemodelSoap.GetApplicationData_element();
                ebizchargeServicemodelSoap.AddApplicationTransactionResponse_element AddApplicationTransactionResponse_element = new ebizchargeServicemodelSoap.AddApplicationTransactionResponse_element();
                ebizchargeServicemodelSoap.SearchPaymentFormReceivedPayments_element SearchPaymentFormReceivedPayments_element = new ebizchargeServicemodelSoap.SearchPaymentFormReceivedPayments_element();
                ebizchargeServicemodelSoap.SearchEbizWebFormPendingPayments_element SearchEbizWebFormPendingPayments_element = new ebizchargeServicemodelSoap.SearchEbizWebFormPendingPayments_element();
                ebizchargeServicemodelSoap.EmailReceiptResponse EmailReceiptResponse = new ebizchargeServicemodelSoap.EmailReceiptResponse();
                ebizchargeServicemodelSoap.PaymentResponse PaymentResponse = new ebizchargeServicemodelSoap.PaymentResponse();
                ebizchargeServicemodelSoap.GetMerchantTransactionDataResponse_element GetMerchantTransactionDataResponse_element = new ebizchargeServicemodelSoap.GetMerchantTransactionDataResponse_element();
                ebizchargeServicemodelSoap.UpdateCustomerPaymentMethodProfile_element UpdateCustomerPaymentMethodProfile_element = new ebizchargeServicemodelSoap.UpdateCustomerPaymentMethodProfile_element();
                ebizchargeServicemodelSoap.MarkInvoiceAsSynchronizedResponse_element MarkInvoiceAsSynchronizedResponse_element = new ebizchargeServicemodelSoap.MarkInvoiceAsSynchronizedResponse_element();
                ebizchargeServicemodelSoap.SearchScheduledRecurringPayments_element SearchScheduledRecurringPayments_element = new ebizchargeServicemodelSoap.SearchScheduledRecurringPayments_element();
                ebizchargeServicemodelSoap.AddUserDataResponse_element AddUserDataResponse_element = new ebizchargeServicemodelSoap.AddUserDataResponse_element();
                ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfiles_element GetCustomerPaymentMethodProfiles_element = new ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfiles_element();
                ebizchargeServicemodelSoap.TransactionDetail TransactionDetail = new ebizchargeServicemodelSoap.TransactionDetail();
                ebizchargeServicemodelSoap.CustomerListSearchResult CustomerListSearchResult = new ebizchargeServicemodelSoap.CustomerListSearchResult();
                ebizchargeServicemodelSoap.ArrayOfItemDetails ArrayOfItemDetails = new ebizchargeServicemodelSoap.ArrayOfItemDetails();
                ebizchargeServicemodelSoap.GetSalesRep_element GetSalesRep_element = new ebizchargeServicemodelSoap.GetSalesRep_element();
                ebizchargeServicemodelSoap.UpdateSalesRep_element UpdateSalesRep_element = new ebizchargeServicemodelSoap.UpdateSalesRep_element();
                ebizchargeServicemodelSoap.UpdateUserDataResponse_element UpdateUserDataResponse_element = new ebizchargeServicemodelSoap.UpdateUserDataResponse_element();
                ebizchargeServicemodelSoap.GetTermsResponse_element GetTermsResponse_element = new ebizchargeServicemodelSoap.GetTermsResponse_element();
                ebizchargeServicemodelSoap.EbizWebForm EbizWebForm = new ebizchargeServicemodelSoap.EbizWebForm();
                ebizchargeServicemodelSoap.GetReceiptsList_element GetReceiptsList_element = new ebizchargeServicemodelSoap.GetReceiptsList_element();
                ebizchargeServicemodelSoap.SearchEbizWebFormReceivedPayments_element SearchEbizWebFormReceivedPayments_element = new ebizchargeServicemodelSoap.SearchEbizWebFormReceivedPayments_element();
                ebizchargeServicemodelSoap.GetPaymentMethodProfileCountsResponse_element GetPaymentMethodProfileCountsResponse_element = new ebizchargeServicemodelSoap.GetPaymentMethodProfileCountsResponse_element();
                ebizchargeServicemodelSoap.ArrayOfUserData ArrayOfUserData = new ebizchargeServicemodelSoap.ArrayOfUserData();
                ebizchargeServicemodelSoap.CopyCustomer_element CopyCustomer_element = new ebizchargeServicemodelSoap.CopyCustomer_element();
                ebizchargeServicemodelSoap.GetScheduledDatesResponse GetScheduledDatesResponse = new ebizchargeServicemodelSoap.GetScheduledDatesResponse();
                ebizchargeServicemodelSoap.GetReportData_element GetReportData_element = new ebizchargeServicemodelSoap.GetReportData_element();
                ebizchargeServicemodelSoap.MarkCustomerAsInactive_element MarkCustomerAsInactive_element = new ebizchargeServicemodelSoap.MarkCustomerAsInactive_element();
                ebizchargeServicemodelSoap.PaymentMethodProfileCountsSearchResult PaymentMethodProfileCountsSearchResult = new ebizchargeServicemodelSoap.PaymentMethodProfileCountsSearchResult();
                ebizchargeServicemodelSoap.SearchUserList_element SearchUserList_element = new ebizchargeServicemodelSoap.SearchUserList_element();
                ebizchargeServicemodelSoap.Attachment Attachment = new ebizchargeServicemodelSoap.Attachment();
                ebizchargeServicemodelSoap.PaymentMethodProfileCounts PaymentMethodProfileCounts = new ebizchargeServicemodelSoap.PaymentMethodProfileCounts();
                ebizchargeServicemodelSoap.GetCardInfo_element GetCardInfo_element = new ebizchargeServicemodelSoap.GetCardInfo_element();
                ebizchargeServicemodelSoap.MarkCustomerAsSynchronizedResponse_element MarkCustomerAsSynchronizedResponse_element = new ebizchargeServicemodelSoap.MarkCustomerAsSynchronizedResponse_element();
                ebizchargeServicemodelSoap.CopyCustomerResponse_element CopyCustomerResponse_element = new ebizchargeServicemodelSoap.CopyCustomerResponse_element();
                ebizchargeServicemodelSoap.GetCardsExpirationList_element GetCardsExpirationList_element = new ebizchargeServicemodelSoap.GetCardsExpirationList_element();
                ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfileCounts ArrayOfPaymentMethodProfileCounts = new ebizchargeServicemodelSoap.ArrayOfPaymentMethodProfileCounts();
                ebizchargeServicemodelSoap.GetPaymentMethodProfileCounts_element GetPaymentMethodProfileCounts_element = new ebizchargeServicemodelSoap.GetPaymentMethodProfileCounts_element();
                ebizchargeServicemodelSoap.GetReportDataResponse_element GetReportDataResponse_element = new ebizchargeServicemodelSoap.GetReportDataResponse_element();
                ebizchargeServicemodelSoap.CardsExpirationListSearchResult CardsExpirationListSearchResult = new ebizchargeServicemodelSoap.CardsExpirationListSearchResult();
                ebizchargeServicemodelSoap.GetCardInfoResponse_element GetCardInfoResponse_element = new ebizchargeServicemodelSoap.GetCardInfoResponse_element();
                ebizchargeServicemodelSoap.GetZipCodeInfoResponse_element GetZipCodeInfoResponse_element = new ebizchargeServicemodelSoap.GetZipCodeInfoResponse_element();
                ebizchargeServicemodelSoap.GetScheduledDatesResponse_element GetScheduledDatesResponse_element = new ebizchargeServicemodelSoap.GetScheduledDatesResponse_element();
                ebizchargeServicemodelSoap.ArrayOfRecurringBillingDetails ArrayOfRecurringBillingDetails = new ebizchargeServicemodelSoap.ArrayOfRecurringBillingDetails();
                ebizchargeServicemodelSoap.GetScheduledDates_element GetScheduledDates_element = new ebizchargeServicemodelSoap.GetScheduledDates_element();
                ebizchargeServicemodelSoap.CardExpirationCounts CardExpirationCounts = new ebizchargeServicemodelSoap.CardExpirationCounts();
                ebizchargeServicemodelSoap.GetRecurringSchedulePreview_element GetRecurringSchedulePreview_element = new ebizchargeServicemodelSoap.GetRecurringSchedulePreview_element();
                ebizchargeServicemodelSoap.SearchUserListResponse_element SearchUserListResponse_element = new ebizchargeServicemodelSoap.SearchUserListResponse_element();
                ebizchargeServicemodelSoap.MarkCustomerAsSynchronized_element MarkCustomerAsSynchronized_element = new ebizchargeServicemodelSoap.MarkCustomerAsSynchronized_element();
                ebizchargeServicemodelSoap.ArrayOfCardExpirationCounts ArrayOfCardExpirationCounts = new ebizchargeServicemodelSoap.ArrayOfCardExpirationCounts();
                ebizchargeServicemodelSoap.GetRecurringSchedulePreviewResponse_element GetRecurringSchedulePreviewResponse_element = new ebizchargeServicemodelSoap.GetRecurringSchedulePreviewResponse_element();
                ebizchargeServicemodelSoap.UserListSearchResult UserListSearchResult = new ebizchargeServicemodelSoap.UserListSearchResult();
                ebizchargeServicemodelSoap.MarkCustomerAsInactiveResponse_element MarkCustomerAsInactiveResponse_element = new ebizchargeServicemodelSoap.MarkCustomerAsInactiveResponse_element();
                ebizchargeServicemodelSoap.GetCardsExpirationListResponse_element GetCardsExpirationListResponse_element = new ebizchargeServicemodelSoap.GetCardsExpirationListResponse_element();
                ebizchargeServicemodelSoap.ZipCodeData ZipCodeData = new ebizchargeServicemodelSoap.ZipCodeData();
                ebizchargeServicemodelSoap.GlobalBINData GlobalBINData = new ebizchargeServicemodelSoap.GlobalBINData();
                ebizchargeServicemodelSoap.GetReportDataResponse GetReportDataResponse = new ebizchargeServicemodelSoap.GetReportDataResponse();
                ebizchargeServicemodelSoap.GetZipCodeInfo_element GetZipCodeInfo_element = new ebizchargeServicemodelSoap.GetZipCodeInfo_element();
                ebizchargeServicemodelSoap.GetEmailTemplatesResponse_element GetEmailTemplatesResponse_element = new ebizchargeServicemodelSoap.GetEmailTemplatesResponse_element();
                ebizchargeServicemodelSoap.ArrayOfSearchFilter ArrayOfSearchFilter = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
                ebizchargeServicemodelSoap.AddSalesRep_element AddSalesRep_element = new ebizchargeServicemodelSoap.AddSalesRep_element();
                ebizchargeServicemodelSoap.AuthenticateSKResponse_element AuthenticateSKResponse_element = new ebizchargeServicemodelSoap.AuthenticateSKResponse_element();
                ebizchargeServicemodelSoap.GetBatchStatusResponse_element GetBatchStatusResponse_element = new ebizchargeServicemodelSoap.GetBatchStatusResponse_element();
                ebizchargeServicemodelSoap.ScheduleRecurringPaymentResponse_element ScheduleRecurringPaymentResponse_element = new ebizchargeServicemodelSoap.ScheduleRecurringPaymentResponse_element();
                ebizchargeServicemodelSoap.GetPaymentsCount_element GetPaymentsCount_element = new ebizchargeServicemodelSoap.GetPaymentsCount_element();
                ebizchargeServicemodelSoap.Invoice Invoice = new ebizchargeServicemodelSoap.Invoice();
                ebizchargeServicemodelSoap.Address Address = new ebizchargeServicemodelSoap.Address();
                ebizchargeServicemodelSoap.GetBatchStatus_element GetBatchStatus_element = new ebizchargeServicemodelSoap.GetBatchStatus_element();
                ebizchargeServicemodelSoap.ModifyScheduledRecurringPayment_PaymentMethodProfile_element ModifyScheduledRecurringPayment_PaymentMethodProfile_element = new ebizchargeServicemodelSoap.ModifyScheduledRecurringPayment_PaymentMethodProfile_element();
                ebizchargeServicemodelSoap.SearchApplicationTransactions_element SearchApplicationTransactions_element = new ebizchargeServicemodelSoap.SearchApplicationTransactions_element();
                ebizchargeServicemodelSoap.GetUserData_element GetUserData_element = new ebizchargeServicemodelSoap.GetUserData_element();
                ebizchargeServicemodelSoap.SearchBatchesResponse_element SearchBatchesResponse_element = new ebizchargeServicemodelSoap.SearchBatchesResponse_element();
                ebizchargeServicemodelSoap.GetGWCustomer_element GetGWCustomer_element = new ebizchargeServicemodelSoap.GetGWCustomer_element();
                ebizchargeServicemodelSoap.UpdateSalesOrder_element UpdateSalesOrder_element = new ebizchargeServicemodelSoap.UpdateSalesOrder_element();
                ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfile_element GetCustomerPaymentMethodProfile_element = new ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfile_element();
                ebizchargeServicemodelSoap.Item Item = new ebizchargeServicemodelSoap.Item();
                ebizchargeServicemodelSoap.GwRecurringBilling GwRecurringBilling = new ebizchargeServicemodelSoap.GwRecurringBilling();
                ebizchargeServicemodelSoap.TransactionSearchResult TransactionSearchResult = new ebizchargeServicemodelSoap.TransactionSearchResult();
                ebizchargeServicemodelSoap.UploadAttachment_element UploadAttachment_element = new ebizchargeServicemodelSoap.UploadAttachment_element();
                ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfilesResponse_element GetCustomerPaymentMethodProfilesResponse_element = new ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfilesResponse_element();
                ebizchargeServicemodelSoap.RenderReceiptResponse_element RenderReceiptResponse_element = new ebizchargeServicemodelSoap.RenderReceiptResponse_element();
                ebizchargeServicemodelSoap.MarkSalesOrderAsSynchronized_element MarkSalesOrderAsSynchronized_element = new ebizchargeServicemodelSoap.MarkSalesOrderAsSynchronized_element();
                ebizchargeServicemodelSoap.ArrayOfApplicationTransactionDetails ArrayOfApplicationTransactionDetails = new ebizchargeServicemodelSoap.ArrayOfApplicationTransactionDetails();
                ebizchargeServicemodelSoap.GetPaymentsCountResponse_element GetPaymentsCountResponse_element = new ebizchargeServicemodelSoap.GetPaymentsCountResponse_element();
                ebizchargeServicemodelSoap.UpdateInvoice_element UpdateInvoice_element = new ebizchargeServicemodelSoap.UpdateInvoice_element();
                ebizchargeServicemodelSoap.SearchEbizWebFormReceivedPaymentsResponse_element SearchEbizWebFormReceivedPaymentsResponse_element = new ebizchargeServicemodelSoap.SearchEbizWebFormReceivedPaymentsResponse_element();
                ebizchargeServicemodelSoap.GetCustomerToken_element GetCustomerToken_element = new ebizchargeServicemodelSoap.GetCustomerToken_element();
                ebizchargeServicemodelSoap.UploadAttachmentResponse_element UploadAttachmentResponse_element = new ebizchargeServicemodelSoap.UploadAttachmentResponse_element();
                ebizchargeServicemodelSoap.ArrayOfEmailTemplate ArrayOfEmailTemplate = new ebizchargeServicemodelSoap.ArrayOfEmailTemplate();
                ebizchargeServicemodelSoap.ArrayOfInvoicePaymentDetails ArrayOfInvoicePaymentDetails = new ebizchargeServicemodelSoap.ArrayOfInvoicePaymentDetails();
                ebizchargeServicemodelSoap.ResendPaymentFormEmailResponse_element ResendPaymentFormEmailResponse_element = new ebizchargeServicemodelSoap.ResendPaymentFormEmailResponse_element();
                ebizchargeServicemodelSoap.SearchApplicationTransactionsResponse_element SearchApplicationTransactionsResponse_element = new ebizchargeServicemodelSoap.SearchApplicationTransactionsResponse_element();
                ebizchargeServicemodelSoap.MerchantDataResponse MerchantDataResponse = new ebizchargeServicemodelSoap.MerchantDataResponse();
                ebizchargeServicemodelSoap.AddCustomerResponse_element AddCustomerResponse_element = new ebizchargeServicemodelSoap.AddCustomerResponse_element();
                ebizchargeServicemodelSoap.SearchTerms_element SearchTerms_element = new ebizchargeServicemodelSoap.SearchTerms_element();
                ebizchargeServicemodelSoap.UpdateInvoiceResponse_element UpdateInvoiceResponse_element = new ebizchargeServicemodelSoap.UpdateInvoiceResponse_element();
                ebizchargeServicemodelSoap.CloseBatchResponse_element CloseBatchResponse_element = new ebizchargeServicemodelSoap.CloseBatchResponse_element();
                ebizchargeServicemodelSoap.DeleteCustomerPaymentMethodProfileResponse_element DeleteCustomerPaymentMethodProfileResponse_element = new ebizchargeServicemodelSoap.DeleteCustomerPaymentMethodProfileResponse_element();
                ebizchargeServicemodelSoap.AddSalesRepResponse_element AddSalesRepResponse_element = new ebizchargeServicemodelSoap.AddSalesRepResponse_element();
                ebizchargeServicemodelSoap.AddSubCustomerResponse_element AddSubCustomerResponse_element = new ebizchargeServicemodelSoap.AddSubCustomerResponse_element();
                ebizchargeServicemodelSoap.runTransaction_element runTransaction_element = new ebizchargeServicemodelSoap.runTransaction_element();
                ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfileResponse_element GetCustomerPaymentMethodProfileResponse_element = new ebizchargeServicemodelSoap.GetCustomerPaymentMethodProfileResponse_element();
                ebizchargeServicemodelSoap.SearchTransactionsResponse_element SearchTransactionsResponse_element = new ebizchargeServicemodelSoap.SearchTransactionsResponse_element();
                ebizchargeServicemodelSoap.TermsResponse TermsResponse = new ebizchargeServicemodelSoap.TermsResponse();
                ebizchargeServicemodelSoap.SalesRepResponse SalesRepResponse = new ebizchargeServicemodelSoap.SalesRepResponse();
                ebizchargeServicemodelSoap.SearchFilter SearchFilter = new ebizchargeServicemodelSoap.SearchFilter();
                ebizchargeServicemodelSoap.SearchCustomerListResponse_element SearchCustomerListResponse_element = new ebizchargeServicemodelSoap.SearchCustomerListResponse_element();
                ebizchargeServicemodelSoap.EmailReceipt_element EmailReceipt_element = new ebizchargeServicemodelSoap.EmailReceipt_element();
                ebizchargeServicemodelSoap.RecurringBilling RecurringBilling = new ebizchargeServicemodelSoap.RecurringBilling();
                ebizchargeServicemodelSoap.TransactionResponse TransactionResponse = new ebizchargeServicemodelSoap.TransactionResponse();
                ebizchargeServicemodelSoap.GetMerchantData_element GetMerchantData_element = new ebizchargeServicemodelSoap.GetMerchantData_element();
                ebizchargeServicemodelSoap.CreditCardData CreditCardData = new ebizchargeServicemodelSoap.CreditCardData();
                ebizchargeServicemodelSoap.DeleteCustomerPaymentMethodProfile_element DeleteCustomerPaymentMethodProfile_element = new ebizchargeServicemodelSoap.DeleteCustomerPaymentMethodProfile_element();
                ebizchargeServicemodelSoap.ResendEbizWebFormEmailResponse_element ResendEbizWebFormEmailResponse_element = new ebizchargeServicemodelSoap.ResendEbizWebFormEmailResponse_element();
                ebizchargeServicemodelSoap.UpdateCustomer_element UpdateCustomer_element = new ebizchargeServicemodelSoap.UpdateCustomer_element();
                ebizchargeServicemodelSoap.AddInvoicePaymentResponse_element AddInvoicePaymentResponse_element = new ebizchargeServicemodelSoap.AddInvoicePaymentResponse_element();
                ebizchargeServicemodelSoap.SalesRep SalesRep = new ebizchargeServicemodelSoap.SalesRep();
                ebizchargeServicemodelSoap.SalesOrderResponse SalesOrderResponse = new ebizchargeServicemodelSoap.SalesOrderResponse();
                ebizchargeServicemodelSoap.MarkInvoiceAsSynchronized_element MarkInvoiceAsSynchronized_element = new ebizchargeServicemodelSoap.MarkInvoiceAsSynchronized_element();
                ebizchargeServicemodelSoap.TransactionLineItem TransactionLineItem = new ebizchargeServicemodelSoap.TransactionLineItem();
                ebizchargeServicemodelSoap.runTransactionResponse_element runTransactionResponse_element = new ebizchargeServicemodelSoap.runTransactionResponse_element();
                ebizchargeServicemodelSoap.ArrayOfTransactionLineItem ArrayOfTransactionLineItem = new ebizchargeServicemodelSoap.ArrayOfTransactionLineItem();
                ebizchargeServicemodelSoap.SetDefaultCustomerPaymentMethodProfile_element SetDefaultCustomerPaymentMethodProfile_element = new ebizchargeServicemodelSoap.SetDefaultCustomerPaymentMethodProfile_element();
                ebizchargeServicemodelSoap.ApplicationTransactionSearchResult ApplicationTransactionSearchResult = new ebizchargeServicemodelSoap.ApplicationTransactionSearchResult();
                ebizchargeServicemodelSoap.SecurityToken SecurityToken = new ebizchargeServicemodelSoap.SecurityToken();
                ebizchargeServicemodelSoap.MerchantData MerchantData = new ebizchargeServicemodelSoap.MerchantData();
                ebizchargeServicemodelSoap.SearchPaymentFormReceivedPaymentsResponse_element SearchPaymentFormReceivedPaymentsResponse_element = new ebizchargeServicemodelSoap.SearchPaymentFormReceivedPaymentsResponse_element();
                ebizchargeServicemodelSoap.ArrayOfSalesRep ArrayOfSalesRep = new ebizchargeServicemodelSoap.ArrayOfSalesRep();
                ebizchargeServicemodelSoap.GetCustomer_element GetCustomer_element = new ebizchargeServicemodelSoap.GetCustomer_element();
                ebizchargeServicemodelSoap.AddInvoice_element AddInvoice_element = new ebizchargeServicemodelSoap.AddInvoice_element();
                ebizchargeServicemodelSoap.SearchScheduledRecurringPaymentsResponse_element SearchScheduledRecurringPaymentsResponse_element = new ebizchargeServicemodelSoap.SearchScheduledRecurringPaymentsResponse_element();
                ebizchargeServicemodelSoap.MarkApplicationTransactionAsApplied_element MarkApplicationTransactionAsApplied_element = new ebizchargeServicemodelSoap.MarkApplicationTransactionAsApplied_element();
                ebizchargeServicemodelSoap.UpdateSubCustomerResponse_element UpdateSubCustomerResponse_element = new ebizchargeServicemodelSoap.UpdateSubCustomerResponse_element();
                ebizchargeServicemodelSoap.LoginResult LoginResult = new ebizchargeServicemodelSoap.LoginResult();
                ebizchargeServicemodelSoap.AddSalesOrderResponse_element AddSalesOrderResponse_element = new ebizchargeServicemodelSoap.AddSalesOrderResponse_element();
                ebizchargeServicemodelSoap.GetPaymentsResponse_element GetPaymentsResponse_element = new ebizchargeServicemodelSoap.GetPaymentsResponse_element();
                ebizchargeServicemodelSoap.ItemDetailsResponse ItemDetailsResponse = new ebizchargeServicemodelSoap.ItemDetailsResponse();
                ebizchargeServicemodelSoap.AddItem_element AddItem_element = new ebizchargeServicemodelSoap.AddItem_element();
                ebizchargeServicemodelSoap.ArrayOfTransactionObject ArrayOfTransactionObject = new ebizchargeServicemodelSoap.ArrayOfTransactionObject();
                ebizchargeServicemodelSoap.GetSubCustomer_element GetSubCustomer_element = new ebizchargeServicemodelSoap.GetSubCustomer_element();
                ebizchargeServicemodelSoap.UploadAttachmentResponse UploadAttachmentResponse = new ebizchargeServicemodelSoap.UploadAttachmentResponse();
                ebizchargeServicemodelSoap.GetTransactionDetailsResponse_element GetTransactionDetailsResponse_element = new ebizchargeServicemodelSoap.GetTransactionDetailsResponse_element();
                ebizchargeServicemodelSoap.CheckData CheckData = new ebizchargeServicemodelSoap.CheckData();
                ebizchargeServicemodelSoap.SalesOrder SalesOrder = new ebizchargeServicemodelSoap.SalesOrder();
                ebizchargeServicemodelSoap.SearchInvoicesResponse_element SearchInvoicesResponse_element = new ebizchargeServicemodelSoap.SearchInvoicesResponse_element();
                ebizchargeServicemodelSoap.ArrayOfSalesOrder ArrayOfSalesOrder = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
                ebizchargeServicemodelSoap.RecurringBillingDetails RecurringBillingDetails = new ebizchargeServicemodelSoap.RecurringBillingDetails();
                ebizchargeServicemodelSoap.MarkRecurringPaymentAsAppliedResponse_element MarkRecurringPaymentAsAppliedResponse_element = new ebizchargeServicemodelSoap.MarkRecurringPaymentAsAppliedResponse_element();
                ebizchargeServicemodelSoap.Receipt Receipt = new ebizchargeServicemodelSoap.Receipt();
                ebizchargeServicemodelSoap.GetGWCustomerResponse_element GetGWCustomerResponse_element = new ebizchargeServicemodelSoap.GetGWCustomerResponse_element();
                ebizchargeServicemodelSoap.ScheduleRecurringPayment_element ScheduleRecurringPayment_element = new ebizchargeServicemodelSoap.ScheduleRecurringPayment_element();
                ebizchargeServicemodelSoap.Terms Terms = new ebizchargeServicemodelSoap.Terms();
                ebizchargeServicemodelSoap.RenderReceipt_element RenderReceipt_element = new ebizchargeServicemodelSoap.RenderReceipt_element();
                ebizchargeServicemodelSoap.GetEbizWebFormURL_element GetEbizWebFormURL_element = new ebizchargeServicemodelSoap.GetEbizWebFormURL_element();
                ebizchargeServicemodelSoap.AddInvoiceResponse_element AddInvoiceResponse_element = new ebizchargeServicemodelSoap.AddInvoiceResponse_element();
                ebizchargeServicemodelSoap.GetPayments_element GetPayments_element = new ebizchargeServicemodelSoap.GetPayments_element();
                ebizchargeServicemodelSoap.UpdateItem_element UpdateItem_element = new ebizchargeServicemodelSoap.UpdateItem_element();
                ebizchargeServicemodelSoap.Payment Payment = new ebizchargeServicemodelSoap.Payment();
                ebizchargeServicemodelSoap.GwAddress GwAddress = new ebizchargeServicemodelSoap.GwAddress();
                ebizchargeServicemodelSoap.DeviceSettings DeviceSettings = new ebizchargeServicemodelSoap.DeviceSettings();
                ebizchargeServicemodelSoap.AddApplicationData_element AddApplicationData_element = new ebizchargeServicemodelSoap.AddApplicationData_element();
                ebizchargeServicemodelSoap.MarkApplicationTransactionAsAppliedResponse_element MarkApplicationTransactionAsAppliedResponse_element = new ebizchargeServicemodelSoap.MarkApplicationTransactionAsAppliedResponse_element();
                ebizchargeServicemodelSoap.SetDefaultCustomerPaymentMethodProfileResponse_element SetDefaultCustomerPaymentMethodProfileResponse_element = new ebizchargeServicemodelSoap.SetDefaultCustomerPaymentMethodProfileResponse_element();
                ebizchargeServicemodelSoap.SearchSalesRepsResponse_element SearchSalesRepsResponse_element = new ebizchargeServicemodelSoap.SearchSalesRepsResponse_element();
                ebizchargeServicemodelSoap.InvoicePaymentRequest InvoicePaymentRequest = new ebizchargeServicemodelSoap.InvoicePaymentRequest();
                ebizchargeServicemodelSoap.EmailReceiptResponse_element EmailReceiptResponse_element = new ebizchargeServicemodelSoap.EmailReceiptResponse_element();
                ebizchargeServicemodelSoap.ApplicationTransactionDetails ApplicationTransactionDetails = new ebizchargeServicemodelSoap.ApplicationTransactionDetails();
                ebizchargeServicemodelSoap.UserData UserData = new ebizchargeServicemodelSoap.UserData();
                ebizchargeServicemodelSoap.AddPayment_element AddPayment_element = new ebizchargeServicemodelSoap.AddPayment_element();
                ebizchargeServicemodelSoap.TransactionRequestObject TransactionRequestObject = new ebizchargeServicemodelSoap.TransactionRequestObject();
                ebizchargeServicemodelSoap.ArrayOfCustomer ArrayOfCustomer = new ebizchargeServicemodelSoap.ArrayOfCustomer();
                ebizchargeServicemodelSoap.UpdateSubCustomer_element UpdateSubCustomer_element = new ebizchargeServicemodelSoap.UpdateSubCustomer_element();
                ebizchargeServicemodelSoap.CustomSchedule CustomSchedule = new ebizchargeServicemodelSoap.CustomSchedule();
                ebizchargeServicemodelSoap.ArrayOfItem ArrayOfItem = new ebizchargeServicemodelSoap.ArrayOfItem();
                ebizchargeServicemodelSoap.ArrayOfBatchStatus ArrayOfBatchStatus = new ebizchargeServicemodelSoap.ArrayOfBatchStatus();
                ebizchargeServicemodelSoap.UpdateSalesOrderResponse_element UpdateSalesOrderResponseElement = new ebizchargeServicemodelSoap.UpdateSalesOrderResponse_element();
                ebizchargeServicemodelSoap.GetSubCustomerResponse_element GetSubCustomerResponseElement = new ebizchargeServicemodelSoap.GetSubCustomerResponse_element();
                ebizchargeServicemodelSoap.CustomerTransactionRequest CustomerTransactionRequest = new ebizchargeServicemodelSoap.CustomerTransactionRequest();
                ebizchargeServicemodelSoap.GetCustomerTokenResponse_element GetCustomerTokenResponse_element = new ebizchargeServicemodelSoap.GetCustomerTokenResponse_element();
                ebizchargeServicemodelSoap.ItemDetails ItemDetails = new ebizchargeServicemodelSoap.ItemDetails();
                ebizchargeServicemodelSoap.eBizService eBizService = new ebizchargeServicemodelSoap.eBizService();
                eBizService.GetSalesOrder(null, null, null, null, null);
                eBizService.SearchSalesOrders(null, null, null, null, null, null, null, null, null, null);
                eBizService.GetPaymentsCount(null, null, null, null, null);
                eBizService.GetMerchantData(null, null);
                eBizService.ScheduleRecurringPayment(null, null, null, null);
                eBizService.UploadAttachment(null, null, null, null);
                eBizService.GetCustomerPaymentMethodProfile(null, null, null);
                eBizService.ResendEbizWebFormEmail(null, null);
                eBizService.MarkRecurringPaymentAsApplied(null, null, null);
                eBizService.SearchPaymentFormReceivedPayments(null, null, null, null, null, null, null);
                eBizService.runCustomerTransaction(null, null, null, null);
                eBizService.AddCustomer(null, null);
                eBizService.UpdateTerms(null, null, null, null);
                eBizService.DeleteCustomerPaymentMethodProfile(null, null, null);
                eBizService.AddInvoice(null, null);
                eBizService.AddItem(null, null);
                eBizService.AddTerms(null, null);
                eBizService.GetGWCustomer(null, null, null, null);
                eBizService.AddCustomerPaymentMethodProfile(null, null, null);
                eBizService.SearchInvoices(null, null, null, null, null, null, null, null, null, null);
                eBizService.SearchRecurringPayments(null, null, null, null, null, null, null, null, null);
                try {
                    eBizService.GetReceiptsList(null, null);
                } catch (Exception ex) {}
                try {
                    eBizService.SearchUserList(null, null, null, 0, 1, null, true);
                } catch (Exception ex) {}
                try {
                    eBizService.GetReportData(null, null, '1111', 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetZipCodeInfo(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetBatchTransactions(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.AddPayment(null, null);
                } catch (Exception ex) {}
                try {
                    eBizService.SearchScheduledRecurringPayments(null, 'test', 'test', 0, 1, null);
                } catch (Exception ex) {}
                try {
                    eBizService.GetCustomerToken(null, 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.AuthenticateSK('test');
                } catch (Exception ex) {}
                try {
                    eBizService.EmailReceipt(null, 'test', 'test', 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetBatchStatus(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetTerms(null, 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetCardInfo(null, 'test', 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetSalesRep(null, 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetPaymentMethodProfileCounts(null, null, 0, 1, 'test', true);
                } catch (Exception ex) {}
                try {
                    eBizService.UpdateMerchantData(null, 'test', null);
                } catch (Exception ex) {}
                try {
                    eBizService.AddApplicationData(null, 'test', 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetEbizWebFormURL(null, null);
                } catch (Exception ex) {}
                try {
                    eBizService.UpdateSubCustomer(null, null, 'test', 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetScheduledDates(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.MarkApplicationTransactionAsApplied(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetApplicationData('test', 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.AddUserData(null, null);
                } catch (Exception ex) {}
                try {
                    eBizService.MarkCustomerAsInactive(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.UpdateApplicationData('test', 'test', 'test', null);
                } catch (Exception ex) {}
                try {
                    eBizService.GetMerchantTransactionDataBySK('test');
                } catch (Exception ex) {}
                try {
                    eBizService.SearchItems(null, 'test', 'test', null, 0, 1, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.ModifyScheduledRecurringPaymentStatus(null, 'test', 0);
                } catch (Exception ex) {}
                try {
                    eBizService.UpdateSalesOrder(null, null, 'test', 'test', 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.RenderReceipt(null, 'test', 'test', 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.ResendPaymentFormEmail(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetRecurringSchedulePreview(null, null);
                } catch (Exception ex) {}
                try {
                    eBizService.CopyCustomer('test', null, null);
                } catch (Exception ex) {}
                try {
                    eBizService.GetCustomerPaymentMethodProfiles(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetCardsExpirationList(null, null, 0, 1, 'test', true);
                } catch (Exception ex) {}
                try {
                    eBizService.GetPaymentFormURL(null, null);
                } catch (Exception ex) {}
                try {
                    eBizService.AddSalesRep(null, null);
                } catch (Exception ex) {}
                try {
                    eBizService.AddSalesOrder(null, null);
                } catch (Exception ex) {}
                try {
                    eBizService.SearchCustomers(null, 'test', 'test', 0, 1, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.MarkEbizWebFormPaymentAsApplied(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.MarkCustomerAsSynchronized(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetMerchantTransactionData(null);
                } catch (Exception ex) {}
                try {
                    eBizService.SearchEbizWebFormPendingPayments(null, 'test', null, null, null, 0, 1, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetInvoice(null, 'test', 'test', 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.UpdateSalesRep(null, null, 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetEmailTemplates(null, 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.SearchSalesReps(null, 'test', 'test', null, 0, 1, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetTransactionDetails(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.AddApplicationTransaction(null, null);
                } catch (Exception ex) {}
                try {
                    eBizService.UpdateCustomerPaymentMethodProfile(null, 'test', null);
                } catch (Exception ex) {}
                try {
                    eBizService.UpdateInvoice(null, null, 'test', 'test', 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.CloseBatch(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.SearchTransactions(null, null, null, true, 'test', 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetSubCustomer(null, 'test', 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetInvoicePayments(null, 'test', 'test', 'test', 'test', null, null, 1, 2, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.MarkSalesOrderAsSynchronized(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.ModifyScheduledRecurringPayment_PaymentMethodProfile(null, 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetUserData(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.MarkPaymentAsApplied(null, 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.ModifyScheduledRecurringPayment_RecurringBilling(null, 'test', null);
                } catch (Exception ex) {}
                try {
                    eBizService.AddSubCustomer(null, null);
                } catch (Exception ex) {}
                try {
                    eBizService.UpdateItem(null, null, 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.SearchCustomerList(null, null, 1, 2, 'test', true, true, true);
                } catch (Exception ex) {}
                try {
                    eBizService.MarkInvoiceAsSynchronized(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.SearchTerms(null, 'test', 'test', 1, 2, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.UpdateCustomer(null, null, 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.SetDefaultCustomerPaymentMethodProfile(null, 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.SearchEbizWebFormReceivedPayments(null, 'test', null, null, null, 1, 2, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.UpdateUserData(null, 'test', null);
                } catch (Exception ex) {}
                try {
                    eBizService.SearchPaymentFormPendingPayments(null, 'test', null, null, 1, 2, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetPaymentsByGatewayRefNum(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.Login('test', 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.SearchApplicationTransactions(null, null, true, 1, 2, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.GetPayments(null, 'test', 'test', null, null, 1, 2, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.DeleteEbizWebFormPayment(null, 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.AddInvoicePayment(null, null);
                } catch (Exception ex) {}
                try {
                    eBizService.GetCustomer(null, 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.SearchBatches(null, null, null, true, 'test', 'test', 'test');
                } catch (Exception ex) {}
                try {
                    eBizService.runTransaction(null, null);
                } catch (Exception ex) {}
                ebizchargeServicemodelSoap.ArrayOfLineItem MockArrayOfLineItem = new ebizchargeServicemodelSoap.ArrayOfLineItem();
                ebizchargeServicemodelSoap.UserDataResponse MockUserDataResponse = new ebizchargeServicemodelSoap.UserDataResponse();
                ebizchargeServicemodelSoap.LineItem MockLineITem = new ebizchargeServicemodelSoap.LineItem();
                ebizchargeServicemodelSoap.GetInvoicePayments_element MockPayment = new ebizchargeServicemodelSoap.GetInvoicePayments_element();
                ebizchargeServicemodelSoap.MarkSalesOrderAsSynchronizedResponse_element MockAsSynchronizedResponse = new ebizchargeServicemodelSoap.MarkSalesOrderAsSynchronizedResponse_element();
                ebizchargeServicemodelSoap.Login_element MockLoginElement = new ebizchargeServicemodelSoap.Login_element();
                ebizchargeServicemodelSoap.SearchCustomers_element MockSearchElement = new ebizchargeServicemodelSoap.SearchCustomers_element();
                ebizchargeServicemodelSoap.SearchItemsResponse_element MockItemsResponse_element = new ebizchargeServicemodelSoap.SearchItemsResponse_element();
                ebizchargeServicemodelSoap.GetPaymentFormURL_element MocktFormURL_element = new ebizchargeServicemodelSoap.GetPaymentFormURL_element();
                ebizchargeServicemodelSoap.BatchSearchResult MockBatchSearchResult = new ebizchargeServicemodelSoap.BatchSearchResult();
                ebizchargeServicemodelSoap.PaymentRequest MockPaymentRequest = new ebizchargeServicemodelSoap.PaymentRequest();
                ebizchargeServicemodelSoap.AddTermsResponse_element MockAddTermRes = new ebizchargeServicemodelSoap.AddTermsResponse_element();
                ebizchargeServicemodelSoap.SearchSalesOrders_element MockSearchSalesOrderElement = new ebizchargeServicemodelSoap.SearchSalesOrders_element();
                ebizchargeServicemodelSoap.EbizCustomField MockEbizCustomField = new ebizchargeServicemodelSoap.EbizCustomField();
                ebizchargeServicemodelSoap.GetSalesOrderResponse_element MockResponse_element = new ebizchargeServicemodelSoap.GetSalesOrderResponse_element();
                ebizchargeServicemodelSoap.SubCustomer MockSubCustomer = new ebizchargeServicemodelSoap.SubCustomer();
                ebizchargeServicemodelSoap.SearchEbizWebFormPendingPaymentsResponse_element MockWebFormPending = new ebizchargeServicemodelSoap.SearchEbizWebFormPendingPaymentsResponse_element();
                test.stopTest();
            }
        }
    }
    private static Account CreateAccountMock() {
        Account acc = new Account();
        acc.First_Name__c = 'test1';
        acc.Last_Name__c = 'test1';
        acc.EBizCharge_Email__c = 'test1@ebzi.com';
        acc.Name = 'test1@ebzi.com';
        insert acc;
        return acc;
    }
    private static order CreateOrderMock(string AccountId) {
        order od = new order();
        od.AccountId = AccountId;
        od.EffectiveDate = Date.today();
        od.Status = 'Draft';
        insert od;
        return od;
    }
}