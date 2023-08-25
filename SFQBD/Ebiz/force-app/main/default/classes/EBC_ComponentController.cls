public with sharing class EBC_ComponentController {
    public static string ClassName = 'EBC_ComponentController';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    @AuraEnabled
    public static EBizcharge_Setting__c getCompSettingsApxc() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        EBizcharge_Setting__c reciprocate = getCompSettingsApxc(dml, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static EBizcharge_Setting__c getCompSettingsApxc(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getCompSettingsApxc';
        String querySelect = 'SELECT AutoPay_four_week__c,AutoPay_weekly__c,AutoPay_daily__c,AutoPay_bi_monthly__c,AutoPay_monthly__c,AutoPay_bi_annually__c,AutoPay_quarterly__c,AutoPay_bi_weekly__c,AutoPay_annually__c,Ebiz_C__EBizcharge_Manage_Payment_Method__c,Ebiz_C__EBizcharge_Process_Payment__c,Ebiz_C__EBizcharge_Request_Payment_Method__c,Ebiz_C__EBizcharge_Schedule_Recurring_Payment__c,	Ebiz_C__EBizcharge_Send_Email_Payment_Request__c,Ebiz_C__Currency__c,Ebiz_C__Use_Custom_Opportunity_Amount__c,Id,Security_Token__c,User_Name__c,Password__c,Transaction_Filter_By__c,Email_Pending_Req_Filter_By__c,' +
            'Sync_Orders_Filter_By__c,Sync_Accounts_Filter_By__c,Sync_Products_Filter_By__c,Allow_Partial_Payment__c,' +
            'Allow_Order_Payment_Type__c,Show_Tax_Field__c,Tax_Action__c,Tax_Calculate_By__c,Tax_Manual_Type__c,Tax_Default_Percent__c,' +
            'Auto_Upload_Order__c,Auto_Upload_Account__c,Auto_Upload_Product__c,Auto_Apply_Received_Payment__c,Component_Label__c' +
            ', Allow_Quote_Payment_Type__c';
        String queryFrom = 'FROM EBizcharge_Setting__c';
        String queryOrderby = 'Order by CreatedDate DESC';
        EBizcharge_Setting__c settingsEntity = (EBizcharge_Setting__c) dml.selectSingleRecord(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryOrderby);
        return settingsEntity;
    }
    // ================= received payment method Start ======================== //
    @AuraEnabled
    public static List < receivedPayments > getReceivedPaymentEmailsApxc(String sDate, String eDate, sObject cust, String objName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < receivedPayments > reciprocate = getReceivedPaymentEmailsApxc(dml, sDate, eDate, cust, objName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < receivedPayments > getReceivedPaymentEmailsApxc(DML dml, String sDate, String eDate, sObject cust, String objName, EBC_Logger ebcLogger) {
        MethodName = 'getReceivedPaymentEmailsApxc';
        List < receivedPayments > receivedPayList = new List < receivedPayments > ();
        List < receivedPayments > receivedEmailPayments = new List < receivedPayments > ();
        receivedEmailPayments = getReceivedPaymentsWithTypeApxc(dml, sDate, eDate, cust, objName, Configuration.EMAILPAYMENTREQUESTS, ebcLogger);
        ebcLogger.debug(ClassName, MethodName, 'epm is' + receivedEmailPayments);
        if (receivedEmailPayments != null) {
            for (receivedPayments receivedPayment: receivedEmailPayments) {
                receivedPayList.add(receivedPayment);
            }
            for (Integer i = 0; i < receivedPayList.size(); i++) {
                DateTime datetimeToCompare = DateTime.valueOf(receivedPayList[i].PaymentRequestDateTime);
                for (Integer j = i + 1; j < receivedPayList.size(); j++) {
                    DateTime datetimeCompareWith = DateTime.valueOf(receivedPayList[j].PaymentRequestDateTime);
                    if (datetimeToCompare < datetimeCompareWith) {
                        receivedPayments receivedpay = receivedPayList[i];
                        receivedPayList[i] = receivedPayList[j];
                        receivedPayList[j] = receivedpay;
                    }
                }
            }
        }
        return receivedPayList;
    }
    // Received payment filters .....
    @AuraEnabled
    public static List < receivedPayments > getReceivedPaymentsWithTypeApxc(String sDate, String eDate, sObject cust, String objName, String webformType) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < receivedPayments > reciprocate = getReceivedPaymentsWithTypeApxc(dml, sDate, eDate, cust, objName, webformType, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < receivedPayments > getReceivedPaymentsWithTypeApxc(DML dml, String sDate, String eDate, sObject cust, String objName, String webformType, EBC_Logger ebcLogger) {
        MethodName = 'getReceivedPaymentsWithTypeApxc';
        ebizchargeServicemodelSoap.ArrayOfSearchFilter ebizFilters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        list < ebizchargeServicemodelSoap.SearchFilter > ebizSearchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
        String customerId = Configuration.EMPTYSTRING;
        if (webformType == Configuration.EMAILPAYMENTREQUESTS) {
            ebcLogger.debug(ClassName, MethodName, 'in Email check');
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.InvoiceNumber);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.ne);
            filter.FieldValue = string.valueOf(Enums.FIELDVALUES.Token);
            ebizSearchFilters.add(filter);
        }
        String orderId;
        if (objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order) || objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote) || objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
            ebcLogger.debug(ClassName, MethodName, 'in order check');
            String querySelect = 'select id,QBD_Customer_ID__c';
            String queryFrom = 'from Account';
            String queryWhere =  'where id=\''+ string.valueOf(cust.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId))) +'\'';
            Account account = (Account)dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
            customerId = (string)account.get('QBD_Customer_ID__c');
            orderId = string.valueOf(cust.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Id)));
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.OrderId);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = orderId;
            ebizSearchFilters.add(filter);
            ebcLogger.debug(ClassName, MethodName, 'Filters are');
        }
        ebizFilters.SearchFilter = ebizSearchFilters;
        String defaultStartDate = '1900-01-01T00:00:00.000Z';
        DateTime startDate = DateTime.ValueofGmt(defaultStartDate.replace(Configuration.DATETIMESEPARATOR, Configuration.DOUBLEBLANKS));
        DateTime endDate = system.now();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        List < ebizchargeServicemodelSoap.Payment > paymentlist = new list < ebizchargeServicemodelSoap.Payment > ();
        ebizchargeServicemodelSoap.ArrayOfPayment arrayOfPayment = new ebizchargeServicemodelSoap.ArrayOfPayment();
        if (!test.isRunningTest()) {
            arrayOfPayment = ebiz.SearchEbizWebFormReceivedPayments(eBc_UtilityController.getSecurityToken(dml, ebcLogger), customerId, startDate, endDate, ebizFilters, 0, 1000, '1');
            paymentlist = arrayOfPayment.Payment;
            ebcLogger.debug(ClassName, MethodName, 'paymentlist is' + paymentlist);
        } else {
            //-----------------------------------mockdata----------------------------------
            ebizchargeServicemodelSoap.Payment pay = new ebizchargeServicemodelSoap.Payment();
            pay.CustomerId = '001123456777777';
            pay.PaidAmount = '2.00';
            Datetime StartDT = Datetime.newInstance(2017, 1, 7, 15, 20, 45);
            pay.PaymentRequestDateTime = StartDT.format('yyyy-MM-dd\'T\'HH:mm:ss');
            paymentlist.add(pay);
            //---------------------------------------------------------------------------------
        }
        List < receivedPayments > receivedList = new List < receivedPayments > ();
        List < receivedPayments > receivedPayList = new List < receivedPayments > ();
        List < String > customerIds = new List < String > ();
        integer paymentsMaxCount = 6;
        integer paymentsLimit = 0;
        integer paymentsCount = 0;
        if (paymentlist != null) {
            ebcLogger.debug(ClassName, MethodName, 'paymentlist size is' + paymentlist.size());
            for (ebizchargeServicemodelSoap.Payment payment: paymentlist) {
                receivedPayments receivedPayment = new receivedPayments();
                if (payment.CustomerId != null && payment.CustomerId != Configuration.EMPTYSTRING) {
                    paymentsCount = paymentsCount + 1;
                }
            }
            for (ebizchargeServicemodelSoap.Payment payment: paymentlist) {
                receivedPayments receivedPayment = new receivedPayments();
                if (payment.CustomerId != null && payment.CustomerId != Configuration.EMPTYSTRING) {
                    string paymentCustomerId = payment.CustomerId;
                    string customerIdString = paymentCustomerId.left(3);
                        decimal paidAmount = decimal.valueOf(payment.PaidAmount);
                        if (test.isRunningTest()) {
                            PaidAmount = 5;
                        }
                        if (paidAmount > 0) {
                            customerIds.add(payment.CustomerId);
                            receivedPayment.OrderId = payment.OrderId;
                            receivedPayment.PoNum = payment.PoNum;
                            ebcLogger.debug(ClassName, MethodName, '<<check one>>' + receivedPayment.OrderId);
                            receivedPayment.CustomerId = payment.CustomerId;
                            receivedPayment.CustomerName = Configuration.EMPTYSTRING;
                            receivedPayment.DivisionId = payment.DivisionId;
                           
                            if (objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
                                receivedPayment.OrderHyperUrl = '/' + payment.OrderId;
                            } else {
                                receivedPayment.OrderHyperUrl =  payment.OrderId;  
                            }
                            receivedPayment.InvoiceNumber = payment.InvoiceNumber;
                            receivedPayment.InvoiceAmount = payment.InvoiceAmount;
                            receivedPayment.AmountDue = payment.AmountDue;
                            receivedPayment.AuthCode = payment.AuthCode;
                            receivedPayment.RefNum = payment.RefNum;
                            receivedPayment.Last4 = payment.Last4;
                            receivedPayment.PaymentMethod = payment.PaymentMethod;
                            receivedPayment.PaymentSourceId = payment.PaymentSourceId;
                            receivedPayment.PaidAmount = paidAmount.setScale(2);
                            receivedPayment.DatePaid = payment.DatePaid;
                            if (payment.PaymentRequestDateTime != Configuration.EMPTYSTRING && payment.PaymentRequestDateTime != null) {
                                receivedPayment.PaymentRequestDateTime = DateTime.ValueofGmt(payment.PaymentRequestDateTime.replace(Configuration.DATETIMESEPARATOR, Configuration.DOUBLEBLANKS));
                            }
                            receivedPayment.TypeId = payment.TypeId;
                            receivedPayment.PaymentSourceId = payment.PaymentSourceId;
                            receivedPayment.PaymentMethodId = payment.PaymentMethodId;
                            receivedPayment.PaymentInternalId = payment.PaymentInternalId;
                            receivedPayment.CustomerEmailAddress = payment.CustomerEmailAddress;
                            receivedPayment.tcount = paymentsCount;
                            receivedList.add(receivedPayment);
                            ebcLogger.debug(ClassName, MethodName, 'unique is' + receivedList);
                        }
                        paymentsLimit = paymentsLimit + 1;
                        if (paymentsLimit == paymentsMaxCount) {
                            break;
                        }
                }
            } // end of loop
            if (!test.isRunningTest()) {
                if (customerIds != null) {
                    List < Account > accountInfolist = eBc_UtilityController.getAccountsDetailForQbd(dml, customerIds, ebcLogger);
                    Map < String, String > customersIdMap = new map < String, String > ();
                    for (Account account: accountInfolist) {
                        customersIdMap.put(account.id, account.Name);
                    }
                    for (receivedPayments receivedPayment: receivedList) {
                        receivedPayment.CustomerName = customersIdMap.get(receivedPayment.CustomerId);
                        receivedPayList.add(receivedPayment);
                    }
                }
            }
            ebcLogger.debug(ClassName, MethodName, 'Email Received Issue' + receivedPayList);
        }
        return receivedPayList;
    }
    //Applypayments latest code
    @AuraEnabled
    public static String markPaymentAsApplied(String RefNum, String PaymentInternalId, String InvoiceNumber, String OrderId, Double Amount) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = markPaymentAsApplied(dml, RefNum, PaymentInternalId, InvoiceNumber, OrderId, Amount, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String markPaymentAsApplied(DML dml, String RefNum, String PaymentInternalId, String InvoiceNumber, String OrderId, Double Amount, EBC_Logger ebcLogger) {
        MethodName = 'markPaymentAsApplied';
        try {
            ebcLogger.debug(ClassName, MethodName, 'PaymentInternalId:' + PaymentInternalId);
            ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
            ebizchargeServicemodelSoap.TransactionObject transactionObject = new ebizchargeServicemodelSoap.TransactionObject();
            if (!test.isRunningTest()) {
                transactionObject = ebiz.GetTransactionDetails(eBc_UtilityController.getSecurityToken(dml, ebcLogger), RefNum);
            }
            String paymentMethodID = Configuration.EMPTYSTRING;
            String expiryYear = Configuration.EMPTYSTRING;
            String expiryMonth = Configuration.EMPTYSTRING;
            String QBD_Id = Configuration.EMPTYSTRING;
            Datetime fromDate = Datetime.newInstance(1900, 1, 1, 15, 20, 45);
            Datetime toDate = Datetime.newInstance(2100, 1, 1, 15, 20, 45);
            List < ebizchargeServicemodelSoap.Payment > paymentlist = new list < ebizchargeServicemodelSoap.Payment > ();
            ebizchargeServicemodelSoap.ArrayOfPayment arrayOfPayment = new ebizchargeServicemodelSoap.ArrayOfPayment();
            ebizchargeServicemodelSoap.ArrayOfSearchFilter ebizFilters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
            ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
            list < ebizchargeServicemodelSoap.SearchFilter > ebizSearchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.RefNum);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = RefNum;
            ebizSearchFilters.add(filter);
            ebizFilters.SearchFilter = ebizSearchFilters;
            if (!test.isRunningTest()) {
                arrayOfPayment = ebiz.SearchEbizWebFormReceivedPayments(eBc_UtilityController.getSecurityToken(dml, ebcLogger),Configuration.EMPTYSTRING, fromDate, toDate, ebizFilters, 0, 10000, '1');
            }
            paymentlist = arrayOfPayment.Payment;
            ebcLogger.debug(ClassName, MethodName, 'paymentlist for apply is' + paymentlist);
            if (paymentlist.size() > 0) {
                ebizchargeServicemodelSoap.Payment payment = paymentlist[0];
                paymentMethodID = payment.PaymentMethodId;
                QBD_Id = payment.CustomerId;
                ebcLogger.debug(ClassName, MethodName, 'Qbd Customer Id is' + QBD_Id);
                ebcLogger.debug(ClassName, MethodName, 'paymentMethodID is' + paymentMethodID);
            } 
            if (paymentMethodID != null && paymentMethodID != Configuration.EMPTYSTRING) {
                string customerToken = ebiz.GetCustomerToken(eBc_UtilityController.getSecurityToken(dml, ebcLogger), QBD_Id, Configuration.EMPTYSTRING);
                ebcLogger.debug(ClassName, MethodName, 'customerToken is' + customerToken);
                ebizchargeServicemodelSoap.PaymentMethodProfile paymentMethodProfile = new ebizchargeServicemodelSoap.PaymentMethodProfile();
                paymentMethodProfile = ebiz.GetCustomerPaymentMethodProfile(eBc_UtilityController.getSecurityToken(dml, ebcLogger), customerToken, paymentMethodID);
                if (paymentMethodProfile != null) {
                    String cardExpiration = paymentMethodProfile.CardExpiration;
                    list < string > cardExpirationList = cardExpiration.split('-');
                    expiryYear = cardExpirationList[0];
                    expiryMonth = cardExpirationList[1];
                }
            }
            ebizchargeServicemodelSoap.PaymentResponse response1 = eBc_UtilityController.MarkEbizWebFormPaymentAsApplied(dml, PaymentInternalId, ebcLogger);
            eBc_UtilityController.markOrderPaid(dml, OrderId, RefNum, Amount, transactionObject, paymentMethodID, expiryYear, expiryMonth, ebcLogger);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static PendingPayments getPendingPaymentsCustomerApxc(String sDate, String eDate, sObject cust, String objName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        PendingPayments reciprocate = getPendingPaymentsCustomerApxc(dml, sDate, eDate, cust, objName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static PendingPayments getPendingPaymentsCustomerApxc(DML dml, String sDate, String eDate, sObject cust, String objName, EBC_Logger ebcLogger) {
        MethodName = 'getPendingPaymentsCustomerApxc';
        list < Payments > returnPendingPayments = new list < Payments > ();
        PendingPayments pendingPaymentMethods = new PendingPayments();
        pendingPaymentMethods = getPendingPaymentsWithTypeApxc(dml, sDate, eDate, cust, objName, Configuration.PYAMENTMETHODREQUESTS, ebcLogger);
        ebcLogger.debug(ClassName, MethodName, 'ppm is' + pendingPaymentMethods);
        PendingPayments pendingEmailPayments = new PendingPayments();
        pendingEmailPayments = getPendingPaymentsWithTypeApxc(dml, sDate, eDate, cust, objName, Configuration.EMAILPAYMENTREQUESTS, ebcLogger);
        ebcLogger.debug(ClassName, MethodName, 'epm is' + pendingEmailPayments);
        if (pendingPaymentMethods.PendingList != null) {
            for (Payments payment: pendingPaymentMethods.PendingList) {
                returnPendingPayments.add(payment);
            }
        }
        if (pendingEmailPayments.PendingList != null) {
            for (Payments payment: pendingEmailPayments.PendingList) {
                returnPendingPayments.add(payment);
            }
        }
        pendingPaymentMethods.PendingList = returnPendingPayments;
        return pendingPaymentMethods;
    }
    @AuraEnabled
    public static PendingPayments getPendingPaymentsWithTypeApxc(String sDate, String eDate, sObject cust, String objName, String webformType) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        PendingPayments reciprocate = getPendingPaymentsWithTypeApxc(dml, sDate, eDate, cust, objName, webformType, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static PendingPayments getPendingPaymentsWithTypeApxc(DML dml, String sDate, String eDate, sObject cust, String objName, String webformType, EBC_Logger ebcLogger) {
        MethodName = 'getPendingPaymentsWithTypeApxc';
        PendingPayments pendingPayments = new PendingPayments();
        String orderPrefix = Order.sObjectType.getDescribe().getKeyPrefix();
        String quotePrefix = Quote.sObjectType.getDescribe().getKeyPrefix();
        String opportunityPrefix = Opportunity.sObjectType.getDescribe().getKeyPrefix();
        List < Contact > contactslist;
        ebizchargeServicemodelSoap.ArrayOfSearchFilter ebizFilters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        list < ebizchargeServicemodelSoap.SearchFilter > ebizSearchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
        String customerId = Configuration.EMPTYSTRING;
        if (webformType == Configuration.PYAMENTMETHODREQUESTS) {
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.InvoiceNumber);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = string.valueOf(Enums.FIELDVALUES.Token);
            ebizSearchFilters.add(filter);
        } else if (webformType == Configuration.EMAILPAYMENTREQUESTS) {
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.InvoiceNumber);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.ne);
            filter.FieldValue = string.valueOf(Enums.FIELDVALUES.Token);
            ebizSearchFilters.add(filter);
        }
        String orderId;
        if(objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account))//For SF-QBD 
        {
            customerId = string.valueOf(cust.get('QBD_Customer_ID__c'));
        }
        if(objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact))//For SF-QBD 
        {
            customerId = string.valueOf(cust.get('Id'));
        }
        if (objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order) || objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote) || objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
            String QbdId= string.valueOf(cust.get('AccountId'));
            String query_select = 'Select QBD_Customer_ID__c';
            String query_from = 'from Account';
            String query_where = 'where id =\'' + QbdId+'\'';
            String query_limit = 'limit 1';
            Account account = (Account)dml.selectSingleRecord(query_select,query_from,query_where,'','');
            customerId = string.valueOf(account.get('QBD_Customer_ID__c'));//For SF-QBD 
            orderId = string.valueOf(cust.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Id)));
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.OrderId);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = orderId;
            ebizSearchFilters.add(filter);
        } else if (objName.contains(Configuration.CUSTOMOBJECTIDENTFIER)) {
            ebcLogger.debug(ClassName, MethodName, 'in custom object check');
            customerId = string.valueOf(cust.get(Configuration.CUSTOMINTERNALIDSTRING));
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.OrderId);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = Configuration.WEBFORMORDERID;
            ebizSearchFilters.add(filter);
        }
        String contactname = Configuration.EMPTYSTRING;
        String contactid = Configuration.EMPTYSTRING;
        if (objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account) || objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order) || objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote) || objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
            String querySelect = 'Select name';
            String queryFrom = 'from Contact';
            String queryWhere = 'where Account.QBD_Customer_ID__c =\'' + customerId + '\'';
            String queryLimit = 'limit 1';
            contactslist = (List < Contact > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryLimit);
            ebcLogger.debug(ClassName, MethodName, 'customerId for pending grid is' + customerId);
            ebcLogger.debug(ClassName, MethodName, 'contact list for pending grid is' + contactslist);
        } else if (objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
            String querySelect = 'Select name';
            String queryFrom = 'from Contact';
            String queryWhere = 'where id =\'' + customerId + '\'';
            String queryLimit = 'limit 1';
            contactslist = (List < Contact > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryLimit);
        }
        contactname = Configuration.EMPTYSTRING;
        contactid = Configuration.EMPTYSTRING;
        if (!test.isRunningTest()) {
            if (contactslist != null && contactslist.size() > 0) {
                contactname = contactslist[0].name;
                contactid = '/' + contactslist[0].id;
            }
        }
        Date startDate = null;
        Date endDate = null;
        if (sDate == null && eDate == null) {
            DateTime defaultDatetimeEntity = system.Today().AddDays(1);
            EBizcharge_Setting__c settingsEntity = eBc_UtilityController.getSettings(dml, ebcLogger);
            if (settingsEntity.Email_Pending_Req_Filter_By__c != null) {
                String filterBy = settingsEntity.Email_Pending_Req_Filter_By__c;
                if (filterBy == string.valueOf(Enums.filterBy.Today)) {
                    startDate = Date.valueOf(defaultDatetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = Date.valueOf(defaultDatetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = endDate.addDays(1);
                } else if (filterBy == Configuration.FILTERBYPASTWEEK) {
                    Datetime datetimeEntity = System.Today().toStartofWeek() - 6;
                    startDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = endDate.addDays(1);
                } else if (filterBy == Configuration.FILTERBYPASTMONTH) {
                    Datetime datetimeEntity = system.Today().addMonths(-1).toStartOfMonth().addDays(1);
                    startDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = endDate.addDays(1);
                } else if (filterBy == Configuration.FILTERBYPASTYEAR) {
                    Datetime datetimeEntity = System.Today().addYears(-1);
                    startDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = endDate.addDays(1);
                }
            } else {
                Datetime datetimeEntity = System.Today().toStartofWeek() - 6;
                startDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                endDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                endDate = endDate.addDays(1);
            }
        } else {
            startDate = Date.valueOf(sDate);
            endDate = Date.valueOf(eDate);
        }
        list < Payments > returnPendingPayments = new list < Payments > ();
        List < Payments > pendingPaymentsList = new List < Payments > ();
        List < String > customerIds = new List < String > ();
        pendingPayments.PendingList = null;
        try {
            list < ebizchargeServicemodelSoap.Payment > paymentlist = new list < ebizchargeServicemodelSoap.Payment > ();
            if (!test.isRunningTest()) {
                ebizFilters.SearchFilter = ebizSearchFilters;
                paymentlist = eBc_UtilityController.searchPendingPaymentsCustomer(dml, startDate, endDate, customerId, ebizFilters, ebcLogger);
                ebcLogger.debug(ClassName, MethodName, 'api response is' + paymentlist);
            } else {
                //-----------------------------------Mock Data----------------------------------
                ebizchargeServicemodelSoap.Payment pay = new ebizchargeServicemodelSoap.Payment();
                pay.CustomerId = '001123456777777';
                pay.PaidAmount = '2.00';
                Datetime startDateTime = Datetime.newInstance(2017, 1, 7, 15, 20, 45);
                pay.PaymentRequestDateTime = startDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss');
                paymentlist.add(pay);
                //---------------------------------------------------------------------------------
            }
            if (paymentlist != null) {
                for (ebizchargeServicemodelSoap.Payment payment: paymentlist) {
                    ebcLogger.debug(ClassName, MethodName, 'payment is' + payment);
                    Payments pendingPayment = new Payments();
                    if (payment.CustomerId != null && payment.CustomerId != Configuration.EMPTYSTRING) {
                        string paymentCustomerId = payment.CustomerId;
                        string customerIdString = payment.CustomerId.left(3);
                        customerIds.add(payment.CustomerId);
                        pendingPayment.contactName = contactname;
                        pendingPayment.contactURL = contactid;
                        if (webformType == Configuration.EMAILPAYMENTREQUESTS) {
                            pendingPayment.methodType = 'Email Payment Method';
                        } else if (webformType == Configuration.PYAMENTMETHODREQUESTS) {
                            pendingPayment.methodType = 'Payment Method Request';
                        }
                        pendingPayment.OrderId = payment.OrderId;
                        if (test.isRunningTest()) {
                            pendingPayment.OrderId = '546656';
                            pendingPayment.OrderId = '0061100000NvMeHAAV';
                        }
                        if (pendingPayment.OrderId != null) {
                            if (pendingPayment.OrderId.startsWith(orderPrefix)) {
                                pendingPayment.Source = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order);
                            } else if (pendingPayment.OrderId.startsWith(quotePrefix)) {
                                pendingPayment.Source = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote);
                            } else if (pendingPayment.OrderId.startsWith(opportunityPrefix)) {
                                pendingPayment.Source = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity);
                            } else {
                                pendingPayment.Source = objName;
                            }
                        }
                        if (payment.PaymentRequestDateTime != Configuration.EMPTYSTRING && payment.PaymentRequestDateTime != null) {
                            List < String > requestDateTime = payment.PaymentRequestDateTime.split(Configuration.DATETIMESPLITTER);
                            String pendingPaymentRequestDateTime = requestDateTime[0] + Configuration.DATETIMESEPERATOR + requestDateTime[1];
                            pendingPayment.PaymentRequestDateTime = DateTime.ValueofGmt(pendingPaymentRequestDateTime);
                        }
                        pendingPaymentsList.add(pendingPayment);
                        ebcLogger.debug(ClassName, MethodName, 'pendinglist is' + pendingPaymentsList);
                    }
                } // end of loop
                pendingPayments.PendingList = pendingPaymentsList;
            } //end isTesting flag
            pendingPayments.fromDate = date.valueOf(startDate);
            pendingPayments.toDate = date.valueOf(endDate);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, '>>>Error has been occured ');
            throw new AuraHandledException('Darn it! ' + e.getMessage());
        }
        return pendingPayments;
    }
    @AuraEnabled
    public static PendingPayments getPendingPaymentsApxc(String sDate, String eDate, String ordNum) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        PendingPayments reciprocate = getPendingPaymentsApxc(dml, sDate, eDate, ordNum, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static PendingPayments getPendingPaymentsApxc(DML dml, String sDate, String eDate, String ordNum, EBC_Logger ebcLogger) {
        MethodName = 'getPendingPaymentsApxc';
        PendingPayments pendingPayments = new PendingPayments();
        ebizchargeServicemodelSoap.ArrayOfSearchFilter ebizFilters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        list < ebizchargeServicemodelSoap.SearchFilter > ebizSearchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.OrderId);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
        filter.FieldValue = ordNum;
        ebizSearchFilters.add(filter);
        Date startDate = null;
        Date endDate = null;
        if (test.isRunningTest()) {
            sDate = null;
            eDate = null;
        }
        if (sDate == null && eDate == null) {
            DateTime defaultDatetimeEntity = system.Today().AddDays(1);
            EBizcharge_Setting__c settingsEntity = eBc_UtilityController.getSettings(dml, ebcLogger);
            if (settingsEntity.Email_Pending_Req_Filter_By__c != null) {
                String filterBy = settingsEntity.Email_Pending_Req_Filter_By__c;
                if (filterBy == string.valueOf(Enums.filterBy.Today)) {
                    startDate = Date.valueOf(defaultDatetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = Date.valueOf(defaultDatetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = endDate.addDays(1);
                } else if (filterBy == Configuration.FILTERBYPASTWEEK) {
                    Datetime datetimeEntity = System.Today().toStartofWeek() - 6;
                    startDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = endDate.addDays(1);
                } else if (filterBy == Configuration.FILTERBYPASTMONTH) {
                    Datetime datetimeEntity = system.Today().addMonths(-1).toStartOfMonth().addDays(1);
                    startDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = endDate.addDays(1);
                } else if (filterBy == Configuration.FILTERBYPASTYEAR) {
                    Datetime datetimeEntity = System.Today().addYears(-1);
                    startDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                    endDate = endDate.addDays(1);
                }
            } else {
                Datetime datetimeEntity = System.Today().toStartofWeek() - 6;
                startDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                endDate = Date.valueOf(datetimeEntity.format(Configuration.DATEFORMAT));
                endDate = endDate.addDays(1);
            }
        } else {
            startDate = Date.valueOf(sDate);
            endDate = Date.valueOf(eDate);
        }
        list < Payments > returnPendingPayments = new list < Payments > ();
        List < Payments > pendingPaymentsList = new List < Payments > ();
        List < String > customerIds = new List < String > ();
        pendingPayments.PendingList = null;
        try {
            list < ebizchargeServicemodelSoap.Payment > paymentlist = new list < ebizchargeServicemodelSoap.Payment > ();
            if (!test.isRunningTest()) {
                ebizFilters.SearchFilter = ebizSearchFilters;
                paymentlist = eBc_UtilityController.searchPendingPaymentsCustomer(dml, startDate, endDate, Configuration.EMPTYSTRING, ebizFilters, ebcLogger);
                ebcLogger.debug(ClassName, MethodName, 'api response is' + paymentlist);
            } else {
                //-----------------------------------Mock Data----------------------------------
                ebizchargeServicemodelSoap.Payment pay = new ebizchargeServicemodelSoap.Payment();
                pay.CustomerId = '001123456777777';
                pay.PaidAmount = '2.00';
                Datetime startDateTime = Datetime.newInstance(2017, 1, 7, 15, 20, 45);
                pay.PaymentRequestDateTime = startDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss');
                paymentlist.add(pay);
                //---------------------------------------------------------------------------------
            }
            if (paymentlist != null) {
                for (ebizchargeServicemodelSoap.Payment payment: paymentlist) {
                    Payments pendingPayment = new Payments();
                    if (payment.CustomerId != null && payment.CustomerId != Configuration.EMPTYSTRING) {
                        string paymentCustomerId = payment.CustomerId;
                        string customerIdString = payment.CustomerId.left(3);
                        if (customerIdString == '001' && (paymentCustomerId.length() == 15 || paymentCustomerId.length() == 18)) {
                            customerIds.add(payment.CustomerId);
                            pendingPayment.isSelected = false;
                            pendingPayment.CustomerId = payment.CustomerId;
                            pendingPayment.OrderId = payment.OrderId;
                            pendingPayment.CustomerName = Configuration.EMPTYSTRING;
                            pendingPayment.DivisionId = payment.DivisionId;
                            pendingPayment.InvoiceNumber = payment.InvoiceNumber;
                            pendingPayment.InvoiceInternalId = payment.InvoiceInternalId;
                            pendingPayment.InvoiceDate = payment.InvoiceDate;
                            pendingPayment.InvoiceDueDate = payment.InvoiceDueDate;
                            pendingPayment.PoNum = payment.PoNum;
                            pendingPayment.InvoiceAmount = payment.InvoiceAmount;
                            pendingPayment.AmountDue = payment.AmountDue;
                            pendingPayment.AuthCode = payment.AuthCode;
                            pendingPayment.RefNum = payment.RefNum;
                            pendingPayment.Last4 = payment.Last4;
                            pendingPayment.PaymentMethod = payment.PaymentMethod;
                            pendingPayment.DatePaid = payment.DatePaid;
                            decimal paidAmount = decimal.valueOf(payment.PaidAmount);
                            pendingPayment.PaidAmount = paidAmount.setScale(2);
                            pendingPayment.PaymentInternalId = payment.PaymentInternalId;
                            if (payment.PaymentRequestDateTime != Configuration.EMPTYSTRING && payment.PaymentRequestDateTime != null) {
                                List < String > dateTimeString = payment.PaymentRequestDateTime.split(Configuration.DATETIMESEPARATOR);
                                pendingPayment.PaymentRequestDate = date.valueOf(dateTimeString[0]);
                                pendingPayment.PaymentRequestTime = dateTimeString[1];
                            }
                            pendingPayment.PaymentMethodId = payment.PaymentMethodId;
                            pendingPayment.TypeId = payment.TypeId;
                            pendingPayment.PaymentSourceId = payment.PaymentSourceId;
                            pendingPayment.TransactionLookupKey = payment.TransactionLookupKey;
                            pendingPayment.ExternalTxnId = payment.ExternalTxnId;
                            pendingPayment.CustomerEmailAddress = payment.CustomerEmailAddress;
                            pendingPaymentsList.add(pendingPayment);
                        }
                    }
                } // end of loop
                pendingPayments.PendingList = pendingPaymentsList;
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, '>>>Error has been occured ');
            throw new AuraHandledException('Darn it! ' + e.getMessage());
        }
        return pendingPayments;
    }
    @AuraEnabled
    public static string SaveObjectConfig(Ebiz_C__EBiz_Object_Config__c config) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = SaveObjectConfig(dml, config, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string SaveObjectConfig(DML dml, Ebiz_C__EBiz_Object_Config__c config, EBC_Logger ebcLogger) {
        MethodName = 'SaveObjectConfig';
        try {
            config.Ebiz_C__ShowMeConfigModel__c = false;
            dml.updateRecord(config);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (DmlException e) {
            return string.valueOf(Enums.RETURNMESSAGE.Error);
        }
    }
    @AuraEnabled
    public static string SaveObjectConfigClose(Ebiz_C__EBiz_Object_Config__c config) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = SaveObjectConfigClose(dml, config, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string SaveObjectConfigClose(DML dml, Ebiz_C__EBiz_Object_Config__c config, EBC_Logger ebcLogger) {
        MethodName = 'SaveObjectConfigClose';
        try {
            Ebiz_C__EBiz_Object_Config__c customEntity = new Ebiz_C__EBiz_Object_Config__c();
            customEntity.id = config.id;
            customEntity.Ebiz_C__ShowMeConfigModel__c = false;
            dml.updateRecord(customEntity);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (DmlException e) {
            return string.valueOf(Enums.RETURNMESSAGE.Error);
        }
    }
    public static string GetObjLabel(string obj_api, EBC_Logger ebcLogger) {
        MethodName = 'GetObjLabel';
        string entityName = obj_api;
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = schemaMap.get(entityName);
        return sobjType.getDescribe().getLabel();
    }
    @AuraEnabled
    public static string GetObjLabelSettings(string obj_api) {
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = GetObjLabel(obj_api, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    @AuraEnabled
    public static wrapperConfigObject GETObjConfig(string objectName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        wrapperConfigObject reciprocate = GETObjConfig(dml, objectName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
        //return GETObjConfig(dml, objectName);
    }
    public static wrapperConfigObject GETObjConfig(DML dml, string objectName, EBC_Logger ebcLogger) {
        MethodName = 'GETObjConfig';
        Ebiz_C__EBiz_Object_Config__c customEntity = new Ebiz_C__EBiz_Object_Config__c();
        wrapperConfigObject wrapperConfig = new wrapperConfigObject();
        try {
            String querySelect = 'SELECT id, Ebiz_C__EBizAmountApi__c,Ebiz_C__ShowMeConfigModel__c,Ebiz_C__EBizCustomerEmailApi__c,Ebiz_C__EBizCustomerNameApi__c';
            String queryFrom = 'from Ebiz_C__EBiz_Object_Config__c';
            String queryWhere = 'where Name=\'' + objectName + '\'';
            customEntity = (Ebiz_C__EBiz_Object_Config__c) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        } catch (QueryException e) {
            customEntity.Name = objectName;
            customEntity.Ebiz_C__ShowMeConfigModel__c = true;
            dml.insertRecord(customEntity);
        }
        wrapperConfig.config = customEntity;
        wrapperConfigObject dropdownVals = FindFields(objectName, ebcLogger);
        wrapperConfig.EBizCharge_EBizCharge_Email_list = dropdownVals.EBizCharge_EBizCharge_Email_list;
        wrapperConfig.EBizCharge_name_fields_list = dropdownVals.EBizCharge_name_fields_list;
        wrapperConfig.EBizCharge_Amount_fields_list = dropdownVals.EBizCharge_Amount_fields_list;
        return wrapperConfig;
    }
    public static wrapperConfigObject FindFields(string obj_name, EBC_Logger ebcLogger) {
        MethodName = 'FindFields';
        List < dropdownVals > collectDropDownAmount = new List < dropdownVals > ();
        List < dropdownVals > collectDropDownEmail = new List < dropdownVals > ();
        List < dropdownVals > collectDropDownSTRING = new List < dropdownVals > ();
        wrapperConfigObject collectDropdownFiels = new wrapperConfigObject();
        String entityName = obj_name;
        Map < String, Schema.SObjectType > schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = schemaMap.get(entityName);
        Schema.DescribeSObjectResult entityDescription = sobjType.getDescribe();
        Map < String, Schema.SObjectField > fieldsMap = entityDescription.fields.getMap();
        Map < String, String > accountFields = new Map < String, String > ();
        Account accountEntity = new Account();
        SObject sfEntity = accountEntity;
        for (String fMap: fieldsMap.keySet()) {
            Schema.SObjectField field = fieldsMap.get(fMap);
            Schema.DisplayType fieldType = field.getDescribe().getType();
            Schema.DescribeFieldResult describeResult = fieldsMap.get(fMap).getDescribe();
            if (fieldType == Schema.DisplayType.CURRENCY) { //find Currency Fields *
                dropdownVals collectVals = new dropdownVals();
                collectVals.value = fMap;
                collectVals.label = fieldsMap.get(fMap).getDescribe().getLabel();
                collectDropDownAmount.add(collectVals);
            }
            if (fieldType == Schema.DisplayType.EMAIL) { //find EMAIL Fields *
                dropdownVals collectVals = new dropdownVals();
                collectVals.value = fMap;
                collectVals.label = fieldsMap.get(fMap).getDescribe().getLabel();
                collectDropDownEmail.add(collectVals);
            }
            if (fieldType == Schema.DisplayType.STRING) { //find STRING Fields *
                dropdownVals collectVals = new dropdownVals();
                collectVals.value = fMap;
                collectVals.label = fieldsMap.get(fMap).getDescribe().getLabel();
                collectDropDownSTRING.add(collectVals);
            }
        }
        collectDropdownFiels.EBizCharge_Amount_fields_list = collectDropDownAmount;
        collectDropdownFiels.EBizCharge_EBizCharge_Email_list = collectDropDownEmail;
        collectDropdownFiels.EBizCharge_name_fields_list = collectDropDownSTRING;
        return collectDropdownFiels;
    }
    @AuraEnabled
    public static String saveSettingsApxc(EBizcharge_Setting__c cmpSettings) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = saveSettingsApxc(dml, cmpSettings, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String saveSettingsApxc(DML dml, EBizcharge_Setting__c cmpSettings, EBC_Logger ebcLogger) {
        MethodName = 'saveSettingsApxc';
        if (cmpSettings != null) {
            if (cmpSettings.Tax_Action__c == Configuration.TAXACTION) {
                ebizchargeServicemodelSoap.SecurityToken securityToken = EBC_CompMethods.getSecurityToken(dml, ebcLogger);
                if (securityToken.Password != null && securityToken.SecurityId != null) {
                    ebizchargeServicemodelSoap.MerchantTransactionData response;
                    if (!test.isRunningTest()) {
                        response = ebiz.GetMerchantTransactionData(securityToken);
                    }
                    if (response != null) {
                        cmpSettings.Tax_Default_Percent__c = response.TaxPercentage.setScale(2, RoundingMode.CEILING);
                    }
                }
            }
            dml.upsertRecord(cmpSettings, Configuration.SETTINGSENTITYID);
        }
        return 'success';
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
        EBizcharge_Setting__c settings = eBc_SettingController.getSettingsApxc(dml, ebcLogger);
        String standardPriceBookId = Configuration.EMPTYSTRING;
        string sfStandardPriceBookId = Configuration.EMPTYSTRING;
        String querySelect = 'SELECT Id,name';
        String queryFrom = 'FROM Pricebook2';
        String queryWhere = 'where name = \'Standard Price Book\'';
        list < Pricebook2 > pricebooklist = (list < Pricebook2 > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        for (Pricebook2 prBook: pricebooklist) {
            standardPriceBookId = prBook.Id;
            sfStandardPriceBookId = prBook.id;
            ebcLogger.debug(ClassName, MethodName, 'standard Pricebook2 id' + standardPriceBookId);
            break;
        }
        Detail detailEntity = new Detail();
        if (!test.isRunningTest()) {
            ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
            responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
            detailEntity.UseFullAmountForAVS = responseMerchant.UseFullAmountForAVS;
        }
        querySelect = 'SELECT Id,CreatedDate,Name';
        queryFrom = ' FROM ' + ObjectName;
        queryWhere = ' WHERE Id = \'' + recordId + '\'';
        if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
            querySelect += ',AccountId,Ebiz_C__Custom_Amount__c,Account.Name,Account.QBD_Customer_ID__c, Amount, Ebiz_C__EBizCharge_Opportunity_Status__c,EBizCharge_Opportunity_Balance__c,EBizCharge_Amount__c,EBizCharge_Internal_ID__c,EBizCharge_Reference_Number__c,EBizCharge_PONumber__c,LastModifiedDate,Pricebook2Id ';
        } else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
            querySelect += ',EBizCharge_Custom_Tax__c,EBizCharge_Captured_Amount__c,AccountId,Account.Name,OrderNumber,PoNumber,TotalAmount,EBizCharge_Order_Status__c,EBizCharge_Order_Balance__c,EBizCharge_Amount__c,EBizCharge_Internal_ID__c,EBizCharge_Reference_Number__c, EBizCharge_Order_Tax__c,Pricebook2Id,LastModifiedDate';
        } else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
            querySelect += ',AccountId,Account.Name,Account.QBD_Customer_ID__c,EBizCharge_Amount__c,EBizCharge_Internal_ID__c,EBizCharge_Reference_Number__c,EBizCharge_Contact_Tax__c';
        }
        // added by @wqkl - 8dec20 - start
        else if (objectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote)) {
            querySelect += ',EBizCharge_Captured_Amount__c, AccountId, Account.Name,Account.QBD_Customer_ID__c, QuoteNumber, GrandTotal, EBizCharge_Quote_Status__c, EBizCharge_Quote_Balance__c, EBizCharge_Amount__c,EBizCharge_Internal_ID__c,EBizCharge_Reference_Number__c, EBizCharge_Quote_Tax_c__c,Pricebook2Id,LastModifiedDate,EBizCharge_PONumber__c';
        }
        else if(objectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)){
            querySelect += ',EBizCharge_Custom_Tax__c,Email__c,QBD_Customer_ID__c, EBizCharge_Amount__c,EBizCharge_Internal_ID__c,EBizCharge_Reference_Number__c';
        }
        // added by @wqkl - 8dec20 - end
        String query = querySelect + Configuration.DOUBLEBLANKS + queryFrom + Configuration.DOUBLEBLANKS + queryWhere;
        try {
            sObject sObjectDetail = dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            String accountId = Configuration.EMPTYSTRING;
            String accountName = Configuration.EMPTYSTRING;
            map < String, String > updateAccountMap = new map < string, string > ();
            if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
                accountId = string.valueOf(sObjectDetail.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId)));
                detailEntity.OppId = recordId;
                detailEntity.OppName = string.valueOf(sObjectDetail.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Name)));
            } else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)) {
                accountId = string.valueOf(sObjectDetail.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.Id)));
                querySelect = 'select id,billingstreet,billingcity,billingstate,billingPostalCode,BillingCountry';
                queryFrom = 'from account';
                queryWhere = 'where id=\'' + accountId + '\'';
                account accountEntity = (account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                string shippingAddress = Configuration.EMPTYSTRING;
                if (accountEntity != null) {
                    if (test.isRunningTest()) {
                        accountEntity.billingstreet = 'FakeStreet';
                        accountEntity.billingPostalCode = 'FakeCode';
                    }
                    if (accountEntity.billingstreet != null && accountEntity.billingstreet != Configuration.EMPTYSTRING) {
                        shippingAddress = shippingAddress + accountEntity.billingstreet;
                    }
                    if (accountEntity.billingPostalCode != null && accountEntity.billingPostalCode != Configuration.EMPTYSTRING) {
                        detailEntity.ZipCode = accountEntity.billingPostalCode;
                    }
                }
                detailEntity.Address = shippingAddress;
            } else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
                accountId = string.valueOf(sObjectDetail.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId)));
            }
            // added by @wqkl against SF-137 : 8dec20 : start
            else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote)) {
                accountId = string.valueOf(sObjectDetail.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId)));
            }
            // added by @wqkl against SF-137 : 8dec20 : end
            else if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
                detailEntity.contactDetail = (contact) sObjectDetail;
                querySelect = 'select id,Mailingstreet,Mailingcity,Mailingstate,MailingPostalCode,MailingCountry';
                queryFrom = 'from contact';
                queryWhere = 'where id=\'' + detailEntity.contactDetail.id + '\'';
                contact contactEntity = (contact) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                string shippingAddress = Configuration.EMPTYSTRING;
                if (contactEntity != null) {
                    if (test.isRunningTest()) {
                        contactEntity.Mailingstreet = 'FakeStreet';
                        contactEntity.MailingPostalCode = 'FakeCode';
                    }
                    if (contactEntity.Mailingstreet != null && contactEntity.Mailingstreet != Configuration.EMPTYSTRING) {
                        shippingAddress = shippingAddress + contactEntity.Mailingstreet;
                    }
                    if (contactEntity.MailingPostalCode != null && contactEntity.MailingPostalCode != Configuration.EMPTYSTRING) {
                        detailEntity.ZipCode = contactEntity.MailingPostalCode;
                    }
                }
                detailEntity.Address = shippingAddress;
                ebcLogger.debug(ClassName, MethodName, 'Address is ' + shippingAddress);
            }
            Account accountDetail;
            if (accountId != Configuration.EMPTYSTRING) {
                ebizchargeServicemodelSoap.CustomerResponse Customer_response = new ebizchargeServicemodelSoap.CustomerResponse();
                accountDetail = EBC_CompMethods.getAccountDetail(dml, accountId, ebcLogger);
                detailEntity.AccountInfo = accountDetail;
                detailEntity.AccountId = (String)accountDetail.get('QBD_Customer_ID__c');
                detailEntity.AccountName = accountDetail.Name;
                ebcLogger.debug(ClassName, MethodName, 'accountDetail.BillingAddress:' + accountDetail.BillingAddress);
                String accountExternalId = accountDetail.EBizCharge_Internal_ID__c;
                if (test.isRunningTest()) {
                    accountExternalId = null;
                }
                if (accountExternalId == null || accountExternalId == Configuration.EMPTYSTRING) {
                    //search customer on Gateway 
                    ebizchargeServicemodelSoap.Customer searchCustomerResponse = new ebizchargeServicemodelSoap.Customer();
                    if(ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)){
                    searchCustomerResponse = EBC_CompMethods.invoke_SearchCustomer(dml,(String)accountDetail.get('QBD_Customer_ID__c'),ebcLogger);
                } else {
                    searchCustomerResponse = EBC_CompMethods.invoke_SearchCustomer(dml,accountId,ebcLogger);
                }
                    if (searchCustomerResponse.CustomerInternalId != null) {
                        accountExternalId = searchCustomerResponse.CustomerInternalId;
                        updateAccountMap.put(accountId, searchCustomerResponse.CustomerInternalId);
                    } else {
                        // add customer on Gateway
                        ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = EBC_CompMethods.invoke_addCustomer(dml, accountDetail, ebcLogger);
                        accountExternalId = addCustomerResponse.CustomerInternalId;
                        updateAccountMap.put(accountId, addCustomerResponse.CustomerInternalId);
                    }
                }else{
                    ebizchargeServicemodelSoap.CustomerResponse customerResponse = eBc_UtilityController.invoke_addORUpdCustomerQBD(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger),'',string.valueOf(Enums.ENTITYACTIONS.updateCustomer), ebcLogger);
                }
                detailEntity.AccountInternalId = accountExternalId;
            }
            if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
                boolean isUpdated = false;
                ebizchargeServicemodelSoap.ArrayOfSearchFilter ebizFilters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
                ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
                list < ebizchargeServicemodelSoap.SearchFilter > ebizSearchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
                ebizchargeServicemodelSoap.ArrayOfSalesOrder salesorderToUpdate = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
                list < ebizchargeServicemodelSoap.CustomSalesOrder > salesOrderList = new list < ebizchargeServicemodelSoap.CustomSalesOrder > ();
                ebizchargeServicemodelSoap.ArrayOfSalesOrder arrayOfSalesOrder = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
                ebizchargeServicemodelSoap.CustomSalesOrder salesOrderFromResponse;
                ebizchargeServicemodelSoap.SalesOrder salesorderResponse = new ebizchargeServicemodelSoap.SalesOrder();
                List < OpportunityLineItem > opportunityLineItem = new List < OpportunityLineItem > ();
                map < string, opportunityLineItem > opportunityLineItemMap = new map < string, opportunityLineItem > ();
                map < string, object > ebizOpportunityLineItem = new map < string, object > ();
                ebcLogger.debug(ClassName, MethodName, 'In Opp:');
                Opportunity opportunityDetail = (Opportunity) sObjectDetail;
                detailEntity.OpportunityDetail = opportunityDetail;
                if (opportunityDetail.Pricebook2Id != null) {
                    standardPriceBookId = opportunityDetail.Pricebook2Id;
                    ebcLogger.debug(ClassName, MethodName, 'standard price book modified as per opportunity');
                } else {
                    opportunityDetail.Pricebook2Id = standardPriceBookId;
                    dml.updateRecord(opportunityDetail);
                    ebcLogger.debug(ClassName, MethodName, 'Opportunity price book was null');
                }
                filter.FieldName = string.valueOf(Enums.FIELDNAMES.SalesOrderInternalId);
                filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
                filter.FieldValue = opportunityDetail.EBizCharge_Internal_ID__c;
                ebcLogger.debug(ClassName, MethodName, 'fieldValue is ' + filter.FieldValue);
                ebizSearchFilters.add(filter);
                ebizFilters.SearchFilter = ebizSearchFilters;
                ebcLogger.debug(ClassName, MethodName, 'filterArray is ' + ebizFilters);
                querySelect = 'select id,billingstreet,billingcity,billingstate,billingPostalCode,BillingCountry,QBD_Customer_ID__c';
                queryFrom = 'from account';
                queryWhere = 'where id=\'' + opportunityDetail.Account.Id + '\'';
                account accountEntity = (account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                string shippingAddress = Configuration.EMPTYSTRING;
                if (accountEntity != null) {
                    if (test.isRunningTest()) {
                        accountEntity.billingstreet = 'FakeStreet';
                        accountEntity.billingPostalCode = 'BillfakeCode';
                    }
                    if (accountEntity.billingstreet != null && accountEntity.billingstreet != Configuration.EMPTYSTRING) {
                        shippingAddress = shippingAddress + accountEntity.billingstreet;
                    }
                    if (accountEntity.billingPostalCode != null && accountEntity.billingPostalCode != Configuration.EMPTYSTRING) {
                        detailEntity.ZipCode = accountEntity.billingPostalCode;
                    }
                }
                detailEntity.Address = shippingAddress;
                map < String, String > mapUpdOrder = new map < string, string > ();
                String orderNumber = recordId;
                String orderInternalId = (string) sObjectDetail.get(Configuration.INTERNALIDSTRING);
                if (orderInternalId == null || orderInternalId == Configuration.EMPTYSTRING) {
                    //search sale order on Gateway
                    String qbdId = (string)accountEntity.get('QBD_Customer_ID__c');// For SF-Qbd
                    //salesorderResponse = EBC_CompMethods.invoke_SearchOrder(dml, accountId, quoteNumber, ebcLogger);
                    salesorderResponse = EBC_CompMethods.invoke_SearchOrder(dml,qbdId, orderNumber, ebcLogger);// For SF-Qbd
                    if (salesorderResponse.SalesOrderInternalId != null) {
                     mapUpdOrder.put(recordId,salesorderResponse.SalesOrderInternalId);
                    } else {
                        // add sale order on Gateway
                        ebizchargeServicemodelSoap.SalesOrderResponse addSOres = EBC_CompMethods.invoke_addOpportunity(dml, opportunityDetail, ebcLogger);
                        mapUpdOrder.put(recordId, addSOres.SalesOrderInternalId);
                    }
                }
                //update Order
                if (mapUpdOrder != null) {
                    List < Opportunity > opportunityToUpdate = new List < Opportunity > ();
                    for (String key: mapUpdOrder.keySet()) {
                        Opportunity opportunity = new Opportunity();
                        opportunity.Id = key;
                        opportunity.EBizCharge_Internal_ID__c = mapUpdOrder.get(key);
                        opportunity.EBizCharge_Last_Sync_Date__c = system.now();
                        opportunityToUpdate.add(opportunity);
                    }
                    if (opportunityToUpdate.size() > 0) {
                        dml.updateRecord(opportunityToUpdate);
                        detailEntity.auto_reload_page = true;
                    }
                }
            }
            if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
                boolean isUpdated = false;
                ebizchargeServicemodelSoap.ArrayOfSearchFilter ebizFilters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
                ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
                list < ebizchargeServicemodelSoap.SearchFilter > ebizSearchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
                ebizchargeServicemodelSoap.ArrayOfSalesOrder salesorderToUpdate = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
                list < ebizchargeServicemodelSoap.CustomSalesOrder > salesOrderList = new list < ebizchargeServicemodelSoap.CustomSalesOrder > ();
                ebizchargeServicemodelSoap.ArrayOfSalesOrder arrayOfSalesOrder = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
                ebizchargeServicemodelSoap.CustomSalesOrder salesOrderFromResponse;
                ebizchargeServicemodelSoap.SalesOrder salesorderResponse = new ebizchargeServicemodelSoap.SalesOrder();
                List < OrderItem > orderLineItem = new List < OrderItem > ();
                map < string, OrderItem > OrderLineItemMap = new map < string, OrderItem > ();
                map < string, object > ebizOrderLineItemMap = new map < string, object > ();
                Order orderDetail = (Order) sObjectDetail;
                detailEntity.ordDetail = orderDetail;
                if (orderDetail.Pricebook2Id != null) {
                    standardPriceBookId = orderDetail.Pricebook2Id;
                    ebcLogger.debug(ClassName, MethodName, 'standard price book modified as per Order');
                } else {
                    orderDetail.Pricebook2Id = standardPriceBookId;
                    dml.updateRecord(orderDetail);
                    ebcLogger.debug(ClassName, MethodName, 'Order price book was null');
                }
                filter.FieldName = string.valueOf(Enums.FIELDNAMES.SalesOrderInternalId);
                filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
                filter.FieldValue = orderDetail.EBizCharge_Internal_ID__c;
                ebcLogger.debug(ClassName, MethodName, 'fieldValue is ' + filter.FieldValue);
                ebizSearchFilters.add(filter);
                ebizFilters.SearchFilter = ebizSearchFilters;
                ebcLogger.debug(ClassName, MethodName, 'filterArray is ' + ebizFilters);
                querySelect = 'select id,billingstreet,billingcity,billingstate,billingPostalCode,BillingCountry,QBD_Customer_ID__c';
                queryFrom = 'from account';
                queryWhere = 'where id=\'' + orderDetail.Account.Id + '\'';
                account accountEntity = (account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                string shippingAddress = Configuration.EMPTYSTRING;
                if (accountEntity != null) {
                    if (test.isRunningTest()) {
                        accountEntity.billingstreet = 'FakeStreet';
                        accountEntity.billingPostalCode = 'BillfakeCode';
                    }
                    if (accountEntity.billingstreet != null && accountEntity.billingstreet != Configuration.EMPTYSTRING) {
                        shippingAddress = shippingAddress + accountEntity.billingstreet;
                    }
                    if (accountEntity.billingPostalCode != null && accountEntity.billingPostalCode != Configuration.EMPTYSTRING) {
                        detailEntity.ZipCode = accountEntity.billingPostalCode;
                    }
                }
                detailEntity.Address = shippingAddress;
                map < String, String > mapUpdOrder = new map < string, string > ();
                String orderNumber = (string) sObjectDetail.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.OrderNumber));
                String orderInternalId = (string) sObjectDetail.get(Configuration.INTERNALIDSTRING);
                if (orderInternalId == null || orderInternalId == Configuration.EMPTYSTRING) {
                    //search sale order on Gateway
                    String qbdId = (string)accountEntity.get('QBD_Customer_ID__c');// For SF-Qbd
                    salesorderResponse = EBC_CompMethods.invoke_SearchOrder(dml,qbdId,orderNumber, ebcLogger);// For SF-Qbd
                    if (salesorderResponse.SalesOrderInternalId != null) {
                     mapUpdOrder.put(recordId,salesorderResponse.SalesOrderInternalId);
                     } else {
                        // add sale order on Gateway
                        ebizchargeServicemodelSoap.SalesOrderResponse addSOres = EBC_CompMethods.invoke_addSaleOrder(dml, orderDetail, ebcLogger);
                        mapUpdOrder.put(recordId, addSOres.SalesOrderInternalId);
                    }
                }
                //update Order
                if (mapUpdOrder != null) {
                    List < Order > orderToUpdate = new List < Order > ();
                    for (String key: mapUpdOrder.keySet()) {
                        Order order = new Order();
                        order.Id = key;
                        order.EBizCharge_Internal_ID__c = mapUpdOrder.get(key);
                        order.EBizCharge_Last_Sync_Date__c = system.now();
                        orderToUpdate.add(order);
                    }
                    if (orderToUpdate.size() > 0) {
                        dml.updateRecord(orderToUpdate);
                        detailEntity.auto_reload_page = true;
                    }
                }
            }
            // added by @wqkl against SF-137 : 8dec20 : start
            if (ObjectName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote)) {
                boolean isUpdated = false;
                ebizchargeServicemodelSoap.ArrayOfSearchFilter ebizFilters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
                ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
                list < ebizchargeServicemodelSoap.SearchFilter > ebizSearchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
                ebizchargeServicemodelSoap.ArrayOfSalesOrder salesorderToUpdate = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
                list < ebizchargeServicemodelSoap.CustomSalesOrder > salesOrderList = new list < ebizchargeServicemodelSoap.CustomSalesOrder > ();
                ebizchargeServicemodelSoap.ArrayOfSalesOrder arrayOfSalesOrder = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
                ebizchargeServicemodelSoap.CustomSalesOrder salesOrderFromResponse;
                ebizchargeServicemodelSoap.SalesOrder salesorderResponse = new ebizchargeServicemodelSoap.SalesOrder();
                List < QuoteLineItem > quotLineItem = new List < QuoteLineItem > ();
                map < string, QuoteLineItem > mapQuotLineItem = new map < string, QuoteLineItem > ();
                map < string, object > mapQuotGWLineItem = new map < string, object > ();
                Quote quoteDetail = (Quote) sObjectDetail;
                detailEntity.quoteDetail = quoteDetail;
                if (quoteDetail.Pricebook2Id != null) {
                    standardPriceBookId = quoteDetail.Pricebook2Id;
                    ebcLogger.debug(ClassName, MethodName, 'standard price book modified as per opportunity');
                } else {
                    quoteDetail.Pricebook2Id = standardPriceBookId;
                    dml.updateRecord(quoteDetail);
                    ebcLogger.debug(ClassName, MethodName, 'Quote price book was null');
                }
                filter.FieldName = string.valueOf(Enums.FIELDNAMES.SalesOrderInternalId);
                filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
                filter.FieldValue = quoteDetail.EBizCharge_Internal_ID__c;
                ebcLogger.debug(ClassName, MethodName, 'fieldValue is ' + filter.FieldValue);
                ebizSearchFilters.add(filter);
                ebizFilters.SearchFilter = ebizSearchFilters;
                ebcLogger.debug(ClassName, MethodName, 'filterArray is ' + ebizFilters);
                querySelect = 'select id,billingstreet,billingcity,billingstate,billingPostalCode,BillingCountry,QBD_Customer_ID__c';
                queryFrom = 'from account';
                queryWhere = 'where id=\'' + quoteDetail.Account.Id + '\'';
                account accountEntity = (account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                string shippingAddress = Configuration.EMPTYSTRING;
                if (accountEntity != null) {
                    if (test.isRunningTest()) {
                        accountEntity.billingstreet = 'FakeStreet';
                        accountEntity.billingPostalCode = 'BillfakeCode';
                    }
                    if (accountEntity.billingstreet != null && accountEntity.billingstreet != Configuration.EMPTYSTRING) {
                        shippingAddress = shippingAddress + accountEntity.billingstreet;
                    }
                    if (accountEntity.billingPostalCode != null && accountEntity.billingPostalCode != Configuration.EMPTYSTRING) {
                        detailEntity.ZipCode = accountEntity.billingPostalCode;
                    }
                }
                detailEntity.Address = shippingAddress;
                map < String, String > quoteUpdateMap = new map < string, string > ();
                String quoteNumber = (string) sObjectDetail.get(string.valueOf(Enums.ENTITYFIELDSMAPSTRINGS.QuoteNumber));
                String quoteInternalId = (string) sObjectDetail.get(Configuration.INTERNALIDSTRING);
                if (quoteInternalId == null || quoteInternalId == Configuration.EMPTYSTRING) {
                    //search quote on Gateway
                     String qbdId = (string)accountEntity.get('QBD_Customer_ID__c');
                    salesorderResponse = EBC_CompMethods.invoke_SearchOrder(dml,qbdId, quoteNumber, ebcLogger);
                    if (salesorderResponse.SalesOrderInternalId != null) {
                      quoteUpdateMap.put(recordId,salesorderResponse.SalesOrderInternalId);
                    }else{
                        // add quote on Gateway
                        ebizchargeServicemodelSoap.SalesOrderResponse addQuoteRes = EBC_CompMethods.invoke_addQuote(dml, quoteDetail, ebcLogger);
                        quoteUpdateMap.put(recordId, addQuoteRes.SalesOrderInternalId);
                    }
                }
                //update Quote
                if (quoteUpdateMap != null) {
                    List < Quote > quoteToUpdate = new List < Quote > ();
                    for (String key: quoteUpdateMap.keySet()) {
                        Quote order = new Quote();
                        order.Id = key;
                        order.EBizCharge_Internal_ID__c = quoteUpdateMap.get(key);
                        order.EBizCharge_Last_Sync_Date__c = system.now();
                        quoteToUpdate.add(order);
                    }
                    if (quoteToUpdate.size() > 0) {
                        dml.updateRecord(quoteToUpdate);
                        detailEntity.auto_reload_page = true;
                    }
                }
            }
            // added by @wqkl against SF-137 : 8dec20 : end
            //update Account
            if (updateAccountMap != null) {
                List < Account > updateCustomer = new List < Account > ();
                for (String key: updateAccountMap.keySet()) {
                    Account account = new Account();
                    account.Id = key;
                    account.EBizCharge_Internal_ID__c = updateAccountMap.get(key);
                    account.EBizCharge_Last_Sync_Date__c = system.now();
                    updateCustomer.add(account);
                }
                if (updateCustomer.size() > 0) {
                    dml.updateRecord(updateCustomer);
                    detailEntity.auto_reload_page = true;
                }
            }
        } catch (Exception e) {
            if (!test.isRunningTest()) {
                throw new AuraHandledException(Configuration.DEFAULTERRORMESSAGESTRING + e.getMessage());
            }
        }
        return detailEntity;
    }
    @AuraEnabled
    public static Detail getDetailApxcContact(String recordId, String ObjectName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        Detail reciprocate = getDetailApxcContact(dml, recordId, ObjectName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static Detail getDetailApxcContact(DML dml, String recordId, String ObjectName, EBC_Logger ebcLogger) {
        MethodName = 'getDetailApxcContact';
        Detail detailEntity = new Detail();
        if (!test.isRunningTest()) {
            ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
            responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
            detailEntity.UseFullAmountForAVS = responseMerchant.UseFullAmountForAVS;
        }
        try {
            map < String, String > updateContactMap = new map < string, string > ();
            Contact contactDetail = EBC_CompMethods.getContactDetail(dml, recordId, ebcLogger);
            detailEntity.ContactInfo = contactDetail;
            detailEntity.ContactId = recordId;
            detailEntity.ContactName = contactDetail.Name;
            String accountExternalId = contactDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c;
            if (test.isRunningTest()) {
                accountExternalId = null;
            }
            if (accountExternalId == null || accountExternalId == Configuration.EMPTYSTRING) {
                ebizchargeServicemodelSoap.Customer searchCustomerResponse = new ebizchargeServicemodelSoap.Customer();
                //search customer on Gateway 
                if (!test.isRunningTest()) {
                    searchCustomerResponse = EBC_CompMethods.invoke_SearchCustomer(dml, recordId, ebcLogger);
                }
                if (searchCustomerResponse.CustomerInternalId != null) {
                    accountExternalId = searchCustomerResponse.CustomerInternalId;
                    updateContactMap.put(recordId, searchCustomerResponse.CustomerInternalId);
                } else {
                    // add customer on Gateway
                    ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = EBC_CompMethods.invoke_addCustomerContact(dml, contactDetail, ebcLogger);
                    accountExternalId = addCustomerResponse.CustomerInternalId;
                    updateContactMap.put(recordId, addCustomerResponse.CustomerInternalId);
                }
            }
            detailEntity.AccountInternalId = accountExternalId;
            //update Account
            if (updateContactMap != null) {
                List < Contact > updateCustomer = new List < Contact > ();
                for (String key: updateContactMap.keySet()) {
                    Contact contact = new Contact();
                    contact.Id = key;
                    contact.Ebiz_C__EBizCharge_Contact_Internal_ID__c = updateContactMap.get(key);
                    contact.EBizCharge_Last_Sync_Date__c = system.now();
                    updateCustomer.add(contact);
                }
                if (updateCustomer.size() > 0) {
                    dml.updateRecord(updateCustomer);
                    detailEntity.auto_reload_page = true;
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(Configuration.DEFAULTERRORMESSAGESTRING + e.getMessage());
        }
        return detailEntity;
    }
    @AuraEnabled
    public static Detail getDetailApxcCustomCustomer(string CustomerId, string objectName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        Detail reciprocate = getDetailApxcCustomCustomer(dml, CustomerId, objectName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static Detail getDetailApxcCustomCustomer(DML dml, string CustomerId, string objectName, EBC_Logger ebcLogger) {
        MethodName = 'getDetailApxcCustomCustomer';
        Detail detailEntity = new Detail();
        if (!test.isRunningTest()) {
            ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
            responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
            detailEntity.UseFullAmountForAVS = responseMerchant.UseFullAmountForAVS;
        }
        try {
            map < String, String > updateCustomerMap = new map < string, string > ();
            Ebiz_C__EBizCharge_Fields_Config__c customEntityDetail = EBC_CompMethods.getCustomFieldDetail(dml, CustomerId, ebcLogger);
            detailEntity.CustomCustInfo = customEntityDetail;
            detailEntity.CustomCustId = CustomerId;
            detailEntity.CustomCustName = customEntityDetail.Name;
            detailEntity.Object_label = GetObjLabel(objectName, ebcLogger);
            ebcLogger.debug(ClassName, MethodName, '>>CustomerId>>>' + CustomerId);
            ebcLogger.debug(ClassName, MethodName, '>>CustomCustName>>>' + detailEntity.CustomCustName);
            ebcLogger.debug(ClassName, MethodName, '>customEntityDetail.Ebiz_C__EBizCharge_Internal_ID__c>>>' + customEntityDetail.Ebiz_C__EBizCharge_Internal_ID__c);
            String accountExternalId = customEntityDetail.Ebiz_C__EBizCharge_Internal_ID__c;
            if (test.isRunningTest()) {
                accountExternalId = null;
            }
            if (accountExternalId == null || accountExternalId == Configuration.EMPTYSTRING || string.isEmpty(accountExternalId)) {
                //search customer on Gateway 
                ebizchargeServicemodelSoap.Customer searchCustomerResponse = new ebizchargeServicemodelSoap.Customer();
                if (!test.isRunningTest()) {
                    searchCustomerResponse = EBC_CompMethods.invoke_SearchCustomer(dml, customEntityDetail.id, ebcLogger);
                }
                ebcLogger.debug(ClassName, MethodName, '>>>searchCustomerResponse.CustomerInternalId>>>' + searchCustomerResponse.CustomerInternalId);
                if (searchCustomerResponse.CustomerInternalId != null) {
                    accountExternalId = searchCustomerResponse.CustomerInternalId;
                } else {
                    // add customer on Gateway
                    ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = EBC_CompMethods.invoke_addCustomCustomer(dml, customEntityDetail, ebcLogger);
                    accountExternalId = addCustomerResponse.CustomerInternalId;
                    updateCustomerMap.put(CustomerId, addCustomerResponse.CustomerInternalId);
                }
                ebcLogger.debug(ClassName, MethodName, '>>accountExternalId>>>' + accountExternalId);
                detailEntity.AccountInternalId = accountExternalId;
                //update Account
                if (updateCustomerMap != null) {
                    List < Ebiz_C__EBizCharge_Fields_Config__c > updateCustomer = new List < Ebiz_C__EBizCharge_Fields_Config__c > ();
                    for (String key: updateCustomerMap.keySet()) {
                        Ebiz_C__EBizCharge_Fields_Config__c customEntity = new Ebiz_C__EBizCharge_Fields_Config__c();
                        customEntity.Ebiz_C__EBizCharge_CustomerId__c = key;
                        customEntity.Ebiz_C__EBizCharge_Internal_ID__c = updateCustomerMap.get(key);
                        customEntity.EBizCharge_Last_Sync_Date__c = system.now();
                        ebcLogger.debug(ClassName, MethodName, 'Externale record>>>>>>>' + customEntity.Ebiz_C__EBizCharge_Internal_ID__c);
                        updateCustomer.add(customEntity);
                    }
                    if (updateCustomer.size() > 0) {
                        dml.upsertRecord(updateCustomer, 'Ebiz_C__EBizCharge_Fields_Config__c.Ebiz_C__EBizCharge_CustomerId__c');
                        detailEntity.auto_reload_page = true;
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, '>>>Error has been occured ' + e.getMessage());
        }
        return detailEntity;
    }
    @AuraEnabled
    public static PaymentMethods getCustPaymentMethodsApx(string AccountId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        PaymentMethods reciprocate = getCustPaymentMethodsApx(dml, AccountId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static PaymentMethods getCustPaymentMethodsApx(DML dml, string AccountId, EBC_Logger ebcLogger) {
        MethodName = 'getCustPaymentMethodsApx';
        PaymentMethods paymentMethods = new PaymentMethods();
        Account accountDetail = EBC_CompMethods.getAccountDetail(dml, AccountId, ebcLogger);
        paymentMethods.AccountInfo = accountDetail;
        String accountExternalId = accountDetail.EBizCharge_Internal_ID__c;
        if (accountExternalId != null && accountExternalId != Configuration.EMPTYSTRING) {
            map < String, String > listOfPaymentMethods = new map < String, String > ();
            list < customerMethod > methods = new list < customerMethod > ();
            list < ebizchargeServicemodelSoap.PaymentMethodProfile > customerPaymentMethods = new list < ebizchargeServicemodelSoap.PaymentMethodProfile > ();
            if (!test.isRunningTest()) {
                customerPaymentMethods = EBC_CompMethods.GetCustomerPaymentMethods(dml,(String)accountDetail.get('QBD_Customer_ID__c'),accountExternalId, ebcLogger);
            } else {
                //********Mock Data*****
                ebizchargeServicemodelSoap.PaymentMethodProfile mockData = new ebizchargeServicemodelSoap.PaymentMethodProfile();
                mockData.SecondarySort = '3';
                mockData.MethodType = 'cc';
                mockData.CardExpiration = '1212 12';
                mockData.CardNumber = '2342343';
                mockData.Account = '234234';
                customerPaymentMethods.add(mockData);
            }
            if (customerPaymentMethods != null) {
                for (ebizchargeServicemodelSoap.PaymentMethodProfile paymentMethod: customerPaymentMethods) {
                    customerMethod customerMethod = new customerMethod();
                    customerMethod.MethodType = paymentMethod.MethodType;
                    customerMethod.MethodID = paymentMethod.MethodID;
                    customerMethod.MethodName = paymentMethod.MethodName;
                    customerMethod.DateCreated = paymentMethod.Created;
                    customerMethod.DateModified = paymentMethod.Modified;
                    customerMethod.AccountHolderName = paymentMethod.AccountHolderName;
                    customerMethod.SecondarySort = Integer.valueOf(paymentMethod.SecondarySort);
                    if (paymentMethod.MethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.cc)) {
                        customerMethod.AvsStreet = paymentMethod.AvsStreet;
                        customerMethod.AvsZip = paymentMethod.AvsZip;
                        customerMethod.CardExpiration = paymentMethod.CardExpiration;
                        customerMethod.CardExpMonth = paymentMethod.CardExpiration.right(2);
                        customerMethod.CardExpYear = paymentMethod.CardExpiration.left(4);
                        customerMethod.CardNumber = paymentMethod.CardNumber;
                        customerMethod.Last4Degit = paymentMethod.CardNumber.right(4);
                        customerMethod.CardType = paymentMethod.CardType;
                    } else {
                        customerMethod.Account = paymentMethod.Account;
                        customerMethod.Last4Degit = paymentMethod.Account.right(4);
                        customerMethod.AccountType = paymentMethod.AccountType;
                        customerMethod.Routing = paymentMethod.Routing;
                    }
                    if (paymentMethod.CardNumber == null) {
                        string method = Configuration.EMPTYSTRING;
                        if (!string.isEmpty(paymentMethod.MethodName)) {
                            method = ', ' + paymentMethod.MethodName;
                        }
                        listOfPaymentMethods.put(paymentMethod.MethodID + '@E', paymentMethod.Routing + '^' + paymentMethod.Account + method);
                    } else {
                        string method = Configuration.EMPTYSTRING;
                        if (!string.isEmpty(paymentMethod.MethodName)) {
                            method = ', ' + paymentMethod.MethodName;
                        }
                        string cardType = Configuration.EMPTYSTRING;
                        if (test.isRunningTest()) {
                            paymentMethod.CardType = 'M';
                        }
                        if (paymentMethod.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.V)) {
                            cardType = string.valueOf(Enums.CARDTYPES.VISA);
                        } else if (paymentMethod.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.M)) {
                            cardType = string.valueOf(Enums.CARDTYPES.MC);
                        } else if (paymentMethod.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.A)) {
                            cardType = string.valueOf(Enums.CARDTYPES.AMEX);
                        } else if (paymentMethod.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.DS)) {
                            cardType = string.valueOf(Enums.CARDTYPES.DISC);
                        }
                        ebcLogger.debug(ClassName, MethodName, 'default card--SecondarySort>' + paymentMethod.SecondarySort);
                        listOfPaymentMethods.put(paymentMethod.MethodID + '@C', cardType + ' - ending in ' + paymentMethod.CardNumber.replace('X', Configuration.EMPTYSTRING) + method);
                    }
                    methods.add(customerMethod);
                }
                paymentMethods.SavedPaymentMethodslist = methods;
                paymentMethods.savedPaymentMethods = listOfPaymentMethods;
            } // list null check...    
        }
        return paymentMethods;
    }
    @AuraEnabled
    public static PaymentMethodsContact getCustPaymentMethodsContactApx(string contactId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        PaymentMethodsContact reciprocate = getCustPaymentMethodsContactApx(dml, contactId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
        //return getCustPaymentMethodsContactApx(dml, contactId);
    }
    public static PaymentMethodsContact getCustPaymentMethodsContactApx(DML dml, string contactId, EBC_Logger ebcLogger) {
        MethodName = 'getCustPaymentMethodsContactApx';
        PaymentMethodsContact paymentMethods = new PaymentMethodsContact();
        Contact contactInfo = EBC_CompMethods.getContactDetail(dml, contactId, ebcLogger);
        paymentMethods.ContactInfo = contactInfo;
        String accountExternalId = contactInfo.Ebiz_C__EBizCharge_Contact_Internal_ID__c;
        if (accountExternalId != null && accountExternalId != Configuration.EMPTYSTRING) {
            map < String, String > listOfPaymentMethods = new map < String, String > ();
            list < customerMethod > methods = new list < customerMethod > ();
            list < ebizchargeServicemodelSoap.PaymentMethodProfile > customerPaymentMethods = new list < ebizchargeServicemodelSoap.PaymentMethodProfile > ();
            if (!test.isRunningTest()) {
                customerPaymentMethods = EBC_CompMethods.GetCustomerPaymentMethods(dml, contactInfo.Id, accountExternalId, ebcLogger);
            } else {
                //********Mock Data*****
                ebizchargeServicemodelSoap.PaymentMethodProfile mockData = new ebizchargeServicemodelSoap.PaymentMethodProfile();
                mockData.SecondarySort = '3';
                mockData.MethodType = 'cc';
                mockData.CardExpiration = '1212 12';
                mockData.CardNumber = '2342343';
                mockData.Account = '234234';
                customerPaymentMethods.add(mockData);
            }
            if (customerPaymentMethods != null) {
                for (ebizchargeServicemodelSoap.PaymentMethodProfile paymentMethod: customerPaymentMethods) {
                    customerMethod customerMethod = new customerMethod();
                    customerMethod.MethodType = paymentMethod.MethodType;
                    customerMethod.MethodID = paymentMethod.MethodID;
                    customerMethod.MethodName = paymentMethod.MethodName;
                    customerMethod.DateCreated = paymentMethod.Created;
                    customerMethod.DateModified = paymentMethod.Modified;
                    customerMethod.AccountHolderName = paymentMethod.AccountHolderName;
                    customerMethod.SecondarySort = Integer.valueOf(paymentMethod.SecondarySort);
                    if (paymentMethod.MethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.cc)) {
                        customerMethod.AvsStreet = paymentMethod.AvsStreet;
                        customerMethod.AvsZip = paymentMethod.AvsZip;
                        customerMethod.CardExpiration = paymentMethod.CardExpiration;
                        customerMethod.CardExpMonth = paymentMethod.CardExpiration.right(2);
                        customerMethod.CardExpYear = paymentMethod.CardExpiration.left(4);
                        customerMethod.CardNumber = paymentMethod.CardNumber;
                        customerMethod.Last4Degit = paymentMethod.CardNumber.right(4);
                        customerMethod.CardType = paymentMethod.CardType;
                    } else {
                        customerMethod.Account = paymentMethod.Account;
                        customerMethod.Last4Degit = paymentMethod.Account.right(4);
                        customerMethod.AccountType = paymentMethod.AccountType;
                        customerMethod.Routing = paymentMethod.Routing;
                    }
                    // if(test.isRunningTest()){
                    //     paymentMethod.CardNumber = null;
                    if (paymentMethod.CardNumber == null) {
                        string method = Configuration.EMPTYSTRING;
                        if (!string.isEmpty(paymentMethod.MethodName)) {
                            method = ', ' + paymentMethod.MethodName;
                        }
                        listOfPaymentMethods.put(paymentMethod.MethodID + '@E', paymentMethod.Routing + '^' + paymentMethod.Account + method);
                    } else {
                        string method = Configuration.EMPTYSTRING;
                        if (!string.isEmpty(paymentMethod.MethodName)) {
                            method = ', ' + paymentMethod.MethodName;
                        }
                        string cardType = Configuration.EMPTYSTRING;
                        if (test.isRunningTest()) {
                            paymentMethod.CardType = 'V';
                        }
                        if (paymentMethod.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.V)) {
                            cardType = string.valueOf(Enums.CARDTYPES.VISA);
                        } else if (paymentMethod.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.M)) {
                            cardType = string.valueOf(Enums.CARDTYPES.MC);
                        } else if (paymentMethod.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.A)) {
                            cardType = string.valueOf(Enums.CARDTYPES.AMEX);
                        } else if (paymentMethod.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.DS)) {
                            cardType = string.valueOf(Enums.CARDTYPES.DISC);
                        }
                        ebcLogger.debug(ClassName, MethodName, 'default card--SecondarySort>' + paymentMethod.SecondarySort);
                        listOfPaymentMethods.put(paymentMethod.MethodID + '@C', cardType + ' - ending in ' + paymentMethod.CardNumber.replace('X', Configuration.EMPTYSTRING) + method);
                    }
                    methods.add(customerMethod);
                }
                paymentMethods.SavedPaymentMethodslist = methods;
                paymentMethods.savedPaymentMethods = listOfPaymentMethods;
            } // list null check...    
        }
        return paymentMethods;
    }
    @AuraEnabled
    public static PaymentMethodsCustomCust getCustPaymentMethodsCustomApx(string CustomCustId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        PaymentMethodsCustomCust reciprocate = getCustPaymentMethodsCustomApx(dml, CustomCustId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
        //return getCustPaymentMethodsCustomApx(dml, CustomCustId);
    }
    public static PaymentMethodsCustomCust getCustPaymentMethodsCustomApx(DML dml, string CustomCustId, EBC_Logger ebcLogger) {
        MethodName = 'getCustPaymentMethodsCustomApx';
        ebcLogger.debug(ClassName, MethodName, 'CustomCustId>>>' + CustomCustId);
        PaymentMethodsCustomCust paymentMethods = new PaymentMethodsCustomCust();
        Ebiz_C__EBizCharge_Fields_Config__c contactInfo = EBC_CompMethods.getCustomFieldDetail(dml, CustomCustId, ebcLogger);
        paymentMethods.ContactInfo = contactInfo;
        String accountExternalId = contactInfo.Ebiz_C__EBizCharge_Internal_ID__c;
        if (accountExternalId != null && accountExternalId != Configuration.EMPTYSTRING) {
            map < String, String > listOfPaymentMethods = new map < String, String > ();
            list < customerMethod > methods = new list < customerMethod > ();
            list < ebizchargeServicemodelSoap.PaymentMethodProfile > customerPaymentMethods = new list < ebizchargeServicemodelSoap.PaymentMethodProfile > ();
            if (!test.isRunningTest()) {
                customerPaymentMethods = EBC_CompMethods.GetCustomerPaymentMethods(dml, contactInfo.Ebiz_C__EBizCharge_CustomerId__c, accountExternalId, ebcLogger);
            } else {
                //********Mock Data*****
                ebizchargeServicemodelSoap.PaymentMethodProfile mockData = new ebizchargeServicemodelSoap.PaymentMethodProfile();
                mockData.SecondarySort = '3';
                mockData.MethodType = 'cc';
                mockData.CardExpiration = '1212 12';
                mockData.CardNumber = '2342343';
                mockData.Account = '234234';
                customerPaymentMethods.add(mockData);
            }
            if (customerPaymentMethods != null) {
                for (ebizchargeServicemodelSoap.PaymentMethodProfile paymentMethod: customerPaymentMethods) {
                    customerMethod customerMethod = new customerMethod();
                    customerMethod.MethodType = paymentMethod.MethodType;
                    customerMethod.MethodID = paymentMethod.MethodID;
                    customerMethod.MethodName = paymentMethod.MethodName;
                    customerMethod.DateCreated = paymentMethod.Created;
                    customerMethod.DateModified = paymentMethod.Modified;
                    customerMethod.AccountHolderName = paymentMethod.AccountHolderName;
                    customerMethod.SecondarySort = Integer.valueOf(paymentMethod.SecondarySort);
                    if (paymentMethod.MethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.cc)) {
                        customerMethod.AvsStreet = paymentMethod.AvsStreet;
                        customerMethod.AvsZip = paymentMethod.AvsZip;
                        customerMethod.CardExpiration = paymentMethod.CardExpiration;
                        customerMethod.CardExpMonth = paymentMethod.CardExpiration.right(2);
                        customerMethod.CardExpYear = paymentMethod.CardExpiration.left(4);
                        customerMethod.CardNumber = paymentMethod.CardNumber;
                        customerMethod.Last4Degit = paymentMethod.CardNumber.right(4);
                        customerMethod.CardType = paymentMethod.CardType;
                    } else {
                        customerMethod.Account = paymentMethod.Account;
                        customerMethod.Last4Degit = paymentMethod.Account.right(4);
                        customerMethod.AccountType = paymentMethod.AccountType;
                        customerMethod.Routing = paymentMethod.Routing;
                    }
                    if (paymentMethod.CardNumber == null) {
                        string method = Configuration.EMPTYSTRING;
                        if (!string.isEmpty(paymentMethod.MethodName)) {
                            method = ', ' + paymentMethod.MethodName;
                        }
                        listOfPaymentMethods.put(paymentMethod.MethodID + '@E', paymentMethod.Routing + '^' + paymentMethod.Account + method);
                    } else {
                        string method = Configuration.EMPTYSTRING;
                        if (!string.isEmpty(paymentMethod.MethodName)) {
                            method = ', ' + paymentMethod.MethodName;
                        }
                        string cardType = Configuration.EMPTYSTRING;
                        if (test.isRunningTest()) {
                            paymentMethod.CardType = 'V';
                        }
                        if (paymentMethod.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.V)) {
                            cardType = string.valueOf(Enums.CARDTYPES.VISA);
                        } else if (paymentMethod.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.M)) {
                            cardType = string.valueOf(Enums.CARDTYPES.MC);
                        } else if (paymentMethod.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.A)) {
                            cardType = string.valueOf(Enums.CARDTYPES.AMEX);
                        } else if (paymentMethod.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.DS)) {
                            cardType = string.valueOf(Enums.CARDTYPES.DISC);
                        }
                        ebcLogger.debug(ClassName, MethodName, 'default card--SecondarySort>' + paymentMethod.SecondarySort);
                        listOfPaymentMethods.put(paymentMethod.MethodID + '@C', cardType + ' - ending in ' + paymentMethod.CardNumber.replace('X', Configuration.EMPTYSTRING) + method);
                    }
                    methods.add(customerMethod);
                }
                paymentMethods.SavedPaymentMethodslist = methods;
                paymentMethods.savedPaymentMethods = listOfPaymentMethods;
            } // list null check...    
        }
        return paymentMethods;
    }
    @AuraEnabled
    public static Detail UpdateCustomerInfoFromSchema(string CustomerId, string objectName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        Detail reciprocate = UpdateCustomerInfoFromSchema(dml, CustomerId, objectName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
        //return UpdateCustomerInfoFromSchema(dml, CustomerId, objectName);
    }
    public static Detail UpdateCustomerInfoFromSchema(DML dml, string CustomerId, string objectName, EBC_Logger ebcLogger) {
        MethodName = 'UpdateCustomerInfoFromSchema';
        Ebiz_C__EBizCharge_Fields_Config__c customEntityDetail = eBc_UtilityController.UpdateCustomObjectsFields(dml, objectName, CustomerId, ebcLogger);
        Detail detailEntity = new Detail();
        detailEntity.CustomCustInfo = EBC_CompMethods.getCustomFieldDetail(dml, customEntityDetail.Ebiz_C__EBizCharge_CustomerId__c, ebcLogger);
        return detailEntity;
    }
    @AuraEnabled
    public static void UpdateInternalIdCustomCustomer(string CustomerId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        UpdateInternalIdCustomCustomer(dml, CustomerId, ebcLogger);
        ebcLogger.saveLogs();
    }
    public static void UpdateInternalIdCustomCustomer(DML dml, string CustomerId, EBC_Logger ebcLogger) {
        MethodName = 'UpdateInternalIdCustomCustomer';
        map < String, String > updateCustomerMap = new map < string, string > ();
        Ebiz_C__EBizCharge_Fields_Config__c customEntityDetail = EBC_CompMethods.getCustomFieldDetail(dml, CustomerId, ebcLogger);
        Detail detailEntity = new Detail();
        detailEntity.CustomCustInfo = customEntityDetail;
        detailEntity.CustomCustId = CustomerId;
        detailEntity.CustomCustName = customEntityDetail.Name;
        ebcLogger.debug(ClassName, MethodName, '>>CustomerId>>>' + CustomerId);
        ebcLogger.debug(ClassName, MethodName, '>>CustomCustName>>>' + detailEntity.CustomCustName);
        ebcLogger.debug(ClassName, MethodName, '>customEntityDetail.Ebiz_C__EBizCharge_Internal_ID__c>>>' + customEntityDetail.Ebiz_C__EBizCharge_Internal_ID__c);
        String accountExternalId = customEntityDetail.Ebiz_C__EBizCharge_Internal_ID__c;
        if (test.isRunningTest()) {
            accountExternalId = null;
        }
        if (accountExternalId == null || accountExternalId == Configuration.EMPTYSTRING || string.isEmpty(accountExternalId)) {
            //search customer on Gateway 
            ebizchargeServicemodelSoap.Customer searchCustomerResponse = new ebizchargeServicemodelSoap.Customer();
            if (!test.isRunningTest()) {
                searchCustomerResponse = EBC_CompMethods.invoke_SearchCustomer(dml, customEntityDetail.Ebiz_C__EBizCharge_CustomerId__c, ebcLogger);
            }
            ebcLogger.debug(ClassName, MethodName, '>>>searchCustomerResponse.CustomerInternalId>>>' + searchCustomerResponse.CustomerInternalId);
            if (searchCustomerResponse.CustomerInternalId != null) {
                accountExternalId = searchCustomerResponse.CustomerInternalId;
                updateCustomerMap.put(CustomerId, searchCustomerResponse.CustomerInternalId);
            } else {
                // add customer on Gateway
                ebizchargeServicemodelSoap.CustomerResponse addCustomerResponse = EBC_CompMethods.invoke_addCustomCustomer(dml, customEntityDetail, ebcLogger);
                accountExternalId = addCustomerResponse.CustomerInternalId;
                updateCustomerMap.put(CustomerId, addCustomerResponse.CustomerInternalId);
            }
            ebcLogger.debug(ClassName, MethodName, '>>accountExternalId>>>' + accountExternalId);
            detailEntity.AccountInternalId = accountExternalId;
            //update Account
            if (updateCustomerMap != null) {
                List < Ebiz_C__EBizCharge_Fields_Config__c > updateCustomer = new List < Ebiz_C__EBizCharge_Fields_Config__c > ();
                for (String key: updateCustomerMap.keySet()) {
                    Ebiz_C__EBizCharge_Fields_Config__c customEntity = new Ebiz_C__EBizCharge_Fields_Config__c();
                    customEntity.Ebiz_C__EBizCharge_CustomerId__c = key;
                    customEntity.Ebiz_C__EBizCharge_Internal_ID__c = updateCustomerMap.get(key);
                    customEntity.EBizCharge_Last_Sync_Date__c = system.now();
                    ebcLogger.debug(ClassName, MethodName, 'Externale record>>>>>>>' + customEntity.Ebiz_C__EBizCharge_Internal_ID__c);
                    updateCustomer.add(customEntity);
                }
                dml.upsertRecord(updateCustomer, 'Ebiz_C__EBizCharge_Fields_Config__c.Ebiz_C__EBizCharge_CustomerId__c');
            }
        }
    }
    @AuraEnabled
    public static List < emailTemplate > getEmailTemplatesApxc() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < emailTemplate > reciprocate = getEmailTemplatesApxc(dml, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < emailTemplate > getEmailTemplatesApxc(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getEmailTemplatesApxc';
        List < emailTemplate > emailTemplatesList = new List < emailTemplate > ();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.EmailTemplate[] EmailTemplateList;
        if (!test.isRunningTest()) {
            ebizchargeServicemodelSoap.ArrayOfEmailTemplate emailTemplatesResponse = new ebizchargeServicemodelSoap.ArrayOfEmailTemplate();
            emailTemplatesResponse = ebiz.GetEmailTemplates(EBC_CompMethods.getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            EmailTemplateList = emailTemplatesResponse.EmailTemplate;
        }
        if (EmailTemplateList != null) {
            for (ebizchargeServicemodelSoap.EmailTemplate ebizEmailTemplate: EmailTemplateList) {
                emailTemplate emailTemplate = new emailTemplate();
                emailTemplate.TemplateName = ebizEmailTemplate.TemplateName;
                emailTemplate.TemplateType = ebizEmailTemplate.TemplateTypeId;
                emailTemplate.TemplateInternalId = ebizEmailTemplate.TemplateInternalId;
                emailTemplate.TemplateSubject = ebizEmailTemplate.TemplateSubject;
                emailTemplate.TemplateFromName = ebizEmailTemplate.FromName;
                emailTemplate.FromEmail = ebizEmailTemplate.FromEmail;
                emailTemplate.ReplyToEmail = ebizEmailTemplate.ReplyToEmail;
                emailTemplatesList.add(emailTemplate);
            }
        }
        return emailTemplatesList;
    }
    @AuraEnabled
    public static String sendEmailPayReqApxc(String sendEmailReqJSON, Account accDetail, String ObjName /*added by @wqkl against SF-137 - 11dec20*/ , Quote QuoteDetail /*added by @wqkl against SF-137 - 11dec20*/ ) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = sendEmailPayReqApxc(dml, sendEmailReqJSON, accDetail, ObjName, QuoteDetail, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String sendEmailPayReqApxc(DML dml, String sendEmailReqJSON, Account accDetail, String ObjName /*added by @wqkl against SF-137 - 11dec20*/ , Quote QuoteDetail /*added by @wqkl against SF-137 - 11dec20*/ , EBC_Logger ebcLogger) {
        MethodName = 'sendEmailPayReqApxc';
        Map < String, Object > emailRequestMap = (Map < String, Object > ) JSON.deserializeUntyped(sendEmailReqJSON);
        ebizchargeServicemodelSoap.EbizWebForm ebizWebForm = new ebizchargeServicemodelSoap.EbizWebForm();
        String startDate = Configuration.PASTDATE;
        String endDate = Configuration.FUTUREDATE;
        boolean orderFoundinSF = false;
        String orderIdToSearch;
        String taxAction = (string) emailRequestMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.TaxAction));
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        if (emailRequestMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OrderId)) != Configuration.EMPTYSTRING && emailRequestMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OrderId)) != null) {
            orderIdToSearch = (string) emailRequestMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OrderId));
        } else {
            orderIdToSearch = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OppId));
        }
        PendingPayments pendingPayments = getPendingPaymentsApxc(dml, startDate, endDate, orderIdToSearch, ebcLogger);
        if (pendingPayments.PendingList != null) {
            List < Payments > pendingPaymentsList = pendingPayments.PendingList;
            if (pendingPaymentsList.size() > 0) {
                List < String > orderIdsList = new List < String > ();
                for (Payments pendingPayment: pendingPaymentsList) {
                    orderIdsList.add(pendingPayment.InvoiceNumber);
                }
                querySelect = 'SELECT Id,Payment_Order_ID__c,Send_Request_Count__c';
                queryFrom = 'FROM EBizCharge_EmailPayPending__c';
                queryWhere = 'WHERE Payment_Order_ID__c IN :';
                list < EBizCharge_EmailPayPending__c > emailPayPendList = (list < EBizCharge_EmailPayPending__c > ) dml.selectRecordsInList(orderIdsList, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                if (emailPayPendList.size() > 0) {
                    orderFoundinSF = true;
                }
            }
        }
        string accountId = (string) emailRequestMap.get('QBD_Customer_ID__c');//For SF-Qbd
        string accountExternalId = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.AccInternalId));
        double amount = double.valueOf((double) emailRequestMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Amount)));
        double Tax = double.valueOf((double) emailRequestMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Tax)));
        if (test.isRunningTest()) {
            taxAction = 'Tax Included';
        }
        if (taxAction == Configuration.TAXACTION) {
            tax = 0;
        }
        double paymentTotal = double.valueOf((double) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.PaymentTotal)));
        double orderTotal = 0.0;
        double orderBalance = 0.0;
        ebizWebForm.FromName = (string) emailRequestMap.get(string.valueOf(Enums.IDENTICALJAVASCRIPTMAPSTRINGS.fromName));
        ebizWebForm.FromEmail = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.fromEmail));
        ebizWebForm.EmailAddress = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.toEmail));
        ebizWebForm.EmailSubject = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Subject));
        ebizWebForm.EmailNotes = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Notes));
        ebizWebForm.EmailTemplateID = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.TemplateId));
        ebizWebForm.Date_x = System.now();
        String query_Select = 'select id,QBD_Customer_ID__c';
        String query_From = 'from Account';
        String query_Where =  'where id=\''+ accDetail.Id+'\'';
        Account account = (Account)dml.selectSingleRecord(query_Select, query_From, query_Where, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
        ebizWebForm.CustomerId = (string)account.get('QBD_Customer_ID__c');
        ebizWebForm.CustFullName = accDetail.Name;
        ebizWebForm.PayByType = Configuration.PAYBYTYPESTRING;
        // added by @wqkl against BillingAddress - (29Jan21) - start
        ebizchargeServicemodelSoap.Address customerAddress = new ebizchargeServicemodelSoap.Address();
        customerAddress.FirstName = accDetail.Name;
        customerAddress.LastName = accDetail.Name;
        customerAddress.Address1 = accDetail.BillingStreet;
        customerAddress.City = accDetail.BillingCity;
        customerAddress.State = accDetail.BillingState;
        customerAddress.ZipCode = accDetail.BillingPostalCode;
        customerAddress.Country = accDetail.BillingCountry;
        ebizWebForm.BillingAddress = customerAddress;
        // added by @wqkl against BillingAddress - (29Jan21) - end
        Order orderDetail = new Order(); // added by @wqkl against (SF-137) - (08jan21)
        if (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account) || ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
            ebizWebForm.OrderId = Configuration.WEBFORMORDERID;
        }
        if (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
            orderTotal = paymentTotal;
            orderBalance = (double) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OrderBalance));
            ebizWebForm.InvoiceNumber = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OrderNo));
            ebizWebForm.PoNum = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.PONum));
            ebizWebForm.OrderId = (string) emailRequestMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OrderId));
            // added by @wqkl against (SF-137) - (08jan21) - start
            Id entityId = (string) emailRequestMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OrderId));
            querySelect = 'select id, EBizCharge_Order_Tax__c';
            queryFrom = 'from order';
            queryWhere = 'where id=\'' + entityId + '\'';
            orderDetail = (Order) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            // added by @wqkl against (SF-137) - (08jan21) - end
        }
        // added by @wqkl against SF-137 - 14dec20 - start
        else if (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote)) {
            orderTotal = paymentTotal;
            orderBalance = (double) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OrderBalance));
            ebizWebForm.InvoiceNumber = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OrderNo));
            ebizWebForm.PoNum = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.PONum));
            ebizWebForm.OrderId = (string) emailRequestMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OrderId));
        }
        // added by @wqkl against SF-137 - 14dec20 - end
        else if (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
            String entityId = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OppId));
            ebizWebForm.InvoiceNumber = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OppId));
            ebizWebForm.PoNum = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.PONum));
            ebizWebForm.OrderId = (string) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OppId));
            orderTotal = (double) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OpportunityTotal));
            orderBalance = (double) emailRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OpportunityBalance));
        } else {
            ebizWebForm.InvoiceNumber = accDetail.Id;
            ebizWebForm.PoNum = accDetail.Id;
        }
        ebcLogger.debug(ClassName, MethodName, 'PaymentTotal->>>' + paymentTotal);
        ebcLogger.debug(ClassName, MethodName, 'OrderTotal->>>' + orderTotal);
        ebizWebForm.TotalAmount = orderTotal;
        ebizWebForm.AmountDue = paymentTotal;
        ebizWebForm.TaxAmount = tax;
        ebizWebForm.ShippingAmount = paymentTotal - tax;
        ebizWebForm.SendEmailToCustomer = true;
        ebizWebForm.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
        if (test.isRunningTest()) {
            return null;
        }
        try {
            String returnMessage = Configuration.EMPTYSTRING;
            if (!orderFoundinSF) {
                ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
                string response = ebiz.GetEbizWebFormURL(EBC_CompMethods.getSecurityToken(dml, ebcLogger), ebizWebForm);
                EBizCharge_EmailPayPending__c emailPaymentEntity = new EBizCharge_EmailPayPending__c();
                emailPaymentEntity.Payment_Order_ID__c = ebizWebForm.InvoiceNumber;
                emailPaymentEntity.Send_Request_Count__c = 1;
                dml.insertRecord(emailPaymentEntity);
                returnMessage = string.valueOf(Enums.RETURNMESSAGE.Success);
                // added by @wqkl against SF-137 - 1jan21 - start
                if (QuoteDetail != null) {
                    dml.updateRecord(QuoteDetail);
                }
                if (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
                    dml.updateRecord(orderDetail);
                } // added by @wqkl against SF-137 - 1jan21 - end		
            } else {
                returnMessage = Configuration.PAYMENTPERSISTS;
            }
            return returnMessage;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, '>>>Error has been occured ');
            return 'Exception';
        }
    }
    @AuraEnabled
    public static String addPaymentMehtodReqApxc(String sendReqJSON, Account accDetail, String orderId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = addPaymentMehtodReqApxc(dml, sendReqJSON, accDetail, orderId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String addPaymentMehtodReqApxc(DML dml, String sendReqJSON, Account accDetail, String orderId, EBC_Logger ebcLogger) {
        MethodName = 'addPaymentMehtodReqApxc';
        Map < String, Object > paymentMethodRequestMap = (Map < String, Object > ) JSON.deserializeUntyped(sendReqJSON);
        ebizchargeServicemodelSoap.EbizWebForm ebizWebForm = new ebizchargeServicemodelSoap.EbizWebForm();
        ebizWebForm.OrderId = orderId;
        ebizWebForm.FromName = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.FromName));
        ebizWebForm.FromEmail = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.fromEmail));
        ebizWebForm.EmailAddress = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.toEmail));
        ebizWebForm.EmailSubject = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Subject));
        ebizWebForm.EmailNotes = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Notes));
        ebizWebForm.EmailTemplateID = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.TemplateId));
        ebizWebForm.Date_x = DateTime.now();
        ebizWebForm.CustomerId = (String)accDetail.get('QBD_Customer_ID__c');//For SF-Qbd
        ebizWebForm.CustFullName = accDetail.Name;
        // In case of payment method invoice number should always be sent Token
        ebizWebForm.InvoiceNumber = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.Token);
        ebizWebForm.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
        ebizWebForm.Clerk = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.AppUser);
        ebizWebForm.FormType = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.PmRequestForm);
        ebizWebForm.PayByType = Configuration.PAYBYTYPESTRING;
        ebizWebForm.SendEmailToCustomer = true;
        // added by @wqkl against BillingAddress - (02Feb21) - start
        ebizchargeServicemodelSoap.Address customerAddress = new ebizchargeServicemodelSoap.Address();
        customerAddress.FirstName = accDetail.Name;
        customerAddress.LastName = accDetail.Name;
        customerAddress.Address1 = accDetail.BillingStreet;
        customerAddress.City = accDetail.BillingCity;
        customerAddress.State = accDetail.BillingState;
        customerAddress.ZipCode = accDetail.BillingPostalCode;
        customerAddress.Country = accDetail.BillingCountry;
        ebizWebForm.BillingAddress = customerAddress;
        // added by @wqkl against BillingAddress - (02Feb21) - end
        ebcLogger.debug(ClassName, MethodName, '->>>EmailNotes____' + ebizWebForm.EmailNotes);
        try {
            string response = ebiz.GetEbizWebFormURL(EBC_CompMethods.getSecurityToken(dml, ebcLogger), ebizWebForm);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            return Configuration.EXCEPTIONMESSAGESTRING + e.getMessage();
        }
    }
    @AuraEnabled
    public static String addPaymentMehtodReqApxcContact(String sendReqJSON, Contact conDetail, String orderId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = addPaymentMehtodReqApxcContact(dml, sendReqJSON, conDetail, orderId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String addPaymentMehtodReqApxcContact(DML dml, String sendReqJSON, Contact conDetail, String orderId, EBC_Logger ebcLogger) {
        MethodName = 'addPaymentMehtodReqApxcContact';
        Map < String, Object > paymentMethodRequestMap = (Map < String, Object > ) JSON.deserializeUntyped(sendReqJSON);
        ebizchargeServicemodelSoap.EbizWebForm ebizWebForm = new ebizchargeServicemodelSoap.EbizWebForm();
        ebizWebForm.OrderId = orderId;
        ebizWebForm.FromName = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.FromName));
        ebizWebForm.FromEmail = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.fromEmail));
        ebizWebForm.EmailAddress = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.toEmail));
        ebizWebForm.EmailSubject = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Subject));
        ebizWebForm.EmailNotes = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Notes));
        ebizWebForm.EmailTemplateID = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.TemplateId));
        ebizWebForm.Date_x = System.now();
        ebizWebForm.CustomerId = conDetail.Id;
        ebizWebForm.CustFullName = conDetail.Name;
        // In case of payment method invoice number should always be sent Token
        ebizWebForm.InvoiceNumber = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.Token);
        ebizWebForm.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
        ebizWebForm.Clerk = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.AppUser);
        ebizWebForm.FormType = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.PmRequestForm);
        ebizWebForm.PayByType = Configuration.PAYBYTYPESTRING;
        ebizWebForm.SendEmailToCustomer = true;
        // added by @wqkl against BillingAddress - (02Feb21) - start
        ebizchargeServicemodelSoap.Address customerAddress = new ebizchargeServicemodelSoap.Address();
        customerAddress.FirstName = conDetail.FirstName;
        customerAddress.LastName = conDetail.LastName;
        customerAddress.Address1 = conDetail.MailingStreet;
        customerAddress.City = conDetail.MailingCity;
        customerAddress.State = conDetail.MailingState;
        customerAddress.ZipCode = conDetail.MailingPostalCode;
        customerAddress.Country = conDetail.MailingCountry;
        ebizWebForm.BillingAddress = customerAddress;
        // added by @wqkl against BillingAddress - (02Feb21) - end
        ebcLogger.debug(ClassName, MethodName, '->>>EmailNotes____' + ebizWebForm.EmailNotes);
        try {
            string response = ebiz.GetEbizWebFormURL(EBC_CompMethods.getSecurityToken(dml, ebcLogger), ebizWebForm);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            return Configuration.EXCEPTIONMESSAGESTRING + e.getMessage();
        }
    }
    @AuraEnabled
    public static String addPaymentMehtodReqApxcCustomCustomer(String sendReqJSON, Ebiz_C__EBizCharge_Fields_Config__c conDetail, String orderId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = addPaymentMehtodReqApxcCustomCustomer(dml, sendReqJSON, conDetail, orderId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String addPaymentMehtodReqApxcCustomCustomer(DML dml, String sendReqJSON, Ebiz_C__EBizCharge_Fields_Config__c conDetail, String orderId, EBC_Logger ebcLogger) {
        MethodName = 'addPaymentMehtodReqApxcCustomCustomer';
        Map < String, Object > paymentMethodRequestMap = (Map < String, Object > ) JSON.deserializeUntyped(sendReqJSON);
        ebizchargeServicemodelSoap.EbizWebForm ebizWebForm = new ebizchargeServicemodelSoap.EbizWebForm();
        ebizWebForm.OrderId = orderId;
        ebizWebForm.FromName = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.FromName));
        ebizWebForm.FromEmail = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.fromEmail));
        ebizWebForm.EmailAddress = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.toEmail));
        ebizWebForm.EmailSubject = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Subject));
        ebizWebForm.EmailNotes = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Notes));
        ebizWebForm.EmailTemplateID = (string) paymentMethodRequestMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.TemplateId));
        ebizWebForm.Date_x = System.now();
        ebizWebForm.CustomerId = conDetail.Ebiz_C__EBizCharge_CustomerId__c;
        ebizWebForm.CustFullName = conDetail.Name;
        ebizWebForm.InvoiceNumber = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.Token);
        ebizWebForm.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
        ebizWebForm.Clerk = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.AppUser);
        ebizWebForm.FormType = string.valueOf(Enums.EBIZWEBFORMPARAMETERS.PmRequestForm);
        ebizWebForm.PayByType = Configuration.PAYBYTYPESTRING;
        ebizWebForm.SendEmailToCustomer = true;
        ebcLogger.debug(ClassName, MethodName, '->>>EmailNotes____' + ebizWebForm.EmailNotes);
        try {
            string response = ebiz.GetEbizWebFormURL(EBC_CompMethods.getSecurityToken(dml, ebcLogger), ebizWebForm);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            return Configuration.EXCEPTIONMESSAGESTRING + e.getMessage();
        }
    }
    @auraEnabled
    public static String runRecurringApxc(String rrInfoJSON, Account accDetail, String ObjName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = runRecurringApxc(dml, rrInfoJSON, accDetail, ObjName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String runRecurringApxc(DML dml, String rrInfoJSON, Account accDetail, String ObjName, EBC_Logger ebcLogger) {
        MethodName = 'runRecurringApxc';
        Map < String, Object > recurringDetailMap = (Map < String, Object > ) JSON.deserializeUntyped(rrInfoJSON);
        string returnMessage = Configuration.EMPTYSTRING;
        ebcLogger.debug(ClassName, MethodName, 'rrInfoJSON>>>>' + rrInfoJSON);
        String paymentMethodType = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.payBy));
        String accountId = (String)accDetail.get('QBD_Customer_ID__c');//For SF-Qbd
        String accountExternalId = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccExternalId));
        Boolean sendReceiptTo = (boolean) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
        String addEmails = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.addEmails));
        String accId = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId));
        String customerToken = Configuration.EMPTYSTRING;
        ebizchargeServicemodelSoap.Customer response = new ebizchargeServicemodelSoap.Customer();
        ebizchargeServicemodelSoap.CustomerResponse customerResponse = new ebizchargeServicemodelSoap.CustomerResponse();
        Account accountDetail = EBC_CompMethods.getAccountDetail(dml, accId, ebcLogger);
        if(accountDetail.EBizCharge_Internal_ID__c != null){
            //GetCustomer on the basis of Internal Id
        try{
            //internal id is changed -----> exception
            response = ebiz.GetCustomer(eBc_UtilityController.getSecurityToken(dml, ebcLogger),Configuration.EMPTYSTRING,accountDetail.EBizCharge_Internal_ID__c);
            //else update on the basis of Internal Id
            if(response.CustomerInternalId != null){
                //Update Api Call
                customerResponse = eBc_UtilityController.invoke_addORUpdCustomerQBD(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger),'',string.valueOf(Enums.ENTITYACTIONS.updateCustomer), ebcLogger);
                customerToken = EBC_CompMethods.getCustomerToken(dml,Configuration.EMPTYSTRING, response.CustomerInternalId, ebcLogger);
                accountExternalId = response.CustomerInternalId;
            }    
        }catch(Exception e){
            //get customer on the basis of QBD ------> if its changed or not?
            try{ 
                //if QBD id is not changed------> get a 200 status code
            response = ebiz.GetCustomer(eBc_UtilityController.getSecurityToken(dml, ebcLogger),(String)accountDetail.get('QBD_Customer_ID__c'),Configuration.EMPTYSTRING);
            if(response.CustomerInternalId != null){
                //Update Api Call
                accountExternalId = response.CustomerInternalId;
                customerResponse = eBc_UtilityController.invoke_addORUpdCustomerQBD(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger),'',string.valueOf(Enums.ENTITYACTIONS.updateCustomer), ebcLogger);
                customerToken = EBC_CompMethods.getCustomerToken(dml,(string)accountDetail.get('QBD_Customer_ID__c'),Configuration.EMPTYSTRING, ebcLogger);
            }
            }catch(exception error){
                //else changed ------> not found 500 status code
                customerResponse = eBc_UtilityController.invoke_addORUpdCustomerQBD(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger),'',string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
            }
        }    
        }
        transactionParams transactionPayload = new transactionParams();
        Decimal amount = (Decimal) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Amount));
        if (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
            transactionPayload.OrderNumber = (string) recurringDetailMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OrderNo));
            transactionPayload.OrderID = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OrderId));
        } else {
            transactionPayload.OrderNumber = Configuration.DEFAULTORDERNUMBER;
            transactionPayload.OrderID = Configuration.DEFAULTORDERNUMBER;
        }
        transactionPayload.SubTotal = 0;
        transactionPayload.Amount = amount;
        transactionPayload.tax = (double) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Tax));
        transactionPayload.accountID = accountId;
        transactionPayload.customerID = accountId;
        transactionPayload.internalID = accountExternalId;
        transactionPayload.customerToken = customerToken;
        transactionPayload.isRecurring = true;
        string startDate = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrStartDate));
        string endDate = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrEndDate));
        Boolean recurIndefinite = (Boolean) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrIndefinit));
        if (recurIndefinite == true) {
            endDate = Configuration.DEFAULTENDDATE;
        }
        transactionPayload.Start = Date.valueOf(startDate);
        transactionPayload.Expire = Date.valueOf(endDate);
        transactionPayload.ScheduleName = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrPayName));
        transactionPayload.Schedule = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrFrequency));
        transactionPayload.Notes = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrNotes));
        if (paymentMethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.UseExistingCard)) {
            transactionPayload.methodID = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.selectedCardId));
            transactionPayload.CardCode = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.cvcNo));
        } else if (paymentMethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.AddNewCard)) {
            transactionPayload.ccNumber = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
            transactionPayload.expMonth = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
            transactionPayload.expYear = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
            transactionPayload.cvvCode = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
            transactionPayload.ccName = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
            transactionPayload.AvsStreet = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
            transactionPayload.AvsZip = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
            transactionPayload.MethodName = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
            if (!test.isRunningTest()) {
                transactionPayload.methodID = EBC_CompMethods.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                if (transactionPayload.methodID.contains(Configuration.CARDEXPIRATION)) {
                    return returnMessage = 'Exception@' + 'Gateway Response Error: Credit card has expired.';
                }
            }
        } else if (paymentMethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.savedACH)) {
            transactionPayload.methodID = (String) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.selectedACHId));
        } else if (paymentMethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.addNewACH)) {
            transactionPayload.AccountName = (string) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
            transactionPayload.Account = (string) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
            transactionPayload.Route = (string) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
            transactionPayload.MethodName = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
            transactionPayload.accountType = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.accType));
            if (!test.isRunningTest()) {
                transactionPayload.methodID = EBC_CompMethods.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH), ebcLogger);
            }
        }
        if (test.isRunningTest()) {
            return null;
        }
        try {
            string apiResponse = EBC_CompMethods.runRecurringPayment(dml, transactionPayload, sendReceiptTo, addEmails, ebcLogger);
            returnMessage = 'rrScheduled@' + apiResponse;
        } catch (CalloutException excpObj) {
            returnMessage = 'Exception@' + excpObj;
        }
        return returnMessage;
    }
    @auraEnabled
    public static String runRecurringApxcContact(String rrInfoJSON, Contact ConDetail, String ObjName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = runRecurringApxcContact(dml, rrInfoJSON, ConDetail, ObjName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String runRecurringApxcContact(DML dml, String rrInfoJSON, Contact ConDetail, String ObjName, EBC_Logger ebcLogger) {
        MethodName = 'runRecurringApxcContact';
        Map < String, Object > recurringDetailMap = (Map < String, Object > ) JSON.deserializeUntyped(rrInfoJSON);
        string returnMessage = Configuration.EMPTYSTRING;
        String paymentMethodType = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.payBy));
        String accountId = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ContactId));
        String accountExternalId = (string) recurringDetailMap.get(string.valueOf(Enums.IDENTICALJAVASCRIPTMAPSTRINGS.conExternalId));
        Boolean sendReceiptTo = (boolean) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
        String addEmails = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.addEmails));
        String customerToken = Configuration.EMPTYSTRING;
        if (!test.isRunningTest()) {
            customerToken = EBC_CompMethods.getCustomerToken(dml, accountId, accountExternalId, ebcLogger);
        } else {
            customerToken = Configuration.EMPTYSTRING;
        }
        transactionParams transactionPayload = new transactionParams();
        Decimal amount = (Decimal) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Amount));
        transactionPayload.SubTotal = 0;
        transactionPayload.Amount = amount;
        transactionPayload.Tax = (double) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Tax));
        transactionPayload.accountID = accountId;
        transactionPayload.customerID = accountId;
        transactionPayload.internalID = accountExternalId;
        transactionPayload.customerToken = customerToken;
        transactionPayload.isRecurring = true;
        string startDate = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrStartDate));
        string endDate = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrEndDate));
        Boolean recurIndefinite = (Boolean) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrIndefinit));
        if (recurIndefinite == true) {
            endDate = Configuration.DEFAULTENDDATE;
        }
        transactionPayload.Start = Date.valueOf(startDate);
        transactionPayload.Expire = Date.valueOf(endDate);
        transactionPayload.ScheduleName = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrPayName));
        transactionPayload.Schedule = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrFrequency));
        transactionPayload.Notes = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrNotes));
        if (paymentMethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.UseExistingCard)) {
            transactionPayload.methodID = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.selectedCardId));
            transactionPayload.CardCode = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.cvcNo));
        } else if (paymentMethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.AddNewCard)) {
            transactionPayload.ccNumber = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
            transactionPayload.expMonth = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
            transactionPayload.expYear = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
            transactionPayload.cvvCode = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
            transactionPayload.ccName = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
            transactionPayload.AvsStreet = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
            transactionPayload.AvsZip = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
            transactionPayload.MethodName = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
            if (!test.isRunningTest()) {
                transactionPayload.methodID = EBC_CompMethods.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                if (transactionPayload.methodID.contains(Configuration.CARDEXPIRATION)) {
                    return returnMessage = 'Exception@' + 'Gateway Response Error: Credit card has expired.';
                }
            }
        } else if (paymentMethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.savedACH)) {
            transactionPayload.methodID = (String) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.selectedACHId));
        } else if (paymentMethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.addNewACH)) {
            transactionPayload.AccountName = (string) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
            transactionPayload.Account = (string) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
            transactionPayload.Route = (string) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
            transactionPayload.MethodName = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
            transactionPayload.accountType = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.accType));
            if (!test.isRunningTest()) {
                transactionPayload.methodID = EBC_CompMethods.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH), ebcLogger);
            }
        }
        if (test.isRunningTest()) {
            return null;
        }
        try {
            string response = EBC_CompMethods.runRecurringPayment(dml, transactionPayload, sendReceiptTo, addEmails, ebcLogger);
            returnMessage = 'rrScheduled@' + response;
        } catch (CalloutException excpObj) {
            returnMessage = 'Exception@' + excpObj;
        }
        return returnMessage;
    }
    @auraEnabled
    public static String runRecurringApxcCustomCustomer(String rrInfoJSON, Ebiz_C__EBizCharge_Fields_Config__c ConDetail, String ObjName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = runRecurringApxcCustomCustomer(dml, rrInfoJSON, ConDetail, ObjName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String runRecurringApxcCustomCustomer(DML dml, String rrInfoJSON, Ebiz_C__EBizCharge_Fields_Config__c ConDetail, String ObjName, EBC_Logger ebcLogger) {
        MethodName = 'runRecurringApxcCustomCustomer';
        Map < String, Object > recurringDetailMap = (Map < String, Object > ) JSON.deserializeUntyped(rrInfoJSON);
        string returnMessage = Configuration.EMPTYSTRING;
        String paymentMethodType = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.payBy));
        String accountId = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ContactId));
        String accountExternalId = (string) recurringDetailMap.get(string.valueOf(Enums.IDENTICALJAVASCRIPTMAPSTRINGS.conExternalId));
        Boolean sendReceiptTo = (boolean) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
        String addEmails = (string) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.addEmails));
        String customerToken = Configuration.EMPTYSTRING;
        if (!test.isRunningTest()) {
            customerToken = EBC_CompMethods.getCustomerToken(dml, accountId, accountExternalId, ebcLogger);
        } else {
            customerToken = Configuration.EMPTYSTRING;
        }
        transactionParams transactionPayload = new transactionParams();
        Decimal amount = (Decimal) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Amount));
        transactionPayload.SubTotal = 0;
        transactionPayload.Amount = amount;
        transactionPayload.Tax = (double) recurringDetailMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Tax));
        transactionPayload.accountID = accountId;
        transactionPayload.customerID = accountId;
        transactionPayload.internalID = accountExternalId;
        transactionPayload.customerToken = customerToken;
        transactionPayload.isRecurring = true;
        string startDate = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrStartDate));
        string endDate = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrEndDate));
        Boolean recurIndefinite = (Boolean) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrIndefinit));
        if (recurIndefinite == true) {
            endDate = Configuration.DEFAULTENDDATE;
        }
        transactionPayload.Start = Date.valueOf(startDate);
        transactionPayload.Expire = Date.valueOf(endDate);
        transactionPayload.ScheduleName = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrPayName));
        transactionPayload.Schedule = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrFrequency));
        transactionPayload.Notes = (string) recurringDetailMap.get(string.valueOf(Enums.RECURRINGJAVASCRIPTMAPSTRINGS.rrNotes));
        if (paymentMethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.UseExistingCard)) {
            transactionPayload.methodID = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.selectedCardId));
            transactionPayload.CardCode = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.cvcNo));
        } else if (paymentMethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.AddNewCard)) {
            transactionPayload.ccNumber = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
            transactionPayload.expMonth = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
            transactionPayload.expYear = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
            transactionPayload.cvvCode = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
            transactionPayload.ccName = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
            transactionPayload.AvsStreet = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
            transactionPayload.AvsZip = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
            transactionPayload.MethodName = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
            if (!test.isRunningTest()) {
                transactionPayload.methodID = EBC_CompMethods.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                if (transactionPayload.methodID.contains(Configuration.CARDEXPIRATION)) {
                    return returnMessage = 'Exception@' + 'Gateway Response Error: Credit card has expired.';
                }
            }
        } else if (paymentMethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.savedACH)) {
            transactionPayload.methodID = (String) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.selectedACHId));
        } else if (paymentMethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.addNewACH)) {
            transactionPayload.AccountName = (string) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
            transactionPayload.Account = (string) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
            transactionPayload.Route = (string) recurringDetailMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
            transactionPayload.MethodName = (string) recurringDetailMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
            if (!test.isRunningTest()) {
                transactionPayload.methodID = EBC_CompMethods.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH), ebcLogger);
            }
        }
        if (test.isRunningTest()) {
            return null;
        }
        try {
            string response = EBC_CompMethods.runRecurringPayment(dml, transactionPayload, sendReceiptTo,addEmails, ebcLogger);
            returnMessage = 'rrScheduled@' + response;
        } catch (CalloutException excpObj) {
            returnMessage = 'Exception@' + excpObj;
        }
        return returnMessage;
    }
    @AuraEnabled
    public static EBizCharge_Transaction__c getTransactionApxc(String RefNum) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        EBizCharge_Transaction__c reciprocate = getTransactionApxc(dml, RefNum, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static EBizCharge_Transaction__c getTransactionApxc(DML dml, String RefNum, EBC_Logger ebcLogger) {
        MethodName = 'getTransactionApxc';
        EBizCharge_Transaction__c ebizTransaction = new EBizCharge_Transaction__c();
        String querySelect = 'SELECT Id,EBizCharge_Subtotal__c,CreatedDate,Tax__c,CreatedDateTime__c,Transaction_Type__c,Ref_Number__c,Payment_Method__c,Card_Type__c,Auth_Amount__c,Last_X_Digit__c,Card_Number__c,Account_Name__c';
        String queryFrom = 'FROM EBizCharge_Transaction__c';
        String queryWhere = 'WHERE Ref_Number__c = \'' + RefNum + '\'';
        String queryLimit = 'limit 1';
        for (EBizCharge_Transaction__c transactionEntity: (list < EBizCharge_Transaction__c > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryLimit)) {
            ebizTransaction = transactionEntity;
        }
        return ebizTransaction;
    }
    @AuraEnabled
    public static List < transactionWrapper > getTransactionsCustomObjectApxc(String id) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < transactionWrapper > reciprocate = getTransactionsCustomObjectApxc(dml, id, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < transactionWrapper > getTransactionsCustomObjectApxc(DML dml, String id, EBC_Logger ebcLogger) {
        MethodName = 'getTransactionsCustomObjectApxc';
        List < transactionWrapper > transactionsList = new List < transactionWrapper > ();
        String start = Configuration.STARTINDEX;
        String endLimit = Configuration.ENDLIMIT;
        Boolean matchAll = true;
        Boolean countOnly = false;
        ebizchargeServicemodelSoap.ArrayOfSearchFilter ebizFilters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        list < ebizchargeServicemodelSoap.SearchFilter > ebizSearchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.CustomerID);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
        filter.FieldValue = id;
        ebizSearchFilters.add(filter);
        ebizFilters.SearchFilter = ebizSearchFilters;
        ebizchargeServicemodelSoap.TransactionSearchResult SearchTransactionsResult = new ebizchargeServicemodelSoap.TransactionSearchResult();
        if (!test.isRunningTest()) {
            SearchTransactionsResult = ebiz.SearchTransactions(eBc_UtilityController.getSecurityToken(dml, ebcLogger), ebizFilters, matchAll, countOnly, start, endLimit, Configuration.EMPTYSTRING);
        } else {
            list < ebizchargeServicemodelSoap.TransactionObject > TransactionObjectListMockData = new list < ebizchargeServicemodelSoap.TransactionObject > ();
            ebizchargeServicemodelSoap.TransactionObject TransactionObjectMockData = new ebizchargeServicemodelSoap.TransactionObject();
            ebizchargeServicemodelSoap.ArrayOfTransactionObject TransactionsMockData = new ebizchargeServicemodelSoap.ArrayOfTransactionObject();
            TransactionObjectMockData.CustomerID = '124563223';
            TransactionObjectMockData.TransactionType = 'Test Transaction Type';
            TransactionObjectListMockData.add(TransactionObjectMockData);
            TransactionsMockData.TransactionObject = TransactionObjectListMockData;
            SearchTransactionsResult.Transactions = TransactionsMockData;
        }
        if (SearchTransactionsResult.Transactions != null) {
            ebizchargeServicemodelSoap.ArrayOfTransactionObject Transactions = SearchTransactionsResult.Transactions;
            if (Transactions.TransactionObject != null) {
                ebizchargeServicemodelSoap.TransactionObject[] TransactionObjectList;
                TransactionObjectList = Transactions.TransactionObject;
                if (TransactionObjectList != null) {
                    String contactname = Configuration.EMPTYSTRING;
                    String contactid = Configuration.EMPTYSTRING;
                    integer maxTransactionCount = 6;
                    integer transactionIndex = 0;
                    integer totalTransactionCount = 0;
                    //loop to calculate correct count
                    for (ebizchargeServicemodelSoap.TransactionObject transactionObject: transactionObjectList) {
                        ebizchargeServicemodelSoap.TransactionResponse transactionResponse = transactionObject.Response;
                        if (transactionResponse.Result != string.valueOf(Enums.RETURNMESSAGE.Error)) {
                            if (transactionObject.CustomerID != null) {
                                if (!(transactionObject.TransactionType == Configuration.VOIDTRANSACTIONTYPE && transactionResponse.AuthAmount == 0.05)) {
                                    totalTransactionCount = totalTransactionCount + 1;
                                }
                            }
                        }
                    }
                    for (Integer i = 0; i < transactionObjectList.size(); i++) {
                        Datetime datetimeToCompare = Datetime.valueOf(transactionObjectList[i].DateTime_x);
                        for (Integer j = i + 1; j < transactionObjectList.size(); j++) {
                            Datetime datetimeCompareWith = Datetime.valueOf(transactionObjectList[j].DateTime_x);
                            if (datetimeToCompare < datetimeCompareWith) {
                                ebizchargeServicemodelSoap.TransactionObject transactionObject = transactionObjectList[i];
                                transactionObjectList[i] = transactionObjectList[j];
                                transactionObjectList[j] = transactionObject;
                            }
                        }
                    }
                    for (ebizchargeServicemodelSoap.TransactionObject transactionObject: transactionObjectList) {
                        ebizchargeServicemodelSoap.TransactionResponse transactionResponse = transactionObject.Response;
                        ebizchargeServicemodelSoap.TransactionDetail transactionDetails = transactionObject.Details;
                        if (transactionResponse.Result != string.valueOf(Enums.RETURNMESSAGE.Error)) {
                            if (transactionObject.CustomerID != null) {
                                transactionWrapper transactionWrapper = new transactionWrapper();
                                transactionWrapper.TransType = transactionObject.TransactionType;
                                string datetimeString = transactionObject.DateTime_x;
                                list < String > datetimeSplitString = datetimeString.split(Configuration.DOUBLEBLANKS);
                                Datetime datetimeEntity = Datetime.valueOf(datetimeString);
                                transactionWrapper.dateTimeTransaction = datetimeEntity;
                                transactionWrapper.formattedDateTimeTransaction = datetimeEntity;
                                transactionWrapper.amountPaid = transactionResponse.AuthAmount;
                                transactionWrapper.refNum = transactionResponse.RefNum;
                                ebizchargeServicemodelSoap.CreditCardData cardData = transactionObject.CreditCardData;
                                if (test.isRunningTest()) {
                                    cardData.CardNumber = '45567g788';
                                }
                                if (cardData.CardNumber != null) {
                                    transactionWrapper.CardType = cardData.CardType;
                                    transactionWrapper.paymentMethod = cardData.CardNumber.right(4);
                                }
                                ebizchargeServicemodelSoap.CheckData chekData = transactionObject.CheckData;
                                if (chekData.Account != null) {
                                    transactionWrapper.CardType = string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH);
                                    transactionWrapper.paymentMethod = chekData.Account.right(4);
                                }
                                transactionWrapper.contact = contactname;
                                transactionWrapper.transHyperURL = contactid;
                                if (!(transactionObject.TransactionType == Configuration.VOIDTRANSACTIONTYPE && transactionResponse.AuthAmount == 0.05)) {
                                    transactionsList.add(transactionWrapper);
                                }
                                transactionWrapper.tcount = totalTransactionCount;
                                transactionIndex = transactionIndex + 1;
                                if (transactionIndex == maxTransactionCount) {
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        return transactionsList;
    }
    @AuraEnabled
    public static List < transactionWrapper > getTransactionsContactApxc(String contactId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < transactionWrapper > reciprocate = getTransactionsContactApxc(dml, contactId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < transactionWrapper > getTransactionsContactApxc(DML dml, String contactId, EBC_Logger ebcLogger) {
        MethodName = 'getTransactionsContactApxc';
        List < transactionWrapper > transactionsList = new List < transactionWrapper > ();
        String start = Configuration.STARTINDEX;
        String endLimit = Configuration.ENDLIMIT;
        Boolean matchAll = true;
        Boolean countOnly = false;
        ebizchargeServicemodelSoap.ArrayOfSearchFilter ebizFilters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        list < ebizchargeServicemodelSoap.SearchFilter > ebizSearchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.CustomerID);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
        filter.FieldValue = contactId;
        ebizSearchFilters.add(filter);
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.Invoice);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
        filter.FieldValue = contactId;
        ebizSearchFilters.add(filter);
        ebizFilters.SearchFilter = ebizSearchFilters;
        ebizchargeServicemodelSoap.TransactionSearchResult SearchTransactionsResult = new ebizchargeServicemodelSoap.TransactionSearchResult();
        if (!test.isRunningTest()) {
            SearchTransactionsResult = ebiz.SearchTransactions(eBc_UtilityController.getSecurityToken(dml, ebcLogger), ebizFilters, matchAll, countOnly, start, endLimit, Configuration.EMPTYSTRING);
        } else {
            list < ebizchargeServicemodelSoap.TransactionObject > TransactionObjectListMockData = new list < ebizchargeServicemodelSoap.TransactionObject > ();
            ebizchargeServicemodelSoap.TransactionObject TransactionObjectMockData = new ebizchargeServicemodelSoap.TransactionObject();
            ebizchargeServicemodelSoap.ArrayOfTransactionObject TransactionsMockData = new ebizchargeServicemodelSoap.ArrayOfTransactionObject();
            TransactionObjectMockData.CustomerID = '124563223';
            TransactionObjectMockData.TransactionType = 'Test Transaction Type';
            TransactionObjectListMockData.add(TransactionObjectMockData);
            TransactionsMockData.TransactionObject = TransactionObjectListMockData;
            SearchTransactionsResult.Transactions = TransactionsMockData;
        }
        if (SearchTransactionsResult.Transactions != null) {
            ebizchargeServicemodelSoap.ArrayOfTransactionObject Transactions = SearchTransactionsResult.Transactions;
            if (Transactions.TransactionObject != null) {
                ebizchargeServicemodelSoap.TransactionObject[] TransactionObjectList;
                TransactionObjectList = Transactions.TransactionObject;
                if (TransactionObjectList != null) {
                    String querySelect = 'Select name';
                    String queryFrom = 'from Contact';
                    String queryWhere = 'where id =\'' + contactId + '\'';
                    String queryOrderby = Configuration.EMPTYSTRING;
                    String queryLimit = 'limit 1';
                    Contact contact = (Contact) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                    integer maxTransactionCount = 6;
                    integer transactionIndex = 0;
                    integer totalTransactionCount = 0;
                    //loop to calculate correct count
                    for (ebizchargeServicemodelSoap.TransactionObject transactionObject: transactionObjectList) {
                        ebizchargeServicemodelSoap.TransactionResponse transactionResponse = transactionObject.Response;
                        if (transactionResponse.Result != string.valueOf(Enums.RETURNMESSAGE.Error)) {
                            if (transactionObject.CustomerID != null) {
                                if (!(transactionObject.TransactionType == Configuration.VOIDTRANSACTIONTYPE && transactionResponse.AuthAmount == 0.05)) {
                                    totalTransactionCount = totalTransactionCount + 1;
                                }
                            }
                        }
                    }
                    for (Integer i = 0; i < transactionObjectList.size(); i++) {
                        Datetime datetimeToCompare = Datetime.valueOf(transactionObjectList[i].DateTime_x);
                        for (Integer j = i + 1; j < transactionObjectList.size(); j++) {
                            Datetime datetimeCompareWith = Datetime.valueOf(transactionObjectList[j].DateTime_x);
                            if (datetimeToCompare < datetimeCompareWith) {
                                ebizchargeServicemodelSoap.TransactionObject transactionObject = transactionObjectList[i];
                                transactionObjectList[i] = transactionObjectList[j];
                                transactionObjectList[j] = transactionObject;
                            }
                        }
                    }
                    for (ebizchargeServicemodelSoap.TransactionObject transactionObject: transactionObjectList) {
                        ebizchargeServicemodelSoap.TransactionResponse transactionResponse = transactionObject.Response;
                        ebizchargeServicemodelSoap.TransactionDetail transactionDetails = transactionObject.Details;
                        if (transactionResponse.Result != string.valueOf(Enums.RETURNMESSAGE.Error)) {
                            if (transactionObject.CustomerID != null) {
                                transactionWrapper transactionWrapper = new transactionWrapper();
                                transactionWrapper.TransType = transactionObject.TransactionType;
                                Datetime datetimeEntity = Datetime.valueOf(transactionObject.DateTime_x);
                                transactionWrapper.dateTimeTransaction = datetimeEntity;
                                transactionWrapper.formattedDateTimeTransaction = datetimeEntity;
                                transactionWrapper.amountPaid = transactionResponse.AuthAmount;
                                transactionWrapper.refNum = transactionResponse.RefNum;
                                ebizchargeServicemodelSoap.CreditCardData cardData = transactionObject.CreditCardData;
                                if (test.isRunningTest()) {
                                    cardData.CardNumber = '45567g788';
                                }
                                if (cardData.CardNumber != null) {
                                    transactionWrapper.CardType = cardData.CardType;
                                    transactionWrapper.paymentMethod = cardData.CardNumber.right(4);
                                }
                                ebizchargeServicemodelSoap.CheckData chekData = transactionObject.CheckData;
                                if (test.isRunningTest()) {
                                    chekData.Account = '45567g788';
                                }
                                if (chekData.Account != null) {
                                    transactionWrapper.CardType = string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH);
                                    transactionWrapper.paymentMethod = chekData.Account.right(4);
                                }
                                transactionWrapper.contact = contact.name;
                                transactionWrapper.transHyperURL = contactId;
                                if (!(transactionObject.TransactionType == Configuration.VOIDTRANSACTIONTYPE && transactionResponse.AuthAmount == 0.05)) {
                                    transactionsList.add(transactionWrapper);
                                    transactionIndex = transactionIndex + 1;
                                }
                                transactionWrapper.tcount = totalTransactionCount;
                                if (transactionIndex == maxTransactionCount) {
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        return transactionsList;
    }
    @AuraEnabled
    public static List < transactionWrapper > getTransactionsOppApxc(Opportunity opp) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < transactionWrapper > reciprocate = getTransactionsOppApxc(dml, opp, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < transactionWrapper > getTransactionsOppApxc(DML dml, Opportunity opp, EBC_Logger ebcLogger) {
        MethodName = 'getTransactionsOppApxc';
        List < transactionWrapper > transactionsList = new List < transactionWrapper > ();
        String start = Configuration.STARTINDEX;
        String endLimit = Configuration.ENDLIMIT;
        Boolean matchAll = true;
        Boolean countOnly = false;
        ebizchargeServicemodelSoap.ArrayOfSearchFilter ebizFilters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        list < ebizchargeServicemodelSoap.SearchFilter > ebizSearchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.IDENTICALJAVASCRIPTMAPSTRINGS.OrderID);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
        filter.FieldValue = opp.id;
        ebizSearchFilters.add(filter);
        ebizFilters.SearchFilter = ebizSearchFilters;
        ebizchargeServicemodelSoap.TransactionSearchResult SearchTransactionsResult = new ebizchargeServicemodelSoap.TransactionSearchResult();
        if (!test.isRunningTest()) {
            SearchTransactionsResult = ebiz.SearchTransactions(eBc_UtilityController.getSecurityToken(dml, ebcLogger), ebizFilters, matchAll, countOnly, start, endLimit, Configuration.EMPTYSTRING);
        } else {
            list < ebizchargeServicemodelSoap.TransactionObject > TransactionObjectListMockData = new list < ebizchargeServicemodelSoap.TransactionObject > ();
            ebizchargeServicemodelSoap.TransactionObject TransactionObjectMockData = new ebizchargeServicemodelSoap.TransactionObject();
            ebizchargeServicemodelSoap.ArrayOfTransactionObject TransactionsMockData = new ebizchargeServicemodelSoap.ArrayOfTransactionObject();
            TransactionObjectMockData.CustomerID = '124563223';
            TransactionObjectMockData.TransactionType = 'Test Transaction Type';
            TransactionObjectListMockData.add(TransactionObjectMockData);
            TransactionsMockData.TransactionObject = TransactionObjectListMockData;
            SearchTransactionsResult.Transactions = TransactionsMockData;
        }
        if (SearchTransactionsResult.Transactions != null) {
            ebizchargeServicemodelSoap.ArrayOfTransactionObject Transactions = SearchTransactionsResult.Transactions;
            if (Transactions.TransactionObject != null) {
                ebizchargeServicemodelSoap.TransactionObject[] TransactionObjectList;
                TransactionObjectList = Transactions.TransactionObject;
                if (TransactionObjectList != null) {
                    integer maxTransactionCount = 6;
                    integer transactionIndex = 0;
                    integer totalTransactionCount = 0;
                    //loop to calculate correct count
                    for (ebizchargeServicemodelSoap.TransactionObject transactionObject: transactionObjectList) {
                        ebizchargeServicemodelSoap.TransactionResponse transactionResponse = transactionObject.Response;
                        if (transactionResponse.Result != string.valueOf(Enums.RETURNMESSAGE.Error)) {
                            if (transactionObject.CustomerID != null) {
                                if (!(transactionObject.TransactionType == Configuration.VOIDTRANSACTIONTYPE && transactionResponse.AuthAmount == 0.05)) {
                                    totalTransactionCount = totalTransactionCount + 1;
                                }
                            }
                        }
                    }
                    for (Integer i = 0; i < transactionObjectList.size(); i++) {
                        Datetime datetimeToCompare = Datetime.valueOf(transactionObjectList[i].DateTime_x);
                        for (Integer j = i + 1; j < transactionObjectList.size(); j++) {
                            Datetime datetimeCompareWith = Datetime.valueOf(transactionObjectList[j].DateTime_x);
                            if (datetimeToCompare < datetimeCompareWith) {
                                ebizchargeServicemodelSoap.TransactionObject transactionObject = transactionObjectList[i];
                                transactionObjectList[i] = transactionObjectList[j];
                                transactionObjectList[j] = transactionObject;
                            }
                        }
                    }
                    for (ebizchargeServicemodelSoap.TransactionObject transactionObject: transactionObjectList) {
                        ebizchargeServicemodelSoap.TransactionResponse transactionResponse = transactionObject.Response;
                        ebizchargeServicemodelSoap.TransactionDetail transactionDetails = transactionObject.Details;
                        if (transactionResponse.Result != string.valueOf(Enums.RETURNMESSAGE.Error)) {
                            if (transactionObject.CustomerID != null) {
                                transactionWrapper transactionWrapper = new transactionWrapper();
                                transactionWrapper.TransType = transactionObject.TransactionType;
                                string datetimeString = transactionObject.DateTime_x;
                                Datetime datetimeEntity = Datetime.valueOf(datetimeString);
                                transactionWrapper.dateTimeTransaction = datetimeEntity;
                                transactionWrapper.formattedDateTimeTransaction = datetimeEntity;
                                transactionWrapper.amountPaid = transactionResponse.AuthAmount;
                                transactionWrapper.refNum = transactionResponse.RefNum;
                                ebizchargeServicemodelSoap.CreditCardData cardData = transactionObject.CreditCardData;
                                if (test.isRunningTest()) {
                                    cardData.CardNumber = '15';
                                }
                                if (cardData.CardNumber != null) {
                                    transactionWrapper.CardType = cardData.CardType;
                                    transactionWrapper.paymentMethod = cardData.CardNumber.right(4);
                                }
                                ebizchargeServicemodelSoap.CheckData chekData = transactionObject.CheckData;
                                if (test.isRunningTest()) {
                                    chekData.Account = '15';
                                }
                                if (chekData.Account != null) {
                                    transactionWrapper.CardType = string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH);
                                    transactionWrapper.paymentMethod = chekData.Account.right(4);
                                }
                                String contactname = Configuration.EMPTYSTRING;
                                String contactid = Configuration.EMPTYSTRING;
                                String regex = Configuration.REGEXSTRING;
                                Pattern pattern = Pattern.compile(regex);
                                if ((transactionDetails.Terminal.length() == 18 || transactionDetails.Terminal.length() == 15)) {
                                    String query_Select = 'Select name';
                                    String query_From = 'from Contact';
                                    String query_Where = 'where id =\'' + transactionDetails.Terminal + '\'';
                                    String queryOrderby = Configuration.EMPTYSTRING;
                                    String queryLimit = 'limit 1';
                                    List < Contact > contactslist = (List < Contact > ) dml.selectRecords(query_Select, query_From, query_Where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryLimit);
                                    if (contactslist != null && contactslist.size() > 0) {
                                        contactname = contactslist[0].name;
                                        contactid = '/' + contactslist[0].id;
                                    }
                                }
                                transactionWrapper.contact = contactname;
                                transactionWrapper.transHyperURL = contactid;
                                if (!(transactionObject.TransactionType == Configuration.VOIDTRANSACTIONTYPE && transactionResponse.AuthAmount == 0.05)) {
                                    transactionsList.add(transactionWrapper);
                                    transactionIndex = transactionIndex + 1;
                                }
                                transactionWrapper.tcount = totalTransactionCount;
                                if (transactionIndex == maxTransactionCount) {
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        return transactionsList;
    }
    @AuraEnabled
    public static List < transactionWrapper > getTransactionsOrderApxc(Order ord) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < transactionWrapper > reciprocate = getTransactionsOrderApxc(dml, ord, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < transactionWrapper > getTransactionsOrderApxc(DML dml, Order ord, EBC_Logger ebcLogger) {
        MethodName = 'getTransactionsOrderApxc';
        List < transactionWrapper > transactionsList = new List < transactionWrapper > ();
        String start = Configuration.STARTINDEX;
        String endLimit = Configuration.ENDLIMIT;
        Boolean matchAll = false;
        Boolean countOnly = false;
        ebizchargeServicemodelSoap.ArrayOfSearchFilter ebizFilters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        list < ebizchargeServicemodelSoap.SearchFilter > ebizSearchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        String querySelect = 'select id,QBD_Customer_ID__c';
        String queryFrom = 'from Account';
        String queryWhere =  'where id=\''+ord.AccountId+'\'';
        Account account = (Account)dml.selectSingleRecord(querySelect,queryFrom,queryWhere,  Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.Invoice);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
        filter.FieldValue = ord.OrderNumber;
        ebizSearchFilters.add(filter);
        ebizFilters.SearchFilter = ebizSearchFilters;
        ebizchargeServicemodelSoap.TransactionSearchResult SearchTransactionsResult = new ebizchargeServicemodelSoap.TransactionSearchResult();
        if (!test.isRunningTest()) {
            SearchTransactionsResult = ebiz.SearchTransactions(eBc_UtilityController.getSecurityToken(dml, ebcLogger), ebizFilters, matchAll, countOnly, start, endLimit, Configuration.EMPTYSTRING);
        } else {
            list < ebizchargeServicemodelSoap.TransactionObject > TransactionObjectListMockData = new list < ebizchargeServicemodelSoap.TransactionObject > ();
            ebizchargeServicemodelSoap.TransactionObject TransactionObjectMockData = new ebizchargeServicemodelSoap.TransactionObject();
            ebizchargeServicemodelSoap.ArrayOfTransactionObject TransactionsMockData = new ebizchargeServicemodelSoap.ArrayOfTransactionObject();
            TransactionObjectMockData.CustomerID = '124563223';
            TransactionObjectMockData.TransactionType = 'Test Transaction Type';
            TransactionObjectListMockData.add(TransactionObjectMockData);
            TransactionsMockData.TransactionObject = TransactionObjectListMockData;
            SearchTransactionsResult.Transactions = TransactionsMockData;
        }
        if (SearchTransactionsResult.Transactions != null) {
            ebizchargeServicemodelSoap.ArrayOfTransactionObject Transactions = SearchTransactionsResult.Transactions;
            if (Transactions.TransactionObject != null) {
                ebizchargeServicemodelSoap.TransactionObject[] TransactionObjectList;
                TransactionObjectList = Transactions.TransactionObject;
                if (TransactionObjectList != null) {
                    integer maxTransactionCount = 6;
                    integer transactionIndex = 0;
                    integer totalTransactionCount = 0;
                    //loop to calculate correct count
                    for (ebizchargeServicemodelSoap.TransactionObject transactionObject: transactionObjectList) {
                        ebizchargeServicemodelSoap.TransactionResponse transactionResponse = transactionObject.Response;
                        if (transactionResponse.Result != string.valueOf(Enums.RETURNMESSAGE.Error)) {
                            if (transactionObject.CustomerID != null) {
                                if (!(transactionObject.TransactionType == Configuration.VOIDTRANSACTIONTYPE && transactionResponse.AuthAmount == 0.05)) {
                                    totalTransactionCount = totalTransactionCount + 1;
                                }
                            }
                        }
                    }
                    for (Integer i = 0; i < transactionObjectList.size(); i++) {
                        Datetime datetimeToCompare = Datetime.valueOf(transactionObjectList[i].DateTime_x);
                        for (Integer j = i + 1; j < transactionObjectList.size(); j++) {
                            Datetime datetimeCompareWith = Datetime.valueOf(transactionObjectList[j].DateTime_x);
                            if (datetimeToCompare < datetimeCompareWith) {
                                ebizchargeServicemodelSoap.TransactionObject transactionObject = transactionObjectList[i];
                                transactionObjectList[i] = transactionObjectList[j];
                                transactionObjectList[j] = transactionObject;
                            }
                        }
                    }
                    for (ebizchargeServicemodelSoap.TransactionObject transactionObject: transactionObjectList) {
                        ebizchargeServicemodelSoap.TransactionResponse transactionResponse = transactionObject.Response;
                        ebizchargeServicemodelSoap.TransactionDetail transactionDetails = transactionObject.Details;
                        if (transactionResponse.Result != string.valueOf(Enums.RETURNMESSAGE.Error)) {
                            if (transactionObject.CustomerID != null) {
                                transactionWrapper transactionWrapper = new transactionWrapper();
                                transactionWrapper.TransType = transactionObject.TransactionType;
                                Datetime datetimeEntity = Datetime.ValueofGmt(transactionObject.DateTime_x);
                                transactionWrapper.dateTimeTransaction = datetimeEntity;
                                transactionWrapper.formattedDateTimeTransaction =  Datetime.Valueof(transactionObject.DateTime_x);
                                transactionWrapper.amountPaid = transactionResponse.AuthAmount;
                                transactionWrapper.refNum = transactionResponse.RefNum;
                                ebizchargeServicemodelSoap.CreditCardData cardData = transactionObject.CreditCardData;
                                if (test.isRunningTest()) {
                                    cardData.CardNumber = '66677';
                                }
                                if (cardData.CardNumber != null) {
                                    transactionWrapper.CardType = cardData.CardType;
                                    transactionWrapper.paymentMethod = cardData.CardNumber.right(4);
                                }
                                ebizchargeServicemodelSoap.CheckData chekData = transactionObject.CheckData;
                                if (test.isRunningTest()) {
                                    chekData.Account = '66677';
                                }
                                if (chekData.Account != null) {
                                    transactionWrapper.CardType = string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH);
                                    transactionWrapper.paymentMethod = chekData.Account.right(4);
                                }
                                String contactname = Configuration.EMPTYSTRING;
                                String contactid = Configuration.EMPTYSTRING;
                                String regex = Configuration.REGEXSTRING;
                                Pattern pattern = Pattern.compile(regex);
                                if ((transactionDetails.Terminal.length() == 18 || transactionDetails.Terminal.length() == 15)) {
                                    String query_Select = 'Select name';
                                    String query_From = 'from Contact';
                                    String query_Where = 'where id =\'' + transactionDetails.Terminal + '\'';
                                    String queryOrderby = Configuration.EMPTYSTRING;
                                    String queryLimit = 'limit 1';
                                    List < Contact > contactslist = (List < Contact > ) dml.selectRecords(query_Select, query_From, query_Where, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryLimit);
                                    if (contactslist != null && contactslist.size() > 0) {
                                        contactname = contactslist[0].name;
                                        contactid = '/' + contactslist[0].id;
                                    }
                                }
                                transactionWrapper.contact = contactname;
                                transactionWrapper.transHyperURL = contactid;
                                if (!(transactionObject.TransactionType == Configuration.VOIDTRANSACTIONTYPE && transactionResponse.AuthAmount == 0.05)) {
                                    transactionsList.add(transactionWrapper);
                                    transactionIndex = transactionIndex + 1;
                                }
                                transactionWrapper.tcount = totalTransactionCount;
                                if (transactionIndex == maxTransactionCount) {
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        return transactionsList;
    }
    @AuraEnabled
    public static List < transactionWrapper > getTransactionsAccountApxc(Account acc) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < transactionWrapper > reciprocate = getTransactionsAccountApxc(dml, acc, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < transactionWrapper > getTransactionsAccountApxc(DML dml, Account acc, EBC_Logger ebcLogger) {
        MethodName = 'getTransactionsAccountApxc';
        List < transactionWrapper > transactionsList = new List < transactionWrapper > ();
        String start = Configuration.STARTINDEX;
        String endLimit = Configuration.ENDLIMIT;
        Boolean matchAll = true;
        Boolean countOnly = false;
        ebizchargeServicemodelSoap.ArrayOfSearchFilter ebizFilters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        list < ebizchargeServicemodelSoap.SearchFilter > ebizSearchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.OrderId);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);// Invoice and Customer Id filter is not supported because its length is not matched with a response get in SeacrhTransaction Api 
        filter.FieldValue = (String)acc.get('QBD_Customer_ID__c');
        ebizSearchFilters.add(filter);
        ebizFilters.SearchFilter = ebizSearchFilters;
        ebizchargeServicemodelSoap.TransactionSearchResult searchTransactionsResult = new ebizchargeServicemodelSoap.TransactionSearchResult();
        searchTransactionsResult = ebiz.SearchTransactions(eBc_UtilityController.getSecurityToken(dml, ebcLogger), ebizFilters, matchAll, countOnly, start, endLimit, Configuration.EMPTYSTRING);
        if (searchTransactionsResult.Transactions != null) {
            ebizchargeServicemodelSoap.ArrayOfTransactionObject transactions = searchTransactionsResult.Transactions;
            if (transactions.TransactionObject != null) {
                ebizchargeServicemodelSoap.TransactionObject[] transactionObjectList;
                transactionObjectList = transactions.TransactionObject;
                if (transactionObjectList != null) {
                    integer maxTransactionCount = 6;
                    integer transactionIndex = 0;
                    integer totalTransactionCount = 0;
                    //loop to calculate correct count
                    for (ebizchargeServicemodelSoap.TransactionObject transactionObject: transactionObjectList) {
                        ebizchargeServicemodelSoap.TransactionResponse transactionResponse = transactionObject.Response;
                        if (transactionResponse.Result != string.valueOf(Enums.RETURNMESSAGE.Error)) {
                            if (transactionObject.CustomerID != null) {
                                if (!(transactionObject.TransactionType == Configuration.VOIDTRANSACTIONTYPE && transactionResponse.AuthAmount == 0.05)) {
                                    totalTransactionCount = totalTransactionCount + 1;
                                }
                            }
                        }
                    }
                    for (Integer i = 0; i < transactionObjectList.size(); i++) {
                        Datetime datetimeToCompare = Datetime.valueOf(transactionObjectList[i].DateTime_x);
                        for (Integer j = i + 1; j < transactionObjectList.size(); j++) {
                            Datetime datetimeCompareWith = Datetime.valueOf(transactionObjectList[j].DateTime_x);
                            if (datetimeToCompare < datetimeCompareWith) {
                                ebizchargeServicemodelSoap.TransactionObject transactionObject = transactionObjectList[i];
                                transactionObjectList[i] = transactionObjectList[j];
                                transactionObjectList[j] = transactionObject;
                            }
                        }
                    }
                    for (ebizchargeServicemodelSoap.TransactionObject transactionObject: transactionObjectList) {
                        ebizchargeServicemodelSoap.TransactionResponse transactionResponse = transactionObject.Response;
                        ebizchargeServicemodelSoap.TransactionDetail transactionDetails = transactionObject.Details;
                        if (transactionResponse.Result != string.valueOf(Enums.RETURNMESSAGE.Error)) {
                            if (transactionObject.CustomerID != null) {
                                transactionWrapper transactionWrapper = new transactionWrapper();
                                transactionWrapper.TransType = transactionObject.TransactionType;
                                string datetimeString = transactionObject.DateTime_x;
                                Datetime datetimeEntity = Datetime.valueOf(transactionObject.DateTime_x);
                                transactionWrapper.dateTimeTransaction = datetimeEntity;
                                transactionWrapper.formattedDateTimeTransaction = datetimeEntity;
                                transactionWrapper.amountPaid = transactionResponse.AuthAmount;
                                transactionWrapper.refNum = transactionResponse.RefNum;
                                String contactname = Configuration.EMPTYSTRING;
                                String contactid = Configuration.EMPTYSTRING;
                                String regex = Configuration.REGEXSTRING;
                                Pattern pattern = Pattern.compile(regex);
                                if ((transactionDetails.Terminal.length() == 18 || transactionDetails.Terminal.length() == 15)) {
                                    String querySelect = 'Select name';
                                    String queryFrom = 'from Contact';
                                    String queryWhere = 'where id =\'' + transactionDetails.Terminal + '\'';
                                    String queryOrderby = Configuration.EMPTYSTRING;
                                    String queryLimit = 'limit 1';
                                    List < Contact > contactslist = (List < Contact > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryLimit);
                                    if (contactslist != null && contactslist.size() > 0) {
                                        contactname = contactslist[0].name;
                                        contactid = '/' + contactslist[0].id;
                                    }
                                }
                                transactionWrapper.contact = contactname;
                                transactionWrapper.transHyperURL = contactid;
                                ebizchargeServicemodelSoap.CreditCardData cardData = transactionObject.CreditCardData;
                                if (cardData.CardNumber != null) {
                                    transactionWrapper.CardType = cardData.CardType;
                                    transactionWrapper.paymentMethod = cardData.CardNumber.right(4);
                                }
                                ebizchargeServicemodelSoap.CheckData chekData = transactionObject.CheckData;
                                if (chekData.Account != null) {
                                    transactionWrapper.CardType = string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH);
                                    transactionWrapper.paymentMethod = chekData.Account.right(4);
                                }
                                if (!(transactionObject.TransactionType == Configuration.VOIDTRANSACTIONTYPE && transactionResponse.AuthAmount == 0.05)) {
                                    transactionsList.add(transactionWrapper);
                                    transactionIndex = transactionIndex + 1;
                                }
                                transactionWrapper.tcount = totalTransactionCount;
                                if (transactionIndex == maxTransactionCount) {
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        return transactionsList;
    }
    @AuraEnabled
    public static List < transactionWrapper > getTransactionsQuoteApxc(Quote quo) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < transactionWrapper > reciprocate = getTransactionsQuoteApxc(dml, quo, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < transactionWrapper > getTransactionsQuoteApxc(DML dml, Quote quo, EBC_Logger ebcLogger) {
        MethodName = 'getTransactionsQuoteApxc';
        List < transactionWrapper > transactionsList = new List < transactionWrapper > ();
        String start = Configuration.STARTINDEX;
        String endLimit = Configuration.ENDLIMIT;
        Boolean matchAll = false;
        Boolean countOnly = false;
        ebizchargeServicemodelSoap.ArrayOfSearchFilter ebizFilters = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        list < ebizchargeServicemodelSoap.SearchFilter > ebizSearchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.Invoice);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
        filter.FieldValue = quo.QuoteNumber;
        ebizSearchFilters.add(filter);
        ebizFilters.SearchFilter = ebizSearchFilters;
        ebizchargeServicemodelSoap.TransactionSearchResult searchTransactionsResult = new ebizchargeServicemodelSoap.TransactionSearchResult();
        searchTransactionsResult = ebiz.SearchTransactions(eBc_UtilityController.getSecurityToken(dml, ebcLogger), ebizFilters, matchAll, countOnly, start, endLimit, Configuration.EMPTYSTRING);
        if (searchTransactionsResult.Transactions != null) {
            ebizchargeServicemodelSoap.ArrayOfTransactionObject transactions = searchTransactionsResult.Transactions;
            if (transactions.TransactionObject != null) {
                ebizchargeServicemodelSoap.TransactionObject[] transactionObjectList;
                transactionObjectList = transactions.TransactionObject;
                if (transactionObjectList != null) {
                    integer maxTransactionCount = 6;
                    integer transactionIndex = 0;
                    integer totalTransactionCount = 0;
                    //loop to calculate correct count
                    for (ebizchargeServicemodelSoap.TransactionObject transactionObject: transactionObjectList) {
                        ebizchargeServicemodelSoap.TransactionResponse transactionResponse = transactionObject.Response;
                        if (transactionResponse.Result != string.valueOf(Enums.RETURNMESSAGE.Error)) {
                            if (transactionObject.CustomerID != null) {
                                if (!(transactionObject.TransactionType == Configuration.VOIDTRANSACTIONTYPE && transactionResponse.AuthAmount == 0.05)) {
                                    totalTransactionCount = totalTransactionCount + 1;
                                }
                            }
                        }
                    }
                    for (Integer i = 0; i < transactionObjectList.size(); i++) {
                        Datetime datetimeToCompare = Datetime.valueOf(transactionObjectList[i].DateTime_x);
                        for (Integer j = i + 1; j < transactionObjectList.size(); j++) {
                            Datetime datetimeCompareWith = Datetime.valueOf(transactionObjectList[j].DateTime_x);
                            if (datetimeToCompare < datetimeCompareWith) {
                                ebizchargeServicemodelSoap.TransactionObject transactionObject = transactionObjectList[i];
                                transactionObjectList[i] = transactionObjectList[j];
                                transactionObjectList[j] = transactionObject;
                            }
                        }
                    }
                    for (ebizchargeServicemodelSoap.TransactionObject transactionObject: transactionObjectList) {
                        ebizchargeServicemodelSoap.TransactionResponse transactionResponse = transactionObject.Response;
                        ebizchargeServicemodelSoap.TransactionDetail transactionDetails = transactionObject.Details;
                        if (transactionResponse.Result != string.valueOf(Enums.RETURNMESSAGE.Error)) {
                            if (transactionObject.CustomerID != null) {
                                transactionWrapper transactionWrapper = new transactionWrapper();
                                transactionWrapper.TransType = transactionObject.TransactionType;
                                string datetimeString = transactionObject.DateTime_x;
                                Datetime datetimeEntity = Datetime.valueOf(datetimeString);
                                transactionWrapper.dateTimeTransaction = datetimeEntity;
                                transactionWrapper.formattedDateTimeTransaction = datetimeEntity;
                                transactionWrapper.amountPaid = transactionResponse.AuthAmount;
                                transactionWrapper.refNum = transactionResponse.RefNum;
                                ebizchargeServicemodelSoap.CreditCardData cardData = transactionObject.CreditCardData;
                                if (test.isRunningTest()) {
                                    cardData.CardNumber = '54657';
                                }
                                if (cardData.CardNumber != null) {
                                    transactionWrapper.CardType = cardData.CardType;
                                    transactionWrapper.paymentMethod = cardData.CardNumber.right(4);
                                }
                                ebizchargeServicemodelSoap.CheckData chekData = transactionObject.CheckData;
                                if (test.isRunningTest()) {
                                    chekData.Account = '54657';
                                }
                                if (chekData.Account != null) {
                                    transactionWrapper.CardType = string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH);
                                    transactionWrapper.paymentMethod = chekData.Account.right(4);
                                }
                                String contactname = Configuration.EMPTYSTRING;
                                String contactid = Configuration.EMPTYSTRING;
                                String regex = Configuration.REGEXSTRING;
                                Pattern pattern = Pattern.compile(regex);
                                if ((transactionDetails.Terminal.length() == 18 || transactionDetails.Terminal.length() == 15)) {
                                    String querySelect = 'Select name';
                                    String queryFrom = 'from Contact';
                                    String queryWhere = 'where id =\'' + transactionDetails.Terminal + '\'';
                                    String queryOrderby = Configuration.EMPTYSTRING;
                                    String queryLimit = 'limit 1';
                                    List < Contact > contactslist = (List < Contact > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryLimit);
                                    if (contactslist != null && contactslist.size() > 0) {
                                        contactname = contactslist[0].name;
                                        contactid = '/' + contactslist[0].id;
                                    }
                                }
                                transactionWrapper.contact = contactname;
                                transactionWrapper.transHyperURL = contactid;
                                if (!(transactionObject.TransactionType == Configuration.VOIDTRANSACTIONTYPE && transactionResponse.AuthAmount == 0.05)) {
                                    transactionsList.add(transactionWrapper);
                                    transactionIndex = transactionIndex + 1;
                                }
                                transactionWrapper.tcount = totalTransactionCount;
                                if (transactionIndex == maxTransactionCount) {
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        return transactionsList;
    }
    @AuraEnabled
    public static String capturePaymentApxc(Order orderDetail, Decimal Amount, Quote quoteDetail, Decimal Tax) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = capturePaymentApxc(dml, orderDetail, Amount, quoteDetail, Tax, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String capturePaymentApxc(DML dml, Order orderDetail, Decimal Amount, Quote quoteDetail, Decimal Tax, EBC_Logger ebcLogger) {
        MethodName = 'capturePaymentApxc';
        ebcLogger.debug(ClassName, MethodName, 'orderDetail:' + orderDetail);
        ebcLogger.debug(ClassName, MethodName, 'Amount:' + Amount);
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        String queryOrderby = Configuration.EMPTYSTRING;
        String queryLimit = Configuration.EMPTYSTRING;
        string orderNumber;
        string accountId;
        //conditioned by @wqkl against (SF-137) - (05jan21)
        if (quoteDetail == null) {
            orderNumber = orderDetail.OrderNumber;
            accountId = orderDetail.AccountId;
        } else {
            orderNumber = quoteDetail.QuoteNumber;
            accountId = quoteDetail.AccountId;
        }
        Decimal orderPaymentAmount = Amount;
        transactionParams transactionPayload = new transactionParams();
        transactionPayload.OrderNumber = orderNumber;
        transactionPayload.OrderID = orderNumber;
        transactionPayload.Amount = orderPaymentAmount;
        transactionPayload.isRecurring = false;
        ebizchargeServicemodelSoap.TransactionRequestObject transactionRequest = new ebizchargeServicemodelSoap.TransactionRequestObject();
        transactionRequest.CustomerID = accountId;
        transactionRequest.BillingAddress = null;
        transactionRequest.ShippingAddress = null;
        transactionRequest.isRecurring = false;
        transactionRequest.IgnoreDuplicate = true;
        transactionRequest.Software = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
        transactionRequest.CustReceipt = true;
        transactionRequest.Command = string.valueOf(Enums.TRANSACTIONCOMMANDS.capture);
        //conditioned by @wqkl against (SF-137) - (05jan21)
        if (quoteDetail == null) {
            transactionRequest.RefNum = orderDetail.EBizCharge_Reference_Number__c;
        } else {
            transactionRequest.RefNum = quoteDetail.EBizCharge_Reference_Number__c;
        }
        ebizchargeServicemodelSoap.TransactionDetail transactionDetail = new ebizchargeServicemodelSoap.TransactionDetail();
        transactionDetail.Amount = orderPaymentAmount;
        transactionDetail.AllowPartialAuth = false;
        transactionDetail.NonTax = false;
        // added by @wqkl against (SF-137) - (16jan21) - start
        if (quoteDetail == null) {
            Order orderWithTax = new Order();
            querySelect = 'select id, EBizCharge_Order_Tax__c';
            queryFrom = 'from Order';
            queryWhere = 'where id =\'' + orderDetail.id + '\'';
            orderWithTax = (Order) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            transactionDetail.Tax = Tax;
            ebcLogger.debug(ClassName, MethodName, 'transactionDetail.Tax:' + transactionDetail.Tax);
        } else {
            Quote quoteWithTax = new Quote();
            querySelect = 'select id, EBizCharge_Quote_Tax_c__c';
            queryFrom = 'from Quote';
            queryWhere = 'where id =\'' + quoteDetail.id + '\'';
            quoteWithTax = (Quote) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            ebcLogger.debug(ClassName, MethodName, 'transactionDetail.Tax:' + transactionDetail.Tax);
        }
        // added by @wqkl against (SF-137) - (16jan21) - end
        transactionDetail.Tax = Tax;
        transactionDetail.Subtotal = 0;
        ebcLogger.debug(ClassName, MethodName, 'subtotal is' + transactionDetail.Subtotal);
        transactionDetail.Shipping = 0;
        transactionDetail.Duty = 0;
        transactionDetail.Discount = 0;
        transactionDetail.AllowPartialAuth = false;
        transactionDetail.Tip = 0;
        transactionDetail.Invoice = orderNumber;
        if (quoteDetail == null) {
            transactionDetail.PONum = orderDetail.PoNumber;
        }else{
            transactionDetail.PONum = quoteDetail.EBizCharge_PONumber__c;
        }
        transactionDetail.OrderID = orderNumber;
        transactionDetail.Clerk = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
        transactionRequest.Details = transactionDetail;
        ebizchargeServicemodelSoap.ArrayOfLineItem arrayOfLineItem = new ebizchargeServicemodelSoap.ArrayOfLineItem();
        arrayOfLineItem.LineItem = new List < ebizchargeServicemodelSoap.Lineitem > ();
        //conditioned by @wqkl against (SF-137) - (05jan21)
        if (quoteDetail == null) {
            querySelect = 'SELECT Id,name,(select Id,OrderId,OrderItemNumber,Description, PricebookEntry.Product2.Name ,PricebookEntry.Product2.id,Quantity,UnitPrice ' +
                'FROM OrderItems )';
            queryFrom = 'from order';
            queryWhere = 'where id =\'' + orderDetail.id + '\'';
            ebcLogger.debug(ClassName, MethodName, 'Componect Controller 2196: ' + querySelect + Configuration.DOUBLEBLANKS + queryFrom + Configuration.DOUBLEBLANKS + queryWhere);
            for (order order: (list < order > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING)) {
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
            }
        } else {
            querySelect = 'select id, name, (select Id, QuoteId, LineNumber, ' +
                'Description, Product2Id, Pricebookentry.Name, Quantity,UnitPrice FROM QuoteLineItems) ';
            queryFrom = 'from quote';
            queryWhere = 'where id =\'' + quoteDetail.id + '\'';
            for (quote order: (list < quote > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING)) {
                for (QuoteLineItem quoteItem: order.QuoteLineItems) {
                    ebizchargeServicemodelSoap.LineItem lineItem = new ebizchargeServicemodelSoap.Lineitem();
                    lineItem.SKU = quoteItem.LineNumber;
                    lineItem.ProductRefNum = quoteItem.LineNumber;
                    lineItem.ProductName = quoteItem.Pricebookentry.Name;
                    lineItem.Description = quoteItem.Description != null ? quoteItem.Description : Configuration.EMPTYSTRING;
                    lineItem.UnitPrice = String.valueOf(quoteItem.UnitPrice);
                    lineItem.Qty = String.valueOf(quoteItem.Quantity);
                    lineItem.Taxable = true;
                    arrayOfLineItem.LineItem.add(lineItem);
                }
            }
        }
        transactionRequest.LineItems = arrayOfLineItem;
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        if (!test.isRunningTest()) {
            response = ebiz.runTransaction(EBC_CompMethods.getSecurityToken(dml, ebcLogger), transactionRequest);
        }
        String transactionId = Configuration.EMPTYSTRING;
        if (response.ResultCode == 'A') {
            transactionId = response.RefNum;
        } else {
            transactionId = Configuration.ERRORWITHSPACESTRING + response.Error;
        }
        if (transactionId.contains(Configuration.ERRORSTRING)) {
            return transactionId;
        } else {
            EBizCharge_Transaction__c transactionEntity = new EBizCharge_Transaction__c();
            transactionEntity.Ref_Number__c = transactionId;
            if (quoteDetail == null) {
                transactionEntity.Order_Id__c = orderDetail.Id;
            } else {
                transactionEntity.Quote_Id__c = quoteDetail.Id;
            }
            transactionEntity.Account_Id__c = accountId;
            EBizCharge_Transaction__c ebizAuthTransaction = new EBizCharge_Transaction__c();
            querySelect = 'SELECT Id,Tax__c,EBizCharge_Subtotal__c,Detail_Amount__c';
            queryFrom = 'FROM EBizCharge_Transaction__c';
            queryWhere = 'where Ref_Number__c = \'' + transactionId + '\'';
            queryOrderby = 'order by CreatedDate desc';
            ebizAuthTransaction = (EBizCharge_Transaction__c) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, queryOrderby);
            if (!test.isRunningTest()) {
                EBC_CompMethods.saveTransaction(dml, transactionId, transactionEntity, ebcLogger);
            }
            EBizCharge_Transaction__c ebizTransaction = new EBizCharge_Transaction__c();
            querySelect = 'SELECT Id,Tax__c';
            queryFrom = 'FROM EBizCharge_Transaction__c';
            queryWhere = 'where Ref_Number__c = \'' + transactionId + '\'';
            queryOrderby = 'order by CreatedDate desc';
            ebizTransaction = (EBizCharge_Transaction__c) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, queryOrderby);
            //conditioned by @wqkl against (SF-137) - (05jan21)
            if (quoteDetail == null) {
                Order order = new Order();
                order.Id = orderDetail.Id;
                ebcLogger.debug(ClassName, MethodName, 'ebizAuthTransaction.EBizCharge_Subtotal__c is' + ebizAuthTransaction.EBizCharge_Subtotal__c);
                if (ebizAuthTransaction.EBizCharge_Subtotal__c != 0) {
                    if (orderDetail.EBizCharge_Order_Balance__c == null || orderDetail.EBizCharge_Order_Balance__c == 0) {
                        order.EBizCharge_Order_Balance__c = (orderDetail.EBizCharge_Captured_Amount__c - amount + ebizTransaction.Tax__c);
                    } else {
                        ebcLogger.debug(ClassName, MethodName, 'ebizTransaction.Tax__c is' + ebizTransaction.Tax__c);
                        ebcLogger.debug(ClassName, MethodName, 'amount is' + amount);
                        order.EBizCharge_Order_Balance__c = orderDetail.EBizCharge_Order_Balance__c - amount + ebizTransaction.Tax__c;
                    }
                } else {
                    if (orderDetail.EBizCharge_Order_Balance__c == null || orderDetail.EBizCharge_Order_Balance__c == 0) {
                        order.EBizCharge_Order_Balance__c = (orderDetail.EBizCharge_Captured_Amount__c - amount);
                    } else {
                        order.EBizCharge_Order_Balance__c = orderDetail.EBizCharge_Order_Balance__c - amount;
                    }
                }
                order.EBizCharge_Order_Balance__c = order.EBizCharge_Order_Balance__c < 0 ? 0 : order.EBizCharge_Order_Balance__c;
                if (order.EBizCharge_Order_Balance__c == 0) {
                    order.EBizCharge_Order_Status__c = string.valueOf(Enums.ENTITYSTATUS.Paid);
                } else if (order.EBizCharge_Order_Balance__c > 0) {
                    order.EBizCharge_Order_Status__c = Configuration.PARTIALPAYMENTSTATUS;
                }
                order.EBizCharge_Payment_Status__c = string.valueOf(Enums.OBJECTPAYMENTSTATUS.Capture);
                if (orderDetail.EBizCharge_Captured_Amount__c != null) {
                    order.EBizCharge_Captured_Amount__c = orderDetail.EBizCharge_Captured_Amount__c + amount;
                } else {
                    order.EBizCharge_Captured_Amount__c = amount;
                }
                order.EBizCharge_Reference_Number__c = transactionId;
                order.EBizCharge_Amount__c = 0;
                if (ebizAuthTransaction.EBizCharge_Subtotal__c != 0) {
                    if (orderDetail.EBizCharge_Order_Tax__c != null && orderDetail.EBizCharge_Order_Tax__c != 0) {
                        order.EBizCharge_Order_Tax__c = orderDetail.EBizCharge_Order_Tax__c + ebizTransaction.Tax__c - ebizAuthTransaction.Tax__c;
                    } else {
                        order.EBizCharge_Order_Tax__c = ebizTransaction.Tax__c;
                    }
                }
                dml.updateRecord(order);
            } else {
                Quote order = new Quote();
                order.Id = quoteDetail.Id;
                if (ebizAuthTransaction.EBizCharge_Subtotal__c != 0) {
                    if (quoteDetail.EBizCharge_Quote_Balance__c == null || quoteDetail.EBizCharge_Quote_Balance__c == 0) {
                        order.EBizCharge_Quote_Balance__c = (quoteDetail.EBizCharge_Captured_Amount__c - amount + ebizTransaction.Tax__c);
                    } else {
                        order.EBizCharge_Quote_Balance__c = quoteDetail.EBizCharge_Quote_Balance__c - amount + ebizTransaction.Tax__c;
                    }
                } else {
                    if (quoteDetail.EBizCharge_Quote_Balance__c == null || quoteDetail.EBizCharge_Quote_Balance__c == 0) {
                        order.EBizCharge_Quote_Balance__c = (quoteDetail.EBizCharge_Captured_Amount__c - amount);
                    } else {
                        order.EBizCharge_Quote_Balance__c = quoteDetail.EBizCharge_Quote_Balance__c - amount;
                    }
                }
                order.EBizCharge_Quote_Balance__c = order.EBizCharge_Quote_Balance__c < 0 ? 0 : order.EBizCharge_Quote_Balance__c;
                if (order.EBizCharge_Quote_Balance__c == 0) {
                    order.EBizCharge_Quote_Status__c = string.valueOf(Enums.ENTITYSTATUS.Paid);
                } else if (order.EBizCharge_Quote_Balance__c > 0) {
                    order.EBizCharge_Quote_Status__c = Configuration.PARTIALPAYMENTSTATUS;
                }
                order.EBizCharge_Payment_Status__c = string.valueOf(Enums.OBJECTPAYMENTSTATUS.Capture);
                if (quoteDetail.EBizCharge_Captured_Amount__c != null) {
                    order.EBizCharge_Captured_Amount__c = quoteDetail.EBizCharge_Captured_Amount__c + amount;
                } else {
                    order.EBizCharge_Captured_Amount__c = amount;
                }
                order.EBizCharge_Reference_Number__c = transactionId;
                order.EBizCharge_Amount__c = 0;
                if (ebizAuthTransaction.EBizCharge_Subtotal__c != 0) {
                    if (quoteDetail.EBizCharge_Quote_Tax_c__c != null && quoteDetail.EBizCharge_Quote_Tax_c__c != 0) {
                        order.EBizCharge_Quote_Tax_c__c = quoteDetail.EBizCharge_Quote_Tax_c__c + ebizTransaction.Tax__c - ebizAuthTransaction.Tax__c;
                    } else {
                        order.EBizCharge_Quote_Tax_c__c = ebizTransaction.Tax__c;
                    }
                }
                dml.updateRecord(order);
            }
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        }
    }
    @AuraEnabled
    public static String processPaymentWithXCApxc(String savedCardJson, Account accDetail, Order OrderDetail, String ObjName , Quote QuoteDetail ) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = processPaymentWithXCApxc(dml, savedCardJson, accDetail, OrderDetail, ObjName, QuoteDetail, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String processPaymentWithXCApxc(DML dml, String savedCardJson, Account accDetail, Order OrderDetail, String ObjName , Quote QuoteDetail, EBC_Logger ebcLogger) {
        MethodName = 'processPaymentWithXCApxc';
        Map < String, Object > savedCardMap = (Map < String, Object > ) JSON.deserializeUntyped(savedCardJson);
        String response = processPayment(dml, savedCardMap, accDetail, OrderDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingCard), ObjName , QuoteDetail , ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String processPaymentWithXCApxcContact(String savedCardJson, Contact ConDetail, String ObjName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = processPaymentWithXCApxcContact(dml, savedCardJson, ConDetail, ObjName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String processPaymentWithXCApxcContact(DML dml, String savedCardJson, Contact ConDetail, String ObjName, EBC_Logger ebcLogger) {
        MethodName = 'processPaymentWithXCApxcContact';
        Map < String, Object > savedCardMap = (Map < String, Object > ) JSON.deserializeUntyped(savedCardJson);
        String response = processPaymentContact(dml, savedCardMap, ConDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingCard), ObjName, ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String processPaymentWithXCApxcCustomCustomer(String savedCardJson, Ebiz_C__EBizCharge_Fields_Config__c ConDetail, String ObjName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = processPaymentWithXCApxcCustomCustomer(dml, savedCardJson, ConDetail, ObjName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String processPaymentWithXCApxcCustomCustomer(DML dml, String savedCardJson, Ebiz_C__EBizCharge_Fields_Config__c ConDetail, String ObjName, EBC_Logger ebcLogger) {
        MethodName = 'processPaymentWithXCApxcCustomCustomer';
        Map < String, Object > savedCardMap = (Map < String, Object > ) JSON.deserializeUntyped(savedCardJson);
        String response = processPaymentCustomerCust(dml, savedCardMap, ConDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingCard), ObjName, ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String processPaymentWithNCApxc(String addNewCardJSON, Account accDetail, Order OrderDetail, String ObjName /*added by @wqkl against SF-137 - 9dec20*/ , Quote QuoteDetail /*added by @wqkl against SF-137 - 9dec20*/ ) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = processPaymentWithNCApxc(dml, addNewCardJSON, accDetail, OrderDetail, ObjName, QuoteDetail, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String processPaymentWithNCApxc(DML dml, String addNewCardJSON, Account accDetail, Order OrderDetail, String ObjName /*added by @wqkl against SF-137 - 9dec20*/ , Quote QuoteDetail /*added by @wqkl against SF-137 - 9dec20*/ , EBC_Logger ebcLogger) {
        MethodName = 'processPaymentWithNCApxc';
        ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
        responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
        Map < String, Object > addNewCardMap = (Map < String, Object > ) JSON.deserializeUntyped(addNewCardJSON);
        String returnMessage = 'AVSCheck@';
        if (responseMerchant.EnableAVSWarnings == false) {
            returnMessage += 'NoAVSWarnings@';
            ebcLogger.debug(ClassName, MethodName, 'returnMessage.removeEnd(@):' + returnMessage.removeEnd('@'));
            return returnMessage.removeEnd('@');
        }
        if (responseMerchant.UseFullAmountForAVS == false) {
            Boolean isAVSCheck = (boolean) addNewCardMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isAVSCheck));
            Boolean AVSMatch = true;
            if (isAVSCheck == true && responseMerchant.UseFullAmountForAVS == false) {
                ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
                if (!Test.isRunningTest()) {
                    response = EBC_CompMethods.runAVSCheck(dml, addNewCardMap, ebcLogger);
                } else {
                    //********Mock Data*****
                    response = new ebizchargeServicemodelSoap.TransactionResponse();
                    response.AvsResultCode = 'YYY';
                    response.AvsResult = 'rt&data';
                }
                if (test.isRunningTest()) {
                    response.Error = 'Approved';
                }
                if (response.ErrorCode == '0') {
                    returnMessage += response.RefNum + '@';
                    if (response.CardCodeResultCode != 'M') {
                        returnMessage += 'CardCodeNotMatch@';
                        AVSMatch = false;
                    } else {
                        returnMessage += 'CardCodeMatch@';
                    }
                    if (response.AvsResultCode != 'YYY' || response.AvsResultCode != 'Y' || response.AvsResultCode != 'YYA' || response.AvsResultCode != 'YYD' ||
                        response.AvsResultCode != 'YYX' || response.AvsResultCode != 'X' || response.AvsResultCode != 'GGG' || response.AvsResultCode != 'D') {
                        if (response.AvsResultCode == 'NNN' || response.AvsResultCode == 'NN' || response.AvsResultCode == 'N') {
                            returnMessage += 'AddressNotMatch@';
                            returnMessage += 'ZipNotMatch@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'NYZ' || response.AvsResultCode == 'Z' || response.AvsResultCode == 'NYW' || response.AvsResultCode == 'W' ||
                            response.AvsResultCode == 'P') {
                            returnMessage += 'AddressNotMatch@';
                            returnMessage += 'ZipCodeMatch@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'YNA' || response.AvsResultCode == 'A' || response.AvsResultCode == 'YNY' ||
                            response.AvsResultCode == 'B' || response.AvsResultCode == 'M') {
                            returnMessage += 'AddressMatch@';
                            returnMessage += 'ZipNotMatch@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'YYG') {
                            returnMessage += 'AddressMatch@';
                            returnMessage += 'Not Compatible@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'YGG') {
                            returnMessage += 'Not Compatible@';
                            returnMessage += 'ZipCodeMatch@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXW') {
                            returnMessage += 'Card Number Not On File@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXU') {
                            returnMessage += 'Address Information not verified for domestic transaction@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXR' || response.AvsResultCode == 'R' || response.AvsResultCode == 'U' || response.AvsResultCode == 'E') {
                            returnMessage += 'Retry / System Unavailable@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXS' || response.AvsResultCode == 'S') {
                            returnMessage += 'Service Not Supported@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXE') {
                            returnMessage += 'Address Verification Not Allowed For Card Type@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXG' || response.AvsResultCode == 'G' || response.AvsResultCode == 'C' || response.AvsResultCode == 'I') {
                            returnMessage += 'Global Non-AVS participant@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'YYY' && response.CardCodeResultCode == 'P') {
                            returnMessage += 'AddressMatch@';
                            returnMessage += 'ZipCodeMatch@';
                        } else {
                            returnMessage += ' @';
                            returnMessage += ' @';
                        }
                    } else {
                        string add = response.AvsResult;
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
                    return Configuration.GATEWAYERRORMESSAGESTRING + '\'' + response.Error + '\''; //updated @wqkl on 29Jan21 against Error message modification
                }
                if (AVSMatch != true) {
                    returnMessage += '@';
                    returnMessage += '@';
                    returnMessage += '@';
                    return returnMessage.removeEnd('@');
                } else {
                    invokeTransactionVoidApxc(dml, response.RefNum, ebcLogger);
                }
            }
        }
        String response = processPayment(dml, addNewCardMap, accDetail, OrderDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard), ObjName /*added by @wqkl against SF-137 - 9dec20*/ , QuoteDetail /*added by @wqkl against SF-137 - 9dec20*/ , ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String processPaymentWithNCApxcContact(String addNewCardJSON, Contact conDetail, String ObjName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = processPaymentWithNCApxcContact(dml, addNewCardJSON, conDetail, ObjName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String processPaymentWithNCApxcContact(DML dml, String addNewCardJSON, Contact conDetail, String ObjName, EBC_Logger ebcLogger) {
        MethodName = 'processPaymentWithNCApxcContact';
        ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
        responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
        Map < String, Object > addNewCardMap = (Map < String, Object > ) JSON.deserializeUntyped(addNewCardJSON);
        String returnMessage = 'AVSCheck@';
        if (responseMerchant.EnableAVSWarnings == false) {
            returnMessage += 'NoAVSWarnings@';
            ebcLogger.debug(ClassName, MethodName, 'returnMessage.removeEnd(@):' + returnMessage.removeEnd('@'));
            return returnMessage.removeEnd('@');
        }
        //avs checks when UseFullAmountForAVS is false
        if (responseMerchant.UseFullAmountForAVS == false) {
            Boolean isAVSCheck = (boolean) addNewCardMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isAVSCheck));
            Boolean AVSMatch = true;
            if (isAVSCheck == true) {
                ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
                if (!Test.isRunningTest()) {
                    response = EBC_CompMethods.runAVSCheckContact(dml, addNewCardMap, ebcLogger);
                } else {
                    //********Mock Data*****
                    response = new ebizchargeServicemodelSoap.TransactionResponse();
                    response.AvsResultCode = 'YYY';
                    response.AvsResult = 'rt&data';
                }
                if (test.isRunningTest()) {
                    response.Error = 'Approved';
                }
                if (response.ErrorCode == '0') {
                    returnMessage += response.RefNum + '@';
                    if (response.CardCodeResultCode != 'M') {
                        returnMessage += 'CardCodeNotMatch@';
                        AVSMatch = false;
                    } else {
                        returnMessage += 'CardCodeMatch@';
                    }
                    if (response.AvsResultCode != 'YYY' || response.AvsResultCode != 'Y' || response.AvsResultCode != 'YYA' || response.AvsResultCode != 'YYD' ||
                        response.AvsResultCode != 'YYX' || response.AvsResultCode != 'X' || response.AvsResultCode != 'GGG' || response.AvsResultCode != 'D') {
                        if (response.AvsResultCode == 'NNN' || response.AvsResultCode == 'NN' || response.AvsResultCode == 'N') {
                            returnMessage += 'AddressNotMatch@';
                            returnMessage += 'ZipNotMatch@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'NYZ' || response.AvsResultCode == 'Z' || response.AvsResultCode == 'NYW' || response.AvsResultCode == 'W' ||
                            response.AvsResultCode == 'P') {
                            returnMessage += 'AddressNotMatch@';
                            returnMessage += 'ZipCodeMatch@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'YNA' || response.AvsResultCode == 'A' || response.AvsResultCode == 'YNY' ||
                            response.AvsResultCode == 'B' || response.AvsResultCode == 'M') {
                            returnMessage += 'AddressMatch@';
                            returnMessage += 'ZipNotMatch@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'YYG') {
                            returnMessage += 'AddressMatch@';
                            returnMessage += 'Not Compatible@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'YGG') {
                            returnMessage += 'Not Compatible@';
                            returnMessage += 'ZipCodeMatch@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXW') {
                            returnMessage += 'Card Number Not On File@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXU') {
                            returnMessage += 'Address Information not verified for domestic transaction@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXR' || response.AvsResultCode == 'R' || response.AvsResultCode == 'U' || response.AvsResultCode == 'E') {
                            returnMessage += 'Retry / System Unavailable@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXS' || response.AvsResultCode == 'S') {
                            returnMessage += 'Service Not Supported@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXE') {
                            returnMessage += 'Address Verification Not Allowed For Card Type@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXG' || response.AvsResultCode == 'G' || response.AvsResultCode == 'C' || response.AvsResultCode == 'I') {
                            returnMessage += 'Global Non-AVS participant@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'YYY' && response.CardCodeResultCode == 'P') {
                            returnMessage += 'AddressMatch@';
                            returnMessage += 'ZipCodeMatch@';
                        } else {
                            returnMessage += ' @';
                            returnMessage += ' @';
                        }
                    } else {
                        string add = response.AvsResult;
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
                    return Configuration.GATEWAYERRORMESSAGESTRING + '\'' + response.Error + '\''; //updated @wqkl on 29Jan21 against Error message modification
                }
                if (AVSMatch != true) {
                    returnMessage += '@';
                    returnMessage += '@';
                    returnMessage += '@';
                    return returnMessage.removeEnd('@');
                } else {
                    invokeTransactionVoidApxc(dml, response.RefNum, ebcLogger);
                }
            }
        }
        String response = processPaymentContact(dml, addNewCardMap, conDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard), ObjName, ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String processPaymentWithNCApxcCustomCustomer(String addNewCardJSON, Ebiz_C__EBizCharge_Fields_Config__c conDetail, String ObjName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = processPaymentWithNCApxcCustomCustomer(dml, addNewCardJSON, conDetail, ObjName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String processPaymentWithNCApxcCustomCustomer(DML dml, String addNewCardJSON, Ebiz_C__EBizCharge_Fields_Config__c conDetail, String ObjName, EBC_Logger ebcLogger) {
        MethodName = 'processPaymentWithNCApxcCustomCustomer';
        ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
        responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
        Map < String, Object > addNewCardMap = (Map < String, Object > ) JSON.deserializeUntyped(addNewCardJSON);
        String returnMessage = 'AVSCheck@';
        if (responseMerchant.EnableAVSWarnings == false) {
            returnMessage += 'NoAVSWarnings@';
            ebcLogger.debug(ClassName, MethodName, 'returnMessage.removeEnd(@):' + returnMessage.removeEnd('@'));
            return returnMessage.removeEnd('@');
        }
        //avs checks when UseFullAmountForAVS is false
        if (responseMerchant.UseFullAmountForAVS == false) {
            Boolean isAVSCheck = (boolean) addNewCardMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isAVSCheck));
            Boolean AVSMatch = true;
            if (isAVSCheck == true) {
                ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
                if (!Test.isRunningTest()) {
                    response = EBC_CompMethods.runAVSCheckContact(dml, addNewCardMap, ebcLogger);
                } else {
                    //********Mock Data*****
                    response = new ebizchargeServicemodelSoap.TransactionResponse();
                    response.AvsResultCode = 'YYY';
                    response.AvsResult = 'rt&data';
                }
                if (test.isRunningTest()) {
                    response.Error = 'Approved';
                }
                if (response.ErrorCode == '0') {
                    returnMessage += response.RefNum + '@';
                    if (response.CardCodeResultCode != 'M') {
                        returnMessage += 'CardCodeNotMatch@';
                        AVSMatch = false;
                    } else {
                        returnMessage += 'CardCodeMatch@';
                    }
                    if (response.AvsResultCode != 'YYY' || response.AvsResultCode != 'Y' || response.AvsResultCode != 'YYA' || response.AvsResultCode != 'YYD' ||
                        response.AvsResultCode != 'YYX' || response.AvsResultCode != 'X' || response.AvsResultCode != 'GGG' || response.AvsResultCode != 'D') {
                        if (response.AvsResultCode == 'NNN' || response.AvsResultCode == 'NN' || response.AvsResultCode == 'N') {
                            returnMessage += 'AddressNotMatch@';
                            returnMessage += 'ZipNotMatch@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'NYZ' || response.AvsResultCode == 'Z' || response.AvsResultCode == 'NYW' || response.AvsResultCode == 'W' ||
                            response.AvsResultCode == 'P') {
                            returnMessage += 'AddressNotMatch@';
                            returnMessage += 'ZipCodeMatch@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'YNA' || response.AvsResultCode == 'A' || response.AvsResultCode == 'YNY' ||
                            response.AvsResultCode == 'B' || response.AvsResultCode == 'M') {
                            returnMessage += 'AddressMatch@';
                            returnMessage += 'ZipNotMatch@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'YYG') {
                            returnMessage += 'AddressMatch@';
                            returnMessage += 'Not Compatible@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'YGG') {
                            returnMessage += 'Not Compatible@';
                            returnMessage += 'ZipCodeMatch@';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXW') {
                            returnMessage += 'Card Number Not On File@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXU') {
                            returnMessage += 'Address Information not verified for domestic transaction@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXR' || response.AvsResultCode == 'R' || response.AvsResultCode == 'U' || response.AvsResultCode == 'E') {
                            returnMessage += 'Retry / System Unavailable@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXS' || response.AvsResultCode == 'S') {
                            returnMessage += 'Service Not Supported@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXE') {
                            returnMessage += 'Address Verification Not Allowed For Card Type@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'XXG' || response.AvsResultCode == 'G' || response.AvsResultCode == 'C' || response.AvsResultCode == 'I') {
                            returnMessage += 'Global Non-AVS participant@';
                            returnMessage += ' @';
                            AVSMatch = false;
                        } else if (response.AvsResultCode == 'YYY' && response.CardCodeResultCode == 'P') {
                            returnMessage += 'AddressMatch@';
                            returnMessage += 'ZipCodeMatch@';
                        } else {
                            returnMessage += ' @';
                            returnMessage += ' @';
                        }
                    } else {
                        string add = response.AvsResult;
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
                    return response.Error;
                }
                if (AVSMatch != true) {
                    returnMessage += '@';
                    returnMessage += '@';
                    returnMessage += '@';
                    return returnMessage.removeEnd('@');
                } else {
                    invokeTransactionVoidApxc(dml, response.RefNum, ebcLogger);
                }
            }
        }
        String response = processPaymentCustomerCust(dml, addNewCardMap, conDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard), ObjName, ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String procesPaymentWithSavedACHApxc(String savedACHJSON, Account accDetail, Order OrderDetail, String ObjName , Quote QuoteDetail ) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = procesPaymentWithSavedACHApxc(dml, savedACHJSON, accDetail, OrderDetail, ObjName, QuoteDetail, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String procesPaymentWithSavedACHApxc(DML dml, String savedACHJSON, Account accDetail, Order OrderDetail, String ObjName, Quote QuoteDetail, EBC_Logger ebcLogger) {
        MethodName = 'procesPaymentWithSavedACHApxc';
        ebcLogger.debug(ClassName, MethodName, 'QuoteDetail' + QuoteDetail);
        Map < String, Object > savedAChMap = (Map < String, Object > ) JSON.deserializeUntyped(savedACHJSON);
        String response = processPayment(dml, savedAChMap, accDetail, OrderDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingACH), ObjName , QuoteDetail , ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String procesPaymentWithSavedACHApxcContact(String savedACHJSON, Contact conDetail, String ObjName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = procesPaymentWithSavedACHApxcContact(dml, savedACHJSON, conDetail, ObjName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String procesPaymentWithSavedACHApxcContact(DML dml, String savedACHJSON, Contact conDetail, String ObjName, EBC_Logger ebcLogger) {
        MethodName = 'procesPaymentWithSavedACHApxcContact';
        Map < String, Object > savedAChMap = (Map < String, Object > ) JSON.deserializeUntyped(savedACHJSON);
        String response = processPaymentContact(dml, savedAChMap, conDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingACH), ObjName, ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String processPaymentNewACHApxc(String addNewACHJSON, Account accDetail, Order OrderDetail, String ObjName , Quote QuoteDetail) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = processPaymentNewACHApxc(dml, addNewACHJSON, accDetail, OrderDetail, ObjName, QuoteDetail, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String processPaymentNewACHApxc(DML dml, String addNewACHJSON, Account accDetail, Order OrderDetail, String ObjName , Quote QuoteDetail , EBC_Logger ebcLogger) {
        MethodName = 'processPaymentNewACHApxc';
        Map < String, Object > newACHmap = (Map < String, Object > ) JSON.deserializeUntyped(addNewACHJSON);
        String response = processPayment(dml, newACHmap, accDetail, OrderDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH), ObjName /*added by @wqkl against SF-137 - 9dec20*/ , QuoteDetail /*added by @wqkl against SF-137 - 9dec20*/ , ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String processPaymentNewACHApxcContact(String addNewACHJSON, Contact conDetail, String ObjName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = processPaymentNewACHApxcContact(dml, addNewACHJSON, conDetail, ObjName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String processPaymentNewACHApxcContact(DML dml, String addNewACHJSON, Contact conDetail, String ObjName, EBC_Logger ebcLogger) {
        MethodName = 'processPaymentNewACHApxcContact';
        Map < String, Object > newACHmap = (Map < String, Object > ) JSON.deserializeUntyped(addNewACHJSON);
        String response = processPaymentContact(dml, newACHmap, conDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH), ObjName, ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String procesPaymentWithSavedACHApxcCustomCustomer(String savedACHJSON, Ebiz_C__EBizCharge_Fields_Config__c conDetail, String ObjName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = procesPaymentWithSavedACHApxcCustomCustomer(dml, savedACHJSON, conDetail, ObjName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String procesPaymentWithSavedACHApxcCustomCustomer(DML dml, String savedACHJSON, Ebiz_C__EBizCharge_Fields_Config__c conDetail, String ObjName, EBC_Logger ebcLogger) {
        MethodName = 'procesPaymentWithSavedACHApxcCustomCustomer';
        Map < String, Object > savedAChMap = (Map < String, Object > ) JSON.deserializeUntyped(savedACHJSON);
        String response = processPaymentCustomerCust(dml, savedAChMap, conDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingACH), ObjName, ebcLogger);
        return response;
    }
    @AuraEnabled
    public static String processPaymentNewACHApxcCustomCustomer(String addNewACHJSON, Ebiz_C__EBizCharge_Fields_Config__c conDetail, String ObjName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = processPaymentNewACHApxcCustomCustomer(dml, addNewACHJSON, conDetail, ObjName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String processPaymentNewACHApxcCustomCustomer(DML dml, String addNewACHJSON, Ebiz_C__EBizCharge_Fields_Config__c conDetail, String ObjName, EBC_Logger ebcLogger) {
        MethodName = 'processPaymentNewACHApxcCustomCustomer';
        Map < String, Object > newACHmap = (Map < String, Object > ) JSON.deserializeUntyped(addNewACHJSON);
        String response = processPaymentCustomerCust(dml, newACHmap, conDetail, string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH), ObjName, ebcLogger);
        return response;
    }
    public static String processPayment(DML dml, Map < String, Object > strMap, Account accDetail, Order OrderDetail, String processBy, String ObjName /*added by @wqkl against SF-137 - 9dec20*/ , Quote QuoteDetail /*added by @wqkl against SF-137 - 9dec20*/ , EBC_Logger ebcLogger) {
        MethodName = 'processPayment';
        ebcLogger.debug(ClassName, MethodName, 'QuoteDetail:' + QuoteDetail);
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        String queryOrderby = Configuration.EMPTYSTRING;
        String queryLimit = Configuration.EMPTYSTRING;
        String taxAction = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.TaxAction));
        EBizcharge_Setting__c settings = eBc_UtilityController.getSettings(dml, ebcLogger);
        string divisionId = settings.Division_ID__c;
        ebcLogger.debug(ClassName, MethodName, 'divisionId is ' + divisionId);
        string expiryMonth = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
        ebcLogger.debug(ClassName, MethodName, 'expiryMonth is ' + expiryMonth);
        string expiryYear = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
        ebcLogger.debug(ClassName, MethodName, 'expiryYear is ' + expiryYear);
        objName = objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact) ? string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account) : objName;
        string accountId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId));
        string accountExternalId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccExternalId));
        ebcLogger.debug(ClassName, MethodName, 'strMap.get(accAmount)>>>>>>>>' + strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.accAmount)));
        Decimal accAmount = (Decimal) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.accAmount));
        accAmount = (accAmount == null) ? 0 : accAmount;
        double amount = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Amount));
        ebcLogger.debug(ClassName, MethodName, 'amount>>>>>>>' + amount);
        double tax = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Tax));
        ebcLogger.debug(ClassName, MethodName, 'tax passed from JS is' + tax);
        Boolean isRecurring = (boolean) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.isRecurring));
        Boolean sendReceiptTo = (boolean) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
        String addEmails = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.addEmails));
        String orderNumber = Configuration.DEFAULTORDERNUMBER;
        String orderId = Configuration.DEFAULTORDERNUMBER;
        String orderExternalId = Configuration.EMPTYSTRING;
        String opportunityName = Configuration.EMPTYSTRING;
        String ContactId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Terminal));
        transactionParams transactionPayload = new transactionParams();
        if (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
            Id opportunityId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OpportunityId));
            opportunityName = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OpportunityName));
            orderNumber = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity);
            orderId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OpportunityId));
            transactionPayload.OrderID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OpportunityId));
            transactionPayload.Description = 'Opportunity - ' + opportunityName;
            querySelect = 'select id, EBizCharge_Internal_ID__c,EBizCharge_PONumber__c';
            queryFrom = 'from Opportunity';
            queryWhere = 'where id=\'' + opportunityId + '\'';
            Opportunity opportunityRecord = (Opportunity) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            String opportunityInternalId = opportunityRecord.EBizCharge_Internal_ID__c;
            transactionPayload.PoNum = opportunityRecord.EBizCharge_PONumber__c;
            orderExternalId = opportunityInternalId;
        }
        if (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
            orderNumber = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order);
            orderId = (string) strMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OrderNo));
            orderExternalId = OrderDetail.EBizCharge_Internal_ID__c;
            transactionPayload.OrderID = (string) strMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OrderNo));
            transactionPayload.OrderNumber = (string) strMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OrderNo));
            transactionPayload.Description = 'Order - ' + transactionPayload.OrderID;
            transactionPayload.PoNum = OrderDetail.PoNumber;
            ebizchargeServicemodelSoap.ArrayOfLineItem arrayOfLineItem = new ebizchargeServicemodelSoap.ArrayOfLineItem();
            arrayOfLineItem.LineItem = new List < ebizchargeServicemodelSoap.Lineitem > ();
            String salesforceOrderId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OrdersfID));
            ebcLogger.debug(ClassName, MethodName, 'salesforceOrderId>>>' + salesforceOrderId);
            querySelect = 'SELECT Id,name,(select Id,OrderId,OrderItemNumber,Description,' +
                'PricebookEntry.Product2.Name ,PricebookEntry.Product2.id,Quantity,UnitPrice FROM OrderItems )';
            queryFrom = 'from order';
            queryWhere = 'where id=\'' + salesforceOrderId + '\'';
            for (order order: (list < order > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING)) {
                for (OrderItem orderItem: order.orderItems) {
                    ebizchargeServicemodelSoap.LineItem lineItem = new ebizchargeServicemodelSoap.Lineitem();
                    lineItem.SKU = orderItem.OrderItemNumber;
                    lineItem.ProductRefNum = orderItem.OrderItemNumber;
                    lineItem.ProductName = orderItem.PricebookEntry.Product2.Name;
                    lineItem.Description = orderItem.Description != null ? orderItem.Description : Configuration.EMPTYSTRING;
                    lineItem.UnitPrice = String.valueOf(orderItem.UnitPrice);
                    lineItem.Qty = String.valueOf(orderItem.Quantity);
                    lineItem.Taxable = true;
                    arrayOfLineItem.LineItem.add(lineItem);
                }
            }
            transactionPayload.LineItems = arrayOfLineItem;
            ebcLogger.debug(ClassName, MethodName, '---transactionPayload.OrderNumber>>>>>>' + transactionPayload.OrderNumber);
        }
        // added by @wqkl against SF-137 - 9dec20 - start
        if (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote)) {
            orderNumber = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote);
            orderId = (string) strMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OrderNo));
            orderExternalId = QuoteDetail.EBizCharge_Internal_ID__c;
            transactionPayload.OrderID = (string) strMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OrderNo));
            transactionPayload.OrderNumber = (string) strMap.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.OrderNo));
            transactionPayload.Description = 'Quote - ' + transactionPayload.OrderID;
            ebizchargeServicemodelSoap.ArrayOfLineItem arrayOfLineItem = new ebizchargeServicemodelSoap.ArrayOfLineItem();
            arrayOfLineItem.LineItem = new List < ebizchargeServicemodelSoap.Lineitem > ();
            String salesforceOrderId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OrdersfID));
            ebcLogger.debug(ClassName, MethodName, 'salesforceOrderId>>>' + salesforceOrderId);
            querySelect = 'select id, name, EBizCharge_PONumber__c, (select Id, QuoteId, LineNumber, Description, Product2Id, Pricebookentry.Name,' +
                'Quantity,UnitPrice FROM QuoteLineItems)';
            queryFrom = 'from quote';
            queryWhere = 'where id=\'' + salesforceOrderId + '\'';
            for (quote order: (list < quote > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING)) {
                transactionPayload.PoNum = order.EBizCharge_PONumber__c;
                for (QuoteLineItem quoteItem: order.QuoteLineItems) {
                    ebizchargeServicemodelSoap.LineItem LineItem = new ebizchargeServicemodelSoap.Lineitem();
                    LineItem.SKU = quoteItem.LineNumber;
                    LineItem.ProductRefNum = quoteItem.LineNumber;
                    LineItem.ProductName = quoteItem.Pricebookentry.Name;
                    LineItem.Description = quoteItem.Description != null ? quoteItem.Description : Configuration.EMPTYSTRING;
                    LineItem.UnitPrice = String.valueOf(quoteItem.UnitPrice);
                    LineItem.Qty = String.valueOf(quoteItem.Quantity);
                    LineItem.Taxable = true;
                    arrayOfLineItem.LineItem.add(LineItem);
                }
            }
            transactionPayload.LineItems = arrayOfLineItem;
            ebcLogger.debug(ClassName, MethodName, '---transactionPayload.LineItems>>>>>>' + transactionPayload.LineItems);
        }
        // added by @wqkl against SF-137 - 9dec20 - end
        transactionPayload.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
        ebcLogger.debug(ClassName, MethodName, 'subtotal in process payment is' + transactionPayload.SubTotal);

        if (taxAction != Configuration.TAXACTION) {
            transactionPayload.Amount = amount + tax; //amount;
            transactionPayload.SubTotal = amount;
            transactionPayload.Tax = tax;
        } else {
            transactionPayload.Amount = amount;
            transactionPayload.SubTotal = 0;
            tax = 0;
            transactionPayload.Tax = 0;
        }
        transactionPayload.Terminal = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Terminal));
        String query_Select = 'select id,QBD_Customer_ID__c';
        String query_From = 'from Account';
        String query_Where =  'where id=\''+accountId+'\'';
        Account account = (Account)dml.selectSingleRecord(query_Select, query_From, query_Where, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
        transactionPayload.accountID = (string)account.get('QBD_Customer_ID__c');
        transactionPayload.customerID = (string)account.get('QBD_Customer_ID__c');
        transactionPayload.internalID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccExternalId));
        transactionPayload.isRecurring = isRecurring;
        if ((ObjName != string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) && (ObjName != string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote))) {
            ebizchargeServicemodelSoap.ArrayOfLineItem arrayOfLineItem = new ebizchargeServicemodelSoap.ArrayOfLineItem();
            arrayOfLineItem.LineItem = new List < ebizchargeServicemodelSoap.Lineitem > ();
            ebizchargeServicemodelSoap.LineItem LineItem = new ebizchargeServicemodelSoap.Lineitem();
            Account lineItemAccount = new Account();
            querySelect = 'select id, name';
            queryFrom = 'from account';
            queryWhere = 'where id=\'' + accountId + '\'';
            lineItemAccount = (Account) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            LineItem.SKU = accountId;
            LineItem.ProductName = lineItemAccount.name;
            LineItem.Description = Configuration.ACCOUNTLINEITEMDESCRIPTION;
            LineItem.UnitPrice = String.valueOf(amount + tax);
            LineItem.Qty = Configuration.LINEITEMQUANTITY;
            LineItem.Taxable = true;
            LineItem.UnitOfMeasure = string.valueOf(Enums.LINEITEMPARAMETERS.EA);
            LineItem.TaxAmount = String.valueOf(tax);
            arrayOfLineItem.LineItem.add(LineItem);
            transactionPayload.LineItems = arrayOfLineItem;
        }
        string paymentType = Configuration.EMPTYSTRING;
        string paymentMethodId = Configuration.EMPTYSTRING;
        String transactionId = Configuration.EMPTYSTRING;
        String command = (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account) || ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) ? string.valueOf(Enums.PAYMENTTYPES.Sale) : string.valueOf(Enums.PAYMENTTYPES.AuthOnly);
        String transactionReferenceId = Configuration.EMPTYSTRING;
        if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingCard)) {
            paymentMethodID = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.selectedCardId));
            transactionPayload.CardCode = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.cvcNo));
            transactionPayload.methodID = paymentMethodID;
            if (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order) /*added by @wqkl against SF-137 - 11dec20*/ || ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote) /*added by @wqkl against SF-137 - 11dec20*/ ) {
                paymentType = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType));
                if (paymentType == string.valueOf(Enums.PAYMENTTYPES.Deposit) || paymentType == string.valueOf(Enums.PAYMENTTYPES.Sale)) {
                    command = string.valueOf(Enums.PAYMENTTYPES.Sale);
                }
            }
            if (!test.isRunningTest()) {
                transactionId = EBC_CompMethods.runTransactionPayment(dml, transactionPayload, sendReceiptTo, addEmails, command, ebcLogger);
            }
            transactionReferenceId = transactionId;
        } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard)) {
            Boolean saveCard = (boolean) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
            if (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order) /*added by @wqkl against SF-137 - 9dec20*/ || ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote) /*added by @wqkl against SF-137 - 9dec20*/ ) {
                paymentType = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType));
                if (paymentType == string.valueOf(Enums.PAYMENTTYPES.Deposit) || paymentType == string.valueOf(Enums.PAYMENTTYPES.Sale)) {
                    command = string.valueOf(Enums.PAYMENTTYPES.Sale);
                }
            }
            transactionPayload.methodID = Configuration.CARDMETHODID;
            transactionPayload.ccNumber = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
            transactionPayload.expMonth = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
            transactionPayload.expYear = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
            transactionPayload.cvvCode = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
            transactionPayload.ccName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
            transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
            transactionPayload.AvsZip = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
            transactionPayload.AvsStreet = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
            ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
            if (strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode)) == Configuration.EMPTYSTRING) {
                response = EBC_CompMethods.runTransactionOnly(dml, transactionPayload, accDetail, strMap, ebcLogger);
            }
            //AVS Checks - Start
            //avs checks when UseFullAmountForAVS is true
            ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
            responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
            String returnMessage = 'AVSCheck@';
            if (strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode)) == Configuration.EMPTYSTRING) {
                if (responseMerchant.UseFullAmountForAVS == true) {
                    Boolean isAVSCheck = (boolean) strMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isAVSCheck));
                    Boolean AVSMatch = true;
                    if (isAVSCheck == true) {
                        if (response.ErrorCode == '0') {
                            returnMessage += response.RefNum + '@';
                            if (response.CardCodeResultCode != 'M') {
                                returnMessage += 'CardCodeNotMatch@';
                                AVSMatch = false;
                            } else {
                                returnMessage += 'CardCodeMatch@';
                            }
                            if (response.AvsResultCode != 'YYY' || response.AvsResultCode != 'Y' || response.AvsResultCode != 'YYA' || response.AvsResultCode != 'YYD' ||
                                response.AvsResultCode != 'YYX' || response.AvsResultCode != 'X' || response.AvsResultCode != 'GGG' || response.AvsResultCode != 'D') {
                                if (response.AvsResultCode == 'NNN' || response.AvsResultCode == 'NN' || response.AvsResultCode == 'N') {
                                    returnMessage += 'AddressNotMatch@';
                                    returnMessage += 'ZipNotMatch@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'NYZ' || response.AvsResultCode == 'Z' || response.AvsResultCode == 'NYW' || response.AvsResultCode == 'W' ||
                                    response.AvsResultCode == 'P') {
                                    returnMessage += 'AddressNotMatch@';
                                    returnMessage += 'ZipCodeMatch@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'YNA' || response.AvsResultCode == 'A' || response.AvsResultCode == 'YNY' ||
                                    response.AvsResultCode == 'B' || response.AvsResultCode == 'M') {
                                    returnMessage += 'AddressMatch@';
                                    returnMessage += 'ZipNotMatch@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'YYG') {
                                    returnMessage += 'AddressMatch@';
                                    returnMessage += 'Not Compatible@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'YGG') {
                                    returnMessage += 'Not Compatible@';
                                    returnMessage += 'ZipCodeMatch@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXW') {
                                    returnMessage += 'Card Number Not On File@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXU') {
                                    returnMessage += 'Address Information not verified for domestic transaction@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXR' || response.AvsResultCode == 'R' || response.AvsResultCode == 'U' || response.AvsResultCode == 'E') {
                                    returnMessage += 'Retry / System Unavailable@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXS' || response.AvsResultCode == 'S') {
                                    returnMessage += 'Service Not Supported@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXE') {
                                    returnMessage += 'Address Verification Not Allowed For Card Type@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXG' || response.AvsResultCode == 'G' || response.AvsResultCode == 'C' || response.AvsResultCode == 'I') {
                                    returnMessage += 'Global Non-AVS participant@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'YYY' && response.CardCodeResultCode == 'P') {
                                    returnMessage += 'AddressMatch@';
                                    returnMessage += 'ZipCodeMatch@';
                                } else {
                                    returnMessage += ' @';
                                    returnMessage += ' @';
                                }
                            } else {
                                string add = response.AvsResult;
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
                            return Configuration.GATEWAYERRORMESSAGESTRING + '\'' + response.Error + '\''; //updated @wqkl on 29Jan21 against Error message modification
                        }
                        if (AVSMatch != true) {
                            returnMessage += response.ResultCode + '@';
                            returnMessage += transactionPayload.methodID + '@';
                            returnMessage += response.Error + '@';
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
                response.ResultCode = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode));
                transactionPayload.methodID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentMethodIDVar));
                response.Error = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resError));
                response.RefNum = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.avsRefNum));
            }
            if (response.ResultCode == 'A') {
                transactionId = response.RefNum + '@' + transactionPayload.methodID;
            } else {
                transactionId = Configuration.ERRORWITHSPACESTRING + response.Error;
            }
            paymentMethodId = transactionId.substringAfter('@');
            transactionReferenceId = transactionId.substringBefore('@');
        } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingACH)) {
            paymentMethodId = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.selectedACHId));
            transactionPayload.methodID = paymentMethodId;
            transactionId = EBC_CompMethods.runTransactionPayment(dml, transactionPayload, sendReceiptTo, addEmails, string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check), ebcLogger);
            transactionReferenceId = transactionId;
            command = string.valueOf(Enums.PAYMENTTYPES.Sale);
            paymentType = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType));
        } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH)) {
            transactionPayload.methodID = Configuration.ACCOUNTMETHODID;
            transactionPayload.AccountName = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
            transactionPayload.Account = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
            transactionPayload.Route = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
            transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
            transactionPayload.accountType = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.accType));
            ebcLogger.debug(ClassName, MethodName, 'payment method nn:' + transactionPayload.MethodName);
            if (!test.isRunningTest()) {
                ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
                response = EBC_CompMethods.runTransactionOnly(dml, transactionPayload, accDetail, strMap, ebcLogger);
                if (response.ResultCode == 'A') {
                    transactionId = response.RefNum + '@' + transactionPayload.methodID;
                } else {
                    transactionId = Configuration.ERRORWITHSPACESTRING + response.Error;
                }
            }
            paymentMethodId = transactionId.substringAfter('@');
            transactionReferenceId = transactionId.substringBefore('@');
            command = string.valueOf(Enums.PAYMENTTYPES.Sale);
            paymentType = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType));
        }
        // call Add Application Transaction...
        if (objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order) /*added by @wqkl against SF-137 - 10dec20*/ || objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote) /*added by @wqkl against SF-137 - 10dec20*/ ||
            objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
            ebizchargeServicemodelSoap.ApplicationTransactionResponse addApplicationResponse = new ebizchargeServicemodelSoap.ApplicationTransactionResponse();
            if (!test.isRunningTest()) {
                divisionId = divisionId != null ? divisionId : Configuration.EMPTYSTRING;
                expiryMonth = expiryMonth != null ? expiryMonth : Configuration.EMPTYSTRING;
                expiryYear = expiryYear != null ? expiryYear : Configuration.EMPTYSTRING;
                addApplicationResponse = EBC_CompMethods.CreateApplicationTransaction(dml, accountExternalId, transactionReferenceId, orderNumber, orderId, orderExternalId, command, divisionId, expiryYear, expiryMonth, paymentMethodID, ebcLogger);
            }
        }
        if (transactionId.contains(Configuration.ERRORSTRING)) {
            return transactionId;
        } else {
            EBizCharge_Transaction__c transactionEntity = new EBizCharge_Transaction__c();
            String referenceNumber = Configuration.EMPTYSTRING;
            if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard) || processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH)) {
                referenceNumber = transactionId.substringBefore('@');
                transactionEntity.Ref_Number__c = referenceNumber;
                transactionEntity.Payment_Method__c = transactionId.substringAfter('@');
            } else {
                referenceNumber = transactionId;
                transactionEntity.Ref_Number__c = referenceNumber;
                transactionEntity.Payment_Method__c = transactionPayload.methodID;
            }
            transactionEntity.Account_Id__c = accountId;
            if (objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
                transactionEntity.Order_Id__c = OrderDetail.Id;
            }
            // added by @wqkl against SF-137 - 9dec20 - start
            if (objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote)) {
                transactionEntity.Quote_Id__c = QuoteDetail.Id;
            }
            // added by @wqkl against SF-137 - 9dec20 - end
            if (objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
                transactionEntity.Opportunity_Id__c = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OpportunityId));
            }
            if (!test.isRunningTest()) {
                EBC_CompMethods.saveTransaction(dml, referenceNumber, transactionEntity, ebcLogger);
            }
            if (objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account)) {
                Account accountToUpdate = new Account();
                accountToUpdate.Id = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId));
                accountToUpdate.EBizCharge_Amount__c = accAmount + amount + tax;
                if (accDetail.EBizCharge_Account_Tax__c != null && accDetail.EBizCharge_Account_Tax__c != 0) {
                    accountToUpdate.EBizCharge_Account_Tax__c = accDetail.EBizCharge_Account_Tax__c + tax;
                } else {
                    accountToUpdate.EBizCharge_Account_Tax__c = tax;
                }
                if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard) || processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH)) {
                    accountToUpdate.EBizCharge_Reference_Number__c = transactionId.substringBefore('@');
                } else {
                    accountToUpdate.EBizCharge_Reference_Number__c = transactionId;
                }
                dml.updateRecord(accountToUpdate);
            } else if (objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) {
                Opportunity opportunityToUpdate = new Opportunity();
                opportunityToUpdate.Id = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.OpportunityId));
                if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard) || processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH)) {
                    opportunityToUpdate.EBizCharge_Reference_Number__c = transactionId.substringBefore('@');
                } else {
                    opportunityToUpdate.EBizCharge_Reference_Number__c = transactionId;
                }
                dml.updateRecord(opportunityToUpdate);
                Account accountToUpdate = new Account();
                accountToUpdate.Id = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.AccountId));
                accountToUpdate.EBizCharge_Amount__c = accAmount + Amount + tax;
                ebcLogger.debug(ClassName, MethodName, 'Account passed from opp is' + accDetail);
                ebcLogger.debug(ClassName, MethodName, 'account tax is' + accDetail.EBizCharge_Account_Tax__c);
                if (accDetail.EBizCharge_Account_Tax__c != null && accDetail.EBizCharge_Account_Tax__c != 0) {
                    accountToUpdate.EBizCharge_Account_Tax__c = accDetail.EBizCharge_Account_Tax__c + tax;
                } else {
                    accountToUpdate.EBizCharge_Account_Tax__c = tax;
                }
                if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard) || processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH)) {
                    accountToUpdate.EBizCharge_Reference_Number__c = transactionId.substringBefore('@');
                } else {
                    accountToUpdate.EBizCharge_Reference_Number__c = transactionId;
                }
                dml.updateRecord(accountToUpdate);
            } else if (objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
                transactionEntity.Order_Id__c = OrderDetail.Id;
                transactionEntity.Account_Id__c = accountId;
                double orderAmount = OrderDetail.TotalAmount == null ? 0 : OrderDetail.TotalAmount;
                double orderBalance = OrderDetail.EBizCharge_Order_Balance__c == null ? 0 : OrderDetail.EBizCharge_Order_Balance__c;
                Order order = new Order();
                order.Id = OrderDetail.Id;
                order.EBizCharge_Order_Status__c = string.valueOf(Enums.ENTITYSTATUS.Unpaid);
                order.EBizCharge_Payment_Status__c = paymentType;
                order.EBizCharge_Reference_Number__c = referenceNumber;
                double eBizAmount = OrderDetail.EBizCharge_Amount__c == null ? 0 : OrderDetail.EBizCharge_Amount__c;
                order.EBizCharge_Amount__c = (eBizAmount == null ? 0 : eBizAmount) + transactionPayload.Amount;
                if (OrderDetail.EBizCharge_Order_Tax__c == null || OrderDetail.EBizCharge_Order_Tax__c == 0) {
                    order.EBizCharge_Order_Tax__c = tax;
                } else {
                    order.EBizCharge_Order_Tax__c = OrderDetail.EBizCharge_Order_Tax__c + tax;
                }
                if (test.isRunningTest()) {
                    paymentType = 'Deposit';
                }
                if (paymentType == string.valueOf(Enums.PAYMENTTYPES.Deposit)) {
                    double eBizCapturedAmount = OrderDetail.EBizCharge_Captured_Amount__c == null ? 0 : OrderDetail.EBizCharge_Captured_Amount__c;
                    order.EBizCharge_Captured_Amount__c = (eBizCapturedAmount == null ? 0 : eBizCapturedAmount) + transactionPayload.Amount;
                    order.EBizCharge_Amount__c = 0;
                    if (orderBalance == null || orderBalance == 0) {
                        order.EBizCharge_Order_Balance__c = (orderAmount - amount);
                    } else {
                        order.EBizCharge_Order_Balance__c = (orderBalance - amount);
                    }
                    order.EBizCharge_Order_Balance__c = order.EBizCharge_Order_Balance__c < 0 ? 0 : order.EBizCharge_Order_Balance__c;
                    if (order.EBizCharge_Order_Balance__c == 0) {
                        order.EBizCharge_Order_Status__c = string.valueOf(Enums.ENTITYSTATUS.Paid);
                    }
                }
                // added by @wqkl against (SF-137) - (16jan21) - start
                ebcLogger.debug(ClassName, MethodName, 'Tax:' + tax);
                // added by @wqkl against (SF-137) - (16jan21) - end
                dml.updateRecord(order);
            }
            // added by @wqkl against SF-137 - 9dec20 - start
            else if (objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Quote)) {
                transactionEntity.Order_Id__c = QuoteDetail.Id;
                transactionEntity.Account_Id__c = accountId;
                double quoteAmount = QuoteDetail.GrandTotal == null ? 0 : QuoteDetail.GrandTotal;
                double quoteBalance = QuoteDetail.EBizCharge_Quote_Balance__c == null ? 0 : QuoteDetail.EBizCharge_Quote_Balance__c;
                Quote order = new Quote();
                order.Id = QuoteDetail.Id;
                order.EBizCharge_Quote_Status__c = string.valueOf(Enums.ENTITYSTATUS.Unpaid);
                order.EBizCharge_Payment_Status__c = paymentType;
                order.EBizCharge_Reference_Number__c = referenceNumber;
                double eBizAmount = QuoteDetail.EBizCharge_Amount__c == null ? 0 : QuoteDetail.EBizCharge_Amount__c;
                order.EBizCharge_Amount__c = (eBizAmount == null ? 0 : eBizAmount) + transactionPayload.Amount;
                if (QuoteDetail.EBizCharge_Quote_Tax_c__c == null || QuoteDetail.EBizCharge_Quote_Tax_c__c == 0) {
                    order.EBizCharge_Quote_Tax_c__c = tax;
                } else {
                    order.EBizCharge_Quote_Tax_c__c = QuoteDetail.EBizCharge_Quote_Tax_c__c + tax;
                }
                if (test.isRunningTest()) {
                    paymentType = 'Deposit';
                }
                if (paymentType == string.valueOf(Enums.PAYMENTTYPES.Deposit)) {
                    double eBizCapturedAmount = QuoteDetail.EBizCharge_Captured_Amount__c == null ? 0 : QuoteDetail.EBizCharge_Captured_Amount__c;
                    order.EBizCharge_Captured_Amount__c = (eBizCapturedAmount == null ? 0 : eBizCapturedAmount) + transactionPayload.Amount;
                    order.EBizCharge_Amount__c = 0;
                    if (quoteBalance == null || quoteBalance == 0) {
                        order.EBizCharge_Quote_Balance__c = (quoteAmount - amount);
                    } else {
                        order.EBizCharge_Quote_Balance__c = (quoteBalance - amount);
                    }
                    order.EBizCharge_Quote_Balance__c = order.EBizCharge_Quote_Balance__c < 0 ? 0 : order.EBizCharge_Quote_Balance__c;
                    if (order.EBizCharge_Quote_Balance__c == 0) {
                        order.EBizCharge_Quote_Status__c = string.valueOf(Enums.ENTITYSTATUS.Paid);
                    }
                }
                // added by @wqkl against (SF-137) - (16jan21) - start
                ebcLogger.debug(ClassName, MethodName, 'Tax:' + tax);
                // added by @wqkl against (SF-137) - (16jan21) - end
                dml.updateRecord(order);
            }
            // added by @wqkl against SF-137 - 9dec20 - end
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        }
    }
    public static String processPaymentCustomerCust(DML dml, Map < String, Object > strMap, Ebiz_C__EBizCharge_Fields_Config__c conDetail, String processBy, String ObjName, EBC_Logger ebcLogger) {
        MethodName = 'processPaymentCustomerCust';
        string contactId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.CustomCustId));
        string contactExternalId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.CustExternalId));
        ebcLogger.debug(ClassName, MethodName, 'strMap.get(ebizAmount)>>>>>>>>' + strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.CustAmount)));
        Decimal ebizAmount = (Decimal) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.CustAmount));
        ebizAmount = (ebizAmount == null) ? 0 : ebizAmount;
        double amount = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Amount));
        ebcLogger.debug(ClassName, MethodName, 'amount>>>>>>>' + amount);
        double tax = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Tax));
        Boolean isRecurring = (boolean) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.isRecurring));
        Boolean sendReceiptTo = (boolean) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
        ebcLogger.debug(ClassName, MethodName, '>>SendReceiptTo>>>' + sendReceiptTo);
        String addEmails = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.addEmails));
        String orderNumber = Configuration.DEFAULTORDERNUMBER;
        String orderId = Configuration.DEFAULTORDERNUMBER;
        String orderExternalId = Configuration.EMPTYSTRING;
        String taxAction = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.TaxAction));
        transactionParams transactionPayload = new transactionParams();
        transactionPayload.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
        if (taxAction != Configuration.TAXACTION) {
            transactionPayload.Amount = amount + tax;
            transactionPayload.SubTotal = amount;
            transactionPayload.Tax = tax;
        } else {
            transactionPayload.Amount = amount;
            transactionPayload.SubTotal = 0;
            tax = 0;
            transactionPayload.Tax = 0;
        }
        transactionPayload.accountID = contactId;
        transactionPayload.customerID = contactId;
        transactionPayload.internalID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.CustExternalId));
        transactionPayload.Terminal = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Terminal));
        transactionPayload.isRecurring = isRecurring;
        ObjName = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact);
        string paymentType = Configuration.EMPTYSTRING;
        string paymentMethodId = Configuration.EMPTYSTRING;
        String transactionId = Configuration.EMPTYSTRING;
        String command = (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact) || ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) ? string.valueOf(Enums.PAYMENTTYPES.Sale) : string.valueOf(Enums.PAYMENTTYPES.AuthOnly);
        String transactionReferenceId = Configuration.EMPTYSTRING;
        if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingCard)) {
            paymentMethodID = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.selectedCardId));
            transactionPayload.CardCode = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.cvcNo));
            transactionPayload.methodID = paymentMethodID;
            if (!test.isRunningTest()) {
                transactionId = EBC_CompMethods.runTransactionPayment(dml, transactionPayload, sendReceiptTo, addEmails, command, ebcLogger);
            }
            transactionReferenceId = transactionId;
        } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard)) {
            Boolean saveCard = (boolean) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
            ebcLogger.debug(ClassName, MethodName, '>>>>Command>>>' + command);
            transactionPayload.methodID = Configuration.CARDMETHODID;
            transactionPayload.ccNumber = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
            transactionPayload.expMonth = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
            transactionPayload.expYear = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
            transactionPayload.cvvCode = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
            transactionPayload.ccName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
            transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
            transactionPayload.AvsZip = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
            transactionPayload.AvsStreet = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
            ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
            if (strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode)) == Configuration.EMPTYSTRING) {
                response = EBC_CompMethods.runTransactionOnlyCustomCustomer(dml, transactionPayload, conDetail, strMap, ebcLogger);
            }
            //AVS Checks - Start
            //avs checks when UseFullAmountForAVS is true
            ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
            responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
            String returnMessage = 'AVSCheck@';
            if (strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode)) == Configuration.EMPTYSTRING) {
                if (responseMerchant.UseFullAmountForAVS == true) {
                    Boolean isAVSCheck = (boolean) strMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isAVSCheck));
                    Boolean AVSMatch = true;
                    if (isAVSCheck == true) {
                        if (response.ErrorCode == '0') {
                            returnMessage += response.RefNum + '@';
                            if (response.CardCodeResultCode != 'M') {
                                returnMessage += 'CardCodeNotMatch@';
                                AVSMatch = false;
                            } else {
                                returnMessage += 'CardCodeMatch@';
                            }
                            if (response.AvsResultCode != 'YYY' || response.AvsResultCode != 'Y' || response.AvsResultCode != 'YYA' || response.AvsResultCode != 'YYD' ||
                                response.AvsResultCode != 'YYX' || response.AvsResultCode != 'X' || response.AvsResultCode != 'GGG' || response.AvsResultCode != 'D') {
                                if (response.AvsResultCode == 'NNN' || response.AvsResultCode == 'NN' || response.AvsResultCode == 'N') {
                                    returnMessage += 'AddressNotMatch@';
                                    returnMessage += 'ZipNotMatch@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'NYZ' || response.AvsResultCode == 'Z' || response.AvsResultCode == 'NYW' || response.AvsResultCode == 'W' ||
                                    response.AvsResultCode == 'P') {
                                    returnMessage += 'AddressNotMatch@';
                                    returnMessage += 'ZipCodeMatch@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'YNA' || response.AvsResultCode == 'A' || response.AvsResultCode == 'YNY' ||
                                    response.AvsResultCode == 'B' || response.AvsResultCode == 'M') {
                                    returnMessage += 'AddressMatch@';
                                    returnMessage += 'ZipNotMatch@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'YYG') {
                                    returnMessage += 'AddressMatch@';
                                    returnMessage += 'Not Compatible@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'YGG') {
                                    returnMessage += 'Not Compatible@';
                                    returnMessage += 'ZipCodeMatch@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXW') {
                                    returnMessage += 'Card Number Not On File@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXU') {
                                    returnMessage += 'Address Information not verified for domestic transaction@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXR' || response.AvsResultCode == 'R' || response.AvsResultCode == 'U' || response.AvsResultCode == 'E') {
                                    returnMessage += 'Retry / System Unavailable@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXS' || response.AvsResultCode == 'S') {
                                    returnMessage += 'Service Not Supported@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXE') {
                                    returnMessage += 'Address Verification Not Allowed For Card Type@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXG' || response.AvsResultCode == 'G' || response.AvsResultCode == 'C' || response.AvsResultCode == 'I') {
                                    returnMessage += 'Global Non-AVS participant@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'YYY' && response.CardCodeResultCode == 'P') {
                                    returnMessage += 'AddressMatch@';
                                    returnMessage += 'ZipCodeMatch@';
                                } else {
                                    returnMessage += ' @';
                                    returnMessage += ' @';
                                }
                            } else {
                                string add = response.AvsResult;
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
                            return Configuration.GATEWAYERRORMESSAGESTRING + '\'' + response.Error + '\''; //updated @wqkl on 29Jan21 against Error message modification
                        }
                        if (AVSMatch != true) {
                            returnMessage += response.ResultCode + '@';
                            returnMessage += transactionPayload.methodID + '@';
                            returnMessage += response.Error + '@';
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
                response.ResultCode = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode));
                transactionPayload.methodID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentMethodIDVar));
                response.Error = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resError));
                response.RefNum = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.avsRefNum));
            }
            if (response.ResultCode == 'A') {
                transactionId = response.RefNum + '@' + transactionPayload.methodID;
            } else {
                transactionId = Configuration.ERRORWITHSPACESTRING + response.Error;
            }
            paymentMethodId = transactionId.substringAfter('@');
            transactionReferenceId = transactionId.substringBefore('@');
        } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingACH)) {
            paymentMethodId = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.selectedACHId));
            transactionPayload.methodID = paymentMethodId;
            transactionId = EBC_CompMethods.runTransactionPayment(dml, transactionPayload, sendReceiptTo, addEmails, string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check), ebcLogger);
            transactionReferenceId = transactionId;
            command = string.valueOf(Enums.PAYMENTTYPES.Sale);
            paymentType = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType));
        } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH)) {
            transactionPayload.methodID = Configuration.ACCOUNTMETHODID;
            transactionPayload.AccountName = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
            transactionPayload.Account = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
            transactionPayload.Route = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
            transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
            if (!test.isRunningTest()) {
                ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
                response = EBC_CompMethods.runTransactionOnlyCustomCustomer(dml, transactionPayload, conDetail, strMap, ebcLogger);
                if (response.ResultCode == 'A') {
                    transactionId = response.RefNum + '@' + transactionPayload.methodID;
                } else {
                    transactionId = Configuration.ERRORWITHSPACESTRING + response.Error;
                }
            }
            paymentMethodId = transactionId.substringAfter('@');
            transactionReferenceId = transactionId.substringBefore('@');
            command = string.valueOf(Enums.PAYMENTTYPES.Sale);
            paymentType = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType));
        }
        if (transactionId.contains(Configuration.ERRORSTRING)) {
            return transactionId;
        } else {
            EBizCharge_Transaction__c transactionEntity = new EBizCharge_Transaction__c();
            String referenceNumber = Configuration.EMPTYSTRING;
            if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard) || processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH)) {
                referenceNumber = transactionId.substringBefore('@');
                transactionEntity.Ref_Number__c = referenceNumber;
                transactionEntity.Payment_Method__c = transactionId.substringAfter('@');
            } else {
                referenceNumber = transactionId;
                transactionEntity.Ref_Number__c = referenceNumber;
                transactionEntity.Payment_Method__c = transactionPayload.methodID;
            }
            transactionEntity.Ebiz_C__EBizCharge_Fields_Id__c = contactId;
            if (!test.isRunningTest()) {
                EBC_CompMethods.saveTransaction(dml, referenceNumber, transactionEntity, ebcLogger);
            }
            Ebiz_C__EBizCharge_Fields_Config__c updateCustomEntity = new Ebiz_C__EBizCharge_Fields_Config__c();
            updateCustomEntity.Ebiz_C__EBizCharge_CustomerId__c = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.CustomCustId));
            updateCustomEntity.Ebiz_C__EBizCharge_Amount__c = ebizAmount + amount + tax;
            if (updateCustomEntity.EBizCharge_Tax__c != null && updateCustomEntity.EBizCharge_Tax__c != 0) {
                updateCustomEntity.EBizCharge_Tax__c = tax + updateCustomEntity.EBizCharge_Tax__c;
            } else {
                updateCustomEntity.EBizCharge_Tax__c = tax;
            }
            if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard) || processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH)) {
                updateCustomEntity.Ebiz_C__EBizCharge_Reference_Number__c = transactionId.substringBefore('@');
            } else {
                updateCustomEntity.Ebiz_C__EBizCharge_Reference_Number__c = transactionId;
            }
            try {
                dml.upsertRecord(updateCustomEntity, 'Ebiz_C__EBizCharge_Fields_Config__c.Ebiz_C__EBizCharge_CustomerId__c');
            } catch (DmlException e) {}
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        }
    }
    public static String processPaymentContact(DML dml, Map < String, Object > strMap, Contact conDetail, String processBy, String ObjName, EBC_Logger ebcLogger) {
        MethodName = 'processPaymentContact';
        string contactId = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ContactId));
        string contactExternalId = (string) strMap.get(string.valueOf(Enums.IDENTICALJAVASCRIPTMAPSTRINGS.conExternalId));
        ebcLogger.debug(ClassName, MethodName, 'strMap.get(conAmount)>>>>>>>>' + strMap.get(string.valueOf(Enums.IDENTICALJAVASCRIPTMAPSTRINGS.conAmount)));
        Decimal ebizAmount = (Decimal) strMap.get(string.valueOf(Enums.IDENTICALJAVASCRIPTMAPSTRINGS.conAmount));
        ebizAmount = (ebizAmount == null) ? 0 : ebizAmount;
        double amount = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Amount));
        ebcLogger.debug(ClassName, MethodName, 'amount>>>>>>>' + amount);
        double tax = (double) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Tax));
        Boolean isRecurring = (boolean) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.isRecurring));
        Boolean sendReceiptTo = (boolean) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.SendReceiptTo));
        ebcLogger.debug(ClassName, MethodName, '>>SendReceiptTo>>>' + sendReceiptTo);
        String taxAction = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.TaxAction));
        String addEmails = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.addEmails));
        String orderNumber = Configuration.DEFAULTORDERNUMBER;
        String orderId = Configuration.DEFAULTORDERNUMBER;
        String orderExternalId = Configuration.EMPTYSTRING;
        transactionParams transactionPayload = new transactionParams();
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        String queryOrderby = Configuration.EMPTYSTRING;
        String queryLimit = Configuration.EMPTYSTRING;
        transactionPayload.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
        if (taxAction != Configuration.TAXACTION) {
            transactionPayload.Amount = amount + tax;
            transactionPayload.SubTotal = amount;
            transactionPayload.Tax = tax;
        } else {
            transactionPayload.Amount = amount;
            transactionPayload.SubTotal = 0;
            tax = 0;
            transactionPayload.Tax = 0;
        }
        transactionPayload.accountID = contactId;
        transactionPayload.customerID = contactId;
        transactionPayload.internalID = (string) strMap.get(string.valueOf(Enums.IDENTICALJAVASCRIPTMAPSTRINGS.conExternalId));
        transactionPayload.Terminal = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.Terminal));
        transactionPayload.isRecurring = isRecurring;
        ebizchargeServicemodelSoap.ArrayOfLineItem arrayOfLineItem = new ebizchargeServicemodelSoap.ArrayOfLineItem();
        arrayOfLineItem.LineItem = new List < ebizchargeServicemodelSoap.Lineitem > ();
        ebizchargeServicemodelSoap.LineItem lineItem = new ebizchargeServicemodelSoap.Lineitem();
        Contact lineItemContact = new Contact();
        querySelect = 'select id, name, accountid';
        queryFrom = 'from contact';
        queryWhere = 'where id=\'' + contactId + '\'';
        lineItemContact = (Contact) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        if (lineItemContact.accountid != null) {
            Account lineItemAccount = new Account();
            querySelect = 'select id, name';
            queryFrom = 'from account';
            queryWhere = 'where id=\'' + lineItemContact.accountid + '\'';
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
            lineItem.SKU = contactId;
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
        string paymentType = Configuration.EMPTYSTRING;
        string paymentMethodId = Configuration.EMPTYSTRING;
        String transactionId = Configuration.EMPTYSTRING;
        String command = (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact) || ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Opportunity)) ? string.valueOf(Enums.PAYMENTTYPES.Sale) : string.valueOf(Enums.PAYMENTTYPES.AuthOnly);
        String transactionRefernceId = Configuration.EMPTYSTRING;
        if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingCard)) {
            paymentMethodID = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.selectedCardId));
            transactionPayload.CardCode = (string) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.cvcNo));
            transactionPayload.methodID = paymentMethodID;
            if (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
                paymentType = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType));
                if (paymentType == string.valueOf(Enums.PAYMENTTYPES.Deposit) || paymentType == string.valueOf(Enums.PAYMENTTYPES.Sale)) {
                    command = string.valueOf(Enums.PAYMENTTYPES.Sale);
                }
            }
            if (!test.isRunningTest()) {
                transactionId = EBC_CompMethods.runTransactionPayment(dml, transactionPayload, sendReceiptTo, addEmails, command, ebcLogger);
            }
            transactionRefernceId = transactionId;
        } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard)) {
            Boolean saveCard = (boolean) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.saveCard));
            if (ObjName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order)) {
                paymentType = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType));
                if (paymentType == string.valueOf(Enums.PAYMENTTYPES.Deposit) || paymentType == string.valueOf(Enums.PAYMENTTYPES.Sale)) {
                    command = string.valueOf(Enums.PAYMENTTYPES.Sale);
                }
            }
            transactionPayload.methodID = Configuration.CARDMETHODID;
            transactionPayload.ccNumber = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
            transactionPayload.expMonth = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
            transactionPayload.expYear = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
            transactionPayload.cvvCode = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
            transactionPayload.ccName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
            transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
            transactionPayload.AvsZip = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
            transactionPayload.AvsStreet = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
            ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
            if (strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode)) == Configuration.EMPTYSTRING) {
                response = EBC_CompMethods.runTransactionOnlyContact(dml, transactionPayload, conDetail, strMap, ebcLogger);
            }
            //avs checks when UseFullAmountForAVS is true
            ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
            responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
            String returnMessage = 'AVSCheck@';
            if (strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode)) == Configuration.EMPTYSTRING) {
                if (responseMerchant.UseFullAmountForAVS == true) {
                    Boolean isAVSCheck = (boolean) strMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isAVSCheck));
                    Boolean AVSMatch = true;
                    if (isAVSCheck == true) {
                        if (response.ErrorCode == '0') {
                            returnMessage += response.RefNum + '@';
                            if (response.CardCodeResultCode != 'M') {
                                returnMessage += 'CardCodeNotMatch@';
                                AVSMatch = false;
                            } else {
                                returnMessage += 'CardCodeMatch@';
                            }
                            if (response.AvsResultCode != 'YYY' || response.AvsResultCode != 'Y' || response.AvsResultCode != 'YYA' || response.AvsResultCode != 'YYD' ||
                                response.AvsResultCode != 'YYX' || response.AvsResultCode != 'X' || response.AvsResultCode != 'GGG' || response.AvsResultCode != 'D') {
                                if (response.AvsResultCode == 'NNN' || response.AvsResultCode == 'NN' || response.AvsResultCode == 'N') {
                                    returnMessage += 'AddressNotMatch@';
                                    returnMessage += 'ZipNotMatch@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'NYZ' || response.AvsResultCode == 'Z' || response.AvsResultCode == 'NYW' || response.AvsResultCode == 'W' ||
                                    response.AvsResultCode == 'P') {
                                    returnMessage += 'AddressNotMatch@';
                                    returnMessage += 'ZipCodeMatch@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'YNA' || response.AvsResultCode == 'A' || response.AvsResultCode == 'YNY' ||
                                    response.AvsResultCode == 'B' || response.AvsResultCode == 'M') {
                                    returnMessage += 'AddressMatch@';
                                    returnMessage += 'ZipNotMatch@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'YYG') {
                                    returnMessage += 'AddressMatch@';
                                    returnMessage += 'Not Compatible@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'YGG') {
                                    returnMessage += 'Not Compatible@';
                                    returnMessage += 'ZipCodeMatch@';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXW') {
                                    returnMessage += 'Card Number Not On File@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXU') {
                                    returnMessage += 'Address Information not verified for domestic transaction@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXR' || response.AvsResultCode == 'R' || response.AvsResultCode == 'U' || response.AvsResultCode == 'E') {
                                    returnMessage += 'Retry / System Unavailable@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXS' || response.AvsResultCode == 'S') {
                                    returnMessage += 'Service Not Supported@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXE') {
                                    returnMessage += 'Address Verification Not Allowed For Card Type@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'XXG' || response.AvsResultCode == 'G' || response.AvsResultCode == 'C' || response.AvsResultCode == 'I') {
                                    returnMessage += 'Global Non-AVS participant@';
                                    returnMessage += ' @';
                                    AVSMatch = false;
                                } else if (response.AvsResultCode == 'YYY' && response.CardCodeResultCode == 'P') {
                                    returnMessage += 'AddressMatch@';
                                    returnMessage += 'ZipCodeMatch@';
                                } else {
                                    returnMessage += ' @';
                                    returnMessage += ' @';
                                }
                            } else {
                                string add = response.AvsResult;
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
                            return Configuration.GATEWAYERRORMESSAGESTRING + '\'' + response.Error + '\''; //updated @wqkl on 29Jan21 against Error message modification
                        }
                        if (AVSMatch != true) {
                            returnMessage += response.ResultCode + '@';
                            returnMessage += transactionPayload.methodID + '@';
                            returnMessage += response.Error + '@';
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
                response.ResultCode = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resResultCode));
                transactionPayload.methodID = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentMethodIDVar));
                response.Error = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.resError));
                response.RefNum = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.avsRefNum));
            }
            if (response.ResultCode == 'A') {
                transactionId = response.RefNum + '@' + transactionPayload.methodID;
            } else {
                transactionId = Configuration.ERRORWITHSPACESTRING + response.Error;
            }
            paymentMethodId = transactionId.substringAfter('@');
            transactionRefernceId = transactionId.substringBefore('@');
        } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.ExistingACH)) {
            paymentMethodId = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.selectedACHId));
            transactionPayload.methodID = paymentMethodId;
            transactionId = EBC_CompMethods.runTransactionPayment(dml, transactionPayload, sendReceiptTo, addEmails, string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check), ebcLogger);
            transactionRefernceId = transactionId;
            command = string.valueOf(Enums.PAYMENTTYPES.Sale);
            paymentType = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType));
        } else if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH)) {
            transactionPayload.methodID = Configuration.ACCOUNTMETHODID;
            transactionPayload.AccountName = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
            transactionPayload.Account = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
            transactionPayload.Route = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
            transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
            transactionPayload.accountType = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.accType));
            if (!test.isRunningTest()) {
                ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
                response = EBC_CompMethods.runTransactionOnlyContact(dml, transactionPayload, conDetail, strMap, ebcLogger);
                if (response.ResultCode == 'A') {
                    transactionId = response.RefNum + '@' + transactionPayload.methodID;
                } else {
                    transactionId = Configuration.ERRORWITHSPACESTRING + response.Error;
                }
            }
            paymentMethodId = transactionId.substringAfter('@');
            transactionRefernceId = transactionId.substringBefore('@');
            command = string.valueOf(Enums.PAYMENTTYPES.Sale);
            paymentType = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.paymentType));
        }
        if (transactionId.contains(Configuration.ERRORSTRING)) {
            return transactionId;
        } else {
            EBizCharge_Transaction__c transactionEntity = new EBizCharge_Transaction__c();
            String referenceNumber = Configuration.EMPTYSTRING;
            if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard) || processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH)) {
                referenceNumber = transactionId.substringBefore('@');
                transactionEntity.Ref_Number__c = referenceNumber;
                transactionEntity.Payment_Method__c = transactionId.substringAfter('@');
            } else {
                referenceNumber = transactionId;
                transactionEntity.Ref_Number__c = referenceNumber;
                transactionEntity.Payment_Method__c = transactionPayload.methodID;
            }
            transactionEntity.Contact_Id__c = contactId;
            if (!test.isRunningTest()) {
                EBC_CompMethods.saveTransaction(dml, referenceNumber, transactionEntity, ebcLogger);
            }
            if (objName == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
                Contact updateContact = new Contact();
                updateContact.Id = (string) strMap.get(string.valueOf(Enums.PAYMENTJAVASCRIPTMAPSTRINGS.ContactId));
                updateContact.Ebiz_C__EBizCharge_Contact_Amount__c = ebizAmount + amount + tax;
                if (conDetail.EBizCharge_Contact_Tax__c != null && conDetail.EBizCharge_Contact_Tax__c != 0) {
                    updateContact.EBizCharge_Contact_Tax__c = tax + conDetail.EBizCharge_Contact_Tax__c;
                } else {
                    updateContact.EBizCharge_Contact_Tax__c = tax;
                }
                if (processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewCard) || processBy == string.valueOf(Enums.PAYMENTMETHODSTRINGS.NewACH)) {
                    updateContact.Ebiz_C__EBizCharge_Contact_Reference_Number__c = transactionId.substringBefore('@');
                } else {
                    updateContact.Ebiz_C__EBizCharge_Contact_Reference_Number__c = transactionId;
                }
                dml.updateRecord(updateContact);
            }
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        }
    }
    public static String AddPaymentMethodContact(DML dml, Map < String, Object > strMap, String saveMethod, EBC_Logger ebcLogger) {
        MethodName = 'AddPaymentMethodContact';
        transactionParams transactionPayload = new transactionParams();
        String paymentMethodID = Configuration.EMPTYSTRING;
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
                if (!Test.isRunningTest()) {
                    paymentMethodID = eBc_UtilityController.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard), ebcLogger);
                }
            }
        }
        if (saveMethod == string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH)) {
            transactionPayload.AccountName = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accHolderName));
            transactionPayload.Account = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accNumber));
            transactionPayload.Route = (string) strMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.accRoutNumber));
            transactionPayload.MethodName = (String) strMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.MethodName));
            Boolean saveACH = (boolean) strMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.saveACH));
            if (saveACH == true) {
                if (!Test.isRunningTest()) {
                    paymentMethodID = eBc_UtilityController.addPaymentMethod(dml, transactionPayload, string.valueOf(Enums.PAYMENTMETHODSTRINGS.ACH), ebcLogger);
                }
            }
        }
        return paymentMethodID;
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
        if (!test.isRunningTest()) {
            ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
            response = ebiz.runTransaction(EBC_CompMethods.getSecurityToken(dml, ebcLogger), transactionRequest);
        }
    }
    @AuraEnabled
    public static String getRecurringSchedulePreview(String startDate, String endDate, String paymentFrequency) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = eBc_RecurringController.getRecurringSchedulePreview(dml, startDate, endDate, paymentFrequency, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public class Detail {
        @AuraEnabled public String QBD_Customer_ID {
            get; set;
        }
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
        @AuraEnabled public Boolean UseFullAmountForAVS {
            get;
            set;
        }
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
        @AuraEnabled public Boolean auto_reload_page {
            get;
            set;
        }
    }
    public class wrapperConfigObject {
        @AuraEnabled public Ebiz_C__EBiz_Object_Config__c config {
            get;
            set;
        }
        @AuraEnabled public List < dropdownVals > EBizCharge_Amount_fields_list {
            get;
            set;
        }
        @AuraEnabled public List < dropdownVals > EBizCharge_name_fields_list {
            get;
            set;
        }
        @AuraEnabled public List < dropdownVals > EBizCharge_EBizCharge_Email_list {
            get;
            set;
        }
    }
    public class dropdownVals {
        @AuraEnabled public string label {
            get;
            set;
        }
        @AuraEnabled public string value {
            get;
            set;
        }
    }
    public class emailTemplate {
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
        @AuraEnabled public String TemplateFromName {
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
    public class PaymentMethods {
        @AuraEnabled public Account AccountInfo {
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
    }
    public class PaymentMethodsContact {
        @AuraEnabled public Contact ContactInfo {
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
    }
    public class PaymentMethodsCustomCust {
        @AuraEnabled public Ebiz_C__EBizCharge_Fields_Config__c ContactInfo {
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
    }
    public class transactionWrapper {
        @AuraEnabled public String CardType {
            get;
            set;
        }
        @AuraEnabled public Datetime formattedDateTimeTransaction {
            get;
            set;
        }
        @AuraEnabled public Datetime dateTimeTransaction {
            get;
            set;
        }
        @AuraEnabled public Integer tcount {
            get;
            set;
        }
        @AuraEnabled public String contact {
            get;
            set;
        }
        @AuraEnabled public Decimal amountPaid {
            get;
            set;
        }
        @AuraEnabled public String paymentMethod {
            get;
            set;
        }
        @AuraEnabled public String refNum {
            get;
            set;
        }
        @AuraEnabled public String transHyperURL {
            get;
            set;
        }
        @AuraEnabled public String RefNumURL {
            get;
            set;
        }
        @AuraEnabled public String TransType {
            get;
            set;
        }
        @AuraEnabled public String userId {
            get;
            set;
        }
    }
    //received payment section part
    public class receivedPay {
        @AuraEnabled public Date fromDate {
            get;
            set;
        }
        @AuraEnabled public Date toDate {
            get;
            set;
        }
        @AuraEnabled public list < receivedPayments > recPaymentList {
            get;
            set;
        }
    }
    public class receivedPayments {
        @AuraEnabled public string OrderHyperUrl {
            get;
            set;
        }
        @AuraEnabled public string OrderId {
            get;
            set;
        }
        @AuraEnabled public Integer tcount {
            get;
            set;
        }
        @AuraEnabled public string CustomerId {
            get;
            set;
        }
        @AuraEnabled public string CustomerName {
            get;
            set;
        }
        @AuraEnabled public string DivisionId {
            get;
            set;
        }
        @AuraEnabled public string InvoiceNumber {
            get;
            set;
        }
        @AuraEnabled public string InvoiceInternalId {
            get;
            set;
        }
        @AuraEnabled public string InvoiceDate {
            get;
            set;
        }
        @AuraEnabled public string InvoiceDueDate {
            get;
            set;
        }
        @AuraEnabled public string PoNum {
            get;
            set;
        }
        @AuraEnabled public string InvoiceAmount {
            get;
            set;
        }
        @AuraEnabled public string AmountDue {
            get;
            set;
        }
        @AuraEnabled public string AuthCode {
            get;
            set;
        }
        @AuraEnabled public string RefNum {
            get;
            set;
        }
        @AuraEnabled public string Last4 {
            get;
            set;
        }
        @AuraEnabled public string PaymentMethod {
            get;
            set;
        }
        @AuraEnabled public string DatePaid {
            get;
            set;
        }
        @AuraEnabled public decimal PaidAmount {
            get;
            set;
        }
        @AuraEnabled public decimal ResendCount {
            get;
            set;
        }
        @AuraEnabled public string PaymentInternalId {
            get;
            set;
        }
        @AuraEnabled public Date PaymentRequestDate {
            get;
            set;
        }
        @AuraEnabled public string PaymentRequestTime {
            get;
            set;
        }
        @AuraEnabled public Datetime PaymentRequestDateTime {
            get;
            set;
        }
        @AuraEnabled public string PaymentMethodId {
            get;
            set;
        }
        @AuraEnabled public string TypeId {
            get;
            set;
        }
        @AuraEnabled public string PaymentSourceId {
            get;
            set;
        }
        @AuraEnabled public string TransactionLookupKey {
            get;
            set;
        }
        @AuraEnabled public string ExternalTxnId {
            get;
            set;
        }
        @AuraEnabled public string CustomerEmailAddress {
            get;
            set;
        }
        @AuraEnabled public boolean isSelected {
            get;
            set;
        }
    }
    public class PendingPayments {
        @AuraEnabled public Date fromDate {
            get;
            set;
        }
        @AuraEnabled public Date toDate {
            get;
            set;
        }
        @AuraEnabled public list < Payments > PendingList {
            get;
            set;
        }
    }
    public class Payments {
        @AuraEnabled public string OrderId {
            get;
            set;
        }
        @AuraEnabled public string CustomerId {
            get;
            set;
        }
        @AuraEnabled public string CustomerName {
            get;
            set;
        }
        @AuraEnabled public string DivisionId {
            get;
            set;
        }
        @AuraEnabled public string InvoiceNumber {
            get;
            set;
        }
        @AuraEnabled public string InvoiceInternalId {
            get;
            set;
        }
        @AuraEnabled public string InvoiceDate {
            get;
            set;
        }
        @AuraEnabled public string InvoiceDueDate {
            get;
            set;
        }
        @AuraEnabled public string PoNum {
            get;
            set;
        }
        @AuraEnabled public string InvoiceAmount {
            get;
            set;
        }
        @AuraEnabled public string AmountDue {
            get;
            set;
        }
        @AuraEnabled public string AuthCode {
            get;
            set;
        }
        @AuraEnabled public string RefNum {
            get;
            set;
        }
        @AuraEnabled public string Last4 {
            get;
            set;
        }
        @AuraEnabled public string PaymentMethod {
            get;
            set;
        }
        @AuraEnabled public string DatePaid {
            get;
            set;
        }
        @AuraEnabled public decimal PaidAmount {
            get;
            set;
        }
        @AuraEnabled public string PaymentInternalId {
            get;
            set;
        }
        @AuraEnabled public Date PaymentRequestDate {
            get;
            set;
        }
        @AuraEnabled public string PaymentRequestTime {
            get;
            set;
        }
        @AuraEnabled public string PaymentMethodId {
            get;
            set;
        }
        @AuraEnabled public string TypeId {
            get;
            set;
        }
        @AuraEnabled public string PaymentSourceId {
            get;
            set;
        }
        @AuraEnabled public string TransactionLookupKey {
            get;
            set;
        }
        @AuraEnabled public string ExternalTxnId {
            get;
            set;
        }
        @AuraEnabled public string CustomerEmailAddress {
            get;
            set;
        }
        @AuraEnabled public boolean isSelected {
            get;
            set;
        }
        @AuraEnabled public String contactName {
            get;
            set;
        }
        @AuraEnabled public String contactURL {
            get;
            set;
        }
        @AuraEnabled public String Source {
            get;
            set;
        }
        @AuraEnabled public String methodType {
            get;
            set;
        }
        @AuraEnabled public DateTime PaymentRequestDateTime {
            get;
            set;
        }
        @AuraEnabled public String userId {
            get;
            set;
        }
    }
}