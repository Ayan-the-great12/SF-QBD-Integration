public with sharing class eBc_SyncDownloadController {
    public static string ClassName = 'eBc_SyncDownloadController';
    public static string MethodName = Configuration.EMPTYSTRING;
    // added by @saud against Order - (25March21) - start
    @AuraEnabled
    public static List < OrderWrapper > getDownloadOrdersApxc(String filters, Integer startLimit, Integer endLimit) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < OrderWrapper > reciprocate = getDownloadOrdersApxc(dml, filters, startLimit, endLimit, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < OrderWrapper > getDownloadOrdersApxc(DML dml, String filters, Integer startLimit, Integer endLimit, EBC_Logger ebcLogger) {
        MethodName = 'getDownloadOrdersApxc';
        EBizcharge_Setting__c settings = eBc_UtilityController.getSettings(dml, ebcLogger);
        List < OrderWrapper > returnOrders = new List < OrderWrapper > ();
        List < String > orderInternalIdsUploaded = new List < String > ();
        List < String > orderSFExternalIds = new List < String > ();
        List < String > orderInternalIdsUpdated = new List < String > ();
        Map < String, order > orderSFExternalIdsUpdated = new Map < String, order > ();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
        ebizchargeServicemodelSoap.ArrayOfSearchFilter searchFilterArray = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        List < ebizchargeServicemodelSoap.SearchFilter > searchFiltersUploaded = new List < ebizchargeServicemodelSoap.SearchFilter > ();
        ebizchargeServicemodelSoap.ArrayOfSearchFilter filterArrayUpdated = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        List < ebizchargeServicemodelSoap.SearchFilter > searchFiltersUpdated = new List < ebizchargeServicemodelSoap.SearchFilter > ();
        String fromDate = Configuration.EMPTYSTRING;
        String toDate = Configuration.EMPTYSTRING;
        String fromDateForApi = Configuration.EMPTYSTRING;
        String toDateForApi = Configuration.EMPTYSTRING;
        try {
            DateTime datetimeEntity = system.Today().AddDays(1);
            toDate = datetimeEntity.format(Configuration.DATEFORMAT);
            DateTime datetimeEntityApi = system.Today().AddDays(2);
            toDateForApi = datetimeEntityApi.format(Configuration.DATEFORMAT);
            DateTime ordersLastSyncDate = settings.Ebizcharge_Orders_Last_Sync_Date__c;
            if (ordersLastSyncDate != null) {
                fromDate = string.valueOfGmt(ordersLastSyncDate);
                Date fromDateEntity = Date.valueOf(fromDate);
                fromDateForApi = String.valueOf(fromDateEntity);
                ebcLogger.debug(ClassName, MethodName, '>>>fromDateForApi: ' + fromDateForApi);
            } else {
                Datetime fromDateEntity = System.Today().AddDays(-13);
                fromDate = fromDateEntity.format(Configuration.DATEFORMAT);
                Datetime fromDateEntityApi = System.Today().AddDays(-14);
                fromDateForApi = fromDateEntityApi.format(Configuration.DATEFORMAT);
            }
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateUploaded);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
            filter.FieldValue = fromDateForApi;
            searchFiltersUploaded.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateUpdated);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
            filter.FieldValue = fromDateForApi;
            searchFiltersUpdated.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.Software);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = Configuration.EPICORFIELDVALUE;
            searchFiltersUpdated.add(filter);
            filterArrayUpdated.SearchFilter = searchFiltersUpdated;
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.Software);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = Configuration.EPICORFIELDVALUE;
            searchFiltersUploaded.add(filter);
            searchFilterArray.SearchFilter = searchFiltersUploaded;
            List < ebizchargeServicemodelSoap.CustomSalesOrder > customSalesOrderUploaded = new List < ebizchargeServicemodelSoap.CustomSalesOrder > ();
            ebizchargeServicemodelSoap.ArrayOfSalesOrder ebizResponseUploaded = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
            List < ebizchargeServicemodelSoap.eBizCustomField > eBizCustomFields = new List < ebizchargeServicemodelSoap.eBizCustomField > ();
            ebizchargeServicemodelSoap.ArrayOfEbizCustomField eBizCustomField = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
            List < ebizchargeServicemodelSoap.CustomSalesOrder > customSalesOrderUpdated = new List < ebizchargeServicemodelSoap.CustomSalesOrder > ();
            ebizchargeServicemodelSoap.ArrayOfSalesOrder ebizResponseUpdated = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
            Boolean matchAll = true;
            Boolean countOnly = false;
            String start = Configuration.STARTINDEX;
            String maximum = '50';
            ebizchargeServicemodelSoap.ArrayOfSearchFilter transactionFiltersArray = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
            ebizchargeServicemodelSoap.SearchFilter transactionFilter = new ebizchargeServicemodelSoap.SearchFilter();
            List < ebizchargeServicemodelSoap.SearchFilter > transactionSearchFilters = new List < ebizchargeServicemodelSoap.SearchFilter > ();
            ebizchargeServicemodelSoap.ArrayOfTransactionObject ebizTransaction;
            ebizchargeServicemodelSoap.TransactionSearchResult searchTransactionsResult = new ebizchargeServicemodelSoap.TransactionSearchResult();
            ebizchargeServicemodelSoap.TransactionObject[] ebizTransactions;
            while (true) {
                if (!test.isRunningTest()) {
                    ebizResponseUploaded = ebiz.SearchSalesOrders(securityToken, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, searchFilterArray, startLimit, endLimit, Configuration.EMPTYSTRING, true);
                    ebizResponseUpdated = ebiz.SearchSalesOrders(securityToken, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, filterArrayUpdated, startLimit, endLimit, Configuration.EMPTYSTRING, true);
                    Boolean responseUploaded = true;
                    Boolean responseUpdated = true;
                    if (ebizResponseUploaded == null || ebizResponseUploaded.SalesOrder == null || ebizResponseUploaded.SalesOrder.size() == 0) {
                        responseUploaded = false;
                    }
                    if (ebizResponseUpdated == null || ebizResponseUpdated.SalesOrder == null || ebizResponseUpdated.SalesOrder.size() == 0) {
                        responseUpdated = false;
                    }
                    if (responseUploaded == false && responseUpdated == false) {
                        break;
                    }
                } else {
                    ebizResponseUploaded.SalesOrder = new List < ebizchargeServicemodelSoap.CustomSalesOrder > ();
                    ebizResponseUpdated.SalesOrder = new List < ebizchargeServicemodelSoap.CustomSalesOrder > ();
                    ebizchargeServicemodelSoap.CustomSalesOrder testSalesOrder = new ebizchargeServicemodelSoap.CustomSalesOrder();
                    testSalesOrder.CustomerId = '1';
                    testSalesOrder.DateUpdated = '2021-09-07 09:31:10';
                    testSalesOrder.SalesOrderInternalId = '123';
                    testSalesOrder.SalesOrderCustomFields = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
                    testSalesOrder.SalesOrderCustomFields.eBizCustomField = new list < ebizchargeServicemodelSoap.eBizCustomField > ();
                    ebizchargeServicemodelSoap.eBizCustomField customField = new ebizchargeServicemodelSoap.eBizCustomField();
                    customField.FieldName = 'name';
                    customField.FieldValue = 'Temp';
                    testSalesOrder.SalesOrderCustomFields.eBizCustomField.add(customField);
                    ebizchargeServicemodelSoap.eBizCustomField customField1 = new ebizchargeServicemodelSoap.eBizCustomField();
                    customField1.FieldName = 'email';
                    customField1.FieldValue = 'Temp';
                    ebizResponseUploaded.SalesOrder.add(testSalesOrder);
                    ebizResponseUpdated.SalesOrder.add(testSalesOrder);
                }
                if (ebizResponseUpdated != null) {
                    customSalesOrderUpdated = ebizResponseUpdated.SalesOrder;
                    if (customSalesOrderUpdated != null) {
                        for (ebizchargeServicemodelSoap.CustomSalesOrder customSalesOrder: customSalesOrderUpdated) {
                            orderInternalIdsUpdated.add(customSalesOrder.SalesOrderInternalId);
                            ebcLogger.debug(ClassName, MethodName, '>>>customSalesOrder.SalesOrderInternalId: ' + customSalesOrder.SalesOrderInternalId);
                        }
                        String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c,EBizCharge_Last_Modified_Date__c	';
                        String queryFrom = 'FROM Order';
                        String queryWhere = 'where EBizCharge_Internal_ID__c IN :';
                        List < Order > sfOrders = (List < Order > ) dml.selectRecordsInList(orderInternalIdsUpdated, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                        if (sfOrders != null) {
                            for (Order order: sfOrders) {
                                orderSFExternalIdsUpdated.put(order.EBizCharge_Internal_ID__c, order);
                            }
                        }
                        for (ebizchargeServicemodelSoap.CustomSalesOrder customSalesOrder: customSalesOrderUpdated) {
                            if (orderSFExternalIdsUpdated.containsKey(customSalesOrder.SalesOrderInternalId)) {
                                Order orderEntity = orderSFExternalIdsUpdated.get(customSalesOrder.SalesOrderInternalId);
                                if (orderEntity.EBizCharge_Last_Modified_Date__c < DateTime.valueOf(customSalesOrder.DateUpdated) || orderEntity.EBizCharge_Last_Modified_Date__c == null) {
                                    OrderWrapper orderWrapper = new OrderWrapper();
                                    orderWrapper.accId = customSalesOrder.CustomerId;
                                    String orderDate = String.valueOf(customSalesOrder.DateUploaded);
                                    Datetime orderDateTime = Datetime.valueOf(orderDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                    orderWrapper.CreatedDate = orderDateTime;
                                    if (customSalesOrder.DateUpdated != null) {
                                        String orderModifiedDate = String.valueOf(customSalesOrder.DateUpdated);
                                        Datetime orderDateTimeModified = Datetime.valueOf(orderModifiedDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                        orderWrapper.UpdatedDate = orderDateTimeModified;
                                        ebcLogger.debug(ClassName, MethodName, '>>>orderDateTimeModified: ' + orderDateTimeModified);
                                    } else {
                                        orderWrapper.UpdatedDate = orderWrapper.CreatedDate;
                                    }
                                    if (customSalesOrder.SalesOrderCustomFields != null) {
                                        eBizCustomField = customSalesOrder.SalesOrderCustomFields;
                                        eBizCustomFields = eBizCustomField.eBizCustomField;
                                        if (eBizCustomFields != null) {
                                            for (ebizchargeServicemodelSoap.EbizCustomField ebizcustomfieldEntity: eBizCustomFields) {
                                                if (ebizcustomfieldEntity.FieldName == string.valueOf(Enums.CUSTOMFIELDNAMES.name)) {
                                                    orderWrapper.accName = ebizcustomfieldEntity.FieldValue;
                                                } else if (ebizcustomfieldEntity.FieldName == string.valueOf(Enums.CUSTOMFIELDNAMES.email)) {
                                                    orderWrapper.accEmail = ebizcustomfieldEntity.FieldValue;
                                                }
                                            }
                                        }
                                    }
                                    if (customSalesOrder.Items != null) {
                                        ebizchargeServicemodelSoap.ArrayOfItem ebizItem = customSalesOrder.Items;
                                        List < ebizchargeServicemodelSoap.Item > ebizItems = ebizItem.Item;
                                        if (ebizItems != null) {
                                            orderWrapper.OrditemsList = new List < OrderItem > ();
                                            for (ebizchargeServicemodelSoap.Item itemEntity: ebizItems) {
                                                OrderItem orderItem = new OrderItem();
                                                orderItem.EBizCharge_OrderItem_ID__c = itemEntity.ItemId;
                                                orderItem.EBizCharge_Order_ID__c = customSalesOrder.SalesOrderInternalId;
                                                orderItem.UnitPrice = itemEntity.UnitPrice;
                                                orderItem.Quantity = itemEntity.Qty;
                                                orderItem.Description = itemEntity.Description;
                                                orderItem.EBizCharge_OrderItem_Name__c = itemEntity.Name;
                                                orderWrapper.OrditemsList.add(orderItem);
                                            }
                                        }
                                    }
                                    orderWrapper.OrderNumber = customSalesOrder.SalesOrderNumber;
                                    transactionFilter.FieldValue = customSalesOrder.SalesOrderNumber;
                                    transactionFilter.FieldName = string.valueOf(Enums.IDENTICALFIELDNAMES.OrderID);
                                    transactionFilter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
                                    transactionSearchFilters.add(transactionFilter);
                                    transactionFiltersArray.SearchFilter = transactionSearchFilters;
                                    searchTransactionsResult = ebiz.SearchTransactions(securityToken, transactionFiltersArray, matchAll, countOnly, start, maximum, Configuration.EMPTYSTRING);
                                    if (searchTransactionsResult.Transactions != null) {
                                        ebizTransaction = searchTransactionsResult.Transactions;
                                        if (ebizTransaction.TransactionObject != null) {
                                            ebizTransactions = ebizTransaction.TransactionObject;
                                            if (ebizTransactions != null) {
                                                List < TransactionsWrapper > transactions = new List < TransactionsWrapper > ();
                                                orderWrapper.AmountPaid = 0;
                                                for (ebizchargeServicemodelSoap.TransactionObject ebizTransactionEntity: ebizTransactions) {
                                                    TransactionsWrapper transactionEntity = new TransactionsWrapper();
                                                    transactionEntity.TransType = ebizTransactionEntity.TransactionType;
                                                    ebizchargeServicemodelSoap.TransactionResponse ebizTransactionResponse = ebizTransactionEntity.Response;
                                                    transactionEntity.RefNumber = ebizTransactionResponse.RefNum;
                                                    orderWrapper.AmountPaid += ebizTransactionResponse.AuthAmount;
                                                    ebizchargeServicemodelSoap.CreditCardData creditCard = ebizTransactionEntity.CreditCardData;
                                                    if (creditCard.CardNumber != null) {
                                                        if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.V)) {
                                                            transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.visa);
                                                        } else if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.M)) {
                                                            transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.master);
                                                        } else if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.A)) {
                                                            transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.american);
                                                        } else if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.DS)) {
                                                            transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.discover);
                                                        }
                                                        transactionEntity.PaymentMethod = 'ending in ' + creditCard.CardNumber.right(4);
                                                    }
                                                    ebizchargeServicemodelSoap.CheckData chekData = ebizTransactionEntity.CheckData;
                                                    if (chekData.Account != null) {
                                                        transactionEntity.CardClass = string.valueOf(Enums.IDENTICALPAYMENTMETHODSTRINGS.ach);
                                                        transactionEntity.PaymentMethod = chekData.Account.right(4);
                                                    }
                                                    transactions.add(transactionEntity);
                                                }
                                                orderWrapper.OrderPayments = transactions;
                                            }
                                        }
                                    }
                                    orderWrapper.EBizChargeId = customSalesOrder.SalesOrderInternalId;
                                    orderWrapper.EndDate = date.valueOf(customSalesOrder.DueDate);
                                    orderWrapper.TotalAmount = customSalesOrder.Amount;
                                    orderWrapper.AmountDue = customSalesOrder.AmountDue;
                                    orderWrapper.PoNumber = customSalesOrder.PoNum;
                                    orderWrapper.Portal = customSalesOrder.Software;
                                    orderWrapper.DivisionId = customSalesOrder.DivisionId;
                                    orderWrapper.fromDate = (fromDate == Configuration.EMPTYSTRING ? null : date.valueOf(fromDate));
                                    orderWrapper.toDate = (toDate == Configuration.EMPTYSTRING ? null : date.valueOf(toDate));
                                    returnOrders.add(orderWrapper);
                                }
                            }
                        }
                    }
                }
                if (ebizResponseUploaded != null) {
                    customSalesOrderUploaded = ebizResponseUploaded.SalesOrder;
                    if (customSalesOrderUploaded != null) {
                        Integer count = 0;
                        for (ebizchargeServicemodelSoap.CustomSalesOrder customSalesOrder: customSalesOrderUploaded) {
                            orderInternalIdsUploaded.add(customSalesOrder.SalesOrderInternalId);
                            ebcLogger.debug(ClassName, MethodName, '>>>customSalesOrder.SalesOrderInternalId: ' + customSalesOrder.SalesOrderInternalId);
                            ebcLogger.debug(ClassName, MethodName, '>>>count is: ' + count);
                            count++;
                        }
                        ebcLogger.debug(ClassName, MethodName, '>>>query in list : ' + orderInternalIdsUploaded);
                        String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c';
                        String queryFrom = 'FROM Order';
                        String queryWhere = 'where EBizCharge_Internal_ID__c IN :';
                        List < Order > sfOrders = (List < Order > ) dml.selectRecordsInList(orderInternalIdsUploaded, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                        if (sfOrders != null) {
                            for (Order order: sfOrders) {
                                orderSFExternalIds.add(order.EBizCharge_Internal_ID__c);
                            }
                        }
                        for (ebizchargeServicemodelSoap.CustomSalesOrder customSalesOrder: customSalesOrderUploaded) {
                            if (!orderSFExternalIds.contains(customSalesOrder.SalesOrderInternalId)) {
                                OrderWrapper orderWrapper = new OrderWrapper();
                                orderWrapper.accId = customSalesOrder.CustomerId;
                                String orderDate = String.valueOf(customSalesOrder.DateUploaded);
                                Datetime orderDateTime = Datetime.valueOf(orderDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                orderWrapper.CreatedDate = orderDateTime;
                                if (customSalesOrder.DateUpdated != null) {
                                    String orderModifiedDate = String.valueOf(customSalesOrder.DateUpdated);
                                    Datetime orderDateTimeModified = Datetime.valueOf(orderModifiedDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                    orderWrapper.UpdatedDate = orderDateTimeModified;
                                    ebcLogger.debug(ClassName, MethodName, '>>>orderDateTimeModified: ' + orderDateTimeModified);
                                } else {
                                    orderWrapper.UpdatedDate = orderWrapper.CreatedDate;
                                }
                                ebcLogger.debug(ClassName, MethodName, '>>>orderDateTime: ' + orderDateTime);
                                if (customSalesOrder.SalesOrderCustomFields != null) {
                                    eBizCustomField = customSalesOrder.SalesOrderCustomFields;
                                    eBizCustomFields = eBizCustomField.EbizCustomField;
                                    if (eBizCustomFields != null) {
                                        for (ebizchargeServicemodelSoap.EbizCustomField ebizcustomfieldEntity: eBizCustomFields) {
                                            if (ebizcustomfieldEntity.FieldName == string.valueOf(Enums.CUSTOMFIELDNAMES.name)) {
                                                orderWrapper.accName = ebizcustomfieldEntity.FieldValue;
                                            } else if (ebizcustomfieldEntity.FieldName == string.valueOf(Enums.CUSTOMFIELDNAMES.email)) {
                                                orderWrapper.accEmail = ebizcustomfieldEntity.FieldValue;
                                            }
                                        }
                                    }
                                }
                                if (customSalesOrder.Items != null) {
                                    ebizchargeServicemodelSoap.ArrayOfItem ebizItem = customSalesOrder.Items;
                                    List < ebizchargeServicemodelSoap.Item > ebizItems = ebizItem.Item;
                                    if (ebizItems != null) {
                                        orderWrapper.OrditemsList = new List < OrderItem > ();
                                        for (ebizchargeServicemodelSoap.Item itemEntity: ebizItems) {
                                            OrderItem orderItem = new OrderItem();
                                            orderItem.EBizCharge_OrderItem_ID__c = itemEntity.ItemId;
                                            orderItem.EBizCharge_Order_ID__c = customSalesOrder.SalesOrderInternalId;
                                            orderItem.UnitPrice = itemEntity.UnitPrice;
                                            orderItem.Quantity = itemEntity.Qty;
                                            orderItem.Description = itemEntity.Description;
                                            orderItem.EBizCharge_OrderItem_Name__c = itemEntity.Name;
                                            orderWrapper.OrditemsList.add(orderItem);
                                        }
                                    }
                                }
                                orderWrapper.OrderNumber = customSalesOrder.SalesOrderNumber;
                                transactionFilter.FieldValue = customSalesOrder.SalesOrderNumber;
                                transactionFilter.FieldName = string.valueOf(Enums.IDENTICALFIELDNAMES.OrderID);
                                transactionFilter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
                                transactionSearchFilters.add(transactionFilter);
                                transactionFiltersArray.SearchFilter = transactionSearchFilters;
                                searchTransactionsResult = ebiz.SearchTransactions(securityToken, transactionFiltersArray, matchAll, countOnly, start, maximum, Configuration.EMPTYSTRING);
                                if (searchTransactionsResult.Transactions != null) {
                                    ebizTransaction = searchTransactionsResult.Transactions;
                                    if (ebizTransaction.TransactionObject != null) {
                                        ebizTransactions = ebizTransaction.TransactionObject;
                                        if (ebizTransactions != null) {
                                            List < TransactionsWrapper > transactions = new List < TransactionsWrapper > ();
                                            orderWrapper.AmountPaid = 0;
                                            for (ebizchargeServicemodelSoap.TransactionObject ebizTransactionEntity: ebizTransactions) {
                                                TransactionsWrapper transactionEntity = new TransactionsWrapper();
                                                transactionEntity.TransType = ebizTransactionEntity.TransactionType;
                                                ebizchargeServicemodelSoap.TransactionResponse ebizTransactionResponse = ebizTransactionEntity.Response;
                                                transactionEntity.RefNumber = ebizTransactionResponse.RefNum;
                                                orderWrapper.AmountPaid += ebizTransactionResponse.AuthAmount;
                                                ebizchargeServicemodelSoap.CreditCardData creditCard = ebizTransactionEntity.CreditCardData;
                                                if (creditCard.CardNumber != null) {
                                                    if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.V)) {
                                                        transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.visa);
                                                    } else if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.M)) {
                                                        transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.master);
                                                    } else if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.A)) {
                                                        transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.american);
                                                    } else if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.DS)) {
                                                        transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.discover);
                                                    }
                                                    transactionEntity.PaymentMethod = 'ending in ' + creditCard.CardNumber.right(4);
                                                }
                                                ebizchargeServicemodelSoap.CheckData chekData = ebizTransactionEntity.CheckData;
                                                if (chekData.Account != null) {
                                                    transactionEntity.CardClass = string.valueOf(Enums.IDENTICALPAYMENTMETHODSTRINGS.ach);
                                                    transactionEntity.PaymentMethod = chekData.Account.right(4);
                                                }
                                                transactions.add(transactionEntity);
                                            }
                                            orderWrapper.OrderPayments = transactions;
                                        }
                                    }
                                }
                                orderWrapper.EBizChargeId = customSalesOrder.SalesOrderInternalId;
                                orderWrapper.EndDate = date.valueOf(customSalesOrder.DueDate);
                                orderWrapper.TotalAmount = customSalesOrder.Amount;
                                orderWrapper.AmountDue = customSalesOrder.AmountDue;
                                orderWrapper.PoNumber = customSalesOrder.PoNum;
                                orderWrapper.Portal = customSalesOrder.Software;
                                orderWrapper.DivisionId = customSalesOrder.DivisionId;
                                orderWrapper.fromDate = (fromDate == Configuration.EMPTYSTRING ? null : date.valueOf(fromDate));
                                orderWrapper.toDate = (toDate == Configuration.EMPTYSTRING ? null : date.valueOf(toDate));
                                returnOrders.add(orderWrapper);
                            }
                        }
                    }
                }
                startLimit = startLimit + 1000;
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnOrders;
    }
    @AuraEnabled
    public static List < OrderWrapper > getOrdersApxc(String filters, Integer startLimit, Integer endLimit) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < OrderWrapper > reciprocate = getOrdersApxc(dml, filters, startLimit, endLimit, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < OrderWrapper > getOrdersApxc(DML dml, String filters, Integer startLimit, Integer endLimit, EBC_Logger ebcLogger) {
        MethodName = 'getOrdersApxc';
        List < OrderWrapper > returnOrders = new List < OrderWrapper > ();
        List < String > orderInternalIdsUploaded = new List < String > ();
        List < String > orderSFExternalIds = new List < String > ();
        List < String > orderInternalIdsUpdated = new List < String > ();
        Map < String, order > orderSFExternalIdsUpdated = new Map < String, order > ();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
        ebizchargeServicemodelSoap.ArrayOfSearchFilter searchFilterArray = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        List < ebizchargeServicemodelSoap.SearchFilter > searchFiltersUploaded = new List < ebizchargeServicemodelSoap.SearchFilter > ();
        ebizchargeServicemodelSoap.ArrayOfSearchFilter filterArrayUpdated = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        List < ebizchargeServicemodelSoap.SearchFilter > searchFiltersUpdated = new List < ebizchargeServicemodelSoap.SearchFilter > ();
        String fromDate = Configuration.EMPTYSTRING;
        String toDate = Configuration.EMPTYSTRING;
        String fromDateForApi = Configuration.EMPTYSTRING;
        String toDateForApi = Configuration.EMPTYSTRING;
        try {
            if (!test.isRunningTest()) {
                Map < String, Object > filterMap = (Map < String, Object > ) JSON.deserializeUntyped(filters);
                fromDate = (String) filterMap.get(string.valueOf(Enums.FILTERJAVASCRIPTMAPSTRINGS.fromDate));
                if (fromDate != null) {
                    Date fromDateEntity = Date.valueOf(fromDate);
                    fromDateEntity = fromDateEntity.AddDays(-1);
                    fromDateForApi = String.valueOf(fromDateEntity);
                }
                toDate = (String) filterMap.get(string.valueOf(Enums.FILTERJAVASCRIPTMAPSTRINGS.toDate));
                if (toDate != null) {
                    Date toDateEntity = Date.valueOf(toDate);
                    toDateEntity = toDateEntity.AddDays(1);
                    toDateForApi = String.valueOf(toDateEntity);
                }
            }
            if (test.isRunningTest()) {
                fromDate = null;
            }
            if (fromDate == null) {
                Datetime fromDateEntity = System.Today().AddDays(-13);
                fromDate = fromDateEntity.format(Configuration.DATEFORMAT);
                Datetime fromDateEntityApi = System.Today().AddDays(-14);
                fromDateForApi = fromDateEntityApi.format(Configuration.DATEFORMAT);
            }
            if (test.isRunningTest()) {
                toDate = null;
            }
            if (toDate == null) {
                DateTime datetimeEntity = system.Today().AddDays(1);
                toDate = datetimeEntity.format(Configuration.DATEFORMAT);
                DateTime datetimeEntityApi = system.Today().AddDays(2);
                toDateForApi = datetimeEntityApi.format(Configuration.DATEFORMAT);
            }
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateUploaded);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
            filter.FieldValue = fromDateForApi;
            searchFiltersUploaded.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateUploaded);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.lt);
            filter.FieldValue = toDateForApi;
            searchFiltersUploaded.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateUpdated);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
            filter.FieldValue = fromDateForApi;
            searchFiltersUpdated.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateUpdated);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.lt);
            filter.FieldValue = toDateForApi;
            searchFiltersUpdated.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.Software);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = Configuration.EPICORFIELDVALUE;
            searchFiltersUploaded.add(filter);
            searchFiltersUpdated.add(filter);
            searchFilterArray.SearchFilter = searchFiltersUploaded;
            filterArrayUpdated.SearchFilter = searchFiltersUpdated;
            List < ebizchargeServicemodelSoap.CustomSalesOrder > customSalesOrderUploaded = new List < ebizchargeServicemodelSoap.CustomSalesOrder > ();
            ebizchargeServicemodelSoap.ArrayOfSalesOrder ebizResponseUploaded = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
            List < ebizchargeServicemodelSoap.EbizCustomField > eBizCustomFields = new List < ebizchargeServicemodelSoap.EbizCustomField > ();
            ebizchargeServicemodelSoap.ArrayOfEbizCustomField eBizCustomField = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
            List < ebizchargeServicemodelSoap.CustomSalesOrder > customSalesOrderUpdated = new List < ebizchargeServicemodelSoap.CustomSalesOrder > ();
            ebizchargeServicemodelSoap.ArrayOfSalesOrder ebizResponseUpdated = new ebizchargeServicemodelSoap.ArrayOfSalesOrder();
            Boolean matchAll = true;
            Boolean countOnly = false;
            String start = Configuration.STARTINDEX;
            String maximum = '50';
            ebizchargeServicemodelSoap.ArrayOfSearchFilter transactionFiltersArray = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
            ebizchargeServicemodelSoap.SearchFilter transactionFilter = new ebizchargeServicemodelSoap.SearchFilter();
            List < ebizchargeServicemodelSoap.SearchFilter > transactionSearchFilters = new List < ebizchargeServicemodelSoap.SearchFilter > ();
            ebizchargeServicemodelSoap.ArrayOfTransactionObject ebizTransaction;
            ebizchargeServicemodelSoap.TransactionSearchResult searchTransactionsResult = new ebizchargeServicemodelSoap.TransactionSearchResult();
            ebizchargeServicemodelSoap.TransactionObject[] ebizTransactions;
            if (!test.isRunningTest()) {
                ebizResponseUploaded = ebiz.SearchSalesOrders(securityToken, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, searchFilterArray, startLimit, endLimit, Configuration.EMPTYSTRING, true);
                ebizResponseUpdated = ebiz.SearchSalesOrders(securityToken, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, filterArrayUpdated, startLimit, endLimit, Configuration.EMPTYSTRING, true);
            } else {
                ebizResponseUploaded.SalesOrder = new List < ebizchargeServicemodelSoap.CustomSalesOrder > ();
                ebizResponseUpdated.SalesOrder = new List < ebizchargeServicemodelSoap.CustomSalesOrder > ();
                ebizchargeServicemodelSoap.CustomSalesOrder testSalesOrder = new ebizchargeServicemodelSoap.CustomSalesOrder();
                testSalesOrder.CustomerId = '1';
                testSalesOrder.SalesOrderInternalId = '123';
                testSalesOrder.DateUpdated = '20/04/2022';
                testSalesOrder.SalesOrderCustomFields = new ebizchargeServicemodelSoap.ArrayOfEbizCustomField();
                testSalesOrder.SalesOrderCustomFields.EbizCustomField = new list < ebizchargeServicemodelSoap.EbizCustomField > ();
                ebizchargeServicemodelSoap.EbizCustomField customField = new ebizchargeServicemodelSoap.EbizCustomField();
                customField.FieldName = 'name';
                customField.FieldValue = 'Temp';
                testSalesOrder.SalesOrderCustomFields.EbizCustomField.add(customField);
                ebizchargeServicemodelSoap.EbizCustomField customField1 = new ebizchargeServicemodelSoap.EbizCustomField();
                customField1.FieldName = 'email';
                customField1.FieldValue = 'Temp';
                ebizResponseUpdated.SalesOrder.add(testSalesOrder);
                ebizResponseUploaded.SalesOrder.add(testSalesOrder);
            }
            if (ebizResponseUpdated != null) {
                customSalesOrderUpdated = ebizResponseUpdated.SalesOrder;
                if (customSalesOrderUpdated != null) {
                    for (ebizchargeServicemodelSoap.CustomSalesOrder customSalesOrder: customSalesOrderUpdated) {
                        orderInternalIdsUpdated.add(customSalesOrder.SalesOrderInternalId);
                        ebcLogger.debug(ClassName, MethodName, '>>>customSalesOrder.SalesOrderInternalId: ' + customSalesOrder.SalesOrderInternalId);
                    }
                    String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c,EBizCharge_Last_Modified_Date__c	';
                    String queryFrom = 'FROM Order';
                    String queryWhere = 'where EBizCharge_Internal_ID__c IN :';
                    List < Order > sfOrders = (List < Order > ) dml.selectRecordsInList(orderInternalIdsUpdated, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                    if (sfOrders != null) {
                        for (Order order: sfOrders) {
                            orderSFExternalIdsUpdated.put(order.EBizCharge_Internal_ID__c, order);
                        }
                    }
                    for (ebizchargeServicemodelSoap.CustomSalesOrder customSalesOrder: customSalesOrderUpdated) {
                        if (orderSFExternalIdsUpdated.containsKey(customSalesOrder.SalesOrderInternalId)) {
                            Order orderEntity = orderSFExternalIdsUpdated.get(customSalesOrder.SalesOrderInternalId);
                            if (orderEntity.EBizCharge_Last_Modified_Date__c < DateTime.valueOf(customSalesOrder.DateUpdated) || orderEntity.EBizCharge_Last_Modified_Date__c == null) {
                                OrderWrapper orderWrapper = new OrderWrapper();
                                orderWrapper.accId = customSalesOrder.CustomerId;
                                String orderDate = String.valueOf(customSalesOrder.DateUploaded);
                                Datetime orerdDateTime = Datetime.valueOf(orderDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                orderWrapper.CreatedDate = orerdDateTime;
                                if (customSalesOrder.DateUpdated != null) {
                                    String orderModifiedDate = String.valueOf(customSalesOrder.DateUpdated);
                                    Datetime orderDateTimeModified = Datetime.valueOf(orderModifiedDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                    orderWrapper.UpdatedDate = orderDateTimeModified;
                                    ebcLogger.debug(ClassName, MethodName, '>>>Updated date: ' + orderDateTimeModified);
                                } else {
                                    orderWrapper.UpdatedDate = orderWrapper.CreatedDate;
                                }
                                ebcLogger.debug(ClassName, MethodName, '>>>created date: ' + orerdDateTime);
                                if (customSalesOrder.SalesOrderCustomFields != null) {
                                    eBizCustomField = customSalesOrder.SalesOrderCustomFields;
                                    eBizCustomFields = eBizCustomField.EbizCustomField;
                                    if (eBizCustomFields != null) {
                                        for (ebizchargeServicemodelSoap.EbizCustomField ebizcustomfieldEntity: eBizCustomFields) {
                                            if (ebizcustomfieldEntity.FieldName == string.valueOf(Enums.CUSTOMFIELDNAMES.name)) {
                                                orderWrapper.accName = ebizcustomfieldEntity.FieldValue;
                                            } else if (ebizcustomfieldEntity.FieldName == string.valueOf(Enums.CUSTOMFIELDNAMES.email)) {
                                                orderWrapper.accEmail = ebizcustomfieldEntity.FieldValue;
                                            }
                                        }
                                    }
                                }
                                if (customSalesOrder.Items != null) {
                                    ebizchargeServicemodelSoap.ArrayOfItem ebizItem = customSalesOrder.Items;
                                    List < ebizchargeServicemodelSoap.Item > ebizItems = ebizItem.Item;
                                    if (ebizItems != null) {
                                        orderWrapper.OrditemsList = new List < OrderItem > ();
                                        for (ebizchargeServicemodelSoap.Item itemEntity: ebizItems) {
                                            OrderItem orderItem = new OrderItem();
                                            orderItem.EBizCharge_OrderItem_ID__c = itemEntity.ItemId;
                                            orderItem.EBizCharge_Order_ID__c = customSalesOrder.SalesOrderInternalId;
                                            orderItem.UnitPrice = itemEntity.UnitPrice;
                                            orderItem.Quantity = itemEntity.Qty;
                                            orderItem.Description = itemEntity.Description;
                                            orderItem.EBizCharge_OrderItem_Name__c = itemEntity.Name;
                                            orderWrapper.OrditemsList.add(orderItem);
                                        }
                                    }
                                }
                                orderWrapper.OrderNumber = customSalesOrder.SalesOrderNumber;
                                transactionFilter.FieldValue = customSalesOrder.SalesOrderNumber;
                                transactionFilter.FieldName = string.valueOf(Enums.IDENTICALFIELDNAMES.OrderID);
                                transactionFilter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
                                transactionSearchFilters.add(transactionFilter);
                                transactionFiltersArray.SearchFilter = transactionSearchFilters;
                                searchTransactionsResult = ebiz.SearchTransactions(securityToken, transactionFiltersArray, matchAll, countOnly, start, maximum, Configuration.EMPTYSTRING);
                                if (searchTransactionsResult.Transactions != null) {
                                    ebizTransaction = searchTransactionsResult.Transactions;
                                    if (ebizTransaction.TransactionObject != null) {
                                        ebizTransactions = ebizTransaction.TransactionObject;
                                        if (ebizTransactions != null) {
                                            List < TransactionsWrapper > transactions = new List < TransactionsWrapper > ();
                                            orderWrapper.AmountPaid = 0;
                                            for (ebizchargeServicemodelSoap.TransactionObject ebizTransactionEntity: ebizTransactions) {
                                                TransactionsWrapper transactionEntity = new TransactionsWrapper();
                                                transactionEntity.TransType = ebizTransactionEntity.TransactionType;
                                                ebizchargeServicemodelSoap.TransactionResponse ebizTransactionResponse = ebizTransactionEntity.Response;
                                                transactionEntity.RefNumber = ebizTransactionResponse.RefNum;
                                                orderWrapper.AmountPaid += ebizTransactionResponse.AuthAmount;
                                                ebizchargeServicemodelSoap.CreditCardData creditCard = ebizTransactionEntity.CreditCardData;
                                                if (creditCard.CardNumber != null) {
                                                    if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.V)) {
                                                        transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.visa);
                                                    } else if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.M)) {
                                                        transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.master);
                                                    } else if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.A)) {
                                                        transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.american);
                                                    } else if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.DS)) {
                                                        transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.discover);
                                                    }
                                                    transactionEntity.PaymentMethod = 'ending in ' + creditCard.CardNumber.right(4);
                                                }
                                                ebizchargeServicemodelSoap.CheckData chekData = ebizTransactionEntity.CheckData;
                                                if (chekData.Account != null) {
                                                    transactionEntity.CardClass = string.valueOf(Enums.IDENTICALPAYMENTMETHODSTRINGS.ach);
                                                    transactionEntity.PaymentMethod = chekData.Account.right(4);
                                                }
                                                transactions.add(transactionEntity);
                                            }
                                            orderWrapper.OrderPayments = transactions;
                                        }
                                    }
                                }
                                orderWrapper.EBizChargeId = customSalesOrder.SalesOrderInternalId;
                                orderWrapper.EndDate = date.valueOf(customSalesOrder.DueDate);
                                orderWrapper.TotalAmount = customSalesOrder.Amount;
                                orderWrapper.AmountDue = customSalesOrder.AmountDue;
                                orderWrapper.PoNumber = customSalesOrder.PoNum;
                                orderWrapper.Portal = customSalesOrder.Software;
                                orderWrapper.DivisionId = customSalesOrder.DivisionId;
                                orderWrapper.fromDate = (fromDate == Configuration.EMPTYSTRING ? null : date.valueOf(fromDate));
                                orderWrapper.toDate = (toDate == Configuration.EMPTYSTRING ? null : date.valueOf(toDate));
                                returnOrders.add(orderWrapper);
                            }
                        }
                    }
                }
            }
            if (ebizResponseUploaded != null) {
                customSalesOrderUploaded = ebizResponseUploaded.SalesOrder;
                if (customSalesOrderUploaded != null) {
                    Integer count = 0;
                    for (ebizchargeServicemodelSoap.CustomSalesOrder customSalesOrder: customSalesOrderUploaded) {
                        orderInternalIdsUploaded.add(customSalesOrder.SalesOrderInternalId);
                        ebcLogger.debug(ClassName, MethodName, '>>>customSalesOrder.SalesOrderInternalId: ' + customSalesOrder.SalesOrderInternalId);
                        count++;
                    }
                    ebcLogger.debug(ClassName, MethodName, '>>>>orderInternalIdsUploaded: ' + orderInternalIdsUploaded);
                    String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c';
                    String queryFrom = 'FROM Order';
                    String queryWhere = 'where EBizCharge_Internal_ID__c IN :';
                    List < Order > sfOrders = (List < Order > ) dml.selectRecordsInList(orderInternalIdsUploaded, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                    if (sfOrders != null) {
                        for (Order order: sfOrders) {
                            orderSFExternalIds.add(order.EBizCharge_Internal_ID__c);
                        }
                    }
                    for (ebizchargeServicemodelSoap.CustomSalesOrder customSalesOrder: customSalesOrderUploaded) {
                        if (!orderSFExternalIds.contains(customSalesOrder.SalesOrderInternalId)) {
                            OrderWrapper orderWrapper = new OrderWrapper();
                            orderWrapper.accId = customSalesOrder.CustomerId;
                            String orderDate = String.valueOf(customSalesOrder.DateUploaded);
                            Datetime orderDateTime = Datetime.valueOf(orderDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                            orderWrapper.CreatedDate = orderDateTime;
                            if (customSalesOrder.DateUpdated != null) {
                                String orderModifiedDate = String.valueOf(customSalesOrder.DateUpdated);
                                Datetime orderDateTimeModified = Datetime.valueOf(orderModifiedDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                orderWrapper.UpdatedDate = orderDateTimeModified;
                                ebcLogger.debug(ClassName, MethodName, '>>>Updated date: ' + orderDateTimeModified);
                            } else {
                                orderWrapper.UpdatedDate = orderWrapper.CreatedDate;
                            }
                            ebcLogger.debug(ClassName, MethodName, '>>>orderDateTime: ' + orderDateTime);
                            if (customSalesOrder.SalesOrderCustomFields != null) {
                                eBizCustomField = customSalesOrder.SalesOrderCustomFields;
                                eBizCustomFields = eBizCustomField.eBizCustomField;
                                if (eBizCustomFields != null) {
                                    for (ebizchargeServicemodelSoap.eBizCustomField ebizcustomfieldEntity: eBizCustomFields) {
                                        if (ebizcustomfieldEntity.FieldName == string.valueOf(Enums.CUSTOMFIELDNAMES.name)) {
                                            orderWrapper.accName = ebizcustomfieldEntity.FieldValue;
                                        } else if (ebizcustomfieldEntity.FieldName == string.valueOf(Enums.CUSTOMFIELDNAMES.email)) {
                                            orderWrapper.accEmail = ebizcustomfieldEntity.FieldValue;
                                        }
                                    }
                                }
                            }
                            if (customSalesOrder.Items != null) {
                                ebizchargeServicemodelSoap.ArrayOfItem ebizItem = customSalesOrder.Items;
                                List < ebizchargeServicemodelSoap.Item > ebizItems = ebizItem.Item;
                                if (ebizItems != null) {
                                    orderWrapper.OrditemsList = new List < OrderItem > ();
                                    for (ebizchargeServicemodelSoap.Item itemEntity: ebizItems) {
                                        OrderItem orderItem = new OrderItem();
                                        orderItem.EBizCharge_OrderItem_ID__c = itemEntity.ItemId;
                                        orderItem.EBizCharge_Order_ID__c = customSalesOrder.SalesOrderInternalId;
                                        orderItem.UnitPrice = itemEntity.UnitPrice;
                                        orderItem.Quantity = itemEntity.Qty;
                                        orderItem.Description = itemEntity.Description;
                                        orderItem.EBizCharge_OrderItem_Name__c = itemEntity.Name;
                                        orderWrapper.OrditemsList.add(orderItem);
                                    }
                                }
                            }
                            orderWrapper.OrderNumber = customSalesOrder.SalesOrderNumber;
                            transactionFilter.FieldValue = customSalesOrder.SalesOrderNumber;
                            transactionFilter.FieldName = string.valueOf(Enums.IDENTICALFIELDNAMES.OrderID);
                            transactionFilter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
                            transactionSearchFilters.add(transactionFilter);
                            transactionFiltersArray.SearchFilter = transactionSearchFilters;
                            searchTransactionsResult = ebiz.SearchTransactions(securityToken, transactionFiltersArray, matchAll, countOnly, start, maximum, Configuration.EMPTYSTRING);
                            if (searchTransactionsResult.Transactions != null) {
                                ebizTransaction = searchTransactionsResult.Transactions;
                                if (ebizTransaction.TransactionObject != null) {
                                    ebizTransactions = ebizTransaction.TransactionObject;
                                    if (ebizTransactions != null) {
                                        List < TransactionsWrapper > transactions = new List < TransactionsWrapper > ();
                                        orderWrapper.AmountPaid = 0;
                                        for (ebizchargeServicemodelSoap.TransactionObject ebizTransactionEntity: ebizTransactions) {
                                            TransactionsWrapper transactionEntity = new TransactionsWrapper();
                                            transactionEntity.TransType = ebizTransactionEntity.TransactionType;
                                            ebizchargeServicemodelSoap.TransactionResponse ebizTransactionResponse = ebizTransactionEntity.Response;
                                            transactionEntity.RefNumber = ebizTransactionResponse.RefNum;
                                            orderWrapper.AmountPaid += ebizTransactionResponse.AuthAmount;
                                            ebizchargeServicemodelSoap.CreditCardData creditCard = ebizTransactionEntity.CreditCardData;
                                            if (creditCard.CardNumber != null) {
                                                if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.V)) {
                                                    transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.visa);
                                                } else if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.M)) {
                                                    transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.master);
                                                } else if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.A)) {
                                                    transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.american);
                                                } else if (creditCard.CardType == string.valueOf(Enums.CARDCOMPARISONSTRINGS.DS)) {
                                                    transactionEntity.CardClass = string.valueOf(Enums.IDENTICALCARDTYPES.discover);
                                                }
                                                transactionEntity.PaymentMethod = 'ending in ' + creditCard.CardNumber.right(4);
                                            }
                                            ebizchargeServicemodelSoap.CheckData chekData = ebizTransactionEntity.CheckData;
                                            if (chekData.Account != null) {
                                                transactionEntity.CardClass = string.valueOf(Enums.IDENTICALPAYMENTMETHODSTRINGS.ach);
                                                transactionEntity.PaymentMethod = chekData.Account.right(4);
                                            }
                                            transactions.add(transactionEntity);
                                        }
                                        orderWrapper.OrderPayments = transactions;
                                    }
                                }
                            }
                            orderWrapper.EBizChargeId = customSalesOrder.SalesOrderInternalId;
                            orderWrapper.EndDate = date.valueOf(customSalesOrder.DueDate);
                            orderWrapper.TotalAmount = customSalesOrder.Amount;
                            orderWrapper.AmountDue = customSalesOrder.AmountDue;
                            orderWrapper.PoNumber = customSalesOrder.PoNum;
                            orderWrapper.Portal = customSalesOrder.Software;
                            orderWrapper.DivisionId = customSalesOrder.DivisionId;
                            orderWrapper.fromDate = (fromDate == Configuration.EMPTYSTRING ? null : date.valueOf(fromDate));
                            orderWrapper.toDate = (toDate == Configuration.EMPTYSTRING ? null : date.valueOf(toDate));
                            returnOrders.add(orderWrapper);
                        }
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnOrders;
    }
    @AuraEnabled
    public static List < OrderWrapper > getUpdatedOrdersApxc(List < OrderWrapper > ordList) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < OrderWrapper > reciprocate = getUpdatedOrdersApxc(dml, ordList, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < OrderWrapper > getUpdatedOrdersApxc(DML dml, List < OrderWrapper > ordList, EBC_Logger ebcLogger) {
        MethodName = 'getUpdatedOrdersApxc';
        List < OrderWrapper > returnUpdatedOrders = new List < OrderWrapper > ();
        List < String > importOrderIds = new List < String > ();
        List < String > ordSFInternalIds = new List < String > ();
        try {
            for (OrderWrapper order: ordList) {
                importOrderIds.add(order.EBizChargeId);
            }
            String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c';
            String queryFrom = 'FROM Order';
            String queryWhere = 'where EBizCharge_Internal_ID__c IN :';
            List < Order > sfOrders = (List < Order > ) dml.selectRecordsInList(importOrderIds, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            if (sfOrders != null) {
                for (Order order: sfOrders) {
                    ordSFInternalIds.add(order.EBizCharge_Internal_ID__c);
                }
            }
            for (OrderWrapper order: ordList) {
                if (!ordSFInternalIds.contains(order.EBizChargeId)) {
                    returnUpdatedOrders.add(order);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnUpdatedOrders;
    }
    @AuraEnabled
    public static Integer getAccountsCountApxc() {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        Integer reciprocate = getAccountsCountApxc(dml, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static Integer getAccountsCountApxc(DML dml, EBC_Logger ebcLogger) {
        MethodName = 'getAccountsCountApxc';
        Integer count = 0;
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
        ebizchargeServicemodelSoap.ArrayOfSearchFilter searchFilterArray = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        List < ebizchargeServicemodelSoap.SearchFilter > searchFilters = new List < ebizchargeServicemodelSoap.SearchFilter > ();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.SoftwareID);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.ne);
        filter.FieldValue = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
        searchFilters.add(filter);
        searchFilterArray.SearchFilter = searchFilters;
        List < ebizchargeServicemodelSoap.Customer > ebizCustomers = new List < ebizchargeServicemodelSoap.Customer > ();
        ebizchargeServicemodelSoap.ArrayOfCustomer ebizResponse = new ebizchargeServicemodelSoap.ArrayOfCustomer();
        ebizchargeServicemodelSoap.CustomerListSearchResult customerResultResponse = new ebizchargeServicemodelSoap.CustomerListSearchResult();
        try {
            if (!test.isRunningTest()) {
                customerResultResponse = ebiz.SearchCustomerList(securityToken, searchFilterArray, 0, 10, Configuration.EMPTYSTRING, false, false, true);
            }
            if (customerResultResponse != null) {
                count = customerResultResponse.Count;
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return count;
    }
    @AuraEnabled
    public static AccountsData getAccountsApxc(String filters, Integer startLimit, Integer endLimit) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        AccountsData reciprocate = getAccountsApxc(dml, filters, startLimit, endLimit, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static AccountsData getAccountsApxc(DML dml, String filters, Integer startLimit, Integer endLimit, EBC_Logger ebcLogger) {
        MethodName = 'getAccountsApxc';
        EBizcharge_Setting__c settings = eBc_UtilityController.getSettings(dml, ebcLogger);
        string divisionId = settings.Division_ID__c;
        divisionId = divisionId != null ? divisionId : Configuration.EMPTYSTRING;
        List < AccountWrapper > accounts = new List < AccountWrapper > ();
        List < String > accountsGWInternalIdsCreated = new List < String > ();
        Map < String, Account > accountsGWExternalIdsCreated = new Map < String, Account > ();
        List < String > accountsGWInternalIdsModified = new List < String > ();
        Map < String, Account > accountsGWExternalIdsModified = new Map < String, Account > ();
        AccountsData returnAccounts = new AccountsData();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        try {
            ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
            ebizchargeServicemodelSoap.ArrayOfSearchFilter searchFilterArrayCreated = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
            ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
            List < ebizchargeServicemodelSoap.SearchFilter > searchFiltersCreated = new List < ebizchargeServicemodelSoap.SearchFilter > ();
            ebizchargeServicemodelSoap.ArrayOfSearchFilter searchFilterArrayModified = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
            List < ebizchargeServicemodelSoap.SearchFilter > searchFiltersModified = new List < ebizchargeServicemodelSoap.SearchFilter > ();
            String fromDate = Configuration.EMPTYSTRING;
            String toDate = Configuration.EMPTYSTRING;
            String fromDateForApi = Configuration.EMPTYSTRING;
            String toDateForApi = Configuration.EMPTYSTRING;
            if (!test.isRunningTest()) {
                Map < String, Object > filterMap = (Map < String, Object > ) JSON.deserializeUntyped(filters);
                fromDate = (String) filterMap.get(string.valueOf(Enums.FILTERJAVASCRIPTMAPSTRINGS.fromDate));
                if (fromDate != null) {
                    Date fromDateEntity = Date.valueOf(fromDate);
                    fromDateEntity = fromDateEntity.AddDays(-1);
                    fromDateForApi = String.valueOf(fromDateEntity);
                }
                toDate = (String) filterMap.get(string.valueOf(Enums.FILTERJAVASCRIPTMAPSTRINGS.toDate));
                if (toDate != null) {
                    Date toDateEntity = Date.valueOf(toDate);
                    toDateEntity = toDateEntity.AddDays(1);
                    toDateForApi = String.valueOf(toDateEntity);
                }
            }
            if (test.isRunningTest()) {
                fromDate = null;
            }
            if (fromDate == null) {
                Datetime fromDateEntity = System.Today().AddDays(-13);
                fromDate = fromDateEntity.format(Configuration.DATEFORMAT);
                Datetime fromDateEntityApi = System.Today().AddDays(-14);
                fromDateForApi = fromDateEntityApi.format(Configuration.DATEFORMAT);
            }
            if (test.isRunningTest()) {
                toDate = null;
            }
            if (toDate == null) {
                DateTime datetimeEntity = system.Today().AddDays(1);
                toDate = datetimeEntity.format(Configuration.DATEFORMAT);
                DateTime datetimeEntityApi = system.Today().AddDays(2);
                toDateForApi = datetimeEntityApi.format(Configuration.DATEFORMAT);
            }
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateTimeCreated);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
            filter.FieldValue = fromDateForApi;
            searchFiltersCreated.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateTimeCreated);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.lt);
            filter.FieldValue = toDateForApi;
            searchFiltersCreated.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateTimeModified);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
            filter.FieldValue = fromDateForApi;
            searchFiltersModified.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateTimeModified);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.lt);
            filter.FieldValue = toDateForApi;
            searchFiltersModified.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.IDENTICALFIELDNAMES.SoftwareId);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.ne);
            filter.FieldValue = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            searchFiltersCreated.add(filter);
            searchFiltersModified.add(filter);
            searchFilterArrayCreated.SearchFilter = searchFiltersCreated;
            searchFilterArrayModified.SearchFilter = searchFiltersModified;
            List < ebizchargeServicemodelSoap.Customer > ebizCustomersCreated = new List < ebizchargeServicemodelSoap.Customer > ();
            ebizchargeServicemodelSoap.ArrayOfCustomer customerCreated = new ebizchargeServicemodelSoap.ArrayOfCustomer();
            ebizchargeServicemodelSoap.CustomerListSearchResult ebizResponseCreated = new ebizchargeServicemodelSoap.CustomerListSearchResult();
            List < ebizchargeServicemodelSoap.Customer > ebizCustomersModified = new List < ebizchargeServicemodelSoap.Customer > ();
            ebizchargeServicemodelSoap.ArrayOfCustomer customerModified = new ebizchargeServicemodelSoap.ArrayOfCustomer();
            ebizchargeServicemodelSoap.CustomerListSearchResult ebizResponseModified = new ebizchargeServicemodelSoap.CustomerListSearchResult();
            if (!test.isRunningTest()) {
                ebizResponseModified = ebiz.SearchCustomerList(securityToken, searchFilterArrayModified, startLimit, endLimit, '1', false, false, false);
                ebizResponseCreated = ebiz.SearchCustomerList(securityToken, searchFilterArrayCreated, startLimit, endLimit, '1', false, false, false);
            } else {
                ebizCustomersModified = new List < ebizchargeServicemodelSoap.Customer > ();
                ebizCustomersCreated = new List < ebizchargeServicemodelSoap.Customer > ();
                ebizchargeServicemodelSoap.Customer customer = new ebizchargeServicemodelSoap.Customer();
                customer.CustomerId = '1';
                customer.CustomerInternalId = '123';
                customer.DateTimeModified = '20/04/2022';
                ebizCustomersModified.add(customer);
                ebizCustomersCreated.add(customer);
                customerModified = new ebizchargeServicemodelSoap.ArrayOfCustomer();
                customerCreated = new ebizchargeServicemodelSoap.ArrayOfCustomer();
                customerModified.Customer = ebizCustomersModified;
                customerCreated.Customer = ebizCustomersCreated;
                ebizResponseModified = new ebizchargeServicemodelSoap.CustomerListSearchResult();
                ebizResponseCreated = new ebizchargeServicemodelSoap.CustomerListSearchResult();
                ebizResponseModified.CustomerList = customerModified;
                ebizResponseCreated.CustomerList = customerCreated;
            }
            if (ebizResponseModified != null) {
                customerModified = ebizResponseModified.CustomerList;
                ebizCustomersModified = customerModified.Customer;
                if (ebizCustomersModified != null) {
                    for (ebizchargeServicemodelSoap.Customer ebizCustomer: ebizCustomersModified) {
                        accountsGWInternalIdsModified.add(ebizCustomer.CustomerInternalId);
                    }
                    String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c,EBizCharge_Last_Modified_Date__c';
                    String queryFrom = 'FROM Account';
                    String queryWhere = 'where EBizCharge_Internal_ID__c IN :';
                    List < Account > sfAccounts = (List < Account > ) dml.selectRecordsInList(accountsGWInternalIdsModified, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                    if (sfAccounts != null) {
                        for (Account account: sfAccounts) {
                            accountsGWExternalIdsModified.put(account.EBizCharge_Internal_ID__c, account);
                        }
                    }
                    ebcLogger.debug(ClassName, MethodName, 'ebizCustomersModified size : ' + ebizCustomersModified.size());
                    for (ebizchargeServicemodelSoap.Customer ebizCustomer: ebizCustomersModified) {
                        if (accountsGWExternalIdsModified.containsKey(ebizCustomer.CustomerInternalId)) {
                            Account account = accountsGWExternalIdsModified.get(ebizCustomer.CustomerInternalId);
                            if (account.EBizCharge_Last_Modified_Date__c < DateTime.valueOf(ebizCustomer.DateTimeModified) || account.EBizCharge_Last_Modified_Date__c == null) {
                                AccountWrapper AccountWrapperEntity = new AccountWrapper();
                                String accountCustomerId = ebizCustomer.CustomerId;
                                if (accountCustomerId.startsWith(divisionId)) {
                                    AccountWrapperEntity.Id = ebizCustomer.CustomerId;
                                    AccountWrapperEntity.accName = ebizCustomer.FirstName + Configuration.CUSTOMERNAMESEPERATOR + ebizCustomer.LastName;
                                    AccountWrapperEntity.HyperUrlAccount = Configuration.TARGETURL + ebizCustomer.CustomerId;
                                    AccountWrapperEntity.accExternalId = ebizCustomer.CustomerInternalId;
                                    AccountWrapperEntity.accFirstName = ebizCustomer.FirstName;
                                    AccountWrapperEntity.accLastName = ebizCustomer.LastName;
                                    AccountWrapperEntity.accEmail = ebizCustomer.Email;
                                    AccountWrapperEntity.accPhone = ebizCustomer.Phone;
                                    AccountWrapperEntity.accSource = ebizCustomer.SoftwareId;
                                    AccountWrapperEntity.DivisionId = ebizCustomer.DivisionId;
                                    AccountWrapperEntity.accAmount = 0;
                                    AccountWrapperEntity.isImported = true;
                                    String accountDate = String.valueOf(ebizCustomer.DateTimeCreated);
                                    Datetime accountDateTime = Datetime.valueOf(accountDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                    AccountWrapperEntity.accDateTimeCreated = accountDateTime;
                                    AccountWrapperEntity.accDateTimeModified = Datetime.valueOf(ebizCustomer.DateTimeModified);
                                    accounts.add(AccountWrapperEntity);
                                }
                            }
                        }
                    }
                }
            }
            if (ebizResponseCreated != null) {
                customerCreated = ebizResponseCreated.CustomerList;
                ebizCustomersCreated = customerCreated.Customer;
                if (ebizCustomersCreated != null) {
                    for (ebizchargeServicemodelSoap.Customer account: ebizCustomersCreated) {
                        accountsGWInternalIdsCreated.add(account.CustomerInternalId);
                    }
                    String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c';
                    String queryFrom = 'FROM Account';
                    String queryWhere = 'where EBizCharge_Internal_ID__c IN :';
                    List < Account > sfAccounts = (List < Account > ) dml.selectRecordsInList(accountsGWInternalIdsCreated, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                    if (sfAccounts != null) {
                        for (Account account: sfAccounts) {
                            accountsGWExternalIdsCreated.put(account.EBizCharge_Internal_ID__c, account);
                        }
                    }
                    ebcLogger.debug(ClassName, MethodName, '>>>ebizCustomersCreated size: ' + ebizCustomersCreated.size());
                    for (ebizchargeServicemodelSoap.Customer ebizAccount: ebizCustomersCreated) {
                        if (!accountsGWExternalIdsCreated.containsKey(ebizAccount.CustomerInternalId)) {
                            AccountWrapper accountWrapperEntity = new AccountWrapper();
                            String accountCustomerId = ebizAccount.CustomerId;
                            if (accountCustomerId.startsWith(divisionId)) {
                                accountWrapperEntity.Id = ebizAccount.CustomerId;
                                accountWrapperEntity.accName = ebizAccount.FirstName + Configuration.CUSTOMERNAMESEPERATOR + ebizAccount.LastName;
                                accountWrapperEntity.HyperUrlAccount = Configuration.TARGETURL + ebizAccount.CustomerId;
                                accountWrapperEntity.accExternalId = ebizAccount.CustomerInternalId;
                                accountWrapperEntity.accFirstName = ebizAccount.FirstName;
                                accountWrapperEntity.accLastName = ebizAccount.LastName;
                                accountWrapperEntity.accEmail = ebizAccount.Email;
                                accountWrapperEntity.accPhone = ebizAccount.Phone;
                                accountWrapperEntity.accSource = ebizAccount.SoftwareId;
                                accountWrapperEntity.DivisionId = ebizAccount.DivisionId;
                                accountWrapperEntity.accAmount = 0;
                                accountWrapperEntity.isImported = false;
                                accountWrapperEntity.accDateTimeCreated = Datetime.valueOf(ebizAccount.DateTimeCreated);
                                if (ebizAccount.DateTimeModified != null) {
                                    accountWrapperEntity.accDateTimeModified = Datetime.valueOf(ebizAccount.DateTimeModified);
                                }
                                accounts.add(accountWrapperEntity);
                            }
                        }
                    }
                }
            }
            returnAccounts.AccountsList = accounts;
            returnAccounts.fromDate = (fromDate == Configuration.EMPTYSTRING ? null : date.valueOf(fromDate));
            returnAccounts.toDate = (toDate == Configuration.EMPTYSTRING ? null : date.valueOf(toDate));
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnAccounts;
    }
    @AuraEnabled
    public static AccountsData getAccountsDownloadApxc(Integer startLimit, Integer endLimit) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        AccountsData reciprocate = getAccountsDownloadApxc(dml, startLimit, endLimit, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static AccountsData getAccountsDownloadApxc(DML dml, Integer startLimit, Integer endLimit, EBC_Logger ebcLogger) {
        MethodName = 'getAccountsDownloadApxc';
        EBizcharge_Setting__c settings = eBc_UtilityController.getSettings(dml, ebcLogger);
        string divisionId = settings.Division_ID__c;
        divisionId = divisionId != null ? divisionId : Configuration.EMPTYSTRING;
        List < AccountWrapper > accounts = new List < AccountWrapper > ();
        List < String > accountsGWInternalIdsCreated = new List < String > ();
        Map < String, Account > accountsGWExternalIdsCreated = new Map < String, Account > ();
        List < String > accountsGWInternalIdsModified = new List < String > ();
        Map < String, Account > accountsGWExternalIdsModified = new Map < String, Account > ();
        AccountsData returnAccounts = new AccountsData();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        try {
            ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
            ebizchargeServicemodelSoap.ArrayOfSearchFilter searchFilterArrayCreated = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
            ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
            List < ebizchargeServicemodelSoap.SearchFilter > searchFiltersCreated = new List < ebizchargeServicemodelSoap.SearchFilter > ();
            ebizchargeServicemodelSoap.ArrayOfSearchFilter searchFilterArrayModified = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
            List < ebizchargeServicemodelSoap.SearchFilter > searchFiltersModified = new List < ebizchargeServicemodelSoap.SearchFilter > ();
            String fromDate = Configuration.EMPTYSTRING;
            String toDate = Configuration.EMPTYSTRING;
            String fromDateForApi = Configuration.EMPTYSTRING;
            String toDateForApi = Configuration.EMPTYSTRING;
            DateTime datetimeEntity = system.Today().AddDays(1);
            toDate = datetimeEntity.format(Configuration.DATEFORMAT);
            DateTime datetimeEntityApi = system.Today().AddDays(2);
            toDateForApi = datetimeEntityApi.format(Configuration.DATEFORMAT);
            DateTime accountsLastSyncDate = settings.Ebizcharge_Accounts_Last_Sync_Date__c;
            if (accountsLastSyncDate != null) {
                fromDate = string.valueOfGmt(accountsLastSyncDate);
                Date fromDateEntity = Date.valueOf(fromDate);
                fromDateForApi = String.valueOf(fromDateEntity);
            } else {
                Datetime fromDateEntity = System.Today().AddDays(-13);
                fromDate = fromDateEntity.format(Configuration.DATEFORMAT);
                Datetime fromDateEntityApi = System.Today().AddDays(-14);
                fromDateForApi = fromDateEntityApi.format(Configuration.DATEFORMAT);
            }
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateTimeCreated);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
            filter.FieldValue = fromDateForApi;
            searchFiltersCreated.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateTimeCreated);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.lt);
            filter.FieldValue = toDateForApi;
            searchFiltersCreated.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateTimeModified);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
            filter.FieldValue = fromDateForApi;
            searchFiltersModified.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateTimeModified);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.lt);
            filter.FieldValue = toDateForApi;
            searchFiltersModified.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.IDENTICALFIELDNAMES.SoftwareId);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.ne);
            filter.FieldValue = string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp);
            searchFiltersCreated.add(filter);
            searchFiltersModified.add(filter);
            searchFilterArrayCreated.SearchFilter = searchFiltersCreated;
            searchFilterArrayModified.SearchFilter = searchFiltersModified;
            List < ebizchargeServicemodelSoap.Customer > ebizCustomersCreated = new List < ebizchargeServicemodelSoap.Customer > ();
            ebizchargeServicemodelSoap.ArrayOfCustomer customerCreated = new ebizchargeServicemodelSoap.ArrayOfCustomer();
            ebizchargeServicemodelSoap.CustomerListSearchResult ebizResponseCreated = new ebizchargeServicemodelSoap.CustomerListSearchResult();
            List < ebizchargeServicemodelSoap.Customer > ebizCustomersModified = new List < ebizchargeServicemodelSoap.Customer > ();
            ebizchargeServicemodelSoap.ArrayOfCustomer customerModified = new ebizchargeServicemodelSoap.ArrayOfCustomer();
            ebizchargeServicemodelSoap.CustomerListSearchResult ebizResponseModified = new ebizchargeServicemodelSoap.CustomerListSearchResult();
            while (true) {
                if (!test.isRunningTest()) {
                    ebizResponseModified = ebiz.SearchCustomerList(securityToken, searchFilterArrayModified, startLimit, endLimit, '1', false, false, false);
                    ebizResponseCreated = ebiz.SearchCustomerList(securityToken, searchFilterArrayCreated, startLimit, endLimit, '1', false, false, false);
                    boolean responseModified = true;
                    boolean responseCreated = true;
                    if (ebizResponseModified == null || ebizResponseModified.CustomerList == null || ebizResponseModified.CustomerList.Customer == null || ebizResponseModified.CustomerList.Customer.size() == 0) {
                        responseModified = false;
                    }
                    if (ebizResponseCreated == null || ebizResponseCreated.CustomerList == null || ebizResponseCreated.CustomerList.Customer == null || ebizResponseCreated.CustomerList.Customer.size() == 0) {
                        responseCreated = false;
                    }
                    if (responseModified == false && responseCreated == false) {
                        break;
                    }
                } else {
                    ebizCustomersModified = new List < ebizchargeServicemodelSoap.Customer > ();
                    ebizCustomersCreated = new List < ebizchargeServicemodelSoap.Customer > ();
                    ebizchargeServicemodelSoap.Customer customer = new ebizchargeServicemodelSoap.Customer();
                    customer.CustomerId = '1';
                    customer.CustomerInternalId = '123';
                    customer.DateTimeModified = '2021-10-14 18:14:16';
                    ebizCustomersModified.add(customer);
                    ebizCustomersCreated.add(customer);
                    customerModified = new ebizchargeServicemodelSoap.ArrayOfCustomer();
                    customerCreated = new ebizchargeServicemodelSoap.ArrayOfCustomer();
                    customerModified.Customer = ebizCustomersModified;
                    customerCreated.Customer = ebizCustomersCreated;
                    ebizResponseModified = new ebizchargeServicemodelSoap.CustomerListSearchResult();
                    ebizResponseCreated = new ebizchargeServicemodelSoap.CustomerListSearchResult();
                    ebizResponseModified.CustomerList = customerModified;
                    ebizResponseCreated.CustomerList = customerCreated;
                }
                if (ebizResponseModified != null) {
                    customerModified = ebizResponseModified.CustomerList;
                    ebizCustomersModified = customerModified.Customer;
                    if (ebizCustomersModified != null) {
                        for (ebizchargeServicemodelSoap.Customer ebizCustomer: ebizCustomersModified) {
                            accountsGWInternalIdsModified.add(ebizCustomer.CustomerInternalId);
                        }
                        String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c,EBizCharge_Last_Modified_Date__c';
                        String queryFrom = 'FROM Account';
                        String queryWhere = 'where EBizCharge_Internal_ID__c IN :';
                        List < Account > sfAccounts = (List < Account > ) dml.selectRecordsInList(accountsGWInternalIdsModified, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                        if (sfAccounts != null) {
                            for (Account account: sfAccounts) {
                                accountsGWExternalIdsModified.put(account.EBizCharge_Internal_ID__c, account);
                            }
                        }
                        ebcLogger.debug(ClassName, MethodName, '>>>ebizCustomersModified size: ' + ebizCustomersModified.size());
                        for (ebizchargeServicemodelSoap.Customer ebizCustomer: ebizCustomersModified) {
                            if (accountsGWExternalIdsModified.containsKey(ebizCustomer.CustomerInternalId)) {
                                Account account = accountsGWExternalIdsModified.get(ebizCustomer.CustomerInternalId);
                                if (account.EBizCharge_Last_Modified_Date__c < DateTime.valueOf(ebizCustomer.DateTimeModified) || account.EBizCharge_Last_Modified_Date__c == null) {
                                    AccountWrapper accountWrapperEntity = new AccountWrapper();
                                    String accountCustomerId = ebizCustomer.CustomerId;
                                    if (accountCustomerId.startsWith(divisionId)) {
                                        accountWrapperEntity.Id = ebizCustomer.CustomerId;
                                        accountWrapperEntity.accName = ebizCustomer.FirstName + Configuration.CUSTOMERNAMESEPERATOR + ebizCustomer.LastName;
                                        accountWrapperEntity.HyperUrlAccount = Configuration.TARGETURL + ebizCustomer.CustomerId;
                                        accountWrapperEntity.accExternalId = ebizCustomer.CustomerInternalId;
                                        accountWrapperEntity.accFirstName = ebizCustomer.FirstName;
                                        accountWrapperEntity.accLastName = ebizCustomer.LastName;
                                        accountWrapperEntity.accEmail = ebizCustomer.Email;
                                        accountWrapperEntity.accPhone = ebizCustomer.Phone;
                                        accountWrapperEntity.accSource = ebizCustomer.SoftwareId;
                                        accountWrapperEntity.DivisionId = ebizCustomer.DivisionId;
                                        accountWrapperEntity.accAmount = 0;
                                        accountWrapperEntity.isImported = true;
                                        String accountDate = String.valueOf(ebizCustomer.DateTimeCreated);
                                        Datetime accountDateTime = Datetime.valueOf(accountDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                        accountWrapperEntity.accDateTimeCreated = accountDateTime;
                                        accountWrapperEntity.accDateTimeModified = Datetime.valueOf(ebizCustomer.DateTimeModified);
                                        accounts.add(accountWrapperEntity);
                                    }
                                }
                            }
                        }
                    }
                }
                if (ebizResponseCreated != null) {
                    customerCreated = ebizResponseCreated.CustomerList;
                    ebizCustomersCreated = customerCreated.Customer;
                    if (ebizCustomersCreated != null) {
                        for (ebizchargeServicemodelSoap.Customer abizAccount: ebizCustomersCreated) {
                            accountsGWInternalIdsCreated.add(abizAccount.CustomerInternalId);
                        }
                        String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c';
                        String queryFrom = 'FROM Account';
                        String queryWhere = 'where EBizCharge_Internal_ID__c IN :';
                        List < Account > sfAccounts = (List < Account > ) dml.selectRecordsInList(accountsGWInternalIdsCreated, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                        if (sfAccounts != null) {
                            for (Account account: sfAccounts) {
                                accountsGWExternalIdsCreated.put(account.EBizCharge_Internal_ID__c, account);
                            }
                        }
                        ebcLogger.debug(ClassName, MethodName, '>>>ebizCustomersCreated size: ' + ebizCustomersCreated.size());
                        for (ebizchargeServicemodelSoap.Customer abizAccount: ebizCustomersCreated) {
                            if (!accountsGWExternalIdsCreated.containsKey(abizAccount.CustomerInternalId)) {
                                AccountWrapper accountWrapperEntity = new AccountWrapper();
                                String accountCustomerId = abizAccount.CustomerId;
                                if (accountCustomerId.startsWith(divisionId)) {
                                    accountWrapperEntity.Id = abizAccount.CustomerId;
                                    accountWrapperEntity.accName = abizAccount.FirstName + Configuration.CUSTOMERNAMESEPERATOR + abizAccount.LastName;
                                    accountWrapperEntity.HyperUrlAccount = Configuration.TARGETURL + abizAccount.CustomerId;
                                    accountWrapperEntity.accExternalId = abizAccount.CustomerInternalId;
                                    accountWrapperEntity.accFirstName = abizAccount.FirstName;
                                    accountWrapperEntity.accLastName = abizAccount.LastName;
                                    accountWrapperEntity.accEmail = abizAccount.Email;
                                    accountWrapperEntity.accPhone = abizAccount.Phone;
                                    accountWrapperEntity.accSource = abizAccount.SoftwareId;
                                    accountWrapperEntity.DivisionId = abizAccount.DivisionId;
                                    accountWrapperEntity.accAmount = 0;
                                    accountWrapperEntity.isImported = false;
                                    accountWrapperEntity.accDateTimeCreated = Datetime.valueOf(abizAccount.DateTimeCreated);
                                    if (abizAccount.DateTimeModified != null) {
                                        accountWrapperEntity.accDateTimeModified = Datetime.valueOf(abizAccount.DateTimeModified);
                                    }
                                    accounts.add(accountWrapperEntity);
                                }
                            }
                        }
                    }
                }
                startLimit = startLimit + 1000;
            }
            returnAccounts.AccountsList = accounts;
            returnAccounts.fromDate = (fromDate == Configuration.EMPTYSTRING ? null : date.valueOf(fromDate));
            returnAccounts.toDate = (toDate == Configuration.EMPTYSTRING ? null : date.valueOf(toDate));
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnAccounts;
    }
    @AuraEnabled
    public static List < AccountWrapper > getUpdatedAccountsApxc(List < AccountWrapper > accList, List < AccountWrapper > selAcclist, EBizcharge_Setting__c Settings) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < AccountWrapper > reciprocate = getUpdatedAccountsApxc(dml, accList, selAcclist, Settings, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < AccountWrapper > getUpdatedAccountsApxc(DML dml, List < AccountWrapper > accList, List < AccountWrapper > selAcclist, EBizcharge_Setting__c Settings, EBC_Logger ebcLogger) {
        MethodName = 'getUpdatedAccountsApxc';
        EBC_ComponentController.saveSettingsApxc(dml, Settings, ebcLogger);
        List < AccountWrapper > returnUpdatedAccounts = new List < AccountWrapper > ();
        List < String > accountInternalIds = new List < String > ();
        try {
            for (AccountWrapper account: selAcclist) {
                accountInternalIds.add(account.accExternalId);
            }
            for (AccountWrapper account: accList) {
                if (!accountInternalIds.contains(account.accExternalId)) {
                    returnUpdatedAccounts.add(account);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnUpdatedAccounts;
    }
    @AuraEnabled
    public static List < ProductWrapper > getProductsApxc(Integer startLimit, Integer endLimit) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < ProductWrapper > reciprocate = getProductsApxc(dml, startLimit, endLimit, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < ProductWrapper > getProductsApxc(DML dml, Integer startLimit, Integer endLimit, EBC_Logger ebcLogger) {
        MethodName = 'getProductsApxc';
        EBizcharge_Setting__c settings = eBc_UtilityController.getSettings(dml, ebcLogger);
        String fromDate = Configuration.EMPTYSTRING;
        String toDate = Configuration.EMPTYSTRING;
        String fromDateForApi = Configuration.EMPTYSTRING;
        String toDateForApi = Configuration.EMPTYSTRING;
        DateTime datetimeEntity = system.Today().AddDays(1);
        toDate = datetimeEntity.format(Configuration.DATEFORMAT);
        DateTime datetimeEntityApi = system.Today().AddDays(2);
        toDateForApi = datetimeEntityApi.format(Configuration.DATEFORMAT);
        DateTime productsLastSyncDate = settings.Ebizcharge_Product_Last_Sync_Date__c;
        if (productsLastSyncDate != null) {
            fromDate = string.valueOfGmt(productsLastSyncDate);
            Date fromDateEntity = Date.valueOf(fromDate);
            fromDateForApi = String.valueOf(fromDateEntity);
        } else {
            Datetime fromDateEntity = System.Today().AddDays(-13);
            fromDate = fromDateEntity.format(Configuration.DATEFORMAT);
            Datetime fromDateEntityApi = System.Today().AddDays(-14);
            fromDateForApi = fromDateEntityApi.format(Configuration.DATEFORMAT);
        }
        List < ProductWrapper > returnProducts = new List < ProductWrapper > ();
        List < String > productGWInternalIdsCreated = new List < String > ();
        List < String > prodSFExternalIDList = new List < String > ();
        List < String > productGWInternalIdsModified = new List < String > ();
        map < string, product2 > productSFExternalIdsMap = new map < string, product2 > ();
        try {
            ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
            ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
            List < ebizchargeServicemodelSoap.ItemDetails > itemDetailsCreatd = new List < ebizchargeServicemodelSoap.ItemDetails > ();
            ebizchargeServicemodelSoap.ArrayOfItemDetails ebizResponseCreated = new ebizchargeServicemodelSoap.ArrayOfItemDetails();
            List < ebizchargeServicemodelSoap.ItemDetails > itemDetailsModified = new List < ebizchargeServicemodelSoap.ItemDetails > ();
            ebizchargeServicemodelSoap.ArrayOfItemDetails ebizResponseModified = new ebizchargeServicemodelSoap.ArrayOfItemDetails();
            ebizchargeServicemodelSoap.ArrayOfSearchFilter searchFilterArrayCreated = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
            ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
            List < ebizchargeServicemodelSoap.SearchFilter > searchFiltersCreated = new List < ebizchargeServicemodelSoap.SearchFilter > ();
            ebizchargeServicemodelSoap.ArrayOfSearchFilter searchFilterArrayModified = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
            List < ebizchargeServicemodelSoap.SearchFilter > searchFiltersModified = new List < ebizchargeServicemodelSoap.SearchFilter > ();
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateCreated);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
            filter.FieldValue = fromDateForApi;
            searchFiltersCreated.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.IDENTICALFIELDNAMES.SoftwareId);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = Configuration.EPICORFIELDVALUE;
            searchFiltersCreated.add(filter);
            searchFilterArrayCreated.SearchFilter = searchFiltersCreated;
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateModified);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
            filter.FieldValue = fromDateForApi;
            searchFiltersModified.add(filter);
            filter = new ebizchargeServicemodelSoap.SearchFilter();
            filter.FieldName = string.valueOf(Enums.FIELDNAMES.Software);
            filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
            filter.FieldValue = Configuration.EPICORFIELDVALUE;
            searchFiltersModified.add(filter);
            searchFilterArrayModified.SearchFilter = searchFiltersModified;
            while (true) {
                ebizResponseCreated = ebiz.SearchItems(securityToken, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, searchFilterArrayCreated, startLimit, endLimit, Configuration.EMPTYSTRING);
                ebizResponseModified = ebiz.SearchItems(securityToken, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, searchFilterArrayModified, startLimit, endLimit, Configuration.EMPTYSTRING);
                Boolean responseUploaded = true;
                Boolean responseUpdated = true;
                if (ebizResponseCreated == null || ebizResponseCreated.ItemDetails == null || ebizResponseCreated.ItemDetails.size() == 0) {
                    responseUploaded = false;
                }
                if (ebizResponseModified == null || ebizResponseModified.ItemDetails == null || ebizResponseModified.ItemDetails.size() == 0) {
                    responseUpdated = false;
                }
                if (responseUploaded == false && responseUpdated == false) {
                    break;
                }
                if (ebizResponseModified != null) {
                    if (ebizResponseModified.ItemDetails != null) {
                        itemDetailsModified = ebizResponseModified.ItemDetails;
                        for (ebizchargeServicemodelSoap.ItemDetails ebizItem: itemDetailsModified) {
                            productGWInternalIdsModified.add(ebizItem.ItemInternalId);
                        }
                        String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c,EBizCharge_Last_Modified_Date__c	';
                        String queryFrom = 'FROM Product2';
                        String queryWhere = 'where EBizCharge_Internal_ID__c IN :';
                        List < Product2 > sfProducts = (List < Product2 > ) dml.selectRecordsInList(productGWInternalIdsModified, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                        if (sfProducts != null) {
                            for (Product2 product: sfProducts) {
                                productSFExternalIdsMap.put(product.EBizCharge_Internal_ID__c, product);
                            }
                        }
                        for (ebizchargeServicemodelSoap.ItemDetails ebizItem: itemDetailsModified) {
                            DateTime itemModifiedDate;
                            if (productSFExternalIdsMap.containsKey(ebizItem.ItemInternalId)) {
                                if (ebizItem.DateTimeModified != null) {
                                    itemModifiedDate = Datetime.valueOf(ebizItem.DateTimeModified.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                }
                                Product2 product = productSFExternalIdsMap.get(ebizItem.ItemInternalId);
                                if (product.EBizCharge_Last_Modified_Date__c < itemModifiedDate || product.EBizCharge_Last_Modified_Date__c == null) {
                                    ProductWrapper productWrapperEntity = new ProductWrapper();
                                    productWrapperEntity.DivisionId = ebizItem.DivisionId;
                                    productWrapperEntity.Id = ebizItem.ItemId;
                                    productWrapperEntity.prodExternalId = ebizItem.ItemInternalId;
                                    productWrapperEntity.prodName = ebizItem.Name;
                                    productWrapperEntity.prodCode = ebizItem.ItemId;
                                    productWrapperEntity.UnitOfMeasure = ebizItem.UnitOfMeasure;
                                    productWrapperEntity.prodDescription = ebizItem.Description;
                                    productWrapperEntity.prodSoftware = ebizItem.SoftwareId;
                                    String itemDate = String.valueOf(ebizItem.DateTimeCreated);
                                    Datetime itemDateTime = Datetime.valueOf(itemDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                    productWrapperEntity.FormatedTransDate = itemDateTime;
                                    if (ebizItem.DateTimeModified != null) {
                                        productWrapperEntity.UpdatedDate = itemModifiedDate;
                                        ebcLogger.debug(ClassName, MethodName, '>>>itemModifiedDate: ' + itemModifiedDate);
                                    } else {
                                        productWrapperEntity.UpdatedDate = productWrapperEntity.FormatedTransDate;
                                    }
                                    productWrapperEntity.prodPrice = ebizItem.UnitPrice;
                                    productWrapperEntity.prodQuantity = Integer.valueOf(ebizItem.QtyOnHand);
                                    productWrapperEntity.fromDate = (fromDate == Configuration.EMPTYSTRING ? null : date.valueOf(fromDate));
                                    productWrapperEntity.toDate = (toDate == Configuration.EMPTYSTRING ? null : date.valueOf(toDate));
                                    returnProducts.add(productWrapperEntity);
                                }
                            }
                        }
                    }
                }
                if (ebizResponseCreated != null) {
                    itemDetailsCreatd = ebizResponseCreated.ItemDetails;
                    if (itemDetailsCreatd != null) {
                        for (ebizchargeServicemodelSoap.ItemDetails ebizItem: itemDetailsCreatd) {
                            productGWInternalIdsCreated.add(ebizItem.ItemInternalId);
                        }
                        String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c';
                        String queryFrom = 'FROM Product2';
                        String queryWhere = 'where EBizCharge_Internal_ID__c IN :';
                        List < Product2 > sfProducts = (List < Product2 > ) dml.selectRecordsInList(productGWInternalIdsCreated, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                        if (sfProducts != null) {
                            for (Product2 product: sfProducts) {
                                prodSFExternalIDList.add(product.EBizCharge_Internal_ID__c);
                            }
                        }
                        for (ebizchargeServicemodelSoap.ItemDetails ebizItem: itemDetailsCreatd) {
                            if (!prodSFExternalIDList.contains(ebizItem.ItemInternalId)) {
                                ProductWrapper productWrapperEntity = new ProductWrapper();
                                productWrapperEntity.DivisionId = ebizItem.DivisionId;
                                productWrapperEntity.Id = ebizItem.ItemId;
                                productWrapperEntity.prodExternalId = ebizItem.ItemInternalId;
                                productWrapperEntity.prodName = ebizItem.Name;
                                productWrapperEntity.prodCode = ebizItem.ItemId;
                                productWrapperEntity.UnitOfMeasure = ebizItem.UnitOfMeasure;
                                productWrapperEntity.prodDescription = ebizItem.Description;
                                productWrapperEntity.prodSoftware = ebizItem.SoftwareId;
                                String itemDate = String.valueOf(ebizItem.DateTimeCreated);
                                Datetime itemDateTime = Datetime.valueOf(itemDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                productWrapperEntity.FormatedTransDate = itemDateTime;
                                productWrapperEntity.UpdatedDate = productWrapperEntity.FormatedTransDate; // handel if datemodified is not null and also nul on gateway.
                                productWrapperEntity.prodPrice = ebizItem.UnitPrice;
                                productWrapperEntity.prodQuantity = Integer.valueOf(ebizItem.QtyOnHand);
                                productWrapperEntity.fromDate = (fromDate == Configuration.EMPTYSTRING ? null : date.valueOf(fromDate));
                                productWrapperEntity.toDate = (toDate == Configuration.EMPTYSTRING ? null : date.valueOf(toDate));
                                returnProducts.add(productWrapperEntity);
                            }
                        }
                    }
                }
                startLimit = startLimit + 1000;
            }
            ebcLogger.debug(ClassName, MethodName, '>>>returnProducts size: ' + returnProducts.size());
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnProducts;
    }
    @AuraEnabled
    public static List < ProductWrapper > findProductsApxc(String filters, Integer startLimit, Integer endLimit) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < ProductWrapper > reciprocate = findProductsApxc(dml, filters, startLimit, endLimit, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < ProductWrapper > findProductsApxc(DML dml, String filters, Integer startLimit, Integer endLimit, EBC_Logger ebcLogger) {
        MethodName = 'findProductsApxc';
        EBizcharge_Setting__c settings = eBc_UtilityController.getSettings(dml, ebcLogger);
        String fromDate = Configuration.EMPTYSTRING;
        String toDate = Configuration.EMPTYSTRING;
        String fromDateForApi = Configuration.EMPTYSTRING;
        String toDateForApi = Configuration.EMPTYSTRING;
        if (!test.isRunningTest()) {
            Map < String, Object > filterMap = (Map < String, Object > ) JSON.deserializeUntyped(filters);
            fromDate = (String) filterMap.get(string.valueOf(Enums.FILTERJAVASCRIPTMAPSTRINGS.fromDate));
            if (fromDate != null) {
                Date fromDateEntity = Date.valueOf(fromDate);
                fromDateEntity = fromDateEntity.AddDays(-1);
                fromDateForApi = String.valueOf(fromDateEntity);
            }
            toDate = (String) filterMap.get(string.valueOf(Enums.FILTERJAVASCRIPTMAPSTRINGS.toDate));
            if (toDate != null) {
                Date toDateEntity = Date.valueOf(toDate);
                toDateEntity = toDateEntity.AddDays(1);
                toDateForApi = String.valueOf(toDateEntity);
            }
        }
        if (test.isRunningTest()) {
            fromDate = null;
        }
        if (fromDate == null) {
            Datetime fromDateEntity = System.Today().AddDays(-13);
            fromDate = fromDateEntity.format(Configuration.DATEFORMAT);
            Datetime fromDateEntityApi = System.Today().AddDays(-14);
            fromDateForApi = fromDateEntityApi.format(Configuration.DATEFORMAT);
        }
        if (test.isRunningTest()) {
            toDate = null;
        }
        if (toDate == null) {
            DateTime datetimeEntity = system.Today().AddDays(1);
            toDate = datetimeEntity.format(Configuration.DATEFORMAT);
            DateTime datetimeEntityApi = system.Today().AddDays(2);
            toDateForApi = datetimeEntityApi.format(Configuration.DATEFORMAT);
        }
        List < ProductWrapper > returnProducts = new List < ProductWrapper > ();
        List < String > productGWInternalIdsCreated = new List < String > ();
        List < String > prodSFExternalIDList = new List < String > ();
        List < String > productGWInternalIdsModified = new List < String > ();
        map < string, product2 > productSFExternalIdsMap = new map < string, product2 > ();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
        List < ebizchargeServicemodelSoap.ItemDetails > itemDetailsCreatd = new List < ebizchargeServicemodelSoap.ItemDetails > ();
        ebizchargeServicemodelSoap.ArrayOfItemDetails ebizResponseCreated = new ebizchargeServicemodelSoap.ArrayOfItemDetails();
        List < ebizchargeServicemodelSoap.ItemDetails > itemDetailsModified = new List < ebizchargeServicemodelSoap.ItemDetails > ();
        ebizchargeServicemodelSoap.ArrayOfItemDetails ebizResponseModified = new ebizchargeServicemodelSoap.ArrayOfItemDetails();
        ebizchargeServicemodelSoap.ArrayOfSearchFilter searchFilterArrayCreated = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        List < ebizchargeServicemodelSoap.SearchFilter > searchFiltersCreated = new List < ebizchargeServicemodelSoap.SearchFilter > ();
        ebizchargeServicemodelSoap.ArrayOfSearchFilter searchFilterArrayModified = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        List < ebizchargeServicemodelSoap.SearchFilter > searchFiltersModified = new List < ebizchargeServicemodelSoap.SearchFilter > ();
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateCreated);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
        filter.FieldValue = fromDateForApi;
        searchFiltersCreated.add(filter);
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.IDENTICALFIELDNAMES.SoftwareId);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
        filter.FieldValue = Configuration.EPICORFIELDVALUE;
        searchFiltersCreated.add(filter);
        searchFilterArrayCreated.SearchFilter = searchFiltersCreated;
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.DateModified);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
        filter.FieldValue = fromDateForApi;
        searchFiltersModified.add(filter);
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.Software);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.eq);
        filter.FieldValue = Configuration.EPICORFIELDVALUE;
        searchFiltersModified.add(filter);
        searchFilterArrayModified.SearchFilter = searchFiltersModified;
        try {
            if (!test.isRunningTest()) {
                ebizResponseCreated = ebiz.SearchItems(securityToken, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, searchFilterArrayCreated, startLimit, endLimit, Configuration.EMPTYSTRING);
                ebizResponseModified = ebiz.SearchItems(securityToken, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, searchFilterArrayModified, startLimit, endLimit, Configuration.EMPTYSTRING);
            } else {
                ebizResponseModified.ItemDetails = new List < ebizchargeServicemodelSoap.ItemDetails > ();
                ebizResponseCreated.ItemDetails = new List < ebizchargeServicemodelSoap.ItemDetails > ();
                ebizchargeServicemodelSoap.ItemDetails itemDetailOf = new ebizchargeServicemodelSoap.ItemDetails();
                itemDetailOf.ItemInternalId = '1';
                itemDetailOf.DivisionId = '123';
                itemDetailOf.DateTimeModified = '2021-10-14 18:14:16';
                ebizResponseModified.ItemDetails.add(itemDetailOf);
                ebizResponseCreated.ItemDetails.add(itemDetailOf);
            }
            if (ebizResponseModified != null) {
                itemDetailsModified = ebizResponseModified.ItemDetails;
                if (itemDetailsModified != null) {
                    for (ebizchargeServicemodelSoap.ItemDetails ebizItem: itemDetailsModified) {
                        productGWInternalIdsModified.add(ebizItem.ItemInternalId);
                    }
                    String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c,EBizCharge_Last_Modified_Date__c	';
                    String queryFrom = 'FROM Product2';
                    String queryWhere = 'where EBizCharge_Internal_ID__c IN :';
                    List < Product2 > sfProducts = (List < Product2 > ) dml.selectRecordsInList(productGWInternalIdsModified, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                    if (sfProducts != null) {
                        for (Product2 product: sfProducts) {
                            productSFExternalIdsMap.put(product.EBizCharge_Internal_ID__c, product);
                        }
                    }
                    for (ebizchargeServicemodelSoap.ItemDetails ebizItem: itemDetailsModified) {
                        DateTime itemModifiedDate;
                        if (productSFExternalIdsMap.containsKey(ebizItem.ItemInternalId)) {
                            if (ebizItem.DateTimeModified != null) {
                                itemModifiedDate = Datetime.valueOf(ebizItem.DateTimeModified.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                            }
                            Product2 product = productSFExternalIdsMap.get(ebizItem.ItemInternalId);
                            if (product.EBizCharge_Last_Modified_Date__c < itemModifiedDate || product.EBizCharge_Last_Modified_Date__c == null) {
                                ProductWrapper productWrapperEntity = new ProductWrapper();
                                productWrapperEntity.DivisionId = ebizItem.DivisionId;
                                productWrapperEntity.Id = ebizItem.ItemId;
                                productWrapperEntity.prodExternalId = ebizItem.ItemInternalId;
                                productWrapperEntity.prodName = ebizItem.Name;
                                productWrapperEntity.prodCode = ebizItem.ItemId;
                                productWrapperEntity.UnitOfMeasure = ebizItem.UnitOfMeasure;
                                productWrapperEntity.prodDescription = ebizItem.Description;
                                productWrapperEntity.prodSoftware = ebizItem.SoftwareId;
                                String itemDate = String.valueOf(ebizItem.DateTimeCreated);
                                Datetime itemDateTime = Datetime.valueOf(itemDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                productWrapperEntity.FormatedTransDate = itemDateTime;
                                if (ebizItem.DateTimeModified != null) {
                                    productWrapperEntity.UpdatedDate = itemModifiedDate;
                                    ebcLogger.debug(ClassName, MethodName, '>>>itemModifiedDate: ' + itemModifiedDate);
                                } else {
                                    productWrapperEntity.UpdatedDate = productWrapperEntity.FormatedTransDate;
                                }
                                productWrapperEntity.prodPrice = ebizItem.UnitPrice;
                                productWrapperEntity.prodQuantity = Integer.valueOf(ebizItem.QtyOnHand);
                                productWrapperEntity.fromDate = (fromDate == Configuration.EMPTYSTRING ? null : date.valueOf(fromDate));
                                productWrapperEntity.toDate = (toDate == Configuration.EMPTYSTRING ? null : date.valueOf(toDate));
                                returnProducts.add(productWrapperEntity);
                            }
                        }
                    }
                }
            }
            if (ebizResponseCreated != null) {
                itemDetailsCreatd = ebizResponseCreated.ItemDetails;
                if (itemDetailsCreatd != null) {
                    for (ebizchargeServicemodelSoap.ItemDetails ebizItem: itemDetailsCreatd) {
                        productGWInternalIdsCreated.add(ebizItem.ItemInternalId);
                    }
                    String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c';
                    String queryFrom = 'FROM Product2';
                    String queryWhere = 'where EBizCharge_Internal_ID__c IN :';
                    List < Product2 > sfProducts = (List < Product2 > ) dml.selectRecordsInList(productGWInternalIdsCreated, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                    if (sfProducts != null) {
                        for (Product2 product: sfProducts) {
                            prodSFExternalIDList.add(product.EBizCharge_Internal_ID__c);
                        }
                    }
                    for (ebizchargeServicemodelSoap.ItemDetails ebizItem: itemDetailsCreatd) {
                        if (!prodSFExternalIDList.contains(ebizItem.ItemInternalId)) {
                            ProductWrapper productWrapperEntity = new ProductWrapper();
                            productWrapperEntity.DivisionId = ebizItem.DivisionId;
                            productWrapperEntity.Id = ebizItem.ItemId;
                            productWrapperEntity.prodExternalId = ebizItem.ItemInternalId;
                            productWrapperEntity.prodName = ebizItem.Name;
                            productWrapperEntity.prodCode = ebizItem.ItemId;
                            productWrapperEntity.UnitOfMeasure = ebizItem.UnitOfMeasure;
                            productWrapperEntity.prodDescription = ebizItem.Description;
                            productWrapperEntity.prodSoftware = ebizItem.SoftwareId;
                            String itemDate = String.valueOf(ebizItem.DateTimeCreated);
                            Datetime itemDateTime = Datetime.valueOf(itemDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                            productWrapperEntity.FormatedTransDate = itemDateTime;
                            productWrapperEntity.UpdatedDate = productWrapperEntity.FormatedTransDate; // handel if datemodified is not null and also nul on gateway.
                            productWrapperEntity.prodPrice = ebizItem.UnitPrice;
                            productWrapperEntity.prodQuantity = Integer.valueOf(ebizItem.QtyOnHand);
                            productWrapperEntity.fromDate = (fromDate == Configuration.EMPTYSTRING ? null : date.valueOf(fromDate));
                            productWrapperEntity.toDate = (toDate == Configuration.EMPTYSTRING ? null : date.valueOf(toDate));
                            returnProducts.add(productWrapperEntity);
                        }
                    }
                }
            }
            ebcLogger.debug(ClassName, MethodName, 'returnProducts size: ' + returnProducts.size());
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnProducts;
    }
    @AuraEnabled
    public static List < ProductWrapper > getUpdatedProductsApxc(List < ProductWrapper > prodList) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < ProductWrapper > reciprocate = getUpdatedProductsApxc(dml, prodList, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < ProductWrapper > getUpdatedProductsApxc(DML dml, List < ProductWrapper > prodList, EBC_Logger ebcLogger) {
        MethodName = 'getUpdatedProductsApxc';
        List < ProductWrapper > returnUpdatedProducts = new List < ProductWrapper > ();
        List < String > productImportInternalIds = new List < String > ();
        List < String > productSFInternalIds = new List < String > ();
        for (ProductWrapper productWrapper: prodList) {
            productImportInternalIds.add(productWrapper.prodExternalId);
        }
        String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c';
        String queryFrom = 'FROM Product2';
        String queryWhere = 'where EBizCharge_Internal_ID__c IN :';
        try {
            List < Product2 > sfProducts = (List < Product2 > ) dml.selectRecordsInList(productImportInternalIds, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            if (sfProducts != null) {
                for (Product2 product: sfProducts) {
                    productSFInternalIds.add(product.EBizCharge_Internal_ID__c);
                }
            }
            for (ProductWrapper productWrapper: prodList) {
                if (!productSFInternalIds.contains(productWrapper.prodExternalId)) {
                    returnUpdatedProducts.add(productWrapper);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnUpdatedProducts;
    }
    @AuraEnabled
    public static List < TransactionsWrapper > getPaymentsApxc(String startLimit, String endLimit) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < TransactionsWrapper > reciprocate = getPaymentsApxc(dml, startLimit, endLimit, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < TransactionsWrapper > getPaymentsApxc(DML dml, String startLimit, String endLimit, EBC_Logger ebcLogger) {
        MethodName = 'getPaymentsApxc';
        List < TransactionsWrapper > returnTransaction = new List < TransactionsWrapper > ();
        List < String > paymentGWInternalIds = new List < String > ();
        List < String > paymentSFInternalIds = new List < String > ();
        EBizcharge_Setting__c settings = eBc_UtilityController.getSettings(dml, ebcLogger);
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
        String fromDate = Configuration.EMPTYSTRING;
        String toDate = Configuration.EMPTYSTRING;
        String fromDateForApi = Configuration.EMPTYSTRING;
        String toDateForApi = Configuration.EMPTYSTRING;
        DateTime datetimeEntity = system.Today().AddDays(1);
        toDate = datetimeEntity.format(Configuration.DATEFORMAT);
        DateTime datetimeEntityApi = system.Today().AddDays(2);
        toDateForApi = datetimeEntityApi.format(Configuration.DATEFORMAT);
        DateTime transactionLastSyncDate = settings.Ebizcharge_Transaction_Last_Sync_Date__c;
        if (transactionLastSyncDate != null) {
            fromDate = string.valueOfGmt(transactionLastSyncDate);
            Date fromDateEntity = Date.valueOf(fromDate);
            fromDateForApi = String.valueOf(fromDateEntity);
        } else {
            Datetime fromDateEntity = System.Today().AddDays(-13);
            fromDate = fromDateEntity.format(Configuration.DATEFORMAT);
            Datetime fromDateEntityApi = System.Today().AddDays(-14);
            fromDateForApi = fromDateEntityApi.format(Configuration.DATEFORMAT);
        }
        Boolean matchAll = true;
        Boolean countOnly = false;
        String start = Configuration.STARTINDEX;
        String maximum = '50';
        ebizchargeServicemodelSoap.ArrayOfSearchFilter transactionFilter = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        List < ebizchargeServicemodelSoap.SearchFilter > transactionSearchFilter = new List < ebizchargeServicemodelSoap.SearchFilter > ();
        ebizchargeServicemodelSoap.ArrayOfTransactionObject ebizTransaction;
        ebizchargeServicemodelSoap.TransactionSearchResult searchTransactionsResult = new ebizchargeServicemodelSoap.TransactionSearchResult();
        ebizchargeServicemodelSoap.TransactionObject[] ebizTransactions;
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.Created);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
        filter.FieldValue = fromDateForApi;
        transactionSearchFilter.add(filter);
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.Created);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.lt);
        filter.FieldValue = toDateForApi;
        transactionSearchFilter.add(filter);
        transactionFilter.SearchFilter = transactionSearchFilter;
        try {
            if (!test.isRunningTest()) {
                searchTransactionsResult = ebiz.SearchTransactions(securityToken, transactionFilter, matchAll, countOnly, startLimit, endLimit, 'DateTime');
            }
            ebcLogger.debug(ClassName, MethodName, '>>>searchTransactionsResult: ' + searchTransactionsResult);
            if (searchTransactionsResult.Transactions != null) {
                ebizTransaction = searchTransactionsResult.Transactions;
                if (ebizTransaction.TransactionObject != null) {
                    ebizTransactions = ebizTransaction.TransactionObject;
                    if (ebizTransactions != null) {
                        for (ebizchargeServicemodelSoap.TransactionObject ebizTransactionObject: ebizTransactions) {
                            if (ebizTransactionObject.Source != string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp)) {
                                ebizchargeServicemodelSoap.TransactionResponse ebizResponse = ebizTransactionObject.Response;
                                paymentGWInternalIds.add(ebizResponse.RefNum);
                            }
                        }
                        ebcLogger.debug(ClassName, MethodName, '>>>paymentGWInternalIds: ' + paymentGWInternalIds);
                        String querySelect = 'SELECT Id,Ref_Number__c';
                        String queryFrom = 'FROM EBizCharge_Transaction__c';
                        String queryWhere = 'where Ref_Number__c IN :';
                        List < EBizCharge_Transaction__c > sfPayments = (List < EBizCharge_Transaction__c > ) dml.selectRecordsInList(paymentGWInternalIds, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                        ebcLogger.debug(ClassName, MethodName, '>>>Salesforce Transactions: ' + sfPayments);
                        if (sfPayments != null) {
                            for (EBizCharge_Transaction__c payment: sfPayments) {
                                paymentSFInternalIds.add(payment.Ref_Number__c);
                            }
                        }
                    }
                }
            }
            // Removing locally Imported REceivedPayments from Grid.........END HERE
            if (searchTransactionsResult.Transactions != null) {
                ebizTransaction = searchTransactionsResult.Transactions;
                if (ebizTransaction.TransactionObject != null) {
                    ebizTransactions = ebizTransaction.TransactionObject;
                    if (ebizTransactions != null) {
                        //add code........................
                        for (ebizchargeServicemodelSoap.TransactionObject ebizTransactionObject: ebizTransactions) {
                            if (ebizTransactionObject.Source != string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp)) {
                                ebizchargeServicemodelSoap.TransactionResponse ebizResponse = ebizTransactionObject.Response;
                                if (ebizTransactionObject.CustomerID != null) {
                                    if (!paymentSFInternalIds.contains(ebizResponse.RefNum)) {
                                        TransactionsWrapper transactionEntity = new TransactionsWrapper();
                                        transactionEntity.Source = ebizTransactionObject.Source;
                                        transactionEntity.TransType = ebizTransactionObject.TransactionType;
                                        transactionEntity.CustomerId = ebizTransactionObject.CustomerID;
                                        transactionEntity.FormatedTransDate = ebizTransactionObject.DateTime_x;
                                        transactionEntity.DateTime_x = ebizTransactionObject.DateTime_x;
                                        String orderDate = ebizTransactionObject.DateTime_x;
                                        Datetime orderDateTime = Datetime.valueOf(orderDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                        transactionEntity.CreatedDate = orderDateTime;
                                        ebcLogger.debug(ClassName, MethodName, '>>>DateTime_x: ' + ebizTransactionObject.DateTime_x);
                                        ebcLogger.debug(ClassName, MethodName, '>>>CreatedDate: ' + orderDateTime);
                                        transactionEntity.AccountName = ebizTransactionObject.AccountHolder;
                                        transactionEntity.fromDate = (fromDate == Configuration.EMPTYSTRING ? null : date.valueOf(fromDate));
                                        transactionEntity.toDate = (toDate == Configuration.EMPTYSTRING ? null : date.valueOf(toDate));
                                        ebizchargeServicemodelSoap.TransactionDetail transactionDetail = ebizTransactionObject.Details;
                                        transactionEntity.OrderNumber = transactionDetail.Invoice;
                                        transactionEntity.OrderId = transactionDetail.OrderID;
                                        transactionEntity.Tax = transactionDetail.Tax;
                                        transactionEntity.Terminal = transactionDetail.Terminal;
                                        transactionEntity.NonTax = transactionDetail.NonTax;
                                        transactionEntity.Table = transactionDetail.Table;
                                        transactionEntity.Subtotal = transactionDetail.Subtotal;
                                        transactionEntity.Shipping = transactionDetail.Shipping;
                                        transactionEntity.ShipFromZip = transactionDetail.ShipFromZip;
                                        transactionEntity.PONum = transactionDetail.PONum;
                                        transactionEntity.Duty = transactionDetail.Duty;
                                        transactionEntity.Discount = transactionDetail.Discount;
                                        transactionEntity.Comments = transactionDetail.Comments;
                                        transactionEntity.Description = transactionDetail.Description;
                                        transactionEntity.Currency_x = transactionDetail.Currency_x;
                                        transactionEntity.Clerk = transactionDetail.Clerk;
                                        transactionEntity.Amount = transactionDetail.Amount;
                                        transactionEntity.AllowPartialAuth = transactionDetail.AllowPartialAuth;
                                        transactionEntity.Tip = transactionDetail.Tip;
                                        transactionEntity.CustNum = ebizResponse.CustNum;
                                        transactionEntity.ResultCode = ebizResponse.ResultCode;
                                        transactionEntity.Result = ebizResponse.Result;
                                        transactionEntity.RemainingBalance = ebizResponse.RemainingBalance;
                                        transactionEntity.isDuplicate = ebizResponse.isDuplicate;
                                        transactionEntity.convertedAmountCurrency = ebizResponse.ConvertedAmountCurrency;
                                        transactionEntity.convertedAmount = ebizResponse.ConvertedAmount;
                                        transactionEntity.ConversionRate = ebizResponse.ConversionRate;
                                        transactionEntity.CardCodeResultCode = ebizResponse.CardCodeResultCode;
                                        transactionEntity.CardCodeResult = ebizResponse.CardCodeResult;
                                        transactionEntity.BatchRefNum = ebizResponse.BatchRefNum;
                                        transactionEntity.BatchNum = ebizResponse.BatchNum;
                                        transactionEntity.AvsResultCode = ebizResponse.AvsResultCode;
                                        transactionEntity.AvsResult = ebizResponse.AvsResult;
                                        transactionEntity.RefNumber = ebizResponse.RefNum;
                                        if (ebizResponse.Error != null) {
                                            transactionEntity.Error = ebizResponse.Error;
                                            transactionEntity.ErrorCode = ebizResponse.ErrorCode;
                                        }
                                        transactionEntity.AuthCode = ebizResponse.AuthCode;
                                        transactionEntity.AuthAmount = ebizResponse.AuthAmount;
                                        transactionEntity.Status = ebizResponse.Status;
                                        transactionEntity.StatusCode = ebizResponse.StatusCode;
                                        ebizchargeServicemodelSoap.CreditCardData creditCard = ebizTransactionObject.CreditCardData;
                                        if (creditCard.CardNumber != null) {
                                            transactionEntity.PayBy = string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard);
                                            transactionEntity.CardType = creditCard.CardType;
                                            transactionEntity.CardNumber = creditCard.CardNumber.right(4);
                                        }
                                        ebizchargeServicemodelSoap.CheckData chekData = ebizTransactionObject.CheckData;
                                        if (chekData.Account != null) {
                                            transactionEntity.PayBy = string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check);
                                            transactionEntity.checkAccount = chekData.Account.right(4);
                                        }
                                        transactionEntity.isSelected = false;
                                        returnTransaction.add(transactionEntity);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnTransaction;
    }
    @AuraEnabled
    public static string importReceivedPaymentApxc(List < TransactionsWrapper > importPayments) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = importReceivedPaymentApxc(dml, importPayments, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string importReceivedPaymentApxc(DML dml, List < TransactionsWrapper > importPayments, EBC_Logger ebcLogger) {
        MethodName = 'importReceivedPaymentApxc';
        EBizcharge_Setting__c settings = eBc_UtilityController.getSettings(dml, ebcLogger);
        map < String, TransactionsWrapper > mapProductLog = new map < string, TransactionsWrapper > ();
        string returnMessage = Configuration.EMPTYSTRING;
        integer count = 0;
        String querySelect = 'SELECT Id,Ref_Number__c';
        String queryFrom = 'FROM EBizCharge_Transaction__c';
        try {
            List < EBizCharge_Transaction__c > sfPayments = (List < EBizCharge_Transaction__c > ) dml.selectRecords(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            List < EBizCharge_Transaction__c > transactions = new List < EBizCharge_Transaction__c > ();
            if (importPayments != null) {
                for (TransactionsWrapper payment: importPayments) {
                    EBizCharge_Transaction__c transactionEntity = new EBizCharge_Transaction__c();
                    if (payment.AccountName != Configuration.CUSTOMERNAMESEPERATOR) {
                        for (EBizCharge_Transaction__c sfPayment: sfPayments) {
                            if (sfPayment.Ref_Number__c == payment.RefNumber) {
                                transactionEntity.Id = sfPayment.Id;
                                break;
                            }
                        }
                        transactionEntity.External_Order_Number__c = (String) payment.OrderNumber;
                        transactionEntity.Customer_Number__c = payment.CustNum;
                        transactionEntity.Status__c = payment.Status;
                        transactionEntity.Status_Code__c = payment.StatusCode;
                        transactionEntity.Tax__c = payment.Tax;
                        transactionEntity.Result_Code__c = payment.ResultCode;
                        transactionEntity.Result__c = payment.Result;
                        transactionEntity.Error__c = payment.Error;
                        transactionEntity.Error_Code__c = payment.ErrorCode;
                        transactionEntity.Card_Type__c = payment.CardType;
                        transactionEntity.Invoice__c = payment.OrderNumber;
                        transactionEntity.EbizCharge_Terminal__c = payment.Terminal;
                        if (payment.NonTax != null) {
                            transactionEntity.Non_Tax__c = payment.NonTax;
                        }
                        transactionEntity.EbizCharge_Table__c = payment.Table;
                        transactionEntity.EBizCharge_Subtotal__c = payment.Subtotal;
                        transactionEntity.EbizCharge_Shipping__c = payment.Shipping;
                        transactionEntity.Ship_From_Zip__c = payment.ShipFromZip;
                        transactionEntity.PONum__c = payment.PONum;
                        transactionEntity.EbizCharge_Duty__c = payment.Duty;
                        transactionEntity.EbizCharge_Discount__c = payment.Discount;
                        transactionEntity.EbizCharge_Comments__c = payment.Comments;
                        transactionEntity.Description__c = payment.Description;
                        transactionEntity.EbizCharge_CurrencyX__c = payment.Currency_x;
                        transactionEntity.EbizCharge_Clerk__c = payment.Clerk;
                        transactionEntity.EbizCharge_Amount__c = payment.Amount;
                        if (payment.AllowPartialAuth != null) {
                            transactionEntity.EbizCharge_AllowPartialAuth__c = payment.AllowPartialAuth;
                        }
                        transactionEntity.EbizCharge_Tip__c = payment.Tip;
                        transactionEntity.Auth_Code__c = payment.AuthCode;
                        transactionEntity.Ref_Number__c = payment.RefNumber;
                        transactionEntity.Card_Number__c = payment.CardNumber;
                        transactionEntity.Payment_Method__c = payment.PayBy;
                        transactionEntity.CreatedDateTime__c = date.valueOf(payment.FormatedTransDate);
                        transactionEntity.Auth_Amount__c = payment.AuthAmount;
                        transactionEntity.Transaction_Type__c = payment.TransType;
                        transactionEntity.Remaining_Balance__c = payment.RemainingBalance;
                        if (payment.isDuplicate != null) {
                            transactionEntity.isDuplicate__c = payment.isDuplicate;
                        }
                        transactionEntity.EbizCharge_Converted_AmountCurrency__c = payment.ConvertedAmountCurrency;
                        transactionEntity.Converted_Amount__c = payment.ConvertedAmount;
                        transactionEntity.Conversion_Rate__c = payment.ConversionRate;
                        transactionEntity.Card_Code_Result_Code__c = payment.CardCodeResultCode;
                        transactionEntity.Card_Code_Result__c = payment.CardCodeResult;
                        transactionEntity.Batch_Ref_Number__c = payment.BatchRefNum;
                        transactionEntity.Batch_Number__c = payment.BatchNum;
                        transactionEntity.Avs_Result_Code__c = payment.AvsResultCode;
                        transactionEntity.Avs_Result__c = payment.AvsResult;
                        mapProductLog.put((Configuration.LOGMAPKEY + payment.RefNumber), payment);
                        transactions.add(transactionEntity);
                        ebcLogger.debug(ClassName, MethodName, '>>>transactions: ' + transactions);
                    }
                }
                try {
                    if (transactions.size() > 0) {
                        dml.upsertRecord(transactions);
                        settings.Ebizcharge_Transaction_Last_Sync_Date__c = System.now();
                        dml.updateRecord(settings);
                        returnMessage = string.valueOf(Enums.RETURNMESSAGE.Success);
                    }
                } catch (Exception e) {
                    ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
                    for (TransactionsWrapper payment: importPayments) {
                        mapProductLog.remove(Configuration.LOGMAPKEY + payment.RefNumber);
                        mapProductLog.put(e.getMessage(), payment);
                    }
                    returnMessage = string.valueOf(Enums.RETURNMESSAGE.Error);
                }
                if (mapProductLog.size() > 0) {
                    List < EBizCharge_Sync_Log__c > logs = new List < EBizCharge_Sync_Log__c > ();
                    integer Keycount = 0;
                    for (String key: mapProductLog.keyset()) {
                        EBizCharge_Sync_Log__c log = new EBizCharge_Sync_Log__c();
                        TransactionsWrapper payment = mapProductLog.get(key);
                        if (key == (Configuration.LOGMAPKEY + payment.RefNumber)) {
                            log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Imported);
                        } else {
                            log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Error);
                            log.Message__c = key;
                        }
                        log.Name = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Payment);
                        log.Type__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Download);
                        log.Order_Number__c = payment.OrderNumber;
                        log.RefNum__c = payment.RefNumber;
                        log.AuthCode__c = payment.AuthCode;
                        log.Account_Name__c = payment.AccountName;
                        log.DatePaid__c = dateTime.valueOf(payment.DateTime_x);
                        log.Amount__c = payment.AuthAmount;
                        log.PaymentMethod__c = payment.PayBy;
                        log.EBizCharge_Source__c = payment.Source;
                        logs.add(log);
                    }
                    if (!test.isRunningTest()) {
                        if (logs.size() > 0) {
                            dml.insertRecord(logs);
                        }
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnMessage;
    }
    @AuraEnabled
    public static List < TransactionsWrapper > getUpdatedPaymentsApxc(List < TransactionsWrapper > paymentList) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < TransactionsWrapper > reciprocate = getUpdatedPaymentsApxc(dml, paymentList, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < TransactionsWrapper > getUpdatedPaymentsApxc(DML dml, List < TransactionsWrapper > paymentList, EBC_Logger ebcLogger) {
        MethodName = 'getUpdatedPaymentsApxc';
        List < TransactionsWrapper > returnUpdatedPayments = new List < TransactionsWrapper > ();
        List < String > importPaymentInternalIds = new List < String > ();
        List < String > paymentSFInternalIds = new List < String > ();
        for (TransactionsWrapper payment: paymentList) {
            importPaymentInternalIds.add(payment.RefNumber);
        }
        ebcLogger.debug(ClassName, MethodName, '>>>importPaymentInternalIds: ' + importPaymentInternalIds);
        try {
            String querySelect = 'SELECT Id,Ref_Number__c';
            String queryFrom = 'FROM EBizCharge_Transaction__c';
            String queryWhere = 'where Ref_Number__c IN :';
            List < EBizCharge_Transaction__c > sfPayments = (List < EBizCharge_Transaction__c > ) dml.selectRecordsInList(importPaymentInternalIds, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            if (sfPayments != null) {
                for (EBizCharge_Transaction__c payment: sfPayments) {
                    paymentSFInternalIds.add(payment.Ref_Number__c);
                }
            }
            for (TransactionsWrapper payment: paymentList) {
                if (!paymentSFInternalIds.contains(payment.RefNumber)) {
                    returnUpdatedPayments.add(payment);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        ebcLogger.debug(ClassName, MethodName, '>>>returnUpdatedPayments: ' + returnUpdatedPayments);
        return returnUpdatedPayments;
    }
    @AuraEnabled
    public static List < TransactionsWrapper > findPaymentsApxc(String filters, String startLimit, String endLimit) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < TransactionsWrapper > reciprocate = findPaymentsApxc(dml, filters, startLimit, endLimit, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < TransactionsWrapper > findPaymentsApxc(DML dml, String filters, String startLimit, String endLimit, EBC_Logger ebcLogger) {
        String fromDate = Configuration.EMPTYSTRING;
        String toDate = Configuration.EMPTYSTRING;
        String fromDateForApi = Configuration.EMPTYSTRING;
        String toDateForApi = Configuration.EMPTYSTRING;
        if (!test.isRunningTest()) {
            Map < String, Object > filterMap = (Map < String, Object > ) JSON.deserializeUntyped(filters);
            fromDate = (String) filterMap.get(string.valueOf(Enums.FILTERJAVASCRIPTMAPSTRINGS.fromDate));
            if (fromDate != null) {
                Date fromDateEntity = Date.valueOf(fromDate);
                // fromDateEntity = fromDateEntity.AddDays(-1);
                fromDateForApi = String.valueOf(fromDateEntity);
            }
            toDate = (String) filterMap.get(string.valueOf(Enums.FILTERJAVASCRIPTMAPSTRINGS.toDate));
            if (toDate != null) {
                Date toDateEntity = Date.valueOf(toDate);
                toDateEntity = toDateEntity.AddDays(1);
                toDateForApi = String.valueOf(toDateEntity);
            }
        }
        if (test.isRunningTest()) {
            fromDate = null;
        }
        if (fromDate == null) {
            Datetime fromDateEntity = System.Today().AddDays(-13);
            fromDate = fromDateEntity.format(Configuration.DATEFORMAT);
            Datetime fromDateEntityApi = System.Today().AddDays(-14);
            fromDateForApi = fromDateEntityApi.format(Configuration.DATEFORMAT);
        }
        if (test.isRunningTest()) {
            toDate = null;
        }
        if (toDate == null) {
            DateTime datetimeEntity = system.Today().AddDays(1);
            toDate = datetimeEntity.format(Configuration.DATEFORMAT);
            DateTime datetimeEntityApi = system.Today().AddDays(2);
            toDateForApi = datetimeEntityApi.format(Configuration.DATEFORMAT);
        }
        Boolean matchAll = true;
        Boolean countOnly = false;
        List < TransactionsWrapper > returnTransaction = new List < TransactionsWrapper > ();
        List < String > paymentGWInternalIds = new List < String > ();
        List < String > paymentSFInternalIds = new List < String > ();
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
        ebizchargeServicemodelSoap.ArrayOfSearchFilter transactionFilter = new ebizchargeServicemodelSoap.ArrayOfSearchFilter();
        ebizchargeServicemodelSoap.SearchFilter filter = new ebizchargeServicemodelSoap.SearchFilter();
        List < ebizchargeServicemodelSoap.SearchFilter > transactionSearchFilter = new List < ebizchargeServicemodelSoap.SearchFilter > ();
        ebizchargeServicemodelSoap.ArrayOfTransactionObject ebizTransaction;
        ebizchargeServicemodelSoap.TransactionSearchResult searchTransactionsResult = new ebizchargeServicemodelSoap.TransactionSearchResult();
        ebizchargeServicemodelSoap.TransactionObject[] ebizTransactions;
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.Created);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.gt);
        filter.FieldValue = fromDateForApi;
        transactionSearchFilter.add(filter);
        filter = new ebizchargeServicemodelSoap.SearchFilter();
        filter.FieldName = string.valueOf(Enums.FIELDNAMES.Created);
        filter.ComparisonOperator = string.valueOf(Enums.COMPARISONOPERATORS.lt);
        filter.FieldValue = toDateForApi;
        transactionSearchFilter.add(filter);
        transactionFilter.SearchFilter = transactionSearchFilter;
        try {
            if (!test.isRunningTest()) {
                searchTransactionsResult = ebiz.SearchTransactions(securityToken, transactionFilter, matchAll, countOnly, startLimit, endLimit, 'DateTime');
            }
            // Removing locally Imported REceivedPayments from Grid.........
            if (searchTransactionsResult.Transactions != null) {
                ebizTransaction = searchTransactionsResult.Transactions;
                if (ebizTransaction.TransactionObject != null) {
                    ebizTransactions = ebizTransaction.TransactionObject;
                    if (ebizTransactions != null) {
                        for (ebizchargeServicemodelSoap.TransactionObject transactionObject: ebizTransactions) {
                            if (transactionObject.Source != string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp)) {
                                ebizchargeServicemodelSoap.TransactionResponse ebizResponse = transactionObject.Response;
                                paymentGWInternalIds.add(ebizResponse.RefNum);
                            }
                        }
                        ebcLogger.debug(ClassName, MethodName, '>>>paymentGWInternalIds: ' + paymentGWInternalIds);
                        String querySelect = 'SELECT Id,Ref_Number__c';
                        String queryFrom = 'FROM EBizCharge_Transaction__c';
                        String queryWhere = 'where Ref_Number__c IN :';
                        List < EBizCharge_Transaction__c > sfPayments = (List < EBizCharge_Transaction__c > ) dml.selectRecordsInList(paymentGWInternalIds, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                        ebcLogger.debug(ClassName, MethodName, 'salesforce payments: ' + sfPayments);
                        if (sfPayments != null) {
                            for (EBizCharge_Transaction__c payment: sfPayments) {
                                paymentSFInternalIds.add(payment.Ref_Number__c);
                            }
                        }
                    }
                }
            }
            // Removing locally Imported REceivedPayments from Grid.........END HERE
            if (searchTransactionsResult.Transactions != null) {
                ebizTransaction = searchTransactionsResult.Transactions;
                if (ebizTransaction.TransactionObject != null) {
                    ebizTransactions = ebizTransaction.TransactionObject;
                    if (ebizTransactions != null) {
                        for (ebizchargeServicemodelSoap.TransactionObject ebizTransactionObject: ebizTransactions) {
                            if (ebizTransactionObject.Source != string.valueOf(Enums.ASSIGNMENTSTRINGS.SalesforceApp)) {
                                ebizchargeServicemodelSoap.TransactionResponse ebizResponse = ebizTransactionObject.Response;
                                if (ebizTransactionObject.CustomerID != null) {
                                    if (!paymentSFInternalIds.contains(ebizResponse.RefNum)) {
                                        TransactionsWrapper transactionEntity = new TransactionsWrapper();
                                        transactionEntity.Source = ebizTransactionObject.Source;
                                        transactionEntity.TransType = ebizTransactionObject.TransactionType;
                                        transactionEntity.CustomerId = ebizTransactionObject.CustomerID;
                                        transactionEntity.FormatedTransDate = ebizTransactionObject.DateTime_x;
                                        transactionEntity.DateTime_x = ebizTransactionObject.DateTime_x;
                                        String orderDate = ebizTransactionObject.DateTime_x;
                                        Datetime orderDateTime = Datetime.valueOf(orderDate.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
                                        transactionEntity.CreatedDate = orderDateTime;
                                        ebcLogger.debug(ClassName, MethodName, '>>>orerdDateTime: ' + orderDateTime);
                                        ebcLogger.debug(ClassName, MethodName, '>>>DateTime_x: ' + ebizTransactionObject.DateTime_x);
                                        transactionEntity.fromDate = (fromDate == Configuration.EMPTYSTRING ? null : date.valueOf(fromDate));
                                        transactionEntity.toDate = (toDate == Configuration.EMPTYSTRING ? null : date.valueOf(toDate));
                                        transactionEntity.AccountName = ebizTransactionObject.AccountHolder;
                                        ebizchargeServicemodelSoap.TransactionDetail transactionDetail = ebizTransactionObject.Details;
                                        transactionEntity.OrderNumber = transactionDetail.Invoice;
                                        transactionEntity.OrderId = transactionDetail.OrderID;
                                        transactionEntity.Tax = transactionDetail.Tax;
                                        transactionEntity.Terminal = transactionDetail.Terminal;
                                        transactionEntity.CustNum = ebizResponse.CustNum;
                                        transactionEntity.ResultCode = ebizResponse.ResultCode;
                                        transactionEntity.Result = ebizResponse.Result;
                                        transactionEntity.RefNumber = ebizResponse.RefNum;
                                        if (ebizResponse.Error != null) {
                                            transactionEntity.Error = ebizResponse.Error;
                                            transactionEntity.ErrorCode = ebizResponse.ErrorCode;
                                        }
                                        transactionEntity.AuthCode = ebizResponse.AuthCode;
                                        transactionEntity.AuthAmount = ebizResponse.AuthAmount;
                                        transactionEntity.Status = ebizResponse.Status;
                                        transactionEntity.StatusCode = ebizResponse.StatusCode;
                                        ebizchargeServicemodelSoap.CreditCardData creditCard = ebizTransactionObject.CreditCardData;
                                        if (creditCard.CardNumber != null) {
                                            transactionEntity.PayBy = string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard);
                                            transactionEntity.CardType = creditCard.CardType;
                                            transactionEntity.CardNumber = creditCard.CardNumber.right(4);
                                        }
                                        ebizchargeServicemodelSoap.CheckData chekData = ebizTransactionObject.CheckData;
                                        if (chekData.Account != null) {
                                            transactionEntity.PayBy = string.valueOf(Enums.PAYMENTMETHODSTRINGS.Check);
                                            transactionEntity.checkAccount = chekData.Account.right(4);
                                        }
                                        transactionEntity.isSelected = false;
                                        returnTransaction.add(transactionEntity);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnTransaction;
    }
    @AuraEnabled
    public static string importAccountApxc(List < AccountWrapper > accountlist) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = importAccountApxc(dml, accountlist, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string importAccountApxc(DML dml, List < AccountWrapper > accountlist, EBC_Logger ebcLogger) {
        MethodName = 'importAccountApxc';
        EBizcharge_Setting__c settings = eBc_UtilityController.getSettings(dml, ebcLogger);
        map < String, AccountWrapper > mapAccountLog = new map < string, AccountWrapper > ();
        string returnMessage = Configuration.EMPTYSTRING;
        integer count = 0;
        String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c';
        String queryFrom = 'FROM Account';
        List < Account > sfAccounts = (List < Account > ) dml.selectRecords(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        List < Account > accounts = new List < Account > ();
        if (accountlist != null) {
            for (AccountWrapper accountWrapper: accountlist) {
                Account account = new Account();
                if (accountWrapper.accName != Configuration.CUSTOMERNAMESEPERATOR) {
                    for (Account sfAcount: sfAccounts) {
                        if (sfAcount.EBizCharge_Internal_ID__c == accountWrapper.accExternalId) {
                            account.Id = sfAcount.Id;
                            break;
                        }
                    }
                    account.Name = accountWrapper.accName;
                    account.EBizCharge_Internal_ID__c = accountWrapper.accExternalId;
                    account.First_Name__c = accountWrapper.accFirstName;
                    account.Last_Name__c = accountWrapper.accLastName;
                    account.EBizCharge_Email__c = accountWrapper.accEmail;
                    account.Phone = accountWrapper.accPhone;
                    account.EBizCharge_Source__c = accountWrapper.accSource;
                    account.EBizCharge_Division_ID__c = accountWrapper.DivisionId;
                    account.EBizCharge_Last_Sync_Date__c = System.now() + (10 / 24 / 60);
                    if (accountWrapper.accDateTimeModified != null) {
                        account.EBizCharge_Last_Modified_Date__c = Datetime.valueOf(accountWrapper.accDateTimeModified);
                    }
                    mapAccountLog.put((Configuration.LOGMAPKEY + accountWrapper.accExternalId), accountWrapper);
                    accounts.add(account);
                }
            }
            try {
                if (accounts.size() > 0) {
                    dml.upsertRecord(accounts);
                    settings.Ebizcharge_Accounts_Last_Sync_Date__c = System.now();
                    dml.updateRecord(settings);
                    returnMessage = string.valueOf(Enums.RETURNMESSAGE.Success);
                }
            } catch (Exception e) {
                ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
                for (AccountWrapper accountWrapper: accountlist) {
                    mapAccountLog.remove(Configuration.LOGMAPKEY + accountWrapper.accExternalId);
                    mapAccountLog.put(e.getMessage(), accountWrapper);
                }
                returnMessage = string.valueOf(Enums.RETURNMESSAGE.Error);
            }
            if (mapAccountLog.size() > 0) {
                List < EBizCharge_Sync_Log__c > logs = new List < EBizCharge_Sync_Log__c > ();
                for (String key: mapAccountLog.keyset()) {
                    EBizCharge_Sync_Log__c log = new EBizCharge_Sync_Log__c();
                    AccountWrapper accountWrapper = mapAccountLog.get(key);
                    if (accountWrapper.accEmail == Configuration.GATEWAYACCOUNTEMAIL) {
                        accountWrapper.accEmail = Configuration.EMPTYSTRING;
                    }
                    if (key == (Configuration.LOGMAPKEY + accountWrapper.accExternalId)) {
                        log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Imported);
                    } else {
                        log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Error);
                        log.Message__c = key;
                    }
                    log.Name = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account);
                    log.Type__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Download);
                    log.Account_Name__c = accountWrapper.accName;
                    log.First_Name__c = accountWrapper.accFirstName;
                    log.Last_Name__c = accountWrapper.accLastName;
                    log.Email__c = accountWrapper.accEmail;
                    log.Phone__c = accountWrapper.accPhone;
                    log.Balance__c = accountWrapper.accAmount;
                    log.EBizCharge_Source__c = accountWrapper.accSource;
                    logs.add(log);
                }
                if (!test.isRunningTest()) {
                    if (logs.size() > 0) {
                        dml.insertRecord(logs);
                    }
                }
            }
        }
        return returnMessage;
    }
    @AuraEnabled
    public static string importProductApxc(List < ProductWrapper > productlist) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = importProductApxc(dml, productlist, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string importProductApxc(DML dml, List < ProductWrapper > productlist, EBC_Logger ebcLogger) {
        MethodName = 'importProductApxc';
        EBizcharge_Setting__c settings = eBc_UtilityController.getSettings(dml, ebcLogger);
        map < String, ProductWrapper > mapProductLog = new map < string, ProductWrapper > ();
        string returnMessage = Configuration.EMPTYSTRING;
        integer count = 0;
        String querySelect = 'SELECT Id,EBizCharge_Internal_ID__c';
        String queryFrom = 'FROM Product2';
        try {
            List < Product2 > sfProducts = (List < Product2 > ) dml.selectRecords(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            List < Product2 > products = new List < Product2 > ();
            if (productlist != null) {
                for (ProductWrapper productWrapper: productlist) {
                    Product2 product = new Product2();
                    if (productWrapper.prodName != Configuration.CUSTOMERNAMESEPERATOR) {
                        for (Product2 sfproduct: sfProducts) {
                            if (sfproduct.EBizCharge_Internal_ID__c == productWrapper.prodExternalId) {
                                product.Id = sfproduct.Id;
                                break;
                            }
                        }
                        product.Name = productWrapper.prodName;
                        product.EBizCharge_Internal_ID__c = productWrapper.prodExternalId;
                        product.ProductCode = productWrapper.prodCode;
                        product.Description = productWrapper.prodDescription;
                        product.EBizCharge_Last_Sync_Date__c = productWrapper.prodLastSync;
                        product.EBizCharge_Source__c = productWrapper.prodSoftware;
                        product.EBizCharge_Division_ID__c = productWrapper.DivisionId;
                        product.EBizCharge_Last_Sync_Date__c = System.now() + (10 / 24 / 60);
                        if (productWrapper.UpdatedDate != null) {
                            product.EBizCharge_Last_Modified_Date__c = Datetime.valueOf(productWrapper.UpdatedDate);
                        }
                        if (productWrapper.UnitOfMeasure != null && productWrapper.UnitOfMeasure != Configuration.EMPTYSTRING) {
                            product.EBizCharge_Unit_Of_Measure__c = productWrapper.UnitOfMeasure;
                        }
                        mapProductLog.put((Configuration.LOGMAPKEY + productWrapper.prodName), productWrapper);
                        products.add(product);
                    }
                }
                try {
                    if (products.size() > 0) {
                        dml.upsertRecord(products);
                        settings.Ebizcharge_Product_Last_Sync_Date__c = system.now();
                        dml.upsertRecord(settings);
                        returnMessage = string.valueOf(Enums.RETURNMESSAGE.Success);
                        assignPriceBookToProduct(dml, productlist, products, ebcLogger);
                    }
                } catch (Exception e) {
                    ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
                    for (ProductWrapper productWrapper: productlist) {
                        mapProductLog.remove(Configuration.LOGMAPKEY + productWrapper.prodName);
                        mapProductLog.put(e.getMessage(), productWrapper);
                    }
                    returnMessage = string.valueOf(Enums.RETURNMESSAGE.Error);
                }
                if (mapProductLog.size() > 0) {
                    List < EBizCharge_Sync_Log__c > logs = new List < EBizCharge_Sync_Log__c > ();
                    for (String key: mapProductLog.keyset()) {
                        EBizCharge_Sync_Log__c log = new EBizCharge_Sync_Log__c();
                        ProductWrapper productWrapper = mapProductLog.get(key);
                        if (key == (Configuration.LOGMAPKEY + productWrapper.prodName)) {
                            log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Imported);
                        } else {
                            log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Error);
                            log.Message__c = key;
                        }
                        log.Name = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Product);
                        log.Type__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Download);
                        log.Product_Name__c = productWrapper.prodName;
                        log.Quantity__c = productWrapper.prodQuantity;
                        log.Product_Code__c = productWrapper.prodCode;
                        log.Description__c = productWrapper.prodDescription;
                        log.Amount__c = productWrapper.prodPrice;
                        log.EBizCharge_Source__c = productWrapper.prodSoftware;
                        logs.add(log);
                    }
                    if (!test.isRunningTest()) {
                        if (logs.size() > 0) {
                            dml.insertRecord(logs);
                        }
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnMessage;
    }
    public static void assignPriceBookToProduct(DML dml, List < ProductWrapper > productlist, List < Product2 > prodList, EBC_Logger ebcLogger) {
        MethodName = 'assignPriceBookToProduct';
        List < PricebookEntry > pricebookEntryList = new List < PricebookEntry > ();
        List < ProductWrapper > updatedProdWrapperWithProdId = new List < ProductWrapper > ();
        String querySelect = 'SELECT Id,name';
        String queryFrom = 'FROM Pricebook2';
        String queryWhere = 'where name = \'Standard Price Book\'';
        List < Pricebook2 > priceBooks = (List < Pricebook2 > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
        querySelect = 'SELECT Id ,Product2Id, Pricebook2Id,UnitPrice,IsActive';
        queryFrom = 'FROM PricebookEntry';
        try {
            List < PricebookEntry > storedPricebookEntrylist = (List < PricebookEntry > ) dml.selectRecords(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            map < string, PricebookEntry > priceBookMap = new map < string, PricebookEntry > ();
            for (PricebookEntry pricebookEntry: storedPricebookEntrylist) {
                priceBookMap.put(pricebookEntry.Product2Id, pricebookEntry);
            }
            String standardPriceBoodId = Configuration.EMPTYSTRING;
            for (Pricebook2 priceBook: priceBooks) {
                standardPriceBoodId = priceBook.Id;
                ebcLogger.debug(ClassName, MethodName, 'standard Pricebook2 id' + standardPriceBoodId);
                break;
            }
            for (Product2 product: prodList) {
                for (ProductWrapper productWrapper: productlist) {
                    if (product.ProductCode == productWrapper.prodCode) {
                        productWrapper.Id = product.Id;
                        updatedProdWrapperWithProdId.add(productWrapper);
                        break;
                    }
                }
            }
            for (ProductWrapper productWrapper: updatedProdWrapperWithProdId) {
                if (!priceBookMap.containsKey(productWrapper.id)) {
                    PricebookEntry pricebookEntry = new PricebookEntry();
                    for (PricebookEntry pricebookEntryEntity: storedPricebookEntrylist) {
                        if (productWrapper.Id == pricebookEntryEntity.Product2Id) {
                            pricebookEntry.Id = pricebookEntryEntity.Id;
                            break;
                        }
                    }
                    pricebookEntry.Product2Id = productWrapper.Id;
                    pricebookEntry.Pricebook2Id = standardPriceBoodId;
                    pricebookEntry.UnitPrice = productWrapper.prodPrice;
                    pricebookEntry.IsActive = true;
                    pricebookEntryList.add(pricebookEntry);
                }
            }
            if (pricebookEntryList.size() > 0) {
                dml.upsertRecord(pricebookEntryList);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    @AuraEnabled
    public static string importOrderApxc(List < OrderWrapper > orderlist) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = importOrderApxc(dml, orderlist, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string importOrderApxc(DML dml, List < OrderWrapper > orderlist, EBC_Logger ebcLogger) {
        MethodName = 'importOrderApxc';
        EBizcharge_Setting__c settings = eBc_UtilityController.getSettings(dml, ebcLogger);
        String standardPriceBookId = Configuration.EMPTYSTRING;
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        ebizchargeServicemodelSoap.SecurityToken securityToken = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
        List < Product2 > productList = new List < Product2 > ();
        List < string > insertedProductsIds = new List < string > ();
        map < string, Decimal > itemsWithUnitPriceMap = new map < string, Decimal > ();
        List < PricebookEntry > priceBookList = new List < PricebookEntry > ();
        map < string, string > insertedPriceBooksMap = new map < string, string > ();
        map < string, ebizchargeServicemodelSoap.ArrayOfItemDetails > orderWithGWProducts = new map < string, ebizchargeServicemodelSoap.ArrayOfItemDetails > ();
        map < string, string > sfProductsInsertedIdsMap = new map < string, string > ();
        string returnMessage = Configuration.EMPTYSTRING;
        try {
            if (!test.isRunningTest()) {
                querySelect = 'SELECT Id,name';
                queryFrom = 'FROM Pricebook2';
                queryWhere = 'where name = \'Standard Price Book\'';
                List < Pricebook2 > priceBooks = (List < Pricebook2 > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                for (Pricebook2 priceBook: priceBooks) {
                    standardPriceBookId = priceBook.Id;
                    ebcLogger.debug(ClassName, MethodName, '>>>standardPriceBookId: ' + standardPriceBookId);
                    break;
                }
            }
            map < String, OrderWrapper > mapOrderLog = new map < string, OrderWrapper > ();
            map < String, List < OrderItem >> mapOrderItems = new map < string, List < OrderItem >> ();
            integer count = 0;
            integer startLimit = 0;
            integer endLimit = 1000;
            querySelect = 'SELECT Id,EBizCharge_Internal_ID__c';
            queryFrom = 'FROM Order';
            List < Order > sfOrders = (List < Order > ) dml.selectRecords(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
            List < Order > orders = new List < Order > ();
            List < OrderItem > orderItemList = new List < OrderItem > ();
            if (orderlist != null) {
                for (OrderWrapper order: orderlist) {
                    ebizchargeServicemodelSoap.Customer ebizCustomer = new ebizchargeServicemodelSoap.Customer();
                    ebizCustomer = EBC_CompMethods.invoke_SearchCustomer(dml, order.accId, ebcLogger);
                    Account account = new Account();
                    querySelect = 'SELECT Id,EBizCharge_Internal_ID__c';
                    queryFrom = 'FROM Account';
                    List < Account > sfAccounts = (List < Account > ) dml.selectRecords(querySelect, queryFrom, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                    for (Account sfAcount: sfAccounts) {
                        if (sfAcount.EBizCharge_Internal_ID__c == ebizCustomer.CustomerInternalId) {
                            account.Id = sfAcount.Id;
                            break;
                        }
                    }
                    if (account.Id == null) {
                        account.EBizCharge_Internal_ID__c = ebizCustomer.CustomerInternalId;
                        if (ebizCustomer.FirstName != Configuration.EMPTYSTRING || ebizCustomer.LastName != Configuration.EMPTYSTRING) {
                            account.Name = ebizCustomer.FirstName + Configuration.CUSTOMERNAMESEPERATOR + ebizCustomer.LastName;
                        } else {
                            account.Name = 'Account' + ebizCustomer.CustomerInternalId;
                        }
                        account.Phone = ebizCustomer.Phone;
                        account.First_Name__c = ebizCustomer.FirstName;
                        account.Last_Name__c = ebizCustomer.LastName;
                        account.EBizCharge_Email__c = ebizCustomer.Email;
                        account.EBizCharge_Amount__c = 0;
                        dml.insertRecord(account);
                    }
                    Order orderEntity = new Order();
                    for (Order sfOrder: sfOrders) {
                        if (sfOrder.EBizCharge_Internal_ID__c == order.EBizChargeId) {
                            orderEntity.Id = sfOrder.Id;
                            break;
                        }
                    }
                    orderEntity.AccountId = account.Id;
                    orderEntity.EBizCharge_Order_Number__c = order.OrderNumber;
                    orderEntity.EBizCharge_Internal_ID__c = order.EBizChargeId;
                    orderEntity.EBizCharge_Amount__c = order.TotalAmount;
                    orderEntity.EffectiveDate = Date.valueOf(order.CreatedDate);
                    orderEntity.Status = string.valueOf(Enums.ORDERSTATUS.Draft);
                    orderEntity.PoNumber = order.PoNumber;
                    orderEntity.EBizCharge_Source__c = order.Portal;
                    orderEntity.EBizCharge_Division_ID__c = order.DivisionId;
                    orderEntity.EBizCharge_Last_Sync_Date__c = System.now() + (10 / 24 / 60);
                    if (order.UpdatedDate != null) {
                        orderEntity.EBizCharge_Last_Modified_Date__c = Datetime.valueOf(order.UpdatedDate);
                    }
                    orderEntity.Pricebook2Id = standardPriceBookId;
                    if (order.OrditemsList != null) {
                        mapOrderItems.put(order.EBizChargeId, order.OrditemsList);
                    }
                    mapOrderLog.put((Configuration.LOGMAPKEY + order.OrderNumber), order);
                    orders.add(orderEntity);
                }
                try {
                    if (orders.size() > 0) {
                        for (Order sfOrder: orders) {
                            List < OrderItem > items = mapOrderItems.get(sfOrder.EBizCharge_Internal_ID__c);
                            if (items != null) {
                                for (OrderItem itm: items) {
                                    String orderItmId = itm.EBizCharge_OrderItem_ID__c;
                                    itm.EBizCharge_OrderItem_ID__c = orderItmId.trim();
                                    ebizchargeServicemodelSoap.ArrayOfItemDetails arrofResponse = new ebizchargeServicemodelSoap.ArrayOfItemDetails();
                                    arrofResponse = ebiz.SearchItems(securityToken, Configuration.EMPTYSTRING, itm.EBizCharge_OrderItem_ID__c, null, startLimit, endLimit, Configuration.EMPTYSTRING);
                                    if (arrofResponse != null) {
                                        orderWithGWProducts.put(itm.EBizCharge_OrderItem_ID__c, arrofResponse);
                                    }
                                }
                                ebcLogger.debug(ClassName, MethodName, '>>>orderWithGWProducts: ' + orderWithGWProducts);
                            }
                        }
                        dml.upsertRecord(orders);
                        settings.Ebizcharge_Orders_Last_Sync_Date__c = system.now();
                        dml.upsertRecord(settings);
                        List < String > orderItemsId = new List < String > ();
                        for (String orderItemId: mapOrderItems.keyset()) {
                            orderItemsId.add(orderItemId);
                        }
                        querySelect = 'SELECT Id,EBizCharge_Internal_ID__c';
                        queryFrom = 'FROM Order';
                        queryWhere = 'WHERE EBizCharge_Internal_ID__c IN :';
                        List < Order > sfOrdersList = (List < Order > ) dml.selectRecordsInList(orderItemsId, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                        querySelect = 'SELECT Id,ProductCode';
                        queryFrom = 'FROM Product2';
                        queryWhere = Configuration.EMPTYSTRING;
                        List < Product2 > sfProductsList = (List < Product2 > ) dml.selectRecordsInList(null, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                        map < String, String > mapProducts = new map < string, String > ();
                        for (product2 product: sfProductsList) {
                            mapProducts.put(product.ProductCode, product.id);
                        }
                        ebcLogger.debug(ClassName, MethodName, '>>>mapProducts: ' + mapProducts);
                        map < String, String > mapPricebook = new map < string, String > ();
                        querySelect = 'SELECT Id,Product2Id';
                        queryFrom = 'FROM PricebookEntry';
                        queryWhere = 'WHERE Product2Id IN :';
                        List < PricebookEntry > sfPriceBookEntryList = (List < PricebookEntry > ) dml.selectRecordsInList(mapProducts.values(), querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                        for (PricebookEntry pricebookEntry: sfPriceBookEntryList) {
                            mapPricebook.put(pricebookEntry.Product2Id, pricebookEntry.id);
                        }
                        for (Order sfOrder: sfOrdersList) {
                            List < OrderItem > items = mapOrderItems.get(sfOrder.EBizCharge_Internal_ID__c);
                            ebcLogger.debug(ClassName, MethodName, '>>>items: ' + items);
                            if (items != null) {
                                for (OrderItem orderItem: items) {
                                    String orderItmId = orderItem.EBizCharge_OrderItem_ID__c;
                                    orderItem.EBizCharge_OrderItem_ID__c = orderItmId.trim();
                                    orderItem.OrderId = sfOrder.Id;
                                    if (mapProducts.containsKey(orderItem.EBizCharge_OrderItem_ID__c)) {
                                        ebcLogger.debug(ClassName, MethodName, '>>>product exists in salesforce ');
                                        string requiredProductId = mapProducts.get(orderItem.EBizCharge_OrderItem_ID__c);
                                        orderItem.PricebookEntryId = mapPricebook.get(requiredProductId);
                                        orderItem.Product2id = requiredProductId;
                                        orderItemList.add(orderItem);
                                    } else {
                                        ebizchargeServicemodelSoap.ArrayOfItemDetails itemsResponse = new ebizchargeServicemodelSoap.ArrayOfItemDetails();
                                        itemsResponse = orderWithGWProducts.get(orderItem.EBizCharge_OrderItem_ID__c);
                                        ebcLogger.debug(ClassName, MethodName, '>>>itemsResponse: ' + itemsResponse);
                                        if (itemsResponse != null && itemsResponse.ItemDetails != null) {
                                            ebcLogger.debug(ClassName, MethodName, '>>>order has items on gateway ');
                                            for (ebizchargeServicemodelSoap.ItemDetails itmDetails: itemsResponse.ItemDetails) {
                                                Product2 product = new Product2();
                                                product.ProductCode = itmDetails.ItemId;
                                                insertedProductsIds.add(product.ProductCode);
                                                itemsWithUnitPriceMap.put(product.ProductCode, itmDetails.UnitPrice);
                                                product.Ebiz_C__EBizCharge_Unit_Of_Measure__c = itmDetails.UnitOfMeasure;
                                                product.EBizCharge_Division_ID__c = itmDetails.DivisionId;
                                                product.Ebiz_C__EBizCharge_Internal_ID__c = itmDetails.ItemInternalId;
                                                product.Name = itmDetails.Name;
                                                product.Ebiz_C__EBizCharge_Last_Sync_Date__c = System.now() + (10 / 24 / 60);
                                                product.Description = itmDetails.Description;
                                                product.Ebiz_C__EBizCharge_Source__c = itmDetails.SoftwareId;
                                                productList.add(product);
                                            }
                                            ebcLogger.debug(ClassName, MethodName, '>>>sfProductsInsertedIdsMap: ' + itemsWithUnitPriceMap);
                                            ebcLogger.debug(ClassName, MethodName, '>>>insertedProductsIds: ' + insertedProductsIds);
                                            try {
                                                ebcLogger.debug(ClassName, MethodName, '>>>productList: ' + productList);
                                                dml.upsertRecord(productList);
                                            } catch (Exception e) {
                                                ebcLogger.debug(ClassName, MethodName, '>>>Error in inserting product');
                                                ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
                                            }
                                            ebcLogger.debug(ClassName, MethodName, '>>>continue');
                                            querySelect = 'SELECT Id,ProductCode';
                                            queryFrom = 'FROM Product2';
                                            queryWhere = 'WHERE ProductCode IN : ';
                                            List < Product2 > sfProductsInsertedList = (List < Product2 > ) dml.selectRecordsInList(insertedProductsIds, querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                                            for (product2 product: sfProductsInsertedList) {
                                                priceBookEntry pricebookEntry = new priceBookEntry();
                                                pricebookEntry.UnitPrice = itemsWithUnitPriceMap.get(product.ProductCode);
                                                pricebookEntry.Product2Id = product.Id;
                                                pricebookEntry.Pricebook2Id = standardPriceBookId;
                                                pricebookEntry.IsActive = true;
                                                pricebookEntry.UseStandardPrice = false;
                                                priceBookList.add(pricebookEntry);
                                                sfProductsInsertedIdsMap.put(product.ProductCode, product.id);
                                            }
                                            try {
                                                ebcLogger.debug(ClassName, MethodName, '>>>sfProductsInsertedIdsMap: ' + sfProductsInsertedIdsMap);
                                                ebcLogger.debug(ClassName, MethodName, '>>>priceBookList: ' + priceBookList);
                                                dml.upsertRecord(priceBookList);
                                            } catch (Exception e) {}
                                            querySelect = 'SELECT Id,Product2Id';
                                            queryFrom = 'FROM priceBookEntry';
                                            queryWhere = 'WHERE Product2Id IN : ';
                                            List < priceBookEntry > sfPriceBooksInsertedList = (List < priceBookEntry > ) dml.selectRecordsInList(sfProductsInsertedIdsMap.values(), querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING);
                                            for (priceBookEntry insertedPriceBookEntry: sfPriceBooksInsertedList) {
                                                insertedPriceBooksMap.put(insertedPriceBookEntry.Product2Id, insertedPriceBookEntry.id);
                                            }
                                            string requiredProductId = sfProductsInsertedIdsMap.get(orderItem.EBizCharge_OrderItem_ID__c);
                                            orderItem.PricebookEntryId = insertedPriceBooksMap.get(requiredProductId);
                                            orderItem.Product2id = requiredProductId;
                                            orderItemList.add(orderItem);
                                        }
                                    }
                                }
                            }
                        }
                        if (orderItemList.size() > 0) {
                            insert orderItemList;
                        }
                        returnMessage = string.valueOf(Enums.RETURNMESSAGE.Success);
                    }
                } catch (Exception e) {
                    ebcLogger.debug(ClassName, MethodName, '>>>Error has been occured ');
                    ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
                    for (OrderWrapper order: orderlist) {
                        mapOrderLog.remove(Configuration.LOGMAPKEY + order.OrderNumber);
                        mapOrderLog.put(e.getMessage(), order);
                    }
                    returnMessage = string.valueOf(Enums.RETURNMESSAGE.Error);
                }
                if (mapOrderLog.size() > 0) {
                    List < EBizCharge_Sync_Log__c > logs = new List < EBizCharge_Sync_Log__c > ();
                    for (String key: mapOrderLog.keyset()) {
                        EBizCharge_Sync_Log__c log = new EBizCharge_Sync_Log__c();
                        OrderWrapper order = mapOrderLog.get(key);
                        if (key == (Configuration.LOGMAPKEY + order.OrderNumber)) {
                            log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Imported);
                        } else {
                            log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Error);
                            log.Message__c = key;
                        }
                        log.Name = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order);
                        log.Type__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Download);
                        log.Account_Name__c = order.accName;
                        log.Balance__c = order.AmountDue;
                        log.Order_Number__c = order.OrderNumber;
                        log.Amount__c = order.AmountPaid;
                        log.EBizCharge_Source__c = order.Portal;
                        logs.add(log);
                    }
                    if (!test.isRunningTest()) {
                        if (logs.size() > 0) {
                            dml.insertRecord(logs);
                        }
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnMessage;
    }
    @AuraEnabled
    public static List < downloadLog > getLogApxc(String logname) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < downloadLog > reciprocate = getLogApxc(dml, logname, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < downloadLog > getLogApxc(DML dml, String logname, EBC_Logger ebcLogger) {
        MethodName = 'getLogApxc';
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        String query_orderby = Configuration.EMPTYSTRING;
        String queryLimit = Configuration.EMPTYSTRING;
        List < downloadLog > returnLog = new List < downloadLog > ();
        querySelect = 'SELECT Id,Name,CreatedDate,Account_Id__c,Account_Name__c,Amount__c,Balance__c,First_Name__c,Last_Name__c,' +
            'Email__c,Message__c,Order_Date__c,Order_Id__c,Order_Number__c,Phone__c,Product_Id__c,Product_Code__c,Product_Name__c,' +
            'Quantity__c,Status__c,Type__c,Upload_Date_Time__c,Description__c,RefNum__c,AuthCode__c,' +
            'DatePaid__c,PaymentMethod__c,EBizCharge_Source__c,EBizCharge_Order_Type__c';
        queryFrom = 'FROM EBizCharge_Sync_Log__c';
        queryWhere = 'WHERE Name =\'' + String.escapeSingleQuotes(logname) + '\' AND Type__c = \'Download\'';
        query_orderby = 'order by CreatedDate DESC';
        queryLimit = 'limit 49000';
        try {
            List < EBizCharge_Sync_Log__c > logs = (List < EBizCharge_Sync_Log__c > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, query_orderby, queryLimit);
            for (EBizCharge_Sync_Log__c log: logs) {
                downloadLog logEntity = new downloadLog();
                logEntity.Id = log.Id;
                logEntity.Name = log.Name;
                logEntity.accId = log.Account_Id__c;
                logEntity.accName = log.Account_Name__c;
                logEntity.amount = log.Amount__c;
                logEntity.balance = log.Balance__c;
                logEntity.email = log.Email__c;
                logEntity.firstName = log.First_Name__c;
                logEntity.lastName = log.Last_Name__c;
                logEntity.message = log.Message__c;
                logEntity.orderId = log.Order_Id__c;
                logEntity.ordNumber = log.Order_Number__c;
                logEntity.ordDate = log.Order_Date__c;
                logEntity.Phone = log.Phone__c;
                logEntity.prodId = log.Product_Id__c;
                logEntity.prodCode = log.Product_Code__c;
                logEntity.prodName = log.Product_Name__c;
                logEntity.description = log.Description__c;
                logEntity.quantity = Integer.valueOf(log.Quantity__c);
                logEntity.status = log.Status__c;
                logEntity.Type = log.Type__c;
                logEntity.orderType = log.EBizCharge_Order_Type__c;
                logEntity.uploadDate = log.Upload_Date_Time__c;
                logEntity.isSelected = false;
                logEntity.InvoiceNumber = log.Order_Number__c;
                logEntity.RefNum = log.RefNum__c;
                logEntity.AuthCode = log.AuthCode__c;
                logEntity.CustNum = log.Account_Name__c;
                logEntity.DatePaid = log.DatePaid__c;
                logEntity.PaidAmount = log.Amount__c;
                logEntity.Source = log.EBizCharge_Source__c;
                logEntity.PaymentMethod = log.PaymentMethod__c;
                logEntity.Last4 = log.Order_Number__c;
                returnLog.add(logEntity);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnLog;
    }
    @AuraEnabled
    public static string clearLogApxc(String logname) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = clearLogApxc(dml, logname, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string clearLogApxc(DML dml, String logname, EBC_Logger ebcLogger) {
        MethodName = 'clearLogApxc';
        String querySelect = 'SELECT Id';
        String queryFrom = 'FROM EBizCharge_Sync_Log__c';
        String queryWhere = 'where Name =\'' + String.escapeSingleQuotes(logname) + '\' AND Type__c = \'Download\'';
        String queryLimit = 'limit 1';
        try {
            if (Schema.sObjectType.Ebiz_C__EBizCharge_Sync_Log__c.isAccessible() && Schema.sObjectType.Ebiz_C__EBizCharge_Sync_Log__c.isDeletable()) {
                dml.deleteRecord(dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, queryLimit));
            }
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    public class OrderWrapper {
        @AuraEnabled public String Id {
            get;
            set;
        }
        @AuraEnabled public String OrderNumber {
            get;
            set;
        }
        @AuraEnabled public Datetime CreatedDate {
            get;
            set;
        }
        @AuraEnabled public Datetime UpdatedDate {
            get;
            set;
        }
        @AuraEnabled public Date EndDate {
            get;
            set;
        }
        @AuraEnabled public String EBizChargeId {
            get;
            set;
        }
        @AuraEnabled public String DivisionId {
            get;
            set;
        }
        @AuraEnabled public String PoNumber {
            get;
            set;
        }
        @AuraEnabled public String accId {
            get;
            set;
        }
        @AuraEnabled public String accExternalId {
            get;
            set;
        }
        @AuraEnabled public String accName {
            get;
            set;
        }
        @AuraEnabled public String accEmail {
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
        @AuraEnabled public double AmountPaid {
            get;
            set;
        }
        @AuraEnabled public string DatePaid {
            get;
            set;
        }
        @AuraEnabled public String Type {
            get;
            set;
        }
        @AuraEnabled public Date EffectiveDate {
            get;
            set;
        }
        @AuraEnabled public String Status {
            get;
            set;
        }
        @AuraEnabled public String Portal {
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
        @AuraEnabled public double EBizChargePaymentStatus {
            get;
            set;
        }
        @AuraEnabled public List < OrderItem > OrditemsList {
            get;
            set;
        }
        @AuraEnabled public Date fromDate {
            get;
            set;
        }
        @AuraEnabled public Date toDate {
            get;
            set;
        }
        @AuraEnabled public List < TransactionsWrapper > OrderPayments {
            get;
            set;
        }
    }
    public class AccountWrapper {
        @AuraEnabled public String Id {
            get;
            set;
        }
        @AuraEnabled public String accName {
            get;
            set;
        }
        @AuraEnabled public String HyperUrlAccount {
            get;
            set;
        }
        @AuraEnabled public String DivisionId {
            get;
            set;
        }
        @AuraEnabled public String accExternalId {
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
        @AuraEnabled public String accEmail {
            get;
            set;
        }
        @AuraEnabled public String accSource {
            get;
            set;
        }
        @AuraEnabled public String accPhone {
            get;
            set;
        }
        @AuraEnabled public Double accAmount {
            get;
            set;
        }
        @AuraEnabled public DateTime accLastSync {
            get;
            set;
        }
        @AuraEnabled public DateTime accDateTimeModified {
            get;
            set;
        }
        @AuraEnabled public DateTime accDateTimeCreated {
            get;
            set;
        }
        @AuraEnabled public boolean isImported {
            get;
            set;
        }
    }
    public class AccountsData {
        @AuraEnabled public Date fromDate {
            get;
            set;
        }
        @AuraEnabled public Date toDate {
            get;
            set;
        }
        @AuraEnabled public List < AccountWrapper > AccountsList {
            get;
            set;
        }
    }
    public class ProductWrapper {
        @AuraEnabled public String Id {
            get;
            set;
        }
        @AuraEnabled public String prodExternalId {
            get;
            set;
        }
        @AuraEnabled public String DivisionId {
            get;
            set;
        }
        @AuraEnabled public String prodCode {
            get;
            set;
        }
        @AuraEnabled public Datetime UpdatedDate {
            get;
            set;
        }
        @AuraEnabled public String prodName {
            get;
            set;
        }
        @AuraEnabled public Decimal prodPrice {
            get;
            set;
        }
        @AuraEnabled public Integer prodQuantity {
            get;
            set;
        }
        @AuraEnabled public String prodDescription {
            get;
            set;
        }
        @AuraEnabled public String prodSoftware {
            get;
            set;
        }
        @AuraEnabled public DateTime prodLastSync {
            get;
            set;
        }
        @AuraEnabled public boolean isSelected {
            get;
            set;
        }
        @AuraEnabled public Datetime FormatedTransDate {
            get;
            set;
        }
        @AuraEnabled public Datetime dateTimeTransaction {
            get;
            set;
        }
        @AuraEnabled public Date fromDate {
            get;
            set;
        }
        @AuraEnabled public Date toDate {
            get;
            set;
        }
        @AuraEnabled public String UnitOfMeasure {
            get;
            set;
        }
    }
    // added by @saud against Received Payments - (25March21) - start
    public class TransactionsWrapper {
        @AuraEnabled public String RefNumber {
            get;
            set;
        }
        @AuraEnabled public String PaymentMethod {
            get;
            set;
        }
        @AuraEnabled public String CardClass {
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
        @AuraEnabled public string TransDate {
            get;
            set;
        }
        @AuraEnabled public string FormatedTransDate {
            get;
            set;
        }
        @AuraEnabled public string TransTime {
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
        @AuraEnabled public Datetime CreatedDate {
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
        @AuraEnabled public Date fromDate {
            get;
            set;
        }
        @AuraEnabled public Date toDate {
            get;
            set;
        }
        @AuraEnabled public Double RemainingBalance {
            get;
            set;
        }
        @AuraEnabled public Boolean isDuplicate {
            get;
            set;
        }
        @AuraEnabled public Double ConvertedAmount {
            get;
            set;
        }
        @AuraEnabled public String ConvertedAmountCurrency {
            get;
            set;
        }
        @AuraEnabled public Double ConversionRate {
            get;
            set;
        }
        @AuraEnabled public String CardCodeResultCode {
            get;
            set;
        }
        @AuraEnabled public String CardCodeResult {
            get;
            set;
        }
        @AuraEnabled public String BatchRefNum {
            get;
            set;
        }
        @AuraEnabled public String BatchNum {
            get;
            set;
        }
        @AuraEnabled public String AvsResultCode {
            get;
            set;
        }
        @AuraEnabled public String AvsResult {
            get;
            set;
        }
        @AuraEnabled public Boolean NonTax {
            get;
            set;
        }
        @AuraEnabled public String Table {
            get;
            set;
        }
        @AuraEnabled public Double Subtotal {
            get;
            set;
        }
        @AuraEnabled public Double Shipping {
            get;
            set;
        }
        @AuraEnabled public String ShipFromZip {
            get;
            set;
        }
        @AuraEnabled public String PONum {
            get;
            set;
        }
        @AuraEnabled public Double Duty {
            get;
            set;
        }
        @AuraEnabled public Double Discount {
            get;
            set;
        }
        @AuraEnabled public String Comments {
            get;
            set;
        }
        @AuraEnabled public String Description {
            get;
            set;
        }
        @AuraEnabled public String Currency_x {
            get;
            set;
        }
        @AuraEnabled public String Clerk {
            get;
            set;
        }
        @AuraEnabled public Double Amount {
            get;
            set;
        }
        @AuraEnabled public Boolean AllowPartialAuth {
            get;
            set;
        }
        @AuraEnabled public Double Tip {
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
    public class PaymentWrapper {
        @AuraEnabled public String CustomerId {
            get;
            set;
        }
        @AuraEnabled public String CustomerName {
            get;
            set;
        }
        @AuraEnabled public String InvoiceNumber {
            get;
            set;
        }
        @AuraEnabled public String InvoiceInternalId {
            get;
            set;
        }
        @AuraEnabled public Date InvoiceDate {
            get;
            set;
        }
        @AuraEnabled public Date InvoiceDueDate {
            get;
            set;
        }
        @AuraEnabled public String PoNum {
            get;
            set;
        }
        @AuraEnabled public String InvoiceAmount {
            get;
            set;
        }
        @AuraEnabled public String AmountDue {
            get;
            set;
        }
        @AuraEnabled public String AuthCode {
            get;
            set;
        }
        @AuraEnabled public String RefNum {
            get;
            set;
        }
        @AuraEnabled public String Last4 {
            get;
            set;
        }
        @AuraEnabled public String PaymentMethod {
            get;
            set;
        }
        @AuraEnabled public DateTime DatePaid {
            get;
            set;
        }
        @AuraEnabled public String PaidAmount {
            get;
            set;
        }
        @AuraEnabled public String PaymentInternalId {
            get;
            set;
        }
        @AuraEnabled public String CustNum {
            get;
            set;
        }
        @AuraEnabled public String PaymentMethodId {
            get;
            set;
        }
        @AuraEnabled public String PaymentType {
            get;
            set;
        }
        @AuraEnabled public String TypeId {
            get;
            set;
        }
        @AuraEnabled public boolean isSelected {
            get;
            set;
        }
    }
    public class downloadLog {
        @AuraEnabled public String Id {
            get;
            set;
        }
        @AuraEnabled public String Name {
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
        @AuraEnabled public Decimal amount {
            get;
            set;
        }
        @AuraEnabled public Decimal balance {
            get;
            set;
        }
        @AuraEnabled public String email {
            get;
            set;
        }
        @AuraEnabled public String firstName {
            get;
            set;
        }
        @AuraEnabled public String lastName {
            get;
            set;
        }
        @AuraEnabled public String message {
            get;
            set;
        }
        @AuraEnabled public String Source {
            get;
            set;
        }
        @AuraEnabled public String orderId {
            get;
            set;
        }
        @AuraEnabled public String ordNumber {
            get;
            set;
        }
        @AuraEnabled public DateTime ordDate {
            get;
            set;
        }
        @AuraEnabled public String Phone {
            get;
            set;
        }
        @AuraEnabled public String prodId {
            get;
            set;
        }
        @AuraEnabled public String prodCode {
            get;
            set;
        }
        @AuraEnabled public String prodName {
            get;
            set;
        }
        @AuraEnabled public String description {
            get;
            set;
        }
        @AuraEnabled public Integer quantity {
            get;
            set;
        }
        @AuraEnabled public String status {
            get;
            set;
        }
        @AuraEnabled public String Type {
            get;
            set;
        }
        @AuraEnabled public String orderType {
            get;
            set;
        }
        @AuraEnabled public DateTime uploadDate {
            get;
            set;
        }
        @AuraEnabled public boolean isSelected {
            get;
            set;
        }
        @AuraEnabled public String InvoiceNumber {
            get;
            set;
        }
        @AuraEnabled public String RefNum {
            get;
            set;
        }
        @AuraEnabled public String AuthCode {
            get;
            set;
        }
        @AuraEnabled public String CustNum {
            get;
            set;
        }
        @AuraEnabled public DateTime DatePaid {
            get;
            set;
        }
        @AuraEnabled public Decimal PaidAmount {
            get;
            set;
        }
        @AuraEnabled public String PaymentMethod {
            get;
            set;
        }
        @AuraEnabled public String Last4 {
            get;
            set;
        }
    }
}