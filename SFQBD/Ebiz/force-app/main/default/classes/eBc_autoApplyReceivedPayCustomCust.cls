Public with sharing class eBc_autoApplyReceivedPayCustomCust implements Database.Batchable < sObject > , Schedulable, Database.AllowsCallouts {
    public static string ClassName = 'eBc_autoApplyReceivedPayCustomCust';
    public static string MethodName = Configuration.EMPTYSTRING;

    public static List < SObject > start(Database.BatchableContext BC) {

        MethodName = 'start';

        List < Ebiz_C__EBizCharge_Received_Payments__c > receivedPayments = new List < Ebiz_C__EBizCharge_Received_Payments__c > ();
        List < Ebiz_C__EBizCharge_Received_Payments__c > receivedPaymentsToExecute = new List < Ebiz_C__EBizCharge_Received_Payments__c > ();
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        Datetime fromDate = Datetime.newInstance(1900, 1, 1, 15, 20, 45);
        Datetime toDate = Datetime.newInstance(2100, 1, 1, 15, 20, 45);
        List < string > customeCustomerIds = new List < string > ();
        ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        List < ebizchargeServicemodelSoap.Payment > ebizPayments = new list < ebizchargeServicemodelSoap.Payment > ();
        ebizchargeServicemodelSoap.ArrayOfPayment arrReceivedPayments = new ebizchargeServicemodelSoap.ArrayOfPayment();
        try {
            arrReceivedPayments = ebiz.SearchEbizWebFormReceivedPayments(eBc_UtilityController.getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, fromDate, toDate, null, 0, 10000, Configuration.CARDMETHODID);
            if (arrReceivedPayments != null) {
                ebizPayments = arrReceivedPayments.Payment;
                if (ebizPayments != null) {
                    for (ebizchargeServicemodelSoap.Payment ebizPayment: ebizPayments) {
                        if (ebizPayment.CustomerId != null && ebizPayment.CustomerId != Configuration.EMPTYSTRING && (ebizPayment.CustomerId.length() == 15 || ebizPayment.CustomerId.length() == 18)) {
                            string customerId = ebizPayment.CustomerId;
                            Schema.DescribeSObjectResult sObjectResultAcount = Account.sObjectType.getDescribe();
                            String keyPrefixAccount = sObjectResultAcount.getKeyPrefix();
                            Schema.DescribeSObjectResult sObjectResultContact = Contact.sObjectType.getDescribe();
                            String keyPrefixContact = sObjectResultContact.getKeyPrefix();
                            if (!customerId.startsWith(keyPrefixAccount) && !customerId.startsWith(keyPrefixContact) && (customerId.length() == 15 || customerId.length() == 18)) {
                                customeCustomerIds.add(customerId);
                                Ebiz_C__EBizCharge_Received_Payments__c transactionEntity = new Ebiz_C__EBizCharge_Received_Payments__c();
                                transactionEntity.Ebiz_C__CustomerId__c = ebizPayment.CustomerId;
                                transactionEntity.Ebiz_C__InvoiceNumber__c = ebizPayment.InvoiceNumber;
                                transactionEntity.Ebiz_C__CustomerEmailAddress__c = ebizPayment.CustomerEmailAddress;
                                transactionEntity.Ebiz_C__OrderId__c = ebizPayment.OrderId;
                                if (ebizPayment.DivisionId != null) {
                                    transactionEntity.Ebiz_C__DivisionId__c = ebizPayment.DivisionId;
                                }
                                if (ebizPayment.InvoiceInternalId != null) {
                                    transactionEntity.Ebiz_C__InvoiceInternalId__c = ebizPayment.InvoiceInternalId;
                                }
                                transactionEntity.Ebiz_C__PoNum__c = ebizPayment.PoNum;
                                transactionEntity.Ebiz_C__RefNum__c = ebizPayment.RefNum;
                                transactionEntity.Ebiz_C__Invoice_Amount__c = double.valueOf(ebizPayment.InvoiceAmount);
                                if (ebizPayment.AmountDue != null) {
                                    transactionEntity.Ebiz_C__Amount_Due__c = double.valueOf(ebizPayment.AmountDue);
                                }
                                transactionEntity.Ebiz_C__Last4__c = ebizPayment.Last4;
                                transactionEntity.Ebiz_C__Payment_Method__c = ebizPayment.PaymentMethod;
                                transactionEntity.Ebiz_C__Paid_Amount__c = double.valueOf(ebizPayment.PaidAmount);
                                transactionEntity.Ebiz_C__PaymentInternalId__c = ebizPayment.PaymentInternalId;
                                transactionEntity.Ebiz_C__PaymentRequestDateTime__c = ebizPayment.PaymentRequestDateTime;
                                if (ebizPayment.PaymentMethodId != null) {
                                    transactionEntity.Ebiz_C__Payment_Method_Id__c = ebizPayment.PaymentMethodId;
                                }
                                if(ebizPayment.TypeId != null){
                                    transactionEntity.Ebiz_C__Type_Id__c = ebizPayment.TypeId;
                                }
                                if(ebizPayment.PaymentSourceId != null){
                                    transactionEntity.Ebiz_C__PaymentSourceId__c = ebizPayment.PaymentSourceId;
                                }
                                if (ebizPayment.TransactionLookupKey != null) {
                                    transactionEntity.Ebiz_C__TransactionLookupKey__c = ebizPayment.TransactionLookupKey;
                                }
                                if (ebizPayment.ExternalTxnId != null) {
                                    transactionEntity.Ebiz_C__ExternalTxnId__c = ebizPayment.ExternalTxnId;
                                }
                                receivedPayments.add(transactionEntity);

                            }
                        }
                    }
                    map < string, object > customCustomerIdsMap = new map < string, object > ();
                    if (customeCustomerIds != null) {
                        List < Ebiz_C__EBizCharge_Fields_Config__c > customCustomerDetails = eBc_UtilityController.getCustomFieldDetails(dml, customeCustomerIds, ebcLogger);
                        for (Ebiz_C__EBizCharge_Fields_Config__c customCustomerDetail: customCustomerDetails) {
                            customCustomerIdsMap.put(customCustomerDetail.Ebiz_C__EBizCharge_CustomerId__c, customCustomerDetail);
                        }
                    }
                    if (receivedPayments != null) {
                        for (Ebiz_C__EBizCharge_Received_Payments__c receivedPayment: receivedPayments) {
                            if (customCustomerIdsMap.containsKey(receivedPayment.Ebiz_C__CustomerId__c)) {
                                receivedPaymentsToExecute.add(receivedPayment);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return receivedPaymentsToExecute;
    }
    Public void execute(SchedulableContext sc) {
        eBc_autoApplyReceivedPayCustomCust receivePaymentsToExecute = new eBc_autoApplyReceivedPayCustomCust();
        Database.executeBatch(receivePaymentsToExecute, 25);
    }
    Public void execute(Database.BatchableContext BC, List < Ebiz_C__EBizCharge_Received_Payments__c > receivedPaymentsToExecute) {

        MethodName = 'execute';

        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        try {
            for (Ebiz_C__EBizCharge_Received_Payments__c payment: receivedPaymentsToExecute) {
                String paymentInternalId = payment.Ebiz_C__PaymentInternalId__c;
                ebizchargeServicemodelSoap.PaymentResponse response = ebiz.MarkEbizWebFormPaymentAsApplied(securityToken, paymentInternalId);
            }
            for (Ebiz_C__EBizCharge_Received_Payments__c payment: receivedPaymentsToExecute) {
                String refNum = payment.Ebiz_C__RefNum__c;
                Decimal amount = payment.Ebiz_C__Paid_Amount__c;
                string customerId = payment.Ebiz_C__CustomerId__c;
                eBc_UtilityController.markCustomCustomerPaidEmailPay(dml, customerId, refNum, amount, ebcLogger);
            }

        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    Public void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}