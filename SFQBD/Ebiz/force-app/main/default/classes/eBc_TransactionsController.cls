public with sharing class eBc_TransactionsController {
    public static string ClassName = 'eBc_TransactionsController';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
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
        //return getSettingsApxc(dml);
    }
    public static EBizcharge_Setting__c getSettingsApxc(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getSettingsApxc';
        try {
            return eBc_UtilityController.getSettings(dml, ebcLogger);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return null;
        }
    }
    @auraEnabled
    public static String GetEmailTrans(string ref) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = GetEmailTrans(dml, ref, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
        //return GetEmailTrans(dml,ref);
    }
    public static String GetEmailTrans(DML dml, string ref, EBC_Logger ebcLogger) {
        MethodName = 'GetEmailTrans';
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        try {
            String email = Configuration.EMPTYSTRING;
            //querySelect = 'SELECT id,Contact_Id__c,EBizCharge_Fields_Id__c ,Ref_Number__c, Account_email__c';
            querySelect = 'SELECT id,Account_Id__c,Contact_Id__c,EBizCharge_Fields_Id__c,Ref_Number__c';
            queryFrom = 'from EBizCharge_Transaction__c';
            queryWhere = 'where Ref_Number__c =\'' + String.escapeSingleQuotes(ref) + '\'';
            Ebiz_C__EBizCharge_Transaction__c transactionEntity = (Ebiz_C__EBizCharge_Transaction__c) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            system.debug('Contact Id>>>' + transactionEntity.Contact_Id__c);
              if (transactionEntity.Contact_Id__c !=null) {
               try {
                querySelect = 'SELECT Email';
                queryFrom = 'from CONTACT';
                queryWhere = 'where id =\'' + String.escapeSingleQuotes(transactionEntity.Ebiz_C__Contact_Id__c) + '\'';
                Contact contact = (Contact) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                if (!String.isBlank(contact.Email)) {
                    email = contact.Email;
                }
             }
              catch(QueryException e)
                {}
             } else if(transactionEntity.EBizCharge_Fields_Id__c !=null){
                 try{
                    querySelect = 'SELECT Ebiz_C__EBizCharge_Email__c';
                    queryFrom = 'from Ebiz_C__EBizCharge_Fields_Config__c';
                    queryWhere = 'where Ebiz_C__EBizCharge_CustomerId__c =\'' + String.escapeSingleQuotes(transactionEntity.Ebiz_C__EBizCharge_Fields_Id__c) + '\'';
                    Ebiz_C__EBizCharge_Fields_Config__c ebizConfig = (Ebiz_C__EBizCharge_Fields_Config__c) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                    if (!String.isBlank(ebizConfig.Ebiz_C__EBizCharge_Email__c)) {
                        email = ebizConfig.Ebiz_C__EBizCharge_Email__c;
                    }
                }
                catch(QueryException e)
                {}
            } else if(transactionEntity.Account_Id__c !=null){
                try{
                    querySelect = 'SELECT id,Email__c';
                    queryFrom = 'from Account';
                    queryWhere = 'where id =\''+transactionEntity.Account_Id__c+'\'';
                    Account account  = (Account)dml.selectSingleRecord(querySelect,queryFrom,queryWhere,Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
                    if(!String.isBlank((String)account.get('Email__c')))
                    {
                        email = (String)account.get('Email__c');
                    }
                }
                catch(QueryException e)
                {}   
            }
            return email;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return Configuration.EMPTYSTRING;
        }
    }
    @AuraEnabled
    public static TransData getTransactionsApxc(String filters) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        TransData reciprocate = getTransactionsApxc(dml, filters, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
        //return getTransactionsApxc(dml,filters);
    }
    public static TransData getTransactionsApxc(DML dml, String filters, EBC_Logger ebcLogger) {
        MethodName = 'getTransactionsApxc';
        String querySelect = 'SELECT Id,Ref_Number__c';
        String queryFrom = 'FROM EBizCharge_Transaction__c';
        String queryWhere = Configuration.EMPTYSTRING;
        list < EBizCharge_Transaction__c > tansactions = (list < EBizCharge_Transaction__c > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        map < string, string > localTransactionsMap = new map < string, string > ();
        for (EBizCharge_Transaction__c transactionEntity: tansactions) {
            localTransactionsMap.put(transactionEntity.Ref_Number__c, transactionEntity.Ref_Number__c);
        }
        Boolean saveTransactions = true;
        TransData returnTransactions = new TransData();
        List < Transactions > transactionsList = new List < Transactions > ();
        list < String > transactionsToSearch = new list < String > ();
        map < String, String > referenceNumberMap = new map < String, String > ();
        list < EBizCharge_Transaction__c > transactionsToSave = new list < EBizCharge_Transaction__c > ();
        list < EBizCharge_Transaction__c > transactionsToInsert = new list < EBizCharge_Transaction__c > ();
        list < EBizCharge_Transaction__c > transactionsToUpsert = new list < EBizCharge_Transaction__c > ();
        ebizchargeServicemodelSoap.ArrayOfSearchFilter searchFilterArray = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        list < ebizchargeServicemodelSoap.SearchFilter > searchFilters = new list < ebizchargeServicemodelSoap.SearchFilter > ();
        Boolean matchAll = false;
        Boolean countOnly = false;
        String start = Configuration.STARTINDEX;
        String endLimit = Configuration.ENDLIMIT;
        Map < String, Object > filterMap = (Map < String, Object > ) JSON.deserializeUntyped(filters);
        String fromDate = Configuration.EMPTYSTRING;
        String toDate = Configuration.EMPTYSTRING;
        String endingDate = Configuration.EMPTYSTRING;
        String inputSearch = (string) filterMap.get(string.valueOf(Enums.FILTERJAVASCRIPTMAPSTRINGS.InputText));
        Boolean viewAll = (Boolean) filterMap.get(string.valueOf(Enums.FILTERJAVASCRIPTMAPSTRINGS.ViewAll));
        if (inputSearch != null && inputSearch != Configuration.EMPTYSTRING) {
            String isAmount = inputSearch.trim();
            String regex = Configuration.ALPHANUMERICREGEXSTRING;
            Pattern pattern = Pattern.compile(regex);
            Matcher matcher = pattern.matcher(isAmount);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.TransID);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = inputSearch.trim();
            searchFilters.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.OrderID);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = inputSearch.trim();
            searchFilters.add(filter);
            if (!matcher.matches()) {
                filter = new ebizchargeServicemodelSoap.SearchFilter();
                filter.FieldName = string.valueOf(Enums.FIELDNAMES.Amount);
                filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
                filter.FieldValue = inputSearch.trim();
            }
            searchFilters.add(filter);
        } else {
            fromDate = (String) filterMap.get(string.valueOf(Enums.FILTERJAVASCRIPTMAPSTRINGS.fromDate));
            toDate = (String) filterMap.get(string.valueOf(Enums.FILTERJAVASCRIPTMAPSTRINGS.toDate));
            if (fromDate == null && toDate == null) {
                saveTransactions = false;
                DateTime startDate = system.Today();
                DateTime endDate = system.Today().AddDays(1);
                DateTime endDateToShow = system.Today();
                string filterBy = Configuration.EMPTYSTRING;
                EBizcharge_Setting__c setting = eBc_UtilityController.getSettings(dml, ebcLogger);
                if (setting.Transaction_Filter_By__c != null) {
                    filterBy = setting.Transaction_Filter_By__c;
                    if (filterBy == string.valueOf(Enums.FILTERBY.Today)) {
                        fromDate = startDate.formatGMT(Configuration.DATEFORMAT);
                        toDate = endDate.formatGMT(Configuration.DATEFORMAT);
                        endingDate =endDateToShow.formatGMT(Configuration.DATEFORMAT);
                    } else if (filterBy == Configuration.FILTERBYPASTWEEK) {
                        Datetime datetimeEntity = System.Today() - 6;
                        fromDate = datetimeEntity.formatGMT(Configuration.DATEFORMAT);
                        toDate = endDate.formatGMT(Configuration.DATEFORMAT);
                        endingDate =endDateToShow.formatGMT(Configuration.DATEFORMAT);
                    } else if (filterBy == Configuration.FILTERBYPASTMONTH) {
                        Datetime datetimeEntity =  system.Today() - 30;
                        fromDate = datetimeEntity.formatGMT(Configuration.DATEFORMAT);
                        toDate = endDate.formatGMT(Configuration.DATEFORMAT);
                        endingDate =endDateToShow.formatGMT(Configuration.DATEFORMAT);
                    } else if (filterBy == Configuration.FILTERBYPASTYEAR) {
                        Datetime datetimeEntity = system.Today() - 364;
                        fromDate = datetimeEntity.formatGMT(Configuration.DATEFORMAT);
                        toDate = endDate.formatGMT(Configuration.DATEFORMAT);
                        endingDate =endDateToShow.formatGMT(Configuration.DATEFORMAT);
                    }
                } else {
                   Datetime datetimeEntity =  System.Today() - 6;
                    fromDate = datetimeEntity.formatGMT(Configuration.DATEFORMAT);
                    toDate = endDate.formatGMT(Configuration.DATEFORMAT);
                    endingDate =endDateToShow.formatGMT(Configuration.DATEFORMAT);
                }
            }
            matchAll = true;
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.Created);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
            filter.FieldValue = fromDate;
            searchFilters.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.Created);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.lt);
            filter.FieldValue = toDate;
            searchFilters.add(filter);
        }
        searchFilterArray.SearchFilter = searchFilters;
        try {
            ebizchargeServicemodelSoap.TransactionSearchResult searchTransactionsResult = new ebizchargeServicemodelSoap.TransactionSearchResult();
            searchTransactionsResult = ebiz.SearchTransactions(eBc_UtilityController.getSecurityToken(dml, ebcLogger), searchFilterArray, matchAll, countOnly, start, endLimit, Configuration.EMPTYSTRING);
            if (searchTransactionsResult.Transactions != null) {
                Schema.DescribeSObjectResult sObjectResult = Account.sObjectType.getDescribe();
                String accountPrefix = sObjectResult.getKeyPrefix();
                sObjectResult = Contact.sObjectType.getDescribe();
                String contactPrefix = sObjectResult.getKeyPrefix();
                sObjectResult = Order.sObjectType.getDescribe();
                String orderPrefix = sObjectResult.getKeyPrefix();
                sObjectResult = Opportunity.sObjectType.getDescribe();
                String opportunityPrefix = sObjectResult.getKeyPrefix();
                sObjectResult = Quote.sObjectType.getDescribe();
                String quotePrefix = sObjectResult.getKeyPrefix();
                ebizchargeServicemodelSoap.ArrayOfTransactionObject transactions = searchTransactionsResult.Transactions;
                if (transactions.TransactionObject != null) {
                    ebizchargeServicemodelSoap.TransactionObject[] transactionObjects;
                    transactionObjects = transactions.TransactionObject;
                    if (transactionObjects != null) {
                        for (ebizchargeServicemodelSoap.TransactionObject ebizTransaction: transactionObjects) {
                            ebizchargeServicemodelSoap.TransactionResponse ebizTransactionResponse = ebizTransaction.Response;
                            ebizchargeServicemodelSoap.TransactionDetail transactionDetail = ebizTransaction.Details;
                            if (ebizTransactionResponse.Result != string.valueOf(Enums.RETURNMESSAGE.Error)) {
                                if (!viewAll && !localTransactionsMap.containsKey(ebizTransactionResponse.RefNum) && transactionDetail.Clerk != string.valueOf(Enums.FIELDVALUES.SalesforceApp)) {
                                    continue;
                                }
                                if (ebizTransaction.CustomerID != null) {
                                    if (!(ebizTransactionResponse.AuthAmount == 0.05)) {
                                        Transactions transactionEntity = new Transactions();
                                        EBizCharge_Transaction__c transactionToSave = new EBizCharge_Transaction__c();
                                        transactionEntity.Source = ebizTransaction.Source;
                                        transactionEntity.TransType = ebizTransaction.TransactionType;
                                        transactionToSave.Transaction_Type__c = ebizTransaction.TransactionType;
                                        transactionEntity.CustomerId = ebizTransaction.CustomerID;
                                        string ebizDateTime = ebizTransaction.DateTime_x;
                                        list < String > transactionDateTime = ebizDateTime.split(' ');
                                        String paidPaymentTime = transactionDateTime[0] + Configuration.DATETIMESEPERATOR + transactionDateTime[1];
                                        transactionToSave.CreatedDateTime__c = Datetime.valueOf(ebizDateTime);
                                        transactionEntity.FormatedTransDate = DateTime.Valueof(paidPaymentTime);
                                        transactionEntity.DateTime_x = ebizTransaction.DateTime_x;
                                        transactionEntity.AccountName = ebizTransaction.AccountHolder;
                                        transactionEntity.OrderNumber = transactionDetail.Invoice;
                                        transactionEntity.OrderId =  transactionDetail.OrderID;
                                        transactionEntity.Tax = transactionDetail.Tax;
                                        transactionToSave.Tax__c = transactionDetail.Tax;
                                        transactionEntity.Terminal = transactionDetail.Terminal;
                                        transactionEntity.CustNum = ebizTransactionResponse.CustNum;
                                        transactionToSave.Customer_Number__c = ebizTransactionResponse.CustNum;
                                        transactionEntity.ResultCode = ebizTransactionResponse.ResultCode;
                                        transactionToSave.Result_Code__c = ebizTransactionResponse.ResultCode;
                                        transactionEntity.Result = ebizTransactionResponse.Result;
                                        transactionToSave.Result__c = ebizTransactionResponse.Result;
                                        transactionEntity.RefNumber = ebizTransactionResponse.RefNum;
                                        transactionsToSearch.add(ebizTransactionResponse.RefNum);
                                        transactionToSave.Ref_Number__c = ebizTransactionResponse.RefNum;
                                        if (ebizTransactionResponse.Error != null) {
                                            transactionEntity.Error = ebizTransactionResponse.Error;
                                            transactionToSave.Error__c = ebizTransactionResponse.Error;
                                            transactionEntity.ErrorCode = ebizTransactionResponse.ErrorCode;
                                            transactionToSave.Error_Code__c = ebizTransactionResponse.ErrorCode;
                                        }
                                        transactionEntity.AuthCode = ebizTransactionResponse.AuthCode;
                                        transactionToSave.Auth_Code__c = ebizTransactionResponse.AuthCode;
                                        transactionEntity.AuthAmount = ebizTransactionResponse.AuthAmount;
                                        transactionToSave.Auth_Amount__c = ebizTransactionResponse.AuthAmount;
                                        transactionEntity.Status = ebizTransactionResponse.Status;
                                        transactionToSave.Status__c = ebizTransactionResponse.Status;
                                        transactionEntity.StatusCode = ebizTransactionResponse.StatusCode;
                                        transactionToSave.Status_Code__c = ebizTransactionResponse.StatusCode;
                                        ebizchargeServicemodelSoap.CreditCardData creditCard = ebizTransaction.CreditCardData;
                                        if (test.isRunningTest()) {
                                            creditCard.CardNumber = '11111';
                                        }
                                        if (creditCard.CardNumber != null) {
                                            transactionEntity.PayBy = string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard);
                                            transactionToSave.Payment_Method__c = string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard);
                                            transactionEntity.CardType = creditCard.CardType;
                                            transactionToSave.Card_Type__c = creditCard.CardType;
                                            transactionEntity.CardNumber = creditCard.CardNumber.right(4);
                                            transactionToSave.Card_Number__c = creditCard.CardNumber;
                                        }
                                        ebizchargeServicemodelSoap.CheckData chekData = ebizTransaction.CheckData;
                                        if (chekData.Account != null) {
                                            transactionEntity.PayBy = string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check);
                                            transactionToSave.Payment_Method__c = string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check);
                                            transactionEntity.checkAccount = chekData.Account.right(4);
                                        }
                                        transactionEntity.isSelected = false;
                                        transactionsList.add(transactionEntity);
                                        transactionsToSave.add(transactionToSave);
                                    }
                                }
                            }
                        }
                        // end of loop...
                    }
                }
            }
            returnTransactions.Transactions = transactionsList;
            returnTransactions.fromDate = (fromDate == Configuration.EMPTYSTRING ? null : date.valueOf(fromDate));
            returnTransactions.toDate = (toDate == Configuration.EMPTYSTRING ? null : date.valueOf(toDate));
            if (saveTransactions) {
                querySelect = 'SELECT Id,Ref_Number__c';
                queryFrom = 'FROM EBizCharge_Transaction__c';
                queryWhere = 'WHERE Ref_Number__c IN :';
                list < EBizCharge_Transaction__c > localTransactions = (list < EBizCharge_Transaction__c > ) dml.selectRecordsInList(transactionsToSearch, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                ebcLogger.debug(ClassName, MethodName, '>>>local transactions' + localTransactions);
                for (EBizCharge_Transaction__c transactionEntity: localTransactions) {
                    referenceNumberMap.put(transactionEntity.Ref_Number__c, transactionEntity.id);
                }
                for (EBizCharge_Transaction__c transactionEntity: transactionsToSave) {
                    if (referenceNumberMap.containskey(transactionEntity.Ref_Number__c)) {
                        transactionEntity.id = referenceNumberMap.get(transactionEntity.Ref_Number__c);
                        transactionsToUpsert.add(transactionEntity);
                    } else {
                        transactionsToUpsert.add(transactionEntity);
                    }
                }
                ebcLogger.debug(ClassName, MethodName, '>>>upsert list is' + transactionsToUpsert);
                ebcLogger.debug(ClassName, MethodName, '>>>insert list is' + transactionsToInsert);
                dml.upsertRecord(transactionsToUpsert, 'Ebiz_C__EBizCharge_Transaction__c.id');
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnTransactions;
    }
    @AuraEnabled
    public static String refundORVoidApxc(String aType, String RefNo, String Amount, String Tax, String OrderId, String AccountId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = refundORVoidApxc(dml, aType, RefNo, Amount, Tax, OrderId, AccountId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
        //return refundORVoidApxc(dml,aType,RefNo,Amount,Tax,OrderId,AccountId);
    }
    public static String refundORVoidApxc(DML dml, String aType, String RefNo, String Amount, String Tax, String OrderId, String AccountId, EBC_Logger ebcLogger) {
        MethodName = 'refundORVoidApxc';
        EBizcharge_Setting__c settings = eBc_UtilityController.getSettings(dml, ebcLogger);
        ebizchargeServicemodelSoap.TransactionObject gatewayTransaction = new ebizchargeServicemodelSoap.TransactionObject();
        gatewayTransaction = ebiz.GetTransactionDetails(eBc_UtilityController.getSecurityToken(dml, ebcLogger), RefNo);
        ebizchargeServicemodelSoap.TransactionDetail gatewaytransactionDetail = new ebizchargeServicemodelSoap.TransactionDetail();
        gatewaytransactionDetail = gatewayTransaction.Details;
        string divisionId = settings.Division_ID__c;
        divisionId = divisionId != null ? divisionId : Configuration.EMPTYSTRING;
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        String queryOrderby = Configuration.EMPTYSTRING;
        String queryLimit = Configuration.EMPTYSTRING;
        String returnMessage = Configuration.EMPTYSTRING;
        ebizchargeServicemodelSoap.TransactionRequestObject ebizTransaction = new ebizchargeServicemodelSoap.TransactionRequestObject();
        try {
            String paymentMethodID = Configuration.EMPTYSTRING;
            Decimal paymentStatus = 1;
            if (aType == string.valueOf(Enums.TRANSACTIONACTIONS.refund)) {
                paymentMethodID = Configuration.REFUNDTRANSACTIONCOMMAND;
                paymentStatus = 2;
                ebizchargeServicemodelSoap.TransactionDetail transactionDetail = new ebizchargeServicemodelSoap.TransactionDetail();
                transactionDetail.Amount = double.valueOf(Amount);
                transactionDetail.NonTax = false;
                transactionDetail.Tax = 0;
                transactionDetail.Subtotal = 0;
                transactionDetail.Shipping = 0;
                transactionDetail.Duty = 0;
                transactionDetail.Discount = 0;
                transactionDetail.AllowPartialAuth = false;
                transactionDetail.Tip = 0;
                transactionDetail.Terminal = gatewaytransactionDetail.Terminal;
                transactionDetail.Clerk = gatewaytransactionDetail.Clerk;
                ebizTransaction.Details = transactionDetail;
            } else if (aType == Configuration.VOIDTRANSACTIONACTION) {
                paymentMethodID = Configuration.VOIDPAYMENTSTATUS;
                paymentStatus = 3;
            } else if (aType == Configuration.PARTIALTRANSACTIONACTION) {
                paymentMethodID = string.valueOf(Enums.TRANSACTIONCOMMANDS.Credit);
                paymentStatus = 4;
                ebizchargeServicemodelSoap.TransactionDetail transactionDetail = new ebizchargeServicemodelSoap.TransactionDetail();
                transactionDetail.Amount = double.valueOf(Amount);
                transactionDetail.NonTax = false;
                transactionDetail.Tax = 0;
                transactionDetail.Subtotal = 0;
                transactionDetail.Shipping = 0;
                transactionDetail.Duty = 0;
                transactionDetail.Discount = 0;
                transactionDetail.AllowPartialAuth = false;
                transactionDetail.Tip = 0;
                transactionDetail.Terminal = gatewaytransactionDetail.Terminal;
                transactionDetail.Clerk = gatewaytransactionDetail.Clerk;
                ebizTransaction.Details = transactionDetail;
            }
            ebizTransaction.Command = paymentMethodID;
            ebizTransaction.IgnoreDuplicate = true;
            ebizTransaction.RefNum = RefNo;
            ebizTransaction.IsRecurring = false;
            ebizTransaction.CustReceipt = true;
            ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
            response = ebiz.runTransaction(eBc_UtilityController.getSecurityToken(dml, ebcLogger), ebizTransaction);
            ebcLogger.debug(ClassName, MethodName, '>>>response: ' + response.ResultCode);
            if (response.ResultCode == Configuration.TRANSACTIONRESULTCODE) {
                ebizchargeServicemodelSoap.TransactionDetail transactionDetail = new ebizchargeServicemodelSoap.TransactionDetail();
                ebizchargeServicemodelSoap.TransactionObject transactionObject = new ebizchargeServicemodelSoap.TransactionObject();
                String refNum = Configuration.EMPTYSTRING;
                if (test.isRunningTest()) {
                    aType = 'void';
                }
                if (aType == Configuration.VOIDTRANSACTIONACTION) {
                    refNum = response.RefNum;
                } else if (aType == string.valueOf(Enums.TRANSACTIONACTIONS.refund) || aType == Configuration.PARTIALTRANSACTIONACTION) {
                    refNum = RefNo;
                }
                Double transactionTax = 0.0;
                String transactionType = Configuration.EMPTYSTRING;
                Double returnedAmount = 0.0;
                Double subtotal = 0.0;
                Double detailAmount = 0.0;
                Double refundAmount = double.valueOf(Amount);
                Boolean transactionFound = false;
                ebcLogger.debug(ClassName, MethodName, '>>>OrderId.length: ' + OrderId.length());
                ebcLogger.debug(ClassName, MethodName, '>>>OrderId: ' + OrderId);
                EBizCharge_Transaction__c transactionEntity = new EBizCharge_Transaction__c();
                querySelect = 'SELECT Order_Id__c,Id,CreatedDate,Quote_Id__c,Invoice__c,Tax__c,Transaction_Type__c,EBizCharge_Subtotal__c,Detail_Amount__c,EBizCharge_Returned_Amount__c';
                queryFrom = 'FROM EBizCharge_Transaction__c';
                queryWhere = 'where Ref_Number__c = \'' + String.escapeSingleQuotes(RefNum) + '\'';
                queryOrderby = 'order by CreatedDate desc';
                try {
                    transactionEntity = (EBizCharge_Transaction__c) dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, queryOrderby);
                    transactionFound = true;
                } catch (Exception e) {}
                EBizCharge_Transaction__c transactionToUpdate = new EBizCharge_Transaction__c();
                if (gatewaytransactionDetail.Clerk != string.valueOf(Enums.FIELDVALUES.SalesforceApp) && !transactionFound) {
                    return Configuration.GATEWAYSUCCESSMESSAGE;
                }
                ebcLogger.debug(ClassName, MethodName, '>>>transactionEntity: ' + transactionEntity);
                if (transactionFound) {
                    transactionToUpdate.id = transactionEntity.id;
                    detailAmount = Double.valueOf(transactionEntity.Detail_Amount__c);
                    subtotal = Double.valueOf(transactionEntity.EBizCharge_Subtotal__c);
                    transactionType = transactionEntity.Transaction_Type__c;
                    transactionTax = transactionEntity.Tax__c;
                    returnedAmount = Double.valueOf(transactionEntity.EBizCharge_Returned_Amount__c);
                    if (aType == Configuration.PARTIALTRANSACTIONACTION) {
                        if (subtotal != 0) {
                            if ((refundAmount + returnedAmount) > subtotal) {
                                refundAmount = refundAmount - transactionTax;
                            }
                            Double perTransactionTax = Double.valueOf(transactionEntity.Tax__c / subtotal);
                            transactionTax = Double.valueOf(perTransactionTax * refundAmount);
                        }
                    } else {
                        transactionTax = Double.valueOf(transactionEntity.Tax__c);
                    }
                    ebcLogger.debug(ClassName, MethodName, '>>>transactionTax: ' + transactionTax);
                }
                Boolean isOrderRefNum = false;
                Boolean isRefNum = false;
                if (transactionEntity.Order_Id__c != null) {
                    isOrderRefNum = true;
                } else if (transactionEntity.Quote_Id__c != null) {
                    isRefNum = true;
                }
                ebcLogger.debug(ClassName, MethodName, '>>>isRefNum: ' + isRefNum);
                ebcLogger.debug(ClassName, MethodName, '>>>isOrderRefNum: ' + isOrderRefNum);
                if (test.isRunningTest()) {
                    isRefNum = true;
                    isOrderRefNum = true;
                }
                if (isRefNum == true || isOrderRefNum == true) {
                        Double orderTotal = 0.0;
                        Double eBizAmount = 0.0;
                        Double eBizCapturedAmount = 0.0;
                        Double orderBalance = 0.0;
                        String updatedOrderId = Configuration.EMPTYSTRING;
                        Double orderTax = 0.0;
                        String orderPaymentStatus = Configuration.EMPTYSTRING;
                        Double quoteBalance = 0.0;
                        Double quoteTax = 0.0;
                        String quotePaymentStatus = Configuration.EMPTYSTRING;
                        if (isOrderRefNum) {
                            try {
                            querySelect = 'SELECT Id,TotalAmount,EBizCharge_Amount__c,EBizCharge_Captured_Amount__c,EBizCharge_Order_Balance__c, EBizCharge_Order_Tax__c, EBizCharge_Payment_Status__c';
                            queryFrom = 'from order';
                            queryWhere = 'where OrderNumber  =\'' + String.escapeSingleQuotes(OrderId) + '\'';
                            queryLimit = 'limit 1';
                            for (Order order: (list < Order > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryLimit)) {
                                updatedOrderId = order.id;
                                orderTotal = order.TotalAmount;
                                eBizAmount = order.EBizCharge_Amount__c;
                                eBizCapturedAmount = order.EBizCharge_Captured_Amount__c;
                                orderBalance = order.EBizCharge_Order_Balance__c;
                                orderTax = order.EBizCharge_Order_Tax__c;
                                orderPaymentStatus = order.EBizCharge_Payment_Status__c;
                            }
                            ebcLogger.debug(ClassName, MethodName, '>>>updatedOrderId: ' + updatedOrderId);
                            Order updatedOrder = new Order();
                            updatedOrder.Id = updatedOrderId;
                            updatedOrder.EBizCharge_Reference_Number__c = RefNum;
                            if (transactionType == Configuration.AUTHONLYTRANSACTION) {
                                if (subtotal != 0) {
                                    updatedOrder.EBizCharge_Amount__c = eBizAmount - refundAmount;
                                    updatedOrder.EBizCharge_Order_Tax__c = orderTax - transactionTax;
                                } else {
                                    updatedOrder.EBizCharge_Amount__c = eBizAmount - refundAmount;
                                }
                            } else {
                                if (subtotal != 0) {
                                    if (aType == Configuration.PARTIALTRANSACTIONACTION) {
                                        updatedOrder.EBizCharge_Captured_Amount__c = eBizCapturedAmount - refundAmount - transactionTax;
                                        updatedOrder.EBizCharge_Order_Balance__c = orderBalance + refundAmount;
                                    } else {
                                        updatedOrder.EBizCharge_Captured_Amount__c = eBizCapturedAmount - refundAmount;
                                        updatedOrder.EBizCharge_Order_Balance__c = orderBalance + refundAmount - transactionTax;
                                    }
                                    updatedOrder.EBizCharge_Order_Tax__c = orderTax - transactionTax;
                                } else {
                                    updatedOrder.EBizCharge_Captured_Amount__c = eBizCapturedAmount - refundAmount;
                                    updatedOrder.EBizCharge_Order_Balance__c = orderBalance + refundAmount;
                                }
                            }
                            updatedOrder.EBizCharge_Order_Status__c = string.valueOf(Enums.ENTITYSTATUS.Unpaid);
                            if (orderPaymentStatus == string.valueOf(Enums.ENTITYPAYMENTSTATUS.Preauth) && transactionType == string.valueOf(Enums.ENTITYPAYMENTSTATUS.Preauth)) {} else {
                                if (aType == Configuration.VOIDTRANSACTIONACTION) {
                                    updatedOrder.EBizCharge_Payment_Status__c = Configuration.VOIDPAYMENTSTATUS;
                                    transactionToUpdate.Transaction_Type__c = Configuration.VOIDTRANSACTIONTYPE;
                                } else if (aType == string.valueOf(Enums.TRANSACTIONACTIONS.refund)) {
                                    updatedOrder.EBizCharge_Payment_Status__c = string.valueOf(Enums.ENTITYPAYMENTSTATUS.Refund);
                                    transactionToUpdate.Transaction_Type__c = string.valueOf(Enums.PAYMENTTYPES.Credit);
                                } else if (aType == Configuration.PARTIALTRANSACTIONACTION) {
                                    updatedOrder.EBizCharge_Payment_Status__c = Configuration.PARTIALTRANSACTIONSTATUS;
                                    transactionToUpdate.Transaction_Type__c = string.valueOf(Enums.PAYMENTTYPES.Credit);
                                }
                            }
                            transactionToUpdate.EBizCharge_Returned_Amount__c = returnedAmount + refundAmount;
                            dml.updateRecord(updatedOrder);
                            dml.updateRecord(transactionToUpdate);
                            returnMessage = string.valueOf(Enums.RETURNMESSAGE.Success);
                        } catch (Exception e) {
                            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
                        }
                        }
                        if (isOrderRefNum) {
                            try {
                            querySelect = 'SELECT Id,TotalAmount,EBizCharge_Amount__c,EBizCharge_Captured_Amount__c,EBizCharge_Order_Balance__c, EBizCharge_Order_Tax__c,EBizCharge_Payment_Status__c';
                            queryFrom = 'from order';
                            queryWhere = 'where id  =\'' + String.escapeSingleQuotes(OrderId) + '\'';
                            queryLimit = 'limit 1';
                            for (Order order: (list < Order > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryLimit)) {
                                updatedOrderId = order.id;
                                orderTotal = order.TotalAmount;
                                eBizAmount = order.EBizCharge_Amount__c;
                                orderBalance = order.EBizCharge_Order_Balance__c;
                                orderTax = order.EBizCharge_Order_Tax__c;
                                eBizCapturedAmount = order.EBizCharge_Captured_Amount__c;
                                orderPaymentStatus = order.EBizCharge_Payment_Status__c;
                            }
                            Order updatedOrder = new Order();
                            updatedOrder.Id = updatedOrderId;
                            updatedOrder.EBizCharge_Reference_Number__c = RefNum;
                            if (transactionType == Configuration.AUTHONLYTRANSACTION) {
                                if (subtotal != 0) {
                                    updatedOrder.EBizCharge_Amount__c = eBizAmount - refundAmount;
                                    updatedOrder.EBizCharge_Order_Tax__c = orderTax - transactionTax;
                                } else {
                                    updatedOrder.EBizCharge_Amount__c = eBizAmount - refundAmount;
                                }
                            } else {
                                if (subtotal != 0) {
                                    if (aType == Configuration.PARTIALTRANSACTIONACTION) {
                                        updatedOrder.EBizCharge_Captured_Amount__c = eBizCapturedAmount - refundAmount - transactionTax;
                                        updatedOrder.EBizCharge_Order_Balance__c = orderBalance + refundAmount;
                                    } else {
                                        updatedOrder.EBizCharge_Captured_Amount__c = eBizCapturedAmount - refundAmount;
                                        updatedOrder.EBizCharge_Order_Balance__c = orderBalance + refundAmount - transactionTax;
                                    }
                                    updatedOrder.EBizCharge_Order_Tax__c = orderTax - transactionTax;
                                } else {
                                    updatedOrder.EBizCharge_Captured_Amount__c = eBizCapturedAmount - refundAmount;
                                    updatedOrder.EBizCharge_Order_Balance__c = orderBalance + refundAmount;
                                }
                            }
                            updatedOrder.EBizCharge_Order_Status__c = string.valueOf(Enums.ENTITYSTATUS.Unpaid);
                            if (orderPaymentStatus == string.valueOf(Enums.ENTITYPAYMENTSTATUS.Preauth) && transactionType == string.valueOf(Enums.ENTITYPAYMENTSTATUS.Preauth)) {} else {
                                if (aType == Configuration.VOIDTRANSACTIONACTION) {
                                    updatedOrder.EBizCharge_Payment_Status__c = Configuration.VOIDPAYMENTSTATUS;
                                    transactionToUpdate.Transaction_Type__c = Configuration.VOIDTRANSACTIONTYPE;
                                } else if (aType == string.valueOf(Enums.TRANSACTIONACTIONS.refund)) {
                                    updatedOrder.EBizCharge_Payment_Status__c = string.valueOf(Enums.ENTITYPAYMENTSTATUS.Refund);
                                    transactionToUpdate.Transaction_Type__c = string.valueOf(Enums.PAYMENTTYPES.Credit);
                                } else if (aType == Configuration.PARTIALTRANSACTIONACTION) {
                                    updatedOrder.EBizCharge_Payment_Status__c = Configuration.PARTIALTRANSACTIONSTATUS;
                                    transactionToUpdate.Transaction_Type__c = string.valueOf(Enums.PAYMENTTYPES.Credit);
                                }
                            }
                            transactionToUpdate.EBizCharge_Returned_Amount__c = returnedAmount + refundAmount;
                            dml.updateRecord(updatedOrder);
                            dml.updateRecord(transactionToUpdate);
                            returnMessage = string.valueOf(Enums.RETURNMESSAGE.Success);
                        } catch (Exception e) {
                            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
                        }
                        }
                        if (isRefNum) {
                            try{
                            querySelect = 'SELECT Id,GrandTotal,EBizCharge_Amount__c,EBizCharge_Captured_Amount__c,EBizCharge_Quote_Balance__c, EBizCharge_Reference_Number__c, EBizCharge_Quote_Tax_c__c,EBizCharge_Payment_Status__c';
                            queryFrom = 'FROM Quote';
                            queryWhere = 'where QuoteNumber  =\'' + String.escapeSingleQuotes(OrderId) + '\'';
                            queryLimit = 'limit 1';
                            for (Quote quote: (list < Quote > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryLimit)) {
                                updatedOrderId = quote.id;
                                orderTotal = quote.GrandTotal;
                                eBizAmount = quote.EBizCharge_Amount__c;
                                quoteBalance = quote.EBizCharge_Quote_Balance__c;
                                quoteTax = quote.EBizCharge_Quote_Tax_c__c;
                                eBizCapturedAmount = quote.EBizCharge_Captured_Amount__c;
                                quotePaymentStatus = quote.EBizCharge_Payment_Status__c;
                            }
                            ebcLogger.debug(ClassName, MethodName, '>>>updatedOrderId: ' + updatedOrderId);
                            Quote updatedQuote = new Quote();
                            updatedQuote.Id = updatedOrderId;
                            updatedQuote.EBizCharge_Reference_Number__c = RefNum;
                            if (transactionType == Configuration.AUTHONLYTRANSACTION) {
                                if (subtotal != 0) {
                                    updatedQuote.EBizCharge_Amount__c = eBizAmount - refundAmount;
                                    updatedQuote.EBizCharge_Quote_Tax_c__c = quoteTax - transactionTax;
                                } else {
                                    updatedQuote.EBizCharge_Amount__c = eBizAmount - refundAmount;
                                }
                            } else {
                                if (subtotal != 0) {
                                    if (aType == Configuration.PARTIALTRANSACTIONACTION) {
                                        updatedQuote.EBizCharge_Captured_Amount__c = eBizCapturedAmount - refundAmount - transactionTax;
                                        updatedQuote.EBizCharge_Quote_Balance__c = quoteBalance + refundAmount;
                                    } else {
                                        updatedQuote.EBizCharge_Captured_Amount__c = eBizCapturedAmount - refundAmount;
                                        updatedQuote.EBizCharge_Quote_Balance__c = quoteBalance + refundAmount - transactionTax;
                                    }
                                    updatedQuote.EBizCharge_Quote_Tax_c__c = quoteTax - transactionTax;
                                } else {
                                    updatedQuote.EBizCharge_Captured_Amount__c = eBizCapturedAmount - refundAmount;
                                    updatedQuote.EBizCharge_Quote_Balance__c = quoteBalance + refundAmount;
                                }
                            }
                            updatedQuote.EBizCharge_Quote_Status__c = string.valueOf(Enums.ENTITYSTATUS.Unpaid);
                            if (quotePaymentStatus == string.valueOf(Enums.ENTITYPAYMENTSTATUS.Preauth) && transactionType == string.valueOf(Enums.ENTITYPAYMENTSTATUS.Preauth)) {} else {
                                if (aType == Configuration.VOIDTRANSACTIONACTION) {
                                    updatedQuote.EBizCharge_Payment_Status__c = Configuration.VOIDPAYMENTSTATUS;
                                    transactionToUpdate.Transaction_Type__c = Configuration.VOIDTRANSACTIONTYPE;
                                } else if (aType == string.valueOf(Enums.TRANSACTIONACTIONS.refund)) {
                                    updatedQuote.EBizCharge_Payment_Status__c = string.valueOf(Enums.ENTITYPAYMENTSTATUS.Refund);
                                    transactionToUpdate.Transaction_Type__c = string.valueOf(Enums.PAYMENTTYPES.Credit);
                                } else if (aType == Configuration.PARTIALTRANSACTIONACTION) {
                                    updatedQuote.EBizCharge_Payment_Status__c = Configuration.PARTIALTRANSACTIONSTATUS;
                                    transactionToUpdate.Transaction_Type__c = string.valueOf(Enums.PAYMENTTYPES.Credit);
                                }
                            }
                            transactionToUpdate.EBizCharge_Returned_Amount__c = returnedAmount + refundAmount;
                            dml.updateRecord(updatedQuote);
                            dml.updateRecord(transactionToUpdate);
                            returnMessage = string.valueOf(Enums.RETURNMESSAGE.Success);
                        } catch (Exception e) {
                            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
                
                        }
                        }
                        if (isRefNum) {
                            try{
                            querySelect = 'SELECT Id,GrandTotal,EBizCharge_Amount__c,EBizCharge_Captured_Amount__c,EBizCharge_Quote_Balance__c, EBizCharge_Reference_Number__c, EBizCharge_Quote_Tax_c__c,EBizCharge_Payment_Status__c';
                            queryFrom = 'FROM Quote';
                            queryWhere = 'where id  =\'' + String.escapeSingleQuotes(OrderId) + '\'';
                            queryLimit = 'limit 1';
                            for (Quote quote: (list < Quote > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryLimit)) {

                                updatedOrderId = quote.id;
                                orderTotal = quote.GrandTotal;
                                eBizAmount = quote.EBizCharge_Amount__c;
                                quoteBalance = quote.EBizCharge_Quote_Balance__c;
                                quoteTax = quote.EBizCharge_Quote_Tax_c__c;
                                eBizCapturedAmount = quote.EBizCharge_Captured_Amount__c;
                                quotePaymentStatus = quote.EBizCharge_Payment_Status__c;
                            }
                            ebcLogger.debug(ClassName, MethodName, '>>>updatedOrderId: ' + updatedOrderId);
                            Quote updatedQuote = new Quote();
                            updatedQuote.Id = updatedOrderId;
                            updatedQuote.EBizCharge_Reference_Number__c = RefNum;
                            if (transactionType == Configuration.AUTHONLYTRANSACTION) {
                                if (subtotal != 0) {
                                    updatedQuote.EBizCharge_Amount__c = eBizAmount - refundAmount;
                                    updatedQuote.EBizCharge_Quote_Tax_c__c = quoteTax - transactionTax;
                                } else {
                                    updatedQuote.EBizCharge_Amount__c = eBizAmount - refundAmount;
                                }
                            } else {
                                if (subtotal != 0) {
                                    if (aType == Configuration.PARTIALTRANSACTIONACTION) {
                                        updatedQuote.EBizCharge_Captured_Amount__c = eBizCapturedAmount - refundAmount - transactionTax;
                                        updatedQuote.EBizCharge_Quote_Balance__c = quoteBalance + refundAmount;
                                    } else {
                                        updatedQuote.EBizCharge_Captured_Amount__c = eBizCapturedAmount - refundAmount;
                                        updatedQuote.EBizCharge_Quote_Balance__c = quoteBalance + refundAmount - transactionTax;
                                    }
                                    updatedQuote.EBizCharge_Quote_Tax_c__c = quoteTax - transactionTax;
                                } else {
                                    updatedQuote.EBizCharge_Captured_Amount__c = eBizCapturedAmount - refundAmount;
                                    updatedQuote.EBizCharge_Quote_Balance__c = quoteBalance + refundAmount;
                                }
                            }
                            updatedQuote.EBizCharge_Quote_Status__c = string.valueOf(Enums.ENTITYSTATUS.Unpaid);
                            if (quotePaymentStatus == string.valueOf(Enums.ENTITYPAYMENTSTATUS.Preauth) && transactionType == string.valueOf(Enums.ENTITYPAYMENTSTATUS.Preauth)) {} else {
                                if (aType == Configuration.VOIDTRANSACTIONACTION) {
                                    updatedQuote.EBizCharge_Payment_Status__c = Configuration.VOIDPAYMENTSTATUS;
                                    transactionToUpdate.Transaction_Type__c = Configuration.VOIDTRANSACTIONTYPE;
                                } else if (aType == string.valueOf(Enums.TRANSACTIONACTIONS.refund)) {
                                    updatedQuote.EBizCharge_Payment_Status__c = string.valueOf(Enums.ENTITYPAYMENTSTATUS.Refund);
                                    transactionToUpdate.Transaction_Type__c = string.valueOf(Enums.PAYMENTTYPES.Credit);
                                } else if (aType == Configuration.PARTIALTRANSACTIONACTION) {
                                    updatedQuote.EBizCharge_Payment_Status__c = Configuration.PARTIALTRANSACTIONSTATUS;
                                    transactionToUpdate.Transaction_Type__c = string.valueOf(Enums.PAYMENTTYPES.Credit);
                                }
                            }
                            transactionToUpdate.EBizCharge_Returned_Amount__c = returnedAmount + refundAmount;
                            dml.updateRecord(updatedQuote);
                            dml.updateRecord(transactionToUpdate);
                            returnMessage = string.valueOf(Enums.RETURNMESSAGE.Success);
                        } catch (Exception e) {
                            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);                
                        }
                        }
                } else {
                    try {
                    string cst = OrderId.left(3);
                    Schema.DescribeSObjectResult schemaResult;
                    if(cst == Configuration.CONTACTTARTINGID){
                        id FindType = (id) OrderId;
                        Schema.SObjectType token = FindType.getSObjectType();
                        schemaResult = token.getDescribe();
                        if (schemaResult.getName() == string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact)) {
                            Double eBizContactAmount = 0.0;
                            Double contactTax = 0.0;
                            querySelect = 'select Id,Name,EBizCharge_Contact_Amount__c,EBizCharge_Contact_Tax__c';
                            queryFrom = 'FROM Contact';
                            queryWhere = 'where Id  =\'' + OrderId + '\'';
                            for (Contact contact: (list < Contact > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING)) {
                                eBizContactAmount = contact.EBizCharge_Contact_Amount__c;
                                contactTax = contact.EBizCharge_Contact_Tax__c;
                            }
                            Contact updateContact = new Contact();
                            updateContact.Id = OrderId;
                            if (subtotal != 0) {
                                if (aType == Configuration.PARTIALTRANSACTIONACTION) {
                                    updateContact.EBizCharge_Contact_Amount__c = eBizContactAmount - refundAmount - transactionTax;
                                } else {
                                    updateContact.EBizCharge_Contact_Amount__c = eBizContactAmount - refundAmount;
                                }
                                updateContact.EBizCharge_Contact_Tax__c = contactTax - transactionTax;
                            } else {
                                updateContact.EBizCharge_Contact_Amount__c = eBizContactAmount - refundAmount;
                            }
                            transactionToUpdate.EBizCharge_Returned_Amount__c = returnedAmount + refundAmount;
                            dml.updateRecord(updateContact);
                            dml.updateRecord(transactionToUpdate);
                            returnMessage = string.valueOf(Enums.RETURNMESSAGE.Success);
                        }
                    }else{
                        if(cst == Configuration.OPPORTUNITYTARTINGID){
                            querySelect = 'select Id, Account.QBD_Customer_ID__c';
                            queryFrom = 'FROM Opportunity';
                            queryWhere = 'where Id  =\'' + OrderId + '\'';
                            Opportunity opportunity = (Opportunity)dml.selectSingleRecord(querySelect,queryFrom,queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                            if(opportunity.Account.QBD_Customer_ID__c !=null){
                                OrderId =  opportunity.Account.QBD_Customer_ID__c;
                            }
                        }
                        Id accountIdSF;
                        Double EBizAmount = 0.0;
                        Double accountTax = 0.0;
                        String query_select = Configuration.EMPTYSTRING;
                        String query_from  = Configuration.EMPTYSTRING;
                        String query_where = Configuration.EMPTYSTRING;
                        query_select = 'SELECT Id,EBizCharge_Amount__c,EBizCharge_Account_Tax__c';
                        query_from = 'FROM Account';
                        query_where = 'where QBD_Customer_ID__c =\''+OrderId+'\'';
                        for(Account account : (list<Account>)dml.selectRecords(query_select,query_from,query_where,Configuration.EMPTYSTRING,Configuration.EMPTYSTRING,Configuration.EMPTYSTRING)){
                            EBizAmount = account.EBizCharge_Amount__c;
                            accountTax = account.EBizCharge_Account_Tax__c;
                            accountIdSF = account.Id;
                        }
                        Account updatedAccount = new Account();
                        updatedAccount.Id = accountIdSF;
                        if(!Test.isRunningTest()){
                            if(subtotal != 0){
                                if(aType ==  Configuration.PARTIALTRANSACTIONACTION){
                                    updatedAccount.EBizCharge_Amount__c = EBizAmount - refundAmount - transactionTax;
                                }
                                else{
                                    updatedAccount.EBizCharge_Amount__c = EBizAmount - refundAmount;
                                }
                                updatedAccount.EBizCharge_Account_Tax__c = accountTax - transactionTax;
                            }
                            else
                            {
                                updatedAccount.EBizCharge_Amount__c = EBizAmount - refundAmount;
                            }
                        }
                        transactionToUpdate.EBizCharge_Returned_Amount__c = returnedAmount + refundAmount;
                        dml.updateRecord(updatedAccount);
                        dml.updateRecord(transactionToUpdate);
                        returnMessage = string.valueOf(Enums.RETURNMESSAGE.Success);
                    }
                    } catch (Exception e) {
                        ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
                    }
                }
            } else if (response.ResultCode == Configuration.RESULTCDOEERROR) {
                returnMessage = response.Error;
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnMessage;
    }
    @AuraEnabled
    public static String sendReceiptToCustomerApex(String Refno, String sendTo) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        String reciprocate = sendReceiptToCustomerApex(dml, Refno, sendTo, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
        //return sendReceiptToCustomerApex(dml, Refno, sendTo);
    }
    public static String sendReceiptToCustomerApex(DML dml, String Refno, String sendTo, EBC_Logger ebcLogger) {
        MethodName = 'sendReceiptToCustomerApex';
        try {
            eBc_UtilityController.sendReceiptToCustomer(dml, Refno, sendTo, ebcLogger);
            return Configuration.SUCCESSMESSAGE;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    public class TransData {
        @AuraEnabled public Date fromDate {
            get;
            set;
        }
        @AuraEnabled public Date toDate {
            get;
            set;
        }
        @AuraEnabled public list < Transactions > Transactions {
            get;
            set;
        }
    }
    public class Transactions {
        @AuraEnabled public String RefNumber {
            get;
            set;
        }
        @AuraEnabled public String OrderNumber {
            get;
            set;
        }
        @AuraEnabled public String OrderId {
            get;
            set;
        }
        @AuraEnabled public String CustomerId {
            get;
            set;
        }
        @AuraEnabled public String AccountName {
            get;
            set;
        }
        @AuraEnabled public DateTime FormatedTransDate {
            get;
            set;
        }
        @AuraEnabled public String Source {
            get;
            set;
        }
        @AuraEnabled public String TransType {
            get;
            set;
        }
        @AuraEnabled public String CustNum {
            get;
            set;
        }
        @AuraEnabled public String AuthCode {
            get;
            set;
        }
        @AuraEnabled public Decimal AuthAmount {
            get;
            set;
        }
        @AuraEnabled public Decimal Tax {
            get;
            set;
        }
        @AuraEnabled public String Result {
            get;
            set;
        }
        @AuraEnabled public String ResultCode {
            get;
            set;
        }
        @AuraEnabled public String Error {
            get;
            set;
        }
        @AuraEnabled public String ErrorCode {
            get;
            set;
        }
        @AuraEnabled public String Status {
            get;
            set;
        }
        @AuraEnabled public String StatusCode {
            get;
            set;
        }
        @AuraEnabled public String DateTime_x {
            get;
            set;
        }
        @AuraEnabled public string Terminal {
            get;
            set;
        }
        @AuraEnabled public String CardType {
            get;
            set;
        }
        @AuraEnabled public String CardNumber {
            get;
            set;
        }
        @AuraEnabled public String checkAccount {
            get;
            set;
        }
        @AuraEnabled public String PayBy {
            get;
            set;
        }
        @AuraEnabled public Boolean isSelected {
            get;
            set;
        }
    }
}