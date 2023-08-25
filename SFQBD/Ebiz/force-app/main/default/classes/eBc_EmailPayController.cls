public with sharing class eBc_EmailPayController {
    public static string ClassName = 'eBc_EmailPayController';
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
        return eBc_UtilityController.getSettings(dml, ebcLogger);
    }
    @AuraEnabled
    public static list < Payments > removeRecievedPaymentsApxc(list < Payments > recievedEmailList) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        list < Payments > reciprocate = removeRecievedPaymentsApxc(dml, recievedEmailList, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static list < Payments > removeRecievedPaymentsApxc(DML dml, list < Payments > recievedEmailList, EBC_Logger ebcLogger) {
        MethodName = 'removeRecievedPaymentsApxc';
        list < Payments > retUpdatedList = new list < Payments > ();
        try {
            for (Payments rec: recievedEmailList) {
                if (rec.isSelected == true) {
                    if (!test.isRunningTest()) {
                        ebizchargeServicemodelSoap.PaymentResponse response = eBc_UtilityController.removeEbizWebFormPayment(dml, rec.PaymentInternalId, ebcLogger);
                    }
                } else {
                    retUpdatedList.add(rec);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return retUpdatedList;
    }
    @auraEnabled
    public static  OrderWrapper  getListOfOrdersApxc(String AccountID, String OrderId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        OrderWrapper reciprocate = getListOfOrdersApxc(dml, AccountID, OrderId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static OrderWrapper getListOfOrdersApxc(DML dml, String AccountID, String OrderId, EBC_Logger ebcLogger) {
        MethodName = 'getListOfOrdersApxc';
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        String qrystr = Configuration.EMPTYSTRING;
        if (AccountID != null && AccountID != Configuration.EMPTYSTRING) {
            querySelect = 'select id, accountId';
            queryFrom = 'from contact';
            queryWhere = 'where id=\'' + AccountID + '\'';
            Schema.DescribeSObjectResult entityDescription = Contact.sObjectType.getDescribe();
            String keyPrefix = entityDescription.getKeyPrefix();
            if (AccountID.startsWith(keyPrefix)) {
                contact contact = (contact) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                AccountID = contact.accountId;
            }
        }
        Account accountDetail;
        if(AccountID != null){
            accountDetail = eBc_UtilityController.getAccountDetail(dml, AccountId, ebcLogger);
        }
        List < helperWrapper > wr = new List < helperWrapper > ();
        EBizcharge_Setting__c st = eBc_UtilityController.getSettings(dml, ebcLogger);
        Boolean AllowPartialPay = st.Allow_Partial_Payment__c;
        try {
            string cols = 'Id,Name,OrderNumber,CreatedDate,TotalAmount,EffectiveDate, EndDate,Status,EBizCharge_Internal_ID__c,';
            cols += 'AccountId,Account.QBD_Customer_ID__c,Account.Name,Account.First_Name__c,Account.Last_Name__c,Account.Email__c,Account.EBizCharge_Internal_ID__c,';
            cols += 'EBizCharge_Payment_Status__c,EBizCharge_Order_Status__c,EBizCharge_Amount__c,PoNumber,EBizCharge_Order_Balance__c';
            string condition = 'EBizCharge_Order_Status__c <> \'Paid\' AND EBizCharge_Payment_Status__c <> \'Preauth\' ';
            if ((AccountID != null && AccountID != Configuration.EMPTYSTRING) && (OrderId != null && OrderId != Configuration.EMPTYSTRING)) {
                condition += 'AND AccountId = \'' + AccountID + '\' AND Id = \'' + OrderId + '\'';
            } else if (AccountID != null && AccountID != Configuration.EMPTYSTRING) {
                condition += 'AND AccountId = \'' + AccountID + '\'';
            } else if (OrderId != null && OrderId != Configuration.EMPTYSTRING) {
                condition += 'AND Id = \'' + OrderId + '\'';
            }
            querySelect = 'SELECT ' + cols + Configuration.EMPTYSTRING;
            queryFrom = 'FROM Order';
            queryWhere = ' WHERE ' + condition;
            List < Order > unpaidOrders = (List < Order > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            for (Order ord: unpaidOrders) {
                helperWrapper obj = new helperWrapper();
                obj.Id = ord.Id;
                obj.OrderNumber = ord.OrderNumber;
                obj.CreatedDate = ord.CreatedDate;
                obj.TotalAmount = ord.TotalAmount;
                obj.AmountDue = ord.EBizCharge_Order_Balance__c == 0 ? ord.TotalAmount : ord.EBizCharge_Order_Balance__c;
                obj.OrderBalance = ord.EBizCharge_Order_Balance__c == 0 ? ord.TotalAmount : ord.EBizCharge_Order_Balance__c;
                obj.OrderTax = 0.0;
                obj.OrdExternalId = ord.EBizCharge_Internal_ID__c;
                obj.EffectiveDate = ord.EffectiveDate;
                obj.endDate = ord.endDate;
                obj.PaymentStatus = string.valueOf(ord.EBizCharge_Payment_Status__c);
                obj.accId = ord.Account.QBD_Customer_ID__c;
                obj.accName = ord.Account.Name;
                obj.accFirstName = ord.Account.First_Name__c;
                obj.accLastName = ord.Account.Last_Name__c;
                obj.accEmail = ord.Account.Email__c;
                obj.accExternalId = ord.Account.EBizCharge_Internal_ID__c;
                obj.isSelected = false;
                obj.isAllowPartialPay = AllowPartialPay;
                obj.PoNum  = ord.PoNumber;
                wr.add(obj);
            }
        } catch (QueryException e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        OrderWrapper orderWarpper = new OrderWrapper();
            orderWarpper.accountOrders = wr;
            orderWarpper.accountDetail = accountDetail;
            return orderWarpper;
    }
    @auraEnabled
    public static List < emailWrapperclass > getEmailTemplatesApxc() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < EmailWrapperclass > reciprocate = getEmailTemplatesApxc(dml, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < emailWrapperclass > getEmailTemplatesApxc(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getEmailTemplatesApxc';
        List < emailWrapperclass > emailWCObj = new List < emailWrapperclass > ();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.EmailTemplate[] EmailTemplateList;
        try {
            ebizchargeServicemodelSoap.ArrayOfEmailTemplate arrofResponse = new ebizchargeServicemodelSoap.ArrayOfEmailTemplate();
            if (!test.isRunningTest()) {
                arrofResponse = ebiz.GetEmailTemplates(EBC_CompMethods.getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                EmailTemplateList = arrofResponse.EmailTemplate;
            }
            if (EmailTemplateList != null) {
                for (ebizchargeServicemodelSoap.EmailTemplate lst: EmailTemplateList) {
                    emailWrapperclass obj = new emailWrapperclass();
                    obj.TemplateName = lst.TemplateName;
                    obj.TemplateType = lst.TemplateTypeId;
                    obj.TemplateInternalId = lst.TemplateInternalId;
                    obj.TemplateSubject = lst.TemplateSubject;
                    obj.FromEmail = lst.FromEmail;
                    obj.ReplyToEmail = lst.ReplyToEmail;
                    emailWCObj.add(obj);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return emailWCObj;
    }
    @AuraEnabled
    public static String sendEmailPayReqApxc(String sendEmailReqJSON, List < helperWrapper > OrdersList, Account accountDetail) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = sendEmailPayReqApxc(dml, sendEmailReqJSON, OrdersList, accountDetail, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String sendEmailPayReqApxc(DML dml, String sendEmailReqJSON, List < helperWrapper > OrdersList, Account accountDetail, EBC_Logger ebcLogger) {
        MethodName = 'sendEmailPayReqApxc';
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        Integer insertCount = 0;
        String retMsg = Configuration.EMPTYSTRING;
        List < EBizCharge_EmailPayPending__c > emailPayToInsert = new List < EBizCharge_EmailPayPending__c > ();
        String StartDate = Configuration.STARTDATE;
        String EndDate = Configuration.ENDDATE;
        PendingPayments retPP = getPendingPaymentsApxc(dml, StartDate, EndDate, ebcLogger);
        try {
            List < Payments > pendingList = retPP.PendingList;
            List < String > OrderIDs = new List < String > ();
            List < String > emailPayOrderIDs = new List < String > ();
            for (Payments p: pendingList) {
                OrderIDs.add(p.InvoiceNumber);
            }
            List < EBizCharge_EmailPayPending__c > emailPayToDel = new List < EBizCharge_EmailPayPending__c > ();
            querySelect = 'SELECT Id,Payment_Order_ID__c,Send_Request_Count__c';
            queryFrom = 'FROM EBizCharge_EmailPayPending__c';
            queryWhere = 'WHERE Payment_Order_ID__c NOT IN :';
            list < EBizCharge_EmailPayPending__c > emailPayPendListToDel = (list < EBizCharge_EmailPayPending__c > ) dml.selectRecordsInList(OrderIDs, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            for (EBizCharge_EmailPayPending__c ePay: emailPayPendListToDel) {
                emailPayToDel.add(ePay);
            }
            List < String > existingEmailPay = new List < String > ();
            querySelect = 'SELECT Id,Payment_Order_ID__c,Send_Request_Count__c';
            queryFrom = 'FROM EBizCharge_EmailPayPending__c';
            queryWhere = 'WHERE Payment_Order_ID__c IN :';
            list < EBizCharge_EmailPayPending__c > emailPayPendSFList = (list < EBizCharge_EmailPayPending__c > ) dml.selectRecordsInList(OrderIDs, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            for (EBizCharge_EmailPayPending__c ePay: emailPayPendSFList) {
                existingEmailPay.add(ePay.Payment_Order_ID__c);
            }
            Map < String, Object > mapReq = (Map < String, Object > ) JSON.deserializeUntyped(sendEmailReqJSON);
            for (helperWrapper o: OrdersList) {
                ebizchargeServicemodelSoap.EbizWebForm tempWebForm = new ebizchargeServicemodelSoap.EbizWebForm();
                double Amount = o.AmountDue;
                double Tax = o.OrderTax;
                String AccountId = o.accId;
                String AccountName = o.accName;
                tempWebForm.FromName = string.valueOf(Enums.ASSIGNMENTSTRINGS.EBizCharge);
                tempWebForm.FromEmail = (string) mapReq.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.fromEmail));
                tempWebForm.EmailAddress = (string) mapReq.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.toEmail));
                tempWebForm.EmailSubject = (string) mapReq.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Subject));
                tempWebForm.EmailNotes = (string) mapReq.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.Notes));
                tempWebForm.EmailTemplateID = (string) mapReq.get(string.valueOf(Enums.EMAILJAVASCRIPTMAPSTRINGS.TemplateId));
                tempWebForm.Date_x = System.now();
                tempWebForm.CustomerId = AccountId;
                tempWebForm.CustFullName = AccountName;
                tempWebForm.InvoiceNumber = o.OrderNumber;
                tempWebForm.PoNum = o.PoNum;
                tempWebForm.OrderId = o.Id;
                tempWebForm.PayByType = Configuration.PAYBYTYPESTRING;
                tempWebForm.SoftwareId = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
                tempWebForm.TotalAmount = Amount + Tax;
                tempWebForm.AmountDue = Amount + Tax;
                tempWebForm.ShippingAmount = Amount;
                tempWebForm.TaxAmount = Tax;
                tempWebForm.SendEmailToCustomer = true;
                // added by @GM against BillingAddress - (21 Oct 21) - start
                ebizchargeServicemodelSoap.Address customerAddress = new ebizchargeServicemodelSoap.Address();
                if(accountDetail!=null){
                    customerAddress.FirstName = accountDetail.Name;
                    customerAddress.LastName = accountDetail.Name;
                    customerAddress.Address1 = accountDetail.BillingStreet;
                    customerAddress.City = accountDetail.BillingCity;
                    customerAddress.State = accountDetail.BillingState;
                    customerAddress.ZipCode = accountDetail.BillingPostalCode;
                    customerAddress.Country = accountDetail.BillingCountry;
                }
                tempWebForm.BillingAddress = customerAddress;
                // added by @GM against BillingAddress - (21 Oct 21) - End
                try {
                    if (!test.isRunningTest()) {
                        if (existingEmailPay.contains(o.OrderNumber) || tempWebForm.TotalAmount == 0) {
                            retMsg += Configuration.KEYSPLITTER + o.OrderNumber;
                        } else {
                            ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
                            string response = ebiz.GetEbizWebFormURL(EBC_CompMethods.getSecurityToken(dml, ebcLogger), tempWebForm);
                            EBizCharge_EmailPayPending__c emailPayObj = new EBizCharge_EmailPayPending__c();
                            emailPayObj.Payment_Order_ID__c = o.OrderNumber;
                            emailPayObj.Send_Request_Count__c = 1;
                            emailPayToInsert.add(emailPayObj);
                            insertCount++;
                        }
                    }
                } catch (Exception err) {}
            }
            if (emailPayToDel.size() > 0) {
                try {
                    if (!test.isRunningTest()) {
                        dml.deleteRecord(emailPayToDel);
                    }
                } catch (Exception err) {}
            }
            if (emailPayToInsert.size() > 0) {
                try {
                    if (!test.isRunningTest()) {
                        dml.insertRecord(emailPayToInsert);
                    }
                } catch (Exception err) {}
            }
            retMsg += Configuration.KEYSPLITTER + insertCount;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return retMsg;
    }
    @AuraEnabled
    public static PendingPayments getPendingPaymentsApxc(String sDate, String eDate) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        PendingPayments reciprocate = getPendingPaymentsApxc(dml, sDate, eDate, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static PendingPayments getPendingPaymentsApxc(DML dml, String sDate, String eDate, EBC_Logger ebcLogger) {
        MethodName = 'getPendingPaymentsApxc';
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        PendingPayments retPP = new PendingPayments();
        Date StartDate = null;
        Date EndDate = null;
        try {
            if (sDate == null && eDate == null) {
                DateTime Td = system.Today().AddDays(1);
                EBizcharge_Setting__c st = eBc_UtilityController.getSettings(dml, ebcLogger);
                if (st.Email_Pending_Req_Filter_By__c != null) {
                    String FilterBy = st.Email_Pending_Req_Filter_By__c;
                    if (FilterBy == string.valueOf(Enums.FILTERBY.Today)) {
                        StartDate = Date.valueOf(Td.format(Configuration.DATETIMEDEFAULTFORMAT));
                        EndDate = Date.valueOf(Td.format(Configuration.DATETIMEDEFAULTFORMAT));
                        EndDate = EndDate.addDays(1);
                    } else if (FilterBy == Configuration.FILTERBYPASTWEEK) {
                        Datetime dt = System.Today().toStartofWeek() - 6;
                        StartDate = Date.valueOf(dt.format(Configuration.DATETIMEDEFAULTFORMAT));
                        EndDate = Date.valueOf(Td.format(Configuration.DATETIMEDEFAULTFORMAT));
                        EndDate = EndDate.addDays(1);
                    } else if (FilterBy == Configuration.FILTERBYPASTMONTH) {
                        Datetime dt = system.Today().addMonths(-1).toStartOfMonth().addDays(1);
                        StartDate = Date.valueOf(dt.format(Configuration.DATETIMEDEFAULTFORMAT));
                        EndDate = Date.valueOf(Td.format(Configuration.DATETIMEDEFAULTFORMAT));
                        EndDate = EndDate.addDays(1);
                    } else if (FilterBy == Configuration.FILTERBYPASTYEAR) {
                        Datetime dt = System.Today().addYears(-1);
                        StartDate = Date.valueOf(dt.format(Configuration.DATETIMEDEFAULTFORMAT));
                        EndDate = Date.valueOf(Td.format(Configuration.DATETIMEDEFAULTFORMAT));
                        EndDate = EndDate.addDays(1);
                    }
                } else {
                    Datetime dt = System.Today().toStartofWeek() - 6;
                    StartDate = Date.valueOf(dt.format(Configuration.DATETIMEDEFAULTFORMAT));
                    EndDate = Date.valueOf(Td.format(Configuration.DATETIMEDEFAULTFORMAT));
                    EndDate = EndDate.addDays(1);
                }
            } else {
                StartDate = Date.valueOf(sDate);
                EndDate = Date.valueOf(eDate);
            }
            list < Payments > retPendingList = new list < Payments > ();
            list < Payments > retPendingListUpd = new list < Payments > ();
            List < Payments > pendingList = new List < Payments > ();
            List < String > cstIds = new List < String > ();
            list < ebizchargeServicemodelSoap.Payment > paymentlist = new list < ebizchargeServicemodelSoap.Payment > ();
            if (!test.isRunningTest()) {
                paymentlist = eBc_UtilityController.searchPendingPayments(dml, StartDate, EndDate, ebcLogger);
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
            if (paymentlist != null) {
                pendingList = new List < Payments > ();
                for (ebizchargeServicemodelSoap.Payment pp: paymentlist) {
                    Payments p1 = new Payments();
                    if (pp.CustomerId != null && pp.CustomerId != Configuration.EMPTYSTRING) {
                        string customerId = pp.CustomerId;
                            cstIds.add(pp.CustomerId);
                            p1.isSelected = false;
                            p1.CustomerId = pp.CustomerId;
                            p1.OrderId = pp.OrderId;
                            p1.CustomerName = Configuration.EMPTYSTRING;
                            p1.DivisionId = pp.DivisionId;
                            p1.InvoiceNumber = pp.InvoiceNumber;
                            p1.InvoiceInternalId = pp.InvoiceInternalId;
                            p1.InvoiceDate = pp.InvoiceDate;
                            p1.InvoiceDueDate = pp.InvoiceDueDate;
                            p1.PoNum = pp.PoNum;
                            p1.InvoiceAmount = pp.InvoiceAmount;
                            p1.AmountDue = pp.AmountDue;
                            p1.AuthCode = pp.AuthCode;
                            p1.RefNum = pp.RefNum;
                            p1.Last4 = pp.Last4;
                            p1.PaymentMethod = pp.PaymentMethod;
                            p1.DatePaid = pp.DatePaid;
                            decimal PaidAmount = decimal.valueOf(pp.PaidAmount);
                            p1.PaidAmount = PaidAmount.setScale(2);
                            p1.PaymentInternalId = pp.PaymentInternalId;
                            string ReqDateTime = pp.PaymentRequestDateTime;
                            if (ReqDateTime != Configuration.EMPTYSTRING && ReqDateTime != null) {
                                List < String > strArr = ReqDateTime.split(Configuration.DATETIMESPLITTER);
                                p1.PaymentRequestDate = date.valueOf(strArr[0]);
                                p1.PaymentRequestTime = strArr[1];
                            }
                            p1.PaymentMethodId = pp.PaymentMethodId;
                            p1.TypeId = pp.TypeId;
                            p1.PaymentSourceId = pp.PaymentSourceId;
                            p1.TransactionLookupKey = pp.TransactionLookupKey;
                            p1.ExternalTxnId = pp.ExternalTxnId;
                            p1.CustomerEmailAddress = pp.CustomerEmailAddress;
                            pendingList.add(p1);
                    }
                }
                if (!test.isRunningTest()) {
                    if (cstIds != null) {
                        List < Account > accountInfolist = eBc_UtilityController.getAccountsDetailForQbd(dml, cstIds, ebcLogger);
                        Map<String,String> cstMap = new map<String,String>();
                        Map<String,String> cstMap2 = new map<String,String>();
                        for (Account acc: accountInfolist) {
                            cstMap.put((String)acc.get('QBD_Customer_ID__c'),acc.Name);
                            cstMap2.put((String)acc.get('QBD_Customer_ID__c'),acc.id);
                        }
                        List < String > OrderIdsList = new List < String > ();
                        for (Payments p: pendingList) {
                            OrderIdsList.add(p.InvoiceNumber);
                            if (cstMap.containsKey(p.CustomerId)) {
                                p.CustomerName = cstMap.get(p.CustomerId);
                                p.CustomerId = cstMap2.get(p.CustomerId);
                                retPendingList.add(p);
                            }
                        }
                        Map < String, Decimal > OrderIdsMap = new map < String, Decimal > ();
                        querySelect = 'SELECT Id,Payment_Order_ID__c,Send_Request_Count__c';
                        queryFrom = 'FROM EBizCharge_EmailPayPending__c';
                        queryWhere = 'WHERE Payment_Order_ID__c IN :';
                        list < EBizCharge_EmailPayPending__c > emailPayPendList = (list < EBizCharge_EmailPayPending__c > ) dml.selectRecordsInList(OrderIdsList, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                        for (EBizCharge_EmailPayPending__c ePay: emailPayPendList) {
                            OrderIdsMap.put(ePay.Payment_Order_ID__c, ePay.Send_Request_Count__c);
                        }
                        for (Payments p: retPendingList) {
                            if (OrderIdsMap.containsKey(p.InvoiceNumber)) {
                                p.ResendCount = OrderIdsMap.get(p.InvoiceNumber);
                            } else {
                                p.ResendCount = 1;
                            }
                            retPendingListUpd.add(p);
                        }
                    }
                }
                retPP.PendingList = retPendingListUpd;
            }
            retPP.fromDate = date.valueOf(StartDate);
            retPP.toDate = date.valueOf(EndDate);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return retPP;
    }
    @AuraEnabled
    public static list < Payments > removePendingPaymentsApxc(list < Payments > pendingPayList) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        list < Payments > reciprocate = removePendingPaymentsApxc(dml, pendingPayList, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static list < Payments > removePendingPaymentsApxc(DML dml, list < Payments > pendingPayList, EBC_Logger ebcLogger) {
        MethodName = 'removePendingPaymentsApxc';
        list < Payments > retUpdatedList = new list < Payments > ();
        try {
            for (Payments rec: pendingPayList) {
                if (rec.isSelected == true) {
                    if (!test.isRunningTest()) {
                        ebizchargeServicemodelSoap.PaymentResponse response = eBc_UtilityController.removeEbizWebFormPayment(dml, rec.PaymentInternalId, ebcLogger);
                    }
                } else {
                    retUpdatedList.add(rec);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return retUpdatedList;
    }
    @AuraEnabled
    public static String resendPendingPaymentApx(list < Payments > pendingPayList) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = resendPendingPaymentApx(dml, pendingPayList, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static String resendPendingPaymentApx(DML dml, list < Payments > pendingPayList, EBC_Logger ebcLogger) {
        MethodName = 'resendPendingPaymentApx';
        ebcLogger.debug(ClassName, MethodName, 'RecordSize>>>' + pendingPayList.size());
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        List < String > OrderIdsList = new List < String > ();
        try {
            for (Payments p: pendingPayList) {
                if (p.isSelected == true) {
                    OrderIdsList.add(p.InvoiceNumber);
                }
            }
            list < EBizCharge_EmailPayPending__c > emailPayPendListUpd = new list < EBizCharge_EmailPayPending__c > ();
            querySelect = 'SELECT Id,Payment_Order_ID__c,Send_Request_Count__c';
            queryFrom = 'FROM EBizCharge_EmailPayPending__c';
            queryWhere = 'WHERE Payment_Order_ID__c IN :';
            list < EBizCharge_EmailPayPending__c > emailPayPendList = (list < EBizCharge_EmailPayPending__c > ) dml.selectRecordsInList(OrderIdsList, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            for (EBizCharge_EmailPayPending__c ep: emailPayPendList) {
                EBizCharge_EmailPayPending__c obj = new EBizCharge_EmailPayPending__c();
                obj.id = ep.Id;
                obj.Payment_Order_ID__c = ep.Payment_Order_ID__c;
                obj.Send_Request_Count__c = ep.Send_Request_Count__c;
                obj.Send_Request_Count__c++;
                emailPayPendListUpd.add(obj);
            }
            for (Payments rec: pendingPayList) {
                if (rec.isSelected == true) {
                    if (!test.isRunningTest()) {
                        string response = eBc_UtilityController.ResendEbizWebFormEmail(dml, rec.PaymentInternalId, ebcLogger);
                    }
                }
            }
            dml.upsertRecord(emailPayPendListUpd);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static List < Payments > getReceivedPaymentsApxc(String AccountId, Date fromDate, Date toDate) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < Payments > reciprocate = getReceivedPaymentsApxc(dml, AccountId, fromDate, toDate, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < Payments > getReceivedPaymentsApxc(DML dml, String AccountId, Date fromDate, Date toDate, EBC_Logger ebcLogger) {
        MethodName = 'getReceivedPaymentsApxc';
        toDate = toDate.addDays(1);
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        List < ebizchargeServicemodelSoap.Payment > paymentlist = new list < ebizchargeServicemodelSoap.Payment > ();
        ebizchargeServicemodelSoap.ArrayOfPayment arrpendings = new ebizchargeServicemodelSoap.ArrayOfPayment();
        list < Payments > retPendingList = new list < Payments > ();
        try {
            if (!test.isRunningTest()) {
                if (fromDate != null && toDate != null && AccountId != null) {
                    arrpendings = ebiz.SearchEbizWebFormReceivedPayments(eBc_UtilityController.getSecurityToken(dml, ebcLogger), AccountId, fromDate, toDate, null, 0, 10000, Configuration.CARDMETHODID);
                } else if (fromDate != null && toDate != null) {
                    arrpendings = ebiz.SearchEbizWebFormReceivedPayments(eBc_UtilityController.getSecurityToken(dml, ebcLogger), Configuration.EMPTYSTRING, fromDate, toDate, null, 0, 10000, Configuration.CARDMETHODID);
                } else {
                    arrpendings = ebiz.SearchEbizWebFormReceivedPayments(eBc_UtilityController.getSecurityToken(dml, ebcLogger), AccountId, fromDate, toDate, null, 0, 10000, Configuration.CARDMETHODID);
                }
                paymentlist = arrpendings.Payment;
            } else {
                ebizchargeServicemodelSoap.Payment mockPayment = new ebizchargeServicemodelSoap.Payment();
                mockPayment.OrderId = '234';
                mockPayment.CustomerId = '001343398728733';
                mockPayment.DivisionId = '2423432';
                mockPayment.InvoiceNumber = '23423432';
                mockPayment.InvoiceInternalId = '2342342';
                mockPayment.InvoiceDate = '2017-12-12';
                mockPayment.InvoiceDueDate = '2017-12-12';
                mockPayment.PoNum = '123';
                mockPayment.InvoiceAmount = '12.00';
                mockPayment.AmountDue = '0.00';
                mockPayment.AuthCode = '2234424auwweew';
                mockPayment.RefNum = '234234';
                mockPayment.Last4 = '08773';
                mockPayment.PaidAmount = '2.00';
                Datetime StartDT = Datetime.newInstance(2017, 1, 7, 15, 20, 45);
                mockPayment.PaymentRequestDateTime = StartDT.format('yyyy-MM-dd\'T\'HH:mm:ss');
                mockPayment.DatePaid = StartDT.format('yyyy-MM-dd\'T\'HH:mm:ss');
                paymentlist.add(mockPayment);
            }
            List < Payments > pendingList = new List < Payments > ();
            List < String > cstIds = new List < String > ();
            if (paymentlist != null) {
                for (ebizchargeServicemodelSoap.Payment pp: paymentlist) {
                    Payments p1 = new Payments();
                    if (pp.CustomerId != null && pp.CustomerId != Configuration.EMPTYSTRING) {
                        string customerId = pp.CustomerId;
                        string cst = customerId.left(3);
                            decimal PaidAmount = decimal.valueOf(pp.PaidAmount);
                            if (PaidAmount > 1) {
                                cstIds.add(pp.CustomerId);
                                p1.OrderId = pp.OrderId;
                                p1.CustomerId = pp.CustomerId;
                                p1.CustomerName = Configuration.EMPTYSTRING;
                                p1.DivisionId = pp.DivisionId;
                                p1.InvoiceNumber = pp.InvoiceNumber;
                                p1.PoNum = pp.PoNum;
                                p1.InvoiceAmount = pp.InvoiceAmount;
                                p1.AmountDue = pp.AmountDue;
                                p1.AuthCode = pp.AuthCode;
                                p1.RefNum = pp.RefNum;
                                p1.Last4 = pp.Last4;
                                p1.PaymentMethod = pp.PaymentMethod;
                                p1.PaidAmount = PaidAmount.setScale(2);
                                string DatePaid = pp.DatePaid;
                                if (DatePaid != Configuration.EMPTYSTRING && DatePaid != null) {
                                    List < String > strArr = DatePaid.split(Configuration.DATETIMESPLITTER);
                                    p1.PayDate = date.valueOf(strArr[0]);
                                    p1.PayTime = strArr[1];
                                }
                                string ReqDateTime = pp.PaymentRequestDateTime;
                                if (ReqDateTime != Configuration.EMPTYSTRING && ReqDateTime != null) {
                                    List < String > strArr = ReqDateTime.split(Configuration.DATETIMESPLITTER);
                                    p1.PaymentRequestDate = date.valueOf(strArr[0]);
                                    p1.PaymentRequestTime = strArr[1];
                                }
                                p1.TypeId = pp.TypeId;
                                p1.PaymentSourceId = pp.PaymentSourceId;
                                p1.PaymentMethodId = pp.PaymentMethodId;
                                p1.PaymentInternalId = pp.PaymentInternalId;
                                p1.CustomerEmailAddress = pp.CustomerEmailAddress;
                                pendingList.add(p1);
                            }
                    }
                }
                if (!test.isRunningTest()) {
                    if (cstIds != null) {
                        system.debug('Qbd Customer Ids are:>>>>>>>' +cstIds);
                        List < Account > accountInfolist = eBc_UtilityController.getAccountsDetailForQbd(dml, cstIds, ebcLogger);
                        system.debug('Account>>>>>>>>>>>>' + accountInfolist);
                        Map<String,String> cstMap = new map<String,String>();
                        Map<String,String> cstMap2 = new map<String,String>();
                        for (Account acc: accountInfolist) {
                        cstMap.put((String)acc.get('QBD_Customer_ID__c'),acc.Name);
                        cstMap2.put((String)acc.get('QBD_Customer_ID__c'),acc.id);
                        }
                        for (Payments p: pendingList) {
                            if (cstMap.containsKey(p.CustomerId)) {
                                p.CustomerName = cstMap.get(p.CustomerId);
                                p.CustomerId = cstMap2.get(p.CustomerId);
                                retPendingList.add(p);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return retPendingList;
    }
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
            Datetime fromDate = Datetime.newInstance(1900, 1, 1, 15, 20, 45);
            Datetime toDate = Datetime.newInstance(2100, 1, 1, 15, 20, 45);
            List < ebizchargeServicemodelSoap.Payment > paymentlist = new list < ebizchargeServicemodelSoap.Payment > ();
            ebizchargeServicemodelSoap.ArrayOfPayment arrpendings = new ebizchargeServicemodelSoap.ArrayOfPayment();
            ebizchargeServicemodelSoap.ArrayOfSearchFilter filterArr = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
            ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
            list < ebizchargeServicemodelSoap.SearchFilter > SearchFilterArr = new list < ebizchargeServicemodelSoap.SearchFilter > ();
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = Configuration.REFERENCENUMBER;
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = RefNum;
            SearchFilterArr.add(filter);
            filterArr.SearchFilter = SearchFilterArr;
            if (!test.isRunningTest()) {
                arrpendings = ebiz.SearchEbizWebFormReceivedPayments(eBc_UtilityController.getSecurityToken(dml, ebcLogger), transactionObject.CustomerID, fromDate, toDate, filterArr, 0, 10000, Configuration.CARDMETHODID);
            }
            if(arrpendings.Payment != null){
                paymentlist = arrpendings.Payment;
            }
            if (paymentlist.size() > 0) {
                ebizchargeServicemodelSoap.Payment pp = paymentlist[0];
                paymentMethodID = pp.PaymentMethodId;
                ebcLogger.debug(ClassName, MethodName, 'paymentMethodID is' + paymentMethodID);
            }
            if (paymentMethodID != null && paymentMethodID != Configuration.EMPTYSTRING) {
                string customerToken = ebiz.GetCustomerToken(eBc_UtilityController.getSecurityToken(dml, ebcLogger), transactionObject.CustomerID, Configuration.EMPTYSTRING);
                ebcLogger.debug(ClassName, MethodName, 'customerToken is' + customerToken);
                ebizchargeServicemodelSoap.PaymentMethodProfile PaymentMethodProfile = new ebizchargeServicemodelSoap.PaymentMethodProfile();
                PaymentMethodProfile = ebiz.GetCustomerPaymentMethodProfile(eBc_UtilityController.getSecurityToken(dml, ebcLogger), customerToken, paymentMethodID);
                if (PaymentMethodProfile != null) {
                    String cardExpiration = PaymentMethodProfile.CardExpiration;
                    list < string > cardExpirationList = cardExpiration.split(Configuration.KEYSPLITTERWITHDASH);
                    expiryYear = cardExpirationList[0];
                    expiryMonth = cardExpirationList[1];
                }
            }
            ebizchargeServicemodelSoap.PaymentResponse response1 = eBc_UtilityController.MarkEbizWebFormPaymentAsApplied(dml, PaymentInternalId, ebcLogger);
            eBc_UtilityController.markOrderPaid(dml, OrderId, RefNum, Amount, transactionObject, paymentMethodID, expiryYear, expiryMonth, ebcLogger);
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception err) {
            return err.getMessage();
        }
    }
    @AuraEnabled
    public static string markAllPaymentsAsApplied(list < Payments > selectedEmailPayList) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = markAllPaymentsAsApplied(dml, selectedEmailPayList, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string markAllPaymentsAsApplied(DML dml, list < Payments > selectedEmailPayList, EBC_Logger ebcLogger) {
        MethodName = 'markAllPaymentsAsApplied';
        try {
            for (Payments wr: selectedEmailPayList) {
                String RefNum = wr.RefNum;
                String PaymentInternalId = wr.PaymentInternalId;
                String InvoiceNumber = wr.PoNum;
                String OrderId = wr.OrderId;
                Double Amount = wr.PaidAmount;
                String res = markPaymentAsApplied(dml, RefNum, PaymentInternalId, InvoiceNumber, OrderId, Amount, ebcLogger);
            }
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    public class helperWrapper {
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
        @AuraEnabled public double OrderBalance {
            get;
            set;
        }
        @AuraEnabled public double OrderTax {
            get;
            set;
        }
        @AuraEnabled public Date EffectiveDate {
            get;
            set;
        }
        @AuraEnabled public Date endDate {
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
        @AuraEnabled public String PoNum {
            get;
            set;
        }
        @AuraEnabled public List < emailWrapperclass > emailTemplatelist {
            get;
            set;
        }
        @AuraEnabled public boolean isAllowPartialPay {
            get;
            set;
        }
    }
    public class OrderWrapper {
        @AuraEnabled public list < helperWrapper > accountOrders {
            get;
            set;
        }
        @AuraEnabled public Account accountDetail {
            get;
            set;
        }
    }

    public class emailWrapperclass {
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
        @AuraEnabled public String FromEmail {
            get;
            set;
        }
        @AuraEnabled public String ReplyToEmail {
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
        @AuraEnabled public Date PayDate {
            get;
            set;
        }
        @AuraEnabled public string PayTime {
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
}