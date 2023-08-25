public with sharing class eBc_SyncUploadController {
    public static string ClassName = 'eBc_SyncUploadController';
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
        try {
            return eBc_UtilityController.getSettings(dml, ebcLogger);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return null;
        }
    }
    @AuraEnabled
    public static syncWrapper getAllOrdersApxc(String AccountId, String OrderId, Date fromDate, Date toDate) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        syncWrapper reciprocate = getAllOrdersApxc(dml, AccountId, OrderId, fromDate, toDate, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static syncWrapper getAllOrdersApxc(DML dml, String AccountId, String OrderId, Date fromDate, Date toDate, EBC_Logger ebcLogger) {
        MethodName = 'getAllOrdersApxc';
        List < OrderWrapper > ordList = new List < OrderWrapper > ();
        List < Order > recList = new List < Order > ();
        syncWrapper retobj = new syncWrapper();
        Date fDate = null;
        Date tDate = null;
        // Datetime currentDatetime = DateTime.now();
        // Datetime formattedFromDate = null;
        // Datetime formattedLastDate = null;
        if (fromDate != null && toDate != null) {
            fDate = fromDate;
            tDate = toDate;
            // formattedFromDate = DateTime.newInstanceGMT(fromDate, currentDatetime.time());
            // formattedLastDate = DateTime.newInstanceGMT(toDate, currentDatetime.time());
            fromDate = fromDate;
            toDate = toDate.addDays(1);
        }
        try {
            String Fields = Configuration.EMPTYSTRING;
            String Condition = Configuration.EMPTYSTRING;
            Fields += 'Name,OrderNumber,TotalAmount,Ebiz_C__EBizCharge_Order_Balance__c	,CreatedDate,EndDate,EffectiveDate,Status,EBizCharge_Internal_ID__c,';
            Fields += 'AccountId,Account.Name,Account.Email__c,Account.EBizCharge_Email__c,Account.EBizCharge_Internal_ID__c,';
            Fields += 'EBizCharge_Last_Sync_Date__c,LastModifiedDate';
            if (AccountId != null && OrderId != null && fromDate != null && toDate != null) {
                Condition = ' AND ( AccountId = \'' + AccountId + '\' AND Id = \'' + OrderId + '\' ' +
                    'AND ((CreatedDate >= ' + ((Datetime) fromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' ' +
                    'AND CreatedDate < ' + ((Datetime) toDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                    'OR (LastModifiedDate >= ' + ((Datetime) fromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' ' +
                    'AND LastModifiedDate < ' + ((Datetime) toDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ) )';
            } else if (AccountId != null && fromDate != null && toDate != null) {
                Condition = ' AND ( AccountId = \'' + AccountId + '\' AND ((CreatedDate >= ' + ((Datetime) fromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) toDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                    'OR (LastModifiedDate >= ' + ((Datetime) fromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) toDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ) )';
            } else if (OrderId != null && fromDate != null && toDate != null) {
                Condition = ' AND ( Id = \'' + OrderId + '\' AND ((CreatedDate >= ' + ((Datetime) fromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) toDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                    'OR (LastModifiedDate >= ' + ((Datetime) fromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) toDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ))';
            } else if (fromDate != null && toDate != null) {
                Condition = ' AND ( (CreatedDate >= ' + ((Datetime) fromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) toDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                    'OR (LastModifiedDate >= ' + ((Datetime) fromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) toDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
            } else if (AccountId != null && OrderId != null) {
                Condition = ' AND ( AccountId = \'' + AccountId + '\' AND Id = \'' + OrderId + '\')';
            } else if (AccountId != null) {
                Condition = ' AND ( AccountId = \'' + AccountId + '\')';
            } else if (OrderId != null) {
                Condition = ' AND ( Id = \'' + OrderId + '\')';
            } else {
                Condition = Configuration.EMPTYSTRING;
                Datetime dt = null;
                Datetime formattedFromDate = null;
                Datetime formattedLastDate = null;
                EBizcharge_Setting__c st = eBc_UtilityController.getSettings(dml, ebcLogger);
                if (st.Sync_Orders_Filter_By__c != null) {
                    String FilterBy = st.Sync_Orders_Filter_By__c;
                    if (FilterBy == string.valueOf(Enums.FILTERBY.Today)) {
                        dt = System.today();
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ( (CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                        'OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    } else if (FilterBy == Configuration.FILTERBYPASTWEEK) {
                        dt = System.Today() - 6;
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ( (CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                        'OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    } else if (FilterBy == Configuration.FILTERBYPASTMONTH) {
                        dt = system.Today() - 30;
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ( (CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                        'OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    } else if (FilterBy == Configuration.FILTERBYPASTYEAR) {
                        dt = System.Today() - 364;
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ( (CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                        'OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    }
                } else {
                    dt = System.today() - 30;
                    formattedFromDate = dt;
                    formattedLastDate = System.Today().addDays(1);
                    Condition = ' AND ( (CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                    'OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                }
                fDate = date.valueOf(dt);
                tDate = system.today().addDays(1);
            }
            String querySelect = 'SELECT Id, ' + Fields + ', (SELECT Id,product2Id,product2.Name,product2.ProductCode,UnitPrice,Quantity,OrderId,Product2.Description,Product2.EBizCharge_Internal_ID__c FROM OrderItems)';
            String queryFrom = 'FROM Order';
            String queryWhere = 'WHERE EBizCharge_Need_to_Sync__c = true ' + Condition + Configuration.EMPTYSTRING;
            String queryOrderBy = 'Order by CreatedDate DESC';
            String queryLimit = 'limit 25000';
            recList = (List < Order > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, queryOrderBy, queryLimit);
            map < string, list < OrderItem >> mapOrderitems = new map < string, list < OrderItem >> ();
            for (Order ord: recList) {
                DateTime lastModfiedDate = ord.LastModifiedDate;
                DateTime lastSyncDate = ord.EBizCharge_Last_Sync_Date__c;
                OrderWrapper obj = new OrderWrapper();
                obj.Id = ord.Id;
                obj.HyperUrlOrder = '/' + ord.Id;
                obj.HyperUrlAccount = '/' + ord.AccountId;
                obj.OrderNumber = ord.OrderNumber;
                obj.CreatedDate = ord.CreatedDate;
                obj.accId = ord.AccountId;
                obj.accExternalId = ord.Account.EBizCharge_Internal_ID__c;
                obj.accName = ord.Account.Name;
                obj.accEmail = ord.Account.Email__c;
                obj.TotalAmount = ord.TotalAmount;
                obj.EffectiveDate = ord.EffectiveDate;
                obj.Status = ord.Status;
                obj.EBizChargeId = ord.EBizCharge_Internal_ID__c;
                obj.Order_Balance = ord.Ebiz_C__EBizCharge_Order_Balance__c;
                obj.isSelected = false;
                obj.OrditemsList = ord.orderItems;
                ordList.add(obj);
            }
            retobj.OrdersList = ordList;
            retobj.fromDate = fDate;
            retobj.toDate = tDate;
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return retobj;
    }
    @AuraEnabled
    public static string syncOrdersGwApxc(list < OrderWrapper > selectedOrders) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = syncOrdersGwApxc(dml, selectedOrders, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string syncOrdersGwApxc(DML dml, list < OrderWrapper > selectedOrders, EBC_Logger ebcLogger) {
        MethodName = 'syncOrdersGwApxc';
        ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
        list < string > ordNos = new list < string > ();
        set < Id > prodIds = new set < Id > ();
        set < Id > accIds = new set < Id > ();
        try {
            for (OrderWrapper ord: selectedOrders) {
                accIds.add(ord.accId);
                ordNos.add(ord.OrderNumber);
                if (ord.OrditemsList != null) {
                    if (ord.OrditemsList.size() > 0) {
                        for (OrderItem oi: ord.OrditemsList) {
                            prodIds.add(oi.Product2Id);
                        }
                    }
                }
            }
            ebcLogger.debug(ClassName, MethodName, '>>>prodIds: ' + prodIds);
            ebizchargeServicemodelSoap.SecurityToken st = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
            List < Id > listaccIds = new List < Id > (accIds);
            list < Account > accList = eBc_UtilityController.getAccountsDetail(dml, listaccIds, ebcLogger);
            map < String, String > mapAccUpdate = new map < string, string > ();
            ebizchargeServicemodelSoap.CustomerResponse accRes = new ebizchargeServicemodelSoap.CustomerResponse();
            for (Account acc: accList) {
                if (acc.EBizCharge_Internal_ID__c != null && acc.EBizCharge_Internal_ID__c != Configuration.EMPTYSTRING) {
                    mapAccUpdate.put(acc.Id, acc.EBizCharge_Internal_ID__c);
                } else {
                    accRes = eBc_UtilityController.invoke_addORUpdCustomer(dml, acc, st, string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
                    if (accRes.StatusCode == 1) {
                        mapAccUpdate.put(acc.Id, accRes.CustomerInternalId);
                    }
                }
            }
            map < String, String > mapProdUpdate = new map < string, string > ();
            List < Id > listprodIds = new List < Id > (prodIds);
            list < Product2 > prodList = eBc_UtilityController.getProductsDetail(dml, listprodIds, ebcLogger);
            ebcLogger.debug(ClassName, MethodName, '>>>>prodList: ' + prodList);
            ebizchargeServicemodelSoap.ItemDetailsResponse prodRes = new ebizchargeServicemodelSoap.ItemDetailsResponse();
            for (Product2 prod: prodList) {
                if (prod.EBizCharge_Internal_ID__c != null && prod.EBizCharge_Internal_ID__c != Configuration.EMPTYSTRING) {
                    mapProdUpdate.put(prod.Id, prod.EBizCharge_Internal_ID__c);
                } else {
                    prodRes = eBc_UtilityController.invoke_addORUpdProduct(dml, prod, st, string.valueOf(Enums.ENTITYACTIONS.addProduct), ebcLogger);
                    if (prodRes.StatusCode == 1) {
                        mapProdUpdate.put(prod.Id, prodRes.ItemInternalId);
                    }
                }
            }
            map < String, String > mapOrdUpdate = new map < string, string > ();
            map < String, Order > mapOrdLog = new map < string, Order > ();
            list < Order > ordList = eBc_UtilityController.getOrdersDetail(dml, ordNos, ebcLogger);
            ebizchargeServicemodelSoap.SalesOrderResponse ordRes = new ebizchargeServicemodelSoap.SalesOrderResponse();
            for (Order ord: ordList) {
                if (ord.EBizCharge_Internal_ID__c != null && ord.EBizCharge_Internal_ID__c != Configuration.EMPTYSTRING) {
                    ordRes = eBc_UtilityController.invoke_AddORUpdateOrder(dml, ord, mapProdUpdate, st, string.valueOf(Enums.ENTITYACTIONS.updOrder), ebcLogger);
                } else {
                    ordRes = eBc_UtilityController.invoke_AddORUpdateOrder(dml, ord, mapProdUpdate, st, string.valueOf(Enums.ENTITYACTIONS.addOrder), ebcLogger);
                }
                if (ordRes.StatusCode == 1) {
                    mapOrdUpdate.put(ord.Id, ordRes.SalesOrderInternalId);
                    mapOrdLog.put(string.valueOf(Enums.LOGTYPESANDSTATUS.Uploaded) + ord.Id, ord);
                } else {
                    mapOrdLog.put(ordRes.Error + ' ' + ord.OrderNumber, ord);
                }
            }
            if (mapOrdUpdate.size() > 0) {
                eBc_UtilityController.updOrdersInSF(dml, mapOrdUpdate, ebcLogger);
            }
            if (mapOrdLog.size() > 0) {
                list < EBizCharge_Sync_Log__c > logList = new list < EBizCharge_Sync_Log__c > ();
                for (String key: mapOrdLog.keyset()) {
                    EBizCharge_Sync_Log__c log = new EBizCharge_Sync_Log__c();
                    Order ord = mapOrdLog.get(key);
                    string check = string.valueOf(Enums.LOGTYPESANDSTATUS.Uploaded) + ord.Id;
                    if (key == check) {
                        log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Uploaded);
                    } else {
                        log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Error);
                        log.Message__c = key;
                    }
                    log.Order_Id__c = ord.Id;
                    log.Name = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Order);
                    log.Order_Number__c = ord.OrderNumber;
                    log.Account_Name__c = ord.Account.Name;
                    log.Account_Id__c = ord.Account.Id;
                    log.Email__c = ord.Account.Email__c;
                    log.Order_Date__c = date.valueOf(ord.CreatedDate);
                    log.Amount__c = ord.TotalAmount;
                    log.Balance__c = ord.TotalAmount;
                    log.Upload_Date_Time__c = system.now();
                    log.Type__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Upload);
                    logList.add(log);
                }
                dml.insertRecord(logList);
            }
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (DmlException e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return Configuration.EXCEPTIONMESSAGESTRING;
        }
    }
    @AuraEnabled
    public static syncWrapper getAllAccountsApxc(Date fromDate, Date toDate) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        syncWrapper reciprocate = getAllAccountsApxc(dml, fromDate, toDate, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static syncWrapper getAllAccountsApxc(DML dml, Date fromDate, Date toDate, EBC_Logger ebcLogger) {
        MethodName = 'getAllAccountsApxc';
        List < AccountWrapper > accList = new List < AccountWrapper > ();
        String querySelect = Configuration.EMPTYSTRING;
        String queryFrom = Configuration.EMPTYSTRING;
        String queryWhere = Configuration.EMPTYSTRING;
        String queryOrderBy = Configuration.EMPTYSTRING;
        String queryLimit = Configuration.EMPTYSTRING;
        String Fields = Configuration.EMPTYSTRING;
        String Condition = Configuration.EMPTYSTRING;
        Date fDate = null;
        Date tDate = null;
        Fields += 'Name,Phone,CreatedDate,LastModifiedDate,First_Name__c,Last_Name__c,Email__c,EBizCharge_Email__c,EBizCharge_Amount__c,EBizCharge_Internal_ID__c,EBizCharge_Last_Sync_Date__c';
        try {
            if (fromDate != null && toDate != null) {
                fDate = fromDate;
                tDate = toDate;
                fromDate = fromDate;
                toDate = toDate.addDays(1);
                Condition = ' AND ((CreatedDate >= ' + ((Datetime) fromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) toDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') OR (LastModifiedDate >= ' + ((Datetime) fromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) toDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
            } else {
                Condition = Configuration.EMPTYSTRING;
                Datetime dt = null;
                Datetime formattedFromDate = null;
                Datetime formattedLastDate = null; 
                EBizcharge_Setting__c st = eBc_UtilityController.getSettings(dml, ebcLogger);
                if (st.Sync_Accounts_Filter_By__c != null) {
                    String FilterBy = st.Sync_Accounts_Filter_By__c;
                    if (FilterBy == string.valueOf(Enums.FILTERBY.Today)) {
                        dt = System.today();
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ((CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    } else if (FilterBy == Configuration.FILTERBYPASTWEEK) {
                        dt = System.Today() - 6;
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ((CreatedDate >= ' + formattedFromDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + formattedLastDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') OR (LastModifiedDate >= ' + formattedFromDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + formattedLastDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    } else if (FilterBy == Configuration.FILTERBYPASTMONTH) {
                        dt = system.Today() - 30;
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ((CreatedDate >= ' + formattedFromDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + formattedLastDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') OR (LastModifiedDate >= ' + formattedFromDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + formattedLastDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    } else if (FilterBy == Configuration.FILTERBYPASTYEAR) {
                        dt = System.Today() - 364;
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ((CreatedDate >= ' + formattedFromDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + formattedLastDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') OR (LastModifiedDate >= ' + formattedFromDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + formattedLastDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    }
                } else {
                    dt = System.today() - 30;
                    formattedFromDate = dt;
                    formattedLastDate = System.Today().addDays(1);
                    Condition = ' AND ((CreatedDate >= ' + formattedFromDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + formattedLastDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') OR (LastModifiedDate >= ' + formattedFromDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + formattedLastDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                }
                fDate = date.valueOf(dt);
                tDate = system.today().addDays(1);
            }
            querySelect = 'SELECT Id, ' + Fields;
            queryFrom = 'FROM Account';
            queryWhere = 'WHERE (EBizCharge_Need_to_Sync__c = true OR EBizCharge_Internal_ID__c = null) ' + Condition;
            queryOrderBy = 'Order by CreatedDate DESC';
            queryLimit = 'limit 25000';
            List < Account > recList = (List < Account > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, queryOrderBy, queryLimit);
            for (Account acc: recList) {
                DateTime lastModfiedDate = acc.LastModifiedDate;
                DateTime lastSyncDate = acc.EBizCharge_Last_Sync_Date__c;
                AccountWrapper obj = new AccountWrapper();
                if (lastModfiedDate >= lastSyncDate || lastSyncDate == null) {
                    obj.Id = acc.Id;
                    obj.HyperUrlAccount = '/' + acc.Id;
                    obj.accName = acc.Name;
                    obj.accExternalId = acc.EBizCharge_Internal_ID__c;
                    obj.accFirstName = acc.First_Name__c;
                    obj.accLastName = acc.Last_Name__c;
                    obj.accEmail = acc.Email__c;
                    obj.accPhone = acc.Phone;
                    obj.accAmount = ((acc.EBizCharge_Amount__c == null) ? 0 : acc.EBizCharge_Amount__c);
                    obj.accLastSync = acc.LastModifiedDate;
                    obj.isSelected = false;
                    accList.add(obj);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        syncWrapper retobj = new syncWrapper();
        retobj.AccountList = accList;
        retobj.fromDate = fDate;
        retobj.toDate = tDate;
        return retobj;
    }
    @AuraEnabled
    public static syncWrapper getAllContactApxc(Date fromDate, Date toDate) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        syncWrapper reciprocate = getAllContactApxc(dml, fromDate, toDate, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static syncWrapper getAllContactApxc(DML dml, Date fromDate, Date toDate, EBC_Logger ebcLogger) {
        MethodName = 'getAllContactApxc';
        List < ContactWrapper > conList = new List < ContactWrapper > ();
        String Fields = Configuration.EMPTYSTRING;
        String Condition = Configuration.EMPTYSTRING;
        Date fDate = null;
        Date tDate = null;
        Fields += 'Name,Phone,FirstName,LastName,CreatedDate,LastModifiedDate,Email,EBizCharge_Contact_Amount__c,EBizCharge_Contact_Internal_ID__c,EBizCharge_Last_Sync_Date__c ';
        try {
            if (fromDate != null && toDate != null) {
                fDate = fromDate;
                tDate = toDate;
                // Datetime currentDatetime = DateTime.now();
                // Datetime formattedFromDate = DateTime.newInstanceGMT(fromDate, currentDatetime.time());
                // Datetime formattedLastDate = DateTime.newInstanceGMT(toDate, currentDatetime.time());
                fromDate = fromDate;
                toDate = toDate.addDays(1);
                Condition = ' AND ((CreatedDate >= ' + ((Datetime) fromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) toDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                    'OR (LastModifiedDate >= ' + ((Datetime) fromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) toDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
            } else {
                Condition = Configuration.EMPTYSTRING;
                Datetime dt = null;
                Datetime formattedFromDate = null;
                Datetime formattedLastDate = null;
                EBizcharge_Setting__c st = eBc_UtilityController.getSettings(dml, ebcLogger);
                if (st.Sync_Accounts_Filter_By__c != null) {
                    String FilterBy = st.Sync_Accounts_Filter_By__c;
                    if (FilterBy == string.valueOf(Enums.FILTERBY.Today)) {
                        dt = System.today();
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ((CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                        'OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    } else if (FilterBy == Configuration.FILTERBYPASTWEEK) {
                        dt = System.Today() - 6;
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ((CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                        'OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    } else if (FilterBy == Configuration.FILTERBYPASTMONTH) {
                        dt = system.Today() - 30;
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ((CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                        'OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    } else if (FilterBy == Configuration.FILTERBYPASTYEAR) {
                        dt = System.Today() - 364;
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ((CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                        'OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    }
                } else {
                    dt = System.today() - 30;
                    formattedFromDate = dt;
                    formattedLastDate = System.Today().addDays(1);
                    Condition = ' AND ((CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') ' +
                    'OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                }
                fDate = date.valueOf(dt);
                tDate = system.today().addDays(1);
            }
            String querySelect = 'SELECT Id, ' + Fields + Configuration.EMPTYSTRING;
            String queryFrom = 'FROM Contact';
            String queryWhere = 'WHERE (EBizCharge_Need_to_Sync__c = true OR EBizCharge_Contact_Internal_ID__c  = null) ' + Condition;
            String queryOrderBy = 'Order by CreatedDate DESC';
            String queryLimit = 'limit 25000';
            List < Contact > recList = (List < Contact > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, queryOrderBy, queryLimit);
            for (Contact con: recList) {
                DateTime lastModfiedDate = con.LastModifiedDate;
                DateTime lastSyncDate = con.EBizCharge_Last_Sync_Date__c;
                ContactWrapper obj = new ContactWrapper();
                if (lastModfiedDate >= lastSyncDate || lastSyncDate == null) {
                    ebcLogger.debug(ClassName, MethodName, '>>>obj.Id>>>' + obj.Id);
                    obj.Id = con.Id;
                    obj.HyperUrlContact = '/' + con.Id;
                    obj.conName = con.Name;
                    obj.conExternalId = con.EBizCharge_Contact_Internal_ID__c;
                    obj.conFirstName = con.FirstName;
                    obj.conLastName = con.LastName;
                    obj.conEmail = con.Email;
                    obj.conPhone = con.Phone;
                    obj.conAmount = ((con.EBizCharge_Contact_Amount__c == null) ? 0 : con.EBizCharge_Contact_Amount__c);
                    obj.conLastSync = con.LastModifiedDate;
                    obj.isSelected = false;
                    conList.add(obj);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        syncWrapper retobj = new syncWrapper();
        retobj.ContactList = conList;
        retobj.fromDate = fDate;
        retobj.toDate = tDate;
        return retobj;
    }
    @AuraEnabled
    public static string syncAccountsGwApxc(list < Id > accIds) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = syncAccountsGwApxc(dml, accIds, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string syncAccountsGwApxc(DML dml, list < Id > accIds, EBC_Logger ebcLogger) {
        MethodName = 'syncAccountsGwApxc';
        map < String, String > mapAccUpdate = new map < string, string > ();
        map < String, Account > mapAccLog = new map < string, Account > ();
        try {
            ebizchargeServicemodelSoap.SecurityToken st = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
            ebizchargeServicemodelSoap.CustomerResponse response = new ebizchargeServicemodelSoap.CustomerResponse();
            list < Account > accList = eBc_UtilityController.getAccountsDetail(dml, accIds, ebcLogger);
            for (Account acc: accList) {
                if (acc.EBizCharge_Internal_ID__c != null && acc.EBizCharge_Internal_ID__c != Configuration.EMPTYSTRING) {
                    response = eBc_UtilityController.invoke_addORUpdCustomer(dml, acc, st, string.valueOf(Enums.ENTITYACTIONS.updCustomer), ebcLogger);
                } else {
                    response = eBc_UtilityController.invoke_addORUpdCustomer(dml, acc, st, string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
                }
                if (response.StatusCode == 1) {
                    mapAccUpdate.put(acc.Id, response.CustomerInternalId);
                    mapAccLog.put(string.valueOf(Enums.ENTITYACTIONS.updCustomer) + acc.Id, acc);
                } else {
                    mapAccLog.put(response.Error + acc.Id, acc);
                }
            }
            if (mapAccUpdate.size() > 0) {
                eBc_UtilityController.updCustomerInSF(dml, mapAccUpdate, ebcLogger);
            }
            if (mapAccLog.size() > 0) {
                list < EBizCharge_Sync_Log__c > logList = new list < EBizCharge_Sync_Log__c > ();
                for (String key: mapAccLog.keyset()) {
                    EBizCharge_Sync_Log__c log = new EBizCharge_Sync_Log__c();
                    Account acc = mapAccLog.get(key);
                    string check = string.valueOf(Enums.ENTITYACTIONS.updCustomer) + acc.Id;
                    if (key == check) {
                        log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Uploaded);
                    } else {
                        log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Error);
                        log.Message__c = key;
                    }
                    log.Account_Id__c = acc.Id;
                    log.Account_Name__c = acc.Name;
                    log.Balance__c = acc.EBizCharge_Amount__c;
                    log.Amount__c = acc.EBizCharge_Amount__c;
                    log.First_Name__c = acc.First_Name__c;
                    log.Last_Name__c = acc.Last_Name__c;
                    log.Email__c = acc.Email__c;
                    log.Phone__c = acc.Phone;
                    log.Upload_Date_Time__c = system.now();
                    log.Name = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Account);
                    log.Type__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Upload);
                    logList.add(log);
                }
                dml.insertRecord(logList);
            }
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (DmlException e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static string syncContactGwApxc(list < Id > conIds) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = syncContactGwApxc(dml, conIds, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string syncContactGwApxc(DML dml, list < Id > conIds, EBC_Logger ebcLogger) {
        MethodName = 'syncContactGwApxc';
        map < String, String > mapConUpdate = new map < string, string > ();
        map < String, Contact > mapConLog = new map < string, Contact > ();
        try {
            ebizchargeServicemodelSoap.SecurityToken st = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
            ebizchargeServicemodelSoap.CustomerResponse response = new ebizchargeServicemodelSoap.CustomerResponse();
            list < Contact > conList = eBc_UtilityController.getContactsDetail(dml, conIds, ebcLogger);
            for (Contact con: conList) {
                if (con.Ebiz_C__EBizCharge_Contact_Internal_ID__c != null && con.Ebiz_C__EBizCharge_Contact_Internal_ID__c != Configuration.EMPTYSTRING) {
                    response = eBc_UtilityController.invoke_addORUpdCustomerContact(dml, con, st, string.valueOf(Enums.ENTITYACTIONS.updCustomer), ebcLogger);
                } else {
                    response = eBc_UtilityController.invoke_addORUpdCustomerContact(dml, con, st, string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
                }
                if (response.StatusCode == 1) {
                    mapConUpdate.put(con.Id, response.CustomerInternalId);
                    mapConLog.put(string.valueOf(Enums.ENTITYACTIONS.updCustomer) + con.Id, con);
                } else {
                    mapConLog.put(response.Error + con.Id, con);
                }
                ebcLogger.debug(ClassName, MethodName, '>>con.Ebiz_C__EBizCharge_Contact_Internal_ID__c>>>' + con.Ebiz_C__EBizCharge_Contact_Internal_ID__c);
            }
            if (mapConUpdate.size() > 0) {
                ebcLogger.debug(ClassName, MethodName, '>>>>mapUpdate');
                eBc_UtilityController.updCustomerInSFContact(dml, mapConUpdate, ebcLogger);
            }
            if (mapConLog.size() > 0) {
                list < EBizCharge_Sync_Log__c > logList = new list < EBizCharge_Sync_Log__c > ();
                for (String key: mapConLog.keyset()) {
                    EBizCharge_Sync_Log__c log = new EBizCharge_Sync_Log__c();
                    Contact con = mapConLog.get(key);
                    string check = string.valueOf(Enums.ENTITYACTIONS.updCustomer) + con.Id;
                    if (key == check) {
                        log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Uploaded);
                    } else {
                        log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Error);
                        log.Message__c = key;
                    }
                    log.Contact_Id__c = con.Id;
                    log.Account_Name__c = con.Name;
                    log.Balance__c = con.EBizCharge_Contact_Amount__c == null ? 0 : con.EBizCharge_Contact_Amount__c;
                    log.Amount__c = con.EBizCharge_Contact_Amount__c == null ? 0 : con.EBizCharge_Contact_Amount__c;
                    log.First_Name__c = con.FirstName;
                    log.Last_Name__c = con.LastName;
                    log.Email__c = con.Email;
                    log.Phone__c = con.Phone;
                    log.Upload_Date_Time__c = system.now();
                    log.Name = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Contact);
                    log.Type__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Upload);
                    logList.add(log);
                }
                dml.insertRecord(logList);
            }
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (DmlException e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static syncWrapper getAllProductsApxc(Date fromDate, Date toDate) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        syncWrapper reciprocate = getAllProductsApxc(dml, fromDate, toDate, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static syncWrapper getAllProductsApxc(DML dml, Date fromDate, Date toDate, EBC_Logger ebcLogger) {
        MethodName = 'getAllProductsApxc';
        List < ProductWrapper > prodList = new List < ProductWrapper > ();
        String Fields = Configuration.EMPTYSTRING;
        String Condition = Configuration.EMPTYSTRING;
        Date fDate = null;
        Date tDate = null;
        Fields += 'Name,LastModifiedDate,ProductCode,Description,EBizCharge_Internal_ID__c,EBizCharge_Last_Sync_Date__c';
        try {
            if (fromDate != null && toDate != null) {
                fDate = fromDate;
                tDate = toDate;
                fromDate = fromDate;
                toDate = toDate.addDays(1);
                // Datetime currentDatetime = DateTime.now();
                // Datetime formattedFromDate = DateTime.newInstanceGMT(fromDate, currentDatetime.time());
                // Datetime formattedLastDate = DateTime.newInstanceGMT(toDate, currentDatetime.time());
                Condition = ' AND ( (CreatedDate >= ' + ((Datetime) fromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) toDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') OR (LastModifiedDate >= ' + ((Datetime) fromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) toDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
            } else {
                Condition = Configuration.EMPTYSTRING;
                Datetime dt = null;
                Datetime formattedFromDate = null;
                Datetime formattedLastDate = null;
                EBizcharge_Setting__c st = eBc_UtilityController.getSettings(dml, ebcLogger);
                if (st.Sync_Products_Filter_By__c != null) {
                    String FilterBy = st.Sync_Products_Filter_By__c;
                    if (FilterBy == string.valueOf(Enums.FILTERBY.Today)) {
                        dt = System.Today();
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ( (CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    } else if (FilterBy == Configuration.FILTERBYPASTWEEK) {
                        dt = System.Today() - 6;
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ( (CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    } else if (FilterBy == Configuration.FILTERBYPASTMONTH) {
                        dt = system.Today() - 30;
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition =' AND ( (CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    } else if (FilterBy == Configuration.FILTERBYPASTYEAR) {
                        dt = System.Today() - 364;
                        formattedFromDate = dt;
                        formattedLastDate = System.Today().addDays(1);
                        Condition = ' AND ( (CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                    }
                } else {
                    dt = System.Date.today() - 30;
                    formattedFromDate = dt;
                    formattedLastDate = System.Today().addDays(1);
                    Condition = ' AND ( (CreatedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND CreatedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ') OR (LastModifiedDate >= ' + ((Datetime) formattedFromDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + ' AND LastModifiedDate < ' + ((Datetime) formattedLastDate).formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'') + '))';
                }
                fDate = date.valueOf(dt);
                tDate = system.today().addDays(1);
            }
            String querySelect = 'SELECT Id, ' + Fields;
            String queryFrom = 'FROM Product2';
            String queryWhere = 'WHERE ( EBizCharge_Need_to_Sync__c = true OR EBizCharge_Internal_ID__c = null) ' + Condition;
            String queryOrderBy = 'Order by CreatedDate DESC';
            String queryLimit = 'limit 25000';
            List < Product2 > recList = (List < Product2 > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, queryOrderBy, queryLimit);
            for (Product2 pd: recList) {
                DateTime lastModfiedDate = pd.LastModifiedDate;
                DateTime lastSyncDate = pd.EBizCharge_Last_Sync_Date__c;
                ProductWrapper obj = new ProductWrapper();
                if (lastModfiedDate >= lastSyncDate || lastSyncDate == null) {
                    obj.Id = pd.Id;
                    obj.HyperUrlProduct = '/' + pd.Id;
                    obj.prodName = pd.Name;
                    obj.prodCode = pd.ProductCode;
                    obj.prodPrice = Configuration.STARTINDEX;
                    obj.prodQuantity = Configuration.CARDMETHODID;
                    obj.prodDescription = pd.Description;
                    obj.prodExternalId = pd.EBizCharge_Internal_ID__c;
                    obj.prodLastSync = pd.EBizCharge_Last_Sync_Date__c;
                    obj.isSelected = false;
                    prodList.add(obj);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        syncWrapper retobj = new syncWrapper();
        retobj.ProductList = prodList;
        retobj.fromDate = fDate;
        retobj.toDate = tDate;
        return retobj;
    }
    @AuraEnabled
    public static string syncProductsGwApxc(list < Id > prodIds) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        string reciprocate = syncProductsGwApxc(dml, prodIds, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static string syncProductsGwApxc(DML dml, list < Id > prodIds, EBC_Logger ebcLogger) {
        MethodName = 'syncProductsGwApxc';
        map < String, String > mapProdUpdate = new map < string, string > ();
        map < String, Product2 > mapProdLog = new map < string, Product2 > ();
        try {
            List < product2 > prodList = eBc_UtilityController.getProductsDetail(dml, prodIds, ebcLogger);
            ebizchargeServicemodelSoap.SecurityToken st = eBc_UtilityController.getSecurityToken(dml, ebcLogger);
            ebizchargeServicemodelSoap.ItemDetailsResponse response = new ebizchargeServicemodelSoap.ItemDetailsResponse();
            for (Product2 prod: prodList) {
                if (prod.EBizCharge_Internal_ID__c != null && prod.EBizCharge_Internal_ID__c != Configuration.EMPTYSTRING) {
                    response = eBc_UtilityController.invoke_addORUpdProduct(dml, prod, st, string.valueOf(Enums.ENTITYACTIONS.updProduct), ebcLogger);
                } else {
                    response = eBc_UtilityController.invoke_addORUpdProduct(dml, prod, st, string.valueOf(Enums.ENTITYACTIONS.addProduct), ebcLogger);
                }
                if (response.StatusCode == 1) {
                    mapProdLog.put(string.valueOf(Enums.LOGTYPESANDSTATUS.Uploaded) + prod.Id, prod);
                    mapProdUpdate.put(prod.Id, response.ItemInternalId);
                } else {
                    mapProdLog.put(response.Error + ' ' + prod.Id, prod);
                }
            }
            if (mapProdUpdate.size() > 0) {
                eBc_UtilityController.updProductsInSF(dml, mapProdUpdate, ebcLogger);
            }
            if (mapProdLog.size() > 0) {
                list < EBizCharge_Sync_Log__c > logList = new list < EBizCharge_Sync_Log__c > ();
                for (String key: mapProdLog.keyset()) {
                    EBizCharge_Sync_Log__c log = new EBizCharge_Sync_Log__c();
                    Product2 product = mapProdLog.get(key);
                    string check = string.valueOf(Enums.LOGTYPESANDSTATUS.Uploaded) + product.Id;
                    if (key == check) {
                        string statusWithID = string.valueOf(Enums.LOGTYPESANDSTATUS.Uploaded) + product.Id;
                        log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Uploaded);
                    } else {
                        log.Status__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Error);
                        log.Message__c = key;
                    }
                    log.Name = string.valueOf(Enums.SALESFORCEOBJECTNAMES.Product);
                    log.Type__c = string.valueOf(Enums.LOGTYPESANDSTATUS.Upload);
                    log.Product_Id__c = product.Id;
                    log.Product_Code__c = product.ProductCode;
                    log.Product_Name__c = product.Name;
                    log.Description__c = product.Description;
                    log.Quantity__c = 0;
                    log.Amount__c = 0;
                    log.Upload_Date_Time__c = system.now();
                    logList.add(log);
                }
                dml.insertRecord(logList);
            }
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (DmlException e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
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
        String querySelect = 'SELECT Id ';
        String queryFrom = 'FROM EBizCharge_Sync_Log__c';
        String queryWhere = 'WHERE Name =\'' + logname + '\'';
        try {
            dml.deleteRecord(dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING, Configuration.EMPTYSTRING));
            return string.valueOf(Enums.RETURNMESSAGE.Success);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static List < uploadLog > getLogApxc(String logname) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < uploadLog > reciprocate = getLogApxc(dml, logname, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < uploadLog > getLogApxc(DML dml, String logname, EBC_Logger ebcLogger) {
        MethodName = 'getLogApxc';
        list < uploadLog > retList = new list < uploadLog > ();
        String querySelect = 'SELECT Id,Name,CreatedDate,Account_Id__c,Account_Name__c,Amount__c,Balance__c,First_Name__c,Last_Name__c,' +
            'Email__c,Message__c,Order_Date__c,Order_Id__c,Order_Number__c,Phone__c,Product_Id__c,Product_Code__c,Product_Name__c,' +
            'Quantity__c,Status__c,Upload_Date_Time__c,Description__c';
        String queryFrom = 'FROM EBizCharge_Sync_Log__c';
        String queryWhere = 'WHERE Name =\'' + logname + '\' AND Type__c = \'Upload\'';
        String queryOrderBy = 'Order by CreatedDate DESC';
        String queryLimit = 'limit 49000';
        try {
            list < EBizCharge_Sync_Log__c > loglist = (list < EBizCharge_Sync_Log__c > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, queryOrderBy, queryLimit);
            for (EBizCharge_Sync_Log__c lg: loglist) {
                uploadLog obj = new uploadLog();
                obj.Id = lg.Id;
                obj.Name = lg.Name;
                obj.accId = lg.Account_Id__c;
                obj.HyperUrlOrder = '/' + lg.Order_Id__c;
                obj.HyperUrlAccount = '/' + lg.Account_Id__c;
                obj.accName = lg.Account_Name__c;
                obj.amount = lg.Amount__c;
                obj.balance = lg.Balance__c;
                obj.email = lg.Email__c;
                obj.firstName = lg.First_Name__c;
                obj.lastName = lg.Last_Name__c;
                obj.message = lg.Message__c;
                obj.orderId = lg.Order_Id__c;
                obj.ordNumber = lg.Order_Number__c;
                obj.ordDate = lg.Order_Date__c;
                obj.Phone = lg.Phone__c;
                obj.prodId = lg.Product_Id__c;
                obj.HyperUrlProduct = '/' + lg.Product_Id__c;
                obj.prodCode = lg.Product_Code__c;
                obj.prodName = lg.Product_Name__c;
                obj.description = lg.Description__c;
                obj.quantity = Integer.valueOf(lg.Quantity__c);
                obj.status = lg.Status__c;
                obj.uploadDate = lg.Upload_Date_Time__c;
                obj.isSelected = false;
                retList.add(obj);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return retList;
    }
    @AuraEnabled
    public static List < uploadLog > getLogApxcContact(String logname) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        List < uploadLog > reciprocate = getLogApxcContact(dml, logname, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static List < uploadLog > getLogApxcContact(DML dml, String logname, EBC_Logger ebcLogger) {
        MethodName = 'getLogApxc';
        list < uploadLog > retList = new list < uploadLog > ();
        String querySelect = 'SELECT Id,Name,CreatedDate,Contact_Id__c,Account_Name__c,Amount__c,Balance__c,First_Name__c,Last_Name__c,' +
            'Email__c,Message__c,Order_Date__c,Order_Id__c,Order_Number__c,Phone__c,Product_Id__c,Product_Code__c,Product_Name__c,' +
            'Quantity__c,Status__c,Upload_Date_Time__c,Description__c ';
        String queryFrom = 'FROM EBizCharge_Sync_Log__c';
        String queryWhere = 'WHERE Name =\'' + logname + '\' AND Type__c = \'Upload\'';
        String queryOrderBy = 'Order by CreatedDate DESC';
        String queryLimit = 'limit 49000';
        try {
            list < EBizCharge_Sync_Log__c > loglist = (list < EBizCharge_Sync_Log__c > ) dml.selectRecords(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING, queryOrderBy, queryLimit);
            for (EBizCharge_Sync_Log__c lg: loglist) {
                uploadLog obj = new uploadLog();
                obj.Id = lg.Id;
                obj.Name = lg.Name;
                obj.conId = lg.Contact_Id__c;
                obj.HyperUrlContact = '/' + lg.Contact_Id__c;
                obj.accName = lg.Account_Name__c;
                obj.amount = lg.Amount__c;
                obj.balance = lg.Balance__c;
                obj.email = lg.Email__c;
                obj.firstName = lg.First_Name__c;
                obj.lastName = lg.Last_Name__c;
                obj.message = lg.Message__c;
                obj.orderId = lg.Order_Id__c;
                obj.ordNumber = lg.Order_Number__c;
                obj.ordDate = lg.Order_Date__c;
                obj.Phone = lg.Phone__c;
                obj.prodId = lg.Product_Id__c;
                obj.prodCode = lg.Product_Code__c;
                obj.prodName = lg.Product_Name__c;
                obj.description = lg.Description__c;
                obj.quantity = Integer.valueOf(lg.Quantity__c);
                obj.status = lg.Status__c;
                obj.uploadDate = lg.Upload_Date_Time__c;
                obj.isSelected = false;
                retList.add(obj);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return retList;
    }
    public class syncWrapper {
        @AuraEnabled public List < OrderWrapper > OrdersList {
            get;
            set;
        }
        @AuraEnabled public List < AccountWrapper > AccountList {
            get;
            set;
        }
        @AuraEnabled public List < ContactWrapper > ContactList {
            get;
            set;
        }
        @AuraEnabled public List < ProductWrapper > ProductList {
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
        @AuraEnabled public DateTime CreatedDate {
            get;
            set;
        }
        @AuraEnabled public String EBizChargeId {
            get;
            set;
        }
        @AuraEnabled public String accId {
            get;
            set;
        }
        @AuraEnabled public String HyperUrlOrder {
            get;
            set;
        }
        @AuraEnabled public String HyperUrlAccount {
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
        @AuraEnabled public double Order_balance {
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
        @AuraEnabled public list < OrderItem > OrditemsList {
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
        @AuraEnabled public boolean isSelected {
            get;
            set;
        }
    }
    public class ContactWrapper {
        @AuraEnabled public String Id {
            get;
            set;
        }
        @AuraEnabled public String conName {
            get;
            set;
        }
        @AuraEnabled public String HyperUrlContact {
            get;
            set;
        }
        @AuraEnabled public String conExternalId {
            get;
            set;
        }
        @AuraEnabled public String conFirstName {
            get;
            set;
        }
        @AuraEnabled public String conLastName {
            get;
            set;
        }
        @AuraEnabled public String conEmail {
            get;
            set;
        }
        @AuraEnabled public String conPhone {
            get;
            set;
        }
        @AuraEnabled public Double conAmount {
            get;
            set;
        }
        @AuraEnabled public DateTime conLastSync {
            get;
            set;
        }
        @AuraEnabled public boolean isSelected {
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
        @AuraEnabled public String HyperUrlProduct {
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
        @AuraEnabled public String prodPrice {
            get;
            set;
        }
        @AuraEnabled public String prodQuantity {
            get;
            set;
        }
        @AuraEnabled public String prodDescription {
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
    }
    public class uploadLog {
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
        @AuraEnabled public String conId {
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
        @AuraEnabled public String orderId {
            get;
            set;
        }
        @AuraEnabled public String HyperUrlOrder {
            get;
            set;
        }
        @AuraEnabled public String HyperUrlAccount {
            get;
            set;
        }
        @AuraEnabled public String HyperUrlContact {
            get;
            set;
        }
        @AuraEnabled public String HyperUrlProduct {
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
        @AuraEnabled public DateTime uploadDate {
            get;
            set;
        }
        @AuraEnabled public boolean isSelected {
            get;
            set;
        }
    }
}